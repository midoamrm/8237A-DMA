module IObuffer(DB_out,clk,DB_in);
input clk;
input[7:0]DB_in;
output reg[7:0]DB_out;
always@(DB_in)
begin
DB_out<=DB_in;
end
endmodule
