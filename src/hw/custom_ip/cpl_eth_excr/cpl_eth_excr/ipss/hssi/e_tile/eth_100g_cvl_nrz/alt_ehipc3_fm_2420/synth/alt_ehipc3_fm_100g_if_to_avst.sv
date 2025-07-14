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

module alt_ehipc3_fm_100g_if_to_avst #(
    parameter MASK_VALID = 1
) (
    input  logic                i_clk,
    input  logic                i_reset,
    input  logic  [0:7]         i_inframe,
    input  logic                i_valid,
    input  logic  [0:7][2:0]    i_status,
    input  logic  [0:7]         i_fcs_error,
    input  logic  [0:7][2:0]    i_empty,
    input  logic  [0:7][1:0]    i_error,

    output logic  [5:0]         o_empty,
    output logic                o_sop,
    output logic                o_eop,
    output logic                o_valid,
    output logic  [5:0]         o_error,
    output logic  [39:0]        o_status_data,
    output logic                o_status_valid
);

    logic   [2:0]           selected_empty;
    logic   [1:0]           selected_error;
    logic                   selected_fcs_error;
    logic   [2:0]           selected_status;

    logic                   malformed_frame;
    logic                   crc_error;
    logic                   length_error;
    logic                   stacked_vlan;
    logic                   vlan;
    logic                   control;
    logic                   pause;
    logic                   pfc;

    logic inframe_last;
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            inframe_last    <= 1'b0;
        end else begin
            if (i_valid) begin
                inframe_last    <= &i_inframe;
            end else begin
                inframe_last    <= inframe_last;
            end
        end
    end

    always_ff @(posedge i_clk) begin
        malformed_frame <= (selected_error == 2'd1);
        crc_error       <= selected_fcs_error;
        length_error    <= (selected_error == 2'd3);
        stacked_vlan    <= (selected_status == 3'd5);
        vlan            <= (selected_status == 3'd4);
        control         <= (selected_status == 3'd2) || (selected_status == 3'd3) || (selected_status == 3'd7);
        pause           <= (selected_status == 3'd2);
        pfc             <= (selected_status == 3'd3);
    end

    generate
        if (MASK_VALID) begin
            always_ff @(posedge i_clk) begin
                if (i_reset) begin
                    o_valid <= 1'b0;
                end else begin
                    if (i_valid) begin
                        o_valid <= inframe_last || i_inframe[0];
                    end else begin
                        o_valid <= 1'b0;
                    end
                end
            end
        end else begin
            always_ff @(posedge i_clk) begin
                o_valid <= i_valid;
            end
        end
    endgenerate

    always_ff @(posedge i_clk) begin
        if (i_valid) begin
            if ({inframe_last, i_inframe[0]} == 2'b01) begin
                o_sop   <= 1'b1;
            end else begin
                o_sop   <= 1'b0;
            end
        end else begin
            o_sop   <= o_sop;
        end
    end

    always_ff @(posedge i_clk) begin
        o_eop <= 1'b0;
        if (i_valid) begin
            case ({inframe_last, i_inframe}) inside
                9'b10???????    : o_eop <= 1'b1;
                9'b?10??????    : o_eop <= 1'b1;
                9'b?110?????    : o_eop <= 1'b1;
                9'b?1110????    : o_eop <= 1'b1;
                9'b?11110???    : o_eop <= 1'b1;
                9'b?111110??    : o_eop <= 1'b1;
                9'b?1111110?    : o_eop <= 1'b1;
                9'b?11111110    : o_eop <= 1'b1;
            endcase
        end
    end

    always_ff @(posedge i_clk) begin
        o_status_valid  <= 1'b0;
        if (i_valid) begin
            case ({inframe_last, i_inframe}) inside
                9'b10???????    : o_status_valid <= 1'b1;
                9'b?10??????    : o_status_valid <= 1'b1;
                9'b?110?????    : o_status_valid <= 1'b1;
                9'b?1110????    : o_status_valid <= 1'b1;
                9'b?11110???    : o_status_valid <= 1'b1;
                9'b?111110??    : o_status_valid <= 1'b1;
                9'b?1111110?    : o_status_valid <= 1'b1;
                9'b?11111110    : o_status_valid <= 1'b1;
            endcase
        end
    end

    always_comb begin
        case (i_inframe) inside
            8'b0??????? : begin
                selected_empty      = i_empty[0];
                selected_error      = i_error[0];
                selected_fcs_error  = i_fcs_error[0];
                selected_status     = i_status[0];
            end
            8'b10?????? : begin
                selected_empty      = i_empty[1];
                selected_error      = i_error[1];
                selected_fcs_error  = i_fcs_error[1];
                selected_status     = i_status[1];
            end
            8'b110????? : begin
                selected_empty      = i_empty[2];
                selected_error      = i_error[2];
                selected_fcs_error  = i_fcs_error[2];
                selected_status     = i_status[2];
            end
            8'b1110???? : begin
                selected_empty      = i_empty[3];
                selected_error      = i_error[3];
                selected_fcs_error  = i_fcs_error[3];
                selected_status     = i_status[3];
            end
            8'b11110??? : begin
                selected_empty      = i_empty[4];
                selected_error      = i_error[4];
                selected_fcs_error  = i_fcs_error[4];
                selected_status     = i_status[4];
            end
            8'b111110?? : begin
                selected_empty      = i_empty[5];
                selected_error      = i_error[5];
                selected_fcs_error  = i_fcs_error[5];
                selected_status     = i_status[5];
            end
            8'b1111110? : begin
                selected_empty      = i_empty[6];
                selected_error      = i_error[6];
                selected_fcs_error  = i_fcs_error[6];
                selected_status     = i_status[6];
            end
            8'b11111110 : begin
                selected_empty      = i_empty[7];
                selected_error      = i_error[7];
                selected_fcs_error  = i_fcs_error[7];
                selected_status     = i_status[7];
            end
            default     : begin
                selected_empty      = 3'd0;
                selected_error      = 2'b00;
                selected_fcs_error  = 1'b0;
                selected_status     = 3'd0;
            end
        endcase
    end

    always_ff @(posedge i_clk) begin
        o_empty [2:0]   <= selected_empty;
        case (i_inframe) inside
            8'b0??????? : o_empty[5:3]    <= 3'd7;
            8'b10?????? : o_empty[5:3]    <= 3'd6;
            8'b110????? : o_empty[5:3]    <= 3'd5;
            8'b1110???? : o_empty[5:3]    <= 3'd4;
            8'b11110??? : o_empty[5:3]    <= 3'd3;
            8'b111110?? : o_empty[5:3]    <= 3'd2;
            8'b1111110? : o_empty[5:3]    <= 3'd1;
            8'b11111110 : o_empty[5:3]    <= 3'd0;
            default     : o_empty[5:3]    <= 3'd0;
        endcase
    end

    assign o_error[0]   = malformed_frame;
    assign o_error[1]   = crc_error;
    assign o_error[2]   = 1'b0;            // reserved
    assign o_error[3]   = 1'b0;            // reserved
    assign o_error[4]   = length_error;
    assign o_error[5]   = 1'b0;            // reserved

    assign o_status_data[31:0]   = 32'd0;        // reserved
    assign o_status_data[32]     = stacked_vlan;
    assign o_status_data[33]     = vlan;
    assign o_status_data[34]     = control;
    assign o_status_data[35]     = pause;
    assign o_status_data[38:36]  = 3'd0;         // reserved
    assign o_status_data[39]     = pfc;
endmodule
