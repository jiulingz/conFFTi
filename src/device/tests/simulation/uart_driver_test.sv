module UARTDriverTest ();

  logic       clock_send;
  logic       clock_recv;
  logic       reset_l;
  logic       uart_tx;
  logic       uart_rx;
  logic       data_in_ready;
  logic [7:0] data_in;

  assign uart_rx = uart_tx;
  Sender s (
      .clock(clock_send),
      .reset_l,
      .uart_tx
  );
  UARTDriver r (
      .clock_50_000_000(clock_recv),
      .reset_l,
      .uart_rx,
      .data_in,
      .data_in_ready
  );

  // clocks
  initial begin
    clock_send = 0;
    forever #1600 clock_send = ~clock_send;
  end
  initial begin
    clock_recv = 0;
    forever #1 clock_recv = ~clock_recv;
  end

  // termination
  initial begin
    repeat (500) @(posedge clock_send);
    $finish;
  end

  // reset_l
  initial begin
    reset_l <= 1'b0;
    @(posedge clock_recv);
    reset_l <= 1'b1;
  end

  initial
    forever begin
      @(posedge clock_recv);
      if (data_in_ready) $display("%b", data_in);
    end

endmodule : UARTDriverTest

module Sender (
    input  logic clock,
    input  logic reset_l,
    output logic uart_tx
);

  parameter WORDS = 20, WORD_SIZE = 11;
  logic [      WORD_SIZE-1:0] message_rom  [WORDS-1:0];
  logic [    $clog2(WORDS):0] word_counter;
  logic [$clog2(WORD_SIZE):0] bit_counter;

  parameter TX_IDLE = 1;

  // side way PASS pattern
  initial begin
    $readmemb("uart_driver_test_data.vm", message_rom);
  end

  always_ff @(posedge clock, negedge reset_l) begin
    if (!reset_l) begin
      uart_tx      <= TX_IDLE;
      word_counter <= 0;
      bit_counter  <= WORD_SIZE - 1;
    end else begin
      if (word_counter < WORDS) uart_tx <= message_rom[word_counter][bit_counter];
      else uart_tx <= TX_IDLE;

      if (bit_counter == 0) begin
        bit_counter  = WORD_SIZE - 1;
        word_counter = word_counter + 1;
      end else bit_counter = bit_counter - 1;
    end
  end

endmodule : Sender
