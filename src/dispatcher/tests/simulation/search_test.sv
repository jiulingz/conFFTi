`default_nettype none

module SearchTest1 ();
  logic       heystack [3:0];
  logic       contains;
  logic [1:0] index;

  Search #(
      .ELEMENT_WIDTH(1),
      .ELEMENT_COUNT(4)
  ) dut (
      .needle(1'b0),
      .heystack,
      .contains,
      .index
  );

  initial begin
    $monitor("\tneedle=%b, heystack=%p, contains=%b, index=%d", 1'b0, heystack, contains, index);
    #1 heystack = {1'b0, 1'b0, 1'b0, 1'b0};
    #1 heystack = {1'b0, 1'b0, 1'b0, 1'b1};
    #1 heystack = {1'b0, 1'b0, 1'b1, 1'b0};
    #1 heystack = {1'b0, 1'b0, 1'b1, 1'b1};
    #1 heystack = {1'b0, 1'b1, 1'b0, 1'b0};
    #1 heystack = {1'b0, 1'b1, 1'b0, 1'b1};
    #1 heystack = {1'b0, 1'b1, 1'b1, 1'b0};
    #1 heystack = {1'b0, 1'b1, 1'b1, 1'b1};
    #1 heystack = {1'b1, 1'b0, 1'b0, 1'b0};
    #1 heystack = {1'b1, 1'b0, 1'b0, 1'b1};
    #1 heystack = {1'b1, 1'b0, 1'b1, 1'b0};
    #1 heystack = {1'b1, 1'b0, 1'b1, 1'b1};
    #1 heystack = {1'b1, 1'b1, 1'b0, 1'b0};
    #1 heystack = {1'b1, 1'b1, 1'b0, 1'b1};
    #1 heystack = {1'b1, 1'b1, 1'b1, 1'b0};
    #1 heystack = {1'b1, 1'b1, 1'b1, 1'b1};
    #1 $finish;
  end
endmodule : SearchTest1

module SearchTest2 ();
  logic [6:0] needle;
  logic [6:0] heystack [3:0];
  logic       contains;
  logic [1:0] index;

  Search #(
      .ELEMENT_WIDTH(7),
      .ELEMENT_COUNT(4)
  ) dut (
      .needle,
      .heystack,
      .contains,
      .index
  );

  initial begin
    needle   = 7'd5;
    heystack = {7'd0, 7'd0, 7'd0, 7'd5};
    #1;
    if (contains != 1'b1 || index != 0)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3],
               heystack[2], heystack[1], heystack[0], contains, index);

    needle   = 7'd5;
    heystack = {7'd5, 7'd0, 7'd5, 7'd0};
    #1;
    if (contains != 1'b1 || index != 1)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3],
               heystack[2], heystack[1], heystack[0], contains, index);

    needle   = 7'd5;
    heystack = {7'd5, 7'd42, 7'd25, 7'd0};
    #1;
    if (contains != 1'b1 || index != 3)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3],
               heystack[2], heystack[1], heystack[0], contains, index);

    needle   = 7'd5;
    heystack = {7'd0, 7'd0, 7'd0, 7'd0};
    #1;
    if (contains != 1'b0)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3],
               heystack[2], heystack[1], heystack[0], contains, index);

    needle   = 7'd10;
    heystack = {7'd40, 7'd30, 7'd20, 7'd10};
    #1;
    if (contains != 1'b1 || index != 0)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3],
               heystack[2], heystack[1], heystack[0], contains, index);

    $finish;
    needle   = 7'd20;
    heystack = {7'd40, 7'd30, 7'd20, 7'd10};
    #1;
    if (contains != 1'b1 || index != 1)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3],
               heystack[2], heystack[1], heystack[0], contains, index);

    $finish;
    needle   = 7'd30;
    heystack = {7'd40, 7'd30, 7'd20, 7'd10};
    #1;
    if (contains != 1'b1 || index != 2)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3],
               heystack[2], heystack[1], heystack[0], contains, index);

    $finish;
    needle   = 7'd40;
    heystack = {7'd40, 7'd30, 7'd20, 7'd10};
    #1;
    if (contains != 1'b1 || index != 3)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3],
               heystack[2], heystack[1], heystack[0], contains, index);

    $finish;
  end
endmodule : SearchTest2
