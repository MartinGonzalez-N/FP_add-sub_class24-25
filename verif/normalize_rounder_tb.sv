`timescale 1ns/1ps

module normalize_rounder_tb;

    // Parámetros del módulo
    parameter WIDTH = 32;
    parameter MANT_BITS = 23;  // Bits de la mantisa
    parameter EXP_BITS = 8;   // Bits del exponente

    // Señales del testbench
    logic [MANT_BITS+1:0] resultMant;
    logic [EXP_BITS-1:0] exp_result;
    logic [WIDTH-1:0] R;

    // Instancia del módulo bajo prueba (UUT)
    Normalize_Rounder #(
        .WIDTH(WIDTH)
    ) uut (
        .resultMant(resultMant),
        .exp_result(exp_result),
        .R(R)
    );

    // Procedimiento de prueba
    initial begin
        // Inicializar señales
        resultMant = 0;
        exp_result = 0;

        // Caso 1: Normalización sin ajuste
        #10 resultMant = 25'b01000000000000000000000; // Mantisa normalizada
            exp_result = 8'b10000001;               // Exponente = 129
        #10 $display("Caso 1: R = %h", R);

        // Caso 2: Normalización con shift a la derecha
        #10 resultMant = 25'b10000000000000000000000; // Mantisa no normalizada
            exp_result = 8'b10000000;               // Exponente = 128
        #10 $display("Caso 2: R = %h", R);

        // Caso 3: Normalización con shift a la izquierda
        #10 resultMant = 25'b00100000000000000000000; // Mantisa pequeña
            exp_result = 8'b01111111;               // Exponente = 127
        #10 $display("Caso 3: R = %h", R);

        // Caso 4: Redondeo hacia arriba
        #10 resultMant = 25'b00000000000000000101000; // Redondeo activado
            exp_result = 8'b01111110;               // Exponente = 126
        #10 $display("Caso 4: R = %h", R);

        // Caso 5: Desbordamiento del exponente
        #10 resultMant = 25'b10000000000000000000000; // Mantisa no normalizada
            exp_result = 8'b11111110;               // Exponente cerca de límite
        #10 $display("Caso 5: R = %h", R);

        // Fin de la simulación
        #10 $stop;
    end

endmodule
