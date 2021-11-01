`include "onehot.v"
`include "regreadwrite.v"

module regfile(clk,rst,rs1,rs2,rd,rs1v,rs2v,we,data_in,dataA,dataB);
	parameter width = 32;
	parameter regsel = 5;
	input clk, rst;
	input [regsel-1:0] rs1, rs2, rd;
	input rs1v, rs2v, we;
	input [width-1:0] data_in;
	output [width-1:0] dataA, dataB;

	wire [width-1:0] onehot_rs1, onehot_rs2, onehot_rd;
	wire [width-1:0] readreg;
	wire [width-1:0] registers [0:31];

onehot o1(
	.sel(rs1),
	.onehot(onehot_rs1),
	.enable(rs1v));

onehot o2(
	.sel(rs2),
	.onehot(onehot_rs2),
	.enable(rs2v));

onehot o3(
	.sel(rd),
	.onehot(onehot_rd),
	.enable(we));

assign readreg = onehot_rs1 | onehot_rs2;

generate
	genvar i;
	for (i=1; i<=31; i=i+1) begin: regfile
		regreadwrite regi(
			.clk(clk),
			.rst(rst),
			.LE(readreg[i]),
			.OE(onehot_rd[i]),
			.D(data_in),
			.Q(registers[i]));
		defparam regi.width = width;
	end	
endgenerate

assign registers[0] = 32'b0;
assign dataA = registers[rs1];
assign dataB = registers[rs2];

endmodule