`ifndef MIDI_VH_
`define MIDI_VH_

package MIDI;

  parameter BAUD_RATE = 31250;

  parameter DATA_WIDTH = 7;
  parameter CHANNEL_WIDTH = 4;

  typedef enum logic {
    STATUS = 1'b1,
    DATA   = 1'b0
  } byte_type_t;

  typedef enum logic [3:0] {
    NOTE_OFF            = 4'h8,
    NOTE_ON             = 4'h9,
    POLYPHONIC_PRESSURE = 4'hA,
    CONTROL_CHANGE      = 4'hB,
    PROGRAM_CHANGE      = 4'hC,
    CHANNEL_PRESSURE    = 4'hD,
    PITCH_BEND          = 4'hE,
    SYSTEM              = 4'hF
  } message_type_t;
  typedef struct packed {
    message_type_t message_type;
    logic [DATA_WIDTH-1:0] data_byte1;
    logic [DATA_WIDTH-1:0] data_byte2;
  } message_t;

  typedef enum logic {
    OFF = 1'b0,
    ON  = 1'b1
  } status_t;
  typedef logic [DATA_WIDTH-1:0] note_t;
  typedef logic [DATA_WIDTH-1:0] velocity_t;
  typedef struct packed {
    status_t status;
    note_t note_number;
    velocity_t velocity;
  } note_change_t;

  typedef enum logic [DATA_WIDTH-1:0] {
    MODULATION  = 7'h01,
    UNUSED_KNOB = 7'h15,
    UNISON      = 7'h16,
    DUTY_CYCLE  = 7'h17,
    ATTACK      = 7'h18,
    DECAY       = 7'h19,
    SUSTAIN     = 7'h1A,
    RELEASE     = 7'h1B,
    VOLUME      = 7'h1C,
    UNUSED_PAD1 = 7'h68,
    UNUSED_PAD2 = 7'h69,
    PLAY        = 7'h73,
    RECORD      = 7'h75
  } controller_t;
  typedef logic [DATA_WIDTH-1:0] value_t;
  typedef struct packed {
    controller_t controller_number;
    value_t value;
  } control_change_t;

endpackage : MIDI

`endif  /* MIDI_VH_ */
