module COMMAND_register(register_selector,clk,commandReg,data_bus);
input[11:0]register_selector;
input clk;
input[7:0]data_bus;
output reg[7:0]commandReg;

always @(register_selector)
begin
if(register_selector==12'h040)// 0 - 6 -7 
begin
commandReg[0] = data_bus[0]; 
commandReg[1] = data_bus[1];
commandReg[2] = data_bus[2];
commandReg[3] = data_bus[3];
commandReg[4] = data_bus[4];
commandReg[5] = data_bus[5];
commandReg[6] = data_bus[6];
commandReg[7] = data_bus[7];
end
end
endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////

module MASK_register(clk , maskReg ,data_bus,register_selector); // 0 ->3
input[11:0]register_selector;
input[7:0]data_bus;
input clk;
output reg[3:0]maskReg;

always @(register_selector)
begin
if(register_selector==12'h400)
begin
maskReg[0] = data_bus[0]; 
maskReg[1] = data_bus[1];
maskReg[2] = data_bus[2];
maskReg[3] = data_bus[3];
end
end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////

module REQUEST_register(register_selector,clk, requestReg ,data_bus); // 0 -1 -2 
input [11:0]register_selector;
input clk;
input [7:0]data_bus;
output reg[3:0]requestReg;
always @(register_selector)
begin
if(register_selector==12'h800)
begin
requestReg[0]= data_bus[0];
requestReg[1]= data_bus[1];
requestReg[2]= data_bus[2];
requestReg[3]= data_bus[3]; 
end
end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////

module BaseAddress_and_BaseCount(TC,register_selector,clk,baseAddress_register,destination_register,baseCount_register,data_bus,finish_converting);
input [7:0]data_bus;
input [11:0]register_selector;
input clk,TC;
output reg[15:0]baseAddress_register,destination_register,baseCount_register;
integer flag,flag2,flag3;			//this flag waits until the write buffer prepare the data
input finish_converting;
initial
begin
flag=0;
flag2=0;
flag3=0;
end
always@(posedge TC)begin flag=0; flag2=0; flag3=0; end
always@(data_bus or register_selector or flag or flag2 or flag3 or posedge clk) //maynf34 @register_selector
begin
if(register_selector==12'h000 && flag<2)
begin
if(flag==0)begin baseAddress_register[7:0]=data_bus;flag=1;end
else if(flag==1)begin baseAddress_register[15:8]=data_bus;flag=2;end
end

if(register_selector==12'h001 && flag2<2)
begin
if(flag2==0)begin baseCount_register[7:0]=data_bus;flag2=1;end
else if(flag2==1)begin baseCount_register[15:8]=data_bus;flag2=2;end
end

if(register_selector==12'h002 && flag3<2)
begin
if(flag3==0)begin destination_register[7:0]=data_bus;flag3=1;end
else if(flag3==1)begin destination_register[15:8]=data_bus;flag3=2;end
end

end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////

module current_address(mode_register,register_selector,TC,current_address,current_address_destination,current_word,baseAddress_register,destination_register,baseCount_register,clk,DACK0,DACK1,DACK2,DACK3,EOP);
input [15:0]baseAddress_register,baseCount_register,destination_register;
input clk,DACK0,DACK1,DACK2,DACK3;
input [7:0]mode_register;
input [11:0]register_selector;
output reg [15:0]current_address,current_word,current_address_destination;
output reg TC,EOP;
integer flag;
initial begin TC=0; EOP=0; flag=0; end
always @(baseAddress_register,baseCount_register)
begin 
current_address=baseAddress_register;
current_address_destination=destination_register;
current_word=baseCount_register;
flag=0;
TC=0;
end
always @(posedge clk)
begin
if(DACK0 || DACK1 || DACK2 || DACK3)
begin
//INCREMENTING ADDRESS MODE
if((current_address<=baseAddress_register+baseCount_register)&&(mode_register[5]==0))
begin
if(mode_register[3]== 0 && mode_register[2]== 0)
begin
if(flag==4)
begin 
current_address= current_address+1;
current_address_destination=current_address_destination+1;
current_word=current_word-1; 
end
flag=flag+1; 
if(flag>=4) flag=0;
end
else 
begin 
current_address= current_address+1;
current_address_destination=current_address_destination+1;
current_word=current_word-1; 
end
end
//DECREMENTING ADDRESS MODE
else if((current_address>=baseAddress_register-baseCount_register+1)&&(mode_register[5]==1))
begin
current_address= current_address-1;
current_address_destination=current_address_destination-1;
current_word=current_word-1;
end
//END OF COUNTING
if(current_word==0)begin TC=1;EOP=1; end
end
end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////

module Mode_register(mode_register,register_selector,clk,data_bus);
input[7:0]data_bus;
input clk;
input[11:0]register_selector;
output reg[7:0]mode_register;
always@(register_selector)
begin
if(register_selector==12'h200)
begin
mode_register<=data_bus;
end
end
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////

module STATUS_register(clk , status_register , TC , DREQ0 , DREQ1 ,DREQ2 , DREQ3 , DACK0 , DACK1 , DACK2 , DACK3 , register_selector);

input clk , DREQ0 , DREQ1 , DREQ2 , DREQ3 , DACK0 , DACK1 , DACK2 , DACK3 , TC;
input [11:0]register_selector;
output reg[7:0]status_register;

initial
begin
status_register[0] = 0;
status_register[1] = 0;
status_register[2] = 0;
status_register[3] = 0;
end

always @(posedge clk)
begin

status_register[4] = DREQ0;
status_register[5] = DREQ1;
status_register[6] = DREQ2;
status_register[7] = DREQ3;

if(DACK0==1)		status_register[0] = TC;
else if(DACK1==1)	status_register[1] = TC;
else if(DACK2==1)	status_register[2] = TC;
else if(DACK3==1)	status_register[3] = TC;	
end
endmodule
