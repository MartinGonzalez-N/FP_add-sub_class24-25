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

module mantissa_swap #(parameter MANTISSA_WIDTH=23)(
    input [MANTISSA_WIDTH-1:0] ma, mb,
    input [1:0] exp_magnitude,
    output [MANTISSA_WIDTH-1:0] greater_mantissa, smaller_mantissa
);

//local parameters
localparam AGREATER = 2'b10;
localparam BGREATER = 2'b00;
localparam EQUAL = 2'b11;


case (exp_magnitude)
    AGREATER: greater_mantissa = ma, smaller_mantissa = mb;
    BGREATER: greater_mantissa = mb, smaller_mantissa = ma;
    EQUAL: greater_mantissa = ma, smaller_mantissa = mb;
    default: greater_mantissa = ma, smaller_mantissa = mb;
endcase

endmodule