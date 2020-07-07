module elJoker(address_A, DMA_data_bus , address_bus_out , clk); //da bytl3 address 16 but to memory

input [7:0]address_A , DMA_data_bus;
input clk;
output reg[31:0]address_bus_out;

always@(posedge clk)
begin

address_bus_out[7:0] = address_A;
address_bus_out[15:8] = DMA_data_bus;
end

endmodule
