`default_nettype none

`include "../internal_defines.vh"

module polyphony_top (
    input wire CLOCK_50
);
  import conFFTi::*;

  logic                input_en;
  logic                clk;
  logic                reset;
  note_en_t            note_in_en;
  logic     [6:0]      note_in;
  logic     [6:0]      velocity_in;
  logic     [3:0]      notes_out_en;
  logic     [3:0][6:0] notes_out;
  logic     [3:0][6:0] velocities_out;

  assign clk = CLOCK_50;
  PolyphonyControl dut (
      .input_en,
      .clk,
      .reset,
      .note_in_en,
      .note_in,
      .velocity_in,
      .notes_out_en,
      .notes_out,
      .velocities_out
  );

endmodule
