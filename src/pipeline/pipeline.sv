`default_nettype none

`include "../includes/config.vh"
`include "../includes/midi.vh"

module Pipeline (
    input  logic                                                       clock_50_000_000,
    input  logic                                                       reset_l,
    input  PARAMETER::parameter_t                                      parameters,
    input  PARAMETER::parameter_change_t                               parameter_changes,
    input  MIDI::note_change_t                                         note,
    input  logic                                                       note_ready,
    output logic                         [CONFIG::AUDIO_BIT_WIDTH-1:0] audio
);

  import MIDI::*;
  import CONFIG::*;
  import PARAMETER::*;

  // oscillator
  logic [   PERIOD_WIDTH-1:0] period;
  logic [   PERIOD_WIDTH-1:0] duty_cycle;
  logic [AUDIO_BIT_WIDTH-1:0] sine;
  logic [AUDIO_BIT_WIDTH-1:0] pulse;
  logic [AUDIO_BIT_WIDTH-1:0] triangle;

  Oscillator oscillator (
      .clock_50_000_000,
      .reset_l,
      .clear     (note_ready && note.status == ON),
      .period,
      .duty_cycle(parameters.duty_cycle),
      .sine,
      .pulse,
      .triangle
  );

  // period
  logic [PERIOD_WIDTH-1:0] period_table[(1 << DATA_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/period_table.vm", period_table);
`else
    $readmemb("lut/period_table.vm", period_table);
`endif
  end
  assign period = period_table[note.note_number];

  logic [AUDIO_BIT_WIDTH-1:0] envelope;
  logic envelope_end;
  Envelope env (
    .clock_50_000_000,
    .reset_l,
    .parameters,
    .note_on  (note_ready && note.status == ON),
    .note_off (note_ready && note.status == OFF),
    .envelope,
    .envelope_end
  );
  // TODO: (mychang) add unision detune

  // temp values
  logic [AUDIO_BIT_WIDTH-1:0] audio_before_envelope;
  logic [AUDIO_BIT_WIDTH+AUDIO_BIT_WIDTH-1:0] audio_w_envelope;

  always_ff @(posedge clock_50_000_000) begin
    if (envelope_end) begin
      audio <= '0;
    end else begin
      unique case (parameters.wave)
        NONE:     audio_before_envelope <= '0;
        SINE:     audio_before_envelope <= sine;
        PULSE:    audio_before_envelope <= pulse;
        TRIANGLE: audio_before_envelope <= triangle;
      endcase
      audio_w_envelope <= (audio_before_envelope * envelope) >> AUDIO_BIT_WIDTH;
      audio <= (audio_w_envelope[AUDIO_BIT_WIDTH-1:0] >> PERCENT_WIDTH) * note.velocity;
    end
  end

endmodule : Pipeline
