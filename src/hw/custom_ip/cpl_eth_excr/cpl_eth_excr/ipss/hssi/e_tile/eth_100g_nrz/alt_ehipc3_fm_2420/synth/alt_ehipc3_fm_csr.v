// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files from any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Intel Program License Subscription
// Agreement, Intel FPGA IP License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Intel and sold by
// Intel or its authorized distributors.  Please refer to the applicable
// agreement for further details.


//-----------------------------------------------------------------------------------------------//
//   Generated with Magillem S.A. MRV generator.
//   MRV generator version : 0.2
//   Protocol :  AVALON
//   Wait State : WS1_OUTPUT
//   Date : Tue Jan 08 18:09:53 PST 2019
//-----------------------------------------------------------------------------------------------//


//-----------------------------------------------------------------------------------------------//
//   Verilog Register Bank
//   Component Name: registers
//   File Ref: /data/sraste/p4root/191/p4/depot/docs/ip/FS_MAS_TP/ethernet/alt_ehipc3_fm/rdl_temp_csr/s10_etile_ehip_csrgen_output/_workspace_mrv_gen_py_/xmlProject/_local_copy_Vendor_Library_registers_1.0.xml
//   Magillem Version :   5.11.2.1
//-----------------------------------------------------------------------------------------------//
//
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module alt_ehipc3_fm_csr (
// register offset : 0x302, field offset : 0, access : RO, phy_name_0.id
// register offset : 0x303, field offset : 0, access : RO, phy_name_1.id
// register offset : 0x304, field offset : 0, access : RO, phy_name_2.id
// register offset : 0x310, field offset : 0, access : RW, phy_config.eio_sys_rst
output  reg phy_config_eio_sys_rst,
// register offset : 0x310, field offset : 1, access : RW, phy_config.soft_tx_rst
output  reg phy_config_soft_tx_rst,
// register offset : 0x310, field offset : 2, access : RW, phy_config.soft_rx_rst
output  reg phy_config_soft_rx_rst,
// register offset : 0x310, field offset : 4, access : RW, phy_config.set_ref_lock
output  reg phy_config_set_ref_lock,
// register offset : 0x310, field offset : 5, access : RW, phy_config.set_data_lock
output  reg phy_config_set_data_lock,
// register offset : 0x313, field offset : 0, access : RW, phy_pma_sloop.sloop
output  reg[3:0] phy_pma_sloop_sloop,
// register offset : 0x313, field offset : 4, access : RW, phy_pma_sloop.mac_adapter_loopback
output  reg phy_pma_sloop_mac_adapter_loopback,
// register offset : 0x313, field offset : 5, access : RW, phy_pma_sloop.dis_rsfec
output  reg phy_pma_sloop_dis_rsfec,
// register offset : 0x320, field offset : 0, access : RO, phy_tx_pll_locked.tx_pll_locked
input  [3:0] phy_tx_pll_locked_tx_pll_locked_i,
// register offset : 0x321, field offset : 0, access : RO, phy_eiofreq_locked.eio_freq_lock
input  [3:0] phy_eiofreq_locked_eio_freq_lock_i,
// register offset : 0x322, field offset : 0, access : RO, phy_tx_corepll_locked.tx_pcs_ready
input   phy_tx_corepll_locked_tx_pcs_ready_i,
// register offset : 0x329, field offset : 0, access : RO, lanes_deskewed.dskew_status
input   lanes_deskewed_dskew_status_i,
// register offset : 0x329, field offset : 1, access : RO, lanes_deskewed.dskew_chng
input   lanes_deskewed_dskew_chng_i,
// register offset : 0x32b, field offset : 0, access : RO, aib_transfer_ready_status.ehip_tx_transfer_ready
input  [3:0] aib_transfer_ready_status_ehip_tx_transfer_ready_i,
// register offset : 0x32b, field offset : 4, access : RO, aib_transfer_ready_status.ptp_tx_transfer_ready
input  [1:0] aib_transfer_ready_status_ptp_tx_transfer_ready_i,
// register offset : 0x32b, field offset : 16, access : RO, aib_transfer_ready_status.ehip_rx_transfer_ready
input  [3:0] aib_transfer_ready_status_ehip_rx_transfer_ready_i,
// register offset : 0x32b, field offset : 20, access : RO, aib_transfer_ready_status.ptp_rx_transfer_ready
input  [1:0] aib_transfer_ready_status_ptp_rx_transfer_ready_i,
// register offset : 0x32c, field offset : 0, access : RO, soft_rc_reset_status.ehip_reset
input   soft_rc_reset_status_ehip_reset_i,
// register offset : 0x32c, field offset : 1, access : RO, soft_rc_reset_status.ehip_tx_reset
input   soft_rc_reset_status_ehip_tx_reset_i,
// register offset : 0x32c, field offset : 2, access : RO, soft_rc_reset_status.ehip_rx_reset
input   soft_rc_reset_status_ehip_rx_reset_i,
// register offset : 0x32c, field offset : 3, access : RO, soft_rc_reset_status.ehip_rsfec_reset
input   soft_rc_reset_status_ehip_rsfec_reset_i,
// register offset : 0x32c, field offset : 4, access : RO, soft_rc_reset_status.ehip_rsfec_tx_reset
input   soft_rc_reset_status_ehip_rsfec_tx_reset_i,
// register offset : 0x32c, field offset : 5, access : RO, soft_rc_reset_status.ehip_rsfec_rx_reset
input   soft_rc_reset_status_ehip_rsfec_rx_reset_i,
// register offset : 0x340, field offset : 0, access : RO, phy_refclk_khz.khz_ref
input  [31:0] phy_refclk_khz_khz_ref_i,
// register offset : 0x341, field offset : 0, access : RO, phy_recclk_khz.khz_rx
input  [31:0] phy_recclk_khz_khz_rx_i,
// register offset : 0x342, field offset : 0, access : RO, phy_txclk_khz.khz_tx
input  [31:0] phy_txclk_khz_khz_tx_i,
// register offset : 0x400, field offset : 0, access : RO, txmac_revid.id
// register offset : 0x401, field offset : 0, access : RW, txmac_scratch.scratch
// register offset : 0x402, field offset : 0, access : RO, txmac_name_0.id
// register offset : 0x403, field offset : 0, access : RO, txmac_name_1.id
// register offset : 0x404, field offset : 0, access : RO, txmac_name_2.id
// register offset : 0x500, field offset : 0, access : RO, rxmac_revid.id
// register offset : 0x501, field offset : 0, access : RW, rxmac_scratch.scratch
// register offset : 0x502, field offset : 0, access : RO, rxmac_name_0.id
// register offset : 0x503, field offset : 0, access : RO, rxmac_name_1.id
// register offset : 0x504, field offset : 0, access : RO, rxmac_name_2.id
// register offset : 0x510, field offset : 0, access : RO, rxmac_adapt_dropped_lo.count
input  [31:0] rxmac_adapt_dropped_lo_count_i,
// register offset : 0x511, field offset : 0, access : RO, rxmac_adapt_dropped_hi.count
input  [31:0] rxmac_adapt_dropped_hi_count_i,
// register offset : 0x512, field offset : 0, access : RW, rxmac_adapt_dropped_clear.clear_drops
output  reg rxmac_adapt_dropped_clear_clear_drops,
// register offset : 0xb10, field offset : 0, access : RW, ptp_tx_ui.tx_ui
output  reg[31:0] ptp_tx_ui_tx_ui,
// register offset : 0xb11, field offset : 0, access : RW, ptp_rx_ui.rx_ui
output  reg[31:0] ptp_rx_ui_rx_ui,
//Bus Interface
input clk,
input reset,
input [31:0] writedata,
input read,
input write,
input [3:0] byteenable,
output reg [31:0] readdata,
output reg readdatavalid,
input [11:0] address

);


wire reset_n = !reset;
// Protocol management
// combinatorial read data signal declaration
reg [31:0] rdata_comb;

// synchronous process for the read
always @(posedge clk)
   if (!reset_n) readdata[31:0] <= 32'h0; else readdata[31:0] <= rdata_comb[31:0];

// read data is always returned on the next cycle
always @( posedge clk)
   if (!reset_n) readdatavalid <= 1'b0; else readdatavalid <= read;
//
//  Protocol specific assignment to inside signals
//
wire  we = write;
wire  re = read;
wire [11:0] addr = address[11:0];
wire [31:0] din  = writedata [31:0];
// A write byte enable for each register
// register phy_config with  writeType: write
wire	  we_phy_config		=	we  & (addr[11:0]  == 12'h310)	?	byteenable[0]	:	1'b0;
// register phy_pma_sloop with  writeType: write
wire	  we_phy_pma_sloop		=	we  & (addr[11:0]  == 12'h313)	?	byteenable[0]	:	1'b0;
// register txmac_scratch with  writeType: write
wire	[3:0]  we_txmac_scratch		=	we  & (addr[11:0]  == 12'h401)	?	byteenable[3:0]	:	{4{1'b0}};
// register rxmac_scratch with  writeType: write
wire	[3:0]  we_rxmac_scratch		=	we  & (addr[11:0]  == 12'h501)	?	byteenable[3:0]	:	{4{1'b0}};
// register rxmac_adapt_dropped_clear with  writeType: write
wire	  we_rxmac_adapt_dropped_clear		=	we  & (addr[11:0]  == 12'h512)	?	byteenable[0]	:	1'b0;
// register ptp_tx_ui with  writeType: write
wire	[3:0]  we_ptp_tx_ui		=	we  & (addr[11:0]  == 12'hb10)	?	byteenable[3:0]	:	{4{1'b0}};
// register ptp_rx_ui with  writeType: write
wire	[3:0]  we_ptp_rx_ui		=	we  & (addr[11:0]  == 12'hb11)	?	byteenable[3:0]	:	{4{1'b0}};

// A read byte enable for each register

/* Definitions of REGISTER "phy_name_0" */

// phy_name_0_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "phy_name_1" */

// phy_name_1_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "phy_name_2" */

// phy_name_2_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "phy_config" */

// phy_config_eio_sys_rst
// bitfield description: Ethernet IO System Reset
// 1:Reset the PMA (starts the PMA's internal reset sequence)
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      phy_config_eio_sys_rst <= 1'h0;
   end
   else begin
   if (we_phy_config) begin
      phy_config_eio_sys_rst   <=  din[0];  //
   end
end

// phy_config_soft_tx_rst
// bitfield description: Soft TXP Reset
// 1:Reset the TX PLL
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      phy_config_soft_tx_rst <= 1'h0;
   end
   else begin
   if (we_phy_config) begin
      phy_config_soft_tx_rst   <=  din[1];  //
   end
end

// phy_config_soft_rx_rst
// bitfield description: Soft RXP Reset
// 1:Reset the RX PLL
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      phy_config_soft_rx_rst <= 1'h0;
   end
   else begin
   if (we_phy_config) begin
      phy_config_soft_rx_rst   <=  din[2];  //
   end
end

// phy_config_set_ref_lock
// bitfield description: Set ref lock
// 1:Force PLL to lock to reference
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      phy_config_set_ref_lock <= 1'h0;
   end
   else begin
   if (we_phy_config) begin
      phy_config_set_ref_lock   <=  din[4];  //
   end
end

// phy_config_set_data_lock
// bitfield description: Set data lock
// 1:Force PLL to lock to data
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      phy_config_set_data_lock <= 1'h0;
   end
   else begin
   if (we_phy_config) begin
      phy_config_set_data_lock   <=  din[5];  //
   end
end
/* Definitions of REGISTER "phy_pma_sloop" */

// phy_pma_sloop_sloop
// bitfield description: Activate Serial Loopback
// 1:Force corresponding physical lane to receive serial data from its own transmitter instead of from its RX serial pins
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      phy_pma_sloop_sloop <= 4'h0;
   end
   else begin
   if (we_phy_pma_sloop) begin
      phy_pma_sloop_sloop[3:0]   <=  din[3:0];  //
   end
end

// phy_pma_sloop_mac_adapter_loopback
// bitfield description: reserved
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      phy_pma_sloop_mac_adapter_loopback <= 1'h0;
   end
   else begin
   if (we_phy_pma_sloop) begin
      phy_pma_sloop_mac_adapter_loopback   <=  din[4];  //
   end
end

// phy_pma_sloop_dis_rsfec
// bitfield description: reserved
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      phy_pma_sloop_dis_rsfec <= 1'h0;
   end
   else begin
   if (we_phy_pma_sloop) begin
      phy_pma_sloop_dis_rsfec   <=  din[5];  //
   end
end
/* Definitions of REGISTER "phy_tx_pll_locked" */

// phy_tx_pll_locked_tx_pll_locked
// bitfield description: TX PLL Locked
// 1=TX PLL used by this lane physical lane is locked
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: phy_tx_pll_locked_tx_pll_locked_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "phy_eiofreq_locked" */

// phy_eiofreq_locked_eio_freq_lock
// bitfield description: CDR PLL locked
// 1:Corresponding physical lane's CDR has locked to reference
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: phy_eiofreq_locked_eio_freq_lock_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "phy_tx_corepll_locked" */

// phy_tx_corepll_locked_tx_pcs_ready
// bitfield description: TX Ready
// 1:TX Datapath is out of reset, stable, and ready for use
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: phy_tx_corepll_locked_tx_pcs_ready_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "lanes_deskewed" */

// lanes_deskewed_dskew_status
// bitfield description: Deskewed status
// 1:RX PCS is deskewed
// 0:RX PCS is not currently deskewed. Note that there is some latency between this status bit and the actual state
//
//
// Not valid for single lane channels (10G/25G)
// Note that this bit is not sticky - we recommend using a soft logic replacement for this bit that can be made sticky based on the deskew_done port
// customType:  RO
// hwAccess: WO
// inputPort: lanes_deskewed_dskew_status_i
// outputPort:  ""
// NO register generated




// lanes_deskewed_dskew_chng
// bitfield description: Change in deskewed status
// 1:RX PCS went from deskewed to not deskewed, or from not deskewed to deskewed
//
//
// Not valid for single lane channels (10G/25G)
// This bit is sticky - use phy_sclk_frame_error.clr_frmerr to set this bit back to 0
// Resetting the RX datapath, or the entire core will also clear the bit
// customType:  RO
// hwAccess: WO
// inputPort: lanes_deskewed_dskew_chng_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "aib_transfer_ready_status" */

// aib_transfer_ready_status_ehip_tx_transfer_ready
// bitfield description: EHIP TX channels Transfer ready status
// 1:transfer_ready is 1
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: aib_transfer_ready_status_ehip_tx_transfer_ready_i
// outputPort:  ""
// NO register generated




// aib_transfer_ready_status_ptp_tx_transfer_ready
// bitfield description: PTP TX channels Transfer ready status
// 1:transfer_ready is 1
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: aib_transfer_ready_status_ptp_tx_transfer_ready_i
// outputPort:  ""
// NO register generated




// aib_transfer_ready_status_ehip_rx_transfer_ready
// bitfield description: EHIP RX channels Transfer ready status
// 1:transfer_ready is 1
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: aib_transfer_ready_status_ehip_rx_transfer_ready_i
// outputPort:  ""
// NO register generated




// aib_transfer_ready_status_ptp_rx_transfer_ready
// bitfield description: PTP RX channels Transfer ready status
// 1:transfer_ready is 1
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: aib_transfer_ready_status_ptp_rx_transfer_ready_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "soft_rc_reset_status" */

// soft_rc_reset_status_ehip_reset
// bitfield description: EHIP reset from the reset controller
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: soft_rc_reset_status_ehip_reset_i
// outputPort:  ""
// NO register generated




// soft_rc_reset_status_ehip_tx_reset
// bitfield description: EHIP TX reset from the reset controller
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: soft_rc_reset_status_ehip_tx_reset_i
// outputPort:  ""
// NO register generated




// soft_rc_reset_status_ehip_rx_reset
// bitfield description: EHIP RX reset from the reset controller
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: soft_rc_reset_status_ehip_rx_reset_i
// outputPort:  ""
// NO register generated




// soft_rc_reset_status_ehip_rsfec_reset
// bitfield description: EHIP rsfec reset from the reset controller
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: soft_rc_reset_status_ehip_rsfec_reset_i
// outputPort:  ""
// NO register generated




// soft_rc_reset_status_ehip_rsfec_tx_reset
// bitfield description: EHIP rsfec TX reset from the reset controller
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: soft_rc_reset_status_ehip_rsfec_tx_reset_i
// outputPort:  ""
// NO register generated




// soft_rc_reset_status_ehip_rsfec_rx_reset
// bitfield description: EHIP rsfec RX reset from the reset controller
// customType:  RO
// hwAccess: WO
// reset value : 0x0
// inputPort: soft_rc_reset_status_ehip_rsfec_rx_reset_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "phy_refclk_khz" */

// phy_refclk_khz_khz_ref
// bitfield description: Refclk frequency
// Reference clock frequency/100, in KHz
// customType:  RO
// hwAccess: WO
// reset value : 0x00000000
// inputPort: phy_refclk_khz_khz_ref_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "phy_recclk_khz" */

// phy_recclk_khz_khz_rx
// bitfield description: Recovered clock frequency
// Recovered clock frequency/100, in KHz
// customType:  RO
// hwAccess: WO
// reset value : 0x00000000
// inputPort: phy_recclk_khz_khz_rx_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "phy_txclk_khz" */

// phy_txclk_khz_khz_tx
// bitfield description: TX clock frequency
// TX clock frequency/100, in KHz
// customType:  RO
// hwAccess: WO
// reset value : 0x00000000
// inputPort: phy_txclk_khz_khz_tx_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "txmac_revid" */

// txmac_revid_id
// bitfield description: Revision ID
// 32b Revision ID for the module
// customType:  RO
// hwAccess: NA
// reset value : 0x11112015
// NO register generated


/* Definitions of REGISTER "txmac_scratch" */

// txmac_scratch_scratch
// customType:  RW
// hwAccess: NA
// reset value : 0x00000000

reg [31:0] txmac_scratch_scratch; //

always @( posedge clk)
   if (!reset_n)  begin
      txmac_scratch_scratch <= 32'h00000000;
   end
   else begin
   if (we_txmac_scratch[0]) begin
      txmac_scratch_scratch[7:0]   <=  din[7:0];  //
   end
   if (we_txmac_scratch[1]) begin
      txmac_scratch_scratch[15:8]   <=  din[15:8];  //
   end
   if (we_txmac_scratch[2]) begin
      txmac_scratch_scratch[23:16]   <=  din[23:16];  //
   end
   if (we_txmac_scratch[3]) begin
      txmac_scratch_scratch[31:24]   <=  din[31:24];  //
   end
end
/* Definitions of REGISTER "txmac_name_0" */

// txmac_name_0_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "txmac_name_1" */

// txmac_name_1_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "txmac_name_2" */

// txmac_name_2_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "rxmac_revid" */

// rxmac_revid_id
// bitfield description: Revision ID
// 32b Revision ID for the module
// customType:  RO
// hwAccess: NA
// reset value : 0x11112015
// NO register generated


/* Definitions of REGISTER "rxmac_scratch" */

// rxmac_scratch_scratch
// customType:  RW
// hwAccess: NA
// reset value : 0x00000000

reg [31:0] rxmac_scratch_scratch; //

always @( posedge clk)
   if (!reset_n)  begin
      rxmac_scratch_scratch <= 32'h00000000;
   end
   else begin
   if (we_rxmac_scratch[0]) begin
      rxmac_scratch_scratch[7:0]   <=  din[7:0];  //
   end
   if (we_rxmac_scratch[1]) begin
      rxmac_scratch_scratch[15:8]   <=  din[15:8];  //
   end
   if (we_rxmac_scratch[2]) begin
      rxmac_scratch_scratch[23:16]   <=  din[23:16];  //
   end
   if (we_rxmac_scratch[3]) begin
      rxmac_scratch_scratch[31:24]   <=  din[31:24];  //
   end
end
/* Definitions of REGISTER "rxmac_name_0" */

// rxmac_name_0_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "rxmac_name_1" */

// rxmac_name_1_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "rxmac_name_2" */

// rxmac_name_2_id
// customType:  RO
// hwAccess: NA
// reset value : 0x00000000
// NO register generated


/* Definitions of REGISTER "rxmac_adapt_dropped_lo" */

// rxmac_adapt_dropped_lo_count
// bitfield description: Number of frames dropped by the RX MAC adapter, bits [31:0]
// customType:  RO
// hwAccess: WO
// inputPort: rxmac_adapt_dropped_lo_count_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "rxmac_adapt_dropped_hi" */

// rxmac_adapt_dropped_hi_count
// bitfield description: Number of frames dropped by the RX MAC adapter, bits [63:32]
// customType:  RO
// hwAccess: WO
// inputPort: rxmac_adapt_dropped_hi_count_i
// outputPort:  ""
// NO register generated



/* Definitions of REGISTER "rxmac_adapt_dropped_clear" */

// rxmac_adapt_dropped_clear_clear_drops
// bitfield description: Clear dropped frame count
// 1: Clears the RX MAC adapter dropped frame count 0: De-asserts clear
// customType:  RW
// hwAccess: RO
// reset value : 0x0


always @( posedge clk)
   if (!reset_n)  begin
      rxmac_adapt_dropped_clear_clear_drops <= 1'h0;
   end
   else begin
   if (we_rxmac_adapt_dropped_clear) begin
      rxmac_adapt_dropped_clear_clear_drops   <=  din[0];  //
   end
end
/* Definitions of REGISTER "ptp_tx_ui" */

// ptp_tx_ui_tx_ui
// bitfield description: UI time in ns and fns
// Sets the time for a single TX serial bit. This time is used to generate TX timestamp estimates
// [31:24]: Nanoseconds field for the time of a single serial TX bit
// [23:0]: Fractional nanoseconds field for the time of a single serial TX bit
// customType:  RW
// hwAccess: RO
// reset value : 0x00000000


always @( posedge clk)
   if (!reset_n)  begin
      ptp_tx_ui_tx_ui <= 32'h00000000;
   end
   else begin
   if (we_ptp_tx_ui[0]) begin
      ptp_tx_ui_tx_ui[7:0]   <=  din[7:0];  //
   end
   if (we_ptp_tx_ui[1]) begin
      ptp_tx_ui_tx_ui[15:8]   <=  din[15:8];  //
   end
   if (we_ptp_tx_ui[2]) begin
      ptp_tx_ui_tx_ui[23:16]   <=  din[23:16];  //
   end
   if (we_ptp_tx_ui[3]) begin
      ptp_tx_ui_tx_ui[31:24]   <=  din[31:24];  //
   end
end
/* Definitions of REGISTER "ptp_rx_ui" */

// ptp_rx_ui_rx_ui
// bitfield description: UI time in ns and fns
// Sets the time for a single RX serial bit. This time is used to generate RX timestamp estimates
// [31:24]: Nanoseconds field for the time of a single serial RX bit
// [23:0]: Fractional nanoseconds field for the time of a single serial RX bit
// customType:  RW
// hwAccess: RO
// reset value : 0x00000000


always @( posedge clk)
   if (!reset_n)  begin
      ptp_rx_ui_rx_ui <= 32'h00000000;
   end
   else begin
   if (we_ptp_rx_ui[0]) begin
      ptp_rx_ui_rx_ui[7:0]   <=  din[7:0];  //
   end
   if (we_ptp_rx_ui[1]) begin
      ptp_rx_ui_rx_ui[15:8]   <=  din[15:8];  //
   end
   if (we_ptp_rx_ui[2]) begin
      ptp_rx_ui_rx_ui[23:16]   <=  din[23:16];  //
   end
   if (we_ptp_rx_ui[3]) begin
      ptp_rx_ui_rx_ui[31:24]   <=  din[31:24];  //
   end
end


// read process
always @ (*)
begin
rdata_comb = 32'h00000000;
   if(re) begin
      case (addr)
	12'h302 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // phy_name_0_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h303 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // phy_name_1_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h304 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // phy_name_2_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h310 : begin
		rdata_comb [0]	= phy_config_eio_sys_rst  ;		// readType = read   writeType =write
		rdata_comb [1]	= phy_config_soft_tx_rst  ;		// readType = read   writeType =write
		rdata_comb [2]	= phy_config_soft_rx_rst  ;		// readType = read   writeType =write
		rdata_comb [4]	= phy_config_set_ref_lock  ;		// readType = read   writeType =write
		rdata_comb [5]	= phy_config_set_data_lock  ;		// readType = read   writeType =write
	end
	12'h313 : begin
		rdata_comb [3:0]	= phy_pma_sloop_sloop [3:0] ;		// readType = read   writeType =write
		rdata_comb [4]	= phy_pma_sloop_mac_adapter_loopback  ;		// readType = read   writeType =write
		rdata_comb [5]	= phy_pma_sloop_dis_rsfec  ;		// readType = read   writeType =write
	end
	12'h320 : begin
		rdata_comb [3:0]	= phy_tx_pll_locked_tx_pll_locked_i [3:0] ;		// readType = read   writeType =illegal
	end
	12'h321 : begin
		rdata_comb [3:0]	= phy_eiofreq_locked_eio_freq_lock_i [3:0] ;		// readType = read   writeType =illegal
	end
	12'h322 : begin
		rdata_comb [0]	= phy_tx_corepll_locked_tx_pcs_ready_i  ;		// readType = read   writeType =illegal
	end
	12'h329 : begin
		rdata_comb [0]	= lanes_deskewed_dskew_status_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= lanes_deskewed_dskew_chng_i  ;		// readType = read   writeType =illegal
	end
	12'h32b : begin
		rdata_comb [3:0]	= aib_transfer_ready_status_ehip_tx_transfer_ready_i [3:0] ;		// readType = read   writeType =illegal
		rdata_comb [5:4]	= aib_transfer_ready_status_ptp_tx_transfer_ready_i [1:0] ;		// readType = read   writeType =illegal
		rdata_comb [19:16]	= aib_transfer_ready_status_ehip_rx_transfer_ready_i [3:0] ;		// readType = read   writeType =illegal
		rdata_comb [21:20]	= aib_transfer_ready_status_ptp_rx_transfer_ready_i [1:0] ;		// readType = read   writeType =illegal
	end
	12'h32c : begin
		rdata_comb [0]	= soft_rc_reset_status_ehip_reset_i  ;		// readType = read   writeType =illegal
		rdata_comb [1]	= soft_rc_reset_status_ehip_tx_reset_i  ;		// readType = read   writeType =illegal
		rdata_comb [2]	= soft_rc_reset_status_ehip_rx_reset_i  ;		// readType = read   writeType =illegal
		rdata_comb [3]	= soft_rc_reset_status_ehip_rsfec_reset_i  ;		// readType = read   writeType =illegal
		rdata_comb [4]	= soft_rc_reset_status_ehip_rsfec_tx_reset_i  ;		// readType = read   writeType =illegal
		rdata_comb [5]	= soft_rc_reset_status_ehip_rsfec_rx_reset_i  ;		// readType = read   writeType =illegal
	end
	12'h340 : begin
		rdata_comb [31:0]	= phy_refclk_khz_khz_ref_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h341 : begin
		rdata_comb [31:0]	= phy_recclk_khz_khz_rx_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h342 : begin
		rdata_comb [31:0]	= phy_txclk_khz_khz_tx_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h400 : begin
		rdata_comb [31:0]	= 32'h11112015 ;  // txmac_revid_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h401 : begin
		rdata_comb [31:0]	= txmac_scratch_scratch [31:0] ;		// readType = read   writeType =write
	end
	12'h402 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // txmac_name_0_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h403 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // txmac_name_1_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h404 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // txmac_name_2_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h500 : begin
		rdata_comb [31:0]	= 32'h11112015 ;  // rxmac_revid_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h501 : begin
		rdata_comb [31:0]	= rxmac_scratch_scratch [31:0] ;		// readType = read   writeType =write
	end
	12'h502 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // rxmac_name_0_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h503 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // rxmac_name_1_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h504 : begin
		rdata_comb [31:0]	= 32'h00000000 ;  // rxmac_name_2_id 	is reserved or a constant value, a read access gives the reset value
	end
	12'h510 : begin
		rdata_comb [31:0]	= rxmac_adapt_dropped_lo_count_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h511 : begin
		rdata_comb [31:0]	= rxmac_adapt_dropped_hi_count_i [31:0] ;		// readType = read   writeType =illegal
	end
	12'h512 : begin
		rdata_comb [0]	= rxmac_adapt_dropped_clear_clear_drops  ;		// readType = read   writeType =write
	end
	12'hb10 : begin
		rdata_comb [31:0]	= ptp_tx_ui_tx_ui [31:0] ;		// readType = read   writeType =write
	end
	12'hb11 : begin
		rdata_comb [31:0]	= ptp_rx_ui_rx_ui [31:0] ;		// readType = read   writeType =write
	end
	default : begin
		rdata_comb = 32'h00000000;
	end
      endcase
   end
end

endmodule
