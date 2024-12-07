
set_fml_appmode AEP
set design AHB_slave_interface

set_app_var fml_enable_fsm_report_complexity true
set_app_var fml_trace_auto_fsm_state_extraction true

read_file -top $design -format sverilog -aep all+fsm_deadlock -vcs {../RTL/AHB_Slave_Interface.sv}

create_clock Hclk -period 100 
create_reset Hresetn -sense low

sim_run -stable 
sim_save_reset
