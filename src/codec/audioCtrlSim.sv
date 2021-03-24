module Top();

  logic        CLOCK_50, clock44, clear_clk;
  logic        reset, osc_reset, en;
  logic        sdin, sclk, usb_clk, daclrc, dacdat;
  logic [23:0] mixer_output;

  // instantiate an audioController
  audioController AudioController (
    .clk(CLOCK_50),
    .reset(reset),
    .SW0(1'b1),
    .SDIN(sdin),
    .mixer_output(mixer_output),
    .SCLK(sclk),
    .USB_clk(usb_clk),
    .BCLK(bclk),
    .DAC_LR_CLK(daclrc),
    .DAC_DATA(dacdat)
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
    .freq(7'd10),
    .out(mixer_output)
  );

  // CLOCK_50
  initial begin
    CLOCK_50 = 0;
    forever #1 CLOCK_50 = ~CLOCK_50;
  end
  
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

endmodule: audioCtrlSim