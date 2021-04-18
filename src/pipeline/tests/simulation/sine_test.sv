`default_nettype none

`include "../../../includes/config.vh"
`include "../../../includes/oscillator.vh"

module SineTest ();

  OSCILLATOR::oscillator_state_t                               state;
  CONFIG::long_percent_t                                       phase;
  logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] sine;

  Sine dut (
      .state,
      .phase,
      .sine
  );

  initial begin
    $monitor("\t%b", sine);
    $display("FRONT");
    state = OSCILLATOR::FRONT;
    for (int i = 0; i < 10; i++) begin
      phase = i;
      #1;
    end
    $display("BACK");
    state = OSCILLATOR::BACK;
    for (int i = 0; i < 10; i++) begin
      phase = '1 - i;
      #1;
    end
    $finish;
  end

endmodule : SineTest
