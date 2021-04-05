`default_nettype none

`include "includes/config.vh"
`include "../includes/midi.vh"

module conFFTi (
    input  logic                               clock_50_000_000,
    input  logic                               clock_16_934_400,
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
  // TODO: change this placeholder
  always_comb begin
    for (int i = 1; i < CONFIG::PIPELINE_COUNT; i++) pipeline_audios[i] = '0;
  end
  import CONFIG::AUDIO_SAMPLE_RATE;
  import CONFIG::AUDIO_CLOCK;
  localparam EDGES = 2;
  localparam SAMPLE_TICKS = AUDIO_CLOCK / (AUDIO_SAMPLE_RATE * EDGES);
  logic [$clog2(SAMPLE_TICKS)-1:0] sample_count;
  logic                            clock_44_100;
  always_ff @(posedge clock_16_934_400, negedge reset_l)
    if (!reset_l) begin
      clock_44_100 <= '0;
      sample_count <= '0;
    end else begin
      if (sample_count >= SAMPLE_TICKS - 1) begin
        clock_44_100 <= ~clock_44_100;
        sample_count <= '0;
      end else begin
        sample_count <= sample_count + 1'b1;
      end
    end
  always_ff @(posedge clock_44_100, negedge reset_l)
    if (!reset_l) pipeline_audios[0] <= '0;
    else pipeline_audios[0] <= pipeline_audios[0] + (1 << 16);

  Mixer #(
      .PIPELINE_COUNT(CONFIG::PIPELINE_COUNT)
  ) mixer (
      .pipeline_audios,
      .audio_out
  );

endmodule
