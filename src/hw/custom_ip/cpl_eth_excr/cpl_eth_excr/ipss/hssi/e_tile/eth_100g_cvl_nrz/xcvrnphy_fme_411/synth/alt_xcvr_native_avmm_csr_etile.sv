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

module alt_xcvr_native_avmm_csr_etile #(
  parameter                               dbg_capability_reg_enable        = 0,
  parameter                               dbg_user_identifier              = 0,
  parameter                               dbg_stat_soft_logic_enable       = 0,
  parameter                               dbg_ctrl_soft_logic_enable       = 0,
  parameter                               channels                         = 1,
  parameter                               channel_num                      = 1,
  parameter                               addr_width                       = 10,
  parameter                               duplex_mode                      = "duplex",
  parameter                               is_dual_channel                  = 0,
  parameter                               rcfg_emb_strm_enable             = 0,
  parameter                               rcfg_emb_strm_cfg_sel_width      = 2,
  parameter                               rcp_load_enable                  = 0

) (
  // avmm signals
  input                                   avmm_clk,
  input                                   avmm_reset,
  input  [addr_width-1:0]                 avmm_address,
  input  [7:0]                            avmm_writedata,
  input                                   avmm_write,
  input                                   avmm_read,
  output reg [7:0]                        avmm_readdata,
  output                                  avmm_waitrequest,

  // input status signals from the channel
  input                                   rx_is_lockedtodata,
  // <TODO: case:335703>
  input                                   tx_transfer_ready,
  input                                   rx_transfer_ready,

  // input control signals
  input                                   rx_analogreset,
  input                                   rx_digitalreset,
  input                                   tx_analogreset,
  input                                   tx_digitalreset,

  // inputs from the reset controller
  input                                   tx_ready,
  input                                   rx_ready,

  // inputs from rx de-skew
  input                                   rx_dskw_min_mkr,

  // embedded reconfigsignals
  input                                   rcfg_emb_strm_busy,
  input                                   rcfg_emb_strm_chan_sel,
  output [rcfg_emb_strm_cfg_sel_width-1:0] rcfg_emb_strm_cfg_sel,
  output                                  rcfg_emb_strm_bcast_en,
  output                                  rcfg_emb_strm_cfg_load,

  // iCal/pCal recipe load
  input                                   rcp_load_busy,
  input                                   rcp_load_timeout,
  input                                   rcp_load_finish,
  input  [4:0]                            rcp_load_state,
  input  [7:0]                            rcp_load_mail_state,
  input  [7:0]                            chnl_id            ,

  output [2:0]    rcp_load_rcp_sel, //#of recipe matches #of reconfig profiles
  output                                  rcp_load,

  // output control signals to the channel
  output                                  csr_rx_analogreset,
  output                                  csr_rx_digitalreset,
  output                                  csr_tx_analogreset,
  output                                  csr_tx_digitalreset,


  //iCal state machine status
  input[7:0]                                   ical_cur_state,

  input                                        ical_finish,
  input                                        ical_timeout,
  input                                        ical_in_progress,

  input[7:0]                                   intrpt_state,

  output                                       r_user_ical_req

);

// Import package with parameters for the soft addresses and offsets
import      s10_avmm_h_etile::*;


// Reg for generating waitrequest and data valid
reg         avmm_valid;

/**********************************************************************/
// wires and bus declaration
/**********************************************************************/
wire [7:0]  rd_channel;
wire [7:0]  rd_channel_num;
wire [7:0]  rd_duplex;
wire [7:0]  rd_system_id;
wire [7:0]  rd_status_en;
wire [7:0]  rd_control_en;
wire [7:0]  rd_ltr_status;
wire [7:0]  rd_chnl_reset;
wire [7:0]  rd_chnl_ready;
wire [7:0]  rd_aib_ready;
wire [7:0]  rd_dual_chnl;
wire [7:0]  rd_rcfg_emb_ctrl;
wire [7:0]  rd_rcfg_emb_status;

reg [7:0]  rd_rcp_load_ctrl;
wire [7:0]  rd_rcp_load_status;
wire [7:0]  rd_rcp_load_mail_status;
wire [7:0] rd_rcp_chnl_id;

reg [7:0] rd_user_ical_req;
wire [7:0] rd_ical_state;
wire [7:0] rd_ical_status;
wire [7:0] rd_intrpt_state;

/**********************************************************************/
// from rx de-skew
/**********************************************************************/
wire       rx_dskw_min_mkr_sync;
wire [7:0] rd_rx_dskw_min_mkr = {7'd0,rx_dskw_min_mkr_sync};

/**********************************************************************/
//generate waitrequest
/**********************************************************************/
assign avmm_waitrequest = (~avmm_valid & avmm_read);


/**********************************************************************/
// soft CSRs for embedded debug
/**********************************************************************/
always@(posedge avmm_clk) begin
  if(~avmm_read) begin
    avmm_valid    <= 1'b0;
    avmm_readdata <= RD_UNUSED;
  end else begin
    avmm_valid    <= avmm_waitrequest;
    case(avmm_address)

      // Address for Capabilities
      S10_XR_ADDR_ID_0:                   avmm_readdata <= rd_system_id;
      S10_XR_ADDR_STATUS_EN:              avmm_readdata <= rd_status_en;
      S10_XR_ADDR_CONTROL_EN:             avmm_readdata <= rd_control_en;
      S10_XR_ADDR_NAT_CHNLS:              avmm_readdata <= rd_channel;
      S10_XR_ADDR_NAT_CHNL_NUM:           avmm_readdata <= rd_channel_num;
      S10_XR_ADDR_NAT_DUPLEX:             avmm_readdata <= rd_duplex;
      S10_XR_ADDR_NAT_DUAL_CHNL:          avmm_readdata <= rd_dual_chnl;

      // Address for status registers
      S10_XR_ADDR_GP_RD_LTR:              avmm_readdata <= rd_ltr_status;
      S10_XR_ADDR_GP_RD_CHNL_STATUS:      avmm_readdata <= rd_chnl_ready;
      S10_XR_ADDR_XFER_STATUS:            avmm_readdata <= rd_aib_ready;

      // Addresses for control registers
      S10_XR_ADDR_CHNL_RESET:             avmm_readdata <= rd_chnl_reset;

      //Embedded reconfig
      S10_XR_ADDR_EMBED_RCFG_CTRL:        avmm_readdata <= rd_rcfg_emb_ctrl;
      S10_XR_ADDR_EMBED_RCFG_STATUS:      avmm_readdata <= rd_rcfg_emb_status;

      //rx de-skew
      S10_XR_ADDR_RX_DSKW_DUAL_CHNL:      avmm_readdata <= rd_rx_dskw_min_mkr;

      //
      S10_XR_ADDR_USR_ICAL_REQ:           avmm_readdata <= rd_user_ical_req;
      S10_XR_ADDR_ICAL_CUR_STATE:         avmm_readdata <= rd_ical_state;
      S10_XR_ADDR_ICAL_STATUS:            avmm_readdata <= rd_ical_status;
      S10_XR_ADDR_INTRPT_CUR_STATE:       avmm_readdata <= rd_intrpt_state;
      S10_XR_ADDR_RCP_LOAD_CTRL:          avmm_readdata <= rd_rcp_load_ctrl;
      S10_XR_ADDR_RCP_LOAD_STATUS:        avmm_readdata <= rd_rcp_load_status;
      S10_XR_ADDR_RCP_LOAD_MAIL_STATUS:   avmm_readdata <= rd_rcp_load_mail_status;
      S10_XR_ADDR_RCP_CHNL_ID:            avmm_readdata <= rd_rcp_chnl_id;
      default:                            avmm_readdata <= RD_UNUSED;
    endcase
  end
end

/**********************************************************************/
// Generate Capability Registers
/**********************************************************************/
generate if(dbg_capability_reg_enable == 1) begin: g_capability_reg_en
    assign rd_channel     = channels[7:0];
    assign rd_channel_num = channel_num[7:0];
    assign rd_duplex      = (duplex_mode == "duplex") ? 8'h3 :
                            (duplex_mode == "tx")     ? 8'h2 : 8'h1;
    assign rd_dual_chnl   = is_dual_channel[7:0];
    assign rd_system_id   = dbg_user_identifier[7:0];
    assign rd_status_en   = dbg_stat_soft_logic_enable[7:0];
    assign rd_control_en  = dbg_ctrl_soft_logic_enable[7:0];
  end else begin: g_capability_reg_dis
    assign rd_channel     = RD_UNUSED;
    assign rd_channel_num = RD_UNUSED;
    assign rd_dual_chnl   = RD_UNUSED;
    assign rd_duplex      = RD_UNUSED;
    assign rd_system_id   = RD_UNUSED;
    assign rd_status_en   = RD_UNUSED;
    assign rd_control_en  = RD_UNUSED;
  end
endgenerate // End generate for g_capability_reg


/**********************************************************************/
// Generate registers for status signals
/**********************************************************************/
generate if(dbg_stat_soft_logic_enable == 1) begin: g_status_reg_en

    /**********************************************************************/
    // Wires for status signal synchronizers inside generate to avoid un-used wires
    /**********************************************************************/
    wire rx_is_ltd_sync;
    wire tx_cal_busy_sync;
    wire rx_cal_busy_sync;


    /**********************************************************************/
    // Instantiate Synchronizers and read logic for rx_is_lockedtodata
    /**********************************************************************/
    alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 3 ),
      .WIDTH                     ( 1 )  // two bits, one for locktodata and one for locktoref
    ) rx_is_locked_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({rx_is_lockedtodata}),
      .q                         ({rx_is_ltd_sync})
    );

    assign rd_ltr_status[S10_XR_OFFSET_RD_LTD] = rx_is_ltd_sync;
    assign rd_ltr_status[S10_XR_OFFSET_LTR_UNUSED+:S10_XR_LTR_UNUSED_LEN] = {S10_XR_LTR_UNUSED_LEN{1'b0}};

    /**********************************************************************/
    // Wires for status signal synchronizers inside generate to avoid un-used wires
    /**********************************************************************/
    wire rx_ready_sync;
    wire tx_ready_sync;


    /**********************************************************************/
    // Instantiate Synchronizers and read logic for rx_is_lockedtodata
    /**********************************************************************/
    alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 3 ),
      .WIDTH                     ( 2 )  // two bits, one for locktodata and one for locktoref
    ) chnl_ready_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({tx_ready, rx_ready}),
      .q                         ({tx_ready_sync, rx_ready_sync})
    );

    assign rd_chnl_ready[S10_XR_OFFSET_TX_RST_READY] = tx_ready_sync;
    assign rd_chnl_ready[S10_XR_OFFSET_RX_RST_READY] = rx_ready_sync;
    assign rd_chnl_ready[S10_XR_OFFSET_CHNL_STATUS_UNUSED+:S10_XR_RST_CHNL_STATUS_UNUSED_LEN] = {S10_XR_RST_CHNL_STATUS_UNUSED_LEN{1'b0}};

    /**********************************************************************/
    // Wires for status signal synchronizers inside generate to avoid un-used wires
    /**********************************************************************/
    wire rx_transfer_ready_sync;
    wire tx_transfer_ready_sync;


    /**********************************************************************/
    // Instantiate Synchronizers and read logic for rx_is_lockedtodata
    /**********************************************************************/
    alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 3 ),
      .WIDTH                     ( 2 )  // two bits, one for locktodata and one for locktoref
    ) chnl_transfer_ready_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({tx_transfer_ready, rx_transfer_ready}),
      .q                         ({tx_transfer_ready_sync, rx_transfer_ready_sync})
    );

    assign rd_aib_ready[S10_XR_OFFSET_TX_XFER_READY] = tx_transfer_ready_sync;
    assign rd_aib_ready[S10_XR_OFFSET_RX_XFER_READY] = rx_transfer_ready_sync;
    assign rd_aib_ready[S10_XR_OFFSET_XFER_STATUS_UNUSED+:S10_XR_XFER_STATUS_UNUSED_LEN] = {S10_XR_XFER_STATUS_UNUSED_LEN{1'b0}};

    /**********************************************************************/
    // Instantiate logic for rx de-skew
    /**********************************************************************/
     alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 2 ),
      .WIDTH                     ( 1 )
    ) rx_dskw_status_mkr_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         (rx_dskw_min_mkr),
      .q                         (rx_dskw_min_mkr_sync)
    );



    /**********************************************************************/
    // Instantiate logic for iCal IP, signals are @ avmm_clk, no re-sync needed
    /**********************************************************************/
//    reg [7:0] rd_user_ical_req;
//    wire r_user_ical_req;
    assign r_user_ical_req = rd_user_ical_req[0];

    always @(posedge avmm_clk or posedge avmm_reset) begin
       if(avmm_reset) begin
           rd_user_ical_req   <= 8'h00;
       end else if(avmm_write && avmm_address == S10_XR_ADDR_USR_ICAL_REQ) begin
           rd_user_ical_req <= avmm_writedata;
       end else if (ical_finish == 1) begin
           rd_user_ical_req <= 8'h00;
       end
    end




//    assign rd_ical_state [7:6] = 2'b00;
    assign rd_ical_status [7:3] = 5'b00000;

    alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 2 ),
      .WIDTH                     ( 8 )
    ) ical_state_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({ical_cur_state}),
      .q                         ({rd_ical_state})
    );

    alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 2 ),
      .WIDTH                     ( 3 )
    ) ical_status_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({ical_finish, ical_timeout, ical_in_progress}),
      .q                         ({rd_ical_status[S10_XR_OFFSET_ICAL_FINISH],rd_ical_status[S10_XR_OFFSET_ICAL_TIMEOUT],rd_ical_status[S10_XR_OFFSET_ICAL_IN_PROGRESS]})
    );

//     assign rd_intrpt_state[7:6] = 2'b00;
    alt_xcvr_resync_etile #(
      .SYNC_CHAIN_LENGTH         ( 2 ),
      .WIDTH                     ( 8 )
    ) intrpt_state_sync (
      .clk                       (avmm_clk),
      .reset                     (avmm_reset),
      .d                         ({intrpt_state}),
      .q                         ({rd_intrpt_state})
    );


  end else begin: g_status_reg_dis
    assign rd_aib_ready                           = RD_UNUSED;
    assign rd_ltr_status                          = RD_UNUSED;
    assign rd_chnl_ready                          = RD_UNUSED;

    assign rd_user_ical_req                       = RD_UNUSED;
    assign rd_ical_state                          = RD_UNUSED;
    assign rd_ical_status                         = RD_UNUSED;
    assign rd_intrpt_state                        = RD_UNUSED;

    assign rx_dskw_min_mkr_sync                   = 1'b0;

  end
endgenerate //End generate g_status_reg


/**********************************************************************/
// Generate registers for control signals
/**********************************************************************/
generate if(dbg_ctrl_soft_logic_enable == 1) begin: g_control_reg

    /**********************************************************************/
    // Registers for Channel Resets and Overrides
    /**********************************************************************/
    reg r_rx_analogreset;
    reg r_rx_digitalreset;
    reg r_tx_analogreset;
    reg r_tx_digitalreset;
    reg r_rx_analogreset_override;
    reg r_rx_digitalreset_override;
    reg r_tx_analogreset_override;
    reg r_tx_digitalreset_override;

    // readback the control registers for the channel resets and overrides
    assign rd_chnl_reset[S10_XR_OFFSET_RX_ANA]     = r_rx_analogreset;
    assign rd_chnl_reset[S10_XR_OFFSET_RX_DIG]     = r_rx_digitalreset;
    assign rd_chnl_reset[S10_XR_OFFSET_TX_ANA]     = r_tx_analogreset;
    assign rd_chnl_reset[S10_XR_OFFSET_TX_DIG]     = r_tx_digitalreset;
    assign rd_chnl_reset[S10_XR_OFFSET_RX_ANA_OVR] = r_rx_analogreset_override;
    assign rd_chnl_reset[S10_XR_OFFSET_RX_DIG_OVR] = r_rx_digitalreset_override;
    assign rd_chnl_reset[S10_XR_OFFSET_TX_ANA_OVR] = r_tx_analogreset_override;
    assign rd_chnl_reset[S10_XR_OFFSET_TX_DIG_OVR] = r_tx_digitalreset_override;

    // assign the output signals to the channel
    assign csr_rx_analogreset         = (rd_chnl_reset[S10_XR_OFFSET_RX_ANA_OVR]) ? rd_chnl_reset[S10_XR_OFFSET_RX_ANA] : rx_analogreset;
    assign csr_rx_digitalreset        = (rd_chnl_reset[S10_XR_OFFSET_RX_DIG_OVR]) ? rd_chnl_reset[S10_XR_OFFSET_RX_DIG] : rx_digitalreset;
    assign csr_tx_analogreset         = (rd_chnl_reset[S10_XR_OFFSET_TX_ANA_OVR]) ? rd_chnl_reset[S10_XR_OFFSET_TX_ANA] : tx_analogreset;
    assign csr_tx_digitalreset        = (rd_chnl_reset[S10_XR_OFFSET_TX_DIG_OVR]) ? rd_chnl_reset[S10_XR_OFFSET_TX_DIG] : tx_digitalreset;

    // write reset and reset override registers
    always@(posedge avmm_clk or posedge avmm_reset) begin
      if(avmm_reset) begin
        r_rx_analogreset              <= 1'b0;
        r_rx_digitalreset             <= 1'b0;
        r_tx_analogreset              <= 1'b0;
        r_tx_digitalreset             <= 1'b0;
        r_rx_analogreset_override     <= 1'b0;
        r_rx_digitalreset_override    <= 1'b0;
        r_tx_analogreset_override     <= 1'b0;
        r_tx_digitalreset_override    <= 1'b0;
      end else if(avmm_write && avmm_address == S10_XR_ADDR_CHNL_RESET) begin
        r_rx_analogreset              <= avmm_writedata[S10_XR_OFFSET_RX_ANA];
        r_rx_digitalreset             <= avmm_writedata[S10_XR_OFFSET_RX_DIG];
        r_tx_analogreset              <= avmm_writedata[S10_XR_OFFSET_TX_ANA];
        r_tx_digitalreset             <= avmm_writedata[S10_XR_OFFSET_TX_DIG];
        r_rx_analogreset_override     <= avmm_writedata[S10_XR_OFFSET_RX_ANA_OVR];
        r_rx_digitalreset_override    <= avmm_writedata[S10_XR_OFFSET_RX_DIG_OVR];
        r_tx_analogreset_override     <= avmm_writedata[S10_XR_OFFSET_TX_ANA_OVR];
        r_tx_digitalreset_override    <= avmm_writedata[S10_XR_OFFSET_TX_DIG_OVR];
      end
    end

  end else begin: g_control_reg_dis
    // assign LTR control signals when control registers are disabled
    assign rd_chnl_reset              = RD_UNUSED;

    // pass through control signals
    assign csr_rx_analogreset         = (rx_analogreset);
    assign csr_rx_digitalreset        = (rx_digitalreset);
    assign csr_tx_analogreset         = (tx_analogreset);
    assign csr_tx_digitalreset        = (tx_digitalreset);
  end
endgenerate // End generate g_control_reg

/**********************************************************************/
// Embedded reconfig registers
/**********************************************************************/
generate if(rcfg_emb_strm_enable) begin: en_rcfg_reg

    /**********************************************************************/
    // Generate registers and wires for the reconfig soft logic
    /**********************************************************************/
    reg [rcfg_emb_strm_cfg_sel_width-1:0] r_rcfg_emb_strm_cfg_sel;
    reg                                   r_rcfg_emb_strm_cfg_load;
    reg                                   r_rcfg_emb_strm_bcast_en;
    reg                                   rcfg_emb_strm_cfg_load_lock = 1'b0;

    // readback the embedded reconfig control
    assign rd_rcfg_emb_ctrl               = {r_rcfg_emb_strm_cfg_load, r_rcfg_emb_strm_bcast_en, {(S10_XR_EMBED_RCFG_CFG_SEL_LEN-rcfg_emb_strm_cfg_sel_width){1'b0}}, r_rcfg_emb_strm_cfg_sel};
    assign rd_rcfg_emb_status             = {7'b0, rcfg_emb_strm_busy};

    // assign the output signals to the channel
    assign rcfg_emb_strm_cfg_sel          = r_rcfg_emb_strm_cfg_sel;
    assign rcfg_emb_strm_cfg_load         = r_rcfg_emb_strm_cfg_load;
    assign rcfg_emb_strm_bcast_en         = r_rcfg_emb_strm_bcast_en;

    always@(posedge avmm_clk or posedge avmm_reset) begin
      if(avmm_reset) begin
        r_rcfg_emb_strm_cfg_sel           <= {rcfg_emb_strm_cfg_sel_width{1'b0}};
        r_rcfg_emb_strm_cfg_load          <= 1'b0;
        r_rcfg_emb_strm_bcast_en          <= 1'b0;
        rcfg_emb_strm_cfg_load_lock       <= 1'b0;
      end else if(avmm_write && avmm_address == S10_XR_ADDR_EMBED_RCFG_CTRL) begin
        // Write to this register
        r_rcfg_emb_strm_cfg_sel           <= avmm_writedata[S10_XR_OFFSET_EMBED_RCFG_CFG_SEL +: rcfg_emb_strm_cfg_sel_width ];
        r_rcfg_emb_strm_cfg_load          <= avmm_writedata[S10_XR_OFFSET_EMBED_RCFG_CFG_LOAD];
        r_rcfg_emb_strm_bcast_en          <= avmm_writedata[S10_XR_OFFSET_EMBED_RCFG_BCAST_EN];
      end else if(rcfg_emb_strm_chan_sel & rcfg_emb_strm_busy & ~rcfg_emb_strm_cfg_load_lock) begin
        // Reset the cfg_load bit when the streaming has started
        r_rcfg_emb_strm_cfg_load          <= 1'b0;
        rcfg_emb_strm_cfg_load_lock       <= 1'b1;
      end else if(~rcfg_emb_strm_busy & rcfg_emb_strm_cfg_load_lock) begin
        rcfg_emb_strm_cfg_load_lock       <= 1'b0;
      end
    end
  end else begin: g_rcfg_reg_dis
    assign rd_rcfg_emb_ctrl               = RD_UNUSED;
    assign rd_rcfg_emb_status             = RD_UNUSED;
    assign rcfg_emb_strm_cfg_sel          = 1'b0;
    assign rcfg_emb_strm_bcast_en         = 1'b0;
    assign rcfg_emb_strm_cfg_load         = 1'b0;
  end
endgenerate //End generate g_rcfg_reg


generate if(rcp_load_enable) begin: en_rcp_load_reg

    /**********************************************************************/
    // Generate registers and wires for the recipe load soft logic
    /**********************************************************************/
    reg                                   rcp_load_lock = 1'b0;

    // readback the embedded reconfig control
    assign rd_rcp_load_status             = {rcp_load_state,rcp_load_busy,rcp_load_timeout,rcp_load_finish};
    assign rd_rcp_load_mail_status        = {rcp_load_mail_state};
    assign rd_rcp_chnl_id                 = {chnl_id};

    // assign the output signals to the channel
    assign rcp_load_rcp_sel    = rd_rcp_load_ctrl[2:0];
    assign rcp_load            = rd_rcp_load_ctrl[S10_XR_OFFSET_RCP_LOAD];
    //assign rcp_load_bcast      = rd_rcp_load_ctrl[S10_XR_OFFSET_RCP_LOAD_BCAST];//commenting as it is not declared as a wire or output

    always@(posedge avmm_clk or posedge avmm_reset) begin
      if(avmm_reset) begin
        rd_rcp_load_ctrl           <= 8'h00;
      end else if(avmm_write && avmm_address == S10_XR_ADDR_RCP_LOAD_CTRL && rcp_load_busy == 1'b0) begin

	rd_rcp_load_ctrl           <= {avmm_writedata[S10_XR_OFFSET_RCP_LOAD],{S10_XR_RCP_LOAD_CTRL_UNUSED_LEN{1'b0}},avmm_writedata[2:0]};

      end else if (rcp_load_finish || rcp_load_timeout) begin
        rd_rcp_load_ctrl[S10_XR_OFFSET_RCP_LOAD] <= 1'b0;
      end
     end
    end else begin: g_rcp_reg_dis
       assign rd_rcp_load_ctrl               = RD_UNUSED;
       assign rd_rcp_load_status             = RD_UNUSED;
       assign rd_rcp_load_mail_status        = RD_UNUSED;
       assign rd_rcp_chnl_id                 = RD_UNUSED;
   end //To LET SIM FAIL TO RUN SIM LOCALLY FOR RECIPE LOAD
endgenerate //End generate g_rcfg_reg

endmodule
