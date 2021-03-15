`default_nettype none

module sine_lut
  #( parameter pw = 8, ow = 24	)
	(input  wire clk, sample_clk_en,
	 input  wire[(pw-1):0] phase,
	 output wire sine_val);
	 
	 always @(posedge clk)
	 if (sample_clk_en)
		  case (phase[(pw-1):

module sinewave 
   #( parameter pw = 8, ow = 24	)
	(input  wire  clk, reset, en,
	 input  wire [(pw-1):0] phase,
	 output wire [(ow-1):0] out );