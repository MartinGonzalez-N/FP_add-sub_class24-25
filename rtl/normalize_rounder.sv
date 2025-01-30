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
    input logic [MANT_BITS+1:0] result_mant; ,      
    input logic [EXP_BITS-1:0] exp_result,
    output logic [WIDTH-1:0] R, 
);

    logic [EXP_BITS-1:0] final_exp;
    logic [MANT_BITS:0] final_mant;

    //Normalize
    always_comb begin
        if (result_mant[MANT_BITS+1]) begin
            final_mant = result_mant[MANT_BITS+1:1];
            final_exp = exp_result + 1;
        end else if (result_mant[MANT_BITS]) begin
            final_mant = result_mant[MANT_BITS:0];
            final_exp = exp_result;
        end else begin
            final_mant = result_mant[MANT_BITS:0] << 1;
            final_exp = exp_result - 1;
        end
    end

    //Rounder
    logic [MANT_BITS-1:0] rounded_mant;
    logic round_up;

    always_comb begin
        round_up = final_mant[0] & (final_mant[1] | (final_mant[0] & final_mant[2]));
        if (round_up) begin
            rounded_mant = final_mant[MANT_BITS:1] + 1;
        end else begin
            rounded_mant = final_mant[MANT_BITS:1];
        end
    end

    always_comb begin
        if (rounded_mant == {MANT_BITS{1'b0}}) begin
            final_exp = final_exp + 1;
        end
    end

    always_comb begin
        R = {resultSign, final_exp, rounded_mant};
        overflow = (final_exp > 8'hFF); // fuera de rango
    end

endmodule