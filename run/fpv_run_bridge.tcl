
set_fml_appmode FPV
set design Bridge_Top

read_file -top $design -format sverilog -sva -aep all -vcs {-f ../RTL/filelist +define+INLINE_SVA ../RTL/bridge_top_sva.sv}

create_clock Hclk -period 100 
create_reset Hresetn -sense low

sim_run -stable 
sim_save_reset

