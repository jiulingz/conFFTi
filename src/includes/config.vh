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

  parameter AUDIO_GENERATION_FREQUENCY = 50000;  // 50 KHz
  parameter PERIOD_WIDTH = 11;  // 21 = $clog2(50,000 / 27.5), 27.5 = A0 frequency
  localparam logic [PERIOD_WIDTH-1:0] PERIOD_MAX = '1;
  localparam logic [PERIOD_WIDTH-1:0] PERIOD_MIN = '0;

  parameter DETUNE_SHIFTS = 2;  // symmetrical shifts increasing and decreasing period

  parameter NUM_WAVETABLES = 3;

endpackage : CONFIG

`endif  /* CONFIG_VH_ */
