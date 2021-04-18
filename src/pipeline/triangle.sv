`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"


module Triangle (
    input  OSCILLATOR::oscillator_state_t                               state,
    input  CONFIG::long_percent_t                                       phase,
    output logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] triangle
);

  import CONFIG::LONG_PERCENT_WIDTH;
  import CONFIG::AUDIO_BIT_WIDTH;

  always_comb begin
    unique case (state)
      OSCILLATOR::FRONT: triangle = phase << (AUDIO_BIT_WIDTH - LONG_PERCENT_WIDTH);
      OSCILLATOR::BACK:  triangle = ~phase << (AUDIO_BIT_WIDTH - LONG_PERCENT_WIDTH);
    endcase
  end

endmodule : Triangle
