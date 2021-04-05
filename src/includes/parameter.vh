`ifndef PARAMETER_VH_
`define PARAMETER_VH_

`include "midi.vh"

package PARAMETER;

  typedef enum logic [1:0] {
    SIN = '0,
    SQR,
    SAW,
    TRI
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

  typedef struct packed {
    logic [MIDI::DATA_WIDTH-1:0] volume;
    logic [MIDI::DATA_WIDTH-1:0] unison_detune;
    logic [MIDI::DATA_WIDTH-1:0] attack_time;
    logic [MIDI::DATA_WIDTH-1:0] decay_time;
    logic [MIDI::DATA_WIDTH-1:0] sustain_level;
    logic [MIDI::DATA_WIDTH-1:0] release_time;
    logic [MIDI::DATA_WIDTH-1:0] tempo;
    wave_t wave;
    dispatcher_mode_t dispatcher_mode;
    arp_mode_t arp_mode;
    arp_rate_t arp_rate;
    arp_rhythm_t arp_rhythm;
  } parameter_t;

endpackage : PARAMETER

`endif  /* PARAMETER_VH_ */
