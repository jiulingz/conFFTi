`ifndef INTERNAL_DEFINES_VH_
`define INTERNAL_DEFINES_VH_

package conFFTi;

  typedef enum logic [1:0] {
    SIN = 2'b00,
    SQR = 2'b01,
    SAW = 2'b10,
    TRI = 2'b11
  } wave_sel_t;

  typedef enum logic {
    ON  = 1'b1,
    OFF = 1'b0
  } note_en_t;

  typedef struct packed {
    logic [6:0] note;  // 21~108
    logic [6:0] velocity;  // 0~127
    wave_sel_t wave_sel;
    note_en_t note_en;
  } dsp_to_osc_t;

  typedef enum logic {
    PP  = 1'b0,
    ARP = 1'b1
  } pp_arp_sel_t;

  typedef enum logic [2:0] {
    UP          = 3'b000,
    DOWN        = 3'b001,
    UPDOWN      = 3'b010,
    PLAYED      = 3'b011,
    RANDOM_MODE = 3'b100,
    CHORD       = 3'b101
  } mode_t;

  typedef enum logic [2:0] {
    QUARTER               = 3'b000,
    EIGHTH                = 3'b001,
    SIXTEENTH             = 3'b010,
    THIRTY_SECOND         = 3'b011,
    QUARTER_TRIPLET       = 3'b100,
    EIGHTH_TRIPLET        = 3'b101,
    SIXTEENTH_TRIPLET     = 3'b110,
    THIRTY_SECOND_TRIPLET = 3'b111
  } rate_t;

  typedef enum logic [1:0] {
    O             = 2'b00,
    OXO           = 2'b01,
    OXXO          = 2'b10,
    RANDOM_RHYTHM = 2'b11
  } rhythm_t;

endpackage : conFFTi

`endif  /* INTERNAL_DEFINES_VH_ */
