`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cinvestav
// Engineer: Daniel, Lino, Kevin, Emmanuel
// 
// Create Date: 22.01.2025 12:31:55
// Design Name: Floating Point Adder and Subctractor
// Module Name: add_sub
// Project Name: Floating Point Adder and Subctractor
// Target Devices: 
// Tool Versions: 
// Description: Adds and subtracts two inputs and delivers one outup following IEEE 754 format
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 											Just testing the git commits
//
//////////////////////////////////////////////////////////////////////////////////
localparam EXP_BITS = 8;
localparam MANT_BITS = 23;

module add_sub_main #(parameter WIDTH = 32)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input operation_select,
    input clk,
    output [WIDTH-1:0] result,
    output sign_a, 
    output sign_b, 
    output sign_result,
    output [MANT_BITS-1:0] mantissa_a, 
    output [MANT_BITS-1:0] mantissa_b, 
    output [MANT_BITS-1:0] mantissa_result,
    output [EXP_BITS-1:0] exp_a, 
    output [EXP_BITS-1:0] exp_b, 
    output [EXP_BITS-1:0] exp_result
);

    // import global_params::*;

    wire a_greater;
    wire carry_out;
    wire [4:0] shift_spaces;
    wire [MANT_BITS+3:0] mantissa_a_shifted;
    wire [MANT_BITS+3:0] mantissa_b_shifted; 
    wire [MANT_BITS+3:0] mantissa_result_shifted;

    //Separate sign, exponent and mantissa values for both inputs
    assign mantissa_a = a[22:0];
    assign exp_a = a[30:23];
    assign sign_a = a[31];
        
    assign mantissa_b = b[22:0];
    assign exp_b = b[30:23];
    assign sign_b = b[31];

    sign_logic #(WIDTH) sign_ins ( 
        .x(a),
        .y(b),
        .operation_select(operation_select)
    );


    exponent_sub_upd #(.EXP_WIDTH(EXP_BITS)) exp_ins  ( 
        .exp_a(exp_a),
        .exp_b(exp_b),
        // .a_greater(a_greater),                  // Only 2 bits for the magnitude signal
        // .a_equal(),                             // I made some changes to the module: input[] instead of logic
       .sign_a(sign_a),
       .sign_b(sign_b),
        .shift_spaces(shift_spaces)
    );

    mantissa_shifter #(.MANTISSA_WIDTH(MANT_BITS)) mantissa_shifter_ins ( 
        .ma(mantissa_s),
        .mb(mantissa_b),
        .shift_spaces(shift_spaces),
        .exp_magnitude(exp_disc),
        .mantissa_a(mantissa_a_shifted),
        .mantissa_b(mantissa_b_shifted)
    );

    mantissa_add_sub #(.MANTISSA_WIDTH(MANT_BITS)) mantissa_add_sub_ins ( 
        .ma(mantissa_a_shifted),
        .mb(mantissa_b_shifted),
        .ma_sign(sign_a),
        .mb_sign(sign_b),
        .operation_select(operation_select),
        .result(mantissa_result_shifted),
        .carry_out(carry_out)
    );

    normalize_rounder #(.WIDTH(WIDTH)) nr_inst ( 
        .result_mant(mantissa_result_shifted),      
        .exp_result(exp_result),
        .R(mantissa_result)
    );
    
endmodule
