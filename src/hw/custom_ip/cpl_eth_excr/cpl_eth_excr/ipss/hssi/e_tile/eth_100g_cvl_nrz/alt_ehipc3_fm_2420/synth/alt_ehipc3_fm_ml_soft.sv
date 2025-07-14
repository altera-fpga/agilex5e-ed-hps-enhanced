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


`timescale 1ps/1ps

module alt_ehipc3_fm_ml_soft #(
    parameter core_variant  = 0,
    parameter active_channel= 0,
    parameter ENABLE_PTP    = 0,
    parameter LANES         = 4,
    parameter ENABLE_PTP_REF_LANE = 1
) (
    // Configuration
    input  wire                     i_enable_rsfec,
    input  wire                     i_tx_preamble_pass,
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
    input  logic                    i_rx_preamble_pass,
// ---------------------------------------------------------------------------------------------------------------------------------
    input  wire                     i_cfg_enforce_max_rx,
    input  wire                     i_cfg_remove_rx_pad,

    // Clock
    input  wire                     i_reconfig_clk,
    input  wire                     i_ml_clk_tx,
    input  wire                     i_ml_clk_rx,

    // Reset
    input  wire                     i_reconfig_reset,
    input  wire                     i_ml_ehip_tx_reset,
    input  wire                     i_ml_ehip_rx_reset,

    // Status Input
    input  wire [LANES-1:0]         i_ml_tx_pma_ready,
    input  wire [LANES-1:0]         i_ml_rx_pma_ready,
    input  wire [LANES-1:0]         i_ml_rx_transfer_ready,
    input  wire [LANES-1:0]         i_ml_tx_transfer_ready,
    input  wire                     i_ml_tx_lanes_stable,
    input  wire                     i_ml_rx_pcs_fully_aligned,
    input  wire                     i_ml_ehip_ready,

    // TX Data Path
    input  wire                     i_ml_tx_early_valid,
    input  wire                     i_ml_tx_valid,
    input  wire [LANES-1:0][63:0]   i_ml_tx_data,
    input  wire [LANES-1:0]         i_ml_tx_inframe,
    input  wire [LANES-1:0][2:0]    i_ml_tx_empty,
    input  wire [LANES-1:0]         i_ml_tx_error,
    input  wire [LANES-1:0]         i_ml_tx_skip_crc,

    output wire                     o_ml_tx_valid,
    output wire [LANES-1:0][63:0]   o_ml_tx_data,
    output wire [LANES-1:0]         o_ml_tx_inframe,
    output wire [LANES-1:0][2:0]    o_ml_tx_empty,
    output wire [LANES-1:0]         o_ml_tx_error,
    output wire [LANES-1:0]         o_ml_tx_skip_crc,

    // RX Data Path
    input  wire                     i_ml_rx_valid,
    input  wire [LANES-1:0][63:0]   i_ml_rx_data,
    input  wire [LANES-1:0]         i_ml_rx_inframe,
    input  wire [LANES-1:0][2:0]    i_ml_rx_empty,
    input  wire [LANES-1:0][1:0]    i_ml_rx_error,
    input  wire [LANES-1:0]         i_ml_rx_fcs_error,
    input  wire [LANES-1:0][2:0]    i_ml_rx_status,

    output wire                     o_ml_rx_valid,
    output wire [LANES-1:0][63:0]   o_ml_rx_data,
    output wire [LANES-1:0]         o_ml_rx_inframe,
    output wire [LANES-1:0][2:0]    o_ml_rx_empty,
    output wire [LANES-1:0][1:0]    o_ml_rx_error,
    output wire [LANES-1:0]         o_ml_rx_fcs_error,
    output wire [LANES-1:0][2:0]    o_ml_rx_status,

    // PTP
    // User Interface: TOD Interface
    input  wire            [95:0]   i_ptp_tod,

    // User Interface: PTP Status
    output wire                     o_ml_tx_ptp_offset_data_valid,
    output wire                     o_ml_rx_ptp_offset_data_valid,
    output wire                     o_ml_tx_ptp_ready,
    output wire                     o_ml_rx_ptp_ready,

    // User Interface: TX 1-step Command
    input  wire                     i_ml_ptp_ins_ets,
    input  wire                     i_ml_ptp_ins_cf,
    input  wire                     i_ml_ptp_ins_zero_csum,
    input  wire                     i_ml_ptp_ins_update_eb,
    input  wire                     i_ml_ptp_ts_format,
    input  wire            [15:0]   i_ml_ptp_ts_offset,
    input  wire            [15:0]   i_ml_ptp_cf_offset,
    input  wire            [15:0]   i_ml_ptp_csum_offset,
    input  wire            [15:0]   i_ml_ptp_eb_offset,
    input  wire            [95:0]   i_ml_ptp_tx_its,

    // User Interface: TX 2-step Timestamp Request
    input  wire                     i_ml_ptp_ts_req,
    input  wire            [7:0]    i_ml_ptp_fp,

    // User Interface: TX 2-step Timestamp Return
    output wire                     o_ml_ptp_ets_valid,
    output wire            [95:0]   o_ml_ptp_ets,
    output wire            [7:0]    o_ml_ptp_ets_fp,

    // User Interface: RX Timestamp
    output wire            [95:0]   o_ml_ptp_rx_its,
    output wire                     o_ml_ptp_rx_its_valid,

    // EHIP Interface: TX 1-step and 2-step Command
    output logic [LANES-1:0][2:0]    o_ml_ptp_ins_type,
    output logic [LANES-1:0][2:0]    o_ml_ptp_byte_offset,
    output logic            [95:0]   o_ml_ptp_ts,
    output logic            [7:0]    o_ml_ptp_tx_fp,


    // EHIP Interface: TX 2-step Timestamp
    input  wire                     i_ml_ptp_tx_ts_valid,
    input  wire            [47:0]   i_ml_ptp_tx_ts,
    input  wire            [7:0]    i_ml_ptp_tx_ts_fp,

    // EHIP Interface: RX Timestamp
    input  wire            [83:0]   i_ml_ptp_rx_ts,

    // EHIP Interface: Reference Timestamp
    output wire [LANES-1:0]         o_ml_sclk,
    output wire [LANES-1:0]         o_ml_tx_sel_sclk_return,
    output wire [LANES-1:0]         o_ml_rx_sel_sclk_return,
    input  wire [LANES-1:0]         i_ml_tx_sclk_return,
    input  wire [LANES-1:0]         i_ml_rx_sclk_return,
    input  wire                     i_ml_tx_am,
    input  wire                     i_ml_rx_am,

    // EHIP Interface: VL Offset Read
    output logic                     o_read_ptp_vl_data,
    output logic            [4:0]    o_select_ptp_vl_data,
    input  wire                     i_reading_ptp_vl_data,

    // AVMM Interface: PTP
    output wire            [31:0]   o_ml_avmm_readdata,
    input  wire                     i_ml_avmm_write,
    input  wire                     i_ml_avmm_read,
    input  wire            [31:0]   i_ml_avmm_writedata,
    output wire                     o_ml_avmm_waitrequest,
    output wire                     o_ml_avmm_readdatavalid,
    input  wire            [7:0]    i_ml_avmm_address
);

    localparam TX_PTP_DLY = 1+4; // 1 cycles delay to detect early_warning, another 4 due to PTP command process
// ---------------------------------------------------------------------------------------------------------------------------------
// 10/Dec/2018 : slim35 : https://hsdes.intel.com/appstore/article/#/2205692107 : Crete 3 hard logic costs too much soft logic.
// Reduce alt_ehipc3_fm_sl_ptp_compute_ts pipeline from 12 to 4 and hence the param needs to be revised.
// ---------------------------------------------------------------------------------------------------------------------------------
//    localparam RX_PTP_DLY = 1+12; // 1 cycles delay to combine RX ingress timestamp with TOD, 12 cycles delay for 330 UI timestamp adjustment under specific condition
    localparam RX_PTP_DLY = 1+4; // 1 cycles delay to combine RX ingress timestamp with TOD, 4 cycles delay for 330 UI timestamp adjustment under specific condition
// ---------------------------------------------------------------------------------------------------------------------------------

    genvar i;
 wire                                    reconfig_reset_sync_reconfig_clk;
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : load_vl_offset_cc & load_tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//    wire                                    reconfig_reset_sync_tx_clk;
    wire                                    ehip_tx_reset_sync_sync_reconfig_clk;
    wire                                    ehip_rx_reset_sync_sync_reconfig_clk;
// ---------------------------------------------------------------------------------------------------------------------------------
    wire                                    ehip_tx_reset_sync_wire;
    wire                                    ehip_rx_reset_sync_wire;
    reg                                     ehip_tx_reset_sync_r/* synthesis preserve */;
    reg                                     ehip_tx_reset_async_r/* synthesis preserve */;
    reg                                     ehip_rx_reset_sync_r/* synthesis preserve */;
    reg                                     ehip_rx_reset_async_r/* synthesis preserve */;
    reg                                     ehip_tx_reset_sync_rr;
    reg                                     ehip_tx_reset_async_rr;
    reg                                     ehip_rx_reset_sync_rr;
    reg                                     ehip_rx_reset_async_rr;
    reg                                     ehip_tx_reset_sync_rrr;
    reg                                     ehip_tx_reset_async_rrr;
    reg                                     ehip_rx_reset_sync_rrr;
    reg                                     ehip_rx_reset_async_rrr;
    reg                                     ehip_tx_reset_sync_rrrr;
    reg                                     ehip_tx_reset_async_rrrr;
    reg                                     ehip_rx_reset_sync_rrrr;
    reg                                     ehip_rx_reset_async_rrrr;
    reg                                     ehip_tx_reset_sync;
    reg                                     ehip_tx_reset_async;
    reg                                     ehip_rx_reset_sync;
    reg                                     ehip_rx_reset_async;


    wire                 [LANES-1:0]        tx_pma_ready_sync;
    wire                 [LANES-1:0]        rx_pma_ready_sync;
    wire                 [LANES-1:0]        tx_transfer_ready_sync;
    wire                 [LANES-1:0]        rx_transfer_ready_sync;
    wire                                    rx_pcs_fully_aligned_sync;
    wire                                    ehip_ready_sync;

    reg                  [LANES-1:0]        tx_pma_ready_sync_r;
    reg                  [LANES-1:0]        rx_pma_ready_sync_r;
    reg                  [LANES-1:0]        tx_transfer_ready_sync_r;
    reg                  [LANES-1:0]        rx_transfer_ready_sync_r;
    reg                                     rx_pcs_fully_aligned_sync_r;
    reg                                     rx_pcs_fully_aligned_sync_rr/* synthesis maxfan = 20 */;
    reg                                     ehip_ready_sync_r;
    reg                                     ehip_ready_sync_rr;

    reg                                     all_ready;
    reg                                     all_ready_r;

    reg  [TX_PTP_DLY-1:0][LANES-1:0][63:0]  ptp_dly_tx_data;
    reg  [TX_PTP_DLY-1:0][LANES-1:0]        ptp_dly_tx_inframe;
    reg  [TX_PTP_DLY-1:0][LANES-1:0][2:0]   ptp_dly_tx_empty;
    reg  [TX_PTP_DLY-1:0][LANES-1:0]        ptp_dly_tx_error;
    reg  [TX_PTP_DLY-1:0][LANES-1:0]        ptp_dly_tx_skip_crc;

    reg                                     ptp_tx_valid;
    reg                  [LANES-1:0][63:0]  ptp_tx_data;
    reg                  [LANES-1:0]        ptp_tx_inframe;
    reg                  [LANES-1:0][2:0]   ptp_tx_empty;
    reg                  [LANES-1:0]        ptp_tx_error;
    reg                  [LANES-1:0]        ptp_tx_skip_crc;

    reg                                     ptp_tx_valid_r;
    reg                  [LANES-1:0][63:0]  ptp_tx_data_r;
    reg                  [LANES-1:0]        ptp_tx_inframe_r;
    reg                  [LANES-1:0][2:0]   ptp_tx_empty_r;
    reg                  [LANES-1:0]        ptp_tx_error_r;
    reg                  [LANES-1:0]        ptp_tx_skip_crc_r;

    reg  [RX_PTP_DLY-1:0]                   ptp_dly_rx_valid;
    reg  [RX_PTP_DLY-1:0][LANES-1:0][63:0]  ptp_dly_rx_data;
    reg  [RX_PTP_DLY-1:0][LANES-1:0]        ptp_dly_rx_inframe;
    reg  [RX_PTP_DLY-1:0][LANES-1:0][2:0]   ptp_dly_rx_empty;
    reg  [RX_PTP_DLY-1:0][LANES-1:0][1:0]   ptp_dly_rx_error;
    reg  [RX_PTP_DLY-1:0][LANES-1:0]        ptp_dly_rx_fcs_error;
    reg  [RX_PTP_DLY-1:0][LANES-1:0][2:0]   ptp_dly_rx_status;

    wire                                    ptp_rx_valid;
    wire                 [LANES-1:0][63:0]  ptp_rx_data;
    wire                 [LANES-1:0]        ptp_rx_inframe;
    wire                 [LANES-1:0][2:0]   ptp_rx_empty;
    wire                 [LANES-1:0][1:0]   ptp_rx_error;
    wire                 [LANES-1:0]        ptp_rx_fcs_error;
    wire                 [LANES-1:0][2:0]   ptp_rx_status;

    reg                       [19:0][35:0]  vl_offset_data;
    reg                       [19:0]        vl_offset_valid_shift;
    wire                                    vl_offset_data_valid;
    wire                      [19:0]        vl_offset_load;
    wire                      [19:0][38:0]  vl_offset;

    wire                            [2:0]   ptp_tx_ref_lane;
    wire                            [2:0]   ptp_rx_ref_lane;
    wire                            [2:0]   ptp_tx_ref_lane_sync;
    wire                            [2:0]   ptp_rx_ref_lane_sync;

    wire                                    ptp_tx_user_cfg_done;
    wire                                    ptp_rx_user_cfg_done;
    wire                                    ptp_tx_user_cfg_done_sync;
    wire                                    ptp_rx_user_cfg_done_sync;

    wire                            [31:0]  ptp_tx_lane_calc_data_constdelay;
    wire                            [31:0]  ptp_rx_lane_calc_data_constdelay;
    wire                 [LANES-1:0][31:0]  ptp_tx_lane_calc_data_offset;
    wire                 [LANES-1:0][31:0]  ptp_rx_lane_calc_data_offset;
    wire                 [LANES-1:0][27:0]  ptp_tx_lane_calc_data_time;
    wire                 [LANES-1:0][27:0]  ptp_rx_lane_calc_data_time;
    wire                 [LANES-1:0][19:0]  ptp_tx_lane_calc_data_wiredelay;
    wire                 [LANES-1:0][19:0]  ptp_rx_lane_calc_data_wiredelay;

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (LANES),
        .INIT_VALUE         (0)
    ) tx_pma_ready_std_sync (
        .clk                (i_ml_clk_tx),
        .reset              (1'b0),
        .d                  (i_ml_tx_pma_ready),
        .q                  (tx_pma_ready_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (LANES),
        .INIT_VALUE         (0)
    ) rx_pma_ready_std_sync (
        .clk                (i_ml_clk_tx),
        .reset              (1'b0),
        .d                  (i_ml_rx_pma_ready),
        .q                  (rx_pma_ready_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (LANES),
        .INIT_VALUE         (0)
    ) tx_transfer_ready_std_sync (
        .clk                (i_ml_clk_tx),
        .reset              (1'b0),
        .d                  (i_ml_tx_transfer_ready),
        .q                  (tx_transfer_ready_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (LANES),
        .INIT_VALUE         (0)
    ) rx_transfer_ready_std_sync (
        .clk                (i_ml_clk_tx),
        .reset              (1'b0),
        .d                  (i_ml_rx_transfer_ready),
        .q                  (rx_transfer_ready_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_pcs_fully_aligned_std_sync (
        .clk                (i_ml_clk_tx),
        .reset              (1'b0),
        .d                  (i_ml_rx_pcs_fully_aligned),
        .q                  (rx_pcs_fully_aligned_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) ehip_ready_std_sync (
        .clk                (i_ml_clk_tx),
        .reset              (1'b0),
        .d                  (i_ml_ehip_ready),
        .q                  (ehip_ready_sync)
    );

    logic tx_pma_ready_sync_all;
    logic rx_pma_ready_sync_all;
    logic tx_transfer_ready_sync_all;
    logic rx_transfer_ready_sync_all;
    always @(posedge i_ml_clk_tx) begin
        if(ehip_tx_reset_sync) begin
            tx_pma_ready_sync_r <= {LANES{1'b0}};
            rx_pma_ready_sync_r <= {LANES{1'b0}};
            tx_transfer_ready_sync_r <= {LANES{1'b0}};
            rx_transfer_ready_sync_r <= {LANES{1'b0}};
            rx_pcs_fully_aligned_sync_r <= 1'b0;
            rx_pcs_fully_aligned_sync_rr <= 1'b0;
            ehip_ready_sync_r <= 1'b0;
            ehip_ready_sync_rr <= 1'b0;

            tx_pma_ready_sync_all <= 1'b0;
            rx_pma_ready_sync_all <= 1'b0;
            tx_transfer_ready_sync_all <= 1'b0;
            rx_transfer_ready_sync_all <= 1'b0;

            all_ready_r <= 1'b0;
            all_ready <= 1'b0;
        end
        else begin
            tx_pma_ready_sync_r <= tx_pma_ready_sync;
            rx_pma_ready_sync_r <= rx_pma_ready_sync;
            tx_transfer_ready_sync_r <= tx_transfer_ready_sync;
            rx_transfer_ready_sync_r <= rx_transfer_ready_sync;
            rx_pcs_fully_aligned_sync_r <= rx_pcs_fully_aligned_sync;
            rx_pcs_fully_aligned_sync_rr <= rx_pcs_fully_aligned_sync_r;
            ehip_ready_sync_r <= ehip_ready_sync;
            ehip_ready_sync_rr <= ehip_ready_sync_r;

            tx_pma_ready_sync_all <= &tx_pma_ready_sync_r;
            rx_pma_ready_sync_all <= &rx_pma_ready_sync_r;
            tx_transfer_ready_sync_all <= &tx_transfer_ready_sync_r;
            rx_transfer_ready_sync_all <= &rx_transfer_ready_sync_r;

            all_ready_r <= (tx_pma_ready_sync_all) &&
                         (rx_pma_ready_sync_all) &&
                         (tx_transfer_ready_sync_all) &&
                         (tx_transfer_ready_sync_all) &&
                         rx_pcs_fully_aligned_sync_rr &&
                         ehip_ready_sync_rr;
            all_ready <= all_ready_r;
        end
    end

    assign o_ml_tx_valid        = ENABLE_PTP ? ptp_tx_valid    : i_ml_tx_valid;
    assign o_ml_tx_data         = ENABLE_PTP ? ptp_tx_data     : i_ml_tx_data;
    assign o_ml_tx_inframe      = ENABLE_PTP ? ptp_tx_inframe  : i_ml_tx_inframe;
    assign o_ml_tx_empty        = ENABLE_PTP ? ptp_tx_empty    : i_ml_tx_empty;
    assign o_ml_tx_error        = ENABLE_PTP ? ptp_tx_error    : i_ml_tx_error;
    assign o_ml_tx_skip_crc     = ENABLE_PTP ? ptp_tx_skip_crc : i_ml_tx_skip_crc;

    assign o_ml_rx_valid        = ENABLE_PTP ? ptp_rx_valid    : i_ml_rx_valid;
    assign o_ml_rx_data         = ENABLE_PTP ? ptp_rx_data     : i_ml_rx_data;
    assign o_ml_rx_inframe      = ENABLE_PTP ? ptp_rx_inframe  : i_ml_rx_inframe;
    assign o_ml_rx_empty        = ENABLE_PTP ? ptp_rx_empty    : i_ml_rx_empty;
    assign o_ml_rx_error        = ENABLE_PTP ? ptp_rx_error    : i_ml_rx_error;
    assign o_ml_rx_fcs_error    = ENABLE_PTP ? ptp_rx_fcs_error: i_ml_rx_fcs_error;
    assign o_ml_rx_status       = ENABLE_PTP ? ptp_rx_status   : i_ml_rx_status;

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (1)
    ) reconfig_reset_sync_reconfig_clk_i (
        .clk                (i_reconfig_clk),
        .reset              (1'b0),
        .d                  (i_reconfig_reset),
        .q                  (reconfig_reset_sync_reconfig_clk)
    );
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : load_vl_offset_cc & load_tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//    alt_xcvr_resync_std #(
//        .SYNC_CHAIN_LENGTH  (3),
//        .WIDTH              (1),
//        .INIT_VALUE         (1)
//    ) reconfig_reset_sync_tx_clk_i (
//        .clk                (i_ml_clk_tx),
//        .reset              (reconfig_reset_sync_reconfig_clk),
//        .d                  (1'b0),
//        .q                  (reconfig_reset_sync_tx_clk)
//    );


    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (1)
    ) ehip_tx_reset_sync_sync_reconfig_clk_resync_inst (
        .clk                (i_reconfig_clk),
        .reset              (ehip_tx_reset_async),
        .d                  (1'b0),
        .q                  (ehip_tx_reset_sync_sync_reconfig_clk)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (1)
    ) ehip_rx_reset_sync_sync_reconfig_clk_resync_inst (
        .clk                (i_reconfig_clk),
        .reset              (ehip_rx_reset_async),
        .d                  (1'b0),
        .q                  (ehip_rx_reset_sync_sync_reconfig_clk)
    );
// ---------------------------------------------------------------------------------------------------------------------------------
    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_reset_sync_tx_clk (
        .clk                (i_ml_clk_tx),
        .reset              (1'b0),
        .d                  (i_ml_ehip_tx_reset),
        .q                  (ehip_tx_reset_sync_wire)
    );

    // Additional flop for better timing
    always @(posedge i_ml_clk_tx) begin
        ehip_tx_reset_sync_r      <= ehip_tx_reset_sync_wire;
        ehip_tx_reset_async_r     <= ehip_tx_reset_sync_wire;
        ehip_tx_reset_sync_rr     <= ehip_tx_reset_sync_r;
        ehip_tx_reset_async_rr    <= ehip_tx_reset_async_r;
        ehip_tx_reset_sync_rrr    <= ehip_tx_reset_sync_rr;
        ehip_tx_reset_async_rrr   <= ehip_tx_reset_async_rr;
        ehip_tx_reset_sync_rrrr   <= ehip_tx_reset_sync_rrr;
        ehip_tx_reset_async_rrrr  <= ehip_tx_reset_async_rrr;
        ehip_tx_reset_sync        <= ehip_tx_reset_sync_rrrr;
        ehip_tx_reset_async       <= ehip_tx_reset_async_rrrr;
    end

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_reset_sync_rx_clk (
        .clk                (i_ml_clk_rx),
        .reset              (1'b0),
        .d                  (i_ml_ehip_rx_reset),
        .q                  (ehip_rx_reset_sync_wire)
    );

    // Additional flop for better timing
    always @(posedge i_ml_clk_rx) begin
        ehip_rx_reset_sync_r      <= ehip_rx_reset_sync_wire;
        ehip_rx_reset_async_r     <= ehip_rx_reset_sync_wire;
        ehip_rx_reset_sync_rr     <= ehip_rx_reset_sync_r;
        ehip_rx_reset_async_rr    <= ehip_rx_reset_async_r;
        ehip_rx_reset_sync_rrr    <= ehip_rx_reset_sync_rr;
        ehip_rx_reset_async_rrr   <= ehip_rx_reset_async_rr;
        ehip_rx_reset_sync_rrrr   <= ehip_rx_reset_sync_rrr;
        ehip_rx_reset_async_rrrr  <= ehip_rx_reset_async_rrr;
        ehip_rx_reset_sync        <= ehip_rx_reset_sync_rrrr;
        ehip_rx_reset_async       <= ehip_rx_reset_async_rrrr;
    end

    wire  [31:0]            sptp_tx_ui;
    wire  [31:0]            sptp_rx_ui;
    wire                    sptp_req_tx_ui_load;
    wire                    sptp_req_rx_ui_load;
    wire  [31:0]            sptp_tx_ui_cc;
    wire  [31:0]            sptp_rx_ui_cc;
    wire                    sptp_req_tx_ui_load_cc;
    wire                    sptp_req_rx_ui_load_cc;

    wire  [19:0]            sptp_vl_offset_load_cc;
    wire  [19:0][38:0]      sptp_vl_offset_cc;

    // TAM capture and AM counts
    wire  [47:0]            tx_tam_capture;
    wire  [15:0]            tx_tam_count;
    wire                    tx_tam_cap_valid;
    wire  [47:0]            rx_tam_capture;
    wire  [15:0]            rx_tam_count;
    wire                    rx_tam_cap_valid;

    wire  [47:0]            tx_tam_capture_cc;
    wire  [15:0]            tx_tam_count_cc;
    wire                    tx_tam_cap_valid_cc;
    wire  [47:0]            rx_tam_capture_cc;
    wire  [15:0]            rx_tam_count_cc;
    wire                    rx_tam_cap_valid_cc;

    generate
    if (((core_variant == 3) && (active_channel == 1)) &&
        (ENABLE_PTP != 0))
    begin : ML_PTP

        always @(posedge i_ml_clk_tx) begin
            if(ehip_tx_reset_sync) begin
                ptp_dly_tx_inframe  <= {(TX_PTP_DLY*LANES){1'b0}};
                ptp_dly_tx_empty    <= {(TX_PTP_DLY*LANES){3'h0}};
                ptp_dly_tx_error    <= {(TX_PTP_DLY*LANES){1'b0}};
                ptp_dly_tx_skip_crc <= {(TX_PTP_DLY*LANES){1'b0}};

                ptp_tx_valid_r        <= 1'b0;
                ptp_tx_inframe_r      <= {(LANES){1'b0}};
                ptp_tx_empty_r        <= {(LANES){3'h0}};
                ptp_tx_error_r        <= {(LANES){1'b0}};
                ptp_tx_skip_crc_r     <= {(LANES){1'b0}};

                ptp_tx_valid        <= 1'b0;
                ptp_tx_inframe      <= {(LANES){1'b0}};
                ptp_tx_empty        <= {(LANES){3'h0}};
                ptp_tx_error        <= {(LANES){1'b0}};
                ptp_tx_skip_crc     <= {(LANES){1'b0}};
            end
            else begin
                if(i_ml_tx_valid) begin
                    ptp_dly_tx_inframe  <= {ptp_dly_tx_inframe  [TX_PTP_DLY-2:0], i_ml_tx_inframe};
                    ptp_dly_tx_empty    <= {ptp_dly_tx_empty    [TX_PTP_DLY-2:0], i_ml_tx_empty};
                    ptp_dly_tx_error    <= {ptp_dly_tx_error    [TX_PTP_DLY-2:0], i_ml_tx_error};
                    ptp_dly_tx_skip_crc <= {ptp_dly_tx_skip_crc [TX_PTP_DLY-2:0], i_ml_tx_skip_crc};
                end

                ptp_tx_valid_r     <= i_ml_tx_valid;
                ptp_tx_inframe_r    <= ptp_dly_tx_inframe    [TX_PTP_DLY-1];
                ptp_tx_empty_r      <= ptp_dly_tx_empty      [TX_PTP_DLY-1];
                ptp_tx_error_r      <= ptp_dly_tx_error      [TX_PTP_DLY-1];
                ptp_tx_skip_crc_r   <= ptp_dly_tx_skip_crc   [TX_PTP_DLY-1];

                ptp_tx_valid     <= ptp_tx_valid_r;
                ptp_tx_inframe   <= ptp_tx_inframe_r;
                ptp_tx_empty     <= ptp_tx_empty_r;
                ptp_tx_error     <= ptp_tx_error_r;
                ptp_tx_skip_crc  <= ptp_tx_skip_crc_r;
            end
        end

        always @(posedge i_ml_clk_tx) begin
            if(i_ml_tx_valid) begin
                ptp_dly_tx_data     <= {ptp_dly_tx_data     [TX_PTP_DLY-2:0], i_ml_tx_data};
            end

            ptp_tx_data_r      <= ptp_dly_tx_data       [TX_PTP_DLY-1];
            ptp_tx_data        <= ptp_tx_data_r;
        end

        always @(posedge i_ml_clk_rx) begin
            if(ehip_rx_reset_sync) begin
                ptp_dly_rx_valid     <= {(RX_PTP_DLY*LANES){1'b0}};
                ptp_dly_rx_inframe   <= {(RX_PTP_DLY*LANES){1'b0}};
                ptp_dly_rx_empty     <= {(RX_PTP_DLY*LANES){3'h0}};
                ptp_dly_rx_error     <= {(RX_PTP_DLY*LANES){2'b0}};
                ptp_dly_rx_fcs_error <= {(RX_PTP_DLY*LANES){1'b0}};
                ptp_dly_rx_status    <= {(RX_PTP_DLY*LANES){3'b0}};
            end
            else begin
                if(i_ml_rx_valid) begin
                    ptp_dly_rx_valid     <= {ptp_dly_rx_valid    [RX_PTP_DLY-2:0], i_ml_rx_valid};
                    ptp_dly_rx_inframe   <= {ptp_dly_rx_inframe  [RX_PTP_DLY-2:0], i_ml_rx_inframe};
                    ptp_dly_rx_empty     <= {ptp_dly_rx_empty    [RX_PTP_DLY-2:0], i_ml_rx_empty};
                    ptp_dly_rx_error     <= {ptp_dly_rx_error    [RX_PTP_DLY-2:0], i_ml_rx_error};
                    ptp_dly_rx_fcs_error <= {ptp_dly_rx_fcs_error[RX_PTP_DLY-2:0], i_ml_rx_fcs_error};
                    ptp_dly_rx_status    <= {ptp_dly_rx_status   [RX_PTP_DLY-2:0], i_ml_rx_status};
                end
            end
        end

        always @(posedge i_ml_clk_rx) begin
            if(i_ml_rx_valid) begin
                ptp_dly_rx_data      <= {ptp_dly_rx_data     [RX_PTP_DLY-2:0], i_ml_rx_data};
            end
        end

        assign ptp_rx_valid     = ptp_dly_rx_valid      [RX_PTP_DLY-1] && i_ml_rx_valid;
        assign ptp_rx_data      = ptp_dly_rx_data       [RX_PTP_DLY-1];
        assign ptp_rx_inframe   = ptp_dly_rx_inframe    [RX_PTP_DLY-1];
        assign ptp_rx_empty     = ptp_dly_rx_empty      [RX_PTP_DLY-1];
        assign ptp_rx_error     = ptp_dly_rx_error      [RX_PTP_DLY-1];
        assign ptp_rx_fcs_error = ptp_dly_rx_fcs_error  [RX_PTP_DLY-1];
        assign ptp_rx_status    = ptp_dly_rx_status     [RX_PTP_DLY-1];

        always @(posedge i_ml_clk_rx) begin
            if(ehip_rx_reset_sync) begin
                vl_offset_data        <= {(20*36){1'b0}};
                vl_offset_valid_shift <= 20'h0;
            end
            else begin
                if(!rx_pcs_fully_aligned_sync_rr) begin
                    vl_offset_valid_shift <= 20'h0;
                end
                else if(i_reading_ptp_vl_data) begin
                    vl_offset_data        <= {vl_offset_data[18:0], i_ml_ptp_rx_ts[52:17]};
                    vl_offset_valid_shift <= {vl_offset_valid_shift[18:0], 1'b1};
                end
            end
        end

        assign vl_offset_data_valid = vl_offset_valid_shift[19];

        alt_ehipc3_fm_ml_ptp_avmm_csr_bank ptp_csr_bank (
            .i_avmm_clk             (i_reconfig_clk),
            .i_avmm_rst_n           (!reconfig_reset_sync_reconfig_clk),
            .o_avmm_readdata        (o_ml_avmm_readdata),
            .i_avmm_write           (i_ml_avmm_write),
            .i_avmm_read            (i_ml_avmm_read),
            .i_avmm_writedata       (i_ml_avmm_writedata),
            .o_avmm_waitrequest     (o_ml_avmm_waitrequest),
            .o_avmm_readdatavalid   (o_ml_avmm_readdatavalid),
            .i_avmm_address         (i_ml_avmm_address),

            .i_tx_tam_capture       (tx_tam_capture_cc),
            .i_tx_tam_count         (tx_tam_count_cc),
            .i_tx_tam_cap_valid     (tx_tam_cap_valid_cc),
            .i_rx_tam_capture       (rx_tam_capture_cc),
            .i_rx_tam_count         (rx_tam_count_cc),
            .i_rx_tam_cap_valid     (rx_tam_cap_valid_cc),

            .o_calibrate            (),
            .i_tx_calibrate_done    (o_ml_tx_sel_sclk_return[0]),
            .i_rx_calibrate_done    (o_ml_rx_sel_sclk_return[0]),
            .i_tx_error_valid       (1'b0),
            .i_tx_error             (32'h0),
            .i_rx_error_valid       (1'b0),
            .i_rx_error             (32'h0),
            .i_rx_pcs_fully_aligned (i_ml_rx_pcs_fully_aligned),
            .i_vl_offset_data_valid (vl_offset_data_valid),
            .i_vl_offset_data       (vl_offset_data),
            .o_vl_offset_load       (vl_offset_load),
            .o_vl_offset            (vl_offset),
            .o_ts_format            (),
            .o_tx_ui                (sptp_tx_ui),
            .o_rx_ui                (sptp_rx_ui),
            .o_req_tx_ui_load       (sptp_req_tx_ui_load),
            .o_req_rx_ui_load       (sptp_req_rx_ui_load),
            .o_tpiso                (),
            .o_rsipo                (),
            .o_rxalign_offset       (),

            .o_ptp_tx_ref_lane                  (ptp_tx_ref_lane),
            .o_ptp_rx_ref_lane                  (ptp_rx_ref_lane),

            .i_ptp_tx_user_cfg_done_hwclr       (!i_ml_tx_lanes_stable),
            .o_ptp_tx_user_cfg_done             (ptp_tx_user_cfg_done),
            .i_ptp_rx_user_cfg_done_hwclr       (!i_ml_rx_pcs_fully_aligned),
            .o_ptp_rx_user_cfg_done             (ptp_rx_user_cfg_done),

            .i_ptp_tx_ptp_offset_data_valid     (o_ml_tx_ptp_offset_data_valid),
            .i_ptp_rx_ptp_offset_data_valid     (o_ml_rx_ptp_offset_data_valid),
            .i_ptp_tx_ptp_ready                 (o_ml_tx_ptp_ready),
            .i_ptp_rx_ptp_ready                 (o_ml_rx_ptp_ready),

            .i_ptp_tx_lane_calc_data_constdelay (ptp_tx_lane_calc_data_constdelay),
            .i_ptp_rx_lane_calc_data_constdelay (ptp_rx_lane_calc_data_constdelay),
            .i_ptp_tx_lane_calc_data_offset     (ptp_tx_lane_calc_data_offset),
            .i_ptp_rx_lane_calc_data_offset     (ptp_rx_lane_calc_data_offset),
            .i_ptp_tx_lane_calc_data_time       (ptp_tx_lane_calc_data_time),
            .i_ptp_rx_lane_calc_data_time       (ptp_rx_lane_calc_data_time),
            .i_ptp_tx_lane_calc_data_wiredelay  (ptp_tx_lane_calc_data_wiredelay),
            .i_ptp_rx_lane_calc_data_wiredelay  (ptp_rx_lane_calc_data_wiredelay)
        );

        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (32),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) load_tx_ui_cc (
            .in_clk                 (i_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : load_vl_offset_cc & load_tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .in_reset               (reconfig_reset_sync_reconfig_clk),
            .in_reset               (ehip_tx_reset_sync_sync_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------
            .in_ready               (),
            .in_valid               (sptp_req_tx_ui_load),
            .in_data                (sptp_tx_ui),
            .out_clk                (i_ml_clk_tx),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : load_vl_offset_cc & load_tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .out_reset              (reconfig_reset_sync_tx_clk),
            .out_reset              (ehip_tx_reset_async),
// ---------------------------------------------------------------------------------------------------------------------------------

            .out_ready              (!ehip_tx_reset_async),
            .out_valid              (sptp_req_tx_ui_load_cc),
            .out_data               (sptp_tx_ui_cc)
        );

        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (32),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) load_rx_ui_cc (
            .in_clk                 (i_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : load_vl_offset_cc & load_tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .in_reset               (reconfig_reset_sync_reconfig_clk),
            .in_reset               (ehip_tx_reset_sync_sync_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------

            .in_ready               (),
            .in_valid               (sptp_req_rx_ui_load),
            .in_data                (sptp_rx_ui),
            .out_clk                (i_ml_clk_tx),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : load_vl_offset_cc & load_tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .out_reset              (reconfig_reset_sync_tx_clk),
            .out_reset              (ehip_tx_reset_async),
// ---------------------------------------------------------------------------------------------------------------------------------

            .out_ready              (!ehip_tx_reset_async),
            .out_valid              (sptp_req_rx_ui_load_cc),
            .out_data               (sptp_rx_ui_cc)
        );

        for(i = 0; i < 20; i++) begin : VL_OFFSET_CC
            alt_ehipc3_fm_clock_crosser #(
                .SYMBOLS_PER_BEAT       (1),
                .BITS_PER_SYMBOL        (39),
                .FORWARD_SYNC_DEPTH     (2),
                .BACKWARD_SYNC_DEPTH    (2)
            ) load_vl_offset_cc (
                .in_clk                 (i_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : load_vl_offset_cc & load_tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//                .in_reset               (reconfig_reset_sync_reconfig_clk),
                .in_reset               (ehip_tx_reset_sync_sync_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------

                .in_ready               (),
                .in_valid               (vl_offset_load[i]),
                .in_data                (vl_offset[i]),
                .out_clk                (i_ml_clk_tx),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : load_vl_offset_cc & load_tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//                .out_reset              (reconfig_reset_sync_tx_clk),
                .out_reset              (ehip_tx_reset_async),
// ---------------------------------------------------------------------------------------------------------------------------------

                .out_ready              (!ehip_tx_reset_async),
                .out_valid              (sptp_vl_offset_load_cc[i]),
                .out_data               (sptp_vl_offset_cc[i])
            );
        end

        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (64),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) inst_tx_tam_capture_cc (
            .in_clk                 (i_ml_clk_tx),
            .in_reset               (ehip_tx_reset_async),
            .in_ready               (),
            .in_valid               (tx_tam_cap_valid),
            .in_data                ({tx_tam_count,tx_tam_capture}),
            .out_clk                (i_reconfig_clk),
            .out_reset              (ehip_tx_reset_sync_sync_reconfig_clk),
            .out_ready              (1'b1),
            .out_valid              (tx_tam_cap_valid_cc),
            .out_data               ({tx_tam_count_cc,tx_tam_capture_cc})
        );

        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (64),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) inst_rx_tam_capture_cc (
            .in_clk                 (i_ml_clk_rx),
            .in_reset               (ehip_rx_reset_async),
            .in_ready               (),
            .in_valid               (rx_tam_cap_valid),
            .in_data                ({rx_tam_count,rx_tam_capture}),
            .out_clk                (i_reconfig_clk),
            .out_reset              (ehip_rx_reset_sync_sync_reconfig_clk),
            .out_ready              (1'b1),
            .out_valid              (rx_tam_cap_valid_cc),
            .out_data               ({rx_tam_count_cc,rx_tam_capture_cc})
        );

        // Pseudo-static signals, use synchronizers so that it could be constrained properly to ensure the skew of the bus is small
        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (3),
            .INIT_VALUE         (0)
        ) tx_ref_lane_std_sync (
            .clk                (i_ml_clk_tx),
            .reset              (1'b0),
            .d                  (ptp_tx_ref_lane),
            .q                  (ptp_tx_ref_lane_sync)
        );

        // Pseudo-static signals, use synchronizers so that it could be constrained properly to ensure the skew of the bus is small
        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (3),
            .INIT_VALUE         (0)
        ) rx_ref_lane_std_sync (
            .clk                (i_ml_clk_tx),
            .reset              (1'b0),
            .d                  (ptp_rx_ref_lane),
            .q                  (ptp_rx_ref_lane_sync)
        );

        // Pseudo-static signals, use synchronizers so that it could be constrained properly to ensure the skew of the bus is small
        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (0)
        ) tx_user_cfg_done_std_sync (
            .clk                (i_ml_clk_tx),
            .reset              (1'b0),
            .d                  (ptp_tx_user_cfg_done),
            .q                  (ptp_tx_user_cfg_done_sync)
        );

        // Pseudo-static signals, use synchronizers so that it could be constrained properly to ensure the skew of the bus is small
        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (0)
        ) rx_user_cfg_done_std_sync (
            .clk                (i_ml_clk_tx),
            .reset              (1'b0),
            .d                  (ptp_rx_user_cfg_done),
            .q                  (ptp_rx_user_cfg_done_sync)
        );

   //flop for timing
    logic [LANES-1:0][2:0]    o_ml_ptp_ins_type_wire;
    logic [LANES-1:0][2:0]    o_ml_ptp_byte_offset_wire;
    logic            [95:0]   o_ml_ptp_ts_wire;
    logic            [7:0]    o_ml_ptp_tx_fp_wire;
    logic                     o_read_ptp_vl_data_wire;
    logic            [4:0]    o_select_ptp_vl_data_wire;

        always @(posedge i_ml_clk_tx) begin
            if(ehip_tx_reset_sync) begin
                o_ml_ptp_ins_type<='h0;
                o_ml_ptp_byte_offset<='h0;
                o_ml_ptp_tx_fp<='h0;
                o_read_ptp_vl_data<='h0;
                o_select_ptp_vl_data<='h0;
            end else begin
                o_ml_ptp_ins_type<=o_ml_ptp_ins_type_wire;
                o_ml_ptp_byte_offset<=o_ml_ptp_byte_offset_wire;
                o_ml_ptp_ts<=o_ml_ptp_ts_wire;
                o_ml_ptp_tx_fp<=o_ml_ptp_tx_fp_wire;
                o_read_ptp_vl_data<=o_read_ptp_vl_data_wire;
                o_select_ptp_vl_data<=o_select_ptp_vl_data_wire;

            end
        end

        alt_ehipc3_fm_ml_ptp #(
            .ENABLE_PTP_REF_LANE    (ENABLE_PTP_REF_LANE),
            .LANES                  (LANES)
        ) soft_ptp (
            // Configuration
            .i_enable_rsfec         (i_enable_rsfec),
            .i_tx_preamble_pass     (i_tx_preamble_pass),
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
            .i_rx_preamble_pass     (i_rx_preamble_pass),
// ---------------------------------------------------------------------------------------------------------------------------------
            .i_cfg_enforce_max_rx   (i_cfg_enforce_max_rx),
            .i_cfg_remove_rx_pad    (i_cfg_remove_rx_pad),

            // System Interface
            .i_ptp_clk              (i_ml_clk_tx),
            .i_tx_rst_n             (!ehip_tx_reset_sync),
            .i_tx_rst_n1            (!ehip_tx_reset_sync),
            .i_tx_rst_n2            (!ehip_tx_reset_sync),
            .i_rx_rst_n             (!ehip_rx_reset_sync),
            .i_rx_rst_n1            (!ehip_rx_reset_sync),
            .i_rx_rst_n2            (!ehip_rx_reset_sync),

            .i_tx_rst_n_rr          (!ehip_tx_reset_sync_rr),
            .i_rx_rst_n_rr          (!ehip_rx_reset_sync_rr),

            .i_pcs_fully_aligned    (rx_pcs_fully_aligned_sync_rr),
            .i_all_ready            (all_ready),

            .i_tx_arst_n             (!ehip_tx_reset_async),
            .i_rx_arst_n             (!ehip_rx_reset_async),

            // AVMM CSR Bank Interface
            .o_tx_error_valid       (),
            .o_tx_error             (),
            .o_rx_error_valid       (),
            .o_rx_error             (),
            .i_tx_ui                (sptp_tx_ui_cc),
            .i_rx_ui                (sptp_rx_ui_cc),
            .i_req_tx_ui_load       (sptp_req_tx_ui_load_cc),
            .i_req_rx_ui_load       (sptp_req_rx_ui_load_cc),
            .i_vl_offset_load       (sptp_vl_offset_load_cc),
            .i_vl_offset            (sptp_vl_offset_cc),

            .i_ptp_tx_ref_lane                  (ptp_tx_ref_lane_sync),
            .i_ptp_rx_ref_lane                  (ptp_rx_ref_lane_sync),

            .i_ptp_tx_user_cfg_done             (ptp_tx_user_cfg_done_sync),
            .i_ptp_rx_user_cfg_done             (ptp_rx_user_cfg_done_sync),

            .o_ptp_tx_lane_calc_data_constdelay (ptp_tx_lane_calc_data_constdelay),
            .o_ptp_rx_lane_calc_data_constdelay (ptp_rx_lane_calc_data_constdelay),
            .o_ptp_tx_lane_calc_data_offset     (ptp_tx_lane_calc_data_offset),
            .o_ptp_rx_lane_calc_data_offset     (ptp_rx_lane_calc_data_offset),
            .o_ptp_tx_lane_calc_data_time       (ptp_tx_lane_calc_data_time),
            .o_ptp_rx_lane_calc_data_time       (ptp_rx_lane_calc_data_time),
            .o_ptp_tx_lane_calc_data_wiredelay  (ptp_tx_lane_calc_data_wiredelay),
            .o_ptp_rx_lane_calc_data_wiredelay  (ptp_rx_lane_calc_data_wiredelay),

            // User Interface: TOD Interface
            .i_ptp_tod              (i_ptp_tod),

            // User Interface: PTP Status
            .o_tx_ptp_offset_data_valid(o_ml_tx_ptp_offset_data_valid),
            .o_rx_ptp_offset_data_valid(o_ml_rx_ptp_offset_data_valid),
            .o_tx_ptp_ready         (o_ml_tx_ptp_ready),
            .o_rx_ptp_ready         (o_ml_rx_ptp_ready),

            // User Interface: TX Framing Interface
            .i_tx_early_valid       (i_ml_tx_early_valid),
            .i_tx_valid             (i_ml_tx_valid),
            .i_tx_inframe           (i_ml_tx_inframe),
            .i_tx_skip_crc          (i_ml_tx_skip_crc),

            // User Interface: TX 1-step Command
            .i_ptp_ins_ets          (i_ml_ptp_ins_ets),
            .i_ptp_ins_cf           (i_ml_ptp_ins_cf),
            .i_ptp_zero_csum        (i_ml_ptp_ins_zero_csum),
            .i_ptp_update_eb        (i_ml_ptp_ins_update_eb),
            .i_ptp_ts_format        (i_ml_ptp_ts_format),
            .i_ptp_asym             (1'b0),
            .i_ptp_ts_offset        (i_ml_ptp_ts_offset),
            .i_ptp_cf_offset        (i_ml_ptp_cf_offset),
            .i_ptp_csum_offset      (i_ml_ptp_csum_offset),
            .i_ptp_eb_offset        (i_ml_ptp_eb_offset),
            .i_ptp_tx_its           (i_ml_ptp_tx_its),

            // User Interface: TX 2-step Timestamp Request
            .i_ptp_ts_req           (i_ml_ptp_ts_req),
            .i_ptp_fp               (i_ml_ptp_fp),

            // User Interface: TX 2-step Timestamp Return
            .o_ptp_ets_valid        (o_ml_ptp_ets_valid),
            .o_ptp_ets              (o_ml_ptp_ets),
            .o_ptp_ets_fp           (o_ml_ptp_ets_fp),

            // User Interface: RX Timestamp
            .o_ptp_rx_its           (o_ml_ptp_rx_its),
            .o_ptp_rx_its_valid     (o_ml_ptp_rx_its_valid),

            // EHIP Interface: TX 1-step and 2-step Command
            .o_ptp_ins_type         (o_ml_ptp_ins_type_wire),
            .o_ptp_byte_offset      (o_ml_ptp_byte_offset_wire),
            .o_ptp_ts               (o_ml_ptp_ts_wire),
            .o_ptp_tx_fp            (o_ml_ptp_tx_fp_wire),

            // EHIP Interface: TX 2-step Timestamp
            .i_ptp_tx_ts_valid      (i_ml_ptp_tx_ts_valid),
            .i_ptp_tx_ts            (i_ml_ptp_tx_ts),
            .i_ptp_tx_fp            (i_ml_ptp_tx_ts_fp),

            // EHIP Interface: RX Timestamp
            .i_rx_valid             (i_ml_rx_valid),
            .i_rx_inframe           (i_ml_rx_inframe),
            .i_ptp_rx_ts            (i_ml_ptp_rx_ts),

            // EHIP Interface: Reference Timestamp
            .o_sclk                 (o_ml_sclk),
            .o_tx_sel_sclk_return   (o_ml_tx_sel_sclk_return),
            .o_rx_sel_sclk_return   (o_ml_rx_sel_sclk_return),
            .i_tx_sclk_return       (i_ml_tx_sclk_return),
            .i_rx_sclk_return       (i_ml_rx_sclk_return),
            .i_tx_am                (i_ml_tx_am),
            .i_rx_am                (i_ml_rx_am),

            // EHIP Interface: VL Offset Read
            .o_read_ptp_vl_data     (o_read_ptp_vl_data_wire),
            .o_select_ptp_vl_data   (o_select_ptp_vl_data_wire),

            // TAM capture and AM counts
            .o_tx_tam_capture       (tx_tam_capture),
            .o_tx_tam_count         (tx_tam_count),
            .o_tx_tam_cap_valid     (tx_tam_cap_valid),
            .o_rx_tam_capture       (rx_tam_capture),
            .o_rx_tam_count         (rx_tam_count),
            .o_rx_tam_cap_valid     (rx_tam_cap_valid)

        );
    end // Block: SL_PTP
    else
    begin
        assign o_ml_tx_ptp_ready        = 1'b0;
        assign o_ml_rx_ptp_ready        = 1'b0;

        assign o_ml_ptp_ets_valid       = 1'b0;
        assign o_ml_ptp_ets             = 96'h0;
        assign o_ml_ptp_ets_fp          = 8'h0;

        assign o_ml_ptp_rx_its          = 96'h0;
        assign o_ml_ptp_rx_its_valid    = 1'b0;

        assign o_ml_ptp_ins_type        = {4{3'b000}};
        assign o_ml_ptp_byte_offset     = {4{3'b000}};
        assign o_ml_ptp_ts              = 96'h0;
        assign o_ml_ptp_tx_fp           = 8'h00;

        assign o_ml_sclk                = 1'b0;
        assign o_ml_tx_sel_sclk_return  = 1'b1;
        assign o_ml_rx_sel_sclk_return  = 1'b1;

        assign o_read_ptp_vl_data       = 1'b0;
        assign o_select_ptp_vl_data     = 5'd0;

        assign o_sl_avmm_waitrequest    = 1'b0;
        assign o_sl_avmm_readdata       = 32'h0;
    end
    endgenerate

endmodule
