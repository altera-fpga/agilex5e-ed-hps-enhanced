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
module alt_ehipc3_fm_sl_ptp_tx_tam_capture_sn (
    input  logic        i_enable_rsfec,
    input  logic        i_clk,
    input  logic        i_ptp_clk,
    input  logic        i_ptp_rst_n,
    input  logic        i_ptp_arst,
    input  logic        i_rst_n,
    input  logic        i_arst_n,
    input  logic [95:0] i_ptp_tx_tod,
    input  logic        i_ptp_update, // unused
    input  logic        i_calibrate,
    input  logic        i_tx_sclk_return,
    input  logic        i_tx_am,
    output logic [95:0] o_tx_tam,
    output logic        o_req_tx_tam_load
);

wire tx_am_sync_int_n;
wire tx_am_sync_int;
wire tx_am_sync;
reg  tx_am_sync_keep;
wire tx_sclk_return_sync;
reg  tx_sclk_return_sync_r;
wire tx_sclk_return_toggle;
wire req_tx_tam_load;
reg  req_tx_tam_load_r;
reg  req_tx_tam_load_l;
reg [95:0] tx_tam_l;

logic  tx_tam_cc_valid_1s;
logic [95:0] tx_tam_cc;

// TX AM Pulse Catcher
alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) tx_am_pulse_catcher_sync_0 (
    .clk    (i_clk),
    .reset  (i_tx_am),
    .d      (1'b1),
    .q      (tx_am_sync_int_n)
);

assign tx_am_sync_int = ~tx_am_sync_int_n;

alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH  (3),
    .WIDTH              (1),
    .INIT_VALUE         (0)
) tx_am_pulse_catcher_sync_1 (
    .clk    (i_clk),
    .reset  (1'b0),
    .d      (tx_am_sync_int),
    .q      (tx_am_sync)
);

// TX PMA Pulse Sync
reg sclk_return_r /* synthesis preserve dont_replicate dont_retime */;
reg sclk_return_rr /* synthesis preserve dont_replicate dont_retime */;
reg sclk_return_rrr /* synthesis preserve dont_replicate dont_retime */;

always @(posedge i_clk) begin
	sclk_return_r   <= i_tx_sclk_return;
	sclk_return_rr  <= sclk_return_r;
	sclk_return_rrr <= sclk_return_rr;
end

assign tx_sclk_return_sync = sclk_return_rrr;

always @(posedge i_clk) begin
    if(!i_rst_n) begin
        tx_am_sync_keep <= 1'b0;
        tx_sclk_return_sync_r <= 1'b0;
        req_tx_tam_load_r <= 1'b0;
        req_tx_tam_load_l <= 1'b0;
        //tx_tam_l <= 96'h0;
    end
    else begin
        tx_am_sync_keep <= ((tx_am_sync_keep && !req_tx_tam_load) || tx_am_sync) && (!i_calibrate);
        tx_sclk_return_sync_r <= tx_sclk_return_sync;
        req_tx_tam_load_r <= req_tx_tam_load;
        req_tx_tam_load_l <= req_tx_tam_load_r;

//        if(req_tx_tam_load_r) begin
//            tx_tam_l <= i_ptp_tx_tod;
//        end
    end
end

always @(posedge i_clk) begin
        if(req_tx_tam_load_r) begin
            tx_tam_l <= i_ptp_tx_tod;
        end
end

assign tx_sclk_return_toggle = tx_sclk_return_sync_r ^ tx_sclk_return_sync;

assign req_tx_tam_load = tx_am_sync_keep && tx_sclk_return_toggle;

/*
    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (96),
        .INIT_VALUE         (0)
    ) sync_txtam_2ptp (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (tx_tam_l),
        .q                  (o_tx_tam)
    );


    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) sync_txtamload_2ptp (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (req_tx_tam_load_l),
        .q                  (o_req_tx_tam_load)
    );

*/


        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (96),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) sync_txtam_2ptp_icc (
            .in_clk                 (i_clk),
            .in_reset               (!i_arst_n),
            .in_ready               (),
            .in_valid               (req_tx_tam_load_l),
            .in_data                (tx_tam_l),
            .out_clk                (i_ptp_clk),
            .out_reset              (i_ptp_arst),
            .out_ready              (!i_ptp_arst),

            .out_valid              (tx_tam_cc_valid_1s),
            .out_data               (tx_tam_cc)
        );

/*
  always@(posedge i_ptp_clk)
  begin
    if(!i_ptp_rst_n)
      o_tx_tam <= 'd0;
    else if (tx_tam_cc_valid_1s)
      o_tx_tam <= tx_tam_cc;
  end
*/

assign o_tx_tam = tx_tam_cc;

  always@(posedge i_ptp_clk)
  begin
    if(!i_ptp_rst_n)
      o_req_tx_tam_load <= 'd0;
    else
      o_req_tx_tam_load <= tx_tam_cc_valid_1s;
  end


endmodule
