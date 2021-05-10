`include "../../../includes/midi.vh"

module RecorderTest;

  import MIDI::*;
  import CONFIG::*;

  logic         clock;
  logic         reset_l;
  message_t     message;
  logic         message_ready;
  note_change_t replay;
  logic         replay_ready;

  Recorder dut (
      .clock_50_000_000(clock),
      .reset_l,
      .message,
      .message_ready,
      .replay,
      .replay_ready
  );

  // clock
  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  // display
  initial $monitor("\t%p %p,%p\n\t%p, %p\n\t%p\n\t%p\n", dut.state, dut.l, dut.i, replay_ready, replay, dut.timestampes, dut.notes);

  // initialization
  initial begin
    message_ready <= 1'b0;
    reset_l       <= 1'b0;
    @(posedge clock);
    reset_l <= 1'b1;
  end

  // trace
  initial begin
    repeat (20) @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: NOTE_OFF, data_byte1: 1, data_byte2: 0};
    @(posedge clock);
    message_ready <= 1'b0;

    // record
    repeat (20) @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: CONTROL_CHANGE, data_byte1: RECORD, data_byte2: 'h7f};
    @(posedge clock);
    message_ready <= 1'b0;

    repeat (20) @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: NOTE_ON, data_byte1: 1, data_byte2: 'h7f};
    @(posedge clock);
    message_ready <= 1'b0;

    repeat (20) @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: NOTE_ON, data_byte1: 2, data_byte2: 'h7f};
    @(posedge clock);
    message_ready <= 1'b0;

    repeat (20) @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: NOTE_OFF, data_byte1: 1, data_byte2: 'h7f};
    @(posedge clock);
    message_ready <= 1'b0;

    repeat (20) @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: NOTE_OFF, data_byte1: 2, data_byte2: 'h7f};
    @(posedge clock);
    message_ready <= 1'b0;

    repeat (20) @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: CONTROL_CHANGE, data_byte1: RECORD, data_byte2: 'h0};
    @(posedge clock);
    message_ready <= 1'b0;

    // replay
    repeat (20) @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: CONTROL_CHANGE, data_byte1: PLAY, data_byte2: 'h7f};
    @(posedge clock);
    message_ready <= 1'b0;
    @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: CONTROL_CHANGE, data_byte1: PLAY, data_byte2: 'h0};
    @(posedge clock);
    message_ready <= 1'b0;

    repeat (200) @(posedge clock);

    message_ready <= 1'b1;
    message       <= '{message_type: CONTROL_CHANGE, data_byte1: PLAY, data_byte2: 'h7f};
    @(posedge clock);
    message_ready <= 1'b0;
    @(posedge clock);
    message_ready <= 1'b1;
    message       <= '{message_type: CONTROL_CHANGE, data_byte1: PLAY, data_byte2: 'h0};
    @(posedge clock);
    message_ready <= 1'b0;

    @(posedge clock);
    $finish;
  end

endmodule : RecorderTest

