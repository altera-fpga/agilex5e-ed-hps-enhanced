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

module alt_ehipc3_fm_preamble_filter2 (
    input   logic           i_clk,
    input   logic           i_reset,
    input   logic           i_valid,
    input   logic   [0:1]   i_inframe,
    output  logic           o_valid,
    output  logic   [0:1]   o_inframe
);

    logic if_last;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            if_last <= 1'b0;
        end else begin
            if_last <= i_valid ? i_inframe[1] : if_last;
        end
    end

    always_ff @(posedge i_clk) begin
        o_valid         <= i_valid;
        o_inframe[0]    <= if_last      & i_inframe[0];
        o_inframe[1]    <= i_inframe[0] & i_inframe[1];
    end
endmodule
