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


/* This module takes a stream of data 3 words wide, and
    compresses it to a stream that's 2 words wide.
    *_num_words indicates the number of valid words.
    Words are aligned to the MSB and also output
    in that order.

    Example for case WIDTH = 8.
    i_num_words = 2'h1
    i_data = 24'h01xxxx

    i_num_words = 2'h2
    i_data = 24'h0102xx

    i_num_words = 2'h3
    i_data = 24'h010203

    When o_ready is high, the input has been accepted.
    If i_ready is held low, o_num_words and o_data will
    be held constant and will stall the pipeline.
*/
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module alt_ehipc3_fm_block_gearbox #(
    parameter WIDTH = 64
) (
    input                       i_reset,
    input                       i_clk,

    input       [3*WIDTH-1:0]   i_data,
    input       [1:0]           i_num_words,
    output                      o_ready,

    output reg  [1:0]           o_num_words,
    output reg  [2*WIDTH-1:0]   o_data,
    output reg                  o_valid,
    input                       i_ready
);

    reg [WIDTH-1:0]     mem [0:3];
    reg [2:0]           stored_words;
    reg                 o_ready_reg;
    reg [1:0]           o_num_words_reg;
    reg [2*WIDTH-1:0]   o_data_reg;
    reg                 o_valid_reg;
    wire [WIDTH-1:0]    i_data_int  [0:2];

    assign i_data_int[0]   = i_data[3*WIDTH-1:2*WIDTH];
    assign i_data_int[1]   = i_data[2*WIDTH-1:WIDTH];
    assign i_data_int[2]   = i_data[WIDTH-1:0];

    always @(posedge i_clk) o_valid_reg <= i_ready;

    always @(posedge i_clk) begin
        if (i_reset) begin
            stored_words <= 3'd0;
        end else begin
            if (i_ready) begin
                if (o_ready) begin
                    case ({i_num_words, stored_words})
                        {2'd0, 3'd0} : stored_words <= 3'd0;
                        {2'd0, 3'd1} : stored_words <= 3'd0;
                        {2'd1, 3'd0} : stored_words <= 3'd0;
                        {2'd1, 3'd1} : stored_words <= 3'd0;
                        {2'd2, 3'd0} : stored_words <= 3'd0;
                        {2'd2, 3'd1} : stored_words <= 3'd1;
                        {2'd3, 3'd0} : stored_words <= 3'd1;
                        {2'd3, 3'd1} : stored_words <= 3'd2;
                        default      : stored_words <= 3'hx;
                    endcase
                end else begin  // i_ready & !o_ready
                    case (stored_words)
                        3'd2    : stored_words <= 3'd0;
                        3'd3    : stored_words <= 3'd1;
                        3'd4    : stored_words <= 3'd2;
                        default : stored_words <= 3'hx;
                    endcase
                end
            end else begin
                if (o_ready) begin  // !i_ready & o_ready
                    case ({i_num_words, stored_words})
                        {2'd0, 3'd0} : stored_words <= 3'd0;
                        {2'd0, 3'd1} : stored_words <= 3'd1;
                        {2'd1, 3'd0} : stored_words <= 3'd1;
                        {2'd1, 3'd1} : stored_words <= 3'd2;
                        {2'd2, 3'd0} : stored_words <= 3'd2;
                        {2'd2, 3'd1} : stored_words <= 3'd3;
                        {2'd3, 3'd0} : stored_words <= 3'd3;
                        {2'd3, 3'd1} : stored_words <= 3'd4;
                        default      : stored_words <= 3'hx;
                    endcase
                end else begin  // !i_ready & !o_ready
                    stored_words <= stored_words;
                end
            end
        end
    end

    always @(posedge i_clk) begin
        if (i_reset) begin
            o_ready_reg <= 1'b1;
        end else begin
            if (i_ready) begin
                if (o_ready) begin  // i_ready & o_ready
                    case ({i_num_words, stored_words})
                        {2'd0, 3'd0} : o_ready_reg <= 1'b1;
                        {2'd0, 3'd1} : o_ready_reg <= 1'b1;
                        {2'd1, 3'd0} : o_ready_reg <= 1'b1;
                        {2'd1, 3'd1} : o_ready_reg <= 1'b1;
                        {2'd2, 3'd0} : o_ready_reg <= 1'b1;
                        {2'd2, 3'd1} : o_ready_reg <= 1'b1;
                        {2'd3, 3'd0} : o_ready_reg <= 1'b1;
                        {2'd3, 3'd1} : o_ready_reg <= 1'b0;
                        default      : o_ready_reg <= 1'bx;
                    endcase
                end else begin  // i_ready & !o_ready
                    case (stored_words)
                        3'd2    : o_ready_reg <= 1'b1;
                        3'd3    : o_ready_reg <= 1'b1;
                        3'd4    : o_ready_reg <= 1'b0;
                        default : o_ready_reg <= 1'bx;
                    endcase
                end
            end else begin
                if (o_ready) begin  // !i_ready & o_ready
                    case ({i_num_words, stored_words})
                        {2'd0, 3'd0} : o_ready_reg <= 1'b1;
                        {2'd0, 3'd1} : o_ready_reg <= 1'b1;
                        {2'd1, 3'd0} : o_ready_reg <= 1'b1;
                        {2'd1, 3'd1} : o_ready_reg <= 1'b0;
                        {2'd2, 3'd0} : o_ready_reg <= 1'b0;
                        {2'd2, 3'd1} : o_ready_reg <= 1'b0;
                        {2'd3, 3'd0} : o_ready_reg <= 1'b0;
                        {2'd3, 3'd1} : o_ready_reg <= 1'b0;
                        default      : o_ready_reg <= 1'bx;
                    endcase
                end else begin  // !i_ready & !o_ready
                    o_ready_reg <= o_ready_reg;
                end
            end
        end
    end

    always @(posedge i_clk) begin
        if (i_reset) begin
            o_num_words_reg <= 2'd0;
        end else begin
            if (i_ready) begin
                if (o_ready) begin  // i_ready & o_ready
                    case ({i_num_words, stored_words})
                        {2'd0, 3'd0} : o_num_words_reg <= 2'd0;
                        {2'd0, 3'd1} : o_num_words_reg <= 2'd1;
                        {2'd1, 3'd0} : o_num_words_reg <= 2'd1;
                        {2'd1, 3'd1} : o_num_words_reg <= 2'd2;
                        {2'd2, 3'd0} : o_num_words_reg <= 2'd2;
                        {2'd2, 3'd1} : o_num_words_reg <= 2'd2;
                        {2'd3, 3'd0} : o_num_words_reg <= 2'd2;
                        {2'd3, 3'd1} : o_num_words_reg <= 2'd2;
                        default      : o_num_words_reg <= 2'dx;
                    endcase
                end else begin  // i_ready & !o_ready
                    case (stored_words)
                        3'd2    : o_num_words_reg <= 2'd2;
                        3'd3    : o_num_words_reg <= 2'd2;
                        3'd4    : o_num_words_reg <= 2'd2;
                        default : o_num_words_reg <= 2'dx;
                    endcase
                end
            end else begin
                o_num_words_reg <= o_num_words_reg;
            end
        end
    end

    always @(posedge i_clk) begin
        if (i_ready) begin
            if (o_ready) begin  // i_ready & o_ready
                case (stored_words[0])
                    1'b0 : o_data_reg[2*WIDTH-1:WIDTH] <= i_data_int[0];
                    1'b1 : o_data_reg[2*WIDTH-1:WIDTH] <= mem[0];
                endcase
            end else begin  // i_ready & !o_ready
                o_data_reg[2*WIDTH-1:WIDTH] <= mem[0];
            end
        end else begin
            o_data_reg[2*WIDTH-1:WIDTH] <= o_data_reg[2*WIDTH-1:WIDTH];
        end
    end

    always @(posedge i_clk) begin
        if (i_ready) begin
            if (o_ready) begin  // i_ready & o_ready
                case (stored_words[0])
                    1'b0 : o_data_reg[WIDTH-1:0] <= i_data_int[1];
                    1'b1 : o_data_reg[WIDTH-1:0] <= i_data_int[0];
                endcase
            end else begin  // i_ready & !o_ready
                o_data_reg[WIDTH-1:0] <= mem[1];
            end
        end else begin
            o_data_reg[WIDTH-1:0] <= o_data_reg[WIDTH-1:0];
        end
    end

    always @(posedge i_clk) begin
        if (i_ready) begin
            if (o_ready) begin
                case (stored_words[0])
                    1'b0 : mem[0] <= i_data_int[2];
                    1'b1 : mem[0] <= i_data_int[1];
                endcase
            end else begin  // i_ready & !o_ready
                mem[0]  <= mem[2];
            end
        end else begin
            if (o_ready) begin  // !i_ready & o_ready
                case (stored_words[0])
                    1'b0 : mem[0] <= i_data_int[0];
                    1'b1 : mem[0] <= mem[0];
                endcase
            end else begin  // !i_ready & !o_ready
                mem[0] <= mem[0];
            end
        end
    end

    always @(posedge i_clk) begin
        if (i_ready) begin
            if (o_ready) begin
                mem[1] <= i_data_int[2];
            end else begin  // i_ready & !o_ready
                mem[1]  <= mem[3];
            end
        end else begin
            if (o_ready) begin  // !i_ready & o_ready
                case (stored_words[0])
                    1'b0 : mem[1] <= i_data_int[1];
                    1'b1 : mem[1] <= i_data_int[0];
                endcase
            end else begin  // !i_ready & !o_ready
                mem[1] <= mem[1];
            end
        end
    end

    // f(o_ready, stored_words[0], i_data_int[2:1], mem[2]) 5 bits
    always @(posedge i_clk) begin
        if (o_ready) begin  // !i_ready & o_ready
            case (stored_words[0])
                1'b0 : mem[2] <= i_data_int[2];
                1'b1 : mem[2] <= i_data_int[1];
            endcase
        end else begin  // !i_ready & !o_ready
            mem[2] <= mem[2];
        end
    end

    // f(o_ready, i_data_int[2], mem[3]) 3 bits
    always @(posedge i_clk) begin
        if (o_ready) begin  // !i_ready & o_ready
            mem[3] <= i_data_int[2];
        end else begin  // !i_ready & !o_ready
            mem[3] <= mem[3];
        end
    end

    assign o_ready      = o_ready_reg;
    always @(posedge i_clk) begin
        o_num_words  <= o_num_words_reg;
        o_data       <= o_data_reg;
        o_valid      <= o_valid_reg;
    end
endmodule
