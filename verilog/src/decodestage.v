`include "rv32i_defs.v"
`include "reg.v"
`include "decoder.v"

module decodestage(inst,dataA,dataB,addr,clk,stall,jmp,rs1,rs2,rd,rs1v,rs2v,rdv,func,left,right,extra);
	parameter width = 32;
	input [width-1:0] inst, dataA, dataB, addr;
	input clk, stall, jmp;
	output [4:0] rs1, rs2, rd;
	output rs1v, rs2v, rdv;
	output [5:0] func;
	output reg [width-1:0] left, right, extra;

	wire enable = ~ stall;
	wire [width-1:0] inst_temp, addr_temp;
	wire [4:0] rs1_temp, rs2_temp, rd_temp;
	wire rs1v_temp, rs2v_temp, rdv_temp;
	wire [width-1:0] immediate;
	wire [5:0] func_temp;

reg0 reg_inst(
	.clk(clk),
	.enable(enable),
	.rst(1'b0),
	.D(inst),
	.Q(inst_temp));
defparam reg_inst.width = width;

reg0 reg_addr(
	.clk(clk),
	.enable(enable),
	.rst(1'b0),
	.D(addr),
	.Q(addr_temp));
defparam reg_addr.width = width;

decoder instdecoder(
	.inst(inst_temp),
	.rs1(rs1_temp),
	.rs2(rs2_temp),
	.rd(rd_temp),
	.rs1v(rs1v_temp),
	.rs2v(rs2v_temp),
	.rdv(rdv_temp),
	.immediate(immediate),
	.func(func_temp));
defparam instdecoder.width = width;


always @(*) begin
	case (func_temp)
		`ADDr || `SUBr || `SLLr || `SLTr || `SLTUr || `XORr ||`SRLr || `SRAr || `ORr || `ANDr: begin
			left <= dataB;
			right <= dataA;
			extra <= 32'b0;
		end
		`ADDI || `SLTI || `SLTIU || `XORI || `ORI || `ANDI || `SLLI || `SRLI || `SRAI: begin
			left <= immediate;
			right <= dataA;
			extra <= 32'b0;
		end
		`LB || `LH || `LW || `LBU || `LHU: begin
			left <= immediate;
			right <= dataA;
			left <= dataB;
		end
		`BEQ || `BNE || `BLT || `BGE || `BLTU || `BGEU: begin
			left <= dataB;
			right <= dataA;
			extra <= addr_temp + immediate;
		end
		`LUI: begin
			left <= 32'b0;
			right <= 32'b0;
			extra <= immediate;
		end
		`AUIPC: begin
			left <= immediate;
			right <= addr_temp;
			extra <= 32'b0;
		end
		`JAL: begin
			left <= immediate;
			right <= addr_temp;
			extra <= addr_temp + 4;
		end
		`JALR: begin
			left <= immediate;
			right <= dataA;
			extra <= addr_temp + 4;
		end
		default: begin
			left <= 32'b0;
			right <= 32'b0;
			extra <= 32'b0;
		end
	endcase
end

assign rs1 = rs1_temp;
assign rs2 = rs2_temp;
assign rd = rd_temp;
assign rs1v = rs1v_temp;
assign rs2v = rs2v_temp;

assign func = (stall|jmp) ? `NOP : func_temp;
assign rdv = (stall|jmp) ? 1'b0 : rdv_temp;

endmodule