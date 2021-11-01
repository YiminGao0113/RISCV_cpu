module mux2to1(in0, in1, Q, sel);
	parameter width = 8;

	input [width-1:0] in0, in1;
	input sel;
	output [width-1:0] Q;

assign Q = sel? in1 : in0;

endmodule
