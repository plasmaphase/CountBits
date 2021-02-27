-------------------------------------------------------------------------------
-- Title      : AXI LITE CONTROL
-------------------------------------------------------------------------------
-- File       : cp_top.vhd
-------------------------------------------------------------------------------
-- Description: This file is the top file for the count bits module
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use work.cb_pkg.all;

entity cb_top is
  generic (
    AXI_RUSER_WIDTH  : integer := 0;
    AXI_ARUSER_WIDTH : integer := 0;
    AXI_WUSER_WIDTH  : integer := 0;
    AXI_AWUSER_WIDTH : integer := 0;
    AXI_BUSER_WIDTH  : integer := 0;
    AXI_ID_WIDTH     : integer := 4;
    AXI_DATA_WIDTH   : integer := 512;
    AXI_ADDR_WIDTH   : integer := 64;
    AXIL_ADDR_WIDTH  : integer := 32;
    AXIL_DATA_WIDTH  : integer := 32
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

    -- AXI4-MM Write Master In
    maxii_awid    : in  std_logic_vector(AXI_ID_WIDTH - 1 downto 0);
    maxii_awaddr  : in  std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
    maxii_awlen   : in  std_logic_vector(7 downto 0);
    maxii_awsize  : in  std_logic_vector(2 downto 0);
    maxii_awburst : in  std_logic_vector(1 downto 0);
    maxii_awlock  : in  std_logic;
    maxii_awcache : in  std_logic_vector(3 downto 0);
    maxii_awprot  : in  std_logic_vector(2 downto 0);
    maxii_awqos   : in  std_logic_vector(3 downto 0);
    maxii_awregion: in  std_logic_vector(3 downto 0);
    maxii_awuser  : in  std_logic_vector(AXI_AWUSER_WIDTH - 1 downto 0);
    maxii_awvalid : in  std_logic;
    maxii_awready : out std_logic;
    maxii_wdata   : in  std_logic_vector(AXI_DATA_WIDTH - 1 downto 0);
    maxii_wstrb   : in  std_logic_vector(AXI_DATA_WIDTH/8 - 1 downto 0);
    maxii_wlast   : in  std_logic;
    maxii_wuser   : in  std_logic_vector(AXI_WUSER_WIDTH - 1 downto 0);
    maxii_wvalid  : in  std_logic;
    maxii_wready  : out std_logic;
    maxii_bid     : out std_logic_vector(AXI_ID_WIDTH - 1 downto 0);
    maxii_bresp   : out std_logic_vector(1 downto 0);
    maxii_buser   : out std_logic_vector(AXI_BUSER_WIDTH - 1 downto 0);
    maxii_bvalid  : out std_logic;
    maxii_bready  : in  std_logic;
    -- AXI4-MM Write Master Out
    maxio_awid    : out std_logic_vector(AXI_ID_WIDTH - 1 downto 0);
    maxio_awaddr  : out std_logic_vector(AXI_ADDR_WIDTH - 1 downto 0);
    maxio_awlen   : out std_logic_vector(7 downto 0);
    maxio_awsize  : out std_logic_vector(2 downto 0);
    maxio_awburst : out std_logic_vector(1 downto 0);
    maxio_awlock  : out std_logic;
    maxio_awcache : out std_logic_vector(3 downto 0);
    maxio_awprot  : out std_logic_vector(2 downto 0);
    maxio_awqos   : out std_logic_vector(3 downto 0);
    maxio_awregion: out  std_logic_vector(3 downto 0);
    maxio_awuser  : out std_logic_vector(AXI_AWUSER_WIDTH - 1 downto 0);
    maxio_awvalid : out std_logic;
    maxio_awready : in  std_logic;
    maxio_wdata   : out std_logic_vector(AXI_DATA_WIDTH - 1 downto 0);
    maxio_wstrb   : out std_logic_vector(AXI_DATA_WIDTH/8 - 1 downto 0);
    maxio_wlast   : out std_logic;
    maxio_wuser   : out std_logic_vector(AXI_WUSER_WIDTH - 1 downto 0);
    maxio_wvalid  : out std_logic;
    maxio_wready  : in  std_logic;
    maxio_bid     : in  std_logic_vector(AXI_ID_WIDTH - 1 downto 0);
    maxio_bresp   : in  std_logic_vector(1 downto 0);
    maxio_buser   : in  std_logic_vector(AXI_BUSER_WIDTH - 1 downto 0);
    maxio_bvalid  : in  std_logic;
    maxio_bready  : out std_logic
  );
end cb_top;

architecture rtl of cb_top is

  signal total_bits : std_logic_vector(AXIL_DATA_WIDTH-1 downto 0);
  signal word_bits  : register_file_typ(0 to (AXI_DATA_WIDTH/32)-1);
  signal byte_bits  : register_file_typ(0 to (AXI_DATA_WIDTH/8)-1);
  signal reset_bits : std_logic;

  component axiLiteCtrl is
    generic (
      AXIL_ADDR_WIDTH : integer := 32;
      AXIL_DATA_WIDTH : integer := 32;
      AXI_DATA_WIDTH  : integer := 128
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
      total_bits   : in  std_logic_vector(AXIL_DATA_WIDTH-1 downto 0);
      word_bits    : in  register_file_typ(0 to (AXI_DATA_WIDTH/32)-1);
      byte_bits    : in  register_file_typ(0 to (AXI_DATA_WIDTH/8)-1);
      reset_bits   : out std_logic
    );
  end component axiLiteCtrl;

  component countbits is
    generic (
      AXIL_DATA_WIDTH : integer := 32;
      AXI_DATA_WIDTH  : integer := 128
    );
    port (
      clk          : in  std_logic;
      rstn         : in  std_logic;
      maxii_wvalid : in  std_logic;
      maxio_wready : in  std_logic;
      maxii_wdata  : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
      total_bits   : out std_logic_vector(AXIL_DATA_WIDTH-1 downto 0);
      word_bits    : out register_file_typ(0 to (AXI_DATA_WIDTH/32)-1);
      byte_bits    : out register_file_typ(0 to (AXI_DATA_WIDTH/8)-1);
      reset_bits   : in  std_logic
    );
  end component countbits;  

begin

  axiLiteCtrl_1 : entity work.axiLiteCtrl
    generic map (
      AXIL_ADDR_WIDTH => AXIL_ADDR_WIDTH,
      AXIL_DATA_WIDTH => AXIL_DATA_WIDTH,
      AXI_DATA_WIDTH  => AXI_DATA_WIDTH
    )
    port map (
      axil_aclk    => axil_aclk,
      axil_aresetn => axil_aresetn,
      axil_awaddr  => axil_awaddr,
      axil_awprot  => axil_awprot,
      axil_awvalid => axil_awvalid,
      axil_awready => axil_awready,
      axil_wdata   => axil_wdata,
      axil_wstrb   => axil_wstrb,
      axil_wvalid  => axil_wvalid,
      axil_wready  => axil_wready,
      axil_bresp   => axil_bresp,
      axil_bvalid  => axil_bvalid,
      axil_bready  => axil_bready,
      axil_araddr  => axil_araddr,
      axil_arprot  => axil_arprot,
      axil_arvalid => axil_arvalid,
      axil_arready => axil_arready,
      axil_rdata   => axil_rdata,
      axil_rresp   => axil_rresp,
      axil_rvalid  => axil_rvalid,
      axil_rready  => axil_rready,
      total_bits   => total_bits,
      word_bits    => word_bits,
      byte_bits    => byte_bits,
      reset_bits   => reset_bits
    );

  countbits_1 : entity work.countbits
    generic map (
      AXIL_DATA_WIDTH => AXIL_DATA_WIDTH,
      AXI_DATA_WIDTH  => AXI_DATA_WIDTH
    )
    port map (
      clk          => axil_aclk,
      rstn         => axil_aresetn,
      maxii_wvalid => maxii_wvalid,
      maxio_wready => maxio_wready,
      maxii_wdata  => maxii_wdata,
      total_bits   => total_bits,
      word_bits    => word_bits,
      byte_bits    => byte_bits,
      reset_bits   => reset_bits
    );    

    --if maxii_wvalid = '1' and maxio_wready = '1' then
    -- data valid
  ----------------------------------------------------------------------------
  -------------------- pass axi write signals passthrough --------------------
  maxio_awid    <= maxii_awid;
  maxio_awaddr  <= maxii_awaddr;
  maxio_awlen   <= maxii_awlen;
  maxio_awsize  <= maxii_awsize;
  maxio_awburst <= maxii_awburst;
  maxio_awlock  <= maxii_awlock;
  maxio_awcache <= maxii_awcache;
  maxio_awprot  <= maxii_awprot;
  maxio_awregion <= maxii_awregion;
  maxio_awqos   <= maxii_awqos;
  maxio_awuser  <= maxii_awuser;
  maxio_awvalid <= maxii_awvalid;
  maxii_awready <= maxio_awready;
  maxio_wdata   <= maxii_wdata;
  maxio_wstrb   <= maxii_wstrb;
  maxio_wlast   <= maxii_wlast;
  maxio_wuser   <= maxii_wuser;
  maxio_wvalid  <= maxii_wvalid;
  maxii_wready  <= maxio_wready;
  maxii_bid     <= maxio_bid;
  maxii_bresp   <= maxio_bresp;
  maxii_buser   <= maxio_buser;
  maxii_bvalid  <= maxio_bvalid;
  maxio_bready  <= maxii_bready;
  ----------------------------------------------------------------------------

end rtl;