`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "interface.sv"
`include "FIFO_seq_item.sv"
`include "sequence_fifo_wr.sv"
`include "sequencer.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "coverage_uvm.sv"
`include "env.sv"
`include "uvmtest.sv"

module top_uvm;

parameter depth=256; 
parameter data_width=8;
parameter ptr_width=8;


	bit rclk;
	bit wclk;
	bit w_rst_n, r_rst_n;

	intfc ifuvm(.wclk(wclk), .rclk(rclk), .w_rst_n(w_rst_n), .r_rst_n(r_rst_n));
	top #(.depth(depth), .data_width(data_width), .ptr_width(ptr_width)) t1 (.in(ifuvm));

	initial begin
		uvm_config_db #(virtual intfc):: set(null, "*", "vif", ifuvm);
	end
	
	
	initial begin
		run_test("uvmtest");
	end
	
	always #2 rclk=~rclk;
    always #1 wclk=~wclk;
	
	
    initial begin
	    w_rst_n = 0;
		r_rst_n = 0;
		
		#15 w_rst_n = 1;
		#15 r_rst_n = 1;
    end
	
	
	initial begin
		#100000;
		$display("Finished clock cycles");
		$finish;
	end
	
	
endmodule