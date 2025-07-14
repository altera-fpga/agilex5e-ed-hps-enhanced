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


//==============================================================================
//
// (C) 2011-2017 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Altera Program License Subscription
// Agreement, Altera MegaCore Function License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Altera and sold by
// Altera or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
//------------------------------------------------------------------------------
//
// Filename         : ptp_opcode_writer.sv
// Author           : Tholu Kiran Kumar <kktholu@intel.com>
// Created On       : Mon Jul 03/07/2017 01:23:43 PM MYT
//
//------------------------------------------------------------------------------
//
// $File: $
// $Revision: $
// $Date: $
// $Author: $
//
//==============================================================================

//------------------------------------------------------------------------------
//
// Description :-
// Submodules:
//             ptp_fp
//             ptp_convert_commands
//             ptp_calc_tam
//             ptp_ts_port
//
//------------------------------------------------------------------------------

`timescale 1ns / 1ns
module alt_ehipc3_fm_sl_ptp_opcode_writer #(
    parameter ENHANCED_PTP_ACCURACY = 0,
    parameter SIM_MODE = 0
) (
    input  logic        i_enable_rsfec,
    input  logic        i_tx_preamble_pass,

    input  logic        i_clk,
    input  logic        i_rst_n,

    input  logic	i_rst_n1,
    input  logic	i_rst_n2,
    input  logic	i_rst_n3,
    input  logic	i_rst_n4,
    input  logic	i_rst_n5,
    input  logic	i_rst_n6,

    input  logic        i_rx_lock,

    input  logic [7:0]  i_ptp_fp,

    input  logic        i_ptp_ins_ets,
    input  logic        i_ptp_ins_cf,
    input  logic        i_ptp_zero_csum,
    input  logic        i_ptp_update_eb,
    input  logic        i_ptp_ts_format,
    input  logic        i_ptp_asym,
    input  logic [15:0] i_ptp_ts_offset,
    input  logic [15:0] i_ptp_cf_offset,
    input  logic [15:0] i_ptp_csum_offset,
    input  logic [15:0] i_ptp_eb_offset,
    input  logic [95:0] i_ptp_tx_its,

    input  logic        i_ptp_ts_req,

    input  logic        i_tx_valid,
    input  logic        i_tx_sop,
    input  logic        i_tx_eop,
    input  logic        i_tx_inframe,
    input  logic        i_tx_skip_crc,

    input  logic        i_req_tx_tam_load,
    input  logic        i_req_rx_tam_load,
    input  logic        i_req_tx_ui_load,
    input  logic        i_req_rx_ui_load,

    input  logic [95:0] i_tx_tam,
    input  logic [31:0] i_tx_tam_adj,
    input  logic [31:0] i_rx_tam_adj,
    input  logic [95:0] i_rx_tam,

    input  logic [31:0] i_tx_ui,
    input  logic [31:0] i_rx_ui,

    output logic [1:0]  o_ptp_tx_fp,

    output logic [2:0]  o_ptp_ins_type,
    output logic [2:0]  o_ptp_byte_offset,
    output logic        o_tx_ptp_ready,
    output logic        o_rx_ptp_ready,

    output logic [23:0] o_ptp_ts,

    output logic        o_tx_tam_valid,
    output logic        o_rx_tam_valid,

    output logic [7:0]  o_ptp_ready_dbg,

    input  logic        i_ptp_rx_aib_dsk_done,
    output logic        o_ptp_rx_aib_dsk_done

  );

  logic [95:0] tx_tam;
  logic [95:0] rx_tam;

generate
if (ENHANCED_PTP_ACCURACY == 0) begin :SL_PTP_OPCODE

  logic        tx_tam_valid;
  logic        rx_tam_valid;
  logic [7:0]  o_ptp_ready_dbg;

  assign o_tx_tam_valid =0;
  assign o_rx_tam_valid =0;
  assign o_ptp_ready_dbg = 8'd0;

  alt_ehipc3_fm_sl_ptp_convert_commands #(
    .SIM_MODE                (SIM_MODE)
  ) ptp_covert_commands_u (
    .i_enable_rsfec          (i_enable_rsfec),
    .i_tx_preamble_pass      (i_tx_preamble_pass),
    .i_clk                   (i_clk),
    .i_rst_n                 (i_rst_n),
    .i_rst_n1		     (i_rst_n1),
    .i_rst_n2		     (i_rst_n2),
    .i_rst_n3		     (i_rst_n3),
    .i_rst_n4		     (i_rst_n4),
    .i_rst_n5		     (i_rst_n5),
    .i_rx_lock               (i_rx_lock),
    .i_ptp_ins_ets           (i_ptp_ins_ets),
    .i_ptp_ins_cf            (i_ptp_ins_cf),
    .i_ptp_zero_csum         (i_ptp_zero_csum),
    .i_ptp_update_eb         (i_ptp_update_eb),
    .i_ptp_ts_format         (i_ptp_ts_format),
    .i_ptp_asym              (i_ptp_asym),
    .i_ptp_ts_offset         (i_ptp_ts_offset),
    .i_ptp_cf_offset         (i_ptp_cf_offset),
    .i_ptp_csum_offset       (i_ptp_csum_offset),
    .i_ptp_eb_offset         (i_ptp_eb_offset),
    .i_ptp_tx_its            (i_ptp_tx_its),
    .i_ptp_ts_req            (i_ptp_ts_req),
    .i_ptp_fp                (i_ptp_fp),
    .i_tx_valid              (i_tx_valid),
    .i_tx_sop                (i_tx_sop),
    .i_tx_eop                (i_tx_eop),
    .i_tx_inframe            (i_tx_inframe),
    .i_tx_skip_crc           (i_tx_skip_crc),
    .i_req_tx_tam_load       (tx_tam_valid),
    .i_tx_tam                (tx_tam),
    .i_req_rx_tam_load       (rx_tam_valid),
    .i_rx_tam                (rx_tam),
    .i_req_tx_ui_load        (i_req_tx_ui_load),
    .i_tx_ui                 (i_tx_ui),
    .i_req_rx_ui_load        (i_req_rx_ui_load),
    .i_rx_ui                 (i_rx_ui),
    .o_ptp_ins_type          (o_ptp_ins_type),
    .o_ptp_byte_offset       (o_ptp_byte_offset),
    .o_tx_ptp_ready          (o_tx_ptp_ready),
    .o_rx_ptp_ready          (o_rx_ptp_ready),
    .o_ptp_ts                (o_ptp_ts),
    .o_ptp_tx_fp             (o_ptp_tx_fp),
    .i_ptp_rx_aib_dsk_done   (i_ptp_rx_aib_dsk_done),
    .o_ptp_rx_aib_dsk_done   (o_ptp_rx_aib_dsk_done)
  );


  alt_ehipc3_fm_sl_ptp_calc_tam ptp_calc_tam_u (
    .i_clk              (i_clk),
    .i_rst_n            (i_rst_n6),
    .i_tx_tam           (i_tx_tam),
    .i_rx_tam           (i_rx_tam),
    .i_tx_tam_adj       (i_tx_tam_adj),
    .i_rx_tam_adj       (i_rx_tam_adj),
    .i_req_tx_tam_load  (i_req_tx_tam_load),
    .i_req_rx_tam_load  (i_req_rx_tam_load),
    .o_tx_tam_valid     (tx_tam_valid),
    .o_rx_tam_valid     (rx_tam_valid),
    .o_tx_tam           (tx_tam),
    .o_rx_tam           (rx_tam)
  );
end else begin
alt_ehipc3_fm_sl_ptp_convert_commands #(
    .SIM_MODE                (SIM_MODE)
  ) ptp_covert_commands_u (
    .i_enable_rsfec          (i_enable_rsfec),
    .i_tx_preamble_pass      (i_tx_preamble_pass),
    .i_clk                   (i_clk),
    .i_rst_n                 (i_rst_n),
    .i_rst_n1		     (i_rst_n1),
    .i_rst_n2		     (i_rst_n2),
    .i_rst_n3		     (i_rst_n3),
    .i_rst_n4		     (i_rst_n4),
    .i_rst_n5		     (i_rst_n5),
    .i_rx_lock               (i_rx_lock),
    .i_ptp_ins_ets           (i_ptp_ins_ets),
    .i_ptp_ins_cf            (i_ptp_ins_cf),
    .i_ptp_zero_csum         (i_ptp_zero_csum),
    .i_ptp_update_eb         (i_ptp_update_eb),
    .i_ptp_ts_format         (i_ptp_ts_format),
    .i_ptp_asym              (i_ptp_asym),
    .i_ptp_ts_offset         (i_ptp_ts_offset),
    .i_ptp_cf_offset         (i_ptp_cf_offset),
    .i_ptp_csum_offset       (i_ptp_csum_offset),
    .i_ptp_eb_offset         (i_ptp_eb_offset),
    .i_ptp_tx_its            (i_ptp_tx_its),
    .i_ptp_ts_req            (i_ptp_ts_req),
    .i_ptp_fp                (i_ptp_fp),
    .i_tx_valid              (i_tx_valid),
    .i_tx_sop                (i_tx_sop),
    .i_tx_eop                (i_tx_eop),
    .i_tx_inframe            (i_tx_inframe),
    .i_tx_skip_crc           (i_tx_skip_crc),
    .i_req_tx_tam_load       (o_tx_tam_valid),
    .i_tx_tam                (tx_tam),
    .i_req_rx_tam_load       (o_rx_tam_valid),
    .i_rx_tam                (rx_tam),
    .i_req_tx_ui_load        (i_req_tx_ui_load),
    .i_tx_ui                 (i_tx_ui),
    .i_req_rx_ui_load        (i_req_rx_ui_load),
    .i_rx_ui                 (i_rx_ui),
    .o_ptp_ins_type          (o_ptp_ins_type),
    .o_ptp_byte_offset       (o_ptp_byte_offset),
    .o_tx_ptp_ready          (o_tx_ptp_ready),
    .o_rx_ptp_ready          (o_rx_ptp_ready),
    .o_ptp_ready_dbg         (o_ptp_ready_dbg),
    .o_ptp_ts                (o_ptp_ts),
    .o_ptp_tx_fp             (o_ptp_tx_fp),
    .i_ptp_rx_aib_dsk_done   (i_ptp_rx_aib_dsk_done),
    .o_ptp_rx_aib_dsk_done   (o_ptp_rx_aib_dsk_done)
  );


  alt_ehipc3_fm_sl_ptp_calc_tam_sn ptp_calc_tam_u (
    .i_clk              (i_clk),
    .i_rst_n            (i_rst_n6),
    .i_tx_tam           (i_tx_tam),
    .i_rx_tam           (i_rx_tam),
    .i_tx_tam_adj       (i_tx_tam_adj),
    .i_rx_tam_adj       (i_rx_tam_adj),
    .i_req_tx_tam_load  (i_req_tx_tam_load),
    .i_req_rx_tam_load  (i_req_rx_tam_load),
    .o_tx_tam_valid     (o_tx_tam_valid),
    .o_rx_tam_valid     (o_rx_tam_valid),
    .o_tx_tam           (tx_tam),
    .o_rx_tam           (rx_tam)
  );

end
endgenerate
  endmodule : alt_ehipc3_fm_sl_ptp_opcode_writer

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
