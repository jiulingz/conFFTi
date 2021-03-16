`default_nettype none

// reference: https://github.com/ZipCPU/cordic/blob/master/rtl/sintable.v

module sinewave 
   #( parameter pw = 8, ow = 24	)
	 ( input  wire clk, reset, en,
	   input  reg  [(pw-1):0] phase,
	   output reg  [(ow-1):0] out );
	 
	 reg [(ow-1):0] lut [0:((1<<pw)-1)];
	 initial $readmemh("sintable.hex", lut);
	 
	 initial out = 0;
	 always @(posedge clk)
	 if (reset)
	     out <= 0;
    else if (en)
	     out <= lut[phase];
	 
endmodule