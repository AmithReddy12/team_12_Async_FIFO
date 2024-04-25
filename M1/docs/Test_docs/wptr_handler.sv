module wptr_handler #(parameter PTR_WIDTH=8) (
  input wclk, wrst_n, w_en,
  input [PTR_WIDTH-1:0] g_rptr_sync,
  output reg [PTR_WIDTH-1:0] b_wptr, g_wptr,
  output reg full
);

  reg [PTR_WIDTH-1:0] b_wptr_next;
  reg [PTR_WIDTH-1:0] g_wptr_next;
   
  reg wrap_around;
  wire wfull;
  int w_count;
  
  assign b_wptr_next = b_wptr+(w_en & !full & (w_count%3));
  assign g_wptr_next = (b_wptr_next >>1)^b_wptr_next;
  
  always_ff @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) begin
      b_wptr <= 0; 
      g_wptr <= 0;
    end
    else begin
      b_wptr <= b_wptr_next; 
      g_wptr <= g_wptr_next; 
    end
  end
  
  //updating the Full
  always_ff @(posedge wclk or negedge wrst_n) begin
    if(!wrst_n) full <= 0;
    else        full <= wfull;
  end
  
  always_ff @(posedge wclk or negedge wrst_n) begin
	if(!wrst_n)
		w_count<=0;
	else
		w_count++;
  end

  assign wfull = (g_wptr_next == {~g_rptr_sync[PTR_WIDTH:PTR_WIDTH-1], g_rptr_sync[PTR_WIDTH-2:0]});

endmodule
