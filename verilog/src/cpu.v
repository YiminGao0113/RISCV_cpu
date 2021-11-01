`include "fetch.v"
`include "decodestage.v"
`include "executestage.v"
`include "memorystage.v"
`include "writebackstage.v"

`include "regfile.v"
`include "regtracker.v"
`include "arbiter.v"

module cpu(clk, rst, mdelay, DataIn, DataOut, AddrOut, we, re, sel);

	parameter width = 32;
	parameter regsel = 5;

	input                clk, rst, mdelay;
	input  [width-1:0]   DataIn;
	output [width-1:0]   DataOut, AddrOut;
	output we, re;
	output [1:0] sel;

	// fetch stage
	wire 				 jmp, delay_fetch, read_fetch;
	wire   [width-1:0]   jaddr, addr_fetch, inst_fetch;	
	// decode stage
	wire                 stall_ds, rs1v, rs2v, rdv;
	wire   [width-1:0]	  dataA_ds, dataB_ds;
	wire   [regsel-1:0]  rs1_ds, rs2_ds, rd_ds;
	wire   [5:0]         func_ds;
	// execute stage
	wire                 stall_es;
	wire   [width-1:0]   addr_es, data_es, left, right, extra;
	wire   [regsel-1:0]  rd_es;
	wire   [5:0]         func_es;
	// memory stage
	wire                 w_ms, r_ms, stall_from_ms;
	wire   [1:0]         sel_ms;
	wire   [width-1:0]   addr_ms, data_ms;
	wire   [regsel-1:0]  rd_ms;
	wire   [5:0]         func_ms;
	// write back stage
	wire                 we_ws;
	wire   [regsel-1:0]  rd_ws;
	wire   [width-1:0]   data_ws;
	// arbiter
	wire                 we, re, mdelay_fetch, mdelay_ms;
	wire   [1:0]         sel;
	// regtracker
	wire                 stall_jmp_mem, stall_from_tracker;


fetch fs(jaddr, DataIn, addr_fetch, inst_fetch, clk, jmp, rst, delay_fetch, read_fetch);

decodestage ds(inst_fetch,dataA_ds,dataB_ds,addr_fetch,clk,stall_ds,jmp,rs1_ds,rs2_ds,rd_ds,rs1v,rs2v,rdv,func_ds,left,right,extra);

executestage es(clk, left, right, extra, rd_ds, func_ds, stall_es, addr_es, data_es, jaddr, rd_es, func_es, jmp);

memorystage ms(clk,addr_es,data_es,rd_es,func_es,DataIn,mdelay_ms,addr_ms,DataOut,w_ms,r_ms,sel_ms,data_ms,rd_ms,func_ms,stall_from_ms);

writebackstage ws(data_ms,rd_ms,func_ms,clk,we_ws,rd_ws,data_ws);

arbiter a(addr_ms, addr_fetch, w_ms, r_ms, sel_ms, mdelay, jmp, AddrOut, we, re, sel, mdelay_ms, mdelay_fetch, stall_jmp_mem);

regfile rf(clk,rst,rs1_ds,rs2_ds,rd_ws,rs1v,rs2v,we_ws,data_ws,dataA_ds,dataB_ds);

regtracker rt(rs1v,rs2v,rdv,we_ws,rst,clk,rs1_ds,rs2_ds,rd_ds,rd_ws,jmp,stall_jmp_mem,stall_from_tracker);


assign delay_fetch = mdelay_fetch | stall_from_tracker;
assign stall_ds = stall_from_tracker | stall_from_ms | stall_jmp_mem;
assign stall_es = stall_from_ms | stall_jmp_mem;
endmodule
