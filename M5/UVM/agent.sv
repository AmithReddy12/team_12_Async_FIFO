class agent extends uvm_agent;
	`uvm_component_utils(agent)

	sequencer s0;
	driver d0;
	monitor mon;

	function new(string name ="agent",uvm_component parent);
		super.new(name,parent);
		`uvm_info("***AGENT_CLASS***\n", "Inside Constructor",UVM_LOW)
	endfunction
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		
		`uvm_info("***AGENT_CLASS***\n", "Inside build phase connection",UVM_LOW)
		s0 = sequencer::type_id::create("s0",this);
		d0 = driver::type_id::create("d0",this);
		mon = monitor:: type_id::create("mon", this);
	endfunction
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("***AGENT_CLASS***\n", "Inside connect phase function",UVM_LOW)
		d0.seq_item_port.connect(s0.seq_item_export);
	endfunction

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("***AGENT_CLASS***\n", "Inside build phase connection",UVM_LOW)
	endtask
	
endclass