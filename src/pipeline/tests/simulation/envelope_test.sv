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
  ENVELOPE::envelope_state_t                                       state;
  logic                  [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0]      count;

  logic [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0] attack_target;
  logic [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0] decay_target;
  logic [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0] release_target;
  logic [CONFIG::ENVELOPE_COUNTER_WIDTH-1:0] quotient;

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
    $display("\t%s\t\t%s\t%s\t%s\t%s\t%s", "envelope", "envelope_end", "note_on", "state", "count", "quotient");
    $monitor("\t%b\t%b\t%b\t%s\t%d\t%d", envelope, envelope_end, note_on, state, count, quotient);
    // $display("\t%s\t\t%s\t%s\t%s", "envelope", "envelope_end", "note_on", "state");
    // $monitor("\t%b\t%b\t%b\t%s", envelope, envelope_end, note_on, state);
    @(posedge clock);
    parameters.attack_time <= 'h7A;
    parameters.decay_time <= 'h7A;
    parameters.sustain_level <= 'h6F;
    parameters.release_time <= 'h3;
    @(posedge clock);
    reset_l    <= 1'b0;
    @(posedge clock);
    reset_l    <= 1'b1;
    @(posedge clock);
    note_on    <= 1'b1;
    @(posedge clock);
    note_on    <= 1'b0;
    repeat (50000) @(posedge clock);
    note_off   <= 1'b1;
    @(posedge clock);
    note_off   <= 1'b0;
    repeat (25000) @(posedge clock);
    $display("\t%d\t%d\t%d\t%d", attack_target, decay_target, release_target, quotient);
    $finish;
  end

endmodule : EnvelopeTest
