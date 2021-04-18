`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Envelope (
    input  logic                                                   clock_50_000_000,
    input  logic                                                   reset_l,
    input  PARAMETER::parameter_t                                  parameters,
    input  logic                                                   note_on,
    input  logic                                                   note_off,
    output logic                  [CONFIG::AUDIO_BIT_WIDTH-1:0]    envelope,
    output logic                                                   envelope_end
);

  import ENVELOPE::envelope_state_t;
  import CONFIG::ENVELOPE_COUNTER_WIDTH;
  import CONFIG::SYSTEM_CLOCK;

  logic [ENVELOPE_COUNTER_WIDTH-1:0] count;
  logic [ENVELOPE_COUNTER_WIDTH-1:0] target;

  // logic [] attack_width;
  // logic [] delay_width;
  // logic [] release_width;

  assign target = SYSTEM_CLOCK / 2;
  // assign attack_width = ;
  // assign delay_width = ;
  // assign release_width = ;

  envelope_state_t state;

  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      state <= ENVELOPE::IDLE;
      count <= '0;
    end else if (note_on) begin
      state <= ENVELOPE::ATTACK;
      count <= '0;
    end else if (note_off) begin
      state <= ENVELOPE::RELEASE;
      count <= '0;
    end else
      unique case (state)
        ENVELOPE::ATTACK: begin
          count <= count + 1;
          if (count == attack_width) begin
            count <= '0;
            state <= ENVELOP::DELAY;
          end
        end
        ENVELOPE::DELAY: begin
          count <= count + 1;
          if (count == delay_width) begin
            count <= '0;
            state <= ENVELOP::SUSTAIN;
          end
        end
        ENVELOPE::RELEASE: begin
          count <= count + 1;
          if (count == release_width) begin
            count <= '0;
            envelope_end <= '1;
            state <= ENVELOP::IDLE;
          end
        end
      endcase
  end

endmodule : Envelope