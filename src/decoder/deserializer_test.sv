`default_nettype none

module top (
  input  logic        CLOCK_50
);
  logic clock, reset, serialOut, isNew;
  logic [7:0] messageByte;

  sender S(.*);
  deserializer R(
    .rx(GPIO[0]),
    .clock(CLOCK_50),
    .reset,
    .ready(isNew),
    .MIDIbyte(messageByte)
  );
  
  initial begin
    clock = 0;
    forever #1600 clock = ~clock;

  end

  initial begin
    while(1) begin
      #400 if (isNew)
            $display($time,, 
                     "in:%b ", serialOut, 
                     "cur_s:%s ", R.c_state,
                     "n_s:%s ", R.n_state,
                     "bitcnt:%b ", R.readBits,
                     "clockFinish:%b ", R.clockFinish,
                     "out: %c/%b", messageByte, messageByte);

    end
  end

  initial begin
    reset <= 1'b1;
    @(posedge clock);
    reset <= 1'b0;
    #100000
  $finish;
  end

endmodule: top