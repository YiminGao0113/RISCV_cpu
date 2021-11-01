module counter(clk, rst, enable, D, Q);
	parameter width = 8;
	
	//Port Declaration

	input  [width-1:0] D;
	input  clk, rst, enable;
	output reg [width-1:0] Q;

// use reg assignment inside a block and wire assignment outside a block
always @(posedge clk) begin
	if (rst)
		Q <= 0; // reset
	else if (enable)
		Q <= Q + 4;
end
endmodule
