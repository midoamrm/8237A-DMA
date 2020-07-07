module transferMode(DMA_data_bus_in , current_address , mode_register , command_register , clk , DMA_data_bus , address_A , EOP , TC , control_bus,DACK0,DACK1,DACK2,DACK3);

input clk , TC ;  // TC is input from current word 
input [7:0]mode_register;
input [7:0]command_register;
input [15:0]current_address;
input [7:0]DMA_data_bus_in;	//data bus that get data out of memory
input DACK0,DACK1,DACK2,DACK3 ;
output reg [3:0]control_bus ;	//4'b(MEMR)(MEMW)(I/O Read)(I/O Write)
output EOP; // =1 when TC = 1 
output reg[7:0]address_A;
output reg[7:0]DMA_data_bus;

reg[7:0]temporary_register;// for mem to mem 
integer flag; //mem to mem

initial
begin
flag=0;
end

always @(posedge clk)
begin

//I/O to Memory:
//**************
if(DACK0||DACK1||DACK2||DACK3)// start only when a DREQ is accpeted ,so I/O data will be transferred
begin


if(command_register[0]==0 &&TC==0 &&mode_register[3]== 1 && mode_register[2]== 0 )
begin
control_bus = 4'b0110; 			//for read data from the I/O device
address_A= current_address[7:0];
DMA_data_bus=current_address[15:8];
end



//Memory to I/O:
//**************

else if(command_register[0]==0 && TC==0 && mode_register[3]== 0 && mode_register[2]== 1)
begin
control_bus = 4'b1001; 			//to write data in the I/O device
address_A= current_address[7:0];
DMA_data_bus=current_address[15:8];
end

end // for upper if condition
//Memory to Memory:
//*****************

else if(command_register[0]==1 && TC==0)
begin

if(flag==0)
begin
control_bus= 4'b1000;
address_A= current_address[7:0];
DMA_data_bus=current_address[15:8];
flag = 1;
end

else if(flag==1)begin temporary_register = DMA_data_bus_in ; flag = flag+1; end
else if(flag==2)
begin
control_bus= 4'b0100;
address_A= current_address[7:0];
DMA_data_bus=current_address[15:8];
flag = flag+1;
end
else if(flag==3) begin DMA_data_bus = temporary_register; flag=0; end
end
end
endmodule
