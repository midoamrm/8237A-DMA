module holdRequest(DREQ0,DREQ1,DREQ2,DREQ3,HRQ); //send hold request 

input DREQ0,DREQ1,DREQ2,DREQ3;
output reg HRQ;

always@(DREQ0,DREQ1,DREQ2,DREQ3)
begin
HRQ=1;
end

endmodule

module channels_priority(Reset,TC,DREQ0,DREQ1,DREQ2,DREQ3,DACK0,DACK1,DACK2,DACK3,ch0,ch1,ch2,ch3,ch_out,HLDA,COMMAND,MASK,REQUEST,clk);

input TC;
input [7:0]COMMAND;
input [3:0]MASK , REQUEST;
input [15:0]ch0,ch1,ch2,ch3;
input DREQ0,DREQ1,DREQ2,DREQ3,HLDA,clk,Reset;
output reg DACK0,DACK1,DACK2,DACK3;
output reg[15:0]ch_out;

initial 
begin
DACK0=0;DACK1=0;DACK2=0;DACK3=0;
end

always @(posedge clk)
begin

if(Reset) begin DACK0=0;DACK1=0;DACK2=0;DACK3=0;
end
else
begin

if(TC==1) begin DACK0=0;DACK1=0;DACK2=0;DACK3=0; end		//AS THE CHANGE IN DACK APPEAR

if(REQUEST[2]==0 && HLDA==1)			//REQUEST:HIGHER PRIORITY FROM HARDWARE
begin

if(COMMAND[6] == 0 && COMMAND[7])		//COMMAND[6]->DREQ enable COMAND[7]->DACK enable
begin

if(DREQ0 && MASK[0]==0)		begin DACK0=1; ch_out=ch0; end	//MASK is enable Or disable channel(MASK[0]=0->enable channel 0 ya 7ywan ya wy4o)

else if(DREQ1 && MASK[1]==0)	begin DACK1=1; ch_out=ch1; end

else if(DREQ2 && MASK[2]==0)	begin DACK2=1; ch_out=ch2; end

else if(DREQ3 && MASK[3]==0)	begin DACK3=1; ch_out=ch3; end
end
end

else if(REQUEST[2]==1 && HLDA==1)						
begin 

if(REQUEST[1:0]==2'b00)		begin DACK0=1; ch_out=ch0; end		//GETTING SELECTED CHANNEL FROM PROCESSOR
else if(REQUEST[1:0]==2'b01)	begin DACK1=1; ch_out=ch1; end
else if(REQUEST[1:0]==2'b10)	begin DACK2=1; ch_out=ch2; end
else if(REQUEST[1:0]==2'b11)	begin DACK3=1; ch_out=ch2; end
end
end 
end

endmodule



