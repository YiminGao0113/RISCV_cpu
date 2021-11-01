--
-- VHDL Architecture CAD_lib.Fetch1.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 13:13:15 2021/02/22
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;



ENTITY Fetch1 IS
  GENERIC(width : NATURAL range 1 TO 64 := 32);
  PORT(Jaddr, Mdata : IN std_ulogic_vector(width - 1 DOWNTO 0);
       Address, Inst: OUT std_ulogic_vector(width - 1 DOWNTO 0);
       Clock, Jmp, Reset, Delay : IN std_ulogic;
       Read : OUT std_ulogic);
END ENTITY Fetch1;

--
ARCHITECTURE Behavior OF Fetch1 IS
  CONSTANT zero : std_ulogic_vector(width - 1 DOWNTO 0) := (others => '0');
  CONSTANT NOP : std_ulogic_vector(width - 1 DOWNTO 0) := "00000000000000000000000000010011";
BEGIN
  PROCESS(Clock,Jmp,Reset)
  BEGIN
      
      
      Read <= NOT (Reset OR Jmp);
      IF((Reset OR Jmp) ='0') THEN
        Inst <= Mdata;
      ELSIF((Reset OR Jmp) = '1') THEN
        Inst <= NOP;
      END IF;
      
      
    IF(rising_edge(Clock)) THEN
      IF(Reset = '0') THEN
        IF(Jmp = '1') THEN
          Address <= Jaddr;
        ELSIF (Jmp = '0' AND Delay = '0') THEN
          Address <= std_ulogic_vector(UNSIGNED(Address) + 4);
        END IF;
      ELSIF(RESET = '1') THEN
        Address <= zero;
      END IF;
    END IF;
  
    
  END PROCESS;
  
END ARCHITECTURE Behavior;

