/*
Alex Yazdani
18 November 2024
4-bit Ripple Carry Adder

Inputs:
    A (4 bits): First operand
    B (4 bits): Second operand
    Cin (1 bit): Carry-in

Outputs:
    Sum (4 bits): Result of A + B + Cin
    Cout (1 bit): Carry-out of the most significant bit
*/

module ripple_carry_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire c1, c2, c3; // Internal carry signals

    // Full Adder for bit 0
    full_adder FA0 (
        .a(A[0]),
        .b(B[0]),
        .cin(Cin),
        .sum(Sum[0]),
        .cout(c1)
    );

    // Full Adder for bit 1
    full_adder FA1 (
        .a(A[1]),
        .b(B[1]),
        .cin(c1),
        .sum(Sum[1]),
        .cout(c2)
    );

    // Full Adder for bit 2
    full_adder FA2 (
        .a(A[2]),
        .b(B[2]),
        .cin(c2),
        .sum(Sum[2]),
        .cout(c3)
    );

    // Full Adder for bit 3
    full_adder FA3 (
        .a(A[3]),
        .b(B[3]),
        .cin(c3),
        .sum(Sum[3]),
        .cout(Cout)
    );

endmodule

// Full Adder Module
module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign sum = a ^ b ^ cin; // XOR for sum
    assign cout = (a & b) | (b & cin) | (a & cin); // Carry-out logic

endmodule
