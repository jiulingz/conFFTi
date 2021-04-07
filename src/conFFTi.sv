`default_nettype none

`include "includes/config.vh"
`include "includes/midi.vh"

module conFFTi (
    input  logic                               clock_50_000_000,
    input  logic                               reset_l,
    input  logic [     CONFIG::BYTE_WIDTH-1:0] data_in,
    input  logic                               data_in_ready,
    output logic [CONFIG::AUDIO_BIT_WIDTH-1:0] audio_out
);

  MIDI::message_t message;
  logic           message_ready;
  MIDIDecoder midi_decoder (
      .clock_50_000_000,
      .reset_l,
      .data_in,
      .data_in_ready,
      .message,
      .message_ready
  );

  PARAMETER::parameter_t parameters;
  ParameterControl parameter_control (
      .clock_50_000_000,
      .reset_l,
      .message,
      .parameters
  );

  MIDI::note_change_t [CONFIG::PIPELINE_COUNT-1:0] pipeline_notes;
  logic [CONFIG::PIPELINE_COUNT-1:0] pipeline_notes_ready;
  Dispatcher #(
      .PIPELINE_COUNT(CONFIG::PIPELINE_COUNT)
  ) dispatcher (
      .clock_50_000_000,
      .reset_l,
      .message,
      .message_ready,
      .pipeline_notes,
      .pipeline_notes_ready
  );

  logic [CONFIG::PIPELINE_COUNT-1:0][CONFIG::AUDIO_BIT_WIDTH-1:0] pipeline_audios;
  generate
    genvar i;
    for (i = 0; i < CONFIG::PIPELINE_COUNT; i++) begin : pipelines
      Pipeline pipeline (
          .clock_50_000_000,
          .reset_l,
          .parameters,
          .note      (pipeline_notes[i]),
          .note_ready(pipeline_notes_ready[i]),
          .audio     (pipeline_audios[i])
      );
    end
  endgenerate

  Mixer #(
      .PIPELINE_COUNT(CONFIG::PIPELINE_COUNT)
  ) mixer (
      .pipeline_audios,
      .audio_out
  );

endmodule : conFFTi
