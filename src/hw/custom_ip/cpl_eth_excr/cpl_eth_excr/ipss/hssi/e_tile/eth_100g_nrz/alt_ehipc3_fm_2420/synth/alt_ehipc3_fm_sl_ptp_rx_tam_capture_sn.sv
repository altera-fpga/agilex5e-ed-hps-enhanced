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
module alt_ehipc3_fm_sl_ptp_rx_tam_capture_sn (
    input  logic        i_enable_rsfec,
    input  logic        i_rx_sn_dn,
    input  logic [15:0] i_rx_ap_roll_dly,
    input  logic        i_clk,
    input  logic        i_ptp_clk,
    input  logic        i_ptp_rst_n,
    input  logic        i_ptp_arst,
    input  logic        i_arst_n,
    input  logic        i_rst_n,
    input  logic [95:0] i_ptp_rx_tod,
    input  logic        i_ptp_update, // unused
    input  logic        i_calibrate,
    input  logic        i_rx_sclk_return,
    input  logic        i_rx_am,
    output logic [95:0] o_rx_tam,
    output logic        o_req_rx_tam_load
);

localparam SAMPLE_DELAY = 10;

reg [31:0] rx_am_sync_rise_pipe;
reg        i_calibrate_f;
wire rx_am_sync_int_n;
wire rx_am_sync_int;
wire rx_am_sync;
reg  rx_am_sync_r;
wire rx_am_sync_rise;
wire rx_sclk_return_sync;
reg  rx_sclk_return_sync_r;
wire rx_sclk_return_toggle;
reg  [SAMPLE_DELAY-1:0] rx_sclk_return_toggle_r;
wire req_rx_tam_load;
reg  req_rx_tam_load_l;

reg [95:0] rx_tam;
reg [95:0] rx_tam_r;
reg [95:0] rx_tam_fec;
reg [95:0] rx_tam_fec_r;
reg [95:0] rx_tam_l;

logic  rx_tam_cc_valid_1s;
logic [95:0] rx_tam_cc;

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

always @(posedge i_clk) begin
	sclk_return_r   <= i_rx_sclk_return;
	sclk_return_rr  <= sclk_return_r;
	sclk_return_rrr <= sclk_return_rr;
end

assign rx_sclk_return_sync = sclk_return_rrr;

always @(posedge i_clk) begin
    if(!i_rst_n) begin
        rx_am_sync_r <= 1'b0;
        rx_sclk_return_sync_r <= 1'b0;
        rx_sclk_return_toggle_r <= {SAMPLE_DELAY{1'b0}};
        req_rx_tam_load_l <= 1'b0;
        //rx_tam <= 96'h0;
        //rx_tam_r <= 96'h0;
        //rx_tam_fec <= 96'h0;
        //rx_tam_fec_r <= 96'h0;
        //rx_tam_l <= 96'h0;
    end
    else begin
        rx_am_sync_r <= rx_am_sync;
        rx_sclk_return_sync_r <= rx_sclk_return_sync;
        rx_sclk_return_toggle_r <= {rx_sclk_return_toggle_r[SAMPLE_DELAY-2:0], rx_sclk_return_toggle};
        req_rx_tam_load_l <= req_rx_tam_load;

      /*  if(rx_sclk_return_toggle) begin
            rx_tam <= i_ptp_rx_tod;
//            rx_tam_fec <= (i_rx_sn_dn) ? i_ptp_rx_tod : rx_tam;
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
            rx_tam_l <= i_enable_rsfec ? rx_tam_fec_r : rx_tam_r;
        end*/
    end
end

always @(posedge i_clk) begin
        if(rx_sclk_return_toggle) begin
            rx_tam <= i_ptp_rx_tod;
//            rx_tam_fec <= (i_rx_sn_dn) ? i_ptp_rx_tod : rx_tam;
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
            rx_tam_l <= i_enable_rsfec ? rx_tam_fec_r : rx_tam_r;
        end
end

assign rx_am_sync_rise = !rx_am_sync_r && rx_am_sync && (!i_calibrate_f);
assign rx_sclk_return_toggle = rx_sclk_return_sync_r ^ rx_sclk_return_sync;

 always@(posedge i_clk)
  begin
    if (i_rx_sn_dn)
      i_calibrate_f <= 1'b0;
    else
      i_calibrate_f <= i_calibrate;
  end
//assign req_rx_tam_load = rx_am_sync_rise;

 always@(posedge i_clk)
  begin
    if (i_rx_sn_dn)
      rx_am_sync_rise_pipe <= {rx_am_sync_rise_pipe[30:0], rx_am_sync_rise};
    else
      rx_am_sync_rise_pipe <= 32'd0;
  end
  assign req_rx_tam_load = (i_rx_sn_dn) ? rx_am_sync_rise_pipe[i_rx_ap_roll_dly - 1] : rx_am_sync_rise;
/*
    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (96),
        .INIT_VALUE         (0)
    ) sync_rxtam_2ptp (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (rx_tam_l),
        .q                  (o_rx_tam)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) sync_rxtamload_2ptp (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (req_rx_tam_load_l),
        .q                  (o_req_rx_tam_load)
    );
*/

        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (96),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) sync_rxtam_2ptp_icc (
            .in_clk                 (i_clk),
            .in_reset               (!i_arst_n),
            .in_ready               (),
            .in_valid               (req_rx_tam_load_l),
            .in_data                (rx_tam_l),
            .out_clk                (i_ptp_clk),
            .out_reset              (i_ptp_arst),
            .out_ready              (!i_ptp_arst),

            .out_valid              (rx_tam_cc_valid_1s),
            .out_data               (rx_tam_cc)
        );

/*
  always@(posedge i_ptp_clk)
  begin
    if(!i_ptp_rst_n)
      o_rx_tam <= 'd0;
    else if (rx_tam_cc_valid_1s)
      o_rx_tam <= rx_tam_cc;
  end*/

  assign o_rx_tam = rx_tam_cc;

  always@(posedge i_ptp_clk)
  begin
    if(!i_ptp_rst_n)
      o_req_rx_tam_load <= 'd0;
    else
      o_req_rx_tam_load <= rx_tam_cc_valid_1s;
  end


endmodule
