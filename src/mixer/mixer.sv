module mixer (
  input logic [23:0] pipe1, pipe2, pipe3, pipe4,
  output logic [23:0] mixer_output
);

  // TODO (ckpt2 integration): add volume control
  logic [25:0] temp_output;

  assign temp_output = pipe1 + pipe2 + pipe3 + pipe4;
  assign mixer_output = temp_output[25:2];

endmodule: mixer