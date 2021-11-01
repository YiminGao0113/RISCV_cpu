--
-- VHDL Architecture CAD_lib.Multiplexer2to1.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 13:52:17 2021/02/11
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Multiplexer2to1 IS
  GENERIC(width : NATURAL range 1 TO 64 := 8);
  PORT(In0, In1 : IN std_ulogic_vector(width - 1 DOWNTO 0);
        Q       : OUT std_ulogic_vector(width - 1 DOWNTO 0);
        Sel     : IN std_ulogic);
END ENTITY Multiplexer2to1;

--
ARCHITECTURE Behavior OF Multiplexer2to1 IS
  CONSTANT HiX : std_ulogic_vector(width - 1 DOWNTO 0) := (others=>'X');
BEGIN
  PROCESS(Sel,In0,In1)
  BEGIN
    IF (Sel = '0') THEN
      Q <= In0;
    ELSIF (Sel = '1') THEN
      Q <= In1;
    ELSE
      Q <= HiX;
    END IF;
    
  END PROCESS;
END ARCHITECTURE Behavior;

