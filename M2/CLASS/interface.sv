interface interface_fifo;
  parameter DATA_WIDTH = 8;
  logic wclk, wrst_n;
  logic rclk, rrst_n;
  logic w_en, r_en;
  logic [DATA_WIDTH-1:0] data_in;
  logic [DATA_WIDTH-1:0] data_out;
  logic full, empty, write_error, read_error,half_empty,half_full;

    
  clocking moni@(posedge wclk or posedge rclk);
    input wclk,rclk;
    input r_en;
    input w_en;
    input data_in;
    input data_out;
    input full,empty;
	input half_full,half_empty;
  endclocking
  
    modport MON (clocking moni);

endinterface 