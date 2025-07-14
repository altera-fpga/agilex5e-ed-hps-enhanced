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

module alt_ehipc3_fm_scfifo_mlab #(
    parameter SIM_EMULATE       = 1'b0,
    parameter WIDTH             = 64
)(
    input                   clk,
    input                   sclr,
    input  [WIDTH-1:0]      wdata,
    input                   wreq,
    output                  full,
    output [WIDTH-1:0]      rdata,
    input                   rreq,
    output                  empty
);

    reg [4:0]   w_ptr;
    reg [4:0]   r_ptr;
    reg [30:0]  used;

    reg     [WIDTH-1:0] readdata_reg;
    wire    [WIDTH-1:0] readdata_int;

    wire    write   = wreq && !full;
    wire    read    = rreq && !empty;

    assign full = used[30];
    assign empty = !used[0];
    assign rdata = readdata_reg;

    always @(posedge clk) begin
        if (sclr) begin
            readdata_reg <= {WIDTH{1'b0}};
        end else begin
            if (read) begin
                readdata_reg <= readdata_int;
            end else begin
                readdata_reg <= readdata_reg;
            end
        end
    end

    always @(posedge clk) begin
        if (sclr) begin
            used <= 31'd0;
        end else begin
            if (write) begin
                if (read) begin
                    used <= used;
                end else begin
                    used <= {used[29:0], 1'b1};
                end
            end else begin
                if (read) begin
                    used <= {1'b0, used[30:1]};
                end else begin
                    used <= used;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (sclr) begin
            w_ptr <= 5'd0;
        end else begin
            if (write) begin
                w_ptr <= w_ptr + 1'b1;
            end else begin
                w_ptr <= w_ptr;
            end
        end

    end

    always @(posedge clk) begin
        if (sclr) begin
            r_ptr <= 5'd0;
        end else begin
            if (read) begin
                r_ptr <= r_ptr + 1'b1;
            end else begin
                r_ptr <= r_ptr;
            end
        end
    end

    alt_ehipc3_fm_mlab #(
        .WIDTH       (WIDTH),
        .ADDR_WIDTH  (5),
        .SIM_EMULATE (SIM_EMULATE)
    ) sm0 (
        .wclk       (clk),
        .wena       (write),
        .waddr_reg  (w_ptr),
        .wdata_reg  (wdata),
        .raddr      (r_ptr),
        .rdata      (readdata_int)
    );
endmodule
