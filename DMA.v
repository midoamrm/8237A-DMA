module DMA(reset,HRQ,IOW,IOR,HLDA,DREQ0,DREQ1,DREQ2,DREQ3,DACK0,DACK1,DACK2,DACK3,EOP,DMA_data_bus_out,address_A ,address_A_in,control_bus,DMA_data_bus_in,clk,commandReg ,maskReg,mode_register,baseAddress_register,destination_register,out_printed,baseCount_register);

input reset,clk,IOW,IOR,HLDA,DREQ0,DREQ1,DREQ2,DREQ3;	//IOW,IOR,HLDA came from precessor , DREQ came from Peripheral
input [7:0]DMA_data_bus_in;			//read_data_bus data come from Memory during DMA service,cpu_data_bus is the dataBus came from alu of processor
input [3:0]address_A_in;
output HRQ,EOP;			//HRQ DMA send this signal for waiting processor to take the bus , EOP signal that terminate DMA service and give the bus back to the processor
output [7:0]DMA_data_bus_out;	//DMA Output data written to Memory
output [7:0]address_A,commandReg,mode_register;
output [3:0]maskReg;		//DMA Output address from A0->A8wire 
output [15:0]baseAddress_register,destination_register,baseCount_register;
output [3:0]control_bus;	//note: MEMW&MEMR&read&write signal of Peripheral is builted in the control bus
output DACK0,DACK1,DACK2,DACK3;
output [11:0]out_printed;
wire finish_converting;
wire TC;
wire [11:0]register_selector;
wire [7:0]mode_register,status_register;
wire [3:0]maskReg,requestReg;
wire [15:0]data_16bit,baseAddress_register,baseCount_register,current_address,current_address_destination,current_word;

A0A3Decoder addressDecoder(clk,IOW,register_selector,address_A_in,HLDA,out_printed);

holdRequest sendHoldRequest(DREQ0,DREQ1,DREQ2,DREQ3,HRQ);
channels_priority priorityCheck(Reset,TC,DREQ0,DREQ1,DREQ2,DREQ3,DACK0,DACK1,DACK2,DACK3,ch0,ch1,ch2,ch3,ch_out,HLDA,commandReg,maskReg,requestReg,clk);

//note: any data bus inside register module is 8 bit don't forget to handle it

COMMAND_register commandRegister(register_selector,clk,commandReg,DMA_data_bus_in);
MASK_register maskRegister(clk , maskReg ,DMA_data_bus_in,register_selector);
REQUEST_register requestRegister(register_selector,clk, requestReg ,DMA_data_bus_in);

//writeBuffer write_buffer(clk,DMA_data_bus_in,data_16bit,finish_converting,register_selector);

BaseAddress_and_BaseCount baseAddress_and_baseCount(TC,register_selector,clk,baseAddress_register,destination_register,baseCount_register,DMA_data_bus_in,finish_converting);
current_address currentAddress(mode_register,register_selector,TC,current_address,current_address_destination,current_word,baseAddress_register,destination_register,baseCount_register,clk,DACK0,DACK1,DACK2,DACK3,EOP);
Mode_register modeRegister(mode_register,register_selector,clk,DMA_data_bus_in);
//STATUS_register statusRegister(clk , status_register , TC , DREQ0 , DREQ1 ,DREQ2 , DREQ3 , DACK0 , DACK1 , DACK2 , DACK3 , register_selector);


transferMode transfer_mode(DMA_data_bus_in , current_address , current_address_destination , mode_register , commandReg , clk , DMA_data_bus_out , address_A , EOP , TC , control_bus,DACK0,DACK1,DACK2,DACK3);

endmodule

/*module ALL_DMA(cpu_data_bus , address_bus_out , clk);

fifo FIFO(DMA_internal_bus,cpu_data_bus,write,read,clk);

elJoker joker(address_A, DMA_data_bus , address_bus_out , clk);

DMA(reset,HRQ,IOW,IOR,HLDA,DREQ0,DREQ1,DREQ2,DREQ3,DACK0,DACK1,DACK2,DACK3,EOP,DMA_data_bus_out,address_A ,address_A_in,control_bus,DMA_data_bus_in,clk);

endmodule*/


module DMA_tb();

wire IOW ;
wire clk ;
wire  HLDA,EOP;
wire [3:0] address_A_in;
//wire [3:0] out_address;
wire [7:0]DMA_data_bus_in;
wire[7:0]commandReg,mode_register;
wire [3:0]maskReg;
wire [15:0]baseAddress_register,baseCount_register;
wire[11:0]out_printed;
wire [7:0]DMA_data_bus_out,address_A;
reg DREQ0;
wire DACK0;
wire[3:0]control_bus ;	
external test(IOW,DMA_data_bus_in,address_A_in,clk,HLDA);
DMA dma(reset,HRQ,IOW,IOR,HLDA,DREQ0,DREQ1,DREQ2,DREQ3,DACK0,DACK1,DACK2,DACK3,EOP,DMA_data_bus_out,address_A ,address_A_in,control_bus,DMA_data_bus_in,clk,commandReg ,maskReg,mode_register,baseAddress_register,out_printed,baseCount_register);
//initial 
//begin
//HLDA=0 ; 
//IOW=0 ; 
//address_A_in = 6 ; 
//DMA_data_bus_in = 1;
//clk = 0 ;
//#5;
//clk =~clk ;
//address_A_in =7 ;
//DMA_data_bus_in=DMA_data_bus_in +1 ; 
//#5;
//clk = 0 ;
//#5;
//address_A_in =11 ;
//DMA_data_bus_in=3;

//end

endmodule 
