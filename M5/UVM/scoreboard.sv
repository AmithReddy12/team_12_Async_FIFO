class scoreboard extends uvm_test;
	`uvm_component_utils(scoreboard)
	 
	 bit [7:0]trans_data[$];
	 fifo_seq_item trans[$];
	 uvm_analysis_imp #(fifo_seq_item,scoreboard) scoreboard_port; //analysis port declaration

	function new(string name= "scoreboard",uvm_component parent);
		super.new(name,parent);
		`uvm_info("***** SCOREBOARD *****", "Constructor",UVM_LOW)
	endfunction
	
	function void build_phase(uvm_phase phase); //build_phase
	 super.build_phase(phase);
		`uvm_info("***** SCOREBOARD *****", "Build phase",UVM_LOW)
		
		scoreboard_port = new("scoreboard_port",this);
		
		endfunction

	function void connect_phase(uvm_phase phase); //connect_phase
		super.connect_phase(phase);
		
		`uvm_info("***** SCOREBOARD *****", "Connect Phase",UVM_LOW)
	endfunction

	task run_phase(uvm_phase phase); //run_phase
		super.run_phase(phase);
		`uvm_info("***** SCOREBOARD *****", "Run Phase",UVM_LOW)
	 forever 
	 begin

	 fifo_seq_item curr_trans;
	    wait(trans.size!=0);
		curr_trans=trans.pop_back();
		read(curr_trans);
	 end
	endtask
	 
	 function void write(fifo_seq_item seqitem); //write data into queue
	 trans.push_front(seqitem);
	   if(seqitem.w_en &!seqitem.full)
	   begin
		trans_data.push_front(seqitem.data_in);
		`uvm_info("***** Scoreboard write data_in *****",$sformatf("Burst_Details:w_en=%d, data_in=%d, full=%0d",seqitem.w_en, seqitem.data_in, seqitem.full),UVM_LOW) 
		end
	endfunction
	

	task read(fifo_seq_item read_trans);
	   bit [7:0] actual;
	   bit [7:0] expected_data;
	   
	//compare actual data and expected data
	   if(read_trans.r_en &!read_trans.empty)
	   begin
		actual = read_trans.data_out;
	    expected_data= trans_data.pop_back();
		 
	    `uvm_info("***** Scoreboard_getting read data_in *****",$sformatf("Burst_Details:r_en=%d, data_in=%d, full=%0d",read_trans.r_en, read_trans.data_in, read_trans.empty),UVM_LOW)
		end
		if(actual != expected_data) begin
			`uvm_error("Comparing_read", $sformatf("transaction failed actual=%d, expected_data=%d", actual,expected_data)) 
		end
		else if(actual == 0 && expected_data == 0) begin
			`uvm_error("NO DATA DRIVEN", $sformatf("transaction failed BUG IN THE CODE actual=%d, expected_data=%d", actual,expected_data))
		end
		else begin
			`uvm_info("Comparing_read", $sformatf("transaction passed actual=%d, expected_data=%d", actual,expected_data), UVM_LOW) 
		end
		
	endtask	
		
endclass
	
	

	 
