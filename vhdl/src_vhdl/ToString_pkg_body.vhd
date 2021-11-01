  PACKAGE body ToString_pkg IS
    function to_hstring (SLV : std_logic_vector) return string is
      variable L : LINE;
    begin
      hwrite(L,SLV);
    return L.all;
    end;
  END ToString_pkg;