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

module alt_ehipc3_fm_alias_csr (
    input   logic           reset,
    input   logic           clk,
    input   logic           write,
    input   logic   [3:0]   byte_en,
    input   logic   [15:0]  address,
    input   logic   [31:0]  write_data,
    output  logic           phy_clear_dsk_chng,
    output  logic           stats_snapshot_freeze_reg
);

    always_ff @(posedge clk) begin
        phy_clear_dsk_chng  <= 1'b0;
        if (reset) begin
            phy_clear_dsk_chng  <= 1'b0;
        end else begin
            if (write) begin
                if (address == 16'h324) begin
                    if (byte_en[0]) begin
                        phy_clear_dsk_chng  <= write_data[0];
                    end
                end
            end
        end
    end



    // hsd:2205696595 Adding stats_snapshot_freeze reg
    always_ff @(posedge clk) begin
        stats_snapshot_freeze_reg  <= 1'b0;
        if (reset) begin
            stats_snapshot_freeze_reg  <= 1'b0;
        end else begin
            if (write) begin
                if (address == 16'h945) begin // address 0x945 for RX stats counter
                    if (byte_en[0]) begin
                        stats_snapshot_freeze_reg <= write_data[2]; //bit 2:rx_shadow_req
                    end
                end
            end
        end
    end
endmodule
