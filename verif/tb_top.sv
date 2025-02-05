`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/27/2025 02:35:40 PM
// Design Name: 
// Module Name: TestBench
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

module tb_top;

    // Parámetros
    parameter CICLES = 1800;
    parameter WIDTH = 32;

    initial begin
        $shm_open("shm_db");
        $shm_probe("ASMTR");
    end

    // Instanciar la interface
    add_sub_main_if #(.WIDTH(WIDTH)) add_sub_main_if_inst();

    // Instancia del DUT
    add_sub_main #(.WIDTH(WIDTH)) add_sub_main_inst(
        .a(add_sub_main_if_inst.a),
        .b(add_sub_main_if_inst.b),
        .operation_select(add_sub_main_if_inst.operation_select)
    );
    
    `define TEST1

    //initial alu_if_inst.clk = 0;
    //always #25ps alu_if_inst.clk = ~alu_if_inst.clk;

    `ifdef TEST1
        initial begin
            repeat (CICLES) begin 
                add_sub_main_if_inst.task_generate_random_stimul();
                #5;
            end
        end
   `endif

endmodule