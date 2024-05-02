class scoreboard;
 virtual interface_fifo in;
 mailbox mts;
 transcation trans;
 int no_trans= '0;
 bit[7:0]ram[0:256-1];
 bit wr_ptr;
 bit rd_ptr;

 
 function new(virtual interface_fifo in,mailbox mts);
   this.in = in;
   this.mts = mts;
   foreach(ram[i])begin
    ram[i] = 8'h00;
   end
 endfunction 
 
  task write();
   int h = 1;
   int P = 0;
   fork
   forever begin
	 //transcation trans;
    trans = new();
    mts.get(trans);
    if(trans.w_en)begin
      ram[wr_ptr] = trans.data_in;
      wr_ptr++;
	  //repeat(2)@(posedge in.wclk); 
    end  
    if(trans.r_en)begin
      if(trans.data_out == ram[rd_ptr])begin
        rd_ptr++;
        if(h==1) $display("[Scoreboard] Brust_ID=%2d,---->>>>>>>>>>>>>>>>>>>>>Passed<<<<<<<<<<<<<<<<<-----\n",h);
		repeat(3) @(posedge in.rclk);
      end
      else begin
        $display("Failed");
        $display("data_out=%d,sc_data=%d",trans.data_out,ram[rd_ptr]);
      end
    end
    P++;
    if(P==256) h++;
   end
   join
  endtask
endclass