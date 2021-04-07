`default_nettype none

`include "../includes/config.vh"

module Mixer
  import CONFIG::AUDIO_BIT_WIDTH;
#(
    parameter PIPELINE_COUNT = 4
) (
    input  PARAMETER::parameter_t                                            parameters,
    input  logic                  [ PIPELINE_COUNT-1:0][AUDIO_BIT_WIDTH-1:0] pipeline_audios,
    output logic                  [AUDIO_BIT_WIDTH-1:0]                      audio_out
);

  localparam SUM_WIDTH = $clog2(PIPELINE_COUNT) + AUDIO_BIT_WIDTH;
  logic [SUM_WIDTH-1:0] sum;
  always_comb begin
    sum = '0;
    for (int i = 0; i < PIPELINE_COUNT; i++) sum += pipeline_audios[i];
  end

  logic [AUDIO_BIT_WIDTH+CONFIG::PERCENT_WIDTH-1:0] high_precision;
  assign high_precision = sum[SUM_WIDTH-1-:AUDIO_BIT_WIDTH] * parameters.volume;
  assign audio_out      = high_precision >> CONFIG::PERCENT_WIDTH;

endmodule : Mixer
