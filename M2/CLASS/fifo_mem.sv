module fifo_mem #(parameter DEPTH=256, DATA_WIDTH=8, PTR_WIDTH=8) (
  input wclk, w_en, rclk, r_en,
  input [PTR_WIDTH-1:0] b_wptr, b_rptr,
  input [DATA_WIDTH-1:0] data_in,
  input full, empty,
  output reg [DATA_WIDTH-1:0] data_out,
  output reg write_error, read_error,
  input wrst_n,rrst_n,
  output reg half_empty,half_full
);
  reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
  
int w_count;
int r_count;


assign half_full=(b_wptr == 8'b01010000)?1'b1:1'b0;
assign half_empty=(b_rptr == 8'b01010000)?1'b1:1'b0;
  
  always_ff @(posedge wclk) begin
    write_error = 0;
    if(w_en) begin
      if(full) begin
       write_error  = 1;
      end 
      else if (w_count%2==0 && !full) begin
       fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
      end
  end 
  end


   
  always_ff @(posedge rclk) begin
    read_error = 0;
    if(r_en) begin
     if(empty) begin
      read_error = 1;
     end
     else if (r_count%4==0 && !empty) begin
      data_out <= fifo[b_rptr[PTR_WIDTH-1:0]];
    end
    end
  end
  
always_ff@(posedge wclk)
	begin
	if(wrst_n)
	w_count=0;
	else
	w_count=w_count+1;
end

always_ff@(posedge rclk)
	begin
	if(rrst_n)
	r_count=0;
	else
	r_count=r_count+1;
end

endmodule