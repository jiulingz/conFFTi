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
    output logic                                                   envelope_end,
    output ENVELOPE::envelope_state_t                              state, // debug
    output logic                  [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0]     count,
    output logic                  [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0]     attack_target,
    output logic                  [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0]     decay_target,
    output logic                  [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0]     release_target,
    output logic                  [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0]     quotient
);

  import PARAMETER::*;
  import ENVELOPE::envelope_state_t;
  import CONFIG::*;

  // logic [ENVELOPE_COUNTER_WIDTH-1:0] count;
  logic [ENVELOPE_COUNTER_WIDTH-1:0] target;
  logic [ENVELOPE_COUNTER_WIDTH-1:0] divisor;
  // logic [ENVELOPE_COUNTER_WIDTH-1:0] quotient;

// `ifdef SIMULATION
  // localparam GENERATION_TICKS = 1;
// `else
  localparam GENERATION_TICKS = SYSTEM_CLOCK / AUDIO_GENERATION_FREQUENCY;
// `endif
  logic [      $clog2(GENERATION_TICKS)-1:0] generation_count;

  // logic [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0] attack_target;
  // logic [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0] decay_target;
  // logic [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0] release_target;
  // envelope_state_t state;

  assign attack_target = (CONFIG::MAX_TARGET_TICKS * parameters.attack_time) >> PERCENT_WIDTH;
  assign decay_target = (CONFIG::MAX_TARGET_TICKS * parameters.decay_time) >> PERCENT_WIDTH;
  assign release_target = (CONFIG::MAX_TARGET_TICKS * parameters.release_time) >> PERCENT_WIDTH;

  logic [       CONFIG::AUDIO_BIT_WIDTH-1:0] sustain_height;
  logic [       CONFIG::AUDIO_BIT_WIDTH-1:0] release_height;
 
  logic [ENVELOPE_COUNTER_WIDTH-1:0] division_table[(1<<ENVELOPE_COUNTER_WIDTH)-1:0];
  initial begin
// `ifdef SIMULATION
    $readmemb("../../lut/adsr_division_table.vm", division_table);
// `else
//     $readmemb("lut/adsr_division_table.vm", division_table);
// `endif
  end

  // assign quotient = count * division_table[divisor] >> ENVELOPE_COUNTER_WIDTH;
  assign quotient = division_table[divisor];
  
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
      count <= '0;
      generation_count <= '0;
    end else if (note_off) begin
      state <= ENVELOPE::RELEASE;
      count <= '0;
      generation_count <= '0;
    end else if (generation_count >= GENERATION_TICKS - 1) begin
      generation_count <= '0;
      count <= count + 1;
      unique case (state)
        ENVELOPE::ATTACK: begin
          divisor <= attack_target;
          if (count >= attack_target) begin
            count <= '0;
            state <= ENVELOPE::DELAY;
            envelope <= quotient;
            release_height <= envelope;
          end
        end
        ENVELOPE::DELAY: begin
          divisor <= decay_target;
          if (count >= decay_target) begin
            count <= '0;
            state <= ENVELOPE::SUSTAIN;
            envelope <= ~quotient * (ENVELOPE_CEILING - sustain_height) << (AUDIO_BIT_WIDTH - ENVELOPE_COUNTER_WIDTH) + sustain_height;
            release_height <= envelope;
          end
        end
        ENVELOPE::SUSTAIN: begin
          envelope <= sustain_height;
          release_height <= envelope;
        end
        ENVELOPE::RELEASE: begin
          divisor <= release_target;
          if (count >= release_target) begin
            count <= '0;
            envelope_end <= '1;
            state <= ENVELOPE::IDLE;
            envelope <= ~quotient * release_height << (AUDIO_BIT_WIDTH - ENVELOPE_COUNTER_WIDTH);
          end
        end
        default: begin
        end
      endcase
    end else begin
      generation_count <=  generation_count + 1'b1;
    end
  end

endmodule : Envelope