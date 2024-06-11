import uvm_pkg::*;
`include "uvm_macros.svh"

class fifo_seq_item #(parameter  data_width =8, ptr_width = 8, depth=256)extends uvm_sequence_item;
    `uvm_object_utils(fifo_seq_item #(8,8,256)) //factory registration
	
	rand bit w_en;
	rand bit r_en;
	rand bit w_rst_n;
	rand bit r_rst_n;
	rand bit [data_width-1:0] data_in;
	bit [data_width-1:0] data_out;
	bit empty, full, half_full, half_empty;
	bit [ptr_width:0] waddr, raddr;
	
	constraint no_rst {w_rst_n == 1 && r_rst_n ==1;} //No reset when w_rst_n and r_rst_n are highs
	function string convert2str();
	   return $sformatf ("w_en =%0d, r_en =%0d,data_in =%0d",w_en,r_en,data_in);
	endfunction

	function new (string name = "fifo_seq_item");
		super.new(name);
	endfunction
endclass
		
	