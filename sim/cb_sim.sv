`timescale 1ps/1ps

module cb_sim;

import axi_vip_pkg::*;
import axi_vip_0_pkg::*;
import axi_vip_1_pkg::*;
import axil_vip_0_pkg::*;
//import axi_vip_slave_0_pkg::*;

    axi_vip_0_mst_t axi_master_agent;
    axil_vip_0_mst_t axil_master_agent;
    axi_vip_1_slv_t  axi_slave_agent;

    // write transaction created by master VIP
    axi_transaction                         wr_transaction;
    // read transaction created by master VIP
    axi_transaction                         rd_transaction;
    axi_transaction                         resp_transaction;


    bit clk, resetn, power_on, done;
    localparam init_thresh = 2000000000;
    localparam axil_addr_width = 32;
    localparam axil_data_width = 32;
    localparam axi_addr_width = 64;
    localparam axi_data_width = 512;
    localparam axi_id_width = 4;
    localparam axi_max_burst = 16;
    localparam axi_num_read_outstanding = 32;
    localparam axi_num_write_outstanding = 32;
    localparam axi_max_issuing = 4;
    localparam max_err_bits_per_bus = 8;
    localparam int unsigned NumWrites = 5000;  // How many writes per master
    localparam int unsigned NumReads  = 3000;  // How many reads per master

    localparam int unsigned addrOffset = 0;


    // timing parameters
    localparam time CyclTime = 10ns;
    localparam time ApplTime =  2ns;
    localparam time TestTime =  8ns;

    // Random Master Atomics
    localparam int unsigned MaxAW      = 32'd30;
    localparam int unsigned MaxAR      = 32'd30;
    localparam bit          EnAtop     = 1'b1;

    // ADDR value for WRITE/READ_BURST transaction
    xil_axi_ulong                           mADDR;
    // Burst Type value for WRITE/READ_BURST transaction
    xil_axi_burst_t                         mBurstType;
    // ID value for WRITE/READ_BURST transaction
    xil_axi_uint                            mID;
    // Burst Length value for WRITE/READ_BURST transaction
    xil_axi_len_t                           mBurstLength;
    // SIZE value for WRITE/READ_BURST transaction
    xil_axi_size_t                          mDataSize;
    // Awuser value for WRITE/READ_BURST transaction
    xil_axi_data_beat                       mAWUSER = 'h0;
    // Wuser value for WRITE/READ_BURST transaction
    xil_axi_data_beat [axi_data_width-1:0]               mWUSER;
    // Bresp value for WRITE/READ_BURST transaction
    xil_axi_resp_t                          mBresp;
    // Rresp value for WRITE/READ_BURST transaction
    xil_axi_resp_t[255:0]                   mRresp;
  // LOCK value for WRITE/READ_BURST transaction
    xil_axi_lock_t                          mLOCK;
    // Cache Type value for WRITE/READ_BURST transaction
    xil_axi_cache_t                         mCacheType = 0;
    // Protection Type value for WRITE/READ_BURST transaction
    xil_axi_prot_t                          mProtectionType = 3'b000;
    // Region value for WRITE/READ_BURST transaction
    xil_axi_region_t                        mRegion = 4'b000;
    // QOS value for WRITE/READ_BURST transaction
    xil_axi_qos_t                           mQOS = 4'b000;
    // Aruser value for WRITE/READ_BURST transaction
    xil_axi_data_beat                       mARUSER = 0;
    // Ruser value for WRITE/READ_BURST transaction
    xil_axi_data_beat [255:0]               mRUSER;

    bit [4095:0][7:0]                           mWData;
    bit [4095:0][7:0]                           mRData;


    logic [2:0] axi_awprot;
    logic [2:0] axi_arprot;

    //Axi write master in ports
    logic [axi_id_width-1:0] maxii_awid;
    //logic [axi_id_width-1:0] maxii_wid;
    logic [axi_addr_width-1:0] maxii_awaddr;
    logic [7:0] maxii_awlen;
    logic [2:0] maxii_awsize;
    logic [1:0] maxii_awburst;
    logic [3:0] maxii_awcache;
    logic [2:0] maxii_awprot;
    logic [3:0] maxii_awregion;

    logic [3:0] maxii_awqos;
    bit maxii_awvalid;
    bit maxii_awready;
    logic [axi_data_width-1:0] maxii_wdata;
    logic [axi_data_width/8-1:0] maxii_wstrb;
    bit maxii_wlast;
    bit maxii_wvalid;
    bit maxii_wready;
    logic [axi_id_width-1:0] maxii_bid;
    logic [1:0] maxii_bresp;
    bit maxii_bvalid;
    bit maxii_bready;

  //axi read master in ports
  logic [axi_id_width-1:0] maxii_arid;
  logic [axi_id_width-1:0] maxii_rid;
  logic [axi_addr_width-1:0] maxii_araddr;
  logic [7:0] maxii_arlen;
  logic [2:0]  maxii_arsize;
  logic [1:0]  maxii_arburst;
  bit maxii_arlock;
  logic [3:0]  maxii_arcache;
  logic [2:0]  maxii_arprot;
  logic [3:0] maxii_arregion;
  logic [3:0] maxii_arqos;
  bit maxii_arvalid;
  bit maxii_arready;
  logic [axi_data_width-1:0] maxii_rdata;
  logic [1:0] maxii_rresp;
  bit maxii_rlast;
  bit maxii_rvalid;
  bit maxii_rready;

//-------------------- AXI Lite Signals ----------------------------

  logic [31 : 0] m_axi_awaddr;
  logic [2 : 0] m_axi_awprot;
  bit m_axi_awvalid;
  bit m_axi_awready;
  logic [31 : 0] m_axi_wdata;
  logic [3 : 0] m_axi_wstrb;
  bit m_axi_wvalid;
  bit m_axi_wready;
  logic [1 : 0] m_axi_bresp;
  bit m_axi_bvalid;
  bit m_axi_bready;
  logic [31 : 0] m_axi_araddr;
  logic [2 : 0] m_axi_arprot;
  bit m_axi_arvalid;
  bit m_axi_arready;
  logic [31 : 0] m_axi_rdata;
  logic [1 : 0] m_axi_rresp;
  bit m_axi_rvalid;
  bit m_axi_rready;

//-------------------- AXI Lite Signals ----------------------------


  logic [3 : 0] s_axi_awid;
  logic [63 : 0] s_axi_awaddr;
  logic [7 : 0] s_axi_awlen;
  logic [2 : 0] s_axi_awsize;
  logic [1 : 0] s_axi_awburst;
  logic [0 : 0] s_axi_awlock;
  logic [3 : 0] s_axi_awcache;
  logic [2 : 0] s_axi_awprot;
  logic [3 : 0] s_axi_awregion;
  logic [3 : 0] s_axi_awqos;
  bit s_axi_awvalid;
  bit s_axi_awready;
  logic [511 : 0] s_axi_wdata;
  logic [63 : 0] s_axi_wstrb;
  bit s_axi_wlast;
  bit s_axi_wvalid;
  bit s_axi_wready;
  logic [1 : 0] s_axi_bresp;
  bit s_axi_bvalid;
  bit s_axi_bready;



    byte     memory[];

   //-------------------------------AXI SLAVE INTERFACES-------------------------------// 
axil_vip_0 #() axil_vip_master_dut 
(
  .aclk(clk),                    // input wire aclk
  .aresetn(resetn),              // input wire aresetn
  .m_axi_awaddr(m_axi_awaddr),    // output wire [31 : 0] m_axi_awaddr
  .m_axi_awprot(m_axi_awprot),    // output wire [2 : 0] m_axi_awprot
  .m_axi_awvalid(m_axi_awvalid),  // output wire m_axi_awvalid
  .m_axi_awready(m_axi_awready),  // input wire m_axi_awready
  .m_axi_wdata(m_axi_wdata),      // output wire [31 : 0] m_axi_wdata
  .m_axi_wstrb(m_axi_wstrb),      // output wire [3 : 0] m_axi_wstrb
  .m_axi_wvalid(m_axi_wvalid),    // output wire m_axi_wvalid
  .m_axi_wready(m_axi_wready),    // input wire m_axi_wready
  .m_axi_bresp(m_axi_bresp),      // input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid(m_axi_bvalid),    // input wire m_axi_bvalid
  .m_axi_bready(m_axi_bready),    // output wire m_axi_bready
  .m_axi_araddr(m_axi_araddr),    // output wire [31 : 0] m_axi_araddr
  .m_axi_arprot(m_axi_arprot),    // output wire [2 : 0] m_axi_arprot
  .m_axi_arvalid(m_axi_arvalid),  // output wire m_axi_arvalid
  .m_axi_arready(m_axi_arready),  // input wire m_axi_arready
  .m_axi_rdata(m_axi_rdata),      // input wire [31 : 0] m_axi_rdata
  .m_axi_rresp(m_axi_rresp),      // input wire [1 : 0] m_axi_rresp
  .m_axi_rvalid(m_axi_rvalid),    // input wire m_axi_rvalid
  .m_axi_rready(m_axi_rready)    // output wire m_axi_rready
);


axi_vip_0 #() axi_vip_master_dut
(
  .aclk(clk),
  .aresetn(resetn),
  .m_axi_awid(maxii_awid),
  //.m_axi_wid(maxii_wid),
  .m_axi_awaddr(maxii_awaddr),
  .m_axi_awlen(maxii_awlen),
  .m_axi_awsize(maxii_awsize),
  .m_axi_awburst(maxii_awburst),
  .m_axi_awcache(maxii_awcache),
  .m_axi_awprot(maxii_awprot),
  .m_axi_awregion(maxii_awregion),
  .m_axi_awqos(maxii_awqos),
  .m_axi_awvalid(maxii_awvalid),
  .m_axi_awready(maxii_awready),
  .m_axi_wdata(maxii_wdata),
  .m_axi_wstrb(maxii_wstrb),
  .m_axi_wlast(maxii_wlast),
  .m_axi_wvalid(maxii_wvalid),
  .m_axi_wready(maxii_wready),
  //.m_axi_bid(maxii_bid),
  .m_axi_bresp(maxii_bresp),
  .m_axi_bvalid(maxii_bvalid),
  .m_axi_bready(maxii_bready),

  //.m_axi_arid(maxii_arid),
  //.m_axi_rid(maxii_rid),
  .m_axi_araddr(maxii_araddr),
  .m_axi_arlen(maxii_arlen),
  .m_axi_arsize(maxii_arsize),
  .m_axi_arburst(maxii_arburst),
  .m_axi_arlock(maxii_arlock),
  .m_axi_arcache(maxii_arcache),
  .m_axi_arprot(maxii_arprot),
  .m_axi_arregion(maxii_arregion),
  .m_axi_arqos(maxii_arqos),
  .m_axi_arvalid(maxii_arvalid),
  .m_axi_arready(maxii_arready),
  .m_axi_rdata(maxii_rdata),
  .m_axi_rresp(maxii_rresp),
  .m_axi_rlast(maxii_rlast),
  .m_axi_rvalid(maxii_rvalid),
  .m_axi_rready(maxii_rready)
);


axi_vip_1 #() axi_vip_slave_dut (
  .aclk(clk),                       // input wire aclk
  .aresetn(resetn),                 // input wire aresetn
  .s_axi_awid(s_axi_awid),          // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr(s_axi_awaddr),      // input wire [63 : 0] s_axi_awaddr
  .s_axi_awlen(s_axi_awlen),        // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize(s_axi_awsize),      // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst(s_axi_awburst),    // input wire [1 : 0] s_axi_awburst
  .s_axi_awlock('h0),               // input wire [0 : 0] s_axi_awlock
  .s_axi_awcache(s_axi_awcache),    // input wire [3 : 0] s_axi_awcache
  .s_axi_awprot(s_axi_awprot),      // input wire [2 : 0] s_axi_awprot
  .s_axi_awregion(s_axi_awregion),  // input wire [3 : 0] s_axi_awregion
  .s_axi_awqos(s_axi_awqos),        // input wire [3 : 0] s_axi_awqos
  .s_axi_awvalid(s_axi_awvalid),    // input wire s_axi_awvalid
  .s_axi_awready(s_axi_awready),    // output wire s_axi_awready
  .s_axi_wdata(s_axi_wdata),        // input wire [511 : 0] s_axi_wdata
  .s_axi_wstrb(s_axi_wstrb),        // input wire [63 : 0] s_axi_wstrb
  .s_axi_wlast(s_axi_wlast),        // input wire s_axi_wlast
  .s_axi_wvalid(s_axi_wvalid),      // input wire s_axi_wvalid
  .s_axi_wready(s_axi_wready),      // output wire s_axi_wready
  .s_axi_bresp(s_axi_bresp),        // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid(s_axi_bvalid),      // output wire s_axi_bvalid
  .s_axi_bready(s_axi_bready),      // input wire s_axi_bready

  .s_axi_araddr(maxii_araddr),      // input wire [63 : 0] s_axi_araddr
  .s_axi_arlen(maxii_arlen),        // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize(maxii_arsize),      // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst(maxii_arburst),    // input wire [1 : 0] s_axi_arburst
  .s_axi_arlock(maxii_arlock),      // input wire [0 : 0] s_axi_arlock
  .s_axi_arcache(maxii_arcache),    // input wire [3 : 0] s_axi_arcache
  .s_axi_arprot(maxii_arprot),      // input wire [2 : 0] s_axi_arprot
  .s_axi_arregion(maxii_arregion),  // input wire [3 : 0] s_axi_arregion
  .s_axi_arqos(maxii_arqos),        // input wire [3 : 0] s_axi_arqos
  .s_axi_arvalid(maxii_arvalid),    // input wire s_axi_arvalid
  .s_axi_arready(maxii_arready),    // output wire s_axi_arready
  .s_axi_rdata(maxii_rdata),        // output wire [511 : 0] s_axi_rdata
  .s_axi_rresp(maxii_rresp),        // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast(maxii_rlast),        // output wire s_axi_rlast
  .s_axi_rvalid(maxii_rvalid),      // output wire s_axi_rvalid
  .s_axi_rready(maxii_rready)      // input wire s_axi_rready
);


cb_top #( .AXI_RUSER_WIDTH (0),
          .AXI_ARUSER_WIDTH(0),
          .AXI_WUSER_WIDTH (0),
          .AXI_AWUSER_WIDTH(0),
          .AXI_BUSER_WIDTH (0),
          .AXI_ID_WIDTH    (axi_id_width),
          .AXI_DATA_WIDTH  (axi_data_width),
          .AXI_ADDR_WIDTH  (axi_addr_width),
          .AXIL_ADDR_WIDTH (axil_addr_width),
          .AXIL_DATA_WIDTH (axil_data_width)
  ) cp_top_dut
  (
    .axil_aclk(clk),
    .axil_aresetn(resetn),
    .axil_awaddr(m_axi_awaddr),
    .axil_awprot(m_axi_awprot),
    .axil_awvalid(m_axi_awvalid),
    .axil_awready(m_axi_awready),
    .axil_wdata(m_axi_wdata),
    .axil_wstrb(m_axi_wstrb),
    .axil_wvalid(m_axi_wvalid),
    .axil_wready(m_axi_wready),
    .axil_bresp(m_axi_bresp),
    .axil_bvalid(m_axi_bvalid),
    .axil_bready(m_axi_bready),
    .axil_araddr(m_axi_araddr),
    .axil_arprot(m_axi_arprot),
    .axil_arvalid(m_axi_arvalid),
    .axil_arready(m_axi_arready),
    .axil_rdata(m_axi_rdata),
    .axil_rresp(m_axi_rresp),
    .axil_rvalid(m_axi_rvalid),
    .axil_rready(m_axi_rready),

       // AXI4-MM Write Master In
        .maxii_awid(maxii_awid),
        //.maxii_wid(maxii_wid),
        .maxii_awaddr(maxii_awaddr),
        .maxii_awlen(maxii_awlen),
        .maxii_awsize(maxii_awsize),
        .maxii_awburst(maxii_awburst),
        .maxii_awlock('h0), //not in VIP?
        .maxii_awcache(maxii_awcache),
        .maxii_awprot(maxii_awprot),
        .maxii_awqos(maxii_awqos),
        .maxii_awregion(maxii_awregion),
        //.maxii_awuser(4'h0), //not in VIP?
        .maxii_awvalid(maxii_awvalid),
        .maxii_awready(maxii_awready),
        .maxii_wdata(maxii_wdata),
        .maxii_wstrb(maxii_wstrb),
        .maxii_wlast(maxii_wlast),
        //.maxii_wuser(open), //not in VIP?
        .maxii_wvalid(maxii_wvalid),
        .maxii_wready(maxii_wready),
        .maxii_bid(maxii_bid),
        .maxii_bresp(maxii_bresp),
        //.maxii_buser(open), //not in VIP?
        .maxii_bvalid(maxii_bvalid),
        .maxii_bready(maxii_bready),

        // AXI4-MM Write Master Out to slave

        .maxio_awid(s_axi_awid),
        //.maxio_wid(s_axi_wid),
        .maxio_awaddr(s_axi_awaddr),
        .maxio_awlen(s_axi_awlen),
        .maxio_awsize(s_axi_awsize),
        .maxio_awburst(s_axi_awburst),
        .maxio_awvalid(s_axi_awvalid),
        .maxio_awcache(s_axi_awcache),
        .maxio_awprot(s_axi_awprot),
        .maxio_awregion(s_axi_awregion),
        .maxio_awready(s_axi_awready),
        .maxio_wdata(s_axi_wdata),
        .maxio_wlast(s_axi_wlast),
        .maxio_wvalid(s_axi_wvalid),
        .maxio_wready(s_axi_wready),
        .maxio_bresp(s_axi_bresp),
        .maxio_bvalid(s_axi_bvalid),
        .maxio_bready(s_axi_bready),
        .maxio_wstrb(s_axi_wstrb),

        //.maxio_awlock(maxio_awlock),
        .maxio_awqos(s_axi_awqos)
        //.maxio_bid(s_axi_bid)
    );



   task clock;
    while (done != 1'b1)
    begin
     clk <= 1'b1;
     #4000;
     clk <= 1'b0;
     #4000;
    end
   endtask // clock

   task reset;
      resetn   <= 1'b0;
    #1000000;
    @(posedge clk);
    resetn <= 1'b1;
   endtask // reset

   task axi_master;
      int err = 0;

      for(int i=0;i<4096;i++) begin
        mWData[i] = 0;
        mRData[i] = 0;
      end

      axi_master_agent = new("master vip agent", axi_vip_master_dut.inst.IF);
      axi_master_agent.set_agent_tag("Master VIP");
      axi_master_agent.set_verbosity(400);
      axi_master_agent.start_master();
      axi_slave_agent = new("slave vip agent", axi_vip_slave_dut.inst.IF);
      axi_slave_agent.set_agent_tag("Slave VIP");
      axi_slave_agent.set_verbosity(400);
      axi_slave_agent.start_slave();
      axil_master_agent = new("axi lite master vip agent", axil_vip_master_dut.inst.IF);
      axil_master_agent.set_agent_tag("AXI Lite Master VIP");
      axil_master_agent.set_verbosity(400);
      axil_master_agent.start_master();

      mADDR = addrOffset;
      mBurstType = XIL_AXI_BURST_TYPE_INCR;
      mID = 3;
      mBurstLength = 0;
      mDataSize = XIL_AXI_SIZE_64BYTE;
      // Awuser value for WRITE/READ_BURST transaction
      mAWUSER = 'h0;
      // generate mWData
      for(int i = 0; i < 4096; i++) begin
        mWData[i] = 'hff; //$urandom_range(0, 255);
      end
      mLOCK = XIL_AXI_ALOCK_NOLOCK;
      mCacheType = 0;
      mProtectionType = 0;
      mRegion = 0;
      mQOS = 0;
      for(int i = 0; i < 512;i++) begin
        mWUSER = i%2;
      end
      for(int i = 0; i < 512;i++) begin
        mRUSER = 'h0;
      end
      
      //reset the accumulation registers prior to issuing data transfer for accurate results
      axil_master_agent.AXI4LITE_WRITE_BURST(4, mProtectionType, 1, mBresp);
      axil_master_agent.AXI4LITE_WRITE_BURST(4, mProtectionType, 0, mBresp);

      for(int b = 0; b < 128;b++) begin
        axi_master_agent.AXI4_WRITE_BURST(mID,mADDR,mBurstLength,mDataSize,mBurstType,mLOCK,mCacheType,mProtectionType,mRegion,mQOS,mAWUSER,mWData,mWUSER,mBresp);
        axi_master_agent.AXI4_READ_BURST(mID,mADDR,mBurstLength,mDataSize,mBurstType,mLOCK,mCacheType,mProtectionType,mRegion,mQOS,mARUSER,mRData,mRresp,mRUSER);
      end

      //clear when finished
      axil_master_agent.AXI4LITE_WRITE_BURST(4, mProtectionType, 1, mBresp);
      axil_master_agent.AXI4LITE_WRITE_BURST(4, mProtectionType, 0, mBresp);
 
      done = 1'b1;
   endtask //axi_master


initial
   begin

    memory   = new[1 << 20];
    power_on = 1'b0;
    done     = 1'b0;
    //memory_fill;
    fork
     clock;
     reset;
     axi_master;
   join;
    $display("@%g Simulation End", $time);
    #1000;
    $finish();
   end

endmodule