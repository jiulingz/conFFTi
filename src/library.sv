`default_nettype none

module Counter
  #(parameter WIDTH=8)
  (input logic [WIDTH-1:0] D,
   input logic up, clk, en, clear, load,
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
  (input  logic [WIDTH-1:0] A, B,
   output logic             AltB, AeqB, AgtB);

  assign AeqB = (A == B);
  assign AltB = (A <  B);
  assign AgtB = (A >  B);
endmodule: MagComp


module Mux4to1
   #( parameter WIDTH = 24 )
	 ( input  logic [1:0] sel,
	   input  logic [(WIDTH-1):0] sin_out, sqr_out, saw_out, tri_out,
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

module clockDivider #(
    parameter WIDTH=8
)  (input  logic             clock, clear,
    input  logic [WIDTH-1:0] bound,
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
  input  logic clear,
  input  logic clock50,
  output logic clock44
);

  clockDivider #(.WIDTH(12)) Counter44 (
    .clock(clock50), .clear(clear), .bound(12'd566), .finish(clock44)
  );
  
endmodule : Clock44

module Clock400 (
  input  logic clear,
  input  logic clock50,
  output logic clock400
);

  clockDivider #(.WIDTH(8)) Counter400 (
    .clock(clock50), .clear(clear), .bound(8'd56), .finish(clock400)
  );

endmodule : Clock400