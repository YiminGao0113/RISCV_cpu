`include "incrementor.v"
module incrementor_tb();
	reg [1:0] inc;
	reg [7:0] D;
	wire [7:0] Q;

initial begin
	D = 8'h01;
	inc = 0;
	#5 inc = 2'b01;
	#5 inc = 2'b10;
	#5 inc = 2'b11;
	#5 $finish;
end


incrementor i1(
	.D(D),
	.inc(inc),
	.Q(Q));

endmodule