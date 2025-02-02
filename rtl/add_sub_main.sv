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

import global_params::*;

module add_sub_main #(parameter WIDTH = 32)(
    logic input  [WIDTH-1:0] a,b,
    logic operation_select,
    logic input clk,
    logic output [WIDTH-1:0] result,
    logic output sign_a, sign_b, sign_result,
    logic output [MANT_BITS-1:0] mantissa_a, mantissa_b, mantissa_result,
    logic output [EXP_BITS-1:0] exp_a, exp_b, exp_result,
    logic output a_greater
);

    logic carry_out;
    logic [4:0] shift_spaces;
    logic [MANT_BITS+3:0] mantissa_a_shifted, mantissa_b_shifted, mantissa_result_shifted;

    //Separate sign, exponent and mantissa values for both inputs
    assign mantissa_a = a[22:0];
    assign exp_a = a[30:23];
    assign sign_a = a[31];
        
    assign mantissa_b = b[22:0];
    assign exp_b = b[30:23];
    assign sign_b = b[31];

    sign_logic #(WIDTH) sign_ins #(.WIDTH(WIDTH)) ( 
        .X(a),
        .Y(b),
        .operation_select(operation_select)
    );


    exponent_sub_upd #(EXP_WIDTH) exp_ins #(.EXP_WIDTH(EXP_BITS)) ( 
        .exp_a(exp_a),
        .exp_b(exp_b),
        .a_greater(a_greater),                  // Only 2 bits for the magnitude signal
        .a_equal(),                             // I made some changes to the module: input[] instead of logic
        .shift_spaces(shift_spaces)
    );

    mantissa_shifter #(MANTISSA_WIDTH) mantissa_shifter_ins #(.MANTISSA_WIDTH(MANT_BITS)) ( 
        .ma(mantissa_s),
        .mb(mantissa_b),
        .shift_spaces(shift_spaces),
        .exp_magnitude(exp_disc),
        .mantissa_a(mantissa_a_shifted),
        .mantissa_b(mantissa_b_shifted)
    );

    mantissa_add_sub #(MANTISSA_WIDTH) mantissa_add_sub_ins #(.MANTISSA_WIDTH(MANT_BITS)) ( 
        .ma(mantissa_a_shifted),
        .mb(mantissa_b_shifted),
        .ma_sign(sign_a),
        .mb_sign(sign_b),
        .operation_select(operation_select),
        .result(mantissa_result_shifted),
        .carry_out(carry_out)
    );

    normalize_rounder #(WIDTH) nr_inst #(.WIDTH(WIDTH)) ( 
        .result_mant(mantissa_result_shifted),      
        .exp_result(exp_result),
        .R(mantissa_result)
    );
    
endmodule
