--
-- VHDL Architecture CAD_lib.RegFileforPipeline_tb.Testbench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 15:56:00 2021/04/12
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

USE std.textio.all;

LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY RegFileforPipeline_tb IS
END ENTITY RegFileforPipeline_tb;

--
ARCHITECTURE Testbench OF RegFileforPipeline_tb IS
FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\RegFileforPipeline_vec.txt";
SIGNAL DataIn : std_ulogic_vector(31 DOWNTO 0);
SIGNAL AddrA, AddrB, AddrD : std_ulogic_vector(4 DOWNTO 0);
SIGNAL rav, rbv, we, R : std_ulogic;
SIGNAL C : std_ulogic;
SIGNAL DataA, DataAv, DataB, DataBv : std_ulogic_vector(31 DOWNTO 0);
SIGNAL vecno : NATURAL := 0;
BEGIN
  duv : ENTITY work.RegFileforPipeline(Mixed)
        GENERIC MAP(RegWidth=>32,RegSel=>5)
        PORT MAP(DataIn=>DataIn,AddrA=>AddrA,AddrB=>AddrB,AddrD=>AddrD,rav=>rav,rbv=>rbv,we=>we,R=>R,Clock=>C,DataA=>DataA,DataB=>DataB);
  stim: PROCESS
    VARIABLE L : LINE;
    VARIABLE DataIn_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE AddrA_val, AddrB_val, AddrD_val : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE rav_val, rbv_val, we_val, R_val : std_ulogic;
    VARIABLE DataA_val, DataB_val : std_ulogic_vector(31 DOWNTO 0);
    BEGIN
      C <= '0';
      wait for 40 ns;
      readline(test_vectors, L);
      WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      read(L,AddrA_val);
      AddrA <= AddrA_val;
      read(L,rav_val);
      rav <= rav_val;
      read(L,AddrB_val);
      AddrB <= AddrB_val;
      read(L,rbv_val);
      rbv <= rbv_val;
      read(L,AddrD_val);
      AddrD <= AddrD_val;
      read(L,we_val);
      we <= we_val;
      read(L,R_val);
      R <= R_val;
      read(L,DataIn_val);
      DataIn <= DataIn_val;
      read(L,DataA_val);
      DataAv <= DataA_val;
      read(L,DataB_val);
      DataBv <= DataB_val;
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
        ASSERT DataA=DataAv AND DataB=DataBv
          REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
          SEVERITY WARNING;
        vecno <= vecno + 1;
      END IF;
    END PROCESS;


END ARCHITECTURE Testbench;
