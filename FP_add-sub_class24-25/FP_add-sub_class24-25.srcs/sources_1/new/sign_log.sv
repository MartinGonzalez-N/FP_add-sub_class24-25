`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cinvestav
// Engineer: Dabiel, Lino, Kevin, Emmanuel
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

module sign_log #(parameter WIDTH = 32)(
    input wire [WIDTH-1:0] X,Y,
    input bit operation_select,
    //input bit clk,
    output reg [0:0] result,
    output sign_r
    
    );
    wire [22:0] mantissa_a, mantissa_b, mantissa_result;
    wire sign_a, sign_b;
    wire def1_1;
    wire sign_x, sign_y;
    
    assign sign_x = X[31];
    assign sign_y = Y[31];
    
    assign mantisa_a = X[22:0];
    assign exp_a = X[30:23];
        
    assign mantisa_b = Y[22:0];
    assign exp_b = Y[30:23];
    assign sign_b = operation_select ? sign_y : ~sign_y;
    
    assign def1_1 = (mantisa_a > mantisa_b) ? sign_x : (mantisa_a < mantisa_b) ? sign_b : (sign_a ~^ sign_b);
    assign sign_r = (exp_a > exp_b) ? sign_x : (exp_a < exp_b) ? sign_b : def1_1;
    
    
    
endmodule
