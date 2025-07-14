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

module alt_ehipc3_fm_sl_avalon_to_if #(
    parameter WORD_WIDTH  = 64,
    parameter EMPTY_BITS  = 3,
    parameter PTP_WIDTH   = 1
) (
    input                     i_reset,
    input                     i_clk,

    input   [WORD_WIDTH-1:0]  i_data,
    input                     i_valid,
    input                     i_sop,
    input                     i_eop,
    input   [EMPTY_BITS-1:0]  i_empty,
    input                     i_error,
    input                     i_skip_crc,
    input   [PTP_WIDTH-1:0]   i_ptp,
    input                     i_ready,

    output  [WORD_WIDTH-1:0]  o_data,
    output                    o_valid,
    output                    o_inframe,
    output  [EMPTY_BITS-1:0]  o_empty,
    output                    o_error,
    //output                    o_numvalid,
    output                    o_skip_crc,
    output  [PTP_WIDTH-1:0]   o_ptp,
    output                    o_ready
);


    reg [EMPTY_BITS-1:0]   empty_reg;
    reg [WORD_WIDTH-1:0]   data_reg;
    reg                    valid_reg;
    reg                    error_reg;
    reg                    skip_crc_reg;
    reg                    o_skip_crc_reg;
    reg [PTP_WIDTH-1:0]    ptp_reg;
    reg                    ready_reg;

    reg                    o_inframe_reg;
    //reg [clogb2(WORD_WIDTH/8)-1:0]  o_numvalid_reg;

    wire inframe = (i_valid & i_sop) ? 1'b1 : ((i_valid & i_eop) ? 1'b0 : o_inframe_reg);

    always @(posedge i_clk) begin
        if (i_reset) begin
          o_inframe_reg <= 0;
        end
        else begin
          o_inframe_reg <= inframe;
        end
    end

    always @(posedge i_clk) begin
        empty_reg       <= i_empty;
        data_reg        <= i_data;
        valid_reg       <= i_valid;
        error_reg       <= i_error;
        skip_crc_reg    <= i_skip_crc;
        o_skip_crc_reg  <= i_skip_crc;
        ptp_reg         <= i_ptp;
        ready_reg       <= i_ready;
    end

    assign o_inframe    = o_inframe_reg;
    assign o_data       = data_reg;
    assign o_valid      = valid_reg;
    assign o_empty      = empty_reg;
    assign o_error      = error_reg;
    assign o_skip_crc   = o_skip_crc_reg;
    assign o_ptp        = ptp_reg;
    assign o_ready      = ready_reg;

   function integer clogb2;
      input integer input_num;
      begin
         for (clogb2=0; input_num>0; clogb2=clogb2+1)
           input_num = input_num >> 1;
         if(clogb2 == 0)
           clogb2 = 1;
      end
   endfunction

endmodule
