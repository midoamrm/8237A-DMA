module writeBuffer(clk,data_bus,data_16bit,finish_converting,register_selector);
input clk;
input[15:0]data_bus;
output reg[15:0]data_16bit;
reg flag;
output reg finish_converting;
input [11:0]register_selector;
initial
begin
flag=0;
finish_converting=0;
end
always@(posedge clk)
begin
if(register_selector == 12'h000)
begin
if(flag==0)
begin
flag=1;
finish_converting=0;
data_16bit[7:0]=data_bus[7:0];
//data_16bit[15:8]=8'h00;
end
else if(flag==1)
begin
data_16bit[15:8]=data_bus[7:0];
flag=0;
finish_converting=1;
end
end
end
endmodule
