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

module clock44 (
  logic input  CLOCK_50,
  logic output CLOCK_44,
);

  logic [10:0] counter;
  always_ff @(posedge CLOCK_50) begin
    counter <= counter + 1;
    if (counter == 11'd1133) begin
      counter <= 0;
      CLOCK_44 <= 1;
    end
    else CLOCK_44 <= 0;
  end
  
endmodule : clock44
