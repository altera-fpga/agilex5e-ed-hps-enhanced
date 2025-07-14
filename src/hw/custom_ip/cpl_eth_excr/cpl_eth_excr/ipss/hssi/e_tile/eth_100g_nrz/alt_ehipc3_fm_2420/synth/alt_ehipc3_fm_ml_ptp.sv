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
module alt_ehipc3_fm_ml_ptp #(
    parameter ENABLE_PTP_REF_LANE   = 1,
    parameter LANES                 = 4
) (
    // Configuration
    input  logic                    i_enable_rsfec,
    input  logic                    i_tx_preamble_pass,
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
    input  logic                    i_rx_preamble_pass,
// ---------------------------------------------------------------------------------------------------------------------------------
    input  logic                    i_cfg_enforce_max_rx,
    input  logic                    i_cfg_remove_rx_pad,

    // System Interface
    input  logic                    i_ptp_clk,
    input  logic                    i_tx_rst_n,
    input  logic                    i_tx_rst_n1,
    input  logic                    i_tx_rst_n2,
    input  logic                    i_rx_rst_n,
    input  logic                    i_rx_rst_n1,
    input  logic                    i_rx_rst_n2,

    input  logic                    i_tx_rst_n_rr,
    input  logic                    i_rx_rst_n_rr,

    input  logic                    i_tx_arst_n,
    input  logic                    i_rx_arst_n,

    input  logic                    i_pcs_fully_aligned,
    input  logic                    i_all_ready,

    // AVMM CSR Bank Interface
    output logic [LANES-1:0]        o_tx_error_valid,
    output logic [LANES-1:0][31:0]  o_tx_error,
    output logic [LANES-1:0]        o_rx_error_valid,
    output logic [LANES-1:0][31:0]  o_rx_error,
    input  logic            [31:0]  i_tx_ui,
    input  logic            [31:0]  i_rx_ui,
    input  logic                    i_req_tx_ui_load,
    input  logic                    i_req_rx_ui_load,
    input  logic [19:0]             i_vl_offset_load,
    input  logic [19:0][38:0]       i_vl_offset,

    input  logic            [2:0]   i_ptp_tx_ref_lane,
    input  logic            [2:0]   i_ptp_rx_ref_lane,

    input  logic                    i_ptp_tx_user_cfg_done,
    input  logic                    i_ptp_rx_user_cfg_done,

    output logic            [31:0]  o_ptp_tx_lane_calc_data_constdelay,
    output logic            [31:0]  o_ptp_rx_lane_calc_data_constdelay,
    output logic [LANES-1:0][31:0]  o_ptp_tx_lane_calc_data_offset,
    output logic [LANES-1:0][31:0]  o_ptp_rx_lane_calc_data_offset,
    output logic [LANES-1:0][27:0]  o_ptp_tx_lane_calc_data_time,
    output logic [LANES-1:0][27:0]  o_ptp_rx_lane_calc_data_time,
    output logic [LANES-1:0][19:0]  o_ptp_tx_lane_calc_data_wiredelay,
    output logic [LANES-1:0][19:0]  o_ptp_rx_lane_calc_data_wiredelay,

    // User Interface: TOD Interface
    input  logic            [95:0]  i_ptp_tod,

    // User Interface: PTP Status
    output logic                    o_tx_ptp_offset_data_valid,
    output logic                    o_rx_ptp_offset_data_valid,
    output logic                    o_tx_ptp_ready,
    output logic                    o_rx_ptp_ready,

    // User Interface: TX Framing Interface
    input  logic                    i_tx_early_valid,
    input  logic                    i_tx_valid,
    input  logic [LANES-1:0]        i_tx_inframe,
    input  logic [LANES-1:0]        i_tx_skip_crc,

    // User Interface: TX 1-step Command
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

    // User Interface: TX 2-step Timestamp Request
    input  logic                    i_ptp_ts_req,
    input  logic            [7:0]   i_ptp_fp,

    // User Interface: TX 2-step Timestamp Return
    output logic                    o_ptp_ets_valid,
    output logic            [95:0]  o_ptp_ets,
    output logic            [7:0]   o_ptp_ets_fp,

    // User Interface: RX Timestamp
    output logic            [95:0]  o_ptp_rx_its,
    output logic                    o_ptp_rx_its_valid,

    // EHIP Interface: TX 1-step and 2-step Command
    output logic [LANES-1:0][2:0]   o_ptp_ins_type,
    output logic [LANES-1:0][2:0]   o_ptp_byte_offset,
    output logic            [95:0]  o_ptp_ts,
    output logic            [7:0]   o_ptp_tx_fp,

    // EHIP Interface: TX 2-step Timestamp
    input  logic                    i_ptp_tx_ts_valid,
    input  logic            [47:0]  i_ptp_tx_ts,
    input  logic            [7:0]   i_ptp_tx_fp,

    // EHIP Interface: RX Timestamp
    input  logic                    i_rx_valid,
    input  logic [LANES-1:0]        i_rx_inframe,
    input  logic            [83:0]  i_ptp_rx_ts,

    // EHIP Interface: Reference Timestamp
    output logic [LANES-1:0]        o_sclk,
    output logic [LANES-1:0]        o_tx_sel_sclk_return,
    output logic [LANES-1:0]        o_rx_sel_sclk_return,
    input  logic [LANES-1:0]        i_tx_sclk_return,
    input  logic [LANES-1:0]        i_rx_sclk_return,
    input  logic                    i_tx_am,
    input  logic                    i_rx_am,

    // EHIP Interface: VL Offset Read
    output logic                    o_read_ptp_vl_data,
    output logic            [4:0]   o_select_ptp_vl_data,

    // TAM capture and AM counts
    output logic            [47:0]  o_tx_tam_capture,
    output logic            [15:0]  o_tx_tam_count,
    output logic                    o_tx_tam_cap_valid,
    output logic            [47:0]  o_rx_tam_capture,
    output logic            [15:0]  o_rx_tam_count,
    output logic                    o_rx_tam_cap_valid

);

    localparam SAMPLING_CLK_PERIOD  = 18'h27B80;
    localparam UI                   = 16'h9EE; // 16-bit FNS of 0.038787...ns

    localparam TX_TAM_ADJUST_CONST  = (SAMPLING_CLK_PERIOD * (3 + 2 - 1)) // Subtract: 3 stages of synchronizer for i_tx_sclk_return, 2 stage of TOD sampling delay to meet timing, add 1 to get latest TOD instead of previous cycle
                                      + (SAMPLING_CLK_PERIOD >> 1);       // Subtract: Half cycle for sampling uncertainty

    localparam RX_TAM_ADJUST_CONST  = (SAMPLING_CLK_PERIOD * (3 + 1 - 1))     // Subtract: 3 stages of synchronizer for i_rx_sclk_return, 1 stage of TOD sampling delay to meet timing, add 1 to get latest TOD instead of previous cycle
                                      + (SAMPLING_CLK_PERIOD >> 1);       // Subtract: Half cycle for sampling uncertainty

    localparam TX_TAM_ADJUST_UI     = (242)      // Add: Alignment marker lag
                                      - (32 * 2) // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                      + (10);    // Add: Interleaved start of block header and SOF bits

    localparam TX_TAM_ADJUST_UI_FEC = (32 * 2)   // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                      - (10);    // Add: Interleaved start of block header and SOF bits

    localparam RX_TAM_ADJUST_UI     = (32 * 2)   // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                      + (32)     // Subtract: 1 div32 clock period due to serial data to parallel data delay
                                      - (10);    // Add: Interleaved start of block header and SOF bits

    localparam RX_TAM_ADJUST_UI_FEC = (32 * 2)   // Subtract: 2 div32 clock period due to sclk pulse pipeline delay
                                      + (32)     // Subtract: 1 div32 clock period due to serial data to parallel data delay
                                      + (32)     // Subtract: 1 div32 clock period in RSFEC mode
                                      - (10);    // Add: Interleaved start of block header and SOF bits

    //avoid using DSP because no DSP in S10 NX device
    localparam TX_TAM_ADJUST_NS     = TX_TAM_ADJUST_UI*UI;
    localparam TX_TAM_ADJUST_FEC_NS = TX_TAM_ADJUST_UI_FEC*UI;
    localparam RX_TAM_ADJUST_NS     = RX_TAM_ADJUST_UI*UI;
    localparam RX_TAM_ADJUST_FEC_NS = RX_TAM_ADJUST_UI_FEC*UI;

    localparam PIPE1 = 8;

    genvar i;

    logic [LANES-1:0][95:0] tx_tam;
    logic [LANES-1:0][95:0] rx_tam;
    logic [LANES-1:0]       req_tx_tam_load;
    logic [LANES-1:0]       req_rx_tam_load;
    logic [LANES-1:0][95:0] tx_tam_sel;
    logic [LANES-1:0][95:0] rx_tam_sel;
    logic [LANES-1:0]       req_tx_tam_load_sel;
    logic [LANES-1:0]       req_rx_tam_load_sel;
    logic            [95:0] common_tx_tam;
    logic            [95:0] common_rx_tam;
    logic                   common_req_tx_tam_load;
    logic                   common_req_rx_tam_load;
    logic                   read_ptp_vl_data_hold;

    logic [32-1:0]          rx_ui;
    (* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) logic [PIPE1*16-1:0] tx_ui_r;
    (* altera_attribute = {" -name SYNCHRONIZER_IDENTIFICATION OFF "} *) logic [PIPE1*16-1:0] rx_ui_r;
    logic [LANES-1:0][PIPE1*8-1:0] tx_tam_adjust_ui_r;
    logic [LANES-1:0][PIPE1*8-1:0] rx_tam_adjust_ui_r;

    logic [LANES-1:0][23:0] tx_tam_adjust;
    logic [LANES-1:0][23:0] rx_tam_adjust;

    logic [LANES-1:0][39:0] tx_tam_adjust_r;
    logic [LANES-1:0][39:0] rx_tam_adjust_r;

    logic [LANES-1:0][39:0] tx_tam_adjust_rr;
    logic [LANES-1:0][39:0] rx_tam_adjust_rr;

    logic [LANES-1:0][40:0] tx_tam_adjust_add;
    logic [LANES-1:0][40:0] tx_tam_adjust_sub;
    logic [LANES-1:0][40:0] tx_tam_adjust_total;
    logic [LANES-1:0][40:0] rx_tam_adjust_total;

    logic [LANES-1:0][40:0] tx_tam_adjust_total_r;
    logic [LANES-1:0][40:0] rx_tam_adjust_total_r;

    logic [LANES-1:0][40:0] tx_tam_adjust_total_rr;
    logic [LANES-1:0][40:0] rx_tam_adjust_total_rr;

    logic [LANES-1:0][41:0] tx_tam_adjust_w_err;
    logic [LANES-1:0][41:0] rx_tam_adjust_w_err;

    logic [LANES-1:0][41:0] tx_tam_adjust_w_err_r;
    logic [LANES-1:0][41:0] rx_tam_adjust_w_err_r;

    logic [LANES-1:0][41:0] tx_tam_adjust_final;
    logic [LANES-1:0][41:0] rx_tam_adjust_final;

    logic [LANES-1:0][31:0] tx_tam_adj;
    logic [LANES-1:0][31:0] rx_tam_adj;

    logic [LANES-1:0][31:0] tx_tam_adj_sel;
    logic [LANES-1:0][31:0] rx_tam_adj_sel;

    logic            [31:0] common_tx_tam_adj;
    logic            [31:0] common_rx_tam_adj;

    logic [LANES-1:0] tx_apulse_time_captured;
    logic [LANES-1:0] rx_apulse_time_captured;

    logic [LANES-1:0] tx_calibrate;
    logic [LANES-1:0] rx_calibrate;

    assign o_tx_sel_sclk_return = ~tx_calibrate;
    assign o_rx_sel_sclk_return = ~rx_calibrate;

    always @(posedge i_ptp_clk) begin
        if(!i_tx_rst_n) begin
            o_tx_ptp_offset_data_valid <= 1'b0;
        end
        else begin
            o_tx_ptp_offset_data_valid <= &tx_apulse_time_captured;
        end
    end

    always @(posedge i_ptp_clk) begin
        if(!i_rx_rst_n1) begin
            o_rx_ptp_offset_data_valid <= 1'b0;
            read_ptp_vl_data_hold      <= 1'b0;
        end
        else begin
            o_rx_ptp_offset_data_valid <= &rx_apulse_time_captured & read_ptp_vl_data_hold;

            if(!i_all_ready) begin
                read_ptp_vl_data_hold <= 1'b0;
            end
            else begin
                read_ptp_vl_data_hold <= read_ptp_vl_data_hold | o_read_ptp_vl_data;
            end
        end
    end

    assign o_ptp_tx_lane_calc_data_constdelay = i_enable_rsfec ? {1'b1, 31'(TX_TAM_ADJUST_UI_FEC * UI)}:
                                                                 {1'b0, 31'(TX_TAM_ADJUST_UI     * UI)};
    assign o_ptp_rx_lane_calc_data_constdelay = i_enable_rsfec ? {1'b1, 31'(RX_TAM_ADJUST_UI_FEC * UI)}:
                                                                 {1'b1, 31'(RX_TAM_ADJUST_UI     * UI)};

    generate
        for(i = 0; i < LANES; i++) begin : TAM_ADJUST

            assign o_ptp_tx_lane_calc_data_offset[i][30:0]  = TX_TAM_ADJUST_CONST;
            assign o_ptp_tx_lane_calc_data_offset[i][31]    = 1'b1;
            assign o_ptp_rx_lane_calc_data_offset[i][30:0]  = RX_TAM_ADJUST_CONST;
            assign o_ptp_rx_lane_calc_data_offset[i][31]    = 1'b1;

            always @(posedge i_ptp_clk) begin
                if(!i_tx_rst_n) begin
                    tx_apulse_time_captured[i]           <= 1'b0;
                end
                else begin
                    if(!i_all_ready) begin
                        tx_apulse_time_captured[i]      <= 1'b0;
                    end
                    else if(req_tx_tam_load[i] && !tx_apulse_time_captured[i]) begin
                        tx_apulse_time_captured[i]      <= 1'b1;
                    end
                end
            end

            always @(posedge i_ptp_clk) begin
                if(!i_all_ready) begin
                    o_ptp_tx_lane_calc_data_time[i] <= 28'h0;
                end
                else if(req_tx_tam_load[i] && !tx_apulse_time_captured[i]) begin
                    o_ptp_tx_lane_calc_data_time[i] <= tx_tam[i][27:0];
                end
            end

            assign o_ptp_tx_lane_calc_data_wiredelay[i] = o_tx_error[i][19:0];

            always @(posedge i_ptp_clk) begin
                if(!i_rx_rst_n1) begin
                    rx_apulse_time_captured[i]           <= 1'b0;
                end
                else begin
                    if(!i_all_ready) begin
                        rx_apulse_time_captured[i]      <= 1'b0;
                    end
                    else if(req_rx_tam_load[i] && !rx_apulse_time_captured[i]) begin
                        rx_apulse_time_captured[i]      <= 1'b1;
                    end
                end
            end

            always @(posedge i_ptp_clk) begin
                if(!i_all_ready) begin
                    o_ptp_rx_lane_calc_data_time[i] <= 28'h0;
                end
                else if(req_rx_tam_load[i] && !rx_apulse_time_captured[i]) begin
                    o_ptp_rx_lane_calc_data_time[i] <= rx_tam[i][27:0];
                end
            end

            assign o_ptp_rx_lane_calc_data_wiredelay[i] = o_rx_error[i][19:0];

            always @(posedge i_ptp_clk) begin
                tx_tam_adjust         [i]   <= i_enable_rsfec ? TX_TAM_ADJUST_FEC_NS[23:0] : TX_TAM_ADJUST_NS[23:0];
                tx_tam_adjust_r       [i]   <= {8'h0,tx_tam_adjust[i],8'h0};
                tx_tam_adjust_rr      [i]   <= tx_tam_adjust_r[i];
                tx_tam_adjust_add     [i]   <= {TX_TAM_ADJUST_CONST, 8'h00} + tx_tam_adjust_rr[i];
                tx_tam_adjust_sub     [i]   <= {TX_TAM_ADJUST_CONST, 8'h00} - tx_tam_adjust_rr[i];
                tx_tam_adjust_total   [i]   <= i_enable_rsfec ? tx_tam_adjust_add[i] : tx_tam_adjust_sub[i];
                tx_tam_adjust_total_r [i]   <= tx_tam_adjust_total[i];
                tx_tam_adjust_total_rr[i]   <= tx_tam_adjust_total_r[i];
                tx_tam_adjust_w_err   [i]   <= {o_tx_error[i], 8'h00} + tx_tam_adjust_total_rr[i];
                tx_tam_adjust_w_err_r [i]   <= tx_tam_adjust_w_err[i];
            end

            always @(posedge i_ptp_clk) begin
                rx_tam_adjust         [i]   <= i_enable_rsfec ? RX_TAM_ADJUST_FEC_NS[23:0] : RX_TAM_ADJUST_NS[23:0];
                rx_tam_adjust_r       [i]   <= {8'h0,rx_tam_adjust[i],8'h0};
                rx_tam_adjust_rr      [i]   <= rx_tam_adjust_r[i];
                rx_tam_adjust_total   [i]   <= {RX_TAM_ADJUST_CONST, 8'h00} + rx_tam_adjust_rr[i];
                rx_tam_adjust_total_r [i]   <= rx_tam_adjust_total[i];
                rx_tam_adjust_total_rr[i]   <= rx_tam_adjust_total_r[i];
                rx_tam_adjust_w_err   [i]   <= {o_rx_error[i], 8'h00} + rx_tam_adjust_total_rr[i];
                rx_tam_adjust_w_err_r [i]   <= rx_tam_adjust_w_err[i];
            end

            assign tx_tam_adjust_final[i] = tx_tam_adjust_w_err_r[i];
            assign rx_tam_adjust_final[i] = rx_tam_adjust_w_err_r[i];

// ---------------------------------------------------------------------------------------------------------------------------------
// 10/Dec/2018 : slim35 : https://hsdes.intel.com/appstore/article/#/2205692107 : Crete 3 hard logic costs too much soft logic.
// Reduce alt_ehipc3_fm_sl_ptp_compute_ts pipeline from 12 to 4 and hence the param needs to be revised.
// In addition to pipeline reduction, the new code is using bit31 of correction_value as part of the value instead of signed bit previously.
// Therefore, the bit31 of input correction_value has to be tied to 1'b0 instead of 1'b1.
// The bit31 is previously tied to 1'b1 to always do a subtraction.
// ---------------------------------------------------------------------------------------------------------------------------------
//            assign tx_tam_adj[i] = {1'b1, tx_tam_adjust_final[i][38:8]};
//            assign rx_tam_adj[i] = {1'b1, rx_tam_adjust_final[i][38:8]};
            assign tx_tam_adj[i] = {1'b0, tx_tam_adjust_final[i][38:8]};
            assign rx_tam_adj[i] = {1'b0, rx_tam_adjust_final[i][38:8]};
// ---------------------------------------------------------------------------------------------------------------------------------

        end
    endgenerate

    //flop for timing
    reg [2:0] ptp_tx_ref_lane_r;
    reg [2:0] ptp_rx_ref_lane_r;
    reg [2:0] ptp_tx_ref_lane_rr /* synthesis maxfan = 50 */;
    reg [2:0] ptp_rx_ref_lane_rr /* synthesis maxfan = 50 */;
    always @(posedge i_ptp_clk) begin
        ptp_tx_ref_lane_r <= i_ptp_tx_ref_lane;
        ptp_rx_ref_lane_r <= i_ptp_rx_ref_lane;
        ptp_tx_ref_lane_rr <= ptp_tx_ref_lane_r;
        ptp_rx_ref_lane_rr <= ptp_rx_ref_lane_r;
    end

    assign common_req_tx_tam_load   = req_tx_tam_load[ptp_tx_ref_lane_rr] & i_ptp_tx_user_cfg_done;
    assign common_req_rx_tam_load   = req_rx_tam_load[ptp_rx_ref_lane_rr] & i_ptp_rx_user_cfg_done;
    assign common_tx_tam            = tx_tam[ptp_tx_ref_lane_rr];
    assign common_rx_tam            = rx_tam[ptp_rx_ref_lane_rr];
    assign common_tx_tam_adj        = 32'h0; // User flow adjust this via TX Extra Latency register
    assign common_rx_tam_adj        = 32'h0; // User flow adjust this via RX Extra Latency register

    always @ (posedge i_ptp_clk) begin
        if (!i_tx_rst_n) begin
            req_tx_tam_load_sel <= 4'b0;
        end else begin
            req_tx_tam_load_sel      <= ENABLE_PTP_REF_LANE ? {4{common_req_tx_tam_load}} : req_tx_tam_load;
        end
    end
    always @ (posedge i_ptp_clk) begin
        if (!i_rx_rst_n) begin
            req_rx_tam_load_sel <= 4'b0;
        end else begin
            req_rx_tam_load_sel      <= ENABLE_PTP_REF_LANE ? {4{common_req_rx_tam_load}} : req_rx_tam_load;
        end
    end
    always @ (posedge i_ptp_clk) begin
        tx_tam_sel               <= ENABLE_PTP_REF_LANE ? {4{common_tx_tam}}          : tx_tam;
        rx_tam_sel               <= ENABLE_PTP_REF_LANE ? {4{common_rx_tam}}          : rx_tam;
        tx_tam_adj_sel           <= ENABLE_PTP_REF_LANE ? {4{common_tx_tam_adj}}      : tx_tam_adj;
        rx_tam_adj_sel           <= ENABLE_PTP_REF_LANE ? {4{common_rx_tam_adj}}      : rx_tam_adj;
    end

    alt_ehipc3_fm_ml_ptp_ref_ts_capture #(
        .LANES                  (LANES)
    ) ptp_ref_ts_capture_u (
        .i_enable_rsfec         (i_enable_rsfec),
        .i_clk                  (i_ptp_clk),
        .i_tx_rst_n             (i_tx_rst_n1),
        .i_rx_rst_n             (i_rx_rst_n2),
        .i_tx_rst_n_rr          (i_tx_rst_n_rr),
        .i_rx_rst_n_rr          (i_rx_rst_n_rr),
        .i_pcs_fully_aligned    (i_pcs_fully_aligned),
        .i_all_ready            (i_all_ready),
        .i_ptp_tod              (i_ptp_tod),
        .o_tx_error_valid       (o_tx_error_valid),
        .o_tx_error             (o_tx_error),
        .o_rx_error             (o_rx_error),
        .o_rx_error_valid       (o_rx_error_valid),
        .o_rx_tam               (rx_tam),
        .o_tx_tam               (tx_tam),
        .o_req_tx_tam_load      (req_tx_tam_load),
        .o_req_rx_tam_load      (req_rx_tam_load),
        .o_sclk                 (o_sclk),
        .i_tx_sclk_return       (i_tx_sclk_return),
        .i_tx_am                (i_tx_am),
        .i_rx_sclk_return       (i_rx_sclk_return),
        .i_rx_am                (i_rx_am),
        .o_read_ptp_vl_data     (o_read_ptp_vl_data),
        .o_select_ptp_vl_data   (o_select_ptp_vl_data),
        .o_tx_calibrate         (tx_calibrate),
        .o_rx_calibrate         (rx_calibrate)
    );

    alt_ehipc3_fm_ml_ptp_opcode_writer #(
        .LANES                  (LANES)
    ) ptp_opcode_writer_u (
        .i_enable_rsfec         (i_enable_rsfec),
        .i_tx_preamble_pass     (i_tx_preamble_pass),
        .i_clk                  (i_ptp_clk),
        .i_rst_n                (i_tx_rst_n2),
        .i_pcs_fully_aligned    (i_pcs_fully_aligned),
        .i_ptp_fp               (i_ptp_fp),
        .i_ptp_ins_ets          (i_ptp_ins_ets),
        .i_ptp_ins_cf           (i_ptp_ins_cf),
        .i_ptp_zero_csum        (i_ptp_zero_csum),
        .i_ptp_update_eb        (i_ptp_update_eb),
        .i_ptp_ts_format        (i_ptp_ts_format),
        .i_ptp_asym             (i_ptp_asym),
        .i_ptp_ts_offset        (i_ptp_ts_offset),
        .i_ptp_cf_offset        (i_ptp_cf_offset),
        .i_ptp_csum_offset      (i_ptp_csum_offset),
        .i_ptp_eb_offset        (i_ptp_eb_offset),
        .i_ptp_tx_its           (i_ptp_tx_its),
        .i_ptp_ts_req           (i_ptp_ts_req),
        .i_tx_early_valid       (i_tx_early_valid),
        .i_tx_valid             (i_tx_valid),
        .i_tx_inframe           (i_tx_inframe),
        .i_tx_skip_crc          (i_tx_skip_crc),
        .i_req_tx_tam_load      (req_tx_tam_load_sel),
        .i_req_rx_tam_load      (req_rx_tam_load_sel),
        .i_req_tx_ui_load       (i_req_tx_ui_load),
        .i_req_rx_ui_load       (i_req_rx_ui_load),
        .i_tx_tam               (tx_tam_sel),
        .i_tx_tam_adj           (tx_tam_adj_sel),
        .i_rx_tam_adj           (rx_tam_adj_sel),
        .i_rx_tam               (rx_tam_sel),
        .i_tx_ui                (i_tx_ui),
        .i_rx_ui                (i_rx_ui),
        .i_vl_offset_load       (i_vl_offset_load),
        .i_vl_offset            (i_vl_offset),
        .o_ptp_tx_fp            (o_ptp_tx_fp),
        .o_ptp_ins_type         (o_ptp_ins_type),
        .o_ptp_byte_offset      (o_ptp_byte_offset),
        .o_tx_ptp_ready         (o_tx_ptp_ready),
        .o_rx_ptp_ready         (o_rx_ptp_ready),
        .o_ptp_ts               (o_ptp_ts)
    );

    alt_ehipc3_fm_ml_ptp_ts_converter #(
        .LANES                  (LANES)
    ) ptp_ts_converter_u (
        .i_clk                  (i_ptp_clk),
        .i_tx_rst_n             (i_tx_rst_n),
        .i_rx_rst_n             (i_rx_rst_n),
        .i_cfg_enforce_max_rx   (i_cfg_enforce_max_rx),
        .i_cfg_remove_rx_pad    (i_cfg_remove_rx_pad),
        .i_rx_preamble_pass     (i_rx_preamble_pass),
        .i_ptp_tx_ts_valid      (i_ptp_tx_ts_valid),
        .i_ptp_tx_ts            (i_ptp_tx_ts),
        .i_ptp_tx_fp            (i_ptp_tx_fp),
        .i_rx_am                (i_rx_am),
        .i_rx_valid             (i_rx_valid),
        .i_rx_inframe           (i_rx_inframe),
        .i_ptp_rx_ts            (i_ptp_rx_ts),
        .i_tod                  (i_ptp_tod),
        .o_ptp_ets_valid        (o_ptp_ets_valid),
        .o_ptp_ets              (o_ptp_ets),
        .o_ptp_ets_fp           (o_ptp_ets_fp),
        .o_ptp_rx_its           (o_ptp_rx_its),
        .o_ptp_rx_its_valid     (o_ptp_rx_its_valid)
    );

    alt_ehipc3_fm_sl_ptp_tam_capture_count_sn ptp_tam_capture_count_u(
        .i_tx_clk               (i_ptp_clk),
        .i_tx_rst_n             (i_tx_rst_n),
        .i_tx_tam               (tx_tam[0][47:0]),
        .i_tx_tam_load          (req_tx_tam_load[0]),
        .o_tx_tam_capture       (o_tx_tam_capture),
        .o_tx_tam_count         (o_tx_tam_count),
        .o_tx_tam_cap_valid     (o_tx_tam_cap_valid),
        .i_rx_clk               (i_ptp_clk),
        .i_rx_rst_n             (i_rx_rst_n),
        .i_rx_tam               (rx_tam[0][47:0]),
        .i_rx_tam_load          (req_rx_tam_load[0]),
        .o_rx_tam_capture       (o_rx_tam_capture),
        .o_rx_tam_count         (o_rx_tam_count),
        .o_rx_tam_cap_valid     (o_rx_tam_cap_valid)
    );

endmodule
