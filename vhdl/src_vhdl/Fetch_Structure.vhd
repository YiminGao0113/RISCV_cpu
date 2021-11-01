--
-- VHDL Architecture CAD_lib.Fetch.Structure
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 18:36:49 2021/02/20
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Fetch IS
  GENERIC(width : NATURAL range 1 TO 64 := 32);
  PORT(Jaddr, Mdata : IN std_ulogic_vector(width - 1 DOWNTO 0);
       Address, Inst: OUT std_ulogic_vector(width - 1 DOWNTO 0);
       Clock, Jmp, Reset, Delay : IN std_ulogic;
       Read : INOUT std_ulogic);
END ENTITY Fetch;

--
ARCHITECTURE Structure OF Fetch IS
  CONSTANT NOP : std_ulogic_vector(width - 1 DOWNTO 0) := "00000000000000000000000000010011";
  CONSTANT zero : std_ulogic_vector(width - 1 DOWNTO 0) := (others => '0');
  SIGNAL Q1 : std_ulogic_vector(width - 1 DOWNTO 0);
  SIGNAL Q2 : std_ulogic_vector(width - 1 DOWNTO 0);
  SIGNAL E,r : std_ulogic;
BEGIN
  
  E <= NOT Delay;
  r <= Jmp OR Reset;
  
  Mux1 : ENTITY work.Multiplexer2to1(Behavior)
    GENERIC MAP(width => width)
    PORT MAP(In0 => Jaddr, In1 => zero, Q => Q1, Sel => Reset);
      
      
  Counter: ENTITY work.Counter(Structure)
    GENERIC MAP(width => width)
    PORT MAP(D=>Q1,Q=>Address,Clock=>Clock,enable=>E,reset=>r,Inc=>"11");
      
  Read1 : Read <= NOT(Jmp OR Reset);
  
  Mux2 : ENTITY work.Multiplexer2to1(Behavior)
    GENERIC MAP(width => width)
    PORT MAP(In0 => NOP, In1 => Mdata, Q => Inst, Sel => Read);
      

    
      
END ARCHITECTURE Structure;

