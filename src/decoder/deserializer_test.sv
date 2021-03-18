`default_nettype none

module top ();

  logic clock, clock50, reset, serialOut, isNew;
  logic [7:0] messageByte;

  sender S(.*);
  deserializer R(
    .rx(serialOut),
    .clock(clock50),
    .reset,
    .ready(isNew),
    .MIDIbyte(messageByte)
  );
  
  initial begin
    clock = 0;
    forever #1600 clock = ~clock;
  end

  initial begin
    clock50 = 0;
    forever #1 clock50 = ~clock50;
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
    #10000000
  $finish;
  end

endmodule: top