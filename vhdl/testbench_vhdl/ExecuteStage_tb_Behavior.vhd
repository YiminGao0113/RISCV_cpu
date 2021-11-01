--
-- VHDL Architecture CAD_lib.ExecuteStage_tb.Behavior
--
-- Created:
--          by - yimin.UNKNOWN (LAPTOP-JLT9STRO)
--          at - 22:14:52 2021/03/26
--
-- using Mentor Graphics HDL Designer(TM) 2018.2 (Build 19)
--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE std.textio.all;

LIBRARY CAD_lib;
USE CAD_lib.RV32I.ALL;


ENTITY ExecuteStage_tb IS
END ENTITY ExecuteStage_tb;

--
ARCHITECTURE Behavior OF ExecuteStage_tb IS
  FILE test_vectors : text OPEN read_mode IS "D:/Myproject/CAD/CAD_lib/hdl/ExecuteStage_vec.txt";

  SIGNAL Left, Right, Extra : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL AddrDest : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL Func : RV32I_Op;
  SIGNAL C : std_ulogic;

  SIGNAL Address, Jaddr, Data, Addressv, Jaddrv, Datav : std_ulogic_vector(31 DOWNTO 0);
  SIGNAL AddrDest1, AddrDest1v : std_ulogic_vector(4 DOWNTO 0);
  SIGNAL Func1, Func1v : RV32I_Op;
  SIGNAL Jump, Jumpv : std_ulogic;

  SIGNAL Stall : std_ulogic;

  SIGNAL vecno : NATURAL := 0;
BEGIN
  duv : ENTITY work.ExecuteStage(Mixed)
        GENERIC MAP(width => 32)
        PORT MAP(Clock => C, Left => Left, Right => Right, Extra => Extra, Stall=> Stall, AddrDest => AddrDest, AddrDest1 => AddrDest1, Func => Func, Address => Address, Data => Data, Func1 => Func1, Jaddr => Jaddr, Jump => Jump);
  Stim : PROCESS
  VARIABLE L : LINE;
  VARIABLE Left_val, Right_val, Extra_val : std_ulogic_vector(31 DOWNTO 0);
  VARIABLE AddrDest_val : std_ulogic_vector(4 DOWNTO 0);
  VARIABLE Func_val,Func1_val : Func_Name;
  VARIABLE Address_val, Jaddr_val, Data_val : std_ulogic_vector(31 DOWNTO 0);
  VARIABLE AddrDest1_val : std_ulogic_vector(4 DOWNTO 0);
  VARIABLE Jump_val : std_ulogic;
  VARIABLE Stall_val : std_ulogic;

  BEGIN
    C <= '0';
    wait for 40 ns;
    readline(test_vectors,L);
    WHILE NOT endfile(test_vectors) LOOP
      readline(test_vectors,L);
      -- Read Input
      read(L,Func_val);
      Func <= Ftype(Func_val);
      read(L,Func1_val);
      Func1v <= Ftype(Func1_val);
      read(L,Stall_val);
      Stall <= Stall_val;
      read(L,Right_val);
      Right <= Right_val;
      read(L,Left_val);
      Left <= Left_val;
      read(L,Extra_val);
      Extra <= Extra_val;
      read(L,AddrDest_val);
      AddrDest <= AddrDest_val;
      -- Read output
      read(L,Address_val);
      Addressv <= Address_val;
      read(L,Data_val);
      Datav <= Data_val;
      read(L,AddrDest1_val);
      AddrDest1v <= AddrDest1_val;
      read(L,Jump_val);
      Jumpv <= Jump_val;
      read(L,Jaddr_val);
      Jaddrv <= Jaddr_val;
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
          ASSERT (Address=Addressv)AND(Data=Datav)AND(AddrDest1=AddrDest1v)AND(Jaddr=Jaddrv)AND(Jump=Jumpv)AND(Func1=Func1v)
          REPORT "ERROR: Incorrect output for vector " & to_String(vecno)
          SEVERITY WARNING;
      vecno <= vecno + 1;
    END IF;
  END PROCESS;





END ARCHITECTURE Behavior;
