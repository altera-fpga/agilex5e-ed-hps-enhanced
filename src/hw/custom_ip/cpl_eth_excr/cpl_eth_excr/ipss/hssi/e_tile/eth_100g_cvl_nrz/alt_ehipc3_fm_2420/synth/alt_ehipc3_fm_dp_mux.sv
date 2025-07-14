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


//=============================================================================
//Description
//
//  Optional datapath mux for a single-lane EHIP module
//      * Includes all the EHIP Datapath interfaces and a PMA direct interface
//         * The PMA direct interface is a direct 80b mapping to the AIB port
//         * The remaining interfaces are mapped and AIB encoded
//      * When INCLUDE_ALTERNATE_PORTS == 0, connects 1 interface, no mux
//         * In this case, the interface is selected based on EHIP_MODE
//      * When INCLUDE_ALTERNATE_PORTS == 1, the interfaces are muxed
//         * i_sl_dp_sel selects which interface drives TX
//         * The RX interfaces don't need muxing
//      * When REGISTER_TX_OUTPUT == 1, register TX parallel data output for better C2P timing
//      * When REGISTER_RX_INPUT  == 1, register RX parallel data input for better P2C timing
//
//=============================================================================
//Declaration

//synthesis translate_off
`timescale 1ns / 1ps
//synthesis translate_on

module alt_ehipc3_fm_dp_mux
import alt_ehipc3_fm_package::*;
#(
    parameter   INCLUDE_ALTERNATE_PORTS =   0,
    parameter   EHIP_MODE               =   "ehip_disable", //ehip modes from BCM
    parameter   REGISTER_TX_OUTPUT      =   0,
    parameter   REGISTER_RX_INPUT       =   0
)
(
    //Clock, reset, and mux select ports
    input   logic               i_sl_clk_tx,
    input   logic               i_sl_clk_rx,
    input   logic               i_sl_tx_rst_n,  //Synchronous, active low
    input   logic               i_sl_rx_rst_n,  //Synchronous, active low
    input   logic   [2:0]       i_sl_dp_sel,    //0=MAC,1=PCS,2=PCS66,3=PMA

    //Shared TX ports for the MAC, PCS, and PCS66 modes
    input   logic               i_sl_stats_snapshot,
    input   logic               i_sl_custom_cadence,
    input   logic               i_sl_deskew,

    // MAC Interface
    input   logic   [63:0]      i_sl_tx_data,
    input   logic               i_sl_tx_error,
    input   logic   [2:0]       i_sl_tx_empty,
    input   logic               i_sl_tx_skip_crc,
    input   logic               i_sl_tx_valid,
    input   logic               i_sl_tx_inframe,
    output  logic               o_sl_tx_ready,

    output  logic   [63:0]      o_sl_rx_data,
    output  logic   [2:0]       o_sl_rx_empty,
    output  logic               o_sl_rx_fcs_error,
    output  logic   [1:0]       o_sl_rx_error,
    output  logic   [2:0]       o_sl_rx_status,
    output  logic               o_sl_rx_inframe,
    output  logic               o_sl_rx_valid,

    // PCS Interface
    input   logic   [63:0]      i_sl_tx_mii_d,
    input   logic   [7:0]       i_sl_tx_mii_c,
    input   logic               i_sl_tx_mii_valid,
    input   logic               i_sl_tx_mii_am,
    output  logic               o_sl_tx_mii_ready,

    output  logic   [63:0]      o_sl_rx_mii_d,
    output  logic   [7:0]       o_sl_rx_mii_c,
    output  logic               o_sl_rx_mii_valid,
    output  logic               o_sl_rx_mii_am_valid,

    // PCS66 Interface
    input   logic   [65:0]      i_sl_tx_pcs66_d,
    input   logic               i_sl_tx_pcs66_valid,
    input   logic               i_sl_tx_pcs66_am,
    output  logic               o_sl_tx_pcs66_ready,

    output  logic   [65:0]      o_sl_rx_pcs66_d,
    output  logic               o_sl_rx_pcs66_valid,
    output  logic               o_sl_rx_pcs66_am_valid,

    // PMA Direct Interface
    input   logic   [79:0]      i_sl_tx_pma,
    output  logic   [79:0]      o_sl_rx_pma,

    //AIB Interface
    input   logic   [79:0]      i_aib_rx_data,
    output  logic   [79:0]      o_aib_tx_data,

    // PTP Interface
    input   logic               i_sl_ptp_sclk,
    input   logic               i_sl_ptp_tx_sel_sclk_return,
    input   logic               i_sl_ptp_rx_sel_sclk_return,
    output  logic               o_sl_ptp_tx_sclk_return,
    output  logic               o_sl_ptp_rx_sclk_return,

    // Deterministic Latency Interface
    input   logic               i_sl_latency_sclk,
    input   logic               i_sl_tx_dl_measure_sel,
    input   logic               i_sl_rx_dl_measure_sel,
    output  logic               o_sl_tx_dl_async_pulse,
    output  logic               o_sl_rx_dl_async_pulse,

    // Native PHY Interface for DL
    output  logic               o_sl_latency_sclk,
    output  logic               o_sl_tx_dl_measure_sel,
    output  logic               o_sl_rx_dl_measure_sel,
    input   logic               i_sl_tx_dl_async_pulse,
    input   logic               i_sl_rx_dl_async_pulse
);

//=============================================================================
//Declarations

    //This should be moved to the shared package
    localparam  SEL_MAC     =   2'd0;
    localparam  SEL_PCS     =   2'd1;
    localparam  SEL_PCS66   =   2'd2;
    localparam  SEL_PMA     =   2'd3;

    logic   [77:0]              tx_mac_client;
    logic   [77:0]              tx_mii;
    logic   [77:0]              tx_pcs66;
    logic   [79:0]              tx_pma;     //extra wide because it doesn't get aib_encoded
    logic   [79:0]              tx_data;    //post aib_encode
    logic   [77:0]              rx_data_dec;    //post aib_decode
    logic   [77:0]              rx_data_dec_r;  //post aib_decode
    logic   [77:0]              rx_data;    //post aib_decode
    logic   [79:0]              tx_data_r;


//=============================================================================
//Main Body of Code


    //========================================================================
    //Remap all the TX datapath interfaces

    always_comb begin:mac_client_interface

        tx_mac_client                           =   '0; //tie off unused

        tx_mac_client[EPRT_TX_MAC_DATA+:64]     =   i_sl_tx_data;
        tx_mac_client[EPRT_TX_ERROR]            =   i_sl_tx_error;
        tx_mac_client[EPRT_TX_EOP_EMPTY+:3]     =   i_sl_tx_empty;
        tx_mac_client[EPRT_TX_SKIP_CRC]         =   i_sl_tx_skip_crc;
        tx_mac_client[EPRT_TX_VALID]            =   i_sl_tx_valid;
        tx_mac_client[EPRT_TX_INFRAME]          =   i_sl_tx_inframe;
        tx_mac_client[EPRT_STATS_SNAPSHOT]      =   i_sl_stats_snapshot;
        tx_mac_client[EPRT_CUSTOM_CADENCE]      =   i_sl_custom_cadence;
        tx_mac_client[EPRT_DESKEW]              =   i_sl_deskew;


    end:mac_client_interface

    always_comb begin:mii_interface

        tx_mii                                  =   '0; //tie off unused

        for(int mii_byte = 0; mii_byte < 8 ; mii_byte++)begin:foreach_byte
            tx_mii[9*mii_byte+:8]               =   i_sl_tx_mii_d[8*mii_byte+:8];
            tx_mii[9*mii_byte+8]                =   i_sl_tx_mii_c[mii_byte];
        end:foreach_byte

        tx_mii[EPRT_TX_VALID]                   =   i_sl_tx_mii_valid;
        tx_mii[EPRT_TX_AM_VALID]                =   i_sl_tx_mii_am;
        tx_mii[EPRT_STATS_SNAPSHOT]             =   i_sl_stats_snapshot;
        tx_mii[EPRT_CUSTOM_CADENCE]             =   i_sl_custom_cadence;
        tx_mii[EPRT_DESKEW]                     =   i_sl_deskew;

    end:mii_interface


    always_comb begin:tx_pcs66_interface

        tx_pcs66                                =   '0; //tie off unused

        tx_pcs66[0+:66]                         =   i_sl_tx_pcs66_d;
        tx_pcs66[EPRT_TX_VALID]                 =   i_sl_tx_pcs66_valid;
        tx_pcs66[EPRT_TX_AM_VALID]              =   i_sl_tx_pcs66_am;
        tx_pcs66[EPRT_STATS_SNAPSHOT]           =   i_sl_stats_snapshot;
        tx_pcs66[EPRT_CUSTOM_CADENCE]           =   i_sl_custom_cadence;
        tx_pcs66[EPRT_DESKEW]                   =   i_sl_deskew;

    end:tx_pcs66_interface


    always_comb begin:tx_pma_direct
        tx_pma                                  =   i_sl_tx_pma;
    end:tx_pma_direct



    //=========================================================================
    //If Alternate ports are enabled, create a mux controlled by i_sl_dp_sel to
    //choose a datapath, and register its output. Otherwise, statically
    //connect the selected datapath, and include no mux or register

    generate
    if(INCLUDE_ALTERNATE_PORTS == 0)begin:no_tx_dp_mux

        //When Include Alternate Ports is disabled, statically select the set
        //of ports needed based on EHIP MODE. AIB encoding is used for all the
        //interface types except PMA direct (tx_pma), because all the modes
        //except for tx_pma are guaranteed to use double-width mode on the
        //AIB, which requires special encoding
        if(     EHIP_MODE == "ehip_mac_no_fec")     assign  tx_data =   aib_encode(tx_mac_client);
        else if(EHIP_MODE == "ehip_mac")            assign  tx_data =   aib_encode(tx_mac_client);
        else if(EHIP_MODE == "ehip_mac_ptp_no_fec") assign  tx_data =   aib_encode(tx_mac_client);
        else if(EHIP_MODE == "ehip_mac_ptp")        assign  tx_data =   aib_encode(tx_mac_client);
        else if(EHIP_MODE == "ehip_pcs_no_fec")     assign  tx_data =   aib_encode(tx_mii);
        else if(EHIP_MODE == "ehip_pcs")            assign  tx_data =   aib_encode(tx_mii);
        else if(EHIP_MODE == "ehip_pcs66_no_fec")   assign  tx_data =   aib_encode(tx_pcs66);
        else if(EHIP_MODE == "ehip_pcs66")          assign  tx_data =   aib_encode(tx_pcs66);
        else if(EHIP_MODE == "ehip_otn_no_fec")     assign  tx_data =   aib_encode(tx_pcs66);
        else if(EHIP_MODE == "ehip_otn")            assign  tx_data =   aib_encode(tx_pcs66);
        else                                        assign  tx_data =   tx_pma;

        if((EHIP_MODE == "ehip_mac_no_fec")     ||
           (EHIP_MODE == "ehip_mac")            ||
           (EHIP_MODE == "ehip_mac_ptp_no_fec") ||
           (EHIP_MODE == "ehip_mac_ptp")) begin
            assign o_sl_latency_sclk      = i_sl_ptp_sclk;
            assign o_sl_tx_dl_measure_sel = i_sl_ptp_tx_sel_sclk_return;
            assign o_sl_rx_dl_measure_sel = i_sl_ptp_rx_sel_sclk_return;
        end
        else begin
            assign o_sl_latency_sclk      = i_sl_latency_sclk;
            assign o_sl_tx_dl_measure_sel = i_sl_tx_dl_measure_sel;
            assign o_sl_rx_dl_measure_sel = i_sl_rx_dl_measure_sel;
        end

    end:no_tx_dp_mux
    else begin:tx_dp_mux

        //When Include Alternate Ports is enabled, dynamically select the set
        //of ports needed by monitoring the current value of a CSR. AIB
        //encoding is used for all datapath encodings, except for PMA direct,
        //which might not be using the AIB double-width mode that makes the
        //encoding necessary
        logic [2:0] sl_dp_sel_r;
        logic [2:0] sl_dp_sel_rr;
        logic [2:0] sl_dp_sel_rrr;
        logic [2:0] sl_dp_sel_rrrr;
        always_ff @(posedge i_sl_clk_tx)
        if(!i_sl_tx_rst_n) begin
			sl_dp_sel_r   <=  '0;
			sl_dp_sel_rr   <=  '0;
			sl_dp_sel_rrr   <=  '0;
			sl_dp_sel_rrrr   <=  '0;
	    end
        else begin
			sl_dp_sel_r      <= i_sl_dp_sel;
			sl_dp_sel_rr      <= sl_dp_sel_r;
			sl_dp_sel_rrr      <= sl_dp_sel_rr;
			sl_dp_sel_rrrr      <= sl_dp_sel_rrr;
	    end

        always_comb begin:tx_dp_mux_logic

            tx_data     =   (sl_dp_sel_rrr == EHIP_MODE_SEL_MAC)  ?   aib_encode(tx_mac_client):
                            (sl_dp_sel_rrr == EHIP_MODE_SEL_PTP)  ?   aib_encode(tx_mac_client):
                            (sl_dp_sel_rrr == EHIP_MODE_SEL_PCS)  ?   aib_encode(tx_mii):
                            (sl_dp_sel_rrr == EHIP_MODE_SEL_OTN)  ?   aib_encode(tx_pcs66):
                            (sl_dp_sel_rrr == EHIP_MODE_SEL_PCS66)?   aib_encode(tx_pcs66):
                            /*sel_pma*/                             tx_pma;

            if((sl_dp_sel_rrrr == EHIP_MODE_SEL_MAC) ||
               (sl_dp_sel_rrrr == EHIP_MODE_SEL_PTP)) begin
                o_sl_latency_sclk      = i_sl_ptp_sclk;
                o_sl_tx_dl_measure_sel = i_sl_ptp_tx_sel_sclk_return;
                o_sl_rx_dl_measure_sel = i_sl_ptp_rx_sel_sclk_return;
            end
            else begin
                o_sl_latency_sclk      = i_sl_latency_sclk;
                o_sl_tx_dl_measure_sel = i_sl_tx_dl_measure_sel;
                o_sl_rx_dl_measure_sel = i_sl_rx_dl_measure_sel;
            end
        end:tx_dp_mux_logic

    end:tx_dp_mux
    endgenerate

    logic [79:0] tx_data_rr;
    logic [79:0] tx_data_rrr;
    logic [79:0] tx_data_rrrr;

    //Register the output of the datapath mux
    always_ff @(posedge i_sl_clk_tx)
    if(!i_sl_tx_rst_n) begin
			tx_data_rrrr   <=  '0;
	end
    else begin
			tx_data_r      <= tx_data;
			tx_data_rr     <= tx_data_r;
			tx_data_rrr    <= tx_data_rr;
			tx_data_rrrr   <= tx_data_rrr;
	end

    assign o_aib_tx_data = (REGISTER_TX_OUTPUT == 0) ? tx_data : tx_data_rrrr;

    //=========================================================================
    //Remap the RX output pins

    //AIB decode the rx data from the AIB. The decoded data is used for all
    //interfaces except PMA direct
    assign  rx_data_dec =   aib_decode(i_aib_rx_data);

    //Register the input of the datapath demux
    always_ff @(posedge i_sl_clk_rx)
    if(!i_sl_rx_rst_n)  rx_data_dec_r   <= '0;
    else                rx_data_dec_r   <= rx_data_dec;

    assign  rx_data     =   (REGISTER_RX_INPUT == 0) ? rx_data_dec : rx_data_dec_r;

    //Map the RX data interfaces
    always_comb begin:rx_mac_client

        o_sl_rx_data        =   rx_data[EPRT_RX_DATA+:64];
        o_sl_rx_empty       =   rx_data[EPRT_RX_EOP_EMPTY+:3];
        o_sl_rx_fcs_error   =   rx_data[EPRT_RX_FCS_ERROR];
        o_sl_rx_error       =   rx_data[EPRT_RX_ERROR+:2];
        o_sl_rx_status      =   rx_data[EPRT_RX_STATUS+:3];
        o_sl_rx_inframe     =   rx_data[EPRT_RX_INFRAME];
        o_sl_rx_valid       =   rx_data[EPRT_RX_VALID];

        o_sl_tx_ready       =   rx_data[EPRT_TX_READY];

    end:rx_mac_client


    always_comb begin:rx_mii_interface
        for(int mii_byte = 0; mii_byte < 8 ; mii_byte++)begin:foreach_byte
            o_sl_rx_mii_d[8*mii_byte+:8]        =   rx_data[9*mii_byte+:8];
            o_sl_rx_mii_c[mii_byte]             =   rx_data[9*mii_byte+8];
        end:foreach_byte

        o_sl_rx_mii_valid                       =   rx_data[EPRT_RX_VALID];
        o_sl_rx_mii_am_valid                    =   rx_data[EPRT_RX_AM_VALID];
        o_sl_tx_mii_ready                       =   rx_data[EPRT_TX_READY];

    end:rx_mii_interface


    always_comb begin:rx_pcs66_interface
        o_sl_rx_pcs66_d                         =   rx_data[0+:66];
        o_sl_rx_pcs66_valid                     =   rx_data[EPRT_RX_VALID];
        o_sl_rx_pcs66_am_valid                  =   rx_data[EPRT_RX_AM_VALID];
        o_sl_tx_pcs66_ready                     =   rx_data[EPRT_TX_READY];

    end:rx_pcs66_interface


    always_comb begin:rx_pma_interface
        //Note that we deliberately use the direct data here, not the AIB
        //decoded data
        o_sl_rx_pma                             =   i_aib_rx_data;
    end:rx_pma_interface


    assign o_sl_ptp_tx_sclk_return = i_sl_tx_dl_async_pulse;
    assign o_sl_ptp_rx_sclk_return = i_sl_rx_dl_async_pulse;

    assign o_sl_tx_dl_async_pulse  = i_sl_tx_dl_async_pulse;
    assign o_sl_rx_dl_async_pulse  = i_sl_rx_dl_async_pulse;



//=============================================================================
//Functions

    function automatic logic [79:0] aib_encode(logic [77:0] aib_data);
        logic   [79:0]  result;

        // The AIB requires a specific encoding when using the double-wide
        // parallel interface - we convert all the interfaces except the PMA
        // direct interface to that format here. The PMA direct interface is
        // not converted because it might not be using the double-wide
        // interface
        //
        // Split the 78 bits of data for the AIB into 2 39b chunks
        // Place the lower 39b into the lower 39b of the aib, then add a 1'b0
        // as the 40th bit
        // Place the upper 39b into the next set of bits, then add a 1'b1 as
        // the top bit
        return  {1'b1,aib_data[39+:39],1'b0,aib_data[0+:39]};
    endfunction



    function automatic logic [77:0] aib_decode(logic [79:0] aib_data);
        logic   [77:0]  result;

        // This function is the inverse of the aib_encode function defined
        // above

        return  {aib_data[40+:39],aib_data[0+:39]};
    endfunction



endmodule
