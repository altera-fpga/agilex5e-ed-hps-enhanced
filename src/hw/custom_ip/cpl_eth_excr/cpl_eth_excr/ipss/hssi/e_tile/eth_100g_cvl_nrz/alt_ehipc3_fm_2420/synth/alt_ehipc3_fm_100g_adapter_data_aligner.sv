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

module alt_ehipc3_fm_100g_adapter_data_aligner #(
    parameter WIDTH = 32
) (
    input   logic                       clk,
    input   logic   [0:7][WIDTH-1:0]    din,
    input   logic   [2:0]               index,
    output  logic   [0:7][WIDTH-1:0]    dout
);

    logic   [0:7][WIDTH-1:0]    temp;
    logic   [1:0]               index_2;

    always_ff @(posedge clk) begin
        index_2 <= index[2:1];
        case (index[0])
            1'd0 : temp <= din;
            1'd1 : temp <= {din[1:7], din[0]};
        endcase
    end

    always_ff @(posedge clk) begin
        case (index_2)
            2'd0 : dout <= temp;
            2'd1 : dout <= {temp[2:7], temp[0:1]};
            2'd2 : dout <= {temp[4:7], temp[0:3]};
            2'd3 : dout <= {temp[6:7], temp[0:5]};
        endcase
    end
endmodule
