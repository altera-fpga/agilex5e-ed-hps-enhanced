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


module altera_xcvr_ical_int_table #( //This module is per channel based
  parameter INT_STEPS = 8
)
(
//interrupt table
output [(INT_STEPS*3-1):0] int_type,
output [(INT_STEPS*16-1):0] int_code,
output [(INT_STEPS*16-1):0] int_data,
output [(INT_STEPS*8-1):0] int_expt

);

`ifdef ALTERA_RESERVED_QIS
  localparam  HW_TEST = 8'h80;
`else
  localparam  HW_TEST = 8'h00;
`endif

   assign  int_type[0 +: 3] = 3'b001; //expect return
   assign  int_code[0 +: 16] = 16'h0002;
   assign  int_data[0 +: 16] = 16'h0125;
   assign  int_expt[0 +: 8] = 8'h02;

   assign  int_type[(1*3) +: 3] = 3'b000;
   assign  int_code[(1*16) +: 16] = 16'h0008;
   assign  int_data[(1*16) +: 16] = 16'h0101;
   assign  int_expt[(1*8) +: 8] = 8'h00;

   assign  int_type[(2*3) +: 3] = 3'b000;
   assign  int_code[(2*16) +: 16] = 16'h000a;
   assign  int_data[(2*16) +: 16] = 16'h0001;
   assign  int_expt[(2*8) +: 8] = 8'h00;

   assign  int_type[(3*3) +: 3] = 3'b001; //expect return
   assign  int_code[(3*16) +: 16] = 16'h0126;
   assign  int_data[(3*16) +: 16] = 16'h0b00;
   assign  int_expt[(3*8) +: 8] = HW_TEST;

   assign  int_type[(4*3) +: 3] = 3'b000;
   assign  int_code[(4*16) +: 16] = 16'h0008;
   assign  int_data[(4*16) +: 16] = 16'h0100;
   assign  int_expt[(4*8) +: 8] = 8'h00;

   assign  int_type[(5*3) +: 3] = 3'b010; //wait for lock2data
   assign  int_code[(5*16) +: 16] = 16'h0002;
   assign  int_data[(5*16) +: 16] = 16'h03ff;
   assign  int_expt[(5*8) +: 8] = 8'h00;

   assign  int_type[(6*3) +: 3] = 3'b000;
   assign  int_code[(6*16) +: 16] = 16'h000a;
   assign  int_data[(6*16) +: 16] = 16'h0001;
   assign  int_expt[(6*8) +: 8] = 8'h00;

   assign  int_type[(7*3) +: 3] = 3'b001;
   assign  int_code[(7*16) +: 16] = 16'h0126;
   assign  int_data[(7*16) +: 16] = 16'h0b00;
   assign  int_expt[(7*8) +: 8] = HW_TEST; // For simulation purpose, vendor's model may NOT support iCal


endmodule
