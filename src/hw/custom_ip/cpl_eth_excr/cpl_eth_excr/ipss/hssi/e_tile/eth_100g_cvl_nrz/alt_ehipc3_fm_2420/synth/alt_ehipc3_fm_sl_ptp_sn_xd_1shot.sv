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


//------------------------------------------------------------------------------
//
// Filename         : alt_ehipc3_fm_sl_ptp_sn_xd_1shot.sv
// Author           : Shoaib Sial <shoaib.sial@intel.com>
// Created On       : Wed Sep 11/09/2019
//
//------------------------------------------------------------------------------

module alt_ehipc3_fm_sl_ptp_sn_xd_1shot  #(
    parameter SYNC_FLOPS = 3
 ) (
	input  logic                     i_reset_n,
	input  logic                     i_clk,
	input  logic                     i_async_triger,
	output logic                     o_sync_pulse_xd_1s,
        output logic			 o_sync_triger_2d

);



  logic       sync_triger_2d;
  logic       sync_triger_3d;

`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) async_2ds (
        .clk                (i_clk),
        .reset              (1'b0),
        .d                  (i_async_triger),
        .q                  (sync_triger_2d)
    );

  assign o_sync_triger_2d = sync_triger_2d;

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      sync_triger_3d <= 1'b0;
    else
      sync_triger_3d <= sync_triger_2d;
  end

    assign o_sync_pulse_xd_1s = sync_triger_2d ^ sync_triger_3d;


endmodule //
