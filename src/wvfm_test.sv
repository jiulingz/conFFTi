`default_nettype none

//`include "internal_defines.vh"

module wvfm_test();
    logic      clk, reset, en;
	 logic      samp_clk;
	 reg [23:0] out;
	 
	 dsp_to_osc_t dsp_to_osc;
	 initial begin
	   dsp_to_osc.note = 7'd31;
		dsp_to_osc.velocity = 7'd10;
		dsp_to_osc.wave_sel = SIN;
		dsp_to_osc.note_en = OFF;
    end
	 
	 assign samp = 1'b0;
	 global_clock gc(.*);
         Clock44 clock44(.clear(1'b0), .clock50(clk), .clock44(samp_clk));
	 oscillator DUT(.*);
	 
	 initial begin
	     clk = 1;
		  forever #5 clk = ~clk;
	 end
	 
	 initial begin
	     $monitor($time,, "out=%b", out);
		  reset <= 1'b1;
		  en <= 1'b1;
		  dsp_to_osc.note_en <= ON;
		  @(posedge clk);
		  reset <= 1'b0;
		  dsp_to_osc.note_en <= OFF;
    end
	 
endmodule: wvfm_test