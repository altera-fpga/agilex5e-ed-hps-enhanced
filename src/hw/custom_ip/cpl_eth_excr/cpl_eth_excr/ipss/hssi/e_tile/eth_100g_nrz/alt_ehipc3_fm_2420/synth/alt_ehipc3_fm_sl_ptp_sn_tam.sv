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
// Filename         : alt_ehipc3_fm_sl_ptp_sn_tam.sv
// Author           : Shoaib Sial <shoaib.sial@intel.com>
// Created On       : Wed Sep 11/09/2019
//
//------------------------------------------------------------------------------

module alt_ehipc3_fm_sl_ptp_sn_tam
(
	input wire 											i_reset_n,
	input wire 											i_clk,
	input wire      [31:0]	     								        i_sn_pll_sclk_period,
	input wire      [31:0]	     								        i_apulse_cnt_pow2,
	input wire 											i_measure_done,
	input wire	[31:0]								                i_counter,
	output reg											o_measure_done,
	output wire	[31:0]								                o_tam_adjust_avg

);



//  localparam PLL_CLK_PERIOD_f16 = 20'h40000;  //4ns
//  localparam PLL_CLK_PERIOD_f16 = 20'h8C000;  //8.75ns


  wire  [31:0] div_mul_f16  /* synthesis keep */;
  reg   [39:0] average_result  /* synthesis preserve */;
  reg   [31:0] tam_adjust_avg  /* synthesis preserve */;
  reg          measure_done_r;

//  assign div_mul_f16 = i_sn_pll_sclk_period >> i_apulse_cnt_pow2;
  assign div_mul_f16 =  i_apulse_cnt_pow2;

  always @ (posedge i_clk) begin
    average_result  <= i_counter[19:0] * div_mul_f16[19:0]; //
  end

  always@(posedge i_clk)
  begin
  /*  if(!i_reset_n)
      tam_adjust_avg <= 32'd0;
    else*/ if (measure_done_r)
      tam_adjust_avg <= average_result[31:0];
  end
  assign o_tam_adjust_avg = tam_adjust_avg;

  always @ (posedge i_clk) begin
    measure_done_r  <= i_measure_done; //
    o_measure_done  <= measure_done_r; //
  end


endmodule //
