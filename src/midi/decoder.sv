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

  enum logic [2:0] {
    IDLE          = 3'b000,
    GOT_STATUS    = 3'b001,
    DATA_MSG_I    = 3'b010,
    NOTE_ON       = 3'b011,
    NOTE_OFF      = 3'b100,
    PARAM_CHANGE  = 3'b101
  } c_state, n_state;

  logic isStatus, isDataMsg, isParamChange, isNoteOn, isNoteOff;

  assign isStatus = ready && (MIDIbyte[7] == 1'b1);
  assign isDataMsg = ready && ~isStatus;

  always_ff @(posedge clk, posedge reset)
    if (reset) begin
      c_state <= IDLE;
      n_state <= IDLE;
    end
    else if (ready) begin
      case (c_state)
        IDLE: begin
          n_state <= isStatus ? GOT_STATUS : IDLE;
          isParamChange <= (MIDIbyte[7:4] == 4'hb);
          isNoteOn <= (MIDIbyte[7:4] == 4'h9);
          isNoteOff <= (MIDIbyte[7:4] == 4'h8);
        end
        GOT_STATUS: begin
          note <= MIDIbyte[6:0];
          n_state <= isDataMsg ? DATA_MSG_I : IDLE;
        end
        DATA_MSG_I: begin
          velocity <= MIDIbyte[6:0];
          if (isParamChange) n_state <= PARAM_CHANGE;
          else if (isNoteOn) n_state <= NOTE_ON;
          else if (isNoteOff) n_state <= NOTE_OFF;
          else n_state <= IDLE;
        end
      endcase
    end
    else begin
      case (c_state)
        PARAM_CHANGE: begin
          n_state <= IDLE;
          param_change_ready <= 1;
        end
        NOTE_ON: begin
          n_state <= IDLE;
          note_event <= ON;
          note_event_ready <= 1;
        end
        NOTE_OFF: begin
          n_state <= IDLE;
          note_event <= OFF;
          note_event_ready <= 1;
        end
        default: begin
          note_event_ready <= 0;
          param_change_ready <= 0;
        end
      endcase
      if (c_state != n_state) c_state <= n_state;
    end

endmodule: decoder
