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
  logic [AUDIO_BIT_WIDTH-1:0] period_table[(1<<LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/period_table.vm", period_table);
`else
    $readmemb("lut/period_table.vm", period_table);
`endif
  end
  assign period = period_table[note.note_number-NOTE_NUMBER_START];

  // TODO: (hongrunz) add ADSR + velocity
  // TODO: (mychang) add unision detune

  // output
  always_comb begin
    if (note.status == OFF) audio = '0;
    else
      case (parameters.wave)
        SINE:     audio = sine;
        PULSE:    audio = pulse;
        TRIANGLE: audio = triangle;
      endcase
  end

endmodule : Pipeline
