module normalize_rounder #(parameter WIDTH = 32) (
    input [26:0] result_mant,
    input [7:0] exp_result,
    output reg [31:0] R
);

    reg [7:0] final_exp;
    reg [26:0] final_mant;
    reg [22:0] rounded_mant;
    reg round_up;
    reg [7:0] new_exp;
    reg result_sign;
    wire [26:0] signed_mant; // Wire for intermediate signed value

    assign result_sign = result_mant[26];

    assign signed_mant = (result_sign) ? ~result_mant + 1 : result_mant; // Two's complement

    always_comb begin  // Normalization is still combinational
        if (signed_mant[25]) begin
            final_mant = signed_mant >> 1;
            new_exp = exp_result + 1;
        end else if (signed_mant[24]) begin
            final_mant = signed_mant;
            new_exp = exp_result;
        end else begin
            final_mant = signed_mant << 1;
            new_exp = exp_result - 1;
        end
    end


    always_comb begin // Rounding is combinational
        round_up = final_mant[1] & (|final_mant[0:0]);
        if (round_up) begin
            rounded_mant = final_mant[24:2] + 1;
        end else begin
            rounded_mant = final_mant[24:2];
        end
    end

    always_comb begin // Exponent adjustment is combinational
        final_exp = new_exp;
        if (rounded_mant == 23'h7FFFFF) begin
            final_exp = new_exp + 1;
            rounded_mant = 23'h000000;
        end
    end

    always_comb begin  // Output assignment is combinational
        R = {result_sign, final_exp, rounded_mant[22:0]};
    end

endmodule