`include "regtracker.v"

module regtracker_tb;
	reg rs1v, rs2v, rdv, we, rst, clk;
	reg [4:0] rs1, rs2, rd, rdwbs;
	reg jmp, stall_jmp_mem;
	wire stall;

regtracker r(rs1v,rs2v,rdv,we,rst,clk,rs1,rs2,rd,rdwbs,jmp,stall_jmp_mem,stall);

initial begin
	$dumpfile("regtracker_tb.vcd");
	$dumpvars(0,regtracker_tb);
	clk=1; rst=0; rs1v=0; rs2v=0; rdv=0; we=0;
	#5 rst=1;
	#10 rst=0;
	#10 rs1=5'b00100;rs2=5'b00010;rd=5'b00111;rdwbs=5'b10000;rs1v=1'b1;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00011;rd=5'b00110;rdwbs=5'b10000;rs1v=1'b0;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00011;rd=5'b00110;rdwbs=5'b10000;rs1v=1'b1;rs2v=1'b1;rdv=1'b0;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00011;rd=5'b00110;rdwbs=5'b00111;rs1v=1'b1;rs2v=1'b1;rdv=1'b0;we=1'b1;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00011;rd=5'b00110;rdwbs=5'b00111;rs1v=1'b1;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00110;rd=5'b00110;rdwbs=5'b00111;rs1v=1'b0;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00110;rd=5'b00110;rdwbs=5'b00110;rs1v=1'b0;rs2v=1'b0;rdv=1'b0;we=1'b1;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00110;rd=5'b00110;rdwbs=5'b00110;rs1v=1'b0;rs2v=1'b0;rdv=1'b0;we=1'b1;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00110;rd=5'b00110;rdwbs=5'b00110;rs1v=1'b0;rs2v=1'b0;rdv=1'b0;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b00111;rs2=5'b00110;rd=5'b00110;rdwbs=5'b00110;rs1v=1'b0;rs2v=1'b1;rdv=1'b0;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;

	#10 rs1=5'b10111;rs2=5'b00001;rd=5'b10111;rdwbs=5'b00001;rs1v=1'b1;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b10110;rs2=5'b00001;rd=5'b10111;rdwbs=5'b00001;rs1v=1'b1;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b1;stall_jmp_mem=1'b0;
	#10 rs1=5'b10110;rs2=5'b00001;rd=5'b10111;rdwbs=5'b00001;rs1v=1'b1;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b0;
	#10 rs1=5'b10110;rs2=5'b00001;rd=5'b10111;rdwbs=5'b00001;rs1v=1'b1;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b1;
	#10 rs1=5'b10111;rs2=5'b00001;rd=5'b10111;rdwbs=5'b10111;rs1v=1'b1;rs2v=1'b1;rdv=1'b1;we=1'b0;jmp=1'b0;stall_jmp_mem=1'b1;
	#10 rs1=5'b10111;rs2=5'b00001;rd=5'b10111;rdwbs=5'b10111;rs1v=1'b1;rs2v=1'b1;rdv=1'b0;we=1'b1;jmp=1'b0;stall_jmp_mem=1'b1;
	#10 rs1=5'b10111;rs2=5'b00001;rd=5'b10111;rdwbs=5'b10111;rs1v=1'b1;rs2v=1'b1;rdv=1'b0;we=1'b1;jmp=1'b0;stall_jmp_mem=1'b1;
	
	#20 $finish;

	$display("Test Complete!");
end

always begin
	#5 clk = ~clk;
end
endmodule