--
-- VHDL Architecture CAD_lib.RegTracker_tb.Testbench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 15:56:23 2021/04/12
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

USE std.textio.all;

LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY RegTracker_tb IS
END ENTITY RegTracker_tb;

--

ARCHITECTURE Testbench OF RegTracker_tb IS
FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\RegTracker_vec.txt";
SIGNAL rs1, rs2, rdDS, rdWBS : std_ulogic_vector(4 DOWNTO 0);
SIGNAL rs1v, rs2v, rdv, we, R : std_ulogic;
SIGNAL C : std_ulogic;
SIGNAL Stall, Stallv : std_ulogic;
SIGNAL vecno : NATURAL := 0;

BEGIN
  duv : ENTITY work.RegTracker(Mixed)
        GENERIC MAP(width=>2,RegSel=>5)
        PORT MAP(rs1=>rs1,rs2=>rs2,rdDS=>rdDS,rdWBS=>rdWBS,rs1v=>rs1v,rs2v=>rs2v,rdv=>rdv,we=>we,R=>R,Jmp=>'0',Clock=>C,Stall=>Stall,StallforSpecialCase=>'0');
  stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE rs1_val, rs2_val, rdDS_val, rdWBS_val : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE rs1v_val, rs2v_val, rdv_val, we_val, R_val : std_ulogic;
    VARIABLE Stall_val :std_ulogic;
  BEGIN
  C <= '0';
  wait for 40 ns;
  readline(test_vectors,L);
  WHILE NOT endfile(test_vectors) LOOP

  readline(test_vectors,L);
  read(L,rs1_val);
  rs1 <= rs1_val;
  read(L,rs1v_val);
  rs1v <= rs1v_val;
  read(L,rs2_val);
  rs2 <= rs2_val;
  read(L,rs2v_val);
  rs2v <= rs2v_val;
  read(L,rdDS_val);
  rdDS <= rdDS_val;
  read(L,rdv_val);
  rdv <= rdv_val;
  read(L,rdWBS_val);
  rdWBS <= rdWBS_val;
  read(L,we_val);
  we <= we_val;
  read(L,R_val);
  R <= R_val;
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


  Check : PROCESS(C)
  BEGIN
    IF(falling_edge(C)) THEN
      ASSERT Stall=Stallv
        REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
END ARCHITECTURE Testbench;
