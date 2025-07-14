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
// Filename         : alt_ehipc3_fm_ptp.sv
// Author           : Tholu Kiran Kumar <kktholu@intel.com>
// Created On       : Tue Jun 13/06/2017 09:52:41 AM MYT
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
//               ptp_opcode_writer
//               ptp_ref_ts_capture
//               ptp_ts_converter
//------------------------------------------------------------------------------

`timescale 1ns / 1ns
module alt_ehipc3_fm_sl_ptp #(
    parameter SIM_MODE = 0
) (
  // Configuration
  input  logic        i_enable_rsfec,
  input  logic        i_tx_preamble_pass,

  // System Interface
  input  logic        i_ptp_clk,
  input  logic        i_tx_rst_n,
  input  logic        i_rx_rst_n,

  input  logic        i_tx_rst_n1,
  input  logic        i_rx_rst_n1,

  input  logic        i_tx_rst_n2,
  input  logic        i_rx_rst_n2,

  input  logic        i_tx_rst_n3,
  input  logic        i_rx_rst_n3,

  input  logic        i_tx_rst_n4,
  input  logic        i_tx_rst_n5,
  input  logic	      i_tx_rst_n6,
  input  logic	      i_tx_rst_n7,
  input  logic	      i_tx_rst_n8,
  input  logic	      i_tx_rst_n9,

  input  logic        i_tx_arst_n,
  input  logic        i_rx_arst_n,

  input  logic        i_rx_lock,
  input  logic        i_pcs_fully_aligned,
  input  logic        i_all_ready,

  // AVMM CSR Bank Interface
  output logic        o_tx_error_valid,
  output logic [31:0] o_tx_error,
  output logic        o_rx_error_valid,
  output logic [31:0] o_rx_error,
  input  logic        i_ts_format,
  input  logic [31:0] i_tx_ui,
  input  logic [31:0] i_rx_ui,
  input  logic        i_req_tx_ui_load,
  input  logic        i_req_rx_ui_load,
  input  logic [31:0] i_tpiso,
  input  logic [31:0] i_rsipo,
  input  logic [31:0] i_rx_align_offset,

  // User Interface: TOD Interface
  input  logic [95:0] i_ptp_tod,
  input  logic        i_ptp_update,

  // User Interface: PTP Status
  output logic        o_tx_ptp_ready,
  output logic        o_rx_ptp_ready,

  // User Interface: TX Framing Interface
  input  logic        i_tx_valid,
  input  logic        i_tx_sop,
  input  logic        i_tx_eop,
  input  logic        i_tx_inframe,
  input  logic        i_tx_skip_crc,

  // User Interface: TX 1-step Command
  input  logic        i_ptp_ins_ets,
  input  logic        i_ptp_ins_cf,
  input  logic        i_ptp_zero_csum,
  input  logic        i_ptp_update_eb,
  input  logic        i_ptp_ts_format,
  input  logic        i_ptp_asym,
  input  logic [15:0] i_ptp_ts_offset,
  input  logic [15:0] i_ptp_cf_offset,
  input  logic [15:0] i_ptp_csum_offset,
  input  logic [15:0] i_ptp_eb_offset,
  input  logic [95:0] i_ptp_tx_its,

  // User Interface: TX 2-step Timestamp Request
  input  logic        i_ptp_ts_req,
  input  logic [7:0]  i_ptp_fp,

  // User Interface: TX 2-step Timestamp Return
  output logic        o_ptp_ets_valid,
  output logic [95:0] o_ptp_ets,
  output logic [7:0]  o_ptp_ets_fp,

  // User Interface: RX Timestamp
  output logic [95:0] o_ptp_rx_its,
  output logic        o_ptp_rx_its_valid,

  // EHIP Interface: TX 1-step and 2-step Command
  output logic [1:0]  o_ptp_tx_fp,
  output logic [2:0]  o_ptp_ins_type,
  output logic [2:0]  o_ptp_byte_offset,
  output logic [23:0] o_ptp_ts,

  // EHIP Interface: TX 2-step Timestamp
  input  logic        i_ptp_tx_ts_valid,
  input  logic [11:0] i_ptp_tx_ts,
  input  logic [1:0]  i_ptp_tx_fp,

  // EHIP Interface: RX Timestamp
  input  logic        i_rx_valid,
  input  logic        i_rx_inframe,
  input  logic [20:0] i_ptp_rx_ts,

  // EHIP Interface: Reference Timestamp
  output logic        o_sl_tx_sclk_return_sync,
  output logic        o_sclk,
  output logic        o_sl_tx_sel_sclk_return,
  output logic        o_sl_rx_sel_sclk_return,
  input  logic        i_tx_sclk_return,
  input  logic        i_rx_sclk_return,
  input  logic        i_tx_am,
  input  logic        i_rx_am,
  input  logic        i_rx_am_dsk,

  // TAM capture and AM counts
  output logic [47:0] o_tx_tam_capture,
  output logic [15:0] o_tx_tam_count,
  output logic        o_tx_tam_cap_valid,
  output logic [47:0] o_rx_tam_capture,
  output logic [15:0] o_rx_tam_count,
  output logic        o_rx_tam_cap_valid,

  // Deskew status
  input  logic        i_ptp_rx_aib_dsk_done,
  output logic        o_ptp_rx_aib_dsk_done,

            // Before stage 2 deskew signals
  input logic         i_rx_am_b4_dsk,
  input logic         i_rx_valid_b4_dsk,
  input logic         i_sl_ptp_rx_aib_dsk_done_b4_dsk

  );

  localparam SAMPLING_CLK_PERIOD = 18'h27B80;

  localparam TX_TAM_ADJUST_CONST  = (SAMPLING_CLK_PERIOD * (4 + 1 - 1)) // Subtract: 4 stages of synchronizer for i_tx_sclk_return, 1 stage of TOD sampling delay to meet timing, add 1 to get latest TOD instead of previous cycle
                                    + (SAMPLING_CLK_PERIOD >> 1)       // Subtract: Half cycle for sampling uncertainty
// -----------------------------------------------------------------------------
// 01/Sep/2020 : slim35 :
// Ciena issue : Not able to to sample i_rx/tx_sclk_return.
// Found alt_ehipc3_fm_sl_ptp_ckt_cal is using unsynchronized version of i_tx_sclk_return.
// By switching to use synchornized version (4 stages), TX/RX_TAM_ADJUST_CONST needs to be offset by 4/2 = 2 cycles delay.
// -----------------------------------------------------------------------------
                                    - (SAMPLING_CLK_PERIOD * 2)       // Add: 4 cycle delay for i_tx/rx_sclk_return synchornizer delay. So one way is 2 cycle.
// -----------------------------------------------------------------------------
                                    - (SAMPLING_CLK_PERIOD >> 1);      // Add: 1 cycle delay for o_sclk for timing. So one way is 0.5 cycle.

  localparam RX_TAM_ADJUST_CONST  = (SAMPLING_CLK_PERIOD * (4 - 1))     // Subtract: 4 stages of synchronizer for i_rx_sclk_return, add 1 to get latest TOD instead of previous cycle
                                    + (SAMPLING_CLK_PERIOD >> 1)       // Subtract: Half cycle for sampling uncertainty
// -----------------------------------------------------------------------------
// 01/Sep/2020 : slim35 :
// Ciena issue : Not able to to sample i_rx/tx_sclk_return.
// Found alt_ehipc3_fm_sl_ptp_ckt_cal is using unsynchronized version of i_tx_sclk_return.
// By switching to use synchornized version (4 stages), TX/RX_TAM_ADJUST_CONST needs to be offset by 4/2 = 2 cycles delay.
// -----------------------------------------------------------------------------
                                    - (SAMPLING_CLK_PERIOD * 2)        // Add: 4 cycle delay for i_tx/rx_sclk_return synchornizer delay. So one way is 2 cycle.
// -----------------------------------------------------------------------------
                                    - (SAMPLING_CLK_PERIOD >> 1);      // Add: 1 cycle delay for o_sclk for timing. So one way is 0.5 cycle.


  localparam TX_TAM_ADJUST_UI     = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                    - (2);   // Add: Block sync header

  localparam TX_TAM_ADJUST_UI_FEC = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                    + (32)   // 3 cycles behind the async pulse
                                    - (2);   // Add: Block sync header

  localparam RX_TAM_ADJUST_UI     = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                    + (32)   // Subtract: 1 div32 clock period due to serial data to parallel data delay
                                    - (2);   // Add: Block sync header

  localparam RX_TAM_ADJUST_UI_FEC = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                    + (32)   // Subtract: 1 div32 clock period due to serial data to parallel data delay
                                    + (32)   // Subtract: 1 div32 clock period in RSFEC mode
                                    - (2);   // Add: Block sync header

  localparam RX_TAM_ADJUST_UI_ADJ = RX_TAM_ADJUST_UI + 66  // Subtract: Adjustment in RSFEC mode when AM position shifted due to EOP
                                    + 32;                  // Subtract: 1 div32 clock period in RSFEC mode

  //avoid using DSP because no DSP in S10 NX device
  localparam UI_10G = 16'h18D3;
  localparam UI_25G = 16'h9EE;

  localparam TX_TAM_ADJUST_UI_10G     = TX_TAM_ADJUST_UI*UI_10G;
  localparam TX_TAM_ADJUST_UI_FEC_10G = TX_TAM_ADJUST_UI_FEC*UI_10G;
  localparam RX_TAM_ADJUST_UI_10G     = RX_TAM_ADJUST_UI*UI_10G;
  localparam RX_TAM_ADJUST_UI_FEC_10G = RX_TAM_ADJUST_UI_FEC*UI_10G;
  localparam RX_TAM_ADJUST_UI_ADJ_10G = RX_TAM_ADJUST_UI_ADJ*UI_10G;

  localparam TX_TAM_ADJUST_UI_25G     = TX_TAM_ADJUST_UI*UI_25G;
  localparam TX_TAM_ADJUST_UI_FEC_25G = TX_TAM_ADJUST_UI_FEC*UI_25G;
  localparam RX_TAM_ADJUST_UI_25G     = RX_TAM_ADJUST_UI*UI_25G;
  localparam RX_TAM_ADJUST_UI_FEC_25G = RX_TAM_ADJUST_UI_FEC*UI_25G;
  localparam RX_TAM_ADJUST_UI_ADJ_25G = RX_TAM_ADJUST_UI_ADJ*UI_25G;

  localparam PIPE1 = 8;

  logic [95:0] tx_tam;
  logic [95:0] rx_tam;
  logic        req_tx_tam_load;
  logic        req_rx_tam_load;

  (* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) logic [PIPE1*16-1:0] tx_ui_r;
  (* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) logic [PIPE1*16-1:0] rx_ui_r;
  logic [PIPE1*8-1:0] tx_tam_adjust_ui_r;
  logic [PIPE1*8-1:0] rx_tam_adjust_ui_r;
  logic [PIPE1*8-1:0] rx_tam_adjust_ui_adj_r;

  logic [23:0] tx_tam_adjust;
  logic [23:0] rx_tam_adjust_no_adj;
  logic [23:0] rx_tam_adjust_adj;

  logic [39:0] tx_tam_adjust_r;
  logic [39:0] rx_tam_adjust_no_adj_r;
  logic [39:0] rx_tam_adjust_adj_r;

  logic [39:0] tx_tam_adjust_rr;
  logic [39:0] rx_tam_adjust_no_adj_rr;
  logic [39:0] rx_tam_adjust_adj_rr;

  logic [40:0] tx_tam_adjust_total;
  logic        tx_tam_adjust_total_carry;
  logic [40:0] rx_tam_adjust_no_adj_total;
  logic        rx_tam_adjust_no_adj_total_carry;
  logic [40:0] rx_tam_adjust_adj_total;
  logic        rx_tam_adjust_adj_total_carry;

  logic [40:0] tx_tam_adjust_total_r;
  logic [40:0] rx_tam_adjust_no_adj_total_r;
  logic [40:0] rx_tam_adjust_adj_total_r;

  logic [40:0] tx_tam_adjust_total_rr;
  logic [40:0] rx_tam_adjust_no_adj_total_rr;
  logic [40:0] rx_tam_adjust_adj_total_rr;

  logic [41:0] tx_tam_adjust_w_err;
  logic        tx_tam_adjust_w_err_carry;
  logic [41:0] rx_tam_adjust_no_adj_w_err;
  logic        rx_tam_adjust_no_adj_w_err_carry;
  logic [41:0] rx_tam_adjust_adj_w_err;
  logic        rx_tam_adjust_adj_w_err_carry;

  logic [41:0] tx_tam_adjust_w_err_r;
  logic [41:0] rx_tam_adjust_no_adj_w_err_r;
  logic [41:0] rx_tam_adjust_adj_w_err_r;

  logic [41:0] tx_tam_adjust_final;
  logic [41:0] rx_tam_adjust_final;

  logic [31:0] tx_tam_adj;
  logic [31:0] rx_tam_adj;

  logic        tx_calibrate;
  logic        rx_calibrate;
  logic        modify_ts;

  logic        is_10g;

  assign o_sl_tx_sel_sclk_return = ~tx_calibrate;
  assign o_sl_rx_sel_sclk_return = ~rx_calibrate;

  always @(posedge i_ptp_clk) begin
      is_10g                                                <= i_tx_ui[20]; //UI of 10G is 24'h18D300 while 25G is 24'h9ee00. Thus bit[20]=1 indicate now is 10G.
      tx_tam_adjust                                         <= i_enable_rsfec ? TX_TAM_ADJUST_UI_FEC_25G[23:0]: //FEC, must be 25G
                                                               is_10g ? TX_TAM_ADJUST_UI_10G[23:0]: //No FEC 10G
                                                                        TX_TAM_ADJUST_UI_25G[23:0]; //No FEC 25G

      tx_tam_adjust_r                                       <= {8'h0,tx_tam_adjust,8'h0};
      tx_tam_adjust_rr                                      <= tx_tam_adjust_r;

      {tx_tam_adjust_total_carry,tx_tam_adjust_total[19:0]} <= {TX_TAM_ADJUST_CONST[11:0], 8'h00} + tx_tam_adjust_rr[19:0];
      tx_tam_adjust_total[40:20]                            <= TX_TAM_ADJUST_CONST[20:12] + tx_tam_adjust_rr[39:20];

      tx_tam_adjust_total_r[19:0]                           <= tx_tam_adjust_total[19:0];
      tx_tam_adjust_total_r[40:20]                          <= 21'(tx_tam_adjust_total[40:20] + tx_tam_adjust_total_carry);

      tx_tam_adjust_total_rr                                <= tx_tam_adjust_total_r;

      {tx_tam_adjust_w_err_carry,tx_tam_adjust_w_err[19:0]} <= {o_tx_error[11:0], 8'h00} + tx_tam_adjust_total_rr[19:0];
      tx_tam_adjust_w_err[41:20]                            <= o_tx_error[31:12] + tx_tam_adjust_total_rr[40:20];

      tx_tam_adjust_w_err_r[19:0]                           <= tx_tam_adjust_w_err[19:0];
      tx_tam_adjust_w_err_r[41:20]                          <= 22'(tx_tam_adjust_w_err[41:20] + tx_tam_adjust_w_err_carry);
  end


  always @(posedge i_ptp_clk) begin
      rx_tam_adjust_no_adj            <= i_enable_rsfec ? RX_TAM_ADJUST_UI_FEC_25G[23:0]://FEC, must be 25G
                                         is_10g ? RX_TAM_ADJUST_UI_10G[23:0]://No FEC 10G
                                                  RX_TAM_ADJUST_UI_25G[23:0];//No FEC 25G

      rx_tam_adjust_adj               <= RX_TAM_ADJUST_UI_ADJ_25G[23:0];//FEC, must be 25G

      rx_tam_adjust_no_adj_r          <= {8'h0,rx_tam_adjust_no_adj,8'h0};
      rx_tam_adjust_adj_r             <= {8'h0,rx_tam_adjust_adj,8'h0};

      rx_tam_adjust_no_adj_rr         <= rx_tam_adjust_no_adj_r;
      rx_tam_adjust_adj_rr            <= rx_tam_adjust_adj_r;

      {rx_tam_adjust_no_adj_total_carry,rx_tam_adjust_no_adj_total[19:0]}      <= {RX_TAM_ADJUST_CONST[11:0], 8'h00} + rx_tam_adjust_no_adj_rr[19:0];
      rx_tam_adjust_no_adj_total[40:20]                                        <= RX_TAM_ADJUST_CONST[20:12] + rx_tam_adjust_no_adj_rr[39:20];
      {rx_tam_adjust_adj_total_carry,rx_tam_adjust_adj_total[19:0]}         <= {RX_TAM_ADJUST_CONST[11:0], 8'h00} + rx_tam_adjust_adj_rr[19:0];
      rx_tam_adjust_adj_total[40:20]                                        <= RX_TAM_ADJUST_CONST[20:12] + rx_tam_adjust_adj_rr[39:20];

      rx_tam_adjust_no_adj_total_r[19:0]    <= rx_tam_adjust_no_adj_total[19:0];
      rx_tam_adjust_no_adj_total_r[40:20]    <= 21'(rx_tam_adjust_no_adj_total[40:20] + rx_tam_adjust_no_adj_total_carry);
      rx_tam_adjust_adj_total_r[19:0]       <= rx_tam_adjust_adj_total[19:0];
      rx_tam_adjust_adj_total_r[40:20]       <= 21'(rx_tam_adjust_adj_total[40:20] + rx_tam_adjust_adj_total_carry);

      rx_tam_adjust_no_adj_total_rr   <= rx_tam_adjust_no_adj_total_r;
      rx_tam_adjust_adj_total_rr      <= rx_tam_adjust_adj_total_r;

      {rx_tam_adjust_no_adj_w_err_carry,rx_tam_adjust_no_adj_w_err[19:0]}      <= {o_rx_error[11:0], 8'h00} + rx_tam_adjust_no_adj_total_rr[19:0];
      rx_tam_adjust_no_adj_w_err[41:20]                                        <= o_rx_error[31:12] + rx_tam_adjust_no_adj_total_rr[40:20];
      {rx_tam_adjust_adj_w_err_carry,rx_tam_adjust_adj_w_err[19:0]}         <= {o_rx_error[11:0], 8'h00} + rx_tam_adjust_adj_total_rr[19:0];
      rx_tam_adjust_adj_w_err[41:20]                                        <= o_rx_error[31:12] + rx_tam_adjust_adj_total_rr[40:20];

      rx_tam_adjust_no_adj_w_err_r[19:0]    <= rx_tam_adjust_no_adj_w_err[19:0];
      rx_tam_adjust_no_adj_w_err_r[41:20]    <= 22'(rx_tam_adjust_no_adj_w_err[41:20]+rx_tam_adjust_no_adj_w_err_carry);
      rx_tam_adjust_adj_w_err_r[19:0]       <= rx_tam_adjust_adj_w_err[19:0];
      rx_tam_adjust_adj_w_err_r[41:20]       <= 22'(rx_tam_adjust_adj_w_err[41:20] + rx_tam_adjust_adj_w_err_carry);
  end

  assign tx_tam_adjust_final = tx_tam_adjust_w_err_r;
  assign rx_tam_adjust_final = modify_ts ? rx_tam_adjust_adj_w_err_r : rx_tam_adjust_no_adj_w_err_r;

// ---------------------------------------------------------------------------------------------------------------------------------
// 10/Dec/2018 : slim35 : https://hsdes.intel.com/appstore/article/#/2205692107 : Crete 3 hard logic costs too much soft logic.
// Reduce alt_ehipc3_fm_sl_ptp_compute_ts pipeline from 12 to 4 and hence the param needs to be revised.
// In addition to pipeline reduction, the new code is using bit31 of correction_value as part of the value instead of signed bit previously.
// Therefore, the bit31 of input correction_value has to be tied to 1'b0 instead of 1'b1.
// The bit31 is previously tied to 1'b1 to always do a subtraction.
// ---------------------------------------------------------------------------------------------------------------------------------
//  assign tx_tam_adj = {1'b1, tx_tam_adjust_final[38:8]};
//  assign rx_tam_adj = {1'b1, rx_tam_adjust_final[38:8]};
  assign tx_tam_adj = {1'b0, tx_tam_adjust_final[38:8]};
  assign rx_tam_adj = {1'b0, rx_tam_adjust_final[38:8]};
// ---------------------------------------------------------------------------------------------------------------------------------

  alt_ehipc3_fm_sl_ptp_tam_adj_detect tam_adj_detect_u(
    .i_enable_rsfec     (i_enable_rsfec),
    .i_clk              (i_ptp_clk),
    .i_rst_n            (i_rx_rst_n),
    .i_rx_valid         (i_rx_valid_b4_dsk),
    .i_rx_am            (i_rx_am_b4_dsk),
    .i_pcs_fully_aligned(i_pcs_fully_aligned),
    .i_sl_ptp_rx_aib_dsk_done_b4_dsk(i_sl_ptp_rx_aib_dsk_done_b4_dsk),
    .o_modify_ts        (modify_ts)
  );


  alt_ehipc3_fm_sl_ptp_ref_ts_capture ptp_ref_ts_capture_u (
    .i_enable_rsfec             (i_enable_rsfec),
    .i_clk              	(i_ptp_clk),
    .i_tx_rst_n        	        (i_tx_rst_n),
    .i_rx_rst_n         	(i_rx_rst_n2),
    .i_tx_rst_n1	        (i_tx_rst_n1),
    .i_rx_rst_n1	        (i_rx_rst_n1),
    .i_all_ready	        (i_all_ready),
    .i_ptp_tod		        (i_ptp_tod),
    .i_ptp_update        	(i_ptp_update),
    .o_tx_error_valid  	        (o_tx_error_valid),
    .o_tx_error   	        (o_tx_error),
    .o_rx_error       	        (o_rx_error),
    .o_rx_error_valid           (o_rx_error_valid),
    .o_rx_tam          	        (rx_tam),
    .o_tx_tam		        (tx_tam),
    .o_req_tx_tam_load          (req_tx_tam_load),
    .o_req_rx_tam_load 	        (req_rx_tam_load),
    .o_sl_tx_sclk_return_sync	(o_sl_tx_sclk_return_sync),
    .o_sclk		        (o_sclk),
    .i_tx_sclk_return           (i_tx_sclk_return),
    .i_tx_am           	        (i_tx_am),
    .i_rx_sclk_return           (i_rx_sclk_return),
    .i_rx_am	                (i_rx_am),
    .o_tx_calibrate		(tx_calibrate),
    .o_rx_calibrate	        (rx_calibrate));

  alt_ehipc3_fm_sl_ptp_opcode_writer #(
    .SIM_MODE            (SIM_MODE)
  ) ptp_opcode_writer_u (
    .i_enable_rsfec      (i_enable_rsfec),
    .i_tx_preamble_pass  (i_tx_preamble_pass),
    .i_clk               (i_ptp_clk),
    .i_rst_n             (i_tx_rst_n2),
    .i_rst_n1            (i_tx_rst_n4),
    .i_rst_n2            (i_tx_rst_n5),
    .i_rst_n3		 (i_tx_rst_n6),
    .i_rst_n4		 (i_tx_rst_n7),
    .i_rst_n5		 (i_tx_rst_n8),
    .i_rst_n6		 (i_tx_rst_n9),
    .i_rx_lock           (i_rx_lock),
    .i_ptp_fp            (i_ptp_fp),
    .i_ptp_ins_ets       (i_ptp_ins_ets),
    .i_ptp_ins_cf        (i_ptp_ins_cf),
    .i_ptp_zero_csum     (i_ptp_zero_csum),
    .i_ptp_update_eb     (i_ptp_update_eb),
    .i_ptp_ts_format     (i_ptp_ts_format),
    .i_ptp_asym          (i_ptp_asym),
    .i_ptp_ts_offset     (i_ptp_ts_offset),
    .i_ptp_cf_offset     (i_ptp_cf_offset),
    .i_ptp_csum_offset   (i_ptp_csum_offset),
    .i_ptp_eb_offset     (i_ptp_eb_offset),
    .i_ptp_tx_its        (i_ptp_tx_its),
    .i_ptp_ts_req        (i_ptp_ts_req),
    .i_tx_valid          (i_tx_valid),
    .i_tx_sop            (i_tx_sop),
    .i_tx_eop            (i_tx_eop),
    .i_tx_inframe        (i_tx_inframe),
    .i_tx_skip_crc       (i_tx_skip_crc),
    .i_req_tx_tam_load   (req_tx_tam_load),
    .i_req_rx_tam_load   (req_rx_tam_load),
    .i_req_tx_ui_load    (i_req_tx_ui_load),
    .i_req_rx_ui_load    (i_req_rx_ui_load),
    .i_tx_tam            (tx_tam),
    .i_tx_tam_adj        (tx_tam_adj),
    .i_rx_tam_adj        (rx_tam_adj),
    .i_rx_tam            (rx_tam),
    .i_tx_ui             (i_tx_ui),
    .i_rx_ui             (i_rx_ui),
    .o_ptp_tx_fp         (o_ptp_tx_fp),
    .o_ptp_ins_type      (o_ptp_ins_type),
    .o_ptp_byte_offset   (o_ptp_byte_offset),
    .o_tx_ptp_ready      (o_tx_ptp_ready),
    .o_rx_ptp_ready      (o_rx_ptp_ready),
    .o_ptp_ts            (o_ptp_ts),
    .i_ptp_rx_aib_dsk_done(i_ptp_rx_aib_dsk_done),
    .o_ptp_rx_aib_dsk_done(o_ptp_rx_aib_dsk_done)
  );

  alt_ehipc3_fm_sl_ptp_ts_converter ptp_ts_converter_u(
    .i_clk              (i_ptp_clk),
    .i_tx_rst_n         (i_tx_rst_n3),
    .i_rx_rst_n         (i_rx_rst_n3),
    .i_ptp_tx_ts_valid  (i_ptp_tx_ts_valid),
    .i_ptp_tx_ts        (i_ptp_tx_ts),
    .i_ptp_tx_fp        (i_ptp_tx_fp),
    .i_rx_valid         (i_rx_valid),
    .i_rx_inframe       (i_rx_inframe),
    .i_ptp_rx_ts        (i_ptp_rx_ts),
    .i_ts_format        (i_ts_format),
    .i_tod              (i_ptp_tod),
    .o_ptp_ets_valid    (o_ptp_ets_valid),
    .o_ptp_ets          (o_ptp_ets),
    .o_ptp_ets_fp       (o_ptp_ets_fp),
    .o_ptp_rx_its       (o_ptp_rx_its),
    .o_ptp_rx_its_valid (o_ptp_rx_its_valid)
  );

  alt_ehipc3_fm_sl_ptp_tam_capture_count ptp_tam_capture_count_u(
    .i_tx_clk           (i_ptp_clk),
    .i_tx_rst_n         (i_tx_rst_n),
    .i_tx_tam           (tx_tam[47:0]),
    .i_tx_tam_load      (req_tx_tam_load),
    .o_tx_tam_capture   (o_tx_tam_capture),
    .o_tx_tam_count     (o_tx_tam_count),
    .o_tx_tam_cap_valid (o_tx_tam_cap_valid),
    .i_rx_clk           (i_ptp_clk),
    .i_rx_rst_n         (i_rx_rst_n),
    .i_rx_tam           (rx_tam[47:0]),
    .i_rx_tam_load      (req_rx_tam_load),
    .o_rx_tam_capture   (o_rx_tam_capture),
    .o_rx_tam_count     (o_rx_tam_count),
    .o_rx_tam_cap_valid (o_rx_tam_cap_valid)
  );

endmodule : alt_ehipc3_fm_sl_ptp

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
