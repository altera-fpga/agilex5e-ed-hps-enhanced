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
// Filename         : ptp_avmm_csr_bank_sn.sv
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
module alt_ehipc3_fm_sl_ptp_avmm_csr_bank_sn(
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

localparam UI_RESET_VALUE = (ehip_rate_sl == "rate_25gx1_fec") ? 32'h00_09_EE_01 :
                            (ehip_rate_sl == "rate_25gx1")     ? 32'h00_09_EE_01 :
                            (ehip_rate_sl == "rate_10gx1_25lr")? 32'h00_18_D3_02 :
                            (ehip_rate_sl == "rate_10gx1")     ? 32'h00_18_D3_02 :
                                                                 32'h00_18_D3_02 ;

localparam SYNC_FLOPS            = 4'd3;


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
      endcase
    end
  end
end


  assign txrx_dt_status_2d = i_txrx_dt_status;
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
*/


  endmodule : alt_ehipc3_fm_sl_ptp_avmm_csr_bank_sn

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
