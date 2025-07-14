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

module alt_ehipc3_fm_100g_fifo_coupler #(
    parameter WIDTH = 8
) (
    input               clear,
    input               clk,

    input   [3:0]       i_numvalid,
    input   [WIDTH-1:0] i_data,
    input               i_valid,
    output              o_ready,

    output  [3:0]       o_numvalid,
    output  [WIDTH-1:0] o_data,
    input               i_ready
);

    reg [WIDTH-1:0] temp_data;
    reg [3:0]       temp_numvalid;

    reg             o_ready_reg;
    reg [3:0]       o_numvalid_reg;
    reg [WIDTH-1:0] o_data_reg;

    always @(posedge clk) o_ready_reg     <= clear ? 1'b1 : i_ready;

    always @(posedge clk) begin
        if (clear) begin
            o_numvalid_reg  <= 4'd0;
            o_data_reg      <= {WIDTH{1'b0}};
        end else begin
            if (i_ready) begin
                if (o_ready) begin
                    if (i_valid) begin
                        o_numvalid_reg  <= i_numvalid;
                        o_data_reg      <= i_data;
                    end else begin
                        o_numvalid_reg  <= 4'd0;
                        o_data_reg      <= {WIDTH{1'b0}};
                    end
                end else begin
                    o_numvalid_reg  <= temp_numvalid;
                    o_data_reg      <= temp_data;
                end
            end else begin
                o_numvalid_reg  <= o_numvalid_reg;
                o_data_reg      <= o_data_reg;
            end
        end
    end

    always @(posedge clk) begin
        if (clear) begin
            temp_data       <= {WIDTH{1'b0}};
            temp_numvalid   <= 4'd0;
        end else begin
            if (i_ready) begin
                temp_data       <= {WIDTH{1'b0}};
                temp_numvalid   <= 4'd0;
            end else begin
                if (o_ready) begin
                    if (i_valid) begin
                        temp_data       <= i_data;
                        temp_numvalid   <= i_numvalid;
                    end else begin
                        temp_data       <= {WIDTH{1'b0}};
                        temp_numvalid   <= 4'd0;
                    end
                end else begin
                    temp_data       <= temp_data;
                    temp_numvalid   <= temp_numvalid;
                end
            end
        end
    end

    assign o_ready      = o_ready_reg;
    assign o_numvalid   = o_numvalid_reg;
    assign o_data       = o_data_reg;
endmodule
