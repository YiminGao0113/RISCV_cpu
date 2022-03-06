--
-- VHDL Architecture CAD_lib.RegFileforPipeline.Structure
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 18:08:02 2021/04/10
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.RV32I.ALL;


ENTITY RegFileforPipeline IS
  GENERIC(RegWidth : NATURAL RANGE 2 TO 64 := 32;
            RegSel : NATURAL RANGE 2 TO 5 := 5);

  PORT(DataIn : IN std_ulogic_vector(RegWidth - 1 DOWNTO 0);
       rav, rbv, we : IN std_ulogic;
       R : IN std_ulogic;
       -- For RegTracker to reset all flags to 00
       AddrA, AddrB, AddrD : IN std_ulogic_vector(RegSel - 1 DOWNTO 0);
       Clock : IN std_ulogic;
       DataA, DataB : OUT std_ulogic_vector(RegWidth - 1 DOWNTO 0));
       -- For later RegTracker design to read rd flag
       -- DataRd : OUT std_ulogic_vector(RegWidth - 1 DOWNTO 0)
END ENTITY RegFileforPipeline;

--
ARCHITECTURE Mixed OF RegFileforPipeline IS

  SIGNAL ReadDC, ReadDCa, ReadDCb, WriteDC : std_ulogic_vector((2**RegSel) - 1 DOWNTO 0);
  CONSTANT HiZ : std_ulogic_vector(RegWidth - 1 DOWNTO 0) := (others => 'Z');
  CONSTANT Zeros : std_ulogic_vector(RegWidth - 1 DOWNTO 0) := (others => '0');

  type registerFile is array(0 to 2**RegSel - 1) of std_ulogic_vector(RegWidth - 1 downto 0);
  SIGNAL registers : registerFile;
BEGIN
  ReadDecode1 : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => AddrA, OneHot => ReadDCa, enable => rav);

  ReadDecode2 : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => AddrB, OneHot => ReadDCb, enable => rbv);

  WriteDecode : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => AddrD, OneHot => WriteDC, enable => we);

--ReadDC <= ReadDCa OR ReadDCb
  ReadDC <= ReadDCa OR ReadDCb;

  ReadArray : FOR i IN 1 TO ((2**RegSel) - 1) GENERATE
    BEGIN
      RegI : ENTITY work.RegReadWrite(Mixed)
        GENERIC MAP(size => RegWidth)
        PORT MAP(D => DataIn, Q => registers(i), Clk => Clock, LE => WriteDC(i), OE => ReadDC(i), R => R);
    END GENERATE ReadArray;



registers(0) <= Zeros;
DataA <= registers(to_integer(UNSIGNED(AddrA))) WHEN rav = '1' ELSE HiZ;
DataB <= registers(to_integer(UNSIGNED(AddrB))) WHEN rbv = '1' ELSE HiZ;



--DataRd <= registers(to_integer(UNSIGNED(AddrD))) WHEN we = '1' ELSE HiZ;

--  Multiplexers : PROCESS(ReadDCa,ReadDCb,WriteDC,rav,rbv,we)
--  BEGIN
--  IF (ReadDCa((2**RegSel) - 1) = '1') THEN
--    DataA <= Zeros WHEN rav = '1' ELSE HiZ; -- The first register is always zero
--  ELSE
--    DataA <= registers(to_integer(UNSIGNED(AddrA))) WHEN rav = '1' ELSE HiZ;
--  END IF;

--  IF (ReadDCb((2**RegSel) - 1) = '1') THEN
--    DataB <= Zeros WHEN rbv = '1' ELSE HiZ;
 -- ELSE
--    DataB <= registers(to_integer(UNSIGNED(AddrB))) WHEN rbv = '1' ELSE HiZ;
--  END IF;

--  IF (WriteDC((2**RegSel) - 1) = '1') THEN
--    DataRd <= Zeros WHEN we = '1' ELSE HiZ;
--  ELSE
--    DataRd <= registers(to_integer(UNSIGNED(AddrD))) WHEN we = '1' ELSE HiZ;
--  END IF;
--END PROCESS;
END ARCHITECTURE Mixed;
