`default_nettype none

`include "../internal_defines.vh"

module clock (
    output logic clk
);
  initial begin
    clk = 1'b0;
    forever #1 clk = ~clk;
  end
endmodule

module pc_test1 ();
  import conFFTi::*;

  logic                input_en;
  logic                clk;
  logic                reset;
  note_en_t            note_in_en;
  logic     [6:0]      note_in;
  logic     [6:0]      velocity_in;
  logic     [3:0]      notes_out_en;
  logic     [3:0][6:0] notes_out;
  logic     [3:0][6:0] velocities_out;

  clock c (.clk);
  PolyphonyControl dut (
      .input_en,
      .clk,
      .reset,
      .note_in_en,
      .note_in,
      .velocity_in,
      .notes_out_en,
      .notes_out,
      .velocities_out
  );

  initial begin
    $display(
        "\tinput_en | note_in_en | note_in | velocity_in | notes_out_en |       notes_out |  velocities_out");
    $monitor(
        "\t       %b |          %b |     %03d |         %03d |   %b  %b  %b  %b | %03d %03d %03d %03d | %03d %03d %03d %03d",
        input_en, note_in_en, note_in, velocity_in, notes_out_en[3], notes_out_en[2],
        notes_out_en[1], notes_out_en[0], notes_out[3], notes_out[2], notes_out[1], notes_out[0],
        velocities_out[3], velocities_out[2], velocities_out[1], velocities_out[0]);
    input_en = 0;
    reset    = 1;
    #1.5 reset = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 10;
    velocity_in = 125;
    #10 input_en = 0;

    #10 $finish;
  end
endmodule

module pc_test2 ();
  import conFFTi::*;

  logic                input_en;
  logic                clk;
  logic                reset;
  note_en_t            note_in_en;
  logic     [6:0]      note_in;
  logic     [6:0]      velocity_in;
  logic     [3:0]      notes_out_en;
  logic     [3:0][6:0] notes_out;
  logic     [3:0][6:0] velocities_out;

  clock c (.clk);
  PolyphonyControl dut (
      .input_en,
      .clk,
      .reset,
      .note_in_en,
      .note_in,
      .velocity_in,
      .notes_out_en,
      .notes_out,
      .velocities_out
  );

  initial begin
    $display(
        "\tinput_en | note_in_en | note_in | velocity_in | notes_out_en |       notes_out |  velocities_out");
    $monitor(
        "\t       %b |          %b |     %03d |         %03d |   %b  %b  %b  %b | %03d %03d %03d %03d | %03d %03d %03d %03d",
        input_en, note_in_en, note_in, velocity_in, notes_out_en[3], notes_out_en[2],
        notes_out_en[1], notes_out_en[0], notes_out[3], notes_out[2], notes_out[1], notes_out[0],
        velocities_out[3], velocities_out[2], velocities_out[1], velocities_out[0]);
    input_en = 0;
    reset    = 1;
    #1.5 reset = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 20;
    velocity_in = 40;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 30;
    velocity_in = 60;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 40;
    velocity_in = 80;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 20;
    velocity_in = 40;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 30;
    velocity_in = 60;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 40;
    velocity_in = 80;
    #10 input_en = 0;

    #10 $finish;
  end
endmodule

module pc_test3 ();
  import conFFTi::*;

  logic                input_en;
  logic                clk;
  logic                reset;
  note_en_t            note_in_en;
  logic     [6:0]      note_in;
  logic     [6:0]      velocity_in;
  logic     [3:0]      notes_out_en;
  logic     [3:0][6:0] notes_out;
  logic     [3:0][6:0] velocities_out;

  clock c (.clk);
  PolyphonyControl dut (
      .input_en,
      .clk,
      .reset,
      .note_in_en,
      .note_in,
      .velocity_in,
      .notes_out_en,
      .notes_out,
      .velocities_out
  );

  initial begin
    $display(
        "\tinput_en | note_in_en | note_in | velocity_in | notes_out_en |       notes_out |  velocities_out");
    $monitor(
        "\t       %b |          %b |     %03d |         %03d |   %b  %b  %b  %b | %03d %03d %03d %03d | %03d %03d %03d %03d",
        input_en, note_in_en, note_in, velocity_in, notes_out_en[3], notes_out_en[2],
        notes_out_en[1], notes_out_en[0], notes_out[3], notes_out[2], notes_out[1], notes_out[0],
        velocities_out[3], velocities_out[2], velocities_out[1], velocities_out[0]);
    input_en = 0;
    reset    = 1;
    #1.5 reset = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 20;
    velocity_in = 40;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 30;
    velocity_in = 60;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 40;
    velocity_in = 80;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 50;
    velocity_in = 100;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 20;
    velocity_in = 40;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 30;
    velocity_in = 60;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 40;
    velocity_in = 80;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 50;
    velocity_in = 100;
    #10 input_en = 0;

    #10 $finish;
  end
endmodule

module pc_test4 ();
  import conFFTi::*;

  logic                input_en;
  logic                clk;
  logic                reset;
  note_en_t            note_in_en;
  logic     [6:0]      note_in;
  logic     [6:0]      velocity_in;
  logic     [3:0]      notes_out_en;
  logic     [3:0][6:0] notes_out;
  logic     [3:0][6:0] velocities_out;

  clock c (.clk);
  PolyphonyControl dut (
      .input_en,
      .clk,
      .reset,
      .note_in_en,
      .note_in,
      .velocity_in,
      .notes_out_en,
      .notes_out,
      .velocities_out
  );

  initial begin
    $display(
        "\tinput_en | note_in_en | note_in | velocity_in | notes_out_en |       notes_out |  velocities_out");
    $monitor(
        "\t       %b |          %b |     %03d |         %03d |   %b  %b  %b  %b | %03d %03d %03d %03d | %03d %03d %03d %03d",
        input_en, note_in_en, note_in, velocity_in, notes_out_en[3], notes_out_en[2],
        notes_out_en[1], notes_out_en[0], notes_out[3], notes_out[2], notes_out[1], notes_out[0],
        velocities_out[3], velocities_out[2], velocities_out[1], velocities_out[0]);
    input_en = 0;
    reset    = 1;
    #1.5 reset = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 20;
    velocity_in = 40;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 20;
    velocity_in = 40;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 30;
    velocity_in = 60;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 30;
    velocity_in = 60;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 40;
    velocity_in = 80;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 40;
    velocity_in = 80;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 50;
    velocity_in = 100;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 50;
    velocity_in = 100;
    #10 input_en = 0;

    #10 $finish;
  end
endmodule

module pc_test5 ();
  import conFFTi::*;

  logic                input_en;
  logic                clk;
  logic                reset;
  note_en_t            note_in_en;
  logic     [6:0]      note_in;
  logic     [6:0]      velocity_in;
  logic     [3:0]      notes_out_en;
  logic     [3:0][6:0] notes_out;
  logic     [3:0][6:0] velocities_out;

  clock c (.clk);
  PolyphonyControl dut (
      .input_en,
      .clk,
      .reset,
      .note_in_en,
      .note_in,
      .velocity_in,
      .notes_out_en,
      .notes_out,
      .velocities_out
  );

  initial begin
    $display(
        "\tinput_en | note_in_en | note_in | velocity_in | notes_out_en |       notes_out |  velocities_out");
    $monitor(
        "\t       %b |          %b |     %03d |         %03d |   %b  %b  %b  %b | %03d %03d %03d %03d | %03d %03d %03d %03d",
        input_en, note_in_en, note_in, velocity_in, notes_out_en[3], notes_out_en[2],
        notes_out_en[1], notes_out_en[0], notes_out[3], notes_out[2], notes_out[1], notes_out[0],
        velocities_out[3], velocities_out[2], velocities_out[1], velocities_out[0]);
    input_en = 0;
    reset    = 1;
    #1.5 reset = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 20;
    velocity_in = 40;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 20;
    velocity_in = 40;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 40;
    velocity_in = 80;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 30;
    velocity_in = 60;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 10;
    velocity_in = 20;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 30;
    velocity_in = 60;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = ON;
    note_in     = 50;
    velocity_in = 100;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 40;
    velocity_in = 80;
    #10 input_en = 0;

    #10 input_en = 1;
    note_in_en  = OFF;
    note_in     = 50;
    velocity_in = 100;
    #10 input_en = 0;

    #10 $finish;
  end
endmodule
