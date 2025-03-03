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
//
//////////////////////////////////////////////////////////////////////////////////
module add_sub_main #(parameter WIDTH = 32, EXP_BITS = 8, MANT_BITS = 23)(
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input operation_select,
    input clk,
    input reset,
    output [WIDTH-1:0] result
);

    reg a_greater;
    reg carry_out;
    reg [4:0] shift_spaces;
    reg [MANT_BITS+3:0] mantissa_a_shifted; 
    reg [MANT_BITS+3:0] mantissa_b_shifted; 
    reg [MANT_BITS+3:0] mantissa_result_shifted;
    reg sign_a;
    reg sign_b;
    reg sign_result;
    reg [MANT_BITS-1:0] mantissa_a;
    reg [MANT_BITS-1:0] mantissa_b;
    reg [MANT_BITS-1:0] mantissa_result;
    reg [EXP_BITS-1:0] exp_a; 
    reg [EXP_BITS-1:0] exp_b;
    reg [EXP_BITS-1:0] exp_result;
    reg [1:0] exp_disc;

    always @(a, b) begin
        mantissa_a = a[22:0];
        exp_a = a[30:23];
        sign_a = a[31];
            
        mantissa_b = b[22:0];
        exp_b = b[30:23];
        sign_b = b[31];
    end


    sign_logic #(WIDTH) sign_ins ( 
        .x(a),
        .y(b),
        .operation_select(operation_select),
        .sign_r(sign_result)
    );


    // TODO add exception_block instance here


    exponent_sub_upd #(.EXP_WIDTH(EXP_BITS)) exp_ins  ( 
        .exp_a(exp_a),
        .exp_b(exp_b),
        .exp_disc(exp_disc),
        .sign_a(sign_a),
        .sign_b(sign_b),
        .exp_value(exp_result),
        .shift_spaces(shift_spaces)
    );

    mantissa_shifter #(.MANTISSA_WIDTH(MANT_BITS)) mantissa_shifter_ins ( 
        .ma(mantissa_a),
        .mb(mantissa_b),
        .shift_spaces(shift_spaces),
        .exp_magnitude(exp_disc),
        .mantissa_a_out(mantissa_a_shifted),
        .mantissa_b_out(mantissa_b_shifted)
    );

    mantissa_add_sub #(.MANTISSA_WIDTH(MANT_BITS)) mantissa_add_sub_ins ( 
        .man_a(mantissa_a_shifted),
        .man_b(mantissa_b_shifted),
        .ma_sign(sign_a),
        .mb_sign(sign_b),
        .operation_select(operation_select),
        .result(mantissa_result_shifted),
        .carry_out(carry_out)
    );

    normalize_rounder #(.WIDTH(WIDTH)) normalize_rounder_inst ( 
        .result_mant(mantissa_result_shifted),      
        .exp_result(exp_result),
        .result_sign(sign_result),
        .carry_out(carry_out),
        .R(result),
        .clk(clk),
        .reset(reset)
    );
    
endmodule
