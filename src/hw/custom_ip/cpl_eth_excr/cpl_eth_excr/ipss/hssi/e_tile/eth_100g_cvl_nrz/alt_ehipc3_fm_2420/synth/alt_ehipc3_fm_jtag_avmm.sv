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


`timescale 1ps/1ps

module alt_ehipc3_fm_jtag_avmm
#(
    parameter MAX_XCVR_CH = 4,
    parameter NUM_LANES_SL = 1,
    parameter CORE_VARIANT = 0,
    parameter ACTIVE_CHANNEL = 0
)
(
    // Clock and Reset
    input   wire 			        i_reconfig_clk,
    input   wire 				i_reconfig_reset,

    // EHIP Reconfig Interface
    input   wire    [20:0] 		        i_eth_reconfig_addr,
    input   wire 				i_eth_reconfig_read,
    input   wire 				i_eth_reconfig_write,
    input   wire    [31:0] 			i_eth_reconfig_writedata,
    output  wire    [31:0] 			o_eth_reconfig_readdata,
    output  wire 			        o_eth_reconfig_readdata_valid,
    output  wire  			        o_eth_reconfig_waitrequest,

    // EHIP Combined Reconfig Interface
    output  wire    [20:0] 			i_eth_reconfig_addr_jtag_arb,
    output  wire 				i_eth_reconfig_read_jtag_arb,
    output  wire 				i_eth_reconfig_write_jtag_arb,
    output  wire    [31:0] 			i_eth_reconfig_writedata_jtag_arb,
    input   wire    [31:0] 			o_eth_reconfig_readdata_jtag_arb,
    input   wire 			        o_eth_reconfig_readdata_valid_jtag_arb,
    input   wire  			        o_eth_reconfig_waitrequest_jtag_arb,

    // ELANE Reconfig Interface
    input   wire    [19*NUM_LANES_SL-1:0]       i_sl_eth_reconfig_addr,
    input   wire    [NUM_LANES_SL-1:0]          i_sl_eth_reconfig_read,
    input   wire    [NUM_LANES_SL-1:0]          i_sl_eth_reconfig_write,
    input   wire    [32*NUM_LANES_SL-1:0]       i_sl_eth_reconfig_writedata,
    output  wire    [32*NUM_LANES_SL-1:0]       o_sl_eth_reconfig_readdata,
    output  wire    [NUM_LANES_SL-1:0]          o_sl_eth_reconfig_readdata_valid,
    output  wire    [NUM_LANES_SL-1:0]          o_sl_eth_reconfig_waitrequest,

    // ELANE Reconfig Interface
    output  wire    [19*NUM_LANES_SL-1:0]       i_sl_eth_reconfig_addr_jtag_arb,
    output  wire    [NUM_LANES_SL-1:0]          i_sl_eth_reconfig_read_jtag_arb,
    output  wire    [NUM_LANES_SL-1:0]          i_sl_eth_reconfig_write_jtag_arb,
    output  wire    [32*NUM_LANES_SL-1:0]       i_sl_eth_reconfig_writedata_jtag_arb,
    input   wire    [32*NUM_LANES_SL-1:0]       o_sl_eth_reconfig_readdata_jtag_arb,
    input   wire    [NUM_LANES_SL-1:0]          o_sl_eth_reconfig_readdata_valid_jtag_arb,
    input   wire    [NUM_LANES_SL-1:0]          o_sl_eth_reconfig_waitrequest_jtag_arb,

    // FEC Reconfig Interface
    input   wire    [11-1:0]                    i_rsfec_reconfig_addr,
    input   wire                                i_rsfec_reconfig_read,
    input   wire                                i_rsfec_reconfig_write,
    input   wire    [8-1:0]                     i_rsfec_reconfig_writedata,
    output  wire    [8-1:0]                     o_rsfec_reconfig_readdata,
    output  wire                                o_rsfec_reconfig_waitrequest,

    // FEC Combined Reconfig Interface
    output  wire    [11-1:0]                    i_rsfec_reconfig_addr_jtag_arb,
    output  wire                                i_rsfec_reconfig_read_jtag_arb,
    output  wire                                i_rsfec_reconfig_write_jtag_arb,
    output  wire    [8-1:0]                     i_rsfec_reconfig_writedata_jtag_arb,
    input   wire    [8-1:0]                     o_rsfec_reconfig_readdata_jtag_arb,
    input   wire                                o_rsfec_reconfig_waitrequest_jtag_arb,

    // XCVR Reconfig Interface
    input   wire    [19*MAX_XCVR_CH-1:0]        i_xcvr_reconfig_address,
    input   wire    [MAX_XCVR_CH-1:0]           i_xcvr_reconfig_read,
    input   wire    [MAX_XCVR_CH-1:0]           i_xcvr_reconfig_write,
    input   wire    [8*MAX_XCVR_CH-1:0]         i_xcvr_reconfig_writedata,
    output  wire    [8*MAX_XCVR_CH-1:0]         o_xcvr_reconfig_readdata,
    output  wire    [MAX_XCVR_CH-1:0]           o_xcvr_reconfig_waitrequest,

    // XCVR Combined Reconfig Interface
    output  wire    [19*MAX_XCVR_CH-1:0]        i_xcvr_reconfig_address_jtag_arb,
    output  wire    [MAX_XCVR_CH-1:0]           i_xcvr_reconfig_read_jtag_arb,
    output  wire    [MAX_XCVR_CH-1:0]           i_xcvr_reconfig_write_jtag_arb,
    output  wire    [8*MAX_XCVR_CH-1:0]         i_xcvr_reconfig_writedata_jtag_arb,
    input   wire    [8*MAX_XCVR_CH-1:0]         o_xcvr_reconfig_readdata_jtag_arb,
    input   wire    [MAX_XCVR_CH-1:0]           o_xcvr_reconfig_waitrequest_jtag_arb

);


    localparam EHIP_VAR     = (CORE_VARIANT == 2) || (CORE_VARIANT == 3 && ACTIVE_CHANNEL == 1);
    localparam ELANE_VAR    = (CORE_VARIANT == 0) || (CORE_VARIANT == 1) || (CORE_VARIANT == 3 && ACTIVE_CHANNEL == 0);
    // JTAG Master
    wire    [23:0]      jtag_addr;
    wire                jtag_read;
    wire    [31:0]      jtag_readdata;
    wire                jtag_write;
    wire    [31:0]      jtag_writedata;
    wire                jtag_waitrequest;
    wire                jtag_readdata_valid;
    wire    [31:0]      av_addr;
    wire    [3:0]       byteenable; // Dummy wire

    assign jtag_addr = av_addr[25:2];

    alt_ehipc3_fm_jtag_int jtag_master_alt_ehipc3_fm (
        .clk_clk                (i_reconfig_clk),
        .clk_reset_reset        (i_reconfig_reset),
        .master_address         (av_addr),
        .master_readdata        (jtag_readdata),
        .master_read            (jtag_read),
        .master_write           (jtag_write),
        .master_writedata       (jtag_writedata),
        .master_waitrequest     (jtag_waitrequest),
        .master_readdatavalid   (jtag_readdata_valid),
        .master_byteenable      (byteenable),
        .master_reset_reset     ()
    );


    // Design Example AVMM Decoding

    wire                        eth_cs;
    wire                        eth_jtag_read;
    wire                        eth_jtag_write;
    wire                        eth_jtag_waitrequest;

    wire    [NUM_LANES_SL-1:0]  sl_eth_cs;
    wire    [NUM_LANES_SL-1:0]  sl_eth_jtag_read;
    wire    [NUM_LANES_SL-1:0]  sl_eth_jtag_write;
    wire    [NUM_LANES_SL-1:0]  sl_eth_jtag_readdata_valid;
    wire    [NUM_LANES_SL-1:0]  sl_eth_jtag_waitrequest;

    wire                        rsfec_cs;
    wire                        rsfec_jtag_read;
    wire                        rsfec_jtag_write;
    wire                        rsfec_jtag_waitrequest;
    wire                        rsfec_jtag_readdata_valid;

    wire    [MAX_XCVR_CH-1:0]   xcvr_cs;
    wire    [MAX_XCVR_CH-1:0]   xcvr_jtag_read;
    wire    [MAX_XCVR_CH-1:0]   xcvr_jtag_write;
    wire    [MAX_XCVR_CH-1:0]   xcvr_jtag_readdata_valid;
    wire    [MAX_XCVR_CH-1:0]   xcvr_jtag_waitrequest;

    genvar ch;
    generate
    if (EHIP_VAR) begin: EHIP_AVMM_CS

        assign  eth_cs                      =   (jtag_addr >= 24'h0_00000) && (jtag_addr <= 24'h0_00FFF);
        assign  eth_jtag_read               =   jtag_read && eth_cs;
        assign  eth_jtag_write              =   jtag_write && eth_cs;

        assign  rsfec_cs                    =   (jtag_addr >= 24'h0_10000) && (jtag_addr <= 24'h0_107FF);
        assign  rsfec_jtag_read             =   jtag_read && rsfec_cs;
        assign  rsfec_jtag_write            =   jtag_write && rsfec_cs;
        assign  rsfec_jtag_readdata_valid   =   rsfec_jtag_read && !rsfec_jtag_waitrequest;

        for (ch = 0; ch < MAX_XCVR_CH; ch=ch+1) begin : XCVR_AVMM_CS
            assign xcvr_cs[ch]                  = (jtag_addr[23:20] == ch + 1);
            assign xcvr_jtag_read[ch]           = jtag_read && xcvr_cs[ch];
            assign xcvr_jtag_write[ch]          = jtag_write && xcvr_cs[ch];
            assign xcvr_jtag_readdata_valid[ch] = xcvr_jtag_read[ch] && !xcvr_jtag_waitrequest[ch];
        end

        assign  jtag_readdata_valid =   o_eth_reconfig_readdata_valid_jtag_arb |
                                        rsfec_jtag_readdata_valid |
                                        (|xcvr_jtag_readdata_valid);

        assign  jtag_waitrequest =  eth_cs      ? eth_jtag_waitrequest :
                                    rsfec_cs    ? rsfec_jtag_waitrequest:
                                    xcvr_cs[0]  ? xcvr_jtag_waitrequest[0]:
                                    xcvr_cs[1]  ? xcvr_jtag_waitrequest[1]:
                                    xcvr_cs[2]  ? xcvr_jtag_waitrequest[2]:
                                    xcvr_cs[3]  ? xcvr_jtag_waitrequest[3]: 1'b0;

        assign  jtag_readdata =     o_eth_reconfig_readdata_valid_jtag_arb  ? o_eth_reconfig_readdata_jtag_arb :
                                    rsfec_jtag_readdata_valid   ? {24'b0, o_rsfec_reconfig_readdata_jtag_arb} :
                                    xcvr_jtag_readdata_valid[0] ? {24'b0, o_xcvr_reconfig_readdata_jtag_arb[7:0]} :
                                    xcvr_jtag_readdata_valid[1] ? {24'b0, o_xcvr_reconfig_readdata_jtag_arb[15:8]} :
                                    xcvr_jtag_readdata_valid[2] ? {24'b0, o_xcvr_reconfig_readdata_jtag_arb[23:16]} :
                                    xcvr_jtag_readdata_valid[3] ? {24'b0, o_xcvr_reconfig_readdata_jtag_arb[31:24]} : 32'hdeadc0de;

    end
    else if (ELANE_VAR) begin: ELANE_AVMM_CS

        wire    sel_sl_eth                  =   (jtag_addr[20:0] >= 21'h0_00000) && (jtag_addr[20:0] <= 21'h0_00FFF);
        wire    rsfec_cs                    =   (jtag_addr[20:0] >= 21'h0_10000) && (jtag_addr[20:0] <= 21'h0_107FF);
        wire    sel_xcvr                    =   (jtag_addr[20:0] >= 21'h1_00000) && (jtag_addr[20:0] <= 21'h1_FFFFF);

        // One RSFEC bus for all channels
        assign  rsfec_jtag_read             =   jtag_read && rsfec_cs;
        assign  rsfec_jtag_write            =   jtag_write && rsfec_cs;
        assign  rsfec_jtag_readdata_valid   =   rsfec_jtag_read && !rsfec_jtag_waitrequest;

        // Per-channel JTAG values
        wire    [32*NUM_LANES_SL-1:0]   jtag_readdata_int;
        wire    [NUM_LANES_SL-1:0]      jtag_readdata_valid_int;
        wire    [NUM_LANES_SL-1:0]      jtag_waitrequest_int;

        wire    [2:0] active_ch = jtag_addr[23:21];


        for (ch = 0; ch < NUM_LANES_SL; ch = ch + 1) begin : AVMM_REMAP
            assign  sl_eth_cs[ch]                   = (active_ch == ch) && sel_sl_eth;
            assign  sl_eth_jtag_read[ch]            = jtag_read && sl_eth_cs[ch];
            assign  sl_eth_jtag_write[ch]           = jtag_write && sl_eth_cs[ch];

            assign  xcvr_cs[ch]                     = (active_ch == ch) && sel_xcvr;
            assign  xcvr_jtag_read[ch]              = jtag_read && xcvr_cs[ch];
            assign  xcvr_jtag_write[ch]             = jtag_write && xcvr_cs[ch];
            assign  xcvr_jtag_readdata_valid[ch]    = xcvr_jtag_read[ch] && !xcvr_jtag_waitrequest[ch];


            assign  jtag_readdata_valid_int[ch] =   o_sl_eth_reconfig_readdata_valid_jtag_arb[ch] |
                                                    rsfec_jtag_readdata_valid |
                                                    xcvr_jtag_readdata_valid[ch];

            assign  jtag_waitrequest_int[ch] =  sl_eth_cs[ch]   ? sl_eth_jtag_waitrequest[ch] :
                                                rsfec_cs        ? rsfec_jtag_waitrequest :
                                                xcvr_cs[ch]     ? xcvr_jtag_waitrequest[ch] : 1'b0;

            assign  jtag_readdata_int[ch*32+:32] =  o_sl_eth_reconfig_readdata_valid_jtag_arb[ch]  ? o_sl_eth_reconfig_readdata_jtag_arb[ch*32+:32] :
                                                    rsfec_jtag_readdata_valid   ? o_rsfec_reconfig_readdata_jtag_arb :
                                                    xcvr_jtag_readdata_valid[ch] ? {24'b0, o_xcvr_reconfig_readdata_jtag_arb[ch*8+:8]} : 32'hdeadc0de;
        end

        // Combine JTAG values
        assign  jtag_readdata_valid = |jtag_readdata_valid_int;
        assign  jtag_readdata       = jtag_readdata_int[active_ch*32+:32];
        assign  jtag_waitrequest    = |jtag_waitrequest_int;

    end
    //else if (DR_VAR) begin: DR_AVMM_CS
    //    // DR register map here
    //end


    // Combine AVMMs
    if (EHIP_VAR) begin: ETH_RECONFIG_ARB

        alt_ehipc3_rcfg_arb #(
            .total_masters  (3), // Reuse KR arbiter and leave one bus unused
            .channels       (1),
            .address_width  (21),
            .data_width     (32)
        ) arb_jtag_eth (

            // Basic AVMM inputs
            .reconfig_clk       (i_reconfig_clk),
            .reconfig_reset     (i_reconfig_reset),

            // User EHIP Reconfig
            .user_address       (i_eth_reconfig_addr),
            .user_read          (i_eth_reconfig_read),
            .user_write         (i_eth_reconfig_write),
            .user_writedata     (i_eth_reconfig_writedata),
            .user_read_write    (i_eth_reconfig_read || i_eth_reconfig_write),
            .user_waitrequest   (o_eth_reconfig_waitrequest),

            // JTAG EHIP Reconfig
            .cpu_address        (jtag_addr[20:0]),
            .cpu_read           (eth_jtag_read),
            .cpu_write          (eth_jtag_write),
            .cpu_writedata      (jtag_writedata),
            .cpu_read_write     (eth_jtag_read || eth_jtag_write),
            .cpu_waitrequest    (eth_jtag_waitrequest),

            // Unused AVMM Master
            .adapt_address      (21'b0),
            .adapt_read         (1'b0),
            .adapt_write        (1'b0),
            .adapt_writedata    (32'b0),
            .adapt_read_write   (1'b0),
            .adapt_waitrequest  (),

            // Combined EHIP Reconfig
            .avmm_address       (i_eth_reconfig_addr_jtag_arb),
            .avmm_read          (i_eth_reconfig_read_jtag_arb),
            .avmm_write         (i_eth_reconfig_write_jtag_arb),
            .avmm_writedata     (i_eth_reconfig_writedata_jtag_arb),
            .avmm_waitrequest   (o_eth_reconfig_waitrequest_jtag_arb)
        );

    end
    else begin: NO_ETH_RECONFIG_ARB

        assign  i_eth_reconfig_addr_jtag_arb        =   i_eth_reconfig_addr;
        assign  i_eth_reconfig_read_jtag_arb        =   i_eth_reconfig_read;
        assign  i_eth_reconfig_write_jtag_arb       =   i_eth_reconfig_write;
        assign  i_eth_reconfig_writedata_jtag_arb   =   i_eth_reconfig_writedata;
        assign  o_eth_reconfig_waitrequest          =   o_eth_reconfig_waitrequest_jtag_arb;
    end

    assign  o_eth_reconfig_readdata         =   o_eth_reconfig_readdata_jtag_arb;
    assign  o_eth_reconfig_readdata_valid   =   o_eth_reconfig_readdata_valid_jtag_arb;


    if (ELANE_VAR) begin: SL_ETH_RECONFIG_ARB

        for (ch = 0; ch < NUM_LANES_SL; ch=ch+1) begin: SL_ETH_RECONFIG_ARB_INST

        alt_ehipc3_rcfg_arb #(
            .total_masters  (3), // Reuse KR arbiter and leave one bus unused
            .channels       (1),
            .address_width  (19),
            .data_width     (32)
        ) arb_jtag_eth (

            // Basic AVMM inputs
            .reconfig_clk       (i_reconfig_clk),
            .reconfig_reset     (i_reconfig_reset),

            // User EHIP Reconfig
            .user_address       (i_sl_eth_reconfig_addr[ch*19+:19]),
            .user_read          (i_sl_eth_reconfig_read[ch]),
            .user_write         (i_sl_eth_reconfig_write[ch]),
            .user_writedata     (i_sl_eth_reconfig_writedata[ch*32+:32]),
            .user_read_write    (i_sl_eth_reconfig_read[ch] || i_sl_eth_reconfig_write[ch]),
            .user_waitrequest   (o_sl_eth_reconfig_waitrequest[ch]),

            // JTAG EHIP Reconfig
            .cpu_address        (jtag_addr[18:0]),
            .cpu_read           (sl_eth_jtag_read[ch]),
            .cpu_write          (sl_eth_jtag_write[ch]),
            .cpu_writedata      (jtag_writedata),
            .cpu_read_write     (sl_eth_jtag_read[ch] || sl_eth_jtag_write[ch]),
            .cpu_waitrequest    (sl_eth_jtag_waitrequest[ch]),

            // Unused AVMM Master
            .adapt_address      (19'b0),
            .adapt_read         (1'b0),
            .adapt_write        (1'b0),
            .adapt_writedata    (32'b0),
            .adapt_read_write   (1'b0),
            .adapt_waitrequest  (),

            // Combined EHIP Reconfig
            .avmm_address       (i_sl_eth_reconfig_addr_jtag_arb[ch*19+:19]),
            .avmm_read          (i_sl_eth_reconfig_read_jtag_arb[ch]),
            .avmm_write         (i_sl_eth_reconfig_write_jtag_arb[ch]),
            .avmm_writedata     (i_sl_eth_reconfig_writedata_jtag_arb[ch*32+:32]),
            .avmm_waitrequest   (o_sl_eth_reconfig_waitrequest_jtag_arb[ch])
        );
        end

    end
    else begin: NO_SL_ETH_RECONFIG_ARB

        assign  i_sl_eth_reconfig_addr_jtag_arb         =   i_sl_eth_reconfig_addr;
        assign  i_sl_eth_reconfig_read_jtag_arb         =   i_sl_eth_reconfig_read;
        assign  i_sl_eth_reconfig_write_jtag_arb        =   i_sl_eth_reconfig_write;
        assign  i_sl_eth_reconfig_writedata_jtag_arb    =   i_sl_eth_reconfig_writedata;
        assign  o_sl_eth_reconfig_waitrequest           =   o_sl_eth_reconfig_waitrequest_jtag_arb;
    end

    assign  o_sl_eth_reconfig_readdata          =   o_sl_eth_reconfig_readdata_jtag_arb;
    assign  o_sl_eth_reconfig_readdata_valid    =   o_sl_eth_reconfig_readdata_valid_jtag_arb;


    alt_ehipc3_rcfg_arb #(
        .total_masters  (3), // Reuse KR arbiter and leave one bus unused
        .channels       (1),
        .address_width  (11),
        .data_width     (8)
    ) arb_jtag_rsfec (

        // Basic AVMM inputs
        .reconfig_clk       (i_reconfig_clk),
        .reconfig_reset     (i_reconfig_reset),

        // User FEC Reconfig
        .user_address       (i_rsfec_reconfig_addr),
        .user_read          (i_rsfec_reconfig_read),
        .user_write         (i_rsfec_reconfig_write),
        .user_writedata     (i_rsfec_reconfig_writedata),
        .user_read_write    (i_rsfec_reconfig_read || i_rsfec_reconfig_write),
        .user_waitrequest   (o_rsfec_reconfig_waitrequest),

        // JTAG FEC Reconfig
        .cpu_address        (jtag_addr[10:0]),
        .cpu_read           (rsfec_jtag_read),
        .cpu_write          (rsfec_jtag_write),
        .cpu_writedata      (jtag_writedata[7:0]),
        .cpu_read_write     (rsfec_jtag_read || rsfec_jtag_write),
        .cpu_waitrequest    (rsfec_jtag_waitrequest),

        // Unused AVMM Master
        .adapt_address      (11'b0),
        .adapt_read         (1'b0),
        .adapt_write        (1'b0),
        .adapt_writedata    (8'b0),
        .adapt_read_write   (1'b0),
        .adapt_waitrequest  (),

        // Combined FEC Reconfig
        .avmm_address       (i_rsfec_reconfig_addr_jtag_arb),
        .avmm_read          (i_rsfec_reconfig_read_jtag_arb),
        .avmm_write         (i_rsfec_reconfig_write_jtag_arb),
        .avmm_writedata     (i_rsfec_reconfig_writedata_jtag_arb),
        .avmm_waitrequest   (o_rsfec_reconfig_waitrequest_jtag_arb)
    );

    assign o_rsfec_reconfig_readdata = o_rsfec_reconfig_readdata_jtag_arb;


    for (ch = 0; ch < MAX_XCVR_CH; ch=ch+1) begin : XCVR_JTAG_ARB

    alt_ehipc3_rcfg_arb #(
        .total_masters  (3), // Reuse KR arbiter and leave one bus unused
        .channels       (1),
        .address_width  (19),
        .data_width     (8)
    ) arb_jtag_xcvr (

        // Basic AVMM inputs
        .reconfig_clk       (i_reconfig_clk),
        .reconfig_reset     (i_reconfig_reset),

        // User XCVR Reconfig
        .user_address       (i_xcvr_reconfig_address[ch*19+:19]),
        .user_read          (i_xcvr_reconfig_read[ch]),
        .user_write         (i_xcvr_reconfig_write[ch]),
        .user_writedata     (i_xcvr_reconfig_writedata[ch*8+:8]),
        .user_read_write    (i_xcvr_reconfig_read[ch] || i_xcvr_reconfig_write[ch]),
        .user_waitrequest   (o_xcvr_reconfig_waitrequest[ch]),

        // JTAG XCVR Reconfig
        .cpu_address        (jtag_addr[18:0]),
        .cpu_read           (xcvr_jtag_read[ch]),
        .cpu_write          (xcvr_jtag_write[ch]),
        .cpu_writedata      (jtag_writedata[7:0]),
        .cpu_read_write     (xcvr_jtag_read[ch] | xcvr_jtag_write[ch]),
        .cpu_waitrequest    (xcvr_jtag_waitrequest[ch]),

        // Unused AVMM Master
        .adapt_address      (19'b0),
        .adapt_read         (1'b0),
        .adapt_write        (1'b0),
        .adapt_writedata    (8'b0),
        .adapt_read_write   (1'b0),
        .adapt_waitrequest  (),

        // Combined XCVR Reconfig
        .avmm_address       (i_xcvr_reconfig_address_jtag_arb[ch*19+:19]),
        .avmm_read          (i_xcvr_reconfig_read_jtag_arb[ch]),
        .avmm_write         (i_xcvr_reconfig_write_jtag_arb[ch]),
        .avmm_writedata     (i_xcvr_reconfig_writedata_jtag_arb[ch*8+:8]),
        .avmm_waitrequest   (o_xcvr_reconfig_waitrequest_jtag_arb[ch])
    );

    end

    assign o_xcvr_reconfig_readdata = o_xcvr_reconfig_readdata_jtag_arb;


    endgenerate

endmodule
