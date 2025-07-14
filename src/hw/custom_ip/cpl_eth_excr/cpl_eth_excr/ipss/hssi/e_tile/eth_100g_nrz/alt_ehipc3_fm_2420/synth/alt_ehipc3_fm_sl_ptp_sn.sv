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
//------------------------------------------------------------------------------
//
// Filename         : alt_ehipc3_fm_sl_ptp_sn.sv
// Author           : Shoaib Sial <shoaib.sial@intel.com>
// Created On       : Wed Sep 11/09/2019
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
module alt_ehipc3_fm_sl_ptp_sn #(
    parameter ENHANCED_PTP_ACCURACY = 0,
    parameter ehip_rate_sl      = "rate_25gx1",
    parameter SIM_MODE = 0
) (
  // Configuration
  input  logic        i_enable_rsfec,
  input  logic        i_tx_preamble_pass,

 //1ns
  input  logic [0:0] i_ptp_sn_sclk,


  output logic [31:0]  o_txrx_dt_status,
  output logic [31:0]  o_rx_dt_reg,
  output logic [31:0]  o_tx_dt_reg,

  output logic [31:0]  o_tx_apulse_rt_period,
  output logic [31:0]  o_tx_apulse_sn_period,
  output logic [31:0]  o_tx_apulse_err_period,
  output logic [31:0]  o_tx_apulse_err2_latency,
  output logic [31:0]  o_rx_apulse_rt_period,
  output logic [31:0]  o_rx_apulse_sn_period,
  output logic [31:0]  o_rx_apulse_err_period,
  output logic [31:0]  o_rx_apulse_err2_latency,

  output logic [31:0]  o_tx_w_apulse_rt_period,
  output logic [31:0]  o_tx_w_apulse_sn_period,
  output logic [31:0]  o_tx_w_apulse_err_period,
  output logic [31:0]  o_tx_w_apulse_err2_latency,
  output logic [31:0]  o_rx_w_apulse_rt_period,
  output logic [31:0]  o_rx_w_apulse_sn_period,
  output logic [31:0]  o_rx_w_apulse_err_period,
  output logic [31:0]  o_rx_w_apulse_err2_latency,

  output logic [3:0]  o_tx_state_rollover,
  output logic [3:0]  o_rx_state_rollover,
  output logic [3:0]  o_tx_w_state_rollover,
  output logic [3:0]  o_rx_w_state_rollover,

  output logic [3:0]  o_tx_state_latencyphz,
  output logic [3:0]  o_rx_state_latencyphz,
  output logic [3:0]  o_tx_w_state_latencyphz,
  output logic [3:0]  o_rx_w_state_latencyphz,

  output logic [3:0]  o_tx_state_transition,
  output logic [3:0]  o_rx_state_transition,

  output logic [31:0]  o_tx_apulse_count,
  output logic [31:0]  o_rx_apulse_count,
  output logic [31:0]  o_tx_w_apulse_count,
  output logic [31:0]  o_rx_w_apulse_count,

  output logic [31:0]  o_tx_skip_ini,
  output logic [31:0]  o_rx_skip_ini,
  output logic [31:0]  o_tx_w_skip_ini,
  output logic [31:0]  o_rx_w_skip_ini,

////
  output logic [95:0] tx_tam_dbg,
  output logic [95:0] rx_tam_dbg,

  output logic [31:0] tx_tam_adjust_avg_dbg,
  output logic [31:0] rx_tam_adjust_avg_dbg,

  output logic [31:0] tx_ui_r_dbg,
  output logic [31:0] rx_ui_r_dbg,

  output logic [11:0] tx_tam_adjust_ui_r_dbg,
  output logic [11:0] rx_tam_adjust_ui_r_dbg,

  output logic [43:0] tx_tam_adjust_dbg,
  output logic [43:0] rx_tam_adjust_no_adj_dbg,

  output logic [31:0] tx_tam_adj_dbg,
  output logic [31:0] rx_tam_adj_dbg,

////
  // System Interface
  input  logic        i_ptp_clk,
  input  logic        i_ptp_tx_clk,
  input  logic        i_ptp_rx_clk,
  input  logic        i_tx_rst_n,
  input  logic        i_rx_rst_n,

  input  logic        i_tx_rst_n1,
  input  logic        i_rx_rst_n1,

  input  logic        i_tx_rst_n2,
  input  logic        i_rx_rst_n2,

  input  logic        i_tx_rst_n3,
  input  logic        i_rx_rst_n3,

  input  logic        i_tx_rst_n4,
  input  logic	      i_rx_rst_n4,

  input  logic        i_tx_rst_n5,
  input  logic	      i_tx_rst_n6,
  input  logic	      i_tx_rst_n7,
  input  logic	      i_tx_rst_n8,
  input  logic	      i_tx_rst_n9,
  input  logic	      i_tx_rst_n10,

  input  logic	      i_tx_arst,
  input  logic	      i_rx_arst,

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
  input  logic [95:0] i_ptp_tx_tod,
  input  logic [95:0] i_ptp_rx_tod,
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
  output logic        o_sclk,
  output logic	      o_sl_tx_sclk_return_sync,
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


  localparam  SYNC_FLOPS       = 4'd3;

  localparam CLK_DIV =   66;

  localparam TX_TAM_ADJUST_CONST_DT_UI  = (CLK_DIV * (3 + 1)); // Subtract: 3 stages of synchronizer for i_tx_sclk_return, 1 stage of TOD sampling delay to meet timing

  localparam RX_TAM_ADJUST_CONST_DT_UI  = (CLK_DIV * (3 ));    // Subtract: 3 stages of synchronizer for i_rx_sclk_return

  localparam RX_FEC_ERR_ADJUST_CONST_UI = 0; // (CLK_DIV >> 1 );       // Subtract: Half cycle for constant error adujstment
  localparam RX_10G_ERR_ADJUST_CONST_UI = 0; // ((CLK_DIV >> 1 ) + (CLK_DIV >> 2 )); // Subtract: 75% cycle for constant error adujstment
  localparam RX_25G_ERR_ADJUST_CONST_UI = 0;       // Subtract: Half cycle for constant error adujstment

  localparam TX_TAM_ADJUST_CONST_UI  = (CLK_DIV * (3 + 1 - 1)) // Subtract: 3 stages of synchronizer for i_tx_sclk_return, 1 stage of TOD sampling delay to meet timing, add 1 to get latest TOD instead of previous cycle
                                    + (CLK_DIV >> 1);       // Subtract: Half cycle for sampling uncertainty

  localparam RX_TAM_ADJUST_CONST_UI  = (CLK_DIV * (3 - 1))     // Subtract: 3 stages of synchronizer for i_rx_sclk_return, add 1 to get latest TOD instead of previous cycle
                                    + (CLK_DIV >> 1);       // Subtract: Half cycle for sampling uncertainty


  localparam TX_TAM_ADJUST_UI     = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                    - (2)    // Add: Block sync header
                                    + TX_TAM_ADJUST_CONST_UI;
  localparam TX_TAM_ADJUST_UI_FEC = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
				    + (32)   // Subtract: 1 div32 clock period in RSFEC mode
                                    - (2)    // Add: Block sync header
                                    + TX_TAM_ADJUST_CONST_UI;

  localparam RX_TAM_ADJUST_UI     = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                    + (32)   // Subtract: 1 div32 clock period due to serial data to parallel data delay
                                    - (2);   // Add: Block sync header
  localparam RX_TAM_ADJUST_UI_FEC = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                    + (32)   // Subtract: 1 div32 clock period due to serial data to parallel data delay
                                    + (32)   // Subtract: 1 div32 clock period in RSFEC mode
                                    - (2);   // Add: Block sync header

  localparam RX_TAM_ADJUST_UI_ADJ = RX_TAM_ADJUST_UI + 66  // Subtract: Adjustment in RSFEC mode when AM position shifted due to EOP
                                    + 32;                  // Subtract: 1 div32 clock period in RSFEC mode

  localparam TX_TAM_ADJUST_UI2    = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                    - (2)    // Add: Block sync header
                                     + TX_TAM_ADJUST_CONST_DT_UI;
  localparam TX_TAM_ADJUST_UI_FEC2 = (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
				    + (32)   // Subtract: 1 div32 clock period in RSFEC mode
                                    - (2)    // Add: Block sync header
                                     + TX_TAM_ADJUST_CONST_DT_UI;

  localparam RX_TAM_ADJUST_UI2     = RX_TAM_ADJUST_UI + RX_TAM_ADJUST_CONST_DT_UI;
  localparam RX_TAM_ADJUST_UI_FEC2 = RX_TAM_ADJUST_UI_FEC + RX_TAM_ADJUST_CONST_DT_UI;

  localparam RX_TAM_ADJUST_UI_ADJ2 = RX_TAM_ADJUST_UI2 + 66  // Subtract: Adjustment in RSFEC mode when AM position shifted due to EOP
                                    + 32;                    // Subtract: 1 div32 clock period in RSFEC mode

  localparam TX_TAM_ADJUST_10G_CALC            = 44'h0001C69814A ;
  localparam TX_TAM_ADJUST_10G_SN_CALC         = 44'h0001F9CB48C ;

  localparam RX_TAM_ADJUST_NOADJ_10G_CALC      = 44'h000091D7ABC ;
  localparam RX_TAM_ADJUST_NOADJ_10G_SN_CALC   = 44'h0001c50ae48 ;

  localparam RX_TAM_ADJUST_10G_CALC            = 44'h000129E4180 ;
  localparam RX_TAM_ADJUST_10G_SN_CALC         = 44'h00025d1750c ;

  localparam EHIP_RATE_10G_EN                  = 0 ;

  logic is_10g;
  logic ehip_rate_sl_eq_rate_25gx1_fec;
  logic ehip_rate_sl_eq_rate_25gx1;
  logic ehip_rate_sl_eq_rate_10gx1_25lr;
  logic ehip_rate_sl_eq_rate_10gx1;

  logic [43:0] TX_TAM_ADJUST_CALC          ;
  logic [43:0] TX_TAM_ADJUST_SN_CALC       ;
  logic [43:0] RX_TAM_ADJUST_NOADJ_CALC    ;
  logic [43:0] RX_TAM_ADJUST_NOADJ_SN_CALC ;
  logic [43:0] RX_TAM_ADJUST_CALC          ;
  logic [43:0] RX_TAM_ADJUST_SN_CALC       ;

  logic [31:0] TX_ASYNC_PULSE_PERIOD       ;
  logic [31:0] TX_APULSE_SKIP              ;
  logic [31:0] TX_APULSE_ROLL_DLY          ;
  logic [31:0] TX_APULSE_CNT               ;
  logic [31:0] TX_APULSE_CNT_POW2          ;
  logic [31:0] TX_SN_CONFIG                ;

  logic [31:0] RX_ASYNC_PULSE_PERIOD       ;
  logic [31:0] RX_APULSE_SKIP              ;
  logic [31:0] RX_APULSE_ROLL_DLY          ;
  logic [31:0] RX_APULSE_CNT               ;
  logic [31:0] RX_APULSE_CNT_POW2          ;
  logic [31:0] RX_SN_CONFIG                ;

  logic [31:0] SN_PLL_SCLK_PERIOD;

  always @(posedge i_ptp_clk) begin
      is_10g <= i_tx_ui[20]; //UI of 10G is 24'h18D300 while 25G is 24'h9ee00. Thus bit[20]=1 indicate now is 10G.
  end

  assign ehip_rate_sl_eq_rate_25gx1_fec        = !is_10g &&  i_enable_rsfec;
  assign ehip_rate_sl_eq_rate_25gx1            = !is_10g && !i_enable_rsfec;
  assign ehip_rate_sl_eq_rate_10gx1_25lr       =  is_10g;
  assign ehip_rate_sl_eq_rate_10gx1            =  is_10g;

  assign     TX_TAM_ADJUST_CALC                = is_10g ? TX_TAM_ADJUST_10G_CALC : 44'h0000b5d6725 ;
  localparam TX_TAM_ADJUST_FEC_CALC            = 44'h0000c9b2745 ;
  assign     TX_TAM_ADJUST_SN_CALC             = is_10g ? TX_TAM_ADJUST_10G_SN_CALC : 44'h0000ca51546 ;
  localparam TX_TAM_ADJUST_FEC_SN_CALC         = 44'h0000de2d566 ;

  assign     RX_TAM_ADJUST_NOADJ_CALC          = is_10g ? RX_TAM_ADJUST_NOADJ_10G_CALC : 44'h00003a5645e ;
  localparam RX_TAM_ADJUST_NOADJ_FEC_CALC      = 44'h00004e3247e ;
  assign     RX_TAM_ADJUST_NOADJ_SN_CALC       = is_10g ? RX_TAM_ADJUST_NOADJ_10G_SN_CALC : 44'h0000b537924 ;
  localparam RX_TAM_ADJUST_NOADJ_FEC_SN_CALC   = 44'h0000c913944 ;

  assign     RX_TAM_ADJUST_CALC                = is_10g ? RX_TAM_ADJUST_10G_CALC : 44'h000077280c0 ;
  localparam RX_TAM_ADJUST_FEC_CALC            = 44'h000077280c0 ;
  assign     RX_TAM_ADJUST_SN_CALC             = is_10g ? RX_TAM_ADJUST_10G_SN_CALC : 44'h0000f209586 ;
  localparam RX_TAM_ADJUST_FEC_SN_CALC         = 44'h0000f209586 ;

  localparam PIPE1 = 8;

`ifdef ENHANCED_PTP_SIM_LONGER
  localparam SIM_LONGER = 1;
`else
  localparam SIM_LONGER = 0;
`endif

assign TX_ASYNC_PULSE_PERIOD     =  (SIM_MODE == 1) ? ehip_rate_sl_eq_rate_25gx1_fec    ? 32'd80    :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'd5120  :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'd5120  :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'd5120  :  32'd5280
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? 32'd80    :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'd81920 :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'd81920 :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'd81920 :  32'd84480;

assign TX_APULSE_SKIP            =  (SIM_MODE == 1) ? ehip_rate_sl_eq_rate_25gx1_fec    ? {16'd1, 16'd3}      :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {16'd1, 16'd3}      : {16'd1, 16'd3}
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? {16'd1, 16'd7}      :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {16'd1, 16'd7}      : {16'd1, 16'd7};

assign TX_APULSE_ROLL_DLY        =  (SIM_MODE == 1) ? ehip_rate_sl_eq_rate_25gx1_fec    ? {8'd15, 8'd4, 16'd16} :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {8'd15, 8'd4, 16'd8}  :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? {8'd15, 8'd4, 16'd16} :
                                                      ehip_rate_sl_eq_rate_10gx1        ? {8'd15, 8'd4, 16'd16} : {8'd15, 8'd4, 16'd8}
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? {8'd15, 8'd4, 16'd16} :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {8'd15, 8'd4, 16'd8}  :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? {8'd15, 8'd4, 16'd16} :
                                                      ehip_rate_sl_eq_rate_10gx1        ? {8'd15, 8'd4, 16'd16} : {8'd15, 8'd4, 16'd8};

assign TX_APULSE_CNT             =  (SIM_MODE == 1) ? (SIM_LONGER == 1)                 ? 32'd175    :
                                                      ehip_rate_sl_eq_rate_25gx1_fec    ? 32'd35     :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'd35     :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'd35     :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'd35     : 32'd35
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? 32'd875     :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'd875     :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'd875     :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'd875     : 32'd875;

assign TX_APULSE_CNT_POW2        =  (SIM_MODE == 1) ? (SIM_LONGER == 1)                 ? 32'hccc       :
                                                      ehip_rate_sl_eq_rate_25gx1_fec    ? 32'h4000      :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'h4000      :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'h4000      :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'h4000      : 32'h4000
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? 32'h28F      :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'h28F      :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'h28F      :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'h28F      : 32'h28f;

assign TX_SN_CONFIG              =  (SIM_MODE == 1) ? ehip_rate_sl_eq_rate_25gx1_fec    ? {16'd1, 16'd1} :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {16'd0, 16'd1} :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? {16'd2, 16'd1} :
                                                      ehip_rate_sl_eq_rate_10gx1        ? {16'd2, 16'd1} : 32'd0
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? {16'd1, 16'd1} :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {16'd0, 16'd1} :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? {16'd2, 16'd1} :
                                                      ehip_rate_sl_eq_rate_10gx1        ? {16'd2, 16'd1} : 32'd0;


assign RX_ASYNC_PULSE_PERIOD     =  (SIM_MODE == 1) ? ehip_rate_sl_eq_rate_25gx1_fec    ? 32'd80    :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'd96    :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'd96    :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'd96    : 32'd99
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? 32'd80    :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'd96    :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'd96    :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'd96    : 32'd99;

assign RX_APULSE_SKIP            =  (SIM_MODE == 1) ? ehip_rate_sl_eq_rate_25gx1_fec    ? {16'd20, 16'd10}      :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {16'd20, 16'd10}      : {16'd20, 16'd10}
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? {16'd20, 16'd5000}  :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {16'd20, 16'd5000}  : {16'd20, 16'd5000};

assign RX_APULSE_ROLL_DLY        =  (SIM_MODE == 1) ? ehip_rate_sl_eq_rate_25gx1_fec    ? {8'd15, 8'd4, 16'd16} :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {8'd15, 8'd4, 16'd8}  :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? {8'd15, 8'd4, 16'd8}  :
                                                      ehip_rate_sl_eq_rate_10gx1        ? {8'd15, 8'd4, 16'd8}  : {8'd15, 8'd4, 16'd8}
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? {8'd15, 8'd4, 16'd16} :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {8'd15, 8'd4, 16'd8}  :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? {8'd15, 8'd4, 16'd8}  :
                                                      ehip_rate_sl_eq_rate_10gx1        ? {8'd15, 8'd4, 16'd8}  : {8'd15, 8'd4, 16'd8};

assign RX_APULSE_CNT             =  (SIM_MODE == 1) ? (SIM_LONGER == 1)                 ? 32'd175    :
                                                      ehip_rate_sl_eq_rate_25gx1_fec    ? 32'd35     :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'd35     :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'd35     :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'd35     : 32'd35
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? 32'd875     :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'd875     :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'd875     :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'd875     : 32'd875;

assign RX_APULSE_CNT_POW2        =  (SIM_MODE == 1) ? (SIM_LONGER == 1)                 ? 32'hccc       :
                                                      ehip_rate_sl_eq_rate_25gx1_fec    ? 32'h4000      :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'h4000      :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'h4000      :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'h4000      : 32'h4000
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? 32'h28F      :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? 32'h28F      :
                                                      ehip_rate_sl_eq_rate_10gx1        ? 32'h28F      :
                                                      ehip_rate_sl_eq_rate_25gx1        ? 32'h28F      : 32'h28f;

assign RX_SN_CONFIG              =  (SIM_MODE == 1) ? ehip_rate_sl_eq_rate_25gx1_fec    ? {16'd1, 16'd1} :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {16'd0, 16'd1} :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? {16'd2, 16'd1} :
                                                      ehip_rate_sl_eq_rate_10gx1        ? {16'd2, 16'd1} : 32'd0
                                                    : ehip_rate_sl_eq_rate_25gx1_fec    ? {16'd1, 16'd1} :
                                                      ehip_rate_sl_eq_rate_25gx1        ? {16'd0, 16'd1} :
                                                      ehip_rate_sl_eq_rate_10gx1_25lr   ? {16'd2, 16'd1} :
                                                      ehip_rate_sl_eq_rate_10gx1        ? {16'd2, 16'd1} : 32'd0;

assign SN_PLL_SCLK_PERIOD    =  20'h8C000;  //8.75ns
//localparam SN_PLL_SCLK_PERIOD    =  20'h40000;  //4ns




 logic [31:0] i_tx_apulse_period;
 logic [31:0] i_tx_apulse_skip;
 logic [31:0] i_tx_apulse_roll_dly;
 logic [31:0] i_tx_apulse_cnt_pow2;
 logic [31:0] i_tx_apulse_cnt;
 logic [31:0] i_tx_sn_config;
 logic [31:0] i_rx_apulse_period;
 logic [31:0] i_rx_apulse_skip;
 logic [31:0] i_rx_apulse_roll_dly;
 logic [31:0] i_rx_apulse_cnt_pow2;
 logic [31:0] i_rx_apulse_cnt;
 logic [31:0] i_rx_sn_config;
 logic [31:0] i_sn_pll_sclk_period;



  logic [95:0] tx_tam;
  logic [95:0] rx_tam;
  logic        req_tx_tam_load;
  logic        req_rx_tam_load;

  (* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) logic [PIPE1*32-1:0] tx_ui_r;
  (* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) logic [PIPE1*32-1:0] rx_ui_r;
  logic [PIPE1*12-1:0] tx_tam_adjust_ui_r;
  logic [PIPE1*12-1:0] rx_tam_adjust_ui_r;
  logic [PIPE1*12-1:0] rx_tam_adjust_ui_adj_r;

  logic [PIPE1*32-1:0] tx_tam_adjust_avg_r;
  logic [39:0] tx_tam_adjust_avg_f24;
  logic [39:0] tx_tam_adjust_avg_f24r;
  logic [39:0] tx_tam_adjust_avg_f24rr;

  logic [PIPE1*32-1:0] rx_tam_adjust_avg_r;
  logic [39:0] rx_tam_adjust_avg_f24;
  logic [39:0] rx_tam_adjust_avg_f24r;
  logic [39:0] rx_tam_adjust_avg_f24rr;

//  logic [39:0] tx_tam_adjust;
  logic [43:0] tx_tam_adjust;
  logic [43:0] rx_tam_adjust_no_adj;
  logic [43:0] rx_tam_adjust_adj;

  logic [39:0] tx_tam_adjust_r;
  logic [39:0] rx_tam_adjust_no_adj_r;
  logic [39:0] rx_tam_adjust_adj_r;

  logic [39:0] tx_tam_adjust_rr;
  logic [39:0] rx_tam_adjust_no_adj_rr;
  logic [39:0] rx_tam_adjust_adj_rr;

  logic [40:0] tx_tam_adjust_total;
  logic [40:0] rx_tam_adjust_no_adj_total;
  logic [40:0] rx_tam_adjust_adj_total;

  logic [40:0] tx_tam_adjust_total_r;
  logic [40:0] rx_tam_adjust_no_adj_total_r;
  logic [40:0] rx_tam_adjust_adj_total_r;

  logic [40:0] tx_tam_adjust_total_rr;
  logic [40:0] rx_tam_adjust_no_adj_total_rr;
  logic [40:0] rx_tam_adjust_adj_total_rr;

  logic [41:0] tx_tam_adjust_w_err;
  logic [41:0] rx_tam_adjust_no_adj_w_err;
  logic [41:0] rx_tam_adjust_adj_w_err;

  logic [41:0] tx_tam_adjust_w_err_r;
  logic [41:0] rx_tam_adjust_no_adj_w_err_r;
  logic [41:0] rx_tam_adjust_adj_w_err_r;

  logic [41:0] tx_tam_adjust_final;
  logic [41:0] rx_tam_adjust_final;

  logic [31:0] tx_tam_adj;
  logic [31:0] rx_tam_adj;

  logic        tx_calibrate;
  logic        rx_calibrate;
  logic        tx_calibrate_p;
  logic        rx_calibrate_p;

  logic        modify_ts;

/////// sub-nano signals /////////
   logic [7:0] o_ptp_ready_dbg;

   logic [15:0] tx_dt_status;
   logic [31:0] tx_tam_adjust_avg;
   logic [31:0] tx_tam_adjust_avg_p;
   logic [31:0] tx_tam_adjust_avg_cc;
   logic        tx_measure_done;
   logic        tx_measure_done_p;
   logic        tx_tam_adjust_valid_1s;
   logic        tx_tam_adjust_avg_p_valid_1s;
   logic        tx_roll_over_trig;

   logic [15:0] rx_dt_status;
   logic [31:0] rx_tam_adjust_avg;
   logic [31:0] rx_tam_adjust_avg_p;
   logic [31:0] rx_tam_adjust_avg_cc;
   logic        rx_measure_done;
   logic        rx_measure_done_p;
   logic        rx_tam_adjust_valid_1s;
   logic        rx_tam_adjust_avg_p_valid_1s;
   logic        rx_roll_over_trig;

   logic        rx_sn_dn;
   logic        rx_am;
   logic        tx_am;

   logic        tx_roll_over_sclk_return;
   logic        rx_roll_over_sclk_return;

   logic        tx_sn_en;
   logic        rx_sn_en;

   logic        tx_sn_ready;
   logic        rx_sn_ready;

   logic        tx_sn_ready_p;
   logic        rx_sn_ready_p;

   logic        tx_ptp_ready;
   logic        rx_ptp_ready;
   logic        tx_ptp_ready_x;
   logic        rx_ptp_ready_x;

   logic        tx_sn_err;
   logic        rx_sn_err;

   logic        tx_sn_err2;
   logic        rx_sn_err2;

   logic        tx_tam_valid;
   logic        rx_tam_valid;

   logic        tx_dw_err;
   logic        tx_dw_err2;
   logic        rx_dw_err;
   logic        rx_dw_err2;
   logic [31:0] tx_error_p;
   logic [31:0] rx_error_p;
   logic [31:0] tx_error_cc;
   logic [31:0] rx_error_cc;
   logic        tx_error_cc_valid_1s;
   logic        rx_error_cc_valid_1s;
   logic        tx_error_valid_1s;
   logic        rx_error_valid_1s;

   reg        pcs_fully_aligned_rxx_sync;
   reg        tx_rst_rxx_n_sync;
   reg        rx_rst_rxx_n_sync;
   reg        tx_rst_txx_n_sync;
   reg        tx_arst_txx_n_0;
   reg        rx_arst_rxx_n_0;
   reg        tx_arst_txx_n;
   reg        rx_arst_rxx_n;
   reg        tx_rst_txx_n_0;
   reg        rx_rst_rxx_n_0;
   reg        tx_rst_txx_n/* synthesis maxfan = 32 preserve */;  // verilog-95
   reg        rx_rst_rxx_n/* synthesis maxfan = 32 preserve */;  // verilog-95
//(* maxfan = 50, preserve *)   reg        tx_rst_txx_n; // verilog-2001
//(* maxfan = 50, preserve *)   reg        rx_rst_rxx_n; // verilog-2001


   logic        tx_sclk_return_2d1s;
   logic        rx_sclk_return_2d1s;

   logic        tx_reset_sn_sclk_n;
   logic        rx_reset_sn_sclk_n;


   logic        tx_sclk_return_phz_2d1s;
   logic        rx_sclk_return_phz_2d1s;

   logic        tx_clb_rollover_pulse_minus1;
   logic        rx_clb_rollover_pulse_minus1;

   logic        in_tx_roll_over_trig;
   logic        in_rx_roll_over_trig;

   logic        tx_cmbo_rollover_pulse_minus1;
   logic        rx_cmbo_rollover_pulse_minus1;
   logic        tx_sclk_return_2d1s_wd;
   logic        tx_sclk_return_2d1s_sn;
   logic        rx_sclk_return_2d1s_wd;
   logic        rx_sclk_return_2d1s_sn;

 assign i_tx_apulse_period = TX_ASYNC_PULSE_PERIOD;
 assign i_tx_apulse_skip = TX_APULSE_SKIP;
 assign i_tx_apulse_roll_dly = TX_APULSE_ROLL_DLY;
 assign i_tx_apulse_cnt_pow2 = TX_APULSE_CNT_POW2;
 assign i_tx_apulse_cnt = TX_APULSE_CNT;
 assign i_tx_sn_config = TX_SN_CONFIG;
 assign i_rx_apulse_period = RX_ASYNC_PULSE_PERIOD;
 assign i_rx_apulse_skip = RX_APULSE_SKIP;
 assign i_rx_apulse_roll_dly = RX_APULSE_ROLL_DLY;
 assign i_rx_apulse_cnt_pow2 = RX_APULSE_CNT_POW2;
 assign i_rx_apulse_cnt = RX_APULSE_CNT;
 assign i_rx_sn_config = RX_SN_CONFIG;
 assign i_sn_pll_sclk_period = SN_PLL_SCLK_PERIOD;


  assign o_sl_tx_sel_sclk_return = ~tx_calibrate_p;
  assign o_sl_rx_sel_sclk_return = ~rx_calibrate_p;

  always @(posedge i_ptp_clk) begin
  /*  if(!i_tx_rst_n9) begin
        tx_ui_r                 <= {PIPE1{32'h0}};
        tx_tam_adjust_ui_r      <= {PIPE1{12'h0}};
        tx_tam_adjust_avg_r     <= {PIPE1{32'h0}};
        tx_tam_adjust_avg_f24   <= 40'h0;
        tx_tam_adjust_avg_f24r  <= 40'h0;
        tx_tam_adjust_avg_f24rr <= 40'h0;
        tx_tam_adjust           <= 44'h0;
        tx_tam_adjust_r         <= 40'h0;
        tx_tam_adjust_rr        <= 40'h0;
        tx_tam_adjust_total     <= 41'h0;
        tx_tam_adjust_total_r   <= 41'h0;
        tx_tam_adjust_total_rr  <= 41'h0;
        tx_tam_adjust_w_err     <= 42'h0;
        tx_tam_adjust_w_err_r   <= 42'h0;
    end
    else*/ // if(tx_measure_done_p) begin
///        tx_ui_r                 <= {tx_ui_r[(PIPE1-1)*32-1:0], i_tx_ui};

///        tx_tam_adjust_ui_r      <= {tx_tam_adjust_ui_r[(PIPE1-1)*12-1:0], tx_calibrate_p ? {12{1'b1}}
///                                    : (tx_measure_done_p && tx_sn_en) ? ( i_enable_rsfec ? TX_TAM_ADJUST_UI_FEC2[12-1:0] : TX_TAM_ADJUST_UI2[12-1:0] )
///                                    : ( i_enable_rsfec ? TX_TAM_ADJUST_UI_FEC[12-1:0] : TX_TAM_ADJUST_UI[12-1:0] ) };
///        tx_tam_adjust           <= tx_tam_adjust_ui_r[(PIPE1)*12-1:(PIPE1-1)*12] * tx_ui_r[(PIPE1)*32-1:(PIPE1-1)*32];

//          tx_tam_adjust           <=  (tx_measure_done_p && tx_sn_en) ?  44'h0000ca51546 : 44'h0000b5d6725;
          tx_tam_adjust           <=  (tx_measure_done_p && tx_sn_en) ? ( i_enable_rsfec ? TX_TAM_ADJUST_FEC_SN_CALC  : TX_TAM_ADJUST_SN_CALC )
                                                                      : ( i_enable_rsfec ? TX_TAM_ADJUST_FEC_CALC     : TX_TAM_ADJUST_CALC ) ;

///
        tx_tam_adjust_avg_r     <= {tx_tam_adjust_avg_r[(PIPE1-1)*32-1:0], (tx_measure_done_p && tx_sn_en) ? tx_tam_adjust_avg_p : 32'd0};
        tx_tam_adjust_avg_f24   <= {tx_tam_adjust_avg_r[(PIPE1)*32-1:(PIPE1-1)*32], 8'h00};
        tx_tam_adjust_avg_f24r  <= tx_tam_adjust_avg_f24;
        tx_tam_adjust_avg_f24rr <= tx_tam_adjust_avg_f24r;

        tx_tam_adjust_r         <= tx_tam_adjust[39:0];
        tx_tam_adjust_rr        <= tx_tam_adjust_r;

        tx_tam_adjust_total     <= tx_tam_adjust_avg_f24rr + tx_tam_adjust_rr;

        tx_tam_adjust_total_r   <= tx_tam_adjust_total;
        tx_tam_adjust_total_rr  <= tx_tam_adjust_total_r;
///
        tx_tam_adjust_w_err     <= {tx_error_p, 8'h00} + tx_tam_adjust_total_rr;
//        tx_tam_adjust_w_err     <=  tx_tam_adjust_total_rr;
////
        tx_tam_adjust_w_err_r   <= tx_tam_adjust_w_err;
//    end
  end

  always @(posedge i_ptp_clk) begin
  /*  if(!i_rx_rst_n4) begin
        rx_ui_r                         <= {PIPE1{32'h0}};
        rx_tam_adjust_ui_r              <= {PIPE1{8'h0}};
        rx_tam_adjust_ui_adj_r          <= {PIPE1{8'h0}};

        rx_tam_adjust_avg_r             <= {PIPE1{32'h0}};
        rx_tam_adjust_avg_f24           <= 40'h0;
        rx_tam_adjust_avg_f24r          <= 40'h0;
        rx_tam_adjust_avg_f24rr         <= 40'h0;

        rx_tam_adjust_no_adj            <= 44'h0;
        rx_tam_adjust_adj               <= 44'h0;

        rx_tam_adjust_no_adj_r          <= 40'h0;
        rx_tam_adjust_adj_r             <= 40'h0;

        rx_tam_adjust_no_adj_rr         <= 40'h0;
        rx_tam_adjust_adj_rr            <= 40'h0;

        rx_tam_adjust_no_adj_total      <= 41'h0;
        rx_tam_adjust_adj_total         <= 41'h0;

        rx_tam_adjust_no_adj_total_r    <= 41'h0;
        rx_tam_adjust_adj_total_r       <= 41'h0;

        rx_tam_adjust_no_adj_total_rr   <= 41'h0;
        rx_tam_adjust_adj_total_rr      <= 41'h0;

        rx_tam_adjust_no_adj_w_err      <= 42'h0;
        rx_tam_adjust_adj_w_err         <= 42'h0;

        rx_tam_adjust_no_adj_w_err_r    <= 42'h0;
        rx_tam_adjust_adj_w_err_r       <= 42'h0;
    end
    else */ // if(rx_measure_done_p) begin
///        rx_ui_r                         <= {rx_ui_r[(PIPE1-1)*32-1:0], i_rx_ui};

///        rx_tam_adjust_ui_r              <= {rx_tam_adjust_ui_r[(PIPE1-1)*12-1:0], rx_calibrate_p ? {12{1'b1}}
///                                            :(rx_measure_done_p && rx_sn_en) ?  ( i_enable_rsfec ? RX_TAM_ADJUST_UI_FEC2[12-1:0] : RX_TAM_ADJUST_UI2[12-1:0] )
 ///                                           : ( i_enable_rsfec ? RX_TAM_ADJUST_UI_FEC[12-1:0] : RX_TAM_ADJUST_UI[12-1:0] ) };

///        rx_tam_adjust_ui_adj_r          <= {rx_tam_adjust_ui_adj_r[(PIPE1-1)*12-1:0], rx_calibrate_p ? {12{1'b1}}
///                                            :(rx_measure_done_p && rx_sn_en) ?  RX_TAM_ADJUST_UI_ADJ2[12-1:0]
///                                            : RX_TAM_ADJUST_UI_ADJ[12-1:0]};

///        rx_tam_adjust_no_adj            <= rx_tam_adjust_ui_r[(PIPE1)*12-1:(PIPE1-1)*12] * rx_ui_r[(PIPE1)*32-1:(PIPE1-1)*32];
///        rx_tam_adjust_adj               <= rx_tam_adjust_ui_adj_r[(PIPE1)*12-1:(PIPE1-1)*12] * rx_ui_r[(PIPE1)*32-1:(PIPE1-1)*32];


//           rx_tam_adjust_no_adj         <= (rx_measure_done_p && rx_sn_en) ? 44'h0000b537924 : 44'h00003a5645e;
//           rx_tam_adjust_adj            <= (rx_measure_done_p && rx_sn_en) ? 44'h0000f209586 : 44'h000_0772_80c0;

          rx_tam_adjust_no_adj           <=  (rx_measure_done_p && rx_sn_en) ? ( i_enable_rsfec ? RX_TAM_ADJUST_NOADJ_FEC_SN_CALC  : RX_TAM_ADJUST_NOADJ_SN_CALC )
                                                                             : ( i_enable_rsfec ? RX_TAM_ADJUST_NOADJ_FEC_CALC     : RX_TAM_ADJUST_NOADJ_CALC ) ;

          rx_tam_adjust_adj              <=  (rx_measure_done_p && rx_sn_en) ? ( i_enable_rsfec ? RX_TAM_ADJUST_FEC_SN_CALC  : RX_TAM_ADJUST_SN_CALC )
                                                                             : ( i_enable_rsfec ? RX_TAM_ADJUST_FEC_CALC     : RX_TAM_ADJUST_CALC ) ;

////

        rx_tam_adjust_avg_r             <= {rx_tam_adjust_avg_r[(PIPE1-1)*32-1:0], (rx_measure_done_p && rx_sn_en) ? rx_tam_adjust_avg_p : 32'd0};
        rx_tam_adjust_avg_f24           <= {rx_tam_adjust_avg_r[(PIPE1)*32-1:(PIPE1-1)*32], 8'h00};
        rx_tam_adjust_avg_f24r          <= rx_tam_adjust_avg_f24;
        rx_tam_adjust_avg_f24rr         <= rx_tam_adjust_avg_f24r;

        rx_tam_adjust_no_adj_r          <= rx_tam_adjust_no_adj[39:0];
        rx_tam_adjust_adj_r             <= rx_tam_adjust_adj[39:0];

        rx_tam_adjust_no_adj_rr         <= rx_tam_adjust_no_adj_r;
        rx_tam_adjust_adj_rr            <= rx_tam_adjust_adj_r;

        rx_tam_adjust_no_adj_total      <= rx_tam_adjust_avg_f24rr + rx_tam_adjust_no_adj_rr;
        rx_tam_adjust_adj_total         <= rx_tam_adjust_avg_f24rr + rx_tam_adjust_adj_rr;

        rx_tam_adjust_no_adj_total_r    <= rx_tam_adjust_no_adj_total;
        rx_tam_adjust_adj_total_r       <= rx_tam_adjust_adj_total;

        rx_tam_adjust_no_adj_total_rr   <= rx_tam_adjust_no_adj_total_r;
        rx_tam_adjust_adj_total_rr      <= rx_tam_adjust_adj_total_r;
///
        rx_tam_adjust_no_adj_w_err      <= {rx_error_p, 8'h00} + rx_tam_adjust_no_adj_total_rr;
        rx_tam_adjust_adj_w_err         <= {rx_error_p, 8'h00} + rx_tam_adjust_adj_total_rr;

//        rx_tam_adjust_no_adj_w_err      <=  rx_tam_adjust_no_adj_total_rr;
//        rx_tam_adjust_adj_w_err         <=  rx_tam_adjust_adj_total_rr;
////

        rx_tam_adjust_no_adj_w_err_r    <= rx_tam_adjust_no_adj_w_err;
        rx_tam_adjust_adj_w_err_r       <= rx_tam_adjust_adj_w_err;
//    end
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

  alt_ehipc3_fm_sl_ptp_ref_ts_capture_sn #(
    .EHIP_RATE_10G_EN    (EHIP_RATE_10G_EN),
    .SIM_MODE            (SIM_MODE)
  ) ptp_ref_ts_capture_u_sn (
    .i_sn_config            (i_tx_sn_config[17:16]),
    .i_enable_rsfec         (i_enable_rsfec),
    .i_rx_sn_dn             (rx_sn_dn),
    .i_rx_ap_roll_dly       (i_rx_apulse_roll_dly[15:0]),
    .i_apulse_period        (i_rx_apulse_period),
    .i_apulse_cnt_pow2      (i_rx_apulse_cnt_pow2),
    .i_apulse_cnt           (i_rx_apulse_cnt),
    .i_tx_ui                (i_tx_ui),
    .i_rx_ui                (i_rx_ui),
    .i_sn_pll_sclk_period   (i_sn_pll_sclk_period),
    .i_ptp_sn_sclk          (i_ptp_sn_sclk),
    .i_clk                  (i_ptp_clk),
    .i_tx_clk               (i_ptp_tx_clk),
    .i_rx_clk               (i_ptp_rx_clk),
    .i_tx_rst_n             (i_tx_rst_n),   //(i_tx_rst_n),
    .i_rx_rst_n             (i_rx_rst_n2),   //(i_rx_rst_n2),
    .i_tx_arst              (i_tx_arst),
    .i_rx_arst              (i_rx_arst),
    .i_txx_arst_n           (tx_arst_txx_n),
    .i_rxx_arst_n           (rx_arst_rxx_n),
    .i_txx_rst_n            (tx_rst_txx_n),
    .i_rxx_rst_n            (rx_rst_rxx_n),
    .i_tx_reset_sn_sclk_n   (tx_reset_sn_sclk_n),
    .i_rx_reset_sn_sclk_n   (rx_reset_sn_sclk_n),
    .i_all_ready            (i_all_ready),
    .i_ptp_tx_tod           (i_ptp_tx_tod),
    .i_ptp_rx_tod           (i_ptp_rx_tod),
    .i_ptp_update           (i_ptp_update),

    .o_tx_w_skip_ini  (o_tx_w_skip_ini),
    .o_rx_w_skip_ini  (o_rx_w_skip_ini),

    .o_tx_w_state_rollover   (o_tx_w_state_rollover),
    .o_rx_w_state_rollover   (o_rx_w_state_rollover),

    .o_tx_w_state_latencyphz   (o_tx_w_state_latencyphz),
    .o_rx_w_state_latencyphz   (o_rx_w_state_latencyphz),

    .o_tx_w_apulse_count  (o_tx_w_apulse_count),
    .o_rx_w_apulse_count  (o_rx_w_apulse_count),

    .o_tx_w_apulse_rt_period (o_tx_w_apulse_rt_period),
    .o_tx_w_apulse_sn_period (o_tx_w_apulse_sn_period),
    .o_tx_w_apulse_err_period (o_tx_w_apulse_err_period),
    .o_tx_w_apulse_err2_latency (o_tx_w_apulse_err2_latency),

    .o_rx_w_apulse_rt_period (o_rx_w_apulse_rt_period),
    .o_rx_w_apulse_sn_period (o_rx_w_apulse_sn_period),
    .o_rx_w_apulse_err_period (o_rx_w_apulse_err_period),
    .o_rx_w_apulse_err2_latency (o_rx_w_apulse_err2_latency),

    .o_tx_dw_err        (tx_dw_err),
    .o_tx_dw_err2       (tx_dw_err2),
    .o_rx_dw_err        (rx_dw_err),
    .o_rx_dw_err2       (rx_dw_err2),
    .o_tx_error_valid   (o_tx_error_valid),
    .o_tx_error_valid_1s   (tx_error_valid_1s),
    .o_tx_error         (o_tx_error),
    .o_rx_error         (o_rx_error),
    .o_rx_error_valid   (o_rx_error_valid),
    .o_rx_error_valid_1s   (rx_error_valid_1s),
    .o_rx_tam           (rx_tam),
    .o_tx_tam           (tx_tam),
    .o_req_tx_tam_load  (req_tx_tam_load),
    .o_req_rx_tam_load  (req_rx_tam_load),
    .o_tx_clb_rollover_pulse_minus1   (tx_clb_rollover_pulse_minus1),
    .o_rx_clb_rollover_pulse_minus1   (rx_clb_rollover_pulse_minus1),
    .o_tx_sclk          (o_tx_sclk),
    .o_rx_sclk          (o_rx_sclk),
//    .i_tx_sclk_return   (i_tx_sclk_return),
    //.i_tx_async_pulse_2d_1s         (tx_sclk_return_2d1s),
	.i_tx_async_pulse_2d_1s         (tx_sclk_return_2d1s_wd),
    .i_tx_async_pulse_phz_2d_1s     (tx_sclk_return_phz_2d1s),
    .i_tx_roll_over_sclk_return     (tx_roll_over_trig), // (tx_roll_over_sclk_return),  // (i_tx_sclk_return),
    .i_tx_clb_roll_pulse_phz_2d1s   (tx_roll_pulse_phz_2d1s),
    .i_tx_am                        (tx_am),
//    .i_rx_sclk_return   (i_rx_sclk_return),
    //.i_rx_async_pulse_2d_1s         (rx_sclk_return_2d1s),
	.i_rx_async_pulse_2d_1s         (rx_sclk_return_2d1s_wd),
    .i_rx_async_pulse_phz_2d_1s     (rx_sclk_return_phz_2d1s),
    .i_rx_roll_over_sclk_return     (rx_roll_over_trig), // (rx_roll_over_sclk_return),  // (i_rx_sclk_return),
    .i_rx_clb_roll_pulse_phz_2d1s   (rx_roll_pulse_phz_2d1s),
    .i_rx_am            (rx_am),
    .o_tx_calibrate     (tx_calibrate),
    .o_rx_calibrate     (rx_calibrate));


  alt_ehipc3_fm_sl_ptp_ts_converter_sn ptp_ts_converter_u_sn(
    .i_clk              (i_ptp_clk),
    .i_tx_rst_n         (i_tx_rst_n3),
    .i_rx_rst_n         (i_rx_rst_n3),
    .i_txx_clk          (i_ptp_tx_clk),
    .i_rxx_clk          (i_ptp_rx_clk),
    .i_tx_arst          (i_tx_arst),
    .i_rx_arst          (i_rx_arst),
    .i_txx_arst_n       (tx_arst_txx_n),
    .i_rxx_arst_n       (rx_arst_rxx_n),
    .i_ptp_tx_ts_valid  (i_ptp_tx_ts_valid),
    .i_ptp_tx_ts        (i_ptp_tx_ts),
    .i_ptp_tx_fp        (i_ptp_tx_fp),
    .i_rx_valid         (i_rx_valid),
    .i_rx_inframe       (i_rx_inframe),
    .i_ptp_rx_ts        (i_ptp_rx_ts),
    .i_ts_format        (i_ts_format),
    .i_tx_tod           (i_ptp_tx_tod),
    .i_rx_tod           (i_ptp_rx_tod),
    .o_ptp_ets_valid    (o_ptp_ets_valid),
    .o_ptp_ets          (o_ptp_ets),
    .o_ptp_ets_fp       (o_ptp_ets_fp),
    .o_ptp_rx_its       (o_ptp_rx_its),
    .o_ptp_rx_its_valid (o_ptp_rx_its_valid)
  );

alt_ehipc3_fm_sl_ptp_opcode_writer #(
    .ENHANCED_PTP_ACCURACY     (ENHANCED_PTP_ACCURACY),
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
    .i_rst_n6		 (i_tx_rst_n10),
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
    .o_tx_ptp_ready      (tx_ptp_ready),
    .o_rx_ptp_ready      (rx_ptp_ready),
    .o_ptp_ts            (o_ptp_ts),
    .o_tx_tam_valid      (tx_tam_valid),
    .o_rx_tam_valid      (rx_tam_valid),
    .o_ptp_ready_dbg     (o_ptp_ready_dbg),
    .i_ptp_rx_aib_dsk_done(i_ptp_rx_aib_dsk_done),
    .o_ptp_rx_aib_dsk_done(o_ptp_rx_aib_dsk_done)
  );

  alt_ehipc3_fm_sl_ptp_tam_capture_count_sn ptp_tam_capture_count_u(
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

  alt_ehipc3_fm_sl_ptp_sub_nano #(
             .nTXRX(0)
	)    tx_ptp_sub_nano  (
    .i_ptp_clk          (i_ptp_tx_clk),
    .i_ptp_sn_sclk      (i_ptp_sn_sclk),
    .i_areset_n         (tx_arst_txx_n),
    .i_reset_n          (tx_rst_txx_n),
    .i_reset_sn_sclk_n  (tx_reset_sn_sclk_n),
    .i_ptp_ready        (tx_ptp_ready_x),
    .i_am               (i_tx_am),
    .i_tam_valid        (tx_tam_valid),
    //.i_async_pulse_2d_1s         (tx_sclk_return_2d1s),
	.i_async_pulse_2d_1s         (tx_sclk_return_2d1s_sn),
    .i_async_pulse_phz_2d_1s     (tx_sclk_return_phz_2d1s),
    .i_roll_pulse_phz_2d_1s      (tx_roll_pulse_phz_2d1s),
    .i_apulse_period    (i_tx_apulse_period),
    .i_apulse_skip      (i_tx_apulse_skip),
    .i_apulse_roll_dly  (i_tx_apulse_roll_dly),
    .i_apulse_cnt_pow2  (i_tx_apulse_cnt_pow2),
    .i_apulse_cnt       (i_tx_apulse_cnt),
    .i_sn_config        (i_tx_sn_config),
    .i_sn_pll_sclk_period   (i_sn_pll_sclk_period),
    .o_am               (tx_am),
    .o_sn_en            (tx_sn_en),
    .o_sn_ready         (tx_sn_ready),
    .o_err              (tx_sn_err),
    .o_err2             (tx_sn_err2),
    .o_skip_ini         (o_tx_skip_ini),
    .o_state_rollover   (o_tx_state_rollover),
    .o_state_latencyphz (o_tx_state_latencyphz),
    .o_state_transition (o_tx_state_transition),
    .o_apulse_count     (o_tx_apulse_count),
    .o_apulse_rt_period (o_tx_apulse_rt_period),
    .o_apulse_sn_period (o_tx_apulse_sn_period),
    .o_apulse_period_err (o_tx_apulse_err_period),
    .o_latency_err2     (o_tx_apulse_err2_latency),
    .o_measure_done     (tx_measure_done),
    .o_rollover_pulse_minus1   (tx_rollover_pulse_minus1),
    .o_roll_over_trig   (tx_roll_over_trig),
    .o_tam_adjust_valid_1s   (tx_tam_adjust_valid_1s),
    .o_tam_adjust_avg   (tx_tam_adjust_avg)
  );

  alt_ehipc3_fm_sl_ptp_sub_nano #(
             .nTXRX(1)
	)   rx_ptp_sub_nano  (
    .i_ptp_clk          (i_ptp_rx_clk),
    .i_ptp_sn_sclk      (i_ptp_sn_sclk),
    .i_areset_n         (rx_arst_rxx_n),
    .i_reset_n          (rx_rst_rxx_n),
    .i_reset_sn_sclk_n  (rx_reset_sn_sclk_n),
    .i_ptp_ready        (~rx_calibrate && rx_ptp_ready_x),
    .i_am               (i_rx_am),
    .i_tam_valid        (rx_tam_valid),
    //.i_async_pulse_2d_1s         (rx_sclk_return_2d1s),
    .i_async_pulse_2d_1s         (rx_sclk_return_2d1s_sn),
    .i_async_pulse_phz_2d_1s     (rx_sclk_return_phz_2d1s),
    .i_roll_pulse_phz_2d_1s      (rx_roll_pulse_phz_2d1s),
    .i_apulse_period    (i_rx_apulse_period),
    .i_apulse_skip      (i_rx_apulse_skip),
    .i_apulse_roll_dly  (i_rx_apulse_roll_dly),
    .i_apulse_cnt_pow2  (i_rx_apulse_cnt_pow2),
    .i_apulse_cnt       (i_rx_apulse_cnt),
    .i_sn_config        (i_rx_sn_config),
    .i_sn_pll_sclk_period   (i_sn_pll_sclk_period),
    .o_am               (rx_am),
    .o_sn_en            (rx_sn_en),
    .o_sn_ready         (rx_sn_ready),
    .o_err              (rx_sn_err),
    .o_err2             (rx_sn_err2),
    .o_skip_ini         (o_rx_skip_ini),
    .o_state_rollover   (o_rx_state_rollover),
    .o_state_latencyphz (o_rx_state_latencyphz),
    .o_state_transition (o_rx_state_transition),
    .o_apulse_count     (o_rx_apulse_count),
    .o_apulse_rt_period (o_rx_apulse_rt_period),
    .o_apulse_sn_period (o_rx_apulse_sn_period),
    .o_apulse_period_err (o_rx_apulse_err_period),
    .o_latency_err2     (o_rx_apulse_err2_latency),
    .o_measure_done     (rx_measure_done),
    .o_rollover_pulse_minus1   (rx_rollover_pulse_minus1),
    .o_roll_over_trig   (rx_roll_over_trig),
    .o_tam_adjust_valid_1s   (rx_tam_adjust_valid_1s),
    .o_tam_adjust_avg   (rx_tam_adjust_avg)
  );

  assign rx_sn_dn = (rx_measure_done && rx_sn_en);

//  assign tx_roll_over_sclk_return = (tx_calibrate) ? i_tx_sclk_return : (tx_measure_done && tx_sn_en) ? tx_roll_over_trig : i_tx_sclk_return;

//  assign rx_roll_over_sclk_return = (rx_calibrate) ? i_rx_sclk_return : (rx_measure_done && rx_sn_en) ? rx_roll_over_trig : i_rx_sclk_return;

  assign o_txrx_dt_status = {rx_dt_status, tx_dt_status};

  always@(posedge i_ptp_tx_clk )
  begin
    if(!tx_rst_txx_n)
      tx_dt_status <= {16{1'b0}};
    else
      tx_dt_status <= {7'h00, tx_sn_en, tx_dw_err2, tx_dw_err, tx_sn_err2, tx_sn_err, tx_sn_ready, tx_measure_done, tx_ptp_ready_x, ~tx_calibrate};
  end

  always@(posedge i_ptp_rx_clk )
  begin
    if(!rx_rst_rxx_n)
      rx_dt_status <= {16{1'b0}};
    else
      rx_dt_status <= {7'h00, rx_sn_en, rx_dw_err2, rx_dw_err, rx_sn_err2, rx_sn_err, rx_sn_ready, rx_measure_done, rx_ptp_ready_x, ~rx_calibrate};
  end


/*
        alt_ehipc3_fm_clock_crosser_nrd  #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (32),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) tx_error_icc (
            .in_clk                 (i_ptp_tx_clk),
            .in_reset               (!tx_rst_txx_n),
            .in_ready               (),
            .in_valid               (tx_error_valid_1s),
            .in_data                (o_tx_error),
            .out_clk                (i_ptp_clk),
            .out_reset              (!i_tx_rst_n1),
            .out_ready              (i_tx_rst_n1),

            .out_valid              (tx_error_cc_valid_1s),
            .out_data               (tx_error_cc)
        );


        always@(posedge i_ptp_clk)
        begin
        if(!i_tx_rst_n1)
          tx_error_p <= 32'd0;
        else if (tx_error_cc_valid_1s)
          tx_error_p <= tx_error_cc;
        end


        alt_ehipc3_fm_clock_crosser_nrd  #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (32),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) rx_error_icc (
            .in_clk                 (i_ptp_rx_clk),
            .in_reset               (!rx_rst_rxx_n),
            .in_ready               (),
            .in_valid               (rx_error_valid_1s),
            .in_data                (o_rx_error),
            .out_clk                (i_ptp_clk),
            .out_reset              (!i_rx_rst_n1),
            .out_ready              (i_rx_rst_n1),

            .out_valid              (rx_error_cc_valid_1s),
            .out_data               (rx_error_cc)
        );


        always@(posedge i_ptp_clk)
        begin
        if(!i_rx_rst_n1)
          rx_error_p <= 32'd0;
        else if (rx_error_cc_valid_1s)
          rx_error_p <= rx_error_cc;
        end


        alt_ehipc3_fm_clock_crosser_nrd  #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (32),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) tx_tam_adjust_avg_icc (
            .in_clk                 (i_ptp_tx_clk),
            .in_reset               (!tx_rst_txx_n),
            .in_ready               (),
            .in_valid               (tx_tam_adjust_valid_1s),
            .in_data                (tx_tam_adjust_avg),
            .out_clk                (i_ptp_clk),
            .out_reset              (!i_tx_rst_n1),
            .out_ready              (i_tx_rst_n1),

            .out_valid              (tx_tam_adjust_avg_p_valid_1s),
            .out_data               (tx_tam_adjust_avg_cc)
        );


        always@(posedge i_ptp_clk)
        begin
        if(!i_tx_rst_n1)
          tx_measure_done_p <= 1'b0;
        else if (tx_tam_adjust_avg_p_valid_1s)
          tx_measure_done_p <= 1'b1;
        end

        always@(posedge i_ptp_clk)
        begin
        if(!i_tx_rst_n1)
          tx_tam_adjust_avg_p <= 32'd0;
        else if (tx_tam_adjust_avg_p_valid_1s)
          tx_tam_adjust_avg_p <= tx_tam_adjust_avg_cc;
        end

        alt_ehipc3_fm_clock_crosser_nrd  #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (32),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) rx_tam_adjust_avg_icc (
            .in_clk                 (i_ptp_rx_clk),
            .in_reset               (!rx_rst_rxx_n),
            .in_ready               (),
            .in_valid               (rx_tam_adjust_valid_1s),
            .in_data                (rx_tam_adjust_avg),
            .out_clk                (i_ptp_clk),
            .out_reset              (!i_rx_rst_n1),
            .out_ready              (i_rx_rst_n1),

            .out_valid              (rx_tam_adjust_avg_p_valid_1s),
            .out_data               (rx_tam_adjust_avg_cc)
        );


        always@(posedge i_ptp_clk)
        begin
        if(!i_rx_rst_n1)
          rx_measure_done_p <= 1'b0;
        else if (rx_tam_adjust_avg_p_valid_1s)
          rx_measure_done_p <= 1'b1;
        end

        always@(posedge i_ptp_clk)
        begin
        if(!i_rx_rst_n1)
          rx_tam_adjust_avg_p <= 32'd0;
        else if (rx_tam_adjust_avg_p_valid_1s)
          rx_tam_adjust_avg_p <= rx_tam_adjust_avg_cc;
        end
*/
assign tx_error_p    = o_tx_error;
assign rx_error_p	   = o_rx_error;
assign tx_tam_adjust_avg_p = tx_tam_adjust_avg;
assign rx_tam_adjust_avg_p = rx_tam_adjust_avg;

   alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_measure_done_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (tx_measure_done),
        .q                  (tx_measure_done_p)
    );

       alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_measure_done_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (rx_measure_done),
        .q                  (rx_measure_done_p)
    );
    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_ptp_ready_2ds (
        .clk                (i_ptp_tx_clk),
        .reset              (1'b0),
        .d                  (tx_ptp_ready),
        .q                  (tx_ptp_ready_x)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_ptp_ready_2ds (
        .clk                (i_ptp_rx_clk),
        .reset              (1'b0),
        .d                  (rx_ptp_ready),
        .q                  (rx_ptp_ready_x)
    );


    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_calibrate_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (tx_calibrate),
        .q                  (tx_calibrate_p)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_calibrate_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (rx_calibrate),
        .q                  (rx_calibrate_p)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_sn_ready_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (tx_sn_ready),
        .q                  (tx_sn_ready_p)
    );


    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_sn_ready_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (rx_sn_ready),
        .q                  (rx_sn_ready_p)
    );


  assign o_tx_ptp_ready = tx_ptp_ready && tx_sn_ready_p;
  assign o_rx_ptp_ready = rx_ptp_ready && rx_sn_ready_p;


    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_rst_txx_n_2ds (
        .clk                (i_ptp_tx_clk),
        .reset              (1'b0),
        .d                  (i_tx_rst_n1),
        .q                  (tx_rst_txx_n_sync)
    );

        always @(posedge i_ptp_tx_clk) begin
             tx_rst_txx_n_0  <= tx_rst_txx_n_sync;
             tx_rst_txx_n    <= tx_rst_txx_n_0;

             tx_arst_txx_n_0 <= tx_rst_txx_n_sync;
             tx_arst_txx_n   <= tx_arst_txx_n_0;
        end


    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_rst_rxx_n_2ds (
        .clk                (i_ptp_rx_clk),
        .reset              (1'b0),
        .d                  (i_tx_rst_n1),
        .q                  (tx_rst_rxx_n_sync)
    );


    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) pcs_fully_aligned_rxx_n_2ds (
        .clk                (i_ptp_rx_clk),
        .reset              (1'b0),
        .d                  (i_pcs_fully_aligned),
        .q                  (pcs_fully_aligned_rxx_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_rst_rxx_n_2ds (
        .clk                (i_ptp_rx_clk),
        .reset              (1'b0),
        .d                  (i_rx_rst_n1),
        .q                  (rx_rst_rxx_n_sync)
    );

        always @(posedge i_ptp_rx_clk) begin
             rx_rst_rxx_n_0  <= rx_rst_rxx_n_sync & tx_rst_rxx_n_sync & pcs_fully_aligned_rxx_sync;
             rx_rst_rxx_n    <= rx_rst_rxx_n_0;

             rx_arst_rxx_n_0 <= rx_rst_rxx_n_sync & tx_rst_rxx_n_sync & pcs_fully_aligned_rxx_sync;
             rx_arst_rxx_n   <= rx_arst_rxx_n_0;
        end



//////////////////


 assign o_tx_dt_reg = 'd0;
 assign o_rx_dt_reg = 'd0;


 assign tx_tam_dbg = 'd0;
 assign rx_tam_dbg = 'd0;
 assign tx_tam_adjust_avg_dbg = 'd0;
 assign rx_tam_adjust_avg_dbg = 'd0;

 assign tx_ui_r_dbg = 'd0;
 assign rx_ui_r_dbg = 'd0;
 assign tx_tam_adjust_ui_r_dbg = 'd0;
 assign rx_tam_adjust_ui_r_dbg = 'd0;

 assign tx_tam_adjust_dbg = 'd0;
 assign rx_tam_adjust_no_adj_dbg = 'd0;
 assign tx_tam_adj_dbg = 'd0;
 assign rx_tam_adj_dbg = 'd0;



////////////////

   assign o_sclk = (tx_calibrate) ? o_tx_sclk : o_rx_sclk;

//   assign tx_sclk_return_2d1s = (tx_calibrate) ? tx_sclk_return_2d1s_wd : tx_sclk_return_2d1s_sn;
//   assign rx_sclk_return_2d1s = (rx_calibrate) ? rx_sclk_return_2d1s_wd : rx_sclk_return_2d1s_sn;

    alt_ehipc3_fm_sl_ptp_sn_xd_1shot #(
        .SYNC_FLOPS  (SYNC_FLOPS)
    ) tx_wasync_2ds (
        .i_reset_n                (tx_rst_txx_n),
        .i_clk                    (i_ptp_tx_clk),
        .i_async_triger           (o_tx_sclk),
        .o_sync_pulse_xd_1s       (tx_sclk_return_2d1s_wd)
    );

    alt_ehipc3_fm_sl_ptp_sn_xd_1shot #(
        .SYNC_FLOPS  (SYNC_FLOPS)
    ) tx_async_2ds (
        .i_reset_n                (tx_rst_txx_n),
        .i_clk                    (i_ptp_tx_clk),
        .i_async_triger           (i_tx_sclk_return),
        .o_sync_pulse_xd_1s       (tx_sclk_return_2d1s_sn),
        .o_sync_triger_2d         (o_sl_tx_sclk_return_sync)
    );


    alt_ehipc3_fm_sl_ptp_sn_xd_1shot #(
        .SYNC_FLOPS  (SYNC_FLOPS)
    ) rx_wasync_2ds (
        .i_reset_n                (rx_rst_rxx_n),
        .i_clk                    (i_ptp_rx_clk),
        .i_async_triger           (o_rx_sclk),
        .o_sync_pulse_xd_1s       (rx_sclk_return_2d1s_wd)
    );


    alt_ehipc3_fm_sl_ptp_sn_xd_1shot #(
        .SYNC_FLOPS  (SYNC_FLOPS)
    ) rx_async_2ds (
        .i_reset_n                (rx_rst_rxx_n),
        .i_clk                    (i_ptp_rx_clk),
        .i_async_triger           (i_rx_sclk_return),
        .o_sync_pulse_xd_1s       (rx_sclk_return_2d1s_sn)
    );


`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_reset_phz_2ds (
        .clk                (i_ptp_sn_sclk),
        .reset              (1'b0),
        .d                  (i_tx_rst_n1),
        .q                  (tx_reset_sn_sclk_n)
    );


`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_reset_phz_2ds (
        .clk                (i_ptp_sn_sclk),
        .reset              (1'b0),
        .d                  (rx_arst_rxx_n),
        .q                  (rx_reset_sn_sclk_n)
    );



    alt_ehipc3_fm_sl_ptp_sn_xd_1shot #(
        .SYNC_FLOPS  (SYNC_FLOPS)
    ) tx_async_phz_2ds (
        .i_reset_n                (tx_reset_sn_sclk_n),
        .i_clk                    (i_ptp_sn_sclk),
        .i_async_triger           (i_tx_sclk_return),
        .o_sync_pulse_xd_1s       (tx_sclk_return_phz_2d1s)
    );

    alt_ehipc3_fm_sl_ptp_sn_xd_1shot #(
        .SYNC_FLOPS  (SYNC_FLOPS)
    ) rx_async_phz_2ds (
        .i_reset_n                (rx_reset_sn_sclk_n),
        .i_clk                    (i_ptp_sn_sclk),
        .i_async_triger           (i_rx_sclk_return),
        .o_sync_pulse_xd_1s       (rx_sclk_return_phz_2d1s)
    );


  assign tx_cmbo_rollover_pulse_minus1 = (tx_calibrate) ? tx_clb_rollover_pulse_minus1 : tx_rollover_pulse_minus1;
  assign rx_cmbo_rollover_pulse_minus1 = (rx_calibrate) ? rx_clb_rollover_pulse_minus1 : rx_rollover_pulse_minus1;

  always@(posedge i_ptp_tx_clk)
  begin
    if(!tx_rst_txx_n)
      in_tx_roll_over_trig <= 1'b0;
//    else if (roll_over_count == apulse_period_minus_1[19:0])
    else if (tx_cmbo_rollover_pulse_minus1)
      in_tx_roll_over_trig <= ~in_tx_roll_over_trig;
  end

  always@(posedge i_ptp_rx_clk)
  begin
    if(!rx_rst_rxx_n)
      in_rx_roll_over_trig <= 1'b0;
//    else if (roll_over_count == apulse_period_minus_1[19:0])
    else if (rx_cmbo_rollover_pulse_minus1)
      in_rx_roll_over_trig <= ~in_rx_roll_over_trig;
  end


    alt_ehipc3_fm_sl_ptp_sn_xd_1shot #(
        .SYNC_FLOPS  (SYNC_FLOPS)
    ) tx_roll_over_phz_2ds (
        .i_reset_n                (tx_reset_sn_sclk_n),
        .i_clk                    (i_ptp_sn_sclk),
        .i_async_triger           (in_tx_roll_over_trig),
        .o_sync_pulse_xd_1s       (tx_roll_pulse_phz_2d1s)
    );

    alt_ehipc3_fm_sl_ptp_sn_xd_1shot #(
        .SYNC_FLOPS  (SYNC_FLOPS)
    ) rx_roll_over_phz_2ds (
        .i_reset_n                (rx_reset_sn_sclk_n),
        .i_clk                    (i_ptp_sn_sclk),
        .i_async_triger           (in_rx_roll_over_trig),
        .o_sync_pulse_xd_1s       (rx_roll_pulse_phz_2d1s)
    );


endmodule : alt_ehipc3_fm_sl_ptp_sn

module latency_module #(
 parameter LAT = 4,
 parameter WIDTH = 1
) (
	input logic clk,
	input logic[WIDTH-1:0]  i_data,
	output logic [WIDTH-1:0]  o_data /* synthesis preserve dont_replicate dont_retime */
);

	generate
		if ( LAT== 1)
			always @(posedge clk)
			begin
				o_data  <= i_data;
			end
		else if ( LAT== 3) begin
	reg [WIDTH-1:0] data_r1 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r2 /* synthesis preserve dont_replicate dont_retime */;
			always @(posedge clk)
			begin
				data_r1 <= i_data;
				data_r2 <= data_r1;
				o_data  <= data_r2;
			end
		end
		else if ( LAT== 4) begin
	reg [WIDTH-1:0] data_r1 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r2 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r3 /* synthesis preserve dont_replicate dont_retime */;
			always @(posedge clk)
			begin
				data_r1 <= i_data;
				data_r2 <= data_r1;
				data_r3 <= data_r2;
				o_data  <= data_r3;
			end
		end
		else
		begin
	reg [WIDTH-1:0] data_r1 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r2 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r3 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r4 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r5 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r6 /* synthesis preserve dont_replicate dont_retime */;
	reg [WIDTH-1:0] data_r7 /* synthesis preserve dont_replicate dont_retime */;
			always @(posedge clk)
			begin
				data_r1 <= i_data;
				data_r2 <= data_r1;
				data_r3 <= data_r2;
				data_r4 <= data_r3;
				data_r5 <= data_r4;
				data_r6 <= data_r5;
				data_r7 <= data_r6;
				o_data  <= data_r7;
			end
		end
	endgenerate
endmodule
//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
