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
module alt_ehipc3_fm_sl_ptp_ref_ts_capture (
    // Configuration
    input  logic        i_enable_rsfec,

    input  logic        i_clk,
    input  logic        i_tx_rst_n,
    input  logic        i_rx_rst_n,
    input  logic        i_tx_rst_n1,
    input  logic        i_rx_rst_n1,

    input  logic        i_all_ready,

    input  logic [95:0] i_ptp_tod,
    input  logic        i_ptp_update,

    output logic        o_tx_error_valid,
    output logic [31:0] o_tx_error,

    output logic [31:0] o_rx_error,
    output logic        o_rx_error_valid,

    output logic [95:0] o_rx_tam,
    output logic [95:0] o_tx_tam,

    output logic        o_req_tx_tam_load,
    output logic        o_req_rx_tam_load,

    output logic	o_sl_tx_sclk_return_sync,
    output logic	o_sl_rx_sclk_return_sync,

    output logic        o_sclk,
    input  logic        i_tx_sclk_return,
    input  logic        i_tx_am,
    input  logic        i_rx_sclk_return,
    input  logic        i_rx_am,

    output logic        o_tx_calibrate,
    output logic        o_rx_calibrate
  );

  reg  txrx_reset;

  reg  calibrate_n;
  reg  calibrate_n_r;
  reg  calibrate_n_rr1/* synthesis maxfan = 50 */;
  wire calibrate1;


  // For better timing
  always @(posedge i_clk) begin
    txrx_reset <= ~(i_tx_rst_n1 & i_rx_rst_n1);
  end

  assign calibrate1      = !calibrate_n_rr1;
  assign o_tx_calibrate = calibrate1;
  assign o_rx_calibrate = calibrate1;

  always @(posedge i_clk) begin
    if(txrx_reset) begin
        calibrate_n    <= 1'b0;
        calibrate_n_r  <= 1'b0;
	calibrate_n_rr1 <= 1'b0;
    end
    else begin
        if(!calibrate_n && o_tx_error_valid && o_rx_error_valid && i_all_ready) begin
            calibrate_n <= 1'b1;
        end
        calibrate_n_r  <= calibrate_n;
	calibrate_n_rr1 <= calibrate_n_r;
    end
  end

  logic sclk_wire;
   //flop for timing
  always @(posedge i_clk) begin
    if(txrx_reset) begin
        o_sclk <= 1'b0;
    end else begin
        o_sclk <= sclk_wire;
    end
  end

  alt_ehipc3_fm_sl_ptp_ckt_cal ptp_ckt_cal_u (
    .i_clk             (i_clk), //402.832MHz
    .i_rst_n           (!txrx_reset),
    .i_all_ready       (i_all_ready),
    .i_calibrate       (calibrate1),
// -----------------------------------------------------------------------------
// 01/Sep/2020 : slim35 :
// Ciena issue : Not able to to sample i_rx/tx_sclk_return.
// Found alt_ehipc3_fm_sl_ptp_ckt_cal is using unsynchronized version of i_tx_sclk_return.
// Pulling out the synchronized version from alt_ehipc3_fm_sl_ptp_tx/rx_tam_capture to be re-used by alt_ehipc3_fm_sl_ptp_ckt_cal.
// -----------------------------------------------------------------------------
//    .i_rx_sclk_return  (i_rx_sclk_return),
//    .i_tx_sclk_return  (i_tx_sclk_return),
    .i_rx_sclk_return  (o_sl_rx_sclk_return_sync),
    .i_tx_sclk_return  (o_sl_tx_sclk_return_sync),
// -----------------------------------------------------------------------------
    .o_sclk            (sclk_wire),
    .o_tx_error        (o_tx_error),
    .o_tx_error_valid  (o_tx_error_valid),
    .o_rx_error        (o_rx_error),
    .o_rx_error_valid   (o_rx_error_valid));

  alt_ehipc3_fm_sl_ptp_tx_tam_capture tx_tam_capture (
    .i_enable_rsfec     	(i_enable_rsfec),
    .i_clk              	(i_clk),
    .i_rst_n            	(i_tx_rst_n),
    .i_ptp_tod          	(i_ptp_tod),
    .i_ptp_update       	(i_ptp_update), // unused
    .i_calibrate        	(calibrate1),
    .i_tx_sclk_return   	(i_tx_sclk_return),
    .i_tx_am            	(i_tx_am),
    .o_tx_tam           	(o_tx_tam),
    .o_req_tx_tam_load  	(o_req_tx_tam_load),
// -----------------------------------------------------------------------------
// 01/Sep/2020 : slim35 :
// Ciena issue : Not able to to sample i_rx/tx_sclk_return.
// Found alt_ehipc3_fm_sl_ptp_ckt_cal is using unsynchronized version of i_tx_sclk_return.
// -----------------------------------------------------------------------------
    .o_sl_tx_sclk_return_sync 	(o_sl_tx_sclk_return_sync)
// -----------------------------------------------------------------------------
  );

    alt_ehipc3_fm_sl_ptp_rx_tam_capture rx_tam_capture (
    .i_enable_rsfec     (i_enable_rsfec),
    .i_clk              (i_clk),
    .i_rst_n            (i_rx_rst_n),
    .i_ptp_tod          (i_ptp_tod),
    .i_ptp_update       (i_ptp_update), // unused
    .i_calibrate        (calibrate1),
    .i_rx_sclk_return   (i_rx_sclk_return),
    .i_rx_am            (i_rx_am),
    .o_rx_tam           (o_rx_tam),
    .o_req_rx_tam_load  (o_req_rx_tam_load),
// -----------------------------------------------------------------------------
// 01/Sep/2020 : slim35 :
// Ciena issue : Not able to to sample i_rx/tx_sclk_return.
// Found alt_ehipc3_fm_sl_ptp_ckt_cal is using unsynchronized version of i_tx_sclk_return.
// -----------------------------------------------------------------------------
    .o_sl_rx_sclk_return_sync 	(o_sl_rx_sclk_return_sync)
// -----------------------------------------------------------------------------
  );

  endmodule : alt_ehipc3_fm_sl_ptp_ref_ts_capture

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
