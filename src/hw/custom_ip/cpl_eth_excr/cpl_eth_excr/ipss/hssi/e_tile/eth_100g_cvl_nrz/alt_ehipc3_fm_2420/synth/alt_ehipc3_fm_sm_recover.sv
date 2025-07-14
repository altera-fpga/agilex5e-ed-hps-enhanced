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

module alt_ehipc3_fm_sm_recover #( SWIDTH = 8)
(
 input 	clk,
 input 	rst_n,
 input [SWIDTH-1:0] state,
 output reg error
 );

   logic     error_comb;
   logic [$clog2(SWIDTH)-1:0] sum;



   always_comb
     begin
	sum = '0;
	for(integer n=0;n<SWIDTH;n++) begin:compress
	   sum = (state[n])? sum + 1'b1 : sum;
	end:compress

	error_comb = sum != 1;
     end


   always_ff @(posedge clk)
     begin
	if (~rst_n)
	  error <= 1'b0;
	else
	  error <= error_comb;
     end


endmodule // alt_ehipc3_fm_sm_recover
