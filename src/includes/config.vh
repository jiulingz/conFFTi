`ifndef CONFIG_VH_
`define CONFIG_VH_

package CONFIG;

  parameter SYSTEM_CLOCK = 50000000;  // 50 MHz
  parameter AUDIO_CLOCK = 16934400;  // 16.9344 MHz

  parameter BYTE_WIDTH = 8;

  parameter AUDIO_BIT_WIDTH = 24;
  parameter AUDIO_SAMPLE_RATE = 44100;  // 44.1 KHz

  parameter PIPELINE_COUNT = 4;

endpackage : CONFIG

`endif  /* CONFIG_VH_ */
