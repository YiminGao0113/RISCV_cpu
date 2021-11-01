module reg0(clk, enable, rst, D, Q);
	parameter width = 8;
	// Port Declaration
	input [width-1:0] D;
	input clk, enable, rst;
	output reg [width-1:0] Q;

//synchronous active high reset
always @(posedge clk or posedge rst) begin
	if (rst)
		Q <= 0;
	else if (enable)
		Q <= D;
end
endmodule