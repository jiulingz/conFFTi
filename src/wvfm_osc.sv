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

     always @(posedge clk) begin
       if (high)
         sqr_out <= 24'h7fffff;
       else
         sqr_out <= 24'h800000;
     end

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

     always @(posedge clk) begin
       if (phase1)
         tri_out <= slope * phase;
       else if (phase2)
         tri_out <= slope * (21'd500000 - phase);
       else if (phase3)
         tri_out <= (1 << (ow-1)) | (slope * (phase - 21'd500000));
       else if (phase4)
         tri_out <= (1 << (ow-1)) | (slope * (phase - 21'd750000));
     end

endmodule: triangle


module sawtooth
  #( parameter pw = 20, ow = 24 )
   ( input wire logic        clk, reset,
     input wire logic [pw:0] phase,
     output logic [(ow-1):0] trg_out );

	   logic       neg, phase1;
	   logic [4:0] slope;

     assign slope = 5'd17; // 7fffff / (100000/4)
     MagComp #21 mag1(.A(phase), .B(21'd500000), .AgtB(neg), .AeqB(), .AltB(phase1));

     always @(posedge clk) begin
       if (neg)
         trg_out <= (21'd500000 - phase) * phase;
       else
         trg_out <= (1 << (ow-1)) | ((phase - 21'd500000) * phase);
     end

endmodule: sawtooth


module oscillator
  #( parameter pw = 8, ow = 24 )
   ( input  wire logic       clk, reset, en,
     input  wire logic [1:0] wave_sel,
     input  dsp_to_osc_t     dsp_to_osc,
     output reg [(ow-1):0]   out );

     logic              clr_phase, load_count, note_en_ff, note_en_rise_edge;
     logic [10:0]       count;
     logic [(ow-1):0]   sin_out, sqr_out, saw_out, trg_out;
	   /* +7 to accomodate for velocity scaling */
     logic [(ow-1+7):0] wave_out;
     logic [20:0]       interval, phase, max_phase;
     reg   [20:0]       div_lut [0:87];

     initial begin
       clr_phase = 0;
       phase = 0;
       $readmemh("wvfm_osc/lut/divtable.hex", div_lut);
     end

     assign max_phase = 1 << 20;
     assign note_en_rise_edge = dsp_to_osc.note_en & (~note_en_ff);
     assign interval = div_lut[dsp_to_osc.note - 7'd21];

     /* Waveform modules */
     sine sin(.*);
     square sqr(.*);
     triangle trg(.*);
     sawtooth saw(.*);

     Counter #11 c(.Q(count), .D(11'd1133), .up(1'd0), .en(1'd1),
                   .clear(1'd0), .load(load_count), .clk(clk));
     MagComp #11 mag2(.A(count), .B(1'd0), .AeqB(load_count), .AltB(), .AgtB());
     Mux4to1 #24 mtx(.sel(wave_sel), .out(wave_out), .*);
     MagComp #21 mag(.A(phase), .B(max_phase), .AgtB(clr_phase), .AeqB(), .AltB());

     /* ff logic to detect rising edge of note_en input */
     always_ff @(posedge clk or negedge reset) begin
       if (!reset)
         note_en_ff <= 1'b0;
       else
         note_en_ff <= dsp_to_osc.note_en;
     end

     always @(posedge clk) begin
       if (reset or note_en_rise_edge) begin
         out <= 0;
         phase <= 0;
         /* when reset signal is on, or when note is first enabled */
       end
       else if (load_count) begin
         phase <= phase + interval;
         out <= ((31'b0 | wave_out) * dsp_to_osc.velocity) >> 7;
         /* update value at sampling frequency */
       end
       else if (clr_phase) begin
         phase <= 0;
         out <= out;
         /* reset counter when phase increments over max_phase */
       end
     end

endmodule: oscillator
