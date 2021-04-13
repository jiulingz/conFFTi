`default_nettype none

module SevenSegmentDriver (
    input  logic [7:0][3:0] value,
    input  logic [7:0]      en,
    output logic [7:0][6:0] segment
);

  generate
    genvar i;
    for (i = 0; i < 8; i++) begin : seven_segment
      HextoSevenSegment hts (
          .value  (value[i]),
          .en     (en[i]),
          .segment(segment[i])
      );
    end
  endgenerate

endmodule : SevenSegmentDriver

/*
 * ----0----
 * |       |
 * 5       1
 * |       |
 * ----6----
 * |       |
 * 4       2
 * |       |
 * ----3----
 */
module HextoSevenSegment (
    input  logic [3:0] value,
    input  logic       en,
    output logic [6:0] segment
);

  always_comb begin
    segment = 7'b111_1111;
    if (en)
      unique case (value)
        4'h0: segment = 7'b100_0000;
        4'h1: segment = 7'b111_1001;
        4'h2: segment = 7'b010_0100;
        4'h3: segment = 7'b011_0000;
        4'h4: segment = 7'b001_1001;
        4'h5: segment = 7'b001_0010;
        4'h6: segment = 7'b000_0010;
        4'h7: segment = 7'b111_1000;
        4'h8: segment = 7'b000_0000;
        4'h9: segment = 7'b001_0000;
        4'hA: segment = 7'b000_1000;
        4'hB: segment = 7'b000_0011;
        4'hC: segment = 7'b100_0110;
        4'hD: segment = 7'b010_0001;
        4'hE: segment = 7'b000_0110;
        4'hF: segment = 7'b000_1110;
      endcase
  end

endmodule : HextoSevenSegment
