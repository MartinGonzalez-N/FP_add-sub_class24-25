`timescale 1ns/1ps
module add_sub_asserts(
    input logic [31:0] a,
    input logic [31:0] b,
    input logic operation_select,
    input logic [31:0] result
    //input logic clk
);

    bit clk;

    always #1 clk = !clk;

    shortreal expected_result;
    //1
    property assert_add;
        @(posedge clk)(operation_select == 1) |-> (shortreal'(a) + shortreal'(b) == shortreal'(result));
    endproperty
    assert property (assert_add)
    else begin
        $error("assert_add: The addition operation is not correct. The result of the module is %0f and the expected result was %0f.", shortreal'(result), shortreal'(a) + shortreal'(b));
    end
    //2
    property assert_sub;
        @(posedge clk)(operation_select == 0) |-> ((shortreal'(a) + shortreal'(b) == shortreal'(result)));
    endproperty
    assert property (assert_sub)
    else begin
        $error("assert_sub: The subtraction operation is not correct.The result of the module is %0f and the expected result was %0f.", shortreal'(result), shortreal'(a) - shortreal'(b));
    end
    //4
    property assert_infs_add;
        @(posedge clk)(a == 32'h7f800000 && b == 32'h7f800000 && operation_select == 1) |-> (result == 32'h7f800000);
    endproperty
    assert property (assert_infs_add)
    else begin
        $error("assert_infs_add: The sum of positive infinities is not a positive infinity.");
    end
    //5
    property assert_infs_sub;
        @(posedge clk)(a == 32'h7f800000 && b == 32'h7f800000 && operation_select == 0) |-> (result[30:23] == 8'hff);
    endproperty
    assert property (assert_infs_sub)
    else begin
        $error("assert_infs_sub: The sub of positive infinities is not a NaN.");
    end
    //6
    property assert_inf_infn_add;
        @(posedge clk)(a == 32'h7f800000 && b == 32'hff800000 && operation_select == 1) |-> (result[30:23] == 8'hff);
    endproperty
    assert property (assert_inf_infn_add)
    else begin
        $error("assert_inf_infn_add: The sum of positive infinity and negative infinity is not a NaN");
    end
    //7
    property assert_inf_add;
        @(posedge clk)(a == 32'h7f800000 &&  operation_select == 1) |-> (result == 32'h7f800000);
    endproperty
    assert property (assert_inf_add)
    else begin
        $error("assert_inf_add: The sum of a number with positive infinity is not positive infinity");
    end
    //8
    property assert_as_add;
        @(posedge clk)(a == b &&  operation_select == 1) |-> (result == a+a);
    endproperty
    assert property (assert_as_add)
    else begin
        $error("assert_as_add: The sum of equal numbers is not the double of the number");
    end
    //9
    property assert_as_sub;
        @(posedge clk)(a == b &&  operation_select == 0) |-> (result == 0);
    endproperty
    assert property (assert_as_sub)
    else begin
        $error("assert_as_sub: The sub of equal numbers is not zero");
    end
    //10
    property assert_a_an_add;
        @(posedge clk)(a[30:0] == b[30:0] && a[31] == ~b[31] & operation_select == 1) |-> (result == 0);
    endproperty
    assert property (assert_a_an_add)
    else begin
        $error("assert_a_an_add: The sum of equal numbers with opposite signs is not zero.");
    end
    //11
    property assert_a_an_sub;
        @(posedge clk)(a[30:0] == b[30:0] && a[31] == ~b[31] & operation_select == 0) |-> (result == a+a);
    endproperty
    assert property (assert_a_an_sub)
    else begin
        $error("assert_a_an_sub: Subtraction of equal numbers with opposite signs is not twice the number.");
    end
    //12
    property assert_signs_0_add;
        @(posedge clk)(a[31] == 0 && b[31] == 0 && operation_select == 1) |-> (result[31] == 0);
    endproperty
    assert property (assert_signs_0_add)
    else begin
        $error("assert_signs_0_add: The sign of the result is not zero");
    end
    //13
    property assert_signs_1_add;
        @(posedge clk)(a[31] == 1 && b[31] == 1 & operation_select == 1) |-> (result[31] == 1);
    endproperty
    assert property (assert_signs_1_add)
    else begin
        $error("assert_signs_1_add: The sign of the result is not one");
    end

endmodule
