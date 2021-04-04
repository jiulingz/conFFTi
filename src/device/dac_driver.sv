`default_nettype none

`include "../includes/config.vh"

module DACDriver
  import CONFIG::AUDIO_BIT_WIDTH;
(
    input  logic                       clock_16_934_400,
    input  logic                       reset_l,
    input  logic [AUDIO_BIT_WIDTH-1:0] audio_out,
    output logic                       i2s_bit_clock,
    output logic                       i2s_left_right_clock,
    output logic                       i2s_data
);

  import CONFIG::AUDIO_SAMPLE_RATE;
  import CONFIG::AUDIO_CLOCK;

  localparam EDGES = 2;
  localparam CHANNEL_NUMBER = 2;  // i2s has left and right channel

  // Generate i2s_bit_clock
  localparam BIT_TICKS = AUDIO_CLOCK / (AUDIO_SAMPLE_RATE * AUDIO_BIT_WIDTH * CHANNEL_NUMBER * EDGES);
  logic [$clog2(BIT_TICKS)-1:0] bit_count;
  always_ff @(posedge clock_16_934_400, negedge reset_l)
    if (!reset_l) begin
      i2s_bit_clock <= '1;
      bit_count     <= '0;
    end else begin
      if (bit_count >= BIT_TICKS - 1) begin
        i2s_bit_clock <= ~i2s_bit_clock;
        bit_count     <= '0;
      end else begin
        bit_count <= bit_count + 1'b1;
      end
    end

  // Generate i2s_left_right_clock
  localparam LR_TICKS = AUDIO_CLOCK / (AUDIO_SAMPLE_RATE * EDGES);
  logic [$clog2(LR_TICKS)-1:0] lr_count;
  always_ff @(posedge clock_16_934_400, negedge reset_l)
    if (!reset_l) begin
      i2s_left_right_clock <= '0;
      lr_count             <= '0;
    end else begin
      if (lr_count >= LR_TICKS - 1) begin
        i2s_left_right_clock <= ~i2s_left_right_clock;
        lr_count             <= '0;
      end else begin
        lr_count <= lr_count + 1'b1;
      end
    end

  // Generate i2s_data
  logic [$clog2(AUDIO_BIT_WIDTH)-1:0] data_count;
  always_ff @(negedge i2s_bit_clock, negedge reset_l)
    if (!reset_l) begin
      i2s_data   <= '0;
      data_count <= AUDIO_BIT_WIDTH - 1;
    end else begin
      i2s_data <= audio_out[data_count];
      if (data_count == 0) data_count <= AUDIO_BIT_WIDTH - 1;
    end

endmodule : DACDriver
