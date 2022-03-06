`timescale 1ns / 1ps


module mem #(parameter WIDTH = 32, parameter DEPTH = 256) (
    input logic clk, // clock
    input logic [WIDTH-1:0] addr, // which word is read/written
    input logic ld, // load data
    input logic st, // store data 
    input logic [WIDTH-1:0] i_data, // data being written
    output logic [WIDTH-1:0] o_data, // data being read, wire
    output logic [7:0] led
);

logic [31:0] addrint;

assign addrint = addr>>2;
assign led = memory_array[26][7:0];

//    logic [WIDTH-1:0] st_mask; // store mask

    (* ram_style = "block" *) logic [WIDTH-1:0] memory_array [0:DEPTH-1];
    // ram_style is an FPGA synthesis directive to map the memory array to BRAM
    // System Verilog style array of DEPTH elements of WIDTH bits logic
    initial begin
        $readmemb("data.mem", memory_array);
    end

    assign o_data = ld ? memory_array[addrint] : 32'b0;
    always @ (posedge clk)
    begin
        if (st)
            memory_array[addrint] <= i_data; // only write to the expected bytes of memory_array[addr]
    end

endmodule

// Reference(s)
// https://timetoexplore.net/blog/block-ram-in-verilog-with-vivado
