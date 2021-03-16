module ChipInterface
  (input  logic [17:0] SW,
   output logic [17:0] LEDR,
   output logic  [7:0] LEDG,
   output logic  [6:0] HEX7, HEX6, HEX5, HEX4,
                       HEX3, HEX2, HEX1, HEX0);

  SECDEDdecoder decoder(.inCode(SW[12:0]),
                        .syndrome(LEDG[7:4]),
                        .outCode(LEDR[12:0]),
                        .is1BitErr(LEDG[0]),
                        .is2BitErr(LEDG[1]));

  logic [3:0] in0, in1, out0, out1;

  HEXtoSevenSegment hex7(.hex(in1), .segment(HEX7));
  HEXtoSevenSegment hex6(.hex(in0), .segment(HEX6));
  HEXtoSevenSegment hex5(.hex(out1), .segment(HEX5));
  HEXtoSevenSegment hex4(.hex(out0), .segment(HEX4));
  HEXtoSevenSegment hex3(.hex(LEDR[15:12]), .segment(HEX3));
  HEXtoSevenSegment hex2(.hex(LEDR[11:8]), .segment(HEX2));
  HEXtoSevenSegment hex1(.hex(LEDR[7:4]), .segment(HEX1));
  HEXtoSevenSegment hex0(.hex(LEDR[3:0]), .segment(HEX0));

  assign in1 = {SW[12], SW[11], SW[10], SW[9]};
  assign in0 = {SW[7],  SW[6],  SW[5],  SW[3]};
  assign out1 = {LEDR[12], LEDR[11], LEDR[10], LEDR[9]};
  assign out0 = {LEDR[7],  LEDR[6],  LEDR[5],  LEDR[3]};

endmodule: ChipInterface


module HEXtoSevenSegment
  (input  logic [3:0] hex,
   output logic [6:0] segment);

  always_comb
    unique case ({hex})
      4'd0: segment = 7'b100_0000;
      4'd1: segment = 7'b111_1001;
      4'd2: segment = 7'b010_0100;
      4'd3: segment = 7'b011_0000;
      4'd4: segment = 7'b001_1001;
      4'd5: segment = 7'b001_0010;
      4'd6: segment = 7'b000_0010;
      4'd7: segment = 7'b111_1000;
      4'd8: segment = 7'b000_0000;
      4'd9: segment = 7'b001_0000;
      4'd10: segment = 7'b000_1000; // A
      4'd11: segment = 7'b000_0011; // b 
      4'd12: segment = 7'b100_0110; // C
      4'd13: segment = 7'b010_0001; // d
      4'd14: segment = 7'b000_0110; // E
      4'd15: segment = 7'b000_1110; // F
    default: segment = 7'd0;
    endcase

endmodule: HEXtoSevenSegment