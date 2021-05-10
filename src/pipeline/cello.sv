`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Cello (
    input                                                               clock,
    input  OSCILLATOR::oscillator_state_t                               state,
    input  CONFIG::long_percent_t                                       phase,
    output logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] cello
);

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] cello_front_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/cello_front_table.vm", cello_front_table);
`else
    $readmemb("lut/cello_front_table.vm", cello_front_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] cello_back_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/cello_back_table.vm", cello_back_table);
`else
    $readmemb("lut/cello_back_table.vm", cello_back_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] front;
  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] back;
  always_ff @(posedge clock) front <= cello_front_table[phase];
  always_ff @(posedge clock) back <= cello_back_table[phase];
  always_comb
    unique case (state)
      OSCILLATOR::FRONT: cello <= front;
      OSCILLATOR::BACK:  cello <= back;
    endcase

endmodule : Cello
