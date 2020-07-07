module external(iow,data_bus,address_bus,clk,HLDA);
output reg[7:0]data_bus;
output reg[3:0]address_bus;
output reg iow, HLDA;
output reg clk ;
reg[3:0]address_memory[0:9];
reg[7:0]data_memory[0:9];
integer i;
initial
begin
$readmemb ("F:\\DMA\\data.txt",data_memory);
$readmemb ("F:\\DMA\\address.txt",address_memory);
iow=0;
HLDA = 0;
i=0;
end

always
begin
clk=0;
#1;
clk=1;
#1;
end
always@(posedge clk)
begin
if(data_memory[i]==8'b11111111) HLDA=1;
address_bus=address_memory[i];
data_bus=data_memory[i];
i=i+1;
end

//always@(negedge clk) iow=1;

endmodule
