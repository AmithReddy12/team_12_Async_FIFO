module rptr_handler #(parameter PTR_WIDTH=8) (
  input rclk, rrst_n, r_en,
  input [PTR_WIDTH-1:0] g_wptr_sync,
  output reg [PTR_WIDTH-1:0] b_rptr, g_rptr,
  output reg empty
);

  reg [PTR_WIDTH-1:0] b_rptr_next;
  reg [PTR_WIDTH-1:0] g_rptr_next;
  reg rempty;
  int r_count;
  
  assign b_rptr_next = b_rptr + (r_en & !empty & (r_count%5)) ;
  assign g_rptr_next = (b_rptr_next >> 1) ^ b_rptr_next;
  assign rempty = (g_wptr_sync == g_rptr_next);

  always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) begin
      b_rptr <= 0;
      g_rptr <= 0;
    end else if(r_count%5 && r_en) begin
        b_rptr <= b_rptr_next;
        g_rptr <= g_rptr_next; 
      end
    end
   
  always_ff @(posedge rclk or negedge rrst_n) begin
    if (!rrst_n) empty <= 1;
    else empty <= rempty;
  end
  
  always_ff @(posedge rclk or negedge rrst_n)begin
	if(!rrst_n)
		r_count <=0;
	else
		r_count++;
  end
endmodule
