`default_nettype none

module Counter
  #(parameter WIDTH=8)
  (input  wire logic [WIDTH-1:0] D,
   input  wire logic up, clk, en, clear, load,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clk)
    if (clear)
      Q <= 0;
    else if (load)
      Q <= D;
    else if (en) begin
      if (up)
        Q <= Q+1;
      else 
        Q <= Q-1;
    end

endmodule: Counter


module MagComp
  #(parameter   WIDTH = 8)
  (input  wire logic [WIDTH-1:0] A, B,
   output logic             AltB, AeqB, AgtB);

  assign AeqB = (A == B);
  assign AltB = (A <  B);
  assign AgtB = (A >  B);
endmodule: MagComp


module Mux4to1
   #( parameter WIDTH = 24 )
	 ( input  wire logic [1:0] sel,
	   input  wire logic [(WIDTH-1):0] sin_out, sqr_out, saw_out, tri_out,
	   output logic [(WIDTH-1):0] out );
    
	 always_comb begin
	     case (sel)
		      2'b00: begin
						 out = sin_out;
						 end
				2'b01: begin
				       out = sqr_out;
						 end
				2'b10: begin
				       out = saw_out;
						 end
				2'b11: begin
				       out = tri_out;
						 end
			endcase
	 end
	 
endmodule: Mux4to1

module Register
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] D,
   input  logic             en, clear, clock,
   output logic [WIDTH-1:0] Q);
   
  always_ff @(posedge clock)
    if (en)
      Q <= D;
    else if (clear)
      Q <= 0;
endmodule: Register

module Multiplexer
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0]         I,
   input  logic [$clog2(WIDTH)-1:0] Sel,
   output logic                     Y);
   
  assign Y = I[Sel];
endmodule: Multiplexer

module ShiftRegister
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] D,
   input  logic clock, en, left, load,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock)
    if (load)
      Q <= D;
    else if (en) begin
      if (left)
        Q <= Q<<1;
      else 
        Q <= Q>>1;
    end

endmodule: ShiftRegister


module BarrelShiftRegister
  #(parameter WIDTH=8)
  (input  logic [WIDTH-1:0] D,
   input  logic [1:0] by,
   input  logic clock, en, load,
   output logic [WIDTH-1:0] Q);

  always_ff @(posedge clock)
    if (load)
      Q <= D;
    else if (en)
      Q <= (Q<<by);

endmodule: BarrelShiftRegister

module clockDivider #(
    parameter WIDTH=8
)  (input  wire logic        clock, clear,
    input  wire logic [WIDTH-1:0] bound,
    output logic             finish);

    reg [WIDTH-1:0] count;
    logic internal_clr;

    always_ff @(posedge clock)
        if (clear == 1'b1) begin
          finish <= 0;
          count <= 0;
        end
        else if (internal_clr == 1'b1) begin
          count <= 0;
          internal_clr <= 1'b0;
        end
        else if (count == bound) begin
          finish <= ~finish;
          internal_clr <= 1'b1;
        end
		  else count <= (count + 1'b1);

endmodule: clockDivider

module Clock44 (
  input  wire logic clear,
  input  wire logic clock50,
  output logic clock44
);

  clockDivider #(.WIDTH(12)) Counter44 (
    .clock(clock50), .clear(clear), .bound(12'd566), .finish(clock44)
  );

endmodule : Clock44

module Clock400 (
  input  wire logic clear,
  input  wire logic clock50,
  output logic clock400
);

  clockDivider #(.WIDTH(8)) Counter400 (
    .clock(clock50), .clear(clear), .bound(8'd56), .finish(clock400)
  );

endmodule : Clock400

// convert one binary value to seven segment display
module BCHtoSevenSegment
  (input logic [3:0] bch,
  output logic [6:0] segment);

  always_comb
    unique case(bch)
      4'b0000: segment = 7'b100_0000;
      4'b0001: segment = 7'b111_1001;
      4'b0010: segment = 7'b010_0100;
      4'b0011: segment = 7'b011_0000;
      4'b0100: segment = 7'b001_1001;
      4'b0101: segment = 7'b001_0010;
      4'b0110: segment = 7'b000_0010;
      4'b0111: segment = 7'b111_1000;

      4'b1000: segment = 7'b000_0000;
      4'b1001: segment = 7'b001_0000;
      4'b1010: segment = 7'b000_1000;
      4'b1011: segment = 7'b000_0011;
      4'b1100: segment = 7'b100_0110;
      4'b1101: segment = 7'b010_0001;
      4'b1110: segment = 7'b000_0110;
      4'b1111: segment = 7'b000_1110;
    endcase

endmodule: BCHtoSevenSegment

// blank display or display as SSD
module SevenSegmentDigit
    (input  logic [3:0] bch,
     output logic [6:0] segment,
     input  logic       blank);

    logic [6:0] decoded;

    // run BCHtoSevenSegment with given bch values
    BCHtoSevenSegment b2ss(.bch(bch), .segment(decoded));

    always_comb begin
        if (blank == 0)
            segment = decoded;
        else
            // if blank is not zero, no segment glows
            segment = 7'b1111111;
    end

endmodule: SevenSegmentDigit

// display or blank the 8 HEX lights on FPGA board
module SevenSegmentControl
    (output logic [6:0] HEX7, HEX6, HEX5, HEX4,
     output logic [6:0] HEX3, HEX2, HEX1, HEX0,
     input  logic [3:0] BCH7, BCH6, BCH5, BCH4,
     input  logic [3:0] BCH3, BCH2, BCH1, BCH0);

    // run SevenSegmentDigit with given input values
    SevenSegmentDigit b2sd0(.bch(BCH0), .segment(HEX0), .blank(1'b0));
    SevenSegmentDigit b2sd1(.bch(BCH1), .segment(HEX1), .blank(1'b0));
    SevenSegmentDigit b2sd2(.bch(BCH2), .segment(HEX2), .blank(1'b0));
    SevenSegmentDigit b2sd3(.bch(BCH3), .segment(HEX3), .blank(1'b0));
    SevenSegmentDigit b2sd4(.bch(BCH4), .segment(HEX4), .blank(1'b0));
    SevenSegmentDigit b2sd5(.bch(BCH5), .segment(HEX5), .blank(1'b0));
    SevenSegmentDigit b2sd6(.bch(BCH6), .segment(HEX6), .blank(1'b0));
    SevenSegmentDigit b2sd7(.bch(BCH7), .segment(HEX7), .blank(1'b0));

endmodule: SevenSegmentControl
