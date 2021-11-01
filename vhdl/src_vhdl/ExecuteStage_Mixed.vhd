--
-- VHDL Architecture CAD_lib.ExecuteStage.Mixed
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 19:34:28 2021/03/26
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

USE ieee.numeric_std.all;


USE work.RV32I.ALL;


ENTITY ExecuteStage IS
  GENERIC(width : NATURAL range 1 to 64 := 32);
  PORT(Left, Right, Extra : IN std_ulogic_vector(width - 1 DOWNTO 0);
       AddrDest : IN std_ulogic_vector(4 DOWNTO 0);
       Func : IN RV32I_Op;
       Stall : IN std_ulogic;
       Address, Jaddr, Data : OUT std_ulogic_vector(width - 1 DOWNTO 0);
       AddrDest1 : OUT std_ulogic_vector(4 DOWNTO 0);
       Func1 : OUT RV32I_Op;
       Jump : OUT std_ulogic;
       Clock : IN std_ulogic);
END ENTITY ExecuteStage;

--
ARCHITECTURE Mixed OF ExecuteStage IS
SIGNAL Left1, Right1, Extra1, Result : std_ulogic_vector(width - 1 DOWNTO 0);
SIGNAL Sel : std_ulogic;
SIGNAL FuncTemp : RV32I_Op;
SIGNAL Enable : std_ulogic;
SIGNAL AddrDest1_temp : std_ulogic_vector(4 DOWNTO 0);
BEGIN
    
    Enable <= NOT Stall;
    
    RegLeft : ENTITY work.Reg(Behavior)
              GENERIC MAP(size => width)
              PORT MAP(D => Left, Q => Left1, C => Clock, E => Enable, R => '0');

    RegRight: ENTITY work.Reg(Behavior)
              GENERIC MAP(size => width)
              PORT MAP(D => Right, Q => Right1, C => Clock, E => Enable, R => '0');

    RegExtra: ENTITY work.Reg(Behavior)
              GENERIC MAP(size => width)
              PORT MAP(D => Extra, Q => Extra1, C => Clock, E => Enable, R => '0');

    RegRd :   ENTITY work.Reg(Behavior)
              GENERIC MAP(size => 5)
              PORT MAP(D => AddrDest, Q => AddrDest1_temp, C => Clock, E => Enable, R => '0');

    RegFunc : ENTITY work.FuncReg(Behavior)
              PORT MAP(D => Func, Q => FuncTemp, C => Clock, E => Enable);

    ALU     : ENTITY work.ALU(Behavior)
              GENERIC MAP(width => 32)
              PORT MAP(Right => Right1, Left => Left1, Func => FuncTemp, Result => Result, Sel => Sel);

    Multiplexers : PROCESS(FuncTemp,Result,Sel,Extra1,AddrDest1_temp,Stall)
    BEGIN
      CASE FuncTemp IS
        WHEN ADDr | ADDI =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN SUBr =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN SLLr | SLLI =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN SLTr | SLTI =>
          Address <= ZEROS_32;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        IF (sel = '1') THEN
          Data <= "00000000000000000000000000000001";
        ELSE
          Data <= ZEROS_32;
        END IF;
        WHEN SLTUr | SLTIU =>
          Address <= ZEROS_32;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        IF (sel = '1') THEN
          Data <= "00000000000000000000000000000001";
        ELSE
          Data <= ZEROS_32;
        END IF;
        WHEN XORr | XORI =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN SRLr | SRLI =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN SRAr | SRAI =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN ORr | ORI =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN ANDr |ANDI =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN LB | LH | LW | LBU | LHU =>
          Address <= Result;
          Data <= ZEROS_32;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN SB | SH | SW =>
          Address <= Result;
          Data <= Extra1;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN BEQ =>
          Address <= ZEROS_32;
          Data <= ZEROS_32;
          IF (sel = '1') THEN
            Jaddr <= Extra1;
            Jump <= '1';
          ELSE
            Jaddr <= ZEROS_32;
            Jump <= '0';
          END IF;
        WHEN BNE =>
          Address <= ZEROS_32;
          Data <= ZEROS_32;
          IF (sel = '1') THEN
            Jaddr <= Extra1;
            Jump <= '1';
          ELSE
            Jaddr <= ZEROS_32;
            Jump <= '0';
          END IF;
        WHEN BLT =>
          Address <= ZEROS_32;
          Data <= ZEROS_32;
          IF (sel = '1') THEN
            Jaddr <= Extra1;
            Jump <= '1';
          ELSE
            Jaddr <= ZEROS_32;
            Jump <= '0';
          END IF;
        WHEN BGE =>
          Address <= ZEROS_32;
          Data <= ZEROS_32;
          IF (sel = '1') THEN
            Jaddr <= Extra1;
            Jump <= '1';
          ELSE
            Jaddr <= ZEROS_32;
            Jump <= '0';
          END IF;
        WHEN BLTU =>
          Address <= ZEROS_32;
          Data <= ZEROS_32;
          IF (sel = '1') THEN
            Jaddr <= Extra1;
            Jump <= '1';
          ELSE
            Jaddr <= ZEROS_32;
            Jump <= '0';
          END IF;
        WHEN BGEU =>
          Address <= ZEROS_32;
          Data <= ZEROS_32;
          IF (sel = '1') THEN
            Jaddr <= Extra1;
            Jump <= '1';
          ELSE
            Jaddr <= ZEROS_32;
            Jump <= '0';
          END IF;
        WHEN LUI =>
          Address <= ZEROS_32;
          Data <= Extra;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN AUIPC =>
          Address <= ZEROS_32;
          Data <= Result;
          Jaddr <= ZEROS_32;
          Jump <= '0';
        WHEN JAL | JALr =>
          Address <= ZEROS_32;
          Data <= Extra1;
          Jaddr <= Result;
          Jump <= '1';
      WHEN OTHERS =>
          Address <= ZEROS_32;
          Data <= ZEROS_32;
          Jaddr <= ZEROS_32;
          Jump <= '0';
      END CASE;

      IF(Stall = '1') THEN
        Func1 <= NOP;
      ELSE
        Func1 <= FuncTemp;
      END IF;

    END PROCESS;
    
    AddrDest1 <= AddrDest1_temp;
END ARCHITECTURE Mixed;
