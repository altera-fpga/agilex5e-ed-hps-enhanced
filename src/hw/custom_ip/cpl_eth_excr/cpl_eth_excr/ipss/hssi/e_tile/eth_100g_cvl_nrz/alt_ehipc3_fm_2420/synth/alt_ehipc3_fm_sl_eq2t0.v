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
// Equality compare of two 2 bit words.  Latency 0.

module alt_ehipc3_fm_sl_eq2t0 #(
    parameter SIM_EMULATE = 1'b0
) (
    input [1:0] dina,
    input [1:0] dinb,
    output dout
);

alt_ehipc3_fm_sl_lut6 t0 (.din({1'b0,dina[1:0],1'b0,dinb[1:0]}),.dout(dout));
defparam t0 .SIM_EMULATE = SIM_EMULATE;
defparam t0 .MASK = 64'h8040201008040201; // {a,b,c} == {d,e,f};

endmodule
