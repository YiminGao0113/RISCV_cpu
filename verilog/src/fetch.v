`include "counter_structure.v"
module fetch(jaddr, mdata, addr, inst, clk, jmp, rst, delay, read);
	parameter width = 32;
	input clk, jmp, rst, delay;
	input [width-1:0] jaddr, mdata;
	output [width-1:0] addr, inst;
	output read;
	wire [width-1:0] zero = {width{1'b0}};
	wire [width-1:0] Q1;
	wire [width-1:0] nop = 32'b10011;

assign read = ~ (jmp | rst);

mux2to1 mux1(
	.in0(jaddr),
	.in1(zero),
	.sel(rst),
	.Q(Q1));
defparam mux1.width = width;

counter c(
	.D(Q1),
	.rst(rst | jmp),
	.enable(~delay),
	.clk(clk),
	.Q(addr));
defparam c.width = width;

mux2to1 mux2(
	.in0(nop),
	.in1(mdata),
	.sel(read),
	.Q(inst));
defparam mux2.width = width;

endmodule