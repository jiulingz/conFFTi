`default_nettype none

module lfsr_test ();
  logic clk;
  logic reset;
  logic en;
  logic q;

  lfsr dut (
      .clk,
      .reset,
      .en,
      .q
  );

  initial begin
    clk = 1;
    forever #5 clk = ~clk;
  end

  initial begin
    $monitor($time,, "q=%b", q);
    reset <= 1'b1;
    en    <= 1'b1;
    @(posedge clk);
    reset <= 1'b0;

    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);

    $display("hold");
    reset <= 1'b1;
    @(posedge clk);
    reset <= 1'b0;
    en <= 1'b0;

    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    #10 $finish;
  end
endmodule
