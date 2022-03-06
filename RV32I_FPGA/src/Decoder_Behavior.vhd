--
-- VHDL Architecture CAD_lib.Decoder.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 20:43:13 2021/02/14
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Decoder IS
  GENERIC(InBits : NATURAL RANGE 2 TO 6 := 5);
  PORT(sel : IN std_ulogic_vector(InBits - 1 DOWNTO 0);
       OneHot : OUT std_ulogic_vector((2**InBits - 1) DOWNTO 0);
       enable : IN std_ulogic);
END ENTITY Decoder;

--
ARCHITECTURE Behavior OF Decoder IS
BEGIN
  PROCESS(sel,enable)
    VARIABLE selection : NATURAL RANGE 0 TO 31;
    VARIABLE result : std_ulogic_vector((2**InBits - 1) DOWNTO 0);
    CONSTANT zero : std_ulogic_vector((2**InBits - 1) DOWNTO 0) := (others => '0');
  BEGIN
    result := zero;
    IF(enable = '1') THEN
      selection := To_Integer(UNSIGNED(sel));
      result(selection) := '1';
    END IF;
    OneHot <= result;
 END PROCESS;
END ARCHITECTURE Behavior;
