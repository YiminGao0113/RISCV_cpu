--
-- VHDL Architecture CAD_lib.ProcessorWithMemSys.Structure
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 21:46:47 2021/04/14
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

USE work.RV32I.ALL;


ENTITY ProcessorWithMemSys IS
  GENERIC(width : NATURAL range 1 TO 64 := 32;
          RegSel : NATURAL range 1 TO 5 := 5);
  PORT(Clock : IN std_ulogic;
       Reset : IN std_ulogic);


END ENTITY ProcessorWithMemSys;

ARCHITECTURE Structure OF ProcessorWithMemSys IS
SIGNAL Addr, DataIn, DataOut : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL we, re, mdelay : std_ulogic;

BEGIN

RV32I_Processor  :  ENTITY work.RV32I_Processor(Structure)
              GENERIC MAP(width=>width,RegSel=>RegSel)
              PORT MAP(Clock=>Clock,Reset=>Reset,Mdelay=>Mdelay,DatafromMemSys=>DataOut,DataFromMSToMemSys=>DataIn,AddrToMemSys=>Addr,weToMemSys=>we,reToMemSys=>re);

MemorySystem: ENTITY work.MemorySystem(Behavior)
              PORT MAP(clock=>Clock,Addr=>Addr,DataIn=>DataIn,we=>we,re=>re,mdelay=>mdelay,DataOut=>DataOut);

END ARCHITECTURE Structure;
