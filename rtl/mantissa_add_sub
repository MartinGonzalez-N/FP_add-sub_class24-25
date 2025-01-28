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

module mantissa_add_sub #(parameter MANTISSA_WIDTH = 23)(
    input  [MANTISSA_WIDTH+3:0] ma, mb,
    input bit ma_sign, mb_sign, operation_select,
    output reg [MANTISSA_WIDTH+3:0] result,
    output reg carry_out
    );
    
    // Internal signals
    wire [MANTISSA_WIDTH+3:0] operand_a, operand_b; 

    // Apply sign to the mantissas
    assign operand_a = ma_sign ? -ma : ma; 
    assign operand_b = mb_sign ? -mb : mb;

    always @(*) begin
        if (operation_select) begin  // Addition
            {carry_out, result} = operand_a + operand_b; 
        end else begin               // Subtraction
            {carry_out, result} = operand_a - operand_b; 
        end
    end
    
endmodule