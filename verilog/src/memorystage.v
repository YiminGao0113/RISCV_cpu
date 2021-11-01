`include "reg.v"
`include "rv32i_defs.v"

module memorystage(clk,addr_in,data_in,rd,func,data_from_mem,mdelay,addr_to_mem,data_to_mem,w,r,sel,data_out,rd_out,func_out,stall);
	parameter width = 32;
	input clk, mdelay;
	input [width-1:0] addr_in, data_in, data_from_mem;
	input [4:0] rd;
	input [5:0] func;
	output [width-1:0] addr_to_mem, data_to_mem;
	output reg w, r;
	output reg [1:0] sel;
	output reg [width-1:0] data_out;
	output [4:0] rd_out;
	output [5:0] func_out;
	output stall;

	wire [width-1:0] addr_temp, data_temp;
	wire [5:0] func_temp;

reg0 reg_addr_ms(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(addr_in),
	.Q(addr_temp));
defparam reg_addr_ms.width = width;

reg0 reg_data_ms(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(data_in),
	.Q(data_temp));
defparam reg_data_ms.width = width;

reg0 reg_rd_ms(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(rd),
	.Q(rd_out));
defparam reg_rd_ms.width = 5;

reg0 reg_func_ms(
	.clk(clk),
	.enable(~stall),
	.rst(1'b0),
	.D(func),
	.Q(func_temp));
defparam reg_func_ms.width = 6;

assign func_out = mdelay ? `NOP : func_temp;
assign stall = mdelay;
assign data_to_mem = data_temp;
assign addr_to_mem = addr_temp;

always @(*) begin
	case (func_temp)
		`LB || `LBU: begin
			w <= 1'b0;
			r <= 1'b1;
			sel <= 2'b00;
			data_out <= data_from_mem;
		end
		`LH || `LHU:begin
			w <= 1'b0;
			r <= 1'b1;
			sel <= 2'b01;
			data_out <= data_from_mem;
		end
		`LW:begin
			w <= 1'b0;
			r <= 1'b1;
			sel <= 2'b10;
			data_out <= data_from_mem;
		end
		`SB:begin
			w <= 1'b1;
			r <= 1'b0;
			sel <= 2'b00;
			data_out <= data_temp;
		end
		`SH:begin
			w <= 1'b1;
			r <= 1'b0;
			sel <= 2'b01;
			data_out <= data_temp;
		end
		`SW:begin
			w <= 1'b1;
			r <= 1'b0;
			sel <= 2'b10;
			data_out <= data_temp;
		end
		default:begin
			w <= 1'b0;
			r <= 1'b0;
			sel <= 2'b11;
			data_out <= data_temp;
		end
	endcase
end

endmodule
