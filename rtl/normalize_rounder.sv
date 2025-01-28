`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2025 12:24:12 AM
// Design Name: 
// Module Name: Normalize_Rounder
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

module Normalize_Rounder #(parameter WIDTH = 32) (
    input logic [MANT_BITS+1:0] resultMant; ,      
    input logic [EXP_BITS-1:0] exp_result,
    output logic [WIDTH-1:0] R, 
);

    logic [EXP_BITS-1:0] finalExp;
    logic [MANT_BITS:0] finalMant;

    //Normalize
    always_comb begin
        if (resultMant[MANT_BITS+1]) begin
            finalMant = resultMant[MANT_BITS+1:1];
            finalExp = exp_result + 1;
        end else if (resultMant[MANT_BITS]) begin
            finalMant = resultMant[MANT_BITS:0];
            finalExp = exp_result;
        end else begin
            finalMant = resultMant[MANT_BITS:0] << 1;
            finalExp = exp_result - 1;
        end
    end

    //Rounder
    logic [MANT_BITS-1:0] roundedMant;
    logic roundUp;

    always_comb begin
        roundUp = finalMant[0] & (finalMant[1] | (finalMant[0] & finalMant[2]));
        if (roundUp) begin
            roundedMant = finalMant[MANT_BITS:1] + 1;
        end else begin
            roundedMant = finalMant[MANT_BITS:1];
        end
    end

    always_comb begin
        if (roundedMant == {MANT_BITS{1'b0}}) begin
            finalExp = finalExp + 1;
        end
    end

    always_comb begin
        R = {resultSign, finalExp, roundedMant};
        overflow = (finalExp > 8'hFF); // fuera de rango
    end

endmodule