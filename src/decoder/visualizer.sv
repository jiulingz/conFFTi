`default_nettype  none

/**
 * visualzer.sv
 * 
 * Adapted from 18240 lab5 chipInterface.sv
 *
 * Visualizes MIDI bytes received by the FPGA,
 * stores 16 bytes in a register and displays
 * MIDI bytes on the FPGA board
 * 
 * Note: this file is not a part of the final conFFTi project,
 * it is a top_level script written for investigating what MIDI messages
 * would be produced when the user interacts with the keyboard
 * and to produce a holistic MIDI code to event mapping
 * 
 */
module visualizer (
  input  logic        CLOCK_50,
  input  logic        GPIO,        // serialIn
  input  logic [17:0] SW,             // reset-SW17, displayGroup-SW[3:0]
  output logic [6:0]  HEX0, HEX1, HEX2, HEX3,  // message in HEX
                      HEX4, HEX5, HEX6, HEX7
);

  logic done, ready;
  logic [31 :0] newByte;
  logic [511:0] RegisterFileOut;
  logic [31 :0] result;

  deserializer MIDI_Deserializer(
    .rx(GPIO),
    .clock(CLOCK_50),
    .reset(1'b0),
    .ready,
    .MIDIbyte(newByte)
  );

  Register #512 RegisterFile(.D({RegisterFileOut[503:0], newByte}),
                             .Q(RegisterFileOut), .en(ready),
                             .clear(1'b0), .clock(CLOCK_50));

  // controlling which page you are one. 4 out of 64 char at one time
  always_comb begin
    case (SW[3:0])
        4'd0: result = RegisterFileOut[31:0];
        4'd1: result = RegisterFileOut[63:32];
        4'd2: result = RegisterFileOut[95:64];
        4'd3: result = RegisterFileOut[127:96];
        4'd4: result = RegisterFileOut[159:128];
        4'd5: result = RegisterFileOut[191:160];
        4'd6: result = RegisterFileOut[223:192];
        4'd7: result = RegisterFileOut[255:224];
        4'd8: result = RegisterFileOut[287:256];
        4'd9: result = RegisterFileOut[319:288];
        4'd10: result = RegisterFileOut[351:320];
        4'd11: result = RegisterFileOut[383:352];
        4'd12: result = RegisterFileOut[415:384];
        4'd13: result = RegisterFileOut[447:416];
        4'd14: result = RegisterFileOut[479:448];
        4'd15: result = RegisterFileOut[511:480];
    endcase
  end

  SevenSegmentControl c1(.HEX7, .HEX6, .HEX5, .HEX4,
                         .HEX3, .HEX2, .HEX1, .HEX0,
                         .BCH7(result[31:28]), .BCH6(result[27:24]),
                         .BCH5(result[23:20]), .BCH4(result[19:16]),
                         .BCH3(result[15:12]), .BCH2(result[11:8]),
                         .BCH1(result[7:4]), .BCH0(result[3:0]));

endmodule: visualizer
