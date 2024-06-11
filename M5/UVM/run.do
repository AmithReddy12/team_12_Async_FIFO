vlib work
vdel -all
vlib work

vlog -coveropt 3 +cover +acc w2rsync.sv r2wsync.sv write_ptr.sv read_ptr.sv fifo_mem.sv top_uvm.sv top.sv


vopt top_uvm -o top_optimized  +acc +cover=sbfec+top(rtl).
vsim top_optimized -coverage +UVM_VERBOSITY=UVM_HIGH
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
add wave -r sim:/top_uvm/*
run -all

coverage save full_empty_cov.ucdb
vcover report full_empty_cov.ucdb 
vcover merge -out Final_cov.ucdb full_empty_cov.ucdb cov.ucdb
vcover report Final_cov.ucdb -cvg -details
quit -sim