
interface add_sub_main_if #(parameter WIDTH = 32, EXP_BITS = 8, MANT_BITS = 23);
    bit  [WIDTH-1:0] a,b;
    bit operation_select;
    bit clk;
    logic [WIDTH-1:0] result;
    logic sign_a, sign_b, sign_result;
    logic [MANT_BITS-1:0] mantissa_a, mantissa_b, mantissa_result;
    logic [EXP_BITS-1:0] exp_a, exp_b, exp_result;
    
    task automatic generate_custom_fp(output bit [31:0] fp_num);
        bit [7:0] exponent;
        bit [22:0] mantissa;
        bit [1:0] exp_rand;    // Para los 2 bits menos significativos del exponente.
        bit [2:0] mant_rand;   // Para los 3 bits más significativos de la mantisa.
        begin
            // Generar 2 bits aleatorios para la parte baja del exponente.
            exp_rand = $urandom_range(0, 3);
            // Exponente: MSB=1, luego 5 bits en 0 y finalmente los 2 bits aleatorios.
            exponent = {1'b1, 5'b00000, exp_rand};
            
            // Generar 3 bits aleatorios para la parte alta de la mantisa.
            mant_rand = $urandom_range(0, 7);
            // Mantisa: 3 bits aleatorios en la parte alta y 20 bits en 0.
            mantissa = {mant_rand, 20'b0};
            
            // Combinar las tres partes: signo (0), exponente y mantisa.
            fp_num = {1'b0, exponent, mantissa};
        end
    endtask

    // Task que asigna el número generado a las señales a y b.
    task task_generate_random_stimul();
        bit [31:0] temp;
        begin
            // Genera un número custom y asígnalo a 'a'
            generate_custom_fp(temp);
            a = temp;
            // Genera otro número custom (podría ser igual o distinto, depende del $urandom_range) y asígnalo a 'b'
            generate_custom_fp(temp);
            b = temp;
        end
    endtask
    
    task task_generate_fixed_stimul();
        begin
            a = 32'h3f800000;
            b = 32'h3f800000;
        end
    endtask

endinterface 
