vlog -source -lint test.sv testbench.sv top.sv
vsim -gui -voptargs=+acc work.async_fifo_TB
#do wave.do
add wave -r *
run -all
quit