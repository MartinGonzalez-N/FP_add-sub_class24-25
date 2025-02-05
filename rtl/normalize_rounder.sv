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
    input [26:0] result_mant,  // 23 bits + 4 extra (por la suma/resta)
    input [7:0] exp_result,    // Exponente en IEEE 754
    output reg [31:0] R            // Resultado final IEEE 754
);

    reg [7:0] final_exp;
    reg [26:0] final_mant;
    reg [22:0] rounded_mant;
    reg round_up;
    reg [7:0] new_exp;
    reg result_sign;
    reg [26:0]x;
    reg [26:0]y;

    // Determinar el signo del resultado
    // assign result_sign = result_mant[26];  // Bit más significativo

    // Normalización
    always @* begin
          
        if (result_sign) begin
            final_mant = -result_mant;
        end else begin
            final_mant = result_mant;
        end

        if (final_mant[25]) begin 
            x = final_mant << 1;  // Desplazar derecha
            new_exp = exp_result + 1;
        end else if (final_mant[24]) begin
            x = final_mant >> 1;  // Mantener
            new_exp = exp_result-1;
         end
    end

    // Redondeo al más cercano (round to nearest, even)
    always @* begin
        round_up = final_mant[0] & (final_mant[1] | final_mant[2]);
        if (round_up) begin
            rounded_mant = final_mant[24:2] + 1;
        end else begin
            rounded_mant = final_mant[24:2];
        end
    end

    // Ajuste del exponente en caso de carry en el redondeo
    always @* begin
        final_exp = new_exp;
        if (rounded_mant == 0) begin
            final_exp = new_exp + 1;
        end
    end

    // Construcción del número IEEE 754
    always @* begin
        R = {result_sign, final_exp, rounded_mant};
    end

endmodule

