`timescale 1ns / 1ps
module top_tb();

reg clk, rst;
int i;
int fd;
initial fd = $fopen("../../../../../trial.txt","w");

top t(clk, rst);

initial begin
//    fd = $fopen("trial.txt","w");
//    $fdisplay(fd, "AIRISC in simulation...\n");
    clk = 0;rst=0; #20;
    rst = 1; #20;
    clk = 1; #20;
    rst = 0; #60;
    $fwrite(fd, "\t\ti\tAddr\tdatafromdmem\tld\tdatatodmem\tst\n");
    for (i = 0; i < 2000; i = i + 1)
        begin 
            clk = ~clk;
            #50;
            $fwrite(fd, "%d\t%h\t%h\t%h\t%h\n%h\n", i+1, t.addr, t.o_data, t.ld, t.i_data, t.st);
            clk = ~clk;
            #50;
        end
    $fclose(fd);
end

endmodule