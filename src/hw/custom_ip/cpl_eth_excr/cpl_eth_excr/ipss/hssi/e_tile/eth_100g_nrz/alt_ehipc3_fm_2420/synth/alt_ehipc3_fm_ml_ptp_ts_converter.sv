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
module alt_ehipc3_fm_ml_ptp_ts_converter #(
    parameter LANES    = 4
) (
    input  logic                    i_clk,
    input  logic                    i_tx_rst_n,
    input  logic                    i_rx_rst_n,

    input  logic                    i_cfg_remove_rx_pad,
    input  logic                    i_cfg_enforce_max_rx,
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
    input  logic                    i_rx_preamble_pass,
// ---------------------------------------------------------------------------------------------------------------------------------

    input  logic                    i_ptp_tx_ts_valid,
    input  logic            [47:0]  i_ptp_tx_ts,
    input  logic            [7:0]   i_ptp_tx_fp,

    input  logic                    i_rx_am,
    input  logic                    i_rx_valid,
    input  logic [LANES-1:0]        i_rx_inframe,
    input  logic            [83:0]  i_ptp_rx_ts,

    input  logic            [95:0]  i_tod,

    output logic                    o_ptp_ets_valid,
    output logic            [95:0]  o_ptp_ets,
    output logic            [7:0]   o_ptp_ets_fp,

    output logic            [95:0]  o_ptp_rx_its,
    output logic                    o_ptp_rx_its_valid
);

    localparam BILLION          = 32'd1000000000;
// ---------------------------------------------------------------------------------------------------------------------------------
// 10/Dec/2018 : slim35 : https://hsdes.intel.com/appstore/article/#/2205692107 : Crete 3 hard logic costs too much soft logic.
// Reduce alt_ehipc3_fm_sl_ptp_compute_ts pipeline from 12 to 4 and hence the param needs to be revised.
// ---------------------------------------------------------------------------------------------------------------------------------
//    localparam RX_TS_ADJ_DLY    = 12;
    localparam RX_TS_ADJ_DLY    = 4;
// ---------------------------------------------------------------------------------------------------------------------------------

    logic [47:0]                ets;
    logic [83:0]                its;
    logic [1:0]                 its_counter;

    logic [LANES-1:0]           rx_inframe_r;
    logic [LANES-1:0]           rx_inframe_rr;
    logic [LANES-1:0]           rx_sop;
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
    logic			rx_sof_at_ln3;
    logic			rx_sof;
// ---------------------------------------------------------------------------------------------------------------------------------

    logic                       tx_tod_rollover;
    logic                       tx_ets_rollover;
    logic                       rx_tod_rollover;
    logic                       rx_its_rollover;

    logic [95:0]                tod_r1;
    logic [47:0]                tod_95_48_r2;
    logic [48:0]                tod_95_48_plus_one_r2;
    logic [48:0]                tod_95_48_minus_one_r2;
    logic [11:0]                tod_95_84_r2;
    logic [12:0]                tod_95_84_plus_one_r2;
    logic [12:0]                tod_95_84_minus_one_r2;

    logic [95:0]                ptp_rx_its;
    logic                       ptp_rx_its_valid;
    logic [RX_TS_ADJ_DLY-1:0]   ptp_rx_its_valid_dly;

    logic                       correct_ts;
    logic                       correct_ts_r;
    logic [31:0]                rx_ts_adjust_value;

    always @(posedge i_clk) begin
        tod_r1  <= i_tod;
    end

    always @(posedge i_clk) begin
        if(!i_tx_rst_n) begin
            o_ptp_ets_valid <= 0;
        end
        else begin
            o_ptp_ets_valid <= i_ptp_tx_ts_valid;
        end
    end

    always @(posedge i_clk) begin
        ets             <= i_ptp_tx_ts;
        o_ptp_ets_fp    <= i_ptp_tx_fp;
    end
    // Assumption:
    //    1. There is no large load adjustment done to i_tod
    //    2. i_tod is smaller than ets
    // When ets upper ns field is all zero, while i_tod upper ns field equal to billion upper ns field, rollover happen
    always @(posedge i_clk) begin
        if(!i_tx_rst_n) begin
            tx_ets_rollover <= 1'b0;
        end
        else begin
            tx_ets_rollover <= (tod_r1[47:44] == BILLION[31:28]) && !(|i_ptp_tx_ts[47:44]);
        end
    end

    // Assumption:
    //    1. There is no large load adjustment done to i_tod
    //    2. i_tod is larger than ets (maybe happen on TX depend on latency of ETS from HIP to SIP)
    // When i_tod upper ns field is all zero, while ets upper ns field equal to billion upper ns field, rollover happen
    assign tx_tod_rollover = !(|tod_r1[47:44]) && (i_ptp_tx_ts[47:44] == BILLION[31:28]);

    always @(posedge i_clk) begin
        tod_95_48_r2            <= tod_r1[95:48];
        tod_95_48_plus_one_r2   <= tod_r1[95:48] + 1'b1;
        tod_95_48_minus_one_r2  <= tod_r1[95:48] - 1'b1;
    end

    assign o_ptp_ets = tx_ets_rollover? {tod_95_48_plus_one_r2[47:0],ets[47:0]}:
                       tx_tod_rollover? {tod_95_48_minus_one_r2[47:0],ets[47:0]}:
                                        {tod_95_48_r2[47:0],ets[47:0]};

    always @ (posedge i_clk) begin
        if(!i_rx_rst_n) begin
            rx_inframe_r    <= 0;
            rx_inframe_rr   <= 0;
            its             <= 0;
        end
        else begin
            if(i_rx_valid) begin
                rx_inframe_r    <= i_rx_inframe;
                rx_inframe_rr   <= rx_inframe_r;
                its             <= i_ptp_rx_ts;
            end
        end
    end

    // Assumption:
    //    1. There is no large load adjustment done to i_tod
    //    2. i_tod is larger than its
    // When i_tod[83:48] second field is all zero, while its[83:48] second field is all one, rollover happen
    always @ (posedge i_clk) begin
        if(!i_rx_rst_n) begin
            rx_tod_rollover <= 1'b0;
        end
        else begin
            rx_tod_rollover <= !(|tod_r1[83:48]) && (&i_ptp_rx_ts[83:48]);
        end
    end

    // Assumption:
    //    1. There is no large load adjustment done to i_tod
    //    2. i_tod is smaller than its (unlikely happen on RX)
    // When its[83:48] second field is all zero, while i_tod[83:48] second field is all one, rollover happen
    //assign rx_its_rollover = (&i_tod[83:48]) && !(|its[83:48]);
    assign rx_its_rollover = 1'b0;

    always @(posedge i_clk) begin
        tod_95_84_r2            <= tod_r1[95:84];
        tod_95_84_plus_one_r2   <= tod_r1[95:84] + 1'b1;
        tod_95_84_minus_one_r2  <= tod_r1[95:84] - 1'b1;
    end

    assign ptp_rx_its = rx_tod_rollover? {tod_95_84_minus_one_r2[11:0], its[83:0]}:
                        rx_its_rollover? {tod_95_84_plus_one_r2[11:0], its[83:0]}:
                                         {tod_95_84_r2[11:0], its[83:0]};

// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
// 480387 issue in EHIP will cause RX TS to be valid at SOF instead of SOP when PP=1.
// When SOP is at lane0, SOF is actually at lane3 in next clock if PP=1.
// So, its_valid equation should be changed to refer to SOF instead of SOP.
// ---------------------------------------------------------------------------------------------------------------------------------
//    assign ptp_rx_its_valid = |rx_sop && i_rx_valid;

// ---------------------------------------------------------------------------------------------------------------------------------
// If upper lane inframe goes low and the lane below inframe goes high then SOP is sitting at the lane below.
// For example when lane2 inframe is low and lane1 inframe is 1, then SOP is sitting at lane1.
// This is the reason the equation is ANDing the current lane with the NOT of upper lane.
// For lane3, the upper lane is the lane0 of previous clock.
// ---------------------------------------------------------------------------------------------------------------------------------
    assign rx_sop = rx_inframe_r & ~{rx_inframe_rr[0], rx_inframe_r[LANES-1:1]};

// SOF is at lane3 if lane0 is SOP (happened at the clock before).
    assign rx_sof_at_ln3    = rx_inframe_rr[0] & ~rx_inframe_rr[1];

// Select SOF based on SOP. SOF is at same clock as SOP clock if any lane from lane3 down to lane1 is SOP.
// SOF is at lane3 at the next clock if previously SOP is at lane0 when PP=1.
    assign rx_sof           = |rx_sop[(LANES-1):1] ? |rx_sop : (i_rx_preamble_pass ? rx_sof_at_ln3 : rx_sop[0]);

    assign ptp_rx_its_valid = rx_sof && i_rx_valid;
// ---------------------------------------------------------------------------------------------------------------------------------

    always @(posedge i_clk) begin
        if(!i_rx_rst_n) begin
            ptp_rx_its_valid_dly <= {RX_TS_ADJ_DLY{1'b0}};
        end
        else begin
            if(i_rx_valid) begin
                ptp_rx_its_valid_dly <= {ptp_rx_its_valid_dly[RX_TS_ADJ_DLY-2:0], ptp_rx_its_valid};
            end
        end
    end

    assign o_ptp_rx_its_valid = ptp_rx_its_valid_dly[RX_TS_ADJ_DLY-1];

    alt_ehipc3_fm_ptp_rx_ts_adj_detect rx_ts_adj_detect (
        .i_clk                  (i_clk),
        .i_rst_n                (i_rx_rst_n),
        .i_rx_valid             (i_rx_valid),
        .i_rx_am                (i_rx_am),
        .i_cfg_enforce_max_rx   (i_cfg_enforce_max_rx),
        .i_cfg_remove_rx_pad    (i_cfg_remove_rx_pad),
        .o_correct_ts           (correct_ts)
    );

    always @(posedge i_clk) begin
        if(!i_rx_rst_n) begin
            correct_ts_r <= 1'b0;
        end
        else begin
            if(i_rx_valid) begin
                correct_ts_r <= correct_ts;
            end
        end
    end

// ---------------------------------------------------------------------------------------------------------------------------------
// 10/Dec/2018 : slim35 : https://hsdes.intel.com/appstore/article/#/2205692107 : Crete 3 hard logic costs too much soft logic.
// Reduce alt_ehipc3_fm_sl_ptp_compute_ts pipeline from 12 to 4 and hence the param needs to be revised.
// In addition to pipeline reduction, the new code is using bit31 of correction_value as part of the value instead of signed bit previously.
// Therefore, the bit31 of input correction_value has to be tied to 1'b0 instead of 1'b1.
// The bit31 is previously tied to 1'b1 to always do a subtraction.
// ---------------------------------------------------------------------------------------------------------------------------------
//    assign rx_ts_adjust_value = correct_ts_r ? {1'b1, 31'hCCCCD} : 32'h0;
    assign rx_ts_adjust_value = correct_ts_r ? {1'b0, 31'hCCCCD} : 32'h0;
// ---------------------------------------------------------------------------------------------------------------------------------

    alt_ehipc3_fm_sl_ptp_compute_ts rx_ts_adj (
        .i_clk                  (i_clk),
        .i_rst_n                (i_rx_rst_n),
        .i_valid                (i_rx_valid),
        .i_correction_value     (rx_ts_adjust_value),
        .i_input_ts             (ptp_rx_its),
        .o_corrected_ts         (o_ptp_rx_its)
    );

endmodule
