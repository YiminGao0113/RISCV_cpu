--
-- VHDL Architecture CAD_lib.Arbiter.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 18:13:18 2021/04/ 3
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE work.RV32I.ALL;


ENTITY Arbiter IS
  GENERIC(width : NATURAL range 1 TO 64 := 32);
  PORT(-- From memory stage or fetch
       AddrFromMem, AddrFromFetch : IN std_ulogic_vector(width - 1 DOWNTO 0);
       w, r : IN std_ulogic;
       sel : IN std_ulogic_vector(1 DOWNTO 0);

       -- From memory system
       Mdelay : IN std_ulogic;

       -- For the special case jump = '1' and sel != "11"
       -- which means jump or taken branch in execute stage
       -- at the same time memory stage using the mem sys
       -- The system should not only stall fetch, but also decode stage and execute stage
       Jmp : IN std_ulogic;
       StallforSpecialCase : OUT std_ulogic;

       -- To memory system
       AddrIn : OUT std_ulogic_vector(width - 1 DOWNTO 0);
       we, re : OUT std_ulogic;
       selIn : OUT std_ulogic_vector(1 DOWNTO 0);

       -- To memory stage
       MSDelay : OUT std_ulogic;
       MFDelay : OUT std_ulogic);

       -- To fetch stage
--       DataOut : IN std_ulogic_vector(width - 1 DOWNTO 0);
END ENTITY Arbiter;

--
ARCHITECTURE Behavior OF Arbiter IS
BEGIN
ToMemorySystem : PROCESS(w, r, sel, Mdelay, AddrFromMem, AddrFromFetch, Jmp)
BEGIN
  IF(sel = "11") THEN
  -- The memory system should link to Fetch
  AddrIn <= AddrFromFetch;
  we <= '0';
  re <= '1';
  selIn <= "10"; --Fetch always read 1 word from memory

  MSDelay <= '0';
  MFDelay <= Mdelay;
  StallforSpecialCase <= '0';
  else
  -- The memory system should link to memory stage
  AddrIn <= AddrFromMem;
  we <= w;
  re <= r;
  selIn <= sel;
  MSDelay <= Mdelay;
  MFDelay <= '1';
  IF Jmp = '0' THEN
    StallforSpecialCase <= '0';
  ELSE
    StallforSpecialCase <= '1';
  END IF;

  END IF;
END PROCESS;
END ARCHITECTURE Behavior;
