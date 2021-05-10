`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Sine (
    input                                                               clock,
    input  OSCILLATOR::oscillator_state_t                               state,
    input  CONFIG::long_percent_t                                       phase,
    output logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] sine
);

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] sine_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/sine_table.vm", sine_table);
`else
    $readmemb("lut/sine_table.vm", sine_table);
`endif
  end

  always_ff @(posedge clock) begin
    unique case (state)
      OSCILLATOR::FRONT: sine <= sine_table[phase];
      OSCILLATOR::BACK:  sine <= sine_table[~phase];
    endcase
  end

endmodule : Sine
