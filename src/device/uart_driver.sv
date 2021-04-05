`default_nettype none

`include "../includes/config.vh"

/*
 * Bit stream format
 *      idle       | start |          8 data bits            | stop  |  idle
 * ________________         _______         ______________    __________________
 *                 |_______|       |_______|              ...
 */
module UARTDriver
  import CONFIG::BYTE_WIDTH;
#(
    parameter BAUD_RATE = 31250
) (
    input  logic                  clock_50_000_000,
    input  logic                  reset_l,
    input  logic                  uart_rx,
    output logic [BYTE_WIDTH-1:0] data_in,
    output logic                  data_in_ready
);

  localparam START_BIT = 0;
  localparam BIT_TICKS = CONFIG::SYSTEM_CLOCK / BAUD_RATE;
  localparam DEBOUNCE_TICKS = BIT_TICKS / 100;

  logic [$clog2(DEBOUNCE_TICKS)-1:0] debounce_count;
  logic [     $clog2(BIT_TICKS)-1:0] bit_count;

  logic [            BYTE_WIDTH-1:0] buffer;
  logic [    $clog2(BYTE_WIDTH)-1:0] index;

  typedef enum logic [1:0] {
    IDLE,
    READING,
    FINISH
  } state_t;
  state_t state;

  always @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      state          <= IDLE;
      buffer         <= '0;
      index          <= '0;
      debounce_count <= '0;
      bit_count      <= '0;
      data_in        <= '0;
      data_in_ready  <= '0;
    end else
      unique case (state)
        IDLE: begin
          data_in_ready <= '0;
          if (uart_rx == START_BIT) begin
            if (debounce_count >= DEBOUNCE_TICKS - 1) begin
              state          <= READING;
              buffer         <= '0;
              index          <= BYTE_WIDTH - 1;
              bit_count      <= '0;
              debounce_count <= '0;
            end else begin
              debounce_count <= debounce_count + 1'b1;
            end
          end else begin
            debounce_count <= '0;
          end
        end
        READING: begin
          if (bit_count >= BIT_TICKS - 1) begin
            bit_count     <= '0;
            buffer[index] <= uart_rx;
            if (index == '0) state <= FINISH;
            else index <= index - 1'b1;
          end else begin
            bit_count <= bit_count + 1'b1;
          end
        end
        FINISH: begin
          if (bit_count >= BIT_TICKS - 1) begin
            state          <= IDLE;
            data_in        <= buffer;
            data_in_ready  <= 1'b1;
            debounce_count <= '0;
          end else begin
            bit_count <= bit_count + 1'b1;
          end
        end
      endcase
  end

endmodule : UARTDriver
