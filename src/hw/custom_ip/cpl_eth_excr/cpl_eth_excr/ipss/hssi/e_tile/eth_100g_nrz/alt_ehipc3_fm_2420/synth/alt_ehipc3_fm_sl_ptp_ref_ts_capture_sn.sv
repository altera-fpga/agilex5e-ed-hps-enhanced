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


//==============================================================================
//
// (C) 2011-2017 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
//
// Filename         : ptp_ref_ts_capture.sv
// Author           : Tholu Kiran Kumar <kktholu@intel.com>
// Created On       : Tue Jul 04/07/2017 11:27:24 AM MYT
//
//------------------------------------------------------------------------------
//
// $File: $
// $Revision: $
// $Date: $
// $Author: $
//
//==============================================================================

//------------------------------------------------------------------------------
//
// Description :-
// Submodules:
//            ptp_ckt_cal
//            ptp_tx_tam_capture
//            ptp_rx_tam_capture
//
//------------------------------------------------------------------------------

`timescale 1ns / 1ns
module alt_ehipc3_fm_sl_ptp_ref_ts_capture_sn  #(
    parameter EHIP_RATE_10G_EN = 0,
    parameter SIM_MODE = 0
)
(
    // Configuration
    input  logic  [1:0] i_sn_config,
    input  logic        i_enable_rsfec,
    input  logic        i_rx_sn_dn,
    input  logic [15:0] i_rx_ap_roll_dly,

    input  logic [31:0] i_apulse_period,
    input  logic [31:0] i_apulse_cnt_pow2,
    input  logic [31:0] i_apulse_cnt,
    input  logic [31:0] i_tx_ui,
    input  logic [31:0] i_rx_ui,
    input  logic [31:0] i_sn_pll_sclk_period,

    input  logic        i_ptp_sn_sclk,
    input  logic        i_clk,
    input  logic        i_tx_clk,
    input  logic        i_rx_clk,
    input  logic        i_tx_rst_n,
    input  logic        i_rx_rst_n,
    input  logic	      i_tx_arst,
    input  logic	      i_rx_arst,
    input  logic        i_txx_arst_n,
    input  logic        i_rxx_arst_n,
    input  logic        i_txx_rst_n,
    input  logic        i_rxx_rst_n,
    input  logic        i_tx_reset_sn_sclk_n,
    input  logic        i_rx_reset_sn_sclk_n,

    input  logic        i_all_ready,

    input  logic [95:0] i_ptp_tx_tod,
    input  logic [95:0] i_ptp_rx_tod,
    input  logic        i_ptp_update,

    output logic        o_tx_error_valid_1s,
    output logic        o_tx_error_valid,
    output logic [31:0] o_tx_error,

    output logic [31:0] o_rx_error,
    output logic        o_rx_error_valid,
    output logic        o_rx_error_valid_1s,

    output logic [95:0] o_rx_tam,
    output logic [95:0] o_tx_tam,

    output logic        o_req_tx_tam_load,
    output logic        o_req_rx_tam_load,

    output logic [3:0]  o_tx_w_state_rollover,
    output logic [3:0]  o_rx_w_state_rollover,

    output logic [3:0]  o_tx_w_state_latencyphz,
    output logic [3:0]  o_rx_w_state_latencyphz,

    output logic [31:0] o_tx_w_apulse_count,
    output logic [31:0] o_rx_w_apulse_count,

    output logic [31:0] o_tx_w_skip_ini,
    output logic [31:0] o_rx_w_skip_ini,

  output logic [31:0]  o_tx_w_apulse_rt_period,
  output logic [31:0]  o_tx_w_apulse_sn_period,
  output logic [31:0]  o_tx_w_apulse_err_period,
  output logic [31:0]  o_tx_w_apulse_err2_latency,
  output logic [31:0]  o_rx_w_apulse_rt_period,
  output logic [31:0]  o_rx_w_apulse_sn_period,
  output logic [31:0]  o_rx_w_apulse_err_period,
  output logic [31:0]  o_rx_w_apulse_err2_latency,

    output logic        o_tx_dw_err,
    output logic        o_tx_dw_err2,
    output logic        o_rx_dw_err,
    output logic        o_rx_dw_err2,

    input  logic        i_tx_clb_roll_pulse_phz_2d1s,
    input  logic        i_rx_clb_roll_pulse_phz_2d1s,
    output logic        o_tx_clb_rollover_pulse_minus1,
    output logic        o_rx_clb_rollover_pulse_minus1,

    output logic        o_tx_sclk,
    output logic        o_rx_sclk,
//    input  logic        i_tx_sclk_return,
    input  logic        i_tx_async_pulse_2d_1s,
    input  logic        i_tx_async_pulse_phz_2d_1s,
    input  logic        i_tx_roll_over_sclk_return,
    input  logic        i_tx_am,
//    input  logic        i_rx_sclk_return,
    input  logic        i_rx_async_pulse_2d_1s,
    input  logic        i_rx_async_pulse_phz_2d_1s,
    input  logic        i_rx_roll_over_sclk_return,
    input  logic        i_rx_am,

    output logic        o_tx_calibrate,
    output logic        o_rx_calibrate,
    output logic        o_rx_calibrate2
  );

  localparam  SYNC_FLOPS       = 4'd3;


  logic        rx_dw_err;
  logic        rx_dw_err2;
  logic        tx_all_ready;
  logic        rx_all_ready;
  logic        x_tx_calibrate;
  logic        rx_calibrate_ready;
  logic        rx_calibrate;
  logic        txrx_calibrate;
  logic [31:0] rx_error;

//  logic        trxx_rst_n/* synthesis maxfan = 32 preserve */;  // verilog-95
//  logic        trx_rst_n;
//  logic        txrx_reset_n /* synthesis preserve dont_replicate dont_retime */;
/*

  always @(posedge i_tx_clk) begin
    if (!i_txx_rst_n)
      txrx_reset_n <= 1'b0;
    else if (!trx_rst_n)
      txrx_reset_n <= 1'b0;
    else
      txrx_reset_n <= 1'b1;
  end
*/
//  assign txrx_calibrate = (o_tx_calibrate || rx_calibrate);

`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_all_ready_2ds (
        .clk                (i_tx_clk),
        .reset              (1'b0),
        .d                  (i_all_ready),
        .q                  (tx_all_ready)
    );

`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_all_ready_2ds (
        .clk                (i_rx_clk),
        .reset              (1'b0),
        .d                  (i_all_ready),
        .q                  (rx_all_ready)
    );

`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) x_tx_calibrate_2ds (
        .clk                (i_rx_clk),
        .reset              (1'b0),
        .d                  (o_tx_calibrate),
        .q                  (x_tx_calibrate)
    );

  alt_ehipc3_fm_sl_ptp_sn_wire_delay #(
    .EHIP_RATE_10G_EN    (EHIP_RATE_10G_EN),
             .nTXRX(0)
	)    tx_ptp_sn_wire_delay  (
    .i_sn_config        (i_sn_config),
    .i_ptp_clk          (i_tx_clk),
    .i_ptp_sn_sclk      (i_ptp_sn_sclk),
    .i_reset_n          (i_txx_rst_n),
    .i_reset_sn_sclk_n  (i_tx_reset_sn_sclk_n),

    .i_calibrate        (o_tx_calibrate),
    .i_sn_clb_trig      (o_tx_sclk),
//    .i_async_triger     (i_tx_sclk_return),
    .i_async_pulse_2d_1s         (i_tx_async_pulse_2d_1s),
    .i_async_pulse_phz_2d_1s     (i_tx_async_pulse_phz_2d_1s),
    .i_roll_pulse_phz_2d_1s      (i_tx_clb_roll_pulse_phz_2d1s),
    .i_apulse_period    (i_apulse_period),
    .i_apulse_skip      ((SIM_MODE) ? {16'hFFFF, 16'hf} : {16'hFFFF, 16'hff}),
    .i_apulse_roll_dly  ({8'hf, 8'hff, 16'd8}),
    .i_apulse_cnt_pow2  (i_apulse_cnt_pow2),
    .i_apulse_cnt       (i_apulse_cnt),

    .i_all_ready       (tx_all_ready),
    .i_ui              (i_tx_ui),
    .i_sn_pll_sclk_period    (i_sn_pll_sclk_period),

    .o_skip_ini         (o_tx_w_skip_ini),
    .o_state_latencyphz (o_tx_w_state_latencyphz),
    .o_state_rollover  (o_tx_w_state_rollover),
    .o_apulse_count    (o_tx_w_apulse_count),
    .o_apulse_rt_period (o_tx_w_apulse_rt_period),
    .o_apulse_sn_period (o_tx_w_apulse_sn_period),
    .o_apulse_period_err (o_tx_w_apulse_err_period),
    .o_latency_err2     (o_tx_w_apulse_err2_latency),
    .o_err             (o_tx_dw_err),
    .o_err2            (o_tx_dw_err2),
    .o_sclk            (o_tx_sclk),
    .o_rollover_pulse_minus1   (o_tx_clb_rollover_pulse_minus1),
    .o_calibrate       (o_tx_calibrate),
    .o_calibrate1      (),	// not used
    .o_wd_error        (o_tx_error),
    .o_wd_error_valid_1s  (o_tx_error_valid_1s),
    .o_wd_error_valid  (o_tx_error_valid)

  );

  assign rx_calibrate_ready = ~x_tx_calibrate & rx_all_ready;

  alt_ehipc3_fm_sl_ptp_sn_wire_delay #(
    .EHIP_RATE_10G_EN    (EHIP_RATE_10G_EN),
             .nTXRX(1)
	)    rx_ptp_sn_wire_delay  (
    .i_sn_config        (i_sn_config),
    .i_ptp_clk          (i_rx_clk),
    .i_ptp_sn_sclk      (i_ptp_sn_sclk),
    .i_reset_n          (i_rxx_rst_n),
    .i_reset_sn_sclk_n          (i_rx_reset_sn_sclk_n),

    .i_calibrate        (o_rx_calibrate2),
    .i_sn_clb_trig      (o_rx_sclk),
//    .i_async_triger     (i_rx_sclk_return),
    .i_async_pulse_2d_1s         (i_rx_async_pulse_2d_1s),
    .i_async_pulse_phz_2d_1s     (i_rx_async_pulse_phz_2d_1s),
    .i_roll_pulse_phz_2d_1s      (i_rx_clb_roll_pulse_phz_2d1s),
    .i_apulse_period    (i_apulse_period),
    .i_apulse_skip      ((SIM_MODE) ? {16'hFFFF, 16'hf} : {16'hFFFF, 16'hff}),
    .i_apulse_roll_dly  ({8'hf, 8'hff, 16'd8}),
    .i_apulse_cnt_pow2  (i_apulse_cnt_pow2),
    .i_apulse_cnt       (i_apulse_cnt),

    .i_all_ready       (rx_calibrate_ready),
    .i_ui              (i_rx_ui),
    .i_sn_pll_sclk_period    (i_sn_pll_sclk_period),

    .o_skip_ini         (o_rx_w_skip_ini),
    .o_state_latencyphz  (o_rx_w_state_latencyphz),
    .o_state_rollover  (o_rx_w_state_rollover),
    .o_apulse_count    (o_rx_w_apulse_count),
    .o_apulse_rt_period (o_rx_w_apulse_rt_period),
    .o_apulse_sn_period (o_rx_w_apulse_sn_period),
    .o_apulse_period_err (o_rx_w_apulse_err_period),
    .o_latency_err2     (o_rx_w_apulse_err2_latency),
    .o_err             (o_rx_dw_err),
    .o_err2            (o_rx_dw_err2),
    .o_sclk            (o_rx_sclk),
    .o_rollover_pulse_minus1   (o_rx_clb_rollover_pulse_minus1),
    .o_calibrate       (o_rx_calibrate),
    .o_calibrate1      (o_rx_calibrate2),
    .o_wd_error        (o_rx_error),
    .o_wd_error_valid_1s  (o_rx_error_valid_1s),
    .o_wd_error_valid  (o_rx_error_valid)

  );

/*
    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) trxx_rst_n_2ds (
        .clk                (i_rx_clk),
        .reset              (1'b0),
        .d                  (i_txx_rst_n),
        .q                  (trxx_rst_n)
    );
*/


/*
    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) trx_rst_n_2ds (
        .clk                (i_tx_clk),
        .reset              (1'b0),
        .d                  (i_rxx_rst_n),
        .q                  (trx_rst_n)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_dw_err_2ds (
        .clk                (i_rx_clk),
        .reset              (1'b0),
        .d                  (rx_dw_err),
        .q                  (o_rx_dw_err)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_dw_err2_2ds (
        .clk                (i_rx_clk),
        .reset              (1'b0),
        .d                  (rx_dw_err2),
        .q                  (o_rx_dw_err2)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_calibrate_2ds (
        .clk                (i_rx_clk),
        .reset              (1'b0),
        .d                  (rx_calibrate),
        .q                  (o_rx_calibrate)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_error_2ds (
        .clk                (i_rx_clk),
        .reset              (1'b0),
        .d                  (rx_error),
        .q                  (o_rx_error)
    );
*/

  alt_ehipc3_fm_sl_ptp_tx_tam_capture_sn tx_tam_capture_sn (
    .i_enable_rsfec     (i_enable_rsfec),
    .i_clk              (i_tx_clk),
    .i_ptp_clk          (i_clk),
    .i_ptp_rst_n        (i_tx_rst_n),
    .i_ptp_arst         (i_tx_arst),
    .i_arst_n           (i_txx_arst_n),
    .i_rst_n            (i_txx_rst_n),
    .i_ptp_tx_tod       (i_ptp_tx_tod),
    .i_ptp_update       (i_ptp_update), // unused
    .i_calibrate        (o_tx_calibrate),
    .i_tx_sclk_return   (i_tx_roll_over_sclk_return),
    .i_tx_am            (i_tx_am),
    .o_tx_tam           (o_tx_tam),
    .o_req_tx_tam_load  (o_req_tx_tam_load)
  );

    alt_ehipc3_fm_sl_ptp_rx_tam_capture_sn rx_tam_capture_sn (
    .i_enable_rsfec     (i_enable_rsfec),
    .i_rx_sn_dn         (i_rx_sn_dn),
    .i_rx_ap_roll_dly   (i_rx_ap_roll_dly),
    .i_clk              (i_rx_clk),
    .i_ptp_clk          (i_clk),
    .i_ptp_rst_n        (i_rx_rst_n),
    .i_ptp_arst         (i_rx_arst),
    .i_arst_n           (i_rxx_arst_n),
    .i_rst_n            (i_rxx_rst_n),
    .i_ptp_rx_tod       (i_ptp_rx_tod),
    .i_ptp_update       (i_ptp_update), // unused
    .i_calibrate        (o_rx_calibrate),
    .i_rx_sclk_return   (i_rx_roll_over_sclk_return),
    .i_rx_am            (i_rx_am),
    .o_rx_tam           (o_rx_tam),
    .o_req_rx_tam_load  (o_req_rx_tam_load)
  );

  endmodule : alt_ehipc3_fm_sl_ptp_ref_ts_capture_sn

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
