`include "regreadwrite.v"
`include "onehot.v"

module regtracker(rs1v,rs2v,rdv,we,rst,clk,rs1,rs2,rd,rdwbs,jmp,stall_jmp_mem,stall);
	parameter width = 2;
	parameter regsel = 5;
	input rs1v, rs2v, rdv, we, rst, clk, jmp, stall_jmp_mem;
	input [regsel-1:0] rs1, rs2, rd, rdwbs;
	output stall;

	wire [31:0] onehot_rs1, onehot_rs2, onehot_rd, onehot_rdwbs, onehot_read, onehot_write;
	wire [31:0] rd_sel;
	wire [width-1:0] DataIn [0:31];
	wire [width-1:0] DataIn1 [0:31];
	wire [width-1:0] DataIn2 [0:31];
	wire [width-1:0] registers [0:31];
	wire [width-1:0] DataRs1, DataRs2, DataRd, DataRdwbs;
	wire stall_temp;

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
		.enable(rdv));

	onehot o4(
		.sel(rdwbs),
		.onehot(onehot_rdwbs),
		.enable(we));

assign rd_sel = jmp | stall_jmp_mem | stall_temp ? 32'b0 : onehot_rd;
assign onehot_read = onehot_rs1 | onehot_rs2 | onehot_rd | onehot_rdwbs;
assign onehot_write = rd_sel | onehot_rdwbs;

generate
	genvar i1;
	for (i1=1; i1<=((2**regsel)-1); i1=i1+1) begin: regfiletracker
		regreadwrite regi(
			.clk(clk),
			.LE(onehot_write[i1]),
			.OE(onehot_read[i1]),
			.rst(rst),
			.D(DataIn[i1]),
			.Q(registers[i1]));
		defparam regi.width = width;
	end
endgenerate


generate
	genvar i2;
	for (i2=0; i2<=((2**regsel)-1); i2=i2+1) begin: assigndata
		assign DataIn1[i2] = (rdv&&(i2==rd)) ? DataRd + 1 : 2'b00;
		assign DataIn2[i2] = (we&&(i2==rdwbs)) ? DataRdwbs - 1: 2'b00;
		assign DataIn[i2] = (rdv&&we&&(rd==rdwbs))? DataRd : (DataIn1[i2]|DataIn2[i2]);
	end
endgenerate

assign registers[0] = 2'b00;

assign DataRd = registers[rd];
assign DataRdwbs = registers[rdwbs];
assign DataRs1 = registers[rs1];
assign DataRs2 = registers[rs2];

assign stall_temp = jmp ? 1'b0 : (rs1v&&(|DataRs1))||(rs2v&(|DataRs2));
assign stall = stall_temp;
endmodule
