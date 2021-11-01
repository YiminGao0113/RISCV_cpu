`include "rv32i_defs.v"

module decoder(inst, func, rs1, rs2, rd, rs1v, rs2v, rdv, immediate);
	parameter width = 32;


	input [width-1:0] inst;
	output [4:0] rs1,rs2,rd;
	output reg rs1v, rs2v, rdv;
	output reg [width-1:0] immediate;
	output reg [5:0] func;

	assign rd = inst[11:7];
	assign rs1 = inst[19:15];
	assign rs2 = inst[24:20];

	wire [width-1:0] RV32I_U = inst & `RV32I_U_MASK;
	wire [width-1:0] RV32I_J = inst & `RV32I_J_MASK;
	wire [width-1:0] RV32I_B = inst & `RV32I_B_MASK;
	wire [width-1:0] RV32I_I = inst & `RV32I_I_MASK;
	wire [width-1:0] RV32I_S = inst & `RV32I_S_MASK;
	wire [width-1:0] RV32I_R = inst & `RV32I_R_MASK;

always @(*) begin
	if (RV32I_U == `RV32I_LUI || RV32I_U == `RV32I_AUIPC) begin	
		case (RV32I_U)
		`RV32I_LUI: begin
			func <= `LUI;
			rs1v <= 0;
			rs2v <= 0;
			rdv <= 1;
			immediate[31:12] <= inst[31:12];
			immediate[11:0] <= 12'b0;
			end
		`RV32I_AUIPC: begin
			func <= `AUIPC;
			rs1v <= 0;
			rs2v <= 0;
			rdv <= 1;
			immediate[31:12] <= inst[31:12];
			immediate[11:0] <= 12'b0;
			end
		default: begin
			func <= `BAD;
			rs1v <= 0;
			rs2v <= 0;
			rdv <= 0;
			immediate <= 32'b0;
			end
	endcase
	end
		else if (RV32I_J == `RV32I_JAL) begin
				func<=`JAL;
				rs1v <= 0;
				rs2v <= 0;
				rdv <= 1;
				immediate[31:21] <= {11{inst[31]}};
				immediate[20:12] <= inst[20:12];
				immediate[11] <= inst[20];
				immediate[10:1] <= inst[30:21];
				immediate[0] <= 1'b0;
		end
		else if (RV32I_B == `RV32I_BEQ || RV32I_B == `RV32I_BNE || RV32I_B == `RV32I_BLT || RV32I_B == `RV32I_BGE || RV32I_B == `RV32I_BLTU || RV32I_B == `RV32I_BGEU) begin
			case (RV32I_B)
				`RV32I_BEQ: begin
					func <= `BEQ;
					rs1v <= 1;
					rs2v <= 1;
					rdv <= 0;
					immediate[12] <= inst[31];
					immediate[10:5] <= inst[30:25];
					immediate[4:1] <= inst[11:8];
					immediate[11] <= inst[7];
					immediate[31:13] <= {19{inst[31]}};
					immediate[0] <= 1'b0;
				end
				`RV32I_BNE: begin
					func <= `BNE;
					rs1v <= 1;
					rs2v <= 1;
					rdv <= 0;
					immediate[12] <= inst[31];
					immediate[10:5] <= inst[30:25];
					immediate[4:1] <= inst[11:8];
					immediate[11] <= inst[7];
					immediate[31:13] <= {19{inst[31]}};
					immediate[0] <= 1'b0;
				end
				`RV32I_BLT: begin
					func <= `BLT;
					rs1v <= 1;
					rs2v <= 1;
					rdv <= 0;
					immediate[12] <= inst[31];
					immediate[10:5] <= inst[30:25];
					immediate[4:1] <= inst[11:8];
					immediate[11] <= inst[7];
					immediate[31:13] <= {19{inst[31]}};
					immediate[0] <= 1'b0;
				end
				`RV32I_BGE: begin
					func <= `BGE;
					rs1v <= 1;
					rs2v <= 1;
					rdv <= 0;
					immediate[12] <= inst[31];
					immediate[10:5] <= inst[30:25];
					immediate[4:1] <= inst[11:8];
					immediate[11] <= inst[7];
					immediate[31:13] <= {19{inst[31]}};
					immediate[0] <= 1'b0;
				end
				`RV32I_BLTU: begin
					func <= `BLTU;
					rs1v <= 1;
					rs2v <= 1;
					rdv <= 0;
					immediate[12] <= inst[31];
					immediate[10:5] <= inst[30:25];
					immediate[4:1] <= inst[11:8];
					immediate[11] <= inst[7];
					immediate[31:13] <= {19{inst[31]}};
					immediate[0] <= 1'b0;
				end
				`RV32I_BGEU: begin
					func <= `BGEU;
					rs1v <= 1;
					rs2v <= 1;
					rdv <= 0;
					immediate[12] <= inst[31];
					immediate[10:5] <= inst[30:25];
					immediate[4:1] <= inst[11:8];
					immediate[11] <= inst[7];
					immediate[31:13] <= {19{inst[31]}};
					immediate[0] <= 1'b0;
				end
				default: begin
					func <= `BAD;
					rs1v <= 0;
					rs2v <= 0;
					rdv <= 0;
					immediate <= 32'b0;
				end
			endcase
		end

			// I type
		else if (RV32I_I == `RV32I_JALR|| RV32I_I == `RV32I_LB|| RV32I_I == `RV32I_LH||RV32I_I == `RV32I_LW||RV32I_I == `RV32I_LBU||RV32I_I == `RV32I_LHU||RV32I_I == `RV32I_ADDI||RV32I_I == `RV32I_SLTI||RV32I_I == `RV32I_SLTI||RV32I_I == `RV32I_XORI||RV32I_I == `RV32I_ORI||RV32I_I == `RV32I_ANDI) begin
			case (RV32I_I)
			`RV32I_JALR: begin
				func <= `JALR;
				rs1v <= 1;
				rs2v <= 0;
				rdv <= 1;
				immediate[11:0] <= inst[31:20];
				immediate[31:12] <= {20{inst[31]}};
			end

		// Load
		`RV32I_LB: begin
			func <= `LB;
			rs1v <= 1;
			rs2v <= 0;
			rdv <= 1;
			immediate[11:0] <= inst[31:20];
			immediate[31:12] <= {20{inst[31]}};
		end

		`RV32I_LH: begin
			func <= `LH;
			rs1v <= 1;
			rs2v <= 0;
			rdv <= 1;
			immediate[11:0] <= inst[31:20];
			immediate[31:12] <= {20{inst[31]}};
		end
		`RV32I_LW: begin
			func <= `LW;
			rs1v <= 1;
			rs2v <= 0;
			rdv <= 1;
			immediate[11:0] <= inst[31:20];
			immediate[31:12] <= {20{inst[31]}};
		end
		`RV32I_LBU: begin
			func <= `LBU;
			rs1v <= 1;
			rs2v <= 0;
			rdv <= 1;
			immediate[11:0] <= inst[31:20];
			immediate[31:12] <= {20{inst[31]}};
		end
		`RV32I_LHU: begin
			func <= `LHU;
			rs1v <= 1;
			rs2v <= 0;
			rdv <= 1;
			immediate[11:0] <= inst[31:20];
			immediate[31:12] <= {20{inst[31]}};
		end




			// ALUI
			`RV32I_ADDI: begin
				if (inst == `NOP) begin
					func <= `NOP;
					rs1v <= 0;
					rs2v <= 0;
					rdv <= 0;
					immediate <= 32'b0;
				end
				else begin
					func <= `ADDI;
					rs1v <= 1;
					rs2v <= 0;
					rdv <= 1;
					immediate[11:0] <= inst[31:20];
					immediate[31:12] <= {20{inst[31]}};
				end
			end
			`RV32I_SLTI: begin
				func <= `SLTI;
				rs1v <= 1;
				rs2v <= 0;
				rdv <= 1;
				immediate[11:0] <= inst[31:20];
				immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_SLTIU: begin
				func <= `SLTIU;
				rs1v <= 1;
				rs2v <= 0;
				rdv <= 1;
				immediate[11:0] <= inst[31:20];
				immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_XORI: begin
					func <= `XORI;
					rs1v <= 1;
					rs2v <= 0;
					rdv <= 1;
					immediate[11:0] <= inst[31:20];
					immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_ORI: begin
					func <= `ORI;
					rs1v <= 1;
					rs2v <= 0;
					rdv <= 1;
					immediate[11:0] <= inst[31:20];
					immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_ANDI: begin
					func <= `ANDI;
					rs1v <= 1;
					rs2v <= 0;
					rdv <= 1;
					immediate[11:0] <= inst[31:20];
					immediate[31:12] <= {20{inst[31]}};
			end
			default: begin
				func <= `BAD;
				rs1v <= 0;
				rs2v <= 0;
				rdv <= 0;
				immediate <= 32'b0;
			end
			endcase
		end

		// S type
		else if (RV32I_S == `SB      ||
				 RV32I_S == `SH      ||
				 RV32I_S == `SW) begin
			case(RV32I_S)
			`RV32I_SB: begin
				func <= `SB;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 0;
				immediate[11:5] <= inst[31:25];
				immediate[4:0] <= inst[11:7];
				immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_SH: begin
				func <= `SH;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 0;
				immediate[11:5] <= inst[31:25];
				immediate[4:0] <= inst[11:7];
				immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_SW: begin
				func <= `SW;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 0;
				immediate[11:5] <= inst[31:25];
				immediate[4:0] <= inst[11:7];
				immediate[31:12] <= {20{inst[31]}};
			end
			default: begin
				func <= `BAD;
				rs1v <= 0;
				rs2v <= 0;
				rdv <= 0;
				immediate <= 32'b0;
			end
			endcase
		end

		// R type
		else if(RV32I_R == `RV32I_SLLI     ||
				RV32I_R == `RV32I_SRLI     ||
				RV32I_R == `RV32I_SRAI     ||
				RV32I_R == `RV32I_ADDr     ||
				RV32I_R == `RV32I_SUBr     ||
				RV32I_R == `RV32I_SLLr     ||
				RV32I_R == `RV32I_SLTr     ||
				RV32I_R == `RV32I_SLTUr    ||
				RV32I_R == `RV32I_XORr     ||
				RV32I_R == `RV32I_SRLr     ||
				RV32I_R == `RV32I_SRAr     ||
				RV32I_R == `RV32I_ORr      ||
				RV32I_R == `RV32I_ANDr
				) begin
			case (RV32I_R)
			`RV32I_SLLI: begin
				func <= `SLLI;
				rs1v <= 1;
				rs2v <= 0;
				rdv <= 1;
				immediate[11:0] <= inst[31:20];
				immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_SRLI: begin
				func <= `SRLI;
				rs1v <= 1;
				rs2v <= 0;
				rdv <= 1;
				immediate[11:0] <= inst[31:20];
				immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_SRAI: begin
				func <= `SRAI;
				rs1v <= 1;
				rs2v <= 0;
				rdv <= 1;
				immediate[11:0] <= inst[31:20];
				immediate[31:12] <= {20{inst[31]}};
			end
			`RV32I_ADDr: begin
				func <= `SRLI;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_SUBr: begin
				func <= `SUBr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_SLLr: begin
				func <= `SLLr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_SLTr: begin
				func <= `SLTr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_SLTUr: begin
				func <= `SLTUr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_XORr: begin
				func <= `XORr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_SRLr: begin
				func <= `SRLr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_SRAr: begin
				func <= `SRAr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_ORr: begin
				func <= `ORr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			`RV32I_ANDr: begin
				func <= `ANDr;
				rs1v <= 1;
				rs2v <= 1;
				rdv <= 1;
				immediate <= 32'b0;
			end
			default: begin
				func <= `BAD;
				rs1v <= 0;
				rs2v <= 0;
				rdv <= 0;
				immediate <= 32'b0;
			end
			endcase
		end
		else begin
				func <= `BAD;
				rs1v <= 0;
				rs2v <= 0;
				rdv <= 0;
				immediate <= 32'b0;
		end
end



endmodule