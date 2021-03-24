module Top(
  input logic CLOCK_50, SW,
  input logic I2C_SDAT, I2C_SCLK, AUD_XCK, AUD_DACLRCK, AUD_DACDAT, AUD_BCLK
);

  logic        clock44, clear_clk;
  logic        reset, osc_reset, en;
  logic [23:0] mixer_output;

  // instantiate an audioController
  audioController AudioController (
    .clk(CLOCK_50),
    .reset(SW[0]),
    .SW0(1'b1),
    .SDIN(I2C_SDAT),
    .mixer_output(mixer_output),
    .SCLK(I2C_SCLK),
    .AUD_XCK(AUD_XCK),
    .BCLK(AUD_BCLK),
    .DAC_LR_CLK(AUD_DACLRCK),
    .DAC_DATA(AUD_DACDAT)
  );

  // instantiate a 44.1kHz clock
  Clock44 clock_44 (
    .clear(clear_clk),
    .CLOCK_50(CLOCK_50),
    .clock44(clock44)
  );

  // instantiate oscillator
  oscillator Osc (
    .clk(clock44),
    .reset(osc_reset),
    .en(en),
    .wave_sel(2'b00),
    .freq(7'd10), // change this number to produce different frequencies
    .out(mixer_output)
  );
  
  initial begin
    reset <= 1'b1;
    osc_reset <= 1'b1;
    en <= 1'b1;
    clear_clk <= 1'b1;
    @(posedge CLOCK_50);
    reset <= 1'b0;
    osc_reset <= 1'b0;
    clear_clk <= 1'b0;
    #5000
  $finish;
  end

endmodule: Top