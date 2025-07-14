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
module alt_ehipc3_fm_sl_ptp_rx_tam_capture (
    input  logic        i_enable_rsfec,
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [95:0] i_ptp_tod,
    input  logic        i_ptp_update, // unused
    input  logic        i_calibrate,
    input  logic        i_rx_sclk_return,
    input  logic        i_rx_am,
    output logic [95:0] o_rx_tam,
    output logic        o_req_rx_tam_load,
// -----------------------------------------------------------------------------
// 01/Sep/2020 : slim35 :
// Ciena issue : Not able to to sample i_rx/tx_sclk_return.
// Found alt_ehipc3_fm_sl_ptp_ckt_cal is using unsynchronized version of i_tx_sclk_return.
// Pulling out the synchronized version from alt_ehipc3_fm_sl_ptp_tx/rx_tam_capture to be re-used by alt_ehipc3_fm_sl_ptp_ckt_cal.
// -----------------------------------------------------------------------------
    output logic        o_sl_rx_sclk_return_sync
// -----------------------------------------------------------------------------
);

localparam SAMPLE_DELAY = 10;

wire rx_am_sync_int_n;
wire rx_am_sync_int;
wire rx_am_sync;
reg  rx_am_sync_r;
wire rx_am_sync_rise;
wire rx_sclk_return_sync;
reg  rx_sclk_return_sync_r;
wire rx_sclk_return_toggle;
reg  [SAMPLE_DELAY-1:0] rx_sclk_return_toggle_r;
reg req_rx_tam_load;

reg [95:0] rx_tam;
reg [95:0] rx_tam_r;
reg [95:0] rx_tam_fec;
reg [95:0] rx_tam_fec_r;

// RX AM Pulse Catcher
alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) rx_am_pulse_catcher_sync_0 (
    .clk    (i_clk),
    .reset  (i_rx_am),
    .d      (1'b1),
    .q      (rx_am_sync_int_n)
);

assign rx_am_sync_int = ~rx_am_sync_int_n;

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) rx_am_pulse_catcher_sync_1 (
    .clk    (i_clk),
    .reset  (1'b0),
    .d      (rx_am_sync_int),
    .q      (rx_am_sync)
);

// RX PMA Pulse Sync
reg sclk_return_r /* synthesis preserve dont_replicate dont_retime */;
reg sclk_return_rr /* synthesis preserve dont_replicate dont_retime */;
reg sclk_return_rrr /* synthesis preserve dont_replicate dont_retime */;
reg sclk_return_rrrr; //for timing purpose

always @(posedge i_clk) begin
	sclk_return_r   <= i_rx_sclk_return;
	sclk_return_rr  <= sclk_return_r;
	sclk_return_rrr <= sclk_return_rr;
	sclk_return_rrrr <= sclk_return_rrr;
end

assign rx_sclk_return_sync = sclk_return_rrrr;

// -----------------------------------------------------------------------------
// 01/Sep/2020 : slim35 :
// Ciena issue : Not able to to sample i_rx/tx_sclk_return.
// Found alt_ehipc3_fm_sl_ptp_ckt_cal is using unsynchronized version of i_tx_sclk_return.
// Pulling out the synchronized version from alt_ehipc3_fm_sl_ptp_tx/rx_tam_capture to be re-used by alt_ehipc3_fm_sl_ptp_ckt_cal.
// -----------------------------------------------------------------------------
assign o_sl_rx_sclk_return_sync = rx_sclk_return_sync;
// -----------------------------------------------------------------------------

always @(posedge i_clk) begin
    if(!i_rst_n) begin
        rx_am_sync_r <= 1'b0;
        rx_sclk_return_sync_r <= 1'b0;
        rx_sclk_return_toggle_r <= {SAMPLE_DELAY{1'b0}};
        req_rx_tam_load <= 1'b0;
        o_req_rx_tam_load <= 1'b0;
    end
    else begin
        rx_am_sync_r <= rx_am_sync;
        rx_sclk_return_sync_r <= rx_sclk_return_sync;
        rx_sclk_return_toggle_r <= {rx_sclk_return_toggle_r[SAMPLE_DELAY-2:0], rx_sclk_return_toggle};
        req_rx_tam_load <= rx_am_sync_rise;
        o_req_rx_tam_load <= req_rx_tam_load;
    end
end

always @(posedge i_clk) begin
    if(rx_sclk_return_toggle) begin
        rx_tam <= i_ptp_tod;
        rx_tam_fec <= rx_tam;
    end

    // Delay the update of rx_tam to avoid scenario when next i_rx_sclk_return is too close (or earlier) to i_rx_am in RSFEC mode
    if(rx_sclk_return_toggle_r[3]) begin
        rx_tam_r <= rx_tam;
    end

    if(rx_sclk_return_toggle_r[SAMPLE_DELAY-1]) begin
        rx_tam_fec_r <= rx_tam_fec;
    end

    if(req_rx_tam_load) begin
        o_rx_tam <= i_enable_rsfec ? rx_tam_fec_r : rx_tam_r;
    end

end

assign rx_am_sync_rise = !rx_am_sync_r && rx_am_sync && (!i_calibrate);
assign rx_sclk_return_toggle = rx_sclk_return_sync_r ^ rx_sclk_return_sync;

endmodule
