--
-- VHDL Architecture CAD_lib.WriteBackStage_tb.Testbench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 15:42:09 2021/04/ 4
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

USE std.textio.all;

LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY WriteBackStage_tb IS
END ENTITY WriteBackStage_tb;

--
ARCHITECTURE Testbench OF WriteBackStage_tb IS

FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\WriteBackStage_vec.txt";
SIGNAL DataIn : std_ulogic_vector(31 DOWNTO 0);
SIGNAL rd : std_ulogic_vector(4 DOWNTO 0);
SIGNAL Func: RV32I_Op;
SIGNAL C : std_ulogic;
SIGNAL we, wev : std_ulogic;
SIGNAL rd1, rd1v : std_ulogic_vector(4 DOWNTO 0);
SIGNAL DataOut,DataOutv : std_ulogic_vector(31 DOWNTO 0);
SIGNAL vecno : NATURAL := 0;


BEGIN
duv : ENTITY work.WriteBackStage(Mixed)
      GENERIC MAP(width=>32)
      PORT MAP(DataIn=>DataIn,rd=>rd,Func=>Func,C=>C,we=>we,rd1=>rd1,DataOut=>DataOut);

stim : PROCESS
VARIABLE L : Line;
VARIABLE DataIn_val : std_ulogic_vector(31 DOWNTO 0);
VARIABLE rd_val : std_ulogic_vector(4 DOWNTO 0);
VARIABLE Func_val: Func_Name;
VARIABLE we_val : std_ulogic;
VARIABLE rd1_val : std_ulogic_vector(4 DOWNTO 0);
VARIABLE DataOut_val : std_ulogic_vector(31 DOWNTO 0);
BEGIN

C <= '0';
wait for 40 ns;
readline(test_vectors,L);
WHILE NOT endfile(test_vectors) LOOP
    readline(test_vectors,L);
    read(L,Func_val);
    Func <= Ftype(Func_val);
    read(L,DataIn_val);
    DataIn <= DataIn_val;
    read(L,rd_val);
    rd <= rd_val;
    read(L,we_val);
    wev <= we_val;
    read(L,rd1_val);
    rd1v <= rd1_val;
    read(L,DataOut_val);
    Dataoutv <= DataOut_val;
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
          ASSERT (we=wev) AND (rd1=rd1v) AND (DataOut=DataOutv)
          REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
          SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;


END ARCHITECTURE Testbench;
