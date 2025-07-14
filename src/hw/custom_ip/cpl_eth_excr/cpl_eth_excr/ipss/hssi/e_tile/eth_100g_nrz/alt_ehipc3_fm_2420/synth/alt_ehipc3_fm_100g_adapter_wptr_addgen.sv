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

module alt_ehipc3_fm_100g_adapter_wptr_addgen (
    input   logic               i_reset,
    input   logic               i_clk,
    input   logic               i_valid,
    output  logic   [0:1][4:0]  lane_ptrs,
    output  logic   [0:3][7:0]  mem_ptrs /* synthesis dont_retime */
);

    logic   [0:1][5:0]  phase;

    assign lane_ptrs[0] = phase[0][5:1];
    assign lane_ptrs[1] = phase[1][5:1];

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase[0]        <= 6'd1;
            phase[1]        <= 6'd0;
            mem_ptrs[0]    <= 8'd0;
            mem_ptrs[1]    <= 8'd1;
            mem_ptrs[2]    <= 8'd2;
            mem_ptrs[3]    <= 8'd3;
        end else begin
            if (i_valid) begin
                phase[0]        <= phase[0] + 1'b1;
                phase[1]        <= phase[1] + 1'b1;
                mem_ptrs[0]    <= mem_ptrs[0] + 8'd4;
                mem_ptrs[1]    <= mem_ptrs[1] + 8'd4;
                mem_ptrs[2]    <= mem_ptrs[2] + 8'd4;
                mem_ptrs[3]    <= mem_ptrs[3] + 8'd4;
            end else begin
                phase[0]        <= phase[0];
                phase[1]        <= phase[1];
                mem_ptrs[0]    <= mem_ptrs[0];
                mem_ptrs[1]    <= mem_ptrs[1];
                mem_ptrs[2]    <= mem_ptrs[2];
                mem_ptrs[3]    <= mem_ptrs[3];
            end
        end
    end
endmodule
