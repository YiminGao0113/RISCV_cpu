`include "fetch.v"
module fetch_tb;
	reg clk, jmp, rst, delay;
	reg [31:0] jaddr, mdata;
	wire [31:0] addr, inst;
	wire read;

fetch f1(jaddr, mdata, addr, inst, clk, jmp, rst, delay, read);
initial begin
    $dumpfile("fetch_tb.vcd");
    $dumpvars(0,fetch_tb);
	clk = 1; rst = 0; jmp = 0; delay = 0; jaddr = 32'b100; mdata = 32'b10011001;
	#5 rst = 1;
	#10 rst = 0;
	#60 jmp = 1;
	#10 jmp = 0;
	#30 delay = 1;
	#20 delay = 0;
	#40 $finish;

	$display("Test complete!");
end

//clock generator
always begin
	#5 clk = ~clk; //Toggle clock every 5 ticks
end

defparam f1.width = 32;
endmodule