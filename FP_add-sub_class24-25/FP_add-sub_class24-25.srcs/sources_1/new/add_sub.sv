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


module add_sub #(parameter WIDTH = 32)(
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

module  exp_subtractor (    // Module that represents the exp subtractor block
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

    reg [1:0] exp_disc;     // Exponent discriminant
    reg [7:0] exp_value;    // Exponent output value
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