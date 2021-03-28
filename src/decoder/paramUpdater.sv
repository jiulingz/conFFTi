`default_nettype none

`include "internal_defines.vh"

// TODO(chkpt 3): add arpeggiator mode, rate and rhythm info parsing
module paramUpdater (
  input  logic             clk,
  input  logic             param_change_ready,
  input  logic       [6:0] note,
  input  logic       [6:0] velocity,
  output logic       [3:0] paramIdx, // between 0-8, indicates which param is updated
  output logic       [6:0] a, // paramIdx: 2
  output logic       [6:0] d, // paramIdx: 3
  output logic       [6:0] s, // paramIdx: 4
  output logic       [6:0] r, // paramIdx: 5
  output logic       [6:0] volume, // paramIdx: 6
  output logic       [6:0] unison_detune, // paramIdx: 7
  output logic       [6:0] tempo // paramIdx: 8
);

  always_ff @(posedge clk) begin
    if (param_change_ready == 1'b1) begin
      case (note)
        7'd104: begin
          if (velocity != 7'd0) begin
            paramIdx <= 4'd0;
          end
        end
        7'd115: begin
          if (velocity != 7'd0) begin
            paramIdx <= 4'd1;
          end
        end
        7'd24: begin
          a <= note;
          paramIdx <= 4'd2;
        end
        7'd25: begin
          d <= note;
          paramIdx <= 4'd3;
        end
        7'd26: begin
          s <= note;
          paramIdx <= 4'd4;
        end
        7'd27: begin
          r <= note;
          paramIdx <= 4'd5;
        end
        7'd28: begin
          volume <= note;
          paramIdx <= 4'd6;
        end
        7'd22: begin
          unison_detune <= note;
          paramIdx <= 4'd7;
        end
        7'd21: begin
          tempo <= note;
          paramIdx <= 4'd8;
        end
        default: begin
          paramIdx <= 4'dx;
        end
      endcase
    end
    else paramIdx <= 4'dx;
  end

endmodule: paramUpdater