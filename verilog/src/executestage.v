`include "rv32i_defs.v"
`include "alu.v"
`include "reg.v"

module executestage(clk, left, right, extra, rd_in, func, stall, addr_out, data_out, jaddr, rd_out, func_out, jmp);
	parameter width = 32;
	input clk, stall;
	input [width-1:0] left, right, extra;
	input [4:0] rd_in;
	input [5:0] func;
	output reg [width-1:0] addr_out, data_out, jaddr;
	output [4:0] rd_out;
	output [5:0] func_out;
	output reg jmp;

	wire [width-1:0] left_temp, right_temp, extra_temp;
	wire [5:0] func_temp;
	wire [width-1:0] result;

reg0 reg_left(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(left),
	.Q(left_temp));
defparam reg_left.width = width;

reg0 reg_right(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(right),
	.Q(right_temp));
defparam reg_right.width = width;

reg0 reg_extra(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(extra),
	.Q(extra_temp));
defparam reg_extra.width = width;

reg0 reg_rd_es(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(rd_in),
	.Q(rd_out));
defparam reg_rd_es.width = 5;

reg0 reg_func_es(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(func),
	.Q(func_temp));
defparam reg_func_es.width = 6;

alu a(
	.left(left_temp),
	.right(right_temp),
	.func(func_temp),
	.result(result));
defparam a.width = width;

always @(*) begin
	case(func_temp)
		`AUIPC || `ADDr || `ADDI || `SUBr || `SLLr || `SLLI || `SLTr || `SLTI || `SLTUr || `SLTIU ||`XORr || `XORI || `SRLr || `SRLI || `SRAr || `SRAI || `ORr || `ORI || `ANDr || `ANDI: begin
			addr_out <= 32'b0;
			data_out <= result;
			jaddr <= 32'b0;
			jmp <= 1'b0;
		end
		`LB || `LH || `LW || `LBU || `LHU: begin
			addr_out <= result;
			data_out <= 32'b0;
			jaddr <= 32'b0;
			jmp <= 1'b0;
		end
		`SB || `SH || `SW: begin
			addr_out <= result;
			data_out <= extra_temp;
			jaddr <= 32'b0;
			jmp <= 1'b0;
		end
		`BEQ || `BNE || `BLT || `BGE || `BLTU || `BGEU: begin
			addr_out <= 32'b0;
			data_out <= 32'b0;
			jaddr <= extra_temp;
			jmp <= result[0];
		end
		`JAL || `JALR: begin
			addr_out <= 32'b0;
			data_out <= extra_temp;
			jaddr <= result;
			jmp <= 1'b1;
		end
		`LUI: begin
			addr_out <= 32'b0;
			data_out <= extra_temp;
			jaddr <= 32'b0;
			jmp <= 1'b0;
		end
		default: begin
			addr_out <= 32'b0;
			data_out <= 32'b0;
			jaddr <= 32'b0;
			jmp <= 1'b0;
		end
	endcase
end

assign func_out = stall ? `NOP : func_temp;

endmodule