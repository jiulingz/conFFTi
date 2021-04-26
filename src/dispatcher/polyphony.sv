`default_nettype none

`include "../includes/midi.vh"

module Polyphony
  import MIDI::*;
#(
    parameter PIPELINE_COUNT = 4
) (
    input  logic                              clock_50_000_000,
    input  logic                              reset_l,
    input  note_change_t                      note,
    input  logic                              note_ready,
    output note_change_t [PIPELINE_COUNT-1:0] pipeline_notes,
    output logic         [PIPELINE_COUNT-1:0] pipeline_notes_ready
);

  note_t     pipeline_note_numbers[PIPELINE_COUNT-1:0];
  velocity_t pipeline_velocities  [PIPELINE_COUNT-1:0];
  status_t   pipeline_status      [PIPELINE_COUNT-1:0];

  generate
    genvar i;
    for (i = 0; i < PIPELINE_COUNT; i++) begin : rewire
      assign pipeline_notes[i].status      = pipeline_status[i];
      assign pipeline_notes[i].note_number = pipeline_note_numbers[i];
      assign pipeline_notes[i].velocity    = pipeline_velocities[i];
    end
  endgenerate

  logic                              is_available;
  logic [$clog2(PIPELINE_COUNT)-1:0] index_available;
  Search #(
      .ELEMENT_WIDTH($bits(status_t)),
      .ELEMENT_COUNT(PIPELINE_COUNT)
  ) status_search (
      .needle  (OFF),
`ifdef SIMULATION  // To pacify ModelSim
      .heystack({pipeline_status}),
`else
      .heystack(pipeline_status),
`endif
      .contains(is_available),
      .index   (index_available)
  );
  logic                              is_playing;
  logic [$clog2(PIPELINE_COUNT)-1:0] index_playing;
  Search #(
      .ELEMENT_WIDTH(DATA_WIDTH),
      .ELEMENT_COUNT(PIPELINE_COUNT)
  ) note_number_search (
      .needle  (note.note_number),
      .heystack(pipeline_note_numbers),
      .contains(is_playing),
      .index   (index_playing)
  );

  always_ff @(posedge clock_50_000_000, negedge reset_l)
    if (!reset_l) begin
      for (int j = 0; j < PIPELINE_COUNT; j++) begin : clear
        pipeline_status[j]       <= OFF;
        pipeline_note_numbers[j] <= '0;
        pipeline_velocities[j]   <= '0;
      end
      pipeline_notes_ready <= '0;
    end else if (note_ready) begin
      unique case (note.status)
        ON: begin
          if ((!is_playing || pipeline_status[index_playing] == OFF) && is_available) begin
            pipeline_status[index_available]       <= ON;
            pipeline_note_numbers[index_available] <= note.note_number;
            pipeline_velocities[index_available]   <= note.velocity;
            pipeline_notes_ready[index_available]  <= '1;
          end
        end
        // TODO(jiulingz): please change OFF status indicator to envelope_idle in pipeline.sv
        OFF: begin
          if (is_playing) begin
            pipeline_status[index_playing]       <= OFF;
            pipeline_note_numbers[index_playing] <= note.note_number;
            pipeline_velocities[index_playing]   <= note.velocity;
            pipeline_notes_ready[index_playing]  <= '1;
          end
        end
      endcase
    end else pipeline_notes_ready <= '0;

endmodule : Polyphony
