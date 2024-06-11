class monitor extends uvm_monitor;
`uvm_component_utils(monitor)
virtual intfc vif; 
fifo_seq_item mon_pkt;

uvm_analysis_port #(fifo_seq_item) monitor_port; //analysis port declaration

function new (string name="monitor", uvm_component parent);
	super.new(name, parent);
	`uvm_info(" ***** @MONITOR *****", "Constructoring Phase",UVM_LOW)
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("***** @MONITOR *****", "Build Phase",UVM_LOW)
	monitor_port = new("monitor_port", this);
	if(!(uvm_config_db # (virtual intfc):: get (this, "*", "vif", vif))) 
	begin
	`uvm_error (" ***** monitor CLASS *****", "monitor class build phase , Failed to get virtual Interface from configured DataBase!")
	end
endfunction


function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("***** @MONITOR *****", "Connect Phase!",UVM_LOW)
endfunction

task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("***** @MONITOR *****", "Run Phase!",UVM_LOW)
	
	forever begin
	
		//write monitor - transfer data from driver using virtual interface to write monitor 
		mon_pkt = fifo_seq_item #(8,8,256)::type_id::create("mon_pkt");
		wait (vif.w_rst_n && vif.r_rst_n);
		if(vif.w_en & !vif.r_en)
		begin
			@(posedge vif.wclk);
		
			mon_pkt.w_en=vif.w_en;
			mon_pkt.r_en=vif.r_en;
			mon_pkt.waddr= vif.waddr;
			mon_pkt.raddr=vif.raddr;
			mon_pkt.data_in= vif.data_in;
			mon_pkt.data_out= vif.data_out;
			mon_pkt.full= vif.full;
			mon_pkt.empty= vif.empty;
			mon_pkt.half_full = vif.half_full;
			mon_pkt.half_empty = vif.half_empty;
			`uvm_info("***** MONITOR WRITE *****",$sformatf("Burst_Details:time=%0d,w_en=%d,r_en=%d,data_in=%d,full=%0d,empty=%0d, w_addr=%d, half_empty = %d, half_full = %d,",$time,vif.w_en,vif.r_en,vif.data_in,vif.full,vif.empty,vif.waddr, vif.half_empty, vif.half_full),UVM_LOW) 
		end
		
		//read monitor - transfer data from dut using virtual interface to read monitor 
		if(vif.r_en & !vif.w_en)
		begin
		    @(posedge vif.rclk);
			mon_pkt.w_en=vif.w_en;
			mon_pkt.r_en=vif.r_en;
			mon_pkt.waddr= vif.waddr;
			mon_pkt.raddr=vif.raddr;
			mon_pkt.data_in= vif.data_in;
			mon_pkt.data_out= vif.data_out;
			mon_pkt.full= vif.full;
			mon_pkt.empty= vif.empty;
			mon_pkt.half_full = vif.half_full;
			mon_pkt.half_empty = vif.half_empty;
			`uvm_info(" ***** MONITOR READ *****",$sformatf("Burst_Details:time=%0d,w_en=%d,r_en=%d,data_out=%d,full=%0d,empty=%0d, raddr=%d, half_empty = %d, half_full = %d",$time,vif.w_en,vif.r_en,vif.data_out,vif.full,vif.empty,vif.raddr, vif.half_empty, vif.half_full),UVM_LOW)
			
		end
		monitor_port.write(mon_pkt);
	end
endtask

endclass