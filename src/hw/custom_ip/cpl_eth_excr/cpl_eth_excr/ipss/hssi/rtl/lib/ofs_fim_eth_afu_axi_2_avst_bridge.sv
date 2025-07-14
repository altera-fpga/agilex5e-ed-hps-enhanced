// Copyright (C) 2020 Intel Corporation.
// SPDX-License-Identifier: MIT

//
//-----------------------------------------------------------------------------
// Description
//-----------------------------------------------------------------------------
//
// FIM AVST <-> AFU AXIS bridge
//
//-----------------------------------------------------------------------------

module ofs_fim_eth_afu_axi_2_avst_bridge (
   // FIM-side AVST interfaces
   ofs_fim_eth_tx_avst_if.master    avst_tx_st,
   ofs_fim_eth_rx_avst_if.slave   avst_rx_st,

   // AFU-side AXI-S interfaces
   ofs_fim_eth_rx_axis_if.master   axi_rx_st,
   ofs_fim_eth_tx_axis_if.slave    axi_tx_st
);

   logic is_tx_sop;

   // ****************************************************
   // *-------------- FIM -> AFU Rx Bridge --------------*
   // ****************************************************
   assign axi_tx_st.clk   = avst_tx_st.clk;
   assign axi_tx_st.rst_n = avst_tx_st.rst_n;

   always_comb
   begin
      axi_tx_st.tready     = avst_tx_st.ready;
      avst_tx_st.tx.valid  = axi_tx_st.tx.tvalid;
      // AVST data is first Symbol In High Order Bits
      avst_tx_st.tx.data   = ofs_fim_eth_avst_if_pkg::eth_axi_to_avst_data(axi_tx_st.tx.tdata);
      avst_tx_st.tx.sop    = axi_tx_st.tx.tvalid & is_tx_sop;
      avst_tx_st.tx.eop    = axi_tx_st.tx.tvalid & axi_tx_st.tx.tlast;
      avst_tx_st.tx.user.error = axi_tx_st.tx.tuser.error;
      avst_tx_st.tx.empty = ofs_fim_eth_avst_if_pkg::eth_tkeep_to_empty(axi_tx_st.tx.tkeep);
   end

   // tx SOP always follows a tlast AXI-S flit
   always_ff @(posedge axi_tx_st.clk)
   begin
      if (!axi_tx_st.rst_n)
         is_tx_sop <= 1'b1;
      else if (axi_tx_st.tx.tvalid && axi_tx_st.tready)
         is_tx_sop <= axi_tx_st.tx.tlast;
   end

   // ****************************************************
   // *-------------- AFU -> FIM Tx Bridge --------------*
   // ****************************************************
   assign axi_rx_st.clk   = avst_rx_st.clk;
   assign axi_rx_st.rst_n = avst_rx_st.rst_n;

   always_comb
   begin
      avst_rx_st.ready         = axi_rx_st.tready;
      axi_rx_st.rx.tvalid      = avst_rx_st.rx.valid;
      // AVST data is first Symbol In High Order Bits
      axi_rx_st.rx.tdata       = ofs_fim_eth_avst_if_pkg::eth_avst_to_axi_data(avst_rx_st.rx.data);
      axi_rx_st.rx.tlast       = avst_rx_st.rx.eop & avst_rx_st.rx.valid;
      axi_rx_st.rx.tuser.error = avst_rx_st.rx.user.error;
      axi_rx_st.rx.tkeep = ofs_fim_eth_avst_if_pkg::eth_empty_to_tkeep(avst_rx_st.rx.empty);
   end

endmodule
