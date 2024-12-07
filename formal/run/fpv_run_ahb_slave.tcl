
# Select AEP as the VC Formal App mode
set_fml_appmode FPV
set design AHB_slave_interface

read_file -top $design -format sverilog -sva  -vcs {-f ../RTL/filelist}

# Creating clock and reset signals
create_clock Hclk -period 100 
create_reset Hresetn -sense low

# Runing a reset simulation
sim_run -stable 
sim_save_reset
