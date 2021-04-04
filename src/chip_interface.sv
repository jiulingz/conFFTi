module ChipInterface (
    // CLOCK
    input  logic        CLOCK_50,
    // LED
    output logic [ 8:0] LEDG,
    output logic [17:0] LEDR,
    // KEY
    input  logic [ 3:0] KEY,
    // SW
    input  logic [17:0] SW,
    // SEG7
    output logic [ 6:0] HEX7,
    output logic [ 6:0] HEX6,
    output logic [ 6:0] HEX5,
    output logic [ 6:0] HEX4,
    output logic [ 6:0] HEX3,
    output logic [ 6:0] HEX2,
    output logic [ 6:0] HEX1,
    output logic [ 6:0] HEX0,
    // GPIO
    inout logic [35:0] GPIO
);

endmodule