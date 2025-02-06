
interface add_sub_main_if #(parameter WIDTH = 32);
    bit  [WIDTH-1:0] a,b;
    bit operation_select;
    bit clk;
    logic [WIDTH-1:0] result;
    logic sign_a, sign_b, sign_result;
    logic [MANT_BITS-1:0] mantissa_a, mantissa_b, mantissa_result;
    logic [EXP_BITS-1:0] exp_a, exp_b, exp_result;
    

    task task_generate_random_stimul();
        begin
            std::randomize(a);
            std::randomize(b);
            std::randomize(operation_select);
        end
    endtask
endinterface 
