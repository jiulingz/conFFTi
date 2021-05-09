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
  localparam SHIFT_WIDTH = PERIOD_WIDTH+PERIOD_WIDTH+DATA_WIDTH;
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
          .period    (`min(PERIOD_MAX, period +  (i + 1) * detune_shift[SHIFT_WIDTH-1-:PERIOD_WIDTH])),
          .duty_cycle(parameters.duty_cycle),
          .waves(detune_high[i])
      );
      Oscillator detune2 (
          .clock_50_000_000,
          .reset_l,
          .clear,
          .period    (`max(PERIOD_MIN, period - (i + 1) * detune_shift[SHIFT_WIDTH-1-:PERIOD_WIDTH])),
          .duty_cycle(parameters.duty_cycle),
          .waves(detune_low[i])
      );
    end
  endgenerate
  logic [NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] detune;
  logic [AUDIO_BIT_WIDTH+$clog2(DETUNE_SHIFTS*2)-1:0] collect;
  always_comb begin
    for (int i = 0; i < NUM_WAVETABLES; i++) begin
      collect = 0;
      for (int j = 0; j < DETUNE_SHIFTS; j++) begin
        collect += detune_high[j][i] + detune_low[j][i];
      end
      if (parameters.unison_detune == 0) detune[i] = waves[i];
      else detune[i] = (5 * waves[i] + 3 * collect[AUDIO_BIT_WIDTH+$clog2(DETUNE_SHIFTS*2)-1-:AUDIO_BIT_WIDTH]) >> 3;
    end
  end

  // adsr
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

  always_comb begin
    if (note.status == OFF) begin
      audio = '0;
    end else begin
      audio = '0;
      for (int i = 0; i < NUM_WAVETABLES; i++) begin
        if (wave_switch[i]) audio = detune[i];
      end
    end
  end

endmodule : Pipeline
