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

module alt_ehipc3_fm_word_shifter #(
    parameter WIDTH = 8
) (
    input                   clk,
    input                   din_valid,
    input   [2*WIDTH-1:0]   din,
    input                   shift,
    output                  dout_valid,
    output  [2*WIDTH-1:0]   dout
);

    reg [WIDTH-1:0]     data_mem;
    reg [2*WIDTH-1:0]   dout_reg;
    reg                 dout_valid_reg;

    always @(posedge clk) data_mem <= din_valid ? din[WIDTH-1:0] : data_mem;
    always @(posedge clk) dout_valid_reg <= din_valid;

    always @(posedge clk) begin
        if (din_valid) begin
            if (shift) begin
                dout_reg[2*WIDTH-1:WIDTH]   <= data_mem;
                dout_reg[WIDTH-1:0]         <= din[2*WIDTH-1:WIDTH];
            end else begin
                dout_reg <= din;
            end
        end else begin
            dout_reg <= dout_reg;
        end
    end

    assign dout = dout_reg;
    assign dout_valid = dout_valid_reg;
endmodule
