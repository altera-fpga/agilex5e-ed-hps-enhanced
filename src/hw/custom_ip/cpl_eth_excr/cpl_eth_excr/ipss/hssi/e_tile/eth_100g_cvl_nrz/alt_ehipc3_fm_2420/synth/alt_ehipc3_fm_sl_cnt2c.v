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
// 2 bit counter.

module alt_ehipc3_fm_sl_cnt2c #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input sclr,
    output [1:0] dout
);

wire [1:0] dout_w;

alt_ehipc3_fm_sl_lut6 t0 (
    .din({6'h0 | dout | ({6{sclr}} & 6'h20)}),
    .dout(dout_w[0])
);
defparam t0 .MASK = 64'h0000000055555555;
defparam t0 .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_lut6 t1 (
    .din({6'h0 | dout | ({6{sclr}} & 6'h20)}),
    .dout(dout_w[1])
);
defparam t1 .MASK = 64'h0000000066666666;
defparam t1 .SIM_EMULATE = SIM_EMULATE;

reg [1:0] dout_r = 2'b0 /* synthesis preserve dont_replicate */;
always @(posedge clk) dout_r <= dout_w;
assign dout = dout_r;

endmodule
