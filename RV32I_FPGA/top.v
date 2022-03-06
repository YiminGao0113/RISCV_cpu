`timescale 1ns / 1ps

module top #(parameter WIDTH = 32)
(
    input clk,
    input rst,
    output [7:0] led
);

wire [WIDTH-1:0] addr;
wire [WIDTH-1:0] i_data;
wire [WIDTH-1:0] o_data;
wire ld, st;
//assign led[7:0] = addr[7:0];
//assign led[7] = rst;

mem m1(
    .clk(clk),
    .addr(addr),
    .ld(ld),
    .st(st),
    .i_data(i_data),
    .o_data(o_data),
    .led(led)
);

RV32I_Processor p(
    .Clock(clk),
    .Reset(rst),
    .DatafromMemSys(o_data),
    .DataFromMSToMemSys(i_data),
    .AddrToMemSys(addr),
    .weToMemSys(st),
    .reToMemSys(ld),
    .Mdelay(1'b0)
);




endmodule