`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Pulse (
    input                                                               clock,
    input  OSCILLATOR::oscillator_state_t                               state,
    input  CONFIG::long_percent_t                                       phase,
    output logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] pulse
);

  always_ff @(posedge clock) begin
    unique case (state)
      OSCILLATOR::FRONT: pulse <= '0;
      OSCILLATOR::BACK:  pulse <= '1;
    endcase
  end

endmodule : Pulse
