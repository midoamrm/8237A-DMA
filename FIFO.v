module fifo (data_out_8bit,data_in_32bit,write,read,clk);
input [31:0] data_in_32bit;
output reg [7:0] data_out_8bit;
reg[7:0] fifo [0:3];
input write,clk;
input [1:0]read;

always @(posedge clk)
begin

if(write == 1)
begin 
fifo[0]<= data_in_32bit[7:0];
fifo[1]<= data_in_32bit[15:8];
fifo[2]<= data_in_32bit[23:16];
fifo[3]<= data_in_32bit[31:24];
end
// DMA will read each line from processor in four steps*****
if(read ==0)
begin 
data_out_8bit<=fifo[0];
end
if(read ==1)
begin 
data_out_8bit<=fifo[1];
end
if(read ==2)
begin 
data_out_8bit<=fifo[2];
end
if(read ==3)
begin 
data_out_8bit<=fifo[3];
end
end
endmodule

