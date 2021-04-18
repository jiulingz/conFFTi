`include "../../../includes/midi.vh"

module MIDIDecoderTest;

  import MIDI::*;

  logic           clock;
  logic           reset_l;
  logic           ready;
  message_t       message;
  logic           message_ready;
  logic     [7:0] data_in;
  logic           data_in_ready;

  MIDIDecoder dut (
      .clock_50_000_000(clock),
      .reset_l,
      .data_in,
      .data_in_ready,
      .message,
      .message_ready
  );

  // clock
  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  // display
  initial
    forever begin
      @(posedge clock);
      if (message_ready) $display("\t%p", message);
    end

  // initialization
  initial begin
    data_in_ready <= 1'b0;
    reset_l <= 1'b0;
    @(posedge clock);
    reset_l <= 1'b1;
  end

  // trace
  initial begin
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= {NOTE_ON, 4'b0000};
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd10;
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd80;
    @(posedge clock);
    data_in_ready <= 1'b0;

    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= {NOTE_ON, 4'b0000};
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd20;
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd0;
    @(posedge clock);
    data_in_ready <= 1'b0;

    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= {NOTE_OFF, 4'b0000};
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd30;
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd0;
    @(posedge clock);
    data_in_ready <= 1'b0;

    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= {CONTROL_CHANGE, 4'b0000};
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= {1'b0, VOLUME};
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd60;
    @(posedge clock);
    data_in_ready <= 1'b0;

    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= {4'hC, 4'b0000}; // Program change, Ignore.
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd50;
    @(posedge clock);
    data_in_ready <= 1'b0;

    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= {NOTE_ON, 4'b0000};
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd60;
    @(posedge clock);
    data_in_ready <= 1'b0;
    repeat (20) @(posedge clock);
    data_in_ready <= 1'b1;
    data_in       <= 8'd80;
    @(posedge clock);
    data_in_ready <= 1'b0;

    repeat (20) @(posedge clock);
    $finish;
  end

endmodule : MIDIDecoderTest
