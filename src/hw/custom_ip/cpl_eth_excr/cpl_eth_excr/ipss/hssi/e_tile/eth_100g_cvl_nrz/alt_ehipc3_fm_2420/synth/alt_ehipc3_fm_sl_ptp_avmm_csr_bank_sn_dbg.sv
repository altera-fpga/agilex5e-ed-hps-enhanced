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
// Filename         : ptp_avmm_csr_bank_sn_dbg.sv
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
//
//
//------------------------------------------------------------------------------

`timescale 1ns / 1ns
module alt_ehipc3_fm_sl_ptp_avmm_csr_bank_sn_dbg(
  input  logic        i_avmm_clk,
  input  logic        i_avmm_rst_n,
  output logic [31:0] o_avmm_readdata,               //                  csr.readdata
  input  logic        i_avmm_write,                  //                     .write
  input  logic        i_avmm_read,                   //                     .read
  input  logic [31:0] i_avmm_writedata,              //                     .writedata
  output logic        o_avmm_waitrequest,            //                     .waitrequest
  input  logic [6:0]  i_avmm_address,

  input  logic [47:0] i_tx_tam_capture,
  input  logic [15:0] i_tx_tam_count,
  input  logic        i_tx_tam_cap_valid,
  input  logic [47:0] i_rx_tam_capture,
  input  logic [15:0] i_rx_tam_count,
  input  logic        i_rx_tam_cap_valid,

  // 1ns
  input logic [31:0]  i_txrx_dt_status,
  input logic [31:0]  i_rx_dt_reg,
  input logic [31:0]  i_tx_dt_reg,

  input logic [31:0]  i_tx_apulse_rt_period,
  input logic [31:0]  i_tx_apulse_sn_period,
  input logic [31:0]  i_tx_apulse_err_period,
  input logic [31:0]  i_tx_apulse_err2_latency,
  input logic [31:0]  i_rx_apulse_rt_period,
  input logic [31:0]  i_rx_apulse_sn_period,
  input logic [31:0]  i_rx_apulse_err_period,
  input logic [31:0]  i_rx_apulse_err2_latency,

  input logic [31:0]  i_tx_w_apulse_rt_period,
  input logic [31:0]  i_tx_w_apulse_sn_period,
  input logic [31:0]  i_tx_w_apulse_err_period,
  input logic [31:0]  i_tx_w_apulse_err2_latency,
  input logic [31:0]  i_rx_w_apulse_rt_period,
  input logic [31:0]  i_rx_w_apulse_sn_period,
  input logic [31:0]  i_rx_w_apulse_err_period,
  input logic [31:0]  i_rx_w_apulse_err2_latency,

////
  input logic [95:0] tx_tam_dbg,
  input logic [95:0] rx_tam_dbg,

  input logic [31:0] tx_tam_adjust_avg_dbg,
  input logic [31:0] rx_tam_adjust_avg_dbg,

  input logic [31:0] tx_ui_r_dbg,
  input logic [31:0] rx_ui_r_dbg,

  input logic [11:0] tx_tam_adjust_ui_r_dbg,
  input logic [11:0] rx_tam_adjust_ui_r_dbg,

  input logic [43:0] tx_tam_adjust_dbg,
  input logic [43:0] rx_tam_adjust_no_adj_dbg,

  input logic [31:0] tx_tam_adj_dbg,
  input logic [31:0] rx_tam_adj_dbg,

  input logic [3:0]  i_tx_state_rollover,
  input logic [3:0]  i_rx_state_rollover,
  input logic [3:0]  i_tx_w_state_rollover,
  input logic [3:0]  i_rx_w_state_rollover,

  input logic [3:0]  i_tx_state_latencyphz,
  input logic [3:0]  i_rx_state_latencyphz,
  input logic [3:0]  i_tx_w_state_latencyphz,
  input logic [3:0]  i_rx_w_state_latencyphz,

  input logic [3:0]  i_tx_state_transition,
  input logic [3:0]  i_rx_state_transition,

  input logic [31:0]  i_tx_apulse_count,
  input logic [31:0]  i_rx_apulse_count,
  input logic [31:0]  i_tx_w_apulse_count,
  input logic [31:0]  i_rx_w_apulse_count,

  input logic [31:0]  i_tx_skip_ini,
  input logic [31:0]  i_rx_skip_ini,
  input logic [31:0]  i_tx_w_skip_ini,
  input logic [31:0]  i_rx_w_skip_ini,
////


  output logic [31:0] o_tx_apulse_period,
  output logic [31:0] o_tx_apulse_skip,
  output logic [31:0] o_tx_apulse_roll_dly,
  output logic [31:0] o_tx_apulse_cnt_pow2,
  output logic [31:0] o_tx_apulse_cnt,
  output logic [31:0] o_tx_sn_config,

  output logic [31:0] o_rx_apulse_period,
  output logic [31:0] o_rx_apulse_skip,
  output logic [31:0] o_rx_apulse_roll_dly,
  output logic [31:0] o_rx_apulse_cnt_pow2,
  output logic [31:0] o_rx_apulse_cnt,
  output logic [31:0] o_rx_sn_config,

  output logic [31:0] o_sn_pll_sclk_period,

  output logic        o_calibrate,
  input  logic        i_tx_calibrate_done,
  input  logic        i_rx_calibrate_done,
  input  logic        i_tx_error_valid,
  input  logic [31:0] i_tx_error,
  input  logic        i_rx_error_valid,
  input  logic [31:0] i_rx_error,
  output logic        o_ts_format,
  output logic        o_req_tx_ui_load,
  output logic        o_req_rx_ui_load,
  output logic [31:0] o_tx_ui,
  output logic [31:0] o_rx_ui,
  output logic [31:0] o_tpiso,
  output logic [31:0] o_rsipo,
  output logic [31:0] o_rxalign_offset

);

parameter ENHANCED_PTP_DBG          = 0;
parameter SIM_MODE          = 0;
parameter ehip_rate_sl      = "rate_25gx1";
parameter TX_UI_ADDR        = 7'h10;
parameter RX_UI_ADDR        = 7'h11;
parameter CAL_ADDR          = 7'h12;
parameter TX_ERR_ADDR       = 7'h13;
parameter RX_ERR_ADDR       = 7'h14;
parameter TS_FORMAT_ADDR    = 7'h15;
parameter TPISO_ADDR        = 7'h16;
parameter RSIPO_ADDR        = 7'h17;
parameter RXALIGH_OFST_ADDR = 7'h18;
parameter TAM_SNAPSHOT_ADDR = 7'h19;
parameter TX_TAM_L_ADDR     = 7'h1A;
parameter TX_TAM_H_ADDR     = 7'h1B;
parameter TX_TAM_COUNT_ADDR = 7'h1C;
parameter RX_TAM_L_ADDR     = 7'h1D;
parameter RX_TAM_H_ADDR     = 7'h1E;
parameter RX_TAM_COUNT_ADDR = 7'h1F;

parameter TXRX_DT_STATUS    = 7'h20;
parameter RX_DT_REG         = 7'h21;
parameter TX_DT_REG         = 7'h22;

parameter TX_APULSE_PERIOD_ADDR       = 7'h23;
parameter TX_APULSE_SKIP_ADDR         = 7'h24;
parameter TX_APULSE_ROLL_DLY_ADDR     = 7'h25;
parameter TX_APULSE_CNT_POW2_ADDR     = 7'h26;
parameter TX_APULSE_CNT_ADDR          = 7'h27;
parameter TX_APULSE_PERIOD_RT_ADDR    = 7'h28;
parameter TX_APULSE_PERIOD_SN_ADDR    = 7'h29;
parameter TX_APULSE_PERIOD_ERR_ADDR   = 7'h2A;
parameter TX_APULSE_LATENCY_ERR2_ADDR = 7'h2B;
parameter TX_SN_CONFIG_ADDR           = 7'h2C;

parameter RX_APULSE_PERIOD_ADDR       = 7'h2D;
parameter RX_APULSE_SKIP_ADDR         = 7'h2E;
parameter RX_APULSE_ROLL_DLY_ADDR     = 7'h2F;
parameter RX_APULSE_CNT_POW2_ADDR     = 7'h30;
parameter RX_APULSE_CNT_ADDR          = 7'h31;
parameter RX_APULSE_PERIOD_RT_ADDR    = 7'h32;
parameter RX_APULSE_PERIOD_SN_ADDR    = 7'h33;
parameter RX_APULSE_PERIOD_ERR_ADDR   = 7'h34;
parameter RX_APULSE_LATENCY_ERR2_ADDR = 7'h35;
parameter RX_SN_CONFIG_ADDR           = 7'h36;


parameter SN_PLL_SCLK_PERIOD_ADDR     = 7'h37;



parameter tx_tam_adjust_avg_dbg_ADDR       = 7'h38;
parameter rx_tam_adjust_avg_dbg_ADDR       = 7'h39;
parameter tx_ui_r_dbg_ADDR       = 7'h3a;
parameter rx_ui_r_dbg_ADDR       = 7'h3b;
parameter tx_tam_adjust_ui_r_dbg_ADDR       = 7'h3c;
parameter rx_tam_adjust_ui_r_dbg_ADDR       = 7'h3d;
parameter tx_tam_adjust_dbg_ADDR       = 7'h3e;
parameter rx_tam_adjust_no_adj_dbg_ADDR       = 7'h3f;

parameter tx_tam_adj_dbg_ADDR       = 7'h5a;
parameter rx_tam_adj_dbg_ADDR       = 7'h5b;

parameter tx_tam_dbg_ADDR       = 7'h5c;
parameter rx_tam_dbg_ADDR       = 7'h5d;


parameter SN_STATE_ADDR               = 7'h40;
parameter SN_W_STATE_ADDR             = 7'h41;

parameter TX_APULSE_COUNT_ADDR        = 7'h42;
parameter RX_APULSE_COUNT_ADDR        = 7'h43;
parameter TX_W_APULSE_COUNT_ADDR      = 7'h44;
parameter RX_W_APULSE_COUNT_ADDR      = 7'h45;

parameter TX_W_APULSE_PERIOD_RT_ADDR    = 7'h48;
parameter TX_W_APULSE_PERIOD_SN_ADDR    = 7'h49;
parameter TX_W_APULSE_PERIOD_ERR_ADDR   = 7'h4A;
parameter TX_W_APULSE_LATENCY_ERR2_ADDR = 7'h4B;

parameter TX_SKIP_INI_ADDR        = 7'h4c;
parameter RX_SKIP_INI_ADDR        = 7'h4d;
parameter TX_W_SKIP_INI_ADDR      = 7'h4e;
parameter RX_W_SKIP_INI_ADDR      = 7'h4f;

parameter RX_W_APULSE_PERIOD_RT_ADDR    = 7'h52;
parameter RX_W_APULSE_PERIOD_SN_ADDR    = 7'h53;
parameter RX_W_APULSE_PERIOD_ERR_ADDR   = 7'h54;
parameter RX_W_APULSE_LATENCY_ERR2_ADDR = 7'h55;

localparam UI_RESET_VALUE = (ehip_rate_sl == "rate_25gx1_fec") ? 32'h00_09_EE_01 :
                            (ehip_rate_sl == "rate_25gx1")     ? 32'h00_09_EE_01 :
                            (ehip_rate_sl == "rate_10gx1_25lr")? 32'h00_18_D3_02 :
                            (ehip_rate_sl == "rate_10gx1")     ? 32'h00_18_D3_02 :
                                                                 32'h00_18_D3_02 ;

localparam TX_ASYNC_PULSE_PERIOD =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? 32'd80    :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'd5120  :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'd5120  :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'd5120  :  32'd5280
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? 32'd80    :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'd81920 :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'd81920 :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'd81920 :  32'd84480;


localparam TX_APULSE_SKIP        =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? {16'd1, 16'd3}      :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {16'd1, 16'd3}      : {16'd1, 16'd3}
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? {16'd1, 16'd7}      :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {16'd1, 16'd7}      : {16'd1, 16'd7};

localparam TX_APULSE_ROLL_DLY    =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? {8'd15, 8'd4, 16'd16} :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {8'd15, 8'd4, 16'd8}  :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? {8'd15, 8'd4, 16'd16} :
                                                      (ehip_rate_sl == "rate_10gx1")     ? {8'd15, 8'd4, 16'd16} : {8'd15, 8'd4, 16'd8}
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? {8'd15, 8'd4, 16'd16} :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {8'd15, 8'd4, 16'd8}  :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? {8'd15, 8'd4, 16'd16} :
                                                      (ehip_rate_sl == "rate_10gx1")     ? {8'd15, 8'd4, 16'd16} : {8'd15, 8'd4, 16'd8};

localparam TX_APULSE_CNT         =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? 32'd175     :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'd175     :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'd175     :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'd175     : 32'd35
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? 32'd875     :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'd875     :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'd875     :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'd875     : 32'd875;

localparam TX_APULSE_CNT_POW2    =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? 32'hccc      :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'hccc      :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'hccc      :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'hccc      : 32'h4000
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? 32'h28F      :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'h28F      :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'h28F      :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'h28F      : 32'h28f;

localparam TX_SN_CONFIG          =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? {16'd1, 16'd1} :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {16'd0, 16'd1} :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? {16'd2, 16'd1} :
                                                      (ehip_rate_sl == "rate_10gx1")     ? {16'd2, 16'd1} : 32'd0
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? {16'd1, 16'd1} :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {16'd0, 16'd1} :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? {16'd2, 16'd1} :
                                                      (ehip_rate_sl == "rate_10gx1")     ? {16'd2, 16'd1} : 32'd0;


localparam RX_ASYNC_PULSE_PERIOD =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? 32'd80    :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'd96    :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'd96    :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'd96    : 32'd99
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? 32'd80    :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'd96    :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'd96    :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'd96    : 32'd99;

localparam RX_APULSE_SKIP        =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? {16'd20, 16'd10}      :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {16'd20, 16'd10}      : {16'd20, 16'd10}
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? {16'd20, 16'd5000}  :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {16'd20, 16'd5000}  : {16'd20, 16'd5000};

localparam RX_APULSE_ROLL_DLY    =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? {8'd15, 8'd4, 16'd16} :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {8'd15, 8'd4, 16'd8}  :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? {8'd15, 8'd4, 16'd8}  :
                                                      (ehip_rate_sl == "rate_10gx1")     ? {8'd15, 8'd4, 16'd8}  : {8'd15, 8'd4, 16'd8}
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? {8'd15, 8'd4, 16'd16} :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {8'd15, 8'd4, 16'd8}  :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? {8'd15, 8'd4, 16'd8}  :
                                                      (ehip_rate_sl == "rate_10gx1")     ? {8'd15, 8'd4, 16'd8}  : {8'd15, 8'd4, 16'd8};

localparam RX_APULSE_CNT         =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? 32'd175     :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'd175     :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'd175     :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'd175     : 32'd35
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? 32'd875     :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'd875     :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'd875     :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'd875     : 32'd875;

localparam RX_APULSE_CNT_POW2    =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? 32'hccc      :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'hccc      :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'hccc      :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'hccc      : 32'h4000
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? 32'h28F      :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? 32'h28F      :
                                                      (ehip_rate_sl == "rate_10gx1")     ? 32'h28F      :
                                                      (ehip_rate_sl == "rate_25gx1")     ? 32'h28F      : 32'h28f;

localparam RX_SN_CONFIG          =  (SIM_MODE == 1) ? (ehip_rate_sl == "rate_25gx1_fec") ? {16'd1, 16'd1} :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {16'd0, 16'd1} :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? {16'd2, 16'd1} :
                                                      (ehip_rate_sl == "rate_10gx1")     ? {16'd2, 16'd1} : 32'd0
                                                    : (ehip_rate_sl == "rate_25gx1_fec") ? {16'd1, 16'd1} :
                                                      (ehip_rate_sl == "rate_25gx1")     ? {16'd0, 16'd1} :
                                                      (ehip_rate_sl == "rate_10gx1_25lr")? {16'd2, 16'd1} :
                                                      (ehip_rate_sl == "rate_10gx1")     ? {16'd2, 16'd1} : 32'd0;

localparam SN_PLL_SCLK_PERIOD    =  20'h8C000;  //8.75ns
//localparam SN_PLL_SCLK_PERIOD    =  20'h40000;  //4ns

localparam SYNC_FLOPS            = 4'd3;

localparam SN_DBG                =  0;



logic [31:0] r_tx_apulse_period;
logic [31:0] r_tx_apulse_skip;
logic [31:0] r_tx_apulse_roll_dly;
logic [31:0] r_tx_apulse_cnt_pow2;
logic [31:0] r_tx_apulse_cnt;
logic [31:0] r_tx_sn_config;

logic [31:0] r_rx_apulse_period;
logic [31:0] r_rx_apulse_skip;
logic [31:0] r_rx_apulse_roll_dly;
logic [31:0] r_rx_apulse_cnt_pow2;
logic [31:0] r_rx_apulse_cnt;
logic [31:0] r_rx_sn_config;

logic [31:0] r_sn_pll_sclk_period;

logic        tx_calibrate_done;
logic        rx_calibrate_done;
logic        tx_calibrate_done_r;
logic        rx_calibrate_done_r;
logic [31:0] r_calibrate;
logic [31:0] r_tx_error;
logic [31:0] r_rx_error;
logic [31:0] r_ts_format;
logic [31:0] r_tx_ui;
logic [31:0] r_rx_ui;
logic [31:0] r_tpiso;
logic [31:0] r_rsipo;
logic [31:0] r_rxalign_offset;
logic [6:0]  r_avmm_address;
logic        r_avmm_read;
logic        r_avmm_waitrequest;
logic        i_avmm_write_r;
logic        i_avmm_read_r;

logic        r_tam_snapshot;
logic [31:0] r_tx_tam_l;
logic [15:0] r_tx_tam_h;
logic [15:0] r_tx_tam_count;
logic [31:0] r_rx_tam_l;
logic [15:0] r_rx_tam_h;
logic [15:0] r_rx_tam_count;


logic [31:0]  txrx_dt_status_2d;
logic [31:0]  rx_dt_reg_2d;
logic [31:0]  tx_dt_reg_2d;

logic [31:0]  tx_apulse_rt_period_2d;
logic [31:0]  tx_apulse_sn_period_2d;
logic [31:0]  tx_apulse_err_period_2d;
logic [31:0]  tx_apulse_err2_latency_2d;
logic [31:0]  rx_apulse_rt_period_2d;
logic [31:0]  rx_apulse_sn_period_2d;
logic [31:0]  rx_apulse_err_period_2d;
logic [31:0]  rx_apulse_err2_latency_2d;

logic [31:0]  tx_w_apulse_rt_period_2d;
logic [31:0]  tx_w_apulse_sn_period_2d;
logic [31:0]  tx_w_apulse_err_period_2d;
logic [31:0]  tx_w_apulse_err2_latency_2d;
logic [31:0]  rx_w_apulse_rt_period_2d;
logic [31:0]  rx_w_apulse_sn_period_2d;
logic [31:0]  rx_w_apulse_err_period_2d;
logic [31:0]  rx_w_apulse_err2_latency_2d;

   logic [3:0]  tx_state_rollover_2d;
   logic [3:0]  rx_state_rollover_2d;
   logic [3:0]  tx_w_state_rollover_2d;
   logic [3:0]  rx_w_state_rollover_2d;

   logic [3:0]  tx_state_latencyphz_2d;
   logic [3:0]  rx_state_latencyphz_2d;
   logic [3:0]  tx_w_state_latencyphz_2d;
   logic [3:0]  rx_w_state_latencyphz_2d;

   logic [3:0]  tx_state_transition_2d;
   logic [3:0]  rx_state_transition_2d;

   logic [31:0]  tx_apulse_count_2d;
   logic [31:0]  rx_apulse_count_2d;
   logic [31:0]  tx_w_apulse_count_2d;
   logic [31:0]  rx_w_apulse_count_2d;

   logic [31:0]  tx_skip_ini_2d;
   logic [31:0]  rx_skip_ini_2d;
   logic [31:0]  tx_w_skip_ini_2d;
   logic [31:0]  rx_w_skip_ini_2d;

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) tx_calibrate_done_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_tx_calibrate_done),
    .q                  (tx_calibrate_done)
);

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) rx_calibrate_done_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_rx_calibrate_done),
    .q                  (rx_calibrate_done)
);

always @ (posedge i_avmm_clk or negedge i_avmm_rst_n)
begin
  if(!i_avmm_rst_n)
  begin
    i_avmm_write_r <= 0;
    i_avmm_read_r  <= 0;
  end
  else
  begin
    i_avmm_write_r <= i_avmm_write;
    i_avmm_read_r  <= i_avmm_read;
  end
end

assign o_avmm_waitrequest = (i_avmm_write_r || (i_avmm_read_r && r_avmm_read && r_avmm_waitrequest && (i_avmm_address == r_avmm_address))) ? 1'b0 : 1'b1;
assign o_calibrate = r_calibrate[0];
assign o_ts_format = r_ts_format[0];
assign o_tx_ui = r_tx_ui;
assign o_rx_ui = r_rx_ui;
assign o_tpiso = r_tpiso;
assign o_rsipo = r_rsipo;
assign o_rxalign_offset = r_rxalign_offset;


assign o_tx_apulse_period   = (SN_DBG == 1) ? r_tx_apulse_period : TX_ASYNC_PULSE_PERIOD;
assign o_tx_apulse_skip     = (SN_DBG == 1) ? r_tx_apulse_skip : TX_APULSE_SKIP;
assign o_tx_apulse_roll_dly = (SN_DBG == 1) ? r_tx_apulse_roll_dly : TX_APULSE_ROLL_DLY;
assign o_tx_apulse_cnt_pow2 = (SN_DBG == 1) ? r_tx_apulse_cnt_pow2 : TX_APULSE_CNT_POW2;
assign o_tx_apulse_cnt      = (SN_DBG == 1) ? r_tx_apulse_cnt : TX_APULSE_CNT;
assign o_tx_sn_config       = (SN_DBG == 1) ? r_tx_sn_config : TX_SN_CONFIG;

assign o_rx_apulse_period   = (SN_DBG == 1) ? r_rx_apulse_period : RX_ASYNC_PULSE_PERIOD;
assign o_rx_apulse_skip     = (SN_DBG == 1) ? r_rx_apulse_skip : RX_APULSE_SKIP;
assign o_rx_apulse_roll_dly = (SN_DBG == 1) ? r_rx_apulse_roll_dly : RX_APULSE_ROLL_DLY;
assign o_rx_apulse_cnt_pow2 = (SN_DBG == 1) ? r_rx_apulse_cnt_pow2 : RX_APULSE_CNT_POW2;
assign o_rx_apulse_cnt      = (SN_DBG == 1) ? r_rx_apulse_cnt : RX_APULSE_CNT;
assign o_rx_sn_config       = (SN_DBG == 1) ? r_rx_sn_config : RX_SN_CONFIG;

assign o_sn_pll_sclk_period = (SN_DBG == 1) ? r_sn_pll_sclk_period : SN_PLL_SCLK_PERIOD;

always @ (posedge i_avmm_clk or negedge i_avmm_rst_n)
begin
  if(!i_avmm_rst_n)
  begin
    r_calibrate <= 0;
    //r_tx_error <= 0;
    //r_rx_error <= 0;
    r_ts_format <= 0;
    r_tx_ui <= UI_RESET_VALUE;
    r_rx_ui <= UI_RESET_VALUE;
    r_tpiso <= 0;
    r_rsipo <= 0;
    r_rxalign_offset <= 0;
    r_tam_snapshot <= 1'b0;

    r_tx_apulse_period   <= TX_ASYNC_PULSE_PERIOD;
    r_tx_apulse_skip     <= TX_APULSE_SKIP;
    r_tx_apulse_roll_dly <= TX_APULSE_ROLL_DLY;
    r_tx_apulse_cnt_pow2 <= TX_APULSE_CNT_POW2;
    r_tx_apulse_cnt      <= TX_APULSE_CNT;
    r_tx_sn_config       <= TX_SN_CONFIG;

    r_rx_apulse_period   <= RX_ASYNC_PULSE_PERIOD;
    r_rx_apulse_skip     <= RX_APULSE_SKIP;
    r_rx_apulse_roll_dly <= RX_APULSE_ROLL_DLY;
    r_rx_apulse_cnt_pow2 <= RX_APULSE_CNT_POW2;
    r_rx_apulse_cnt      <= RX_APULSE_CNT;
    r_rx_sn_config       <= RX_SN_CONFIG;

    r_sn_pll_sclk_period <= SN_PLL_SCLK_PERIOD;

  end
  else
  begin
    if (i_avmm_write)
    begin
      case (i_avmm_address)
        TX_UI_ADDR          : r_tx_ui          <= i_avmm_writedata;
        RX_UI_ADDR          : r_rx_ui          <= i_avmm_writedata;
        CAL_ADDR            : r_calibrate      <= i_avmm_writedata;
        //TX_ERR_ADDR         : r_tx_error       <= i_avmm_writedata;
        //RX_ERR_ADDR         : r_rx_error       <= i_avmm_writedata;
        TPISO_ADDR          : r_tpiso          <= i_avmm_writedata;
        TS_FORMAT_ADDR      : r_ts_format      <= i_avmm_writedata;
        RSIPO_ADDR          : r_rsipo          <= i_avmm_writedata;
        RXALIGH_OFST_ADDR   : r_rxalign_offset <= i_avmm_writedata;
        TAM_SNAPSHOT_ADDR   : r_tam_snapshot   <= i_avmm_writedata[0];

        TX_APULSE_PERIOD_ADDR    : r_tx_apulse_period     <= i_avmm_writedata;
        TX_APULSE_SKIP_ADDR      : r_tx_apulse_skip       <= i_avmm_writedata;
        TX_APULSE_ROLL_DLY_ADDR  : r_tx_apulse_roll_dly   <= i_avmm_writedata;
        TX_APULSE_CNT_POW2_ADDR  : begin
                                     r_tx_apulse_cnt_pow2   <= i_avmm_writedata;
//                                     r_tx_apulse_cnt        <= 1'b1 << i_avmm_writedata;
                                   end
 //       TX_APULSE_CNT_ADDR       : r_tx_apulse_cnt        <= i_avmm_writedata;
        TX_SN_CONFIG_ADDR        : r_tx_sn_config   <= {r_tx_sn_config[31:16], i_avmm_writedata[15:0]};

        RX_APULSE_PERIOD_ADDR    : r_rx_apulse_period     <= i_avmm_writedata;
        RX_APULSE_SKIP_ADDR      : r_rx_apulse_skip       <= i_avmm_writedata;
        RX_APULSE_ROLL_DLY_ADDR  : r_rx_apulse_roll_dly   <= i_avmm_writedata;
        RX_APULSE_CNT_POW2_ADDR  : begin
                                     r_rx_apulse_cnt_pow2   <= i_avmm_writedata;
//                                     r_rx_apulse_cnt        <= 1'b1 << i_avmm_writedata;
                                   end
//        RX_APULSE_CNT_ADDR       : r_rx_apulse_cnt        <= i_avmm_writedata;
        RX_SN_CONFIG_ADDR        : r_rx_sn_config   <= {r_rx_sn_config[31:16], i_avmm_writedata[15:0]};

        SN_PLL_SCLK_PERIOD_ADDR  : r_sn_pll_sclk_period   <= i_avmm_writedata;

      endcase
    end
  end
end

always @ (posedge i_avmm_clk or negedge i_avmm_rst_n)
begin
  if(!i_avmm_rst_n)
  begin
    r_rx_error <= 0;
  end
  else
  begin
    if (i_rx_error_valid)
    begin
      r_rx_error <= i_rx_error;
    end
  end
end

always @ (posedge i_avmm_clk or negedge i_avmm_rst_n)
begin
  if(!i_avmm_rst_n)
  begin
    r_tx_error <= 0;
  end
  else
  begin
    if (i_tx_error_valid)
    begin
      r_tx_error <= i_tx_error;
    end
  end
end

always @ (posedge i_avmm_clk or negedge i_avmm_rst_n)
begin
  if(!i_avmm_rst_n)
  begin
    tx_calibrate_done_r <= 0;
    rx_calibrate_done_r <= 0;
    o_req_tx_ui_load <= 0;
    o_req_rx_ui_load <= 0;
  end
  else
  begin
    tx_calibrate_done_r <= tx_calibrate_done;
    rx_calibrate_done_r <= rx_calibrate_done;
    o_req_tx_ui_load <= (i_avmm_write && (i_avmm_address == TX_UI_ADDR)) || (!tx_calibrate_done_r && tx_calibrate_done);
    o_req_rx_ui_load <= (i_avmm_write && (i_avmm_address == RX_UI_ADDR)) || (!rx_calibrate_done_r && rx_calibrate_done);
  end
end

always @ (posedge i_avmm_clk or negedge i_avmm_rst_n)
begin
  if (!i_avmm_rst_n)
  begin
    r_tx_tam_l     <= 32'h0;
    r_tx_tam_h     <= 16'h0;
    r_tx_tam_count <= 16'h0;
    r_rx_tam_l     <= 32'h0;
    r_rx_tam_h     <= 16'h0;
    r_rx_tam_count <= 16'h0;
  end
  else
  begin
    r_tx_tam_l     <= (~r_tam_snapshot & i_tx_tam_cap_valid) ? i_tx_tam_capture[31:0]  : r_tx_tam_l;
    r_tx_tam_h     <= (~r_tam_snapshot & i_tx_tam_cap_valid) ? i_tx_tam_capture[47:32] : r_tx_tam_h;
    r_tx_tam_count <= (~r_tam_snapshot & i_tx_tam_cap_valid) ? i_tx_tam_count          : r_tx_tam_count;
    r_rx_tam_l     <= (~r_tam_snapshot & i_rx_tam_cap_valid) ? i_rx_tam_capture[31:0]  : r_rx_tam_l;
    r_rx_tam_h     <= (~r_tam_snapshot & i_rx_tam_cap_valid) ? i_rx_tam_capture[47:32] : r_rx_tam_h;
    r_rx_tam_count <= (~r_tam_snapshot & i_rx_tam_cap_valid) ? i_rx_tam_count          : r_rx_tam_count;
  end
end

always @ (posedge i_avmm_clk or negedge i_avmm_rst_n)
begin
  if (!i_avmm_rst_n)
  begin
    r_avmm_address <= 0;
    r_avmm_read <= 0;
    r_avmm_waitrequest <= 0;
    o_avmm_readdata <= 0;
  end
  else
  begin
    r_avmm_address <= i_avmm_address;
    r_avmm_read <= i_avmm_read_r;
    r_avmm_waitrequest <= o_avmm_waitrequest;
    if (i_avmm_read_r)
    begin
      case (i_avmm_address)
        TX_UI_ADDR          : o_avmm_readdata <= r_tx_ui;
        RX_UI_ADDR          : o_avmm_readdata <= r_rx_ui;
        CAL_ADDR            : o_avmm_readdata <= r_calibrate;
        TX_ERR_ADDR         : o_avmm_readdata <= r_tx_error;
        RX_ERR_ADDR         : o_avmm_readdata <= r_rx_error;
        TS_FORMAT_ADDR      : o_avmm_readdata <= r_ts_format;
        TPISO_ADDR          : o_avmm_readdata <= r_tpiso;
        RSIPO_ADDR          : o_avmm_readdata <= r_rsipo;
        RXALIGH_OFST_ADDR   : o_avmm_readdata <= r_rxalign_offset;
        TAM_SNAPSHOT_ADDR   : o_avmm_readdata <= {31'h0,r_tam_snapshot};
        TX_TAM_L_ADDR       : o_avmm_readdata <= r_tx_tam_l;
        TX_TAM_H_ADDR       : o_avmm_readdata <= {16'h0,r_tx_tam_h};
        TX_TAM_COUNT_ADDR   : o_avmm_readdata <= {16'h0,r_tx_tam_count};
        RX_TAM_L_ADDR       : o_avmm_readdata <= r_rx_tam_l;
        RX_TAM_H_ADDR       : o_avmm_readdata <= {16'h0,r_rx_tam_h};
        RX_TAM_COUNT_ADDR   : o_avmm_readdata <= {16'h0,r_rx_tam_count};

        TXRX_DT_STATUS      : o_avmm_readdata <= txrx_dt_status_2d;
        RX_DT_REG           : o_avmm_readdata <= rx_dt_reg_2d;
        TX_DT_REG           : o_avmm_readdata <= tx_dt_reg_2d;

        TX_APULSE_PERIOD_ADDR       : o_avmm_readdata <= (SN_DBG == 1) ? r_tx_apulse_period : TX_ASYNC_PULSE_PERIOD;
        TX_APULSE_SKIP_ADDR         : o_avmm_readdata <= (SN_DBG == 1) ? r_tx_apulse_skip : TX_APULSE_SKIP;
        TX_APULSE_ROLL_DLY_ADDR     : o_avmm_readdata <= (SN_DBG == 1) ? r_tx_apulse_roll_dly : TX_APULSE_ROLL_DLY;
        TX_APULSE_CNT_POW2_ADDR     : o_avmm_readdata <= (SN_DBG == 1) ? r_tx_apulse_cnt_pow2 : TX_APULSE_CNT_POW2;
        TX_APULSE_CNT_ADDR          : o_avmm_readdata <= (SN_DBG == 1) ? r_tx_apulse_cnt : TX_APULSE_CNT;
        TX_APULSE_PERIOD_RT_ADDR    : o_avmm_readdata <= tx_apulse_rt_period_2d;
        TX_APULSE_PERIOD_SN_ADDR    : o_avmm_readdata <= tx_apulse_sn_period_2d;
        TX_APULSE_PERIOD_ERR_ADDR   : o_avmm_readdata <= tx_apulse_err_period_2d;
        TX_APULSE_LATENCY_ERR2_ADDR : o_avmm_readdata <= tx_apulse_err2_latency_2d;
        TX_SN_CONFIG_ADDR           : o_avmm_readdata <= (SN_DBG == 1) ? r_tx_sn_config : TX_SN_CONFIG;

        RX_APULSE_PERIOD_ADDR       : o_avmm_readdata <= (SN_DBG == 1) ? r_rx_apulse_period : RX_ASYNC_PULSE_PERIOD;
        RX_APULSE_SKIP_ADDR         : o_avmm_readdata <= (SN_DBG == 1) ? r_rx_apulse_skip : RX_APULSE_SKIP;
        RX_APULSE_ROLL_DLY_ADDR     : o_avmm_readdata <= (SN_DBG == 1) ? r_rx_apulse_roll_dly : RX_APULSE_ROLL_DLY;
        RX_APULSE_CNT_POW2_ADDR     : o_avmm_readdata <= (SN_DBG == 1) ? r_rx_apulse_cnt_pow2 : RX_APULSE_CNT_POW2;
        RX_APULSE_CNT_ADDR          : o_avmm_readdata <= (SN_DBG == 1) ? r_rx_apulse_cnt : RX_APULSE_CNT;
        RX_APULSE_PERIOD_RT_ADDR    : o_avmm_readdata <= rx_apulse_rt_period_2d;
        RX_APULSE_PERIOD_SN_ADDR    : o_avmm_readdata <= rx_apulse_sn_period_2d;
        RX_APULSE_PERIOD_ERR_ADDR   : o_avmm_readdata <= rx_apulse_err_period_2d;
        RX_APULSE_LATENCY_ERR2_ADDR : o_avmm_readdata <= rx_apulse_err2_latency_2d;
        RX_SN_CONFIG_ADDR           : o_avmm_readdata <= (SN_DBG == 1) ? r_rx_sn_config : RX_SN_CONFIG;

        SN_PLL_SCLK_PERIOD_ADDR     : o_avmm_readdata <= (SN_DBG == 1) ? r_sn_pll_sclk_period : SN_PLL_SCLK_PERIOD;

////
        tx_tam_dbg_ADDR    : o_avmm_readdata <= tx_tam_dbg[31:0];
        rx_tam_dbg_ADDR    : o_avmm_readdata <= rx_tam_dbg[31:0];

        tx_tam_adjust_avg_dbg_ADDR    : o_avmm_readdata <= tx_tam_adjust_avg_dbg;
        rx_tam_adjust_avg_dbg_ADDR    : o_avmm_readdata <= rx_tam_adjust_avg_dbg;

        tx_ui_r_dbg_ADDR    : o_avmm_readdata <= tx_ui_r_dbg;
        rx_ui_r_dbg_ADDR    : o_avmm_readdata <= rx_ui_r_dbg;

        tx_tam_adjust_ui_r_dbg_ADDR    : o_avmm_readdata <= tx_tam_adjust_ui_r_dbg;
        rx_tam_adjust_ui_r_dbg_ADDR    : o_avmm_readdata <= rx_tam_adjust_ui_r_dbg;

        tx_tam_adjust_dbg_ADDR    : o_avmm_readdata <= tx_tam_adjust_dbg[31:0];
        rx_tam_adjust_no_adj_dbg_ADDR    : o_avmm_readdata <= rx_tam_adjust_no_adj_dbg[31:0];

        tx_tam_adj_dbg_ADDR    : o_avmm_readdata <= tx_tam_adj_dbg;
        rx_tam_adj_dbg_ADDR    : o_avmm_readdata <= rx_tam_adj_dbg;
///

        SN_STATE_ADDR               : o_avmm_readdata <= {4'h0, rx_state_transition_2d, rx_state_latencyphz_2d, rx_state_rollover_2d,
                                                          4'h0, tx_state_transition_2d, tx_state_latencyphz_2d, tx_state_rollover_2d};

        SN_W_STATE_ADDR             : o_avmm_readdata <= {8'h00, rx_w_state_latencyphz_2d, rx_w_state_rollover_2d,
                                                          8'h00, tx_w_state_latencyphz_2d, tx_w_state_rollover_2d};

        TX_APULSE_COUNT_ADDR        : o_avmm_readdata <= tx_apulse_count_2d;
        RX_APULSE_COUNT_ADDR        : o_avmm_readdata <= rx_apulse_count_2d;
        TX_W_APULSE_COUNT_ADDR      : o_avmm_readdata <= tx_w_apulse_count_2d;
        RX_W_APULSE_COUNT_ADDR      : o_avmm_readdata <= rx_w_apulse_count_2d;


        TX_W_APULSE_PERIOD_RT_ADDR    : o_avmm_readdata <= tx_w_apulse_rt_period_2d;
        TX_W_APULSE_PERIOD_SN_ADDR    : o_avmm_readdata <= tx_w_apulse_sn_period_2d;
        TX_W_APULSE_PERIOD_ERR_ADDR   : o_avmm_readdata <= tx_w_apulse_err_period_2d;
        TX_W_APULSE_LATENCY_ERR2_ADDR : o_avmm_readdata <= tx_w_apulse_err2_latency_2d;

        TX_SKIP_INI_ADDR        : o_avmm_readdata <= tx_skip_ini_2d;
        RX_SKIP_INI_ADDR        : o_avmm_readdata <= rx_skip_ini_2d;
        TX_W_SKIP_INI_ADDR      : o_avmm_readdata <= tx_w_skip_ini_2d;
        RX_W_SKIP_INI_ADDR      : o_avmm_readdata <= rx_w_skip_ini_2d;

        RX_W_APULSE_PERIOD_RT_ADDR    : o_avmm_readdata <= rx_w_apulse_rt_period_2d;
        RX_W_APULSE_PERIOD_SN_ADDR    : o_avmm_readdata <= rx_w_apulse_sn_period_2d;
        RX_W_APULSE_PERIOD_ERR_ADDR   : o_avmm_readdata <= rx_w_apulse_err_period_2d;
        RX_W_APULSE_LATENCY_ERR2_ADDR : o_avmm_readdata <= rx_w_apulse_err2_latency_2d;



      endcase
    end
  end
end

/*

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) txrx_dt_status_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_txrx_dt_status),
        .q                  (txrx_dt_status_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_dt_reg_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_dt_reg),
        .q                  (rx_dt_reg_2d)
    );


     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_dt_reg_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_dt_reg),
        .q                  (tx_dt_reg_2d)
    );
*/

  assign txrx_dt_status_2d = i_txrx_dt_status;

  generate
  if (ENHANCED_PTP_DBG == 1)
  begin : DBG

  assign tx_dt_reg_2d = i_tx_dt_reg;
  assign rx_dt_reg_2d = i_rx_dt_reg;

  assign tx_apulse_rt_period_2d = i_tx_apulse_rt_period;
  assign tx_apulse_sn_period_2d = i_tx_apulse_sn_period;
  assign tx_apulse_err_period_2d = i_tx_apulse_err_period;
  assign tx_apulse_err2_latency_2d = i_tx_apulse_err2_latency;

  assign rx_apulse_rt_period_2d = i_rx_apulse_rt_period;
  assign rx_apulse_sn_period_2d = i_rx_apulse_sn_period;
  assign rx_apulse_err_period_2d = i_rx_apulse_err_period;
  assign rx_apulse_err2_latency_2d = i_rx_apulse_err2_latency;


  assign tx_w_apulse_rt_period_2d = i_tx_w_apulse_rt_period;
  assign tx_w_apulse_sn_period_2d = i_tx_w_apulse_sn_period;
  assign tx_w_apulse_err_period_2d = i_tx_w_apulse_err_period;
  assign tx_w_apulse_err2_latency_2d = i_tx_w_apulse_err2_latency;

  assign rx_w_apulse_rt_period_2d = i_rx_w_apulse_rt_period;
  assign rx_w_apulse_sn_period_2d = i_rx_w_apulse_sn_period;
  assign rx_w_apulse_err_period_2d = i_rx_w_apulse_err_period;
  assign rx_w_apulse_err2_latency_2d = i_rx_w_apulse_err2_latency;

  assign tx_state_rollover_2d = i_tx_state_rollover;
  assign rx_state_rollover_2d = i_rx_state_rollover;
  assign tx_w_state_rollover_2d = i_tx_w_state_rollover;
  assign rx_w_state_rollover_2d = i_rx_w_state_rollover;
  assign tx_state_latencyphz_2d = i_tx_state_latencyphz;
  assign rx_state_latencyphz_2d = i_rx_state_latencyphz;
  assign tx_w_state_latencyphz_2d = i_tx_w_state_latencyphz;
  assign rx_w_state_latencyphz_2d = i_rx_w_state_latencyphz;
  assign tx_state_transition_2d = i_tx_state_transition;
  assign rx_state_transition_2d = i_rx_state_transition;
  assign tx_apulse_count_2d = i_tx_apulse_count;
  assign rx_apulse_count_2d = i_rx_apulse_count;
  assign tx_w_apulse_count_2d = i_tx_w_apulse_count;
  assign rx_w_apulse_count_2d = i_rx_w_apulse_count;
  assign tx_skip_ini_2d = i_tx_skip_ini;
  assign rx_skip_ini_2d = i_rx_skip_ini;
  assign tx_w_skip_ini_2d = i_tx_w_skip_ini;
  assign rx_w_skip_ini_2d = i_rx_w_skip_ini;


/*


     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_apulse_rt_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_apulse_rt_period),
        .q                  (tx_apulse_rt_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_apulse_sn_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_apulse_sn_period),
        .q                  (tx_apulse_sn_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_apulse_err_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_apulse_err_period),
        .q                  (tx_apulse_err_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_apulse_err2_latency_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_apulse_err2_latency),
        .q                  (tx_apulse_err2_latency_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_apulse_rt_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_apulse_rt_period),
        .q                  (rx_apulse_rt_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_apulse_sn_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_apulse_sn_period),
        .q                  (rx_apulse_sn_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_apulse_err_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_apulse_err_period),
        .q                  (rx_apulse_err_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_apulse_err2_latency_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_apulse_err2_latency),
        .q                  (rx_apulse_err2_latency_2d)
    );
//


     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_w_apulse_rt_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_w_apulse_rt_period),
        .q                  (tx_w_apulse_rt_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_w_apulse_sn_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_w_apulse_sn_period),
        .q                  (tx_w_apulse_sn_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_w_apulse_err_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_w_apulse_err_period),
        .q                  (tx_w_apulse_err_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_w_apulse_err2_latency_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_w_apulse_err2_latency),
        .q                  (tx_w_apulse_err2_latency_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_w_apulse_rt_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_w_apulse_rt_period),
        .q                  (rx_w_apulse_rt_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_w_apulse_sn_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_w_apulse_sn_period),
        .q                  (rx_w_apulse_sn_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_w_apulse_err_period_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_w_apulse_err_period),
        .q                  (rx_w_apulse_err_period_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_w_apulse_err2_latency_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_w_apulse_err2_latency),
        .q                  (rx_w_apulse_err2_latency_2d)
    );


/////



     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) tx_state_rollover_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_state_rollover),
        .q                  (tx_state_rollover_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) rx_state_rollover_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_state_rollover),
        .q                  (rx_state_rollover_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) tx_w_state_rollover_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_w_state_rollover),
        .q                  (tx_w_state_rollover_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) rx_w_state_rollover_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_w_state_rollover),
        .q                  (rx_w_state_rollover_2d)
    );



//
     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) tx_state_latencyphz_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_state_latencyphz),
        .q                  (tx_state_latencyphz_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) rx_state_latencyphz_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_state_latencyphz),
        .q                  (rx_state_latencyphz_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) tx_w_state_latencyphz_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_w_state_latencyphz),
        .q                  (tx_w_state_latencyphz_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) rx_w_state_latencyphz_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_w_state_latencyphz),
        .q                  (rx_w_state_latencyphz_2d)
    );



//
     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) tx_state_transition_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_state_transition),
        .q                  (tx_state_transition_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) rx_state_transition_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_state_transition),
        .q                  (rx_state_transition_2d)
    );

//
     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_apulse_count_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_apulse_count),
        .q                  (tx_apulse_count_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_apulse_count_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_apulse_count),
        .q                  (rx_apulse_count_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_w_apulse_count_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_w_apulse_count),
        .q                  (tx_w_apulse_count_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_w_apulse_count_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_w_apulse_count),
        .q                  (rx_w_apulse_count_2d)
    );

//

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_skip_ini_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_skip_ini),
        .q                  (tx_skip_ini_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_skip_ini_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_skip_ini),
        .q                  (rx_skip_ini_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tx_w_skip_ini_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_tx_w_skip_ini),
        .q                  (tx_w_skip_ini_2d)
    );

     alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) rx_w_skip_ini_2ds (
        .clk                (i_avmm_clk),
        .reset              (1'b0),
        .d                  (i_rx_w_skip_ini),
        .q                  (rx_w_skip_ini_2d)
    );
*/
  end // DBG
  endgenerate

/////

  endmodule : alt_ehipc3_fm_sl_ptp_avmm_csr_bank_sn_dbg

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
