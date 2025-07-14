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


//**********************************************************************************
// Synchronous ROM for storing multiple configurations
//**********************************************************************************
`timescale 1 ps/1 ps


module alt_xcvr_native_rcp_load_rom_isub23q
import alt_xcvr_native_ical_strm_functions::*;
import alt_xcvr_native_rcp_load_rom_params_isub23q::*;

#(
  parameter rcfg_rom_style   = "LOGIC",           //Type of inferred rom ("", "MLAB", or "M20K")
  parameter rcfg_profile_cnt = 2,                  //Number of configerations in file
  parameter ROM_ADD_WIDTH = 8,
  parameter ROM_DATA_WIDTH= 32
)(
  input  wire                               clk,
  input  wire [2:0]                         rcp_load_rcp_sel, //Selects a recipe
  input  wire [ROM_ADD_WIDTH-1:0]           addr,
  output reg  [ROM_DATA_WIDTH-1:0]          data
);


  localparam rom_addr_width  = altera_xcvr_native_s10_functions_h::clogb2_alt_xcvr_native_s10(alt_xcvr_native_rcp_load_rom_params_isub23q::rom_depth-1); //Calculate address width

  wire [31:0]                rom_addr_long;
  wire [ROM_ADD_WIDTH-1:0]   rom_addr;

  assign rom_addr_long = get_sum(rcp_load_rcp_sel, alt_xcvr_native_rcp_load_rom_params_isub23q::ical_depth_list)  + addr; //Calculate rom address using sum of preceding configuration depths and address within current configuration
  assign rom_addr      = rom_addr_long[ROM_ADD_WIDTH-1:0];        //Truncate rom address to correct width

  (* romstyle = rcfg_rom_style *) reg [ROM_DATA_WIDTH-1:0] rom [0:alt_xcvr_native_rcp_load_rom_params_isub23q::rom_depth-1]; //Inferred rom

  initial begin
    rom = alt_xcvr_native_rcp_load_rom_params_isub23q::config_rom;
  end

  always @ (posedge clk) begin
    data <= rom[rom_addr]; //Synchronously read data from rom
  end


/*
  always @ (posedge clk) begin
if (addr == 0)  data = 32'h8000_1234;
if (addr == 1)  data = 32'h7700_ABCD;
if (addr == 2)  data = 32'hFFFF_FFFF;

end
*/
endmodule
