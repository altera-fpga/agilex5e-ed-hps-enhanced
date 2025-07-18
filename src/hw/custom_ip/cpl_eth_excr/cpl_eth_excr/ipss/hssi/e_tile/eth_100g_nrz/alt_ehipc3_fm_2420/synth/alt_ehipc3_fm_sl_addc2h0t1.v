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
// 2 bit val + const(0) adder.  Latency 1.

module alt_ehipc3_fm_sl_addc2h0t1 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input [1:0] din,
    output [1:0] dout
);

//////////////////////////////////////////
// 2 zeros fall through on the bottom
wire [1:0] doutz;
reg [1:0] doutz_r0 = 2'b0;
always @(posedge clk) doutz_r0 <= din[1:0];

assign dout[1:0] = doutz_r0;

//////////////////////////////////////////
// 0 bits remain
endmodule
