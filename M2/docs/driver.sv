class driver;
  transcation trans;
  virtual interface_fifo in;
  mailbox gtd;
  mailbox dtg;
  int no_trans = 0;
  
  function new (virtual interface_fifo in, mailbox gtd);
    this.in = in;
    this.gtd = gtd;
  endfunction
    
  task reset();
    in.wclk = 1'b0; in.wrst_n = 1'b0;
    in.w_en = 1'b0;
    in.data_in = 0;
    in.rclk = 1'b0; in.rrst_n = 1'b0;
    in.r_en = 1'b0; 
    repeat(5) @(posedge in.wclk);
    in.wrst_n = 1'b1;
    in.rrst_n = 1'b1;
    in.w_en = 1'b1;
  endtask :reset;
  
  task write_read();
    int h = 1;
    int p = 0;
    fork
      forever begin
        trans = new();
        gtd.get(trans);
        in.w_en <= 1;
        @(posedge in.wclk);
        if (in.w_en) begin
          in.w_en <= trans.w_en;
          in.data_in <= trans.data_in;
          //@(posedge in.wclk);
        end
        in.r_en <= 1;
        if (h == 1) begin
          $display("[Driver] Brust_ID=%2d, Packet_id=%2d, w_en=%d, r_en=%d, data_in=%d", h, p, in.w_en, in.r_en, in.data_in);
        end
        @(posedge in.rclk);
        if (in.r_en) begin
          in.r_en <= trans.r_en;
          @(posedge in.rclk);
          trans.data_out = in.data_out;
          trans.full = in.full;
          trans.empty = in.empty;
          repeat(2) @(posedge in.rclk);
          in.r_en <= 0;
        end
        p++;
        if (p == 256) h++;
        no_trans++;
        @(posedge in.wclk);
      end
    join_none
  endtask
  
 task write(transcation trans);
  forever begin
    int h = 1;
    //trans = new();
    gtd.get(trans);
    in.w_en <= 1;
    @(posedge in.wclk);
    if(in.w_en) begin
	    in.w_en <= trans.w_en;
	    in.data_in <= trans.data_in;
	    @(posedge in.wclk);
	    in.w_en <= '0;
    end
  end
 endtask
	
  task read(transcation trans);
    forever begin
    //int h = 1;
    in.r_en <= 1;
        //if (h == 1) begin
          //$display("[Driver] Brust_ID=%2d, Packet_id=%2d, w_en=%d, r_en=%d, data_in=%d", h, p, in.w_en, in.r_en, in.data_in);
        //end
        @(posedge in.rclk);
        if (in.r_en) begin
          in.r_en <= trans.r_en;
          @(posedge in.rclk);
          trans.data_out = in.data_out;
          trans.full = in.full;
          trans.empty = in.empty;
          repeat(2) @(posedge in.rclk);
          in.r_en <= 0;
        end
        //p++;
        //if (p == 256) h++;
        //no_trans++;
        //@(posedge in.wclk);
    end
  endtask
	// task read();
		// int h=1;
		
		// forever begin
			// trans = new();
			// gtd.get(trans);
			// in.r_en <=1;
			
	
endclass
