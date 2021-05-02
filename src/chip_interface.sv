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

  logic                                    clock_50_000_000;
  logic                                    clock_16_934_400;
  logic                                    reset_l;
  logic                                    uart_rx;
  logic [     CONFIG::BYTE_WIDTH-1:0]      data_in;
  logic                                    data_in_ready;
  logic                                    i2s_bit_clock;
  logic                                    i2s_left_right_clock;
  logic                                    i2s_data;
  logic [CONFIG::AUDIO_BIT_WIDTH-1:0]      audio_out;
  logic [ CONFIG::NUM_WAVETABLES-1:0]      wave_switch;
  // debug display
  logic [                        5:0][3:0] midi_info;
  logic [                        5:0]      midi_info_en;
  logic [                        3:0]      pipeline_info;

  assign clock_50_000_000 = CLOCK_50;
  assign reset_l          = KEY[0];
  assign wave_switch      = SW[CONFIG::NUM_WAVETABLES-1:0];
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
      .wave_switch,
      .audio_out,
      // debug display
      .midi_info,
      .midi_info_en,
      .pipeline_info
  );

  DACDriver dac_driver (
      .clock_16_934_400,
      .reset_l,
      .audio_out,
      .i2s_bit_clock,
      .i2s_left_right_clock,
      .i2s_data
  );

  SevenSegmentDriver seven_segment_driver (
      .value  ({8'b0, midi_info}),
      .en     ({2'b00, midi_info_en}),
      .segment({HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0})
  );

  assign LEDG[3:0] = pipeline_info;

  assign LEDR[0]   = audio_out > 24'd0;
  assign LEDR[1]   = audio_out > 24'd932067;
  assign LEDR[2]   = audio_out > 24'd1864135;
  assign LEDR[3]   = audio_out > 24'd2796202;
  assign LEDR[4]   = audio_out > 24'd3728270;
  assign LEDR[5]   = audio_out > 24'd4660337;
  assign LEDR[6]   = audio_out > 24'd5592405;
  assign LEDR[7]   = audio_out > 24'd6524472;
  assign LEDR[8]   = audio_out > 24'd7456540;
  assign LEDR[9]   = audio_out > 24'd8388608;
  assign LEDR[10]  = audio_out > 24'd9320675;
  assign LEDR[11]  = audio_out > 24'd10252743;
  assign LEDR[12]  = audio_out > 24'd11184810;
  assign LEDR[13]  = audio_out > 24'd12116878;
  assign LEDR[14]  = audio_out > 24'd13048945;
  assign LEDR[15]  = audio_out > 24'd13981013;
  assign LEDR[16]  = audio_out > 24'd14913080;
  assign LEDR[17]  = audio_out > 24'd15845148;

endmodule : ChipInterface
