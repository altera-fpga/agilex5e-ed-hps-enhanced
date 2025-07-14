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
module alt_ehipc3_fm_sl_ptp_rx_deskew #(
    parameter ENABLE_PTP_RX_DESKEW = 1
) (
    // Configuration
    input  wire         i_enable_ptp,

    // Clock
    input  wire         i_clk,

    // Reset
    input  wire         i_rx_rst_n,
    input  wire		i_rx_rst_n1,

    // PTP channels RX deskew
    input  wire         i_sl_ptp_rx_aib_dsk_done,

    // Data Path + PTP channels RX deskew
    output wire         o_sl_ptp_rx_aib_dsk_done,

    // RX data path
    input  wire [63:0]  i_sl_rx_data,
    input  wire         i_sl_rx_valid,
    input  wire         i_sl_rx_inframe,
    input  wire [2:0]   i_sl_rx_empty,
    input  wire [1:0]   i_sl_rx_error,
    input  wire         i_sl_rx_fcs_error,
    input  wire [2:0]   i_sl_rx_status,

    output wire [63:0]  o_sl_rx_data,
    output wire         o_sl_rx_valid,
    output wire         o_sl_rx_inframe,
    output wire [2:0]   o_sl_rx_empty,
    output wire [1:0]   o_sl_rx_error,
    output wire         o_sl_rx_fcs_error,
    output wire [2:0]   o_sl_rx_status,

    // RX PTP timestamp
    input  wire [20:0]  i_sl_ptp_rx_ts,
    output wire [20:0]  o_sl_ptp_rx_ts,

    // RX AM pulse
    input  wire         i_sl_rx_am,
    output wire         o_sl_rx_am
);

    localparam PKT_DATA_W = 1+3+1+2+3+1+64+1; // 76
    localparam PTP_DATA_W = 21+1;

    localparam SELECT_INPUT = 2'b00;
    localparam SELECT_NONE  = 2'b01;
    localparam SELECT_DSK   = 2'b10;

    wire [PKT_DATA_W-1:0] pkt_data_in;
    wire [PKT_DATA_W-1:0] ptp_data_in;

    reg  [PKT_DATA_W-1:0] pkt_data_in_r;
    reg  [PKT_DATA_W-1:0] ptp_data_in_r;

    wire [PKT_DATA_W-1:0] pkt_data_dsk;
    wire [PKT_DATA_W-1:0] ptp_data_dsk;

    wire [PKT_DATA_W-1:0] pkt_data_out;
    wire [PKT_DATA_W-1:0] ptp_data_out;

    reg                   rx_inframe_r;
    reg  [20:0]           ptp_rx_ts_r;

    wire                  rx_sop;
    wire                  rx_eop;

    wire                  pkt_dsk_marker;
    wire                  ptp_dsk_marker;

    reg                   pkt_dsk_marker_r;
    reg                   ptp_dsk_marker_r;
    reg                   first_ptp_dsk_marker;

    wire                  pkt_data_select_sop;
    reg  [1:0]            pkt_data_select;

    assign pkt_data_in = {(o_sl_ptp_rx_aib_dsk_done && rx_sop),
                          i_sl_rx_valid,
                          i_sl_rx_status,
                          i_sl_rx_fcs_error,
                          i_sl_rx_error,
                          i_sl_rx_empty,
                          i_sl_rx_inframe,
                          i_sl_rx_data};

    assign ptp_data_in = {{(PKT_DATA_W-PTP_DATA_W){1'b0}},
                          i_sl_rx_am,
                          i_sl_ptp_rx_ts};

    assign {o_sl_rx_valid,
            o_sl_rx_status,
            o_sl_rx_fcs_error,
            o_sl_rx_error,
            o_sl_rx_empty,
            o_sl_rx_inframe,
            o_sl_rx_data} = pkt_data_out[PKT_DATA_W-2:0];

    assign {o_sl_rx_am,
            o_sl_ptp_rx_ts} = ptp_data_out[PTP_DATA_W-1:0];

    if(ENABLE_PTP_RX_DESKEW) begin : RX_DESKEW

        reg [PKT_DATA_W-1:0] pkt_data_out_r;
        reg [PKT_DATA_W-1:0] pkt_data_out_rr;
        reg [PKT_DATA_W-1:0] ptp_data_out_r;
        reg [PKT_DATA_W-1:0] ptp_data_out_rr;

        assign pkt_data_select_sop = pkt_data_dsk[PKT_DATA_W-1];

        always @(posedge i_clk) begin
            if(!i_rx_rst_n) begin
                rx_inframe_r    <= 1'b0;
                ptp_rx_ts_r     <= 21'h0;
                pkt_data_select <= SELECT_INPUT;
            end
            else begin
                rx_inframe_r    <= i_sl_rx_valid ? i_sl_rx_inframe : rx_inframe_r;
                ptp_rx_ts_r     <= i_sl_ptp_rx_ts;
                pkt_data_select <= (pkt_data_select == SELECT_DSK)                             ? SELECT_DSK  :  // At stable state, always use deskew data
                                   pkt_data_select_sop                                         ? SELECT_DSK  :  // Switch to use deskew data after receive first packet with deskew done status
                                   (pkt_data_select == SELECT_NONE)                            ? SELECT_NONE :  // At transition state, output nothing
                                   (o_sl_ptp_rx_aib_dsk_done && (rx_eop && i_sl_rx_valid))     ? SELECT_NONE :  // No output after deskew is done and before next packet
                                                                                                 SELECT_INPUT;  // Default
            end
        end

        assign rx_sop         = i_sl_rx_inframe && !rx_inframe_r;
        assign rx_eop         = !i_sl_rx_inframe && rx_inframe_r;

        assign pkt_dsk_marker = first_ptp_dsk_marker && rx_sop && i_sl_rx_valid && i_sl_ptp_rx_aib_dsk_done && !o_sl_ptp_rx_aib_dsk_done;
        assign ptp_dsk_marker = (i_sl_ptp_rx_ts == 21'h1FFFFF) && (ptp_rx_ts_r == 21'h0) && i_sl_ptp_rx_aib_dsk_done && !o_sl_ptp_rx_aib_dsk_done;

        always @(posedge i_clk) begin
            if(!i_rx_rst_n) begin
                first_ptp_dsk_marker    <= 1'b0;
            end
            else begin
                first_ptp_dsk_marker    <= first_ptp_dsk_marker || ((i_sl_ptp_rx_ts == 21'h1FFFFF) && (ptp_rx_ts_r == 21'h0));
            end
        end

        always @(posedge i_clk) begin
            if(!i_rx_rst_n) begin
                pkt_data_in_r       <= {PKT_DATA_W{1'b0}};
                ptp_data_in_r       <= {PKT_DATA_W{1'b0}};
                pkt_dsk_marker_r    <= 1'b0;
                ptp_dsk_marker_r    <= 1'b0;
            end
            else begin
                pkt_data_in_r       <= pkt_data_in;
                ptp_data_in_r       <= ptp_data_in;
                pkt_dsk_marker_r    <= pkt_dsk_marker;
                ptp_dsk_marker_r    <= ptp_dsk_marker;
            end
        end

        alt_ehipc3_fm_rx_deskew #(
            .LANES          (2),
            .WIDTH          (PKT_DATA_W), // Per lane width
            .REGISTER_INPUT (0),
            .REGISTER_OUTPUT(1),
            .SIM_EMULATE    (0)
        ) rx_dsk_inst (
            .i_clk          (i_clk),
            .i_reset        (!i_rx_rst_n1),
            .i_sync_pulse   ({ptp_dsk_marker_r, pkt_dsk_marker_r}),
            .i_data         ({ptp_data_in_r,    pkt_data_in_r}),
            .o_data         ({ptp_data_dsk,     pkt_data_dsk}),
            .o_deskew_done  (o_sl_ptp_rx_aib_dsk_done)
        );

        always @(posedge i_clk) begin
            if(!i_rx_rst_n) begin
                ptp_data_out_r <= {PKT_DATA_W{1'b0}};
                ptp_data_out_rr <= {PKT_DATA_W{1'b0}};
                pkt_data_out_r <= {PKT_DATA_W{1'b0}};
                pkt_data_out_rr <= {PKT_DATA_W{1'b0}};
            end
            else begin
                pkt_data_out_r <= !i_enable_ptp                    ? pkt_data_in :                                            // No deskew if PTP not used
                              (pkt_data_select == SELECT_DSK)  ? pkt_data_dsk :                                           // Use deskew data at stable state
                              pkt_data_select_sop              ? pkt_data_dsk :                                           // Use deskew data after receive first packet with deskew done status
                              (pkt_data_select == SELECT_NONE) ? {1'b0,pkt_data_dsk[PKT_DATA_W-2],{(PKT_DATA_W-2){1'b0}}} : // No output after deskew is done and before next packet, valid still need to present to ensure down stream components could work correctly
                                                                 pkt_data_in;                                             // Default
                pkt_data_out_rr <= pkt_data_out_r;
                ptp_data_out_r <= ptp_data_dsk;
                ptp_data_out_rr <= ptp_data_out_r;
            end
        end
        assign pkt_data_out = pkt_data_out_rr;
        assign ptp_data_out = ptp_data_out_rr;
    end
    else begin
        assign pkt_data_out = pkt_data_in;
        assign ptp_data_out = ptp_data_in;

        assign rx_sop = 1'b0;
        assign o_sl_ptp_rx_aib_dsk_done = 1'b1;
    end

endmodule
