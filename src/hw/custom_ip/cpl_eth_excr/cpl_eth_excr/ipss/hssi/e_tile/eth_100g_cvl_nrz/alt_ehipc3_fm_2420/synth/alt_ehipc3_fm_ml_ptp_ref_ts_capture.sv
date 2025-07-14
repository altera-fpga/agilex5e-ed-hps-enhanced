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
module alt_ehipc3_fm_ml_ptp_ref_ts_capture #(
    parameter LANES    = 4
) (
    // Configuration
    input  logic                    i_enable_rsfec,

    input  logic                    i_clk,
    input  logic                    i_tx_rst_n,
    input  logic                    i_rx_rst_n,

    input  logic                    i_tx_rst_n_rr,
    input  logic                    i_rx_rst_n_rr,

    input  logic                    i_pcs_fully_aligned,
    input  logic                    i_all_ready,

    input  logic            [95:0]  i_ptp_tod,

    output logic [LANES-1:0]        o_tx_error_valid,
    output logic [LANES-1:0][31:0]  o_tx_error,

    output logic [LANES-1:0][31:0]  o_rx_error,
    output logic [LANES-1:0]        o_rx_error_valid,

    output logic [LANES-1:0][95:0]  o_rx_tam,
    output logic [LANES-1:0][95:0]  o_tx_tam,

    output logic [LANES-1:0]        o_req_tx_tam_load,
    output logic [LANES-1:0]        o_req_rx_tam_load,

    output logic                    o_read_ptp_vl_data,
    output logic            [4:0]   o_select_ptp_vl_data,

    output logic [LANES-1:0]        o_sclk,
    input  logic [LANES-1:0]        i_tx_sclk_return,
    input  logic                    i_tx_am,
    input  logic [LANES-1:0]        i_rx_sclk_return,
    input  logic                    i_rx_am,

    output logic [LANES-1:0]        o_tx_calibrate,
    output logic [LANES-1:0]        o_rx_calibrate
);

    genvar                  i;
    reg                     txrx_reset/* synthesis maxfan = 50 */;

    reg  [LANES-1:0]        calibrate_n;
    reg  [LANES-1:0]        calibrate_n_r;
    reg  [LANES-1:0]        calibrate_n_rr;
    wire [LANES-1:0]        calibrate;

    reg             [1:0]   tx_am_r;
    reg             [1:0]   rx_am_r;
    wire                    tx_am_rise;
    wire                    rx_am_rise;

    wire [LANES-1:0]        vl_offset_read_ok;
    reg                     vl_offset_read_done;

    wire [LANES-1:0]        rx_sclk_toggle;
    reg  [LANES-1:0][5:0]   rx_sclk_toggle_r;
    reg  [LANES-1:0]        rx_sclk_toggle_detect;
    wire                    rx_sclk_toggle_detect_all_lanes;
    reg                     rx_sclk_toggle_detect_all_lanes_r;
    wire                    rx_sclk_cnt_incr;

    // For better timing
    always @(posedge i_clk) begin
        txrx_reset <= ~(i_tx_rst_n_rr & i_rx_rst_n_rr);
    end

    always @(posedge i_clk) begin
        if(!i_rx_rst_n) begin
            tx_am_r <= 2'b00;
            rx_am_r <= 2'b00;
        end
        else begin
            tx_am_r <= {tx_am_r[0], i_tx_am};
            rx_am_r <= {rx_am_r[0], i_rx_am};
        end
    end

    // As i_rx_am will be high for 4 cycles in 100G mode, but may be deasserted in the middle of 4 cycle during deassertion of RX valid
    // Therefore, rising edge detection of RX AM are done by checking two cycle of low instead of one cycle to filter out false rise
    assign tx_am_rise = {tx_am_r, i_tx_am} == 3'b001;
    assign rx_am_rise = {rx_am_r, i_rx_am} == 3'b001;

    assign rx_sclk_toggle_detect_all_lanes = &rx_sclk_toggle_detect;

    always @(posedge i_clk) begin
        if(!i_rx_rst_n) begin
            rx_sclk_toggle_detect_all_lanes_r <= 1'b0;
        end
        else begin
            rx_sclk_toggle_detect_all_lanes_r <= rx_sclk_toggle_detect_all_lanes;
        end
    end

    assign rx_sclk_cnt_incr = !rx_sclk_toggle_detect_all_lanes_r && rx_sclk_toggle_detect_all_lanes;

    logic all_vl_offset_read_ok; //for timing
    always @(posedge i_clk) begin
        if(!i_rx_rst_n) begin
            all_vl_offset_read_ok  <= 1'b0;
            vl_offset_read_done  <= 1'b0;
            o_read_ptp_vl_data   <= 1'b0;
            o_select_ptp_vl_data <= 5'd0;
        end
        else begin
            all_vl_offset_read_ok <= &vl_offset_read_ok;
            if(!i_pcs_fully_aligned) begin
                vl_offset_read_done <= 1'b0;
            end
            else if(!vl_offset_read_done) begin
                if(o_read_ptp_vl_data && (o_select_ptp_vl_data == 5'd19)) begin
                    o_read_ptp_vl_data <= 1'b0;
                    vl_offset_read_done <= 1'b1;
                end
                else if(all_vl_offset_read_ok) begin
                    o_read_ptp_vl_data <= 1'b1;
                end

                if(o_read_ptp_vl_data) begin
                    o_select_ptp_vl_data <= o_select_ptp_vl_data + 1'b1;
                end
            end
        end
    end

    reg   [LANES-1:0]        calibrate_dly_n;
    reg   [LANES-1:0]        calibrate_dly_n_r;
    reg   [LANES-1:0]        calibrate_dly_n_rr;
    wire  [LANES-1:0]        calibrate_dly;
    localparam               CALIBRATE_DELAY = 242; // 242*2.482 = 600.644ns
    logic [LANES-1:0]        calibrate_dly_cnt_ena;
    logic [LANES-1:0][8:0]   calibrate_dly_cnt;

    generate
        for(i = 0; i < LANES; i++) begin: LANES_LOOP
            assign calibrate     [i] = !calibrate_n_rr[i];
            assign o_tx_calibrate[i] = calibrate[i];
            assign o_rx_calibrate[i] = calibrate[i];

            always @(posedge i_clk) begin
                if(txrx_reset) begin
                    calibrate_n   [i] <= 1'b0;
                    calibrate_n_r [i] <= 1'b0;
                    calibrate_n_rr[i] <= 1'b0;
                end
                else begin
                    if(!calibrate_n[i] && o_tx_error_valid[i] && o_rx_error_valid[i] && i_all_ready) begin
                        calibrate_n[i] <= 1'b1;
                    end
                    calibrate_n_r[i] <= calibrate_n[i];
                    calibrate_n_rr[i] <= calibrate_n_r[i];
                end
            end

            assign calibrate_dly [i] = !calibrate_dly_n_rr[i];

            always @(posedge i_clk) begin
                if(txrx_reset) begin
                    calibrate_dly_n        [i]  <= 1'b0;
                    calibrate_dly_n_r      [i]  <= 1'b0;
                    calibrate_dly_n_rr     [i]  <= 1'b0;
                    calibrate_dly_cnt_ena  [i]  <= 1'b1;
                    calibrate_dly_cnt      [i]  <= 9'h0;
                end
                else begin
                    calibrate_dly_cnt_ena[i] <= (calibrate_dly_cnt[i] >= CALIBRATE_DELAY) ? 1'b0 : 1'b1;

                    if (calibrate_n[i]) begin
                        if (calibrate_dly_cnt_ena) begin
                            calibrate_dly_cnt[i] <= calibrate_dly_cnt[i] + 9'd1;
                        end
                    end
                    else begin
                        calibrate_dly_cnt[i] <= 9'h0;
                    end

                    calibrate_dly_n[i]    <= !calibrate_dly_cnt_ena;
                    calibrate_dly_n_r[i]  <= calibrate_dly_n[i];
                    calibrate_dly_n_rr[i] <= calibrate_dly_n_r[i];
                end
            end

            alt_ehipc3_fm_ml_ptp_ckt_cal ptp_ckt_cal_u (
                .i_clk              (i_clk), //402.832MHz
                .i_rst_n            (!txrx_reset),
                .i_all_ready        (i_all_ready),
                .i_calibrate        (calibrate[i]),
                .i_rx_sclk_return   (i_rx_sclk_return[i]),
                .i_tx_sclk_return   (i_tx_sclk_return[i]),
                .o_sclk             (o_sclk[i]),
                .o_tx_error         (o_tx_error[i]),
                .o_tx_error_valid   (o_tx_error_valid[i]),
                .o_rx_error         (o_rx_error[i]),
                .o_rx_error_valid   (o_rx_error_valid[i])
            );

            alt_ehipc3_fm_ml_ptp_tx_tam_capture tx_tam_capture (
                .i_enable_rsfec     (i_enable_rsfec),
                .i_clk              (i_clk),
                .i_rst_n            (i_tx_rst_n),
                .i_ptp_tod          (i_ptp_tod),
                .i_calibrate        (calibrate_dly[i]),
                .i_tx_sclk_return   (i_tx_sclk_return[i]),
                .i_tx_am            (i_tx_am),
                .o_tx_tam           (o_tx_tam[i]),
                .o_req_tx_tam_load  (o_req_tx_tam_load[i])
            );

            always @(posedge i_clk) begin
                if(!i_rx_rst_n) begin
                    rx_sclk_toggle_r[i] <= {6{1'b0}};
                    rx_sclk_toggle_detect[i] <= 1'b0;
                end
                else begin
                    rx_sclk_toggle_r[i] <= {rx_sclk_toggle_r[i][4:0], rx_sclk_toggle[i]};
                    rx_sclk_toggle_detect[i] <= |rx_sclk_toggle_r[i] | rx_sclk_toggle[i];
                end
            end

            alt_ehipc3_fm_ml_ptp_rx_tam_capture rx_tam_capture (
                .i_enable_rsfec     (i_enable_rsfec),
                .i_clk              (i_clk),
                .i_rst_n            (i_rx_rst_n),
                .i_ptp_tod          (i_ptp_tod),
                .i_calibrate        (calibrate_dly[i]),
                .i_tx_am_rise       (tx_am_rise),
                .i_rx_am_rise       (rx_am_rise),
                .i_rx_sclk_return   (i_rx_sclk_return[i]),
                .i_rx_sclk_cnt_incr (rx_sclk_cnt_incr),
                .o_rx_sclk_toggle   (rx_sclk_toggle[i]),
                .o_rx_tam           (o_rx_tam[i]),
                .o_req_rx_tam_load  (o_req_rx_tam_load[i]),
                .o_vl_offset_read_ok(vl_offset_read_ok[i])
            );
        end
    endgenerate
endmodule
