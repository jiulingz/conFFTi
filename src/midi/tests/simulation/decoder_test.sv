module decoder_test;

  logic              clk, reset, ready;
  logic        [7:0] MIDIbyte;
  logic        [6:0] note, velocity;
  logic              note_event_ready, param_change_ready;
  note_en_t          note_event;

  // view this on waveform to validate test result
  logic        [3:0]     paramIdx;
  logic        [6:0]     a, d, s, r, volume, unison_detune, tempo;

  decoder Decoder(.*);

  paramUpdater ParamUpdater(.*);

  initial begin
    clk = 0;
    forever #1 clk = ~clk;
  end

  initial begin
    reset <= 1'b1;
    ready <= 1'b0;
    MIDIbyte <= 8'b00000000;
    repeat (20) @(posedge clk);
    reset <= 1'b0;
    repeat (20) @(posedge clk);
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b10110000; // param change
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 7'h15; // tempo
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b01100101; // tempo->65
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b0;
    MIDIbyte <= 8'b00000000;
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b10110000; // B0 got status
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 7'h1b; // release
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b01100111; // r->67
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b0;
    MIDIbyte <= 8'b00000000;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b10110000; // B0 got status
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'd104; // wave_sel 
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b01101000; // 68
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b0;
    MIDIbyte <= 8'b00000000;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b10010000; // 90 got status
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b01000101; // 69
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b01100111; // note on
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b0;
    MIDIbyte <= 8'b00000000;
    repeat (20) @(posedge clk);
    repeat (20) @(posedge clk);
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b10010000; // 90 got status
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b00000101; // 5
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b01111111; // note on
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b0;
    MIDIbyte <= 8'b00000000;
    repeat (20) @(posedge clk);
    repeat (20) @(posedge clk);
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b10000000; // 80 got status
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b00000101; // 
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b00000000; // note off
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b0;
    MIDIbyte <= 8'b00000000;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b10000000; // 80 got status
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b01000101; // 69
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    ready <= 1'b1;
    MIDIbyte <= 8'b00000000; // note off
    @(posedge clk);
    ready <= 1'b0;
    repeat (20) @(posedge clk);
    repeat (20) @(posedge clk);
    repeat (20) @(posedge clk);
  $finish;
  end

endmodule: decoder_test