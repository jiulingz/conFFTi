`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Envelope (
    input  logic                  clock_50_000_000,
    input  logic                  reset_l,
    input  PARAMETER::parameter_t parameters,
    input  logic                  note_on,
    input  logic                  note_off,
    output CONFIG::long_percent_t envelope
);

  import PARAMETER::*;
  import CONFIG::*;

  typedef enum logic [2:0] {
    IDLE,
    ATTACK,
    DECAY,
    SUSTAIN,
    RELEASE
  } state_t;
  state_t state;

`ifdef SIMULATION
  localparam GENERATION_TICKS = 1;
`else
  localparam GENERATION_TICKS = ENVELOPE_MAX_TICKS >> DIVISION_WIDTH;
`endif
  logic [$clog2(GENERATION_TICKS)-1:0] generation_count;

  long_percent_t phase;
  logic [DIVISION_WIDTH-1:0] count;
  logic [DIVISION_WIDTH-1:0] target[state.num()-1:0];
`ifdef SIMULATION
  assign target[IDLE]    = '1;
  assign target[ATTACK]  = parameters.attack_time;
  assign target[DECAY]   = parameters.decay_time;
  assign target[SUSTAIN] = '1;
  assign target[RELEASE] = parameters.release_time;
`else
  assign target[IDLE]    = '1;
  assign target[ATTACK]  = parameters.attack_time << (DIVISION_WIDTH - PERCENT_WIDTH);
  assign target[DECAY]   = parameters.decay_time << (DIVISION_WIDTH - PERCENT_WIDTH);
  assign target[SUSTAIN] = '1;
  assign target[RELEASE] = parameters.release_time << (DIVISION_WIDTH - PERCENT_WIDTH);
`endif

  long_percent_t sustain_height;
  assign sustain_height = parameters.sustain_level << (LONG_PERCENT_WIDTH - PERCENT_WIDTH);
  long_percent_t release_height;

  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      state            <= IDLE;
      count            <= '0;
      generation_count <= '0;
    end else if (note_on) begin
      state            <= ATTACK;
      count            <= '0;
      generation_count <= '0;
    end else if (note_off) begin
      state            <= RELEASE;
      count            <= '0;
      generation_count <= '0;
      release_height   <= envelope;
    end else if (target[state] != '1 && (target[state] == 0 || count >= target[state] - 1)) begin
      state            <= state.next();
      count            <= '0;
      generation_count <= '0;
    end else begin
      if (generation_count >= GENERATION_TICKS - 1) begin
        generation_count <= '0;
        count            <= count + 1'b1;
      end else begin
        generation_count <= generation_count + 1'b1;
      end
    end
  end

  Divide divide (
      .dividend(count),
      .divisor (target[state]),
      .quotient(phase)
  );

  logic [LONG_PERCENT_WIDTH+LONG_PERCENT_WIDTH-1:0] high_precision_decay;
  logic [LONG_PERCENT_WIDTH+LONG_PERCENT_WIDTH-1:0] high_precision_release;
  assign high_precision_decay = (LONG_PERCENT_MAX - sustain_height) * phase;
  assign high_precision_release = release_height * phase;
  always_comb begin
    unique case (state)
      IDLE: begin
        envelope = 0;
      end
      ATTACK: begin
        envelope = phase;
      end
      DECAY: begin
        envelope = LONG_PERCENT_MAX - high_precision_decay[LONG_PERCENT_WIDTH+LONG_PERCENT_WIDTH-1-:LONG_PERCENT_WIDTH];
      end
      SUSTAIN: begin
        envelope = sustain_height;
      end
      RELEASE: begin
        envelope = release_height - high_precision_release[LONG_PERCENT_WIDTH+LONG_PERCENT_WIDTH-1-:LONG_PERCENT_WIDTH];
      end
    endcase
  end

endmodule : Envelope
