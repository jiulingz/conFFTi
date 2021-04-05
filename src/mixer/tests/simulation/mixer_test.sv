`default_nettype none

module MixerTest ();

  logic [ 3:0][23:0] pipeline_audios;
  logic [23:0]       audio_out;

  Mixer dut (
      .pipeline_audios,
      .audio_out
  );

  initial begin
    $monitor("\t%p, %p", pipeline_audios, audio_out);

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
