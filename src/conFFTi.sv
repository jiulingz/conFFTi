`default_nettype none

`include "includes/config.vh"
`include "includes/midi.vh"

module conFFTi (
    input  logic                                    clock_50_000_000,
    input  logic                                    reset_l,
    input  logic [     CONFIG::BYTE_WIDTH-1:0]      data_in,
    input  logic                                    data_in_ready,
    output logic [CONFIG::AUDIO_BIT_WIDTH-1:0]      audio_out,
    // debug display
    output logic [                        5:0][3:0] midi_info,
    output logic [                        5:0]      midi_info_en,
    output logic [                        3:0]      pipeline_info
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

  PARAMETER::parameter_t        parameters;
  PARAMETER::parameter_change_t parameter_changes;
  ParameterControl parameter_control (
      .clock_50_000_000,
      .reset_l,
      .message,
      .message_ready,
      .parameters,
      .parameter_changes
  );

  MIDI::note_change_t [CONFIG::PIPELINE_COUNT-1:0] pipeline_notes;
  logic [CONFIG::PIPELINE_COUNT-1:0] pipeline_notes_ready;
  Dispatcher #(
      .PIPELINE_COUNT(CONFIG::PIPELINE_COUNT)
  ) dispatcher (
      .clock_50_000_000,
      .reset_l,
      .parameters,
      .parameter_changes,
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
          .parameter_changes,
          .note      (pipeline_notes[i]),
          .note_ready(pipeline_notes_ready[i]),
          .audio     (pipeline_audios[i])
      );
    end
  endgenerate

  Mixer #(
      .PIPELINE_COUNT(CONFIG::PIPELINE_COUNT)
  ) mixer (
      .parameters,
      .pipeline_audios,
      .audio_out
  );

  // debug diaplay
  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      midi_info_en <= '0;
    end else if (message_ready) begin
      midi_info_en[4]   <= '1;
      midi_info[4]      <= message.message_type;
      midi_info_en[3:2] <= '1;
      midi_info[3:2]    <= message.data_byte1;
      midi_info_en[1:0] <= '1;
      midi_info[1:0]    <= message.data_byte2;
    end
  end

  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      pipeline_info <= '0;
    end else begin
      if (pipeline_notes_ready[0]) pipeline_info[0] <= pipeline_notes[0].status;
      if (pipeline_notes_ready[1]) pipeline_info[1] <= pipeline_notes[1].status;
      if (pipeline_notes_ready[2]) pipeline_info[2] <= pipeline_notes[2].status;
      if (pipeline_notes_ready[3]) pipeline_info[3] <= pipeline_notes[3].status;
    end
  end

endmodule : conFFTi
