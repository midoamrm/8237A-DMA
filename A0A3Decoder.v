module A0A3Decoder(clk,IOW,out_address,Address,HLDA,out_printed);
input[3:0]Address;
input IOW,HLDA,clk;
output reg[11:0]out_address;
output reg[11:0]out_printed;
always@(Address) 		//in idle cycle if IOW =0 you write in register
begin
if(HLDA==0 && IOW==0)
begin
if(Address==4'b0000)out_address=12'h000; // base address
else if (Address==4'b0001)out_address=12'h001; // base count
else if (Address==4'b0010)out_address=12'h002;
else if (Address==4'b0011)out_address=12'h004;
else if (Address==4'b0100)out_address=12'h008;
else if (Address==4'b0101)out_address=12'h010;
else if (Address==4'b0110)out_address=12'h020;
else if (Address==4'b0111)out_address=12'h040; //command 
else if (Address==4'b1000)out_address=12'h080;
else if (Address==4'b1001)out_address=12'h100;
else if (Address==4'b1010)out_address=12'h200; //mode
else if (Address==4'b1011)out_address=12'h400; //mask
else if (Address==4'b1100)out_address=12'h800; //request
end
else out_address=12'h101;		//to end the idle cycle and not change the register value in active cycle
out_printed=out_address;
end
endmodule
