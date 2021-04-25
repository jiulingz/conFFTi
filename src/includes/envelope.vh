`ifndef ENVELOPE_VH_
`define ENVELOPE_VH_

package ENVELOPE;

typedef enum logic [2:0] {
  IDLE    = 3'b000,
  ATTACK  = 3'b001,
  DELAY   = 3'b010,
  SUSTAIN = 3'b011,
  RELEASE = 3'b100
} envelope_state_t;

endpackage : ENVELOPE

`endif  /* ENVELOPE_VH_ */

