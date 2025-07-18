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
// Equality compare of two 4 bit words.  Latency 1.

module alt_ehipc3_fm_sl_eq4t1 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input [3:0] dina,
    input [3:0] dinb,
    output dout,
    output dout_l,
    output dout_h
);

wire [1:0] leaf;

alt_ehipc3_fm_sl_eq2t1 eq0 (
    .clk(clk),
    .dina(dina[1:0]),
    .dinb(dinb[1:0]),
    .dout(leaf[0])
);

defparam eq0 .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_eq2t1 eq1 (
    .clk(clk),
    .dina(dina[3:2]),
    .dinb(dinb[3:2]),
    .dout(leaf[1])
);

defparam eq1 .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_and2t0 c2 (
    .din(leaf),
    .dout(dout)
);
defparam c2 .SIM_EMULATE = SIM_EMULATE;

assign dout_l = leaf[0];
assign dout_h = leaf[1];

endmodule
