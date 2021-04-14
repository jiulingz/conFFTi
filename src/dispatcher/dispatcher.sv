`default_nettype none

`include "../includes/midi.vh"

module Dispatcher
  import MIDI::*;
#(
    parameter PIPELINE_COUNT = 4
) (
    input  logic                                              clock_50_000_000,
    input  logic                                              reset_l,
    input  PARAMETER::parameter_t                             parameters,
    input  PARAMETER::parameter_change_t                      parameter_changes,
    input  message_t                                          message,
    input  logic                                              message_ready,
    output note_change_t                 [PIPELINE_COUNT-1:0] pipeline_notes,
    output logic                         [PIPELINE_COUNT-1:0] pipeline_notes_ready
);

  note_change_t note;
  logic         note_ready;
  always_comb begin
    unique case (message.message_type)
      NOTE_ON: begin
        note_ready = message_ready;
        note = '{status: ON, note_number: message.data_byte1, velocity   : message.data_byte2};
      end
      NOTE_OFF: begin
        note_ready = message_ready;
        note = '{status: OFF, note_number: message.data_byte1, velocity   : message.data_byte2};
      end
      default: begin
        note_ready = '0;
        note       = '0;
      end
    endcase
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

  // TODO: (jiulingz) add arpegiator

endmodule : Dispatcher
