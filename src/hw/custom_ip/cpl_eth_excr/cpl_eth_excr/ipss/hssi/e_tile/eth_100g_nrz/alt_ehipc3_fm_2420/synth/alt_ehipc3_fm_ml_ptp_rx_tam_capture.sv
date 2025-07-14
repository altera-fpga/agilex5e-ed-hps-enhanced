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
module alt_ehipc3_fm_ml_ptp_rx_tam_capture (
    input  logic        i_enable_rsfec,
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [95:0] i_ptp_tod,
    input  logic        i_calibrate,
    input  logic        i_tx_am_rise,
    input  logic        i_rx_am_rise,
    input  logic        i_rx_sclk_return,
    input  logic        i_rx_sclk_cnt_incr,
    output logic        o_rx_sclk_toggle,
    output logic        o_vl_offset_read_ok,
    output logic [95:0] o_rx_tam,
    output logic        o_req_rx_tam_load
);

    localparam SKIP_TAMS_CNTR_VAL = 3;

    // Non-FEC mode
    localparam VL_OFFSET_VALID_VAL = 11'h2;
    localparam AM_SFT_TOLERENCE = 2;
    localparam AM_SFT_W = AM_SFT_TOLERENCE*3+2;

    // FEC mode
    localparam TAM_DELAY = 20;

    // Non-FEC mode
    reg                 am_shift_needed;
    reg                 am_shift_done;
    reg [AM_SFT_W-1:0]  rx_am_rise_r;
    wire                rx_am_rise_shifted;

    wire                tx_am_rise;
    reg                 rx_am_rise;
    reg                 rx_am_rise_shifted_r;
    reg                 rx_am_rise_shifted_rr;
    reg                 rx_sclk_return_sync;
    reg                 rx_sclk_return_sync_r;
    wire                rx_sclk_return_toggle;
    reg [TAM_DELAY-1:0] rx_sclk_return_toggle_dly;
    wire                req_rx_tam_load;


    reg  [95:0] rx_tam;
    reg  [95:0] rx_tam_fec;
    reg  [95:0] rx_tam_fec_dly;

    reg  [2:0]  skip_tams_cntr; // skip first 3 rx_ams

    // Non-FEC mode
    reg  [10:0] sclk_pulse_cnt_vl_offset;
    reg  [10:0] sclk_pulse_cnt_per_am;
    reg  [11:0] rx_sclk_pulse_cntr_plus_one;
    reg  [10:0] rx_sclk_pulse_cntr;
    reg  [10:0] rx_sclk_pulse_cntr_r;
    reg  [7:0]  hold_cnt;
    reg         rx_sclk_pulse_capture_tam;
    reg         rx_sclk_cnt_incr_r;
    reg         rx_sclk_cnt_incr_rr;
    reg         rx_sclk_cnt_incr_rrr;

    // RX PMA Pulse Sync
    reg sclk_return_r /* synthesis preserve dont_replicate dont_retime */;
    reg sclk_return_rr /* synthesis preserve dont_replicate dont_retime */;
    reg sclk_return_rrr /* synthesis preserve dont_replicate dont_retime */;

    always @(posedge i_clk) begin
        sclk_return_r   <= i_rx_sclk_return;
        sclk_return_rr  <= sclk_return_r;
        sclk_return_rrr <= sclk_return_rr;
        rx_sclk_return_sync <= sclk_return_rrr;
    end

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            rx_sclk_return_sync_r <= 1'b0;
            rx_sclk_return_toggle_dly <= {TAM_DELAY{1'b0}};
            o_req_rx_tam_load <= 1'b0;
        end
        else begin
            rx_sclk_return_sync_r <= rx_sclk_return_sync;
            rx_sclk_return_toggle_dly <= {rx_sclk_return_toggle_dly[TAM_DELAY-2:0], rx_sclk_return_toggle};
            o_req_rx_tam_load <= req_rx_tam_load && (skip_tams_cntr == SKIP_TAMS_CNTR_VAL);
        end
    end

    always @(posedge i_clk) begin
        // Non-FEC mode
        if((rx_sclk_return_toggle) && (rx_sclk_pulse_capture_tam)) begin
            rx_tam <= i_ptp_tod;
        end

        // FEC mode
        // The async pulse before RX AM detect signal is the right pulse to capture
        // Adding 20 cycle delays as guardband to avoid undetermistic latency across FIFO for AM signals
        if(rx_sclk_return_toggle) begin
            rx_tam_fec <= i_ptp_tod;
        end

        if(rx_sclk_return_toggle_dly[TAM_DELAY-1]) begin
            rx_tam_fec_dly <= rx_tam_fec;
        end

        if(req_rx_tam_load) begin
            o_rx_tam <= i_enable_rsfec ? rx_tam_fec_dly : rx_tam;
        end
    end

    // Handling of non-FEC mode for corner scenario
    // https://hsdes.intel.com/appstore/article/#/16012110471
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            rx_am_rise_r <= {AM_SFT_W{1'b0}};
            am_shift_needed <= 1'b0;
            am_shift_done <= 1'b0;
        end
        else begin
            rx_am_rise_r <= {rx_am_rise_r[AM_SFT_W-2:0], i_rx_am_rise};

            if(i_enable_rsfec) begin
                am_shift_needed <= 1'b0;
                am_shift_done <= 1'b1;
            end
            else if(!i_calibrate) begin
                // Shift required if AM is close to async pulses to avoid ambiguity of count increment
                if(i_rx_sclk_cnt_incr && (|rx_am_rise_r[AM_SFT_TOLERENCE*2-1:0] | i_rx_am_rise)) begin
                    am_shift_needed <= 1'b1;
                end

                if(rx_am_rise_r[AM_SFT_W-1]) begin
                    am_shift_done <= 1'b1;
                end
            end
        end
    end

    assign tx_am_rise = i_tx_am_rise && (!i_calibrate);
    assign rx_am_rise_shifted = i_enable_rsfec  ? i_rx_am_rise :
                                am_shift_needed ? rx_am_rise_r[AM_SFT_W-1] : rx_am_rise_r[AM_SFT_TOLERENCE-1];
    assign rx_sclk_return_toggle = rx_sclk_return_sync_r ^ rx_sclk_return_sync;
    assign o_rx_sclk_toggle = rx_sclk_return_toggle;

    assign req_rx_tam_load = rx_am_rise;

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            rx_sclk_cnt_incr_r <= 1'b0;
            rx_sclk_cnt_incr_rr <= 1'b0;
            rx_sclk_cnt_incr_rrr <= 1'b0;
            rx_am_rise_shifted_r <= 1'b0;
            rx_am_rise_shifted_rr <= 1'b0;
            rx_am_rise <= 1'b0;
        end
        else begin
            rx_sclk_cnt_incr_r <= i_rx_sclk_cnt_incr;
            rx_sclk_cnt_incr_rr <= rx_sclk_cnt_incr_r;
            rx_sclk_cnt_incr_rrr <= rx_sclk_cnt_incr_rr;
            rx_am_rise_shifted_r <= rx_am_rise_shifted && (!i_calibrate) && am_shift_done;
            rx_am_rise_shifted_rr <= rx_am_rise_shifted_r;
            rx_am_rise <= rx_am_rise_shifted_rr;
        end
    end

    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            skip_tams_cntr <= '0;
        end
        else begin
            if((skip_tams_cntr != SKIP_TAMS_CNTR_VAL) && rx_am_rise) begin
                skip_tams_cntr <= skip_tams_cntr + 1'b1;
            end
        end
    end

    // Non-FEC mode
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            rx_sclk_pulse_capture_tam <= 1'b0;
            rx_sclk_pulse_cntr <= 11'd0;
            sclk_pulse_cnt_vl_offset <= 11'd0;
        end
        else begin
            rx_sclk_pulse_capture_tam <= (rx_sclk_pulse_cntr_r == sclk_pulse_cnt_vl_offset) ? 1'b1 : 1'b0;

            rx_sclk_pulse_cntr_plus_one <= rx_sclk_pulse_cntr + 1'b1;
            rx_sclk_pulse_cntr_r <= rx_sclk_pulse_cntr;

            if(rx_am_rise) begin
                rx_sclk_pulse_cntr <= 11'd0;
                sclk_pulse_cnt_per_am <= rx_sclk_pulse_cntr;
            end
            else if(rx_sclk_cnt_incr_rrr) begin
                rx_sclk_pulse_cntr <= rx_sclk_pulse_cntr_plus_one[10:0];
            end

            sclk_pulse_cnt_vl_offset <= sclk_pulse_cnt_per_am - VL_OFFSET_VALID_VAL;
        end
    end

    // Non-FEC mode
    always @(posedge i_clk) begin
        if(!i_rst_n) begin
            o_vl_offset_read_ok <= 1'b0;
            hold_cnt <= 8'd20;
        end
        else begin
            if((skip_tams_cntr == SKIP_TAMS_CNTR_VAL) &&
               (rx_sclk_pulse_capture_tam) &&
               (rx_sclk_return_toggle)) begin
                o_vl_offset_read_ok <= 1'b1;
                hold_cnt <= 8'd0;
            end
            else begin
                if(hold_cnt == 8'd20) begin
                    o_vl_offset_read_ok <= 1'b0;
                    hold_cnt <= 8'd20;
                end
                else begin
                    o_vl_offset_read_ok <= 1'b1;
                    hold_cnt <= hold_cnt + 8'd1;
                end
           end
        end
    end

endmodule
