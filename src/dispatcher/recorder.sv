`default_nettype none

`include "../includes/midi.vh"

module Recorder
  import MIDI::*;
(
    input  logic         clock_50_000_000,
    input  logic         reset_l,
    input  message_t     message,
    input  logic         message_ready,
    output note_change_t replay,
    output logic         replay_ready
);

  import CONFIG::*;

  localparam message_t RECORD_START = '{
      message_type: CONTROL_CHANGE,
      data_byte1: RECORD,
      data_byte2: 'h7f
  };
  localparam message_t RECORD_STOP = '{
      message_type: CONTROL_CHANGE,
      data_byte1: RECORD,
      data_byte2: 'h0
  };
  localparam message_t REPLAY_TOGGLE = '{
      message_type: CONTROL_CHANGE,
      data_byte1: PLAY,
      data_byte2: 'h7f
  };

  typedef enum logic [1:0] {
    IDLE,
    RECORDING,
    REPLAYING
  } state_t;
  state_t state;

  localparam COUNTER_WIDTH = 32;
  typedef logic [COUNTER_WIDTH-1:0] counter_t;

  note_change_t [RECORD_LENGTH-1:0] notes;
  counter_t     [RECORD_LENGTH:0] timestampes;

  counter_t counter;
  logic [$clog2(RECORD_LENGTH)-1:0] l;
  logic [$clog2(RECORD_LENGTH)-1:0] i;
  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      state        <= IDLE;
      counter      <= '0;
      l            <= '0;
      i            <= '0;
      replay_ready <= '0;
    end else begin
      replay_ready <= '0;
      unique case (state)
        IDLE: begin
          if (message_ready) begin
            if (message == RECORD_START) begin
              l       <= 0;
              counter <= 0;
              state   <= RECORDING;
            end else if (message == REPLAY_TOGGLE) begin
              i       <= 0;
              counter <= 0;
              state   <= REPLAYING;
            end
          end
        end
        RECORDING: begin
          if (message_ready) begin
            unique case (message.message_type)
              NOTE_ON: begin
                notes[l] <= '{status: ON, note_number: message.data_byte1, velocity: message.data_byte2};
                timestampes[l] <= counter;
                l <= l + 1;
              end
              NOTE_OFF: begin
                notes[l] <= '{status: OFF, note_number: message.data_byte1, velocity: message.data_byte2};
                timestampes[l] <= counter;
                l <= l + 1;
              end
              CONTROL_CHANGE: begin
                if (message == RECORD_STOP) begin
                  state          <= IDLE;
                  timestampes[l] <= counter;
                end
              end
              default: begin
              end
            endcase
          end
          counter <= counter + 1;
        end
        REPLAYING: begin
          if (counter == timestampes[i]) begin
            replay       <= notes[i];
            replay_ready <= 1'b1;
            i            <= i + 1 >= l ? 0 : i + 1;
          end
          if (message_ready && message == REPLAY_TOGGLE) begin
            state <= IDLE;
          end
          counter <= counter + 1;
          if (counter >= timestampes[l]) counter <= 0;
        end
      endcase
    end
  end
endmodule : Recorder
