--
-- VHDL Architecture CAD_lib.Counter.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 15:39:14 2021/02/11
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Counter IS
  GENERIC(width : NATURAL range 1 TO 64 := 8);
  PORT(D : IN std_ulogic_vector(width - 1 DOWNTO 0);
       Q : OUT std_ulogic_vector(width - 1 DOWNTO 0);
       Inc : IN std_ulogic_vector(1 DOWNTO 0);
       Clock, enable, reset: IN std_ulogic);
END ENTITY Counter;

--
ARCHITECTURE Structure OF Counter IS
  SIGNAL Q1 : std_ulogic_vector(width -1 DOWNTO 0);
  SIGNAL Q2 : std_ulogic_vector(width -1 DOWNTO 0);
  SIGNAL Q3 : std_ulogic_vector(width -1 DOWNTO 0);
BEGIN
  
  reg : ENTITY work.Reg(Behavior)
    GENERIC MAP(size => width)
    PORT MAP(D=>Q1,Q=>Q2,C=>Clock,E=>enable,R=>'0');
      
      
  incrementor : ENTITY work.incrementor(Behavior)
    GENERIC MAP(size => width)
    PORT MAP(D=>Q2,Q=>Q3,Inc=>Inc);
      
      
  Mux : ENTITY work.Multiplexer2to1(Behavior)
    GENERIC MAP(width => width)
    PORT MAP(In0=>Q3,In1=>D,Q=>Q1,Sel=>reset);
      
  Q <= Q2;
END ARCHITECTURE Structure;

