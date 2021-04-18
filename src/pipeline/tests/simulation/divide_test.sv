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
    {dividend, divisor, desired} = {11'd1, 11'd10, 8'd25};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd2, 11'd10, 8'd51};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd3, 11'd10, 8'd76};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd4, 11'd10, 8'd102};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd5, 11'd10, 8'd127};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd6, 11'd10, 8'd153};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd7, 11'd10, 8'd178};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd8, 11'd10, 8'd204};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd9, 11'd10, 8'd229};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    {dividend, divisor, desired} = {11'd10, 11'd10, 8'd255};
    #1;
    if (quotient != desired) $display("\t%p / %p = %p != %p", dividend, divisor, desired, quotient);
    #1

    $finish;
  end

endmodule : DivideTest
