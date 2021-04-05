module LFSRTest1 ();

  logic clock;
  logic reset_l;
  logic en;
  logic q;

  LFSR lfsr (
      .clock,
      .reset_l,
      .en,
      .q
  );

  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  initial forever begin
    @(posedge clock);
    $display("%b", q);
  end

  initial begin
    repeat (30) @(posedge clock);
    $finish;
  end

  initial begin
    reset_l <= 1'b0;
    en    <= 1'b1;
    @(posedge clock);
    reset_l <= 1'b1;
  end

endmodule : LFSRTest1

module LFSRTest2 ();

  logic clock;
  logic reset_l;
  logic en;
  logic q;

  LFSR lfsr (
      .clock,
      .reset_l,
      .en,
      .q
  );

  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  initial forever begin
    @(posedge clock);
    $display("%b", q);
  end

  initial begin
    repeat (30) @(posedge clock);
    $finish;
  end

  initial begin
    reset_l <= 1'b0;
    en    <= 1'b0;
    @(posedge clock);
    reset_l <= 1'b1;
  end

endmodule : LFSRTest2

module LFSRTest3 ();

  logic clock;
  logic reset_l;
  logic en;
  logic q;

  LFSR lfsr (
      .clock,
      .reset_l,
      .en,
      .q
  );

  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  initial forever begin
    @(posedge clock);
    $display("%b", q);
  end

  initial begin
    repeat (30) @(posedge clock);
    $finish;
  end

  initial begin
    reset_l <= 1'b0;
    en    <= 1'b1;
    @(posedge clock);
    reset_l <= 1'b1;
    repeat (5) @(posedge clock);
    en    <= 1'b0;
  end

endmodule : LFSRTest3
