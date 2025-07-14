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
// Filename         : ptp_ts_converter.sv
// Author           : Tholu Kiran Kumar <kktholu@intel.com>
// Created On       : Mon Jul 03/07/2017 10:16:25 AM MYT
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
// Description :- This module convertes the 48 bit 2 step Rx and Tx Ts into 96
// bit. It is assumed that i_tod is synchronized to the datapath clock outside
// this module and hence no synchronizer is used for tod in the module. The
// TOD originaly comes from TOD clock domain.
//
//
//------------------------------------------------------------------------------

`timescale 1ns / 1ns
module alt_ehipc3_fm_sl_ptp_ts_converter (
    input  logic        i_clk,
    input  logic        i_tx_rst_n,
    input  logic        i_rx_rst_n,

    input  logic        i_ptp_tx_ts_valid,
    input  logic [11:0] i_ptp_tx_ts,
    input  logic [1:0]  i_ptp_tx_fp,

    input  logic        i_rx_valid,
    input  logic        i_rx_inframe,
    input  logic [20:0] i_ptp_rx_ts,

    input  logic        i_ts_format,
    input  logic [95:0] i_tod,

    output logic        o_ptp_ets_valid,
    output logic [95:0] o_ptp_ets,
    output logic [7:0]  o_ptp_ets_fp,

    output logic [95:0] o_ptp_rx_its,
    output logic        o_ptp_rx_its_valid
  );

  localparam BILLION = 32'd1000000000;

  logic [47:0] ets;
  logic [7:0]  ets_fp;
  logic [1:0]  ets_counter;
  logic [2:0]  ets_counter_plus_one;
  logic [83:0] its;
  logic [1:0]  its_counter;

  logic        r_rx_inframe;
  logic [3:0]  its_in_progress;
  logic        rx_sop;

  logic        tx_tod_rollover;
  logic        tx_ets_rollover;
  logic        rx_tod_rollover;
  logic        rx_its_rollover;

  logic [95:0] tod_r1;
  logic [47:0] tod_95_48_r2;
  logic [48:0] tod_95_48_plus_one_r2;
  logic [48:0] tod_95_48_minus_one_r2;
  logic [11:0] tod_95_84_r2;
  logic [12:0] tod_95_84_plus_one_r2;
  logic [12:0] tod_95_84_minus_one_r2;

  //flop for timing
  logic        ptp_tx_ts_valid_r;
  logic [11:0] ptp_tx_ts_r;
  logic [1:0]  ptp_tx_fp_r;

  always @(posedge i_clk) begin
      tod_r1  <= i_tod;
  end

  assign ets_counter_plus_one = ets_counter + 1'b1;

  always @ (posedge i_clk)
  begin
      if (!i_tx_rst_n) begin
          ptp_tx_ts_valid_r <= 1'b0;
      end else begin
          ptp_tx_ts_valid_r <= i_ptp_tx_ts_valid;
      end
  end

  always @ (posedge i_clk)
  begin
      ptp_tx_ts_r <= i_ptp_tx_ts;
      ptp_tx_fp_r <= i_ptp_tx_fp;

      if (ptp_tx_ts_valid_r)
      begin
        ets <= {ets[35:0], ptp_tx_ts_r};
        ets_fp <= {ets_fp[5:0],ptp_tx_fp_r};
      end
  end

  always @ (posedge i_clk)
  begin
    if (!i_tx_rst_n)
    begin
      ets_counter <= 0;
      o_ptp_ets_valid <= 0;
    end
    else
    begin
      if (ptp_tx_ts_valid_r)
      begin
        ets_counter <= ets_counter_plus_one[1:0];
      end
      else begin
        ets_counter <= 0;
      end

      o_ptp_ets_valid <= (ets_counter == 2'b11);
    end
  end

  // Assumption:
  //    1. There is no large load adjustment done to i_tod
  //    2. i_tod is smaller than ets
  // When ets upper ns field is all zero, while i_tod upper ns field equal to billion upper ns field, rollover happen
  always @ (posedge i_clk)
  begin
      tx_ets_rollover <= (tod_r1[47:44] == BILLION[31:28]) && !(|ets[35:32]);
    end

  // Assumption:
  //    1. There is no large load adjustment done to i_tod
  //    2. i_tod is larger than ets (maybe happen on TX depend on latency of ETS from HIP to SIP)
  // When i_tod upper ns field is all zero, while ets upper ns field equal to billion upper ns field, rollover happen
  assign tx_tod_rollover = !(|tod_r1[47:44]) && (ets[47:44] == BILLION[31:28]);

  always @ (posedge i_clk)
  begin
      tod_95_48_r2            <= tod_r1[95:48];
      tod_95_48_plus_one_r2   <= tod_r1[95:48] + 1'b1;
      tod_95_48_minus_one_r2  <= tod_r1[95:48] - 1'b1;
  end

  assign o_ptp_ets = tx_ets_rollover? {tod_95_48_plus_one_r2[47:0],ets[47:0]}:
                     tx_tod_rollover? {tod_95_48_minus_one_r2[47:0],ets[47:0]}:
                                      {tod_95_48_r2[47:0],ets[47:0]};
  assign o_ptp_ets_fp = ets_fp;

  always @ (posedge i_clk)
  begin
    if (!i_rx_rst_n)
    begin
      r_rx_inframe <= 0;
    end
    else
    begin
      if(i_rx_valid)
      begin
        r_rx_inframe <= i_rx_inframe;
      end
    end
  end

  assign rx_sop = i_rx_inframe & !r_rx_inframe;

  always @ (posedge i_clk)
  begin
    if (!i_rx_rst_n)
    begin
      its_in_progress <= 0;
    end
    else
    begin
      if (i_rx_valid)
      begin
        its_in_progress <= {its_in_progress[2:0], rx_sop};
      end
    end
  end

  always @ (posedge i_clk)
  begin
    if (i_rx_valid && ((|its_in_progress[2:0]) || rx_sop))
    begin
      its <= {its[62:0],i_ptp_rx_ts};
    end
  end

  // Assumption:
  //    1. There is no large load adjustment done to i_tod
  //    2. i_tod is larger than its
  // When i_tod[83:48] second field is all zero, while its[83:48] second field is all one, rollover happen
  always @ (posedge i_clk)
  begin
     if (its_in_progress[2])
     begin
       rx_tod_rollover <= !(|tod_r1[83:48]) && (&its[62:27]);
     end
  end

  // Assumption:
  //    1. There is no large load adjustment done to i_tod
  //    2. i_tod is smaller than its (unlikely happen on RX)
  // When its[83:48] second field is all zero, while i_tod[83:48] second field is all one, rollover happen
  //assign rx_its_rollover = (&i_tod[83:48]) && !(|its[83:48]);
  assign rx_its_rollover = 1'b0;

  always @ (posedge i_clk)
  begin
    if (its_in_progress[2])
    begin
    tod_95_84_r2            <= tod_r1[95:84];
    tod_95_84_plus_one_r2   <= tod_r1[95:84] + 1'b1;
    tod_95_84_minus_one_r2  <= tod_r1[95:84] - 1'b1;
    end
  end

  assign o_ptp_rx_its = rx_tod_rollover? {tod_95_84_minus_one_r2[11:0], its}:
                        rx_its_rollover? {tod_95_84_plus_one_r2[11:0], its}:
                                         {tod_95_84_r2[11:0], its};
  assign o_ptp_rx_its_valid = its_in_progress[3] && i_rx_valid;

endmodule : alt_ehipc3_fm_sl_ptp_ts_converter

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
