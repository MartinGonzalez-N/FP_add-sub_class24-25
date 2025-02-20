clear -all
set design_top mul_div

analyze -sv -f superlint_list 
config_rtlds -rule -load superlint_Verilog_SystemVerilog.def
elaborate -top $design_top

clock clk
reset arst -non_resettable_regs 0
check_superlint -extract
check_superlint -prove
