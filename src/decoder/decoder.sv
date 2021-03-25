`default_nettype none

`include "internal_defines.vh"

module decoder(
  input  logic       clk, reset,
  input  logic       ready,
  input  logic [7:0] MIDIbyte,
  output logic       note_event_ready, param_change_ready,
  output logic [6:0] note,
  output logic [6:0] velocity,
  output note_en_t   note_event
);

  enum logic [3:0] {
    IDLE          = 3'b000,
    GOT_STATUS    = 3'b001,
    DATA_MSG_I    = 3'b010,
    NOTE_ON       = 3'b011,
    NOTE_OFF      = 3'b100,
    PARAM_CHANGE  = 3'b101
  } c_state, n_state;

  logic isStatus, isDataMsg, isParamChange, isNoteOn, isNoteOff;

  always_ff @(posedge clock, posedge reset)
    if (reset) begin
      c_state <= IDLE;
    end
    else if (ready) begin
      isStatus <= (MIDIbyte[7] == 1'b1);
      isDataMsg <= (MIDIbyte >= 8'd0 && MIDIbyte < 8'd128);
      case (c_state)
        IDLE: n_state <= isStatus ? GOT_STATUS : IDLE;
        GOT_STATUS: begin
          n_state <= isDataMsg ? DATA_MSG_I : IDLE;
          isParamChange <= (MIDIbyte[7:4] == 4'hb);
          isNoteOn <= (MIDIbyte[7:4] == 4'h9);
          isNoteOff <= (MIDIbyte[7:4] == 4'h8);
        end
        DATA_MSG_I: begin
          note <= MIDIbyte[6:0];
          if (isParamChange == 1'b1) n_state <= PARAM_CHANGE;
          else if (isNoteOn == 1'b1) n_state <= NOTE_ON;
          else if (isNoteOff) == 1'b1) n_state <= NOTE_OFF;
          else n_state <= IDLE;
        end
        default: begin
          n_state <= IDLE;
          velocity <= MIDIbyte[6:0];
        end
      endcase
    end
    if (c_state != n_state) begin
      case (n_state)
        IDLE: begin
          note_event_ready <= 1'b0;
          param_change_ready <= 1'b0;
          note <= 7'd0;
          velocity <= 7'd0;
        end
        PARAM_CHANGE: param_change_ready <= 1'b1;
        NOTE_ON: note_event_ready <= 1'b1;
        NOTE_OFF: note_event_ready <= 1'b1;
      endcase
    end
    c_state <= n_state;

endmodule: decoder
