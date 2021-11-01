`include "reg.v"
`include "incrementor.v"
`include "mux2to1.v"
module counter(D, rst, enable, clk, Q);
	parameter width = 32;
	input rst, enable, clk;
	input [width-1:0] D;
	output [width-1:0] Q;
	wire [width-1:0] Q0, Qtemp;

mux2to1 m(
	.in0(Qtemp),
	.in1(D),
	.sel(rst),
	.Q(Q0));
defparam m.width = width;

reg0 r(
	.clk(clk),
	.enable(enable),
	.rst(1'b0),
	.D(Q0),
	.Q(Q));
defparam r.width = width;

incrementor i(
	.D(Q),
	.Q(Qtemp),
	.inc(2'b11));
defparam i.width = width;

endmodule