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
    output reg [31:0] R        
);

    reg [7:0] final_exp;
    reg [26:0] final_mant;
    reg [26:0] compliment_mant;
    reg [22:0] rounded_mant;
    reg round_up;
    reg [7:0] new_exp;
    reg [26:0] x;

    // Normalization
    always @* begin
        if (result_sign) begin
            final_mant = -result_mant;
        end else begin
            final_mant = result_mant;
        end

        if (final_mant[25]) begin 
            x = final_mant >> 1;  // shift right
            new_exp = exp_result + 1;
        end else if (final_mant[24]) begin
            x = final_mant;       // hold
            new_exp = exp_result;
        end else begin
            x = final_mant << 1;  // shift left
            new_exp = exp_result - 1;
        end

        if(carry_out) begin     //mantissa add sub was positive
            x = final_mant >> 1
            new_exp = exp_result + 1;
        end else if(~carry_out) begin  //mantissa add sub was negative
            compliment_mant = final_mant;
            compliment_mant = -1;
            x = compliment_mant << 1
        end
    end

    // round to the closest
    always @* begin
        round_up = x[1] & (|x[0]);
        if (round_up) begin
            rounded_mant = x[24:2] + 1;
        end else begin
            rounded_mant = x[24:2];
        end
    end

    // exponent adjust
    always @* begin
        final_exp = new_exp;
        if (rounded_mant == 23'h7FFFFF) begin
            final_exp = new_exp + 1;
            rounded_mant = 27'h000000;
        end
    end

    //  IEEE 754 final
    always @* begin
        R = {result_sign, final_exp, rounded_mant};
    end

endmodule

