--
-- VHDL Architecture CAD_lib.Fetch_tb.Testbench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 16:32:39 2021/02/27
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

ENTITY Fetch_tb IS
END ENTITY Fetch_tb;

--
ARCHITECTURE Testbench OF Fetch_tb IS
  FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\Fetch_vec.txt";
  
  SIGNAL Jaddr, Mdata : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Address, Inst, Addressv, Instv : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Jmp, Reset, Delay : std_ulogic;
  SIGNAL C,Read0, Readv : std_ulogic;
  SIGNAL vecno : NATURAL := 0;
  
BEGIN
  duv : ENTITY work.Fetch(Structure)
      GENERIC MAP(width => 32)
      PORT MAP(Jaddr=>Jaddr,Mdata=>Mdata,Jmp=>Jmp,Reset=>Reset,Delay=>Delay,Clock=>C,Address=>Address,Inst=>Inst,Read=>Read0);
  Stim : PROCESS
    VARIABLE L : LINE;
    VARIABLE Jaddr_val, Mdata_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Jmp_val, Reset_val, Delay_val: std_ulogic;
    VARIABLE Address_val, Inst_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Read_val : std_ulogic;
  BEGIN
    C <= '0';
    wait for 40 ns;
    readline(test_vectors, L);
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors, L);
      read(L,Jaddr_val);
      Jaddr <= Jaddr_val;
      read(L, Mdata_val);
      Mdata <= Mdata_val;
      read(L,Jmp_val);
      Jmp <= Jmp_val;
      read(L,Reset_val);
      Reset <= Reset_val;
      read(L, Delay_val);
      Delay <= Delay_val;
      read(L, Address_val);
      Addressv <= Address_val;
      read(L, Inst_val);
      Instv <= Inst_val;
      read(L, Read_val);
      Readv <= Read_val;
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
      ASSERT (Address = Addressv AND Inst = Instv AND Read0 = Readv)
        REPORT "ERROR: Incorrect output for in vector " & to_String(vecno)
        SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
  
  
  
END ARCHITECTURE Testbench;

