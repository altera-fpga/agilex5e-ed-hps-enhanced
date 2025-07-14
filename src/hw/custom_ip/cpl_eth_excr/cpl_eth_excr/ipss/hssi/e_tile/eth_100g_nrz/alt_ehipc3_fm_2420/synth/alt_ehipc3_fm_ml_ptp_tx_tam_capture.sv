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
module alt_ehipc3_fm_ml_ptp_tx_tam_capture (
    input  logic        i_enable_rsfec,
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [95:0] i_ptp_tod,
    input  logic        i_calibrate,
    input  logic        i_tx_sclk_return,
    input  logic        i_tx_am,
    output logic [95:0] o_tx_tam,
    output logic        o_req_tx_tam_load
);

wire tx_am_sync;
reg  tx_am_sync_keep;
reg  tx_sclk_return_sync;
reg  tx_sclk_return_sync_r;
wire tx_sclk_return_toggle;
wire req_tx_tam_load;
reg  req_tx_tam_load_r;

assign tx_am_sync = i_tx_am;

// TX PMA Pulse Sync
reg sclk_return_r /* synthesis preserve dont_replicate dont_retime */;
reg sclk_return_rr /* synthesis preserve dont_replicate dont_retime */;
reg sclk_return_rrr /* synthesis preserve dont_replicate dont_retime */;

always @(posedge i_clk) begin
	sclk_return_r   <= i_tx_sclk_return;
	sclk_return_rr  <= sclk_return_r;
	sclk_return_rrr <= sclk_return_rr;
	tx_sclk_return_sync <= sclk_return_rrr;
end

always @(posedge i_clk) begin
    if(!i_rst_n) begin
        tx_am_sync_keep <= 1'b0;
        tx_sclk_return_sync_r <= 1'b0;
        req_tx_tam_load_r <= 1'b0;
        o_req_tx_tam_load <= 1'b0;
    end
    else begin
        tx_am_sync_keep <= ((tx_am_sync_keep && !req_tx_tam_load) || tx_am_sync) && (!i_calibrate);
        tx_sclk_return_sync_r <= tx_sclk_return_sync;
        req_tx_tam_load_r <= req_tx_tam_load;
        o_req_tx_tam_load <= req_tx_tam_load_r;
    end
end

always @(posedge i_clk) begin
    if(req_tx_tam_load_r) begin
        o_tx_tam <= i_ptp_tod;
    end
end

assign tx_sclk_return_toggle = tx_sclk_return_sync_r ^ tx_sclk_return_sync;

assign req_tx_tam_load = tx_am_sync_keep && tx_sclk_return_toggle;

endmodule
