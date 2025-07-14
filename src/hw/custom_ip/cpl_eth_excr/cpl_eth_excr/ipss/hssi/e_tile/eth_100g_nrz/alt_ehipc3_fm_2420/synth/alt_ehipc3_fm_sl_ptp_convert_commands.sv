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
// Filename         : ptp_convert_commands.sv
// Author           : Tholu Kiran Kumar <kktholu@intel.com>
// Created On       : Thu Jun 15/06/2017 06:13:31 PM MYT
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
module alt_ehipc3_fm_sl_ptp_convert_commands #(
    parameter SIM_MODE = 0
) (
    // Configuration
    input  logic        i_enable_rsfec,
    input  logic        i_tx_preamble_pass,

    // System Intetrface
    input  logic        i_clk,
    input  logic        i_rst_n,

    input  logic	i_rst_n1,
    input  logic	i_rst_n2,
    input  logic	i_rst_n3,
    input  logic	i_rst_n4,
    input  logic	i_rst_n5,

    input  logic        i_rx_lock,

    // 1-Step TS Interface
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

    // 2-Step TS Interface
    input  logic        i_ptp_ts_req,
    input  logic [7:0]  i_ptp_fp,

    // TX Framing interface
    input  logic        i_tx_valid,
    input  logic        i_tx_sop,
    input  logic        i_tx_eop,
    input  logic        i_tx_inframe,
    input  logic        i_tx_skip_crc,

    // TAM Request
    input  logic        i_req_tx_tam_load,
    input  logic [95:0] i_tx_tam,

    input  logic        i_req_rx_tam_load,
    input  logic [95:0] i_rx_tam,

    // UI Request
    input  logic        i_req_tx_ui_load,
    input  logic [31:0] i_tx_ui,

    input  logic        i_req_rx_ui_load,
    input  logic [31:0] i_rx_ui,

    // EHIP TS Interface
    output logic [2:0]  o_ptp_ins_type,
    output logic [2:0]  o_ptp_byte_offset,
    output logic [23:0] o_ptp_ts,
    output logic [1:0]  o_ptp_tx_fp,

    // PTP Status
    output logic        o_tx_ptp_ready,
    output logic        o_rx_ptp_ready,
    output logic [7:0]  o_ptp_ready_dbg,

    // Deskew status
    input  logic        i_ptp_rx_aib_dsk_done,
    output logic        o_ptp_rx_aib_dsk_done
  );

    // Constants to limit TAM load window to avoid loading TAM to incorrect AM
    localparam PERIOD_TX_FEC          = 17'd81916; // STANDARD_25G_FEC_AM_PERIOD
    localparam PERIOD_TX_NO_FEC       = 17'd81919; // STANDARD_25G_AM_PERIOD
    localparam PERIOD_RX_FEC          = PERIOD_TX_FEC;
    localparam PERIOD_RX_NO_FEC       = 14'd98; // cfg_rx_bit_counter_rollover / cfg_sel_bit_counter_adder = 6304 / 32 / 2
    localparam SIM_PERIOD_TX_FEC      = 17'd1276; // SIM_ONLY_25G_FEC_AM_PERIOD
    localparam SIM_PERIOD_TX_NO_FEC   = 17'd5119; // SIM_ONLY_25G_AM_PERIOD
    localparam SIM_PERIOD_RX_FEC      = SIM_PERIOD_TX_FEC;
    localparam SIM_PERIOD_RX_NO_FEC   = 14'd98; // cfg_rx_bit_counter_rollover / cfg_sel_bit_counter_adder / 2 (due to full rate to half rate clock) = 6304 / 32 / 2

    localparam DLY_TX_AM_PTP_TO_SOFT  = 36+3; // Obtained in simulation: AM input to hard TX PTP and to soft TX PTP (tx_sclk_return)
                                              // Added 3 because of additional latency in rx_deskew block after adding pipeline for timing purpose
    localparam DLY_RX_AM_PTP_TO_SOFT  = 8+8+3; // Obtained in simulation: AM input to hard RX PTP and to soft RX PTP (rx_am_detect), +8 for deskew
                                               // Added 3 because of additional latency in rx_deskew block after adding pipeline for timing purpose
    localparam DLY_TX_PULSE_CAPTURE   = 3+1+2; // Obtained from RTL: Two 3 cycles synchronizer, one metastability uncertainty, two cylce delay for load request output
    localparam DLY_RX_PULSE_CAPTURE   = 3+1+1; // Obtained from RTL: Two 3 cycles synchronizer, one metastability uncertainty, one cylce delay for load request output
    localparam DLY_CALC_TAM           = 12; // Obtained from RTL: Number of pipelines to calculate TAM
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Marc/2020 : slim35 : 1809826393 :
// Add 1 additional delay for pre-evaluation of the entry condition of loading_p5678 process.
// ---------------------------------------------------------------------------------------------------------------------------------
//    localparam DLY_CONVERT_CMD        = 5; // Obtained from RTL: Number of delay to generate ins_type
//    localparam DLY_CONVERT_CMD        = 6; // Obtained from RTL: Number of delay to generate ins_type
// ---------------------------------------------------------------------------------------------------------------------------------
// Add 1 additional delay for remain_cycle process
    localparam DLY_CONVERT_CMD	      = 10; // Obtained from RTL: Number of delay to generate ins_type
// ---------------------------------------------------------------------------------------------------------------------------------
    localparam DLY_LOAD_TAM_PATH      = 9; // Obtained in simulation: Max delay from soft PTP output to hard MAC
    localparam DLY_TX_MAC_TO_PTP      = 3; // Obtained in simulation: From hard TX MAC input to hard TX PTP
    localparam DLY_RX_MAC_TO_PTP      = 4; // Obtained in simulation: From hard RX MAC input to hard RX PTP
    localparam DLY_EXTRA_MARGIN       = 10; // Extra safety guardband to avoid loading with older TAM
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

    // RX deskew state
    localparam STM_RXDSK_INIT           = 7'b0000001;
    localparam STM_RXDSK_LOAD_UI        = 7'b0000010;
    localparam STM_RXDSK_WAIT_LOAD_UI   = 7'b0000100;
    localparam STM_RXDSK_LOAD_TAM       = 7'b0001000;
    localparam STM_RXDSK_WAIT_LOAD_TAM  = 7'b0010000;
    localparam STM_RXDSK_WAIT_DSK_DONE  = 7'b0100000;
    localparam STM_RXDSK_DONE           = 7'b1000000;

    // RX deskew state
    logic [6:0]     rxdsk_state;
    logic [6:0]     rxdsk_next_state;
    logic           rxdsk_done;

    // TAM load request control and window control
    logic           r_req_tx_tam_load;
    logic           r_req_rx_tam_load;
    logic           r_req_tx_ui_load;
    logic           r_req_rx_ui_load;

    logic           req_tx_tam_load_rise;
    logic           req_rx_tam_load_rise;

    logic	    req_tx_tam_load_rise_r;
    logic	    req_rx_tam_load_rise_r;

    logic           req_tx_ui_load_rise;
    logic           req_rx_ui_load_rise;
    logic           req_rxdsk_tam_load_rise;
    logic           req_rxdsk_ui_load_rise;

    logic [16:0]    limit_tx;
    logic [16:0]    limit_rx;
    logic [16:0]    remain_cycle_tx;
    logic [16:0]    remain_cycle_rx;
    logic           remain_cycle_tx_msb_is_zero;
    logic           remain_cycle_rx_msb_is_zero;
    logic           remain_cycle_tx_is_zero;
    logic           remain_cycle_rx_is_zero;

    logic 	    or_remain_cycle_tx_r;
    logic	    or_remain_cycle_rx_r;

    logic           tx_load_tam_enable;
    logic           rx_load_tam_enable;

    logic           req_tx_tam_load_clear;
    logic           req_rx_tam_load_clear;
    logic           req_tx_ui_load_clear;
    logic           req_rx_ui_load_clear;

    logic           tx_tam_load_complete;
    logic           rx_tam_load_complete;
    logic           tx_ui_load_complete;
    logic           rx_ui_load_complete;

    logic           req_tx_tam;
    logic           req_rx_tam;
    logic           req_tx_ui;
    logic           req_rx_ui;

    logic           req_rxdsk_ui;
    logic           req_rxdsk_tam;

    // PTP ready status
    logic           tx_ui_load_done;
    logic           rx_ui_load_done;
    logic           tx_tam_load_done;
    logic           tx_tam_load_done_r;
    logic           rx_tam_load_done;
    logic           rx_tam_load_done_r;

    // PTP commands conversion
    logic           tx_sop_p1;
    logic           tx_sop_p2;
    logic           tx_sop_p3;
    logic           tx_sop_p4;
    logic           tx_inframe_p1;
    logic           tx_inframe_p2;
    logic [8:0]     byte_count_lsb_p1;
    logic [7:0]     byte_count_lsb_p2;
    logic [8:0]     byte_count_msb_p2;
    logic [15:0]    byte_count_p2;

    logic           tr_cmd_p1;
    logic           ts_cmd_p1;
    logic           cf_cmd_p1;
    logic           cs_cmd_p1;
    logic           eb_cmd_p1;
    logic           tf_cmd_p1;

    logic           tr_cmd_p2;
    logic           ts_cmd_p2;
    logic           cf_cmd_p2;
    logic           cs_cmd_p2;
    logic           eb_cmd_p2;
    logic           tf_cmd_p2;

    logic           tr_cmd_p3;
    logic           ts_cmd_p3;
    logic           cf_cmd_p3;
    logic           cs_cmd_p3;
    logic           eb_cmd_p3;
    logic           tf_cmd_p3;

    logic [15:0]    ts_offset_p1;
    logic [15:0]    cf_offset_p1;
    logic [15:0]    cs_offset_p1;
    logic [15:0]    eb_offset_p1;

    logic [15:0]    ts_offset_p2;
    logic [15:0]    cf_offset_p2;
    logic [15:0]    cs_offset_p2;
    logic [15:0]    eb_offset_p2;

    logic [15:0]    ts_offset_p3;
    logic [15:0]    cf_offset_p3;
    logic [15:0]    cs_offset_p3;
    logic [15:0]    eb_offset_p3;

    logic [3:0]     is_ts_offset_p3;
    logic [3:0]     is_cf_offset_p3;
    logic [3:0]     is_cs_offset_p3;
    logic [3:0]     is_eb_offset_p3;

    logic [2:0]     cmd_ins_type_p4;
    logic [2:0]     cmd_ins_type_p5;

    logic [2:0]     cmd_byte_offset_p4;
    logic [2:0]     cmd_byte_offset_p5;

    // Early warning detection
    logic           ptp_cmd_p0;
    logic           early_warning_p1;
    logic           early_warning_p2;
    logic           early_warning_p3;
    logic           early_warning_p4;
    logic           early_warning_all_p4;

    // PTP loading
    logic           loading_in_progress_p5678;
    logic [3:0]     loading_p5678;

    logic [95:0]    selected_tam_p4;
    logic [2:0]     load_ins_type_p4;
    logic [2:0]     load_byte_offset_p4;
    logic [2:0]     load_type_p4;
    logic [95:0]    selected_tam_p5678;
    logic [2:0]     load_ins_type_p5678;
    logic [2:0]     load_byte_offset_p5678;
    logic [2:0]     load_type;

    // Fingerprint and ingress timestamp
    logic [ 7:0]    tx_fp_p1;
    logic [ 7:0]    tx_fp_p2;
    logic [ 7:0]    tx_fp_p3;
    logic [ 7:0]    tx_fp_p4;
    logic [ 7:0]    tx_fp_p5678;

    logic [95:0]    tx_its_p1;
    logic [95:0]    tx_its_p2;
    logic [95:0]    tx_its_p3;
    logic [95:0]    tx_its_p4;
    logic [95:0]    tx_its_p5678;
    logic           ptp_rx_aib_dsk_lost_intrpt;
    logic           ptp_rx_aib_dsk_lost_intrpt_r;

    // flop rx ptp deskew done signal for timing
    logic ptp_rx_aib_dsk_done_r;
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
           ptp_rx_aib_dsk_done_r <= 1'b0;
        end
        else begin
           ptp_rx_aib_dsk_done_r <= i_ptp_rx_aib_dsk_done;
        end
    end

    // RX deskew state
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            rxdsk_state <= STM_RXDSK_INIT;
        end
        else begin
            rxdsk_state <= rxdsk_next_state;
        end
    end

    always @(*) begin
        case(rxdsk_state)
            STM_RXDSK_INIT: begin
                rxdsk_next_state = ptp_rx_aib_dsk_done_r ? STM_RXDSK_DONE : STM_RXDSK_LOAD_UI;
            end

            STM_RXDSK_LOAD_UI: begin
                rxdsk_next_state = STM_RXDSK_WAIT_LOAD_UI;
            end

            STM_RXDSK_WAIT_LOAD_UI: begin
                rxdsk_next_state = rx_ui_load_complete ? STM_RXDSK_LOAD_TAM : STM_RXDSK_WAIT_LOAD_UI;
            end

            STM_RXDSK_LOAD_TAM: begin
                rxdsk_next_state = STM_RXDSK_WAIT_LOAD_TAM;
            end

            STM_RXDSK_WAIT_LOAD_TAM: begin
                rxdsk_next_state = rx_tam_load_complete ? STM_RXDSK_WAIT_DSK_DONE : STM_RXDSK_WAIT_LOAD_TAM;
            end

            STM_RXDSK_WAIT_DSK_DONE: begin
                rxdsk_next_state = ptp_rx_aib_dsk_done_r ? STM_RXDSK_DONE : STM_RXDSK_WAIT_DSK_DONE;
            end

            STM_RXDSK_DONE: begin
                rxdsk_next_state = ptp_rx_aib_dsk_done_r ? STM_RXDSK_DONE : STM_RXDSK_LOAD_UI;
            end

            default: begin
                rxdsk_next_state = STM_RXDSK_INIT;
            end

        endcase
    end

    // RX Channel deskew lost interrupt
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            ptp_rx_aib_dsk_lost_intrpt <= 1'b0;
        end
        else if (!ptp_rx_aib_dsk_done_r & (rxdsk_state == STM_RXDSK_DONE)) begin
            ptp_rx_aib_dsk_lost_intrpt <= 1'b1;
        end
        else begin
            ptp_rx_aib_dsk_lost_intrpt <= 1'b0;
        end
    end

    // RX Channel deskew lost interrupt
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            ptp_rx_aib_dsk_lost_intrpt_r <= 1'b0;
        end
        else begin
            ptp_rx_aib_dsk_lost_intrpt_r <= ptp_rx_aib_dsk_lost_intrpt;
        end
    end

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            req_rxdsk_tam_load_rise <= 1'b0;
            req_rxdsk_ui_load_rise  <= 1'b0;
            rxdsk_done              <= 1'b0;
        end
        else begin
            case(rxdsk_state)
                STM_RXDSK_INIT: begin
                    req_rxdsk_tam_load_rise <= 1'b0;
                    req_rxdsk_ui_load_rise  <= 1'b0;
                    rxdsk_done              <= 1'b0;
                end

                STM_RXDSK_LOAD_UI: begin
                    req_rxdsk_tam_load_rise <= 1'b0;
                    req_rxdsk_ui_load_rise  <= 1'b1;
                    rxdsk_done              <= 1'b0;
                end

                STM_RXDSK_WAIT_LOAD_UI: begin
                    req_rxdsk_tam_load_rise <= 1'b0;
                    req_rxdsk_ui_load_rise  <= 1'b0;
                    rxdsk_done              <= 1'b0;
                end

                STM_RXDSK_LOAD_TAM: begin
                    req_rxdsk_tam_load_rise <= 1'b1;
                    req_rxdsk_ui_load_rise  <= 1'b0;
                    rxdsk_done              <= 1'b0;
                end

                STM_RXDSK_WAIT_LOAD_TAM: begin
                    req_rxdsk_tam_load_rise <= 1'b0;
                    req_rxdsk_ui_load_rise  <= 1'b0;
                    rxdsk_done              <= 1'b0;
                end

                STM_RXDSK_WAIT_DSK_DONE: begin
                    req_rxdsk_tam_load_rise <= 1'b0;
                    req_rxdsk_ui_load_rise  <= 1'b0;
                    rxdsk_done              <= 1'b0;
                end

                STM_RXDSK_DONE: begin
                    req_rxdsk_tam_load_rise <= 1'b0;
                    req_rxdsk_ui_load_rise  <= 1'b0;
                    rxdsk_done              <= 1'b1;
                end

                default: begin
                    req_rxdsk_tam_load_rise <= 1'b0;
                    req_rxdsk_ui_load_rise  <= 1'b0;
                    rxdsk_done              <= 1'b0;
                end
            endcase
        end
    end

    assign o_ptp_rx_aib_dsk_done = rxdsk_done;

    // TAM load request control and window control
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            r_req_tx_tam_load   <= 0;
            r_req_rx_tam_load   <= 0;
            r_req_tx_ui_load    <= 0;
            r_req_rx_ui_load    <= 0;
        end
        else begin
            r_req_tx_tam_load   <= i_req_tx_tam_load;
            r_req_rx_tam_load   <= i_req_rx_tam_load && rxdsk_done;
            r_req_tx_ui_load    <= i_req_tx_ui_load;
            r_req_rx_ui_load    <= i_req_rx_ui_load && rxdsk_done;
        end
    end

    assign req_tx_tam_load_rise = !r_req_tx_tam_load & i_req_tx_tam_load;
    assign req_rx_tam_load_rise = !r_req_rx_tam_load & i_req_rx_tam_load;
    assign req_tx_ui_load_rise  = !r_req_tx_ui_load & i_req_tx_ui_load;
    assign req_rx_ui_load_rise  = !r_req_rx_ui_load & i_req_rx_ui_load;

    `ifdef ALTERA_RESERVED_QIS
        assign limit_tx = i_enable_rsfec ? LIMIT_TX_FEC : LIMIT_TX_NO_FEC;
        assign limit_rx = i_enable_rsfec ? LIMIT_RX_FEC : LIMIT_RX_NO_FEC;
    `else
        assign limit_tx = i_enable_rsfec ? SIM_LIMIT_TX_FEC : SIM_LIMIT_TX_NO_FEC;
        assign limit_rx = i_enable_rsfec ? SIM_LIMIT_RX_FEC : SIM_LIMIT_RX_NO_FEC;
    `endif

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            remain_cycle_tx_msb_is_zero <= 1'b0;
            remain_cycle_rx_msb_is_zero <= 1'b0;
            remain_cycle_tx_is_zero <= 1'b0;
            remain_cycle_rx_is_zero <= 1'b0;
        end else begin
            remain_cycle_tx_msb_is_zero <= (remain_cycle_tx[16:2] == 15'd0) ? 1'b1 : 1'b0;
            remain_cycle_rx_msb_is_zero <= (remain_cycle_rx[16:2] == 15'd0) ? 1'b1 : 1'b0;
            remain_cycle_tx_is_zero <= (!req_tx_tam_load_rise && remain_cycle_tx_msb_is_zero && (remain_cycle_tx == 2'd1 || remain_cycle_tx == 2'd0)) ? 1'b1 : 1'b0;
            remain_cycle_rx_is_zero <= (!req_rx_tam_load_rise && remain_cycle_rx_msb_is_zero && (remain_cycle_rx == 2'd1 || remain_cycle_rx == 2'd0)) ? 1'b1 : 1'b0;
        end
    end

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            remain_cycle_tx <= 0;
            remain_cycle_rx <= 0;
        end
        else begin
            if(req_tx_tam_load_rise) begin
                remain_cycle_tx <= limit_tx;
            end
            else if (remain_cycle_tx_is_zero) begin
                remain_cycle_tx <= 0;
            end
            else begin
                remain_cycle_tx <= remain_cycle_tx - 1'b1;
            end

            if(req_rx_tam_load_rise) begin
                remain_cycle_rx <= limit_rx;
            end
            else if(remain_cycle_rx_is_zero) begin
                remain_cycle_rx <= 0;
            end
            else begin
                remain_cycle_rx <= remain_cycle_rx - 1'b1;
            end
        end
    end

    always @(posedge i_clk) begin
	if(!i_rst_n) begin
	    or_remain_cycle_tx_r <= 0;
	    or_remain_cycle_rx_r <= 0;
	end
	else begin
	    or_remain_cycle_tx_r <= |remain_cycle_tx;
	    or_remain_cycle_rx_r <= |remain_cycle_rx;
	end
    end

    assign tx_load_tam_enable = or_remain_cycle_tx_r;
    assign rx_load_tam_enable = or_remain_cycle_rx_r;

    assign req_tx_tam_load_clear = tx_tam_load_complete || !tx_load_tam_enable;
    assign req_rx_tam_load_clear = rx_tam_load_complete || !rx_load_tam_enable;
    assign req_tx_ui_load_clear  = tx_ui_load_complete;
    assign req_rx_ui_load_clear  = rx_ui_load_complete && rxdsk_done;

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            req_tx_tam_load_rise_r <= 0;
            req_rx_tam_load_rise_r <= 0;
        end
        else begin
            req_tx_tam_load_rise_r <= req_tx_tam_load_rise;
            req_rx_tam_load_rise_r <= req_rx_tam_load_rise;
        end
    end

    alt_ehipc3_fm_sl_ptp_sticky_register psr_req_tx_tam (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_set_sticky   (req_tx_tam_load_rise_r),
        .i_clear_sticky (req_tx_tam_load_clear),
        .o_sticky_reg   (req_tx_tam)
    );

    alt_ehipc3_fm_sl_ptp_sticky_register psr_req_rx_tam (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_set_sticky   (req_rx_tam_load_rise_r),
        .i_clear_sticky (req_rx_tam_load_clear),
        .o_sticky_reg   (req_rx_tam)
    );

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

    alt_ehipc3_fm_sl_ptp_sticky_register psr_req_rxdsk_tam (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_set_sticky   (req_rxdsk_tam_load_rise),
        .i_clear_sticky (rx_tam_load_complete),
        .o_sticky_reg   (req_rxdsk_tam)
    );

    alt_ehipc3_fm_sl_ptp_sticky_register psr_req_rxdsk_ui (
        .i_clk          (i_clk),
        .i_rst_n        (i_rst_n),
        .i_set_sticky   (req_rxdsk_ui_load_rise),
        .i_clear_sticky (rx_ui_load_complete),
        .o_sticky_reg   (req_rxdsk_ui)
    );

    assign tx_ui_load_complete    = (load_type == LOAD_TYPE_TX_UI)  && (loading_p5678[2]);
    assign rx_ui_load_complete    = (load_type == LOAD_TYPE_RX_UI)  && (loading_p5678[2]);
    assign tx_tam_load_complete   = (load_type == LOAD_TYPE_TX_TAM) && (loading_p5678[2]);
    assign rx_tam_load_complete   = (load_type == LOAD_TYPE_RX_TAM) && (loading_p5678[2]);

    // TX PTP ready status
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            tx_ui_load_done     <= 1'b0;
            tx_tam_load_done    <= 1'b0;
            tx_tam_load_done_r  <= 1'b0;
        end
        else begin
            if(tx_ui_load_complete)   tx_ui_load_done    <= 1'b1;
            if(tx_tam_load_complete)  tx_tam_load_done   <= 1'b1;
            if(tx_tam_load_complete)  tx_tam_load_done_r <= tx_tam_load_done;
        end
    end

    // RX PTP ready status
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            rx_ui_load_done     <= 1'b0;
            rx_tam_load_done    <= 1'b0;
            rx_tam_load_done_r  <= 1'b0;
        end
        else if (ptp_rx_aib_dsk_lost_intrpt_r) begin
            rx_ui_load_done     <= 1'b0;
            rx_tam_load_done    <= 1'b0;
            rx_tam_load_done_r  <= 1'b0;
        end
        else begin
            if(rx_ui_load_complete)  rx_ui_load_done    <= rxdsk_done;
            if(rx_tam_load_complete) rx_tam_load_done   <= rxdsk_done;
            if(rx_tam_load_complete) rx_tam_load_done_r <= rx_tam_load_done;
        end
    end

    // TX PTP ready status
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
           o_tx_ptp_ready <= 1'b0;
        end
        else begin
           o_tx_ptp_ready <= tx_ui_load_done & tx_tam_load_done_r;
        end
    end

    // RX PTP ready status
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
           o_rx_ptp_ready <= 1'b0;
        end
        else begin
           o_rx_ptp_ready <= rx_ui_load_done & rx_tam_load_done_r & i_rx_lock & ptp_rx_aib_dsk_done_r;
        end
    end

    //assign o_tx_ptp_ready = tx_ui_load_done & tx_tam_load_done_r;
    //assign o_rx_ptp_ready = rx_ui_load_done & rx_tam_load_done_r & i_rx_lock & ptp_rx_aib_dsk_done_r;

    //  PTP ready Debug
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
           o_ptp_ready_dbg <= 8'd0;
        end
        else begin
           o_ptp_ready_dbg <= {o_rx_ptp_ready, rx_tam_load_done_r, rx_ui_load_done, ptp_rx_aib_dsk_done_r,
                               i_rx_lock, o_tx_ptp_ready, tx_tam_load_done_r, tx_ui_load_done};
        end
    end


    // PTP commands conversion
    always @(posedge i_clk) begin
        if(!i_rst_n4) begin
            tx_sop_p1           <= 0;
            tx_sop_p2           <= 0;
            tx_sop_p3           <= 0;
            tx_sop_p4           <= 0;
            tx_inframe_p1       <= 0;
            tx_inframe_p2       <= 0;
            byte_count_lsb_p1   <= 0;
            byte_count_lsb_p2   <= 0;
            byte_count_msb_p2   <= 0;
        end
        else begin
            if(i_tx_valid) begin
                tx_sop_p1 <= i_tx_sop;
                tx_sop_p2 <= tx_sop_p1;
                tx_sop_p3 <= tx_sop_p2;
                tx_sop_p4 <= tx_sop_p3;

                tx_inframe_p1 <= i_tx_inframe;
                tx_inframe_p2 <= tx_inframe_p1;

                byte_count_lsb_p1 <= (!i_tx_preamble_pass && i_tx_sop)  ? 9'h0 :
                                     ( i_tx_preamble_pass && i_tx_sop)  ? 9'h0 :
                                     ( i_tx_preamble_pass && tx_sop_p1) ? 9'h0 :
                                                                          byte_count_lsb_p1[7:0] + 8'h8;
                byte_count_lsb_p2 <= byte_count_lsb_p1[7:0];
                byte_count_msb_p2 <= (!i_tx_preamble_pass && tx_sop_p1) ? 9'h0 :
                                     ( i_tx_preamble_pass && tx_sop_p1) ? 9'h0 :
                                     ( i_tx_preamble_pass && tx_sop_p2) ? 9'h0 :
                                                                          byte_count_msb_p2[7:0] + byte_count_lsb_p1[8];
            end
        end
    end

    assign byte_count_p2 = {byte_count_msb_p2[7:0], byte_count_lsb_p2[7:0]};

    // tr : 2-step timestamp request
    // ts : 1-step timestamp insert
    // cf : 1-step modify correction field
    // cs : IPv4 clear checksum to zero
    // eb : IPv6 extended byte
    // tf : Format for 1-step timestamp insert 1588v1/1588v2
    always @(posedge i_clk) begin
        if(!i_rst_n3) begin
            tr_cmd_p1    <= 0;
            ts_cmd_p1    <= 0;
            cf_cmd_p1    <= 0;
            cs_cmd_p1    <= 0;
            eb_cmd_p1    <= 0;
            tf_cmd_p1    <= 0;

            tr_cmd_p2    <= 0;
            ts_cmd_p2    <= 0;
            cf_cmd_p2    <= 0;
            cs_cmd_p2    <= 0;
            eb_cmd_p2    <= 0;
            tf_cmd_p2    <= 0;

            tr_cmd_p3    <= 0;
            ts_cmd_p3    <= 0;
            cf_cmd_p3    <= 0;
            cs_cmd_p3    <= 0;
            eb_cmd_p3    <= 0;
            tf_cmd_p3    <= 0;

            ts_offset_p1 <= 0;
            cf_offset_p1 <= 0;
            cs_offset_p1 <= 0;
            eb_offset_p1 <= 0;

            ts_offset_p2 <= 0;
            cf_offset_p2 <= 0;
            cs_offset_p2 <= 0;
            eb_offset_p2 <= 0;

            ts_offset_p3 <= 0;
            cf_offset_p3 <= 0;
            cs_offset_p3 <= 0;
            eb_offset_p3 <= 0;

            is_ts_offset_p3 <= 0;
            is_cf_offset_p3 <= 0;
            is_cs_offset_p3 <= 0;
            is_eb_offset_p3 <= 0;

            cmd_ins_type_p4    <= 0;
            cmd_ins_type_p5    <= 0;

            cmd_byte_offset_p4 <= 0;
            cmd_byte_offset_p5 <= 0;
        end
        else begin
            if(i_tx_valid) begin
                if(i_tx_sop) begin
                    tr_cmd_p1    <= i_ptp_ts_req;
                    ts_cmd_p1    <= i_ptp_ins_ets   && !i_tx_skip_crc;
                    cf_cmd_p1    <= i_ptp_ins_cf    && !i_tx_skip_crc;
                    cs_cmd_p1    <= i_ptp_zero_csum && !i_tx_skip_crc;
                    eb_cmd_p1    <= i_ptp_update_eb && !i_tx_skip_crc;
                    tf_cmd_p1    <= i_ptp_ts_format;

                    ts_offset_p1 <= i_ptp_ts_offset;
                    cf_offset_p1 <= i_ptp_cf_offset;
                    cs_offset_p1 <= i_ptp_csum_offset;
                    eb_offset_p1 <= i_ptp_eb_offset;
                end

                // Priority: Insert timestamp => Modify correction field => Request 2-step timestamp
                tr_cmd_p2    <= (tr_cmd_p1 || (cf_cmd_p1 && tf_cmd_p1)) && !ts_cmd_p1 && !(cf_cmd_p1 && !tf_cmd_p1);
                ts_cmd_p2    <= ts_cmd_p1;
                cf_cmd_p2    <= cf_cmd_p1 && !tf_cmd_p1 && !ts_cmd_p1;
                cs_cmd_p2    <= cs_cmd_p1;
                eb_cmd_p2    <= eb_cmd_p1;
                tf_cmd_p2    <= tf_cmd_p1;

                tr_cmd_p3    <= tr_cmd_p2;
                ts_cmd_p3    <= ts_cmd_p2;
                cf_cmd_p3    <= cf_cmd_p2;
                cs_cmd_p3    <= cs_cmd_p2;
                eb_cmd_p3    <= eb_cmd_p2;
                tf_cmd_p3    <= tf_cmd_p2;

                ts_offset_p2 <= ts_offset_p1;
                cf_offset_p2 <= cf_offset_p1;
                cs_offset_p2 <= cs_offset_p1;
                eb_offset_p2 <= eb_offset_p1;

                ts_offset_p3 <= ts_offset_p2;
                cf_offset_p3 <= cf_offset_p2;
                cs_offset_p3 <= cs_offset_p2;
                eb_offset_p3 <= eb_offset_p2;

                is_ts_offset_p3[0] <= (ts_offset_p2[ 3: 3] == byte_count_p2[ 3: 3]) ? 1'b1 : 1'b0;
                is_ts_offset_p3[1] <= (ts_offset_p2[ 7: 4] == byte_count_p2[ 7: 4]) ? 1'b1 : 1'b0;
                is_ts_offset_p3[2] <= (ts_offset_p2[11: 8] == byte_count_p2[11: 8]) ? 1'b1 : 1'b0;
                is_ts_offset_p3[3] <= (ts_offset_p2[15:12] == byte_count_p2[15:12]) ? 1'b1 : 1'b0;

                is_cf_offset_p3[0] <= (cf_offset_p2[ 3: 3] == byte_count_p2[ 3: 3]) ? 1'b1 : 1'b0;
                is_cf_offset_p3[1] <= (cf_offset_p2[ 7: 4] == byte_count_p2[ 7: 4]) ? 1'b1 : 1'b0;
                is_cf_offset_p3[2] <= (cf_offset_p2[11: 8] == byte_count_p2[11: 8]) ? 1'b1 : 1'b0;
                is_cf_offset_p3[3] <= (cf_offset_p2[15:12] == byte_count_p2[15:12]) ? 1'b1 : 1'b0;

                is_cs_offset_p3[0] <= (cs_offset_p2[ 3: 3] == byte_count_p2[ 3: 3]) ? 1'b1 : 1'b0;
                is_cs_offset_p3[1] <= (cs_offset_p2[ 7: 4] == byte_count_p2[ 7: 4]) ? 1'b1 : 1'b0;
                is_cs_offset_p3[2] <= (cs_offset_p2[11: 8] == byte_count_p2[11: 8]) ? 1'b1 : 1'b0;
                is_cs_offset_p3[3] <= (cs_offset_p2[15:12] == byte_count_p2[15:12]) ? 1'b1 : 1'b0;

                is_eb_offset_p3[0] <= (eb_offset_p2[ 3: 3] == byte_count_p2[ 3: 3]) ? 1'b1 : 1'b0;
                is_eb_offset_p3[1] <= (eb_offset_p2[ 7: 4] == byte_count_p2[ 7: 4]) ? 1'b1 : 1'b0;
                is_eb_offset_p3[2] <= (eb_offset_p2[11: 8] == byte_count_p2[11: 8]) ? 1'b1 : 1'b0;
                is_eb_offset_p3[3] <= (eb_offset_p2[15:12] == byte_count_p2[15:12]) ? 1'b1 : 1'b0;

                cmd_ins_type_p4    <= tx_sop_p3 ? tf_cmd_p3 ? ts_cmd_p3 ? 3'b001 : // Insert 1588v1 timestamp
                                                              tr_cmd_p3 ? 3'b100 : // Request 2-step timestamp
                                                                          3'b000 : // No op
                                               /*!tf_cmd_p3*/ ts_cmd_p3 ? 3'b010 : // Insert 1588v2 timestamp
                                                              cf_cmd_p3 ? 3'b011 : // Modify 1588v2 correction field
                                                              tr_cmd_p3 ? 3'b100 : // Request 2-step timestamp
                                                                          3'b000 : // No op
                                   /*!tx_sop_p3*/ (&is_ts_offset_p3 && ts_cmd_p3)                                ? 3'b001 :
                                                  (&is_cf_offset_p3 && ((cf_cmd_p3 || ts_cmd_p3) && !tf_cmd_p3)) ? 3'b010 :
                                                  (&is_cs_offset_p3 && cs_cmd_p3)                                ? 3'b011 :
                                                  (&is_eb_offset_p3 && eb_cmd_p3)                                ? 3'b100 :
                                                                                                                 3'b000;

                cmd_byte_offset_p4 <= tx_sop_p3 ? (ts_cmd_p3 || (cf_cmd_p3 && !tf_cmd_p3)) ? eb_cmd_p3 ? 3'b010 : // Extended bytes for UDP/IPv6
                                                                                             cs_cmd_p3 ? 3'b001 : // Zero checksum for UDP/IPv4
                                                                                                         3'b000 :
                                                /*(ts_cmd_p3 || (cf_cmd_p3 && !tf_cmd_p3))*/ 3'b000 :
                                 /*!tx_sop_p3*/ (&is_ts_offset_p3 && ts_cmd_p3)                                ? ts_offset_p3[2:0] :
                                                (&is_cf_offset_p3 && ((cf_cmd_p3 || ts_cmd_p3) && !tf_cmd_p3)) ? cf_offset_p3[2:0] :
                                                (&is_cs_offset_p3 && cs_cmd_p3)                                ? cs_offset_p3[2:0] :
                                                (&is_eb_offset_p3 && eb_cmd_p3)                                ? eb_offset_p3[2:0] :
                                                                                                                 3'b000;

                cmd_ins_type_p5    <= cmd_ins_type_p4;
                cmd_byte_offset_p5 <= cmd_byte_offset_p4;
            end
        end
    end

    // Early warning detection
    assign ptp_cmd_p0 = (i_ptp_ts_req || i_ptp_ins_ets || i_ptp_ins_cf);


    assign early_warning_p1 = (!tx_inframe_p1 && i_tx_inframe) ? ptp_cmd_p0: //sop
                              (tx_inframe_p2 && !tx_inframe_p1) ? 1'b0: //delayed eop
                                                                  early_warning_p2;

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            early_warning_p2 <= 1'b0;
            early_warning_p3 <= 1'b0;
            early_warning_p4 <= 1'b0;
            early_warning_all_p4 <= 1'b0;
        end
        else begin
            if(i_tx_valid) begin
                early_warning_p2 <= early_warning_p1;
                early_warning_p3 <= early_warning_p2;
                early_warning_p4 <= early_warning_p3;
                early_warning_all_p4 <= early_warning_p1 ||
                                       early_warning_p2 ||
                                       early_warning_p3 ||
                                       early_warning_p4;
            end
        end
    end



// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Marc/2020 : slim35 : 1809826393 :
// Preevaluate and pipeline the entry condition of loading_p5678 process to avoid the big combi.
// ---------------------------------------------------------------------------------------------------------------------------------
	logic	req_loading_p3_tx_ui;
	logic	req_loading_p3_rx_ui;
	logic	req_loading_p3_tx_tam;
	logic	req_loading_p3_rx_tam;
	logic	any_req_loading_p3;
	logic	any_req_loading_p4;
	logic	loading_p4_avail;

	assign	req_loading_p3_tx_ui    = (req_tx_ui && tx_tam_load_done);
	assign	req_loading_p3_rx_ui    = ((req_rxdsk_ui || (req_rx_ui && rxdsk_done)) && tx_tam_load_done);
	assign	req_loading_p3_tx_tam   = (req_tx_tam);
	assign	req_loading_p3_rx_tam   = (req_rxdsk_tam || req_rx_tam);
	assign	any_req_loading_p3      = (req_loading_p3_tx_ui || req_loading_p3_rx_ui || req_loading_p3_tx_tam || req_loading_p3_rx_tam);

	always @(posedge i_clk) begin
		if(!i_rst_n) begin
			any_req_loading_p4	<= 1'b0;
		end
		else begin
			any_req_loading_p4	<= any_req_loading_p3;
		end
	end

	assign	loading_p4_avail    = (i_tx_valid && !early_warning_all_p4) && (!loading_in_progress_p5678);
// ---------------------------------------------------------------------------------------------------------------------------------

    // PTP loading
    always @(posedge i_clk) begin
        if(!i_rst_n1) begin
            loading_in_progress_p5678   <= 1'b0;
            loading_p5678               <= 4'b0000;
        end
        else begin
            if(loading_p4_avail && any_req_loading_p4) begin
                loading_in_progress_p5678   <= 1'b1;
                loading_p5678               <= 4'b0001;
            end
            else begin
                loading_in_progress_p5678   <= |loading_p5678[2:0];
                loading_p5678               <= {loading_p5678[2:0], 1'b0};
            end
        end
    end

    // PTP loading
    always @(posedge i_clk) begin
        // Load TX UI
        if(req_loading_p3_tx_ui) begin
            selected_tam_p4     <= i_tx_ui;
            load_ins_type_p4    <= 3'b111;
            load_byte_offset_p4 <= 3'b010;
            load_type_p4        <= LOAD_TYPE_TX_UI;
        end

        // Load RX UI
        else if(req_loading_p3_rx_ui) begin
            selected_tam_p4     <= req_rxdsk_ui ? 96'h0 : i_rx_ui;
            load_ins_type_p4    <= 3'b111;
            load_byte_offset_p4 <= 3'b011;
            load_type_p4        <= LOAD_TYPE_RX_UI;
        end

        // Load TX TAM
        else if(req_loading_p3_tx_tam) begin
            selected_tam_p4     <= i_tx_tam;
            load_ins_type_p4    <= 3'b111;
            load_byte_offset_p4 <= 3'b000;
            load_type_p4        <= LOAD_TYPE_TX_TAM;
        end

        // Load RX TAM
        else if(req_loading_p3_rx_tam) begin
            selected_tam_p4     <= (req_rxdsk_tam | !ptp_rx_aib_dsk_done_r) ? 96'hFFFFFFFFFFFF000000000000 : i_rx_tam;
            load_ins_type_p4    <= 3'b111;
            load_byte_offset_p4 <= 3'b001;
            load_type_p4        <= LOAD_TYPE_RX_TAM;
        end

        // Default
        else begin
            selected_tam_p4     <= 96'h0;
            load_ins_type_p4    <= 3'b000;
            load_byte_offset_p4 <= 3'b000;
            load_type_p4        <= LOAD_TYPE_NONE;
        end

        if(!loading_in_progress_p5678) begin
            selected_tam_p5678      <= selected_tam_p4;
            load_ins_type_p5678     <= load_ins_type_p4;
            load_byte_offset_p5678  <= load_byte_offset_p4;
            load_type               <= load_type_p4;
        end
        else begin
            selected_tam_p5678      <= selected_tam_p5678 << 24;
            load_ins_type_p5678     <= 3'b000;
            load_byte_offset_p5678  <= 3'b000;
            load_type               <= load_type;
        end
    end

    // Fingerprint and ingress timestamp
    always @(posedge i_clk) begin
        if(i_tx_valid) begin
            tx_fp_p1    <= i_ptp_fp;
            tx_fp_p2    <= tx_fp_p1;
            tx_fp_p3    <= tx_fp_p2;
            tx_fp_p4    <= tx_fp_p3;

            tx_its_p1   <= i_ptp_tx_its;
            tx_its_p2   <= tx_its_p1;
            tx_its_p3   <= tx_its_p2;
            tx_its_p4   <= tx_its_p3;

            if(tx_sop_p4) begin
                tx_fp_p5678  <= tx_fp_p4;
                tx_its_p5678 <= tx_its_p4;
            end
            else begin
                tx_fp_p5678  <= tx_fp_p5678 << 2;
                tx_its_p5678 <= tx_its_p5678 << 24;
            end

        end
    end

    always @(posedge i_clk) begin
        o_ptp_ins_type      <= loading_in_progress_p5678 ? load_ins_type_p5678: cmd_ins_type_p5;
        o_ptp_byte_offset   <= loading_in_progress_p5678 ? load_byte_offset_p5678: cmd_byte_offset_p5;
        o_ptp_ts            <= loading_in_progress_p5678 ? selected_tam_p5678[95:72]: tx_its_p5678[95:72];
        o_ptp_tx_fp         <= tx_fp_p5678[7:6];
    end

endmodule : alt_ehipc3_fm_sl_ptp_convert_commands

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
