`include "interface.sv"
`include "test.sv"
module async_fifo_TB;

 

 interface_fifo in();
 test tet(in);
 
 asynchronous_fifo as_fifo (.wclk(in.wclk),.wrst_n(in.wrst_n),.rclk(in.rclk),.rrst_n(in.rrst_n),
                            .w_en(in.w_en),.r_en(in.r_en),.data_in(in.data_in),.data_out(in.data_out),.full(in.full),.empty(in.empty),.write_error(in.write_error),
                            .read_error(in.read_error));


  always #1ns in.wclk = ~in.wclk;
  always #2ns in.rclk = ~in.rclk;

 initial begin
    in.wclk = 1;
    in.rclk = 1;
 end 


endmodule
