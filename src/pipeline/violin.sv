`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Violin (
    input                                                               clock,
    input  OSCILLATOR::oscillator_state_t                               state,
    input  CONFIG::long_percent_t                                       phase,
    output logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] violin
);

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] violin_front_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/violin_front_table.vm", violin_front_table);
`else
    $readmemb("lut/violin_front_table.vm", violin_front_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] violin_back_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/violin_back_table.vm", violin_back_table);
`else
    $readmemb("lut/violin_back_table.vm", violin_back_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] front;
  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] back;
  always_ff @(posedge clock) front <= violin_front_table[phase];
  always_ff @(posedge clock) back <= violin_back_table[phase];
  always_comb
    unique case (state)
      OSCILLATOR::FRONT: violin <= front;
      OSCILLATOR::BACK:  violin <= back;
    endcase

endmodule : Violin
