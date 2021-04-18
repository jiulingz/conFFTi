`default_nettype none

`include "../../../includes/config.vh"
`include "../../../includes/oscillator.vh"

module TriangleTest ();

  OSCILLATOR::oscillator_state_t                               state;
  CONFIG::long_percent_t                                       phase;
  logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] triangle;

  Triangle dut (
      .state,
      .phase,
      .triangle
  );

  initial begin
    $monitor("\t%b", triangle);
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

endmodule : TriangleTest
