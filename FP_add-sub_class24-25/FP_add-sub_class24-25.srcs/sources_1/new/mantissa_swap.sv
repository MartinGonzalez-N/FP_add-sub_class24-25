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
    input [4:0] shift_spaces,
    input [1:0] exp_magnitude,
    output reg [MANTISSA_WIDTH+3:0] mantissa_a, mantissa_b
);

//local parameters
localparam AGREATER = 2'b10;
localparam BGREATER = 2'b00;
localparam EQUAL = 2'b11;

// Internal signals
wire [MANTISSA_WIDTH+3:0] operand_a, operand_b;

assign operand_a = {1'b1, ma, 3'b0};  // Addition of leading, guard, round and sticky bits
assign operand_b = {1'b1, mb, 3'b0};  // Addition of leading, guard, round and sticky bits

always @(*) begin 
    case (exp_magnitude)
        AGREATER: begin
            mantissa_a = operand_a;
            mantissa_b = operand_b >> shift_spaces;
            end
        BGREATER: begin
            mantissa_b = operand_b;
            mantissa_a = operand_a >> shift_spaces;
            end
        EQUAL: 
            begin 
            mantissa_a = operand_a;
            mantissa_b = operand_b;
            end
        default: begin 
            mantissa_a = operand_a;
            mantissa_b = operand_b;
            end
    endcase
end

endmodule