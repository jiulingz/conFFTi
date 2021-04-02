module Top(
  input logic CLOCK_50, SW,
  output logic [35:0] GPIO
);

  logic        clock44;
  logic [23:0] mixer_output;

  // instantiate an audioController
  DacController dac_controller (
    .reset(SW[0]),
    .mixer_output(mixer_output),
    .i2sBitClock(GPIO[0]),
    .i2sLeftRightSelect(GPIO[1]),
    .i2sSoundData(GPIO[2])
  );

  // instantiate a 44.1kHz clock
  Clock44 clock_44 (
    .clear(SW[0]),
    .CLOCK_50(CLOCK_50),
    .clock44(clock44)
  );

  // instantiate oscillator
  oscillator Osc (
    .clk(clock44),
    .reset(SW[0]),
    .en(SW[1]),
    .wave_sel(2'b00),
    .freq(7'd10), // change this number to produce different frequencies
    .out(mixer_output)
  );

endmodule: Top