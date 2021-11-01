module incrementor(D,Q,inc);
	parameter width = 8;

	input [width-1:0] 	  D;
	input [1:0]			  inc;
	output [width-1:0]    Q;

// always @(D or Q or inc) begin
// 	if (inc == 01)
// 	Q <= D + 1;
// 	else if(inc == 10)
// 	Q <= D + 2;
// 	else if(inc == 11)
// 	Q <= D + 4;
// end


assign Q = (inc == 2'b01) ? D + 1 :
		   (inc == 2'b10) ? D + 2 :
		   (inc == 2'b11) ? D + 4 :
		   D;

endmodule