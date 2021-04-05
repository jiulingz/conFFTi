`default_nettype none

`include "../../../includes/midi.vh"

module PolyphonyTest1 ();

  import MIDI::*;

  logic                     clock;
  logic                     reset_l;
  note_change_t             note;
  logic                     note_ready;
  note_change_t [      3:0] pipeline_notes;
  logic           [3:0]     pipeline_notes_ready;

  Polyphony dut (
      .clock_50_000_000(clock),
      .reset_l,
      .note,
      .note_ready,
      .pipeline_notes,
      .pipeline_notes_ready
  );

  // clock
  initial begin
    clock = 1'b0;
    forever #1 clock = ~clock;
  end

  // initialization
  initial begin
    reset_l <= 1'b0;
    @(posedge clock);
    reset_l <= 1'b1;
  end

  // display
  initial
    forever begin
      @(posedge clock);
      if (pipeline_notes_ready) $display("%p", pipeline_notes);
    end

  // trace
  initial begin
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd10, 7'd123};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    $finish;
  end

endmodule : PolyphonyTest1

module PolyphonyTest2 ();

  import MIDI::*;

  logic                     clock;
  logic                     reset_l;
  note_change_t             note;
  logic                     note_ready;
  note_change_t [      3:0] pipeline_notes;
  logic           [3:0]     pipeline_notes_ready;

  Polyphony dut (
      .clock_50_000_000(clock),
      .reset_l,
      .note,
      .note_ready,
      .pipeline_notes,
      .pipeline_notes_ready
  );

  // clock
  initial begin
    clock = 1'b0;
    forever #1 clock = ~clock;
  end

  // initialization
  initial begin
    reset_l <= 1'b0;
    @(posedge clock);
    reset_l <= 1'b1;
  end

  // display
  initial
    forever begin
      @(posedge clock);
      if (pipeline_notes_ready) $display("%p", pipeline_notes);
    end

  // trace
  initial begin
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd20, 7'd40};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd30, 7'd60};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd40, 7'd80};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd20, 7'd40};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd30, 7'd60};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd40, 7'd80};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    $finish;
  end

endmodule : PolyphonyTest2

module PolyphonyTest3 ();

  import MIDI::*;

  logic                     clock;
  logic                     reset_l;
  note_change_t             note;
  logic                     note_ready;
  note_change_t [      3:0] pipeline_notes;
  logic           [3:0]     pipeline_notes_ready;

  Polyphony dut (
      .clock_50_000_000(clock),
      .reset_l,
      .note,
      .note_ready,
      .pipeline_notes,
      .pipeline_notes_ready
  );

  // clock
  initial begin
    clock = 1'b0;
    forever #1 clock = ~clock;
  end

  // initialization
  initial begin
    reset_l <= 1'b0;
    @(posedge clock);
    reset_l <= 1'b1;
  end

  // display
  initial
    forever begin
      @(posedge clock);
      if (pipeline_notes_ready) $display("%p", pipeline_notes);
    end

  // trace
  initial begin
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd20, 7'd40};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd30, 7'd60};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd40, 7'd80};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    // does not play
    repeat (20) @(posedge clock);
    note       <= {ON, 7'd50, 7'd100};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    // does not play
    repeat (20) @(posedge clock);
    note       <= {ON, 7'd60, 7'd120};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd20, 7'd40};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd30, 7'd60};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd40, 7'd80};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    // no effect
    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd50, 7'd100};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    // no effect
    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd60, 7'd120};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    $finish;
  end

endmodule : PolyphonyTest3

module PolyphonyTest4 ();

  import MIDI::*;

  logic                     clock;
  logic                     reset_l;
  note_change_t             note;
  logic                     note_ready;
  note_change_t [      3:0] pipeline_notes;
  logic           [3:0]     pipeline_notes_ready;

  Polyphony dut (
      .clock_50_000_000(clock),
      .reset_l,
      .note,
      .note_ready,
      .pipeline_notes,
      .pipeline_notes_ready
  );

  // clock
  initial begin
    clock = 1'b0;
    forever #1 clock = ~clock;
  end

  // initialization
  initial begin
    reset_l <= 1'b0;
    @(posedge clock);
    reset_l <= 1'b1;
  end

  // display
  initial
    forever begin
      @(posedge clock);
      if (pipeline_notes_ready) $display("%p", pipeline_notes);
    end

  // trace
  initial begin
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd20, 7'd40};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd20, 7'd40};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd30, 7'd60};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd30, 7'd60};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd40, 7'd80};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd40, 7'd80};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd50, 7'd100};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd50, 7'd100};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    $finish;
  end
endmodule : PolyphonyTest4

module PolyphonyTest5 ();

  import MIDI::*;

  logic                     clock;
  logic                     reset_l;
  note_change_t             note;
  logic                     note_ready;
  note_change_t [      3:0] pipeline_notes;
  logic           [3:0]     pipeline_notes_ready;

  Polyphony dut (
      .clock_50_000_000(clock),
      .reset_l,
      .note,
      .note_ready,
      .pipeline_notes,
      .pipeline_notes_ready
  );

  // clock
  initial begin
    clock = 1'b0;
    forever #1 clock = ~clock;
  end

  // initialization
  initial begin
    reset_l <= 1'b0;
    @(posedge clock);
    reset_l <= 1'b1;
  end

  // display
  initial
    forever begin
      @(posedge clock);
      if (pipeline_notes_ready) $display("%p", pipeline_notes);
    end

  // trace
  initial begin
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd20, 7'd40};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd20, 7'd40};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd40, 7'd80};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd30, 7'd60};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd10, 7'd20};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {OFF, 7'd30, 7'd60};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd50, 7'd100};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd40, 7'd80};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    note       <= {ON, 7'd50, 7'd100};
    note_ready <= 1;
    @(posedge clock);
    note_ready <= 0;

    repeat (20) @(posedge clock);
    $finish;
  end

endmodule : PolyphonyTest5
