--
-- VHDL Architecture CAD_lib.RV32I_Decoder_tb.TestBench
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 00:50:07 2021/03/ 6
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;


LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY RV32I_Decoder_tb IS
END ENTITY RV32I_Decoder_tb;

--
ARCHITECTURE TestBench OF RV32I_Decoder_tb IS
  FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\RV32I_Decoder_vec.txt";
  
  SIGNAL Instruction : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Func,FuncA: RV32I_Op;
  SIGNAL RS1, RS2, RD, RS1A, RS2A, RDA : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL RS1v, RS2v, RDv, RS1vA, RS2vA, RDvA ,C: std_ulogic;
  SIGNAL Immediate, ImmediateA : std_ulogic_vector(31 DOWNTO 0);
  
  SIGNAL vecno : NATURAL := 0;
BEGIN
  DUV : ENTITY work.RV32I_Decoder(Behavior)
      PORT MAP(Instruction=>Instruction,Func=>Func,RS1=>RS1,RS2=>RS2,RD=>RD,RS1v=>RS1v,RS2v=>RS2v,RDv=>RDv,Immediate=>Immediate);
  Stim: PROCESS
    VARIABLE L : LINE;
    VARIABLE Instruction_val : std_ulogic_vector(31 DOWNTO 0);
    VARIABLE Func_val : Func_Name; 
    VARIABLE RS1_val, RS2_val, RD_val : std_ulogic_vector(4 DOWNTO 0);
    VARIABLE RS1v_val, RS2v_val, RDv_val : std_ulogic;
    VARIABLE Immediate_val : std_ulogic_vector(31 DOWNTO 0);  
  BEGIN
    C <= '0';
    wait for 40 ns;
  readline(test_vectors,L);
  WHILE NOT endfile(test_vectors) LOOP
    readline(test_vectors,L);
    read(L,Func_val);
    FuncA <= Ftype(Func_val);
    read(L,Instruction_val);
    Instruction <= Instruction_val;
    read(L,RS1_val);
    RS1A <= RS1_val;
    read(L,RS2_val);
    RS2A <= RS2_val;
    read(L,RD_val);
    RDA <= RD_val;
    read(L,RS1v_val);
    RS1vA <= RS1v_val;
    read(L,RS2v_val);
    RS2vA <= RS2v_val;
    read(L,RDv_val);
    RDvA <= RDv_val;
    read(L,Immediate_val);
    ImmediateA <= Immediate_val;
    
    wait for 10 ns;
    C <= '1';
    wait for 50 ns;
    C <= '0';
    wait for 40 ns;
  END LOOP;
  
    report "End of TestBench.";
    std.env.finish;
  END PROCESS;
  
  
  Check: PROCESS(C)

  BEGIN
    IF(falling_edge(C)) THEN
          ASSERT (Func=FuncA)AND(RS1=RS1A)AND(RS2=RS2A)AND(RD=RDA)AND(RS1v=RS1vA)AND(RS2v=RS2vA)AND(RDv=RDvA)AND(Immediate=ImmediateA)
          REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
          SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;
END ARCHITECTURE TestBench;
