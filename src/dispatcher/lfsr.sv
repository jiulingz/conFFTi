`default_nettype none

// tap reference: https://www.xilinx.com/support/documentation/application_notes/xapp052.pdf, Table 3
module LFSR #(
    RESET_VAL = 16'b0
) (
    input  logic clock,
    input  logic reset_l,
    input  logic en,
    output logic q
);

  logic [16:1] s;

  assign q = ~^{s[16], s[15], s[13], s[4]};
  always_ff @(posedge clock, negedge reset_l) begin
    if (!reset_l) s <= RESET_VAL;
    else if (en) s <= {s[15:1], q};
  end

endmodule : LFSR
