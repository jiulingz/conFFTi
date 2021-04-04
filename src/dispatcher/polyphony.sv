// `default_nettype none

`include "../internal_defines.vh"

module PolyphonyControl
  import conFFTi::*;
#(
    parameter COUNT = 4
) (
    input  wire logic                      input_en,
    input  wire logic                      clk,
    input  wire logic                      reset,
    input  note_en_t                  note_in_en,
    input  wire logic     [      6:0]      note_in,
    input  wire logic     [      6:0]      velocity_in,
    output logic          [COUNT-1:0]      notes_out_en,
    output logic          [COUNT-1:0][6:0] notes_out,
    output logic          [COUNT-1:0][6:0] velocities_out
);


  logic                       has_empty_pipeline;
  logic [$clog2(COUNT+1)-1:0] next_pipeline;
  search #(
      .ELEMENT_WIDTH(1),
      .ELEMENT_COUNT(COUNT)
  ) state_search (
      .needle  (1'b0),
      .heystack(notes_out_en),
      .contains(has_empty_pipeline),
      .index   (next_pipeline)
  );
  logic                       note_playing;
  logic [$clog2(COUNT+1)-1:0] note_pipeline;
  search #(
      .ELEMENT_WIDTH(7),
      .ELEMENT_COUNT(COUNT)
  ) note_search (
      .needle  (note_in),
      .heystack(notes_out),
      .contains(note_playing),
      .index   (note_pipeline)
  );

  always @(posedge reset, posedge clk)
    if (reset) begin
      notes_out_en   <= '0;
      velocities_out <= '0;
      notes_out      <= '0;
    end else if (input_en) begin
      unique case (note_in_en)
        ON:
        if (!note_playing && has_empty_pipeline) begin
          notes_out_en[next_pipeline]   <= 1'b1;
          notes_out[next_pipeline]      <= note_in;
          velocities_out[next_pipeline] <= velocity_in;
        end
        OFF:
        if (note_playing) begin
          notes_out_en[note_pipeline]   <= 1'b0;
          notes_out[note_pipeline]      <= '0;
          velocities_out[note_pipeline] <= '0;
        end
      endcase
    end

endmodule
