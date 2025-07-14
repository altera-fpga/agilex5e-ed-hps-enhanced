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


// Clock Monitors
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module alt_ehipc3_fm_clock_mon
  #(
    parameter SIM_EMULATE = 1'b0,
    parameter SIM_HURRY = 1'b0
    )

   (
    input wire 	      csr_clk,
    input wire 	      cdr_ref_clk,
    input wire 	      tx_clk64,
    input wire 	      tx_clk66,
    input wire 	      rx_clk64,
    input wire 	      rx_clk66,

    output reg [15:0] khz_ref_phy,
    output reg [15:0] khz_rx_clk64,
    output reg [15:0] khz_tx_clk64,
    output reg [15:0] khz_rx_clk66,
    output reg [15:0] khz_tx_clk66

    );


//                                  100       011          000      010             001
//wire [7:0] mon_clocks = {{3'b000}, rx_clk66, tx_clk66, rx_clk64, tx_clk64, cdr_ref_clk};
wire [7:0] mon_clocks = {{3'b000}, rx_clk66, tx_clk66, rx_clk64, tx_clk64, 1'b0};
reg [2:0] mon_clock_sel = 3'b000;
wire mon_clock_rate_fresh;
wire [15:0] mon_clock_rate;
alt_ehipc3_fm_fmon8 fm0 (
    .clk        (csr_clk),
    .din        (mon_clocks),
    .din_sel    (mon_clock_sel),
    .dout       (mon_clock_rate),
    .dout_fresh (mon_clock_rate_fresh)
);
defparam fm0 .SIM_EMULATE = SIM_EMULATE;
defparam fm0 .SIM_HURRY = SIM_HURRY;

always @(posedge csr_clk) begin
    if (mon_clock_rate_fresh) begin
        if (mon_clock_sel == 3'b100)
            mon_clock_sel   <=  3'b000;
        else
            mon_clock_sel   <=  mon_clock_sel + 1'b1;
    end
end

reg [15:0]  khz_tx_io_phy_i = 0;

always @(posedge csr_clk) begin
    if (mon_clock_rate_fresh) begin
        case (mon_clock_sel)
            3'b000:  khz_rx_clk66        <=  mon_clock_rate;
            3'b001:  khz_ref_phy         <=  mon_clock_rate;
            3'b010:  khz_tx_clk64        <=  mon_clock_rate;
            3'b011:  khz_rx_clk64        <=  mon_clock_rate;
            3'b100:  khz_tx_clk66        <=  mon_clock_rate;
            default: khz_tx_io_phy_i     <=  mon_clock_rate;
        endcase
    end
end

endmodule // alt_ehipc3_fm_clock_mon
