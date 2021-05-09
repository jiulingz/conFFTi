`ifndef CONFIG_VH_
`define CONFIG_VH_

package CONFIG;

  parameter SYSTEM_CLOCK = 50000000;  // 50 MHz
  parameter AUDIO_CLOCK = 16934400;  // 16.9344 MHz
  parameter AUDIO_GENERATION_FREQUENCY = 400000;  // 400 KHz

  parameter BYTE_WIDTH = 8;

  parameter AUDIO_BIT_WIDTH = 16;
  parameter AUDIO_SAMPLE_RATE = 44100;  // 44.1 KHz

  parameter PIPELINE_COUNT = 4;

  parameter PERCENT_WIDTH = 7;
  typedef logic [PERCENT_WIDTH-1:0] percent_t;
  localparam [PERCENT_WIDTH-1:0] PERCENT_MAX = '1;

  parameter LONG_PERCENT_WIDTH = 8;
  typedef logic [LONG_PERCENT_WIDTH-1:0] long_percent_t;
  localparam [LONG_PERCENT_WIDTH-1:0] LONG_PERCENT_MAX = '1;

  parameter DIVISION_WIDTH = 16;
  parameter [DIVISION_WIDTH-1:0] DIVISION_MAX = '1;

  parameter PERIOD_WIDTH = DIVISION_WIDTH;
  localparam [PERIOD_WIDTH-1:0] PERIOD_MAX = '1;
  localparam [PERIOD_WIDTH-1:0] PERIOD_MIN = '0;

  parameter DETUNE_SHIFTS = 2;  // symmetrical shifts increasing and decreasing period

  parameter NUM_WAVETABLES = 8;

  parameter ENVELOPE_MAX_TICKS = 2 * SYSTEM_CLOCK; // 2s

endpackage : CONFIG

`endif  /* CONFIG_VH_ */
