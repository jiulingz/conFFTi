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
    NOTE_ON        = 4'h8,
    NOTE_OFF       = 4'h9,
    CONTROL_CHANGE = 4'hB,
    PROGRAM_CHANGE = 4'hC
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
    TEMPO   = 7'd21,
    UNISON  = 7'd22,
    ATTACK  = 7'd24,
    DECAY   = 7'd25,
    SUSTAIN = 7'd26,
    RELEASE = 7'd27,
    VOLUME  = 7'd28
  } controller_t;
  typedef logic [DATA_WIDTH-1:0] value_t;
  typedef struct packed {
    controller_t controller_number;
    value_t value;
  } control_change_t;

  // TODO: (ck3) add program changes (key press)
  typedef enum logic [DATA_WIDTH-1:0] {TODO = 7'd0} program_t;
  typedef struct packed {program_t program_number;} program_change_t;

endpackage : MIDI

`endif  /* MIDI_VH_ */