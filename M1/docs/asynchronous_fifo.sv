module asynchronous_fifo # ( parameter depth= 256, parameter width = 8)( input logic wclk,rclk,reset,w_en,r_en,
input logic [width-1:0]data_in,
output logic [width-1:0]data_out,
output logic full,empty,half_full,half_empty);

reg [width-1:0] mem [depth-1:0];
logic [7:0]wrptr,rdptr;

int w_count;
int r_count;


assign full=(wrptr == 8'b10100000)?1'b1:1'b0;
assign empty=(rdptr == wrptr)?1'b1:1'b0;
assign half_full=(wrptr == 8'b01010000)?1'b1:1'b0;
assign half_empty=(rdptr == 8'b01010000)?1'b1:1'b0;


always @(posedge wclk or negedge reset)
begin
        if(reset)
        begin
                for(int i=0;i<=depth;i=i+1)
                begin
                        mem[i]<=8'b0;
                        
                end
        end


        else if(w_count%3==0 && w_en ==1 && full== 0)
           begin
                mem[wrptr]<=data_in;
           end

 end

always_ff@(posedge wclk)
begin
if(reset)
w_count=0;
else
w_count=w_count+1;
end


always_ff@(posedge rclk)
begin
if(reset)
r_count=0;
else
r_count=r_count+1;
end

always_ff @(posedge rclk or posedge  reset)
begin
        if(reset)
         begin
        data_out<=8'b0;
         end



       else if(r_count%5 == 0 && r_en==1'b1 && empty==1'b0)
               data_out<= mem[rdptr];


end


always_ff @(posedge wclk)
begin

        if(reset)
         begin
         wrptr<=8'b0;
         end
     else if(full && rdptr==8'b10100000)
        begin
         wrptr<=8'b0; end

       else if( w_count%3==0 && w_en==1'b1 && full==1'b0) 
             begin 
               wrptr<=wrptr+8'b00000001;
               
            end
end

always_ff@(posedge rclk)
begin

        if(reset)
         begin
         rdptr<=8'b0;
         end
        else if(full && rdptr==8'b10100000)
        begin
         rdptr<=8'b0; end
       else if(r_count%5 ==0 && r_en==1'b1 && empty==1'b0) begin
               rdptr<=rdptr+8'b00000001;
               
     end
end

endmodule
