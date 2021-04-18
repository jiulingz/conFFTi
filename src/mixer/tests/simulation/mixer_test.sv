`default_nettype none

module MixerTest ();

  logic [ 3:0][23:0] pipeline_audios;
  logic [23:0]       audio_out;
  PARAMETER::parameter_t parameters;

  Mixer dut (
      .pipeline_audios,
      .parameters,
      .audio_out
  );

  initial begin
    $monitor("\t%p, %p, %p", pipeline_audios, audio_out, parameters.volume);

    parameters.volume = 127;
    pipeline_audios = {24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF};
    #10;
    pipeline_audios = {24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFC};
    #10;
    pipeline_audios = {24'h3FFFFF, 24'h3FFFFF, 24'h3FFFFF, 24'h3FFFFF};
    #10;
    pipeline_audios = {24'h00FFFF, 24'h00FFF, 24'h00FFF, 24'h00FFF};
    #10;
    pipeline_audios = {24'h3, 24'h1, 24'h2, 24'h0};
    #10;
    pipeline_audios = {24'hF, 24'hF, 24'hF, 24'hF};

    parameters.volume = 64;
    pipeline_audios = {24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF};
    #10;
    pipeline_audios = {24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFC};
    #10;
    pipeline_audios = {24'h3FFFFF, 24'h3FFFFF, 24'h3FFFFF, 24'h3FFFFF};
    #10;
    pipeline_audios = {24'h00FFFF, 24'h00FFF, 24'h00FFF, 24'h00FFF};
    #10;
    pipeline_audios = {24'h3, 24'h1, 24'h2, 24'h0};
    #10;
    pipeline_audios = {24'hF, 24'hF, 24'hF, 24'hF};
    #10;

    parameters.volume = 0;
    pipeline_audios = {24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF};
    #10;
    pipeline_audios = {24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFF, 24'hFFFFFC};
    #10;
    pipeline_audios = {24'h3FFFFF, 24'h3FFFFF, 24'h3FFFFF, 24'h3FFFFF};
    #10;
    pipeline_audios = {24'h00FFFF, 24'h00FFF, 24'h00FFF, 24'h00FFF};
    #10;
    pipeline_audios = {24'h3, 24'h1, 24'h2, 24'h0};
    #10;
    pipeline_audios = {24'hF, 24'hF, 24'hF, 24'hF};
    #10;
    $finish;
  end

endmodule : MixerTest
