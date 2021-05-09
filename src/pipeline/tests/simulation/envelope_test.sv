`default_nettype none

`include "../../../includes/config.vh"
`include "../../../includes/parameter.vh"

module EnvelopeTest ();

  logic                  clock;
  logic                  reset_l;
  PARAMETER::parameter_t parameters;
  logic                  note_on;
  logic                  note_off;
  CONFIG::long_percent_t envelope;

  Envelope dut (
      .clock_50_000_000(clock),
      .reset_l,
      .parameters,
      .note_on,
      .note_off,
      .envelope
  );

  // clock
  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  // display
  initial begin
    @(posedge clock);
    forever begin
      @(posedge clock);
      $display("\t%p\t %0b", dut.state, envelope);
    end
  end

  initial begin
    reset_l                  <= 1'b0;
    parameters.attack_time   <= 'h5;
    parameters.decay_time    <= 'h5;
    parameters.sustain_level <= 'h10;
    parameters.release_time  <= 'h5;
    @(posedge clock);
    reset_l <= 1'b1;
    @(posedge clock);
    note_on <= 1'b1;
    @(posedge clock);
    note_on <= 1'b0;
    repeat (15) @(posedge clock);
    note_off <= 1'b1;
    @(posedge clock);
    note_off <= 1'b0;
  end

  // trace
  initial begin
    repeat (25) @(posedge clock);
    $finish;
  end

endmodule : EnvelopeTest
