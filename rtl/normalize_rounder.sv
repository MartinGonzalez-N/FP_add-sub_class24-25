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

module normalize_rounder(PARAMETER WIDTH) (
    input logic [MANT_BITS+3:0] result_mant,  // 23 bits + 4 extra (por la suma/resta)
    input logic [EXP_BITS-1:0] exp_result,    // Exponente en IEEE 754
    output logic [WIDTH-1:0] R            // Resultado final IEEE 754
);

    logic [7:0] final_exp;
    logic [26:0] final_mant;
    logic [22:0] rounded_mant;
    logic round_up;
    logic [7:0] new_exp;
    logic result_sign;

    // Determinar el signo del resultado
    assign result_sign = result_mant[26];  // Bit más significativo

    // Convertir a positivo si es negativo (complemento a 2)
    always_comb begin
        if (result_sign)
            final_mant = -result_mant;
        else
            final_mant = result_mant;
    end

    // Normalización
    always_comb begin
        if (final_mant[25]) begin
            final_mant = final_mant[25:1];  // Desplazar derecha
            new_exp = exp_result + 1;
        end else if (final_mant[24]) begin
            final_mant = final_mant[24:0];  // Mantener
            new_exp = exp_result;
        end else begin
            final_mant = final_mant[24:0] << 1;  // Desplazar izquierda
            new_exp = exp_result - 1;
        end
    end

    // Redondeo al más cercano (round to nearest, even)
    always_comb begin
        round_up = final_mant[0] & (final_mant[1] | final_mant[2]);
        if (round_up) begin
            rounded_mant = final_mant[24:2] + 1;
        end else begin
            rounded_mant = final_mant[24:2];
        end
    end

    // Ajuste del exponente en caso de carry en el redondeo
    always_comb begin
        final_exp = new_exp;
        if (rounded_mant == 0) begin
            final_exp = new_exp + 1;
        end
    end

    // Construcción del número IEEE 754
    always_comb begin
        R = {result_sign, final_exp, rounded_mant};
    end

endmodule

