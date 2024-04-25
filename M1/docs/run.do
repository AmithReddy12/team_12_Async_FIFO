vlog -source -lint -sv *.sv
vsim -gui -voptargs=+acc work.asynchronous_fifo_tb
#do wave.do
add wave -r *
run -all
quit -sim