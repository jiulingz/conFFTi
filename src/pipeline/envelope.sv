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

  import PARAMETER::*;
  import ENVELOPE::envelope_state_t;
  import CONFIG::*;

  logic [ENVELOPE_COUNTER_WIDTH-1:0] count;
  logic [ENVELOPE_COUNTER_WIDTH-1:0] target;
  logic [ENVELOPE_COUNTER_WIDTH-1:0] divisor;
  logic [ENVELOPE_COUNTER_WIDTH+ENVELOPE_COUNTER_WIDTH-1:0] step;
  logic [ENVELOPE_COUNTER_WIDTH-1:0] top;
  logic [ENVELOPE_COUNTER_WIDTH+ENVELOPE_COUNTER_WIDTH-1:0] quotient;

  localparam GENERATION_TICKS = SYSTEM_CLOCK / AUDIO_GENERATION_FREQUENCY;
  
  logic [$clog2(GENERATION_TICKS)-1:0] generation_count;

  logic [ENVELOPE_COUNTER_WIDTH-1:0] attack_target;
  logic [ENVELOPE_COUNTER_WIDTH-1:0] decay_target;
  logic [ENVELOPE_COUNTER_WIDTH-1:0] release_target;
  envelope_state_t state;

  assign attack_target = (MAX_TARGET_TICKS * parameters.attack_time) >> PERCENT_WIDTH;
  assign decay_target = (MAX_TARGET_TICKS * parameters.decay_time) >> PERCENT_WIDTH;
  assign release_target = (MAX_TARGET_TICKS * parameters.release_time) >> PERCENT_WIDTH;

  logic [AUDIO_BIT_WIDTH-1:0] sustain_height;
  logic [AUDIO_BIT_WIDTH-1:0] release_height;
 
  logic [ENVELOPE_COUNTER_WIDTH-1:0] division_table[(1<<ENVELOPE_COUNTER_WIDTH)-1:0];

  initial begin
    $readmemb("../../lut/adsr_division_table.vm", division_table);
  end

  assign sustain_height = parameters.sustain_level << (AUDIO_BIT_WIDTH - PERCENT_WIDTH);

  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    envelope_end <= '0;
    if (!reset_l) begin
      state <= ENVELOPE::IDLE;
      count <= '0;
      divisor <= '0;
      envelope <= '0;
      generation_count <= '0;
    end else if (note_on) begin
      state <= ENVELOPE::ATTACK;
      envelope <= '0;
      count <= '0;
      generation_count <= '0;
    end else if (note_off) begin
      state <= ENVELOPE::RELEASE;
      count <= '0;
      envelope <= release_height;
      generation_count <= '0;
    end else if (generation_count >= GENERATION_TICKS - 1) begin
      generation_count <= '0;
      count <= count + 1;
      unique case (state)
        ENVELOPE::ATTACK: begin
          divisor <= attack_target;
          quotient <= count * division_table[divisor];
          envelope <= quotient << ENVELOPE_PUSH_BITS;
          release_height <= envelope;
          top <= release_height;
          if (count >= attack_target) begin
            count <= '0;
            state <= ENVELOPE::DECAY;
          end
        end
        ENVELOPE::DECAY: begin
          divisor <= decay_target;
          step <= ((PARAM_CEILING - parameters.sustain_level) * division_table[divisor]);
          quotient <= (decay_target - count) * step;
          envelope <= sustain_height + (quotient << (ENVELOPE_PUSH_BITS-PERCENT_WIDTH));
          release_height <= envelope;
          if (count >= decay_target) begin
            count <= '0;
            state <= ENVELOPE::SUSTAIN;
          end
        end
        ENVELOPE::SUSTAIN: begin
          envelope <= sustain_height;
          release_height <= envelope;
        end
        ENVELOPE::RELEASE: begin
          divisor <= release_target;
          step <= division_table[divisor];
          quotient <= (step * release_height) >> ENVELOPE_COUNTER_WIDTH;
          envelope <= (release_target - count) * quotient;
          if (count >= release_target) begin
            count <= '0;
            envelope_end <= '1;
            state <= ENVELOPE::IDLE;
          end
        end
        default: begin
          envelope <= '0;
        end
      endcase
    end else begin
      generation_count <=  generation_count + 1'b1;
    end
  end

endmodule : Envelope