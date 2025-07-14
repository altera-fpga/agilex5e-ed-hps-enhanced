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


`timescale 1ns / 1ns
module alt_ehipc3_fm_ml_ptp_avmm_csr_bank(
  input  logic        i_avmm_clk,
  input  logic        i_avmm_rst_n,
  output logic [31:0] o_avmm_readdata,               //                  csr.readdata
  input  logic        i_avmm_write,                  //                     .write
  input  logic        i_avmm_read,                   //                     .read
  input  logic [31:0] i_avmm_writedata,              //                     .writedata
  output logic        o_avmm_waitrequest,            //                     .waitrequest
  output logic        o_avmm_readdatavalid,          //                     .readdatavalid
  input  logic [7:0]  i_avmm_address,

  input  logic [47:0] i_tx_tam_capture,
  input  logic [15:0] i_tx_tam_count,
  input  logic        i_tx_tam_cap_valid,
  input  logic [47:0] i_rx_tam_capture,
  input  logic [15:0] i_rx_tam_count,
  input  logic        i_rx_tam_cap_valid,

  output logic        o_calibrate,
  input  logic        i_tx_calibrate_done,
  input  logic        i_rx_calibrate_done,
  input  logic        i_tx_error_valid,
  input  logic [31:0] i_tx_error,
  input  logic        i_rx_error_valid,
  input  logic [31:0] i_rx_error,
  input  logic        i_rx_pcs_fully_aligned,
  input  logic        i_vl_offset_data_valid,
  input  logic [19:0][35:0] i_vl_offset_data,
  output logic        o_ts_format,
  output logic        o_req_tx_ui_load,
  output logic        o_req_rx_ui_load,
  output logic [31:0] o_tx_ui,
  output logic [31:0] o_rx_ui,
  output logic [31:0] o_tpiso,
  output logic [31:0] o_rsipo,
  output logic [31:0] o_rxalign_offset,
  output logic [19:0] o_vl_offset_load,
  output logic [19:0][38:0] o_vl_offset,

  output logic [2:0]  o_ptp_tx_ref_lane,
  output logic [2:0]  o_ptp_rx_ref_lane,

  input  logic        i_ptp_tx_user_cfg_done_hwclr,
  output logic        o_ptp_tx_user_cfg_done,
  input  logic        i_ptp_rx_user_cfg_done_hwclr,
  output logic        o_ptp_rx_user_cfg_done,

  input  logic        i_ptp_tx_ptp_offset_data_valid,
  input  logic        i_ptp_rx_ptp_offset_data_valid,
  input  logic        i_ptp_tx_ptp_ready,
  input  logic        i_ptp_rx_ptp_ready,

  input  logic      [31:0] i_ptp_tx_lane_calc_data_constdelay,
  input  logic      [31:0] i_ptp_rx_lane_calc_data_constdelay,
  input  logic [3:0][31:0] i_ptp_tx_lane_calc_data_offset,
  input  logic [3:0][31:0] i_ptp_rx_lane_calc_data_offset,
  input  logic [3:0][27:0] i_ptp_tx_lane_calc_data_time,
  input  logic [3:0][27:0] i_ptp_rx_lane_calc_data_time,
  input  logic [3:0][19:0] i_ptp_tx_lane_calc_data_wiredelay,
  input  logic [3:0][19:0] i_ptp_rx_lane_calc_data_wiredelay
);

localparam TX_UI_ADDR           = 8'h0;
localparam RX_UI_ADDR           = 8'h1;
localparam CAL_ADDR             = 8'h2;
localparam TX_ERR_ADDR          = 8'h3;
localparam RX_ERR_ADDR          = 8'h4;
localparam TS_FORMAT_ADDR       = 8'h5;
localparam TPISO_ADDR           = 8'h6;
localparam RSIPO_ADDR           = 8'h7;
localparam RXALIGH_OFST_ADDR    = 8'h8;
localparam VL_OFFSET_RLD_ADDR   = 8'hF;
localparam VL_OFFSET_DATA_ADDR  = 8'h10;
localparam VL_OFFSET_ADDR       = 8'h40;
localparam TAM_SNAPSHOT_ADDR    = 8'h70;
localparam TX_TAM_L_ADDR        = 8'h71;
localparam TX_TAM_H_ADDR        = 8'h72;
localparam TX_TAM_COUNT_ADDR    = 8'h73;
localparam RX_TAM_L_ADDR        = 8'h74;
localparam RX_TAM_H_ADDR        = 8'h75;
localparam RX_TAM_COUNT_ADDR    = 8'h76;
localparam TX_REF_LANE_ADDR     = 8'h77;
localparam RX_REF_LANE_ADDR     = 8'h78;
localparam TX_USER_CFG_ADDR     = 8'h79;
localparam RX_USER_CFG_ADDR     = 8'h7A;
localparam PTP_STATUS_ADDR      = 8'h7B;
localparam TX_CONST_DELAY_ADDR  = 8'h7C;
localparam RX_CONST_DELAY_ADDR  = 8'h7D;
localparam TX_L0_OFFSET_ADDR    = 8'h7E;
localparam RX_L0_OFFSET_ADDR    = 8'h7F;
localparam TX_L0_TIME_ADDR      = 8'h80;
localparam RX_L0_TIME_ADDR      = 8'h81;
localparam TX_L0_WIRE_DLY_ADDR  = 8'h82;
localparam RX_L0_WIRE_DLY_ADDR  = 8'h83;
localparam TX_L1_OFFSET_ADDR    = 8'h84;
localparam RX_L1_OFFSET_ADDR    = 8'h85;
localparam TX_L1_TIME_ADDR      = 8'h86;
localparam RX_L1_TIME_ADDR      = 8'h87;
localparam TX_L1_WIRE_DLY_ADDR  = 8'h88;
localparam RX_L1_WIRE_DLY_ADDR  = 8'h89;
localparam TX_L2_OFFSET_ADDR    = 8'h8A;
localparam RX_L2_OFFSET_ADDR    = 8'h8B;
localparam TX_L2_TIME_ADDR      = 8'h8C;
localparam RX_L2_TIME_ADDR      = 8'h8D;
localparam TX_L2_WIRE_DLY_ADDR  = 8'h8E;
localparam RX_L2_WIRE_DLY_ADDR  = 8'h8F;
localparam TX_L3_OFFSET_ADDR    = 8'h90;
localparam RX_L3_OFFSET_ADDR    = 8'h91;
localparam TX_L3_TIME_ADDR      = 8'h92;
localparam RX_L3_TIME_ADDR      = 8'h93;
localparam TX_L3_WIRE_DLY_ADDR  = 8'h94;
localparam RX_L3_WIRE_DLY_ADDR  = 8'h95;

localparam TX_UI_RESET_VALUE    = 32'h00_09_EE_01;
localparam RX_BLOCK_RESET_VALUE = 32'h0C_CC_CC_CD;

logic        tx_calibrate_done;
logic        rx_calibrate_done;
logic        tx_calibrate_done_r;
logic        rx_calibrate_done_r;
logic        rx_pcs_fully_aligned;
logic        vl_offset_need_reload;
logic        vl_offset_data_valid;
logic [31:0] r_calibrate;
logic [31:0] r_tx_error;
logic [31:0] r_rx_error;
logic [31:0] r_ts_format;
logic [31:0] r_tx_ui;
logic [31:0] r_rx_ui;
logic [31:0] r_tpiso;
logic [31:0] r_rsipo;
logic [31:0] r_rxalign_offset;
logic [7:0]  r_avmm_address;
logic        r_avmm_read;
logic        r_avmm_waitrequest;

logic        r_tam_snapshot;
logic [31:0] r_tx_tam_l;
logic [15:0] r_tx_tam_h;
logic [15:0] r_tx_tam_count;
logic [31:0] r_rx_tam_l;
logic [15:0] r_rx_tam_h;
logic [15:0] r_rx_tam_count;

logic        ptp_tx_user_cfg_done_hwclr;
logic        ptp_rx_user_cfg_done_hwclr;
logic        ptp_tx_ptp_offset_data_valid;
logic        ptp_rx_ptp_offset_data_valid;
logic        ptp_tx_ptp_ready;
logic        ptp_rx_ptp_ready;

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

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) rx_pcs_fully_aligned_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_rx_pcs_fully_aligned),
    .q                  (rx_pcs_fully_aligned)
);

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) vl_offset_data_valid_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_vl_offset_data_valid),
    .q                  (vl_offset_data_valid)
);

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) ptp_tx_user_cfg_done_hwclr_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_ptp_tx_user_cfg_done_hwclr),
    .q                  (ptp_tx_user_cfg_done_hwclr)
);

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) ptp_rx_user_cfg_done_hwclr_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_ptp_rx_user_cfg_done_hwclr),
    .q                  (ptp_rx_user_cfg_done_hwclr)
);

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) ptp_tx_ptp_offset_data_valid_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_ptp_tx_ptp_offset_data_valid),
    .q                  (ptp_tx_ptp_offset_data_valid)
);

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) ptp_rx_ptp_offset_data_valid_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_ptp_rx_ptp_offset_data_valid),
    .q                  (ptp_rx_ptp_offset_data_valid)
);

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) ptp_tx_ptp_ready_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_ptp_tx_ptp_ready),
    .q                  (ptp_tx_ptp_ready)
);

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) ptp_rx_ptp_ready_sync (
    .clk                (i_avmm_clk),
    .reset              (!i_avmm_rst_n),
    .d                  (i_ptp_rx_ptp_ready),
    .q                  (ptp_rx_ptp_ready)
);

assign o_avmm_waitrequest = (i_avmm_write || (i_avmm_read && r_avmm_read && r_avmm_waitrequest && (i_avmm_address == r_avmm_address))) ? 1'b0 : 1'b1;
assign o_avmm_readdatavalid = (i_avmm_read && !o_avmm_waitrequest) ? 1'b1 : 1'b0;
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
    r_tx_ui <= TX_UI_RESET_VALUE;
    r_rx_ui <= RX_BLOCK_RESET_VALUE;
    r_tpiso <= 0;
    r_rsipo <= 0;
    r_rxalign_offset <= 0;
    o_vl_offset <= '0;
    r_tam_snapshot <= 1'b0;
    o_ptp_tx_ref_lane <= 3'b000;
    o_ptp_rx_ref_lane <= 3'b000;
    o_ptp_tx_user_cfg_done <= 1'b0;
    o_ptp_rx_user_cfg_done <= 1'b0;
  end
  else
  begin
    if (i_avmm_write)
    begin
      case (i_avmm_address)
        TX_UI_ADDR          : r_tx_ui               <= i_avmm_writedata;
        RX_UI_ADDR          : r_rx_ui               <= i_avmm_writedata;
        CAL_ADDR            : r_calibrate           <= i_avmm_writedata;
        //TX_ERR_ADDR         : r_tx_error            <= i_avmm_writedata;
        //RX_ERR_ADDR         : r_rx_error            <= i_avmm_writedata;
        TPISO_ADDR          : r_tpiso               <= i_avmm_writedata;
        TS_FORMAT_ADDR      : r_ts_format           <= i_avmm_writedata;
        RSIPO_ADDR          : r_rsipo               <= i_avmm_writedata;
        RXALIGH_OFST_ADDR   : r_rxalign_offset      <= i_avmm_writedata;
        VL_OFFSET_ADDR +  0 : o_vl_offset[ 0][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR +  1 : o_vl_offset[ 0][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR +  2 : o_vl_offset[ 1][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR +  3 : o_vl_offset[ 1][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR +  4 : o_vl_offset[ 2][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR +  5 : o_vl_offset[ 2][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR +  6 : o_vl_offset[ 3][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR +  7 : o_vl_offset[ 3][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR +  8 : o_vl_offset[ 4][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR +  9 : o_vl_offset[ 4][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 10 : o_vl_offset[ 5][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 11 : o_vl_offset[ 5][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 12 : o_vl_offset[ 6][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 13 : o_vl_offset[ 6][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 14 : o_vl_offset[ 7][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 15 : o_vl_offset[ 7][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 16 : o_vl_offset[ 8][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 17 : o_vl_offset[ 8][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 18 : o_vl_offset[ 9][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 19 : o_vl_offset[ 9][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 20 : o_vl_offset[10][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 21 : o_vl_offset[10][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 22 : o_vl_offset[11][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 23 : o_vl_offset[11][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 24 : o_vl_offset[12][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 25 : o_vl_offset[12][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 26 : o_vl_offset[13][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 27 : o_vl_offset[13][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 28 : o_vl_offset[14][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 29 : o_vl_offset[14][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 30 : o_vl_offset[15][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 31 : o_vl_offset[15][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 32 : o_vl_offset[16][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 33 : o_vl_offset[16][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 34 : o_vl_offset[17][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 35 : o_vl_offset[17][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 36 : o_vl_offset[18][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 37 : o_vl_offset[18][38:7] <= i_avmm_writedata;
        VL_OFFSET_ADDR + 38 : o_vl_offset[19][ 6:0] <= i_avmm_writedata[6:0];
        VL_OFFSET_ADDR + 39 : o_vl_offset[19][38:7] <= i_avmm_writedata;
        TAM_SNAPSHOT_ADDR   : r_tam_snapshot        <= i_avmm_writedata[0];
        TX_REF_LANE_ADDR    : o_ptp_tx_ref_lane     <= i_avmm_writedata[2:0];
        RX_REF_LANE_ADDR    : o_ptp_rx_ref_lane     <= i_avmm_writedata[2:0];
        TX_USER_CFG_ADDR    : o_ptp_tx_user_cfg_done<= i_avmm_writedata[0];
        RX_USER_CFG_ADDR    : o_ptp_rx_user_cfg_done<= i_avmm_writedata[0];
      endcase
    end
    if(ptp_tx_user_cfg_done_hwclr) o_ptp_tx_user_cfg_done <= 1'b0;
    if(ptp_rx_user_cfg_done_hwclr) o_ptp_rx_user_cfg_done <= 1'b0;
  end
end

always @ (posedge i_avmm_clk or negedge i_avmm_rst_n)
begin
  if(!i_avmm_rst_n)
  begin
    vl_offset_need_reload <= 0;
  end
  else
  begin
    if (!rx_pcs_fully_aligned)
    begin
      vl_offset_need_reload <= 1'b1;
    end
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// 11/Oct/2018 : slim35 : Missing address checking in reload equation.
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
//    else if (i_avmm_write && !i_avmm_writedata[0]) //else if (i_avmm_write && ((i_avmm_address >= (VL_OFFSET_ADDR + 0)) || (i_avmm_address <= (VL_OFFSET_ADDR + 39))))
    else if (i_avmm_write && !i_avmm_writedata[0] && (i_avmm_address==VL_OFFSET_RLD_ADDR)) //else if (i_avmm_write && ((i_avmm_address >= (VL_OFFSET_ADDR + 0)) || (i_avmm_address <= (VL_OFFSET_ADDR + 39))))
// -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    begin
      vl_offset_need_reload <= 1'b0;
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
    o_vl_offset_load <= 0;
  end
  else
  begin
    tx_calibrate_done_r <= tx_calibrate_done;
    rx_calibrate_done_r <= rx_calibrate_done;
    o_req_tx_ui_load <= (i_avmm_write && (i_avmm_address == TX_UI_ADDR)) || (!tx_calibrate_done_r && tx_calibrate_done);
    o_req_rx_ui_load <= (i_avmm_write && (i_avmm_address == RX_UI_ADDR)) || (!rx_calibrate_done_r && rx_calibrate_done);
    o_vl_offset_load[ 0] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR +  1)));
    o_vl_offset_load[ 1] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR +  3)));
    o_vl_offset_load[ 2] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR +  5)));
    o_vl_offset_load[ 3] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR +  7)));
    o_vl_offset_load[ 4] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR +  9)));
    o_vl_offset_load[ 5] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 11)));
    o_vl_offset_load[ 6] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 13)));
    o_vl_offset_load[ 7] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 15)));
    o_vl_offset_load[ 8] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 17)));
    o_vl_offset_load[ 9] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 19)));
    o_vl_offset_load[10] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 21)));
    o_vl_offset_load[11] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 23)));
    o_vl_offset_load[12] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 25)));
    o_vl_offset_load[13] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 27)));
    o_vl_offset_load[14] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 29)));
    o_vl_offset_load[15] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 31)));
    o_vl_offset_load[16] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 33)));
    o_vl_offset_load[17] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 35)));
    o_vl_offset_load[18] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 37)));
    o_vl_offset_load[19] <= (i_avmm_write && (i_avmm_address == (VL_OFFSET_ADDR + 39)));
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
    r_avmm_read <= i_avmm_read;
    r_avmm_waitrequest <= o_avmm_waitrequest;
    if (i_avmm_read)
    begin
      case (i_avmm_address)
        TX_UI_ADDR               : o_avmm_readdata <= r_tx_ui;
        RX_UI_ADDR               : o_avmm_readdata <= r_rx_ui;
        CAL_ADDR                 : o_avmm_readdata <= r_calibrate;
        TX_ERR_ADDR              : o_avmm_readdata <= r_tx_error;
        RX_ERR_ADDR              : o_avmm_readdata <= r_rx_error;
        TS_FORMAT_ADDR           : o_avmm_readdata <= r_ts_format;
        TPISO_ADDR               : o_avmm_readdata <= r_tpiso;
        RSIPO_ADDR               : o_avmm_readdata <= r_rsipo;
        RXALIGH_OFST_ADDR        : o_avmm_readdata <= r_rxalign_offset;
        VL_OFFSET_RLD_ADDR       : o_avmm_readdata <= {31'h0, vl_offset_need_reload};
        VL_OFFSET_DATA_ADDR +  0 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 0][23:0]};
        VL_OFFSET_DATA_ADDR +  1 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 0][35:24]};
        VL_OFFSET_DATA_ADDR +  2 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 1][23:0]};
        VL_OFFSET_DATA_ADDR +  3 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 1][35:24]};
        VL_OFFSET_DATA_ADDR +  4 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 2][23:0]};
        VL_OFFSET_DATA_ADDR +  5 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 2][35:24]};
        VL_OFFSET_DATA_ADDR +  6 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 3][23:0]};
        VL_OFFSET_DATA_ADDR +  7 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 3][35:24]};
        VL_OFFSET_DATA_ADDR +  8 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 4][23:0]};
        VL_OFFSET_DATA_ADDR +  9 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 4][35:24]};
        VL_OFFSET_DATA_ADDR + 10 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 5][23:0]};
        VL_OFFSET_DATA_ADDR + 11 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 5][35:24]};
        VL_OFFSET_DATA_ADDR + 12 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 6][23:0]};
        VL_OFFSET_DATA_ADDR + 13 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 6][35:24]};
        VL_OFFSET_DATA_ADDR + 14 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 7][23:0]};
        VL_OFFSET_DATA_ADDR + 15 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 7][35:24]};
        VL_OFFSET_DATA_ADDR + 16 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 8][23:0]};
        VL_OFFSET_DATA_ADDR + 17 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 8][35:24]};
        VL_OFFSET_DATA_ADDR + 18 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[ 9][23:0]};
        VL_OFFSET_DATA_ADDR + 19 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[ 9][35:24]};
        VL_OFFSET_DATA_ADDR + 20 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[10][23:0]};
        VL_OFFSET_DATA_ADDR + 21 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[10][35:24]};
        VL_OFFSET_DATA_ADDR + 22 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[11][23:0]};
        VL_OFFSET_DATA_ADDR + 23 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[11][35:24]};
        VL_OFFSET_DATA_ADDR + 24 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[12][23:0]};
        VL_OFFSET_DATA_ADDR + 25 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[12][35:24]};
        VL_OFFSET_DATA_ADDR + 26 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[13][23:0]};
        VL_OFFSET_DATA_ADDR + 27 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[13][35:24]};
        VL_OFFSET_DATA_ADDR + 28 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[14][23:0]};
        VL_OFFSET_DATA_ADDR + 29 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[14][35:24]};
        VL_OFFSET_DATA_ADDR + 30 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[15][23:0]};
        VL_OFFSET_DATA_ADDR + 31 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[15][35:24]};
        VL_OFFSET_DATA_ADDR + 32 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[16][23:0]};
        VL_OFFSET_DATA_ADDR + 33 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[16][35:24]};
        VL_OFFSET_DATA_ADDR + 34 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[17][23:0]};
        VL_OFFSET_DATA_ADDR + 35 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[17][35:24]};
        VL_OFFSET_DATA_ADDR + 36 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[18][23:0]};
        VL_OFFSET_DATA_ADDR + 37 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[18][35:24]};
        VL_OFFSET_DATA_ADDR + 38 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 6'h0,  i_vl_offset_data[19][23:0]};
        VL_OFFSET_DATA_ADDR + 39 : o_avmm_readdata <= {vl_offset_data_valid, vl_offset_need_reload, 18'h0, i_vl_offset_data[19][35:24]};
        VL_OFFSET_ADDR +  0      : o_avmm_readdata <= {25'h0, o_vl_offset[ 0][ 6:0]};
        VL_OFFSET_ADDR +  1      : o_avmm_readdata <=         o_vl_offset[ 0][38:7];
        VL_OFFSET_ADDR +  2      : o_avmm_readdata <= {25'h0, o_vl_offset[ 1][ 6:0]};
        VL_OFFSET_ADDR +  3      : o_avmm_readdata <=         o_vl_offset[ 1][38:7];
        VL_OFFSET_ADDR +  4      : o_avmm_readdata <= {25'h0, o_vl_offset[ 2][ 6:0]};
        VL_OFFSET_ADDR +  5      : o_avmm_readdata <=         o_vl_offset[ 2][38:7];
        VL_OFFSET_ADDR +  6      : o_avmm_readdata <= {25'h0, o_vl_offset[ 3][ 6:0]};
        VL_OFFSET_ADDR +  7      : o_avmm_readdata <=         o_vl_offset[ 3][38:7];
        VL_OFFSET_ADDR +  8      : o_avmm_readdata <= {25'h0, o_vl_offset[ 4][ 6:0]};
        VL_OFFSET_ADDR +  9      : o_avmm_readdata <=         o_vl_offset[ 4][38:7];
        VL_OFFSET_ADDR + 10      : o_avmm_readdata <= {25'h0, o_vl_offset[ 5][ 6:0]};
        VL_OFFSET_ADDR + 11      : o_avmm_readdata <=         o_vl_offset[ 5][38:7];
        VL_OFFSET_ADDR + 12      : o_avmm_readdata <= {25'h0, o_vl_offset[ 6][ 6:0]};
        VL_OFFSET_ADDR + 13      : o_avmm_readdata <=         o_vl_offset[ 6][38:7];
        VL_OFFSET_ADDR + 14      : o_avmm_readdata <= {25'h0, o_vl_offset[ 7][ 6:0]};
        VL_OFFSET_ADDR + 15      : o_avmm_readdata <=         o_vl_offset[ 7][38:7];
        VL_OFFSET_ADDR + 16      : o_avmm_readdata <= {25'h0, o_vl_offset[ 8][ 6:0]};
        VL_OFFSET_ADDR + 17      : o_avmm_readdata <=         o_vl_offset[ 8][38:7];
        VL_OFFSET_ADDR + 18      : o_avmm_readdata <= {25'h0, o_vl_offset[ 9][ 6:0]};
        VL_OFFSET_ADDR + 19      : o_avmm_readdata <=         o_vl_offset[ 9][38:7];
        VL_OFFSET_ADDR + 20      : o_avmm_readdata <= {25'h0, o_vl_offset[10][ 6:0]};
        VL_OFFSET_ADDR + 21      : o_avmm_readdata <=         o_vl_offset[10][38:7];
        VL_OFFSET_ADDR + 22      : o_avmm_readdata <= {25'h0, o_vl_offset[11][ 6:0]};
        VL_OFFSET_ADDR + 23      : o_avmm_readdata <=         o_vl_offset[11][38:7];
        VL_OFFSET_ADDR + 24      : o_avmm_readdata <= {25'h0, o_vl_offset[12][ 6:0]};
        VL_OFFSET_ADDR + 25      : o_avmm_readdata <=         o_vl_offset[12][38:7];
        VL_OFFSET_ADDR + 26      : o_avmm_readdata <= {25'h0, o_vl_offset[13][ 6:0]};
        VL_OFFSET_ADDR + 27      : o_avmm_readdata <=         o_vl_offset[13][38:7];
        VL_OFFSET_ADDR + 28      : o_avmm_readdata <= {25'h0, o_vl_offset[14][ 6:0]};
        VL_OFFSET_ADDR + 29      : o_avmm_readdata <=         o_vl_offset[14][38:7];
        VL_OFFSET_ADDR + 30      : o_avmm_readdata <= {25'h0, o_vl_offset[15][ 6:0]};
        VL_OFFSET_ADDR + 31      : o_avmm_readdata <=         o_vl_offset[15][38:7];
        VL_OFFSET_ADDR + 32      : o_avmm_readdata <= {25'h0, o_vl_offset[16][ 6:0]};
        VL_OFFSET_ADDR + 33      : o_avmm_readdata <=         o_vl_offset[16][38:7];
        VL_OFFSET_ADDR + 34      : o_avmm_readdata <= {25'h0, o_vl_offset[17][ 6:0]};
        VL_OFFSET_ADDR + 35      : o_avmm_readdata <=         o_vl_offset[17][38:7];
        VL_OFFSET_ADDR + 36      : o_avmm_readdata <= {25'h0, o_vl_offset[18][ 6:0]};
        VL_OFFSET_ADDR + 37      : o_avmm_readdata <=         o_vl_offset[18][38:7];
        VL_OFFSET_ADDR + 38      : o_avmm_readdata <= {25'h0, o_vl_offset[19][ 6:0]};
        VL_OFFSET_ADDR + 39      : o_avmm_readdata <=         o_vl_offset[19][38:7];
        TAM_SNAPSHOT_ADDR        : o_avmm_readdata <= {31'h0,r_tam_snapshot};
        TX_TAM_L_ADDR            : o_avmm_readdata <= r_tx_tam_l;
        TX_TAM_H_ADDR            : o_avmm_readdata <= {16'h0,r_tx_tam_h};
        TX_TAM_COUNT_ADDR        : o_avmm_readdata <= {16'h0,r_tx_tam_count};
        RX_TAM_L_ADDR            : o_avmm_readdata <= r_rx_tam_l;
        RX_TAM_H_ADDR            : o_avmm_readdata <= {16'h0,r_rx_tam_h};
        RX_TAM_COUNT_ADDR        : o_avmm_readdata <= {16'h0,r_rx_tam_count};
        TX_REF_LANE_ADDR         : o_avmm_readdata <= {29'h0,o_ptp_tx_ref_lane};
        RX_REF_LANE_ADDR         : o_avmm_readdata <= {29'h0,o_ptp_rx_ref_lane};
        TX_USER_CFG_ADDR     	 : o_avmm_readdata <= {31'h0,o_ptp_tx_user_cfg_done};
        RX_USER_CFG_ADDR     	 : o_avmm_readdata <= {31'h0,o_ptp_rx_user_cfg_done};
        PTP_STATUS_ADDR      	 : o_avmm_readdata <= {28'h0,ptp_rx_ptp_ready,ptp_tx_ptp_ready,ptp_rx_ptp_offset_data_valid,ptp_tx_ptp_offset_data_valid};
        TX_CONST_DELAY_ADDR  	 : o_avmm_readdata <= i_ptp_tx_lane_calc_data_constdelay;
        RX_CONST_DELAY_ADDR  	 : o_avmm_readdata <= i_ptp_rx_lane_calc_data_constdelay;
        TX_L0_OFFSET_ADDR    	 : o_avmm_readdata <= i_ptp_tx_lane_calc_data_offset[0];
        RX_L0_OFFSET_ADDR    	 : o_avmm_readdata <= i_ptp_rx_lane_calc_data_offset[0];
        TX_L0_TIME_ADDR      	 : o_avmm_readdata <= {4'h0,i_ptp_tx_lane_calc_data_time[0]};
        RX_L0_TIME_ADDR      	 : o_avmm_readdata <= {4'h0,i_ptp_rx_lane_calc_data_time[0]};
        TX_L0_WIRE_DLY_ADDR  	 : o_avmm_readdata <= {12'h0,i_ptp_tx_lane_calc_data_wiredelay[0]};
        RX_L0_WIRE_DLY_ADDR  	 : o_avmm_readdata <= {12'h0,i_ptp_rx_lane_calc_data_wiredelay[0]};
        TX_L1_OFFSET_ADDR    	 : o_avmm_readdata <= i_ptp_tx_lane_calc_data_offset[1];
        RX_L1_OFFSET_ADDR    	 : o_avmm_readdata <= i_ptp_rx_lane_calc_data_offset[1];
        TX_L1_TIME_ADDR      	 : o_avmm_readdata <= {4'h0,i_ptp_tx_lane_calc_data_time[1]};
        RX_L1_TIME_ADDR      	 : o_avmm_readdata <= {4'h0,i_ptp_rx_lane_calc_data_time[1]};
        TX_L1_WIRE_DLY_ADDR  	 : o_avmm_readdata <= {12'h0,i_ptp_tx_lane_calc_data_wiredelay[1]};
        RX_L1_WIRE_DLY_ADDR  	 : o_avmm_readdata <= {12'h0,i_ptp_rx_lane_calc_data_wiredelay[1]};
        TX_L2_OFFSET_ADDR    	 : o_avmm_readdata <= i_ptp_tx_lane_calc_data_offset[2];
        RX_L2_OFFSET_ADDR    	 : o_avmm_readdata <= i_ptp_rx_lane_calc_data_offset[2];
        TX_L2_TIME_ADDR      	 : o_avmm_readdata <= {4'h0,i_ptp_tx_lane_calc_data_time[2]};
        RX_L2_TIME_ADDR      	 : o_avmm_readdata <= {4'h0,i_ptp_rx_lane_calc_data_time[2]};
        TX_L2_WIRE_DLY_ADDR   	 : o_avmm_readdata <= {12'h0,i_ptp_tx_lane_calc_data_wiredelay[2]};
        RX_L2_WIRE_DLY_ADDR  	 : o_avmm_readdata <= {12'h0,i_ptp_rx_lane_calc_data_wiredelay[2]};
        TX_L3_OFFSET_ADDR    	 : o_avmm_readdata <= i_ptp_tx_lane_calc_data_offset[3];
        RX_L3_OFFSET_ADDR    	 : o_avmm_readdata <= i_ptp_rx_lane_calc_data_offset[3];
        TX_L3_TIME_ADDR          : o_avmm_readdata <= {4'h0,i_ptp_tx_lane_calc_data_time[3]};
        RX_L3_TIME_ADDR      	 : o_avmm_readdata <= {4'h0,i_ptp_rx_lane_calc_data_time[3]};
        TX_L3_WIRE_DLY_ADDR  	 : o_avmm_readdata <= {12'h0,i_ptp_tx_lane_calc_data_wiredelay[3]};
        RX_L3_WIRE_DLY_ADDR  	 : o_avmm_readdata <= {12'h0,i_ptp_rx_lane_calc_data_wiredelay[3]};
        default: o_avmm_readdata <= 32'h0;
      endcase
    end
  end
end

endmodule
