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
// 9 bit val == const(1fd) equality comparator.  Latency 2.

module alt_ehipc3_fm_sl_eqc9h1fdt2 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input [8:0] din,
    output dout
);

wire [1:0] leaf;

alt_ehipc3_fm_sl_eqc5h1dt1 cmp0 (
    .clk(clk),
    .din(din[4:0]),
    .dout(leaf[0])
);
defparam cmp0 .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_eqc4hft1 cmp1 (
    .clk(clk),
    .din(din[8:5]),
    .dout(leaf[1])
);
defparam cmp1 .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_and2t1 c2 (
    .clk(clk),
    .din(leaf),
    .dout(dout)
);
defparam c2 .SIM_EMULATE = SIM_EMULATE;

endmodule
