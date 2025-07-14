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
module alt_ehipc3_fm_ml_ptp_ckt_cal #(
    parameter PERIOD_NS_FNS = 18'h27B80 // 402.832MHz
)(
    input  logic        i_clk, //402.832MHz
    input  logic        i_rst_n,

    input  logic        i_all_ready,

    input  logic        i_calibrate,

    input  logic        i_rx_sclk_return,
    input  logic        i_tx_sclk_return,

    output logic        o_sclk,
    output logic [31:0] o_tx_error,
    output logic        o_tx_error_valid,
    output logic [31:0] o_rx_error,
    output logic        o_rx_error_valid
  );

    // TX PMA Pulse Sync
    logic           tx_sclk_return_r /* synthesis preserve dont_replicate dont_retime */;
    logic           tx_sclk_return_rr /* synthesis preserve dont_replicate dont_retime */;
    logic           tx_sclk_return_rrr /* synthesis preserve dont_replicate dont_retime */;
    logic           tx_sclk_return_sync;
    logic           tx_sclk_return_sync_r;
    logic           tx_sclk_return_sync_rr;
    logic           tx_sclk_return_rise;
    logic           tx_sclk_return_rise_r;

    // RX PMA Pulse Sync
    logic           rx_sclk_return_r /* synthesis preserve dont_replicate dont_retime */;
    logic           rx_sclk_return_rr /* synthesis preserve dont_replicate dont_retime */;
    logic           rx_sclk_return_rrr /* synthesis preserve dont_replicate dont_retime */;
    logic           rx_sclk_return_sync;
    logic           rx_sclk_return_sync_r;
    logic           rx_sclk_return_sync_rr;
    logic           rx_sclk_return_rise;
    logic           rx_sclk_return_rise_r;

    logic           sclk;
    logic           sclk_r;
    logic [3:0]     counter;
    logic [4:0]     counter_plus_one;
    logic [3:0]     tx_error_counter;
    logic [3:0]     tx_error_counter_adj;
    logic [3:0]     rx_error_counter;
    logic [3:0]     rx_error_counter_adj;
    logic [31:0]    tx_error;
    logic [31:0]    rx_error;
    logic [31:0]    tx_error_adj;
    logic [31:0]    rx_error_adj;
    logic           tx_error_valid;
    logic           rx_error_valid;
    logic           tx_error_valid_r;
    logic           tx_error_valid_rr;
    logic           rx_error_valid_r;
    logic           rx_error_valid_rr;

    logic           tx_error_cnt_in_progress;
    logic           rx_error_cnt_in_progress;

    always @(posedge i_clk) begin
        tx_sclk_return_r      <= i_tx_sclk_return;
        tx_sclk_return_rr     <= tx_sclk_return_r;
        tx_sclk_return_rrr    <= tx_sclk_return_rr;
    end

    always @(posedge i_clk) begin
        rx_sclk_return_r      <= i_rx_sclk_return;
        rx_sclk_return_rr     <= rx_sclk_return_r;
        rx_sclk_return_rrr    <= rx_sclk_return_rr;
    end

    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            sclk <= 0;
            sclk_r <= 0;

            tx_sclk_return_sync_r <= 1'b0;
            rx_sclk_return_sync_r <= 1'b0;

            tx_sclk_return_sync_rr <= 1'b0;
            rx_sclk_return_sync_rr <= 1'b0;

            tx_sclk_return_rise_r <= 1'b0;
            rx_sclk_return_rise_r <= 1'b0;
        end
        else begin
            sclk <= ((counter == 0) || (counter == 1)) && i_calibrate && i_all_ready;
            sclk_r <= sclk;

            tx_sclk_return_sync_r <= tx_sclk_return_sync;
            rx_sclk_return_sync_r <= rx_sclk_return_sync;

            tx_sclk_return_sync_rr <= tx_sclk_return_sync_r;
            rx_sclk_return_sync_rr <= rx_sclk_return_sync_r;

            tx_sclk_return_rise_r <= tx_sclk_return_rise;
            rx_sclk_return_rise_r <= rx_sclk_return_rise;
        end
    end

    always @ (posedge i_clk) begin
        o_sclk <= sclk;
    end

    assign tx_sclk_return_sync = tx_sclk_return_rrr;
    assign rx_sclk_return_sync = rx_sclk_return_rrr;

    assign tx_sclk_return_rise = tx_sclk_return_sync_r && !tx_sclk_return_sync_rr;
    assign rx_sclk_return_rise = rx_sclk_return_sync_r && !rx_sclk_return_sync_rr;

    assign counter_plus_one = counter + 1'b1;

    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            counter <= 0;
        end
        else begin
            if (i_calibrate && i_all_ready) begin
                counter <= counter_plus_one[3:0];
            end
        else begin
            counter <= 0;
        end
        end
    end

    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            tx_error_cnt_in_progress <= 0;
        end
        else begin
            if (tx_sclk_return_rise) begin
                tx_error_cnt_in_progress <= 0;
            end
            else if (sclk) begin
                tx_error_cnt_in_progress <= 1;
            end
        end
    end

    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            rx_error_cnt_in_progress <= 0;
        end
        else begin
            if (rx_sclk_return_rise) begin
                rx_error_cnt_in_progress <= 0;
            end
            else if (sclk) begin
                rx_error_cnt_in_progress <= 1;
            end
        end
    end

    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            tx_error_counter <= 0;
        end
        else begin
            if (!i_all_ready) begin
                tx_error_counter <= 0;
            end
            else if (sclk && !sclk_r) begin
                tx_error_counter <= 0;
            end
            else begin
                if (tx_error_cnt_in_progress) begin
                    tx_error_counter <= tx_error_counter + 1'b1;
                end
            end
        end
    end

    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            rx_error_counter <= 0;
        end
        else begin
            if (!i_all_ready) begin
                rx_error_counter <= 0;
            end
            else if (sclk && !sclk_r) begin
                rx_error_counter <= 0;
            end
            else begin
                if (rx_error_cnt_in_progress) begin
                    rx_error_counter <= rx_error_counter + 1'b1;
                end
            end
        end
    end

    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            tx_error_valid <= 0;
            tx_error_valid_r <= 0;
            tx_error_valid_rr <= 0;
            tx_error_counter_adj <= 0;
            tx_error <= 0;
            tx_error_adj <= 0;
        end
        else begin
            if (tx_sclk_return_rise_r && i_calibrate && i_all_ready) begin
                tx_error_valid <= 1;
                tx_error_counter_adj <= tx_error_counter - 4'h5;
            end

            tx_error_valid_r <= tx_error_valid;
            tx_error_valid_rr <= tx_error_valid_r;

            tx_error <= tx_error_counter_adj * PERIOD_NS_FNS;

            // Add by half cycle for sampling uncertainty
            tx_error_adj <= tx_error + (PERIOD_NS_FNS >> 1);

        end
    end

    always @ (posedge i_clk) begin
        if (!i_rst_n) begin
            rx_error_valid <= 0;
            rx_error_valid_r <= 0;
            rx_error_valid_rr <= 0;
            rx_error_counter_adj <= 0;
            rx_error <= 0;
            rx_error_adj <= 0;
        end
        else begin
            if (rx_sclk_return_rise_r && i_calibrate && i_all_ready) begin
                rx_error_valid <= 1;
                rx_error_counter_adj <= rx_error_counter - 4'h5;
            end

            rx_error_valid_r <= rx_error_valid;
            rx_error_valid_rr <= rx_error_valid_r;

            rx_error <= rx_error_counter_adj * PERIOD_NS_FNS;

            // Add by half cycle for sampling uncertainty
            rx_error_adj <= rx_error + (PERIOD_NS_FNS >> 1);

        end
    end

    assign o_tx_error_valid = tx_error_valid_rr;
    assign o_rx_error_valid = rx_error_valid_rr;

    // Divide round trip latency by 2
    assign o_tx_error = tx_error_adj >> 1;
    assign o_rx_error = rx_error_adj >> 1;

endmodule
