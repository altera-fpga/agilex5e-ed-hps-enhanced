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
// Filename         : ptp_sticky_register.sv
// Author           : Tholu Kiran Kumar <kktholu@intel.com>
// Created On       : Wed Jun 21/06/2017 02:16:18 PM MYT
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
//
//
//------------------------------------------------------------------------------

`timescale 1ns / 1ns
module alt_ehipc3_fm_sl_ptp_sticky_register (
  input  logic i_clk,
  input  logic i_rst_n,
  input  logic i_set_sticky,
  input  logic i_clear_sticky,
  output logic o_sticky_reg
);

  always @ (posedge i_clk)
  begin
    if (!i_rst_n)
    begin
      o_sticky_reg <= 0;
    end
    else
     begin
       if (i_set_sticky)
       begin
         o_sticky_reg <= 1;
       end
       else
       begin
         if (i_clear_sticky)
         begin
           o_sticky_reg <= 0;
         end
       end
     end
  end

  endmodule : alt_ehipc3_fm_sl_ptp_sticky_register

//============================================================================//
//                           E N D   O F   F I L E                            //
//============================================================================//
