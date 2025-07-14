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
module alt_ehipc3_fm_sl_ptp_ts_converter_sn (
    input  logic        i_clk,
    input  logic        i_tx_rst_n,
    input  logic        i_rx_rst_n,
    input  logic        i_txx_clk,
    input  logic        i_rxx_clk,
    input  logic        i_txx_arst_n,
    input  logic        i_rxx_arst_n,
    input  logic	      i_tx_arst,
    input  logic	      i_rx_arst,

    input  logic        i_ptp_tx_ts_valid,
    input  logic [11:0] i_ptp_tx_ts,
    input  logic [1:0]  i_ptp_tx_fp,

    input  logic        i_rx_valid,
    input  logic        i_rx_inframe,
    input  logic [20:0] i_ptp_rx_ts,

    input  logic        i_ts_format,
    input  logic [95:0] i_tx_tod,
    input  logic [95:0] i_rx_tod,

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

  logic        tod_tx_ptp_cc_valid;
  logic        tod_tx_ptp_cc_valid_1s;
  logic [3:0]  tod_tx_ptp_47_44_cc;
  logic [47:0] tod_tx_ptp_95_48_cc;
  logic [3:0]  tod_tx_ptp_47_44_l;
  logic [47:0] tod_tx_ptp_95_48_l;
  logic [3:0]  tod_tx_ptp_47_44;
  logic [47:0] tod_tx_ptp_95_48;
  logic        tod_rx_ptp_cc_valid_1s;
  logic [35:0] tod_rx_ptp_83_48_cc;
  logic [11:0] tod_rx_ptp_95_84_cc;
  logic [35:0] tod_rx_ptp_83_48;
  logic [11:0] tod_rx_ptp_95_84;
  logic [47:0] tod_95_48;
  logic [48:0] tod_95_48_plus_one;
  logic [48:0] tod_95_48_minus_one;
  logic [11:0] tod_95_84;
  logic [12:0] tod_95_84_plus_one;
  logic [12:0] tod_95_84_minus_one;

  logic        ptp_tx_ts_valid_1s;
  logic        ptp_tx_ts_valid_r;
  logic        ptp_tx_ts_valid_rr;
  logic [11:0] ptp_tx_ts_r;
  logic [1:0]  ptp_tx_fp_r;

  assign ets_counter_plus_one = ets_counter + 1'b1;

  always @ (posedge i_clk)
  begin
    if (!i_tx_rst_n)
    begin
      ptp_tx_ts_valid_r  <= 0;
      ptp_tx_ts_valid_rr <= 0;

    end
    else begin
      ptp_tx_ts_valid_r <= i_ptp_tx_ts_valid;
      ptp_tx_ts_valid_rr <= ptp_tx_ts_valid_r;
      ptp_tx_ts_r       <= i_ptp_tx_ts;
      ptp_tx_fp_r       <= i_ptp_tx_fp;
    end
  end
    assign ptp_tx_ts_valid_1s = ~ptp_tx_ts_valid_rr && ptp_tx_ts_valid_r;

  always @ (posedge i_clk)
  begin
    if (!i_tx_rst_n)
    begin

      ets_counter <= 0;
      ets_fp <= 0;
      o_ptp_ets_valid <= 0;
    end
    else
    begin
      if (ptp_tx_ts_valid_r)
      begin
        ets <= {ets[35:0], ptp_tx_ts_r};
        ets_fp <= {ets_fp[5:0],ptp_tx_fp_r};
        ets_counter <= ets_counter_plus_one[1:0];
      end
      else
      begin
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

//      tx_ets_rollover <= (i_tod[47:44] == BILLION[31:28]) && !(|ets[35:32]);
      tx_ets_rollover <= (tod_tx_ptp_47_44 == BILLION[31:28]) && !(|ets[35:32]);

  end

  // Assumption:
  //    1. There is no large load adjustment done to i_tod
  //    2. i_tod is larger than ets (unlikely happen on TX)
  // When i_tod upper ns field is all zero, while ets upper ns field equal to billion upper ns field, rollover happen
  //assign tx_tod_rollover = !(|i_tod[47:44]) && (ets[47:44] == BILLION[31:28]);
//  assign tx_tod_rollover = 1'b0;
  assign tx_tod_rollover = !(|tod_tx_ptp_47_44) && (ets[47:44] == BILLION[31:28]);

/*
  always @ (posedge i_clk)
  begin
    if (!i_tx_rst_n)
    begin
      tod_95_48           <= 48'h0;
      tod_95_48_plus_one  <= 49'h0;
      tod_95_48_minus_one <= 49'h0;
    end
    else
    begin
      tod_95_48           <= i_tod[95:48];
      tod_95_48_plus_one  <= i_tod[95:48] + 1'b1;
      tod_95_48_minus_one <= i_tod[95:48] - 1'b1;
    end
  end
*/
  assign o_ptp_ets = tx_ets_rollover? {tod_95_48_plus_one[47:0],ets[47:0]}:
                     tx_tod_rollover? {tod_95_48_minus_one[47:0],ets[47:0]}:
                                      {tod_95_48[47:0],ets[47:0]};
  assign o_ptp_ets_fp = ets_fp;

/////////////


        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (52),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) sync_tod_tx_2ptp_icc (
            .in_clk                 (i_txx_clk),
            .in_reset               (!i_txx_arst_n),
            .in_ready               (),
            .in_valid               (1'b1),
            .in_data                (i_tx_tod[95:44]),
            .out_clk                (i_clk),
            .out_reset              (i_tx_arst),
            .out_ready              (!i_tx_arst),

            .out_valid              (tod_tx_ptp_cc_valid_1s),
            .out_data               ({tod_tx_ptp_95_48_cc, tod_tx_ptp_47_44_cc})
        );


  always@(posedge i_clk)
  begin

    if (tod_tx_ptp_cc_valid_1s)
    begin
      tod_tx_ptp_47_44_l <= tod_tx_ptp_47_44_cc;
      tod_tx_ptp_95_48_l <= tod_tx_ptp_95_48_cc;
    end
  end

  always@(posedge i_clk)
  begin

    if (ptp_tx_ts_valid_1s)
    begin
      tod_tx_ptp_47_44 <= tod_tx_ptp_47_44_l;
      tod_tx_ptp_95_48 <= tod_tx_ptp_95_48_l;
    end
  end

/*

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (4),
        .INIT_VALUE         (0)
    ) sync_tod_txl_2ptp (
        .clk                (i_clk),
        .reset              (1'b0),
        .d                  (i_tx_tod[47:44]),
        .q                  (tod_tx_ptp_47_44)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (48),
        .INIT_VALUE         (0)
    ) sync_tod_txh_2ptp (
        .clk                (i_clk),
        .reset              (1'b0),
        .d                  (i_tx_tod[95:48]),
        .q                  (tod_tx_ptp_95_48)
    );
*/
  always @ (posedge i_clk)
  begin

      tod_95_48           <= tod_tx_ptp_95_48;
      tod_95_48_plus_one  <= tod_tx_ptp_95_48 + 1'b1;
      tod_95_48_minus_one <= tod_tx_ptp_95_48 - 1'b1;

  end


////////////

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
    if (!i_rx_rst_n)
    begin
      its <= 0;
    end
    else
    begin
      if (i_rx_valid && ((|its_in_progress[2:0]) || rx_sop))
      begin
        its <= {its[62:0],i_ptp_rx_ts};
      end
    end
  end

  // Assumption:
  //    1. There is no large load adjustment done to i_tod
  //    2. i_tod is larger than its
  // When i_tod[83:48] second field is all zero, while its[83:48] second field is all one, rollover happen
  always @ (posedge i_clk)
  begin
    if (!i_rx_rst_n)
    begin
      rx_tod_rollover <= 1'b0;
    end
    else
    begin
      if (its_in_progress[2])
      begin
       // rx_tod_rollover <= !(|i_tod[83:48]) && (&its[62:27]);
        rx_tod_rollover <= !(|tod_rx_ptp_83_48) && (&its[62:27]);
      end
    end
  end

  // Assumption:
  //    1. There is no large load adjustment done to i_tod
  //    2. i_tod is smaller than its (unlikely happen on RX)
  // When its[83:48] second field is all zero, while i_tod[83:48] second field is all one, rollover happen
  //assign rx_its_rollover = (&i_tod[83:48]) && !(|its[83:48]);
  assign rx_its_rollover = 1'b0;
/*
  always @ (posedge i_clk)
  begin
    if (!i_rx_rst_n)
    begin
      tod_95_84           <= 12'h0;
      tod_95_84_plus_one  <= 13'h0;
      tod_95_84_minus_one <= 13'h0;
    end
    else
    begin
      tod_95_84           <= i_tod[95:84];
      tod_95_84_plus_one  <= i_tod[95:84] + 1'b1;
      tod_95_84_minus_one <= i_tod[95:84] - 1'b1;
    end
  end
*/

/////////////

        alt_ehipc3_fm_clock_crosser #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (48),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) sync_tod_rx_2ptp_icc (
            .in_clk                 (i_rxx_clk),
            .in_reset               (!i_rxx_arst_n),
            .in_ready               (),
            .in_valid               (1'b1),
            .in_data                (i_rx_tod[95:48]),
            .out_clk                (i_clk),
            .out_reset              (i_rx_arst),
            .out_ready              (!i_rx_arst),

            .out_valid              (tod_rx_ptp_cc_valid_1s),
            .out_data               ({tod_rx_ptp_95_84_cc, tod_rx_ptp_83_48_cc})
        );


  always@(posedge i_clk)
  begin
    if (tod_rx_ptp_cc_valid_1s)
    begin
      tod_rx_ptp_83_48 <= tod_rx_ptp_83_48_cc;
      tod_rx_ptp_95_84 <= tod_rx_ptp_95_84_cc;
    end
  end


/*

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (36),
        .INIT_VALUE         (0)
    ) sync_tod_rxl_2ptp (
        .clk                (i_clk),
        .reset              (1'b0),
        .d                  (i_rx_tod[83:48]),
        .q                  (tod_rx_ptp_83_48)
    );

    alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH  (3),
        .WIDTH              (12),
        .INIT_VALUE         (0)
    ) sync_tod_rxh_2ptp (
        .clk                (i_clk),
        .reset              (1'b0),
        .d                  (i_rx_tod[95:84]),
        .q                  (tod_rx_ptp_95_84)
    );
*/

  always @ (posedge i_clk)
  begin
      if (its_in_progress[2])
      begin
        tod_95_84           <= tod_rx_ptp_95_84;
        tod_95_84_plus_one  <= tod_rx_ptp_95_84 + 1'b1;
        tod_95_84_minus_one <= tod_rx_ptp_95_84 - 1'b1;
      end
  end

////////////

  assign o_ptp_rx_its = rx_tod_rollover? {tod_95_84_minus_one[11:0], its}:
                        rx_its_rollover? {tod_95_84_plus_one[11:0], its}:
                                         {tod_95_84[11:0], its};
  assign o_ptp_rx_its_valid = its_in_progress[3] && i_rx_valid;

endmodule : alt_ehipc3_fm_sl_ptp_ts_converter_sn

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
