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

module alt_ehipc3_fm_word_aligner #(
    parameter WIDTH = 8
) (
    input                   i_clk,
    input                   i_reset,
    input                   i_valid,
    input   [2*WIDTH-1:0]   i_data,
    input   [1:0]           i_inframe,
    output                  o_valid,
    output  [2*WIDTH-1:0]   o_data,
    output  [1:0]           o_inframe
);

    reg                 i_valid_last;
    reg [2*WIDTH-1:0]   i_data_last;
    reg [1:0]           inframe_last;
    reg                 shift;

    always @(posedge i_clk) begin
        if (i_reset) begin
            shift <= 1'b0;
        end else begin
            if (i_valid) begin
                shift <= shift;
                casez ({inframe_last[0], i_inframe})
                    3'b?01 : shift <= 1'b1; // un-aligned start
                    3'b01? : shift <= 1'b0; // aligned start
                endcase
            end else begin
                shift <= shift;
            end
        end
    end

    always @(posedge i_clk) begin
        i_valid_last <= i_valid;
        i_data_last  <= i_data;
        inframe_last <= i_inframe;
    end

    alt_ehipc3_fm_word_shifter #(
        .WIDTH  (WIDTH+1)
    ) w0 (
        .clk        (i_clk),
        .din_valid  (i_valid_last),
        .din        ({inframe_last[1], i_data_last[2*WIDTH-1:WIDTH], inframe_last[0], i_data_last[WIDTH-1:0]}),
        .shift      (shift),
        .dout_valid (o_valid),
        .dout       ({o_inframe[1], o_data[2*WIDTH-1:WIDTH], o_inframe[0], o_data[WIDTH-1:0]})
    );
endmodule
