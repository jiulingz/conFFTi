`default_nettype none

`include "internal_defines.vh"

module sine
   #( parameter pw = 20, ow = 24	)
	 ( input  wire logic        clk,
	   input  wire logic [20:0] phase,
	   output logic [(ow-1):0]  sin_out );

	 reg [(ow-1):0] sin_lut [0:((1<<pw)-1)];
	 initial $readmemh("wvfm_osc/lut/sintable.hex", sin_lut);

	 initial sin_out = 0;
	 always @(posedge clk)
	     sin_out <= sin_lut[phase];

endmodule: sine


module oscillator
   #( parameter pw = 8, ow = 24 )
	 ( input  wire logic       clk, samp_clk, reset, en,
	   input  dsp_to_osc_t     dsp_to_osc,
	   output reg [(ow-1):0]   out );

	logic              clr_phase;
	logic [(ow-1):0] sin_out, sqr_out, saw_out, tri_out;
	 /* +7 to accomodate for velocity scaling */
	logic [(ow-1+7):0] wave_out;
	logic [20:0]       interval, phase, max_phase;
	reg   [20:0]       lut [0:87];
	
	initial begin
	  clr_phase = 0;
	  $readmemh("wvfm_osc/lut/freqtable.hex", lut);
	end

	// TEMP: placeholders
	assign sqr_out = 24'b0;
	assign saw_out = 24'b0;
	assign tri_out = 24'b0;
	
	assign max_phase = 1 << 20;
	/* largest entry has 20 bits; total 108-21+1=88 entries */
	assign interval = lut[dsp_to_osc.note - 7'd21];

	/* Waveform modules will use the incrementing phase values */
	sine sine_(.*);
	Mux4to1 #24 mux(.sel(dsp_to_osc.wave_sel), .out(wave_out), .*);
	MagComp #21 mag(.A(phase), .B(max_phase), .AgtB(clr_phase), .AeqB(), .AltB());

   always @(posedge clk)
	  if (reset) begin
	    out <= 0;
	    phase <= interval;
	  end
	  else
	    phase <= phase << 1; 
		 /* double the interval */
	
   always @(posedge samp_clk)
       out <= ((31'b0 | wave_out) * dsp_to_osc.velocity) >> 7; 
		 /* update value at sampling frequency */
	
	always @(posedge dsp_to_osc.note_en)
	  phase <= interval; 
	  /* reset counter when note_enable turns high */
	 
	always @(posedge clk)
	  if (clr_phase)
		 phase <= interval; 
		 /* reset counter when phase increments over max_phase */


endmodule: oscillator
