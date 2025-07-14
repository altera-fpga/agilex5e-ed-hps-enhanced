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

module alt_ehipc3_fm_word_delay_mlab #(
    parameter WIDTH         = 32,
    parameter SIM_EMULATE   = 0
) (
    input 	       i_clk,
    input              i_rst,
    input [4:0]        i_delay,
    input [WIDTH-1:0]  i_data,
    output [WIDTH-1:0] o_data
);

    wire    [WIDTH-1:0] o_data_int;
    reg     [WIDTH-1:0] o_data_reg;

    reg [4:0]   write_ptr;
    reg [4:0]   read_ptr = 5'd0;

    always @(posedge i_clk) begin
       if (i_rst) begin
	  write_ptr <= 3'd0;
	  read_ptr  <= 3'd0;
       end
       else begin
        write_ptr <= 5'(read_ptr + i_delay);
        read_ptr <= 5'(read_ptr + 1'b1);
       end
    end


    alt_ehipc3_fm_mlab #(
        .WIDTH       (WIDTH),
        .ADDR_WIDTH  (5),
        .SIM_EMULATE (SIM_EMULATE)
    ) sm0 (
        .wclk       (i_clk),
        .wena       (1'b1),
        .waddr_reg  ({ write_ptr}),
        .wdata_reg  (i_data),
        .raddr      ({read_ptr}),
        .rdata      (o_data_int)
    );

    always @(posedge i_clk) o_data_reg <= o_data_int;

    assign o_data = o_data_reg;
endmodule
