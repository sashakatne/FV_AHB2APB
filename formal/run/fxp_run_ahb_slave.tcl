
set_fml_appmode FXP
set design AHB_slave_interface

read_file -top $design -format sverilog -sva -vcs {../RTL/AHB_Slave_Interface.sv}

create_clock Hclk -period 100 
create_reset Hresetn -sense low

sim_run -stable 
sim_save_reset
