-------------------------------------------------------------------------------
-- Title      : COUNT BITS PACKAGE
-------------------------------------------------------------------------------
-- File       : cb_pkg.vhd
-------------------------------------------------------------------------------
-- Description: This file provides general functionality related to count bits
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package cb_pkg is

  subtype register_typ is std_logic_vector(31 downto 0);
  type register_file_typ is array(natural range <>) of register_typ;

  function to_slv(slvv               : register_file_typ) return std_logic_vector;
  function log2 (a                   : integer) return integer;
  function inv_mask_bits (data, mask : std_logic_vector ) return std_logic_vector;

end package cb_pkg;

package body cb_pkg is

  function to_slv(slvv : register_file_typ) return std_logic_vector is
    variable slv         : std_logic_vector((slvv'length * 32) - 1 downto 0);
  begin
    slv := (others => '0');
    for i in slvv'range loop
      slv(((i * 32) + 31) downto (i * 32)) := std_logic_vector(slvv(i));
    end loop;
    return slv;
  end function;

  function log2 (
      a : integer)
    return integer is
    variable temp, res : integer;
  begin -- function log2
    temp := a / 2;
    res  := 0;
    while (temp > 0) loop
      res  := res + 1;
      temp := temp / 2;
    end loop;
    return res;
  end function log2;

  function inv_mask_bits (data, mask : std_logic_vector )
    return std_logic_vector is
  begin
    return ((data and not(mask)) or (not(data) and mask));
  end function inv_mask_bits;


end package body cb_pkg;
