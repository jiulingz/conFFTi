`default_nettype none

`include "../includes/config.vh"
`include "../includes/oscillator.vh"

module Divide (
    input  logic                  [CONFIG::DIVISION_WIDTH-1:0] dividend,
    input  logic                  [CONFIG::DIVISION_WIDTH-1:0] divisor,
    output CONFIG::long_percent_t                              quotient
);

  import CONFIG::LONG_PERCENT_WIDTH;
  import CONFIG::long_percent_t;
  import CONFIG::DIVISION_WIDTH;

  logic [DIVISION_WIDTH-1:0] division_table[(1<<DIVISION_WIDTH)-1:0];
  initial begin
`ifdef SIMULATION
    $readmemb("../../lut/division_table.vm", division_table);
`else
    $readmemb("lut/division_table.vm", division_table);
`endif
  end

  logic [DIVISION_WIDTH+DIVISION_WIDTH-1:0] high_precision;
  assign high_precision = dividend * division_table[divisor];
  assign quotient       = high_precision[DIVISION_WIDTH-1-:LONG_PERCENT_WIDTH];

endmodule : Divide
