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


//------------------------------------------------------------------------------
//
// Filename         : alt_ehipc3_fm_sl_ptp_sn_clb_pulse.sv
// Author           : Shoaib Sial <shoaib.sial@intel.com>
// Created On       : Wed Sep 11/09/2019
//
//------------------------------------------------------------------------------

module alt_ehipc3_fm_sl_ptp_sn_clb_pulse
(
	input wire 											i_reset_n,
	input wire 											i_clk,
	input wire 											i_all_ready,
	input wire 											i_calibrate,
   input wire [31:0]                         i_apulse_period,

	output wire											o_sclk

);


  reg [19:0] roll_over_count;
  reg        o_roll_over_trig;


  reg   rollover_pulse_minus1 /* synthesis dont_merge */;
  reg   rollover_pulse_minus2 /* synthesis dont_merge */;
  wire  rollover_pulse_minus3;
  wire [19:0] apulse_period_minus_3;
  wire carry;

  assign {carry,apulse_period_minus_3}  = i_apulse_period[19:0] - 2'b11;

  assign rollover_pulse_minus3 = (roll_over_count == apulse_period_minus_3[19:0]) ? 1'b1 :1'b0;

 always@(posedge i_clk)
  begin
      rollover_pulse_minus2 <= rollover_pulse_minus3;
  end

 always@(posedge i_clk)
  begin
      rollover_pulse_minus1 <= rollover_pulse_minus2;
  end


  assign o_sclk = o_roll_over_trig;

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_roll_over_trig <= 1'b0;
    else if (rollover_pulse_minus1)
      o_roll_over_trig <= ~o_roll_over_trig;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      roll_over_count <= 20'd0;
    else if (~i_all_ready || ~i_calibrate)
      roll_over_count <= 20'd0;
    else if (rollover_pulse_minus1)
      roll_over_count <= 20'd0;
    else
      roll_over_count <= roll_over_count + 1'b1;
  end


endmodule //
