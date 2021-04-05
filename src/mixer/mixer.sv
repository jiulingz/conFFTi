`default_nettype none

`include "../includes/config.vh"

module Mixer
  import CONFIG::AUDIO_BIT_WIDTH;
#(
    parameter PIPELINE_COUNT = 4
) (
    input  logic [ PIPELINE_COUNT-1:0][AUDIO_BIT_WIDTH-1:0] pipeline_audios,
    output logic [AUDIO_BIT_WIDTH-1:0]                      audio_out
);

  localparam SUM_WIDTH = $clog2(PIPELINE_COUNT) + AUDIO_BIT_WIDTH;
  logic [SUM_WIDTH-1:0] sum;
  always_comb begin
    sum = '0;
    for (int i = 0; i < PIPELINE_COUNT; i++) sum += pipeline_audios[i];
  end

  // TODO (ck3) add master volume control
  assign audio_out = sum[SUM_WIDTH-1-:AUDIO_BIT_WIDTH];

endmodule : Mixer
