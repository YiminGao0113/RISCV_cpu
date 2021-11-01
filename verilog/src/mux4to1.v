module mux4to1(in0, in1, in2, in3, sel, Q);
	parameter width = 8;
	input [width-1:0] in0, in1, in2, in3;
	input [1:0] sel;
	output [width-1:0] Q;

assign Q = (sel == 2'b00) ? in0 :
		   (sel == 2'b01) ? in1 :
		   (sel == 2'b10) ? in2 :
		   (sel == 2'b11) ? in3 :
		   0;

endmodule
