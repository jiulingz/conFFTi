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

  // TODO: change this placeholder
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
    if (!reset_l) audio_out <= '0;
    else audio_out <= audio_out + (1 << 16);

endmodule
