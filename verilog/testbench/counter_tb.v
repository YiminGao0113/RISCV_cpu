`include "counter_structure.v"
module counter_tb();
	reg clk, rst, enable;
	reg[31:0] D;
	wire[31:0] Q;

initial begin
	clk = 1;
	rst = 0;
	enable = 0;
	#5 rst = 1;
	   D = 8'h01;
	   enable = 1;
	#10 rst = 0;
	#40 rst = 1;
	#10 rst = 0;
	#100 enable = 0;
	#5 $finish;
end

//clock generator
always begin
	#5 clk = ~clk; //Toggle clock every 5 ticks
end

counter c1(
	.clk(clk),
	.rst(rst),
	.enable(enable),
	.D(D),
	.Q(Q)
	);
endmodule