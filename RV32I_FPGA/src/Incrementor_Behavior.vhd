--
-- VHDL Architecture CAD_lib.Incrementor.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 14:40:35 2021/02/11
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Incrementor IS
  GENERIC(size : NATURAL range 1 TO 64 := 8);
  PORT(D : IN std_ulogic_vector(size - 1 DOWNTO 0);
       Q : OUT std_ulogic_vector(size - 1 DOWNTO 0);
       Inc : IN std_ulogic_vector(1 DOWNTO 0));
END ENTITY Incrementor;

--
ARCHITECTURE Behavior OF Incrementor IS
BEGIN
  PROCESS(D,Inc)
  VARIABLE Sum : UNSIGNED(size - 1 DOWNTO 0);
  BEGIN
    Sum := UNSIGNED(D);
    IF (Inc = "01") THEN
      Sum := UNSIGNED(D) + 1;
    ELSIF(Inc = "10") THEN
      Sum := UNSIGNED(D) + 2;
    ELSIF(Inc = "11") THEN
      Sum := UNSIGNED(D) + 4;
    END IF;
    Q <= std_ulogic_vector(Sum);
  END PROCESS;
END ARCHITECTURE Behavior;

