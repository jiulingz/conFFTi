`default_nettype none

`include "../includes/config.vh"
`include "../includes/midi.vh"

module MIDIDecoder
  import MIDI::*;
(
    input  logic                              clock_50_000_000,
    input  logic                              reset_l,
    input  logic     [CONFIG::BYTE_WIDTH-1:0] data_in,
    input  logic                              data_in_ready,
    output message_t                          message,
    output logic                              message_ready
);

  byte_type_t                     byte_type;
  message_type_t                  message_type;
  logic          [DATA_WIDTH-1:0] data_byte;
  assign byte_type    = byte_type_t'(data_in[7]);
  assign message_type = message_type_t'(data_in[7:4]);
  assign data_byte    = data_in[6:0];

  typedef enum logic [2:0] {
    STATUS_BYTE,
    DATA_BYTE_1,
    DATA_BYTE_2,
    FINISH
  } state_t;
  state_t   state;
  message_t buffer;

  always_ff @(posedge clock_50_000_000, negedge reset_l)
    if (!reset_l) begin
      state         <= STATUS_BYTE;
      buffer        <= '0;
      message       <= '0;
      message_ready <= '0;
    end else
      unique case (state)
        STATUS_BYTE: begin
          message_ready <= '0;
          if (data_in_ready)
            unique case (byte_type)
              MIDI::STATUS: begin
                unique case (message_type)
                  NOTE_ON, NOTE_OFF, CONTROL_CHANGE: begin
                    state               <= DATA_BYTE_1;
                    buffer.message_type <= message_type;
                  end
                  default: begin  // invalid byte
                    state  <= STATUS_BYTE;
                    buffer <= '0;
                  end
                endcase
              end
              default: begin  // invalid byte
                state  <= STATUS_BYTE;
                buffer <= '0;
              end
            endcase
          else state <= state;
        end
        DATA_BYTE_1: begin
          if (data_in_ready)
            unique case (byte_type)
              MIDI::DATA: begin
                unique case (buffer.message_type)
                  NOTE_ON, NOTE_OFF, CONTROL_CHANGE: begin
                    state             <= DATA_BYTE_2;
                    buffer.data_byte1 <= data_byte;
                  end
                  default: begin  // invalid byte
                    state  <= STATUS_BYTE;
                    buffer <= '0;
                  end
                endcase
              end
              default: begin  // invalid byte
                state  <= STATUS_BYTE;
                buffer <= '0;
              end
            endcase
          else state <= state;
        end
        DATA_BYTE_2: begin
          if (data_in_ready)
            unique case (byte_type)
              MIDI::DATA: begin
                unique case (buffer.message_type)
                  NOTE_ON: begin
                    state             <= FINISH;
                    buffer.data_byte2 <= data_byte;
                    if (data_byte == 'b0) begin
                      // NOTE_ON with 0 velocity is equivalent to NOTE_OFF
                      buffer.message_type <= NOTE_OFF;
                    end
                  end
                  NOTE_OFF: begin
                    state             <= FINISH;
                    buffer.data_byte2 <= '0;
                  end
                  CONTROL_CHANGE: begin
                    state             <= FINISH;
                    buffer.data_byte2 <= data_byte;
                  end
                  default: begin  // invalid byte
                    state  <= STATUS_BYTE;
                    buffer <= '0;
                  end
                endcase
              end
              default: begin  // invalid byte
                state  <= STATUS_BYTE;
                buffer <= '0;
              end
            endcase
          else state <= state;
        end
        FINISH: begin
          state         <= STATUS_BYTE;
          message       <= buffer;
          message_ready <= '1;
        end
      endcase

endmodule : MIDIDecoder
