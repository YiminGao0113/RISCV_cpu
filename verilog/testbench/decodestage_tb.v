module decodestage_tb;
	reg    [31:0]     inst, addr, dataA, dataB, left, right, extra;
	reg 	 		  clk, jmp, stall;
	reg    [5:0]      func;
	reg    [4:0]      rs1, rs2, rd;
	reg               rs1v, rs2v, rdv;

	integer i;
	integer f;



	initial begin
		clk = 1;
		f = $fopen("D:\Myproject\riscv-cpu-verilog\src\decodestage_vec.bin", "r");
		while (!$feof(f)) begin
			@(posedge clk)
			$fscanf(f,"%b\n", func);
		end
		#20 $finish;
	end


always begin
	#5 clk = ~clk;
end

endmodule