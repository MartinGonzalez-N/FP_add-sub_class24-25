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
// 
//////////////////////////////////////////////////////////////////////////////////

import GlobalParams::*;

module add_sub_main #(parameter WIDTH = 32)(
    input  [WIDTH-1:0] a,b,
    input bit operation_select,
    input clk,
    output [WIDTH-1:0] result,
    output sign_a, sign_b, sign_result,
    output [MANT_BITS-1:0] mantissa_a, mantissa_b, mantissa_result,
    output [EXP_BITS-1:0] exp_a, exp_b, exp_result,
    output a_greater,
    wire [4:0] shift_spaces,
    wire [MANT_BITS+3:0] mantissa_a_shifted, mantissa_b_shifted, mantissa_result_shifted
);

    reg carry_out;

    //Separate sign, exponent and mantissa values for both inputs
    assign mantissa_a = a[22:0];
    assign exp_a = a[30:23];
    assign sign_a = a[31];
        
    assign mantissa_b = b[22:0];
    assign exp_b = b[30:23];
    assign sign_b = b[31];

    sign_logic sign_ins(.WIDTH(WIDTH))(
        .X(a),
        .Y(b),
        .operation_select(operation_select),
    );


    exponent_sub_upd exp_ins(.EXP_WIDTH(EXP_BITS))(
        .exp_a(exp_a),
        .exp_b(exp_b),
        .a_greater(a_greater),                  // Only 2 bits for the magnitude signal
        .a_equal(),                             // I made some changes to the module: input[] instead of logic
        .shift_spaces(shift_spaces)
    );

    mantissa_shifter mantissa_shifter_ins(.MANTISSA_WIDTH(MANT_BITS))(
        .ma(mantissa_s),
        .mb(mantissa_b),
        .shift_spaces(shift_spaces),
        .exp_magnitude(/* 2 bit magnitude signal fromexponent_sub_upd module */),
        .mantissa_a(mantissa_a_shifted),
        .mantissa_b(mantissa_b_shifted)
    );

    mantissa_add_sub mantissa_add_sub_ins(.MANTISSA_WIDTH(MANT_BITS))(
        .ma(mantissa_a_shifted),
        .mb(mantissa_b_shifted),
        .ma_sign(sign_a),
        .mb_sign(sign_b),
        .operation_select(operation_select),
        .result(mantissa_result_shifted),
        .carry_out(carry_out)
    );

    normalize_rounder NR_Inst(.WIDTH(WIDTH))(
        .mantissa_result_shifted(result_mant),      
        .exp_result(exp_result),
        .R(mantissa_result)
    );
    
endmodule