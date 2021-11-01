
module arbiter(addr_ms, addr_fs, w, r, sel, mdelay, jmp,addr_out,we,re,sel_out,MMDelay,MFDelay,stall_jmp_mem);
	parameter width = 32;
	input [width-1:0] addr_ms, addr_fs;
	input w, r;
	input [1:0] sel;
	input mdelay, jmp;
	// When taken branch and memory stage manipulating memory system occur at same time
	// decode stage and execute stage should be also stalled like the fetch stage
	output [width-1:0] addr_out;
	output we, re;
	output [1:0] sel_out;
	output MMDelay, MFDelay, stall_jmp_mem;

assign addr_out = (&sel) ? addr_fs : addr_ms;
assign we = (&sel) ? 1'b0 : w;
assign re = (&sel) ? 1'b1 : r;
assign sel_out = (&sel) ? 2'b10 : sel;
assign MMDelay = (&sel) ? 1'b0 : mdelay;
assign MFDelay = (&sel) ? mdelay : 1'b1;
assign stall_jmp_mem = (~&sel)&jmp;

endmodule