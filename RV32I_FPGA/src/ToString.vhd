library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

package ToString is
  function to_hstring (SLV : std_ulogic_vector) return string;
end ToString;

PACKAGE body ToString IS
  function to_hstring (SLV : std_ulogic_vector) return string is
    variable L : LINE;
  begin
    hwrite(L,SLV);
  return L.all;
  end;
END ToString;
