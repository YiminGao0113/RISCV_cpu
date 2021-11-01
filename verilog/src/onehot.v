module onehot(sel, onehot, enable);

	input [4:0] sel;
	input enable;
	output [31:0] onehot;

	wire [31:0] result;

	generate
		genvar i;
		for (i=0; i<=31; i=i+1) begin: o
			assign result[i] = (i==sel) ? 1'b1 : 1'b0;
		end
	endgenerate

	assign onehot = enable ? result : 32'b0;

endmodule