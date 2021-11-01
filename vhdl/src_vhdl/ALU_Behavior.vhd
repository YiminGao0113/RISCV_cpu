--
-- VHDL Architecture CAD_lib.ALU.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 23:35:07 2021/03/31
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;

USE ieee.numeric_std.all;

USE work.RV32I.ALL;


ENTITY ALU IS
  GENERIC(width : NATURAL range 1 TO 64 := 32);
  PORT(Left, Right : IN std_ulogic_vector(width - 1 DOWNTO 0);
       Func : IN RV32I_Op;
       Result : OUT std_ulogic_vector(width - 1 DOWNTO 0);
--       Overflow : OUT std_ulogic;
       Sel : OUT std_ulogic);
END ENTITY ALU;

--
ARCHITECTURE Behavior OF ALU IS
SIGNAL Result_temp : std_ulogic_vector(width - 1 DOWNTO 0);
BEGIN



    ALU : PROCESS(Func,Left,Right)
    VARIABLE Overflow : std_ulogic;
    VARIABLE Sign1 : std_ulogic; --Sign of Right
    VARIABLE Sign2 : std_ulogic; -- Sign of Left
    BEGIN
    Sign1 := Right(width - 1);
    Sign2 := Left(width - 1);
      CASE Func IS

        WHEN ADDr | ADDI | LB | LH | LW | LBU | LHU | SB | SH | SW | JAL | JALr | AUIPC =>
          Result_temp <= std_ulogic_vector(SIGNED(Right) + SIGNED(Left));
          Sel <= '0';
          if(Sign1 = Sign2 and Sign1 /= Result_temp(width - 1)) THEN
          -- Overflow Case:
          -- 1. Right(+)+Left(+) => Result(-)
          -- 2. Right(-)+Left(-) => Result(+)
          Overflow := '1';
          else
          Overflow := '0';
          END IF;
        WHEN SUBr =>
          Result_temp <= std_ulogic_vector(SIGNED(Right) - SIGNED(Left));
          Sel <= '0';
          if(Sign1 /= Sign2 and Sign2 = Result_temp(width - 1)) THEN
          -- Overflow Case:
          -- 1. Right(+)-Left(-) => Result(-)
          -- 2. Right(-)-Left(+) => Result(+)
          Overflow := '1';
          else
          Overflow := '0';
          END IF;
        WHEN SLLr | SLLI =>
          Result_temp <= std_ulogic_vector(shift_left(UNSIGNED(Right),to_integer(UNSIGNED(Left))));
          Sel <= '0';
        WHEN SLTr | SLTI =>
          Result_temp <= ZEROS_32;
          IF (SIGNED(Right) < SIGNED(Left)) THEN
            Sel <= '1';
          ELSE
            Sel <= '0';
          END IF;
        WHEN SLTUr | SLTIU =>
          Result_temp <= ZEROS_32;
          IF (UNSIGNED(Right) < UNSIGNED(Left)) THEN
            Sel <= '1';
          ELSE
            Sel <= '0';
          END IF;
        WHEN XORr | XORI =>
          Result_temp <= Right XOR Left;
          Sel <= '0';
        WHEN SRLr | SRLI =>
          Result_temp <= std_ulogic_vector(shift_right(UNSIGNED(Right),to_integer(UNSIGNED(Left))));
          Sel <= '0';
        WHEN SRAr | SRAI =>
          Result_temp <= std_ulogic_vector(shift_right(SIGNED(Right),to_integer(UNSIGNED(Left))));
          Sel <= '0';
        WHEN ORr | ORI =>
          Result_temp <= Right OR Left;
          Sel <= '0';
        WHEN ANDr |ANDI =>
          Result_temp <= Right AND Left;
          Sel <= '0';
        WHEN BEQ =>
          Result_temp <= ZEROS_32;
          IF (UNSIGNED(Right) = UNSIGNED(Left)) THEN
            Sel <= '1';
          ELSE
            Sel <= '0';
          END IF;
        WHEN BNE =>
          Result_temp <= ZEROS_32;
          IF NOT(UNSIGNED(Right) = UNSIGNED(Left)) THEN
            Sel <= '1';
          ELSE
            Sel <= '0';
          END IF;
        WHEN BLT =>
          Result_temp <= ZEROS_32;
          IF (SIGNED(Right) < SIGNED(Left)) THEN
            Sel <= '1';
          ELSE
            Sel <= '0';
          END IF;
        WHEN BGE =>
          Result_temp <= ZEROS_32;
          IF (SIGNED(Right) > SIGNED(Left)) THEN
            Sel <= '1';
          ELSE
            Sel <= '0';
          END IF;
        WHEN BLTU =>
          Result_temp <= ZEROS_32;
          IF (UNSIGNED(Right) < UNSIGNED(Left)) THEN
            Sel <= '1';
          ELSE
            Sel <= '0';
          END IF;
        WHEN BGEU =>
          Result_temp <= ZEROS_32;
          IF (UNSIGNED(Right) >= UNSIGNED(Left)) THEN
            Sel <= '1';
          ELSE
            Sel <= '0';
          END IF;
      WHEN OTHERS =>
          Result_temp <= ZEROS_32;
          Sel <= '0';
      END CASE;
    END PROCESS;
    
    Result <= Result_temp;
END ARCHITECTURE Behavior;
