--
-- VHDL Architecture CAD_lib.Multiplexer3to1.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 14:04:26 2021/02/11
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Multiplexer3to1 IS
  GENERIC(width : NATURAL range 1 TO 64 := 8);
  PORT(In0, In1, In2 : IN std_ulogic_vector(width - 1 DOWNTO 0);
        Q       : OUT std_ulogic_vector(width - 1 DOWNTO 0);
        Sel     : IN std_ulogic_vector(1 DOWNTO 0));
END ENTITY Multiplexer3to1;

--
ARCHITECTURE Behavior OF Multiplexer3to1 IS
BEGIN
  PROCESS(Sel,In0, In1, In2)
  BEGIN
    IF (Sel = "00") THEN
      Q <= In0;
    ELSIF (Sel = "01") THEN
      Q <= In1;
    ELSIF (Sel = "10") THEN
      Q <= In2;
    ELSE
      Q <= "XXXXXXXX";
    END IF;
    
  END PROCESS;
END ARCHITECTURE Behavior;

