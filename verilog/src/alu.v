`include "rv32i_defs.v"

module alu(left, right, func, result, overflow);
	parameter width = 32;
	input [width-1:0] left, right;
	input [5:0] func;
	output reg [width-1:0] result;
	output reg overflow;

	wire sign_right = right[width-1];
	wire sign_left = left[width-1];

	always @(*) begin
		case (func)
			`ADDr || `ADDI || `LB || `LH || `LW || `LBU || `LHU || `SB || `SH || `SW || `JAL || `JALR || `AUIPC: begin
				result <= $signed(right) + $signed(left);
				if (sign_right == sign_left && sign_right != result[width-1])
					overflow <= 1'b1;
				else 
					overflow <= 1'b0;
			end
			`SUBr: begin
				result <= $signed(right) - $signed(left);
				if (sign_right != sign_left && sign_left == result[width-1])
					overflow <= 1'b1;
				else 
					overflow <= 1'b0;
			end
			`SLLr || `SLLI: begin
				result <= right << left[4:0];
			end
			`SLTr || `SLTI: begin
				result <= ($signed(right)<$signed(left))? 1'b1 : 1'b0;
			end
		  // 3'b010: begin  // SLT
	      //   out <= {31'b0, $signed(x) < $signed(y)};
	      // end
	      // 3'b011: begin  // SLTU
	      //   out <= {31'b0, x < y};
	      // end
			`SLTUr || `SLTIU: begin
				result <= (right<left)? 1'b1 : 1'b0;
			end
			`XORr || `XORI: begin
				result <= right ^ left;
			end
			`SRLr || `SRLI: begin
				result <= right >> left[4:0];
			end
			`SRAr || `SRAI: begin
				result <= right >>> left[4:0];
			end
			`ORr || `ORI: begin
				result <= right | left;
			end
			`ANDr || `ANDI: begin
				result <= right & left;
			end

			`BEQ: begin
				result[0] <= right == left;
				result[31:1] <= 31'b0;
			end
			`BNE: begin
				result[0] <= right != left;
				result[31:1] <= 31'b0;
			end
			`BLT: begin
				result[0] <= $signed(right) < $signed(left);
				result[31:1] <= 31'b0;
			end
			`BGE: begin
				result[0] <= $signed(right) >= $signed(left);
				result[31:1] <= 31'b0;
			end
			`BLTU: begin
				result[0] <= right < left;
				result[31:1] <= 31'b0;
			end
			`BGEU: begin
				result[0] <= right >= left;
				result[31:1] <= 31'b0;
			end
			default: begin
				result <= 32'b0;
			end
		endcase
	end



endmodule