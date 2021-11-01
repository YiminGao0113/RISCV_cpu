`include "reg.v"
module regreadwrite(clk, LE, OE, rst, D, Q);
	parameter width = 8;
	input LE, OE, clk, rst;
	input [width-1:0] D;
	output [width-1:0] Q;

	wire [width-1:0] Qtemp;
reg0 r(
	.clk(clk),
	.enable(LE),
	.rst(rst),
	.D(D),
	.Q(Qtemp));
defparam r.width = width;
assign Q = OE ? Qtemp : {width{1'bz}};
endmodule 