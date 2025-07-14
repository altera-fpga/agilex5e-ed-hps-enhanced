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
module alt_ehipc3_fm_ml_ptp_convert_commands #(
    parameter LANES    = 4 // Not fully supported
) (
    // Configuration
    input  logic                    i_enable_rsfec,
    input  logic                    i_tx_preamble_pass,

    // System Intetrface
    input  logic                    i_clk,
    input  logic                    i_rst_n,

    input  logic                    i_pcs_fully_aligned,

    // 1-Step TS Interface
    input  logic                    i_ptp_ins_ets,
    input  logic                    i_ptp_ins_cf,
    input  logic                    i_ptp_zero_csum,
    input  logic                    i_ptp_update_eb,
    input  logic                    i_ptp_ts_format,
    input  logic                    i_ptp_asym,
    input  logic            [15:0]  i_ptp_ts_offset,
    input  logic            [15:0]  i_ptp_cf_offset,
    input  logic            [15:0]  i_ptp_csum_offset,
    input  logic            [15:0]  i_ptp_eb_offset,
    input  logic            [95:0]  i_ptp_tx_its,

    // 2-Step TS Interface
    input  logic                    i_ptp_ts_req,
    input  logic            [7:0]   i_ptp_fp,

    // TX Framing interface
    input  logic                    i_tx_early_valid,
    input  logic                    i_tx_valid,
    input  logic [LANES-1:0]        i_tx_inframe,
    input  logic [LANES-1:0]        i_tx_skip_crc,

    // TAM Request
    input  logic [LANES-1:0]        i_req_tx_tam_load,
    input  logic [LANES-1:0][95:0]  i_tx_tam,

    input  logic [LANES-1:0]        i_req_rx_tam_load,
    input  logic [LANES-1:0][95:0]  i_rx_tam,

    // UI Request
    input  logic                    i_req_tx_ui_load,
    input  logic            [31:0]  i_tx_ui,

    input  logic                    i_req_rx_ui_load,
    input  logic            [31:0]  i_rx_ui,

    // VL Offset
    input  logic [19:0]             i_vl_offset_load,
    input  logic [19:0][38:0]       i_vl_offset,

    // EHIP TS Interface
    output logic [LANES-1:0][2:0]   o_ptp_ins_type,
    output logic [LANES-1:0][2:0]   o_ptp_byte_offset,
    output logic            [95:0]  o_ptp_ts,
    output logic            [7:0]   o_ptp_tx_fp,

    // PTP Status
    output logic                    o_tx_ptp_ready,
    output logic                    o_rx_ptp_ready
  );

    // Constants to limit TAM load window to avoid loading TAM to incorrect AM
    localparam PERIOD_TX_FEC          = 17'd81920;    // (STANDARD_100G_AM_PERIOD+5)
    localparam PERIOD_TX_NO_FEC       = PERIOD_TX_FEC;
    localparam PERIOD_RX_FEC          = PERIOD_TX_FEC;
    localparam PERIOD_RX_NO_FEC       = PERIOD_TX_FEC;
    localparam SIM_PERIOD_TX_FEC      = 11'd1280;     // (SIM_ONLY_100G_FEC_AM_PERIOD+5)
    localparam SIM_PERIOD_TX_NO_FEC   = 9'd320;       // (SIM_ONLY_AM_PERIOD+5)
    localparam SIM_PERIOD_RX_FEC      = SIM_PERIOD_TX_FEC;
    localparam SIM_PERIOD_RX_NO_FEC   = SIM_PERIOD_TX_FEC;

    localparam DLY_TX_AM_PTP_TO_SOFT  = 36+4; // Obtained in simulation: AM input to hard TX PTP and to soft TX PTP (tx_sclk_return)
                                              // added extra 4 clock cycles because of additional pipeline in rx deskew block
    localparam DLY_RX_AM_PTP_TO_SOFT  = 8+4; // Obtained in simulation: AM input to hard RX PTP and to soft RX PTP (rx_am_detect)
                                              // added extra 4 clock cycles because of additional pipeline in rx deskew block
    localparam DLY_TX_PULSE_CAPTURE   = 3+1+2; // Obtained from RTL: Two 3 cycles synchronizer, one metastability uncertainty, two cylce delay for load request output
    localparam DLY_RX_PULSE_CAPTURE   = 3+1+1; // Obtained from RTL: Two 3 cycles synchronizer, one metastability uncertainty, one cylce delay for load request output
    localparam DLY_CALC_TAM           = 12; // Obtained from RTL: Number of pipelines to calculate TAM
    localparam DLY_CONVERT_CMD        = 6+1; // Obtained from RTL: Number of delay to generate ins_type, one cycle pipe from sip to hip for timing
    localparam DLY_LOAD_TAM_PATH      = 9; // Obtained in simulation: Max delay from soft PTP output to hard MAC
    localparam DLY_TX_MAC_TO_PTP      = 3; // Obtained in simulation: From hard TX MAC input to hard TX PTP
    localparam DLY_RX_MAC_TO_PTP      = 4; // Obtained in simulation: From hard RX MAC input to hard RX PTP
    localparam DLY_EXTRA_MARGIN       = 13; // Extra safety guardband to avoid loading with older TAM
    localparam DLY_TX_TOTAL           = DLY_TX_AM_PTP_TO_SOFT + DLY_TX_PULSE_CAPTURE + DLY_CALC_TAM + DLY_CONVERT_CMD + DLY_LOAD_TAM_PATH + DLY_TX_MAC_TO_PTP + DLY_EXTRA_MARGIN;
    localparam DLY_RX_TOTAL           = DLY_RX_AM_PTP_TO_SOFT + DLY_RX_PULSE_CAPTURE + DLY_CALC_TAM + DLY_CONVERT_CMD + DLY_LOAD_TAM_PATH + DLY_RX_MAC_TO_PTP + DLY_EXTRA_MARGIN;

    localparam LIMIT_TX_FEC           = PERIOD_TX_FEC - DLY_TX_TOTAL;
    localparam LIMIT_TX_NO_FEC        = PERIOD_TX_NO_FEC - DLY_TX_TOTAL;
    localparam LIMIT_RX_FEC           = PERIOD_RX_FEC - DLY_RX_TOTAL;
    localparam LIMIT_RX_NO_FEC        = PERIOD_RX_NO_FEC - DLY_RX_TOTAL;
    localparam SIM_LIMIT_TX_FEC       = SIM_PERIOD_TX_FEC - DLY_TX_TOTAL;
    localparam SIM_LIMIT_TX_NO_FEC    = SIM_PERIOD_TX_NO_FEC - DLY_TX_TOTAL;
    localparam SIM_LIMIT_RX_FEC       = SIM_PERIOD_RX_FEC - DLY_RX_TOTAL;
    localparam SIM_LIMIT_RX_NO_FEC    = SIM_PERIOD_RX_NO_FEC - DLY_RX_TOTAL;

    // PTP loading state
    localparam LOAD_TYPE_NONE         = 3'b000;
    localparam LOAD_TYPE_TX_UI        = 3'b001;
    localparam LOAD_TYPE_RX_UI        = 3'b010;
    localparam LOAD_TYPE_TX_TAM       = 3'b101;
    localparam LOAD_TYPE_RX_TAM       = 3'b110;
    localparam LOAD_TYPE_VL_OFFSET    = 3'b111;

    genvar          i;
    integer         l;

    // TAM load request control and window control
    logic [LANES-1:0]       r_req_tx_tam_load;
    logic [LANES-1:0]       r_req_rx_tam_load;
    logic                   r_req_tx_ui_load;
    logic                   r_req_rx_ui_load;

    logic [LANES-1:0]       r_req_tx_tam_load_r;
    logic [LANES-1:0]       r_req_rx_tam_load_r;
    logic                   r_req_tx_ui_load_r;
    logic                   r_req_rx_ui_load_r;

    logic [LANES-1:0]       req_tx_tam_load_rise;
    logic [LANES-1:0]       req_rx_tam_load_rise;
    logic                   req_tx_ui_load_rise;
    logic                   req_rx_ui_load_rise;

    logic            [31:0] limit_tx;
    logic            [31:0] limit_rx;
    logic [LANES-1:0][31:0] remain_cycle_tx;
    logic [LANES-1:0][31:0] remain_cycle_rx;
    logic [LANES-1:0][31:0] remain_cycle_tx_r;
    logic [LANES-1:0][31:0] remain_cycle_rx_r;
    logic [LANES-1:0]       tx_load_tam_enable;
    logic [LANES-1:0]       rx_load_tam_enable;
    logic [LANES-1:0]       remain_cycle_tx_msb_is_zero;
    logic [LANES-1:0]       remain_cycle_rx_msb_is_zero;
    logic [LANES-1:0]       remain_cycle_tx_is_zero;
    logic [LANES-1:0]       remain_cycle_rx_is_zero;

    logic [LANES-1:0]       req_tx_tam_load_clear;
    logic [LANES-1:0]       req_rx_tam_load_clear;
    logic                   req_tx_ui_load_clear;
    logic                   req_rx_ui_load_clear;

    logic [LANES-1:0]       tx_tam_load_selected;
    logic [LANES-1:0]       rx_tam_load_selected;
    logic [LANES-1:0]       tx_tam_load_complete;
    logic [LANES-1:0]       rx_tam_load_complete;
    logic                   tx_ui_load_complete;
    logic                   rx_ui_load_complete;

    logic [LANES-1:0]       req_tx_tam;
    logic [LANES-1:0]       req_rx_tam;
    logic                   req_tx_ui;
    logic                   req_rx_ui;

    // VL offset load request control
    logic [19:0]            r_req_vl_offset_load;
    logic [19:0]            r_req_vl_offset_load_r;
    logic [19:0]            req_vl_offset_load_rise;
    logic [19:0]            req_vl_offset_load_clear;
    logic [19:0]            vl_offset_load_complete;
    logic [19:0]            req_vl_offset;

    // PTP ready status
    logic                   tx_ui_load_done;
    logic                   rx_ui_load_done;
    logic [LANES-1:0]       tx_tam_load_done;
    logic [LANES-1:0]       tx_tam_load_done_r;
    logic [LANES-1:0]       tx_tam_load_done_p;
    logic [LANES-1:0]       rx_tam_load_done;
    logic [LANES-1:0]       rx_tam_load_done_r;
    logic [LANES-1:0]       rx_tam_load_done_p;
    logic [19:0]            vl_offset_load_done;

    // PTP commands conversion
    logic [LANES  :0]       tx_sop_p0;
    logic [LANES  :0]       tx_sop_p1;
    logic [LANES-1:0]       tx_sop_p2;
    logic [LANES-1:0]       tx_sop_p3;
    logic [LANES-1:0]       tx_eop_p0;
    logic [LANES-1:0]       tx_eop_p1;
    logic [LANES-1:0]       tx_inframe_p1;
    logic [LANES-1:0][8:0]  byte_count_lsb_p1;
    logic [LANES-1:0][7:0]  byte_count_lsb_p2;
    logic [LANES-1:0][8:0]  byte_count_msb_p2;
    logic [LANES-1:0][15:0] byte_count_p2;
// ---------------------------------------------------------------------------------------------------------------------------------
// 01/Oct/2018 : slim35 : 595303 : ts not embedded in random packet.
// ---------------------------------------------------------------------------------------------------------------------------------
    logic		    byte_count_lsb_p1_ln0b8_4ln1_r;
    logic		    byte_count_lsb_p1_ln0b8_4ln2_r;
    logic		    byte_count_lsb_p1_ln0b8_4ln3_r;
// ---------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------------------------------
// 17/Oct/2018 : slim35 : 596644 : checksum 0 not replaced at random packets.
// ---------------------------------------------------------------------------------------------------------------------------------
// 16/Oct/2018 : slim35 : 596638 : ACDS 19.1 - eb calculations mismatch in random number of packets.
// ---------------------------------------------------------------------------------------------------------------------------------
//    logic                   tr_cmd_p1;
//    logic                   ts_cmd_p1;
//    logic                   cf_cmd_p1;
//    logic                   cs_cmd_p1;
//    logic                   eb_cmd_p1;
//    logic                   tf_cmd_p1;
//
//    logic                   tr_cmd_p2;
//    logic                   ts_cmd_p2;
//    logic                   cf_cmd_p2;
//    logic                   cs_cmd_p2;
//    logic                   eb_cmd_p2;
//    logic                   tf_cmd_p2;
//
//    logic                   tr_cmd_p3;
//    logic                   ts_cmd_p3;
//    logic                   cf_cmd_p3;
//    logic                   cs_cmd_p3;
//    logic                   eb_cmd_p3;
//    logic                   tf_cmd_p3;

    logic [(LANES-1):0]		perln_tr_cmd_p1;
    logic [(LANES-1):0]		perln_tr_cmd_p2;
    logic [(LANES-1):0]		perln_tr_cmd_p3;

    logic [(LANES-1):0]		perln_ts_cmd_p1;
    logic [(LANES-1):0]		perln_ts_cmd_p2;
    logic [(LANES-1):0]		perln_ts_cmd_p3;
    logic [(LANES-1):0][15:0]	perln_ts_offset_p1;
    logic [(LANES-1):0][15:0]	perln_ts_offset_p2;
    logic [(LANES-1):0][15:0]	perln_ts_offset_p3;

    logic [(LANES-1):0]		perln_cf_cmd_p1;
    logic [(LANES-1):0]		perln_cf_cmd_p2;
    logic [(LANES-1):0]		perln_cf_cmd_p3;
    logic [(LANES-1):0][15:0]	perln_cf_offset_p1;
    logic [(LANES-1):0][15:0]	perln_cf_offset_p2;
    logic [(LANES-1):0][15:0]	perln_cf_offset_p3;

    logic [(LANES-1):0]		perln_cs_cmd_p1;
    logic [(LANES-1):0]		perln_cs_cmd_p2;
    logic [(LANES-1):0]		perln_cs_cmd_p3;
    logic [(LANES-1):0][15:0]	perln_cs_offset_p1;
    logic [(LANES-1):0][15:0]	perln_cs_offset_p2;
    logic [(LANES-1):0][15:0]	perln_cs_offset_p3;

    logic [(LANES-1):0]		perln_eb_cmd_p1;
    logic [(LANES-1):0]		perln_eb_cmd_p2;
    logic [(LANES-1):0]		perln_eb_cmd_p3;
    logic [(LANES-1):0][15:0]	perln_eb_offset_p1;
    logic [(LANES-1):0][15:0]	perln_eb_offset_p2;
    logic [(LANES-1):0][15:0]	perln_eb_offset_p3;

    logic [(LANES-1):0]		perln_tf_cmd_p1;
    logic [(LANES-1):0]		perln_tf_cmd_p2;
    logic [(LANES-1):0]		perln_tf_cmd_p3;

//    logic            [15:0] ts_offset_p1;
//    logic            [15:0] cf_offset_p1;
//    logic            [15:0] cs_offset_p1;
//    logic            [15:0] eb_offset_p1;
//
//    logic            [15:0] ts_offset_p2;
//    logic            [15:0] cf_offset_p2;
//    logic            [15:0] cs_offset_p2;
//    logic            [15:0] eb_offset_p2;
//
//    logic            [15:0] ts_offset_p3;
//    logic            [15:0] cf_offset_p3;
//    logic            [15:0] cs_offset_p3;
//    logic            [15:0] eb_offset_p3;
// ---------------------------------------------------------------------------------------------------------------------------------

    logic [LANES-1:0][3:0]  is_ts_offset_p3;
    logic [LANES-1:0][3:0]  is_cf_offset_p3;
    logic [LANES-1:0][3:0]  is_cs_offset_p3;
    logic [LANES-1:0][3:0]  is_eb_offset_p3;

    logic [LANES-1:0][2:0]  cmd_ins_type_p4;
    logic [LANES-1:0][2:0]  cmd_ins_type_p5;

    logic [LANES-1:0][2:0]  cmd_byte_offset_p4;
    logic [LANES-1:0][2:0]  cmd_byte_offset_p5;

    // Early warning detection
    logic                   ptp_cmd_p0;
    logic                   early_warning_p1;
    logic                   early_warning_p2;
    logic                   early_warning_p3;
    logic                   early_warning_p4;
    logic                   early_warning_all_p4;

    // PTP loading
    logic                   loading_mux_select_dup0 /* synthesis preserve */;
    logic                   loading_mux_select_dup1 /* synthesis preserve */;
    logic                   loading_req_hold_p0;
    logic                   loading_req_hold_p1;
    logic                   loading_req_hold_p2;
    logic                   loading_req_hold_p3;
    logic                   loading_req_hold;
    logic                   loading_complete;
    logic                   loading_req_update_p0;
    logic                   loading_req_update_p1;
    logic                   loading_req_update_p2;
    logic                   loading_req_update_p3;
    logic                   loading_req_update_p4;
    logic                   loading_req_update;

    logic            [95:0] selected_tam_p4;
    logic            [95:0] selected_tam_p56;
    logic [LANES-1:0][2:0]  load_ins_type_p4;
    logic [LANES-1:0][2:0]  load_ins_type_p56;
    logic [LANES-1:0][2:0]  load_byte_offset_p4;
    logic [LANES-1:0][2:0]  load_byte_offset_p56;
    logic            [2:0]  load_type_p4;
    logic            [2:0]  load_type;

    logic                   req_tx_tam_p2;
    logic                   req_tx_tam_p3;
    logic                   req_tx_tam_p4;
    logic            [1:0]  tx_tam_lane_p2;
    logic            [1:0]  tx_tam_lane_p3;
    logic            [1:0]  tx_tam_lane_p4;
    logic            [1:0]  tx_tam_lane_p56;
    logic            [95:0] tx_tam_p3;
    logic            [95:0] tx_tam_p4;

    logic                   req_rx_tam_p2;
    logic                   req_rx_tam_p3;
    logic                   req_rx_tam_p4;
    logic            [1:0]  rx_tam_lane_p2;
    logic            [1:0]  rx_tam_lane_p3;
    logic            [1:0]  rx_tam_lane_p4;
    logic            [1:0]  rx_tam_lane_p56;
    logic            [95:0] rx_tam_p3;
    logic            [95:0] rx_tam_p4;

    logic                   req_vl_offset_p2a;
    logic                   req_vl_offset_p2b;
    logic                   req_vl_offset_p2c;
    logic                   req_vl_offset_p2d;
    logic                   req_vl_offset_p3;
    logic                   req_vl_offset_p4;
    logic            [4:0]  vl_sel_p2a;
    logic            [4:0]  vl_sel_p2b;
    logic            [4:0]  vl_sel_p2c;
    logic            [4:0]  vl_sel_p2d;
    logic            [4:0]  vl_sel_p3;
    logic            [4:0]  vl_sel_p4;
    logic            [4:0]  vl_sel_p56;
    logic            [38:0] vl_offset_p3a;
    logic            [38:0] vl_offset_p3b;
    logic            [38:0] vl_offset_p3c;
    logic            [38:0] vl_offset_p3d;
    logic            [38:0] vl_offset_p4;

    logic                   req_tam_p4;

    // Fingerprint and ingress timestamp
    logic            [ 7:0] tx_fp_p1;
    logic            [ 7:0] tx_fp_p2;
    logic            [ 7:0] tx_fp_p3;
    logic            [ 7:0] tx_fp_p4;
    logic            [ 7:0] tx_fp_p5;

    logic            [95:0] tx_its_p1;
    logic            [95:0] tx_its_p2;
    logic            [95:0] tx_its_p3;
    logic            [95:0] tx_its_p4;
    logic            [95:0] tx_its_p5;

    // TAM load request control and window control
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            r_req_tx_ui_load <= 0;
            r_req_rx_ui_load <= 0;
            r_req_tx_ui_load_r <= 0;
            r_req_rx_ui_load_r <= 0;
        end
        else begin
            r_req_tx_ui_load <= i_req_tx_ui_load;
            r_req_rx_ui_load <= i_req_rx_ui_load;
            r_req_tx_ui_load_r <= r_req_tx_ui_load;
            r_req_rx_ui_load_r <= r_req_rx_ui_load;
        end
    end

    assign req_tx_ui_load_rise  = !r_req_tx_ui_load_r && r_req_tx_ui_load;
    assign req_rx_ui_load_rise  = !r_req_rx_ui_load_r && r_req_rx_ui_load;

    assign req_tx_ui_load_clear = tx_ui_load_complete;
    assign req_rx_ui_load_clear = rx_ui_load_complete;

    alt_ehipc3_fm_sl_ptp_sticky_register psr_req_tx_ui (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_set_sticky   (req_tx_ui_load_rise),
        .i_clear_sticky (req_tx_ui_load_clear),
        .o_sticky_reg   (req_tx_ui)
    );

    alt_ehipc3_fm_sl_ptp_sticky_register psr_req_rx_ui (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_set_sticky   (req_rx_ui_load_rise),
        .i_clear_sticky (req_rx_ui_load_clear),
        .o_sticky_reg   (req_rx_ui)
    );

    assign tx_ui_load_complete = (load_type == LOAD_TYPE_TX_UI) && (loading_complete);
    assign rx_ui_load_complete = (load_type == LOAD_TYPE_RX_UI) && (loading_complete);

    // PTP ready status
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            tx_ui_load_done <= 1'b0;
            rx_ui_load_done <= 1'b0;
        end
        else begin
            if(tx_ui_load_complete) tx_ui_load_done <= 1'b1;
            if(rx_ui_load_complete) rx_ui_load_done <= 1'b1;
        end
    end

    `ifdef ALTERA_RESERVED_QIS
        assign limit_tx = i_enable_rsfec ? LIMIT_TX_FEC : LIMIT_TX_NO_FEC;
        assign limit_rx = i_enable_rsfec ? LIMIT_RX_FEC : LIMIT_RX_NO_FEC;
    `else
        assign limit_tx = i_enable_rsfec ? SIM_LIMIT_TX_FEC : SIM_LIMIT_TX_NO_FEC;
        assign limit_rx = i_enable_rsfec ? SIM_LIMIT_RX_FEC : SIM_LIMIT_RX_NO_FEC;
    `endif

    generate
        for(i = 0; i < LANES; i++) begin: LANES_LOOP
            always @(posedge i_clk) begin
                if(!i_rst_n) begin
                    r_req_tx_tam_load[i] <= 0;
                    r_req_rx_tam_load[i] <= 0;
                    r_req_tx_tam_load_r[i] <= 0;
                    r_req_rx_tam_load_r[i] <= 0;
                    req_tx_tam_load_rise[i] <= 1'b0;
                    req_rx_tam_load_rise[i] <= 1'b0;
                end
                else begin
                    r_req_tx_tam_load[i] <= i_req_tx_tam_load[i];
                    r_req_rx_tam_load[i] <= i_req_rx_tam_load[i];
                    r_req_tx_tam_load_r[i] <= r_req_tx_tam_load[i];
                    r_req_rx_tam_load_r[i] <= r_req_rx_tam_load[i];
                    req_tx_tam_load_rise[i] <= ~r_req_tx_tam_load_r[i] & r_req_tx_tam_load[i];
                    req_rx_tam_load_rise[i] <= ~r_req_rx_tam_load_r[i] & r_req_rx_tam_load[i];
                end
            end

            always @(posedge i_clk) begin
                if(!i_rst_n) begin
                    remain_cycle_tx_msb_is_zero[i] <= 1'b0;
                    remain_cycle_rx_msb_is_zero[i] <= 1'b0;
                    remain_cycle_tx_is_zero[i] <= 1'b0;
                    remain_cycle_rx_is_zero[i] <= 1'b0;
                end else begin
                    remain_cycle_tx_msb_is_zero[i] <= (remain_cycle_tx[i][31:2] == 30'd0) ? 1'b1 : 1'b0;
                    remain_cycle_rx_msb_is_zero[i] <= (remain_cycle_rx[i][31:2] == 30'd0) ? 1'b1 : 1'b0;
                    remain_cycle_tx_is_zero[i] <= (!req_tx_tam_load_rise[i] && remain_cycle_tx_msb_is_zero[i] && (remain_cycle_tx[i] == 2'd1 || remain_cycle_tx[i] == 2'd0)) ? 1'b1 : 1'b0;
                    remain_cycle_rx_is_zero[i] <= (!req_rx_tam_load_rise[i] && remain_cycle_rx_msb_is_zero[i] && (remain_cycle_rx[i] == 2'd1 || remain_cycle_rx[i] == 2'd0)) ? 1'b1 : 1'b0;
                end
            end

            // Counter to keep track of window allowed to load TAM
            always @(posedge i_clk) begin
                if(!i_rst_n) begin
                    remain_cycle_tx[i] <= 0;
                    remain_cycle_rx[i] <= 0;
                    remain_cycle_tx_r[i] <= 0;
                    remain_cycle_rx_r[i] <= 0;
                    tx_load_tam_enable[i] <= 0;
                    rx_load_tam_enable[i] <= 0;
                end
                else begin
                    if(req_tx_tam_load_rise[i]) begin
                        remain_cycle_tx[i] <= limit_tx;
                    end
                    else if (remain_cycle_tx_is_zero[i]) begin
                        remain_cycle_tx[i] <= 0;
                    end
                    else begin
                        remain_cycle_tx[i] <= remain_cycle_tx[i] - 1'b1;
                    end

                    if(req_rx_tam_load_rise[i]) begin
                        remain_cycle_rx[i] <= limit_rx;
                    end
                    else if(remain_cycle_rx_is_zero[i]) begin
                        remain_cycle_rx[i] <= 0;
                    end
                    else begin
                        remain_cycle_rx[i] <= remain_cycle_rx[i] - 1'b1;
                    end

                    if(req_tx_tam_load_rise[i]) begin
                        remain_cycle_tx_r[i] <= '1;
                        tx_load_tam_enable[i] <= '1;
                    end
                    else begin
                        remain_cycle_tx_r[i] <= remain_cycle_tx[i];
                        tx_load_tam_enable[i] <= |(remain_cycle_tx_r[i]);
                    end

                    if(req_rx_tam_load_rise[i]) begin
                        remain_cycle_rx_r[i] <= '1;
                        rx_load_tam_enable[i] <= '1;
                    end
                    else begin
                        remain_cycle_rx_r[i] <= remain_cycle_rx[i];
                        rx_load_tam_enable[i] <= |(remain_cycle_rx_r[i]);
                    end
                end
            end

            assign req_tx_tam_load_clear[i] = tx_tam_load_complete[i] || !tx_load_tam_enable[i];
            assign req_rx_tam_load_clear[i] = rx_tam_load_complete[i] || !rx_load_tam_enable[i];

            alt_ehipc3_fm_sl_ptp_sticky_register psr_req_tx_tam (
                .i_clk          (i_clk),
                .i_rst_n        (i_rst_n),
                .i_set_sticky   (req_tx_tam_load_rise[i]),
                .i_clear_sticky (req_tx_tam_load_clear[i]),
                .o_sticky_reg   (req_tx_tam[i])
            );

            alt_ehipc3_fm_sl_ptp_sticky_register psr_req_rx_tam (
                .i_clk          (i_clk),
                .i_rst_n        (i_rst_n),
                .i_set_sticky   (req_rx_tam_load_rise[i]),
                .i_clear_sticky (req_rx_tam_load_clear[i]),
                .o_sticky_reg   (req_rx_tam[i])
            );

            assign tx_tam_load_complete[i]  = (tx_tam_load_selected[i]) && (loading_complete);
            assign rx_tam_load_complete[i]  = (rx_tam_load_selected[i]) && (loading_complete);

            always @(posedge i_clk) begin
                if(!i_rst_n) begin
                    tx_tam_load_selected[i] <= 1'b0;
                    rx_tam_load_selected[i] <= 1'b0;
                end
                else begin
                    tx_tam_load_selected[i] <= (load_type == LOAD_TYPE_TX_TAM) && (tx_tam_lane_p56 == i);
                    rx_tam_load_selected[i] <= (load_type == LOAD_TYPE_RX_TAM) && (rx_tam_lane_p56 == i);
                end
            end

            // PTP ready status
            always @(posedge i_clk) begin
                if(!i_rst_n) begin
                    tx_tam_load_done[i]   <= 1'b0;
                    tx_tam_load_done_r[i] <= 1'b0;
                    tx_tam_load_done_p[i] <= 1'b0;
                    rx_tam_load_done[i]   <= 1'b0;
                    rx_tam_load_done_r[i] <= 1'b0;
                    rx_tam_load_done_p[i] <= 1'b0;
                end
                else begin
                    if(tx_tam_load_complete[i]) begin
                        tx_tam_load_done[i]   <= 1'b1;
                        tx_tam_load_done_r[i] <= tx_tam_load_done[i];
                    end

                    tx_tam_load_done_p[i] <= tx_tam_load_done[i];

                    if(!i_pcs_fully_aligned) begin
                        rx_tam_load_done[i]   <= 1'b0;
                        rx_tam_load_done_r[i] <= 1'b0;
                    end
                    else if(rx_tam_load_complete[i]) begin
                        rx_tam_load_done[i]   <= 1'b1;
                        rx_tam_load_done_r[i] <= rx_tam_load_done[i];
                    end

                    rx_tam_load_done_p[i] <= rx_tam_load_done[i];
                end
            end

        end
    endgenerate

    // VL offset load request control
    generate
        for(i = 0; i < 20; i++) begin: VL_OFFSET_LOOP
            always @(posedge i_clk) begin
                if(!i_rst_n) begin
                    r_req_vl_offset_load[i] <= 0;
                    r_req_vl_offset_load_r[i] <= 0;
                end
                else begin
                    r_req_vl_offset_load[i] <= i_vl_offset_load[i];
                    r_req_vl_offset_load_r[i] <= r_req_vl_offset_load[i];
                end
            end

            assign req_vl_offset_load_rise[i]  = !r_req_vl_offset_load_r[i] && r_req_vl_offset_load[i];

            assign req_vl_offset_load_clear[i] = vl_offset_load_complete[i];

            alt_ehipc3_fm_sl_ptp_sticky_register psr_req_vl_offset (
                .i_clk          (i_clk),
                .i_rst_n        (i_rst_n),
                .i_set_sticky   (req_vl_offset_load_rise[i]),
                .i_clear_sticky (req_vl_offset_load_clear[i]),
                .o_sticky_reg   (req_vl_offset[i])
            );

            assign vl_offset_load_complete[i] = (load_type == LOAD_TYPE_VL_OFFSET) && (loading_complete) && (vl_sel_p56 == i);

            // PTP ready status
            always @(posedge i_clk) begin
                if(!i_rst_n) begin
                    vl_offset_load_done[i] <= 1'b0;
                end
                else begin
                    if(!i_pcs_fully_aligned) begin
                        vl_offset_load_done[i] <= 1'b0;
                    end
                    else if(vl_offset_load_complete[i]) begin
                        vl_offset_load_done[i] <= 1'b1;
                    end
                end
            end
        end
    endgenerate

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            o_tx_ptp_ready <= 1'b0;
            o_rx_ptp_ready <= 1'b0;
        end
        else begin
            o_tx_ptp_ready <= tx_ui_load_done && &tx_tam_load_done_r;
            o_rx_ptp_ready <= rx_ui_load_done && &rx_tam_load_done_r && &vl_offset_load_done && i_pcs_fully_aligned;
        end
    end

    assign tx_sop_p0 = {tx_sop_p1[0], i_tx_inframe & ~{tx_inframe_p1[0], i_tx_inframe[LANES-1:1]}};
    assign tx_eop_p0 = ~i_tx_inframe & {tx_inframe_p1[0], i_tx_inframe[LANES-1:1]};

    // PTP commands conversion
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            tx_sop_p1           <= '0;
            tx_sop_p2           <= '0;
            tx_sop_p3           <= '0;
            tx_eop_p1           <= '0;
            tx_inframe_p1       <= '0;
            byte_count_lsb_p1   <= '0;
            byte_count_lsb_p2   <= '0;
            byte_count_msb_p2   <= '0;
            byte_count_lsb_p1_ln0b8_4ln1_r <= 1'b0;
            byte_count_lsb_p1_ln0b8_4ln2_r <= 1'b0;
            byte_count_lsb_p1_ln0b8_4ln3_r <= 1'b0;
        end
        else begin
            if(i_tx_valid) begin
                tx_sop_p1 <= tx_sop_p0;
                tx_sop_p2 <= tx_sop_p1[LANES-1:0];
                tx_sop_p3 <= tx_sop_p2;

                tx_eop_p1 <= tx_eop_p0;

                tx_inframe_p1 <= i_tx_inframe;

                byte_count_lsb_p1[0] <= !i_tx_preamble_pass ?   tx_sop_p0[0]    ? 9'd 0 :
                                                                tx_sop_p0[1]    ? 9'd 8 :
                                                                tx_sop_p0[2]    ? 9'd16 :
                                                                tx_sop_p0[3]    ? 9'd24 :
                                                                                  byte_count_lsb_p1[0][7:0] + 8'd32 :
                                       /*i_tx_preamble_pass*/ |(tx_sop_p0[1:0]) ? 9'd 0 :
                                                              |(tx_sop_p0[2:1]) ? 9'd 8 :
                                                              |(tx_sop_p0[3:2]) ? 9'd16 :
                                                              |(tx_sop_p0[4:3]) ? 9'd24 :
                                                                                  byte_count_lsb_p1[0][7:0] + 8'd32;

                byte_count_lsb_p1[1] <= !i_tx_preamble_pass ?   tx_sop_p0[1]    ? 9'd 0 :
                                                                tx_sop_p0[2]    ? 9'd 8 :
                                                                tx_sop_p0[3]    ? 9'd16 :
                                                                                  byte_count_lsb_p1[0][7:0] + 8'd24 :
                                       /*i_tx_preamble_pass*/ |(tx_sop_p0[2:1]) ? 9'd 0 :
                                                              |(tx_sop_p0[3:2]) ? 9'd 8 :
                                                              |(tx_sop_p0[4:3]) ? 9'd16 :
                                                                                  byte_count_lsb_p1[0][7:0] + 8'd24;

                byte_count_lsb_p1[2] <= !i_tx_preamble_pass ?   tx_sop_p0[2]    ? 9'd 0 :
                                                                tx_sop_p0[3]    ? 9'd 8 :
                                                                                  byte_count_lsb_p1[0][7:0] + 8'd16 :
                                       /*i_tx_preamble_pass*/ |(tx_sop_p0[3:2]) ? 9'd 0 :
                                                              |(tx_sop_p0[4:3]) ? 9'd 8 :
                                                                                  byte_count_lsb_p1[0][7:0] + 8'd16;

                byte_count_lsb_p1[3] <= !i_tx_preamble_pass ?   tx_sop_p0[3]    ? 9'd 0 :
                                                                                  byte_count_lsb_p1[0][7:0] + 8'd8 :
                                       /*i_tx_preamble_pass*/ |(tx_sop_p0[4:3]) ? 9'd 0 :
                                                                                  byte_count_lsb_p1[0][7:0] + 8'd8;

                byte_count_lsb_p2[0] <= byte_count_lsb_p1[0][7:0];
                byte_count_lsb_p2[1] <= byte_count_lsb_p1[1][7:0];
                byte_count_lsb_p2[2] <= byte_count_lsb_p1[2][7:0];
                byte_count_lsb_p2[3] <= byte_count_lsb_p1[3][7:0];

		// ---------------------------------------------------------------------------------------------------------------------------------
		// 01/Oct/2018 : slim35 : 595303 : ts not embedded in random packet.
		// ---------------------------------------------------------------------------------------------------------------------------------
		// When lowest lane from P1 rollover and upper lane in P1 is still not rollover yet, increment is needed on P2 MSB for all lanes.
		// However, the increment should only happen the on the 2nd clock of P2 because 1st clock of P2 should remains as P1.
		// Delay byte_count_lsb_p1[0][8] for 1 clock and only valid if the lane itself is not planning to rollover yet.
		// ---------------------------------------------------------------------------------------------------------------------------------
                byte_count_lsb_p1_ln0b8_4ln1_r <= byte_count_lsb_p1[0][8] && !byte_count_lsb_p1[1][8];
                byte_count_lsb_p1_ln0b8_4ln2_r <= byte_count_lsb_p1[0][8] && !byte_count_lsb_p1[2][8];
                byte_count_lsb_p1_ln0b8_4ln3_r <= byte_count_lsb_p1[0][8] && !byte_count_lsb_p1[3][8];
		// ---------------------------------------------------------------------------------------------------------------------------------

                byte_count_msb_p2[0] <= !i_tx_preamble_pass ?  tx_sop_p1[0]     ? 9'd 0 :
                                                               tx_sop_p1[1]     ? 9'd 0 :
                                                               tx_sop_p1[2]     ? 9'd 0 :
                                                               tx_sop_p1[3]     ? 9'd 0 :
                                                              |(tx_sop_p2[3:0]) ? 9'd 0 :
                                                                                  byte_count_msb_p2[0][7:0] + byte_count_lsb_p1[0][8] :
                                       /*i_tx_preamble_pass*/ |(tx_sop_p1[1:0]) ? 9'd 0 :
                                                              |(tx_sop_p1[2:1]) ? 9'd 0 :
                                                              |(tx_sop_p1[3:2]) ? 9'd 0 :
                                                              |(tx_sop_p1[4:3]) ? 9'd 0 :
                                                              |(tx_sop_p2[3:0]) ? 9'd 0 :
                                                                                  byte_count_msb_p2[0][7:0] + byte_count_lsb_p1[0][8];

                byte_count_msb_p2[1] <= !i_tx_preamble_pass ?   tx_sop_p1[1]    ? 9'd 0 :
                                                                tx_sop_p1[2]    ? 9'd 0 :
                                                                tx_sop_p1[3]    ? 9'd 0 :
                                                              |(tx_sop_p2[3:0]) ? 9'd 0 :
                                                                                  byte_count_msb_p2[1][7:0] + (byte_count_lsb_p1[1][8] ||  byte_count_lsb_p1_ln0b8_4ln1_r):
                                       /*i_tx_preamble_pass*/ |(tx_sop_p1[2:1]) ? 9'd 0 :
                                                              |(tx_sop_p1[3:2]) ? 9'd 0 :
                                                              |(tx_sop_p1[4:3]) ? 9'd 0 :
                                                              |(tx_sop_p2[3:0]) ? 9'd 0 :
                                                                                  byte_count_msb_p2[1][7:0] + (byte_count_lsb_p1[1][8] ||  byte_count_lsb_p1_ln0b8_4ln1_r);

                byte_count_msb_p2[2] <= !i_tx_preamble_pass ?   tx_sop_p1[2]    ? 9'd 0 :
                                                                tx_sop_p1[3]    ? 9'd 0 :
                                                              |(tx_sop_p2[3:0]) ? 9'd 0 :
                                                                                  byte_count_msb_p2[2][7:0] + (byte_count_lsb_p1[2][8] ||  byte_count_lsb_p1_ln0b8_4ln2_r):
                                       /*i_tx_preamble_pass*/ |(tx_sop_p1[3:2]) ? 9'd 0 :
                                                              |(tx_sop_p1[4:3]) ? 9'd 0 :
                                                              |(tx_sop_p2[3:0]) ? 9'd 0 :
                                                                                  byte_count_msb_p2[2][7:0] + (byte_count_lsb_p1[2][8] ||  byte_count_lsb_p1_ln0b8_4ln2_r);

                byte_count_msb_p2[3] <= !i_tx_preamble_pass ?   tx_sop_p1[3]    ? 9'd 0 :
                                                              |(tx_sop_p2[3:0]) ? 9'd 0 :
                                                                                  byte_count_msb_p2[3][7:0] + (byte_count_lsb_p1[3][8] ||  byte_count_lsb_p1_ln0b8_4ln3_r):
                                       /*i_tx_preamble_pass*/ |(tx_sop_p1[4:3]) ? 9'd 0 :
                                                              |(tx_sop_p2[3:0]) ? 9'd 0 :
                                                                                  byte_count_msb_p2[3][7:0] + (byte_count_lsb_p1[3][8] ||  byte_count_lsb_p1_ln0b8_4ln3_r);
            end
        end
    end

    assign byte_count_p2[0] = {byte_count_msb_p2[0][7:0], byte_count_lsb_p2[0][7:0]};
    assign byte_count_p2[1] = {byte_count_msb_p2[1][7:0], byte_count_lsb_p2[1][7:0]};
    assign byte_count_p2[2] = {byte_count_msb_p2[2][7:0], byte_count_lsb_p2[2][7:0]};
    assign byte_count_p2[3] = {byte_count_msb_p2[3][7:0], byte_count_lsb_p2[3][7:0]};

    // tr : 2-step timestamp request
    // ts : 1-step timestamp insert
    // cf : 1-step modify correction field
    // cs : IPv4 clear checksum to zero
    // eb : IPv6 extended byte
    // tf : Format for 1-step timestamp insert 1588v1/1588v2
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
// ---------------------------------------------------------------------------------------------------------------------------------
// 17/Oct/2018 : slim35 : 596644 : checksum 0 not replaced at random packets.
// ---------------------------------------------------------------------------------------------------------------------------------
// 16/Oct/2018 : slim35 : 596638 : ACDS 19.1 - eb calculations mismatch in random number of packets.
// ---------------------------------------------------------------------------------------------------------------------------------
//            tr_cmd_p1    <= '0;
//            ts_cmd_p1    <= '0;
//            cf_cmd_p1    <= '0;
//            cs_cmd_p1    <= '0;
//            eb_cmd_p1    <= '0;
//            tf_cmd_p1    <= '0;
//
//            tr_cmd_p2    <= '0;
//            ts_cmd_p2    <= '0;
//            cf_cmd_p2    <= '0;
//            cs_cmd_p2    <= '0;
//            eb_cmd_p2    <= '0;
//            tf_cmd_p2    <= '0;
//
//            tr_cmd_p3    <= '0;
//            ts_cmd_p3    <= '0;
//            cf_cmd_p3    <= '0;
//            cs_cmd_p3    <= '0;
//            eb_cmd_p3    <= '0;
//            tf_cmd_p3    <= '0;
//
//            ts_offset_p1 <= '0;
//            cf_offset_p1 <= '0;
//            cs_offset_p1 <= '0;
//            eb_offset_p1 <= '0;
//
//            ts_offset_p2 <= '0;
//            cf_offset_p2 <= '0;
//            cs_offset_p2 <= '0;
//            eb_offset_p2 <= '0;
//
//            ts_offset_p3 <= '0;
//            cf_offset_p3 <= '0;
//            cs_offset_p3 <= '0;
//            eb_offset_p3 <= '0;
// ---------------------------------------------------------------------------------------------------------------------------------

            is_ts_offset_p3 <= '0;
            is_cf_offset_p3 <= '0;
            is_cs_offset_p3 <= '0;
            is_eb_offset_p3 <= '0;

            cmd_ins_type_p4    <= '0;
            cmd_ins_type_p5    <= '0;

            cmd_byte_offset_p4 <= '0;
            cmd_byte_offset_p5 <= '0;
        end
        else begin
            if(i_tx_valid) begin
// ---------------------------------------------------------------------------------------------------------------------------------
// 17/Oct/2018 : slim35 : 596644 : checksum 0 not replaced at random packets.
// ---------------------------------------------------------------------------------------------------------------------------------
// 16/Oct/2018 : slim35 : 596638 : ACDS 19.1 - eb calculations mismatch in random number of packets.
// ---------------------------------------------------------------------------------------------------------------------------------
//                if(|(tx_sop_p0[LANES-1:0])) begin
//                    tr_cmd_p1    <= i_ptp_ts_req;
//                    ts_cmd_p1    <= i_ptp_ins_ets   && !i_tx_skip_crc;
//                    cf_cmd_p1    <= i_ptp_ins_cf    && !i_tx_skip_crc;
//                    cs_cmd_p1    <= i_ptp_zero_csum && !i_tx_skip_crc;
//                    eb_cmd_p1    <= i_ptp_update_eb && !i_tx_skip_crc;
//                    tf_cmd_p1    <= i_ptp_ts_format;
//
//                    ts_offset_p1 <= i_ptp_ts_offset;
//                    cf_offset_p1 <= i_ptp_cf_offset;
//                    cs_offset_p1 <= i_ptp_csum_offset;
//                    eb_offset_p1 <= i_ptp_eb_offset;
//                end
//
//                // Priority: Insert timestamp => Modify correction field => Request 2-step timestamp
//                tr_cmd_p2    <= (tr_cmd_p1 || (cf_cmd_p1 && tf_cmd_p1)) && !ts_cmd_p1 && !(cf_cmd_p1 && !tf_cmd_p1);
//                ts_cmd_p2    <= ts_cmd_p1;
//                cf_cmd_p2    <= cf_cmd_p1 && !tf_cmd_p1 && !ts_cmd_p1;
//                cs_cmd_p2    <= cs_cmd_p1;
//                eb_cmd_p2    <= eb_cmd_p1;
//                tf_cmd_p2    <= tf_cmd_p1;
//
//                tr_cmd_p3    <= tr_cmd_p2;
//                ts_cmd_p3    <= ts_cmd_p2;
//                cf_cmd_p3    <= cf_cmd_p2;
//                cs_cmd_p3    <= cs_cmd_p2;
//                eb_cmd_p3    <= eb_cmd_p2;
//                tf_cmd_p3    <= tf_cmd_p2;
//
//                ts_offset_p2 <= ts_offset_p1;
//                cf_offset_p2 <= cf_offset_p1;
//                cs_offset_p2 <= cs_offset_p1;
//                eb_offset_p2 <= eb_offset_p1;
//
//                ts_offset_p3 <= ts_offset_p2;
//                cf_offset_p3 <= cf_offset_p2;
//                cs_offset_p3 <= cs_offset_p2;
//                eb_offset_p3 <= eb_offset_p2;
// ---------------------------------------------------------------------------------------------------------------------------------

                for(l = 0; l < LANES; l++) begin
// ---------------------------------------------------------------------------------------------------------------------------------
// 17/Oct/2018 : slim35 : 596644 : checksum 0 not replaced at random packets.
// ---------------------------------------------------------------------------------------------------------------------------------
// 16/Oct/2018 : slim35 : 596638 : ACDS 19.1 - eb calculations mismatch in random number of packets.
// ---------------------------------------------------------------------------------------------------------------------------------
//                    is_ts_offset_p3[l][0] <= (ts_offset_p2[ 3: 3] == byte_count_p2[l][ 3: 3]) ? 1'b1 : 1'b0;
//                    is_ts_offset_p3[l][1] <= (ts_offset_p2[ 7: 4] == byte_count_p2[l][ 7: 4]) ? 1'b1 : 1'b0;
//                    is_ts_offset_p3[l][2] <= (ts_offset_p2[11: 8] == byte_count_p2[l][11: 8]) ? 1'b1 : 1'b0;
//                    is_ts_offset_p3[l][3] <= (ts_offset_p2[15:12] == byte_count_p2[l][15:12]) ? 1'b1 : 1'b0;
                    is_ts_offset_p3[l][0] <= (perln_ts_offset_p2[l][ 3: 3] == byte_count_p2[l][ 3: 3]) ? 1'b1 : 1'b0;
                    is_ts_offset_p3[l][1] <= (perln_ts_offset_p2[l][ 7: 4] == byte_count_p2[l][ 7: 4]) ? 1'b1 : 1'b0;
                    is_ts_offset_p3[l][2] <= (perln_ts_offset_p2[l][11: 8] == byte_count_p2[l][11: 8]) ? 1'b1 : 1'b0;
                    is_ts_offset_p3[l][3] <= (perln_ts_offset_p2[l][15:12] == byte_count_p2[l][15:12]) ? 1'b1 : 1'b0;

//                    is_cf_offset_p3[l][0] <= (cf_offset_p2[ 3: 3] == byte_count_p2[l][ 3: 3]) ? 1'b1 : 1'b0;
//                    is_cf_offset_p3[l][1] <= (cf_offset_p2[ 7: 4] == byte_count_p2[l][ 7: 4]) ? 1'b1 : 1'b0;
//                    is_cf_offset_p3[l][2] <= (cf_offset_p2[11: 8] == byte_count_p2[l][11: 8]) ? 1'b1 : 1'b0;
//                    is_cf_offset_p3[l][3] <= (cf_offset_p2[15:12] == byte_count_p2[l][15:12]) ? 1'b1 : 1'b0;
                    is_cf_offset_p3[l][0] <= (perln_cf_offset_p2[l][ 3: 3] == byte_count_p2[l][ 3: 3]) ? 1'b1 : 1'b0;
                    is_cf_offset_p3[l][1] <= (perln_cf_offset_p2[l][ 7: 4] == byte_count_p2[l][ 7: 4]) ? 1'b1 : 1'b0;
                    is_cf_offset_p3[l][2] <= (perln_cf_offset_p2[l][11: 8] == byte_count_p2[l][11: 8]) ? 1'b1 : 1'b0;
                    is_cf_offset_p3[l][3] <= (perln_cf_offset_p2[l][15:12] == byte_count_p2[l][15:12]) ? 1'b1 : 1'b0;

//                    is_cs_offset_p3[l][0] <= (cs_offset_p2[ 3: 3] == byte_count_p2[l][ 3: 3]) ? 1'b1 : 1'b0;
//                    is_cs_offset_p3[l][1] <= (cs_offset_p2[ 7: 4] == byte_count_p2[l][ 7: 4]) ? 1'b1 : 1'b0;
//                    is_cs_offset_p3[l][2] <= (cs_offset_p2[11: 8] == byte_count_p2[l][11: 8]) ? 1'b1 : 1'b0;
//                    is_cs_offset_p3[l][3] <= (cs_offset_p2[15:12] == byte_count_p2[l][15:12]) ? 1'b1 : 1'b0;
                    is_cs_offset_p3[l][0] <= (perln_cs_offset_p2[l][ 3: 3] == byte_count_p2[l][ 3: 3]) ? 1'b1 : 1'b0;
                    is_cs_offset_p3[l][1] <= (perln_cs_offset_p2[l][ 7: 4] == byte_count_p2[l][ 7: 4]) ? 1'b1 : 1'b0;
                    is_cs_offset_p3[l][2] <= (perln_cs_offset_p2[l][11: 8] == byte_count_p2[l][11: 8]) ? 1'b1 : 1'b0;
                    is_cs_offset_p3[l][3] <= (perln_cs_offset_p2[l][15:12] == byte_count_p2[l][15:12]) ? 1'b1 : 1'b0;

//                    is_eb_offset_p3[l][0] <= (eb_offset_p2[ 3: 3] == byte_count_p2[l][ 3: 3]) ? 1'b1 : 1'b0;
//                    is_eb_offset_p3[l][1] <= (eb_offset_p2[ 7: 4] == byte_count_p2[l][ 7: 4]) ? 1'b1 : 1'b0;
//                    is_eb_offset_p3[l][2] <= (eb_offset_p2[11: 8] == byte_count_p2[l][11: 8]) ? 1'b1 : 1'b0;
//                    is_eb_offset_p3[l][3] <= (eb_offset_p2[15:12] == byte_count_p2[l][15:12]) ? 1'b1 : 1'b0;
                    is_eb_offset_p3[l][0] <= (perln_eb_offset_p2[l][ 3: 3] == byte_count_p2[l][ 3: 3]) ? 1'b1 : 1'b0;
                    is_eb_offset_p3[l][1] <= (perln_eb_offset_p2[l][ 7: 4] == byte_count_p2[l][ 7: 4]) ? 1'b1 : 1'b0;
                    is_eb_offset_p3[l][2] <= (perln_eb_offset_p2[l][11: 8] == byte_count_p2[l][11: 8]) ? 1'b1 : 1'b0;
                    is_eb_offset_p3[l][3] <= (perln_eb_offset_p2[l][15:12] == byte_count_p2[l][15:12]) ? 1'b1 : 1'b0;
// ---------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------------------------------
// 17/Oct/2018 : slim35 : 596644 : checksum 0 not replaced at random packets.
// ---------------------------------------------------------------------------------------------------------------------------------
// 16/Oct/2018 : slim35 : 596638 : ACDS 19.1 - eb calculations mismatch in random number of packets.
// ---------------------------------------------------------------------------------------------------------------------------------
//                    cmd_ins_type_p4[l]    <= tx_sop_p3[l] ? tf_cmd_p3 ? ts_cmd_p3 ? 3'b001 : // Insert 1588v1 timestamp
//                                                                        tr_cmd_p3 ? 3'b100 : // Request 2-step timestamp
//                                                                                    3'b000 : // No op
//                                                         /*!tf_cmd_p3*/ ts_cmd_p3 ? 3'b010 : // Insert 1588v2 timestamp
//                                                                        cf_cmd_p3 ? 3'b011 : // Modify 1588v2 correction field
//                                                                        tr_cmd_p3 ? 3'b100 : // Request 2-step timestamp
//                                                                                    3'b000 : // No op
//                                          /*!tx_sop_p3[l]*/ (&is_ts_offset_p3[l] && ts_cmd_p3)                                ? 3'b001 :
//                                                            (&is_cf_offset_p3[l] && ((cf_cmd_p3 || ts_cmd_p3) && !tf_cmd_p3)) ? 3'b010 :
//                                                            (&is_cs_offset_p3[l] && cs_cmd_p3)                                ? 3'b011 :
//                                                            (&is_eb_offset_p3[l] && eb_cmd_p3)                                ? 3'b100 :
//                                                                                                                                3'b000;
                    cmd_ins_type_p4[l]    <= tx_sop_p3[l] ? perln_tf_cmd_p3[l] ? perln_ts_cmd_p3[l] ? 3'b001 : // Insert 1588v1 timestamp
                                                                        perln_tr_cmd_p3[l] ? 3'b100 : // Request 2-step timestamp
                                                                                    3'b000 : // No op
                                                         /*!tf_cmd_p3*/ perln_ts_cmd_p3[l] ? 3'b010 : // Insert 1588v2 timestamp
                                                                        perln_cf_cmd_p3[l] ? 3'b011 : // Modify 1588v2 correction field
                                                                        perln_tr_cmd_p3[l] ? 3'b100 : // Request 2-step timestamp
                                                                                    3'b000 : // No op
                                          /*!tx_sop_p3[l]*/ (&is_ts_offset_p3[l] && perln_ts_cmd_p3[l])                                ? 3'b001 :
                                                            (&is_cf_offset_p3[l] && ((perln_cf_cmd_p3[l] || perln_ts_cmd_p3[l]) && !perln_tf_cmd_p3[l])) ? 3'b010 :
                                                            (&is_cs_offset_p3[l] && perln_cs_cmd_p3[l])                                ? 3'b011 :
                                                            (&is_eb_offset_p3[l] && perln_eb_cmd_p3[l])                                ? 3'b100 :
                                                                                                                                3'b000;
// ---------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------------------------------
// 17/Oct/2018 : slim35 : 596644 : checksum 0 not replaced at random packets.
// ---------------------------------------------------------------------------------------------------------------------------------
// 16/Oct/2018 : slim35 : 596638 : ACDS 19.1 - eb calculations mismatch in random number of packets.
// ---------------------------------------------------------------------------------------------------------------------------------
//                    cmd_byte_offset_p4[l] <= tx_sop_p3[l] ? (ts_cmd_p3 || (cf_cmd_p3 && !tf_cmd_p3)) ? eb_cmd_p3 ? 3'b010 : // Extended bytes for UDP/IPv6
//                                                                                                       cs_cmd_p3 ? 3'b001 : // Zero checksum for UDP/IPv4
//                                                                                                                   3'b000 :
//                                                          /*(ts_cmd_p3 || (cf_cmd_p3 && !tf_cmd_p3))*/ 3'b000 :
//                                          /*!tx_sop_p3[l]*/ (&is_ts_offset_p3[l] && ts_cmd_p3)                                ? ts_offset_p3[2:0] :
//                                                            (&is_cf_offset_p3[l] && ((cf_cmd_p3 || ts_cmd_p3) && !tf_cmd_p3)) ? cf_offset_p3[2:0] :
//                                                            (&is_cs_offset_p3[l] && cs_cmd_p3)                                ? cs_offset_p3[2:0] :
//                                                            (&is_eb_offset_p3[l] && eb_cmd_p3)                                ? eb_offset_p3[2:0] :
//                                                                                                                                3'b000;
                    cmd_byte_offset_p4[l] <= tx_sop_p3[l] ? (perln_ts_cmd_p3[l] || (perln_cf_cmd_p3[l] && !perln_tf_cmd_p3[l])) ? perln_eb_cmd_p3[l] ? 3'b010 : // Extended bytes for UDP/IPv6
                                                                                                       perln_cs_cmd_p3[l] ? 3'b001 : // Zero checksum for UDP/IPv4
                                                                                                                   3'b000 :
                                                          /*(perln_ts_cmd_p3[l] || (perln_cf_cmd_p3[l] && !perln_tf_cmd_p3[l]))*/ 3'b000 :
                                          /*!tx_sop_p3[l]*/ (&is_ts_offset_p3[l] && perln_ts_cmd_p3[l])                                ? perln_ts_offset_p3[l][2:0] :
                                                            (&is_cf_offset_p3[l] && ((perln_cf_cmd_p3[l] || perln_ts_cmd_p3[l]) && !perln_tf_cmd_p3[l])) ? perln_cf_offset_p3[l][2:0] :
                                                            (&is_cs_offset_p3[l] && perln_cs_cmd_p3[l])                                ? perln_cs_offset_p3[l][2:0] :
                                                            (&is_eb_offset_p3[l] && perln_eb_cmd_p3[l])                                ? perln_eb_offset_p3[l][2:0] :
                                                                                                                                3'b000;
// ---------------------------------------------------------------------------------------------------------------------------------

                    cmd_ins_type_p5[l]    <= cmd_ins_type_p4[l];
                    cmd_byte_offset_p5[l] <= cmd_byte_offset_p4[l];
                end
            end
        end
    end



// ---------------------------------------------------------------------------------------------------------------------------------
// 17/Oct/2018 : slim35 : 596644 : checksum 0 not replaced at random packets.
// ---------------------------------------------------------------------------------------------------------------------------------
// In multilane, skip_crc should be used on per lane basis instead of 1 for all the lanes for the same reason as EB issue below.
// For example packet1 has skip_crc=1 with EOP at lane[2] while packet2 has skip_crc=0 with SOP at lane[1], this will mask the CMD of packet2 and causes missing CMD.
// This is affecting all 4 commands (ts, cf, c & eb) where skip_crc is required to be 0.
// ---------------------------------------------------------------------------------------------------------------------------------
// 16/Oct/2018 : slim35 : 596638 : ACDS 19.1 - eb calculations mismatch in random number of packets.
// ---------------------------------------------------------------------------------------------------------------------------------
// We need eb_cmd_p* to be per lane instead of one signal for all lanes.
// Reason being EOP and SOP can happen at the same clock where upper lanes are still working on previous packet while lower lanes are starting on new packet.
// Therefore we cannot reset the eb_cmd of upper lanes immediately at the same clock else it will lose its states while the remaining payloads are still in the pipeline.
// ---------------------------------------------------------------------------------------------------------------------------------
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            perln_tr_cmd_p1    <= '0;
            perln_tr_cmd_p2    <= '0;
            perln_tr_cmd_p3    <= '0;

            perln_ts_cmd_p1    <= '0;
            perln_ts_cmd_p2    <= '0;
            perln_ts_cmd_p3    <= '0;
	    perln_ts_offset_p1 <= '0;
	    perln_ts_offset_p2 <= '0;
	    perln_ts_offset_p3 <= '0;

            perln_cf_cmd_p1    <= '0;
            perln_cf_cmd_p2    <= '0;
            perln_cf_cmd_p3    <= '0;
	    perln_cf_offset_p1 <= '0;
	    perln_cf_offset_p2 <= '0;
	    perln_cf_offset_p3 <= '0;

            perln_cs_cmd_p1    <= '0;
            perln_cs_cmd_p2    <= '0;
            perln_cs_cmd_p3    <= '0;
	    perln_cs_offset_p1 <= '0;
	    perln_cs_offset_p2 <= '0;
	    perln_cs_offset_p3 <= '0;

            perln_eb_cmd_p1    <= '0;
            perln_eb_cmd_p2    <= '0;
            perln_eb_cmd_p3    <= '0;
	    perln_eb_offset_p1 <= '0;
	    perln_eb_offset_p2 <= '0;
	    perln_eb_offset_p3 <= '0;

            perln_tf_cmd_p1    <= '0;
            perln_tf_cmd_p2    <= '0;
            perln_tf_cmd_p3    <= '0;
        end
        else begin
            if(i_tx_valid) begin
		// -----------------------------------------------------------------------------------------------------------------------
		// Per Lane TR CMD.
		// -----------------------------------------------------------------------------------------------------------------------
                perln_tr_cmd_p1[3]	<=   tx_sop_p0[3]            ? i_ptp_ts_req : perln_tr_cmd_p1[0];
                perln_tr_cmd_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? i_ptp_ts_req : perln_tr_cmd_p1[0];
                perln_tr_cmd_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? i_ptp_ts_req : perln_tr_cmd_p1[0];
                perln_tr_cmd_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? i_ptp_ts_req : perln_tr_cmd_p1[0];

                for(l = 0; l < LANES; l++) begin
			perln_tr_cmd_p2[l]    <= (perln_tr_cmd_p1[l] || (perln_cf_cmd_p1[l] && perln_tf_cmd_p1[l])) && !perln_ts_cmd_p1[l] && !(perln_cf_cmd_p1[l] && !perln_tf_cmd_p1[l]);
		end

                perln_tr_cmd_p3		<= perln_tr_cmd_p2;

		// -----------------------------------------------------------------------------------------------------------------------
		// Per Lane TS CMD.
		// -----------------------------------------------------------------------------------------------------------------------
                perln_ts_cmd_p1[3]	<=   tx_sop_p0[3]            ? (i_ptp_ins_ets && !i_tx_skip_crc[3]) : perln_ts_cmd_p1[0];
                perln_ts_cmd_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? (i_ptp_ins_ets && !i_tx_skip_crc[2]) : perln_ts_cmd_p1[0];
                perln_ts_cmd_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? (i_ptp_ins_ets && !i_tx_skip_crc[1]) : perln_ts_cmd_p1[0];
                perln_ts_cmd_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? (i_ptp_ins_ets && !i_tx_skip_crc[0]) : perln_ts_cmd_p1[0];

                perln_ts_cmd_p2		<= perln_ts_cmd_p1;
                perln_ts_cmd_p3		<= perln_ts_cmd_p2;

                perln_ts_offset_p1[3]	<=   tx_sop_p0[3]            ? i_ptp_ts_offset : perln_ts_offset_p1[0];
                perln_ts_offset_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? i_ptp_ts_offset : perln_ts_offset_p1[0];
                perln_ts_offset_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? i_ptp_ts_offset : perln_ts_offset_p1[0];
                perln_ts_offset_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? i_ptp_ts_offset : perln_ts_offset_p1[0];

	        perln_ts_offset_p2	<= perln_ts_offset_p1;
	        perln_ts_offset_p3	<= perln_ts_offset_p2;

		// -----------------------------------------------------------------------------------------------------------------------
		// Per Lane CF CMD.
		// -----------------------------------------------------------------------------------------------------------------------
                perln_cf_cmd_p1[3]	<=   tx_sop_p0[3]            ? (i_ptp_ins_cf && !i_tx_skip_crc[3]) : perln_cf_cmd_p1[0];
                perln_cf_cmd_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? (i_ptp_ins_cf && !i_tx_skip_crc[2]) : perln_cf_cmd_p1[0];
                perln_cf_cmd_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? (i_ptp_ins_cf && !i_tx_skip_crc[1]) : perln_cf_cmd_p1[0];
                perln_cf_cmd_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? (i_ptp_ins_cf && !i_tx_skip_crc[0]) : perln_cf_cmd_p1[0];

                for(l = 0; l < LANES; l++) begin
			perln_cf_cmd_p2[l]    <= perln_cf_cmd_p1[l] && !perln_tf_cmd_p1[l] && !perln_ts_cmd_p1[l];
                end

                perln_cf_cmd_p3		<= perln_cf_cmd_p2;

                perln_cf_offset_p1[3]	<=   tx_sop_p0[3]            ? i_ptp_cf_offset : perln_cf_offset_p1[0];
                perln_cf_offset_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? i_ptp_cf_offset : perln_cf_offset_p1[0];
                perln_cf_offset_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? i_ptp_cf_offset : perln_cf_offset_p1[0];
                perln_cf_offset_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? i_ptp_cf_offset : perln_cf_offset_p1[0];

	        perln_cf_offset_p2	<= perln_cf_offset_p1;
	        perln_cf_offset_p3	<= perln_cf_offset_p2;

		// -----------------------------------------------------------------------------------------------------------------------
		// Per Lane CS CMD.
		// -----------------------------------------------------------------------------------------------------------------------
                perln_cs_cmd_p1[3]	<=   tx_sop_p0[3]            ? (i_ptp_zero_csum && !i_tx_skip_crc[3]) : perln_cs_cmd_p1[0];
                perln_cs_cmd_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? (i_ptp_zero_csum && !i_tx_skip_crc[2]) : perln_cs_cmd_p1[0];
                perln_cs_cmd_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? (i_ptp_zero_csum && !i_tx_skip_crc[1]) : perln_cs_cmd_p1[0];
                perln_cs_cmd_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? (i_ptp_zero_csum && !i_tx_skip_crc[0]) : perln_cs_cmd_p1[0];

                perln_cs_cmd_p2		<= perln_cs_cmd_p1;
                perln_cs_cmd_p3		<= perln_cs_cmd_p2;

                perln_cs_offset_p1[3]	<=   tx_sop_p0[3]            ? i_ptp_csum_offset : perln_cs_offset_p1[0];
                perln_cs_offset_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? i_ptp_csum_offset : perln_cs_offset_p1[0];
                perln_cs_offset_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? i_ptp_csum_offset : perln_cs_offset_p1[0];
                perln_cs_offset_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? i_ptp_csum_offset : perln_cs_offset_p1[0];

	        perln_cs_offset_p2	<= perln_cs_offset_p1;
	        perln_cs_offset_p3	<= perln_cs_offset_p2;

		// -----------------------------------------------------------------------------------------------------------------------
		// Per Lane EB CMD.
		// -----------------------------------------------------------------------------------------------------------------------
                perln_eb_cmd_p1[3]	<=   tx_sop_p0[3]            ? (i_ptp_update_eb && !i_tx_skip_crc[3]) : perln_eb_cmd_p1[0];
                perln_eb_cmd_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? (i_ptp_update_eb && !i_tx_skip_crc[2]) : perln_eb_cmd_p1[0];
                perln_eb_cmd_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? (i_ptp_update_eb && !i_tx_skip_crc[1]) : perln_eb_cmd_p1[0];
                perln_eb_cmd_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? (i_ptp_update_eb && !i_tx_skip_crc[0]) : perln_eb_cmd_p1[0];

                perln_eb_cmd_p2		<= perln_eb_cmd_p1;
                perln_eb_cmd_p3		<= perln_eb_cmd_p2;

                perln_eb_offset_p1[3]	<=   tx_sop_p0[3]            ? i_ptp_eb_offset : perln_eb_offset_p1[0];
                perln_eb_offset_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? i_ptp_eb_offset : perln_eb_offset_p1[0];
                perln_eb_offset_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? i_ptp_eb_offset : perln_eb_offset_p1[0];
                perln_eb_offset_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? i_ptp_eb_offset : perln_eb_offset_p1[0];

	        perln_eb_offset_p2	<= perln_eb_offset_p1;
	        perln_eb_offset_p3	<= perln_eb_offset_p2;

		// -----------------------------------------------------------------------------------------------------------------------
		// Per Lane TF.
		// -----------------------------------------------------------------------------------------------------------------------
                perln_tf_cmd_p1[3]	<=   tx_sop_p0[3]            ? i_ptp_ts_format : perln_tf_cmd_p1[0];
                perln_tf_cmd_p1[2]	<= (|tx_sop_p0[(LANES-1):2]) ? i_ptp_ts_format : perln_tf_cmd_p1[0];
                perln_tf_cmd_p1[1]	<= (|tx_sop_p0[(LANES-1):1]) ? i_ptp_ts_format : perln_tf_cmd_p1[0];
                perln_tf_cmd_p1[0]	<= (|tx_sop_p0[(LANES-1):0]) ? i_ptp_ts_format : perln_tf_cmd_p1[0];

                perln_tf_cmd_p2		<= perln_tf_cmd_p1;
                perln_tf_cmd_p3		<= perln_tf_cmd_p2;
            end
        end
    end
// ---------------------------------------------------------------------------------------------------------------------------------


    // Early warning detection
    assign ptp_cmd_p0 = (i_ptp_ts_req || i_ptp_ins_ets || i_ptp_ins_cf);

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            early_warning_p1 <= 1'b0;
            early_warning_p2 <= 1'b0;
            early_warning_p3 <= 1'b0;
            early_warning_p4 <= 1'b0;
        end
        else begin
            if(i_tx_valid) begin
                if(|(tx_sop_p0[LANES-1:0])) begin // SOP
                    early_warning_p1 <= ptp_cmd_p0;
                end
                else if(|(tx_eop_p1[LANES-1:0])) begin // Delayed EOP
                    early_warning_p1 <= 1'b0;
                end

                early_warning_p2 <= early_warning_p1;
                early_warning_p3 <= early_warning_p2;
                early_warning_p4 <= early_warning_p3;
            end
        end
    end

    assign early_warning_all_p4 = early_warning_p4;

    // PTP loading
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            req_tx_tam_p2           <= 1'b0;
            req_tx_tam_p3           <= 1'b0;
            req_tx_tam_p4           <= 1'b0;
            tx_tam_lane_p2          <= 2'd0;
            tx_tam_lane_p3          <= 2'd0;
            tx_tam_lane_p4          <= 2'd0;

            req_rx_tam_p2           <= 1'b0;
            req_rx_tam_p3           <= 1'b0;
            req_rx_tam_p4           <= 1'b0;
            rx_tam_lane_p2          <= 2'd0;
            rx_tam_lane_p3          <= 2'd0;
            rx_tam_lane_p4          <= 2'd0;

            req_vl_offset_p2a       <= 1'b0;
            req_vl_offset_p2b       <= 1'b0;
            req_vl_offset_p2c       <= 1'b0;
            req_vl_offset_p2d       <= 1'b0;
            req_vl_offset_p3        <= 1'b0;
            req_vl_offset_p4        <= 1'b0;
            vl_sel_p2a              <= 5'd0;
            vl_sel_p2b              <= 5'd0;
            vl_sel_p2c              <= 5'd0;
            vl_sel_p2d              <= 5'd0;
            vl_sel_p3               <= 5'd0;
            vl_sel_p4               <= 5'd0;

            req_tam_p4              <= 1'b0;

            loading_mux_select_dup0 <= 1'b0;
            loading_mux_select_dup1 <= 1'b0;
            loading_req_hold_p0     <= 1'b0;
            loading_req_hold_p1     <= 1'b0;
            loading_req_hold_p2     <= 1'b0;
            loading_req_hold_p3     <= 1'b0;
            loading_req_hold        <= 1'b0;
            loading_req_update_p0   <= 1'b0;
            loading_req_update_p1   <= 1'b0;
            loading_req_update_p2   <= 1'b0;
            loading_req_update_p3   <= 1'b0;
            loading_req_update_p4   <= 1'b0;
            loading_req_update      <= 1'b0;

            load_ins_type_p56       <= {4{3'b000}};
            load_byte_offset_p56    <= {4{3'b000}};
            load_type               <= LOAD_TYPE_NONE;

            tx_tam_lane_p56         <= 2'b00;
            rx_tam_lane_p56         <= 2'b00;
            vl_sel_p56              <= 5'd0;
        end
        else begin
            req_tx_tam_p2   <= |req_tx_tam;
            req_tx_tam_p3   <= req_tx_tam_p2;
            req_tx_tam_p4   <= req_tx_tam_p3;
            tx_tam_lane_p2  <= req_tx_tam[0] ? 2'd0 :
                               req_tx_tam[1] ? 2'd1 :
                               req_tx_tam[2] ? 2'd2 :
                                               2'd3;
            tx_tam_lane_p3  <= tx_tam_lane_p2;
            tx_tam_lane_p4  <= tx_tam_lane_p3;
            tx_tam_p3       <= i_tx_tam[tx_tam_lane_p2];
            tx_tam_p4       <= tx_tam_p3;

            req_rx_tam_p2   <= |req_rx_tam;
            req_rx_tam_p3   <= req_rx_tam_p2;
            req_rx_tam_p4   <= req_rx_tam_p3;
            rx_tam_lane_p2  <= req_rx_tam[0] ? 2'd0 :
                               req_rx_tam[1] ? 2'd1 :
                               req_rx_tam[2] ? 2'd2 :
                                               2'd3;
            rx_tam_lane_p3  <= rx_tam_lane_p2;
            rx_tam_lane_p4  <= rx_tam_lane_p3;
            rx_tam_p3       <= i_rx_tam[rx_tam_lane_p2];
            rx_tam_p4       <= rx_tam_p3;

            req_vl_offset_p2a <= |(req_vl_offset[4:0]);
            req_vl_offset_p2b <= |(req_vl_offset[9:5]);
            req_vl_offset_p2c <= |(req_vl_offset[14:10]);
            req_vl_offset_p2d <= |(req_vl_offset[19:15]);
            req_vl_offset_p3 <= req_vl_offset_p2a |
                                req_vl_offset_p2b |
                                req_vl_offset_p2c |
                                req_vl_offset_p2d;
            req_vl_offset_p4 <= req_vl_offset_p3;
            vl_sel_p2a <= req_vl_offset[ 0] ? 5'd 0 :
                          req_vl_offset[ 1] ? 5'd 1 :
                          req_vl_offset[ 2] ? 5'd 2 :
                          req_vl_offset[ 3] ? 5'd 3 :
                                              5'd 4;
            vl_sel_p2b <= req_vl_offset[ 5] ? 5'd 5 :
                          req_vl_offset[ 6] ? 5'd 6 :
                          req_vl_offset[ 7] ? 5'd 7 :
                          req_vl_offset[ 8] ? 5'd 8 :
                                              5'd 9;
            vl_sel_p2c <= req_vl_offset[10] ? 5'd10 :
                          req_vl_offset[11] ? 5'd11 :
                          req_vl_offset[12] ? 5'd12 :
                          req_vl_offset[13] ? 5'd13 :
                                              5'd14;
            vl_sel_p2d <= req_vl_offset[15] ? 5'd15 :
                          req_vl_offset[16] ? 5'd16 :
                          req_vl_offset[17] ? 5'd17 :
                          req_vl_offset[18] ? 5'd18 :
                                              5'd19;
            vl_sel_p3        <= req_vl_offset_p2a ? vl_sel_p2a :
                                req_vl_offset_p2b ? vl_sel_p2b :
                                req_vl_offset_p2c ? vl_sel_p2c :
                                                    vl_sel_p2d;
            vl_sel_p4        <= vl_sel_p3;
            vl_offset_p3a    <= (vl_sel_p2a == 5'd 0) ? i_vl_offset[0] :
                                (vl_sel_p2a == 5'd 1) ? i_vl_offset[1] :
                                (vl_sel_p2a == 5'd 2) ? i_vl_offset[2] :
                                (vl_sel_p2a == 5'd 3) ? i_vl_offset[3] :
                                                        i_vl_offset[4];
            vl_offset_p3b    <= (vl_sel_p2b == 5'd 5) ? i_vl_offset[5] :
                                (vl_sel_p2b == 5'd 6) ? i_vl_offset[6] :
                                (vl_sel_p2b == 5'd 7) ? i_vl_offset[7] :
                                (vl_sel_p2b == 5'd 8) ? i_vl_offset[8] :
                                                        i_vl_offset[9];
            vl_offset_p3c    <= (vl_sel_p2c == 5'd10) ? i_vl_offset[10] :
                                (vl_sel_p2c == 5'd11) ? i_vl_offset[11] :
                                (vl_sel_p2c == 5'd12) ? i_vl_offset[12] :
                                (vl_sel_p2c == 5'd13) ? i_vl_offset[13] :
                                                        i_vl_offset[14];
            vl_offset_p3d    <= (vl_sel_p2d == 5'd15) ? i_vl_offset[15] :
                                (vl_sel_p2d == 5'd16) ? i_vl_offset[16] :
                                (vl_sel_p2d == 5'd17) ? i_vl_offset[17] :
                                (vl_sel_p2d == 5'd18) ? i_vl_offset[18] :
                                                        i_vl_offset[19];
            vl_offset_p4     <= (vl_sel_p3  == 5'd 0) ? vl_offset_p3a :
                                (vl_sel_p3  == 5'd 1) ? vl_offset_p3a :
                                (vl_sel_p3  == 5'd 2) ? vl_offset_p3a :
                                (vl_sel_p3  == 5'd 3) ? vl_offset_p3a :
                                (vl_sel_p3  == 5'd 4) ? vl_offset_p3a :
                                (vl_sel_p3  == 5'd 5) ? vl_offset_p3b :
                                (vl_sel_p3  == 5'd 6) ? vl_offset_p3b :
                                (vl_sel_p3  == 5'd 7) ? vl_offset_p3b :
                                (vl_sel_p3  == 5'd 8) ? vl_offset_p3b :
                                (vl_sel_p3  == 5'd 9) ? vl_offset_p3b :
                                (vl_sel_p3  == 5'd10) ? vl_offset_p3c :
                                (vl_sel_p3  == 5'd11) ? vl_offset_p3c :
                                (vl_sel_p3  == 5'd12) ? vl_offset_p3c :
                                (vl_sel_p3  == 5'd13) ? vl_offset_p3c :
                                (vl_sel_p3  == 5'd14) ? vl_offset_p3c :
                                (vl_sel_p3  == 5'd15) ? vl_offset_p3d :
                                (vl_sel_p3  == 5'd16) ? vl_offset_p3d :
                                (vl_sel_p3  == 5'd17) ? vl_offset_p3d :
                                (vl_sel_p3  == 5'd18) ? vl_offset_p3d :
                                                        vl_offset_p3d;
            req_tam_p4 <= req_tx_tam_p3 | req_rx_tam_p3;

// ---------------------------------------------------------------------------------------------------------------------------------
// 01/Oct/2018 : slim35 : 595303 : ts not embedded in random packet.
// To avoid many boundary conditions when load command clashes with insert command, we decided to only allow TAM loading during invalid gap.
// ---------------------------------------------------------------------------------------------------------------------------------
//            if(((i_tx_valid && !early_warning_all_p4) || (i_tx_valid && !i_tx_early_valid)) && // Load only when non-PTP packet is transmitting, or during invalid gap
            if(((i_tx_valid && !i_tx_early_valid)) && // Load only when non-PTP packet is transmitting, or during invalid gap
// ---------------------------------------------------------------------------------------------------------------------------------
               (!loading_req_hold) &&
               (!loading_req_update) &&
               ((req_tx_ui && tx_tam_load_done_p) ||
                (req_rx_ui && tx_tam_load_done_p) ||
                (req_tam_p4) ||
                (req_vl_offset_p4))
              ) begin
                loading_mux_select_dup0 <= 1'b1;
                loading_mux_select_dup1 <= 1'b1;
                loading_req_hold_p0 <= 1'b1;
                loading_req_hold    <= 1'b1;
            end
            else begin
                loading_mux_select_dup0 <= 1'b0;
                loading_mux_select_dup1 <= 1'b0;
                loading_req_hold_p0 <= 1'b0;
                loading_req_hold    <= loading_req_hold_p0 |
                                       loading_req_hold_p1 |
                                       loading_req_hold_p2 |
                                       loading_req_hold_p3;
            end

            loading_req_hold_p1   <= loading_req_hold_p0;
            loading_req_hold_p2   <= loading_req_hold_p1;
            loading_req_hold_p3   <= loading_req_hold_p2;
            loading_complete      <= loading_req_hold_p3;
            loading_req_update_p0 <= loading_req_hold_p3;
            loading_req_update_p1 <= loading_req_update_p0;
            loading_req_update_p2 <= loading_req_update_p1;
            loading_req_update_p3 <= loading_req_update_p2;
            loading_req_update_p4 <= loading_req_update_p3;
            loading_req_update    <= loading_req_hold_p3 |
                                     loading_req_update_p0 |
                                     loading_req_update_p1 |
                                     loading_req_update_p2 |
                                     loading_req_update_p3 |
                                     loading_req_update_p4;

            if(!loading_req_hold) begin
                // Load TX UI
                if(req_tx_ui && tx_tam_load_done_p) begin
                    selected_tam_p56        <= i_tx_ui;
                    load_ins_type_p56       <= {4{3'b111}};
                    load_byte_offset_p56    <= {4{3'b010}};
                    load_type               <= LOAD_TYPE_TX_UI;
                end

                // Load RX UI
                else if(req_rx_ui && tx_tam_load_done_p) begin
                    selected_tam_p56        <= i_rx_ui;
                    load_ins_type_p56       <= {4{3'b111}};
                    load_byte_offset_p56    <= {4{3'b011}};
                    load_type               <= LOAD_TYPE_RX_UI;
                end

                // Load TX TAM/RX TAM
                else if(req_tam_p4) begin
                    selected_tam_p56        <= selected_tam_p4;
                    load_ins_type_p56       <= load_ins_type_p4;
                    load_byte_offset_p56    <= load_byte_offset_p4;
                    load_type               <= load_type_p4;
                end

                // Load VL Offset
                else if(req_vl_offset_p4) begin
                    selected_tam_p56        <= {57'h0, vl_offset_p4};
                    load_ins_type_p56       <= {4{3'b111}};
                    load_byte_offset_p56    <= {4{3'b100}};
                    load_type               <= LOAD_TYPE_VL_OFFSET;
                end

                // Default
                else begin
                    selected_tam_p56        <= 96'h0;
                    load_ins_type_p56       <= {4{3'b000}};
                    load_byte_offset_p56    <= {4{3'b000}};
                    load_type               <= LOAD_TYPE_NONE;
                end

                tx_tam_lane_p56 <= tx_tam_lane_p4;
                rx_tam_lane_p56 <= rx_tam_lane_p4;
                vl_sel_p56      <= vl_sel_p4;
            end
            else begin
                selected_tam_p56        <= 96'h0;
                load_ins_type_p56       <= {4{3'b000}};
                load_byte_offset_p56    <= {4{3'b000}};
                load_type               <= load_type;

                tx_tam_lane_p56         <= tx_tam_lane_p56;
                rx_tam_lane_p56         <= rx_tam_lane_p56;
                vl_sel_p56              <= vl_sel_p56;
            end

            // Load TX TAM
            if(req_tx_tam_p3) begin
                selected_tam_p4         <= tx_tam_p3;
                load_ins_type_p4        <= {(tx_tam_lane_p3 == 2'd3) ? 3'b111 : 3'b000,
                                            (tx_tam_lane_p3 == 2'd2) ? 3'b111 : 3'b000,
                                            (tx_tam_lane_p3 == 2'd1) ? 3'b111 : 3'b000,
                                            (tx_tam_lane_p3 == 2'd0) ? 3'b111 : 3'b000};
                load_byte_offset_p4     <= {(tx_tam_lane_p3 == 2'd3) ? 3'b000 : 3'b000,
                                            (tx_tam_lane_p3 == 2'd2) ? 3'b000 : 3'b000,
                                            (tx_tam_lane_p3 == 2'd1) ? 3'b000 : 3'b000,
                                            (tx_tam_lane_p3 == 2'd0) ? 3'b000 : 3'b000};
                load_type_p4            <= LOAD_TYPE_TX_TAM;
            end

            // Load RX TAM
            else if(req_rx_tam_p3) begin
                selected_tam_p4         <= rx_tam_p3;
                load_ins_type_p4        <= {(rx_tam_lane_p3 == 2'd3) ? 3'b111 : 3'b000,
                                            (rx_tam_lane_p3 == 2'd2) ? 3'b111 : 3'b000,
                                            (rx_tam_lane_p3 == 2'd1) ? 3'b111 : 3'b000,
                                            (rx_tam_lane_p3 == 2'd0) ? 3'b111 : 3'b000};
                load_byte_offset_p4     <= {(rx_tam_lane_p3 == 2'd3) ? 3'b001 : 3'b000,
                                            (rx_tam_lane_p3 == 2'd2) ? 3'b001 : 3'b000,
                                            (rx_tam_lane_p3 == 2'd1) ? 3'b001 : 3'b000,
                                            (rx_tam_lane_p3 == 2'd0) ? 3'b001 : 3'b000};
                load_type_p4            <= LOAD_TYPE_RX_TAM;
            end

        end
    end

    // Fingerprint and ingress timestamp
    always @(posedge i_clk) begin
        if(i_tx_valid) begin
            tx_fp_p1 <= i_ptp_fp;
            tx_fp_p2 <= tx_fp_p1;
            tx_fp_p3 <= tx_fp_p2;
            tx_fp_p4 <= tx_fp_p3;
            tx_fp_p5 <= tx_fp_p4;

            tx_its_p1 <= i_ptp_tx_its;
            tx_its_p2 <= tx_its_p1;
            tx_its_p3 <= tx_its_p2;
            tx_its_p4 <= tx_its_p3;
            tx_its_p5 <= tx_its_p4;
        end
    end

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            o_ptp_ins_type    <= {LANES{3'h0}};
            o_ptp_byte_offset <= {LANES{3'h0}};
        end
        else begin
            o_ptp_ins_type    <= loading_mux_select_dup0 ? load_ins_type_p56: cmd_ins_type_p5;
            o_ptp_byte_offset <= loading_mux_select_dup1 ? load_byte_offset_p56: cmd_byte_offset_p5;
        end
    end

    always @(posedge i_clk) begin
        o_ptp_ts[47:0]    <= loading_mux_select_dup0 ? selected_tam_p56[47:0]: tx_its_p5[47:0];
        o_ptp_ts[95:0]    <= loading_mux_select_dup1 ? selected_tam_p56[95:0]: tx_its_p5[95:0];
        o_ptp_tx_fp       <= tx_fp_p5;
    end

endmodule
