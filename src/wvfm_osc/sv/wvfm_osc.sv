`default_nettype none

module sine
   #( parameter pw = 8, ow = 24	)
	 ( input  wire logic            clk,
	   input  wire logic [7:0] phase,
	   output logic [(ow-1):0] out );
	 
	 reg [(ow-1):0] lut [0:((1<<pw)-1)];
	 initial $readmemh("../lut/sintable.hex", lut);
	 
	 initial out = 0;
	 always @(posedge clk)
	     out <= lut[phase];
	 
endmodule: sine


// TEMP: freq is set to an index value of actual_f-21
// subject to change after MIDI decoder is done
// wave_sel: 2'b00-sine, 2'b01-sqr, 2'b10-saw, 2'b11-tri
module oscillator
   #( parameter pw = 8, ow = 24 )
	 ( input  wire logic 		clk, reset,
	   input  wire logic [1:0] wave_sel,
	   input  wire logic [6:0] freq,
	   output reg   [(ow-1):0] out );
	
	 logic            incr_phase;
	 logic [7:0]      phase;
	 logic [(ow-1):0] sin_out, sqr_out, saw_out, tri_out;
	 logic [20:0]     incr_interval, count;
	 reg   [20:0] lut [0:87];
	 
	 initial phase = 0;
	 
	 // TEMP: placeholders
	 assign sqr_out = 23'b0;
	 assign saw_out = 23'b0;
	 assign tri_out = 23'b0;
	 
	 // largest entry has 20 bits; total 108-21+1=88 entries
	 initial $readmemh("../lut/freqtable.hex", lut);
	 assign incr_interval = lut[freq];
	 // TEMP: use for testing
	 // assign incr_interval = 15;
	 
	 // Increments phase according to down_ticks
	 Counter #21 c1(.D(21'b0), .Q(count), 
	                .up(1'd1), .clear(incr_phase), .load(reset), .*);
	 MagComp #21 mag(.A(count), .B(incr_interval), .AgtB(incr_phase), .AeqB(), .AltB());
	 Counter #8 c2(.D(8'b0), .Q(phase), .en(incr_phase), 
						.up(1'd1), .clk(clk), .clear(1'd0), .load(reset));
	
	 // Waveform modules will use the incrementing phase values
	 sine sine_(.out(sin_out), .*);
	 
	 // Choose a type of waveform to output
	 Mux4to1 mux(.sel(wave_sel), .*);
	 
endmodule: oscillator

