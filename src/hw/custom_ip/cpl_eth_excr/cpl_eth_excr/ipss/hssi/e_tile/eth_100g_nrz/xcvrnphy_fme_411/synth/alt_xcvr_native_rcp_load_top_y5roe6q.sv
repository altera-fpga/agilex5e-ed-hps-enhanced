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
// Top-level streamer, containing configuration rom and streamer control block
//**********************************************************************************

`timescale 1 ns / 1 ps



module alt_xcvr_native_rcp_load_top_y5roe6q
import alt_xcvr_native_ical_strm_functions::*;
import alt_xcvr_native_rcp_load_rom_params_y5roe6q::*;

#(
  parameter rcfg_rom_style        = "LOGIC",           //Type of inferred rom ("", "MLAB", or "M20K")
  parameter rcfg_profile_cnt      = 2,                //Number of configuration profiles
  parameter AVMM_ADD_WIDTH        = 19,               //XCVR RCFG address width
  parameter AVMM_DATA_WIDTH       = 8,               //XCVR RCFG address width
  parameter CHANNELS              = 3
)(
  // Clock and reset
  input  wire clk,
  input  wire reset,

  input  [CHANNELS-1:0]                     user_write,
  input  [CHANNELS-1:0]                     user_read ,
  input  [(CHANNELS*AVMM_ADD_WIDTH)-1:0]    user_address  ,
  input  [(CHANNELS*AVMM_DATA_WIDTH)-1:0]   user_writedata ,
  output  [(CHANNELS*AVMM_DATA_WIDTH)-1:0]  user_readdata ,
  output  [CHANNELS-1:0]                    user_waitrequest ,	//output
  // User interfce ports
  input  wire [2:0]  rcp_load_rcp_sel,
  input  wire        rcp_load,
  output wire        rcp_load_busy,
  output wire        rcp_load_finish,
  output wire        rcp_load_timeout,
  output wire[4:0] rcp_load_state,
  output wire[7:0] rcp_load_mail_state,
  output wire[7:0] chnl_id,

  // HSSI Reconfig Interface
  output wire [CHANNELS-1:0]                          avmm_write,
  output wire [CHANNELS-1:0]                          avmm_read,
  output wire [(CHANNELS*AVMM_ADD_WIDTH)-1:0]        avmm_address,
  output wire [(CHANNELS*AVMM_DATA_WIDTH)-1:0]        avmm_writedata,
  input  wire [(CHANNELS*AVMM_DATA_WIDTH)-1:0]        avmm_readdata,
  input  wire [CHANNELS-1:0]                          avmm_waitrequest

);

  localparam ROM_ADD_WIDTH = altera_xcvr_native_s10_functions_h::clogb2_alt_xcvr_native_s10(alt_xcvr_native_rcp_load_rom_params_y5roe6q::rom_depth -1 ); //Maximum ROM address width

  localparam ROM_DATA_WIDTH = alt_xcvr_native_rcp_load_rom_params_y5roe6q::rom_data_width;

  wire [ROM_ADD_WIDTH-1:0]                   rom_address;
  wire [ROM_DATA_WIDTH-1:0]                  rom_readdata;


  reg [CHANNELS-1:0]                          avmm_rcp_write;
  reg [CHANNELS-1:0]                          avmm_rcp_read;
  reg [(CHANNELS*AVMM_ADD_WIDTH)-1:0]         avmm_rcp_address;
  reg [(CHANNELS*AVMM_DATA_WIDTH)-1:0]        avmm_rcp_writedata;
  // Rom to store the recipe
  alt_xcvr_native_rcp_load_rom_y5roe6q #(
    .rcfg_rom_style            (rcfg_rom_style           ),
    .rcfg_profile_cnt          (rcfg_profile_cnt         ),
    .ROM_ADD_WIDTH             (ROM_ADD_WIDTH),
    .ROM_DATA_WIDTH            (ROM_DATA_WIDTH)
  )rom_inst(
    .clk                       (clk                      ),
    .rcp_load_rcp_sel          (rcp_load_rcp_sel         ),
    .addr                      (rom_address              ),
    .data                      (rom_readdata             )
  );

  // Recipe load state machine
  alt_xcvr_native_rcp_load_ctrl_y5roe6q #(
    .ROM_ADD_WIDTH       (ROM_ADD_WIDTH           ),
    .ROM_DATA_WIDTH      (ROM_DATA_WIDTH     ),
    .AVMM_ADD_WIDTH      (AVMM_ADD_WIDTH     ),
    .AVMM_DATA_WIDTH     (AVMM_DATA_WIDTH    ),
    .CHANNELS            (CHANNELS     )
  )ctrl_inst(
    .avmm_clk                       (clk                     ),
    .avmm_reset                     (reset                   ),
    .rcp_load                  (rcp_load                ),
    .rcp_load_busy             (rcp_load_busy           ),
    .rcp_load_finish           (rcp_load_finish         ),
    .rcp_load_timeout          (rcp_load_timeout        ),
    .rcp_load_state            (rcp_load_state          ),
    .rcp_load_mail_state       (rcp_load_mail_state     ),
    .chnl_id                   (chnl_id                 ),
    .rom_address               (rom_address             ),
    .rom_readdata              (rom_readdata            ),
    .avmm_write       (avmm_rcp_write      ),
    .avmm_read        (avmm_rcp_read       ),
    .avmm_address     (avmm_rcp_address    ),
    .avmm_writedata   (avmm_rcp_writedata  ),
    .avmm_readdata    (avmm_readdata   ),
    .avmm_waitrequest (avmm_waitrequest)
  );

assign avmm_write = rcp_load_busy? avmm_rcp_write:user_write;
assign avmm_read  = rcp_load_busy? avmm_rcp_read:user_read;
assign avmm_writedata = rcp_load_busy? avmm_rcp_writedata:user_writedata;
assign avmm_address  = rcp_load_busy? avmm_rcp_address:user_address;
assign user_readdata  = rcp_load_busy? {CHANNELS{8'h00}}: avmm_readdata;
assign user_waitrequest  = rcp_load_busy? {CHANNELS{1'b1}}:avmm_waitrequest;
endmodule
