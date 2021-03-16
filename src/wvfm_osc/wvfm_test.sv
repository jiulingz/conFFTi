`default_nettype none


module phase_test();
    reg   [7:0] phase;
	 logic       clk, reset, en;
	 phase_osc DUT(.*);
	 
	 initial begin
	     clk = 1;
		  forever #5 clk = ~clk;
	 end
	 
	 initial begin
	     $monitor($time,, "out=%b", phase);
		  reset <= 1'b1;
		  en <= 1'b1;
		  @(posedge clk);
		  reset <= 1'b0;
    end
	 
endmodule: phase_test


module sinwave_test();
    reg   [7:0]  phase;
	 reg   [23:0] out;
	 logic        clk, reset, en;
	 
	 phase_osc phase_(.*);
	 sinewave DUT(.*);
	 
	 initial begin
	     clk = 1;
		  forever #5 clk = ~clk;
	 end
	 
	 initial phase = 0;
	 initial begin
	     $monitor($time,, "out=%h", out);
		  reset <= 1'b1;
		  en <= 1'b1;
		  @(posedge clk);
		  reset <= 1'b0;
		  @(posedge clk);
		  @(posedge clk);
		  @(posedge clk);
		  @(posedge clk);
	 end

endmodule: sinwave_test