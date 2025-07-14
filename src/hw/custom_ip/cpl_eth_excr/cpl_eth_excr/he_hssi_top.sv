// Copyright 2020 Intel Corporation
// SPDX-License-Identifier: MIT

//---
//
// Description:
// The Host Exerciser  HSSI (he_hssi  is responsible for generating eth traffic with
// the intention of exercising the path from the AFU to the Host at full bandwidth.
// Per the IOFS specification, It has a  PCIE AVL-ST interface  whcih is user for CSR access
//  HSSI subssytem interface provides connects to HSSI subsystem
//`include "vendor_defines.vh"
// Description
//-----------------------------------------------------------------------------
//
//   TOOL and VENDOR Specific configurations
//   ------------------------------------------------------------------------
//   The TOOL and VENDOR definition necessary to correctly configure project
//   package currently supports
//   Vendors : Intel
//   Tools   : Quartus II
//
//-----------------------------------------------------------------------------

`ifndef VENDOR_DEFINES_VH
   `define VENDOR_DEFINES_VH

   `ifndef VENDOR_INTEL
      `define VENDOR_INTEL
   `endif

    `ifndef TOOL_QUARTUS
      `define TOOL_QUARTUS
   `endif

   `ifdef VENDOR_INTEL
       `define GRAM_AUTO "no_rw_check"                         // defaults to auto
       `define GRAM_BLCK "no_rw_check, M20K"
       `define GRAM_DIST "no_rw_check, MLAB"
   `endif

   //-------------------------------------------
   `ifdef TOOL_QUARTUS
       `define GRAM_STYLE   ramstyle
       `define NO_RETIMING  dont_retime
       `define NO_MERGE     dont_merge
       `define KEEP_WIRE    syn_keep = 1
   `endif
`endif
import ofs_fim_eth_if_pkg::*;

module he_hssi_top #(
   parameter PF_NUM=0,
   parameter VF_NUM=0,
   parameter VF_ACTIVE=0,
   parameter AXI4_LITE_CSR = 0,
   parameter MAX_NUM_ETH_CHANNELS = 16
)(
	input  logic                            clk,
	input  logic                            softreset,
   //AVMM interface (JTAG <---> CSR module)
	ofs_avmm_if.sink                csr_lite_if,

	//AXI-ST
	ofs_fim_eth_tx_axis_if.master     afu_eth_tx_st[MAX_NUM_ETH_CHANNELS-1:0],
	ofs_fim_eth_rx_axis_if.slave      afu_eth_rx_st[MAX_NUM_ETH_CHANNELS-1:0],

	input logic [31:0]				e_tile_txrx_status


);


// ----------- Parameters -------------
   localparam ETH_DW           = ofs_fim_eth_if_pkg::ETH_PACKET_WIDTH;
   localparam RX_ERROR_WIDTH   = ofs_fim_eth_if_pkg::ETH_RX_ERROR_WIDTH;
   localparam TX_ERROR_WIDTH   = ofs_fim_eth_if_pkg::ETH_TX_ERROR_WIDTH;
   localparam AVMM_DATA_W      = 32;
   localparam AVMM_ADDR_W      = 16;
   localparam NUM_ETH_BY_2     = NUM_ETH_CHANNELS/2;

   // ---- Logic / Struct Declarations ---
   logic                            clk_sys;
   logic                            rst_sys;

   logic [AVMM_ADDR_W-1:0]          s_avmm_addr;
   logic                            s_avmm_read;
   logic                            s_avmm_write;
   logic [AVMM_DATA_W-1:0]          s_avmm_writedata;
   logic [AVMM_DATA_W-1:0]          s_avmm_readdata;
   logic                            s_avmm_waitrequest, s_avmm_waitrequest_q1;
   logic                            s_avmm_waitrequest_q2, s_avmm_waitrequest_q3;
   logic [3:0]                      s_csr_port_sel;
   logic                            s_port_swap_en;

   ofs_fim_eth_sideband_tx_avst_if  afu_eth_sideband_tx [MAX_NUM_ETH_CHANNELS-1:0] ();
   ofs_fim_eth_sideband_rx_avst_if  afu_eth_sideband_rx [MAX_NUM_ETH_CHANNELS-1:0] ();

      always_ff @(posedge clk_sys) begin
      if(rst_sys) begin
         s_avmm_waitrequest_q1 <= '0;
         s_avmm_waitrequest_q2 <= '0;
         s_avmm_waitrequest_q3 <= '0;
      end else begin
         s_avmm_waitrequest_q1 <= s_avmm_waitrequest;
         s_avmm_waitrequest_q2 <= s_avmm_waitrequest_q1;
         s_avmm_waitrequest_q3 <= s_avmm_waitrequest_q2;
      end
   end

   // Clock and reset mapping for HSSI datapath
   generate
      for (genvar ch=0; ch<NUM_ETH_CHANNELS; ch++) begin : GenRstSync
         logic tx_sync_rst_n;
		 fim_resync # (
               .SYNC_CHAIN_LENGTH(3),
               .WIDTH(1),
               .INIT_VALUE(0),
               .NO_CUT(0)
            ) tx_reset_synchronizer(
               .clk   (afu_eth_tx_st[ch].clk),
               .reset (softreset),
               .d     (1'b1),
               .q     (tx_sync_rst_n)
            );

         logic rx_sync_rst_n;
         fim_resync # (
               .SYNC_CHAIN_LENGTH(3),
               .WIDTH(1),
               .INIT_VALUE(0),
               .NO_CUT(0)
            ) rx_reset_synchronizer(
               .clk   (afu_eth_rx_st[ch].clk),
               .reset (softreset),
               .d     (1'b1),
               .q     (rx_sync_rst_n)
            );

//         always_comb begin // sideband mapping
            // afu_eth_tx_st[ch].clk         = s_tx_bus_clk[ch];
//            afu_eth_tx_st[ch].rst_n       = ~softreset;
            // afu_eth_rx_st[ch].clk         = s_rx_bus_clk[ch];
//            afu_eth_rx_st[ch].rst_n       = ~softreset;
            // afu_eth_sideband_tx[ch].clk   = s_tx_bus_clk[ch];
            // afu_eth_sideband_tx[ch].rst_n = tx_sync_rst_n;
            // afu_eth_sideband_rx[ch].clk   = s_rx_bus_clk[ch];
            // afu_eth_sideband_rx[ch].rst_n = rx_sync_rst_n;
//         end
      end
   endgenerate

   // cross port routing logic
   // cpr_eth* connected to traffic controller
   // afu_eth* connected to HSSI SS interfaces


generate

begin

   eth_traffic_pcie_axil_csr  #(
      .AVMM_DATA_W   (AVMM_DATA_W),
      .AVMM_ADDR_W   (AVMM_ADDR_W)
   ) eth_traffic_pcie_axil_csr_inst (
      .clk                (csr_lite_if.clk),
      .rst_n              (csr_lite_if.rst_n),
      .csr_lite_if        (csr_lite_if),
      .o_avmm_addr        (s_avmm_addr),
      .o_avmm_read        (s_avmm_read),
      .o_avmm_write       (s_avmm_write),
      .o_avmm_writedata   (s_avmm_writedata),
      .i_avmm_readdata    (s_avmm_readdata),
      .i_avmm_waitrequest (s_avmm_waitrequest_q3),
      .o_csr_port_sel     (s_csr_port_sel),
	  .e_tile_txrx_status (e_tile_txrx_status),
      .o_port_swap_en     (s_port_swap_en)
   );


   assign clk_sys = csr_lite_if.clk;
   assign rst_sys = ~csr_lite_if.rst_n;

end

endgenerate



// Multi-channel 100G/10G ethernet traffic controller top
multi_port_axi_traffic_ctrl #(
      .NUM_ETH       (NUM_ETH_CHANNELS),
      .AVMM_DATA_W   (AVMM_DATA_W),
      .AVMM_ADDR_W   (AVMM_ADDR_W)
   ) multi_port_axi_traffic_ctrl_inst (
      .clk                (clk_sys),
      .reset              (rst_sys),
      .eth_tx_st          (afu_eth_tx_st[NUM_ETH_CHANNELS-1:0]), //Axi interface removed,Avalon interface inserted
      .eth_rx_st          (afu_eth_rx_st[NUM_ETH_CHANNELS-1:0]),
      .i_avmm_addr        (s_avmm_addr),
      .i_avmm_read        (s_avmm_read),
      .i_avmm_write       (s_avmm_write),
      .i_avmm_writedata   (s_avmm_writedata),
      .o_avmm_readdata    (s_avmm_readdata),
      .o_avmm_waitrequest (s_avmm_waitrequest),
      .i_csr_port_sel     (s_csr_port_sel)
   );
endmodule // eth_traffic_afu
