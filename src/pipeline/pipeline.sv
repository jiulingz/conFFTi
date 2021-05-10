`default_nettype none

`include "../includes/config.vh"
`include "../includes/midi.vh"

`define min(X, Y) ((X < Y) ? X : Y)
`define max(X, Y) ((X > Y) ? X : Y)

module Pipeline (
    input  logic                                                       clock_50_000_000,
    input  logic                                                       reset_l,
    input  PARAMETER::parameter_t                                      parameters,
    input  PARAMETER::parameter_change_t                               parameter_changes,
    input  logic                         [ CONFIG::NUM_WAVETABLES-1:0] wave_switch,
    input  MIDI::note_change_t                                         note,
    input  logic                                                       note_ready,
    output logic                         [CONFIG::AUDIO_BIT_WIDTH-1:0] audio
);

  import MIDI::*;
  import CONFIG::*;
  import PARAMETER::*;

  // period
  logic [PERIOD_WIDTH-1:0] period;
  logic [PERIOD_WIDTH-1:0] period_table[(1 << DATA_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/period_table.vm", period_table);
`else
    $readmemb("lut/period_table.vm", period_table);
`endif
  end
  assign period = period_table[note.note_number];

  // oscillator
  logic [NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] waves;
  logic clear;
  assign clear = note_ready && note.status == ON;
  Oscillator oscillator (
      .clock_50_000_000,
      .reset_l,
      .clear,
      .period,
      .duty_cycle(parameters.duty_cycle),
      .waves
  );

  // detune
  localparam SHIFT_WIDTH = PERIOD_WIDTH + PERIOD_WIDTH + DATA_WIDTH;
  logic [SHIFT_WIDTH-1:0] detune_shift;
  assign detune_shift = period * period * parameters.unison_detune;

  logic [DETUNE_SHIFTS-1:0][NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] detune_high;
  logic [DETUNE_SHIFTS-1:0][NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] detune_low;
  generate
    genvar i;
    for (i = 0; i < DETUNE_SHIFTS; i++) begin : detunes
      Oscillator detune1 (
          .clock_50_000_000,
          .reset_l,
          .clear,
          .period(`min(PERIOD_MAX, period + (i + 1) * detune_shift[SHIFT_WIDTH-1-:PERIOD_WIDTH])),
          .duty_cycle(parameters.duty_cycle),
          .waves(detune_high[i])
      );
      Oscillator detune2 (
          .clock_50_000_000,
          .reset_l,
          .clear,
          .period(`max(PERIOD_MIN, period - (i + 1) * detune_shift[SHIFT_WIDTH-1-:PERIOD_WIDTH])),
          .duty_cycle(parameters.duty_cycle),
          .waves(detune_low[i])
      );
    end
  endgenerate

  logic [NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] detuned_audio;
  localparam COLLECT_WIDTH = AUDIO_BIT_WIDTH + $clog2(DETUNE_SHIFTS * 2);
  logic [COLLECT_WIDTH-1:0] collect;
  always_comb begin
    for (int i = 0; i < NUM_WAVETABLES; i++) begin
      collect = 0;
      for (int j = 0; j < DETUNE_SHIFTS; j++) begin
        collect += detune_high[j][i] + detune_low[j][i];
      end
      if (parameters.unison_detune == 0) detuned_audio[i] = waves[i];
      else begin
        detuned_audio[i] = (5 * waves[i] + 3 * collect[COLLECT_WIDTH-1-:AUDIO_BIT_WIDTH]) >> 3;
      end
    end
  end

  // adsr
  long_percent_t envelope;
  logic envelope_end;
  Envelope env (
      .clock_50_000_000,
      .reset_l,
      .parameters,
      .note_on (note_ready && note.status == ON),
      .note_off(note_ready && note.status == OFF),
      .envelope
  );
  logic [NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] enveloped_audio;
  logic [AUDIO_BIT_WIDTH+LONG_PERCENT_WIDTH+PERCENT_WIDTH-1:0] high_precision;
  always_comb begin
    for (int i = 0; i < NUM_WAVETABLES; i++) begin
      high_precision = detuned_audio[i] * envelope * note.velocity;
      enveloped_audio[i] = high_precision[AUDIO_BIT_WIDTH+LONG_PERCENT_WIDTH+PERCENT_WIDTH-1-:AUDIO_BIT_WIDTH];
    end
  end

  // wave selection
  always_comb begin
    audio = '0;
    for (int i = 0; i < NUM_WAVETABLES; i++) begin
      if (wave_switch[i]) audio = enveloped_audio[i];
    end
  end

endmodule : Pipeline
