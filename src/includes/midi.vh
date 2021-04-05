`ifndef MIDI_VH_
`define MIDI_VH_

`include "config.vh"

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

  typedef logic [DATA_WIDTH-1:0] note_t;
  typedef enum logic [DATA_WIDTH-1:0] {
    TEMPO   = 7'd21,
    UNISON  = 7'd22,
    ATTACK  = 7'd24,
    DECAY   = 7'd25,
    SUSTAIN = 7'd26,
    RELEASE = 7'd27,
    VOLUME  = 7'd28
  } controller_t;
  typedef enum logic [DATA_WIDTH-1:0] {TODO = 7'd0} program_t; // TODO: (ck3) add program changes (key press)

  typedef struct packed {
    message_type_t message_type;
    logic [DATA_WIDTH-1:0] data_byte1;
    logic [DATA_WIDTH-1:0] data_byte2;
  } message_t;
  typedef struct packed {
    message_type_t message_type;
    note_t note_number;
    logic [DATA_WIDTH-1:0] velocity;
  } note_on_t;
  typedef struct packed {
    message_type_t message_type;
    note_t note_number;
    logic [DATA_WIDTH-1:0] zero;
  } note_off_t;
  typedef struct packed {
    message_type_t message_type;
    controller_t controller_number;
    logic [DATA_WIDTH-1:0] value;
  } control_change_t;
  typedef struct packed {
    message_type_t message_type;
    program_t program_number;
    logic [DATA_WIDTH-1:0] zero;
  } program_change_t;

endpackage : MIDI

`endif  /* MIDI_VH_ */
