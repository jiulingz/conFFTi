`default_nettype none

`include "../includes/parameter.vh"
`include "../includes/midi.vh"

module ParameterControl (
    input  logic                  clock_50_000_000,
    input  logic                  reset_l,
    input  MIDI::message_t        message,
    output PARAMETER::parameter_t parameters
);
  import MIDI::*;
  import PARAMETER::*;

  control_change_t control_change;
  assign control_change = {message.data_byte1, message.data_byte2};

  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      parameters <= '0;
    end else begin
      unique case (message.message_type)
        CONTROL_CHANGE: begin
          unique case (control_change.controller_number)
            TEMPO:   parameters.tempo <= control_change.value;
            UNISON:  parameters.unison_detune <= control_change.value;
            ATTACK:  parameters.attack_time <= control_change.value;
            DECAY:   parameters.decay_time <= control_change.value;
            SUSTAIN: parameters.sustain_level <= control_change.value;
            RELEASE: parameters.release_time <= control_change.value;
            VOLUME:  parameters.volume <= control_change.value;
            default: parameters <= parameters;
          endcase
        end
        default: parameters <= parameters;
      endcase
    end
  end

endmodule : ParameterControl
