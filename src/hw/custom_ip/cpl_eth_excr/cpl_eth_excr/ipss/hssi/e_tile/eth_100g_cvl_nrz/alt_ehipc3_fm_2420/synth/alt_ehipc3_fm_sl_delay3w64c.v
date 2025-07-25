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




`timescale 1ps/1ps

// DESCRIPTION
// Delay 64 bit words by 3 cycles.

module alt_ehipc3_fm_sl_delay3w64c #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input sclr,
    input [63:0] din,
    output [63:0] dout
);

wire [1:0] wptr;
alt_ehipc3_fm_sl_cnt2c ct0 (
    .clk(clk),
    .sclr(sclr),
    .dout(wptr)
);
defparam ct0 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] rptr;
alt_ehipc3_fm_sl_subc2h0t1 sc0 (
    .clk(clk),
    .din(wptr),
    .dout(rptr)
);
defparam sc0 .SIM_EMULATE = SIM_EMULATE;

wire [63:0] dout_w;
alt_ehipc3_fm_sl_mlab64a2r1w1 m0 (
    .rclk(clk),
    .wclk(clk),
    .waddr(wptr),
    .din(din),
    .raddr(rptr),
    .dout(dout_w)
);
defparam m0 .SIM_EMULATE = SIM_EMULATE;


reg [63:0] dout_r = 64'b0;
always @(posedge clk) dout_r <= dout_w;
assign dout = dout_r;
endmodule
