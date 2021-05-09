`default_nettype none

`include "../../../includes/config.vh"

module DivideTest ();

 import CONFIG::*;

  logic [PERIOD_WIDTH-1:0] dividend;
  logic [PERIOD_WIDTH-1:0] divisor;
  logic [LONG_PERCENT_WIDTH-1:0] quotient;
  logic [LONG_PERCENT_WIDTH-1:0] desired;

  Divide dut (
    .dividend,
    .divisor,
    .quotient
  );

  initial begin
    {dividend, divisor, desired} = {16'd1, 16'd10, 8'd25};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd2, 16'd10, 8'd51};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd3, 16'd10, 8'd76};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd4, 16'd10, 8'd102};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd5, 16'd10, 8'd127};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd6, 16'd10, 8'd153};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd7, 16'd10, 8'd179};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd8, 16'd10, 8'd204};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd9, 16'd10, 8'd230};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {16'd10, 16'd10, 8'd255};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    $finish;
  end

endmodule : DivideTest
