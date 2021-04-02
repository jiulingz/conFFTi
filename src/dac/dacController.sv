module DacController (
  input  logic clk,
  input  logic reset,
  input  logic [15:0] mixer_output,
  output logic i2sBitClock,
  output logic i2sSoundData,
  output logic i2sLeftRightSelect
);
  
  // 50,000,000 / 44,100 / 16 / 2 / 2 (DE0 Nano clock / sample rate / bits per sample / channels / edges);
  localparam  i2sTicks = 8'd18;

  reg [11:0] i2sCount;
  reg [7:0] bitCount;

  always @(posedge clk)
  if (reset) begin
    i2sCount <= 0;
    bitCount <= 15;
  end
  else begin
    i2sCount <= i2sCount + 1'b1;
    if (i2sCount == i2sTicks) begin
      i2sCount <= 1'b0;
      i2sBitClock <= ~i2sBitClock;
      if (i2sBitClock == 1'b1) begin
        bitCount <= 1'b1;
        i2sSoundData <= mixer_output[bitCount +: 1];
      end
      if (bitCount == 0) begin
        i2sLeftRightSelect <= ~i2sLeftRightSelect;
        bitCount <= 15;
      end
      else bitCount <= bitCount - 1'b1;
    end
  end

endmodule : DacController