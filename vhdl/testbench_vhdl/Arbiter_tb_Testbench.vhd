--
-- VHDL Architecture CAD_lib.Arbiter_tb.Testbench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 15:41:46 2021/04/ 4
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE std.textio.all;

LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY Arbiter_tb IS
END ENTITY Arbiter_tb;

--
ARCHITECTURE Testbench OF Arbiter_tb IS
-- File variable
FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\Arbiter_vec.txt";

SIGNAL AddrFromMem, AddrFromFetch, DataFromMem, DataFromFetch : std_ulogic_vector(31 DOWNTO 0);
SIGNAL w, r : std_ulogic;
SIGNAL sel : std_ulogic_vector(1 DOWNTO 0);
SIGNAL Mdelay : std_ulogic;
SIGNAL C : std_ulogic;
-- To memory system
SIGNAL AddrIn, AddrInv, DataIn, DataInv : std_ulogic_vector(31 DOWNTO 0);
SIGNAL we, wev, re, rev : std_ulogic;
SIGNAL selIn,selInv: std_ulogic_vector(1 DOWNTO 0);
-- To memory stage
SIGNAL MSDelay, MSDelayv,MFDelay, MFDelayv : std_ulogic;


SIGNAL vecno : NATURAL := 0;

BEGIN

duv : ENTITY work.Arbiter(Behavior)
      GENERIC MAP(width => 32)
      PORT MAP(AddrFromMem=>AddrFromMem,AddrFromFetch=>AddrFromFetch,w=>w,r=>r,sel=>sel,Mdelay=>Mdelay,AddrIn=>AddrIn,we=>we,re=>re,selIn=>selIn,Jmp=>'0',MSDelay=>MSDelay,MFDelay=>MFDelay);
stim : PROCESS
  VARIABLE L : LINE;
  VARIABLE AddrFromMem_val, AddrFromFetch_val: std_ulogic_vector(31 DOWNTO 0);
  VARIABLE w_val,r_val : std_ulogic;
  VARIABLE sel_val : std_ulogic_vector(1 DOWNTO 0);
  VARIABLE Mdelay_val : std_ulogic;
  VARIABLE AddrIn_val : std_ulogic_vector(31 DOWNTO 0);
  VARIABLE we_val, re_val : std_ulogic;
  VARIABLE selIn_val : std_ulogic_vector(1 DOWNTO 0);
  VARIABLE MSDelay_val,MFDelay_val : std_ulogic;


  BEGIN
  C <= '0';
  wait for 40 ns;
  readline(test_vectors,L);
  WHILE NOT endfile(test_vectors) LOOP
  readline(test_vectors,L);
  read(L, AddrFromMem_val);
  AddrFromMem <= AddrFromMem_val;
  read(L, AddrFromFetch_val);
  AddrFromFetch <= AddrFromFetch_val;
  read(L, w_val);
  w <= w_val;
  read(L, r_val);
  r <= r_val;
  read(L, sel_val);
  sel <= sel_val;
  read(L, Mdelay_val);
  Mdelay <= Mdelay_val;
  read(L, AddrIn_val);
  AddrInv <= AddrIn_val;
  read(L, we_val);
  wev <= we_val;
  read(L, re_val);
  rev <= re_val;
  read(L, selIn_val);
  selInv <= selIn_val;
  read(L, MSDelay_val);
  MSDelayv <= MSDelay_val;
  read(L, MFDelay_val);
  MFDelayv <= MFDelay_val;
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
        ASSERT (AddrIn=AddrInv) AND (we=wev) AND (re=rev) AND (selIn=selInv) AND (MSDelay=MSDelayv) AND (MFDelay=MFDelayv)
        REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
        SEVERITY WARNING;
    vecno <= vecno + 1;
  END IF;
END PROCESS;

END ARCHITECTURE Testbench;
