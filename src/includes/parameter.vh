`ifndef PARAMETER_VH_
`define PARAMETER_VH_

`include "config.vh"
`include "midi.vh"

package PARAMETER;

  typedef enum logic [$clog2(CONFIG::NUM_WAVETABLES)-1:0] {
    SINE        = 3'd0,
    PULSE       = 3'd1,
    TRIANGLE    = 3'd2,
    CELLO       = 3'd3,
    FRENCH_HORN = 3'd4,
    TRUMPET     = 3'd5,
    VIOLA       = 3'd6,
    VIOLIN      = 3'd7
  } wave_t;

  import CONFIG::percent_t;
  typedef struct packed {
    percent_t volume;
    logic [MIDI::DATA_WIDTH-1:0] unison_detune;
    logic [MIDI::DATA_WIDTH-1:0] attack_time;
    logic [MIDI::DATA_WIDTH-1:0] decay_time;
    percent_t sustain_level;
    logic [MIDI::DATA_WIDTH-1:0] release_time;
    percent_t duty_cycle;
  } parameter_t;
  parameter parameter_t DEFAULT_PARAMETERS = '{
    volume: 'h40,
    unison_detune: 'h0,
    attack_time: 'h0,
    decay_time: 'h0,
    sustain_level: 'h7F,
    release_time: 'h0,
    duty_cycle: 'h40
  };
  typedef enum logic [3:0] {
    PARAM_NONE            = '0,
    PARAM_VOLUME,
    PARAM_UNISON_DETUNE,
    PARAM_ATTACK_TIME,
    PARAM_DECAY_TIME,
    PARAM_SUSTAIN_LEVEL,
    PARAM_RELEASE_TIME,
    PARAM_DUTY_CYCLE
  } parameter_change_t;

endpackage : PARAMETER

`endif  /* PARAMETER_VH_ */
