/**
 * deserializer.sv
 * 
 * Deserializes serial UART_RX data gotten from the GPIO pin
 * on the FPGA, accumulates eight-bit MIDI bytes using a FSM
 * and outputs the MIDI byte when ready
 * 
 */
`include "internal_defines.vh"

`default_nettype none

module deserializer(
    input  logic        rx,
    input  logic        clock,
    input  logic        reset,
    output logic        ready,
    output logic [7 :0] MIDIbyte
);

    // counter bound at different FSM states
    localparam STOP_cycle_count = SAMPLE_RATE / 16;
    localparam START_cycle_count = SAMPLE_RATE / 2;
    localparam GETBIT_cycle_count = SAMPLE_RATE;
    localparam FINISH_cycle_count = SAMPLE_RATE;
 
    enum logic [1:0] {
        STOP = 2'b00,
        START = 2'b01,
        GETBIT = 2'b10,
        FINISH = 2'b11
    } c_state, n_state;

    logic   [ 7:0] word;
    reg     [ 3:0] readBits;
    logic          clockEn, clockClear, clockFinish;
    logic   [11:0] bound;

    // when clockCounter reaches upper bound, a clockFinish signal flags high
    clockCounter #(
        .WIDTH(12)
    ) ClockCounter (
        .clock(clock),
        .clear(clockClear),
        .bound(bound),
        .finish(clockFinish)
    );
 
    always_ff @(posedge clock, posedge reset)
        if (reset) begin
            c_state <= STOP;
            clockClear <= 1'b1;
            readBits <= 4'd0;
            word <= 8'd0;
            bound <= STOP_cycle_count;
        end
        // when clockCounter finishes counting to the upper bound
        else if (clockFinish) begin
            clockClear <= 1'b1;
            case (c_state)
                STOP: begin
                    if (rx == 1'b1) n_state <= START;
                    else n_state <= STOP;
                end
                START: n_state <= GETBIT;
                GETBIT: begin
                    if (!clockClear) begin
                        if (readBits >= 4'b1000) n_state <= FINISH;
                        else begin
                            word[readBits] <= rx;
                            readBits <= readBits + 1;
                        end
                    end
                end
                FINISH: n_state <= STOP;
            endcase
            // a state change detected, set up the next state
            if (c_state != n_state) begin
                case (n_state)
                    STOP: begin
                        readBits <= 4'd0;
                        word <= 8'd0;
                        bound <= STOP_cycle_count;
                    end
                    START: bound <= START_cycle_count;
                    GETBIT: bound <= GETBIT_cycle_count;
                    FINISH: begin
                        bound <= FINISH_cycle_count;
                        ready <= 1'b1;
                        MIDIbyte <= word;
                        word <= 8'd0;
                    end
                endcase
            end
            c_state <= n_state;
        end
        else clockClear <= 1'b0;
 
endmodule : deserializer

module clockCounter #(
    parameter WIDTH=8
)  (input  logic             clock, clear,
    input  logic [WIDTH-1:0] bound,
    output logic             finish);

    reg [WIDTH-1:0] count;

    always_ff @(posedge clock)
        if (clear == 1'b1) begin
            count <= 0;
            finish <= 1'b0;
        end
        else if (count == bound) finish <= 1'b1;
		  else count <= (count + 1'b1);

endmodule: clockCounter