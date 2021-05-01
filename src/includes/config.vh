`ifndef CONFIG_VH_
`define CONFIG_VH_

package CONFIG;

  parameter SYSTEM_CLOCK = 50000000;  // 50 MHz
  parameter AUDIO_CLOCK = 16934400;  // 16.9344 MHz

  parameter BYTE_WIDTH = 8;

  parameter AUDIO_BIT_WIDTH = 24;
  parameter AUDIO_SAMPLE_RATE = 44100;  // 44.1 KHz

  parameter PIPELINE_COUNT = 4;

  parameter PERCENT_WIDTH = 7;
  typedef logic [PERCENT_WIDTH-1:0] percent_t;
  parameter LONG_PERCENT_WIDTH = 8;
  typedef logic [LONG_PERCENT_WIDTH-1:0] long_percent_t;

  parameter AUDIO_GENERATION_FREQUENCY = 400000;
  parameter PERIOD_WIDTH = 16; // 21 = $clog2(50,000 / 27.5), 27.5 = A0 frequency

  parameter MAX_TARGET_TICKS = 400000; // 1s => 400000 audio clock clicks
  parameter ENVELOPE_COUNTER_WIDTH = 19; // $clog2(400,000)
  parameter ENVELOPE_PUSH_BITS = 8;
  parameter ENVELOPE_CEILING = 19'h7ffff;
  parameter PARAM_CEILING = 'h7f;
  
endpackage : CONFIG

`endif  /* CONFIG_VH_ */
