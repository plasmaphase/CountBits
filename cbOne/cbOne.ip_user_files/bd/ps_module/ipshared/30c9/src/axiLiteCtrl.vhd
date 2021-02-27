-------------------------------------------------------------------------------
-- Title      : AXI LITE CONTROL
-------------------------------------------------------------------------------
-- File       : axiLiteCtrl.vhd
-------------------------------------------------------------------------------
-- Description: This file is the AXI Lite interface for the Count Bits Module
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use work.cb_pkg.all;

entity axiLiteCtrl is
  generic (
    AXIL_ADDR_WIDTH     : integer := 32;
    AXIL_DATA_WIDTH     : integer := 32;
    AXI_DATA_WIDTH      : integer := 512
  );
  port (
    axil_aclk    : in  std_logic;
    axil_aresetn : in  std_logic;
    axil_awaddr  : in  std_logic_vector(AXIL_ADDR_WIDTH-1 downto 0);
    axil_awprot  : in  std_logic_vector(2 downto 0);
    axil_awvalid : in  std_logic;
    axil_awready : out std_logic;
    axil_wdata   : in  std_logic_vector(31 downto 0);
    axil_wstrb   : in  std_logic_vector(3 downto 0);
    axil_wvalid  : in  std_logic;
    axil_wready  : out std_logic;
    axil_bresp   : out std_logic_vector(1 downto 0);
    axil_bvalid  : out std_logic;
    axil_bready  : in  std_logic;
    axil_araddr  : in  std_logic_vector(AXIL_ADDR_WIDTH-1 downto 0);
    axil_arprot  : in  std_logic_vector(2 downto 0);
    axil_arvalid : in  std_logic;
    axil_arready : out std_logic;
    axil_rdata   : out std_logic_vector(31 downto 0);
    axil_rresp   : out std_logic_vector(1 downto 0);
    axil_rvalid  : out std_logic;
    axil_rready  : in  std_logic;

    total_bits   : in std_logic_vector(AXIL_DATA_WIDTH-1 downto 0);
    word_bits    : in register_file_typ(0 to (AXI_DATA_WIDTH/32)-1);
    byte_bits    : in register_file_typ(0 to (AXI_DATA_WIDTH/8)-1);
    reset_bits   : out std_logic
  );
end axiLiteCtrl;

architecture rtl of axiLiteCtrl is

  constant REVISION : std_logic_vector(31 downto 0) := X"00000001";

  -- axi4lite signals
  signal axi_awaddr  : std_logic_vector(AXIL_ADDR_WIDTH-1 downto 0);
  signal axi_awready : std_logic;
  signal axi_wready  : std_logic;
  signal axi_bresp   : std_logic_vector(1 downto 0);
  signal axi_bvalid  : std_logic;
  signal axi_araddr  : std_logic_vector(AXIL_ADDR_WIDTH-1 downto 0);
  signal axi_arready : std_logic;
  signal axi_rdata   : std_logic_vector(31 downto 0);
  signal axi_rresp   : std_logic_vector(1 downto 0);
  signal axi_rvalid  : std_logic;

  constant addr_lsb          : integer := (AXIL_DATA_WIDTH/32)+1;
  constant opt_mem_addr_bits : integer := 8; -- how many bits of register space, this is excessive
  constant num_axi_bytes     : integer := (AXI_DATA_WIDTH/8);
  constant num_axi_words     : integer := (AXI_DATA_WIDTH/32);

  ------------------------------------------------
  ---- functions and signals mostly for register space
  --------------------------------------------------
  function last_register
    return integer is
  begin 
    return 3+(num_axi_bytes+num_axi_words);
  end function last_register;

  constant LAST_REG     : integer := last_register;
  signal reg_data_out   : std_logic_vector(31 downto 0);
  signal byte_index     : integer;
  signal aw_en          : std_logic;
  signal slv_reg_rden   : std_logic;
  signal slv_reg_wren   : std_logic;

  signal register_file : register_file_typ(0 to LAST_REG-1);

  alias revision_reg   : register_typ is register_file(0);
  alias control_reg    : register_typ is register_file(1);
  alias total_bits_reg : register_typ is register_file(2);
  alias word_bits_reg  : register_file_typ(0 to num_axi_words-1) is register_file(3 to (3+(num_axi_words))-1);
  alias byte_bits_reg  : register_file_typ(0 to num_axi_bytes-1) is register_file(3+(num_axi_words) to (3+(num_axi_words + num_axi_bytes)-1));

  alias clear_regs : std_logic is control_reg(0);
  
begin

  ----------------------------------------------------------------------------------
  -- AXI Lite protocol specific logic
  ----------------------------------------------------------------------------------

  process (axil_aclk)
  begin
    if rising_edge(axil_aclk) then
      if axil_aresetn = '0' then
        axi_awready <= '0';
        aw_en       <= '1';
        axi_awaddr <= (others => '0');
      else
        if (axi_awready = '0' and axil_awvalid = '1' and axil_wvalid = '1' and aw_en = '1') then
          axi_awready <= '1';
          aw_en       <= '0';
          axi_awaddr <= axil_awaddr;
        elsif (axil_bready = '1' and axi_bvalid = '1') then
          aw_en       <= '1';
          axi_awready <= '0';
        else
          axi_awready <= '0';
        end if;
      end if;
    end if;
  end process;

  process (axil_aclk)
  begin
    if rising_edge(axil_aclk) then
      if axil_aresetn = '0' then
        axi_wready <= '0';
      else
        if (axi_wready = '0' and axil_wvalid = '1' and axil_awvalid = '1' and aw_en = '1') then
          axi_wready <= '1';
        else
          axi_wready <= '0';
        end if;
      end if;
    end if;
  end process;

  process (axil_aclk)
  begin
    if rising_edge(axil_aclk) then
      if axil_aresetn = '0' then
        axi_bvalid <= '0';
        axi_bresp  <= "00";
      else
        if (axi_awready = '1' and axil_awvalid = '1' and axi_wready = '1' and axil_wvalid = '1' and axi_bvalid = '0') then
          axi_bvalid <= '1';
          axi_bresp  <= "00";
        elsif (axil_bready = '1' and axi_bvalid = '1') then
          axi_bvalid <= '0';
        end if;
      end if;
    end if;
  end process;

  process (axil_aclk)
  begin
    if rising_edge(axil_aclk) then
      if axil_aresetn = '0' then
        axi_arready <= '0';
        axi_araddr  <= (others => '1');
      else
        if (axi_arready = '0' and axil_arvalid = '1') then
          axi_arready <= '1';
          axi_araddr  <= axil_araddr;
        else
          axi_arready <= '0';
        end if;
      end if;
    end if;
  end process;

  process (axil_aclk)
  begin
    if rising_edge(axil_aclk) then
      if axil_aresetn = '0' then
        axi_rvalid <= '0';
        axi_rresp  <= "00";
      else
        if (axi_arready = '1' and axil_arvalid = '1' and axi_rvalid = '0') then
          axi_rvalid <= '1';
          axi_rresp  <= "00";
        elsif (axi_rvalid = '1' and axil_rready = '1') then
          axi_rvalid <= '0';
        end if;
      end if;
    end if;
  end process;

  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------

  slv_reg_wren <= axi_wready and axil_wvalid and axi_awready and axil_awvalid;

  process (axil_aclk)
    variable loc_addr : std_logic_vector(opt_mem_addr_bits downto 0);
  begin
    if rising_edge(axil_aclk) then
      if axil_aresetn = '0' then
        register_file <= (others => (others => '0'));
      else
        loc_addr := axi_awaddr(addr_lsb+opt_mem_addr_bits downto addr_lsb);

        revision_reg           <= REVISION;
        total_bits_reg <= total_bits;
        word_bits_reg <= word_bits;
        byte_bits_reg <= byte_bits;
        --------------------------------------------------------------
        if (slv_reg_wren = '1') then
          for addr_index in 0 to (LAST_REG-1) loop
            for byte_index in 0 to 3 loop --# bytes per data bus
              if loc_addr = std_logic_vector(to_unsigned(addr_index, loc_addr'length)) then
                if (axil_wstrb(byte_index) = '1') then
                  if addr_index < 2 then --everything beyond this is read only
                   register_file(addr_index)(byte_index*8+7 downto byte_index*8) <= axil_wdata(byte_index*8+7 downto byte_index*8);
                  end if;
                end if;
              end if;
            end loop;
          end loop;
        end if;
      end if;
    end if;
  end process;

  slv_reg_rden <= axi_arready and axil_arvalid and (not axi_rvalid);

  ----------------------------------------------------------------------------------
  process (axil_aclk)
    variable loc_addr : std_logic_vector(opt_mem_addr_bits downto 0);
  begin
    if rising_edge(axil_aclk) then
      if axil_aresetn = '0' then
        reg_data_out <= (others => '0');
      else
        -- address decoding for reading registers
        loc_addr := axi_araddr(addr_lsb+opt_mem_addr_bits downto addr_lsb);
        for addr_index in 0 to (LAST_REG-1) loop
          if loc_addr = std_logic_vector(to_unsigned(addr_index, loc_addr'length)) then
            reg_data_out <= register_file(addr_index);
          end if;
        end loop;
      end if;
    end if;
  end process;

  axi_rdata <= reg_data_out;
  ----------------------------------------------------------------------------------
  ----------------------------------------------------------------------------------

  axil_awready <= axi_awready;
  axil_wready  <= axi_wready;
  axil_bresp   <= axi_bresp;
  axil_bvalid  <= axi_bvalid;
  axil_arready <= axi_arready;
  axil_rdata   <= axi_rdata;
  axil_rresp   <= axi_rresp;
  axil_rvalid  <= axi_rvalid;

  --TODO: Future improvement would be edge detect
  --so user doesn't have to clear the register
  --after setting
  reset_bits <= clear_regs;
  
end rtl;