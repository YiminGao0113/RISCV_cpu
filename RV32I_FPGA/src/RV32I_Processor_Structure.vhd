--
-- VHDL Architecture CAD_lib.RV32I_Processor.Structure
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 16:46:26 2021/04/14
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


USE work.RV32I.ALL;


ENTITY RV32I_Processor IS
  GENERIC(width : NATURAL range 1 TO 64 := 32;
          RegSel : NATURAL range 1 TO 5 := 5);
  PORT(Clock,Reset: IN std_ulogic;
       --From Memory System
       Mdelay : IN std_ulogic;
       DatafromMemSys : IN std_ulogic_vector(width - 1 DOWNTO 0);
       --To Memory System
       DataFromMSToMemSys : OUT std_ulogic_vector(width - 1 DOWNTO 0);
       AddrToMemSys : OUT std_ulogic_vector(width - 1 DOWNTO 0);
       weToMemSys, reToMemSys : OUT std_ulogic;
       selToMemSys : OUT std_ulogic_vector(1 DOWNTO 0)
       );
END ENTITY RV32I_Processor;

--
ARCHITECTURE Structure OF RV32I_Processor IS

SIGNAL Jmp, StallFromMS, StallFromRegTracker : std_ulogic; --Hazards control signals


SIGNAL StallforSpecialCase : std_ulogic;
-- For the special case jump or taken branch in execute stage (Jump = 1)
-- at the same time memory stage using the mem sys
-- The system should not only stall fetch in this case, but also stall decode stage and execute stage
-- Otherwise the jump address will be missed in the next time cycle



-- Fetch stage output
SIGNAL Address, Inst: std_ulogic_vector(width - 1 DOWNTO 0);
--Fetch Stage delay
SIGNAL MFDelay : std_ulogic;


-- Decode stage output
SIGNAL Left, Right, Extra : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL rs1, rs2, rdFromDS : std_ulogic_vector(RegSel - 1 DOWNTO 0);
SIGNAL rs1v, rs2v, rdv : std_ulogic;
SIGNAL FuncFromDS : RV32I_Op;


-- Execute stage output
SIGNAL AddrFromES, Jaddr, DataFromES : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL rdFromES : std_ulogic_vector(RegSel - 1 DOWNTO 0);
SIGNAL FuncFromES : RV32I_Op;


-- Memory stage signals
-- Input ports
-- SIGNAL DatafromMemSys : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL MSdelay : std_ulogic;
-- Output ports
-- SIGNAL DataFromMSToMemSys : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL AddrFromMS : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL w, r : std_ulogic;
SIGNAL selFromMS : std_ulogic_vector(1 DOWNTO 0);
SIGNAL DatafromMSToWBS : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL rdFromMS : std_ulogic_vector(RegSel - 1 DOWNTO 0);
SIGNAL FuncFromMS : RV32I_Op;


-- Write back stage output
SIGNAL we : std_ulogic;
SIGNAL rdFromWBS : std_ulogic_vector(RegSel - 1 DOWNTO 0);
SIGNAL DataFromWBS : std_ulogic_vector(width - 1 DOWNTO 0);

--RegFile
SIGNAL DataA, DataB : std_ulogic_vector(width - 1 DOWNTO 0);

--RegTracker
-- SIGNAL AddrToMemSys : std_ulogic_vector(width - 1 DOWNTO 0);
-- SIGNAL weToMemSys, reToMemSys : std_ulogic;
-- SIGNAL selToMemSys : std_ulogic_vector(1 DOWNTO 0);

--Memory system
--SIGNAL Mdelay : std_ulogic;
--SIGNAL DatafromMemSys : std_ulogic_vector(width - 1 DOWNTO 0);

SIGNAL DelayTemp, StallTemp1, StallTemp2 : std_ulogic;

BEGIN
DelayTemp <= MFDelay OR StallFromRegTracker;
StallTemp1 <= StallFromMS OR StallFromRegTracker OR StallforSpecialCase;
StallTemp2 <= StallFromMS OR StallforSpecialCase;

FetchStage :  ENTITY work.Fetch(Structure)
              GENERIC MAP(width => width)
              PORT MAP(Jaddr=>Jaddr,Mdata=>DatafromMemSys,Address=>Address,Inst=>Inst,CLock=>Clock,Jmp=>Jmp,Reset=>Reset,Delay=>DelayTemp);


DecodeStage:  ENTITY work.PipelineDecodeStage(Mixed)
              GENERIC MAP(width => width)
              PORT MAP(Inst=>Inst,DataA=>DataA,DataB=>DataB,Address=>Address,Clock=>Clock,Stall=>StallTemp1,Jmp=>Jmp,AddrA=>rs1,AddrB=>rs2,AddrDest=>rdFromDS,RS1v=>rs1v,RS2v=>rs2v,RDv=>rdv,Func=>FuncFromDS,Left=>Left,Right=>Right,Extra=>Extra);

ExecuteStage: ENTITY work.ExecuteStage(Mixed)
              GENERIC MAP(width => width)
              PORT MAP(Left=>Left,Right=>Right,Extra=>Extra,AddrDest=>rdFromDS,Func=>FuncFromDS,Stall=>StallTemp2,Address=>AddrFromES,Jaddr=>Jaddr,Data=>DataFromES,AddrDest1=>rdFromES,Func1=>FuncFromES,Jump=>Jmp,Clock=>Clock);

MemoryStage : ENTITY work.MemoryStage(Mixed)
              GENERIC MAP(width => width)
              PORT MAP(Addr=>AddrFromES,Data=>DataFromES,Rd=>rdFromES,Func=>FuncFromES,DataIn=>DatafromMemSys,Mdelay=>MSdelay,AddrOut=>AddrFromMS,DataOut=>DataFromMSToMemSys,w=>w,r=>r,sel=>selFromMS,Data1=>DatafromMSToWBS,Rd1=>rdFromMS,Func1=>FuncFromMS,Stall=>StallFromMS,c=>CLock);

WriteBackStage: ENTITY work.WriteBackStage(Mixed)
              GENERIC MAP(width => width)
              PORT MAP(DataIn=>DatafromMSToWBS,rd=>rdFromMS,Func=>FuncFromMS,C=>Clock,we=>we,rd1=>rdFromWBS,DataOut=>DataFromWBS);

Regfile :     ENTITY work.RegFileforPipeline(Mixed)
              GENERIC MAP(RegWidth => width, RegSel => RegSel)
              PORT MAP(DataIn=>DataFromWBS,rav=>rs1v,rbv=>rs2v,we=>we,R=>'0',AddrA=>rs1,AddrB=>rs2,AddrD=>rdFromWBS,Clock=>CLock,DataA=>DataA,DataB=>DataB);

RegTracker :  ENTITY work.RegTracker(Mixed)
              GENERIC MAP(width => 2, RegSel => RegSel)
              PORT MAP(rs1=>rs1,rs2=>rs2,rdDS=>rdFromDS,rdWBS=>rdFromWBS,rs1v=>rs1v,rs2v=>rs2v,rdv=>rdv,we=>we,Jmp=>Jmp,Clock=>Clock,R=>Reset,StallforSpecialCase=>StallforSpecialCase,Stall=>StallFromRegTracker);

Arbiter :     ENTITY work.Arbiter(Behavior)
              GENERIC MAP(width => width)
              PORT MAP(AddrFromMem=>AddrFromMS,AddrFromFetch=>Address,w=>w,r=>r,sel=>selFromMS,Mdelay=>Mdelay,AddrIn=>AddrToMemSys,we=>weToMemSys,re=>reToMemSys,selIn=>selToMemSys,Jmp=>Jmp,StallforSpecialCase=>StallforSpecialCase,MSDelay=>MSDelay,MFDelay=>MFDelay);




END ARCHITECTURE Structure;
