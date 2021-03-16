`default_nettype none

module phase_osc
  #( parameter pw = 8 )
	(input  wire  clk, reset, en,
	 output reg [(pw-1):0] phase);
	 
	 initial phase = 0;
	 always @(posedge clk)
	 if (reset)
	     phase <= 0;
	 else if (en)
	     phase <= phase + 1;

endmodule