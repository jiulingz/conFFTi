`default_nettype none


module wvfm_test();
    logic        clk, reset, en;
	 reg   [23:0] out;
	 
	 oscillator DUT(.wave_sel(2'b00), .freq(7'd10), .*);
	 
	 initial begin
	     clk = 1;
		  forever #5 clk = ~clk;
	 end
	 
	 initial begin
	     $monitor($time,, "out=%b", out);
		  reset <= 1'b1;
			en <= 1'b1;
		  @(posedge clk);
		  reset <= 1'b0;
    end
	 
endmodule: wvfm_test