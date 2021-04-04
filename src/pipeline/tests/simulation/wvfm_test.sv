`default_nettype none

`include "internal_defines.vh"

module wvfm_test();
    logic       clk, reset, en;
	 logic [1:0] wave_sel;
	 reg [23:0]  out;
	 
	 dsp_to_osc_t dsp_to_osc;
	 initial begin
	   dsp_to_osc.note = 7'd31;
		dsp_to_osc.velocity = 7'd10;
		dsp_to_osc.note_en = OFF;
    end
	 
	 oscillator DUT(.*);
	 
	 initial begin
	     wave_sel = SIN;
	     clk = 1;
		  forever #10000 clk = ~clk;
		  /* simulate 50M clock rate */
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