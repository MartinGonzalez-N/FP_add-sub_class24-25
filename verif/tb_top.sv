`timescale 1ns/1ps
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

    parameter CICLES = 1000;
    parameter WIDTH = 32;
    bit clk;
    always #5 clk = !clk;

    initial begin
        $shm_open("shm_db");
        $shm_probe("ASMTR");
    end

    // Instanciar la interface
    add_sub_main_if #(.WIDTH(WIDTH)) add_sub_main_if_inst();

    // Instancia del DUT
    add_sub_main #(.WIDTH(WIDTH)) DUT(
        .a(add_sub_main_if_inst.a),
        .b(add_sub_main_if_inst.b),
        .operation_select(add_sub_main_if_inst.operation_select),
        .result(add_sub_main_if_inst.result),
        .clk(clk)
    );

    bind DUT add_sub_asserts asserts(
        .a(add_sub_main_if_inst.a),
        .b(add_sub_main_if_inst.b),
        .operation_select(add_sub_main_if_inst.operation_select),
        .result(add_sub_main_if_inst.result)
        //.clk(clk)
    );


    //`define TC_Add_AB_random_p
    //`define TC_ADD_SUB_CHECK
    //initial alu_if_inst.clk = 0;
    //always #25ps alu_if_inst.clk = ~alu_if_inst.clk;

    //1
    `ifdef ADD_POS_AB
        `CREATE_COVERGROUPS(add_sub_main_if_inst.a, add_sub_main_if_inst.b)
        initial begin
            cg_a cg_a_inst = new();
            cg_b cg_b_inst = new();
            repeat(CICLES)@(posedge clk) begin
                cg_a_inst.sample();
                cg_b_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_a_rdm();
                add_sub_main_if_inst.a = add_sub_main_if_inst.a & 32'h7fffffff;
                add_sub_main_if_inst.set_input_b_rdm();
                add_sub_main_if_inst.b = add_sub_main_if_inst.b & 32'h7fffffff;
            end
            $finish;
        end
    `endif
    //2
    `ifdef ADD_NEG_AB
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk) begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_a_rdm();
                add_sub_main_if_inst.a = add_sub_main_if_inst.a | 32'h80000000;
                add_sub_main_if_inst.set_input_b_rdm();
                add_sub_main_if_inst.b = add_sub_main_if_inst.b | 32'h80000000;
            end
            $finish;
        end
    `endif
    //5
    `ifdef ADD_INF_A
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
          //  cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
            //    cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_a_to_specific_value(32'h7f800000);
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //6
    `ifdef ADD_INF_B
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
          //  cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_b_to_specific_value(32'h7f800000);
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //7 Add when A and B are zeros
    `ifdef ADD_ZERO_AB
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
          //  cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
            //    cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_a_to_zero();
                add_sub_main_if_inst.set_input_b_to_zero();
            end
            $finish;
        end
    `endif
    //8 Add when A is zero and B is random
    `ifdef ADD_ZERO_A
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
          //  cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_a_to_zero();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //9 Add when B is zero and A is random
    `ifdef ADD_ZERO_B
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();
            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_b_to_zero();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //10 A is maximum positive value and B is random
    `ifdef ADD_MAX_A
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();
            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_a_max_pos();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //11 Add when A is random and B is maximum positive value
    `ifdef ADD_MAX_B
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();
            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_b_max_pos();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //12 Add A and B with maximum positive value
    `ifdef ADD_MAX_AB
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();
            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_a_max_pos();
                add_sub_main_if_inst.set_input_b_max_pos();
            end
            $finish;
        end
    `endif
    //13 Add when A and B are Nan
    `ifdef ADD_NAN_AB
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
          //  cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
            //    cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_b_to_nan();
                add_sub_main_if_inst.set_input_a_to_nan();
            end
            $finish;
        end
    `endif
    //14 Add when A is NaN and B is random
    `ifdef ADD_NAN_A
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();
            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_a_to_nan();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //15 Add when B is NaN and A is random
    `ifdef ADD_NAN_B
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 1;
                add_sub_main_if_inst.set_input_b_to_nan();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //16
    `ifdef SUB_POS_AB
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
          //  cg_a_exp cg_a_exp_inst = new();
            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                //a_result_verif:assert ($shortrealtobits(expected_result) == add_sub_main_if_inst.result);
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_a_rdm();
                add_sub_main_if_inst.a = add_sub_main_if_inst.a & 32'h7fffffff;
                add_sub_main_if_inst.set_input_b_rdm();
                add_sub_main_if_inst.b = add_sub_main_if_inst.b & 32'h7fffffff;
            end
            $finish;
        end
    `endif
    //17
    `ifdef SUB_NEG_AB
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                //a_result_verif:assert ($shortrealtobits(expected_result) == add_sub_main_if_inst.result);
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_a_rdm();
                add_sub_main_if_inst.a = add_sub_main_if_inst.a | 32'h80000000;
                add_sub_main_if_inst.set_input_b_rdm();
                add_sub_main_if_inst.b = add_sub_main_if_inst.b | 32'h80000000;
            end
            $finish;
        end
    `endif
    //20 Substraction when A and B are zeros
    `ifdef SUB_ZERO_AB
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_a_to_zero();
                add_sub_main_if_inst.set_input_b_to_zero();
            end
            $finish;
        end
    `endif
    //21 Substraction when A is zero and B is random
    `ifdef SUB_ZERO_A
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_a_to_zero();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //22 Substraction when B is zero and A is random
    `ifdef SUB_ZERO_B
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_b_to_zero();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //23 Substraction when A is maximum negative value and B is random
    `ifdef SUB_MAX_A
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_a_max_neg();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //24 Substraction when A is random and B is maximum negative value
    `ifdef SUB_MAX_B
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_b_max_neg();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif
    //25 Substraction when A and B are NaN
    `ifdef SUB_NAN_AB
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_b_to_nan();
                add_sub_main_if_inst.set_input_a_to_nan();
            end
            $finish;
        end
    `endif
    //26 Substraction when A is NaN and B is random
    `ifdef SUB_NAN_A
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_a_to_nan();
                add_sub_main_if_inst.set_input_b_rdm();
            end
            $finish;
        end
    `endif
    //27 Substraction when B is NaN and A is random
    `ifdef SUB_NAN_B
        //`CREATE_EXPONENT_COVERGROUP(cg_a_exp, add_sub_main_if_inst.a)
        initial begin
            //cg_a_exp cg_a_exp_inst = new();

            repeat (CICLES)@(posedge clk)begin
                //cg_a_exp_inst.sample();
                add_sub_main_if_inst.operation_select = 0;
                add_sub_main_if_inst.set_input_b_to_nan();
                add_sub_main_if_inst.set_input_a_rdm();
            end
            $finish;
        end
    `endif

endmodule
