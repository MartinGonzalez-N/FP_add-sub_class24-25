`define CREATE_COVERGROUPS(in_a, in_b) \
    covergroup cg_a; \
        cp_a_sign : coverpoint in_a[31] { \
            bins range[] = {[0:1]}; \
        } \
        cp_a_exp : coverpoint in_a[30:23] { \
            bins range[] = {[0:$]}; \
        } \
        cp_a_man : coverpoint in_a[22:0] { \
            bins range[] = {[0:$]}; \
        } \
        cross cp_a_sign, cp_a_exp, cp_a_man; \
    endgroup \
    covergroup cg_b; \
        cp_b_sign : coverpoint in_b[31] { \
            bins range[] = {[0:1]}; \
        } \
        cp_b_exp : coverpoint in_b[30:23] { \
            bins range[] = {[0:$]}; \
        } \
        cp_b_man : coverpoint in_b[22:0] { \
            bins range[] = {[0:$]}; \
        } \
        cross cp_b_sign, cp_b_exp, cp_b_man; \
    endgroup \




