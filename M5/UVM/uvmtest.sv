class uvmtest extends uvm_test;
	`uvm_component_utils(uvmtest)
	
	env e0;
	fifo_sequence    reset_seq;
	fifo_sequence_wr write_seq;
	sequence_fifo_rd read_seq;

	function new(string name ="uvmtest",uvm_component parent);
		super.new(name,parent);
		`uvm_info("TEST CLASS", "Inside Constructor",UVM_LOW)
	endfunction
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("TEST CLASS", "Inside Build_phase",UVM_LOW)
		e0 = env::type_id::create("e0",this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("TEST CLASS", "Inside Connect phase",UVM_LOW)
		
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("TEST CLASS", "Inside Run phase",UVM_LOW)
		phase.raise_objection(this);
		
			reset_seq=	fifo_sequence::type_id::create("reset_seq");
			reset_seq.start(e0.agnt.s0);
			
		#10;
			write_seq=	fifo_sequence_wr::type_id::create("write_seq");
			write_seq.start(e0.agnt.s0);
		#2;

			read_seq= sequence_fifo_rd::type_id::create("read_seq");
			read_seq.start(e0.agnt.s0);
		#4;
			
		phase.drop_objection(this);
	endtask

function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
  uvm_root::get().print_topology();
endfunction

endclass