`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2025 12:20:58 AM
// Design Name: 
// Module Name: exponent_sub_upd
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


module  exponent_sub_upd #(parameter EXP_WIDTH = 8)(    // Module that represents the EXP_WIDTH subtractor block
    input [EXP_WIDTH-1: 0] exp_a, exp_b,
    output bit a_greater, a_less, a_equal,
    output reg [4:0] shift_spaces
);    


    reg [EXP_WIDTH-7:0] exp_disc;     // Exponent discriminant
    reg [EXP_WIDTH-1:0] exp_value;    // Exponent output value
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


// Pending
module exp_update (
    input [7:0] shift_spaces,
    input shift_dir       
);
    
    
endmodule