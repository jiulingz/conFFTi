`default_nettype none

`include "../../../includes/config.vh"
`include "../../../includes/oscillator.vh"

module OscillatorTest ();

  logic                                           clock;
  logic                                           reset_l;
  logic                                           clear;
  logic             [   CONFIG::PERIOD_WIDTH-1:0] period;
  CONFIG::percent_t                               duty_cycle;
  logic             [CONFIG::AUDIO_BIT_WIDTH-1:0] sine;
  logic             [CONFIG::AUDIO_BIT_WIDTH-1:0] pulse;
  logic             [CONFIG::AUDIO_BIT_WIDTH-1:0] triangle;

  Oscillator dut (
      .clock_50_000_000(clock),
      .reset_l,
      .clear,
      .period,
      .duty_cycle,
      .waves           ({triangle, pulse, sine})
  );

  // clock
  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  // display
  initial begin
    @(posedge clock);
    forever begin
      @(posedge clock);
      $display("\t%p %10p %10p %10p", dut.generation_count, sine, pulse, triangle);
    end
  end

  // initialization
  initial begin
    clear      <= 1'b0;
    reset_l    <= 1'b0;
    period     <= 10;
    duty_cycle <= 64;
    @(posedge clock);
    reset_l <= 1'b1;
    clear   <= 1'b1;
    @(posedge clock);
    clear <= 1'b0;
  end

  // trace
  initial begin
    repeat (20) @(posedge clock);
    $finish;
  end

endmodule : OscillatorTest
