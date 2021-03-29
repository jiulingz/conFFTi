module mixer_test ();

  logic [23:0] pipe1, pipe2, pipe3, pipe4, mixer_output;

  mixer Mixer (.*);

  initial begin
    $monitor($time, " pipe1=%b, pipe2=%b, pipe3=%b, pipe4=%b, mixer_output=%b");

    #10 pipe1 = 24'h3FFFFF;
    pipe2 = 24'h3FFFFF;
    pipe3 = 24'h3FFFFF;
    pipe4 = 24'h3FFFFF;

    #10 pipe1 = 24'h00FFFF;
    pipe2 = 24'h00FFF;
    pipe3 = 24'h00FFF;
    pipe4 = 24'h00FFF;

    #10 pipe1 = 24'h3;
    pipe2 = 24'h1;
    pipe3 = 24'h2;
    pipe4 = 24'h0;

    #10 pipe1 = 24'hF;
    pipe2 = 24'hF;
    pipe3 = 24'hF;
    pipe4 = 24'hF;

  end

endmodule: mixer_test