`include "rv32i_defs.v"
`include "reg.v"

module writebackstage(data_in,rd,func,clk,we,rd_out,data_out);
	parameter width = 32;
	input clk;
	input [width-1:0] data_in;
	input [4:0] rd;
	input [5:0] func;
	output we;
	output [4:0] rd_out;
	output [width-1:0] data_out;

	wire [5:0] func_temp; 
reg0 reg_data_ws(
	.clk(clk),
	.enable(1'b1),
	.rst(1'b0),
	.D(data_in),
	.Q(data_out));
defparam reg_data_ws.width = width;

reg0 reg_rd_ws(
	.clk(clk),
	.enable(1'b1),
	.rst(1'b0),
	.D(rd),
	.Q(rd_out));
defparam reg_rd_ws.width = 5;

reg0 reg_func_ws(
	.clk(clk),
	.enable(1'b1),
	.rst(1'b0),
	.D(func),
	.Q(func_temp));
defparam reg_func_ws.width = 6;

assign we = (func_temp == `LUI    ||
			 func_temp == `AUIPC  ||
			 func_temp == `JAL    ||
			 func_temp == `JALR   ||
			 func_temp == `LB     ||
			 func_temp == `LH     ||
			 func_temp == `LW     ||
			 func_temp == `LBU    ||
			 func_temp == `LHU    ||
			 func_temp == `ADDI   ||
			 func_temp == `SLTI   ||
			 func_temp == `SLTIU  ||
			 func_temp == `XORI   ||
			 func_temp == `ORI    ||
			 func_temp == `ANDI   ||
			 func_temp == `SLLI   ||
			 func_temp == `SRLI   ||
			 func_temp == `SRAI   ||
			 func_temp == `ADDr   ||
			 func_temp == `SUBr   ||
			 func_temp == `SLLr   ||
			 func_temp == `SLTr   ||
			 func_temp == `SLTUr  ||
			 func_temp == `XORr   ||
			 func_temp == `SRLr   ||
			 func_temp == `SRAr   ||
			 func_temp == `ORr    ||
			 func_temp == `ANDr) ? 1'b1 : 1'b0;
endmodule
