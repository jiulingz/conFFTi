module audioCtrlSim();

  logic        clock50, clock44;
  logic        reset, osc_reset;
  logic        sdin, sclk, usb_clk, daclrc, dacdat;
  logic [24:0] mixer_output;

  // instantiate an audioController
  audioController AudioController (
    .clk(clock50),
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
  clock44 Clock44 (
    .clock50(clock50),
    .clock44(clock44)
  );

  // instantiate oscillator
  oscillator Osc (
    .clk(clock44),
    .reset(osc_reset),
    .wave_sel(2'b00),
    .freq(7'd10),
    .out(mixer_output)
  );

  // clock50
  initial begin
    clock50 = 0;
    bclk = 0;
    forever #1 clock50 = ~clock50;
    forever #113 bclk = ~bclk;
  end

  assign sclk = clock50;
  assign usb_clk = clock50;
  assign daclrc = clock44;
  
  initial begin
    reset <= 1'b1;
    @(posedge clk);
    reset <= 1'b0;
    #5000
  $finish;
  end

endmodule: audioCtrlSim