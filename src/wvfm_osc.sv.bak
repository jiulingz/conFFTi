`default_nettype none

`include "internal_defines.vh"

module sine
   #( parameter pw = 20, ow = 24	)
	 ( input  wire logic        clk,
	   input  wire logic [pw:0] phase,
	   output logic [(ow-1):0]  sin_out );

	 reg [(ow-1):0] sin_lut [0:((1<<pw)-1)];
	 initial $readmemh("wvfm_osc/lut/sintable.hex", sin_lut);

	 initial sin_out = 0;
	 always @(posedge clk)
	     sin_out <= sin_lut[phase];

endmodule: sine


module square
  #( parameter pw = 20, ow = 24	)
   ( input  wire logic        clk,
     input  wire logic [pw:0] phase,
     output logic [(ow-1):0]  sqr_out );

    logic high;
    logic [(ow-1):0] high_val;

    MagComp #21 mag3(.A(phase), .B(21'd500000), .AgtB(high), .AeqB(), .AltB());

    always @(posedge clk)
      if (high)
        sqr_out <= 24'h7fffff;
      else
        sqr_out <= 24'h800000;

endmodule: square


module triangle
  #( parameter pw = 20, ow = 24 )
   ( input wire logic        clk, reset,
     input wire logic [pw:0] phase,
     output logic [(ow-1):0] tri_out );

     logic phase1, phase2, phase3, phase4;
     logic [6:0] slope;

     assign slope = 7'd34; // 7FFFFF / (100000/4)
     MagComp #21 mag1(.A(phase), .B(21'd250000), .AgtB(phase2), .AeqB(), .AltB(phase1));
     MagComp #21 mag3(.A(phase), .B(21'd750000), .AgtB(phase4), .AeqB(), .AltB(phase3));

     always @(posedge clk)
       // phase 1
       if (phase1)
         tri_out <= slope * phase;
       else if (phase2)
         tri_out <= slope * (21'd500000 - phase);
       else if (phase3)
         tri_out <= (1 << (ow-1)) | (slope * (phase - 21'd500000));
       else if (phase4)
         tri_out <= (1 << (ow-1)) | (slope * (phase - 21'd750000));

endmodule: triangle


module sawtooth
  #( parameter pw = 20, ow = 24 )
   ( input wire logic        clk, reset,
     input wire logic [pw:0] phase,
     output logic [(ow-1):0] tri_out );

     assign slope = 5'd17 // 7fffff / (100000/4)
     MagComp #21 mag1(.A(phase), .B(21'd500000), .AgtB(neg), .AeqB(), .AltB(phase1));

     always @(posedge clk)
       if (neg)
         tri_out <= (21'd500000 - phase) * phase;
       else
         tri_out <= (1 << (ow-1)) | ((phase - 21'd500000) * phase);

endmodule: sawtooth


module oscillator
  #( parameter pw = 8, ow = 24 )
	 ( input  wire logic       clk, reset, en,
	   input  dsp_to_osc_t     dsp_to_osc,
	   output reg [(ow-1):0]   out );

	logic              clr_phase, clr_count, load_count, en_d1, en_d2;
  logic              update_note;
  logic [10:0]       count;
	logic [(ow-1):0]   sin_out, sqr_out, saw_out, tri_out;
	 /* +7 to accomodate for velocity scaling */
	logic [(ow-1+7):0] wave_out;
	logic [20:0]       interval, phase, max_phase;
  logic [12:0]       freq;
	reg   [20:0]       div_lut [0:87];
  reg   [12:0]       freq_lut [0:87];

	initial begin
	  clr_phase = 0;
	  $readmemh("wvfm_osc/lut/divtable.hex", div_lut);
    $readmemh("wvfm_osc/lut/freqtable.hex", freq_lut);
	end

	// TEMP: placeholders
	assign sqr_out = 24'b0;
	assign saw_out = 24'b0;
	assign tri_out = 24'b0;

	assign max_phase = 1 << 20;
	/* largest entry has 20 bits; total 108-21+1=88 entries */
  assign freq = freq_lut[dsp_to_osc.note - 7'd21];
  assign update_note = en_d1 & (!en_d2);

	/* Waveform modules will use the incrementing phase values */
	sine sin(.*);
  square sqr(.*);
  triangle tri(.*);
  sawtooth saw(.*);
  
  Counter #11 c(.Q(count), .D(11'd1133), .up(1'd0), .en(1'd1),
                .clear(1'd0), .load(load_count), .clk(clk));
  MagComp #11 mag2(.A(count), .B(0), .AeqB(load_count), .AltB(). .AgtB());
	Mux4to1 #24 mux(.sel(dsp_to_osc.wave_sel), .out(wave_out), .*);
	MagComp #21 mag(.A(phase), .B(max_phase), .AgtB(clr_phase), .AeqB(), .AltB());

  always @(posedge clk)
	  if (reset) begin
	    out <= 0;
      phase <= 0;
      interval <= div_lut[dsp_to_osc.note - 7'd21];
    end
    if (load_count) begin
      phase <= phase + interval
      out <= ((31'b0 | wave_out) * dsp_to_osc.velocity) >> 7;
      /* update value at sampling frequency */
    end
    if (dsp_to_osc.note_en) begin
      en_d1 <= dsp_to_osc.note_en;
      en_d2 <= en_d1;
    end
    if (update_note)
      interval <= div_lut[dsp_to_osc.note - 7'd21];
    if (clr_phase)
		  phase <= 0;
		  /* reset counter when phase increments over max_phase */

endmodule: oscillator
