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

module alt_xcvr_native_rcfg_opt_logic_y5roe6q #(
  // Parameters for the embedded reconfiguration logic
  parameter                                 dbg_user_identifier         = 0,
  parameter                                 duplex_mode                 = "duplex",
  parameter                                 dbg_embedded_debug_enable   = 0,
  parameter                                 dbg_capability_reg_enable   = 0,
  parameter                                 dbg_stat_soft_logic_enable  = 0,
  parameter                                 dbg_ctrl_soft_logic_enable  = 0,

  // Parameters for the AVMM masters and split interface
  parameter                                 CHANNELS                    = 1,
  parameter                                 DUAL_CHANNELS               = 1,
  parameter                                 RECONFIG_SHARED             = 0,
  parameter                                 JTAG_ENABLED                = 0,    // Can only be enabled when using a shared reconfig interface
  parameter                                 ADME_SLAVE_MAP              = "altera_xcvr_native_s10",
  parameter                                 ADME_ASSGN_MAP              = " ",
  parameter                                 RCFG_EMB_STRM_ENABLED       = 0,    // Enable the embedded reconfiguration streamer logic
  parameter                                 RCFG_PROFILE_CNT            = 2,    // Number of configuration profiles for embedded streamer
  parameter                                 RCP_LOAD_ENABLE             = 0,
  parameter                                 ENABLE_PMA_RESET            = 0,	// Enable pma spico reset avmm sequence logic

  // The following are not intended to be directly set
  parameter                                 IFACES                      = RECONFIG_SHARED ? 1 : CHANNELS,
  parameter                                 ADDR_BITS                   = 11,
  parameter                                 SEL_BITS                    = (RECONFIG_SHARED ? altera_xcvr_native_s10_functions_h::clogb2_alt_xcvr_native_s10(CHANNELS-1) : 0),
  parameter                                 DATA_WIDTH                  = 32,
  parameter                                 is_dual_channel                  = 0

) (
  // User reconfig interface ports
  input  [IFACES-1:0]                          reconfig_clk,
  input  [IFACES-1:0]                          reconfig_reset,
  input  [IFACES-1:0]                          reconfig_write,
  input  [IFACES-1:0]                          reconfig_read,
  input  [IFACES*(ADDR_BITS+SEL_BITS)-1:0]     reconfig_address,
  input  [IFACES*DATA_WIDTH-1:0]               reconfig_writedata,
  output [IFACES*DATA_WIDTH-1:0]               reconfig_readdata,
  output [IFACES-1:0]                          reconfig_waitrequest,

  // AVMM ports to transceiver Split bychannel
  output [CHANNELS-1:0]                        avmm_clk,
  output [CHANNELS-1:0]                        avmm_reset,
  output [CHANNELS-1:0]                        avmm_write,
  output [CHANNELS-1:0]                        avmm_read,
  output [CHANNELS*ADDR_BITS-1:0]              avmm_address,
  output [CHANNELS*8-1:0]                      avmm_writedata,
  input  [CHANNELS*8-1:0]                      avmm_readdata,
  input  [CHANNELS-1:0]                        avmm_waitrequest,

  // input status signals
  input  [CHANNELS-1:0]                        in_tx_pma_ready,
  input  [CHANNELS-1:0]                        in_rx_pma_ready,
  input  [CHANNELS-1:0]                        in_rx_is_lockedtodata,
  input  [CHANNELS-1:0]                        in_tx_transfer_ready,
  input  [CHANNELS-1:0]                        in_rx_transfer_ready,

  // input status from the reset controller
  input  [CHANNELS-1:0]                        in_tx_ready,
  input  [CHANNELS-1:0]                        in_rx_ready,

  input  [DUAL_CHANNELS-1:0]                   pma_reset,
  input  [DUAL_CHANNELS-1:0]                   spico_reset,
  output [DUAL_CHANNELS-1:0]                   pma_reset_busy,
  output [DUAL_CHANNELS-1:0]                   pma_spico_reset_timeout,

  // input control signals
  input  [CHANNELS-1:0]                        in_rx_analogreset,
  input  [CHANNELS-1:0]                        in_rx_digitalreset,
  input  [CHANNELS-1:0]                        in_tx_analogreset,
  input  [CHANNELS-1:0]                        in_tx_digitalreset,

  // input from rx de-skew
  input  [CHANNELS-1:0]                        in_rx_dskw_min_mkr,

  // output control signals to the phy
  output [CHANNELS-1:0]                        out_rx_analogreset,
  output [CHANNELS-1:0]                        out_rx_digitalreset,
  output [CHANNELS-1:0]                        out_tx_analogreset,
  output [CHANNELS-1:0]                        out_tx_digitalreset,

  // iCal
  output                         rcp_load_timeout,
  output                         rcp_load_finish
);

/**********************************************************************/
// Per Instance instantiations and assignments
/**********************************************************************/
localparam AVMM_OFFSET                 = ADDR_BITS - 1;
localparam NUM_CSR_BITS                = 10;
localparam CHANNEL_SEL_WIDTH           = altera_xcvr_native_s10_functions_h::clogb2_alt_xcvr_native_s10(CHANNELS-1);
localparam ENABLED_JTAG_MASTERS        = 1 + JTAG_ENABLED + RCFG_EMB_STRM_ENABLED;
localparam RCFG_EMB_STRM_CFG_SEL_WIDTH = altera_xcvr_native_s10_functions_h::clogb2_alt_xcvr_native_s10(RCFG_PROFILE_CNT-1);


// Raw rmbedded reconfig signals (always independent)
wire [CHANNELS-1:0]             rcfg_emb_strm_write;
wire [CHANNELS-1:0]             rcfg_emb_strm_read;
wire [CHANNELS*ADDR_BITS-1:0]   rcfg_emb_strm_address;
wire [CHANNELS*DATA_WIDTH-1:0]  rcfg_emb_strm_writedata;
wire [CHANNELS-1:0]             rcfg_emb_strm_waitrequest;

// User AVMM signals expanded to independent channels
wire [CHANNELS-1:0]             split_user_write;
wire [CHANNELS-1:0]             split_user_read;
wire [CHANNELS*ADDR_BITS-1:0]   split_user_address;
wire [CHANNELS*DATA_WIDTH-1:0]  split_user_writedata;
wire [CHANNELS-1:0]             split_user_waitrequest;

// ODI AVMM signals, for Warning removal
// For tie-off warnings
wire [CHANNELS-1:0]             odi_write;
wire [CHANNELS-1:0]             odi_read;
wire [CHANNELS*ADDR_BITS-1:0]   odi_address;
wire [CHANNELS*DATA_WIDTH-1:0]  odi_writedata;
wire [CHANNELS-1:0]             odi_read_write;


// JTAG signals expanded to independent channels
wire [CHANNELS-1:0]             split_jtag_write;
wire [CHANNELS-1:0]             split_jtag_read;
wire [CHANNELS*ADDR_BITS-1:0]   split_jtag_address;
wire [CHANNELS*DATA_WIDTH-1:0]  split_jtag_writedata;
wire [CHANNELS-1:0]             split_jtag_waitrequest;

// Additional arbitration signals for soft CSR
wire [CHANNELS-1:0]             chnl_write;
wire [CHANNELS-1:0]             chnl_read;
wire [CHANNELS-1:0]             chnl_busy;
wire [CHANNELS-1:0]             chnl_waitrequest;
wire [CHANNELS*8-1:0]           chnl_readdata;

// PRE avmm signals before iCAL IP, if no ical, pass pre_avmm to avmm*_after_ical.
wire [CHANNELS-1:0]             pre_avmm_write;
wire [CHANNELS-1:0]             pre_avmm_read;
wire [CHANNELS-1:0]             pre_avmm_waitrequest;
wire [CHANNELS*8-1:0]           pre_avmm_readdata;
wire [CHANNELS*8-1:0]           pre_avmm_writedata;
wire [CHANNELS*ADDR_BITS-1:0]   pre_avmm_address;

// avmm signals after iCAL IP, before pma/spico reset, if no pma/spico reset, pass avmm*_after_ical to output avmm.
wire [CHANNELS-1:0]             avmm_write_after_ical;
wire [CHANNELS-1:0]             avmm_read_after_ical;
wire [CHANNELS-1:0]             avmm_waitrequest_after_ical;
wire [CHANNELS*8-1:0]           avmm_readdata_after_ical;
wire [CHANNELS*8-1:0]           avmm_writedata_after_ical;
wire [CHANNELS*ADDR_BITS-1:0]   avmm_address_after_ical;



// embedded reconfig signals
wire [CHANNELS-1:0]             rcfg_emb_strm_busy;
wire [CHANNELS-1:0]             rcfg_emb_strm_chan_sel;
wire [CHANNELS*RCFG_EMB_STRM_CFG_SEL_WIDTH-1:0]   rcfg_emb_strm_cfg_sel;
wire [CHANNELS-1:0]             rcfg_emb_strm_bcast_en;
wire [CHANNELS-1:0]             rcfg_emb_strm_cfg_load;

// recipe load signals <> CSR
wire                            rcp_load_busy;
wire [4:0]                      rcp_load_state;
wire [7:0]                      rcp_load_mail_state;
wire [7:0]                      chnl_id;
wire [CHANNELS-1:0]             rcp_load;
wire [3*CHANNELS-1 :0]          rcp_load_rcp_sel;



// Read_write signals to assist with prioritizing arbitrarion
wire [CHANNELS-1:0]             user_read_write;
wire [CHANNELS-1:0]             jtag_read_write;
wire [CHANNELS-1:0]             rcfg_emb_strm_read_write;

// Wires for converting between data widths
wire [CHANNELS*DATA_WIDTH-1:0]  expanded_avmm_readdata;
wire [CHANNELS*DATA_WIDTH-1:0]  expanded_avmm_writedata;
wire [CHANNELS*DATA_WIDTH-1 :0] expanded_rcp_writedata;

// Wires for qmap cleanup
wire lcl_g_arbiter_dis;
wire lcl_g_avmm_csr_dis;
wire lcl_ground;

// Warning Removal
assign lcl_g_avmm_csr_dis   = &{1'b0,
                                rcfg_emb_strm_busy};
assign lcl_g_arbiter_dis    = &{1'b0,
                                rcfg_emb_strm_address,
                                rcfg_emb_strm_writedata,
                                split_jtag_address,
                                split_jtag_writedata,
                                user_read_write,
                                jtag_read_write,
                                rcfg_emb_strm_read_write};
assign lcl_ground           = &{1'b0,
                                lcl_g_avmm_csr_dis,
                                lcl_g_arbiter_dis};

assign odi_write = {CHANNELS{1'b0}}  ;
assign odi_read = {CHANNELS{1'b0}}  ;
assign odi_address = {CHANNELS*ADDR_BITS{1'b0}}  ;
assign odi_writedata = {CHANNELS*DATA_WIDTH{1'b0}}  ;
assign odi_read_write = {CHANNELS{1'b0}} ;

// Generate variable for channel numbers


genvar ig;


/**********************************************************************/
// Generate Statement for the Shared vs Split user interface
/**********************************************************************/
generate
  // Expand the AVMM signals from the channel to the 32-bit interface of the user
  for(ig=0;ig<CHANNELS;ig=ig+1) begin: g_expanded_avmm_signals
    assign  expanded_avmm_readdata [ig*DATA_WIDTH +: DATA_WIDTH] = {24'd0,chnl_readdata [ig*8 +: 8]};
    assign  pre_avmm_writedata [ig*8 +: 8]                           = expanded_avmm_writedata   [ig*DATA_WIDTH +: 8];
  end


  /**********************************************************************/
  // Split the reconfig interface to the independent channel when using shared reconfig
  /**********************************************************************/
  if(!RECONFIG_SHARED) begin : g_not_shared
    // Signals are already split, so wire straight through
    assign avmm_clk                                             = reconfig_clk;
    assign avmm_reset                                           = reconfig_reset;

    assign split_user_write                                     = reconfig_write;
    assign split_user_read                                      = reconfig_read;
    assign split_user_address                                   = reconfig_address;
    assign split_user_writedata                                 = reconfig_writedata;
    assign reconfig_readdata                                    = expanded_avmm_readdata;
    assign reconfig_waitrequest                                 = ({CHANNELS{lcl_ground}} | split_user_waitrequest);

  // If we are using a shared interface
  end else begin : g_shared
    wire [CHANNEL_SEL_WIDTH-1:0]                                 rcfg_if_sel;

    // Generate interface select based on upper address bits
    assign rcfg_if_sel                                          = reconfig_address[ADDR_BITS+:CHANNEL_SEL_WIDTH];
    assign reconfig_readdata                                    = expanded_avmm_readdata[rcfg_if_sel*DATA_WIDTH +: DATA_WIDTH];
    assign reconfig_waitrequest                                 = split_user_waitrequest[rcfg_if_sel];

    for(ig=0;ig<CHANNELS;ig=ig+1) begin : g_shared
      // Split shared signals to independent channels
      assign avmm_clk             [ig]                          = reconfig_clk;
      assign avmm_reset           [ig]                          = reconfig_reset;

      assign split_user_write     [ig]                          = reconfig_write & (rcfg_if_sel == ig) | lcl_ground;
      assign split_user_read      [ig]                          = reconfig_read  & (rcfg_if_sel == ig);
      assign split_user_address   [ig*ADDR_BITS +: ADDR_BITS]   = reconfig_address[0+:ADDR_BITS];
      assign split_user_writedata [ig*DATA_WIDTH +: DATA_WIDTH] = reconfig_writedata;
    end
  end //End g_not_shared
endgenerate


/**********************************************************************/
// Embedded JTAG Debug Master (ADME)
/**********************************************************************/
generate if(JTAG_ENABLED) begin : g_jtag

    // Set the slave type for the ADME.  Since the span needs to be a string, 2^(total addr_bits) will
    // give the max value, however since the adme uses byte alignment, shift the span by two bits.
    localparam set_slave_span = altera_xcvr_native_s10_functions_h::int2str_alt_xcvr_native_s10(2**(ADDR_BITS+CHANNEL_SEL_WIDTH+2));
    localparam set_slave_map  = {"{typeName ",ADME_SLAVE_MAP," address 0x0 span ",set_slave_span," hpath {}",ADME_ASSGN_MAP,"}"};

    // Raw JTAG signals
    wire                                     jtag_write;
    wire                                     jtag_read;
    wire [(ADDR_BITS+CHANNEL_SEL_WIDTH)-1:0] jtag_address;
    wire [DATA_WIDTH-1:0]                    jtag_writedata;
    wire [DATA_WIDTH-1:0]                    jtag_readdata;
    wire                                     jtag_waitrequest;
    wire [CHANNEL_SEL_WIDTH-1:0]             jtag_if_sel;

    // Generate channel select based on upper address bits
    assign jtag_if_sel                                          = jtag_address[ADDR_BITS+:CHANNEL_SEL_WIDTH];
    assign jtag_readdata                                        = expanded_avmm_readdata[jtag_if_sel*DATA_WIDTH +: DATA_WIDTH];
    assign jtag_waitrequest                                     = split_jtag_waitrequest[jtag_if_sel];

    // Split shared signals to independent channels
    for(ig=0;ig<CHANNELS;ig=ig+1) begin: g_expanded_avmm_signals
      assign split_jtag_write     [ig]                          = jtag_write & (jtag_if_sel == ig);
      assign split_jtag_read      [ig]                          = jtag_read  & (jtag_if_sel == ig);
      assign split_jtag_address   [ig*ADDR_BITS +: ADDR_BITS]   = jtag_address[0+:ADDR_BITS];
      assign split_jtag_writedata [ig*DATA_WIDTH +: DATA_WIDTH] = jtag_writedata[DATA_WIDTH-1:0];
    end

    // When doing RTL sims, remove the altera_debug_master_endpoint, as
    // there is no RTL simulation model.  Pre and Post Fit sims are ok.
    `ifdef ALTERA_RESERVED_QIS
      altera_debug_master_endpoint
      #(
        .ADDR_WIDTH                            ( (ADDR_BITS+CHANNEL_SEL_WIDTH) ),
        .DATA_WIDTH                            ( DATA_WIDTH                    ),
        .HAS_RDV                               ( 0                             ),
        .SLAVE_MAP                             ( set_slave_map                 ),
        .PREFER_HOST                           ( " "                           ),
        .CLOCK_RATE_CLK                        ( 0                             )
      ) adme (
        .clk                                   ( reconfig_clk[0]               ),  // Avoid compiler warning about port width mismatch for split interface
        .reset                                 ( |reconfig_reset               ),  // Any reset bit will reset the ADME
        .master_write                          ( jtag_write                    ),
        .master_read                           ( jtag_read                     ),
        .master_address                        ( jtag_address                  ),
        .master_writedata                      ( jtag_writedata                ),
        .master_waitrequest                    ( jtag_waitrequest              ),
        .master_readdatavalid                  ( 1'b0                          ),
        .master_readdata                       ( jtag_readdata                 )
      );
    `else
      assign jtag_write                         = 1'b0;
      assign jtag_read                          = 1'b0;
      assign jtag_address                       = {(ADDR_BITS+CHANNEL_SEL_WIDTH){1'b0}};
      assign jtag_writedata                     = {DATA_WIDTH{1'b0}};
    `endif

  // If we have not enabled the ADME
  end else begin : g_jtag_disable
    assign split_jtag_write                     = {CHANNELS{1'b0}};
    assign split_jtag_read                      = {CHANNELS{1'b0}};
    assign split_jtag_address                   = {(CHANNELS*ADDR_BITS){1'b0}};
    assign split_jtag_writedata                 = {(CHANNELS*DATA_WIDTH){1'b0}};
  end
endgenerate // End g_jtag


/**********************************************************************/
// Embedded Reconfig Streamer
/**********************************************************************/
generate if(RCFG_EMB_STRM_ENABLED) begin : g_rcfg_strm_enable //TODO check to see if there is parameter redundancy
      if (ADME_SLAVE_MAP == "altera_xcvr_rsfec_s10_etile") begin
      alt_xcvr_native_rsfec_rcfg_strm_top_y5roe6q #(
        .xcvr_rcfg_interfaces                  ( CHANNELS                        ),
        .xcvr_rcfg_addr_width                  ( ADDR_BITS                   ),
        .xcvr_rcfg_data_width                  ( DATA_WIDTH                      ),
        .rcfg_profile_cnt                      ( RCFG_PROFILE_CNT                )
      )rcfg_strm_top_inst(
        .clk                                   ( reconfig_clk[0]                 ), // All clock bits should be driven by the same source if using independent interface
        .reset                                 ( |reconfig_reset                 ), // Any reset bit will reset the reconfig streamer
        .cfg_sel                               ( rcfg_emb_strm_cfg_sel           ),
        .bcast_en                              ( rcfg_emb_strm_bcast_en          ),
        .cfg_load                              ( rcfg_emb_strm_cfg_load          ),
        .chan_sel                              ( rcfg_emb_strm_chan_sel          ),
        .stream_busy                           ( rcfg_emb_strm_busy              ),
        .xcvr_reconfig_write                   ( rcfg_emb_strm_write             ),
        .xcvr_reconfig_read                    ( rcfg_emb_strm_read              ),
        .xcvr_reconfig_address                 ( rcfg_emb_strm_address           ),
        .xcvr_reconfig_writedata               ( rcfg_emb_strm_writedata         ),
        .xcvr_reconfig_readdata                ( expanded_avmm_readdata          ),
        .xcvr_reconfig_waitrequest             ( rcfg_emb_strm_waitrequest       )
      );
      end else begin
      alt_xcvr_native_rcfg_strm_top_y5roe6q #(
        .xcvr_rcfg_interfaces                  ( CHANNELS                        ),
        .xcvr_rcfg_addr_width                  ( ADDR_BITS                   ),
        .xcvr_rcfg_data_width                  ( DATA_WIDTH                      ),
        .rcfg_profile_cnt                      ( RCFG_PROFILE_CNT                )
      )rcfg_strm_top_inst(
        .clk                                   ( reconfig_clk[0]                 ), // All clock bits should be driven by the same source if using independent interface
        .reset                                 ( |reconfig_reset                 ), // Any reset bit will reset the reconfig streamer
        .cfg_sel                               ( rcfg_emb_strm_cfg_sel           ),
        .bcast_en                              ( rcfg_emb_strm_bcast_en          ),
        .cfg_load                              ( rcfg_emb_strm_cfg_load          ),
        .chan_sel                              ( rcfg_emb_strm_chan_sel          ),
        .stream_busy                           ( rcfg_emb_strm_busy              ),
        .xcvr_reconfig_write                   ( rcfg_emb_strm_write             ),
        .xcvr_reconfig_read                    ( rcfg_emb_strm_read              ),
        .xcvr_reconfig_address                 ( rcfg_emb_strm_address           ),
        .xcvr_reconfig_writedata               ( rcfg_emb_strm_writedata         ),
        .xcvr_reconfig_readdata                ( expanded_avmm_readdata          ),
        .xcvr_reconfig_waitrequest             ( rcfg_emb_strm_waitrequest       )
      );
      end

    // If we disable the reconfig streamer
    end else begin: g_rcfg_strm_disable
      assign  rcfg_emb_strm_write               = {CHANNELS{1'b0}};
      assign  rcfg_emb_strm_read                = {CHANNELS{1'b0}};
      assign  rcfg_emb_strm_address             = {(CHANNELS*ADDR_BITS){1'b0}};
      assign  rcfg_emb_strm_writedata           = {CHANNELS{32'b0}};
      assign  rcfg_emb_strm_chan_sel            = {CHANNELS{1'b0}};
      assign  rcfg_emb_strm_busy                = {CHANNELS{1'b0}};
  end
endgenerate // End g_rcfg_strm_enable










/**********************************************************************/
// AVMM Master read/write signals.
/**********************************************************************/
assign user_read_write          = split_user_read    | split_user_write;       // Bits asserted for corresponding channels from/to which user avmm is currently reading/writing
assign jtag_read_write          = split_jtag_read    | split_jtag_write;       // Bits asserted for corresponding channels from/to which jtag is currently reading/writing
assign rcfg_emb_strm_read_write = rcfg_emb_strm_read | rcfg_emb_strm_write;    // Bits asserted for corresponding channels from/to which embedded streamer is currently reading/writing

/**********************************************************************/
// AVMM Arbiter.  Instantiated once per channel, however to handle streaming
// broadcast, the channel-wise instantiation is handled within the arbiter.
/**********************************************************************/
generate if (ENABLED_JTAG_MASTERS > 1 ) begin: g_arbiber_enable
    alt_xcvr_native_rcfg_arb #(
      .total_masters                                 ( 4                         ),
      .channels                                      ( CHANNELS                  ),
      .address_width                                 ( ADDR_BITS                 ),
      .data_width                                    ( DATA_WIDTH                )
    ) alt_xcvr_rcfg_arb (
      // Basic AVMM inputs
      .reconfig_clk                                  ( avmm_clk                  ),
      .reconfig_reset                                ( avmm_reset                ),

      // User AVMM input
      .user_read                                     ( split_user_read           ),
      .user_write                                    ( split_user_write          ),
      .user_address                                  ( split_user_address        ),
      .user_writedata                                ( split_user_writedata      ),
      .user_read_write                               ( user_read_write           ),
      .user_waitrequest                              ( split_user_waitrequest    ),

      // Reconfig Steamer AVMM input
      .strm_read                                     ( rcfg_emb_strm_read        ),
      .strm_write                                    ( rcfg_emb_strm_write       ),
      .strm_address                                  ( rcfg_emb_strm_address     ),
      .strm_writedata                                ( rcfg_emb_strm_writedata   ),
      .strm_read_write                               ( rcfg_emb_strm_read_write  ),
      .strm_waitrequest                              ( rcfg_emb_strm_waitrequest ),

      // ODI AVMM input
      .odi_read                                      ( odi_read                       ),
      .odi_write                                     ( odi_write                       ),
      .odi_address                                   ( odi_address                       ),
      .odi_writedata                                 ( odi_writedata                       ),
      .odi_read_write                                ( odi_read_write                       ),
      .odi_waitrequest                               (                             ),

      // ADME AVMM input
      .jtag_read                                     ( split_jtag_read           ),
      .jtag_write                                    ( split_jtag_write          ),
      .jtag_address                                  ( split_jtag_address        ),
      .jtag_writedata                                ( split_jtag_writedata      ),
      .jtag_read_write                               ( jtag_read_write           ),
      .jtag_waitrequest                              ( split_jtag_waitrequest    ),

      // AVMM output the channel and the CSR
      .avmm_waitrequest                              ( chnl_waitrequest          ),
      .avmm_read                                     ( chnl_read                 ),
      .avmm_write                                    ( chnl_write                ),
      .avmm_address                                  ( pre_avmm_address              ),
      .avmm_writedata                                ( expanded_avmm_writedata   )
    );
  end else begin: g_arbiter_disable
    // Pass through signals
    assign split_user_waitrequest                    = chnl_waitrequest;
    assign chnl_read                                 = split_user_read;
    assign chnl_write                                = split_user_write;
    assign expanded_avmm_writedata                   = split_user_writedata;
    assign pre_avmm_address                              = split_user_address;

  end
endgenerate // End g_arbiter


/**********************************************************************/
// Per Channel instantiations and assignments
/**********************************************************************/
generate for(ig=0;ig<CHANNELS;ig=ig+1) begin: g_optional_chnl_reconfig_logic

    /**********************************************************************/
    // Instantiate the Soft CSR
    /**********************************************************************/
    if(dbg_embedded_debug_enable) begin: g_avmm_csr_enabled

      // Instantiate wires as part of generate to avoid warnings about unused wires.
      // AVMM reconfiguration signals for embedded debug
      wire [CHANNELS-1:0]             debug_write;
      wire [CHANNELS-1:0]             debug_read;
      wire [CHANNELS-1:0]             debug_waitrequest;
      wire [CHANNELS*8-1:0]           debug_readdata;

      // avmm arbitration for soft csr and channel
      assign debug_read       [ig]      = (pre_avmm_address[ig*ADDR_BITS+AVMM_OFFSET]) ? chnl_read          [ig]      : 1'b0;
      assign debug_write      [ig]      = (pre_avmm_address[ig*ADDR_BITS+AVMM_OFFSET]) ? chnl_write         [ig]      : 1'b0;
      assign pre_avmm_read        [ig]      = (pre_avmm_address[ig*ADDR_BITS+AVMM_OFFSET]) ? 1'b0                         : chnl_read         [ig];
      assign pre_avmm_write       [ig]      = (pre_avmm_address[ig*ADDR_BITS+AVMM_OFFSET]) ? 1'b0                         : chnl_write        [ig];
      assign chnl_waitrequest [ig]      = (pre_avmm_address[ig*ADDR_BITS+AVMM_OFFSET]) ? debug_waitrequest  [ig]      : pre_avmm_waitrequest  [ig];
      assign chnl_readdata    [ig*8+:8] = (pre_avmm_address[ig*ADDR_BITS+AVMM_OFFSET]) ? debug_readdata     [ig*8+:8] : pre_avmm_readdata     [ig*8+:8];


      alt_xcvr_native_avmm_csr_etile #(
        .channels                            ( CHANNELS                            ),
        .channel_num                         ( ig                                  ),
	.addr_width		                       ( NUM_CSR_BITS                        ),
        .dbg_user_identifier                 ( dbg_user_identifier                 ),
        .duplex_mode                         ( duplex_mode                         ),
        .is_dual_channel                     ( is_dual_channel                     ),
        .dbg_capability_reg_enable           ( dbg_capability_reg_enable           ),
        .dbg_stat_soft_logic_enable          ( dbg_stat_soft_logic_enable          ),
        .dbg_ctrl_soft_logic_enable          ( dbg_ctrl_soft_logic_enable          ),
        .rcfg_emb_strm_enable                ( RCFG_EMB_STRM_ENABLED               ),
        .rcfg_emb_strm_cfg_sel_width         ( RCFG_EMB_STRM_CFG_SEL_WIDTH         ),
        .rcp_load_enable                     ( RCP_LOAD_ENABLE                     )
      ) embedded_debug_soft_csr (
        // avmm signals
        .avmm_clk                            ( avmm_clk                 [ig]                        ),
        .avmm_reset                          ( avmm_reset               [ig]                        ),
        .avmm_address                        ( pre_avmm_address             [ig*ADDR_BITS+:NUM_CSR_BITS] ),
        .avmm_writedata                      ( pre_avmm_writedata           [ig*8+:8]                   ),
        .avmm_write                          ( debug_write              [ig]                        ),
        .avmm_read                           ( debug_read               [ig]                        ),
        .avmm_readdata                       ( debug_readdata           [ig*8+:8]                   ),
        .avmm_waitrequest                    ( debug_waitrequest        [ig]                        ),

        // input status signals from the channel
        .rx_is_lockedtodata                  ( in_rx_is_lockedtodata    [ig]       ),
        .tx_transfer_ready                   ( in_tx_transfer_ready     [ig]       ),
        .rx_transfer_ready                   ( in_rx_transfer_ready     [ig]       ),

        // input status from the reset controller
        .tx_ready                            ( in_tx_ready              [ig]       ),
        .rx_ready                            ( in_rx_ready              [ig]       ),

        // input from rx de-skew
        .rx_dskw_min_mkr                     ( in_rx_dskw_min_mkr       [ig]    ),

        // input control signals
        .rx_analogreset                      ( in_rx_analogreset        [ig]       ),
        .rx_digitalreset                     ( in_rx_digitalreset       [ig]       ),
        .tx_analogreset                      ( in_tx_analogreset        [ig]       ),
        .tx_digitalreset                     ( in_tx_digitalreset       [ig]       ),

	//ical
        .ical_cur_state                      ( 8'h00  ),
        .intrpt_state                        ( 8'h00  ),
        .ical_in_progress                    ( 1'b0       ),
        .ical_finish                         ( 1'b1       ),
        .ical_timeout                        ( 1'b0       ),
        .r_user_ical_req                     (            ),

        // embedded reconfig signals
        .rcfg_emb_strm_busy                  ( rcfg_emb_strm_busy       [ig]                                                          ),
        .rcfg_emb_strm_chan_sel              ( rcfg_emb_strm_chan_sel   [ig]                                                          ),
        .rcfg_emb_strm_cfg_sel               ( rcfg_emb_strm_cfg_sel    [ig*RCFG_EMB_STRM_CFG_SEL_WIDTH+:RCFG_EMB_STRM_CFG_SEL_WIDTH] ),
        .rcfg_emb_strm_bcast_en              ( rcfg_emb_strm_bcast_en   [ig]                                                          ),
        .rcfg_emb_strm_cfg_load              ( rcfg_emb_strm_cfg_load   [ig]                                                          ),

        // recipe load signals
        .rcp_load_busy                       ( rcp_load_busy                     ),
        .rcp_load_finish                     ( rcp_load_finish                   ),
        .rcp_load_timeout                    ( rcp_load_timeout                  ),
        .rcp_load_state                      ( rcp_load_state                    ),
        .rcp_load_mail_state                 ( rcp_load_mail_state               ),
        .chnl_id                              (chnl_id                           ),
        .rcp_load_rcp_sel                    ( rcp_load_rcp_sel   [ig*3 +: 3]           ),
        .rcp_load                            ( rcp_load   [ig]                   ),

        // output control signals to the channel
        .csr_rx_analogreset                  ( out_rx_analogreset       [ig]       ),
        .csr_rx_digitalreset                 ( out_rx_digitalreset      [ig]       ),
        .csr_tx_analogreset                  ( out_tx_analogreset       [ig]       ),
        .csr_tx_digitalreset                 ( out_tx_digitalreset      [ig]       )
      );

    end else begin: g_avmm_csr_disable
      // do a pass though for control signals when no embedded debug
      assign out_rx_analogreset     [ig]  = in_rx_analogreset      [ig];
      assign out_rx_digitalreset    [ig]  = in_rx_digitalreset     [ig];
      assign out_tx_analogreset     [ig]  = in_tx_analogreset      [ig];
      assign out_tx_digitalreset    [ig]  = in_tx_digitalreset     [ig];

      // assign these signals to ground when no embedded debug
      assign pre_avmm_read        [ig]        = chnl_read              [ig];
      assign pre_avmm_write       [ig]        = chnl_write             [ig];
      assign chnl_waitrequest [ig]        = pre_avmm_waitrequest       [ig];
      assign chnl_readdata    [ig*8+:8]   = pre_avmm_readdata          [ig*8+:8];
    end

  end // End for Loop for channels
endgenerate

/**********************************************************************/







    // Instantiate iCAL Recipe Load
    /**********************************************************************/
    if(RCP_LOAD_ENABLE) begin: g_rcp_load
      alt_xcvr_native_rcp_load_top_y5roe6q #(
        .CHANNELS                        ( CHANNELS               ),
        .AVMM_ADD_WIDTH                  ( ADDR_BITS              ),
        .AVMM_DATA_WIDTH                 ( 8                      ),
        .rcfg_profile_cnt                ( RCFG_PROFILE_CNT       )
      )rcp_load_top_inst(
        .clk                            ( avmm_clk[0]             ),
        .reset                          ( |avmm_reset              ),   ///// Add reset??
        .user_write                          ( pre_avmm_write          ),
        .user_read                           ( pre_avmm_read           ),
        .user_address                        ( pre_avmm_address        ),
        .user_writedata                      ( pre_avmm_writedata      ),
        .user_readdata                       ( pre_avmm_readdata       ),
        .user_waitrequest                    ( pre_avmm_waitrequest    ),				//output

        .avmm_write                          ( avmm_write_after_ical          ),
        .avmm_read                           ( avmm_read_after_ical           ),
        .avmm_address                        ( avmm_address_after_ical        ),
        .avmm_waitrequest                    ( avmm_waitrequest_after_ical    ),
        .avmm_writedata                      ( avmm_writedata_after_ical      ),
        .avmm_readdata                       ( avmm_readdata_after_ical       ),

        .rcp_load_rcp_sel                      ( rcp_load_rcp_sel[2:0]      ),
        .rcp_load                              ( rcp_load[0]                ),
        .rcp_load_busy                         ( rcp_load_busy              ),
        .rcp_load_timeout                      ( rcp_load_timeout           ),
        .rcp_load_finish                       ( rcp_load_finish            ),

        .rcp_load_state                        ( rcp_load_state             ),
        .rcp_load_mail_state                   ( rcp_load_mail_state        ),
         .chnl_id                              (chnl_id                     )
      );
    end else begin: g_rcp_load_disabled
      // pass though avmm signals when no ical ip
      assign avmm_write_after_ical               = pre_avmm_write      ;
      assign avmm_read_after_ical                = pre_avmm_read       ;
      assign avmm_address_after_ical             = pre_avmm_address       ;
      assign avmm_writedata_after_ical           = pre_avmm_writedata  ;
      assign pre_avmm_readdata                   = avmm_readdata_after_ical       ;
      assign pre_avmm_waitrequest                = avmm_waitrequest_after_ical    ;
      assign  rcp_load_busy                = {1'b0};
      assign  rcp_load_timeout             = {1'b0};
      assign  rcp_load_finish              = {1'b1};
      assign  rcp_load_state               = {5'b0_0000};
      assign  rcp_load_mail_state          = {8'h00};
      assign  chnl_id                      = {8'h00};

  end


/**********************************************************************/
// Per Channel(SERDES) instantiations
/**********************************************************************/
generate if(ENABLE_PMA_RESET) begin: g_pma_spico_reset_enabled

// slipt channel interfaces for avmm*_after_ical, used as inputs to pma/spico reset block
    wire [DUAL_CHANNELS-1:0]             pre_pma_reset_write;
    wire [DUAL_CHANNELS-1:0]             pre_pma_reset_read;
    wire [DUAL_CHANNELS-1:0]             pre_pma_reset_waitrequest;
    wire [DUAL_CHANNELS*8-1:0]           pre_pma_reset_readdata;
    wire [DUAL_CHANNELS*8-1:0]           pre_pma_reset_writedata;
    wire [DUAL_CHANNELS*ADDR_BITS-1:0]   pre_pma_reset_address;

// combine channel interfaces from pma_reset*avmm, used feeds to final out avmm bus after pma/spico reset block
    wire [DUAL_CHANNELS-1:0]             pma_reset_write;
    wire [DUAL_CHANNELS-1:0]             pma_reset_read;
    wire [DUAL_CHANNELS-1:0]             pma_reset_waitrequest;
    wire [DUAL_CHANNELS*8-1:0]           pma_reset_readdata;
    wire [DUAL_CHANNELS*8-1:0]           pma_reset_writedata;
    wire [DUAL_CHANNELS*ADDR_BITS-1:0]   pma_reset_address;

	if (is_dual_channel) begin: g_pma_reset_dual
		for(ig=0;ig<DUAL_CHANNELS;ig=ig+1) begin : g_pma_reset_avmm_signals
			//dual channel: pass avmm*after_ical bus on channel(0,2,4...) to pre_pma_reset* bus on bit(0,1,2...)
			assign pre_pma_reset_address[ADDR_BITS*ig+:ADDR_BITS]	= avmm_address_after_ical[2*ADDR_BITS*ig+:ADDR_BITS];
			assign pre_pma_reset_read[ig]							= avmm_read_after_ical[2*ig];
			assign pre_pma_reset_write[ig]							= avmm_write_after_ical[2*ig];
			assign pre_pma_reset_writedata[8*ig+:8]					= avmm_writedata_after_ical[16*ig+:8];
			assign avmm_readdata_after_ical[16*ig+:16]				= {avmm_readdata[16*ig+8+:8],pre_pma_reset_readdata[8*ig+:8]};
			assign avmm_waitrequest_after_ical[2*ig+:2]				= {avmm_waitrequest[2*ig+1],pre_pma_reset_waitrequest[ig]};

			//dual channel: pass avmm*after_ical bus on channel(1,3,5...) to avmm bus on channel(1,3,5...)
			//dual channel: pass pma_reset* bus on channel(0,1,2...) to avmm bus on channel(0,2,4...)
			assign avmm_address[2*ADDR_BITS*ig+:2*ADDR_BITS]	= {avmm_address_after_ical[2*ADDR_BITS*ig+ADDR_BITS+:ADDR_BITS],pma_reset_address[ADDR_BITS*ig+:ADDR_BITS]};
			assign avmm_read[2*ig+:2]							= {avmm_read_after_ical[2*ig+1],pma_reset_read[ig]};
			assign avmm_write[2*ig+:2]							= {avmm_write_after_ical[2*ig+1],pma_reset_write[ig]};
			assign avmm_writedata[16*ig+:16]					= {avmm_writedata_after_ical[16*ig+8+:8],pma_reset_writedata[8*ig+:8]};
			assign pma_reset_waitrequest[ig]					= avmm_waitrequest[2*ig];
			assign pma_reset_readdata[8*ig+:8]					= avmm_readdata[16*ig+:8];
		end
	end else begin: g_pma_reset_single
			//single channel: pass avmm*after_ical bus to pre_pma_reset* bus
			assign pre_pma_reset_address			= avmm_address_after_ical;
			assign pre_pma_reset_read 				= avmm_read_after_ical;
			assign pre_pma_reset_write				= avmm_write_after_ical;
			assign pre_pma_reset_writedata			= avmm_writedata_after_ical;
			assign avmm_waitrequest_after_ical		= pre_pma_reset_waitrequest;
			assign avmm_readdata_after_ical			= pre_pma_reset_readdata;
			//single channel: pass pma_reset* bus to avmm bus
			assign avmm_address						= pma_reset_address;
			assign avmm_write						= pma_reset_write;
			assign avmm_read						= pma_reset_read;
			assign avmm_writedata					= pma_reset_writedata;
			assign pma_reset_waitrequest			= avmm_waitrequest;
			assign pma_reset_readdata				= avmm_readdata;
	end

	for(ig=0;ig<DUAL_CHANNELS;ig=ig+1) begin: g_pma_spico_reset_logic

		altera_xcvr_pma_spico_reset_etile #(
	.AVMM_ADD_WIDTH                  ( ADDR_BITS              ),
        .AVMM_DATA_WIDTH                 ( 8                      )
		) pma_spico_reset_etile_inst (
        .user_clk                            ( avmm_clk                    [ig]                        ),
        .user_reset                          ( avmm_reset                  [ig]                        ),
        .user_address                        ( pre_pma_reset_address       [ig*ADDR_BITS+:ADDR_BITS]   ),
        .user_writedata                      ( pre_pma_reset_writedata     [ig*8+:8]                   ),
        .user_write                          ( pre_pma_reset_write         [ig]                        ),
        .user_read                           ( pre_pma_reset_read          [ig]                        ),
        .user_readdata                       ( pre_pma_reset_readdata      [ig*8+:8]                   ),
        .user_waitrequest                    ( pre_pma_reset_waitrequest   [ig]                        ),

        .avmm_write                          ( pma_reset_write         [ig]                      ),
        .avmm_read                           ( pma_reset_read          [ig]                      ),
        .avmm_address                        ( pma_reset_address       [ig*ADDR_BITS+:ADDR_BITS] ),
        .avmm_waitrequest                    ( pma_reset_waitrequest   [ig]                      ),
        .avmm_writedata                      ( pma_reset_writedata     [ig*8+:8]                 ),
        .avmm_readdata                       ( pma_reset_readdata      [ig*8+:8]                 ),

        .pma_reset                           ( pma_reset               [ig]                      ),
        .spico_reset                         ( spico_reset             [ig]                      ),
        .pma_reset_busy                      ( pma_reset_busy          [ig]                      ),
        .pma_spico_reset_timeout             ( pma_spico_reset_timeout [ig]                      )


		);

	end // End for Loop for channels
end else begin: g_pma_spico_reset_disabled
      assign avmm_write                          = avmm_write_after_ical      ;
      assign avmm_read                           = avmm_read_after_ical       ;
      assign avmm_address                        = avmm_address_after_ical       ;
      assign avmm_writedata                      = avmm_writedata_after_ical  ;
      assign avmm_readdata_after_ical            = avmm_readdata       ;
      assign avmm_waitrequest_after_ical         = avmm_waitrequest    ;
      assign pma_reset_busy                      = {DUAL_CHANNELS{1'b0}};
      assign pma_spico_reset_timeout             = {DUAL_CHANNELS{1'b0}};


end
endgenerate





endmodule
