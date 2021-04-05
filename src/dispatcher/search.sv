`default_nettype none

module Search #(
    parameter ELEMENT_WIDTH = 0,
    parameter ELEMENT_COUNT = 0
) (
    input  logic [        ELEMENT_WIDTH-1:0] needle,
    input  logic [        ELEMENT_WIDTH-1:0] heystack[ELEMENT_COUNT-1:0],
    output logic                             contains,
    output logic [$clog2(ELEMENT_COUNT)-1:0] index
);

  localparam INDEX_WIDTH = $clog2(ELEMENT_COUNT);

  logic [$clog2(ELEMENT_COUNT+1)-1:0] i;
  always_comb begin
    i = 0;
    while (i < ELEMENT_COUNT && needle != heystack[i[0+:INDEX_WIDTH]]) i++;
  end

  assign contains = i < ELEMENT_COUNT;
  assign index    = i[0+:INDEX_WIDTH];

endmodule
