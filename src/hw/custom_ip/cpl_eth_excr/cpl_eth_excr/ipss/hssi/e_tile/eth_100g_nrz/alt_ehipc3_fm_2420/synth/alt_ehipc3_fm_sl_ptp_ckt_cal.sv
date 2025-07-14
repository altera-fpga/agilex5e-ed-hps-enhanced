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
// Filename         : ptp_ckt_cal.sv
// Author           : Tholu Kiran Kumar <kktholu@intel.com>
// Created On       : Tue Jul 04/07/2017 02:18:44 PM MYT
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
//                Assumption is a clock period of 2.482424ns i.e. 402.832MHz
//                For emulation it will be 24.8242ns i.e. 40.2832MHz
//
//
//------------------------------------------------------------------------------

`timescale 1ns / 1ns
module alt_ehipc3_fm_sl_ptp_ckt_cal #(
  parameter PERIOD_NS_FNS = 18'h27B80 // 402.832MHz
)(
    input  logic        i_clk, //402.832MHz
    input  logic        i_rst_n,

    input  logic        i_all_ready,

    input  logic        i_calibrate,

    input  logic        i_rx_sclk_return,
    input  logic        i_tx_sclk_return,

    output logic        o_sclk,
    output logic [31:0] o_tx_error,
    output logic        o_tx_error_valid,
    output logic [31:0] o_rx_error,
    output logic        o_rx_error_valid
  );

  logic       tx_sclk_return_r;
  logic       rx_sclk_return_r;
  logic       tx_sclk_return_rise;
  logic       rx_sclk_return_rise;
  logic       tx_sclk_return_rise_r;
  logic       rx_sclk_return_rise_r;
  logic [3:0] counter;
  logic [4:0] counter_plus_one;
  logic [3:0] tx_error_counter;
  logic [3:0] rx_error_counter;
  logic [31:0] tx_error;
  logic [31:0] rx_error;
  logic [31:0] tx_error_adj;
  logic [31:0] rx_error_adj;
  logic        tx_error_valid;
  logic        rx_error_valid;
  logic        tx_error_valid_r;
  logic        rx_error_valid_r;

  logic tx_error_cnt_in_progress;
  logic rx_error_cnt_in_progress;

  logic sclk_r;

  assign counter_plus_one = counter + 1'b1;

  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      counter <= 0;
    end
    else
    begin
      if (i_calibrate && i_all_ready)
      begin
        counter <= counter_plus_one[3:0];
      end
      else
      begin
        counter <= 0;
      end
    end
  end

  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      o_sclk <= 0;
      sclk_r <= 0;

      tx_sclk_return_r <= 1'b0;
      rx_sclk_return_r <= 1'b0;
      tx_sclk_return_rise_r <= 1'b0;
      rx_sclk_return_rise_r <= 1'b0;
    end
    else
    begin
// -----------------------------------------------------------------------------
// 01/Sep/2020 : slim35 :
// Ciena issue : Not able to to sample i_rx/tx_sclk_return.
// Found alt_ehipc3_fm_sl_ptp_ckt_cal is using unsynchronized version of i_tx_sclk_return.
// Also extending o_sclk pulse which returns as i_tx/rx_sclk_return from 1 to 2 cycles for better sampling possibility.
// -----------------------------------------------------------------------------
//      o_sclk <= (counter == 0) && i_calibrate && i_all_ready;
      o_sclk <= ((counter == 0) || (counter == 1)) && i_calibrate && i_all_ready;
// -----------------------------------------------------------------------------
      sclk_r <= o_sclk;

      tx_sclk_return_r <= i_tx_sclk_return;
      rx_sclk_return_r <= i_rx_sclk_return;
      tx_sclk_return_rise_r <= tx_sclk_return_rise;
      rx_sclk_return_rise_r <= rx_sclk_return_rise;
    end
  end

  assign tx_sclk_return_rise = i_tx_sclk_return && !tx_sclk_return_r;
  assign rx_sclk_return_rise = i_rx_sclk_return && !rx_sclk_return_r;

  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      tx_error_cnt_in_progress <= 0;
    end
    else
    begin
      if (tx_sclk_return_rise)
      begin
        tx_error_cnt_in_progress <= 0;
      end
      else if (o_sclk)
      begin
        tx_error_cnt_in_progress <= 1;
      end
    end
  end

  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      rx_error_cnt_in_progress <= 0;
    end
    else
    begin
      if (rx_sclk_return_rise)
      begin
        rx_error_cnt_in_progress <= 0;
      end
      else if (o_sclk)
      begin
        rx_error_cnt_in_progress <= 1;
      end
    end
  end


  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      tx_error_counter <= 0;
    end
    else
    begin
      if (!i_all_ready)
      begin
        tx_error_counter <= 0;
      end
      else if (o_sclk && !sclk_r)
      begin
        tx_error_counter <= 0;
      end
      else
      begin
        if (tx_error_cnt_in_progress)
        begin
          tx_error_counter <= tx_error_counter + 1'b1;
        end
      end
    end
  end

  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      rx_error_counter <= 0;
    end
    else
    begin
      if (!i_all_ready)
      begin
        rx_error_counter <= 0;
      end
      else if (o_sclk && !sclk_r)
      begin
        rx_error_counter <= 0;
      end
      else
      begin
        if (rx_error_cnt_in_progress)
        begin
          rx_error_counter <= rx_error_counter + 1'b1;
        end
      end
    end
  end

  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      tx_error_valid <= 0;
      tx_error_valid_r <= 0;
      tx_error <= 0;
      tx_error_adj <= 0;
    end
    else
    begin
      if (tx_sclk_return_rise_r && i_calibrate && i_all_ready)
      begin
        tx_error_valid <= 1;
        tx_error <= tx_error_counter * PERIOD_NS_FNS;
      end

      tx_error_valid_r <= tx_error_valid;

      // Add by half cycle for sampling uncertainty
      tx_error_adj <= tx_error + (PERIOD_NS_FNS >> 1);
    end
  end

  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      rx_error_valid <= 0;
      rx_error_valid_r <= 0;
      rx_error <= 0;
      rx_error_adj <= 0;
    end
    else
    begin
      if (rx_sclk_return_rise_r && i_calibrate && i_all_ready)
      begin
        rx_error_valid <= 1;
        rx_error <= rx_error_counter * PERIOD_NS_FNS;
      end

      rx_error_valid_r <= rx_error_valid;

      // Add by half cycle for sampling uncertainty
      rx_error_adj <= rx_error + (PERIOD_NS_FNS >> 1);
    end
  end

  assign o_tx_error_valid = tx_error_valid_r;
  assign o_rx_error_valid = rx_error_valid_r;

  // Divide round trip latency by 2
  assign o_tx_error = tx_error_adj >> 1;
  assign o_rx_error = rx_error_adj >> 1;

  endmodule : alt_ehipc3_fm_sl_ptp_ckt_cal

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
