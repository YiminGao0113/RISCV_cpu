--
-- VHDL Architecture CAD_lib.PipelineDecodeStage_tb.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 23:10:10 2021/03/12
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;



LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY PipelineDecodeStage_tb IS
END ENTITY PipelineDecodeStage_tb;



ARCHITECTURE Behavior OF PipelineDecodeStage_tb IS

  SIGNAL Inst, DataA, DataB, Address : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL Func, Func_v : RV32I_Op;
  SIGNAL C : std_ulogic;
  SIGNAL AddrA, AddrB, AddrDest, AddrA_v, AddrB_v, AddrDest_v: std_ulogic_vector(4 DOWNTO 0);
  SIGNAL Left, Right, Extra, Left_v, Right_v, Extra_v: std_ulogic_vector(31 DOWNTO 0);

  SIGNAL vecno : NATURAL := 0;
  FILE test_vectors : text OPEN read_mode IS "D:\Myproject\CAD\CAD_lib\hdl\PipelineDecodeStage_vec.txt";
 BEGIN

    duv : ENTITY work.PipelineDecodeStage(Mixed)
      GENERIC MAP(width => 32)
      PORT MAP(Inst=>Inst, DataA=>DataA, DataB=>DataB, Clock=>C, Jmp=>'0', Stall=>'0', Address=>Address, AddrA=>AddrA, AddrB=>AddrB, AddrDest=>AddrDest, Func=>Func, Left=>Left, Right=>Right, Extra=>Extra);
    stim: PROCESS
      VARIABLE L : LINE;
      VARIABLE Inst_val, DataA_val, DataB_val, Address_val: std_ulogic_vector(31 DOWNTO 0);
      VARIABLE Func_val : Func_Name;
      VARIABLE AddrA_val, AddrB_val, AddrDest_val : std_ulogic_vector(4 DOWNTO 0);
      VARIABLE Left_val, Right_val, Extra_val : std_ulogic_vector(31 DOWNTO 0);

      BEGIN
      C <= '0';
      wait for 40 ns;
      readline(test_vectors,L);
      WHILE NOT endfile(test_vectors) LOOP
        readline(test_vectors,L);

        read(L,Func_val);
        Func_v <= Ftype(Func_val);

        read(L, Inst_val);
        Inst <= Inst_val;

        read(L, DataA_val);
        DataA <= DataA_val;

        read(L, DataB_val);
        DataB <= DataB_val;

        read(L, Address_val);
        Address <= Address_val;

        read(L, AddrA_val);
        AddrA_v <= AddrA_val;

        read(L, AddrB_val);
        AddrB_v <= AddrB_val;

        read(L, AddrDest_val);
        AddrDest_v <= AddrDest_val;

        read(L,Left_val);
        Left_v <= Left_val;

        read(L,Right_val);
        Right_v <= Right_val;

        read(L,Extra_val);
        Extra_v <= Extra_val;

        wait for 10 ns;
        C <= '1';
        wait for 50 ns;
        C <= '0';
        wait for 40 ns;
      END LOOP;


          report "End of TestBench.";
          std.env.finish;
      END PROCESS;
    check: PROCESS(C)
    BEGIN
    IF(falling_edge(C)) THEN
          ASSERT (Func=Func_v)AND(AddrA=AddrA_v)AND(AddrB=AddrB_v)AND(AddrDest=AddrDest_v)AND(Left=Left_v)AND(Right=Right_v)AND(Extra=Extra_v)
          REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
          SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;


END ARCHITECTURE Behavior;
