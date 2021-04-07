`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Oscillator (
    input  logic                                           clock_50_000_000,
    input  logic                                           reset_l,
    input  logic                                           clear,
    input  logic             [   CONFIG::PERIOD_WIDTH-1:0] period,
    input  CONFIG::percent_t                               duty_cycle,
    output logic             [CONFIG::AUDIO_BIT_WIDTH-1:0] sine,
    output logic             [CONFIG::AUDIO_BIT_WIDTH-1:0] pulse,
    output logic             [CONFIG::AUDIO_BIT_WIDTH-1:0] triangle
);

  import OSCILLATOR::oscillator_state_t;
  import CONFIG::long_percent_t;
  import CONFIG::AUDIO_BIT_WIDTH;
  import CONFIG::PERIOD_WIDTH;
  import CONFIG::SYSTEM_CLOCK;
  import CONFIG::AUDIO_GENERATION_FREQUENCY;

  oscillator_state_t state;
  long_percent_t     phase;

`ifdef SIMULATION
  localparam GENERATION_TICKS = 1;
`else
  localparam GENERATION_TICKS = SYSTEM_CLOCK / AUDIO_GENERATION_FREQUENCY;
`endif
  logic [$clog2(GENERATION_TICKS)-1:0] generation_count;

  logic [           PERIOD_WIDTH-1:0] count;
  logic [           PERIOD_WIDTH-1:0] duty_ticks;
  logic [           PERIOD_WIDTH-1:0] target           [$bits(state):0];

  assign duty_ticks = period * duty_cycle >> CONFIG::PERCENT_WIDTH;

  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      state                     <= OSCILLATOR::FRONT;
      count                     <= '0;
      generation_count          <= '0;
      target[OSCILLATOR::FRONT] <= duty_ticks;
      target[OSCILLATOR::BACK]  <= period - duty_ticks;
    end else if (clear) begin
      state                     <= OSCILLATOR::FRONT;
      count                     <= '0;
      generation_count          <= '0;
      target[OSCILLATOR::FRONT] <= duty_ticks;
      target[OSCILLATOR::BACK]  <= period - duty_ticks;
    end else if (count >= target[state] - 1) begin
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
      .state,
      .phase,
      .sine
  );
  Pulse p (
      .state,
      .phase,
      .pulse
  );
  Triangle t (
      .state,
      .phase,
      .triangle
  );

endmodule : Oscillator
