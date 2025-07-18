// (C) 2001-2021 Intel Corporation. All rights reserved.
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


module alt_e100s10_frame_buffer #(
    parameter DATA_WIDTH    = 8,
    parameter EMPTY_WIDTH   = 3,
    parameter SIM_EMULATE   = 0
) (
    input   logic                       i_clk,
    input   logic                       i_reset,

    input   logic                       i_sop,
    input   logic                       i_eop,
    input   logic                       i_valid,
    input   logic   [EMPTY_WIDTH-1:0]   i_empty,
    input   logic   [DATA_WIDTH-1:0]    i_data,

    output  logic                       o_sop,
    output  logic                       o_eop,
    output  logic                       o_valid,
    output  logic   [EMPTY_WIDTH-1:0]   o_empty,
    output  logic   [DATA_WIDTH-1:0]    o_data,
    input   logic                       i_ready
);

    localparam BUFFER_WIDTH = 1 + 1 + EMPTY_WIDTH + DATA_WIDTH;

    logic   [BUFFER_WIDTH-1:0]  buffer_din;
    logic   [BUFFER_WIDTH-1:0]  buffer_dout;

    assign buffer_din = {i_sop, i_eop, i_empty, i_data};
    assign {o_sop, o_eop, o_empty, o_data} = buffer_dout;

    alt_e100s10_data_block_buffer #(
        .WIDTH      (BUFFER_WIDTH),
        .SIM_EMULATE(SIM_EMULATE)
    ) buf0 (
        .i_reset    (i_reset),
        .i_clk      (i_clk),
        .i_eop      (i_eop),
        .i_valid    (i_valid),
        .i_data     (buffer_din),
        .o_data     (buffer_dout),
        .o_valid    (o_valid),
        .i_ready    (i_ready)
    );
endmodule
