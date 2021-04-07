`ifndef PARAMETER_VH_
`define PARAMETER_VH_

`include "config.vh"
`include "midi.vh"

package PARAMETER;

  typedef enum logic [1:0] {
    SINE     = '0,
    PULSE,
    TRIANGLE
  } wave_t;

  typedef enum logic {
    POLYPHONY   = '0,
    ARPEGGIATOR
  } dispatcher_mode_t;

  typedef enum logic [2:0] {
    ARP_MODE_UP     = '0,
    ARP_MODE_DOWN,
    ARP_MODE_UPDOWN,
    ARP_MODE_PLAYED,
    ARP_MODE_RANDOM,
    ARP_MODE_CHORD
  } arp_mode_t;

  typedef enum logic [2:0] {
    ARP_RATE_QUARTER               = '0,
    ARP_RATE_EIGHTH,
    ARP_RATE_SIXTEENTH,
    ARP_RATE_THIRTY_SECOND,
    ARP_RATE_QUARTER_TRIPLET,
    ARP_RATE_EIGHTH_TRIPLET,
    ARP_RATE_SIXTEENTH_TRIPLET,
    ARP_RATE_THIRTY_SECOND_TRIPLET
  } arp_rate_t;

  typedef enum logic [1:0] {
    ARP_RHYTHM_O      = '0,
    ARP_RHYTHM_OXO,
    ARP_RHYTHM_OXXO,
    ARP_RHYTHM_RANDOM
  } arp_rhythm_t;

  import CONFIG::percent_t;
  typedef struct packed {
    percent_t volume;
    logic [MIDI::DATA_WIDTH-1:0] unison_detune;
    logic [MIDI::DATA_WIDTH-1:0] attack_time;
    logic [MIDI::DATA_WIDTH-1:0] decay_time;
    percent_t sustain_level;
    logic [MIDI::DATA_WIDTH-1:0] release_time;
    logic [MIDI::DATA_WIDTH-1:0] tempo;
    wave_t wave;
    percent_t duty_cycle;
    dispatcher_mode_t dispatcher_mode;
    arp_mode_t arp_mode;
    arp_rate_t arp_rate;
    arp_rhythm_t arp_rhythm;
  } parameter_t;
  typedef enum logic [3:0] {
    PARAM_NONE            = '0,
    PARAM_VOLUME,
    PARAM_UNISON_DETUNE,
    PARAM_ATTACK_TIME,
    PARAM_DECAY_TIME,
    PARAM_SUSTAIN_LEVEL,
    PARAM_RELEASE_TIME,
    PARAM_TEMPO,
    PARAM_WAVE,
    PARAM_DUTY_CYCLE,
    PARAM_DISPATCHER_MODE,
    PARAM_ARP_MODE,
    PARAM_ARP_RATE,
    PARAM_ARP_RHYTHM
  } parameter_change_t;

endpackage : PARAMETER

`endif  /* PARAMETER_VH_ */
