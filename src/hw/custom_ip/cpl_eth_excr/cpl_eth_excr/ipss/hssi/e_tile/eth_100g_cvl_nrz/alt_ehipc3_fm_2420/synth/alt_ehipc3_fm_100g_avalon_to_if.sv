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

module alt_ehipc3_fm_100g_avalon_to_if (
    input   logic               i_reset,
    input   logic               i_clk,

    input   logic               i_valid,
    input   logic               i_sop,
    input   logic               i_eop,
    input   logic   [5:0]       i_empty,
    input   logic               i_error,
    input   logic               i_skip_crc,

    output  logic   [0:7]       o_inframe,
    output  logic   [0:7][2:0]  o_empty,
    output  logic   [0:7]       o_error,
    output  logic   [0:7]       o_skip_crc,
    output  logic        [3:0]  o_num_valid
);

    enum logic  {IDLE, INFRAME} state;

    logic   [2:0]   empty_blocks;

    assign empty_blocks = i_empty[5:3];

    always_ff @(posedge i_clk) begin
        o_error     <= {8{i_error}};
        o_empty     <= {8{i_empty[2:0]}};
        o_skip_crc  <= {8{i_skip_crc}};
    end

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            o_num_valid <= 4'd0;
        end else begin
            if (i_valid) begin
                if (state == IDLE) begin
                    o_num_valid <= 4'd8;
                end else begin
                    if (i_eop) begin
                        o_num_valid <= 4'd8 - empty_blocks;
                    end else begin
                        o_num_valid <= 4'd8;
                    end
                end
            end else begin
                o_num_valid <= 4'd0;
            end
        end
    end

    always_ff @(posedge i_clk) begin
        if (i_sop || (state == INFRAME)) begin
            if (i_eop) begin
                case (empty_blocks)
                    3'd0 : o_inframe <= 8'b11111110;
                    3'd1 : o_inframe <= 8'b11111100;
                    3'd2 : o_inframe <= 8'b11111000;
                    3'd3 : o_inframe <= 8'b11110000;
                    3'd4 : o_inframe <= 8'b11100000;
                    3'd5 : o_inframe <= 8'b11000000;
                    3'd6 : o_inframe <= 8'b10000000;
                    3'd7 : o_inframe <= 8'b00000000;
                endcase
            end else begin
                o_inframe <= 8'b11111111;
            end
        end else begin
            o_inframe <= 8'b00000000;
        end
    end

    always_ff @(posedge i_clk) begin
        state <= state;
        if (i_reset) begin
            state <= IDLE;
        end else begin
            if (i_valid) begin
                if (i_eop) begin
                    state <= IDLE;
                end else begin
                    if (i_sop) begin
                        state <= INFRAME;
                    end
                end
            end
        end
    end
endmodule
