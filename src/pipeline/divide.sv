`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Divide
(
    input  logic          [CONFIG::PERIOD_WIDTH-1:0] dividend,
    input  logic          [CONFIG::PERIOD_WIDTH-1:0] divisor,
    output long_percent_t                    quotient
);

  import CONFIG::LONG_PERCENT_WIDTH;
  import CONFIG::long_percent_t;
  import CONFIG::PERIOD_WIDTH;

  logic [PERIOD_WIDTH-1:0] division_table[(1<<PERIOD_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/division_table.vm", division_table);
`else
    $readmemb("lut/division_table.vm", division_table);
`endif
  end

  logic [PERIOD_WIDTH+PERIOD_WIDTH-1:0] high_percision;
  assign high_percision = dividend * division_table[divisor];
  assign quotient       = high_percision[PERIOD_WIDTH-1-:LONG_PERCENT_WIDTH];

endmodule : Divide
