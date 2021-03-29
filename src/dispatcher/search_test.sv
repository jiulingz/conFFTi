`default_nettype none

module search_test1 ();
  logic [3:0] heystack;
  logic       contains;
  logic [2:0] index;

  search #(
      .ELEMENT_WIDTH(1),
      .ELEMENT_COUNT(4)
  ) dut (
      .needle(1'b0),
      .heystack,
      .contains,
      .index
  );

  initial begin
    $monitor("\tneedle=%b, heystack=%b, contains=%b, index=%d", 1'b0, heystack, contains, index);
    for (heystack = 4'b0000; heystack < 4'b1111; heystack++) #1;
    #1 $finish;
  end
endmodule

module search_test2 ();
  logic [6:0]      needle;
  logic [3:0][6:0] heystack;
  logic            contains;
  logic [2:0]      index;

  search #(
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
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3], heystack[2], heystack[1], heystack[0], contains, index);

    needle   = 7'd5;
    heystack = {7'd5, 7'd0, 7'd5, 7'd0};
    #1;
    if (contains != 1'b1 || index != 1)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3], heystack[2], heystack[1], heystack[0], contains, index);

    needle   = 7'd5;
    heystack = {7'd5, 7'd42, 7'd25, 7'd0};
    #1;
    if (contains != 1'b1 || index != 3)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3], heystack[2], heystack[1], heystack[0], contains, index);

    needle   = 7'd5;
    heystack = {7'd0, 7'd0, 7'd0, 7'd0};
    #1;
    if (contains != 1'b0)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3], heystack[2], heystack[1], heystack[0], contains, index);

    needle   = 7'd10;
    heystack = {7'd40, 7'd30, 7'd20, 7'd10};
    #1;
    if (contains != 1'b1 || index != 0)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3], heystack[2], heystack[1], heystack[0], contains, index);

    $finish;
    needle   = 7'd20;
    heystack = {7'd40, 7'd30, 7'd20, 7'd10};
    #1;
    if (contains != 1'b1 || index != 1)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3], heystack[2], heystack[1], heystack[0], contains, index);

    $finish;
    needle   = 7'd30;
    heystack = {7'd40, 7'd30, 7'd20, 7'd10};
    #1;
    if (contains != 1'b1 || index != 2)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3], heystack[2], heystack[1], heystack[0], contains, index);

    $finish;
    needle   = 7'd40;
    heystack = {7'd40, 7'd30, 7'd20, 7'd10};
    #1;
    if (contains != 1'b1 || index != 3)
      $display("\tneedle=%d, heystack=%d %d %d %d, contains=%b, index=%d", needle, heystack[3], heystack[2], heystack[1], heystack[0], contains, index);

    $finish;
  end
endmodule
