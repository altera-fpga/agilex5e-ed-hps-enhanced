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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module alt_ehipc3_fm_100g_adapter_rptr_addgen (
    input   logic               clk,
    input   logic   [7:0]       i_ptr,
    output  logic   [0:7][4:0]  o_ptr
);

    genvar i;
    generate
    for (i = 0; i < 8; i++) begin : lane_loop
            always_ff @(posedge clk) o_ptr[i]   <= (i_ptr[2:0] <= i[2:0]) ? i_ptr[7:3] : i_ptr[7:3] + 1'b1;
        end
    endgenerate
endmodule
