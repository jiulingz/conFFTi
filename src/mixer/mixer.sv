module mixer (
  input logic [23:0] pipe1, pipe2, pipe3, pipe4,
  output logic [23:0] mixer_output
);

  // TODO (ckpt2 integration): add volume control
  mixer_output = (pipe1 >> 2) + (pipe2 >> 2) + (pipe3 >> 2) + (pipe4 >> 2);

endmodule: mixer