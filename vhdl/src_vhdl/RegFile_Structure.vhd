--
-- VHDL Architecture CAD_lib.RegFile.Structure
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 22:19:56 2021/02/15
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY RegFile IS
  GENERIC(RegWidth : NATURAL RANGE 2 TO 64 := 32;
          RegSel : NATURAL RANGE 2 TO 5 := 5);

  PORT(D : IN std_ulogic_vector(RegWidth - 1 DOWNTO 0);
       Q : OUT std_ulogic_vector(RegWidth - 1 DOWNTO 0);
       ReadSel, WriteSel : IN std_ulogic_vector(RegSel - 1 DOWNTO 0);
       Clock, Load : IN std_ulogic);
END ENTITY RegFile;

--
ARCHITECTURE Structure OF RegFile IS
  SIGNAL ReadDC, WriteDC : std_ulogic_vector((2**RegSel) - 1 DOWNTO 0);
  SIGNAL RegOut: std_ulogic_vector(RegWidth - 1 DOWNTO 0);
BEGIN
  ReadDecode : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => ReadSel, OneHot => ReadDC, enable => '1');


  WriteDecode : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => WriteSel, OneHot => WriteDC, enable => Load);


  ReadArray : FOR i IN 0 TO ((2**RegSel) - 1) GENERATE
    BEGIN
      RegI : ENTITY work.RegReadWrite(Mixed)
        GENERIC MAP(size => RegWidth)
        PORT MAP(D => D, Q => RegOut, Clk => Clock, LE => WriteDC(i), OE => ReadDC(i), R =>'0');
    END GENERATE ReadArray;
  Q <= RegOut;

END ARCHITECTURE Structure;
