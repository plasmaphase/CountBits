`timescale 1ps/1ps

module cb_sim;

import axi_vip_pkg::*;
import axi_vip_0_pkg::*;
import axi_vip_1_pkg::*;
import axil_vip_0_pkg::*;

    axi_vip_0_mst_t axi_master_agent;
    axil_vip_0_mst_t axil_master_agent;
    axi_vip_1_slv_t  axi_slave_agent;

    // write transaction created by master VIP
    axi_transaction                         wr_transaction;


    typedef struct packed
    {
      logic [30:0] rsvd;
      bit clear_regs;
    } control_reg_t;

    typedef struct packed
    {
      logic [63:0][31:0] byte_bits_regs;
      logic [15:0][31:0] word_bits_regs;
      logic [31:0] total_bits_reg;
      control_reg_t control_reg;
      logic [31:0] revision_reg;
    } count_bit_regs_t;

    typedef union packed
    {
      logic[82:0][31:0] dword;
      count_bit_regs_t count_regs;
    } c_regs_u;


    bit clk, resetn, power_on, done;
    localparam axil_addr_width = 32;
    localparam axil_data_width = 32;
    localparam axi_addr_width = 64;
    localparam axi_data_width = 512;
    localparam axi_id_width = 4;

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

    c_regs_u c_regs;


//-------------------- AXI Master Signals (write input to Count Bits) ----------------------------
  wire [3 : 0] mwi_axi_awid;
  wire [63 : 0] mwi_axi_awaddr;
  wire [7 : 0] mwi_axi_awlen;
  wire [2 : 0] mwi_axi_awsize;
  wire [1 : 0] mwi_axi_awburst;
  wire [0 : 0] mwi_axi_awlock;
  wire [3 : 0] mwi_axi_awcache;
  wire [2 : 0] mwi_axi_awprot;
  wire [3 : 0] mwi_axi_awregion;
  wire [3 : 0] mwi_axi_awqos;
  wire mwi_axi_awvalid;
  wire mwi_axi_awready;
  wire [511 : 0] mwi_axi_wdata;
  wire [63 : 0] mwi_axi_wstrb;
  wire mwi_axi_wlast;
  wire mwi_axi_wvalid;
  wire mwi_axi_wready;
  wire [3 : 0] mwi_axi_bid;
  wire [1 : 0] mwi_axi_bresp;
  wire mwi_axi_bvalid;
  wire mwi_axi_bready;
  //-------------------- AXI Master Signals (write ouput from Count Bits) ----------------------------
  wire [3 : 0] mwo_axi_awid;
  wire [63 : 0] mwo_axi_awaddr;
  wire [7 : 0] mwo_axi_awlen;
  wire [2 : 0] mwo_axi_awsize;
  wire [1 : 0] mwo_axi_awburst;
  wire [0 : 0] mwo_axi_awlock;
  wire [3 : 0] mwo_axi_awcache;
  wire [2 : 0] mwo_axi_awprot;
  wire [3 : 0] mwo_axi_awregion;
  wire [3 : 0] mwo_axi_awqos;
  wire mwo_axi_awvalid;
  wire mwo_axi_awready;
  wire [511 : 0] mwo_axi_wdata;
  wire [63 : 0] mwo_axi_wstrb;
  wire mwo_axi_wlast;
  wire mwo_axi_wvalid;
  wire mwo_axi_wready;
  wire [3 : 0] mwo_axi_bid;
  wire [1 : 0] mwo_axi_bresp;
  wire mwo_axi_bvalid;
  wire mwo_axi_bready;

//-------------------- AXI Master Signals (read, bypassing count bits) ----------------------------
  wire [3 : 0] mr_axi_arid;
  wire [63 : 0] mr_axi_araddr;
  wire [7 : 0] mr_axi_arlen;
  wire [2 : 0] mr_axi_arsize;
  wire [1 : 0] mr_axi_arburst;
  wire [0 : 0] mr_axi_arlock;
  wire [3 : 0] mr_axi_arcache;
  wire [2 : 0] mr_axi_arprot;
  wire [3 : 0] mr_axi_arregion;
  wire [3 : 0] mr_axi_arqos;
  wire mr_axi_arvalid;
  wire mr_axi_arready;
  wire [3 : 0] mr_axi_rid;
  wire [511 : 0] mr_axi_rdata;
  wire [1 : 0] mr_axi_rresp;
  wire mr_axi_rlast;
  wire mr_axi_rvalid;
  wire mr_axi_rready;

//-------------------- AXI Lite Signals ------------------------------

 wire [31 : 0] m_axil_awaddr;
 wire [2 : 0] m_axil_awprot;
 wire m_axil_awvalid;
 wire m_axil_awready;
 wire [31 : 0] m_axil_wdata;
 wire [3 : 0] m_axil_wstrb;
 wire m_axil_wvalid;
 wire m_axil_wready;
 wire [1 : 0] m_axil_bresp;
 wire m_axil_bvalid;
 wire m_axil_bready;
 wire [31 : 0] m_axil_araddr;
 wire [2 : 0] m_axil_arprot;
 wire m_axil_arvalid;
 wire m_axil_arready;
 wire [31 : 0] m_axil_rdata;
 wire [1 : 0] m_axil_rresp;
 wire m_axil_rvalid;
 wire m_axil_rready;



    byte     memory[];

//------------------------------- AXI LITE INSTANCE -------------------------------//
axil_vip_0 #() axil_vip_master_dut
(
  .aclk(clk),
  .aresetn(resetn),
  .m_axi_awaddr(m_axil_awaddr),
  .m_axi_awprot(m_axil_awprot),
  .m_axi_awvalid(m_axil_awvalid),
  .m_axi_awready(m_axil_awready),
  .m_axi_wdata(m_axil_wdata),
  .m_axi_wstrb(m_axil_wstrb),
  .m_axi_wvalid(m_axil_wvalid),
  .m_axi_wready(m_axil_wready),
  .m_axi_bresp(m_axil_bresp),
  .m_axi_bvalid(m_axil_bvalid),
  .m_axi_bready(m_axil_bready),
  .m_axi_araddr(m_axil_araddr),
  .m_axi_arprot(m_axil_arprot),
  .m_axi_arvalid(m_axil_arvalid),
  .m_axi_arready(m_axil_arready),
  .m_axi_rdata(m_axil_rdata),
  .m_axi_rresp(m_axil_rresp),
  .m_axi_rvalid(m_axil_rvalid),
  .m_axi_rready(m_axil_rready)
);

//------------------------------- AXI MASTER INSTANCE -------------------------------//
axi_vip_0 axi_vip_master_dut (
  .aclk(clk),
  .aresetn(resetn),
  .m_axi_awid(mwi_axi_awid),
  .m_axi_awaddr(mwi_axi_awaddr),
  .m_axi_awlen(mwi_axi_awlen),
  .m_axi_awsize(mwi_axi_awsize),
  .m_axi_awburst(mwi_axi_awburst),
  .m_axi_awlock(mwi_axi_awlock),
  .m_axi_awcache(mwi_axi_awcache),
  .m_axi_awprot(mwi_axi_awprot),
  .m_axi_awregion(mwi_axi_awregion),
  .m_axi_awqos(mwi_axi_awqos),
  .m_axi_awvalid(mwi_axi_awvalid),
  .m_axi_awready(mwi_axi_awready),
  .m_axi_wdata(mwi_axi_wdata),
  .m_axi_wstrb(mwi_axi_wstrb),
  .m_axi_wlast(mwi_axi_wlast),
  .m_axi_wvalid(mwi_axi_wvalid),
  .m_axi_wready(mwi_axi_wready),
  .m_axi_bid(mwi_axi_bid),
  .m_axi_bresp(mwi_axi_bresp),
  .m_axi_bvalid(mwi_axi_bvalid),
  .m_axi_bready(mwi_axi_bready),

  .m_axi_arid(mr_axi_arid),
  .m_axi_araddr(mr_axi_araddr),
  .m_axi_arlen(mr_axi_arlen),
  .m_axi_arsize(mr_axi_arsize),
  .m_axi_arburst(mr_axi_arburst),
  .m_axi_arlock(mr_axi_arlock),
  .m_axi_arcache(mr_axi_arcache),
  .m_axi_arprot(mr_axi_arprot),
  .m_axi_arregion(mr_axi_arregion),
  .m_axi_arqos(mr_axi_arqos),
  .m_axi_arvalid(mr_axi_arvalid),
  .m_axi_arready(mr_axi_arready),
  .m_axi_rid(mr_axi_rid),
  .m_axi_rdata(mr_axi_rdata),
  .m_axi_rresp(mr_axi_rresp),
  .m_axi_rlast(mr_axi_rlast),
  .m_axi_rvalid(mr_axi_rvalid),
  .m_axi_rready(mr_axi_rready)
);

//------------------------------- AXI SLAVE INSTANCE -------------------------------//

axi_vip_1 axi_vip_slave_dut (
  .aclk(clk),
  .aresetn(resetn),
  .s_axi_awid(mwo_axi_awid),
  .s_axi_awaddr(mwo_axi_awaddr),
  .s_axi_awlen(mwo_axi_awlen),
  .s_axi_awsize(mwo_axi_awsize),
  .s_axi_awburst(mwo_axi_awburst),
  .s_axi_awlock('h0),
  .s_axi_awcache(mwo_axi_awcache),
  .s_axi_awprot(mwo_axi_awprot),
  .s_axi_awregion(mwo_axi_awregion),
  .s_axi_awqos(mwo_axi_awqos),
  .s_axi_awvalid(mwo_axi_awvalid),
  .s_axi_awready(mwo_axi_awready),
  .s_axi_wdata(mwo_axi_wdata),
  .s_axi_wstrb(mwo_axi_wstrb),
  .s_axi_wlast(mwo_axi_wlast),
  .s_axi_wvalid(mwo_axi_wvalid),
  .s_axi_wready(mwo_axi_wready),
  .s_axi_bid(mwo_axi_bid),
  .s_axi_bresp(mwo_axi_bresp),
  .s_axi_bvalid(mwo_axi_bvalid),
  .s_axi_bready(mwo_axi_bready),

  .s_axi_arid(mr_axi_arid),
  .s_axi_araddr(mr_axi_araddr),
  .s_axi_arlen(mr_axi_arlen),
  .s_axi_arsize(mr_axi_arsize),
  .s_axi_arburst(mr_axi_arburst),
  .s_axi_arlock('h0),
  .s_axi_arcache(mr_axi_arcache),
  .s_axi_arprot(mr_axi_arprot),
  .s_axi_arregion(mr_axi_arregion),
  .s_axi_arqos(mr_axi_arqos),
  .s_axi_arvalid(mr_axi_arvalid),
  .s_axi_arready(mr_axi_arready),
  .s_axi_rid(mr_axi_rid),
  .s_axi_rdata(mr_axi_rdata),
  .s_axi_rresp(mr_axi_rresp),
  .s_axi_rlast(mr_axi_rlast),
  .s_axi_rvalid(mr_axi_rvalid),
  .s_axi_rready(mr_axi_rready)
);

//------------------------------- COUNT BITS INSTANCE -------------------------------//
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
    .axil_awaddr(m_axil_awaddr),
    .axil_awprot(m_axil_awprot),
    .axil_awvalid(m_axil_awvalid),
    .axil_awready(m_axil_awready),
    .axil_wdata(m_axil_wdata),
    .axil_wstrb(m_axil_wstrb),
    .axil_wvalid(m_axil_wvalid),
    .axil_wready(m_axil_wready),
    .axil_bresp(m_axil_bresp),
    .axil_bvalid(m_axil_bvalid),
    .axil_bready(m_axil_bready),
    .axil_araddr(m_axil_araddr),
    .axil_arprot(m_axil_arprot),
    .axil_arvalid(m_axil_arvalid),
    .axil_arready(m_axil_arready),
    .axil_rdata(m_axil_rdata),
    .axil_rresp(m_axil_rresp),
    .axil_rvalid(m_axil_rvalid),
    .axil_rready(m_axil_rready),

       // AXI4-MM Write Master In
        .maxii_awid(mwi_axi_awid),
        .maxii_awaddr(mwi_axi_awaddr),
        .maxii_awlen(mwi_axi_awlen),
        .maxii_awsize(mwi_axi_awsize),
        .maxii_awburst(mwi_axi_awburst),
        .maxii_awlock('h0),
        .maxii_awcache(mwi_axi_awcache),
        .maxii_awprot(mwi_axi_awprot),
        .maxii_awqos(mwi_axi_awqos),
        .maxii_awregion(mwi_axi_awregion),
        .maxii_awvalid(mwi_axi_awvalid),
        .maxii_awready(mwi_axi_awready),
        .maxii_wdata(mwi_axi_wdata),
        .maxii_wstrb(mwi_axi_wstrb),
        .maxii_wlast(mwi_axi_wlast),
        .maxii_wvalid(mwi_axi_wvalid),
        .maxii_wready(mwi_axi_wready),
        .maxii_bid(mwi_axi_bid),
        .maxii_bresp(mwi_axi_bresp),
        .maxii_bvalid(mwi_axi_bvalid),
        .maxii_bready(mwi_axi_bready),

        // AXI4-MM Write Master Out to slave
        .maxio_awid(mwo_axi_awid),
        .maxio_awaddr(mwo_axi_awaddr),
        .maxio_awlen(mwo_axi_awlen),
        .maxio_awsize(mwo_axi_awsize),
        .maxio_awburst(mwo_axi_awburst),
        .maxio_awvalid(mwo_axi_awvalid),
        .maxio_awcache(mwo_axi_awcache),
        .maxio_awprot(mwo_axi_awprot),
        .maxio_awregion(mwo_axi_awregion),
        .maxio_awready(mwo_axi_awready),
        .maxio_wdata(mwo_axi_wdata),
        .maxio_wlast(mwo_axi_wlast),
        .maxio_wvalid(mwo_axi_wvalid),
        .maxio_wready(mwo_axi_wready),
        .maxio_bresp(mwo_axi_bresp),
        .maxio_bvalid(mwo_axi_bvalid),
        .maxio_bready(mwo_axi_bready),
        .maxio_wstrb(mwo_axi_wstrb),
        .maxio_awqos(mwo_axi_awqos),
        .maxio_bid(mwo_axi_bid)
    );


   function automatic void fill_wr_trans(inout axi_transaction t);
     t.set_bresp(XIL_AXI_RESP_OKAY);
   endfunction: fill_wr_trans

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
      automatic int err = 0;
      c_regs_u local_c_regs;

      for(int i=0;i<4096;i++) begin
        mWData[i] = 0;
      end

      //Start Master VIP
      axi_master_agent = new("master vip agent", axi_vip_master_dut.inst.IF);
      axi_master_agent.set_agent_tag("Master VIP");
      axi_master_agent.set_verbosity(400);
      axi_master_agent.start_master();
      //Start Slave VIP
      axil_master_agent = new("axi lite master vip agent", axil_vip_master_dut.inst.IF);
      axil_master_agent.set_agent_tag("AXI Lite Master VIP");
      axil_master_agent.set_verbosity(400);
      axil_master_agent.start_master();

      mADDR = addrOffset;
      mBurstType = XIL_AXI_BURST_TYPE_INCR;
      mID = 2;
      mBurstLength = 15;
      mDataSize = XIL_AXI_SIZE_64BYTE;
      mBresp = XIL_AXI_RESP_OKAY;
      mAWUSER = 'h0;
      mLOCK = XIL_AXI_ALOCK_NOLOCK;
      mCacheType = 0;
      mProtectionType = 0;
      mRegion = 0;
      mQOS = 0;
      for(int i = 0; i < 512;i++) begin
        mWUSER = 'h0;
      end
      for(int i = 0; i < 512;i++) begin
        mRUSER = 'h0;
      end

      for(int creg=0;creg < $bits(count_bit_regs_t)/32; creg++) begin
        c_regs.dword[creg] = 0;
      end

      //This loop will provide 2 different write data sets for verification
      for (int wr = 0; wr<2;wr++ ) begin
        //reset the accumulation registers prior to issuing data transfer for accurate results
        axil_master_agent.AXI4LITE_WRITE_BURST(4, mProtectionType, 1, mBresp);
        axil_master_agent.AXI4LITE_WRITE_BURST(4, mProtectionType, 0, mBresp);


        // generate mWData, as well as generate verification data
        // "local_c_regs" is filled with expected results using
        // systemverilog's countones function
        for(int i = 0; i < 1024; i++) begin
          if (wr == 0) begin
            mWData[i] = 'hff;
          end else begin
            mWData[i] = $urandom_range(0, 255);
          end
          local_c_regs.count_regs.total_bits_reg += $countones(mWData);
          local_c_regs.count_regs.word_bits_regs[i/4] += $countones(mWData);
          local_c_regs.count_regs.byte_bits_regs[i] += $countones(mWData);
        end

        //issue the write transaction
        axi_master_agent.AXI4_WRITE_BURST(mID,mADDR,mBurstLength,mDataSize,mBurstType,mLOCK,mCacheType,mProtectionType,mRegion,mQOS,mAWUSER,mWData,mWUSER,mBresp);

        //read all the registers to fill in local structure for verification
        for(int regpos = 0; regpos < $bits(count_bit_regs_t)/32; regpos++) begin
          int data;
          axil_master_agent.AXI4LITE_READ_BURST((regpos*4), mProtectionType, c_regs.dword[regpos], mBresp);
          //$display("Reg %d  Data: %d", regpos, c_regs.dword[regpos]);
        end

        //make sure total_bits register is correct.
        assert(c_regs.count_regs.total_bits_reg == local_c_regs.count_regs.total_bits_reg) else $error("Total bits count wrong!!");
        local_c_regs.count_regs.total_bits_reg = 0;

        //make sure word registers are correct.
        for(int w = 0; w < 16; w++) begin
          assert(c_regs.count_regs.word_bits_regs[w] == local_c_regs.count_regs.word_bits_regs[w]) else $error("Word %d bits count wrong!!", w);
          local_c_regs.count_regs.word_bits_regs[w] = 0;
        end

        //make sure byte registers are correct.
        for(int b = 0; b < 64; b++) begin
          assert(c_regs.count_regs.byte_bits_regs[b] == local_c_regs.count_regs.byte_bits_regs[b]) else $error("Byte %d bits count wrong!!", b);
          local_c_regs.count_regs.byte_bits_regs[b] = 0;
        end


        //clear when finished
        axil_master_agent.AXI4LITE_WRITE_BURST(4, mProtectionType, 1, mBresp);
        axil_master_agent.AXI4LITE_WRITE_BURST(4, mProtectionType, 0, mBresp);

      end
      done = 1'b1;
   endtask //axi_master


   //Xilinx VIP requires that the slave responds to each burst
   //transaction.  get_wr_reactive() is blocking, waiting for
   //write bursts, and servicing them continuously
   task automatic axiSlave;

      axi_slave_agent = new("slave vip agent", axi_vip_slave_dut.inst.IF);
      axi_slave_agent.set_agent_tag("Slave VIP");
      axi_slave_agent.set_verbosity(400);
      axi_slave_agent.start_slave();

      forever begin
        axi_slave_agent.wr_driver.get_wr_reactive(wr_transaction);
        fill_wr_trans(wr_transaction);
        axi_slave_agent.wr_driver.send(wr_transaction);
      end
   endtask

initial
   begin

    memory   = new[1 << 20];
    power_on = 1'b0;
    done     = 1'b0;
    fork
     clock;
     reset;
     axiSlave;
     axi_master;
   join;
    $display("@%g Simulation End", $time);
    #1000;
    $finish();
   end

endmodule