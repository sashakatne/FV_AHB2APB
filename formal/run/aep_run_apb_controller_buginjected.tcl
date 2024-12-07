
# Select AEP as the VC Formal App mode
set_fml_appmode AEP
set design APB_Controller

set_app_var fml_enable_fsm_report_complexity true
set_app_var fml_trace_auto_fsm_state_extraction true

read_file -top $design -format sverilog -aep all+fsm_deadlock -vcs {../RTL/APB_Controller.sv +define+BUG_INJECTION}

# Creating clock and reset signals
create_clock Hclk -period 100 
create_reset Hresetn -sense low

# Runing a reset simulation
sim_run -stable 
sim_save_reset

aep_generate -type fsm_fairness
