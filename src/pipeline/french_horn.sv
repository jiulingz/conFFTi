`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module FrenchHorn (
    input                                                               clock,
    input  OSCILLATOR::oscillator_state_t                               state,
    input  CONFIG::long_percent_t                                       phase,
    output logic                          [CONFIG::AUDIO_BIT_WIDTH-1:0] french_horn
);

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] french_horn_front_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/french_horn_front_table.vm", french_horn_front_table);
`else
    $readmemb("lut/french_horn_front_table.vm", french_horn_front_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] french_horn_back_table[(1<<CONFIG::LONG_PERCENT_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/french_horn_back_table.vm", french_horn_back_table);
`else
    $readmemb("lut/french_horn_back_table.vm", french_horn_back_table);
`endif
  end

  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] front;
  logic [CONFIG::AUDIO_BIT_WIDTH-1:0] back;
  always_ff @(posedge clock) front <= french_horn_front_table[phase];
  always_ff @(posedge clock) back <= french_horn_back_table[phase];
  always_comb
    unique case (state)
      OSCILLATOR::FRONT: french_horn <= front;
      OSCILLATOR::BACK:  french_horn <= back;
    endcase

endmodule : FrenchHorn
