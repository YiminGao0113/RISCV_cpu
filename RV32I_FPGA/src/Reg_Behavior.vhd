--
-- VHDL Architecture CAD_lib.Reg.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 18:23:35 2021/02/11
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Reg IS
  GENERIC(size : NATURAL RANGE 2 TO 64 := 8);
  PORT(D : IN std_ulogic_vector(size - 1 DOWNTO 0);
       Q : OUT std_ulogic_vector(size - 1 DOWNTO 0);
       C,E,R : IN std_ulogic);
END ENTITY Reg;

--
ARCHITECTURE Behavior OF Reg IS
  CONSTANT Hi0 : std_ulogic_vector(size - 1 DOWNTO 0) := (others => '0');
BEGIN
  PROCESS(R,C)
    BEGIN
      IF(rising_edge(C) and E = '1' and R = '0') THEN
        Q <= D;
      END IF;
      IF(R = '1') THEN
        Q <= Hi0;
      END IF;
  END PROCESS;
END ARCHITECTURE Behavior;