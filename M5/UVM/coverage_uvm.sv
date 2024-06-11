class coverage extends uvm_test ;
`uvm_component_utils(coverage)
uvm_analysis_imp #(fifo_seq_item, coverage) coverage_port;

real coverage_score1;
real coverage_score2;
real coverage_score3;
real total_coverage;
fifo_seq_item cov_pkt;
virtual intfc cov_if;

covergroup cov_mem with function sample(fifo_seq_item cov_pkt) ;
    a1: coverpoint cov_pkt.waddr {
       bins waddr[]= {[0:255]};
     }
	 a2: coverpoint cov_pkt.raddr {
     bins raddr[]= {[0:255]};
     }
   endgroup

covergroup test_write with function sample(fifo_seq_item w_pkt) ;

c0:coverpoint w_pkt.w_rst_n{
             bins RESET_1 = {1};
			 bins RESET_0 ={0};
			 }
c1:coverpoint w_pkt.empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c2:coverpoint w_pkt.full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
			 
c3 : coverpoint w_pkt.w_en {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }

c4 : coverpoint w_pkt.data_in {
             bins wr_data = {[0:255]};
			  }

c10 : coverpoint w_pkt.r_en {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
c12 : coverpoint w_pkt.half_full {
			bins h_full_o = {1};
			bins h_full_z = {0};
			}
			  
read_and_fifo_empty:cross c3,c1;      
read_write_fifo_empty:cross c3,c4,c1;
read_and_clear:cross c3,c0;
write_and_fifo_full:cross c4,c2;
clear_and_fifo_empty:cross c1,c0;

endgroup

covergroup test_read with function sample(fifo_seq_item r_pkt) ;
c5 : coverpoint r_pkt.r_en {
             bins read_1 = {1};
			 bins read_0 = {0};
			 }
c6: coverpoint r_pkt.r_rst_n {
             bins r_rst_n_high = {1};
			 bins r_rst_n_low = {0};
			 }			 

c7 : coverpoint r_pkt.data_out {
             bins rd_data = {[0:255]};
			  }
			  
c8:coverpoint r_pkt.empty {
             bins  fifo_empty_1 = {1};
			 bins fifo_empty_0 = {0};
			 }
c9:coverpoint r_pkt.full {
             bins fifo_full_1 = {1};
			 bins fifo_full_0 = {0};
}
c11 : coverpoint r_pkt.w_en {
             bins write_1 = {1};
			 bins write_0 = {0};
			 }
c13 : coverpoint r_pkt.half_empty {
			bins h_empty_o = {1};
			bins h_empty_z = {0};
			}

read_and_fifo_emptyr:cross c5,c8;
read_write_fifo_emptyr:cross c11,c5,c8;
write_and_fifo_fullr:cross c9,c11;
clear_and_fifo_empty:cross c6,c8;


endgroup

function new (string name="coverage",uvm_component parent);
super.new(name,parent);
`uvm_info("*****COVERAGE_CLASS*****", "Inside Constructor!", UVM_LOW)
cov_mem=new();
test_write=new();
test_read=new();
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("*****COVERAGE_CLASS*****\N", "Inside Build Phase function", UVM_HIGH)
   
    coverage_port = new("coverage_port", this); 
endfunction
  

function void write(fifo_seq_item t);
cov_mem.sample(t);
test_read.sample(t);
test_write.sample(t);

endfunction

function void extract_phase(uvm_phase phase);
   super.extract_phase(phase);
  coverage_score1=cov_mem.get_coverage();
coverage_score2=test_write.get_coverage();
coverage_score3=test_read.get_coverage();
endfunction


function void report_phase(uvm_phase phase);
	super.report_phase(phase);
	`uvm_info("*****COVERAGE*****",$sformatf("*****Coverage=%0f%% *****",coverage_score1),UVM_MEDIUM);
	`uvm_info("*****COVERAGE*****",$sformatf("*****Coverage=%0f%% *****",coverage_score2),UVM_MEDIUM);
	`uvm_info("*****COVERAGE*****",$sformatf("*****Coverage=%0f%% *****",coverage_score3),UVM_MEDIUM);
endfunction

endclass