`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Viola (
    input                                                               clock,
    input  OSCILLATOR::oscillator_state_t                               state,
    input  CONFIG::long_percent_t                                       phase,
    output logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] viola
);

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] viola_front_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/viola_front_table.vm", viola_front_table);
`else
    $readmemb("lut/viola_front_table.vm", viola_front_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] viola_back_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/viola_back_table.vm", viola_back_table);
`else
    $readmemb("lut/viola_back_table.vm", viola_back_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] front;
  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] back;
  always_ff @(posedge clock) front <= viola_front_table[phase];
  always_ff @(posedge clock) back <= viola_back_table[phase];
  always_comb
    unique case (state)
      OSCILLATOR::FRONT: viola <= front;
      OSCILLATOR::BACK:  viola <= back;
    endcase

endmodule : Viola
