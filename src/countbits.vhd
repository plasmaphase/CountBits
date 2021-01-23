-------------------------------------------------------------------------------
-- Title      : COUNT BITS MODULE
-------------------------------------------------------------------------------
-- File       : countbits.vhd
-------------------------------------------------------------------------------
-- Description: This file is the core logic for the count bits module
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.cb_pkg.all;

entity countbits is
  generic (
    AXIL_DATA_WIDTH : integer := 32;
    AXI_DATA_WIDTH  : integer := 512
  );
  port (
    clk          : in std_logic;
    rstn         : in std_logic;
    maxii_wvalid : in std_logic;
    maxio_wready : in std_logic;
    maxii_wdata  : in std_logic_vector(AXI_DATA_WIDTH-1 downto 0);

    total_bits : out std_logic_vector(AXIL_DATA_WIDTH-1 downto 0);
    word_bits  : out register_file_typ(0 to (AXI_DATA_WIDTH/32)-1);
    byte_bits  : out register_file_typ(0 to (AXI_DATA_WIDTH/8)-1);
    reset_bits : in  std_logic
  );
end countbits;

architecture rtl of countbits is

  constant BYTES_IN_WORD : integer := 4;
  constant BITS_IN_BYTE  : integer := 8;

  signal data_valid     : std_logic;
  signal total_bits_reg : std_logic_vector(AXIL_DATA_WIDTH-1 downto 0);
  signal word_bits_reg  : register_file_typ(0 to (AXI_DATA_WIDTH/32)-1);
  signal byte_bits_reg  : register_file_typ(0 to (AXI_DATA_WIDTH/8)-1);

begin

  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------

  data_valid <= maxii_wvalid and maxio_wready;

  -----------------------------------------------------------------------------------
  -------------------------- accumulate set bits on bus -----------------------------
  data_bits_proc : process (clk) is
    variable accum_bus  : std_logic_vector(31 downto 0);
    variable accum_word : std_logic_vector(31 downto 0);
    variable accum_byte : std_logic_vector(31 downto 0);
    variable cnt        : std_logic_vector(31 downto 0);

    variable byt_idx : integer := 0;
    variable wrd_idx : integer := 0;
  begin
    if rising_edge(clk) then
      if (rstn = '0') then
        accum_bus      := (others => '0');
        accum_word     := (others => '0');
        accum_byte     := (others => '0');
        total_bits_reg <= (others => '0');
        word_bits_reg  <= (others => (others => '0'));
        byte_bits_reg  <= (others => (others => '0'));
      else

        -- user can reset/clear accumulation registers
        if (reset_bits = '1') then
          total_bits_reg <= (others => '0');
          word_bits_reg  <= (others => (others => '0'));
          byte_bits_reg  <= (others => (others => '0'));
        end if;

        if (data_valid = '1') then
          accum_bus  := (others => '0');
          accum_word := (others => '0');
          accum_byte := (others => '0');

          --loop over all bits in the data bus
          bitloop : for bt in 1 to AXI_DATA_WIDTH loop

            -- this is used to interpret lower bits for segregating bus into bytes/words
            cnt := std_logic_vector(to_unsigned(bt, cnt'length));

            -- update counters when bit set
            if(maxii_wdata(bt-1) = '1') then
              accum_bus  := accum_bus + 1;
              accum_word := accum_word + 1;
              accum_byte := accum_byte + 1;
            end if;

            -- if we rollover at a byte boundary (2^3 = 8)
            if((cnt(2 downto 0) = "000") and (bt /= 0)) then
              byte_bits_reg(byt_idx) <= byte_bits_reg(byt_idx) + accum_byte;
              byt_idx                := byt_idx + 1;
              accum_byte             := (others => '0');
            end if;

            -- if we rollover at a word boundary (2^5 = 32)
            if((cnt(4 downto 0) = "00000") and (bt /= 0)) then
              word_bits_reg(wrd_idx) <= word_bits_reg(wrd_idx) + accum_word;
              wrd_idx                := wrd_idx + 1;
              accum_word             := (others => '0');
            end if;
          end loop;

          total_bits_reg <= total_bits_reg + accum_bus;
          accum_bus      := (others => '0');
          byt_idx        := 0;
          wrd_idx        := 0;

        end if;
      end if;
    end if;
  end process data_bits_proc;
  -----------------------------------------------------------------------------------


  gen_words_reg : for w in 0 to (AXI_DATA_WIDTH/32)-1 generate
    word_bits(w) <= word_bits_reg(w);
  end generate gen_words_reg;

  gen_bytes_reg : for b in 0 to (AXI_DATA_WIDTH/8)-1 generate
    byte_bits(b) <= byte_bits_reg(b);
  end generate gen_bytes_reg;

  total_bits <= total_bits_reg;


end rtl;

