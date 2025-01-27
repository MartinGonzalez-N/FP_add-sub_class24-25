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

#define MANT_BITS 23
#define EXP_BITS 8

module add_sub_main #(parameter WIDTH = 32)(
    input  [WIDTH-1:0] a,b,
    input bit operation_select,
    output [WIDTH-1:0] result,
    output sign_a, sign_b, sign_result,
    output [WIDTH-10:0] mantissa_a, mantissa_b, mantissa_result,
    output [WIDTH-25:0] exp_a, exp_b, exp_result,
    output a_greater    
);
    
    //Separate sign, exponent and mantissa values for both inputs
    assign mantissa_a = a[22:0];
    assign exp_a = a[30:23];
    assign sign_a = a[31];
        
    assign mantissa_b = b[22:0];
    assign exp_b = b[30:23];
    assign sign_b = b[31];
endmodule

module Rounder #(parameter WIDTH = 32) (
    input  logic [WIDTH-1:0] A,  
    input  logic [WIDTH-1:0] B,  
    input  logic op,             
    output logic [WIDTH-1:0] R,  
    output logic overflow        
);

    logic [EXP_BITS-1:0] finalExp;
    logic [MANT_BITS:0] finalMant;

    //Normalize
    always_comb begin
        if (resultMant[MANT_BITS+1]) begin
            finalMant = resultMant[MANT_BITS+1:1];
            finalExp = expA + 1;
        end else if (resultMant[MANT_BITS]) begin
            finalMant = resultMant[MANT_BITS:0];
            finalExp = expA;
        end else begin
            finalMant = resultMant[MANT_BITS:0] << 1;
            finalExp = expA - 1;
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

module  exp_subtractor #(parameter EXP = 8)(    // Module that represents the exp subtractor block
    logic exp_a,
    logic exp_b,
    logic a_greater, a_less, a_equal
);    

add_sub  exp_ins (          // add_sub module instance

    .exp_a(exp_a),
    .exp_b(exp_b),
    .sign_a(sign_a),
    .sign_b(sign_b)
    
);    

    reg [EXP-7:0] exp_disc;     // Exponent discriminant
    reg [EXP-1:0] exp_value;    // Exponent output value
    reg out_sign;
    //reg exp_sub;
    assign a_greater = exp_a > exp_b;
    assign a_less = exp_a < exp_b;
    assign a_equal = exp_a == exp_b;

    always @(*) begin
        exp_disc = a_greater ? 2'b10 : 
        a_less ? 2'b01 :
        a_equal ? 2'b11 : 2'b00; 
    end
    
    always @(*) begin
    exp_value = (a_greater || a_equal) ? exp_a : exp_b;
    end   
    
    always @(*) begin
    out_sign = a_greater ? sign_a : sign_b;
    end      
endmodule 

module right_shift #(parameter MANT = 23) (
    input [MANT-1:0] smaller_mantissa,
    input [7:0] shift_spaces,
    output [MANT-1:0] shifted_mantissa
);

    assign shifted_mantissa = smaller_mantissa >> shift_spaces;          
endmodule      

// Pending
module exp_update (
    input [7:0] shift_spaces,
    input shift_dir       
);
    
    
endmodule
