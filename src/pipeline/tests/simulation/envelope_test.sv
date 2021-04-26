`default_nettype none

`include "../../../includes/config.vh"
`include "../../../includes/envelope.vh"
`include "../../../includes/parameter.vh"

module EnvelopeTest ();

  logic                                                            clock;
  logic                                                            reset_l;
  PARAMETER::parameter_t                                           parameters;
  logic                                                            note_on, note_off;
  logic                  [CONFIG::AUDIO_BIT_WIDTH-1:0]             envelope;
  logic                                                            envelope_end;

  Envelope dut (
    .clock_50_000_000(clock),
    .*
  );

  // clock
  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  initial begin
    $display("\t%s\t\t%s\t%s", "envelope", "envelope_end", "note_on");
    $monitor("\t%b\t%b\t%b", envelope, envelope_end, note_on);
    @(posedge clock);
    parameters.attack_time <= 'h7;
    parameters.decay_time <= 'hA;
    parameters.sustain_level <= 'h7;
    parameters.release_time <= 'h2;
    @(posedge clock);
    reset_l    <= 1'b0;
    @(posedge clock);
    reset_l    <= 1'b1;
    @(posedge clock);
    note_on    <= 1'b1;
    @(posedge clock);
    note_on    <= 1'b0;
    repeat (30000000) @(posedge clock);
    note_off   <= 1'b1;
    @(posedge clock);
    note_off   <= 1'b0;
    repeat (2500000) @(posedge clock);
    $finish;
  end

endmodule : EnvelopeTest
