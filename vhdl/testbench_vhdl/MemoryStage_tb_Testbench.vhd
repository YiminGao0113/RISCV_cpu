--
-- VHDL Architecture CAD_lib.MemoryStage_tb.Testbench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 15:41:14 2021/04/ 4
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE std.textio.all;

LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY MemoryStage_tb IS
END ENTITY MemoryStage_tb;

--
ARCHITECTURE Testbench OF MemoryStage_tb IS
-- File variable
  FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\MemoryStage_vec.txt";
--Input
SIGNAL Addr, Data, DataIn : std_ulogic_vector(31 DOWNTO 0);
SIGNAL Rd : std_ulogic_vector(4 DOWNTO 0);
SIGNAL Func : RV32I_Op;
SIGNAL Mdelay : std_ulogic;

SIGNAL C : std_ulogic;
--Ouput
SIGNAL DataOut, DataOutv, AddrOut, AddrOutv, Data1, Data1v : std_ulogic_vector(31 DOWNTO 0);
SIGNAL Stall, Stallv, w, wv, r, rv : std_ulogic;
SIGNAL sel, selv : std_ulogic_vector(1 DOWNTO 0);

-- Test vector number
SIGNAL vecno : NATURAL := 0;

BEGIN
  duv : ENTITY work.MemoryStage(Mixed)
        GENERIC MAP(width => 32)
        PORT MAP(Addr=>Addr,Data=>Data,Rd=>Rd,Func=>Func,DataIn=>DataIn,Mdelay=>Mdelay,DataOut=>DataOut,AddrOut=>AddrOut,w=>w,r=>r,sel=>sel,Data1=>Data1,Stall=>Stall,C=>C);
  stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE Func_val : Func_Name;
    VARIABLE Addr_val, Data_val, DataIn_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Rd_val : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE Mdelay_val : std_ulogic;

    VARIABLE w_val, r_val : std_ulogic;
    VARIABLE sel_val : std_ulogic_vector(1 DOWNTO 0);
    VARIABLE DataOut_val, Data1_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Stall_val : std_ulogic;
    BEGIN
    C <= '0';
    wait for 40 ns;
    readline(test_vectors,L);
    WHILE NOT endfile(test_vectors) LOOP
    readline(test_vectors,L);

    -- Read Input
    read(L,Func_val);
    Func <= Ftype(Func_val);
    read(L,Addr_val);
    Addr <= Addr_val;
    read(L,Data_val);
    Data <= Data_val;
    read(L,Rd_val);
    Rd <= Rd_val;
    read(L,DataIn_val);
    DataIn <= DataIn_val;
    read(L,Mdelay_val);
    Mdelay <= Mdelay_val;

    --Read output we want to Check
    read(L,w_val);
    wv <= w_val;
    read(L,r_val);
    rv <= r_val;
    read(L,sel_val);
    selv <= sel_val;
    read(L,DataOut_val);
    DataOutv <= DataOut_val;
    read(L,Data1_val);
    Data1v <= Data1_val;
    read(L,Stall_val);
    Stallv <= Stall_val;


    wait for 10 ns;
    C <= '1';
    wait for 50 ns;
    C <= '0';
    wait for 40 ns;

    END LOOP;
        report "End of TestBench.";
        std.env.finish;
    END PROCESS;

    Check: PROCESS(C)

    BEGIN
      IF(falling_edge(C)) THEN
            ASSERT (DataOut=DataOutv) AND (w=wv) AND (r=rv) AND (sel=selv) AND (Data1=Data1v) AND (Stall=Stallv)
            REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
            SEVERITY WARNING;
        vecno <= vecno + 1;
      END IF;
    END PROCESS;




END ARCHITECTURE Testbench;
