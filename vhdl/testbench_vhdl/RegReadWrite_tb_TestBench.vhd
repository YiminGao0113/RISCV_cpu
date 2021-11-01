--
-- VHDL Architecture CAD_lib.RegReadWrite_tb.TestBench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 15:22:26 2021/02/27
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

ENTITY RegReadWrite_tb IS
END ENTITY RegReadWrite_tb;

--
ARCHITECTURE TestBench OF RegReadWrite_tb IS
  FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\RegReadWrite_vec.txt";
  
  SIGNAL D: std_ulogic_vector(7 DOWNTO 0);
  SIGNAL Q, Qv: std_logic_vector(7 DOWNTO 0);
  SIGNAL C, LE, OE: std_ulogic;
  
  SIGNAL vecno : NATURAL := 0;
BEGIN
  duv : ENTITY work.RegReadWrite(Mixed)
    GENERIC MAP(size => 8)
    PORT MAP(D => D, Q => Q, Clk => C, LE => LE, OE => OE);
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE Dval : std_ulogic_vector(7 DOWNTO 0);
    VARIABLE Qval : std_logic_vector(7 DOWNTO 0);
    VARIABLE LEval, OEval : std_ulogic;
  BEGIN
    C <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      read(L, LEval);
      LE <= LEval;
      read(L, OEval);
      OE <= OEval;
      read(L, Dval);
      D <= Dval;
      read(L, Qval);
      Qv <= Qval;
      wait for 10 ns;
      C <= '1';
      wait for 50 ns;
      C <= '0';
      wait for 40 ns;
    END LOOP;
    
    report "End of TestBench.";
 --   std.env.finish;
  END PROCESS;
  Check : PROCESS(C)
  BEGIN
    IF(falling_edge(C)) THEN
      ASSERT Q = Qv
        REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
    

  END PROCESS;
END ARCHITECTURE TestBench;

