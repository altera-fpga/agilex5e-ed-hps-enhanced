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


`timescale 1ns/1ns
module alt_ehipc3_fm_100g_gearbox #(
    parameter WIDTH = 64
) (
    input                   i_reset,
    input                   i_clk,

    input   [0:8*WIDTH-1]   i_data,
    input   [0:7]           i_inframe,
    input   [3:0]           i_numvalid,
    output                  o_ready,

    output  [0:4*WIDTH-1]   o_data,
    output  [0:3]           o_inframe,
    output                  o_valid,
    input                   i_ready
);

    localparam TEMP_WORDS   = 14;

    reg [0:TEMP_WORDS*WIDTH-1]  temp_data;
    reg [0:TEMP_WORDS-1]        temp_inframe;
    reg [3:0]           num_stored;

    reg [4*WIDTH-1:0]   o_data_reg;
    reg [0:3]           o_inframe_reg;
    reg                 o_valid_reg;
    reg                 o_ready_reg;

    reg                 i_ready_r1;

    always @(posedge i_clk) begin
        i_ready_r1  <= i_ready;
        o_valid_reg <= i_ready_r1; // Fixed relationship
    end

    always @(posedge i_clk) begin
        if (i_reset) begin
            num_stored      <= 4'd0;
        end else begin
            if (o_ready) begin
                if (i_ready_r1) begin
                    num_stored <= (num_stored + i_numvalid > 4'd4) ? num_stored + i_numvalid - 4'd4 : 4'd0;
                end else begin
                    num_stored <= num_stored + i_numvalid;
                end
            end else begin
                if (i_ready_r1) begin
                    num_stored <= num_stored - 4'd4;
                end else begin
                    num_stored <= num_stored;
                end
            end
        end
    end

    always @(posedge i_clk) begin
        temp_data       <= {14*WIDTH{1'b0}};
        if (o_ready) begin
            if (i_ready_r1) begin
                case (num_stored)
                    4'd0 : temp_data       <= {i_data[4*WIDTH:8*WIDTH-1], {10*WIDTH{1'b0}}};
                    4'd1 : temp_data       <= {i_data[3*WIDTH:8*WIDTH-1], {9*WIDTH{1'b0}}};
                    4'd2 : temp_data       <= {i_data[2*WIDTH:8*WIDTH-1], {8*WIDTH{1'b0}}};
                    4'd3 : temp_data       <= {i_data[1*WIDTH:8*WIDTH-1], {7*WIDTH{1'b0}}};
                    4'd4 : temp_data       <= {i_data[0*WIDTH:8*WIDTH-1], {6*WIDTH{1'b0}}};
                    4'd5 : temp_data       <= {temp_data[4*WIDTH:5*WIDTH-1], i_data[0:8*WIDTH-1], {5*WIDTH{1'b0}}};
                    4'd6 : temp_data       <= {temp_data[4*WIDTH:6*WIDTH-1], i_data[0:8*WIDTH-1], {4*WIDTH{1'b0}}};
                endcase
            end else begin
                case (num_stored)
                    4'd0 : temp_data       <= {i_data[0:8*WIDTH-1], {6*WIDTH{1'b0}}};
                    4'd1 : temp_data       <= {temp_data[0:1*WIDTH-1], i_data[0:8*WIDTH-1], {5*WIDTH{1'b0}}};
                    4'd2 : temp_data       <= {temp_data[0:2*WIDTH-1], i_data[0:8*WIDTH-1], {4*WIDTH{1'b0}}};
                    4'd3 : temp_data       <= {temp_data[0:3*WIDTH-1], i_data[0:8*WIDTH-1], {3*WIDTH{1'b0}}};
                    4'd4 : temp_data       <= {temp_data[0:4*WIDTH-1], i_data[0:8*WIDTH-1], {2*WIDTH{1'b0}}};
                    4'd5 : temp_data       <= {temp_data[0:5*WIDTH-1], i_data[0:8*WIDTH-1], {1*WIDTH{1'b0}}};
                    4'd6 : temp_data       <= {temp_data[0:6*WIDTH-1], i_data[0:8*WIDTH-1]};
                endcase
            end
        end else begin
            if (i_ready_r1) begin
                temp_data       <= {temp_data[4*WIDTH:14*WIDTH-1], {4*WIDTH{1'b0}}};
            end else begin
                temp_data       <= temp_data;
            end
        end
    end

    always @(posedge i_clk) begin
        temp_inframe <= 14'd0;
        if (o_ready) begin
            if (i_ready_r1) begin
                case (num_stored)
                    4'd0 : temp_inframe    <= {i_inframe[4:7], 10'd0};
                    4'd1 : temp_inframe    <= {i_inframe[3:7], 9'd0};
                    4'd2 : temp_inframe    <= {i_inframe[2:7], 8'd0};
                    4'd3 : temp_inframe    <= {i_inframe[1:7], 7'd0};
                    4'd4 : temp_inframe    <= {i_inframe[0:7], 6'd0};
                    4'd5 : temp_inframe    <= {temp_inframe[4], i_inframe[0:7], 5'd0};
                    4'd6 : temp_inframe    <= {temp_inframe[4:5], i_inframe[0:7], 4'd0};
                endcase
            end else begin
                case (num_stored)
                    4'd0 : temp_inframe    <= {i_inframe[0:7], 6'd0};
                    4'd1 : temp_inframe    <= {temp_inframe[0], i_inframe[0:7], 5'd0};
                    4'd2 : temp_inframe    <= {temp_inframe[0:1], i_inframe[0:7], 4'd0};
                    4'd3 : temp_inframe    <= {temp_inframe[0:2], i_inframe[0:7], 3'd0};
                    4'd4 : temp_inframe    <= {temp_inframe[0:3], i_inframe[0:7], 2'd0};
                    4'd5 : temp_inframe    <= {temp_inframe[0:4], i_inframe[0:7], 1'd0};
                    4'd6 : temp_inframe    <= {temp_inframe[0:5], i_inframe[0:7]};
                endcase
            end
        end else begin
            if (i_ready_r1) begin
                temp_inframe    <= {temp_inframe[4:13], 4'b0000};
            end else begin
                temp_inframe    <= temp_inframe;
            end
        end
    end

    always @(posedge i_clk) begin
        o_data_reg      <= {4*WIDTH{1'b0}};
        if (i_ready_r1) begin
            if (o_ready) begin
                case (num_stored)
                    4'd0 : o_data_reg      <= i_data[0:4*WIDTH-1];
                    4'd1 : o_data_reg      <= {temp_data[0:WIDTH-1], i_data[0:3*WIDTH-1]};
                    4'd2 : o_data_reg      <= {temp_data[0:2*WIDTH-1], i_data[0:2*WIDTH-1]};
                    4'd3 : o_data_reg      <= {temp_data[0:3*WIDTH-1], i_data[0:WIDTH-1]};
                    4'd4 : o_data_reg      <= temp_data[0:4*WIDTH-1];
                    4'd5 : o_data_reg      <= temp_data[0:4*WIDTH-1];
                    4'd6 : o_data_reg      <= temp_data[0:4*WIDTH-1];
                endcase
            end else begin
                o_data_reg      <= temp_data[0:4*WIDTH-1];
            end
        end else begin
            o_data_reg      <= o_data_reg;
        end
    end

    always @(posedge i_clk) begin
        if (i_reset) begin
            o_inframe_reg   <= 4'b0000;
        end else begin
            o_inframe_reg   <= 4'b0000;
            if (i_ready_r1) begin
                case (num_stored)
                    4'd0    : o_inframe_reg   <= i_inframe[0:3];
                    4'd1    : o_inframe_reg   <= {temp_inframe[0], i_inframe[0:2]};
                    4'd2    : o_inframe_reg   <= {temp_inframe[0:1], i_inframe[0:1]};
                    4'd3    : o_inframe_reg   <= {temp_inframe[0:2], i_inframe[0]};
                    default : o_inframe_reg   <= temp_inframe[0:3];
                endcase
            end else begin
                o_inframe_reg   <= o_inframe_reg;
            end
        end
    end

    always @(posedge i_clk) begin
        if (i_reset) begin
            o_ready_reg     <= 1'b1;
        end else begin
            if (o_ready) begin
                if (i_ready_r1) begin
                    o_ready_reg <= (num_stored + i_numvalid) < 4'd11;
                end else begin
                    o_ready_reg <= (num_stored + i_numvalid) < 4'd7;
                end
            end else begin
                if (i_ready_r1) begin
                    o_ready_reg <= num_stored < 4'd11;
                end else begin
                    o_ready_reg     <= o_ready_reg;
                end
            end
        end
    end

    assign o_data       = o_data_reg;
    assign o_inframe    = o_inframe_reg;
    assign o_valid      = o_valid_reg;
    assign o_ready      = o_ready_reg;
endmodule
