--
-- VHDL Architecture CAD_lib.FuncReg.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 20:03:50 2021/03/26
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

USE work.RV32I.ALL;


ENTITY FuncReg IS
  PORT(D : IN RV32I_Op;
       Q : OUT RV32I_Op;
       C,E : IN std_ulogic);
END ENTITY FuncReg;

--
ARCHITECTURE Behavior OF FuncReg IS
BEGIN
  PROCESS(C)
    BEGIN
      IF (rising_edge(C) and E = '1') THEN
        IF (E = '1') THEN
        Q <= D;
        ELSE
        Q <= NOP;
        END IF;
      END IF;
  END PROCESS;



END ARCHITECTURE Behavior;
