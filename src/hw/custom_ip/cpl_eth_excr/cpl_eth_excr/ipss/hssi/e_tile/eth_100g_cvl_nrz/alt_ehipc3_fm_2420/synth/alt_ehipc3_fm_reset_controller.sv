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


/*************************************************************************************************************
alt_ehipc3_fm_reset_controller.sv
This file instantiates following modules:
alt_ehipc3_fm_reset_controller.sv => top level file
alt_ehipc3_fm_ehip_rst.sv => handles EHIP resets
alt_ehipc3_fm_tx_rst.sv => TX digital/channel resets
alt_ehipc3_fm_rx_rst.sv => RX digital/channel resets
altera_s10_xcvr_clkout_endpoint => clock from master TRS (Transceiver reset sequencer)
altera_s10_xcvr_reset_endpoint => Reset endpoint

Function :
This Reset Controller handles all digital channels and EHIP reset sequencing as per the hardware requirement.
The assertion and deassertion of reset needs to be separated by a minimum delay (200ns) from the prior reset
assertion/deassertion across the device.

// All resets in this module are active high
**************************************************************************************************************/
// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module alt_ehipc3_fm_reset_controller
  #(
	parameter CLK_FREQ_IN_HZ = 100000000,
	parameter DEFAULT_RESET_SEPARATION_NS =100,
	parameter RESET_SEPARATION_NS = 100,
	parameter TX_ENABLE = 1,
	parameter RX_ENABLE = 1,
	parameter NUM_CHANNELS = 1,
	parameter SIM_EMULATE = 1,
	parameter ENABLE_RSFEC = 0,
	parameter TILE = "htile",
        parameter ENABLE_EXTERNAL_AIB_CLOCKING = 0
    )
   (

    // User hard Reset signals
    input wire 			   csr_rst_in, // User reset (~csr_rst_n) Resets Transcivers, EHIP
    input wire 			   tx_rst_in, // User reset (~tx_rst_n) Resets EHIP TX
    input wire 			   rx_rst_in, // User reset (~rx_rst_n) Resets EHIP RX
    // Soft CSR reset signals
    input wire 			   soft_tx_rst_in,
    input wire 			   soft_rx_rst_in,
    input wire 			   soft_csr_rst_in,


    // Native PHY IP interface signals

    input wire [NUM_CHANNELS-1:0]  tx_pma_ready_in, // from Native PHY IP
    input wire [NUM_CHANNELS-1:0]  rx_pma_ready_in, // from Native PHY IP
    input wire [NUM_CHANNELS-1:0]  tx_transfer_ready_in, // from Native PHY IP
    input wire [NUM_CHANNELS-1:0]  tx_dll_lock_in, // from Native PHY IP
    input wire [NUM_CHANNELS-1:0]  rx_transfer_ready_in, // from Native PHY IP
    input wire [NUM_CHANNELS-1:0]  tx_cal_busy, // from Native PHY IP
    input wire [NUM_CHANNELS-1:0]  rx_cal_busy, // from Native PHY IP
    input wire [NUM_CHANNELS-1:0]  rx_is_lockedtoref_in, // from Native PHY IP
    input wire [NUM_CHANNELS-1:0]  rx_is_lockedtodata_in, // from Native PHY IP

    // For C3 - For first revision we will not assert analogresets, for C3 analogresets need to be asserted
    // through Interrupt, enable interrupt through AVMM Interface
//    output reg [NUM_CHANNELS-1:0]  tx_analogreset_out,
//    output reg [NUM_CHANNELS-1:0]  rx_analogreset_out,
    output wire [NUM_CHANNELS-1:0] tx_aib_reset_out, // To native PHY
    output wire [NUM_CHANNELS-1:0] tx_pcs_reset_out, // To Native PHY
    output wire [NUM_CHANNELS-1:0] rx_aib_reset_out, // To native PHY
    output wire [NUM_CHANNELS-1:0] rx_pcs_reset_out, // To native PHY

    // EHIP Interface signals
    input wire 			   ehip_ready_in,
    input wire 			   pause_ehip_ready_in,
    input wire 			   ehip_reset_ack_in, // From EHIP - ~o_rst_n, after applying ehip_reset to EHIP, high on this signal makes sure the reset is applied
    input wire 			   ehip_tx_reset_ack_in, // from EHIP - ~o_tx_rst_n, ack for ehip_tx_reset
    input wire 			   ehip_rx_reset_ack_in, // from EHIP - ~o_rx_rst_n, ack for ehip_rx_reset

    output wire 		   ehip_reset_out, // To EHIP -    connect this to i_rst_n of EHIP
    output wire 		   ehip_tx_reset_out, // to EHIP - connect this to i_tx_rst_n of EHIP
    output wire 		   ehip_rx_reset_out, // to EHIP - connect this to i_rx_rst_n of EHIP

    output wire 		   rsfec_reset_out, // To EHIP -    connect this to i_rst_n of EHIP
    output wire 		   rsfec_tx_reset_out, // to EHIP - connect this to i_tx_rst_n of EHIP
    output wire 		   rsfec_rx_reset_out, // to EHIP - connect this to i_rx_rst_n of EHIP

    output wire 		   ehip_signal_ok_out, // "1" when rx_is_lockedtodata and RSFEC, EHIP RX is deasserted
    output wire 		   rx_signal_ok_out, // goes "1" when rx is lockedtodata

    output wire 		   ehip_pld_ready_out,

    output reg 			   csr_rst_stat, // to core csr_rst_stat
    output wire 		   tx_rst_stat, // to core tx_rst_stat
    output wire 		   rx_rst_stat, // to core rx_rst_stat

    // AN/LT reset ethernet controller Interface signals
    input wire 			   kr_mode_in, // indicates datapath not available due to KR, should mask tx_lanes_stable
    input wire 			   kr_rst_req, // assert -> reconfiguration. release -> data mode
    output wire 		   kr_rst_stat,


    // Following signals to generate tx_eth_ready and rx_eth_ready
    // which indicates the reset sequence is complete

    input wire 			   clk_status,
    input wire 			   pll_locked_in,
    input wire 			   rx_pcs_fully_aligned_in,


    output reg 			   tx_eth_ready,
    output reg 			   tx_lanes_stable,
    output reg 			   rx_eth_ready,
    output reg                     ehip_ready_out



    );

   wire clk;
   reg 	reset_req;
   wire reset_ack;
   reg 	csr_reset_sample;
   reg 	tx_reset_sample;
   reg 	rx_reset_sample;
   reg 	kr_reset_sample;
   reg 	ltd_reset_sample;
   wire csr_reset_match;
   wire tx_reset_match;
   wire rx_reset_match;
   wire ltd_reset_match;
   wire kr_reset_match;
   wire csr_assert_req, csr_deassert_req;
   wire tx_assert_req, tx_deassert_req;
   wire rx_assert_req, rx_deassert_req;
   wire kr_assert_req, kr_deassert_req;
   wire ltd_assert_req, ltd_deassert_req;
   reg 	csr_reset_stat;
   reg 	tx_reset_stat;
   reg 	rx_reset_stat;
   reg 	kr_reset_stat;
   reg 	ltd_reset_stat;
   reg 	csr_rst_stat_comb;
   reg 	tx_rst_stat_comb;
   reg 	rx_rst_stat_comb;
   reg 	kr_rst_stat_comb;
   reg 	ltd_rst_stat_comb;
//   wire csr_rst_stat_int, // to core csr_rst_stat

   reg 	update_csr_reset;
   reg 	update_tx_reset;
   reg 	update_rx_reset;
   reg 	update_kr_reset;
   reg 	update_ltd_reset;

   reg 	ehiprst_assert_f;
   reg 	ehiptxrst_assert_f;
   reg 	ehiprxrst_assert_f;
   reg 	rxaibrst_assert_f;
   reg 	rxpcsrst_assert_f;
   reg 	txaibrst_assert_f;
   reg 	txchrst_assert_f;

   reg 	ehiprst_deassert_f;
   reg 	ehiptxrst_deassert_f;
   reg 	ehiprxrst_deassert_f;
   reg 	rxaibrst_deassert_f;
   reg 	rxpcsrst_deassert_f;
   reg 	txaibrst_deassert_f;
   reg 	txchrst_deassert_f;

   reg 	csr_assert_seq_done;
   reg 	csr_deassert_seq_done;
   reg 	tx_assert_seq_done;
   reg 	rx_assert_seq_done;
   reg 	tx_deassert_seq_done;
   reg 	rx_deassert_seq_done;
   reg 	ltd_assert_seq_done;
   reg 	kr_assert_seq_done;
   reg 	ltd_deassert_seq_done;
   reg 	kr_deassert_seq_done;
//   reg [NUM_CHANNELS-1:0] tx_analogreset_comb;
//   reg [NUM_CHANNELS-1:0] rx_analogreset_comb;

   reg [3:0] top_sm_cs;
   reg [3:0] top_sm_ns;
   localparam [3:0] SAMPLE_RESET = 3'b000;
   localparam [3:0] RESET_REQ = 3'b001;
   localparam [3:0] RESET_ACK = 3'b010;
   localparam [3:0] SAMPLE_PMA_RDY_ASSERT = 3'b011;
   localparam [3:0] SAMPLE_PMA_RDY_DEASSERT = 3'b100;
//   localparam [3:0] ASSERT_ANALOG_RESETS = 3'b011;
//   localparam [3:0] DEASSERT_ANALOG_RESETS = 3'b100;
   localparam [3:0] RESUME_RESET = 3'b111;


   localparam [3:0] IDLE = 4'b0000;
   localparam [3:0] CTRL_CSR_ASSERT = 4'b0001;
   localparam [3:0] CTRL_CSR_DEASSERT = 4'b0010;
   localparam [3:0] CTRL_TX_ASSERT = 4'b0011;
   localparam [3:0] CTRL_TX_DEASSERT = 4'b0100;
   localparam [3:0] CTRL_RX_ASSERT = 4'b0101;
   localparam [3:0] CTRL_RX_DEASSERT = 4'b0110;
   localparam [3:0] CTRL_LTD_ASSERT = 4'b0111;
   localparam [3:0] CTRL_LTD_DEASSERT = 4'b1000;
   localparam [3:0] CTRL_KR_ASSERT = 4'b1001;
   localparam [3:0] CTRL_KR_DEASSERT = 4'b1010;

   reg [3:0] ctrl_code_comb;
   reg [3:0] ctrl_code;
   reg       new_ctrl_code;


   reg 	     reset_req_comb;
   wire      tx_req_done;
   wire      rx_req_done;
   wire      ehip_req_done;
   wire      rx_aib_deassert_req_done;
   wire      rx_pcs_deassert_req_done;
   wire      tx_aib_deassert_req_done;
   wire      tx_pcs_deassert_req_done;
   wire      csr_reset_in_sync;
   wire      tx_reset_in_sync;
   wire      rx_reset_in_sync;
   wire      kr_reset_in_sync;
   wire      rx_is_lockedtodata_stat;
   wire      rx_is_lockedtodata_in_sync;
   wire		 tx_pma_ready_in_sync_clk;
   wire		 rx_pma_ready_in_sync;

   wire      reset_n;
   wire      greset_n;
   wire      e_signal_ok_out;


   //***************************************************************************
   // Getting the clock from Master TRS
   //***************************************************************************
   altera_s10_xcvr_clkout_endpoint clock_endpoint
     (
	.clk_out(clk)
	);


   //****************
   // Reset TRE instance
   //****************
   if (SIM_EMULATE) begin
      assign reset_ack = reset_req;
   end else begin
      //TRE instance
      altera_s10_xcvr_reset_endpoint alt_ehipc3_fm_reset_endpoint_inst
	(
	 .tre_reset_req(reset_req),
	 .tre_reset_ack(reset_ack)
	 );
   end // else: !if(SIM_EMULATE)




    //***************************************************************************
   // Need to self-generate internal reset signal
   //***************************************************************************
   alt_xcvr_resync_std #
     (
      .SYNC_CHAIN_LENGTH(3),
      .INIT_VALUE(0)
      ) reset_n_generator
       (
	.clk	(clk),
	.reset	(1'b0),
	.d		(1'b1),
	.q		(reset_n)
	);


   //***************************************************************************

   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.INIT_VALUE(0))
   greset_generator
     (	.clk	(clk),
	.reset	(~reset_n | csr_rst_in | soft_csr_rst_in),
	.d	(1'b1),
	.q	(greset_n));




   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   csr_reset_synchronizers
     (	.clk	(clk),
	.reset	(~reset_n),
	.d	(csr_rst_in | soft_csr_rst_in),
	.q	(csr_reset_in_sync));


   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   tx_reset_synchronizers
     (	.clk	(clk),
	.reset	(~reset_n),
	.d	(tx_rst_in | soft_tx_rst_in),
	.q	(tx_reset_in_sync));


   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   rx_reset_synchronizers
     (	.clk	(clk),
	.reset	(~reset_n),
	.d	(rx_rst_in | soft_rx_rst_in),
	.q	(rx_reset_in_sync));

   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   kr_reset_synchronizers
     (	.clk	(clk),
	.reset	(~reset_n),
	.d	(kr_rst_req),
	.q	(kr_reset_in_sync));

   //--------------------------------------------------------------------
   //--------------------------------------------------------------------
   // Reset Sampling logic -
   // samples resets and generates the reset assert, deassert request
   // based on reset match and the last sampled value


   assign csr_rst_stat = csr_reset_stat;
   assign tx_rst_stat = tx_reset_stat;
   assign rx_rst_stat = rx_reset_stat;
   assign kr_rst_stat = kr_reset_stat;


   //********************************************************************************
   // Reset output status reflects the reset output that is asserted/de-asserted last
   // match is "1" when reset_stat and current sampled value is same
   // match is 0 when reset_stat and current value is different
   //********************************************************************************


   assign csr_reset_match = (csr_reset_stat == csr_reset_sample);
   assign tx_reset_match = (tx_reset_stat == tx_reset_sample);
   assign rx_reset_match = (rx_reset_stat == rx_reset_sample);
   assign kr_reset_match = (kr_reset_stat == kr_reset_sample);
   assign ltd_reset_match = (ltd_reset_stat == ltd_reset_sample);

   //********************************************************************************
   // assert request when no match and the reset_stat register is 0
   // deassert request when no match and reset_stat is "1"
   //********************************************************************************
   assign csr_assert_req = (!csr_reset_match && csr_reset_stat == 0);
   assign csr_deassert_req = (!csr_reset_match && csr_reset_stat == 1);

   assign tx_assert_req = (!tx_reset_match && tx_reset_stat == 0);
   assign tx_deassert_req = (!tx_reset_match && tx_reset_stat == 1);

   assign rx_assert_req = (!rx_reset_match && rx_reset_stat == 0);
   assign rx_deassert_req = (!rx_reset_match && rx_reset_stat == 1);

   assign kr_assert_req = (!kr_reset_match && kr_reset_stat == 0);
   assign kr_deassert_req = (!kr_reset_match && kr_reset_stat == 1);

   assign ltd_assert_req = (!ltd_reset_match && ltd_reset_stat == 0);
   assign ltd_deassert_req = (!ltd_reset_match && ltd_reset_stat == 1);

/*
   assign csr_deassert_req = !csr_reset_match ? (!csr_reset_sample ? 1'b1 : 1'b0)
                                              : 1'b0;

   assign tx_assert_req = !tx_reset_match ? (tx_reset_sample ? 1'b1 : 1'b0)
                                          : 1'b0;
   assign tx_deassert_req = !tx_reset_match ? (!tx_reset_sample ? 1'b1 : 1'b0)
                                            : 1'b0;
   assign rx_assert_req = !rx_reset_match ? (rx_reset_sample ? 1'b1 : 1'b0)
                                          : 1'b0;
   assign rx_deassert_req = !rx_reset_match ? (!rx_reset_sample ? 1'b1 : 1'b0)
                                            : 1'b0;
*/
    always @(posedge clk or negedge greset_n) begin
        if(!greset_n) begin
            csr_reset_stat <= 1'b0;
            tx_reset_stat <= 1'b0;
            rx_reset_stat <= 1'b0;
            kr_reset_stat <= 1'b0;
            ltd_reset_stat <= 1'b0;
        end else begin
            if(update_csr_reset) csr_reset_stat <= csr_rst_stat_comb;
            if(update_tx_reset) tx_reset_stat <= tx_rst_stat_comb;
            if(update_rx_reset) rx_reset_stat <= rx_rst_stat_comb;
            if(update_kr_reset) kr_reset_stat <= kr_rst_stat_comb;
            if(update_ltd_reset) ltd_reset_stat <= ltd_rst_stat_comb;
        end
    end

    always @(posedge clk or negedge greset_n) begin
        if(!greset_n) begin
            csr_reset_sample <= 1'b1; // this will assure csr reset on startup
            tx_reset_sample <= 1'b0;
            rx_reset_sample <= 1'b0;
            kr_reset_sample <= 1'b0;
            ltd_reset_sample <= 1'b0;
        end else begin
            // sample if there is no pending request (match)
            // or immediately if there's a reset request
            if(csr_reset_match || csr_reset_in_sync) csr_reset_sample <= csr_reset_in_sync;
            if(tx_reset_match || tx_reset_in_sync) tx_reset_sample <= tx_reset_in_sync;
            if(rx_reset_match || rx_reset_in_sync) rx_reset_sample <= rx_reset_in_sync;
            if(kr_reset_match || kr_reset_in_sync) kr_reset_sample <= kr_reset_in_sync;
            if(ltd_reset_match || !rx_is_lockedtodata_stat) ltd_reset_sample <= !rx_is_lockedtodata_stat;
        end
    end

   //***************************************************************************
   // Synchronizer for lockedtodata
   //***************************************************************************
   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(1),.INIT_VALUE(0))
   rx_lockedtodata_synchronizers
     (.clk	(clk),
      .reset	(~greset_n),
      .d	(&rx_is_lockedtodata_in),
      .q	(rx_is_lockedtodata_in_sync));

   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(1),.INIT_VALUE(0))
   rx_pma_ready_synchronizers
     (.clk	(clk),
      .reset	(~greset_n),
      .d	(&rx_pma_ready_in),
      .q	(rx_pma_ready_in_sync));

   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(1),.INIT_VALUE(0))
   tx_pma_ready_synchronizers
     (.clk	(clk),
      .reset	(~greset_n),
      .d	(&tx_pma_ready_in),
      .q	(tx_pma_ready_in_sync_clk));

 // Generate rx_is_lockedtodata_stat signal
 // if rx_is_lockedtodata is "1" for min 180us for E-tile
 // that indicates stable rx_lockedtodata
 // generate rx_is_lockedtodata_stat signal
 // For 180 us count=57E4,we will keep count ~5FFF (24575) need 16 bit counter
 // with cnt_lock = 16 bits and clk = 125 mhz (8ns) = 8 *24575 = 196us

   reg cnt_max;
   localparam CNTWIDTH = SIM_EMULATE ? 3: 16;
   reg [CNTWIDTH-1:0] cnt_lock;
   reg [11:0] 	     cnt12;
   reg [3:0] 	     cnt4;



   assign cnt12 = SIM_EMULATE ? 12'd0 : cnt_lock[11:0];
   assign cnt4 = SIM_EMULATE ? 4'd0: cnt_lock[15:12];

   // Counter for counting 5us for rx_lockedtodata
   always @(posedge clk or negedge greset_n)
     begin
	if (~greset_n)
	  begin
	     cnt_max  <= 1'b0;
	     cnt_lock <= {CNTWIDTH{1'b0}};
	  end
	else
	  begin
	     if (SIM_EMULATE)
	       begin
		  cnt_max <= (&cnt_lock);
		  if (~rx_is_lockedtodata_in_sync)
		    cnt_lock <= {CNTWIDTH{1'b0}};
		  else if (&cnt_lock)
		    cnt_lock <= cnt_lock;
		  else
		    cnt_lock <= cnt_lock + 1'b1;
	       end
	     else
	       begin
		  cnt_max <= (cnt4 == 4'b0101 && &cnt12);
		  if (~rx_is_lockedtodata_in_sync)
		    cnt_lock <= {CNTWIDTH{1'b0}};
		  else if ((cnt4== 4'b0101) && (&cnt12))
		    cnt_lock <= cnt_lock;
		  else
		    cnt_lock <= cnt_lock + 1'b1;
	       end // else: !if(SIM_EMULATE)
	  end // else: !if(~greset_n)
     end // always @ (posedge mgmt_clk or posedge mgmt_reset)

   assign rx_is_lockedtodata_stat = (cnt_max) ? 1'b1 : 1'b0;


   //--------------------------------------------------------------------

   //--------------------------------------------------------------------
   // Main reset control State machine which controls the reset sequence
   // based on the request generated by the reset sampling logic
   //--------------------------------------------------------------------


   /************************************************************************************************************************
    // CSR ASSERTION Sequence -
    // Do following sequence
    // reset EHIP RX
    // reset EHIP TX
    // reset EHIP
    // Reset RX CHs - RX PCS, RX AIB, ??assert rx_analogreset (need to handle assertion of analogresets differently - TODO)
    // Reset Tx Chs - TX PCS, TX AIB, ??Assert tx analogreset (need to handle assertion of analogresets differently - TODO)
    // Release req - csr_assert_request
    // wait for analogreset_stat from Native PHY and then clear csr_assert_req_done signals
   ************************************************************************************************************************/

   // CSR DEASSERTION Sequence -
   // Do following sequence
   // DEASSERT TX ANALOGRESETS
   // DEASSERT RX ANALOGRESETS
   // Wait for PMA_READY - Timeout if don't come
   // request the master, wait for ack
   // deassert TX AIB, dll_lock_req
   // wait for tx transfer redady
   // deassert TX PCS
   // deassert Rx AIB rx_dll_lock_req
   // Assert EHIP PLD READY
   // deassert EHIP RESET
   // deassert EHIP TX
   // wait for EHIP READY
   // Deassert EHIP RX
   // Assert EHIP_SIGNAL_OK
   // csr_deassert_req_done is "1" Give back the request while waiting for lockedtodata


   always @(*)
   begin

       reset_req_comb = 1'b0;
       top_sm_ns = top_sm_cs;
       update_csr_reset = 1'b0;
       update_tx_reset = 1'b0;
       update_rx_reset = 1'b0;
       update_ltd_reset = 1'b0;
       update_kr_reset = 1'b0;
       csr_rst_stat_comb = 1'b0;
       tx_rst_stat_comb = 1'b0;
       rx_rst_stat_comb = 1'b0;
       kr_rst_stat_comb = 1'b0;
       ltd_rst_stat_comb = 1'b0;
       ctrl_code_comb = IDLE;
//       tx_analogreset_comb = {NUM_CHANNELS{1'b0}};
//       rx_analogreset_comb = {NUM_CHANNELS{1'b0}};
       case(top_sm_cs)
           SAMPLE_RESET:
           begin
               // If not match that means there is a change in the previous and current sampled value so go and request the
               // master with request by going to RESET_REQ state.
               // only service tx & rx if not in CSR reset or KR mode
               //  additional only service rx if not in LTD reset
               // only service LTD if not in CSR reset or reconfiguration (KR reset)
               if ( !reset_ack && (!csr_reset_match ||
                   ( !csr_rst_stat && !kr_reset_match ) ||
                   ( !csr_rst_stat && !kr_rst_stat && !tx_reset_match ) ||
                   ( !csr_rst_stat && !kr_rst_stat && !ltd_reset_stat && !rx_reset_match ) ||
                   ( !csr_rst_stat && !kr_rst_stat && !ltd_reset_match )
               ) )
               begin
                  if (csr_deassert_req)
		    //                     top_sm_ns = DEASSERT_ANALOG_RESETS;
                    top_sm_ns = SAMPLE_PMA_RDY_ASSERT;
                  else
                    top_sm_ns = RESET_REQ;
               end
           end

           RESET_REQ:
           begin
               if (reset_ack)
               begin
                   top_sm_ns = RESET_ACK;
               end
               reset_req_comb = 1'b1;
           end

           RESET_ACK:
             begin
		if (!reset_ack)
		  top_sm_ns = SAMPLE_RESET;
		else
		  begin
		     /*****************************     CSR ASSERTION ************************************* */
		     if (csr_assert_req)
		       begin
			  // CSR assert request is all done then move on to next request
			  if (csr_assert_seq_done)
			    begin
			       update_csr_reset = 1'b1;
			       csr_rst_stat_comb = 1'b1;
			       update_tx_reset = 1'b1;
			       tx_rst_stat_comb = 1'b1;
			       update_rx_reset = 1'b1;
			       rx_rst_stat_comb = 1'b1;
			       update_ltd_reset = 1'b1;
			       ltd_rst_stat_comb = 1'b1;
			       update_kr_reset = 1'b1;
			       kr_rst_stat_comb = 1'b0;

			       // After all requests are done, assert analogresets and release the request but wait for analogstats to go high to complete the CSR ASSERTION fully
			       //                       top_sm_ns = ASSERT_ANALOG_RESETS;
			       //                      top_sm_ns = SAMPLE_PMA_RDY_DEASSERT; - I don't think we need this as we can't do this

			    end // if (ehip_req_done && tx_req_done && rx_req_done)
			  else
			    begin
			       ctrl_code_comb = CTRL_CSR_ASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done && tx_req_done && rx_req_done)
		       end // if (csr_assert_req && !req_done)

		     /*****************************    KR_RST ASSERTION ************************************* */
		     else if (kr_assert_req && !csr_deassert_req)
		       begin
			  if (kr_assert_seq_done)
			    begin
			       update_tx_reset = 1'b1;
			       tx_rst_stat_comb = 1'b1;
			       update_rx_reset = 1'b1;
			       rx_rst_stat_comb = 1'b1;
			       update_ltd_reset = 1'b1;
			       ltd_rst_stat_comb = 1'b1;
			       update_kr_reset = 1'b1;
			       kr_rst_stat_comb = 1'b1;
			       top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       // call following state machines in following sequence
			       // eth_sm
			       ctrl_code_comb = CTRL_KR_ASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done)
		       end // if (kr_assert_req)

		     /*****************************     TX_RST ASSERTION ************************************* */
		     else if (tx_assert_req)
		       begin
			  // CSR assert request is all done then move on to next request
			  if (tx_assert_seq_done)
			    begin
			       update_tx_reset = 1'b1;
			       tx_rst_stat_comb = 1'b1;
			       top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       // call following state machines in following sequence
			       // eth_sm
			       ctrl_code_comb = CTRL_TX_ASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done)
		       end // if (tx_assert_req)

		     /*****************************     RX_RST ASSERTION ************************************* */
		     else if (rx_assert_req)
		       begin
			  // CSR assert request is all done then move on to next request
			  if (rx_assert_seq_done)
			    begin
			       update_rx_reset = 1'b1;
			       rx_rst_stat_comb = 1'b1;
			       top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       // call following state machines in following sequence
			       // eth_sm
			       ctrl_code_comb = CTRL_RX_ASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done)
		       end // if (rx_assert_req)

		     /*****************************    LTD_RST ASSERTION ************************************* */
		     else if (ltd_assert_req)
		       begin
			  if (ltd_assert_seq_done)
			    begin
			       update_ltd_reset = 1'b1;
			       ltd_rst_stat_comb = 1'b1;
			       update_rx_reset = 1'b1;
			       rx_rst_stat_comb = 1'b1;
			       top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       // call following state machines in following sequence
			       // eth_sm
			       ctrl_code_comb = CTRL_LTD_ASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done)
		       end // if (ltd_assert_req)

		     /*****************************  CSR_RST DEASSERTION ************************************* */
		     else if (csr_deassert_req)
		       begin
			  // CSR deassert request is all done then move on to next request
			  if (csr_deassert_seq_done)
			    begin
			       update_csr_reset = 1'b1;
			       csr_rst_stat_comb = 1'b0;
			       update_kr_reset = 1'b1;
			       kr_rst_stat_comb = 1'b0;

			       // continue servicing requests on same reset_ack if requested
			       if(tx_deassert_req || ltd_deassert_req)
				 reset_req_comb = 1'b1;
			       else
				 top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       ctrl_code_comb = CTRL_CSR_DEASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done && tx_req_done && rx_req_done)
		       end // if (csr_deassert_req)

		     /*****************************    KR_RST DEASSERTION ************************************* */
		     else if (kr_deassert_req)
		       begin
			  if (kr_deassert_seq_done || csr_deassert_seq_done)
			    begin
			       update_kr_reset = 1'b1;
			       kr_rst_stat_comb = 1'b0;
			       // continue servicing requests on same reset_ack if requested
			       if(tx_deassert_req || ltd_deassert_req)
				 reset_req_comb = 1'b1;
			       else
				 top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       ctrl_code_comb = CTRL_CSR_DEASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done)
		       end // if (kr_assert_req)

		     /*****************************  TX_RST DEASSERTION ************************************* */
		     else if (tx_deassert_req)
		       begin
			  // tx assert request is all done then move on to next request
			  if (tx_deassert_seq_done)
			    begin
			       update_tx_reset = 1'b1;
			       tx_rst_stat_comb = 1'b0;
			       // continue servicing requests on same reset_ack if requested
			       if(rx_deassert_req && !ltd_reset_stat || ltd_deassert_req)
				 reset_req_comb = 1'b1;
			       else
				 top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       ctrl_code_comb = CTRL_TX_DEASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done)
		       end // if (tx_deassert_req)
		     /*****************************  LTD_RST DEASSERTION ************************************* */
		     else if (ltd_deassert_req)
		       begin
			  if (ltd_deassert_seq_done)
			    begin
			       update_ltd_reset = 1'b1;
			       ltd_rst_stat_comb = 1'b0;
			       // continue servicing requests on same reset_ack if requested
			       if(rx_deassert_req)
				 reset_req_comb = 1'b1;
			       top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       ctrl_code_comb = CTRL_LTD_DEASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done)
		       end // if (ltd_assert_req)

		     /*****************************  RX_RST DEASSERTION ************************************* */
		     else if (rx_deassert_req && !ltd_reset_stat)
		       begin
			  // tx assert request is all done then move on to next request
			  if (rx_deassert_seq_done)
			    begin
			       update_rx_reset = 1'b1;
			       rx_rst_stat_comb = 1'b0;
			       // continue servicing requests on same reset_ack if requested
			       if(ltd_deassert_req)
				 reset_req_comb = 1'b1;
			       else
				 top_sm_ns = RESUME_RESET;
			    end
			  else
			    begin
			       ctrl_code_comb = CTRL_RX_DEASSERT;
			       reset_req_comb = 1'b1;
			    end // else: !if(ehip_req_done)
		       end

		     /*************************************************************************************** */
		     else
		       begin
			  top_sm_ns = RESUME_RESET; // we shouldn't be here...
		       end // else: !assert _req)
		  end // else: !if(!reset_ack)
             end // case: RESET_ACK
	 /*
           // Sample tx_pma_ready and rx_pma_ready signals from Native PHY
           // If not ready that means PMA is still not ready so resume reset
         SAMPLE_PMA_RDY_DEASSERT:
           begin
              if (&(!tx_pma_ready_in) && &(!rx_pma_ready_in))
                top_sm_ns = RESUME_RESET;
           end // case: ASSERT_ANALOG_RESETS
*/

	 // check if TX amd RX PMA is ready and if yes then request the master
         SAMPLE_PMA_RDY_ASSERT:        // Sangeeta - ADD timeout if PMA READY won't go high in timeout period and assert error
           begin
	      //               tx_analogreset_comb = {NUM_CHANNELS{1'b0}};
	      //               rx_analogreset_comb = {NUM_CHANNELS{1'b0}};
              if (tx_pma_ready_in_sync_clk && rx_pma_ready_in_sync) begin
                 top_sm_ns = RESET_REQ;
              end
           end

/*
           // After asseerting analogrests, need to wait for analogreset_stat signals fron Native PHY
           // Wait for those and resume the request
           ASSERT_ANALOG_RESETS:        // Sangeeta - ADD timeout and assert error
           begin
               tx_analogreset_comb = {NUM_CHANNELS{1'b1}};
               rx_analogreset_comb = {NUM_CHANNELS{1'b1}};
               if (&tx_analogreset_stat_in && &rx_analogreset_stat_in)
                   top_sm_ns = RESUME_RESET;
           end // case: ASSERT_ANALOG_RESETS

           DEASSERT_ANALOG_RESETS:        // Sangeeta - ADD timeout if aanlgresetstat won't go high in timeout period and assert error
           begin
               tx_analogreset_comb = {NUM_CHANNELS{1'b0}};
               rx_analogreset_comb = {NUM_CHANNELS{1'b0}};
               if (!(&tx_analogreset_stat_in) && !(&rx_analogreset_stat_in)) begin
                   top_sm_ns = RESET_REQ;
               end
           end // case: DEASSERT_ANALOG_RESETS
*/
           RESUME_RESET:
           begin
               top_sm_ns = SAMPLE_RESET;
           end

           default :
           begin
               top_sm_ns = SAMPLE_RESET;
               ctrl_code_comb = IDLE;
//               tx_analogreset_comb = {NUM_CHANNELS{1'b0}};
//               rx_analogreset_comb = {NUM_CHANNELS{1'b0}};
               update_csr_reset = 1'b0;
               update_tx_reset = 1'b0;
               update_rx_reset = 1'b0;
           end

       endcase // case (top_sm_cs)
   end // always @ (*)

    always @(posedge clk or negedge greset_n) begin
        if (~greset_n) begin
            top_sm_cs <= SAMPLE_RESET;
        end else begin
            top_sm_cs <= top_sm_ns;
        end
    end

   always @(posedge clk or negedge greset_n)
     begin
	if (~greset_n)
	  reset_req <= 1'b0;
	else
	  reset_req <= reset_req_comb;
     end


     // ctrl_code stores the ASSERT, DEASSERT requests code
     always @(posedge clk or negedge greset_n)
     begin
         if (~greset_n) begin
             ctrl_code <= IDLE;
             new_ctrl_code <= 1'b0;
         end else begin
             ctrl_code <= ctrl_code_comb;
             // when the control code changes we should flush out the current sequence state
             // in case the new interrupt is preempting the current one in progress
             new_ctrl_code <= ctrl_code != ctrl_code_comb;
         end
     end
/*
   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  tx_analogreset_out <= {NUM_CHANNELS{1'b0}};
	else
	  if (top_sm_ns == ASSERT_ANALOG_RESETS || top_sm_ns == DEASSERT_ANALOG_RESETS)
	    tx_analogreset_out <= tx_analogreset_comb;
     end


   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  rx_analogreset_out <= {NUM_CHANNELS{1'b0}};
	else
	  if (top_sm_ns == ASSERT_ANALOG_RESETS || top_sm_ns == DEASSERT_ANALOG_RESETS)
	    rx_analogreset_out <= rx_analogreset_comb;
     end
*/
   //*********************** Call EHIP, TX CHANNEL, RX CHANNELS ************************************



   alt_ehipc3_fm_ehip_rst #(
			 .ENABLE_RSFEC(ENABLE_RSFEC),
			 .RESET_SEPARATION_NS(RESET_SEPARATION_NS),
			 .DEFAULT_RESET_SEPARATION_NS(DEFAULT_RESET_SEPARATION_NS))
     ehip_rst_seqinst
       (
	.clk(clk),
	.reset_n(greset_n),
	.reset_ack(reset_ack),
        .ehip_reset_ack_in (ehip_reset_ack_in),    // From EHIP - o_rst_n
        .ehip_tx_reset_ack_in(ehip_tx_reset_ack_in), // from EHIP - o_tx_rst_n
        .ehip_rx_reset_ack_in(ehip_rx_reset_ack_in), // from EHIP - o_rx_rst_n
	.csr_assert_req(ehiprst_assert_f),
	.csr_deassert_req(ehiprst_deassert_f),
	.tx_assert_req(ehiptxrst_assert_f),
	.tx_deassert_req(ehiptxrst_deassert_f),
	.rx_assert_req(ehiprxrst_assert_f),
	.rx_deassert_req(ehiprxrst_deassert_f),
	.kr_assert_req(kr_assert_req), //added this as in CTRL_KR_ASSERT ehip_tx_assert and ehip_rx_assert are updated/changed at the same time
	.all_seq_done(csr_assert_seq_done || tx_assert_seq_done || rx_assert_seq_done || csr_deassert_seq_done || tx_deassert_seq_done || rx_deassert_seq_done || kr_assert_seq_done || ltd_assert_seq_done || new_ctrl_code),
	.ehip_ready_in(ehip_ready_in),
	.rx_pcs_fully_aligned_in(rx_pcs_fully_aligned_in),
	.ehip_reset_out(ehip_reset_out),
	.ehip_tx_reset_out(ehip_tx_reset_out),
	.ehip_rx_reset_out(ehip_rx_reset_out),
	.rsfec_reset_out(rsfec_reset_out),
	.rsfec_tx_reset_out(rsfec_tx_reset_out),
	.rsfec_rx_reset_out(rsfec_rx_reset_out),
	.ehip_pld_ready_out(ehip_pld_ready_out),
	.req_done(ehip_req_done),
	.signal_ok_out(e_signal_ok_out)
	);



   // tx_channels
   alt_ehipc3_fm_tx_ch_rst #(
		       .NUM_CHANNELS(NUM_CHANNELS),
		       .CTRL_TX_ASSERT(CTRL_TX_ASSERT),
		       .CTRL_TX_DEASSERT(CTRL_TX_DEASSERT),
		       .CTRL_KR_ASSERT(CTRL_KR_ASSERT),
		       .ENABLE_EXTERNAL_AIB_CLOCKING(ENABLE_EXTERNAL_AIB_CLOCKING),
		       .RESET_SEPARATION_NS(RESET_SEPARATION_NS),
		       .DEFAULT_RESET_SEPARATION_NS(DEFAULT_RESET_SEPARATION_NS))
   tx_ch_rst_inst(
		  .clk(clk),
		  .reset_n(greset_n),
		  .reset_ack(reset_ack),
		  .ctrl_code(ctrl_code),
//		  .assert_req(txchrst_assert_f),
//		  .deassert_req(txchrst_deassert_f),
		  .tx_aib_assert_req(txaibrst_assert_f),
		  .tx_pcs_assert_req(txchrst_assert_f),
		  .tx_aib_deassert_req(txaibrst_deassert_f),
		  .tx_pcs_deassert_req(txchrst_deassert_f),

		  .tx_transfer_ready_in(tx_transfer_ready_in),
		  .tx_dll_lock_in(tx_dll_lock_in),
		  .all_seq_done(csr_assert_seq_done || csr_deassert_seq_done || kr_assert_seq_done || kr_deassert_seq_done || tx_assert_seq_done || tx_deassert_seq_done || new_ctrl_code),
		  .tx_aib_reset_out(tx_aib_reset_out),
		  .tx_pcs_reset_out(tx_pcs_reset_out),
		  .tx_aib_deassert_req_done(tx_aib_deassert_req_done),
		  .tx_pcs_deassert_req_done(tx_pcs_deassert_req_done),
		  .req_done(tx_req_done)
		  );


   alt_ehipc3_fm_rx_ch_rst #(
		       .NUM_CHANNELS(NUM_CHANNELS),
		       .RESET_SEPARATION_NS(RESET_SEPARATION_NS),
		       .DEFAULT_RESET_SEPARATION_NS(DEFAULT_RESET_SEPARATION_NS))
   rx_ch_rst_inst(
		  .clk(clk),
		  .reset_n(greset_n),
		  .reset_ack(reset_ack),
		  .rx_aib_assert_req(rxaibrst_assert_f),
		  .rx_pcs_assert_req(rxpcsrst_assert_f),
		  .rx_aib_deassert_req(rxaibrst_deassert_f),
		  .rx_pcs_deassert_req(rxpcsrst_deassert_f),
		  .rx_transfer_ready_in(rx_transfer_ready_in),
		  .all_seq_done(csr_assert_seq_done || csr_deassert_seq_done || kr_assert_seq_done || ltd_assert_seq_done || ltd_deassert_seq_done || new_ctrl_code),
		  .rx_aib_reset_out(rx_aib_reset_out),
		  .rx_pcs_reset_out(rx_pcs_reset_out),
		  .signal_ok_out(rx_signal_ok_out),
		  .rx_aib_deassert_req_done(rx_aib_deassert_req_done),
		  .rx_pcs_deassert_req_done(rx_pcs_deassert_req_done),
		  .req_done(rx_req_done)
		  );

   assign ehip_signal_ok_out = rx_signal_ok_out && e_signal_ok_out;


   always @(posedge clk or negedge greset_n)
     begin
	if (~greset_n)
	  begin
	     txchrst_assert_f <= 1'b0;
	     txaibrst_assert_f <= 1'b0;
	     rxaibrst_assert_f <= 1'b0;
	     rxpcsrst_assert_f <= 1'b0;
	     ehiprst_assert_f <= 1'b0;
	     ehiptxrst_assert_f <= 1'b0;
	     ehiprxrst_assert_f <= 1'b0;
	     txchrst_deassert_f <= 1'b0;
	     txaibrst_deassert_f <= 1'b0;
	     rxaibrst_deassert_f <= 1'b0;
	     rxpcsrst_deassert_f <= 1'b0;
	     ehiprst_deassert_f <= 1'b0;
	     ehiptxrst_deassert_f <= 1'b0;
	     ehiprxrst_deassert_f <= 1'b0;
	     csr_assert_seq_done <= 1'b0;
	     tx_assert_seq_done <= 1'b0;
	     rx_assert_seq_done <= 1'b0;
	     csr_deassert_seq_done <= 1'b0;
	     tx_deassert_seq_done <= 1'b0;
	     rx_deassert_seq_done <= 1'b0;

	  end
	else
	  begin
	     txchrst_assert_f <= 1'b0;
	     txaibrst_assert_f <= 1'b0;
	     rxaibrst_assert_f <= 1'b0;
	     rxpcsrst_assert_f <= 1'b0;
	     ehiprst_assert_f <= 1'b0;
	     ehiptxrst_assert_f <= 1'b0;
	     ehiprxrst_assert_f <= 1'b0;
	     txchrst_deassert_f <= 1'b0;
	     txaibrst_deassert_f <= 1'b0;
	     rxaibrst_deassert_f <= 1'b0;
	     rxpcsrst_deassert_f <= 1'b0;
	     ehiprst_deassert_f <= 1'b0;
	     ehiptxrst_deassert_f <= 1'b0;
	     ehiprxrst_deassert_f <= 1'b0;
	     csr_assert_seq_done <= 1'b0;
	     tx_assert_seq_done <= 1'b0;
	     rx_assert_seq_done <= 1'b0;
	     csr_deassert_seq_done <= 1'b0;
	     tx_deassert_seq_done <= 1'b0;
	     rx_deassert_seq_done <= 1'b0;
             kr_assert_seq_done <= 1'b0;
             kr_deassert_seq_done <= 1'b0;
             ltd_assert_seq_done <= 1'b0;
             ltd_deassert_seq_done <= 1'b0;

	     case (ctrl_code)
	       CTRL_CSR_ASSERT:
		 // call following resets in following sequence
		 // ehip_reset
		 //    ehip_tx
		 //    ehip_rx
		 //    ehip_rst
		 // rx_ch_sm
		 // tx_ch_sm

		 begin
		    if (ehip_req_done && !tx_req_done && !rx_req_done)
		      begin
			 rxaibrst_assert_f <= csr_assert_req;
			 rxpcsrst_assert_f <= csr_assert_req;
		      end
		    else if (ehip_req_done && rx_req_done && !tx_req_done)
		      begin
			 txchrst_assert_f <= csr_assert_req;
			 txaibrst_assert_f <= csr_assert_req;
		      end
		    else if (ehip_req_done && rx_req_done && tx_req_done)
		      begin
			 csr_assert_seq_done <= 1'b1;
		      end
		    else
		      begin
			 ehiprst_assert_f <= csr_assert_req;
		      end
		 end // case: CTRL_CSR_ASSERT
	       CTRL_TX_ASSERT:
		 // Making an update where, when tx_rst_n/soft_tx_rst is called it will reset EHIP TX and TX CH
		 // call following resets in following sequence
		 // EHIP TX -> TX PCS -> TX AIB
		 begin
		    if (ehip_req_done && !tx_req_done)
		      begin
			 txchrst_assert_f <= tx_assert_req;
			 txaibrst_assert_f <= tx_assert_req;
		      end
		    else if (ehip_req_done && tx_req_done)
		      begin
			 tx_assert_seq_done <= 1'b1;
		      end
		    else
		      begin
			 ehiptxrst_assert_f <= tx_assert_req;
		      end
		 end
	       CTRL_RX_ASSERT:
		 // call following resets in following sequence
		 // ehip_reset
		 //    ehip_tx
		 begin
		    if (ehip_req_done)
		      begin
			 rx_assert_seq_done <= 1'b1;
		      end
		    else
		      begin
			 ehiprxrst_assert_f <= rx_assert_req;
		      end
		 end
	       CTRL_LTD_ASSERT:
           // for loss of LTD, need to also put ehip rx into reset
		 begin
		    if (ehip_req_done && rx_req_done)
		      begin
			 ltd_assert_seq_done <= 1'b1;
		      end
		    else if (ehip_req_done)
		      begin
			 rxpcsrst_assert_f <= ltd_assert_req;
		      end
		    else
		      begin
			 ehiprxrst_assert_f <= ltd_assert_req;
		      end
		 end
	       CTRL_KR_ASSERT:
           // similar to CSR, but don't reset ehip top
		 begin
		    if (ehip_req_done && !rx_req_done && !tx_req_done)
		      begin
			 rxaibrst_assert_f <= kr_assert_req;
			 rxpcsrst_assert_f <= kr_assert_req;
		      end
		    if (ehip_req_done && rx_req_done && !tx_req_done)
		      begin
			 txchrst_assert_f <= kr_assert_req;
			 txaibrst_assert_f <= (ENABLE_EXTERNAL_AIB_CLOCKING) ? 1'b0 : kr_assert_req;
		      end
		    else if (ehip_req_done && rx_req_done && tx_req_done)
		      begin
			 kr_assert_seq_done <= 1'b1;
		      end
		    else
		      begin
			 ehiptxrst_assert_f <= kr_assert_req;
			 ehiprxrst_assert_f <= kr_assert_req;
		      end
		 end
	       CTRL_CSR_DEASSERT:
		 // call following in following sequence
		 // tx_ch_sm
		 // rx_ch_sm
		 // ehip_sm
		    // ehip_tx_sm (check tx_assert_req is pending if yes then don't deassert EHIP TX rather assert)
		 // ehip_rx_sm (check rx_assert_req is pending if yes then don't deassert EHIP RX rather assert)
		 //
		 // ehip mode - deassert txch, rxaib, ehip
		 // kr mode - only deassert ehip
		 // NEW sequence
		 // TX AIB -> RX AIB -> EHIP RST -> EHIP TX -> XCVR TX PCS -> XCVR RX PCS
		 begin
		    // if tx aib deassertion req done then request rx_aib deassertion
		    if (tx_aib_deassert_req_done && !ehip_req_done && !rx_aib_deassert_req_done)
		      begin
			 rxaibrst_deassert_f <= csr_deassert_req || kr_deassert_req;
		      end
		    // now request ehip deassertion
		    else if (tx_aib_deassert_req_done && rx_aib_deassert_req_done && !ehip_req_done)
		      begin
			 ehiprst_deassert_f <= csr_deassert_req || kr_deassert_req;
		      end
		    // If all sequences are done then reset all request flags
		    else if (ehip_req_done && tx_aib_deassert_req_done && rx_aib_deassert_req_done)
		      begin
			 csr_deassert_seq_done <= 1'b1;
		      end
		    //Start with TX AIB deassertion
		    else
		      begin
			 txaibrst_deassert_f <= csr_deassert_req || kr_deassert_req;
		      end
		 end // case: CTRL_CSR_DEASSERT

	       CTRL_TX_DEASSERT:
		 // Making an update where, when tx_rst_n/soft_tx_rst is called it will deassert EHIP TX and TX CH
		 // call following resets in following sequence
		 //  TX PCS -> ehip_tx
		 // NEW ->EHIP TX -> TX PCS
		 begin
		    if (ehip_req_done && !tx_pcs_deassert_req_done)
		      begin
			 txchrst_deassert_f <= tx_deassert_req;
		      end
		    else if (ehip_req_done && tx_pcs_deassert_req_done)
		      begin
			 tx_deassert_seq_done <= 1'b1;
		      end
		    // TX deassertion start with EHIP TX
		    else
		      begin
			 ehiptxrst_deassert_f <= tx_deassert_req;
		      end
		 end // case: CTRL_TX_DEASSERT

	       CTRL_RX_DEASSERT:
		 // call following resets in following sequence
		 //    ehip_rx
		 begin
		    if (ehip_req_done)
		      begin
			 rx_deassert_seq_done <= 1'b1;
		      end
		    else
		      begin
			 ehiprxrst_deassert_f <= rx_deassert_req;
		      end
		 end // case: CTRL_RX_DEASSERT

	       CTRL_LTD_DEASSERT:
           // data mode: only release pcs; main SM will then EHIP RX
		 begin
		    if (rx_pcs_deassert_req_done)
			 ltd_deassert_seq_done <= 1'b1;
		    else if (!rx_aib_deassert_req_done)
		      begin
			 rxaibrst_deassert_f <= ltd_deassert_req;
		      end
		    else
			 rxpcsrst_deassert_f <= ltd_deassert_req;
		 end

	       CTRL_KR_DEASSERT:
           // data_mode: use CTRL_CSR_DEASSERT
		 begin
		    if (tx_aib_deassert_req_done)
		      begin
			 kr_deassert_seq_done <= 1'b1;
		      end
		    else
		      begin
			 txaibrst_deassert_f <= kr_deassert_req;
		      end
		 end

	       default:
		 begin
		    txchrst_assert_f <= 1'b0;
		    txaibrst_assert_f <= 1'b0;
		    ehiprst_assert_f <= 1'b0;
		    ehiptxrst_assert_f <= 1'b0;
		    ehiprxrst_assert_f <= 1'b0;
		    txchrst_deassert_f <= 1'b0;
		    txaibrst_deassert_f <= 1'b0;
		    ehiprst_deassert_f <= 1'b0;
		    ehiptxrst_deassert_f <= 1'b0;
		    ehiprxrst_deassert_f <= 1'b0;
		    csr_assert_seq_done <= 1'b0;
		    tx_assert_seq_done <= 1'b0;
		    rx_assert_seq_done <= 1'b0;
		    csr_deassert_seq_done <= 1'b0;
		    tx_deassert_seq_done <= 1'b0;
		    rx_deassert_seq_done <= 1'b0;
		    kr_assert_seq_done <= 1'b0;
		    kr_deassert_seq_done <= 1'b0;
		    ltd_assert_seq_done <= 1'b0;
		    ltd_deassert_seq_done <= 1'b0;

		 end
	     endcase // case (ctrl_code)

	  end // else: !if!(greset_n)
     end // always @ (posedge clk or negedge greset_n)


   // Process AN/LT reset requests



/****************************************************************************************
 // Generate tx_eth_ready and rx_eth_ready signals
 // How we want these, wrt top mac_clk or clk_status??
*****************************************************************************************/

 // synchronize pll_locked wrt, rx_pcs_fully_aligned rx_lockedtodata_stat wrt clk_status

   wire pll_locked_sync;
   wire rx_is_lockedtodata_stat_sync;
   wire rx_pcs_fully_aligned_sync;
   wire status_csr_reset_in_sync;
   wire status_tx_reset_in_sync;
   wire status_rx_reset_in_sync;
   wire ehip_ready_in_sync;
   wire tx_reset_stat_sync;
   wire tx_pma_ready_in_sync;
   reg rx_eth_ready_qual_reg;
   wire rx_eth_ready_qual;
   wire rx_eth_ready_qual_sync;



   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(6),	.INIT_VALUE(0))
   ready_synchronizers
     (	.clk	(clk_status),
	.reset	(~greset_n),
	.d	({pll_locked_in, rx_is_lockedtodata_stat, rx_pcs_fully_aligned_in, tx_reset_stat, ehip_ready_in, &tx_pma_ready_in}),
	.q	({pll_locked_sync, rx_is_lockedtodata_stat_sync, rx_pcs_fully_aligned_sync, tx_reset_stat_sync, ehip_ready_in_sync, tx_pma_ready_in_sync})
	);

	assign rx_eth_ready_qual = !csr_assert_req && !rx_assert_req && !rx_reset_stat && !csr_reset_stat  && rx_is_lockedtodata_stat;

	always @ (posedge clk)
	begin
			rx_eth_ready_qual_reg 	<= rx_eth_ready_qual;
	end

   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   req_synchronizers
     (	.clk	(clk_status),
	.reset	(~greset_n),
	.d	({rx_eth_ready_qual_reg}),
	.q	({rx_eth_ready_qual_sync})
	);


// Synchronize csr_rst_n, tx_rst_n, rx_rst_n wrt to cklk_status to generate proper rx_ready, tx_eth_ready
   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   status_csr_reset_synchronizers
     (	.clk	(clk_status),
	.reset	(1'b0),
	.d	(csr_rst_in | soft_csr_rst_in),
	.q	(status_csr_reset_in_sync));


   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   status_tx_reset_synchronizers
     (	.clk	(clk_status),
	.reset	(1'b0),
	.d	(tx_rst_in | soft_tx_rst_in),
	.q	(status_tx_reset_in_sync));


   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   status_rx_reset_synchronizers
     (	.clk	(clk_status),
	.reset	(1'b0),
	.d	(rx_rst_in | soft_rx_rst_in),
	.q	(status_rx_reset_in_sync));


     always @(posedge clk_status)
     begin
	if (status_tx_reset_in_sync || status_csr_reset_in_sync)
	  begin
	     tx_eth_ready <= 1'b0;
	  end
	else
	  begin
	     if (tx_pma_ready_in_sync && !tx_reset_stat_sync && ehip_ready_in_sync)
	       tx_eth_ready <= 1'b1;
	     else
	       tx_eth_ready <= 1'b0;
	  end
     end // always @ (posedge clk_statu)

   always @(posedge clk_status)
     begin
	if (status_tx_reset_in_sync || status_csr_reset_in_sync)
	  begin
	     tx_lanes_stable <= 1'b0;
	  end
	else
	  begin
	     if (tx_pma_ready_in_sync && !kr_mode_in)
	       tx_lanes_stable <= 1'b1;
	     else
	       tx_lanes_stable <= 1'b0;
	  end
     end // always @ (posedge clk_statu)



   always @(posedge clk_status)
     begin
	if (status_rx_reset_in_sync || status_csr_reset_in_sync)
	  begin
	     rx_eth_ready <= 1'b0;
	  end
	else
	  begin
	     if (rx_eth_ready_qual_sync && rx_pcs_fully_aligned_sync)
	       rx_eth_ready <= 1'b1;
	     else
	       rx_eth_ready <= 1'b0;
	  end
     end // always @ (posedge clk_status)


// Generate o_ehip_ready - pull it low as soon as csr_reset or tx reset is asserted

   wire ehip_ready_qual;
   reg ehip_ready_qual_reg;

   assign ehip_ready_qual = !csr_assert_req && !tx_assert_req && !tx_reset_stat && !csr_reset_stat;
   always @ (posedge clk)
     begin
	ehip_ready_qual_reg 	<= ehip_ready_qual;
     end

  alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   eready_synchronizers
     (	.clk	(clk_status),
	.reset	(~greset_n),
	.d	({ehip_ready_qual_reg}),
	.q	({ehip_ready_qual_sync})
	);


   always @(posedge clk_status)
     begin
	if (status_tx_reset_in_sync || status_csr_reset_in_sync)
	  begin
	     ehip_ready_out <= 1'b0;
	  end
	else
	  begin
	     if (ehip_ready_qual_sync)
	       ehip_ready_out <= pause_ehip_ready_in;
	     else
	       ehip_ready_out <= 1'b0;
	  end
     end // always @ (posedge sys_clk_in)



endmodule // alt_ehipc3_fm_reset_controller
