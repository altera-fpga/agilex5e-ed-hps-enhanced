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
// MLAB with 64 bit words.  2 addr lines.

module alt_ehipc3_fm_sl_mlab64a2r1w1 #(
    parameter SIM_EMULATE = 1'b0
) (
    input wclk,
    input [1:0] waddr,
    input [63:0] din,
    input rclk,
    input [1:0] raddr,
    output [63:0] dout
);

////////////////////////////
// handle data bits 19..0

reg [1:0] waddr_m0 = 2'b0 /* synthesis syn_only_preserve */;
always @(posedge wclk) waddr_m0 <= waddr;

reg [19:0] wdata_m0 = 20'b0 /* synthesis syn_only_preserve */;
always @(posedge wclk) wdata_m0 <= din[19:0];

reg [1:0] raddr_m0 = 2'b0 /* synthesis syn_only_preserve */;
always @(posedge rclk) raddr_m0 <= raddr;

alt_ehipc3_fm_sl_mlab m0 (
	.wclk(wclk),
	.wena(1'b1),
	.waddr_reg(waddr_m0),
	.wdata_reg(wdata_m0),
	.raddr(raddr_m0),
	.rdata(dout[19:0])
);
defparam m0 .WIDTH = 20;
defparam m0 .ADDR_WIDTH = 2;
defparam m0 .SIM_EMULATE = SIM_EMULATE;

////////////////////////////
// handle data bits 39..20

reg [1:0] waddr_m1 = 2'b0 /* synthesis syn_only_preserve */;
always @(posedge wclk) waddr_m1 <= waddr;

reg [19:0] wdata_m1 = 20'b0 /* synthesis syn_only_preserve */;
always @(posedge wclk) wdata_m1 <= din[39:20];

reg [1:0] raddr_m1 = 2'b0 /* synthesis syn_only_preserve */;
always @(posedge rclk) raddr_m1 <= raddr;

alt_ehipc3_fm_sl_mlab m1 (
	.wclk(wclk),
	.wena(1'b1),
	.waddr_reg(waddr_m1),
	.wdata_reg(wdata_m1),
	.raddr(raddr_m1),
	.rdata(dout[39:20])
);
defparam m1 .WIDTH = 20;
defparam m1 .ADDR_WIDTH = 2;
defparam m1 .SIM_EMULATE = SIM_EMULATE;

////////////////////////////
// handle data bits 59..40

reg [1:0] waddr_m2 = 2'b0 /* synthesis syn_only_preserve */;
always @(posedge wclk) waddr_m2 <= waddr;

reg [19:0] wdata_m2 = 20'b0 /* synthesis syn_only_preserve */;
always @(posedge wclk) wdata_m2 <= din[59:40];

reg [1:0] raddr_m2 = 2'b0 /* synthesis syn_only_preserve */;
always @(posedge rclk) raddr_m2 <= raddr;

alt_ehipc3_fm_sl_mlab m2 (
	.wclk(wclk),
	.wena(1'b1),
	.waddr_reg(waddr_m2),
	.wdata_reg(wdata_m2),
	.raddr(raddr_m2),
	.rdata(dout[59:40])
);
defparam m2 .WIDTH = 20;
defparam m2 .ADDR_WIDTH = 2;
defparam m2 .SIM_EMULATE = SIM_EMULATE;

////////////////////////////
// handle data bits 63..60

reg [1:0] waddr_m3 = 2'b0 /* synthesis syn_only_preserve */;
always @(posedge wclk) waddr_m3 <= waddr;

reg [3:0] wdata_m3 = 4'b0 /* synthesis syn_only_preserve */;
always @(posedge wclk) wdata_m3 <= din[63:60];

reg [1:0] raddr_m3 = 2'b0 /* synthesis syn_only_preserve */;
always @(posedge rclk) raddr_m3 <= raddr;

alt_ehipc3_fm_sl_mlab m3 (
	.wclk(wclk),
	.wena(1'b1),
	.waddr_reg(waddr_m3),
	.wdata_reg(wdata_m3),
	.raddr(raddr_m3),
	.rdata(dout[63:60])
);
defparam m3 .WIDTH = 4;
defparam m3 .ADDR_WIDTH = 2;
defparam m3 .SIM_EMULATE = SIM_EMULATE;

endmodule
