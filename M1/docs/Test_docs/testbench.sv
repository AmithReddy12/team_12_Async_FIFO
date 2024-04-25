`timescale 1ns/1ps

module asynchronous_fifo_tb;
parameter DEPTH= 256; parameter DATA_WIDTH = 8; 
bit wclk,rclk;
bit reset,wr_en,rd_en;
logic [DATA_WIDTH-1:0]data_in;
logic [DATA_WIDTH-1:0]data_out;
logic full,empty,almost_full,almost_empty,half_empty,half_full;




 asynchronous_fifo as_fifo (.wclk(wclk),.wrst_n(reset),.rclk(rclk),.rrst_n(reset),
                            .w_en(wr_en),.r_en(rd_en),.data_in(data_in),.data_out(data_out),.full(full),.empty(empty),.write_error(almost_full),
                            .read_error(almost_empty),.half_full(half_full),.half_empty(half_empty));

initial
begin
wclk=1'b1;
forever #2 wclk=~wclk;
end

initial
begin
rclk=1'b1;
forever #5 rclk=~rclk;
end

task initialize;
begin
data_in='0;
wr_en='0;
rd_en='0;
end
endtask

task rst;
@(negedge wclk)
@(negedge rclk)
reset=1'b0;
@(negedge wclk)
@(negedge rclk)
reset=1'b1;
endtask

task write;
begin
for(int i=0;i<256;i++) begin
@(posedge wclk);
wr_en=1'b1;
data_in=i;
repeat(2) @(posedge wclk);
end

@(posedge wclk);
wr_en=1'b0;
data_in=0;
end
endtask

task read;
begin
for(int i=0; i<256; i++)begin
@(posedge rclk);
rd_en=1'b1;
repeat(4) @(posedge rclk);
end

@(posedge rclk);
rd_en=1'b0;
end
endtask

initial
#8000 $finish();

  initial begin
    initialize;
    rst;
    fork
      write;
      read;
    join
    end

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end

endmodule
