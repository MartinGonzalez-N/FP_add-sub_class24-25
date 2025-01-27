`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2025 12:20:58 AM
// Design Name: 
// Module Name: Exponent_sub_upd
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


module  Exponent_sub_upd #(parameter EXP = 8)(    // Module that represents the exp subtractor block
    logic exp_a,
    logic exp_b,
    logic a_greater, a_less, a_equal
);    

/* add_sub  exp_ins (          // add_sub module instance

    .exp_a(exp_a),
    .exp_b(exp_b),
    .sign_a(sign_a),
    .sign_b(sign_b)
    
);  */   

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