`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Trumpet (
    input                                                               clock,
    input  OSCILLATOR::oscillator_state_t                               state,
    input  CONFIG::long_percent_t                                       phase,
    output logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] trumpet
);

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] trumpet_front_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/trumpet_front_table.vm", trumpet_front_table);
`else
    $readmemb("lut/trumpet_front_table.vm", trumpet_front_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] trumpet_back_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/trumpet_back_table.vm", trumpet_back_table);
`else
    $readmemb("lut/trumpet_back_table.vm", trumpet_back_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] front;
  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] back;
  always_ff @(posedge clock) front <= trumpet_front_table[phase];
  always_ff @(posedge clock) back <= trumpet_back_table[phase];
  always_comb
    unique case (state)
      OSCILLATOR::FRONT: trumpet <= front;
      OSCILLATOR::BACK:  trumpet <= back;
    endcase

endmodule : Trumpet
