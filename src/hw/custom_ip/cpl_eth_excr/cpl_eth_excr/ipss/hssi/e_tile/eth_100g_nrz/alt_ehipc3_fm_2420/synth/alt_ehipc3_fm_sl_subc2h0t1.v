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
// 2 bit val - const(0).  Latency 1.

module alt_ehipc3_fm_sl_subc2h0t1 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input [1:0] din,
    output [1:0] dout
);

alt_ehipc3_fm_sl_addc2h0t1 adc0 (
    .clk(clk),
    .din(din),
    .dout(dout)
);
defparam adc0 .SIM_EMULATE = SIM_EMULATE;

endmodule
