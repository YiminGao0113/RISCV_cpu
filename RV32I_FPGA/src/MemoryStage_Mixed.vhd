--
-- VHDL Architecture CAD_lib.MemoryStage.Mixed
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 17:10:16 2021/04/ 3
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE work.RV32I.ALL;


ENTITY MemoryStage IS
  GENERIC(width : NATURAL range 1 TO 64 := 32);
  PORT(-- From Execute Stage
       Addr, Data : IN std_ulogic_vector(width - 1 DOWNTO 0);
       Rd : IN std_ulogic_vector(4 DOWNTO 0);
       Func : RV32I_Op;
       -- From Memory System
       DataIn : IN std_ulogic_vector(width - 1 DOWNTO 0);
       Mdelay : IN std_ulogic;
       -- To Memory System
       AddrOut, DataOut : OUT std_ulogic_vector(width - 1 DOWNTO 0);
       w, r : OUT std_ulogic;
       sel : OUT std_ulogic_vector(1 DOWNTO 0);
       -- To Write Back MemoryStage
       Data1 : OUT std_ulogic_vector(width - 1 DOWNTO 0);
       Rd1 : OUT std_ulogic_vector(4 DOWNTO 0);
       Func1 : OUT RV32I_Op;
       -- To previous stages
       Stall : OUT std_ulogic;
       -- Clock
       C : IN std_ulogic);

END ENTITY MemoryStage;

--
ARCHITECTURE Mixed OF MemoryStage IS
SIGNAL DataTemp : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL FuncTemp : RV32I_Op;
SIGNAL StallTemp,e : std_ulogic;
SIGNAL AddrOutTemp, DataOutTemp : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL Rd1Temp : std_ulogic_vector(4 DOWNTO 0);
BEGIN
  E <= NOT StallTemp;
    
  RegAddr : ENTITY work.Reg(Behavior)
            GENERIC MAP(size => width)
            PORT MAP(D => Addr, Q => AddrOutTemp, C => C, E => E, R => '0');

  RegData: ENTITY work.Reg(Behavior)
            GENERIC MAP(size => width)
            PORT MAP(D => Data, Q => DataOutTemp, C => C, E => E, R => '0');

  RegRd :   ENTITY work.Reg(Behavior)
            GENERIC MAP(size => 5)
            PORT MAP(D => Rd, Q => Rd1Temp, C => C, E => E, R => '0');

  RegFunc : ENTITY work.FuncReg(Behavior)
            PORT MAP(D => Func, Q => FuncTemp, C => C, E => E);

  Multiplexers : PROCESS(AddrOutTemp,DataIn,DataOutTemp,Rd1Temp,FuncTemp,Mdelay)
  BEGIN
    CASE FuncTemp IS
      WHEN LB | LBU =>
        w <= '0';
        r <= '1';
        sel <= "00";
        Data1 <= DataIn; --From Memory System
      WHEN LH | LHU =>
        w <= '0';
        r <= '1';
        sel <= "01";
        Data1 <= DataIn; --From Memory System
      WHEN LW =>
        w <= '0';
        r <= '1';
        sel <= "10";
        Data1 <= DataIn; --From Memory System
      WHEN SB =>
        w <= '1';
        r <= '0';
        sel <= "00";
        Data1 <= DataOutTemp; --From Execute stage, output of regdata
      WHEN SH =>
        w <= '1';
        r <= '0';
        sel <= "01";
        Data1 <= DataOutTemp; --From Execute stage, output of regdata
      WHEN SW =>
        w <= '1';
        r <= '0';
        sel <= "10";
        Data1 <= DataOutTemp; --From Execute stage, output of regdata
      WHEN OTHERS =>
        w <= '0';
        r <= '0';
        sel <= "11";
        Data1 <= DataOutTemp; --From Execute stage, output of regdata
    END CASE;


    IF(Mdelay = '0') THEN
      Func1 <= FuncTemp;
      StallTemp <= '0';
    else
      Func1 <= NOP;
      StallTemp <= '1';
    END IF;


  END PROCESS;

Stall <= StallTemp;
AddrOut <= AddrOutTemp;
DataOut <= DataOutTemp;
Rd1 <= Rd1Temp;

 -- GenerateStall : PROCESS(Mdelay)
 -- BEGIN
 -- CASE Func1 IS
  --  WHEN LB | LH | LW | LBU | LHU | SB | SH | SW => -- If mdelay is caused by memory stage
 --     enable <= not Mdelay;
  --    Stall <= Mdelay;
  --  WHEN OTHERS => -- If mdelay is caused by fetch stage
  --    enable <= '1';
  --    Stall <= '0';
 -- END CASE;

 -- END PROCESS;


END ARCHITECTURE Mixed;
