`default_nettype none

`include "../includes/midi.vh"

module Dispatcher
  import MIDI::*;
#(
    parameter PIPELINE_COUNT = 4
) (
    input  logic                              clock_50_000_000,
    input  logic                              reset_l,
    input  message_t                          message,
    input  logic                              message_ready,
    output note_change_t [PIPELINE_COUNT-1:0] pipeline_notes,
    output logic         [PIPELINE_COUNT-1:0] pipeline_notes_ready
);

  note_change_t note;
  logic         note_ready;
  always_comb begin
    note_ready = '0;
    note       = '0;
    if (message.message_type == NOTE_ON || message.message_type == NOTE_OFF) begin
      note_ready       = message_ready;
      note.status      = message.message_type == NOTE_ON ? ON : OFF;
      note.note_number = message.data_byte1;
      note.velocity    = message.data_byte2;
    end
  end

  Polyphony #(
      .PIPELINE_COUNT(CONFIG::PIPELINE_COUNT)
  ) polyphony (
      .clock_50_000_000,
      .reset_l,
      .note,
      .note_ready,
      .pipeline_notes,
      .pipeline_notes_ready
  );

endmodule
