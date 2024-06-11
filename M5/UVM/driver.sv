class driver extends uvm_driver #(fifo_seq_item);
	`uvm_component_utils(driver) //factory registration
	
	virtual intfc vif;
	fifo_seq_item drv_pkt;
	
	function new(string name ="driver",uvm_component parent);
		super.new (name,parent);
		`uvm_info("***DRIVER***", "Inside Constructor function!",UVM_LOW)
	endfunction
	
	function void build_phase (uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("***DRIVER_CLASS***", "inside Build Phase function!",UVM_LOW)
		//Config database
		if(!(uvm_config_db #(virtual intfc)::get(this,"*","vif",vif)))
		begin
			`uvm_error("***DRIVER_CLASS***", "Inside driver_class build_phase Failed to get virtual_interface from config Database")
		end
		
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("***DRIVER CLASS***", "Inside Connect Phase function",UVM_LOW)
		
	endfunction	

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info("DRIVER CLASS", "Inside run Phase",UVM_LOW)
		forever 
		 begin
			drv_pkt = fifo_seq_item#(8,8,256)::type_id::create("drv_pkt"); //object creation for the drv_pkt
			seq_item_port.get_next_item(drv_pkt); //get next transaction
			drive(drv_pkt);
			seq_item_port.item_done();//transaction done
		 end
    endtask
	
	//Drive Method
	task drive(fifo_seq_item drv_pkt);
		begin
		if (!drv_pkt.w_rst_n & !drv_pkt.r_rst_n) begin
			vif.w_rst_n <= drv_pkt.w_rst_n;
			vif.r_rst_n <= drv_pkt.r_rst_n;
		end
		else begin
			if(drv_pkt.w_en & !drv_pkt.r_en) //write data from driver to monitor via interface 
			  begin
			  vif.w_rst_n <= drv_pkt.w_rst_n;
				vif.r_rst_n <= drv_pkt.r_rst_n;
				vif.w_en <= drv_pkt.w_en;
				vif.r_en <= drv_pkt.r_en;
				vif.data_in <= drv_pkt.data_in;
				@(posedge vif.wclk);			
				`uvm_info("***** DRIVER_WRITE ***** ",$sformatf("Burst_Details:time=%0d,w_en=%d,r_en=%d,data_in=%d,full=%0d,empty=%0d,waddr=%d",$time,vif.w_en,vif.r_en,vif.data_in,vif.full,vif.empty,vif.waddr),UVM_LOW) 
				
			  end

			if(drv_pkt.r_en & !drv_pkt.w_en) //read transaction from driver to interface
			  begin
			    vif.w_rst_n <= drv_pkt.w_rst_n;
				vif.r_rst_n <= drv_pkt.r_rst_n;
				vif.r_en <= drv_pkt.r_en;
				vif.w_en <= drv_pkt.w_en;
				vif.data_in <= drv_pkt.data_in;
				 @(posedge vif.rclk);
				`uvm_info("***** DRIVER_READ *****",$sformatf("Burst_Details:time=%0d,w_en=%d,r_en=%d,data_out=%d,full=%0d,empty=%0d,raddr=%d",$time,vif.w_en,vif.r_en,vif.data_out,vif.full,vif.empty,vif.raddr),UVM_LOW)
			    
			  end
			  
		end
	end
	endtask
endclass
    		 
			 
		
	