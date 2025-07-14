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

(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)

module alt_ehipc3_fm_sl_soft #(
    parameter ehip_rate_sl  = "rate_25gx1",
    parameter ehip_mode_sl  = "ehip_disable",
    parameter core_variant  = 0,
    parameter active_channel= 0,
    parameter ENABLE_PTP    = 0,
    parameter ENABLE_PTP_RX_DESKEW = 0,
    parameter sl_num_lanes  = 1,
    parameter sim_mode      = "disable",
    parameter SIM_EMULATE   = 0,
    parameter READY_LATENCY = 0,
    parameter ENABLE_ASYNC_ADAPTERS_SL = 0,
    parameter ENHANCED_PTP_ACCURACY = 0,
    parameter ENHANCED_PTP_DBG = 0,
    parameter ENABLE_EXTERNAL_AIB_CLOCKING = 0
) (
    // Configuration
    input wire 				 i_enable_rsfec,
    input wire 				 i_tx_preamble_pass,
    input wire 				 i_tx_am_pulse,

    // Clock
    input wire 				 i_reconfig_clk,
    input wire [sl_num_lanes-1:0] 	 i_sl_clk_tx, // TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div64 to this
    input wire [sl_num_lanes-1:0] 	 i_sl_clk_rx, // TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div64 to this
    input wire [sl_num_lanes-1:0] 	 i_sl_async_clk_tx, // TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div66 to this
    input wire [sl_num_lanes-1:0] 	 i_sl_async_clk_rx, // TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div66 to this
    input wire [sl_num_lanes-1:0] 	 i_sl_clk_tx_tod, // TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div66 to this
    input wire [sl_num_lanes-1:0] 	 i_sl_clk_rx_tod, // TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div66 to this

    // Reset
    input wire 				 i_reconfig_reset,
    input wire [sl_num_lanes-1:0] 	 i_sl_csr_rst_n, // Resets the entire Ethernet core. Active low.
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_rst_n, // Resets the TX digital path (Ethernet MAC and Ethernet PCS)
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_rst_n, // Resets the RX digital path (Ethernet MAC, PCS)

    input wire [sl_num_lanes-1:0] 	 i_sl_soft_csr_rst,
    input wire [sl_num_lanes-1:0] 	 i_sl_soft_tx_rst,
    input wire [sl_num_lanes-1:0] 	 i_sl_soft_rx_rst,

    input wire [sl_num_lanes-1:0] 	 i_sl_pause_ehip_ready, // This is from the pause module
    // Reset Controller
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_aib_reset,
    output wire [sl_num_lanes-1:0] 	 o_sl_rx_aib_reset,
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_pcs_reset,
    output wire [sl_num_lanes-1:0] 	 o_sl_rx_pcs_reset,
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_pma_ready,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_pma_ready,
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_dll_lock,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_is_lockedtodata,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_transfer_ready,
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_transfer_ready,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_pcs_fully_aligned,

    input wire [sl_num_lanes-1:0] 	 i_sl_ehip_ready,
    input wire [sl_num_lanes-1:0] 	 i_sl_ehip_reset_stat,
    input wire [sl_num_lanes-1:0] 	 i_sl_ehip_tx_reset_stat,
    input wire [sl_num_lanes-1:0] 	 i_sl_ehip_rx_reset_stat,
    output wire [sl_num_lanes-1:0] 	 o_sl_ehip_reset,
    output wire [sl_num_lanes-1:0] 	 o_sl_ehip_tx_reset,
    output wire [sl_num_lanes-1:0] 	 o_sl_ehip_rx_reset,
    output wire [sl_num_lanes-1:0] 	 o_sl_ehip_pld_ready,
    output wire [sl_num_lanes-1:0] 	 o_sl_ehip_signal_ok,
    output wire [sl_num_lanes-1:0] 	 o_sl_ehip_ready,

    output wire [sl_num_lanes-1:0] 	 o_sl_rsfec_reset,
    output wire [sl_num_lanes-1:0] 	 o_sl_rsfec_tx_reset,
    output wire [sl_num_lanes-1:0] 	 o_sl_rsfec_rx_reset,

    output wire [sl_num_lanes-1:0] 	 o_sl_tx_lanes_stable, //Asserted when TX MAC is ready to send data
    output wire [sl_num_lanes-1:0] 	 o_sl_rx_pcs_ready, //Asserted when RX PCS is ready to receive data

    // TX Adapter
    input wire [sl_num_lanes-1:0][63:0]  i_sl_tx_data, // Input data to the MAC. Bits 0 is the LSB
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_valid, // Indicates data TX data is valid. Must remain high throughout transmission of packet
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_startofpacket, // Start of packet (SOP). Asserted for one cycle at the beginning of frame
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_endofpacket, // End of packet (EOP). Asserted for one cycle on the last cycle of the frame
    input wire [sl_num_lanes-1:0][2:0] 	 i_sl_tx_empty, // Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted.
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_error, // A valid high on this signal aligned with an eop will cause the tx frame to be treated as an error.
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_skip_crc,
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_ready,
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_aib_dsk,

    output wire [sl_num_lanes-1:0][63:0] o_sl_tx_data,
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_valid,
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_inframe,
    output wire [sl_num_lanes-1:0][2:0]  o_sl_tx_empty,
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_error,
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_skip_crc,
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_ready,

    // RX Adapter
    input wire [sl_num_lanes-1:0][63:0]  i_sl_rx_data,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_valid,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_inframe,
    input wire [sl_num_lanes-1:0][2:0] 	 i_sl_rx_empty,
    input wire [sl_num_lanes-1:0][1:0] 	 i_sl_rx_error,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_fcs_error,
    input wire [sl_num_lanes-1:0][2:0] 	 i_sl_rx_status,

    output wire [sl_num_lanes-1:0][63:0] o_sl_rx_data, // output data from the MAC, Bit 0 is LSB
    output wire [sl_num_lanes-1:0] 	 o_sl_rx_valid, // Indicates data RX data, EOP, and SOP are valid.
    output wire [sl_num_lanes-1:0] 	 o_sl_rx_startofpacket, // Start of packet (SOP). Asserted for one cycle at the beginning of frame
    output wire [sl_num_lanes-1:0] 	 o_sl_rx_endofpacket, // End of packet (EOP). Asserted for one cycle on the last cycle of the frame
    output wire [sl_num_lanes-1:0][2:0]  o_sl_rx_empty, // Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted.
    output wire [sl_num_lanes-1:0][5:0]  o_sl_rx_error, // RX error bits asserted on the EOP cycle.[0] : malformed block, [1] : crc error, [2] : reserved, [3] : reserved, [4] : length error, [5] : reserved
    output wire [sl_num_lanes-1:0][39:0] o_sl_rxstatus_data, // RX frame status information. Valid on EOP cycle.[0:31] : reserved, [32] : stacked vlan frame ,[33] : vlan frame ,[34] : control frame, [35] : pause frame, [36:38] : reserved, [39] : pfc frame
    output wire [sl_num_lanes-1:0] 	 o_sl_rxstatus_valid, // asserted to indicate that bits on o_rxstatus_data are valid

    // PTP
    input wire 				 i_sl_ptp_rx_aib_dsk_done,

    // User Interface: TOD Interface
    input wire [95:0] 			 i_ptp_tod,     // for 3ns
    input wire [0:0][95:0] 		 i_ptp_tx_tod,  // for 1ns TODO need to check if the width is correct
    input wire [0:0][95:0] 		 i_ptp_rx_tod,

    // User Interface: PTP Status
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_ptp_ready,
    output wire [sl_num_lanes-1:0] 	 o_sl_rx_ptp_ready,

    // User Interface: TX 1-step Command
    input wire [sl_num_lanes-1:0] 	 i_sl_ptp_ins_ets,
    input wire [sl_num_lanes-1:0] 	 i_sl_ptp_ins_cf,
    input wire [sl_num_lanes-1:0] 	 i_sl_ptp_ins_zero_csum,
    input wire [sl_num_lanes-1:0] 	 i_sl_ptp_ins_update_eb,
    input wire [sl_num_lanes-1:0] 	 i_sl_ptp_ts_format,
    input wire [sl_num_lanes-1:0][15:0]  i_sl_ptp_ts_offset,
    input wire [sl_num_lanes-1:0][15:0]  i_sl_ptp_cf_offset,
    input wire [sl_num_lanes-1:0][15:0]  i_sl_ptp_csum_offset,
    input wire [sl_num_lanes-1:0][15:0]  i_sl_ptp_ed_offset,
    input wire [sl_num_lanes-1:0][95:0]  i_sl_ptp_tx_its,

    // User Interface: TX 2-step Timestamp Request
    input wire [sl_num_lanes-1:0] 	 i_sl_ptp_ts_req,
    input wire [sl_num_lanes-1:0][7:0] 	 i_sl_ptp_fp,

    // User Interface: TX 2-step Timestamp Return
    output wire [sl_num_lanes-1:0] 	 o_sl_ptp_ets_valid,
    output wire [sl_num_lanes-1:0][95:0] o_sl_ptp_ets,
    output wire [sl_num_lanes-1:0][7:0]  o_sl_ptp_ets_fp,

    // User Interface: RX Timestamp
    output wire [sl_num_lanes-1:0][95:0] o_sl_ptp_rx_its,
    output wire [sl_num_lanes-1:0] 	 o_sl_ptp_rx_its_valid,

    // EHIP Interface: TX 1-step and 2-step Command
    output wire [sl_num_lanes-1:0][1:0]  o_sl_ptp_tx_fp,
    output wire [sl_num_lanes-1:0][2:0]  o_sl_ptp_ins_type,
    output wire [sl_num_lanes-1:0][2:0]  o_sl_ptp_byte_offset,
    output wire [sl_num_lanes-1:0][23:0] o_sl_ptp_ts,

    // EHIP Interface: TX 2-step Timestamp
    input wire [sl_num_lanes-1:0] 	 i_sl_ptp_tx_ts_valid,
    input wire [sl_num_lanes-1:0][11:0]  i_sl_ptp_tx_ts,
    input wire [sl_num_lanes-1:0][1:0] 	 i_sl_ptp_tx_ts_fp,

    // EHIP Interface: RX Timestamp
    input wire [sl_num_lanes-1:0][20:0]  i_sl_ptp_rx_ts,

    // EHIP Interface: Reference Timestamp
    output wire [sl_num_lanes-1:0] 	 o_sl_sclk,
    output wire [sl_num_lanes-1:0] 	 o_sl_tx_sel_sclk_return,
    output wire [sl_num_lanes-1:0] 	 o_sl_rx_sel_sclk_return,
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_sclk_return,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_sclk_return,
    input wire [sl_num_lanes-1:0] 	 i_sl_tx_am,
    input wire [sl_num_lanes-1:0] 	 i_sl_rx_am,

    //1ns
    input wire [0:0]                i_ptp_sn_sclk,
   // AVMM Interface: PTP
    output wire [sl_num_lanes-1:0][31:0] o_sl_avmm_readdata,
    input wire [sl_num_lanes-1:0] 	 i_sl_avmm_write,
    input wire [sl_num_lanes-1:0] 	 i_sl_avmm_read,
    input wire [sl_num_lanes-1:0][31:0]  i_sl_avmm_writedata,
    output wire [sl_num_lanes-1:0] 	 o_sl_avmm_waitrequest,
    input wire [sl_num_lanes-1:0][6:0] 	 i_sl_avmm_address,

    // KR Reset controller interface
    input reg 				 kr_mode,
    input wire 				 kr_rst_req,
    output wire 			 kr_rst_stat
);
    localparam SIM_MODE_INT = (sim_mode == "disable") ? 0 : 1;

    localparam TX_PTP_WIDTH = 1*6+16*4+96+8;
    localparam RX_PTP_WIDTH = 96;
    localparam TX_PTP_DLY = 1+4; // 1 cycles delay to detect early_warning, another 4 due to PTP command process
    localparam RX_PTP_DLY = 4;   // 4 cycles delay to merge RX ingress timestamp over 4 clock cycles

// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
    wire                        reconfig_reset_sync_tx_clk;
    wire                        ehip_tx_reset_sync_sync_reconfig_clk;
// ---------------------------------------------------------------------------------------------------------------------------------
    wire                        reconfig_reset_sync_rx_clk;
    wire                        ehip_csr_reset_sync_tx_clk;
    wire                        ehip_tx_reset_sync_wire;
    wire                        ehip_rx_reset_sync_wire;

    reg                         ehip_tx_reset_sync/* synthesis preserve */;
    reg                         ehip_rx_reset_sync/* synthesis preserve */;
    reg                         ehip_tx_reset_async/* synthesis preserve */;
    reg                         ehip_rx_reset_async/* synthesis preserve */;

    reg                         ehip_tx_reset_sync_0;
    reg                         ehip_rx_reset_sync_0;
    reg                         ehip_tx_reset_async_0;
    reg                         ehip_rx_reset_async_0;

    reg                         ehip_tx_reset_sync_1;
    reg                         ehip_rx_reset_sync_1;
    reg                         ehip_tx_reset_async_1;
    reg                         ehip_rx_reset_async_1;

    reg                         ehip_tx_reset_sync_1n;
    reg                         ehip_rx_reset_sync_1n;

    reg                         ehip_tx_reset_sync_2n/* synthesis maxfan = 50 */;
    reg                         ehip_rx_reset_sync_2n/* synthesis maxfan = 50 */;

    reg                         ehip_tx_reset_sync_2/* synthesis maxfan = 50 */;
    reg                         ehip_rx_reset_sync_2/* synthesis maxfan = 50 */;
    reg                         ehip_tx_reset_async_2;
    reg                         ehip_rx_reset_async_2;

    wire                        ehip_tx_reset_async_adpt;

    reg                         all_ready_r;
    reg                         all_ready;

    reg                         tx_sel_sclk_return_r;
    reg                         tx_sel_sclk_return_rr;
    reg                         tx_sel_sclk_return_rrr;
    reg                         tx_sel_sclk_return_rrrr;
    wire			int_sl_tx_sclk_return_sync;
    wire                        tx_sclk_return_sync;
    reg                         tx_sclk_return_sync_r;
    wire                        tx_sclk_return_toggle;
    reg                         tx_sclk_return_toggle_r;
    reg                         tx_transmit_ready;
    reg                         tx_transmit_ready_r;
    wire                        user_tx_valid;
    wire                        user_tx_ready;

    wire [63:0]                 adpt_tx_data;
    wire                        adpt_tx_valid;
    wire                        adpt_tx_inframe;
    wire [2:0]                  adpt_tx_empty;
    wire                        adpt_tx_error;
    wire                        adpt_tx_skip_crc;
    wire                        adpt_tx_sop;

    wire [TX_PTP_WIDTH-1:0]     sl_tx_ptp;
    wire [TX_PTP_WIDTH-1:0]     adpt_tx_ptp;

    wire [RX_PTP_WIDTH-1:0]     int_sl_rx_ptp;

    wire                        adpt_ptp_ins_ets;
    wire                        adpt_ptp_ins_cf;
    wire                        adpt_ptp_ins_zero_csum;
    wire                        adpt_ptp_ins_update_eb;
    wire                        adpt_ptp_ts_format;
    wire [15:0]                 adpt_ptp_ts_offset;
    wire [15:0]                 adpt_ptp_cf_offset;
    wire [15:0]                 adpt_ptp_csum_offset;
    wire [15:0]                 adpt_ptp_ed_offset;
    wire [95:0]                 adpt_ptp_tx_its;
    wire                        adpt_ptp_ts_req;
    wire [7:0]                  adpt_ptp_fp;

    reg  [TX_PTP_DLY-1:0][63:0] ptp_dly_tx_data;
    reg  [TX_PTP_DLY-1:0]       ptp_dly_tx_inframe;
    reg  [TX_PTP_DLY-1:0][2:0]  ptp_dly_tx_empty;
    reg  [TX_PTP_DLY-1:0]       ptp_dly_tx_error;
    reg  [TX_PTP_DLY-1:0]       ptp_dly_tx_skip_crc;

    reg                         ptp_dly_tx_valid_r;
    reg  [63:0]                 ptp_dly_tx_data_r;
    reg                         ptp_dly_tx_inframe_r;
    reg  [2:0]                  ptp_dly_tx_empty_r;
    reg                         ptp_dly_tx_error_r;
    reg                         ptp_dly_tx_skip_crc_r;

    wire [63:0]                 ptp_tx_data;
    wire                        ptp_tx_inframe;
    wire [2:0]                  ptp_tx_empty;
    wire                        ptp_tx_error;
    wire                        ptp_tx_skip_crc;

    reg  [RX_PTP_DLY-1:0]       ptp_dly_rx_valid;
    reg  [RX_PTP_DLY-1:0][63:0] ptp_dly_rx_data;
    reg  [RX_PTP_DLY-1:0]       ptp_dly_rx_inframe;
    reg  [RX_PTP_DLY-1:0][2:0]  ptp_dly_rx_empty;
    reg  [RX_PTP_DLY-1:0][1:0]  ptp_dly_rx_error;
    reg  [RX_PTP_DLY-1:0]       ptp_dly_rx_fcs_error;
    reg  [RX_PTP_DLY-1:0][2:0]  ptp_dly_rx_status;

    wire			i_enable_ptp;

    wire                        dsk_rx_valid;
    wire [63:0]                 dsk_rx_data;
    wire                        dsk_rx_inframe;
    wire [2:0]                  dsk_rx_empty;
    wire [1:0]                  dsk_rx_error;
    wire                        dsk_rx_fcs_error;
    wire [2:0]                  dsk_rx_status;

    wire [20:0]                 dsk_ptp_rx_ts;
    wire                        dsk_rx_am;

    wire                        ptp_rx_valid;
    wire [63:0]                 ptp_rx_data;
    wire                        ptp_rx_inframe;
    wire [2:0]                  ptp_rx_empty;
    wire [1:0]                  ptp_rx_error;
    wire                        ptp_rx_fcs_error;
    wire [2:0]                  ptp_rx_status;

    wire                        adpt_rx_valid;
    wire [63:0]                 adpt_rx_data;
    wire                        adpt_rx_inframe;
    wire [2:0]                  adpt_rx_empty;
    wire [1:0]                  adpt_rx_error;
    wire                        adpt_rx_fcs_error;
    wire [2:0]                  adpt_rx_status;

    wire                        tx_pma_ready_sync;
    wire                        rx_pma_ready_sync;
    wire                        tx_transfer_ready_sync;
    wire                        rx_transfer_ready_sync;
    wire                        ehip_ready_sync;

    wire                        ptp_rx_aib_dsk_done;
    wire                        ptp_rx_aib_dsk_done_stm;

    wire [(sl_num_lanes*96)-1:0]    sl_ptp_ets_int;
    wire [(sl_num_lanes*8)-1:0]     sl_ptp_ets_fp_int;
    wire [sl_num_lanes-1:0]         sl_ptp_ets_valid_int;

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_pma_ready_std_sync (
        .clk                (i_sl_clk_tx),
        .reset              (1'b0),
        .d                  (i_sl_tx_pma_ready),
        .q                  (tx_pma_ready_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_pma_ready_std_sync (
        .clk                (i_sl_clk_tx),
        .reset              (1'b0),
        .d                  (i_sl_rx_pma_ready),
        .q                  (rx_pma_ready_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) tx_transfer_ready_std_sync (
        .clk                (i_sl_clk_tx),
        .reset              (1'b0),
        .d                  (i_sl_tx_transfer_ready),
        .q                  (tx_transfer_ready_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) rx_transfer_ready_std_sync (
        .clk                (i_sl_clk_tx),
        .reset              (1'b0),
        .d                  (i_sl_rx_transfer_ready),
        .q                  (rx_transfer_ready_sync)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) ehip_ready_std_sync (
        .clk                (i_sl_clk_tx),
        .reset              (1'b0),
        .d                  (i_sl_ehip_ready),
        .q                  (ehip_ready_sync)
    );

    //flop for timing
    logic tx_pma_ready_sync_r;
    logic rx_pma_ready_sync_r;
    logic tx_transfer_ready_sync_r;
    logic rx_transfer_ready_sync_r;
    logic ehip_ready_sync_r;

    always @(posedge i_sl_clk_tx) begin
        if(ehip_tx_reset_sync_2) begin
            all_ready_r <= 1'b0;
            all_ready   <= 1'b0;

            tx_pma_ready_sync_r   <= 1'b0;
            rx_pma_ready_sync_r   <= 1'b0;
            tx_transfer_ready_sync_r   <= 1'b0;
            rx_transfer_ready_sync_r   <= 1'b0;
            ehip_ready_sync_r   <= 1'b0;
        end
        else begin
            all_ready_r <= tx_pma_ready_sync_r &&
                           rx_pma_ready_sync_r &&
                           tx_transfer_ready_sync_r &&
                           rx_transfer_ready_sync_r &&
                           ehip_ready_sync_r;
            all_ready   <= all_ready_r;

            tx_pma_ready_sync_r   <= tx_pma_ready_sync;
            rx_pma_ready_sync_r   <= rx_pma_ready_sync;
            tx_transfer_ready_sync_r   <= tx_transfer_ready_sync;
            rx_transfer_ready_sync_r   <= rx_transfer_ready_sync;
            ehip_ready_sync_r   <= ehip_ready_sync;
        end
    end

    assign o_sl_tx_data         = ENABLE_PTP ? ptp_tx_data     : adpt_tx_data;
    assign o_sl_tx_valid        = ENABLE_PTP ? ptp_dly_tx_valid_r : adpt_tx_valid;
    assign o_sl_tx_inframe      = ENABLE_PTP ? ptp_tx_inframe  : adpt_tx_inframe;
    assign o_sl_tx_empty        = ENABLE_PTP ? ptp_tx_empty    : adpt_tx_empty;
    assign o_sl_tx_error        = ENABLE_PTP ? ptp_tx_error    : adpt_tx_error;
    assign o_sl_tx_skip_crc     = ENABLE_PTP ? ptp_tx_skip_crc : adpt_tx_skip_crc;

    assign i_enable_ptp     	= ENABLE_PTP ? 1'b1 	       : 1'b0;

    assign adpt_rx_valid        = ENABLE_PTP ? ptp_rx_valid    : dsk_rx_valid;
    assign adpt_rx_data         = ENABLE_PTP ? ptp_rx_data     : dsk_rx_data;
    assign adpt_rx_inframe      = ENABLE_PTP ? ptp_rx_inframe  : dsk_rx_inframe;
    assign adpt_rx_empty        = ENABLE_PTP ? ptp_rx_empty    : dsk_rx_empty;
    assign adpt_rx_error        = ENABLE_PTP ? ptp_rx_error    : dsk_rx_error;
    assign adpt_rx_fcs_error    = ENABLE_PTP ? ptp_rx_fcs_error: dsk_rx_fcs_error;
    assign adpt_rx_status       = ENABLE_PTP ? ptp_rx_status   : dsk_rx_status;

    wire tx_rst_int_n;
    wire soft_tx_rst_int_n;
    wire sl_tx_rst_n_sync;

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
       ) ehip_tx_rst_n_sync (
        .clk                (i_reconfig_clk),
        .reset              (1'b0),
        .d                  (i_sl_tx_rst_n),
        .q                  (sl_tx_rst_n_sync)
    );

    generate
    if ((SIM_EMULATE == 0) && (ENABLE_PTP != 0)) begin: TX_RESET_INT
       wire sl_ehip_signal_ok_sync;
       wire sl_csr_rst_n_sync;
       reg  sl_ehip_signal_ok_sync_r;
       reg  sl_ehip_signal_ok_sync_r1;
       reg  csr_detected = 0;
       reg  sl_csr_rst_n_sync_r;

       wire sl_soft_csr_rst_sync;
       reg  sl_soft_csr_rst_sync_r;
       reg  soft_csr_detected = 0;

       alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
       ) ehip_soft_csr_rst_n_sync (
        .clk                (i_reconfig_clk),
        .reset              (1'b0),
        .d                  (i_sl_soft_csr_rst),
        .q                  (sl_soft_csr_rst_sync)
       );

       alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
       ) ehip_csr_rst_n_sync (
        .clk                (i_reconfig_clk),
        .reset              (1'b0),
        .d                  (i_sl_csr_rst_n),
        .q                  (sl_csr_rst_n_sync)
       );

       alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
       ) ehip_ready_reconfig_sync (
        .clk                (i_reconfig_clk),
        .reset              (1'b0),
        .d                  (o_sl_ehip_signal_ok),
        .q                  (sl_ehip_signal_ok_sync)
       );

       always @(posedge i_reconfig_clk) begin
         sl_ehip_signal_ok_sync_r  <= sl_ehip_signal_ok_sync;
         sl_ehip_signal_ok_sync_r1 <= sl_ehip_signal_ok_sync_r;
         sl_csr_rst_n_sync_r       <= sl_csr_rst_n_sync;
         sl_soft_csr_rst_sync_r    <= sl_soft_csr_rst_sync;
       end

      always @(posedge i_reconfig_clk) begin
        if ((sl_csr_rst_n_sync & ~sl_csr_rst_n_sync_r)) begin
          csr_detected <= 1'b1;
        end
        else if (~sl_ehip_signal_ok_sync_r1 & sl_ehip_signal_ok_sync_r) begin
          csr_detected <= 1'b0;
        end
      end

      always @(posedge i_reconfig_clk) begin
        if ((sl_soft_csr_rst_sync & ~sl_soft_csr_rst_sync_r)) begin
           soft_csr_detected <= 1'b1;
        end
        else if (~sl_ehip_signal_ok_sync_r1 & sl_ehip_signal_ok_sync_r) begin
           soft_csr_detected <= 1'b0;
        end
      end

      assign tx_rst_int_n = ~(((~sl_ehip_signal_ok_sync_r1 & sl_ehip_signal_ok_sync_r) | (~sl_ehip_signal_ok_sync_r & sl_ehip_signal_ok_sync)) & csr_detected);
      assign soft_tx_rst_int_n = ~(((~sl_ehip_signal_ok_sync_r1 & sl_ehip_signal_ok_sync_r) | (~sl_ehip_signal_ok_sync_r & sl_ehip_signal_ok_sync)) & soft_csr_detected);
    end
    else begin
      assign tx_rst_int_n = 1'b1;
      assign soft_tx_rst_int_n = 1'b1;
    end
    endgenerate

    // Reset controller IP
    generate
    if ( (core_variant == 0) ||
         (core_variant == 1) ||
        ((core_variant == 3) && (active_channel == 0)) ||
         (core_variant == 4) || (core_variant == 5) || (core_variant == 7))
    begin : SL_RST_CTRL
        alt_ehipc3_fm_reset_controller #(
            .CLK_FREQ_IN_HZ(100000000),
            .NUM_CHANNELS(1),
            .SIM_EMULATE(SIM_EMULATE),
            .ENABLE_RSFEC(0),
            .ENABLE_EXTERNAL_AIB_CLOCKING(ENABLE_EXTERNAL_AIB_CLOCKING),
            .TILE("etile")
        ) i_sl_reset_controller (
            .csr_rst_in                (~i_sl_csr_rst_n),
            .tx_rst_in                 (~sl_tx_rst_n_sync|~tx_rst_int_n),
            .rx_rst_in                 (~i_sl_rx_rst_n),
            .soft_tx_rst_in            (i_sl_soft_tx_rst|~soft_tx_rst_int_n),
            .soft_rx_rst_in            (i_sl_soft_rx_rst),
            .soft_csr_rst_in           (i_sl_soft_csr_rst),

            .tx_pma_ready_in           (i_sl_tx_pma_ready),
            .rx_pma_ready_in           (i_sl_rx_pma_ready),
            .tx_transfer_ready_in      (i_sl_tx_transfer_ready),
            .rx_transfer_ready_in      (i_sl_rx_transfer_ready),
            .tx_dll_lock_in            (i_sl_tx_dll_lock),
            .tx_cal_busy               (1'b0),
            .rx_cal_busy               (1'b0),
            .rx_is_lockedtoref_in      (1'b1),
            .rx_is_lockedtodata_in     (i_sl_rx_is_lockedtodata),

            .tx_aib_reset_out          (o_sl_tx_aib_reset),
            .tx_pcs_reset_out          (o_sl_tx_pcs_reset),
            .rx_aib_reset_out          (o_sl_rx_aib_reset),
            .rx_pcs_reset_out          (o_sl_rx_pcs_reset),

	        .pause_ehip_ready_in       (i_sl_pause_ehip_ready), // EHIP ready from the pause module

            .ehip_ready_in             (i_sl_ehip_ready),
            .ehip_reset_ack_in         (~i_sl_ehip_reset_stat),
            .ehip_tx_reset_ack_in      (~i_sl_ehip_tx_reset_stat),
            .ehip_rx_reset_ack_in      (~i_sl_ehip_rx_reset_stat),
            .ehip_reset_out            (o_sl_ehip_reset),
            .ehip_tx_reset_out         (o_sl_ehip_tx_reset),
            .ehip_rx_reset_out         (o_sl_ehip_rx_reset),
            .ehip_signal_ok_out        (o_sl_ehip_signal_ok),
            .ehip_pld_ready_out        (o_sl_ehip_pld_ready),

            .rsfec_reset_out           (o_sl_rsfec_reset),
            .rsfec_tx_reset_out        (o_sl_rsfec_tx_reset),
            .rsfec_rx_reset_out        (o_sl_rsfec_rx_reset),

            .csr_rst_stat              (),
            .tx_rst_stat               (),
            .rx_rst_stat               (),

            .kr_mode_in                (kr_mode),
            .kr_rst_req                (kr_rst_req),
            .kr_rst_stat               (kr_rst_stat),

            .clk_status                (i_reconfig_clk),
            .pll_locked_in             (1'b1),
            .rx_pcs_fully_aligned_in   (i_sl_rx_pcs_fully_aligned),

            .tx_lanes_stable           (o_sl_tx_lanes_stable),
            .tx_eth_ready              (),
            .rx_eth_ready              (o_sl_rx_pcs_ready),
	    .ehip_ready_out            (o_sl_ehip_ready)

        );

// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (1)
        ) reconfig_reset_sync_tx_clk_i (
            .clk                (i_sl_clk_tx),
            .reset              (i_reconfig_reset),
            .d                  (1'b0),
            .q                  (reconfig_reset_sync_tx_clk)
        );

        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (1)
        ) ehip_tx_reset_sync_sync_reconfig_clk_resync_inst (
            .clk                (i_reconfig_clk),
            .reset              (ehip_tx_reset_async_2),
            .d                  (1'b0),
            .q                  (ehip_tx_reset_sync_sync_reconfig_clk)
        );
// ---------------------------------------------------------------------------------------------------------------------------------
//
        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (1)
        ) reconfig_reset_sync_rx_clk_i (
            .clk                (i_sl_clk_rx),
            .reset              (i_reconfig_reset),
            .d                  (1'b0),
            .q                  (reconfig_reset_sync_rx_clk)
        );

        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (1)
        ) csr_reset_sync_tx_clk (
            .clk                (i_sl_clk_tx),
            .reset              (!i_sl_csr_rst_n),
            .d                  (1'b0),
            .q                  (ehip_csr_reset_sync_tx_clk)
        );

        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (0)
        ) tx_reset_sync_tx_clk (
            .clk                (i_sl_clk_tx),
            .reset              (1'b0),
            .d                  (o_sl_ehip_tx_reset),
            .q                  (ehip_tx_reset_sync_wire_p)
        );

        // Additional flop for better timing
        always @(posedge i_sl_clk_tx) begin
            ehip_tx_reset_sync     <= ehip_tx_reset_sync_wire_p;
            ehip_tx_reset_sync_0   <= ehip_tx_reset_sync;
	        ehip_tx_reset_sync_1   <= ehip_tx_reset_sync_0;
	        ehip_tx_reset_sync_2   <= ehip_tx_reset_sync_1;
	        ehip_tx_reset_sync_2n   <= ~ehip_tx_reset_sync_1;
	        ehip_tx_reset_sync_1n   <= ~ehip_tx_reset_sync_0;

            ehip_tx_reset_async     <= ehip_tx_reset_sync_wire_p;
            ehip_tx_reset_async_0   <= ehip_tx_reset_async;
	        ehip_tx_reset_async_1   <= ehip_tx_reset_async_0;
	        ehip_tx_reset_async_2   <= ehip_tx_reset_async_1;
        end


        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (0)
        ) rx_reset_sync_rx_clk (
            .clk                (i_sl_clk_rx),
            .reset              (1'b0),
            .d                  (o_sl_ehip_rx_reset),
            .q                  (ehip_rx_reset_sync_wire_p)
        );

        // Additional flop for better timing
        always @(posedge i_sl_clk_rx) begin
            ehip_rx_reset_sync     <= ehip_rx_reset_sync_wire_p;
            ehip_rx_reset_sync_0   <= ehip_rx_reset_sync;
	        ehip_rx_reset_sync_1   <= ehip_rx_reset_sync_0;
	        ehip_rx_reset_sync_2   <= ehip_rx_reset_sync_1;
	        ehip_rx_reset_sync_2n   <= ~ehip_rx_reset_sync_1;
	        ehip_rx_reset_sync_1n   <= ~ehip_rx_reset_sync_0;

            ehip_rx_reset_async     <= ehip_rx_reset_sync_wire_p;
            ehip_rx_reset_async_0   <= ehip_rx_reset_async;
	        ehip_rx_reset_async_1   <= ehip_rx_reset_async_0;
	        ehip_rx_reset_async_2   <= ehip_rx_reset_async_1;
        end

        // Use TX sclk_return signal to indicate that TX gearbox realignment is complete
        // Therefore we wait the sclk_return signal to toggle twice
        alt_xcvr_resync_std #(
            .SYNC_CHAIN_LENGTH  (3),
            .WIDTH              (1),
            .INIT_VALUE         (0)
        ) tx_sclk_return_std_sync (
            .clk    (i_sl_clk_tx),
            .reset  (1'b0),
            .d      (int_sl_tx_sclk_return_sync),
            .q      (tx_sclk_return_sync)
        );

        assign tx_sclk_return_toggle = tx_sclk_return_sync ^ tx_sclk_return_sync_r;

        always @(posedge i_sl_clk_tx) begin
            if(ehip_tx_reset_sync_2) begin
                tx_sel_sclk_return_r    <= 1'b0;
                tx_sel_sclk_return_rr   <= 1'b0;
                tx_sel_sclk_return_rrr  <= 1'b0;
                tx_sel_sclk_return_rrrr <= 1'b0;
                tx_sclk_return_sync_r   <= 1'b0;
                tx_sclk_return_toggle_r <= 1'b0;
            end
            else begin
                tx_sel_sclk_return_r    <= o_sl_tx_sel_sclk_return;
                tx_sel_sclk_return_rr   <= tx_sel_sclk_return_r;
                tx_sel_sclk_return_rrr  <= tx_sel_sclk_return_rr;
                tx_sel_sclk_return_rrrr <= tx_sel_sclk_return_rrr;
                tx_sclk_return_sync_r   <= tx_sclk_return_sync;

                if(tx_sel_sclk_return_rrr) begin
                    if(tx_sclk_return_toggle) begin
                        tx_sclk_return_toggle_r <= 1'b1;
                    end
		end
            end
        end

	always @(posedge i_sl_clk_tx) begin
	    if(ehip_tx_reset_sync_2) begin
		tx_transmit_ready	<= 1'b0;
		tx_transmit_ready_r	<= 1'b0;
	    end
	    else begin
		if(tx_sel_sclk_return_rrr) begin
                    if(tx_sclk_return_toggle_r && tx_sclk_return_toggle) begin
                        tx_transmit_ready <= 1'b1;
                    end
                end
            tx_transmit_ready_r <= tx_transmit_ready;
            end
        end

    end // block: SL_RST_CTRL
    else
    begin
        assign o_sl_tx_aib_reset    = 1'b0;
        assign o_sl_tx_pcs_reset    = 1'b0;
        assign o_sl_rx_aib_reset    = 1'b0;
        assign o_sl_rx_pcs_reset    = 1'b0;

        assign o_sl_ehip_reset      = 1'b0;
        assign o_sl_ehip_tx_reset   = 1'b0;
        assign o_sl_ehip_rx_reset   = 1'b0;
        assign o_sl_ehip_signal_ok  = 1'b0;
        assign o_sl_ehip_pld_ready  = 1'b0;

        assign o_sl_ehip_rx_reset   = 1'b0;
        assign o_sl_rsfec_tx_reset  = 1'b0;
        assign o_sl_rsfec_rx_reset  = 1'b0;
    end
    endgenerate

    generate
    if ((((core_variant == 0) ||
          (core_variant == 1)) &&
         ((ehip_mode_sl == "ehip_mac") ||
          (ehip_mode_sl == "ehip_mac_no_fec"))) ||
         ((core_variant == 3) && (active_channel == 0)))
    begin : SL_TX_ADAPTER

        if (ENABLE_ASYNC_ADAPTERS_SL == 1) begin
            reg                         tx_transmit_ready_390clk;
            reg                         i_tx_am_pulse_390clk;

            assign user_tx_valid =  i_sl_tx_valid && (tx_transmit_ready_390clk || !i_tx_am_pulse_390clk);
            assign o_sl_tx_ready =  user_tx_ready ;

            alt_xcvr_resync_std #(
              .SYNC_CHAIN_LENGTH  (3),
                .WIDTH              (1),
                .INIT_VALUE         (0)
            ) tx_transmit_ready_sync (
                .clk                (i_sl_async_clk_tx),
                .reset              (ehip_tx_reset_async_2),
                .d                  (tx_transmit_ready_r),
                .q                  (tx_transmit_ready_390clk)
            );

            alt_xcvr_resync_std #(
                .SYNC_CHAIN_LENGTH  (3),
                .WIDTH              (1),
                .INIT_VALUE         (0)
            ) i_tx_am_pulse_sync (
                .clk                (i_sl_async_clk_tx),
                .reset              (ehip_tx_reset_async_2),
                .d                  (i_tx_am_pulse),
                .q                  (i_tx_am_pulse_390clk)
            );

            alt_xcvr_resync_std #(
             .SYNC_CHAIN_LENGTH  (3),
             .WIDTH              (1),
             .INIT_VALUE         (1)
            ) sl_ehip_tx_reset_sync_asynclk (
               .clk                (i_sl_async_clk_tx),
               .reset              (ehip_tx_reset_async_2),

               .d                  (1'b0),
               .q                  (ehip_tx_reset_async_adpt)
            );

            alt_ehipc3_fm_sl_adapter_tx_async #(
                    .NUM_CHANNELS   (sl_num_lanes),
                    .WORD_WIDTH     (64),
                    .EMPTY_BITS     (3),
                    .PTP_WIDTH      (TX_PTP_WIDTH),
                    .SIM_EMULATE    (SIM_EMULATE),
                    .READY_LATENCY  (READY_LATENCY)
                ) i_sl_ehip_adapter_tx_async (
                    .i_clk              (i_sl_clk_tx),
                    .i_sl_async_clk_tx  (i_sl_async_clk_tx),
                    .i_reset            (ehip_tx_reset_async_2),
                    .i_reset_async      (ehip_tx_reset_async_adpt),

                    .i_tx_am_pulse      (i_tx_am_pulse_390clk),
                    .tx_transmit_ready  (tx_transmit_ready_390clk),
                    .i_valid            (user_tx_valid),
                    .i_data         (i_sl_tx_data),
                    .i_sop          (i_sl_tx_startofpacket),
                    .i_eop          (i_sl_tx_endofpacket),
                    .i_empty        (i_sl_tx_empty),
                    .i_error        (i_sl_tx_error),
                    .i_skip_crc     (i_sl_tx_skip_crc),
                    .i_ptp          (sl_tx_ptp),
                    .o_ready        (user_tx_ready),

                    .o_data         (adpt_tx_data),
                    .o_valid        (adpt_tx_valid),
                    .i_ready        (i_sl_tx_ready),
                    .o_inframe      (adpt_tx_inframe),
                    .o_empty        (adpt_tx_empty),
                    .o_error        (adpt_tx_error),
                    .o_ptp          (adpt_tx_ptp),
                    .o_skip_crc     (adpt_tx_skip_crc)
                );
        end
        else begin
        assign user_tx_valid =  i_sl_tx_valid && (tx_transmit_ready_r || !i_tx_am_pulse);
        assign o_sl_tx_ready =  user_tx_ready && (tx_transmit_ready_r || !i_tx_am_pulse);

            alt_ehipc3_fm_sl_adapter_tx #(
                .NUM_CHANNELS   (sl_num_lanes),
                .WORD_WIDTH     (64),
                .EMPTY_BITS     (3),
                .PTP_WIDTH      (TX_PTP_WIDTH),
                .SIM_EMULATE    (SIM_EMULATE),
                .READY_LATENCY  (READY_LATENCY)
            ) i_sl_ehip_adapter_tx (
                .i_clk          (i_sl_clk_tx),
                .i_reset        (ehip_tx_reset_sync_2),

                .i_valid        (user_tx_valid),
                .i_data         (i_sl_tx_data),
                .i_sop          (i_sl_tx_startofpacket),
                .i_eop          (i_sl_tx_endofpacket),
                .i_empty        (i_sl_tx_empty),
                .i_error        (i_sl_tx_error),
                .i_skip_crc     (i_sl_tx_skip_crc),
                .i_ptp          (sl_tx_ptp),
                .o_ready        (user_tx_ready),

                .o_data         (adpt_tx_data),
                .o_valid        (adpt_tx_valid),
                .i_ready        (i_sl_tx_ready),
                .o_inframe      (adpt_tx_inframe),
                .o_empty        (adpt_tx_empty),
                .o_error        (adpt_tx_error),
                .o_ptp          (adpt_tx_ptp),
                .o_skip_crc     (adpt_tx_skip_crc)
            );
        end

        // TX deskew logic
        alt_ehipc3_fm_tx_deskew #(
            .LANES          (1)
        ) i_tx_dsk (
            .i_clk          (i_sl_clk_tx),
            .i_resetn       (!ehip_csr_reset_sync_tx_clk),
            .o_dsk          (o_sl_tx_aib_dsk)
        );
    end // block: SL_TX_ADAPTER
    else
    begin
        assign o_sl_tx_ready    = 1'b0;

        assign adpt_tx_data     = 64'h0;
        assign adpt_tx_valid    = 1'b0;
        assign adpt_tx_inframe  = 1'b0;
        assign adpt_tx_empty    = 3'b000;
        assign adpt_tx_error    = 1'b0;
        assign adpt_tx_skip_crc = 1'b0;
        assign o_sl_tx_aib_dsk  = 1'b0;
    end
    endgenerate

    generate
    if ((((core_variant == 0) ||
          (core_variant == 1)) &&
         ((ehip_mode_sl == "ehip_mac") ||
          (ehip_mode_sl == "ehip_mac_no_fec"))) ||
         ((core_variant == 3) && (active_channel == 0)))
    begin : SL_RX_ADAPTER

        alt_ehipc3_fm_sl_ptp_rx_deskew #(
            .ENABLE_PTP_RX_DESKEW       (ENABLE_PTP && ENABLE_PTP_RX_DESKEW)
        ) i_sl_rx_deskew (
            // Configuration
            .i_enable_ptp               (i_enable_ptp),

            // Clock
            .i_clk                      (i_sl_clk_rx),

            // Reset
            .i_rx_rst_n                 (ehip_rx_reset_sync_2n),
	    .i_rx_rst_n1		(ehip_rx_reset_sync_2n),

            // PTP channels RX deskew
            .i_sl_ptp_rx_aib_dsk_done   (i_sl_ptp_rx_aib_dsk_done),

            // Data Path + PTP channels RX deskew
            .o_sl_ptp_rx_aib_dsk_done   (ptp_rx_aib_dsk_done),

            // RX data path
            .i_sl_rx_data               (i_sl_rx_data),
            .i_sl_rx_valid              (i_sl_rx_valid),
            .i_sl_rx_inframe            (i_sl_rx_inframe),
            .i_sl_rx_empty              (i_sl_rx_empty),
            .i_sl_rx_error              (i_sl_rx_error),
            .i_sl_rx_fcs_error          (i_sl_rx_fcs_error),
            .i_sl_rx_status             (i_sl_rx_status),

            .o_sl_rx_data               (dsk_rx_data),
            .o_sl_rx_valid              (dsk_rx_valid),
            .o_sl_rx_inframe            (dsk_rx_inframe),
            .o_sl_rx_empty              (dsk_rx_empty),
            .o_sl_rx_error              (dsk_rx_error),
            .o_sl_rx_fcs_error          (dsk_rx_fcs_error),
            .o_sl_rx_status             (dsk_rx_status),

            // RX PTP timestamp
            .i_sl_ptp_rx_ts             (i_sl_ptp_rx_ts),
            .o_sl_ptp_rx_ts             (dsk_ptp_rx_ts),

            // RX AM pulse
            .i_sl_rx_am                 (i_sl_rx_am),
            .o_sl_rx_am                 (dsk_rx_am)
        );

        if (ENABLE_ASYNC_ADAPTERS_SL == 1) begin
            alt_ehipc3_fm_sl_adapter_rx_async #(
                .NUM_CHANNELS   (sl_num_lanes),
                .WORD_WIDTH     (64),
                .EMPTY_BITS     (3),
                .PTP_WIDTH      (RX_PTP_WIDTH)
            ) i_sl_ehip_adapter_rx_async (
                .i_clk          (i_sl_clk_rx),
                .i_sl_async_clk_rx  (i_sl_async_clk_rx),
                .i_reset        (ehip_rx_reset_sync_2),
		.i_reset_1	(ehip_rx_reset_sync_2),

                .i_valid        (adpt_rx_valid),
                .i_data         (adpt_rx_data),
                .i_inframe      (adpt_rx_inframe),
                .i_empty        (adpt_rx_empty),
                .i_error        (adpt_rx_error),
                .i_fcs_error    (adpt_rx_fcs_error),
                .i_status       (adpt_rx_status),
                .i_ptp          (int_sl_rx_ptp),

                .o_data         (o_sl_rx_data),
                .o_valid        (o_sl_rx_valid),
                .o_sop          (o_sl_rx_startofpacket),
                .o_eop          (o_sl_rx_endofpacket),
                .o_empty        (o_sl_rx_empty),
                .o_error        (o_sl_rx_error),
                .o_status       (o_sl_rxstatus_data),
                .o_ptp          (o_sl_ptp_rx_its)
            );
        end
        else begin
            alt_ehipc3_fm_sl_adapter_rx #(
                .NUM_CHANNELS   (sl_num_lanes),
                .WORD_WIDTH     (64),
                .EMPTY_BITS     (3),
                .PTP_WIDTH      (RX_PTP_WIDTH)
            ) i_sl_ehip_adapter_rx (
                .i_clk          (i_sl_clk_rx),
                .i_reset        (ehip_rx_reset_sync_2),
		.i_reset_1	(ehip_rx_reset_sync_2),

                .i_valid        (adpt_rx_valid),
                .i_data         (adpt_rx_data),
                .i_inframe      (adpt_rx_inframe),
                .i_empty        (adpt_rx_empty),
                .i_error        (adpt_rx_error),
                .i_fcs_error    (adpt_rx_fcs_error),
                .i_status       (adpt_rx_status),
                .i_ptp          (int_sl_rx_ptp),

                .o_data         (o_sl_rx_data),
                .o_valid        (o_sl_rx_valid),
                .o_sop          (o_sl_rx_startofpacket),
                .o_eop          (o_sl_rx_endofpacket),
                .o_empty        (o_sl_rx_empty),
                .o_error        (o_sl_rx_error),
                .o_status       (o_sl_rxstatus_data),
                .o_ptp          (o_sl_ptp_rx_its)
            );
            end
        assign o_sl_rxstatus_valid = o_sl_rx_valid & o_sl_rx_endofpacket;
    end // block: SL_RX_ADAPTER
    else
    begin
        assign o_sl_rx_data             = 64'h0;
        assign o_sl_rx_valid            = 1'b0;
        assign o_sl_rx_startofpacket    = 1'b0;
        assign o_sl_rx_endofpacket      = 1'b0;
        assign o_sl_rx_empty            = 3'b000;
        assign o_sl_rx_error            = 6'h0;
        assign o_sl_rxstatus_data       = 40'h0;
        assign o_sl_rxstatus_valid      = 1'b0;

        assign o_sl_ptp_rx_its          = 96'h0;
    end
    endgenerate

    reg                     req_tx_ui_stky;
    wire                    req_tx_ui_ready;
    reg                     req_rx_ui_stky;
    wire                    req_rx_ui_ready;

    wire                    sptp_calibrate;
    wire                    sptp_tx_error_valid;
    wire  [31:0]            sptp_tx_error;
    wire                    sptp_rx_error_valid;
    wire  [31:0]            sptp_rx_error;
    wire                    sptp_ts_format;
    wire  [31:0]            sptp_tx_ui;
    wire  [31:0]            sptp_rx_ui;
    wire                    sptp_req_tx_ui_load;
    wire                    sptp_req_rx_ui_load;
    wire  [31:0]            sptp_tx_ui_cc;
    wire  [31:0]            sptp_rx_ui_cc;
    wire                    sptp_req_tx_ui_load_cc;
    wire                    sptp_req_rx_ui_load_cc;
    wire  [31:0]            sptp_tpiso;
    wire  [31:0]            sptp_rsipo;
    wire  [31:0]            sptp_rxalign_offset;

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
    if ((((core_variant == 3) && (active_channel == 0)) &&
        (ENABLE_PTP != 0)))
    begin : SL_PTP

        always @(posedge i_sl_clk_tx) begin
            if(ehip_tx_reset_sync_2) begin
                ptp_dly_tx_inframe  <= {TX_PTP_DLY{1'b0}};
                ptp_dly_tx_empty    <= {TX_PTP_DLY{3'h0}};
                ptp_dly_tx_error    <= {TX_PTP_DLY{1'b0}};
                ptp_dly_tx_skip_crc <= {TX_PTP_DLY{1'b0}};
            end
            else begin
                if(adpt_tx_valid) begin
                    ptp_dly_tx_inframe  <= {ptp_dly_tx_inframe  [TX_PTP_DLY-2:0], adpt_tx_inframe};
                    ptp_dly_tx_empty    <= {ptp_dly_tx_empty    [TX_PTP_DLY-2:0], adpt_tx_empty};
                    ptp_dly_tx_error    <= {ptp_dly_tx_error    [TX_PTP_DLY-2:0], adpt_tx_error};
                    ptp_dly_tx_skip_crc <= {ptp_dly_tx_skip_crc [TX_PTP_DLY-2:0], adpt_tx_skip_crc};
                end
            end
        end

        always @(posedge i_sl_clk_tx) begin
            if(adpt_tx_valid) begin
                ptp_dly_tx_data     <= {ptp_dly_tx_data     [TX_PTP_DLY-2:0], adpt_tx_data};
            end
        end

        assign adpt_tx_sop = adpt_tx_inframe && !ptp_dly_tx_inframe[0];

        always @(posedge i_sl_clk_tx) begin
            ptp_dly_tx_data_r       <= ptp_dly_tx_data       [TX_PTP_DLY-1];

            if(ehip_tx_reset_sync_2) begin
                ptp_dly_tx_valid_r      <= 1'b0;
                ptp_dly_tx_inframe_r    <= 1'b0;
                ptp_dly_tx_empty_r      <= 3'h0;
                ptp_dly_tx_error_r      <= 1'b0;
                ptp_dly_tx_skip_crc_r   <= 1'b0;
            end
            else begin
                ptp_dly_tx_valid_r      <= adpt_tx_valid;
                ptp_dly_tx_inframe_r    <= ptp_dly_tx_inframe    [TX_PTP_DLY-1];
                ptp_dly_tx_empty_r      <= ptp_dly_tx_empty      [TX_PTP_DLY-1];
                ptp_dly_tx_error_r      <= ptp_dly_tx_error      [TX_PTP_DLY-1];
                ptp_dly_tx_skip_crc_r   <= ptp_dly_tx_skip_crc   [TX_PTP_DLY-1];
            end
        end

        assign ptp_tx_data      = ptp_dly_tx_data_r;
        assign ptp_tx_inframe   = ptp_dly_tx_inframe_r;
        assign ptp_tx_empty     = ptp_dly_tx_empty_r;
        assign ptp_tx_error     = ptp_dly_tx_error_r;
        assign ptp_tx_skip_crc  = ptp_dly_tx_skip_crc_r;

        always @(posedge i_sl_clk_rx) begin
            if(ehip_rx_reset_sync_2) begin
                ptp_dly_rx_valid     <= {RX_PTP_DLY{1'b0}};
                ptp_dly_rx_inframe   <= {RX_PTP_DLY{1'b0}};
                ptp_dly_rx_empty     <= {RX_PTP_DLY{3'h0}};
                ptp_dly_rx_error     <= {RX_PTP_DLY{2'b0}};
                ptp_dly_rx_fcs_error <= {RX_PTP_DLY{1'b0}};
                ptp_dly_rx_status    <= {RX_PTP_DLY{3'b0}};
            end
            else begin
                if(dsk_rx_valid) begin
                    ptp_dly_rx_valid     <= {ptp_dly_rx_valid    [RX_PTP_DLY-2:0], dsk_rx_valid};
                    ptp_dly_rx_inframe   <= {ptp_dly_rx_inframe  [RX_PTP_DLY-2:0], dsk_rx_inframe};
                    ptp_dly_rx_empty     <= {ptp_dly_rx_empty    [RX_PTP_DLY-2:0], dsk_rx_empty};
                    ptp_dly_rx_error     <= {ptp_dly_rx_error    [RX_PTP_DLY-2:0], dsk_rx_error};
                    ptp_dly_rx_fcs_error <= {ptp_dly_rx_fcs_error[RX_PTP_DLY-2:0], dsk_rx_fcs_error};
                    ptp_dly_rx_status    <= {ptp_dly_rx_status   [RX_PTP_DLY-2:0], dsk_rx_status};
                end
            end
        end

        always @(posedge i_sl_clk_rx) begin
            if(dsk_rx_valid) begin
                ptp_dly_rx_data      <= {ptp_dly_rx_data     [RX_PTP_DLY-2:0], dsk_rx_data};
            end
        end

        assign ptp_rx_valid     = ptp_dly_rx_valid      [RX_PTP_DLY-1] & dsk_rx_valid;
        assign ptp_rx_data      = ptp_dly_rx_data       [RX_PTP_DLY-1];
        assign ptp_rx_inframe   = ptp_dly_rx_inframe    [RX_PTP_DLY-1];
        assign ptp_rx_empty     = ptp_dly_rx_empty      [RX_PTP_DLY-1];
        assign ptp_rx_error     = ptp_dly_rx_error      [RX_PTP_DLY-1];
        assign ptp_rx_fcs_error = ptp_dly_rx_fcs_error  [RX_PTP_DLY-1];
        assign ptp_rx_status    = ptp_dly_rx_status     [RX_PTP_DLY-1];

        assign sl_tx_ptp = {i_sl_ptp_ins_ets,       // 1-bit
                            i_sl_ptp_ins_cf,        // 1-bit
                            i_sl_ptp_ins_zero_csum, // 1-bit
                            i_sl_ptp_ins_update_eb, // 1-bit
                            i_sl_ptp_ts_format,     // 1-bit
                            i_sl_ptp_ts_offset,     // 16-bit
                            i_sl_ptp_cf_offset,     // 16-bit
                            i_sl_ptp_csum_offset,   // 16-bit
                            i_sl_ptp_ed_offset,     // 16-bit
                            i_sl_ptp_tx_its,        // 96-bit
                            i_sl_ptp_ts_req,        // 1-bit
                            i_sl_ptp_fp             // 8-bit
                           };

        assign {adpt_ptp_ins_ets,       // 1-bit
                adpt_ptp_ins_cf,        // 1-bit
                adpt_ptp_ins_zero_csum, // 1-bit
                adpt_ptp_ins_update_eb, // 1-bit
                adpt_ptp_ts_format,     // 1-bit
                adpt_ptp_ts_offset,     // 16-bit
                adpt_ptp_cf_offset,     // 16-bit
                adpt_ptp_csum_offset,   // 16-bit
                adpt_ptp_ed_offset,     // 16-bit
                adpt_ptp_tx_its,        // 96-bit
                adpt_ptp_ts_req,        // 1-bit
                adpt_ptp_fp             // 8-bit
               } = adpt_tx_ptp;

    if (ENHANCED_PTP_ACCURACY == 1) begin

    wire [31:0]                 tx_apulse_period;
    wire [31:0]                 tx_apulse_skip;
    wire [31:0]                 tx_apulse_roll_dly;
    wire [31:0]                 tx_apulse_cnt_pow2;
    wire [31:0]                 tx_apulse_cnt;
    wire [31:0]                 tx_sn_config;

    wire [31:0]                 rx_apulse_period;
    wire [31:0]                 rx_apulse_skip;
    wire [31:0]                 rx_apulse_roll_dly;
    wire [31:0]                 rx_apulse_cnt_pow2;
    wire [31:0]                 rx_apulse_cnt;
    wire [31:0]                 rx_sn_config;

    wire [31:0]                 sn_pll_sclk_period;

    wire [31:0]                 tx_apulse_rt_period;
    wire [31:0]                 tx_apulse_sn_period;
    wire [31:0]                 tx_apulse_err_period;
    wire [31:0]                 tx_apulse_err2_latency;
    wire [31:0]                 rx_apulse_rt_period;
    wire [31:0]                 rx_apulse_sn_period;
    wire [31:0]                 rx_apulse_err_period;
    wire [31:0]                 rx_apulse_err2_latency;

    wire [31:0]                 tx_w_apulse_rt_period;
    wire [31:0]                 tx_w_apulse_sn_period;
    wire [31:0]                 tx_w_apulse_err_period;
    wire [31:0]                 tx_w_apulse_err2_latency;
    wire [31:0]                 rx_w_apulse_rt_period;
    wire [31:0]                 rx_w_apulse_sn_period;
    wire [31:0]                 rx_w_apulse_err_period;
    wire [31:0]                 rx_w_apulse_err2_latency;
///
   logic [95:0] tx_tam_dbg;
   logic [95:0] rx_tam_dbg;

   logic [31:0] tx_tam_adjust_avg_dbg;
   logic [31:0] rx_tam_adjust_avg_dbg;

   logic [31:0] tx_ui_r_dbg;
   logic [31:0] rx_ui_r_dbg;

   logic [11:0] tx_tam_adjust_ui_r_dbg;
   logic [11:0] rx_tam_adjust_ui_r_dbg;

   logic [43:0] tx_tam_adjust_dbg;
   logic [43:0] rx_tam_adjust_no_adj_dbg;

   logic [31:0] tx_tam_adj_dbg;
   logic [31:0] rx_tam_adj_dbg;

   logic [3:0]  tx_state_rollover;
   logic [3:0]  rx_state_rollover;
   logic [3:0]  tx_w_state_rollover;
   logic [3:0]  rx_w_state_rollover;

   logic [3:0]  tx_state_latencyphz;
   logic [3:0]  rx_state_latencyphz;
   logic [3:0]  tx_w_state_latencyphz;
   logic [3:0]  rx_w_state_latencyphz;

   logic [3:0]  tx_state_transition;
   logic [3:0]  rx_state_transition;

   logic [31:0]  tx_apulse_count;
   logic [31:0]  rx_apulse_count;
   logic [31:0]  tx_w_apulse_count;
   logic [31:0]  rx_w_apulse_count;

   logic [31:0]  tx_skip_ini;
   logic [31:0]  rx_skip_ini;
   logic [31:0]  tx_w_skip_ini;
   logic [31:0]  rx_w_skip_ini;
///

    wire [31:0]                 txrx_dt_status;
    wire [31:0]                 rx_dt_reg;
    wire [31:0]                 tx_dt_reg;

        if (ENHANCED_PTP_DBG == 1) begin  // ENHANCED_PTP_DBG


        alt_ehipc3_fm_sl_ptp_avmm_csr_bank_sn_dbg #(
            .SIM_MODE               (SIM_MODE_INT),
            .ENHANCED_PTP_DBG       (ENHANCED_PTP_DBG),
            .ehip_rate_sl           (ehip_rate_sl)
        ) ptp_csr_bank_sn (
            .i_avmm_clk             (i_reconfig_clk),
            .i_avmm_rst_n           (!i_reconfig_reset),
            .o_avmm_readdata        (o_sl_avmm_readdata),
            .i_avmm_write           (i_sl_avmm_write),
            .i_avmm_read            (i_sl_avmm_read),
            .i_avmm_writedata       (i_sl_avmm_writedata),
            .o_avmm_waitrequest     (o_sl_avmm_waitrequest),
            .i_avmm_address         (i_sl_avmm_address),

            .i_tx_tam_capture       (tx_tam_capture_cc),
            .i_tx_tam_count         (tx_tam_count_cc),
            .i_tx_tam_cap_valid     (tx_tam_cap_valid_cc),
            .i_rx_tam_capture       (rx_tam_capture_cc),
            .i_rx_tam_count         (rx_tam_count_cc),
            .i_rx_tam_cap_valid     (rx_tam_cap_valid_cc),

            // 1ns
            .i_txrx_dt_status        (txrx_dt_status),
            .i_rx_dt_reg             (rx_dt_reg),
            .i_tx_dt_reg             (tx_dt_reg),

            .i_tx_apulse_rt_period   (tx_apulse_rt_period),
            .i_tx_apulse_sn_period   (tx_apulse_sn_period),
            .i_tx_apulse_err_period  (tx_apulse_err_period),
            .i_tx_apulse_err2_latency (tx_apulse_err2_latency),
            .i_rx_apulse_rt_period   (rx_apulse_rt_period),
            .i_rx_apulse_sn_period   (rx_apulse_sn_period),
            .i_rx_apulse_err_period  (rx_apulse_err_period),
            .i_rx_apulse_err2_latency (rx_apulse_err2_latency),

            .i_tx_w_apulse_rt_period   (tx_w_apulse_rt_period),
            .i_tx_w_apulse_sn_period   (tx_w_apulse_sn_period),
            .i_tx_w_apulse_err_period  (tx_w_apulse_err_period),
            .i_tx_w_apulse_err2_latency (tx_w_apulse_err2_latency),
            .i_rx_w_apulse_rt_period   (rx_w_apulse_rt_period),
            .i_rx_w_apulse_sn_period   (rx_w_apulse_sn_period),
            .i_rx_w_apulse_err_period  (rx_w_apulse_err_period),
            .i_rx_w_apulse_err2_latency (rx_w_apulse_err2_latency),
////
            .tx_tam_dbg            (tx_tam_dbg),
            .rx_tam_dbg            (rx_tam_dbg),
            .tx_tam_adjust_avg_dbg            (tx_tam_adjust_avg_dbg),
            .rx_tam_adjust_avg_dbg            (rx_tam_adjust_avg_dbg),
            .tx_ui_r_dbg            (tx_ui_r_dbg),
            .rx_ui_r_dbg            (rx_ui_r_dbg),
            .tx_tam_adjust_ui_r_dbg            (tx_tam_adjust_ui_r_dbg),
            .rx_tam_adjust_ui_r_dbg            (rx_tam_adjust_ui_r_dbg),
            .tx_tam_adjust_dbg            (tx_tam_adjust_dbg),
            .rx_tam_adjust_no_adj_dbg            (rx_tam_adjust_no_adj_dbg),
            .tx_tam_adj_dbg            (tx_tam_adj_dbg),
            .rx_tam_adj_dbg            (rx_tam_adj_dbg),

            .i_tx_state_rollover    (tx_state_rollover),
            .i_rx_state_rollover    (rx_state_rollover),
            .i_tx_w_state_rollover  (tx_w_state_rollover),
            .i_rx_w_state_rollover  (rx_w_state_rollover),

            .i_tx_state_latencyphz    (tx_state_latencyphz),
            .i_rx_state_latencyphz    (rx_state_latencyphz),
            .i_tx_w_state_latencyphz  (tx_w_state_latencyphz),
            .i_rx_w_state_latencyphz  (rx_w_state_latencyphz),

            .i_tx_state_transition    (tx_state_transition),
            .i_rx_state_transition    (rx_state_transition),

            .i_tx_apulse_count    (tx_apulse_count),
            .i_rx_apulse_count    (rx_apulse_count),
            .i_tx_w_apulse_count  (tx_w_apulse_count),
            .i_rx_w_apulse_count  (rx_w_apulse_count),

            .i_tx_skip_ini    (tx_skip_ini),
            .i_rx_skip_ini    (rx_skip_ini),
            .i_tx_w_skip_ini  (tx_w_skip_ini),
            .i_rx_w_skip_ini  (rx_w_skip_ini),

////
            .o_tx_apulse_period      (tx_apulse_period),
            .o_tx_apulse_skip        (tx_apulse_skip),
            .o_tx_apulse_roll_dly    (tx_apulse_roll_dly),
            .o_tx_apulse_cnt_pow2    (tx_apulse_cnt_pow2),
            .o_tx_apulse_cnt         (tx_apulse_cnt),
            .o_tx_sn_config          (tx_sn_config),

            .o_rx_apulse_period      (rx_apulse_period),
            .o_rx_apulse_skip        (rx_apulse_skip),
            .o_rx_apulse_roll_dly    (rx_apulse_roll_dly),
            .o_rx_apulse_cnt_pow2    (rx_apulse_cnt_pow2),
            .o_rx_apulse_cnt         (rx_apulse_cnt),
            .o_rx_sn_config          (rx_sn_config),

            .o_sn_pll_sclk_period    (sn_pll_sclk_period),

            .o_calibrate            (sptp_calibrate),
            .i_tx_calibrate_done    (o_sl_tx_sel_sclk_return),
            .i_rx_calibrate_done    (o_sl_rx_sel_sclk_return),
            .i_tx_error_valid       (sptp_tx_error_valid),
            .i_tx_error             (sptp_tx_error),
            .i_rx_error_valid       (sptp_rx_error_valid),
            .i_rx_error             (sptp_rx_error),
            .o_ts_format            (sptp_ts_format),
            .o_tx_ui                (sptp_tx_ui),
            .o_rx_ui                (sptp_rx_ui),
            .o_req_tx_ui_load       (sptp_req_tx_ui_load),
            .o_req_rx_ui_load       (sptp_req_rx_ui_load),
            .o_tpiso                (sptp_tpiso),
            .o_rsipo                (sptp_rsipo),
            .o_rxalign_offset       (sptp_rxalign_offset)
        );
        alt_ehipc3_fm_sl_ptp_sn_dbg #(
            .ENHANCED_PTP_ACCURACY  (ENHANCED_PTP_ACCURACY),
	    .ehip_rate_sl           (ehip_rate_sl),
            .SIM_MODE               (SIM_MODE_INT)
        ) soft_ptp_sn (
            // Configuration
            .i_enable_rsfec         (i_enable_rsfec),
            .i_tx_preamble_pass     (i_tx_preamble_pass),

            // System Interface
            .i_ptp_clk              (i_sl_clk_tx),

            .i_ptp_tx_clk           (i_sl_clk_tx_tod),
            .i_ptp_rx_clk           (i_sl_clk_rx_tod),

            .i_tx_rst_n             (ehip_tx_reset_sync_2n),
            .i_rx_rst_n             (ehip_rx_reset_sync_2n),
            .i_tx_rst_n1            (ehip_tx_reset_sync_1n),
            .i_rx_rst_n1            (ehip_rx_reset_sync_1n),
            .i_tx_rst_n2            (ehip_tx_reset_sync_2n),
            .i_rx_rst_n2            (ehip_rx_reset_sync_2n),
            .i_rx_rst_n3            (ehip_rx_reset_sync_2n),
            .i_tx_rst_n3            (ehip_tx_reset_sync_2n),
	    .i_rx_rst_n4	    (ehip_rx_reset_sync_2n),
	    .i_tx_rst_n4            (ehip_tx_reset_sync_2n),
	    .i_tx_rst_n5            (ehip_tx_reset_sync_2n),
            .i_tx_rst_n6	    (ehip_tx_reset_sync_2n),
	    .i_tx_rst_n7	    (ehip_tx_reset_sync_2n),
	    .i_tx_rst_n8	    (ehip_tx_reset_sync_2n),
	    .i_tx_rst_n9	    (ehip_tx_reset_sync_2n),
	    .i_tx_rst_n10	    (ehip_tx_reset_sync_2n),

            .i_rx_lock              (1'b1),
            .i_pcs_fully_aligned    (i_sl_rx_pcs_fully_aligned),
            .i_all_ready            (all_ready),

            // AVMM CSR Bank Interface
            .o_tx_error_valid       (sptp_tx_error_valid),
            .o_tx_error             (sptp_tx_error),
            .o_rx_error_valid       (sptp_rx_error_valid),
            .o_rx_error             (sptp_rx_error),
            .i_ts_format            (sptp_ts_format),
            .i_tx_ui                (sptp_tx_ui_cc),
            .i_rx_ui                (sptp_rx_ui_cc),
            .i_req_tx_ui_load       (sptp_req_tx_ui_load_cc),
            .i_req_rx_ui_load       (sptp_req_rx_ui_load_cc),
            .i_tpiso                (sptp_tpiso),
            .i_rsipo                (sptp_rsipo),
            .i_rx_align_offset      (sptp_rxalign_offset),

            // User Interface: TOD Interface
            .i_ptp_tx_tod           (i_ptp_tx_tod),
            .i_ptp_rx_tod           (i_ptp_rx_tod),

            .i_ptp_update           (1'b0), // Unused

            // User Interface: PTP Status
            .o_tx_ptp_ready         (o_sl_tx_ptp_ready),
            .o_rx_ptp_ready         (o_sl_rx_ptp_ready),

            // User Interface: TX Framing Interface
            .i_tx_valid             (adpt_tx_valid),
            .i_tx_sop               (adpt_tx_sop),
            .i_tx_eop               (1'b0), // Unused
            .i_tx_inframe           (adpt_tx_inframe),
            .i_tx_skip_crc          (adpt_tx_skip_crc),

            // User Interface: TX 1-step Command
            .i_ptp_ins_ets          (adpt_ptp_ins_ets),
            .i_ptp_ins_cf           (adpt_ptp_ins_cf),
            .i_ptp_zero_csum        (adpt_ptp_ins_zero_csum),
            .i_ptp_update_eb        (adpt_ptp_ins_update_eb),
            .i_ptp_ts_format        (adpt_ptp_ts_format),
            .i_ptp_asym             (1'b0),
            .i_ptp_ts_offset        (adpt_ptp_ts_offset),
            .i_ptp_cf_offset        (adpt_ptp_cf_offset),
            .i_ptp_csum_offset      (adpt_ptp_csum_offset),
            .i_ptp_eb_offset        (adpt_ptp_ed_offset),
            .i_ptp_tx_its           (adpt_ptp_tx_its),

            // User Interface: TX 2-step Timestamp Request
            .i_ptp_ts_req           (adpt_ptp_ts_req),
            .i_ptp_fp               (adpt_ptp_fp),

            // User Interface: TX 2-step Timestamp Return
            .o_ptp_ets_valid        (sl_ptp_ets_valid_int),
            .o_ptp_ets              (sl_ptp_ets_int),
            .o_ptp_ets_fp           (sl_ptp_ets_fp_int),

            // User Interface: RX Timestamp
            .o_ptp_rx_its           (int_sl_rx_ptp),
            .o_ptp_rx_its_valid     (),

            // EHIP Interface: TX 1-step and 2-step Command
            .o_ptp_tx_fp            (o_sl_ptp_tx_fp),
            .o_ptp_ins_type         (o_sl_ptp_ins_type),
            .o_ptp_byte_offset      (o_sl_ptp_byte_offset),
            .o_ptp_ts               (o_sl_ptp_ts),

            // EHIP Interface: TX 2-step Timestamp
            .i_ptp_tx_ts_valid      (i_sl_ptp_tx_ts_valid),
            .i_ptp_tx_ts            (i_sl_ptp_tx_ts),
            .i_ptp_tx_fp            (i_sl_ptp_tx_ts_fp),

            // EHIP Interface: RX Timestamp
            .i_rx_valid             (dsk_rx_valid),
            .i_rx_inframe           (dsk_rx_inframe),
            .i_ptp_rx_ts            (dsk_ptp_rx_ts),

            // EHIP Interface: Reference Timestamp
            .o_sclk                 	(o_sl_sclk),
	    .o_sl_tx_sclk_return_sync 	(int_sl_tx_sclk_return_sync),
            .o_sl_tx_sel_sclk_return	(o_sl_tx_sel_sclk_return),
            .o_sl_rx_sel_sclk_return	(o_sl_rx_sel_sclk_return),
            .i_tx_sclk_return       	(i_sl_tx_sclk_return),
            .i_rx_sclk_return       	(i_sl_rx_sclk_return),
            .i_tx_am                	(i_sl_tx_am),
            .i_rx_am                	(i_sl_rx_am),
            .i_rx_am_dsk            	(dsk_rx_am),

            // TAM capture and AM counts
            .o_tx_tam_capture       (tx_tam_capture),
            .o_tx_tam_count         (tx_tam_count),
            .o_tx_tam_cap_valid     (tx_tam_cap_valid),
            .o_rx_tam_capture       (rx_tam_capture),
            .o_rx_tam_count         (rx_tam_count),
            .o_rx_tam_cap_valid     (rx_tam_cap_valid),

            //1ns
            .i_ptp_sn_sclk          (i_ptp_sn_sclk),
            .o_txrx_dt_status       (txrx_dt_status),
            .o_rx_dt_reg            (rx_dt_reg),
            .o_tx_dt_reg            (tx_dt_reg),

            .o_tx_apulse_rt_period  (tx_apulse_rt_period),
            .o_tx_apulse_sn_period  (tx_apulse_sn_period),
            .o_tx_apulse_err_period (tx_apulse_err_period),
            .o_tx_apulse_err2_latency (tx_apulse_err2_latency),
            .o_rx_apulse_rt_period  (rx_apulse_rt_period),
            .o_rx_apulse_sn_period  (rx_apulse_sn_period),
            .o_rx_apulse_err_period (rx_apulse_err_period),
            .o_rx_apulse_err2_latency (rx_apulse_err2_latency),

            .o_tx_w_apulse_rt_period  (tx_w_apulse_rt_period),
            .o_tx_w_apulse_sn_period  (tx_w_apulse_sn_period),
            .o_tx_w_apulse_err_period (tx_w_apulse_err_period),
            .o_tx_w_apulse_err2_latency (tx_w_apulse_err2_latency),
            .o_rx_w_apulse_rt_period  (rx_w_apulse_rt_period),
            .o_rx_w_apulse_sn_period  (rx_w_apulse_sn_period),
            .o_rx_w_apulse_err_period (rx_w_apulse_err_period),
            .o_rx_w_apulse_err2_latency (rx_w_apulse_err2_latency),
////
            .tx_tam_dbg            (tx_tam_dbg),
            .rx_tam_dbg            (rx_tam_dbg),
            .tx_tam_adjust_avg_dbg            (tx_tam_adjust_avg_dbg),
            .rx_tam_adjust_avg_dbg            (rx_tam_adjust_avg_dbg),
            .tx_ui_r_dbg            (tx_ui_r_dbg),
            .rx_ui_r_dbg            (rx_ui_r_dbg),
            .tx_tam_adjust_ui_r_dbg            (tx_tam_adjust_ui_r_dbg),
            .rx_tam_adjust_ui_r_dbg            (rx_tam_adjust_ui_r_dbg),
            .tx_tam_adjust_dbg            (tx_tam_adjust_dbg),
            .rx_tam_adjust_no_adj_dbg            (rx_tam_adjust_no_adj_dbg),
            .tx_tam_adj_dbg            (tx_tam_adj_dbg),
            .rx_tam_adj_dbg            (rx_tam_adj_dbg),

            .o_tx_state_rollover    (tx_state_rollover),
            .o_rx_state_rollover    (rx_state_rollover),
            .o_tx_w_state_rollover  (tx_w_state_rollover),
            .o_rx_w_state_rollover  (rx_w_state_rollover),

            .o_tx_state_latencyphz    (tx_state_latencyphz),
            .o_rx_state_latencyphz    (rx_state_latencyphz),
            .o_tx_w_state_latencyphz  (tx_w_state_latencyphz),
            .o_rx_w_state_latencyphz  (rx_w_state_latencyphz),

            .o_tx_state_transition    (tx_state_transition),
            .o_rx_state_transition    (rx_state_transition),

            .o_tx_apulse_count    (tx_apulse_count),
            .o_rx_apulse_count    (rx_apulse_count),
            .o_tx_w_apulse_count  (tx_w_apulse_count),
            .o_rx_w_apulse_count  (rx_w_apulse_count),

            .o_tx_skip_ini    (tx_skip_ini),
            .o_rx_skip_ini    (rx_skip_ini),
            .o_tx_w_skip_ini  (tx_w_skip_ini),
            .o_rx_w_skip_ini  (rx_w_skip_ini),

////
            .i_tx_apulse_period     (tx_apulse_period),
            .i_tx_apulse_skip       (tx_apulse_skip),
            .i_tx_apulse_roll_dly   (tx_apulse_roll_dly),
            .i_tx_apulse_cnt_pow2   (tx_apulse_cnt_pow2),
            .i_tx_apulse_cnt        (tx_apulse_cnt),
            .i_tx_sn_config         (tx_sn_config),

            .i_rx_apulse_period     (rx_apulse_period),
            .i_rx_apulse_skip       (rx_apulse_skip),
            .i_rx_apulse_roll_dly   (rx_apulse_roll_dly),
            .i_rx_apulse_cnt_pow2   (rx_apulse_cnt_pow2),
            .i_rx_apulse_cnt        (rx_apulse_cnt),
            .i_rx_sn_config         (rx_sn_config),

            .i_sn_pll_sclk_period   (sn_pll_sclk_period),

            // Deskew status
            .i_ptp_rx_aib_dsk_done  (ptp_rx_aib_dsk_done),
            .o_ptp_rx_aib_dsk_done  (ptp_rx_aib_dsk_done_stm),

            // Before stage 2 deskew signals
            .i_rx_am_b4_dsk (i_sl_rx_am),
            .i_rx_valid_b4_dsk (i_sl_rx_valid),
            .i_sl_ptp_rx_aib_dsk_done_b4_dsk(i_sl_ptp_rx_aib_dsk_done)

        );

        end else begin // ENHANCED_PTP_DBG

        alt_ehipc3_fm_sl_ptp_avmm_csr_bank_sn #(
            .SIM_MODE               (SIM_MODE_INT),
            .ENHANCED_PTP_DBG       (ENHANCED_PTP_DBG),
            .ehip_rate_sl           (ehip_rate_sl)
        ) ptp_csr_bank_sn (
            .i_avmm_clk             (i_reconfig_clk),
            .i_avmm_rst_n           (!i_reconfig_reset),
            .o_avmm_readdata        (o_sl_avmm_readdata),
            .i_avmm_write           (i_sl_avmm_write),
            .i_avmm_read            (i_sl_avmm_read),
            .i_avmm_writedata       (i_sl_avmm_writedata),
            .o_avmm_waitrequest     (o_sl_avmm_waitrequest),
            .i_avmm_address         (i_sl_avmm_address),

            .i_tx_tam_capture       (tx_tam_capture_cc),
            .i_tx_tam_count         (tx_tam_count_cc),
            .i_tx_tam_cap_valid     (tx_tam_cap_valid_cc),
            .i_rx_tam_capture       (rx_tam_capture_cc),
            .i_rx_tam_count         (rx_tam_count_cc),
            .i_rx_tam_cap_valid     (rx_tam_cap_valid_cc),

            // 1ns
            .i_txrx_dt_status        (txrx_dt_status),

            .o_calibrate            (sptp_calibrate),
            .i_tx_calibrate_done    (o_sl_tx_sel_sclk_return),
            .i_rx_calibrate_done    (o_sl_rx_sel_sclk_return),
            .i_tx_error_valid       (sptp_tx_error_valid),
            .i_tx_error             (sptp_tx_error),
            .i_rx_error_valid       (sptp_rx_error_valid),
            .i_rx_error             (sptp_rx_error),
            .o_ts_format            (sptp_ts_format),
            .o_tx_ui                (sptp_tx_ui),
            .o_rx_ui                (sptp_rx_ui),
            .o_req_tx_ui_load       (sptp_req_tx_ui_load),
            .o_req_rx_ui_load       (sptp_req_rx_ui_load),
            .o_tpiso                (sptp_tpiso),
            .o_rsipo                (sptp_rsipo),
            .o_rxalign_offset       (sptp_rxalign_offset)
        );

       alt_ehipc3_fm_sl_ptp_sn #(
            .ENHANCED_PTP_ACCURACY  (ENHANCED_PTP_ACCURACY),
            .ehip_rate_sl           (ehip_rate_sl),
            .SIM_MODE               (SIM_MODE_INT)
        ) soft_ptp_sn (
            // Configuration
            .i_enable_rsfec         (i_enable_rsfec),
            .i_tx_preamble_pass     (i_tx_preamble_pass),

            // System Interface
            .i_ptp_clk              (i_sl_clk_tx),

            .i_ptp_tx_clk           (i_sl_clk_tx_tod),
            .i_ptp_rx_clk           (i_sl_clk_rx_tod),

            .i_tx_rst_n             (ehip_tx_reset_sync_2n),
            .i_rx_rst_n             (ehip_rx_reset_sync_2n),
            .i_tx_rst_n1            (ehip_tx_reset_sync_1n),
            .i_rx_rst_n1            (ehip_rx_reset_sync_1n),
            .i_tx_rst_n2            (ehip_tx_reset_sync_2n),
            .i_rx_rst_n2            (ehip_rx_reset_sync_2n),
            .i_rx_rst_n3            (ehip_rx_reset_sync_2n),
            .i_tx_rst_n3            (ehip_tx_reset_sync_2n),
            .i_rx_rst_n4            (ehip_rx_reset_sync_2n),
            .i_tx_rst_n4            (ehip_tx_reset_sync_2n),
            .i_tx_rst_n5            (ehip_tx_reset_sync_2n),
            .i_tx_rst_n6            (ehip_tx_reset_sync_2n),
            .i_tx_rst_n7            (ehip_tx_reset_sync_2n),
            .i_tx_rst_n8            (ehip_tx_reset_sync_2n),
            .i_tx_rst_n9            (ehip_tx_reset_sync_2n),
            .i_tx_rst_n10           (ehip_tx_reset_sync_2n),
            .i_tx_arst              (ehip_tx_reset_async_2),
            .i_rx_arst              (ehip_rx_reset_async_2),

            .i_rx_lock              (1'b1),
            .i_pcs_fully_aligned    (i_sl_rx_pcs_fully_aligned),
            .i_all_ready            (all_ready),

            // AVMM CSR Bank Interface
            .o_tx_error_valid       (sptp_tx_error_valid),
            .o_tx_error             (sptp_tx_error),
            .o_rx_error_valid       (sptp_rx_error_valid),
            .o_rx_error             (sptp_rx_error),
            .i_ts_format            (sptp_ts_format),
            .i_tx_ui                (sptp_tx_ui_cc),
            .i_rx_ui                (sptp_rx_ui_cc),
            .i_req_tx_ui_load       (sptp_req_tx_ui_load_cc),
            .i_req_rx_ui_load       (sptp_req_rx_ui_load_cc),
            .i_tpiso                (sptp_tpiso),
            .i_rsipo                (sptp_rsipo),
            .i_rx_align_offset      (sptp_rxalign_offset),

            // User Interface: TOD Interface
            .i_ptp_tx_tod           (i_ptp_tx_tod),
            .i_ptp_rx_tod           (i_ptp_rx_tod),

            .i_ptp_update           (1'b0), // Unused

            // User Interface: PTP Status
            .o_tx_ptp_ready         (o_sl_tx_ptp_ready),
            .o_rx_ptp_ready         (o_sl_rx_ptp_ready),

            // User Interface: TX Framing Interface
            .i_tx_valid             (adpt_tx_valid),
            .i_tx_sop               (adpt_tx_sop),
            .i_tx_eop               (1'b0), // Unused
            .i_tx_inframe           (adpt_tx_inframe),
            .i_tx_skip_crc          (adpt_tx_skip_crc),

            // User Interface: TX 1-step Command
            .i_ptp_ins_ets          (adpt_ptp_ins_ets),
            .i_ptp_ins_cf           (adpt_ptp_ins_cf),
            .i_ptp_zero_csum        (adpt_ptp_ins_zero_csum),
            .i_ptp_update_eb        (adpt_ptp_ins_update_eb),
            .i_ptp_ts_format        (adpt_ptp_ts_format),
            .i_ptp_asym             (1'b0),
            .i_ptp_ts_offset        (adpt_ptp_ts_offset),
            .i_ptp_cf_offset        (adpt_ptp_cf_offset),
            .i_ptp_csum_offset      (adpt_ptp_csum_offset),
            .i_ptp_eb_offset        (adpt_ptp_ed_offset),
            .i_ptp_tx_its           (adpt_ptp_tx_its),

            // User Interface: TX 2-step Timestamp Request
            .i_ptp_ts_req           (adpt_ptp_ts_req),
            .i_ptp_fp               (adpt_ptp_fp),

            // User Interface: TX 2-step Timestamp Return
            .o_ptp_ets_valid        (sl_ptp_ets_valid_int),
            .o_ptp_ets              (sl_ptp_ets_int),
            .o_ptp_ets_fp           (sl_ptp_ets_fp_int),

            // User Interface: RX Timestamp
            .o_ptp_rx_its           (int_sl_rx_ptp),
            .o_ptp_rx_its_valid     (),

            // EHIP Interface: TX 1-step and 2-step Command
            .o_ptp_tx_fp            (o_sl_ptp_tx_fp),
            .o_ptp_ins_type         (o_sl_ptp_ins_type),
            .o_ptp_byte_offset      (o_sl_ptp_byte_offset),
            .o_ptp_ts               (o_sl_ptp_ts),

            // EHIP Interface: TX 2-step Timestamp
            .i_ptp_tx_ts_valid      (i_sl_ptp_tx_ts_valid),
            .i_ptp_tx_ts            (i_sl_ptp_tx_ts),
            .i_ptp_tx_fp            (i_sl_ptp_tx_ts_fp),

            // EHIP Interface: RX Timestamp
            .i_rx_valid             (dsk_rx_valid),
            .i_rx_inframe           (dsk_rx_inframe),
            .i_ptp_rx_ts            (dsk_ptp_rx_ts),

            // EHIP Interface: Reference Timestamp
            .o_sclk                 	(o_sl_sclk),
            .o_sl_tx_sclk_return_sync	(int_sl_tx_sclk_return_sync),
            .o_sl_tx_sel_sclk_return	(o_sl_tx_sel_sclk_return),
            .o_sl_rx_sel_sclk_return	(o_sl_rx_sel_sclk_return),
            .i_tx_sclk_return       	(i_sl_tx_sclk_return),
            .i_rx_sclk_return       	(i_sl_rx_sclk_return),
            .i_tx_am                	(i_sl_tx_am),
            .i_rx_am                	(i_sl_rx_am),
            .i_rx_am_dsk            	(dsk_rx_am),

            // TAM capture and AM counts
            .o_tx_tam_capture       (tx_tam_capture),
            .o_tx_tam_count         (tx_tam_count),
            .o_tx_tam_cap_valid     (tx_tam_cap_valid),
            .o_rx_tam_capture       (rx_tam_capture),
            .o_rx_tam_count         (rx_tam_count),
            .o_rx_tam_cap_valid     (rx_tam_cap_valid),

            //1ns
            .i_ptp_sn_sclk          (i_ptp_sn_sclk),
            .o_txrx_dt_status       (txrx_dt_status),
            .o_rx_dt_reg            (rx_dt_reg),
            .o_tx_dt_reg            (tx_dt_reg),

            .o_tx_apulse_rt_period  (tx_apulse_rt_period),
            .o_tx_apulse_sn_period  (tx_apulse_sn_period),
            .o_tx_apulse_err_period (tx_apulse_err_period),
            .o_tx_apulse_err2_latency (tx_apulse_err2_latency),
            .o_rx_apulse_rt_period  (rx_apulse_rt_period),
            .o_rx_apulse_sn_period  (rx_apulse_sn_period),
            .o_rx_apulse_err_period (rx_apulse_err_period),
            .o_rx_apulse_err2_latency (rx_apulse_err2_latency),

            .o_tx_w_apulse_rt_period  (tx_w_apulse_rt_period),
            .o_tx_w_apulse_sn_period  (tx_w_apulse_sn_period),
            .o_tx_w_apulse_err_period (tx_w_apulse_err_period),
            .o_tx_w_apulse_err2_latency (tx_w_apulse_err2_latency),
            .o_rx_w_apulse_rt_period  (rx_w_apulse_rt_period),
            .o_rx_w_apulse_sn_period  (rx_w_apulse_sn_period),
            .o_rx_w_apulse_err_period (rx_w_apulse_err_period),
            .o_rx_w_apulse_err2_latency (rx_w_apulse_err2_latency),
////
            .tx_tam_dbg            (tx_tam_dbg),
            .rx_tam_dbg            (rx_tam_dbg),
            .tx_tam_adjust_avg_dbg            (tx_tam_adjust_avg_dbg),
            .rx_tam_adjust_avg_dbg            (rx_tam_adjust_avg_dbg),
            .tx_ui_r_dbg            (tx_ui_r_dbg),
            .rx_ui_r_dbg            (rx_ui_r_dbg),
            .tx_tam_adjust_ui_r_dbg            (tx_tam_adjust_ui_r_dbg),
            .rx_tam_adjust_ui_r_dbg            (rx_tam_adjust_ui_r_dbg),
            .tx_tam_adjust_dbg            (tx_tam_adjust_dbg),
            .rx_tam_adjust_no_adj_dbg            (rx_tam_adjust_no_adj_dbg),
            .tx_tam_adj_dbg            (tx_tam_adj_dbg),
            .rx_tam_adj_dbg            (rx_tam_adj_dbg),

            .o_tx_state_rollover    (tx_state_rollover),
            .o_rx_state_rollover    (rx_state_rollover),
            .o_tx_w_state_rollover  (tx_w_state_rollover),
            .o_rx_w_state_rollover  (rx_w_state_rollover),

            .o_tx_state_latencyphz    (tx_state_latencyphz),
            .o_rx_state_latencyphz    (rx_state_latencyphz),
            .o_tx_w_state_latencyphz  (tx_w_state_latencyphz),
            .o_rx_w_state_latencyphz  (rx_w_state_latencyphz),

            .o_tx_state_transition    (tx_state_transition),
            .o_rx_state_transition    (rx_state_transition),

            .o_tx_apulse_count    (tx_apulse_count),
            .o_rx_apulse_count    (rx_apulse_count),
            .o_tx_w_apulse_count  (tx_w_apulse_count),
            .o_rx_w_apulse_count  (rx_w_apulse_count),

            .o_tx_skip_ini    (tx_skip_ini),
            .o_rx_skip_ini    (rx_skip_ini),
            .o_tx_w_skip_ini  (tx_w_skip_ini),
            .o_rx_w_skip_ini  (rx_w_skip_ini),


            // Deskew status
            .i_ptp_rx_aib_dsk_done  (ptp_rx_aib_dsk_done),
            .o_ptp_rx_aib_dsk_done  (ptp_rx_aib_dsk_done_stm),

            // Before stage 2 deskew signals
            .i_rx_am_b4_dsk (i_sl_rx_am),
            .i_rx_valid_b4_dsk (i_sl_rx_valid),
            .i_sl_ptp_rx_aib_dsk_done_b4_dsk(i_sl_ptp_rx_aib_dsk_done)

        );

        end  // ENHANCED_PTP_DBG

    end else begin
        alt_ehipc3_fm_sl_ptp_avmm_csr_bank #(
            .ehip_rate_sl           (ehip_rate_sl)
        ) ptp_csr_bank (
            .i_avmm_clk             (i_reconfig_clk),
            .i_avmm_rst_n           (!i_reconfig_reset),
            .o_avmm_readdata        (o_sl_avmm_readdata),
            .i_avmm_write           (i_sl_avmm_write),
            .i_avmm_read            (i_sl_avmm_read),
            .i_avmm_writedata       (i_sl_avmm_writedata),
            .o_avmm_waitrequest     (o_sl_avmm_waitrequest),
            .i_avmm_address         (i_sl_avmm_address),

            .i_tx_tam_capture       (tx_tam_capture_cc),
            .i_tx_tam_count         (tx_tam_count_cc),
            .i_tx_tam_cap_valid     (tx_tam_cap_valid_cc),
            .i_rx_tam_capture       (rx_tam_capture_cc),
            .i_rx_tam_count         (rx_tam_count_cc),
            .i_rx_tam_cap_valid     (rx_tam_cap_valid_cc),

            .o_calibrate            (sptp_calibrate),
            .i_tx_calibrate_done    (o_sl_tx_sel_sclk_return),
            .i_rx_calibrate_done    (o_sl_rx_sel_sclk_return),
            .i_tx_error_valid       (sptp_tx_error_valid),
            .i_tx_error             (sptp_tx_error),
            .i_rx_error_valid       (sptp_rx_error_valid),
            .i_rx_error             (sptp_rx_error),
            .o_ts_format            (sptp_ts_format),
            .o_tx_ui                (sptp_tx_ui),
            .o_rx_ui                (sptp_rx_ui),
            .o_req_tx_ui_load       (sptp_req_tx_ui_load),
            .o_req_rx_ui_load       (sptp_req_rx_ui_load),
            .o_tpiso                (sptp_tpiso),
            .o_rsipo                (sptp_rsipo),
            .o_rxalign_offset       (sptp_rxalign_offset)
        );


        alt_ehipc3_fm_sl_ptp #(
            .SIM_MODE               (SIM_MODE_INT)
        ) soft_ptp (
            // Configuration
            .i_enable_rsfec         (i_enable_rsfec),
            .i_tx_preamble_pass     (i_tx_preamble_pass),

            // System Interface
            .i_ptp_clk              (i_sl_clk_tx),
            .i_tx_rst_n             (!ehip_tx_reset_sync_2),
            .i_rx_rst_n             (!ehip_rx_reset_sync_2),
            .i_tx_rst_n1            (!ehip_tx_reset_sync_2),
            .i_rx_rst_n1            (!ehip_rx_reset_sync_2),
            .i_tx_rst_n2            (!ehip_tx_reset_sync_2),
            .i_rx_rst_n2            (!ehip_rx_reset_sync_2),
            .i_rx_rst_n3            (!ehip_rx_reset_sync_2),
            .i_tx_rst_n3            (!ehip_tx_reset_sync_2),
	    .i_tx_rst_n4            (!ehip_tx_reset_sync_2),
	    .i_tx_rst_n5            (!ehip_tx_reset_sync_2),
            .i_tx_rst_n6            (!ehip_tx_reset_sync_2),
	    .i_tx_rst_n7	    (!ehip_tx_reset_sync_2),
	    .i_tx_rst_n8	    (!ehip_tx_reset_sync_2),
	    .i_tx_rst_n9	    (!ehip_tx_reset_sync_2),

        .i_tx_arst_n(!ehip_tx_reset_async_2),
        .i_rx_arst_n(!ehip_rx_reset_async_2),

            .i_rx_lock              (1'b1),
            .i_pcs_fully_aligned    (i_sl_rx_pcs_fully_aligned),
            .i_all_ready            (all_ready),

            // AVMM CSR Bank Interface
            .o_tx_error_valid       (sptp_tx_error_valid),
            .o_tx_error             (sptp_tx_error),
            .o_rx_error_valid       (sptp_rx_error_valid),
            .o_rx_error             (sptp_rx_error),
            .i_ts_format            (sptp_ts_format),
            .i_tx_ui                (sptp_tx_ui_cc),
            .i_rx_ui                (sptp_rx_ui_cc),
            .i_req_tx_ui_load       (sptp_req_tx_ui_load_cc),
            .i_req_rx_ui_load       (sptp_req_rx_ui_load_cc),
            .i_tpiso                (sptp_tpiso),
            .i_rsipo                (sptp_rsipo),
            .i_rx_align_offset      (sptp_rxalign_offset),

            // User Interface: TOD Interface
            .i_ptp_tod              (i_ptp_tod),
            .i_ptp_update           (1'b0), // Unused

            // User Interface: PTP Status
            .o_tx_ptp_ready         (o_sl_tx_ptp_ready),
            .o_rx_ptp_ready         (o_sl_rx_ptp_ready),

            // User Interface: TX Framing Interface
            .i_tx_valid             (adpt_tx_valid),
            .i_tx_sop               (adpt_tx_sop),
            .i_tx_eop               (1'b0), // Unused
            .i_tx_inframe           (adpt_tx_inframe),
            .i_tx_skip_crc          (adpt_tx_skip_crc),

            // User Interface: TX 1-step Command
            .i_ptp_ins_ets          (adpt_ptp_ins_ets),
            .i_ptp_ins_cf           (adpt_ptp_ins_cf),
            .i_ptp_zero_csum        (adpt_ptp_ins_zero_csum),
            .i_ptp_update_eb        (adpt_ptp_ins_update_eb),
            .i_ptp_ts_format        (adpt_ptp_ts_format),
            .i_ptp_asym             (1'b0),
            .i_ptp_ts_offset        (adpt_ptp_ts_offset),
            .i_ptp_cf_offset        (adpt_ptp_cf_offset),
            .i_ptp_csum_offset      (adpt_ptp_csum_offset),
            .i_ptp_eb_offset        (adpt_ptp_ed_offset),
            .i_ptp_tx_its           (adpt_ptp_tx_its),

            // User Interface: TX 2-step Timestamp Request
            .i_ptp_ts_req           (adpt_ptp_ts_req),
            .i_ptp_fp               (adpt_ptp_fp),

            // User Interface: TX 2-step Timestamp Return
            .o_ptp_ets_valid        (sl_ptp_ets_valid_int),
            .o_ptp_ets              (sl_ptp_ets_int),
            .o_ptp_ets_fp           (sl_ptp_ets_fp_int),

            // User Interface: RX Timestamp
            .o_ptp_rx_its           (int_sl_rx_ptp),
            .o_ptp_rx_its_valid     (),

            // EHIP Interface: TX 1-step and 2-step Command
            .o_ptp_tx_fp            (o_sl_ptp_tx_fp),
            .o_ptp_ins_type         (o_sl_ptp_ins_type),
            .o_ptp_byte_offset      (o_sl_ptp_byte_offset),
            .o_ptp_ts               (o_sl_ptp_ts),

            // EHIP Interface: TX 2-step Timestamp
            .i_ptp_tx_ts_valid      (i_sl_ptp_tx_ts_valid),
            .i_ptp_tx_ts            (i_sl_ptp_tx_ts),
            .i_ptp_tx_fp            (i_sl_ptp_tx_ts_fp),

            // EHIP Interface: RX Timestamp
            .i_rx_valid             (dsk_rx_valid),
            .i_rx_inframe           (dsk_rx_inframe),
            .i_ptp_rx_ts            (dsk_ptp_rx_ts),

            // EHIP Interface: Reference Timestamp
	    .o_sl_tx_sclk_return_sync	(int_sl_tx_sclk_return_sync),
            .o_sclk                 	(o_sl_sclk),
            .o_sl_tx_sel_sclk_return	(o_sl_tx_sel_sclk_return),
            .o_sl_rx_sel_sclk_return	(o_sl_rx_sel_sclk_return),
            .i_tx_sclk_return       	(i_sl_tx_sclk_return),
            .i_rx_sclk_return       	(i_sl_rx_sclk_return),
            .i_tx_am                	(i_sl_tx_am),
            .i_rx_am                	(i_sl_rx_am),
            .i_rx_am_dsk            	(dsk_rx_am),

            // TAM capture and AM counts
            .o_tx_tam_capture       (tx_tam_capture),
            .o_tx_tam_count         (tx_tam_count),
            .o_tx_tam_cap_valid     (tx_tam_cap_valid),
            .o_rx_tam_capture       (rx_tam_capture),
            .o_rx_tam_count         (rx_tam_count),
            .o_rx_tam_cap_valid     (rx_tam_cap_valid),

            // Deskew status
            .i_ptp_rx_aib_dsk_done  (ptp_rx_aib_dsk_done),
            .o_ptp_rx_aib_dsk_done  (ptp_rx_aib_dsk_done_stm),

            // Before stage 2 deskew signals
            .i_rx_am_b4_dsk (i_sl_rx_am),
            .i_rx_valid_b4_dsk (i_sl_rx_valid),
            .i_sl_ptp_rx_aib_dsk_done_b4_dsk(i_sl_ptp_rx_aib_dsk_done)

        );


    end

  always@(posedge i_reconfig_clk)
  begin
    if(ehip_tx_reset_sync_sync_reconfig_clk)
      req_tx_ui_stky <= 1'b0;
    else if (req_tx_ui_ready)
      req_tx_ui_stky <= 1'b0;
    else if (sptp_req_tx_ui_load)
      req_tx_ui_stky <= 1'b1;
  end


  always@(posedge i_reconfig_clk)
  begin
    if(ehip_tx_reset_sync_sync_reconfig_clk)
      req_rx_ui_stky <= 1'b0;
    else if (req_rx_ui_ready)
      req_rx_ui_stky <= 1'b0;
    else if (sptp_req_rx_ui_load)
      req_rx_ui_stky <= 1'b1;
  end

        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (32),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) load_tx_ui_cc (
            .in_clk                 (i_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .in_reset               (i_reconfig_reset),
            .in_reset               (ehip_tx_reset_sync_sync_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------
            .in_ready               (req_tx_ui_ready),
            .in_valid               (sptp_req_tx_ui_load || req_tx_ui_stky),
            .in_data                (sptp_tx_ui),
            .out_clk                (i_sl_clk_tx),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .out_reset              (reconfig_reset_sync_tx_clk),
            .out_reset              (ehip_tx_reset_async_2),
// ---------------------------------------------------------------------------------------------------------------------------------
            .out_ready              (!ehip_tx_reset_async_2),
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
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .in_reset               (i_reconfig_reset),
            .in_reset               (ehip_tx_reset_sync_sync_reconfig_clk),
// ---------------------------------------------------------------------------------------------------------------------------------
            .in_ready               (req_rx_ui_ready),
            .in_valid               (sptp_req_rx_ui_load || req_rx_ui_stky),
            .in_data                (sptp_rx_ui),
            .out_clk                (i_sl_clk_tx),
// ---------------------------------------------------------------------------------------------------------------------------------
// 03/Apr/2019 : slim35 : HSD#1506990478 : XPROP : tx/rx_ui_cc clock crossing instance is using source reset instead of destination reset.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .out_reset              (reconfig_reset_sync_tx_clk),
            .out_reset              (ehip_tx_reset_async_2),
// ---------------------------------------------------------------------------------------------------------------------------------
            .out_ready              (!ehip_tx_reset_async_2 && ptp_rx_aib_dsk_done_stm),
            .out_valid              (sptp_req_rx_ui_load_cc),
            .out_data               (sptp_rx_ui_cc)
        );

        if (ENABLE_ASYNC_ADAPTERS_SL == 1) begin


        alt_ehipc3_fm_sl_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (8+96),//
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) inst_ptp_ets_cmd_async_cc (
            .in_clk                 (i_sl_clk_tx),
            .in_reset               (ehip_tx_reset_async_2),
            .in_ready               (),
            .in_valid               (sl_ptp_ets_valid_int),
            .in_data                ({sl_ptp_ets_fp_int,sl_ptp_ets_int}),
            .out_clk                (i_sl_async_clk_tx),
            .out_reset              (ehip_tx_reset_async_adpt),
            .out_ready              (1'b1),
            .out_valid              (o_sl_ptp_ets_valid),
            .out_data               ({o_sl_ptp_ets_fp,o_sl_ptp_ets})
        );

        end
        else begin
        assign o_sl_ptp_ets_fp = sl_ptp_ets_fp_int;
        assign o_sl_ptp_ets = sl_ptp_ets_int;
        assign o_sl_ptp_ets_valid = sl_ptp_ets_valid_int;
        end

        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (64),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) inst_tx_tam_capture_cc (
            .in_clk                 (i_sl_clk_tx),
            .in_reset               (reconfig_reset_sync_tx_clk),
            .in_ready               (),
            .in_valid               (tx_tam_cap_valid),
            .in_data                ({tx_tam_count,tx_tam_capture}),
            .out_clk                (i_reconfig_clk),
            .out_reset              (i_reconfig_reset),
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
            .in_clk                 (i_sl_clk_rx),
            .in_reset               (reconfig_reset_sync_rx_clk),
            .in_ready               (),
            .in_valid               (rx_tam_cap_valid),
            .in_data                ({rx_tam_count,rx_tam_capture}),
            .out_clk                (i_reconfig_clk),
            .out_reset              (i_reconfig_reset),
            .out_ready              (1'b1),
            .out_valid              (rx_tam_cap_valid_cc),
            .out_data               ({rx_tam_count_cc,rx_tam_capture_cc})
        );

    end // Block: SL_PTP
    else
    begin

        assign sl_tx_ptp                = {TX_PTP_WIDTH{1'b0}};
        assign int_sl_rx_ptp            = {RX_PTP_WIDTH{1'b0}};

        assign o_sl_tx_ptp_ready        = 1'b0;
        assign o_sl_rx_ptp_ready        = 1'b0;

        assign o_sl_ptp_ets_valid       = 1'b0;
        assign o_sl_ptp_ets             = 96'h0;
        assign o_sl_ptp_ets_fp          = 8'h0;

        assign o_sl_ptp_tx_fp           = 2'b00;
        assign o_sl_ptp_ins_type        = 3'b000;
        assign o_sl_ptp_byte_offset     = 3'b00;
        assign o_sl_ptp_ts              = 24'h0;

        assign o_sl_sclk                = 1'b0;
        assign o_sl_tx_sel_sclk_return  = 1'b1;
        assign o_sl_rx_sel_sclk_return  = 1'b1;

        assign o_sl_avmm_waitrequest    = 1'b0;
        assign o_sl_avmm_readdata       = 32'h0;

        assign int_sl_tx_sclk_return_sync = i_sl_tx_sclk_return;
    end
    endgenerate

endmodule // alt_ehipc3_fm_sl_soft
