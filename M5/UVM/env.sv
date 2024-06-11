class env extends uvm_env;
	`uvm_component_utils(env)
	agent agnt;
	scoreboard scb;
	coverage cov;

	function new(string name ="env" , uvm_component parent);
		super.new(name,parent);
		`uvm_info("***** ENVIRONMENT CLASS *****\n", "Inside Constructor",UVM_LOW)
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("***** ENVIRONMENT CLASS *****\n", "Build Phase",UVM_LOW)

		agnt = agent ::type_id::create("agnt",this); //create object for the agent class
		scb = scoreboard:: type_id::create("scb", this); //create object for the scoreboard class
		cov=coverage::type_id::create("cov",this); //create object for the coverage class
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("*****ENVIRONMENT CLASS*****", "Connect Phase",UVM_LOW)
		
		agnt.mon.monitor_port.connect(scb.scoreboard_port); //connecting monitor to scoreboard via analysis port
		agnt.mon.monitor_port.connect(cov.coverage_port);  //connecting monitor to coverage class via analysis port
	endfunction
	
	task run_phase (uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("***** ENVIRONMENT CLASS *****", "Inside Run Phase",UVM_LOW)
	endtask
endclass
		
	
	
	
	