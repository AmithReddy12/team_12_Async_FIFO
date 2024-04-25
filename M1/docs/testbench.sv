`timescale 1ns/1ps

module asynchronous_fifo_tb;
parameter depth= 256; 
parameter width = 8; 
bit wclk,rclk;
bit reset,w_en,r_en;
logic [width-1:0]data_in;
logic [width-1:0]data_out;
logic full,empty,half_full,half_empty;
logic[7:0]rdptr,wrptr;

asynchronous_fifo dut (wclk,rclk,reset,w_en,r_en,data_in,data_out,full,empty,half_full,half_empty);

initial
begin
wclk=1'b1;
forever #1.5 wclk=~wclk;
end

initial
begin
rclk=1'b1;
forever #5 rclk=~rclk;
end

task initialize;
begin
data_in='0;
w_en='0;
r_en='0;
end
endtask

task rst;
@(negedge wclk)
@(negedge rclk)
reset=1'b1;
@(negedge wclk)
@(negedge rclk)
reset=1'b0;
endtask

task write;
begin
for(int i=0;i<512;i++) begin
@(posedge wclk);
w_en=1'b1;
data_in=i;
repeat(2) @(posedge wclk);
end

/*@(posedge wclk);
w_en=1'b0;
data_in=0;*/
end
endtask

task read;
begin
for(int i=0; i<512; i++)begin
@(posedge rclk);
r_en=1'b1;
repeat(4)@(posedge rclk);
end

/*@(posedge rclk);
r_en=1'b0;*/
end
endtask

initial
#10000 $finish();

  initial begin
    initialize;
    rst;
    fork
      write;
      read;
    join
    end

	initial
	$monitor("time=",$time,"		datain=%b, dataout=%b, read_en=%b,write_en=%b,empty=%b,full=%b",data_in,data_out,r_en,w_en,empty,full);

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end

endmodule