class transcation;

  parameter DATA_WIDTH = 8;
   bit w_en;
   bit r_en;
  rand bit [DATA_WIDTH-1:0] data_in;
  bit [DATA_WIDTH-1:0] data_out;
  bit full, empty, write_error, read_error;


endclass