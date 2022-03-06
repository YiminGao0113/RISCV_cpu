--
-- VHDL Architecture CAD_lib.RegTracker.Mixed
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 16:18:33 2021/04/10
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
USE work.RV32I.ALL;


ENTITY RegTracker IS
  GENERIC(width : NATURAL range 2 to 64 := 2;
          RegSel : NATURAL range 2 to 5 := 5);
  PORT(rs1, rs2, rdDS, rdWBS : IN std_ulogic_vector(RegSel - 1 DOWNTO 0);
       rs1v, rs2v : IN std_ulogic;
       rdv, we : IN std_ulogic;
       -- If the signal is from decode Stage
       -- rdv = 1 we = 0
       -- If it is from write back Stage
       -- rdv = 0 we = 1
       StallforSpecialCase : IN std_ulogic;
       -- For the special case jump or taken branch in execute stage (Jump = 1)
       -- at the same time memory stage using the mem sys
       -- The system should not only stall fetch in this case, but also stall decode stage and execute stage
       -- Otherwise the jumP address will be missed in the next time cycle
       -- In this case, alu should stop working.
       Jmp : IN std_ulogic;
       Clock : IN std_ulogic;
       R : IN std_ulogic;
       Stall : OUT std_ulogic);
END ENTITY RegTracker;

--
ARCHITECTURE Mixed OF RegTracker IS

type registerFile is array(0 to 2**RegSel - 1) of std_logic_vector(width - 1 downto 0);
SIGNAL registers : registerFile;
CONSTANT HiZ : std_ulogic_vector(width - 1 DOWNTO 0) := (others => 'Z');
SIGNAL FlagRs1, FlagRs2, FlagRdDSTemp, FlagRdWBSTemp, FlagRdDS, FlagRdWBS : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL Stall1, Stall2,StallTemp : std_ulogic;
BEGIN




-- This is a regfile which can write two values to two registers in a single time cycle
RegFile : ENTITY work.RegFileforTracker(Mixed)
          GENERIC MAP(RegWidth=>width,RegSel=>RegSel)
          PORT MAP(DataDS=>FlagRdDS,DataWBS=>FlagRdWBS,AddrA=>rs1,AddrB=>rs2,RdDs=>rdDS,RdWBS=>rdWBS,rav=>rs1v,rbv=>rs2v,rdv=>rdv,we=>we,Clock=>Clock,DataA=>FlagRs1,DataB=>FlagRs2,DataRdDS=>FlagRdDSTemp,DataRdWBS=>FlagRdWBSTemp,R=>R);


Stall1 <= '1' WHEN FlagRs1 = "01" OR FlagRs1 = "10" OR FlagRs1 = "11" ELSE '0';
Stall2 <= '1' WHEN FlagRs2 = "01" OR FlagRs2 = "10" OR FlagRs2 = "11" ELSE '0';

StallTemp <= Stall1 OR Stall2 WHEN Jmp = '0' ELSE '0';
Stall <= StallTemp;
ALU : PROCESS(FlagRdDSTemp, FlagRdWBSTemp, StallTemp, we, rdv)
BEGIN
IF (rdDS=rdWBS AND StallTemp='0' AND we='1' AND rdv='1') THEN
FlagRdDS <= FlagRdDSTemp;
FlagRdWBS <= FlagRdWBSTemp;
else
  IF (StallTemp = '0' AND StallforSpecialCase = '0') THEN
    FlagRdDS <= std_ulogic_vector(UNSIGNED(FlagRdDSTemp) + 1);
  ELSE
    FlagRdDS <= FlagRdDSTemp;
  END IF;
    FlagRdWBS <= std_ulogic_vector(UNSIGNED(FlagRdWBSTemp) - 1);
END IF;
END PROCESS;
-- Decode stage should stop adding flag to regtracker if there is a stall
-- FlagRdDS <= std_ulogic_vector(UNSIGNED(FlagRdDSTemp) + 1) WHEN Stall = '0' ELSE std_ulogic_vector(UNSIGNED(FlagRdDSTemp));
-- Write back stage should always write to regtracker without considering stalls
-- FlagRdWBS <= std_logic_vector(UNSIGNED(FlagRdWBSTemp) - 1);

END ARCHITECTURE Mixed;
