`default_nettype none

`include "../includes/parameter.vh"
`include "../includes/midi.vh"

module ParameterControl (
    input  logic                         clock_50_000_000,
    input  logic                         reset_l,
    input  MIDI::message_t               message,
    input  logic                         message_ready,
    output PARAMETER::parameter_t        parameters,
    output PARAMETER::parameter_change_t parameter_changes
);
  import MIDI::*;
  import PARAMETER::*;

  control_change_t control_change;
  assign control_change = {message.data_byte1, message.data_byte2};

  // TODO: (jiulingz) add arpegiator parameter
  always_ff @(posedge clock_50_000_000, negedge reset_l) begin
    if (!reset_l) begin
      parameters        <= DEFAULT_PARAMETERS;
      parameter_changes <= PARAM_NONE;
    end else if (message_ready) begin
      unique case (message.message_type)
        CONTROL_CHANGE: begin
          unique case (control_change.controller_number)
            TEMPO: begin
              parameters.tempo  <= control_change.value;
              parameter_changes <= PARAM_TEMPO;
            end
            UNISON: begin
              parameters.unison_detune <= control_change.value;
              parameter_changes        <= PARAM_UNISON_DETUNE;
            end
            DUTY_CYCLE: begin
              parameters.duty_cycle <= control_change.value;
              parameter_changes        <= PARAM_DUTY_CYCLE;
            end
            ATTACK: begin
              parameters.attack_time <= control_change.value;
              parameter_changes      <= PARAM_ATTACK_TIME;
            end
            DECAY: begin
              parameters.decay_time <= control_change.value;
              parameter_changes     <= PARAM_DECAY_TIME;
            end
            SUSTAIN: begin
              parameters.sustain_level <= control_change.value;
              parameter_changes        <= PARAM_SUSTAIN_LEVEL;
            end
            RELEASE: begin
              parameters.release_time <= control_change.value;
              parameter_changes       <= PARAM_RELEASE_TIME;
            end
            VOLUME: begin
              parameters.volume <= control_change.value;
              parameter_changes <= PARAM_VOLUME;
            end
            default: begin
              parameters        <= parameters;
              parameter_changes <= PARAM_NONE;
            end
          endcase
        end
        default: begin
          parameters        <= parameters;
          parameter_changes <= PARAM_NONE;
        end
      endcase
    end
  end

endmodule : ParameterControl
