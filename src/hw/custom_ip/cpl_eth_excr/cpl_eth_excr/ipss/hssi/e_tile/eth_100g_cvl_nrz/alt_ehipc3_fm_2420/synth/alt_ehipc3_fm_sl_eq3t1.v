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
// Equality compare of two 3 bit words.  Latency 1.

module alt_ehipc3_fm_sl_eq3t1 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input [2:0] dina,
    input [2:0] dinb,
    output dout
);

wire dout_w;
alt_ehipc3_fm_sl_eq3t0 eq0 (
    .dina(dina),
    .dinb(dinb),
    .dout(dout_w)
);

defparam eq0 .SIM_EMULATE = SIM_EMULATE;

reg dout_r = 1'b0;
always @(posedge clk) dout_r <= dout_w;
assign dout = dout_r;

endmodule
