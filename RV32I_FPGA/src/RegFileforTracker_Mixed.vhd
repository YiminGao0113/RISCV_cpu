--
-- VHDL Architecture CAD_lib.RegFileforTracker.Mixed
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 18:10:03 2021/04/12
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.RV32I.ALL;


ENTITY RegFileforTracker IS


  GENERIC(RegWidth : NATURAL RANGE 2 TO 64 := 2;
            RegSel : NATURAL RANGE 2 TO 5 := 5);

  PORT(DataDS, DataWBS : IN std_ulogic_vector(RegWidth - 1 DOWNTO 0);
       rav, rbv, rdv, we : IN std_ulogic;
       --rdv from decode stage, we from write back stage
       R : IN std_ulogic;
       -- For RegTracker to reset all flags to 00
       AddrA, AddrB, RdDS, RdWBS : IN std_ulogic_vector(RegSel - 1 DOWNTO 0);
       Clock : IN std_ulogic;
       DataA, DataB : OUT std_ulogic_vector(RegWidth - 1 DOWNTO 0);
       DataRdDS, DataRdWBS : OUT std_ulogic_vector(RegWidth - 1 DOWNTO 0) );
       -- For later RegTracker design to read rd flag

END ENTITY RegFileforTracker;

--
ARCHITECTURE Mixed OF RegFileforTracker IS
  SIGNAL ReadDC, ReadDCa, ReadDCb, WriteDCa, WriteDCb, WriteDC : std_ulogic_vector((2**RegSel) - 1 DOWNTO 0);

  CONSTANT HiZ : std_ulogic_vector(RegWidth - 1 DOWNTO 0) := (others => 'Z');
  CONSTANT Zeros : std_ulogic_vector(RegWidth - 1 DOWNTO 0) := (others => '0');

  type registerFile is array(0 to 2**RegSel - 1) of std_ulogic_vector(RegWidth - 1 downto 0);
  SIGNAL registers : registerFile;

  type DataInArray is array(0 to 2**RegSel - 1) of std_ulogic_vector(RegWidth - 1 downto 0);
  SIGNAL DataIn1, DataIn2, DataIn : DataInArray;

BEGIN
  ReadDecode1 : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => AddrA, OneHot => ReadDCa, enable => rav);

  ReadDecode2 : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => AddrB, OneHot => ReadDCb, enable => rbv);

  WriteDecodeRdFromDS : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => RdDS, OneHot => WriteDCa, enable => rdv);

  WriteDecodeRdFromWBS : ENTITY work.Decoder(Behavior)
    GENERIC MAP(InBits => RegSel)
    PORT MAP(sel => RdWBS, OneHot => WriteDCb, enable => we);


ReadDC <= ReadDCa OR ReadDCb OR WriteDCa OR WriteDCb;
WriteDC <= WriteDCa OR WriteDCb;


  ReadArray : FOR i IN 1 TO ((2**RegSel) - 1) GENERATE
    BEGIN
      RegI : ENTITY work.RegReadWrite(Mixed)
        GENERIC MAP(size => RegWidth)
        PORT MAP(D => DataIn(i), Q => registers(i), Clk => Clock, LE => WriteDC(i), OE => ReadDC(i), R => R); --ReadDC(i)

        DataIn(i) <= DataIn2(i) WHEN RdDS = RdWBS AND rdv = '1' AND we = '1' ELSE  DataIn1(i) OR DataIn2(i);
    END GENERATE ReadArray;


  WriteEachArray : PROCESS(DataDS,DataWBS,RdDS,RdWBS,rdv,we)
  BEGIN
  FOR i IN 0 TO ((2**RegSel) - 1) LOOP


    IF (rdv='1' AND i = CONV_INTEGER(std_logic_vector(RdDS))) THEN
      DataIn1(i) <= DataDS;
    else
      DataIn1(i) <= "00";
    END IF;

    IF (we='1' AND i = CONV_INTEGER(std_logic_vector(RdWBS))) THEN
      DataIn2(i) <= DataWBS;
    else
      DataIn2(i) <= "00";
    END IF;

  END LOOP;
  END PROCESS;



registers(0) <= Zeros;
DataA <= registers(CONV_INTEGER(std_logic_vector(AddrA))) WHEN rav = '1' ELSE HiZ;
DataB <= registers(CONV_INTEGER(std_logic_vector(AddrB))) WHEN rbv = '1' ELSE HiZ;
DataRdDS <= registers(CONV_INTEGER(std_logic_vector(RdDS))) WHEN rdv = '1' ELSE HiZ;
DataRdWBS <= registers(CONV_INTEGER(std_logic_vector(RdWBS))) WHEN we = '1' ELSE HiZ;


END ARCHITECTURE Mixed;
