--
-- VHDL Architecture CAD_lib.MemorySystem_tb.Testbench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 10:10:40 2021/04/28
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

USE std.textio.all;

LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY MemorySystem_tb IS
END ENTITY MemorySystem_tb;

--
ARCHITECTURE Testbench OF MemorySystem_tb IS

FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\MemorySystem_vec.txt";
SIGNAL Addr, DataIn : std_ulogic_vector(31 DOWNTO 0);
SIGNAL C, we, re: std_ulogic;
SIGNAL mdelay, mdelayv : std_ulogic;
SIGNAL DataOut, DataOutv : std_ulogic_vector(31 DOWNTO 0);
SIGNAL vecno : NATURAL := 0;

BEGIN
duv : ENTITY work.MemorySystem(Behavior)
      PORT MAP(Addr=>Addr,DataIn=>DataIn,clock=>C,we=>we,re=>re,mdelay=>mdelay,DataOut=>DataOut);

stim : PROCESS
  VARIABLE L : Line;
  VARIABLE Addr_val, DataIn_val : std_ulogic_vector(31 DOWNTO 0);
  VARIABLE we_val, re_val : std_ulogic;
  VARIABLE mdelay_val : std_ulogic;
  VARIABLE DataOut_val : std_ulogic_vector(31 DOWNTO 0);
  BEGIN
  wait for 40 ns;
  C <= '0';
  readline(test_vectors, L);
  while not endfile(test_vectors) LOOP
    readline(test_vectors, L);
    read(L,Addr_val);
    Addr <= Addr_val;
    read(L,DataIn_val);
    DataIn <= DataIn_val;
    read(L,we_val);
    we <= we_val;
    read(L,re_val);
    re <= re_val;
    read(L,mdelay_val);
    mdelayv <= mdelay_val;
    read(L,DataOut_val);
    DataOutv <= DataOut_val;

    wait for 10 ns;
    C <= '1';
    wait for 50 ns;
    C <= '0';
    wait for 40 ns;
  END LOOP;
      report "End of TestBench.";
      std.env.finish;
END PROCESS;

Check : PROCESS(C)

BEGIN
  IF(falling_edge(C)) THEN
        ASSERT (mdelay=mdelayv) AND (DataOut=DataOutv)
        REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
        SEVERITY WARNING;
    vecno <= vecno + 1;
  END IF;
END PROCESS;


END ARCHITECTURE Testbench;
