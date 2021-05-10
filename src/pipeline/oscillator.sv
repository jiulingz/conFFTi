`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"
`include "../includes/parameter.vh"

module Oscillator
  import CONFIG::*;
(
    input  logic                                               clock_50_000_000,
    input  logic                                               reset_l,
    input  logic                                               clear,
    input  logic     [  PERIOD_WIDTH-1:0]                      period,
    input  percent_t                                           duty_cycle,
    output logic     [NUM_WAVETABLES-1:0][AUDIO_BIT_WIDTH-1:0] waves
);

  import OSCILLATOR::*;
  import PARAMETER::*;

  oscillator_state_t state;
  long_percent_t     phase;

`ifdef SIMULATION
  localparam GENERATION_TICKS = 1;
`else
  localparam GENERATION_TICKS = SYSTEM_CLOCK / AUDIO_GENERATION_FREQUENCY;
`endif
  logic [  $clog2(GENERATION_TICKS)-1:0] generation_count;

  logic [PERIOD_WIDTH-1:0] count;
  logic [PERIOD_WIDTH-1:0] duty_ticks;
  logic [PERIOD_WIDTH-1:0] target[state.num()-1:0];
  assign target[OSCILLATOR::FRONT] = duty_ticks;
  assign target[OSCILLATOR::BACK]  = period - duty_ticks;

  logic [PERIOD_WIDTH+PERCENT_WIDTH-1:0] high_precision;
  assign high_precision = period * duty_cycle;
  assign duty_ticks     = high_precision[PERIOD_WIDTH+PERCENT_WIDTH-1-:PERIOD_WIDTH];

  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      state            <= OSCILLATOR::FRONT;
      count            <= '0;
      generation_count <= '0;
    end else if (clear) begin
      state            <= OSCILLATOR::FRONT;
      count            <= '0;
      generation_count <= '0;
    end else if (target[state] == 0 || count >= target[state] - 1) begin
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

  Sine s (
      .clock(clock_50_000_000),
      .state,
      .phase,
      .sine(waves[SINE])
  );
  Pulse p (
      .clock(clock_50_000_000),
      .state,
      .phase,
      .pulse(waves[PULSE])
  );
  Triangle t (
      .clock(clock_50_000_000),
      .state,
      .phase,
      .triangle(waves[TRIANGLE])
  );
  Cello c (
      .clock(clock_50_000_000),
      .state,
      .phase,
      .cello(waves[CELLO])
  );
  FrenchHorn f (
      .clock(clock_50_000_000),
      .state,
      .phase,
      .french_horn(waves[FRENCH_HORN])
  );
  Trumpet tp (
      .clock(clock_50_000_000),
      .state,
      .phase,
      .trumpet(waves[TRUMPET])
  );
  Viola va (
      .clock(clock_50_000_000),
      .state,
      .phase,
      .viola(waves[VIOLA])
  );
  Violin vn (
      .clock(clock_50_000_000),
      .state,
      .phase,
      .violin(waves[VIOLIN])
  );

endmodule : Oscillator
