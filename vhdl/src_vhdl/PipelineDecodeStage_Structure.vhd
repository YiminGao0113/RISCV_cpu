--
-- VHDL Architecture CAD_lib.PipelineDecodeStage.Structure
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 22:33:02 2021/03/12
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE work.RV32I.ALL;


ENTITY PipelineDecodeStage IS
    GENERIC(width : NATURAL range 1 TO 64 := 32);
  PORT(Inst, DataA, DataB, Address: IN std_ulogic_vector(width - 1 DOWNTO 0);
       Clock : IN std_ulogic;
       Stall, Jmp : IN std_ulogic;
       -- To Register File
       AddrA, AddrB : OUT std_ulogic_vector(4 DOWNTO 0);
       RS1v, RS2v, RDv : OUT std_ulogic;
       -- To Execute Stage
       Func : OUT RV32I_Op;
       AddrDest : OUT std_ulogic_vector(4 DOWNTO 0);
       Left, Right, Extra : OUT std_ulogic_vector(width - 1 DOWNTO 0));

--       RS1v, RS2v, RDv : OUT std_ulogic;
END ENTITY PipelineDecodeStage;

--
ARCHITECTURE Mixed OF PipelineDecodeStage IS
  SIGNAL Inst1, Address1 : std_ulogic_vector(width - 1 DOWNTO 0);
  SIGNAL Func1 : RV32I_Op;
  SIGNAL Immediate : std_ulogic_vector(width - 1 DOWNTO 0);
  SIGNAL RS1vTemp, RS2vTemp, RDvTemp : std_ulogic;
  SIGNAL E : std_ulogic;
  SIGNAL AddrATemp, AddrBTemp, AddrDestTemp :std_ulogic_vector(4 DOWNTO 0);
BEGIN
    E <= NOT Stall;
    InstReg :  ENTITY work.Reg(Behavior)
          GENERIC MAP(size => width)
          PORT MAP(D=>Inst,Q=>Inst1,C=>Clock,E=>E,R=>'0');

    AddrReg :  ENTITY work.Reg(Behavior)
            GENERIC MAP(size => width)
            PORT MAP(D=>Address,Q=>Address1,C=>Clock,E=>E,R=>'0');

    Decoder : ENTITY work.RV32I_Decoder(Behavior)
           PORT MAP(Instruction=>Inst1,Func=>Func1,RS1=>AddrATemp,RS2=>AddrBTemp,RD=>AddrDestTemp,RS1v=>RS1vTemp,RS2v=>RS2vTemp,RDv=>RDvTemp,Immediate=>Immediate);

    Multiplexers : PROCESS(Func1,AddrATemp,AddrBTemp,DataA,DataB,addrDestTemp,RS1vTemp,RS2vTemp,RDvTemp,Immediate,Stall,Jmp)
    VARIABLE Sum : UNSIGNED(width - 1 DOWNTO 0);
    BEGIN
      CASE Func1 IS

      WHEN ADDr | SUBr | SLLr | SLTr | SLTUr | XORr | SRLr | SRAr | ORr | ANDr =>
        Left <= DataB;
        Right <= DataA;
        Extra <= ZEROS_32;

      WHEN ADDI | SLTI | SLTIU | XORI | ORI | ANDI | SLLI | SRLI | SRAI =>
        Left <= Immediate;
        Right <= DataA;
        Extra <= ZEROS_32;

      WHEN LB | LH | LW | LBU | LHU =>
        Left <= Immediate;
        Right <= DataA; -- From Base Register
        Extra <= ZEROS_32;

      WHEN SB | SH | SW =>
        Left <= Immediate;
        Right <= DataA; -- From Base Register
        Extra <= DataB;

      WHEN BEQ | BNE | BLT | BGE | BLTU | BGEU =>
        Left <= DataB;
        Right <= DataA;
        Sum := UNSIGNED(Address1) + UNSIGNED(Immediate);
        Extra <= std_ulogic_vector(Sum);

      WHEN LUI =>
        Left <= ZEROS_32;
        Right <= ZEROS_32;
        Extra <= Immediate;

      WHEN AUIPC =>
        Left <= Immediate;
        Right <= Address1;
        Extra <= ZEROS_32;

      WHEN JAL =>
        Left <= Immediate;
        Right <= Address1;
        Sum := UNSIGNED(Address1) + 4;
        Extra <= std_ulogic_vector(Sum); --Load the return address to rd

      WHEN JALR =>
        Left <= Immediate;
        Right <= DataA;
        Sum := UNSIGNED(Address1) + 4;
        Extra <= std_ulogic_vector(Sum); --Load the return address to rd

      WHEN others =>
        Left <= ZEROS_32;
        Right <= ZEROS_32;
        Extra <= ZEROS_32;
      END CASE;

      IF (Stall = '1' OR Jmp = '1') THEN
        Func <= NOP;
        RDv <= '0';
      else
        Func <= Func1;
        RDv <= RDvTemp;
      END IF;
    END PROCESS;
AddrA <= AddrATemp;
AddrB <= AddrBTemp;
AddrDest <= AddrDestTemp;
RS1v <= RS1vTemp;
RS2v <= RS2vTemp;


END ARCHITECTURE Mixed;
