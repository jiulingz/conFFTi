module decoder_test;

  logic              clk, reset, ready;
  logic        [7:0] MIDIbyte;
  logic        [6:0] note, velocity;
  logic              note_event_ready, param_change_ready;
  note_en_t          note_event;

  // view this on waveform to validate test result
  logic        [3:0] paramIdx,
  wave_sel_t         wave_sel,
  pp_arp_sel_t       pipeline_mode,
  logic        [6:0] attack, delay, sustain, release, volume, unison_detune, tempo;

  decoder Decoder(.*);

  paramUpdater ParamUpdater(.*);

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // t1: PARAM_CHANGE
  // t2: NOTE_ON
  // t3: NOTE_OFF
  // t4: error after MIDI data byte I
  // t5: error after status byte
  // t6: status byte error
  initial begin
    reset <= 1'b1;
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    reset <= 1'b0;
    @(posedge clock);
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b11000000; // B0 got status
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'd21; // tempo
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b01100101; // param change
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b00000000; // idle
    @(posedge clock);
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b11000000; // B0 got status
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'd27; // sustain
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b01100111; // param change
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b11000000; // B0 got status
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b01000101; // 69
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b01101000; // param change
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b10010000; // 90 got status
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b01000101; // 69
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b01100111; // note on
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b10010000; // 90 got status
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b00000101; // 5
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b01111111; // note on
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b10000000; // 80 got status
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b00000101; // 5
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b00000000; // note off
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b10000000; // 80 got status
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b01000101; // 69
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b00000000; // note off
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b10000000; // 80 got status
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b00000101; // 5 data msg I
    @(posedge clock);
    MIDIbyte <= 7'b00000000; // idle
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b10000000; // 90 got status
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    ready <= 1'b1;
    MIDIbyte <= 7'b10000000; // 90 got status
    @(posedge clock);
    MIDIbyte <= 7'b00000000;
    @(posedge clock);
    @(posedge clock);
    @(posedge clock);
  $finish;
  end

endmodule: decoder_test