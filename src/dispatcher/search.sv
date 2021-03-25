`default_nettype none

module search #(
    parameter ELEMENT_WIDTH = 0,
    parameter ELEMENT_COUNT = 4
) (
    input  wire logic [          ELEMENT_WIDTH-1:0]                    needle,
    input  wire logic [          ELEMENT_COUNT-1:0][ELEMENT_WIDTH-1:0] heystack,
    output logic                                                       contains,
    output logic      [$clog2(ELEMENT_COUNT+1)-1:0]                    index
);
  always_comb begin
    index = 0;
    while (index < ELEMENT_COUNT && needle != heystack[index]) begin
      index++;
    end
  end
  assign contains = index < ELEMENT_COUNT;

endmodule
