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

module alt_ehipc3_fm_100g_gb_4to8 #(
    parameter WIDTH = 32
) (
    input                   i_clk,
    input                   i_reset,
    input   [0:4*WIDTH-1]   i_data_0,
    input   [0:4*WIDTH-1]   i_data_1,
    input   [0:3]           i_inframe_0,
    input   [0:3]           i_inframe_1,
    input                   i_valid_0,
    input                   i_valid_1,  // if i_valid_0 == 1, then i_valid_1 = 1
    output  [0:8*WIDTH-1]   o_data,
    output  [0:7]           o_inframe,
    output                  o_valid
);

    reg                 i_reset_r1;
    reg   [0:4*WIDTH-1] i_data_0_r1;
    reg   [0:4*WIDTH-1] i_data_1_r1;
    reg   [0:3]         i_inframe_0_r1;
    reg   [0:3]         i_inframe_1_r1;
    reg                 i_valid_0_r1;
    reg                 i_valid_1_r1;

    reg [0:8*WIDTH-1]   o_data_reg;
    reg [0:7]           o_inframe_reg;
    reg                 o_valid_reg;

    reg [0:4*WIDTH-1]   temp_data;      // Must be start of frame
    reg [0:3]           temp_inframe;
    reg                 stored;
    reg                 empty_stored;

    reg                 eop_in_block_1;

    always @(posedge i_clk) begin
        i_reset_r1          <= i_reset;
        i_data_0_r1         <= i_data_0;
        i_data_1_r1         <= i_data_1;
        i_inframe_0_r1      <= i_inframe_0;
        i_inframe_1_r1      <= i_inframe_1;
        i_valid_0_r1        <= i_valid_0;
        i_valid_1_r1        <= i_valid_1;
        eop_in_block_1      <= ~&i_inframe_1;
    end

    always @(posedge i_clk) begin
        if (i_reset_r1) begin
            o_inframe_reg   <= 8'b0;
            o_valid_reg     <= 1'b0;
            temp_inframe    <= 4'b0;
            stored          <= 1'b0;
            empty_stored    <= 1'b0;
        end else begin
            if (i_valid_0_r1) begin    // both valid
                if (stored) begin
                    o_inframe_reg   <= {temp_inframe, i_inframe_0_r1};
                    o_valid_reg     <= 1'b1;
                    temp_inframe    <= i_inframe_1_r1;
                    stored          <= 1'b1;
                    empty_stored    <= eop_in_block_1;
                end else begin
                    o_inframe_reg   <= {i_inframe_0_r1, 4'b0000};
                    o_valid_reg     <= 1'b1;
                    temp_inframe    <= i_inframe_1_r1;
                    stored          <= 1'b1;
                    empty_stored    <= eop_in_block_1;
                end
            end else begin
                if (i_valid_1_r1) begin    // block 1 valid only
                    if (stored) begin
                        if (empty_stored) begin
                            o_inframe_reg   <= {temp_inframe, 4'b0000};
                            o_valid_reg     <= 1'b1;
                            temp_inframe    <= i_inframe_1_r1;
                            stored          <= 1'b1;
                            empty_stored    <= eop_in_block_1;
                        end else begin
                            o_inframe_reg   <= {temp_inframe, i_inframe_1_r1};
                            o_valid_reg     <= 1'b1;
                            temp_inframe    <= 4'b0;
                            stored          <= 1'b0;
                            empty_stored    <= eop_in_block_1;
                        end
                    end else begin
                        if (eop_in_block_1) begin
                            o_inframe_reg   <= {i_inframe_1_r1, 4'b0000};
                            o_valid_reg     <= 1'b1;
                            temp_inframe    <= 4'b0;
                            stored          <= 1'b0;
                            empty_stored    <= eop_in_block_1;
                        end else begin
                            o_inframe_reg   <= 8'b0;
                            o_valid_reg     <= 1'b0;
                            temp_inframe    <= i_inframe_1_r1;
                            stored          <= 1'b1;
                            empty_stored    <= eop_in_block_1;
                        end
                    end
                end else begin  // no valid blocks
                    o_inframe_reg   <= 8'b0;
                    o_valid_reg     <= 1'b0;
                    temp_inframe    <= temp_inframe;
                    stored          <= stored;
                    empty_stored    <= empty_stored;
                end
            end
        end
    end

    always @(posedge i_clk) begin
        if (stored) begin
            o_data_reg[0:4*WIDTH-1] <= temp_data;
        end else begin
            if (i_valid_0_r1) begin    // both valid
                o_data_reg[0:4*WIDTH-1] <= i_data_0_r1;
            end else begin
                o_data_reg[0:4*WIDTH-1]      <= i_data_1_r1;
            end
        end
    end

    always @(posedge i_clk) begin
        if (i_valid_0_r1) begin    // both valid
            o_data_reg[4*WIDTH:8*WIDTH-1]      <= i_data_0_r1;
        end else begin
            o_data_reg[4*WIDTH:8*WIDTH-1]      <= i_data_1_r1;
        end
    end

    always @(posedge i_clk) begin
        if (i_valid_0_r1 || i_valid_1_r1) begin    // both valid
            temp_data       <= i_data_1_r1;
        end else begin
            temp_data       <= temp_data;
        end
    end

    assign o_data      = o_data_reg;
    assign o_inframe   = o_inframe_reg;
    assign o_valid     = o_valid_reg;
endmodule
