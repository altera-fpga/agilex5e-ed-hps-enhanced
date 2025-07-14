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

module alt_ehipc3_fm_data_sync #(
    parameter WIDTH = 32
) (
    input   logic               aclr,

    input   logic               clk_in,
    input   logic   [WIDTH-1:0] data_in,
    input   logic               clk_out,
    output  logic   [WIDTH-1:0] data_out
);

    logic   reset_in;
    logic   valid;
    logic   valid_last;
    logic   valid_sync;

    logic   ack;
    logic   ack_last;
    logic   ack_sync;

    logic   [WIDTH-1:0] din_reg;

    always_ff @(posedge clk_in) begin
        valid_last  <= valid;
        if (reset_in) begin
            valid   <= 1'b0;
        end else begin
            valid   <= ~ack_sync;
        end

        if (valid && !valid_last) begin
            din_reg <= data_in;
        end else begin
            din_reg <= din_reg;
        end
    end

    always_ff @(posedge clk_out) begin
        ack         <= valid_sync;
        ack_last    <= ack;

        if (ack && !ack_last) begin
            data_out <= din_reg;
        end
    end

    alt_ehipc3_fm_reset_synchronizer rst_sync_0 (
        .aclr       (aclr),
        .clk        (clk_in),
        .aclr_sync  (reset_in)
    );

    alt_ehipc3_fm_altera_std_synchronizer_nocut valid_sync_0 (
        .clk     (clk_out),
        .reset_n (1'b1),
        .din     (valid),
        .dout    (valid_sync)
    );

    alt_ehipc3_fm_altera_std_synchronizer_nocut ack_sync_0 (
        .clk     (clk_in),
        .reset_n (1'b1),
        .din     (ack),
        .dout    (ack_sync)
    );
endmodule
