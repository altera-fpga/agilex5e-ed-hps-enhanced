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


`timescale 1 ps/1 ps

package s10_avmm_h_etile;

  // localparam to define unused bus
  localparam RD_UNUSED                          = 8'h0;

  // localparams for common capability registers
  localparam S10_XR_ADDR_ID_0                   = 10'h0;
  localparam S10_XR_ADDR_ID_1                   = 10'h1;
  localparam S10_XR_ADDR_ID_2                   = 10'h2;
  localparam S10_XR_ADDR_ID_3                   = 10'h3;
  localparam S10_XR_ADDR_STATUS_EN              = 10'h4;
  localparam S10_XR_ADDR_CONTROL_EN             = 10'h5;
  // Reserve Address 10'h6 to 10'hF for common capablities

  // native phy capability
  localparam S10_XR_ADDR_NAT_CHNLS              = 10'h10;
  localparam S10_XR_ADDR_NAT_CHNL_NUM           = 10'h11;
  localparam S10_XR_ADDR_NAT_DUPLEX             = 10'h12;
  localparam S10_XR_ADDR_NAT_DUAL_CHNL          = 10'h13;
  localparam S10_XR_ADDR_NAT_DUAL_CHNL_MASTER   = 10'h14;

  // localparams for csr for lock to ref and lock to data
  localparam S10_XR_ADDR_GP_RD_LTR              = 10'h80;
  localparam S10_XR_OFFSET_RD_LTD               = 0;
  localparam S10_XR_OFFSET_LTR_UNUSED           = 1;
  localparam S10_XR_LTR_UNUSED_LEN              = 7;

  // localparam for reading the stat signals from the resets
  localparam S10_XR_ADDR_GP_RD_CHNL_STATUS      = 10'h81;
  localparam S10_XR_OFFSET_TX_RST_READY         = 0;
  localparam S10_XR_OFFSET_RX_RST_READY         = 1;
  localparam S10_XR_OFFSET_CHNL_STATUS_UNUSED   = 2;
  localparam S10_XR_RST_CHNL_STATUS_UNUSED_LEN  = 6;

  // localparam for reading the stat signals from the AIB for transfer ready
  localparam S10_XR_ADDR_XFER_STATUS            = 10'h82;
  localparam S10_XR_OFFSET_TX_XFER_READY        = 0;
  localparam S10_XR_OFFSET_RX_XFER_READY        = 1;
  localparam S10_XR_OFFSET_XFER_STATUS_UNUSED   = 2;
  localparam S10_XR_XFER_STATUS_UNUSED_LEN      = 6;

  // localparams for setting channel resets
  localparam S10_XR_ADDR_CHNL_RESET             = 10'hE2;
  localparam S10_XR_OFFSET_RX_ANA               = 0;
  localparam S10_XR_OFFSET_RX_DIG               = 1;
  localparam S10_XR_OFFSET_TX_ANA               = 2;
  localparam S10_XR_OFFSET_TX_DIG               = 3;
  localparam S10_XR_OFFSET_RX_ANA_OVR           = 4;
  localparam S10_XR_OFFSET_RX_DIG_OVR           = 5;
  localparam S10_XR_OFFSET_TX_ANA_OVR           = 6;
  localparam S10_XR_OFFSET_TX_DIG_OVR           = 7;

  // localparam for reading the stat signals from the resets
  localparam S10_XR_ADDR_CHNL_TX_RESET_CTRL     = 10'hE3;
  localparam S10_XR_OFFSET_TX_RESET             = 0;
  localparam S10_XR_OFFSET_TX_RESET_OVERRIDE    = 1;
  localparam S10_XR_OFFSET_TX_RESET_REQ         = 2;
  localparam S10_XR_OFFSET_TX_RESET_ACK         = 3;
  localparam S10_XR_OFFSET_TX_RESET_STAT        = 4;
  localparam S10_XR_OFFSET_TX_RESET_TIMEOUT     = 5;
  localparam S10_XR_OFFSET_TX_RESET_CTRL_UNUSED = 6;
  localparam S10_XR_TX_RESET_CTRL_UNUSED_LEN    = 2;

  // localparam for reading the stat signals from the resets
  localparam S10_XR_ADDR_CHNL_RX_RESET_CTRL     = 10'hE4;
  localparam S10_XR_OFFSET_RX_RESET             = 0;
  localparam S10_XR_OFFSET_RX_RESET_OVERRIDE    = 1;
  localparam S10_XR_OFFSET_RX_RESET_REQ         = 2;
  localparam S10_XR_OFFSET_RX_RESET_ACK         = 3;
  localparam S10_XR_OFFSET_RX_RESET_STAT        = 4;
  localparam S10_XR_OFFSET_RX_RESET_TIMEOUT     = 5;
  localparam S10_XR_OFFSET_RX_RESET_CTRL_UNUSED = 6;
  localparam S10_XR_RX_RESET_CTRL_UNUSED_LEN    = 2;

  // localparams for embedded reconfig addresses
  // Control reg and offsets
  localparam S10_XR_ADDR_EMBED_RCFG_CTRL        = 10'h140;
  localparam S10_XR_OFFSET_EMBED_RCFG_CFG_SEL   = 0;
  localparam S10_XR_EMBED_RCFG_CFG_SEL_LEN      = 6; //bits [5:0] are alloted for cfg_sel even though GUI currently only supports upto 8 profiles.

  localparam S10_XR_OFFSET_EMBED_RCFG_BCAST_EN  = 6;
  localparam S10_XR_OFFSET_EMBED_RCFG_CFG_LOAD  = 7;

  // Status reg and offsets
  localparam S10_XR_ADDR_EMBED_RCFG_STATUS      = 10'h141;
  localparam S10_XR_OFFSET_EMBED_RCFG_STRM_BUSY = 0;



  // localparams for iCal/pCal recipe addresses
  // Control reg and offsets
  localparam S10_XR_ADDR_RCP_LOAD_CTRL        = 10'h143;
  localparam S10_XR_OFFSET_RCP_LOAD_CFG_SEL   = 0;
  //localparam S10_XR_OFFSET_RCP_LOAD_BCAST  = 6;
  localparam S10_XR_OFFSET_RCP_LOAD  = 7;
  localparam S10_XR_RCP_LOAD_CTRL_UNUSED_LEN = 4; //bits [6:3] are unused

  // Recipe Load Status reg and offsets
  localparam S10_XR_ADDR_RCP_LOAD_STATUS      = 10'h144;
  localparam S10_XR_OFFSET_RCP_LOAD_FINISH = 0;
  localparam S10_XR_OFFSET_RCP_LOAD_TIMEOUT = 1;
  localparam S10_XR_OFFSET_RCP_LOAD_BUSY = 2;
  localparam S10_XR_OFFSET_RCP_LOAD_STATE = 3;
  localparam S10_XR_ADDR_RCP_LOAD_MAIL_STATUS      = 10'h145;
  localparam S10_XR_ADDR_RCP_CHNL_ID               = 10'h146;

  //iCal user request
  localparam S10_XR_ADDR_USR_ICAL_REQ      = 10'h200;
  localparam S10_XR_OFFSET_USR_ICAL_REQ = 0;

  //iCal state machine
  localparam S10_XR_ADDR_ICAL_CUR_STATE      = 10'h201;
  localparam S10_XR_OFFSET_ICAL_CUR_STATE    = 0;

  //iCal Status
  localparam S10_XR_ADDR_ICAL_STATUS         = 10'h202;
  localparam S10_XR_OFFSET_ICAL_FINISH       = 0;
  localparam S10_XR_OFFSET_ICAL_TIMEOUT      = 1;
  localparam S10_XR_OFFSET_ICAL_IN_PROGRESS  = 2;

  //interrupt state machine
  localparam S10_XR_ADDR_INTRPT_CUR_STATE      = 10'h203;
  localparam S10_XR_OFFSET_INTRPT_CUR_STATE = 0;

  //rx de-skew
  localparam S10_XR_ADDR_RX_DSKW_DUAL_CHNL     = 10'h300;



endpackage
