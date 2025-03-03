`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//
// Create Date: 01/27/2025 12:24:12 AM
// Design Name: 
// Module Name: normalize_rounder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module normalize_rounder #(parameter WIDTH = 32) (
    input [26:0] result_mant,  
    input [7:0] exp_result,    
    input result_sign,
    input carry_out,
    input clk,
    input reset,
    output reg [31:0] R        
);

    reg [7:0] final_exp = 0;
    reg [26:0] final_mant = 0;
    reg [26:0] compliment_one_mant = 0;
    reg [26:0] compliment_two_mant = 0;
    reg [22:0] rounded_mant = 0;
    reg round_up = 0;
    reg [7:0] new_exp = 0;
    reg [7:0] exp_after_round = 0;
    reg [26:0] x = 0;
    reg [26:0] x_shifted = 0;
    reg [26:0] mant_shifted = 0;
    reg final_sign = 0;

    // Normalization
    // always @(posedge clk) begin
    always @(*) begin
        if (result_sign) begin
            final_mant = -result_mant;
        end else begin
            final_mant = result_mant;
        end

       /*  if (final_mant[25]) begin  
            x = final_mant >> 1;  // shift right
            new_exp = exp_result + 1;
        end else if (final_mant[24]) begin
            x = final_mant;       // hold
            new_exp = exp_result;
        end else begin
            x = final_mant << 1;  // shift left
            new_exp = exp_result - 1;
        end */
        
        if(carry_out) begin     //mantissa add sub was positive
            // x = final_mant >> 1;
            x = {carry_out, final_mant[26:1]};
            x_shifted = x << 1;
            new_exp = exp_result + 1;
        end else if(~carry_out) begin  //mantissa add sub was negative
            compliment_one_mant = ~final_mant;
            compliment_two_mant = compliment_one_mant + 1;
            x = compliment_two_mant << 1;
            new_exp = exp_result-1;
            final_sign = 1;
        end
        
    end

    // round to the closest
    // always @(posedge clk) begin
    always @(*) begin
        /* round_up = x[1] & (|x[0]);
        if (round_up) begin
            rounded_mant = x[24:2] + 1;
        end else begin
            rounded_mant = x[24:2];
        end */

        if((x[0] | x[1] | x[3]) & x[2]) begin
            mant_shifted = x + 1;
            // rounded_mant = mant_shifted >> 1;
            rounded_mant = x[24:2];
            exp_after_round = new_exp + 1;
        end else begin
            rounded_mant = x_shifted[26:4];
            exp_after_round = new_exp;
        end
    end

    // exponent adjust
    always @(*) begin
        final_exp = new_exp;
        if (rounded_mant == 23'h7FFFFF) begin
            final_exp = new_exp + 1;
            rounded_mant = 23'h000000;
        end /*else begin
            final_exp = new_exp;
            // rounded_mant = rounded_mant;
        end */
    end

    //  IEEE 754 final
    // always @(posedge clk) begin
    always @(*) begin
        R = {final_sign, final_exp, rounded_mant};
    end

endmodule

