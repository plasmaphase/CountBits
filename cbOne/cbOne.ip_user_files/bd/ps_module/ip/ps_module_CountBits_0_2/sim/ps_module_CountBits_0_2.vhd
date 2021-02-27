-- (c) Copyright 1995-2021 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: markwgilson.com:lib:CountBits:1.0
-- IP Revision: 8

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ps_module_CountBits_0_2 IS
  PORT (
    axil_aclk : IN STD_LOGIC;
    axil_aresetn : IN STD_LOGIC;
    axil_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    axil_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    axil_awvalid : IN STD_LOGIC;
    axil_awready : OUT STD_LOGIC;
    axil_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    axil_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    axil_wvalid : IN STD_LOGIC;
    axil_wready : OUT STD_LOGIC;
    axil_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    axil_bvalid : OUT STD_LOGIC;
    axil_bready : IN STD_LOGIC;
    axil_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    axil_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    axil_arvalid : IN STD_LOGIC;
    axil_arready : OUT STD_LOGIC;
    axil_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    axil_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    axil_rvalid : OUT STD_LOGIC;
    axil_rready : IN STD_LOGIC;
    maxii_awid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxii_awaddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    maxii_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    maxii_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    maxii_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    maxii_awlock : IN STD_LOGIC;
    maxii_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxii_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    maxii_awqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxii_awregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxii_awuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    maxii_awvalid : IN STD_LOGIC;
    maxii_awready : OUT STD_LOGIC;
    maxii_wdata : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
    maxii_wstrb : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
    maxii_wlast : IN STD_LOGIC;
    maxii_wuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    maxii_wvalid : IN STD_LOGIC;
    maxii_wready : OUT STD_LOGIC;
    maxii_bid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxii_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    maxii_buser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    maxii_bvalid : OUT STD_LOGIC;
    maxii_bready : IN STD_LOGIC;
    maxio_awid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxio_awaddr : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    maxio_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    maxio_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    maxio_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    maxio_awlock : OUT STD_LOGIC;
    maxio_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxio_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    maxio_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxio_awregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxio_awuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    maxio_awvalid : OUT STD_LOGIC;
    maxio_awready : IN STD_LOGIC;
    maxio_wdata : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
    maxio_wstrb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
    maxio_wlast : OUT STD_LOGIC;
    maxio_wuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    maxio_wvalid : OUT STD_LOGIC;
    maxio_wready : IN STD_LOGIC;
    maxio_bid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    maxio_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    maxio_buser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    maxio_bvalid : IN STD_LOGIC;
    maxio_bready : OUT STD_LOGIC
  );
END ps_module_CountBits_0_2;

ARCHITECTURE ps_module_CountBits_0_2_arch OF ps_module_CountBits_0_2 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF ps_module_CountBits_0_2_arch: ARCHITECTURE IS "yes";
  COMPONENT cb_top IS
    GENERIC (
      AXI_RUSER_WIDTH : INTEGER;
      AXI_ARUSER_WIDTH : INTEGER;
      AXI_WUSER_WIDTH : INTEGER;
      AXI_AWUSER_WIDTH : INTEGER;
      AXI_BUSER_WIDTH : INTEGER;
      AXI_ID_WIDTH : INTEGER;
      AXI_DATA_WIDTH : INTEGER;
      AXI_ADDR_WIDTH : INTEGER;
      AXIL_ADDR_WIDTH : INTEGER;
      AXIL_DATA_WIDTH : INTEGER
    );
    PORT (
      axil_aclk : IN STD_LOGIC;
      axil_aresetn : IN STD_LOGIC;
      axil_awaddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      axil_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      axil_awvalid : IN STD_LOGIC;
      axil_awready : OUT STD_LOGIC;
      axil_wdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      axil_wstrb : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      axil_wvalid : IN STD_LOGIC;
      axil_wready : OUT STD_LOGIC;
      axil_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      axil_bvalid : OUT STD_LOGIC;
      axil_bready : IN STD_LOGIC;
      axil_araddr : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      axil_arprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      axil_arvalid : IN STD_LOGIC;
      axil_arready : OUT STD_LOGIC;
      axil_rdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      axil_rresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      axil_rvalid : OUT STD_LOGIC;
      axil_rready : IN STD_LOGIC;
      maxii_awid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxii_awaddr : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      maxii_awlen : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
      maxii_awsize : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      maxii_awburst : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      maxii_awlock : IN STD_LOGIC;
      maxii_awcache : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxii_awprot : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
      maxii_awqos : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxii_awregion : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxii_awuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      maxii_awvalid : IN STD_LOGIC;
      maxii_awready : OUT STD_LOGIC;
      maxii_wdata : IN STD_LOGIC_VECTOR(511 DOWNTO 0);
      maxii_wstrb : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
      maxii_wlast : IN STD_LOGIC;
      maxii_wuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      maxii_wvalid : IN STD_LOGIC;
      maxii_wready : OUT STD_LOGIC;
      maxii_bid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxii_bresp : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      maxii_buser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      maxii_bvalid : OUT STD_LOGIC;
      maxii_bready : IN STD_LOGIC;
      maxio_awid : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxio_awaddr : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      maxio_awlen : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      maxio_awsize : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      maxio_awburst : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
      maxio_awlock : OUT STD_LOGIC;
      maxio_awcache : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxio_awprot : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
      maxio_awqos : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxio_awregion : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxio_awuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      maxio_awvalid : OUT STD_LOGIC;
      maxio_awready : IN STD_LOGIC;
      maxio_wdata : OUT STD_LOGIC_VECTOR(511 DOWNTO 0);
      maxio_wstrb : OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
      maxio_wlast : OUT STD_LOGIC;
      maxio_wuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
      maxio_wvalid : OUT STD_LOGIC;
      maxio_wready : IN STD_LOGIC;
      maxio_bid : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
      maxio_bresp : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
      maxio_buser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
      maxio_bvalid : IN STD_LOGIC;
      maxio_bready : OUT STD_LOGIC
    );
  END COMPONENT cb_top;
  ATTRIBUTE IP_DEFINITION_SOURCE : STRING;
  ATTRIBUTE IP_DEFINITION_SOURCE OF ps_module_CountBits_0_2_arch: ARCHITECTURE IS "package_project";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_PARAMETER : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF maxio_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_buser: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio BUSER";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_bid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio BID";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_wuser: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio WUSER";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_wlast: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio WLAST";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awuser: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWUSER";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awregion: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWREGION";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awqos: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWQOS";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWPROT";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awcache: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWCACHE";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awlock: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWLOCK";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awburst: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWBURST";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awsize: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWSIZE";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awlen: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWLEN";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWADDR";
  ATTRIBUTE X_INTERFACE_PARAMETER OF maxio_awid: SIGNAL IS "XIL_INTERFACENAME maxio, DATA_WIDTH 512, PROTOCOL AXI4, ID_WIDTH 4, ADDR_WIDTH 64, AWUSER_WIDTH 1, ARUSER_WIDTH 0, WUSER_WIDTH 1, RUSER_WIDTH 0, BUSER_WIDTH 1, READ_WRITE_MODE WRITE_ONLY, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.000, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, IN" & 
"SERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF maxio_awid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxio AWID";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_buser: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii BUSER";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_bid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii BID";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_wuser: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii WUSER";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_wlast: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii WLAST";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awuser: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWUSER";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awregion: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWREGION";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awqos: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWQOS";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWPROT";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awcache: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWCACHE";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awlock: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWLOCK";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awburst: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWBURST";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awsize: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWSIZE";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awlen: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWLEN";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWADDR";
  ATTRIBUTE X_INTERFACE_PARAMETER OF maxii_awid: SIGNAL IS "XIL_INTERFACENAME maxii, DATA_WIDTH 512, PROTOCOL AXI4, ID_WIDTH 4, ADDR_WIDTH 64, AWUSER_WIDTH 1, ARUSER_WIDTH 0, WUSER_WIDTH 1, RUSER_WIDTH 0, BUSER_WIDTH 1, READ_WRITE_MODE WRITE_ONLY, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 1, HAS_REGION 1, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 0, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.000, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, IN" & 
"SERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF maxii_awid: SIGNAL IS "xilinx.com:interface:aximm:1.0 maxii AWID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_rready: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil RREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_rvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil RVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_rresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil RRESP";
  ATTRIBUTE X_INTERFACE_INFO OF axil_rdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil RDATA";
  ATTRIBUTE X_INTERFACE_INFO OF axil_arready: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil ARREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_arvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil ARVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_arprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil ARPROT";
  ATTRIBUTE X_INTERFACE_INFO OF axil_araddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil ARADDR";
  ATTRIBUTE X_INTERFACE_INFO OF axil_bready: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil BREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_bvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil BVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_bresp: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil BRESP";
  ATTRIBUTE X_INTERFACE_INFO OF axil_wready: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil WREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_wvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil WVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_wstrb: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil WSTRB";
  ATTRIBUTE X_INTERFACE_INFO OF axil_wdata: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil WDATA";
  ATTRIBUTE X_INTERFACE_INFO OF axil_awready: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil AWREADY";
  ATTRIBUTE X_INTERFACE_INFO OF axil_awvalid: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil AWVALID";
  ATTRIBUTE X_INTERFACE_INFO OF axil_awprot: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil AWPROT";
  ATTRIBUTE X_INTERFACE_PARAMETER OF axil_awaddr: SIGNAL IS "XIL_INTERFACENAME axil, DATA_WIDTH 32, PROTOCOL AXI4LITE, ID_WIDTH 0, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 0, NUM_READ_OUTSTANDING 1, NUM_WRITE_OUTSTANDING 1, MAX_BURST_LENGTH 1, PHASE 0.000, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, IN" & 
"SERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF axil_awaddr: SIGNAL IS "xilinx.com:interface:aximm:1.0 axil AWADDR";
  ATTRIBUTE X_INTERFACE_PARAMETER OF axil_aresetn: SIGNAL IS "XIL_INTERFACENAME axil_aresetn, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF axil_aresetn: SIGNAL IS "xilinx.com:signal:reset:1.0 axil_aresetn RST";
  ATTRIBUTE X_INTERFACE_PARAMETER OF axil_aclk: SIGNAL IS "XIL_INTERFACENAME axil_aclk, ASSOCIATED_BUSIF axil:maxii:maxio, ASSOCIATED_RESET axil_aresetn, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0";
  ATTRIBUTE X_INTERFACE_INFO OF axil_aclk: SIGNAL IS "xilinx.com:signal:clock:1.0 axil_aclk CLK";
BEGIN
  U0 : cb_top
    GENERIC MAP (
      AXI_RUSER_WIDTH => 0,
      AXI_ARUSER_WIDTH => 0,
      AXI_WUSER_WIDTH => 0,
      AXI_AWUSER_WIDTH => 0,
      AXI_BUSER_WIDTH => 0,
      AXI_ID_WIDTH => 4,
      AXI_DATA_WIDTH => 512,
      AXI_ADDR_WIDTH => 64,
      AXIL_ADDR_WIDTH => 32,
      AXIL_DATA_WIDTH => 32
    )
    PORT MAP (
      axil_aclk => axil_aclk,
      axil_aresetn => axil_aresetn,
      axil_awaddr => axil_awaddr,
      axil_awprot => axil_awprot,
      axil_awvalid => axil_awvalid,
      axil_awready => axil_awready,
      axil_wdata => axil_wdata,
      axil_wstrb => axil_wstrb,
      axil_wvalid => axil_wvalid,
      axil_wready => axil_wready,
      axil_bresp => axil_bresp,
      axil_bvalid => axil_bvalid,
      axil_bready => axil_bready,
      axil_araddr => axil_araddr,
      axil_arprot => axil_arprot,
      axil_arvalid => axil_arvalid,
      axil_arready => axil_arready,
      axil_rdata => axil_rdata,
      axil_rresp => axil_rresp,
      axil_rvalid => axil_rvalid,
      axil_rready => axil_rready,
      maxii_awid => maxii_awid,
      maxii_awaddr => maxii_awaddr,
      maxii_awlen => maxii_awlen,
      maxii_awsize => maxii_awsize,
      maxii_awburst => maxii_awburst,
      maxii_awlock => maxii_awlock,
      maxii_awcache => maxii_awcache,
      maxii_awprot => maxii_awprot,
      maxii_awqos => maxii_awqos,
      maxii_awregion => maxii_awregion,
      maxii_awuser => maxii_awuser,
      maxii_awvalid => maxii_awvalid,
      maxii_awready => maxii_awready,
      maxii_wdata => maxii_wdata,
      maxii_wstrb => maxii_wstrb,
      maxii_wlast => maxii_wlast,
      maxii_wuser => maxii_wuser,
      maxii_wvalid => maxii_wvalid,
      maxii_wready => maxii_wready,
      maxii_bid => maxii_bid,
      maxii_bresp => maxii_bresp,
      maxii_buser => maxii_buser,
      maxii_bvalid => maxii_bvalid,
      maxii_bready => maxii_bready,
      maxio_awid => maxio_awid,
      maxio_awaddr => maxio_awaddr,
      maxio_awlen => maxio_awlen,
      maxio_awsize => maxio_awsize,
      maxio_awburst => maxio_awburst,
      maxio_awlock => maxio_awlock,
      maxio_awcache => maxio_awcache,
      maxio_awprot => maxio_awprot,
      maxio_awqos => maxio_awqos,
      maxio_awregion => maxio_awregion,
      maxio_awuser => maxio_awuser,
      maxio_awvalid => maxio_awvalid,
      maxio_awready => maxio_awready,
      maxio_wdata => maxio_wdata,
      maxio_wstrb => maxio_wstrb,
      maxio_wlast => maxio_wlast,
      maxio_wuser => maxio_wuser,
      maxio_wvalid => maxio_wvalid,
      maxio_wready => maxio_wready,
      maxio_bid => maxio_bid,
      maxio_bresp => maxio_bresp,
      maxio_buser => maxio_buser,
      maxio_bvalid => maxio_bvalid,
      maxio_bready => maxio_bready
    );
END ps_module_CountBits_0_2_arch;
