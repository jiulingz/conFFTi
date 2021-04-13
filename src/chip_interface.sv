`default_nettype none

`include "includes/config.vh"
`include "includes/midi.vh"

module ChipInterface (
    // CLOCK
    input  logic        CLOCK_50,
    // LED
    output logic [ 8:0] LEDG,
    output logic [17:0] LEDR,
    // KEY
    input  logic [ 3:0] KEY,
    // SW
    input  logic [17:0] SW,
    // SEG7
    output logic [ 6:0] HEX7,
    output logic [ 6:0] HEX6,
    output logic [ 6:0] HEX5,
    output logic [ 6:0] HEX4,
    output logic [ 6:0] HEX3,
    output logic [ 6:0] HEX2,
    output logic [ 6:0] HEX1,
    output logic [ 6:0] HEX0,
    // GPIO
    inout  logic [35:0] GPIO
);

  logic                               clock_50_000_000;
  logic                               clock_16_934_400;
  logic                               reset_l;
  logic                               uart_rx;
  logic [     CONFIG::BYTE_WIDTH-1:0] data_in;
  logic                               data_in_ready;
  logic                               i2s_bit_clock;
  logic                               i2s_left_right_clock;
  logic                               i2s_data;
  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] audio_out;

  assign clock_50_000_000 = CLOCK_50;
  assign reset_l          = KEY[0];
  assign uart_rx          = GPIO[7];
  assign GPIO[0]          = i2s_bit_clock;
  assign GPIO[1]          = i2s_data;
  assign GPIO[2]          = i2s_left_right_clock;

  AudioPLL audio_pll (
      .ref_clk_clk       (clock_50_000_000),
      .ref_reset_reset   (!reset_l),
      .audio_clk_clk     (clock_16_934_400),
      .reset_source_reset()
  );

  UARTDriver #(
      .BAUD_RATE(MIDI::BAUD_RATE)
  ) uart_driver (
      .clock_50_000_000,
      .uart_rx,
      .reset_l,
      .data_in,
      .data_in_ready
  );

  conFFTi conffti (
      .clock_50_000_000,
      .reset_l,
      .data_in,
      .data_in_ready,
      .audio_out
  );

  DACDriver dac_driver (
      .clock_16_934_400,
      .reset_l,
      .audio_out,
      .i2s_bit_clock,
      .i2s_left_right_clock,
      .i2s_data
  );

endmodule : ChipInterface
