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


//Simple TX Deskew moule
// This module generates a pulse after 30 clocks
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module alt_ehipc3_fm_tx_deskew
  #(parameter LANES = 1)
   (
    input wire 	     i_resetn,
    input wire 	     i_clk,
    output reg [LANES-1:0] o_dsk
    );


   reg [4:0] 		dsk_cnt = 5'd0;

   always @(posedge i_clk)
     begin
	if (~i_resetn)
	  begin
	     o_dsk <= ({LANES{1'b0}});
	     dsk_cnt <= 5'd0;
	  end
	else
	  begin
	     if (dsk_cnt == 5'd30)
	       begin
		  o_dsk <= ({LANES{1'b1}});
		  dsk_cnt <= 5'd0;
	       end
	     else
	       begin
		  o_dsk <= ({LANES{1'b0}});
		  dsk_cnt <= dsk_cnt+1'b1;
	       end
	  end // else: !if(~i_csr_rst_n)
     end // always @ (negedge i_resetn or posedge i_clk)

endmodule // alt_ehipc3_fm_tx_deskew
