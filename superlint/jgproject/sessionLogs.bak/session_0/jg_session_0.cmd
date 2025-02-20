# ----------------------------------------
# Jasper Version Info
# tool      : Jasper 2023.09
# platform  : Linux 4.19.0-20-amd64
# version   : 2023.09 FCS 64 bits
# build date: 2023.09.27 19:40:18 UTC
# ----------------------------------------
# started   : 2025-02-18 22:12:29 UTC
# hostname  : joc047.(none)
# pid       : 48352
# arguments : '-label' 'session_0' '-console' '//127.0.0.1:35791' '-style' 'windows' '-data' 'AAAA3HicY2RgYLCp////PwMYMFcBCQEGHwZfhiAGVyDpzxAGpBkYzBjMGUyA0IHBkMGAQQ+MzYHYFMi3wiMHBowPIDSDDSMDMmAMbEChGRhYYQphSpiAWIRBl6GYoZShgCGVoYghhyGTIY+hBCguhUVUD4iTgTyQUQD6DBju' '-proj' '/home/joc/c12025/FP_mult-div_class24-25/superlint/jgproject/sessionLogs/session_0' '-init' '-hidden' '/home/joc/c12025/FP_mult-div_class24-25/superlint/jgproject/.tmp/.initCmds.tcl' 'superlint.tcl'
check_superlint -init
clear -all
set design_top mul_div

analyze -sv -f superlint_list 
config_rtlds -rule -load superlint_Verilog_SystemVerilog.def
elaborate -top $design_top

clock clk
reset arst -non_resettable_regs 0
check_superlint -extract
check_superlint -prove
visualize -violation -property <SL_AUTO_FORMAL_OVERFLOW>::arithmetic_overflow_assignment_prop_4233 -new_window
