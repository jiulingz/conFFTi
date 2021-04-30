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
  logic [AUDIO_BIT_WIDTH-1:0] detune;
  logic [AUDIO_BIT_WIDTH-1:0] sine, sine1, sine2, sine3, sine4;
  logic [AUDIO_BIT_WIDTH-1:0] pulse, pulse1, pulse2, pulse3, pulse4;
  logic [AUDIO_BIT_WIDTH-1:0] triangle, triangle1, triangle2, triangle3, triangle4;
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
  // oscillators below are for unison
  Oscillator detune1 (
      .clock_50_000_000,
      .reset_l,
      .clear     (note_ready && note.status == ON),
      .period(period - ((period >> DETUNE_PERIOD_SCALE1) * parameters.unison_detune >> 10)),
      .duty_cycle(parameters.duty_cycle),
      .sine(sine1),
      .pulse(pulse1),
      .triangle(triangle1)
  );
  Oscillator detune2 (
      .clock_50_000_000,
      .reset_l,
      .clear     (note_ready && note.status == ON),
      .period(period - ((period >> DETUNE_PERIOD_SCALE2) * parameters.unison_detune >> 10)),
      .duty_cycle(parameters.duty_cycle),
      .sine(sine2),
      .pulse(pulse2),
      .triangle(triangle2)
  );
  Oscillator detune3 (
      .clock_50_000_000,
      .reset_l,
      .clear     (note_ready && note.status == ON),
      .period(period + ((period >> DETUNE_PERIOD_SCALE1) * parameters.unison_detune >> 10)),
      .duty_cycle(parameters.duty_cycle),
      .sine(sine3),
      .pulse(pulse3),
      .triangle(triangle3)
  );
  Oscillator detune4 (
      .clock_50_000_000,
      .reset_l,
      .clear     (note_ready && note.status == ON),
      .period(period + ((period >> DETUNE_PERIOD_SCALE2) * parameters.unison_detune >> 10)),
      .duty_cycle(parameters.duty_cycle),
      .sine(sine4),
      .pulse(pulse4),
      .triangle(triangle4)
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

  // TODO: (hongrunz) add ADSR + velocity
  // TODO: (mychang) add unision detune

  // output
  always_comb begin
    if (note.status == OFF) begin
	     detune = '0;
		  audio = '0;
    end
    else
      case (parameters.wave)
        NONE: begin
		     detune = '0;
    		  audio = '0;
		  end
        SINE: begin
		     detune = (sine1 + sine2 + sine3 + sine4) >> 2;
   		  audio = (sine + detune) >> 1;
		  end
        PULSE: begin
		     detune = (pulse1 + pulse2 + pulse3 + pulse4) >> 2;
    		  audio = (pulse + detune) >> 1;
		  end
        TRIANGLE: begin
		     detune = (triangle1 + triangle2 + triangle3 + triangle4) >> 2;
		     audio = (triangle + detune) >> 1;
		  end
      endcase
  end

endmodule : Pipeline
