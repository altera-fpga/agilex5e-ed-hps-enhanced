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
// Equality compare of two 8 bit words.  Latency 1.

module alt_ehipc3_fm_sl_eq8t1 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input [7:0] dina,
    input [7:0] dinb,
    output dout
);

wire [2:0] leaf;

alt_ehipc3_fm_sl_eq3t1 eq0 (
    .clk(clk),
    .dina(dina[2:0]),
    .dinb(dinb[2:0]),
    .dout(leaf[0])
);

defparam eq0 .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_eq3t1 eq1 (
    .clk(clk),
    .dina(dina[5:3]),
    .dinb(dinb[5:3]),
    .dout(leaf[1])
);

defparam eq1 .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_eq2t1 eq2 (
    .clk(clk),
    .dina(dina[7:6]),
    .dinb(dinb[7:6]),
    .dout(leaf[2])
);

defparam eq2 .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_and3t0 c3 (
    .din(leaf),
    .dout(dout)
);
defparam c3 .SIM_EMULATE = SIM_EMULATE;

endmodule
