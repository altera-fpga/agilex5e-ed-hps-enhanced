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


// Copyright 2010-2019 Altera Corporation. All rights reserved.
// Altera products are protected under numerous U.S. and foreign patents,
// maskwork rights, copyrights and other intellectual property laws.
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design
// License Agreement (either as signed by you or found at www.altera.com).  By
// using this reference design file, you indicate your acceptance of such terms
// and conditions between you and Altera Corporation.  In the event that you do
// not agree with such terms and conditions, you may not use the reference
// design file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an "as-is" basis and as an
// accommodation and therefore all warranties, representations or guarantees of
// any kind (whether express, implied or statutory) including, without
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or
// require that this reference design file be used in combination with any
// other product not provided by Altera.
/////////////////////////////////////////////////////////////////////////////

`timescale 1ps/1ps

// Generated by one of Gregg's toys.   Share And Enjoy.
// Executable compiled May 18 2018 10:06:40
// This file was generated 08/16/2019 14:20:21

module intc_mlab6_a1r1w1_fm #(
    parameter SIM_EMULATE = 1'b0
) (
    input wclk,
    input [0:0] waddr,
    input [5:0] din,
    input rclk,
    input [0:0] raddr,
    output [5:0] dout
);

wire [5:0] dout_i;

////////////////////////////////////////
// handle data bits 5..0

reg [0:0] waddr_m0 = 1'b0 /* synthesis preserve_syn_only */;
always @(posedge wclk) waddr_m0 <= waddr;

reg [5:0] wdata_m0 = 6'b0 /* synthesis preserve_syn_only */;
always @(posedge wclk) wdata_m0 <= din[5:0];

reg [0:0] raddr_m0 = 1'b0 /* synthesis preserve_syn_only */;
always @(posedge rclk) raddr_m0 <= raddr;

intc_mlab_fm m0 (
	.wclk(wclk),
	.wena(1'b1),
	.waddr_reg(waddr_m0),
	.wdata_reg(wdata_m0),
	.raddr(raddr_m0),
	.rdata(dout_i[5:0])
);
defparam m0 .WIDTH = 6;
defparam m0 .ADDR_WIDTH = 1;
defparam m0 .SIM_EMULATE = SIM_EMULATE;

////////////////////////////////////////
// handle output connection

assign dout = dout_i;

endmodule
