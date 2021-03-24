`default_nettype none

`include "internal_defines.vh"

module decoder(
  input  logic       clk, reset,
  input  logic       ready,
  input  logic [7:0] MIDIbyte,
  output logic       output_ready,
  output logic [6:0] note,
  output logic [6:0] velocity,
  output note_en_t       note_event
);

  enum logic [3:0] {
    IDLE          = 3'b000,
    GOT_STATUS    = 3'b001,
    DATA_MSG_I    = 3'b010,
    NOTE_ON       = 3'b011,
    NOTE_OFF      = 3'b100,
    PARAM_CHANGE  = 3'b101
  } c_state, n_state;

  logic isStatus, isDataMsgI, isDataMsgII, isParamChange, isNoteOn, isNoteOff;

  // TODOs
  // assgin isStatus = ready & (cond);

  always_ff @(posedge clock, posedge reset)
    if (reset) begin
      c_state <= IDLE;
    end
    else if (ready) begin
      case (c_state)
        IDLE: n_state <= isStatus ? GOT_STATUS : IDLE;
        GOT_STATUS: n_state <= isDataMsgI ? DATA_MSG_I : IDLE;
        DATA_MSG_I: begin
          if (isParamChange == 1'b1) n_state <= PARAM_CHANGE;
          else if (isNoteOn == 1'b1) n_state <= 
        end
      endcase
    end
    if (c_state != n_state) begin
      // TODO: a state change is detected, update output in final states
    end
    c_state <= n_state;

endmodule: decoder