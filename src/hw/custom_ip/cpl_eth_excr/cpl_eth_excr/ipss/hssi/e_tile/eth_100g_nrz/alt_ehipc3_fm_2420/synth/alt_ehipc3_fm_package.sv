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


//-----------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Copyright © 2015 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//-----------------------------------------------------------------------------
//  Project Name:  ehip
//  Author      :  ngulston
//  Date        :
//-----------------------------------------------------------------------------
//Description:
//  This is a package for the EHIP design. It contains declarations for the
//  shared constants, shared data types, and shared functions used in the
//  design
//
//-----------------------------------------------------------------------------
//Package Declaration
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

package alt_ehipc3_fm_package;

//-----------------------------------------------------------------------------
//Shared Parameters

    localparam  EHP_TARGET_CHIP     =   2;
    localparam  EHP_REVID           =   32'h10142016;   //Rev ID is the date of the MS3.0 Release
    localparam  EHP_BASE_RXMAC      =   5;
    localparam  EHP_BASE_RXSTAT     =   7;
    localparam  EHP_ERRORBITWIDTH   =   11;
    localparam  EHP_STATSBITWIDTH   =   32;
    localparam  EHP_RXERRWIDTH      =   6;
    localparam  EHP_RXSTATUSWIDTH   =   3;
    localparam  EHP_WORDS           =   3'd4;   //WORDS in ehip_core
    localparam  EHP_STWORDS         =   3'd2;   //RX status words in ehip core
    localparam  EHP_LANES           =   3'd6;
    localparam  EHP_STAT_ACCUM_WIDTH=   16;
    localparam  EHP_STAT_NUMCOUNTS  =   3;
    localparam  EHP_STAT_CINNUM     =   36; // Should be = ehip_cfgcsr_package::STATS_TOTAL_NUM
    localparam  EHP_PREAMBLE        =   64'hfb555555555555d5;
    localparam  EHP_PMA_WIDTH       =   66;
    localparam  EHP_PCS_DWIDTH      =   256;
    localparam  EHP_PCS_CWIDTH      =   32;
    localparam  EHP_MAC_WIDTH       =   64;
    localparam  EHP_PLD_WIDTH       =   78;
    localparam  EHP_FEC_WIDTH       =   264;
    localparam  EHP_AIB_WIDTH       =   78;
    localparam  EHP_DSK_WIDTH       =   EHP_AIB_WIDTH-1;
    localparam  EHP_BLK_WIDTH       =   66;
    localparam  EHP_VL_DATA_W       =   36;

    //tx_ptp_status.ts_method settings
    localparam  EHP_PTP_1STEP       =   1'b0;
    localparam  EHP_PTP_2STEP       =   1'b1;

    //Localparams for indexing stats count arrays
    localparam  SCNT_FRAME_OCTETS   =   0;
    localparam  SCNT_MII_ERRORS     =   1;
    localparam  SCNT_PACKET_OCTETS  =   2;

    //Status bus encodings
    localparam  STATBUS_FC          =   3'd7;
    localparam  STATBUS_ILL_ETHTYPE =   3'd6;
    localparam  STATBUS_SVLAN       =   3'd5;
    localparam  STATBUS_VLAN        =   3'd4;
    localparam  STATBUS_PFC         =   3'd3;
    localparam  STATBUS_SFC         =   3'd2;
    localparam  STATBUS_CTRL        =   3'd1;
    localparam  STATBUS_NONE        =   3'd0;

    //Ethertype encodings
    localparam  TYPE_FC             =   16'h8808;
    localparam  TYPE_VLAN1          =   16'h8100;
    localparam  TYPE_VLAN2          =   16'h88A8;
    localparam  TYPE_VLAN3          =   16'h88F5;
    localparam  TYPE_VLAN4          =   16'h9100;
    localparam  TYPE_VLAN5          =   16'h9200;
    localparam  TYPE_PTP            =   16'h88F7;
    localparam  TYPE_SFC_FULL       =   16'h0001;
    localparam  TYPE_PFC_FULL       =   16'h0101;
    localparam  TYPE_SFC            =   1'b0;   //Full code is 0001
    localparam  TYPE_PFC            =   1'b1;   //Full code is 0101

    //Error bus encodings
    localparam  ERRBUS_LENGTH       =   2'd3;
    localparam  ERRBUS_SIZE         =   2'd2;
    localparam  ERRBUS_MALFORMED    =   2'd1;
    localparam  ERRBUS_NONE         =   2'd0;

    //Encoding for the Interpacket gap CSR
    localparam  IPG_12  =   2'd0;
    localparam  IPG_10  =   2'd1;
    localparam  IPG_8   =   2'd2;
    localparam  IPG_1   =   2'd3;

    //Encodings for rx and tx pld ehip modes
    localparam  EHIP_MODE_SEL_MAC       =   3'h0;
    localparam  EHIP_MODE_SEL_PTP       =   3'h1;
    localparam  EHIP_MODE_SEL_PCS       =   3'h2;
    localparam  EHIP_MODE_SEL_OTN       =   3'h3; //Same as PCS66, except in PCS
    localparam  EHIP_MODE_SEL_PCS66     =   3'h4;
    localparam  EHIP_MODE_SEL_AN        =   3'h5;
    localparam  EHIP_MODE_SEL_PTP_ONLY  =   3'h6;

    //Encoding for tx_dsk_status output
    localparam  EHP_TX_DSK_STATUS_ERROR =   3'd7;

    //Encodings for phy_ehip_pcs_modes.select_tx_am and
    //phy_ehip_pcs_modes.select_rx_am
    localparam  EHP_SEL_100G_AMS    =   1'b1;
    localparam  EHP_SEL_40G_AMS     =   1'b0;

    //MII Codes for PCS and MAC
    localparam  MII_IDLE            =   8'h7;     // I
    localparam  MII_START           =   8'hfb;    // S
    localparam  MII_TERMINATE       =   8'hfd;    // T
    localparam  MII_ERROR           =   8'hfe;    // E
    localparam  MII_SEQ_ORDERED     =   8'h9c;    // Q aka O, used for LF/RF
    localparam  MII_SIG_ORDERED     =   8'h5c;    // Fsig aka O
    localparam  MII_SFD             =   8'hd5;    // Start frame delimiter
    localparam  MII_PREAMBLE        =   8'h55;    // Single preamble byte
    localparam  MII_D_PREAMBLE      =   {MII_SFD,{7{MII_PREAMBLE}}}; //Preamble, in MII order

    //PCS66 Codes for PCS
    localparam  PCS66_IDLE          =   {56'd0,8'h1e,2'h1}; //66b encoded IDLE block

    //ehip_fec_distribution cfg_sel_multilane settings
    localparam  EHP_USE_SL          =   2'd0;   //Use single lane cores
    localparam  EHP_USE_ML          =   2'd1;   //Use multilane core
    localparam  EHP_USE_SLMLMUX     =   2'd2;   //Let the user controlled mux decide

    //TX Flow Regulator control contants
    localparam  EHP_RATE_100G   =   3'd0;
    localparam  EHP_RATE_50G    =   3'd1;
    localparam  EHP_RATE_40G    =   3'd2;
    localparam  EHP_RATE_25G    =   3'd3;
    localparam  EHP_RATE_10G    =   3'd4;
    localparam  EHP_RATE_CUSTOM =   3'd7;

    //Port Widths
    localparam  EPRT_W_PTP_CHAN             =   39; //Half an AIB channel
    localparam  EPRT_W_PTP_INS_TYPE         =   3;  //per lane
    localparam  EPRT_W_PTP_BYTE_OFFSET      =   3;  //per lane
    localparam  EPRT_W_PTP_TX_FP            =   2;  //per lane
    localparam  EPRT_W_PTP_TS               =   24; //per lane

    //Pin position parameter. These must match the mapping spreadsheet
    localparam  EPRT_PTP_TOD_UPDATE         =   35;
    localparam  EPRT_PTP_TS_INIT_TOD        =   57;
    localparam  EPRT_PTP_TS                 =   8;
    localparam  EPRT_PTP_INS_TYPE           =   0;
    localparam  EPRT_PTP_BYTE_OFFSET        =   3;
    localparam  EPRT_PTP_TX_FP              =   6;
    localparam  EPRT_TX_AM_VALID            =   73;
    localparam  EPRT_TX_VALID               =   72;
    localparam  EPRT_STATS_SNAPSHOT         =   76;
    localparam  EPRT_TX_MAC_DATA            =   0;
    localparam  EPRT_TX_ERROR               =   64;
    localparam  EPRT_TX_EOP_EMPTY           =   66;
    localparam  EPRT_TX_INFRAME             =   69;
    localparam  EPRT_TX_SKIP_CRC            =   70;
    localparam  EPRT_RX_DATA                =   0;
    localparam  EPRT_RX_FCS_ERROR           =   64;
    localparam  EPRT_RX_VALID               =   72;
    localparam  EPRT_RX_AM_VALID            =   73;
    localparam  EPRT_RX_EOP_EMPTY           =   65;
    localparam  EPRT_RX_INFRAME             =   71;
    localparam  EPRT_RX_ERROR               =   73;
    localparam  EPRT_RX_STATUS              =   68;
    localparam  EPRT_RXPCS_INTERR           =   76;
    localparam  EPRT_RX_PAUSE               =   142;
    localparam  EPRT_RX_PFC0                =   146;
    localparam  EPRT_RX_PFC1                =   147;
    localparam  EPRT_RX_PFC2                =   148;
    localparam  EPRT_RX_PFC3                =   150;
    localparam  EPRT_RX_PFC4                =   151;
    localparam  EPRT_RX_PFC5                =   152;
    localparam  EPRT_RX_PFC6                =   153;
    localparam  EPRT_RX_PFC7                =   154;
    localparam  EPRT_TX_READY               =   75;
    localparam  EPRT_DESKEW                 =   77;
    localparam  EPRT_TX_PAUSE               =   65;
    localparam  EPRT_TX_PFC0                =   71;
    localparam  EPRT_TX_PFC1                =   73;
    localparam  EPRT_TX_PFC2                =   75;
    localparam  EPRT_TX_PFC3                =   150;
    localparam  EPRT_TX_PFC4                =   151;
    localparam  EPRT_TX_PFC5                =   152;
    localparam  EPRT_TX_PFC6                =   153;
    localparam  EPRT_TX_PFC7                =   154;
    localparam  EPRT_CUSTOM_CADENCE         =   74;
    localparam  EPRT_TX_TESTBUS_SEL         =   344;
    localparam  EPRT_TX_TESTBUS_SOURCE      =   383;
    localparam  EPRT_TX_TESTBUS_EN          =   386;
    localparam  EPRT_TX_READ_PTP_VL_DATA    =   422;
    localparam  EPRT_TX_SELECT_PTP_VL_DATA  =   423;

    //Ports that don't go through the PLD FIFO are reused
    localparam  EPRT_SOP                    =   EPRT_CUSTOM_CADENCE;
    localparam  EPRT_EOP                    =   EPRT_STATS_SNAPSHOT;

    //CSR position decode for flow control
    localparam  EHP_SFC_BIT                 =   8;

    //Selections for rxpldmux_sel
    localparam  RXPLDMUX_RXMAC          =   3'd0;
    localparam  RXPLDMUX_RXPCS          =   3'd1;
    localparam  RXPLDMUX_RXFEC          =   3'd2;   //Reserved, don't use
    localparam  RXPLDMUX_RXPMA          =   3'd3;   //Reserved, don't use
    localparam  RXPLDMUX_TXFEC          =   3'd4;   //Reserved, don't use
    localparam  RXPLDMUX_TXPCS          =   3'd5;
    localparam  RXPLDMUX_TXMAC          =   3'd6;
    localparam  RXPLDMUX_TXAIB          =   3'd7;

    //Encodings for blk_type/enc_dout_type
    // for use in RTYPE classification
    localparam BLK_TYPE_START    = 3'h0;
    localparam BLK_TYPE_DATA     = 3'h1;
    localparam BLK_TYPE_ORDSET   = 3'h2;
    localparam BLK_TYPE_TERM     = 3'h3;
    localparam BLK_TYPE_CONTROL  = 3'h4;
    localparam BLK_TYPE_ERROR    = 3'h5;

    //enc_dout encodings
    localparam  BLK_CTRL  = 8'h1e,
                BLK_START = 8'h78,
                BLK_OS    = 8'h4b,
                BLK_TERM0 = 8'h87,
                BLK_TERM1 = 8'h99,
                BLK_TERM2 = 8'haa,
                BLK_TERM3 = 8'hb4,
                BLK_TERM4 = 8'hcc,
                BLK_TERM5 = 8'hd2,
                BLK_TERM6 = 8'he1,
                BLK_TERM7 = 8'hff;

    localparam LBLOCK_T = {64'h0000_0001_0000_4B,2'b01};    // ord set Local Fault block
    localparam EBLOCK_T = {{8{7'h1e}},8'h1E,2'b01};         // Error Block
    localparam IBLOCK_T = {{8{7'h00}},BLK_CTRL,2'b01};      // Idle Block

//-----------------------------------------------------------------------------
//Data types

    //Stats increment vector
    typedef logic   [EHP_STAT_CINNUM-1:0]  t_stats_inc;

    //Segmented bus type; use this for data flowing on segmented buses
    typedef struct packed {
        logic   [63:0]  data;
        logic           inframe;
        logic   [2:0]   eop_empty;
        logic           mii_err;
        logic           mii_sop_err;
    } t_sbus;

    //MII word type; use this for each mii word
    typedef struct packed {
        logic   [63:0]      d;
        logic   [7:0]       c;
    } t_mii;

    //MII bus type; use this for data flowing on mii buses
    typedef struct packed {
        t_mii       [EHP_WORDS-1:0] words;
        logic                       valid;
    } t_mii_bus;

    //Framebus
    typedef struct packed {
        logic   [64-1:0]  data;
        logic             sop;
        logic   [8-1:0]   eop;
    } t_frmbus;

    //Frame size type; use this type to store frame sizes
    typedef logic   [15:0]          t_framesize ;

    //Use one extra bit for storing packet sizes
    typedef logic   [16:0]          t_packetsize;

    //Data type to store quanta value
    typedef logic   [15:0]          t_quanta;

    //VLAN Ethertype; use this type to store VLAN Ethertype
    typedef struct packed {
        logic           en;
        logic   [15:0]  etype;
    } t_vlan_etype;


    //Type for extracting header fields
    typedef struct packed {
        logic   [6*8-1:0]           daddr;
        logic                       multi;
        logic   [2*8-1:0]           tl;     //Type/length field
        logic   [2*8-1:0]           fctype; //Flow control type
        logic   [2*8-1:0]           vltl;
        logic   [2*8-1:0]           vlfctype;
        logic   [2*8-1:0]           svtl;
        logic   [2*8-1:0]           svfctype;
    } t_frm_flds;


    //Decode type; use this for moving decode data in the header processor
    typedef struct packed {
        logic                       bcast;
        logic                       mcast;
        logic                       ucast;
        logic                       fc_addr;
        logic                       fc;
        logic                       sfc;
        logic                       pfc;
        logic                       ptp;
        logic                       vlan;
        t_framesize                 length;
        logic                       vlfc;
        logic                       vlptp;
        logic                       vlsfc;
        logic                       vlpfc;
        logic                       svlan;
        t_framesize                 vllength;
        logic                       svfc;
        logic                       svptp;
        t_framesize                 svlength;
        logic                       svsfc;
        logic                       svpfc;
    } t_hdr_dec;

    //Validated header decode type; use this more compact version of the
    //decode after the decoding data has been validated
    typedef struct packed {
        logic                       bcast;
        logic                       mcast;
        logic                       ucast;
        logic                       fc_addr;
        logic                       fc;
        logic                       sfc;
        logic                       pfc;
        logic                       ptp;
        logic                       vlan;
        logic                       svlan;
        t_framesize                 length;
        logic   [15:0]              wcount;
    } t_hdr_vdec;

    //Data type for rxstatus bus
    typedef struct packed {
        logic                       fc;
        logic                       sfc;
        logic                       pfc;
        logic                       ptp;
        logic                       mcast;
        logic                       bcast;
        logic                       ctrl;
        logic                       ctrl_other;
        logic                       ill_etype;  //Not legal length field nor legal type field
        logic                       vlan;
        logic                       svlan;
    } t_rxstatus;

    //Data type for rxerror bus
    typedef struct packed {
        logic                       mii_err;
        logic                       mii_sop_err;
        logic                       undersize;
        logic                       oversize;
        logic                       length_err;
    } t_rxerror;

    //Link fault detection bus
    typedef struct packed {
        logic               remote_fault;
        logic               local_fault;
    } t_linkfault;

    //Data type for stats increment vector
    typedef logic [EHP_STAT_CINNUM-1:0]    t_stat_inc;

    //Data type for stats count array
    typedef logic [EHP_STAT_NUMCOUNTS-1:0][15:0]   t_statcounts;

    //Data type for timestamps and fingerprints
    typedef logic   [95:0]  t_timestamp;
    typedef logic   [15:0]  t_fingerprint;

    //Data type for PTP onestep commands
    typedef struct packed {
        logic               ts_out_req;
        t_fingerprint       fp_out_req;
        logic               ins_ts;
        logic               ins_ts_format;
        logic               tx_asym;
        logic               upd_corr;
        t_timestamp         ing_ts;
        logic               corr_format;
        logic               chk_sum_zero;
        logic               chk_sum_upd;
        logic   [15:0]      ts_offset;
        logic   [15:0]      corr_offset;
        logic   [15:0]      chk_sum_zero_offset;
        logic   [15:0]      chk_sum_udp_offset;
    } t_ptp_cmd;

    //Data type for RX MAC config bits
    typedef struct packed {
        logic               preamble_pass;
        logic               keep_rx_crc;
        logic               pld_length_chk;
        logic   [15:0]      max_frm_length;
        logic               pld_disable_vlan;
    } t_rx_mac_cfg;


    //Data type for PCS interface
    typedef struct packed {
        t_mii   [EHP_WORDS-1:0]     mii;
        logic                       mii_valid;
        logic                       am_active;
    } t_ehip_top_mii;

    //Data type for PCS interface
    typedef struct packed {
        t_mii                       mii;
        logic                       mii_valid;
        logic                       am_active;
    } t_elane_top_mii;

    //Data type for FEC interface
    typedef struct packed {
        logic   [65:0]              data;
        logic                       valid;
        logic                       am_valid;
    } t_ehip_top_pcs66;

    //Per Word FEC interface signals
    typedef struct packed {
        logic   [65:0]              data;       //Block data, right 2 bits are header
        logic                       valid;      //1=data valid
        logic                       am_valid;   //1=is alignment marker word
    } t_ehip_top_fec;


    typedef struct packed {
        logic   [63:0]  data;
        logic           inframe;
        logic   [2:0]   empty;
    } t_ehip_top_mac_rx;

    typedef struct packed {
        logic           fcs_error;
        logic   [2:0]   status;
        logic   [1:0]   error;
    } t_ehip_top_rxst;

    typedef struct packed {
        logic   [63:0]              data;
        logic                       inframe;
        logic   [2:0]               eop_empty;
        logic                       skip_crc;
        logic                       tx_error;
    } t_ehip_top_mac_tx;

    typedef struct packed {
        logic                       am_lock;
        logic                       block_lock;
        logic                       dsk_done;
        logic                       internal_err;
    } t_ehip_top_pcs_astatus;


    typedef struct packed {
        logic   [1:0]               tx_fp;
        logic   [23:0]              ts;
        logic   [2:0]               ins_type;
        logic   [2:0]               byte_offset;
    } t_ehip_top_ptpmac;

    typedef struct packed {
        logic                       scan_mode_n;
        logic                       scan_shift_n;
        logic                       occ_scan_out;
        logic                       occ_scan_in;
        logic                       global_pipe_se;
        logic                       occ_enable;
        logic                       occ_clk_sel_n;
        logic                       bistmode_n;
        logic                       tck;
        logic                       tms;
        logic                       trst;
        logic                       tdi;
    } t_ehip_top_dft_in;

    //Type declarations for configuration signals
    typedef  logic  [31:0]  t_ehip_avmm1_rdata;
    typedef  logic  [16:0]  t_ehip_elane_addr;
    typedef  logic  [8:0]   t_ehip_xcvr_addr;
    typedef  logic  [3:0]   t_ehip_avmm1_byte_en;
    typedef  logic  [31:0]  t_ehip_avmm1_wdata;
    typedef  logic  [31:0]  t_ehip_avmm2_cfg_rdata;
    typedef  logic  [16:0]  t_ehip_avmm2_cfg_addr;
    typedef  logic  [3:0]   t_ehip_avmm2_cfg_byte_en;
    typedef  logic  [31:0]  t_ehip_avmm2_cfg_wdata;
    typedef  logic  [7:0]   t_ehip_avmm2_usr_rdata;
    typedef  logic  [20:0]  t_ehip_avmm2_usr_addr;
    typedef  logic  [7:0]   t_ehip_avmm2_usr_wdata;

    typedef struct packed {
        logic                       write;
        logic                       read;
        t_ehip_avmm2_cfg_addr       addr;
        t_ehip_avmm2_cfg_wdata      wdata;
        t_ehip_avmm2_cfg_byte_en    byte_en;
    } t_ehip_top_cfg_avmm2_wr;

    typedef struct packed {
        t_ehip_avmm2_cfg_rdata      rdata;
        logic                       rdatavalid;
        logic                       waitrequest;
        logic                       slave_active;
    } t_ehip_top_cfg_avmm2_rd;

    typedef struct packed {
        logic                       write;
        logic                       read;
        t_ehip_avmm2_usr_addr       addr;
        t_ehip_avmm2_usr_wdata      wdata;
    } t_ehip_top_user_avmm2_wr;

    typedef struct packed {
        t_ehip_avmm2_usr_rdata      rdata;
        logic                       rdatavalid;
        logic                       writedone;
    } t_ehip_top_user_avmm2_rd;

    typedef struct packed {
        logic                       write;
        logic                       read;
        t_ehip_elane_addr           addr;
        t_ehip_avmm1_wdata          wdata;
        t_ehip_avmm1_byte_en        byte_en;
        logic                       cfg_active;
    } t_ehip_top_avmm1_wr;

    typedef struct packed {
        t_ehip_avmm1_rdata          rdata;
        logic                       rdatavalid;
        logic                       waitrequest;
    } t_ehip_top_avmm1_rd;


    typedef struct packed {
        logic                       cfg_clk;
        logic                       cfg_rst_n;
        logic                       usr_clk;
        logic                       usr_rst_n;
        t_ehip_top_cfg_avmm2_wr     cfg;
        t_ehip_top_user_avmm2_wr    usr;
    } t_ehip_avmm2_wr;

    typedef struct packed {
        t_ehip_top_cfg_avmm2_rd     cfg;
        t_ehip_top_user_avmm2_rd    usr;
    } t_ehip_avmm2_rd;

    typedef struct packed {
        logic                       clk;
        logic                       rst_n;
        t_ehip_top_avmm1_wr         avmm;
    } t_ehip_avmm1_wr;

    //Lane PLD deskew signals
    typedef struct packed {
        logic                       got_marker;
        logic   [5:0]               tap_sel_one_hot;
        logic                       deskew_marker;
    } t_ptp_lane_deskew;

    //Lane PLD PTP FIFO sharing signals
    typedef struct packed {
        logic                       rd_en;
        logic                       wr_en;
    } t_ptp_fifo_share;

   typedef struct packed {
      // For module ../config_csr/ehip_cfgcsr_crssm_arb.sv
      logic csr_busy_sync         ;
      logic regmap_readdatavalid  ;
      logic regmap_waitrequest    ;
      logic regmap_read           ;
      logic regmap_write          ;
      logic [1:0] state_crssm     ;
      } t_testbus_cfgcsr_crssm_arb;

   typedef struct packed {
      // For module ../config_csr/ehip_cfgcsr_crssm_intf.sv
      logic [2:0] state_crssm        ;
      logic crssm_avmm_read          ;
      logic csr_avmm_read_filt       ;
      logic crssm_avmm_read_r        ;
      logic posedge_get_csr_addr     ;
      logic csr_avmm_read            ;
      logic rdval_csr_level          ;
      logic rdval_csr_pulse          ;
      logic rdval_crssm              ;
      logic rdval_crssm_level        ;
      logic posedge_get_crssm_rddata ;
      } t_testbus_cfgcsr_crssm_intf;

   typedef struct packed {
      // For module ../config_csr/ehip_cfgcsr_load.sv
      logic [2:0] nstate                       ;
      logic       sm_usr_stages                ;
      logic       r_usr_avmm_readdatavalid     ;
      logic       r_usr_avmm_waitrequest       ;
      logic       r_csr_avmm_read              ;
      logic       r_csr_avmm_write             ;
      logic       r_cfg_avmm_read              ;
      logic       r_ehip_cfgcsr_cfg_load_done  ;
      logic [1:0] cnt_cfg_byte                 ;
      logic [6:0] cnt_cfg_bar                  ;
      logic [9:0] w_cfg_addr                   ;
      logic       ehip_cfgcsr_cfg_busy         ;
      } t_testbus_cfgcsr_load;

   typedef struct packed {
      // For module ../config_csr/ehip_cfgcsr_usr_intf.sv
      logic i_usr_avmm_read                ;
      logic i_usr_avmm_write               ;
      logic o_usr_avmm_readdatavalid       ;
      logic o_usr_avmm_waitrequest         ;
      logic o_usr_avmm_writedone           ;
      logic o_csr_avmm_read                ;
      logic o_csr_avmm_write               ;
      logic i_csr_avmm_readdatavalid       ;
      logic i_csr_avmm_waitrequest         ;
      logic [1:0]  cstate                  ;
      logic r_usr_avmm_write_cycle         ;
      logic r_usr_avmm_write               ;
      logic r_usr_avmm_read                ;
      logic token_waitreq                  ;
      logic capture_ready_next             ;
      logic w_csr_avmm_read                ;
      logic w_csr_avmm_write               ;
      logic r_csr_avmm_readdatavalid       ;
      logic usr_avmm_read_and_waitrequest  ;
      logic usr_avmm_write_and_waitrequest ;
      logic usr_avmm_waitrequest_n         ;
      logic usr_avmm_readdatavalid         ;
      logic usr_avmm_waitrequest           ;
      logic capture_usr_addr               ;
      logic capture_usr_wdata              ;
      logic capture_csr_rddata             ;
      } t_testbus_cfgcsr_usr_intf;

   typedef struct packed {
      // For module ../config_csr/ehip_cfgcsr_csr_stats.sv
      t_stats_inc    i_rx_stats_inc0     ;
      t_stats_inc    i_tx_stats_inc0     ;
      t_stats_inc    i_rx_stats_inc1     ;
      t_stats_inc    i_tx_stats_inc1     ;
      t_statcounts   i_rx_statcounts     ;
      t_statcounts   i_tx_statcounts     ;
      logic [5:0]    addr_cnt            ;
      logic [1:0]    sm_snap;
      logic          user_rd_snap_on_tx  ;
      logic          user_rd_snap_on_rx  ;
      } t_testbus_cfgcsr_csr_stats;


   typedef struct packed {
      // For module ../config_csr/ehip_cfgcsr_load.sv
      t_testbus_cfgcsr_csr_stats  t_csr_stats    ;
      logic rx_parity_err     ;
      logic rx_shadow_on      ;
      logic tx_parity_err     ;
      logic tx_shadow_on      ;
      logic tx_shadow_req     ;
      logic rx_shadow_req     ;
      logic emap_read         ;
      logic emap_write        ;
      logic emap_readdatavalid;
      logic emap_waitrequest  ;
      logic request_r         ;
      } t_testbus_cfgcsr_csr_arb;

   // test bus for ../config_csr/ehip_cfgcsr.sv
    typedef struct packed {
      logic                       cfg_load_done;
      t_testbus_cfgcsr_crssm_arb  t_crssm_arb  ;
      t_testbus_cfgcsr_crssm_intf t_crssm_intf ;
      t_testbus_cfgcsr_csr_arb    t_csr_arb    ;
      t_testbus_cfgcsr_load       t_load       ;
      t_testbus_cfgcsr_usr_intf   t_usr_intf   ;
    } t_testbus_cfgcsr;
//-----------------------------------------------------------------------------
//Functions

    function automatic logic [2:0] encode8to3;
    input [7:0] enc_in;

    reg   [2:0] enc_out;
    integer     i;
    reg   [31:0]    iterator;

    begin
        enc_out = 3'd0;
        for (i = 0; i < 8; i = i + 1) begin
            iterator    =   i;
            if (enc_in[i])   enc_out = enc_out | iterator[2:0];
        end
        encode8to3 = enc_out;
    end
    endfunction

    //Reverse an mii data byte
    function automatic logic [7:0] ehp_reverse_mii_d (logic [7:0] mii_d);
        logic [7:0] result;
        for(integer ii=0;ii<8;ii=ii+1)begin
            result[ii]  =   mii_d[7-ii];
        end
        return result;
    endfunction

    //Rotate the 4 bytes of CRC from the CRC generator
    function automatic logic [31:0] f_rotate_crc_bytes(logic [31:0] crc);
        integer         bb;
        logic   [31:0]  rotated_crc;
        for(bb=0;bb<4;bb++)begin:do_rotation
            rotated_crc[8*bb+:8]    =   crc[8*(3-bb)+:8];
        end:do_rotation

        return rotated_crc;
    endfunction

endpackage
