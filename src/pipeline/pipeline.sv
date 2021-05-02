`default_nettype none

`include "../includes/config.vh"
`include "../includes/midi.vh"

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
  logic [DETUNE_SHIFTS-1:0][NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] detune_high;
  logic [DETUNE_SHIFTS-1:0][NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] detune_low;
  logic [(PERIOD_WIDTH-1)-1:0] detune_diff;
  assign detune_diff = ((period * parameters.unison_detune) >> PERCENT_WIDTH) >> 1;
  generate
    genvar i;
    for (i = 0; i < DETUNE_SHIFTS; i++) begin : detunes
      Oscillator detune1 (
          .clock_50_000_000,
          .reset_l,
          .clear,
          .period    (period + i * detune_diff),
          .duty_cycle(parameters.duty_cycle),
          .waves     (detune_high[i])
      );
      Oscillator detune2 (
          .clock_50_000_000,
          .reset_l,
          .clear,
          .period    (period - i * detune_diff),
          .duty_cycle(parameters.duty_cycle),
          .waves     (detune_low[i])
      );
    end
  endgenerate
  logic [NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] detune;
  logic [AUDIO_BIT_WIDTH+$clog2(DETUNE_SHIFTS*2)-1:0] collect;
  always_comb begin
    for (int i = 0; i < NUM_WAVETABLES; i++) begin
      collect = 0;
      for (int j = 0; j < DETUNE_SHIFTS; j++) begin
        collect += detune_high[j] + detune_low[j];
      end
      detune[i] = (waves[i] + collect >> $clog2(DETUNE_SHIFTS*2)) >> 1;
    end
  end

  // TODO: (hongrunz) add ADSR + velocity

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
