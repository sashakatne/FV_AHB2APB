vlib work
vmap work work

vlog -source -lint AHB_Slave_Interface.sv
vlog -source -lint APB_Controller.sv
vlog -source -lint bridge_top.sv

#Testbench compilation
vlog -source -lint bridge_top_tb.sv

vsim -voptargs=+acc work.Bridge_Top_tb

add wave -position insertpoint sim:/Bridge_Top_tb/uut/*
add wave -position insertpoint sim:/Bridge_Top_tb/uut/APBControl/*
add wave -position insertpoint sim:/Bridge_Top_tb/uut/AHBSlave/*

run -all