// tap reference: https://www.xilinx.com/support/documentation/application_notes/xapp052.pdf, Table 3
`default_nettype none

module lfsr #(
    RESET_VAL = 16'b0
) (
    input wire logic clk,
    input wire logic reset,
    input wire logic en,
    output logic q
);
  logic [16:1] s;

  assign q = ~^{s[16], s[15], s[13], s[4]};
  always_ff @(posedge clk, posedge reset) begin
    if (reset) s <= RESET_VAL;
    else if (en) s <= {s[15:1], q};
  end

endmodule
