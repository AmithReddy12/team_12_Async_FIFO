class scoreboard;
 virtual interface_fifo in;
 mailbox mts;
 transcation trans;
 int no_trans= '0;
 bit[7:0]ram[0:256-1];
 int wr_ptr;
 int rd_ptr;

 
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
    trans = new();
    mts.get(trans);
    if(trans.w_en)begin
      ram[wr_ptr] = trans.data_in;
	  $display("****** ram[%0d] = %0d",wr_ptr,ram[wr_ptr]);
	  wr_ptr++;
    end  
    if(trans.r_en)begin
      if(trans.data_out == ram[rd_ptr])begin
        if(h==1) $display("[Scoreboard] Brust_ID=%2d,---->>>>>>>>>>>>>>>>>>>>>Passed trans.data_out = %0d, data_in[%0d] = %0d<<<<<<<<<<<<<<<<<-----\n ",h,trans.data_out,rd_ptr,ram[rd_ptr]);
		rd_ptr++;
      end
      else begin
        $display("Failed");
        $display("data_out=%d,sc_data=%d",trans.data_out,ram[rd_ptr]);
      end
    end
    P++;
	no_trans++;
    if(P==256) h++;
   end
   join
  endtask
endclass