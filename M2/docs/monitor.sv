class monitor; 

virtual interface_fifo in;

 mailbox mts;
 
 function new(virtual interface_fifo in,mailbox mts);
  this.in = in;
  this.mts = mts;
 endfunction
 
 task write();
  int h = 1;
  int P = 0;
    fork
    forever begin
    transcation trans;
    trans = new();
    @(posedge in.moni.wclk);
    if(in.moni.w_en)begin
        trans.w_en = in.moni.w_en ;
        trans.data_in = in.moni.data_in; 
        trans.full = in.moni.full;
        trans.empty = in.moni.empty;
		@(posedge in.moni.wclk);
    end
	//@(posedge in.moni.rclk)
    if(in.moni.r_en)begin
        trans.r_en = in.moni.r_en;
        @(posedge in.moni.rclk);
        trans.data_out = in.moni.data_out;
        trans.full = in.moni.full;
        trans.empty = in.moni.empty;
    end
    if(h==1) begin $display("[Monitor] Brust_ID=%2d,Packet_id=%2d, w_en=%d,r_en=%d,data_in=%d,data_out=%d,full=%d,empty=%d",h,P,trans.w_en,trans.r_en,in.data_in,in.data_out,in.full,in.empty);
    mts.put(trans); 
    end
    P++;
     if(P==512) h++;
    end   
    join_none
 endtask
endclass