`default_nettype none

`include "../../../includes/config.vh"
`include "../../../includes/oscillator.vh"

module EnvelopeTest ();

  logic                                                   clock;
  logic                                                   reset_l;
  PARAMETER::parameter_t                                  parameters;
  logic                                                   note_on, note_off;
  logic                  [CONFIG::AUDIO_BIT_WIDTH-1:0]    envelope;
  logic                                                   envelope_end;

  parameters.attack_time = 'h2A;
  parameters.decay_time = 'h2B;
  parameters.sustain_level = 'h6F;
  parameters.release_time = 'h2F;

  Envelope dut (
    .clock_50_000_000(clock),
    .reset_l,
    .parameters,
    .note_on,
    .note_off,
    .envelope,
    .envelope_end
  );

  // clock
  initial begin
    clock = 0;
    forever #1 clock = ~clock;
  end

  initial begin
    $monitor("\t%b\t%b", envelope, envelope_end);
    clear      <= 1'b0;
    reset_l    <= 1'b1;
    @(posedge clock);
    reset_l    <= 1'b0;
    note_on    <= 1'b1;
    @(posedge clock);
    note_on    <= 1'b0;
    #500 @(posedge clock);
    note_off   <= 1'b1;
    @(posedge clock);
    note_off   <= 1'b0;
    #100
  end

endmodule : EnvelopeTest
