module Top_dac(
  input logic CLOCK_50,
  input logic [17:0] SW,
  output logic [35:0] GPIO
);

  logic        clock44;
  logic [23:0] mixer_output;
  dsp_to_osc_t dsp_to_osc;
  
  initial begin
	 dsp_to_osc.note = 7'd31;
    dsp_to_osc.velocity = 7'd10;
    dsp_to_osc.wave_sel = SIN;
    dsp_to_osc.note_en = ON;
  end
  
  // instantiate an audioController
  DacController dac_controller (
	 .clk(CLOCK_50),
    .reset(SW[0]),
    .mixer_output(mixer_output[23:8]),
    .i2sBitClock(GPIO[0]),
    .i2sLeftRightSelect(GPIO[2]),
    .i2sSoundData(GPIO[1])
  );

  // instantiate a 44.1kHz clock
  Clock44 clock_44 (
    .clear(SW[0]),
    .CLOCK_50(CLOCK_50),
    .clock44(clock44)
  );

  // instantiate oscillator
  oscillator Osc (
    .clk(CLOCK_50),
	 .wave_sel(2'b00),
    .reset(SW[0]),
    .en(SW[1]),
    .dsp_to_osc(dsp_to_osc),
    .out(mixer_output)
  );

endmodule: Top_dac