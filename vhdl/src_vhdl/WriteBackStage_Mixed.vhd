--
-- VHDL Architecture CAD_lib.WriteBackStage.Mixed
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 20:13:53 2021/04/ 3
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE work.RV32I.ALL;


ENTITY WriteBackStage IS
  GENERIC(width : NATURAL range 1 TO 64 := 32);
  PORT(DataIn : IN std_ulogic_vector(width - 1 DOWNTO 0);
       rd : IN std_ulogic_vector(4 DOWNTO 0);
       Func : IN RV32I_Op;
       C : IN std_ulogic;
       we : OUT std_ulogic;
       rd1 : OUT std_ulogic_vector(4 DOWNTO 0);
       DataOut : OUT std_ulogic_vector(width - 1 DOWNTO 0));
--       Func1 : OUT RV32I_Op
END ENTITY WriteBackStage;

--
ARCHITECTURE Mixed OF WriteBackStage IS
SIGNAL DataOutTemp : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL Rd1Temp : std_ulogic_vector(4 DOWNTO 0);
SIGNAL Func1 : RV32I_Op;
BEGIN
RegData : ENTITY work.Reg(Behavior)
          GENERIC MAP(size => width)
          PORT MAP(D => DataIn, Q => DataOutTemp, C => C, E => '1', R => '0');
RegRd :   ENTITY work.Reg(Behavior)
          GENERIC MAP(size => 5)
          PORT MAP(D => Rd, Q => Rd1Temp, C => C, E => '1', R => '0');
RegFunc : ENTITY work.FuncReg(Behavior)
          PORT MAP(D => Func, Q => Func1, C => C, E => '1');
writeenable : PROCESS(DataOutTemp, Rd1Temp, Func1)
BEGIN
CASE Func1 IS
  WHEN LUI | AUIPC | JAL | JALR | LB | LH | LW | LBU | LHU | ADDI | SLTI | SLTIU | XORI | ORI | ANDI | SLLI |SRLI | SRAI | ADDr | SUBr | SLLr | SLTr | SLTUr | XORr | SRLr | SRAr | ORr | ANDr =>
    we <= '1';
  WHEN OTHERS =>
    we <= '0';
END CASE;
END PROCESS;

DataOut <= DataOutTemp;
Rd1 <= Rd1Temp;

END ARCHITECTURE Mixed;
