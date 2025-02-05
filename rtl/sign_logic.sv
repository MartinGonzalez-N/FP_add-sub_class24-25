module sign_logic #(parameter WIDTH = 32)(
    input wire [WIDTH-1:0] x,y,
    input operation_select,
    //input bit clk,
    output reg [0:0] result,
    output sign_r
    );
    
    wire [22:0] mantissa_a, mantissa_b, mantissa_result;
    wire sign_a, sign_b;
    wire def1_1;
    wire sign_x, sign_y;
    
    assign sign_x = x[31];
    assign sign_y = y[31];
    
    assign mantisa_a = x[22:0];
    assign exp_a = x[30:23];

    assign mantisa_b = y[22:0];
    assign exp_b = y[30:23];
    assign sign_b = operation_select ? sign_y : ~sign_y;
    
    assign def1_1 = (mantisa_a > mantisa_b) ? sign_x : (mantisa_a < mantisa_b) ? sign_b : (sign_a ~^ sign_b);
    assign sign_r = (exp_a > exp_b) ? sign_x : (exp_a < exp_b) ? sign_b : def1_1;

endmodule
