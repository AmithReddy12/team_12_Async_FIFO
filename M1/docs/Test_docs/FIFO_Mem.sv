module fifo_mem #(parameter DEPTH=256, DATA_WIDTH=8, PTR_WIDTH=8) (
  input wclk, w_en, rclk, r_en,
  input [PTR_WIDTH-1:0] b_wptr, b_rptr,
  input [DATA_WIDTH-1:0] data_in,
  input full, empty,
  output reg [DATA_WIDTH-1:0] data_out,
  output reg write_error, read_error,half_full,half_empty
);
  reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
  int w_count,r_count;
  
  //write block
  always_ff @(posedge wclk) begin
    write_error = 0;
    if(w_en) begin
      if(full) begin
       write_error  = 1;
      end 
      else if (!full && w_count == 2) begin
		if(b_wptr == DEPTH/2)
			half_full <=1;
		else
			half_full <= 0;
       fifo[b_wptr[PTR_WIDTH-1:0]] <= data_in;
	   w_count = 0;
      end
	  w_count++;
  end 
  end


   //Read block
  always_ff @(posedge rclk) begin
    read_error = 0;
    if(r_en) begin
		if(empty) begin
		  read_error = 1;
		end
		else if (!empty && r_count == 4) begin
			if(b_rptr == DEPTH/2)
				half_empty <= 1;
			else
				half_empty <= 0;
			  data_out <= fifo[b_rptr[PTR_WIDTH-1:0]];
			  r_count = 0;
		end
		else
			r_count++;
    end
  end

endmodule
