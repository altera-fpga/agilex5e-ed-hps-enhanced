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
// 4 bit val == const(f) equality comparator.  Latency 1.

module alt_ehipc3_fm_sl_eqc4hft1 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input [3:0] din,
    output dout
);

wire dout_w;

alt_ehipc3_fm_sl_lut6 t0 (.din(6'h0 | din),.dout(dout_w));
defparam t0 .MASK = 64'h0000000000008000;
defparam t0 .SIM_EMULATE = SIM_EMULATE;

reg dout_r0 = 1'b0;
always @(posedge clk) dout_r0 <= dout_w;

assign dout = dout_r0;
endmodule
