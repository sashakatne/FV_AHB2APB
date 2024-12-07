
set_fml_appmode FXP
set design Bridge_Top

read_file -top $design -format sverilog -sva -vcs {-f ../RTL/filelist}

create_clock Hclk -period 100 
create_reset Hresetn -sense low

sim_run -stable 
sim_save_reset
