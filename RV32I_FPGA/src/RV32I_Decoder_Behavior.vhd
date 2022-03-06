--
-- VHDL Architecture CAD_lib.RV32I_Decoder.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 21:41:34 2021/03/ 5
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--

USE work.RV32I.ALL;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


ENTITY RV32I_Decoder IS
   PORT (Instruction : IN std_ulogic_vector(31 DOWNTO 0);
         Func : OUT RV32I_Op;
         RS1, RS2, RD : OUT std_ulogic_vector(4 DOWNTO 0);
         RS1v, RS2v, RDv : OUT std_ulogic;
         Immediate : OUT std_ulogic_vector(31 DOWNTO 0));
END RV32I_Decoder;



ARCHITECTURE Behavior OF RV32I_Decoder IS
BEGIN
  
  Decode : PROCESS(Instruction)
    VARIABLE OpCode : std_ulogic_vector(4 DOWNTO 0);
--    VARIABLE itype : InsType;
    VARIABLE LowDigits : std_ulogic_vector(1 DOWNTO 0);
    VARIABLE Inst31_Fill : std_ulogic_vector(31 DOWNTO 0);
  BEGIN
    
    RS2 <= Instruction(24 DOWNTO 20);
    RS1 <= Instruction(19 DOWNTO 15);
    RD <= Instruction(11 DOWNTO 7);
    LowDigits := Instruction(1 DOWNTO 0);
    OpCode := Instruction(6 DOWNTO 2);
    Inst31_Fill := (others => Instruction(31));
    
    IF (LowDigits = "11") THEN
    CASE OpCode IS
      
      WHEN RV32I_OP_LUI => -- Load Upper Immediate
--        itype := U;
        Func <= LUI;
        RS1v <= '0';
        RS2v <= '0';
        RDv <= '1';
        Immediate(31 DOWNTO 12) <= Instruction(31 DOWNTO 12);
            
        Immediate(11 DOWNTO 0) <= ZEROS_32(11 DOWNTO 0);
      WHEN RV32I_OP_AUIPC => -- Add Upper Immediate to PC
--        itype := U;
        Func <= AUIPC;
        RS1v <= '0';
        RS2v <= '0';
        RDv <= '1';
        Immediate(31 DOWNTO 12) <= Instruction(31 DOWNTO 12);
            
        Immediate(11 DOWNTO 0) <= ZEROS_32(11 DOWNTO 0);
        
      WHEN RV32I_OP_JAL => -- Jump and Link
--        itype := UJ;
        Func <= JAL;
        RS1v <= '0';
        RS2v <= '0';
        RDv <= '1';
        Immediate(20 DOWNTO 20) <= Instruction(31 DOWNTO 31);
        Immediate(10 DOWNTO 1) <= Instruction(30 DOWNTO 21);
        Immediate(11 DOWNTO 11) <= Instruction(20 DOWNTO 20);
        Immediate(19 DOWNTO 12) <= Instruction(19 DOWNTO 12);
        
        Immediate(31 DOWNTO 21) <= Inst31_Fill(31 DOWNTO 21);
        Immediate(0) <= ZEROS_32(0);
      WHEN RV32I_OP_JALR => -- Jump and Link Register
--        itype := I;
        Func <= JALR;
        RS1v <= '1';
        RS2v <= '0';
        RDv <= '1';
        Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
        Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
      WHEN RV32I_OP_BRANCH => 
--        itype := SB;
         CASE Instruction(14 DOWNTO 12) IS
           WHEN RV32I_FN3_BRANCH_EQ => -- Branch if Equal
            Func <= BEQ;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(12 DOWNTO 12) <= Instruction(31 DOWNTO 31);
            Immediate(10 DOWNTO 5) <= Instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 1) <= Instruction(11 DOWNTO 8);
            Immediate(11 DOWNTO 11) <= Instruction(7 DOWNTO 7);
            
            Immediate(31 DOWNTO 13) <= Inst31_Fill(31 DOWNTO 13);
            Immediate(0 DOWNTO 0) <= ZEROS_32(0 DOWNTO 0);
           WHEN RV32I_FN3_BRANCH_NE => -- Branch if Not Equal
            Func <= BNE;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(12 DOWNTO 12) <= Instruction(31 DOWNTO 31);
            Immediate(10 DOWNTO 5) <= Instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 1) <= Instruction(11 DOWNTO 8);
            Immediate(11 DOWNTO 11) <= Instruction(7 DOWNTO 7);
            
            Immediate(31 DOWNTO 13) <= Inst31_Fill(31 DOWNTO 13);
            Immediate(0 DOWNTO 0) <= ZEROS_32(0 DOWNTO 0);
           WHEN RV32I_FN3_BRANCH_LT => -- Branch if Less Than
            Func <= BLT;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(12 DOWNTO 12) <= Instruction(31 DOWNTO 31);
            Immediate(10 DOWNTO 5) <= Instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 1) <= Instruction(11 DOWNTO 8);
            Immediate(11 DOWNTO 11) <= Instruction(7 DOWNTO 7);
            
            Immediate(31 DOWNTO 13) <= Inst31_Fill(31 DOWNTO 13);
            Immediate(0 DOWNTO 0) <= ZEROS_32(0 DOWNTO 0);
           WHEN RV32I_FN3_BRANCH_GE  => -- Branch if Greater or Equal
            Func <= BGE;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(12 DOWNTO 12) <= Instruction(31 DOWNTO 31);
            Immediate(10 DOWNTO 5) <= Instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 1) <= Instruction(11 DOWNTO 8);
            Immediate(11 DOWNTO 11) <= Instruction(7 DOWNTO 7);
            
            Immediate(31 DOWNTO 13) <= Inst31_Fill(31 DOWNTO 13);
            Immediate(0 DOWNTO 0) <= ZEROS_32(0 DOWNTO 0);
           WHEN RV32I_FN3_BRANCH_LTU  => -- Branch if Less Than Unsigned
            Func <= BLTU;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(12 DOWNTO 12) <= Instruction(31 DOWNTO 31);
            Immediate(10 DOWNTO 5) <= Instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 1) <= Instruction(11 DOWNTO 8);
            Immediate(11 DOWNTO 11) <= Instruction(7 DOWNTO 7);
            
            Immediate(31 DOWNTO 13) <= Inst31_Fill(31 DOWNTO 13);
            Immediate(0 DOWNTO 0) <= ZEROS_32(0 DOWNTO 0);
           WHEN RV32I_FN3_BRANCH_GEU  => -- Branch if Greater or Equal Unsigned
            Func <= BGEU;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(12 DOWNTO 12) <= Instruction(31 DOWNTO 31);
            Immediate(10 DOWNTO 5) <= Instruction(30 DOWNTO 25);
            Immediate(4 DOWNTO 1) <= Instruction(11 DOWNTO 8);
            Immediate(11 DOWNTO 11) <= Instruction(7 DOWNTO 7);
            
            Immediate(31 DOWNTO 13) <= Inst31_Fill(31 DOWNTO 13);
            Immediate(0 DOWNTO 0) <= ZEROS_32(0 DOWNTO 0);
           WHEN OTHERS =>
            Func <= BAD;
            RS1v <= '0';
            RS2v <= '0';
            RDv <= '0';
            Immediate <= ZEROS_32;
        END CASE;
        
      WHEN RV32I_OP_LOAD =>
--        itype := I;
        CASE Instruction(14 DOWNTO 12) IS
          
          WHEN RV32I_FN3_LOAD_B => -- Load Byte
            Func <= LB;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_LOAD_H => -- Load Half Word
            Func <= LH;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_LOAD_W => -- Load Word
            Func <= LW;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_LOAD_BU => -- Load Byte Unsigned
            Func <= LBU;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_LOAD_HU => -- Load Half Word Unsigned
            Func <= LHU;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN OTHERS =>
            Func <= BAD;
            RS1v <= '0';
            RS2v <= '0';
            RDv <= '0';
            Immediate <= ZEROS_32;
        END CASE;
  
      WHEN RV32I_OP_STORE =>
--        itype := S;

        CASE Instruction(14 DOWNTO 12) IS
        
          WHEN RV32I_FN3_STORE_B => -- Store Byte
            Func <= SB;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(11 DOWNTO 5) <= Instruction(31 DOWNTO 25);
            Immediate(4 DOWNTO 0) <= Instruction(11 DOWNTO 7);
            
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_STORE_H => -- Store Half Word
            Func <= SH;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(11 DOWNTO 5) <= Instruction(31 DOWNTO 25);
            Immediate(4 DOWNTO 0) <= Instruction(11 DOWNTO 7);
            
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_STORE_W => -- Store Word
            Func <= SW;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '0';
            Immediate(11 DOWNTO 5) <= Instruction(31 DOWNTO 25);
            Immediate(4 DOWNTO 0) <= Instruction(11 DOWNTO 7);
            
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN OTHERS =>
            Func <= BAD;
            RS1v <= '0';
            RS2v <= '0';
            RDv <= '0';
            Immediate <= ZEROS_32;
        END CASE;
        
      WHEN RV32I_OP_ALUI =>
--        itype := I;

        CASE Instruction(14 DOWNTO 12) IS
          WHEN RV32I_FN3_ALU_ADD =>
            CASE Instruction IS
            WHEN "00000000000000000000000000010011"=>
              Func <= NOP;
              RS1v <= '0';
              RS2v <= '0';
              RDv <= '0';
            WHEN OTHERS=>
              Func <= ADDI;
              RS1v <= '1';
              RS2v <= '0';
              RDv <= '1';
            END CASE;
              Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
              Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_ALU_SLT =>
            Func <= SLTI;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_ALU_SLTU =>
            Func <= SLTIU;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN  RV32I_FN3_ALU_XOR =>
            Func <= XORI;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN RV32I_FN3_ALU_OR =>
            Func <= ORI;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN  RV32I_FN3_ALU_AND =>
            Func <= ANDI;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN  RV32I_FN3_ALU_SLL =>
            Func <= SLLI;
            RS1v <= '1';
            RS2v <= '0';
            RDv <= '1';
            Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
            Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
          WHEN  RV32I_FN3_ALU_SRL =>
            
            CASE Instruction(31 DOWNTO 25) IS
              WHEN RV32I_FN7_ALU =>
                Func <= SRLI;
                RS1v <= '1';
                RS2v <= '0';
                RDv <= '1';
                Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
                Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
              WHEN RV32I_FN7_ALU_SA =>
                Func <= SRAI;
                RS1v <= '1';
                RS2v <= '0';
                RDv <= '1';
                Immediate(11 DOWNTO 0) <= Instruction(31 DOWNTO 20);
                Immediate(31 DOWNTO 12) <= Inst31_Fill(31 DOWNTO 12);
              WHEN OTHERS =>
                Func <= BAD;
                RS1v <= '0';
                RS2v <= '0';
                RDv <= '0';
                Immediate <= ZEROS_32;
            END CASE;
          WHEN OTHERS =>
            Func <= BAD;
            RS1v <= '0';
            RS2v <= '0';
            RDv <= '0';
            Immediate <= ZEROS_32;
        END CASE;
        
      WHEN RV32I_OP_ALU =>
--        itype := R;
        CASE Instruction(14 DOWNTO 12) IS
          WHEN RV32I_FN3_ALU_ADD =>
            CASE Instruction(31 DOWNTO 25) IS
              WHEN RV32I_FN7_ALU =>
                Func <= ADDr;
                RS1v <= '1';
                RS2v <= '1';
                RDv <= '1';
                Immediate <= ZEROS_32;
              WHEN RV32I_FN7_ALU_SUB =>
                Func <= SUBr;
                RS1v <= '1';
                RS2v <= '1';
                RDv <= '1';
                Immediate <= ZEROS_32;
              WHEN OTHERS =>
                Func <= BAD;
                RS1v <= '0';
                RS2v <= '0';
                RDv <= '0';
                Immediate <= ZEROS_32;
            END CASE;
          WHEN RV32I_FN3_ALU_SLT =>
            Func <= SLTr;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '1';
            Immediate <= ZEROS_32;
          WHEN RV32I_FN3_ALU_SLTU =>
            Func <= SLTUr;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '1';
            Immediate <= ZEROS_32;
          WHEN  RV32I_FN3_ALU_XOR=>
            Func <= XORr;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '1';
            Immediate <= ZEROS_32;
          WHEN RV32I_FN3_ALU_OR =>
            Func <= ORr;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '1';
            Immediate <= ZEROS_32;
          WHEN  RV32I_FN3_ALU_AND =>
            Func <= ANDr;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '1';
            Immediate <= ZEROS_32;
          WHEN  RV32I_FN3_ALU_SLL =>
            Func <= SLLr;
            RS1v <= '1';
            RS2v <= '1';
            RDv <= '1';
            Immediate <= ZEROS_32;
          WHEN  RV32I_FN3_ALU_SRL =>
            CASE Instruction(31 DOWNTO 25) IS
              WHEN RV32I_FN7_ALU =>
                Func <= SRLr;
                RS1v <= '1';
                RS2v <= '1';
                RDv <= '1';
                Immediate <= ZEROS_32;
              WHEN RV32I_FN7_ALU_SA =>
                Func <= SRAr;
                RS1v <= '1';
                RS2v <= '1';
                RDv <= '1';
                Immediate <= ZEROS_32;
              WHEN OTHERS =>
                Func <= BAD;
                RS1v <= '0';
                RS2v <= '0';
                RDv <= '0';
                Immediate <= ZEROS_32;
            END CASE;
          WHEN OTHERS =>
            Func <= BAD;
            RS1v <= '0';
            RS2v <= '0';
            RDv <= '0';
            Immediate <= ZEROS_32;
        END CASE;
        
      WHEN OTHERS =>
        Func <= BAD;
        RS1v <= '0';
        RS2v <= '0';
        RDv <= '0';
        Immediate <= ZEROS_32;
      END CASE;
      

      
--    ELSIF LowDigits = "00" THEN
--      Func <= NOP;
--      RS1v <= '0';
--      RS2v <= '0';
--      RDv <= '0';
--      Immediate <= ZEROS_32;
      
    ELSE
      Func <= BAD;
      RS1v <= '0';
      RS2v <= '0';
      RDv <= '0';
      Immediate <= ZEROS_32;
    END IF;
    
  END PROCESS;
  
  
  
  
END ARCHITECTURE;