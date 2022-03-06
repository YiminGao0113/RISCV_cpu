--
-- VHDL Architecture CAD_lib.RegReadWrite.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 18:16:15 2021/02/11
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY RegReadWrite IS
  GENERIC(size : NATURAL RANGE 2 TO 64 := 8);
  PORT(D : IN std_ulogic_vector(size - 1 DOWNTO 0);
       Q : OUT std_ulogic_vector(size - 1 DOWNTO 0);
       Clk, LE, OE, R : IN std_ulogic);
END ENTITY RegReadWrite;

--
ARCHITECTURE Behavior OF RegReadWrite IS
  SIGNAL Qval : std_ulogic_vector(size-1 DOWNTO 0);
  CONSTANT HiZ : std_ulogic_vector(size-1 DOWNTO 0) := (others => 'Z');
BEGIN
  store : ENTITY work.Reg(Behavior)
  GENERIC MAP(size => size)
  PORT MAP(D=>D, Q=>Qval, C=>Clk, E=>LE, R=>R);
Q <= Qval WHEN OE='1' ELSE HiZ;
END ARCHITECTURE Behavior;
