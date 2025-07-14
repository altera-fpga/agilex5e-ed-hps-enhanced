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
//Description:
//  This module implements a highly conservative version of PAUSE XOFF
//  processing that can be used with EHIP
//    * EHIP has a corner case bug on XOFF processing, where if the queues in
//      TX MAC reach a very specific state and at the same moment a user
//      requests an XOFF and then subsequently requests an XON without waiting
//      for the XOFF to be executed while a packet is being transmitted, the
//      end of the packet is truncated
//    * While this corner case is extremely unlikely, it can only be avoided
//    completely in systems where XOFF packets will be given a chance to take
//    effect before XON is requested.
//    * For systems where this is not the case, we provide this workaround
//    logic, which monitors the o_pause output from the MAC, and implements
//    XOFF using disable_tx_mac operations through the AVMM instead
//    * The module includes an AVMM arbitrator that takes control of the AVMM
//    when it needs to execute a PAUSE operation, and a filter to monitor the
//    o_rx_pause signal
//    * The module works around the corner case because its response time is
//    too slow to trigger the undesired behavior. As a side-effect, however,
//    the module responds to PAUSE with higher latency, and takes longer to
//    restart data than the built-in XOFF logic.

`timescale 1ps/1ps

module alt_ehipc3_fm_sl_pause #(
    parameter   AW                      =   21,         //AVMM Address width
    parameter   DW                      =   32,         //AVMM Data width
    parameter   TXMAC_CONTROL_ADDR      =   21'h40A,    //Address for register with disable bit
    parameter   DISABLE_MAC_BIT         =   2,          //Bit address for disable_tx_mac
    parameter   SHADOW_MAX              =   3,          //Upper bit for shadow register
    parameter   SHADOW_MIN              =   1,           //Lower bit for shadow register
	parameter   FLOW_CONTROL            =   "both"
)
(
    //clock & reset
    input logic 	                    i_clk,
    input logic 	                    i_rst_n, //Sync, active low
    input logic 	                    i_reconfig_clk,
    input logic 	                    i_reconfig_reset, //Sync, active low
    input logic 	                    i_rx_pcs_ready, //Async

    input logic 	                    i_ehip_ready,

    //Pause indicator input
    input   logic                           i_rx_pause,

    //TX Datapath interface
    input   logic                           i_tx_ready,

    //AVMM interface to EHIP
    output  logic   [AW-1:0]                o_eth_reconfig_addr,
    output  logic   [DW-1:0]                o_eth_reconfig_writedata,
    output  logic                           o_eth_reconfig_write,
    output  logic                           o_eth_reconfig_read,
    input   logic   [DW-1:0]                i_eth_reconfig_readdata,
    input   logic                           i_eth_reconfig_readdata_valid,
    input   logic                           i_eth_reconfig_waitrequest,

    //AVMM interface to Application
    input   logic   [AW-1:0]                i_usr_reconfig_addr,
    input   logic   [DW-1:0]                i_usr_reconfig_writedata,
    input   logic                           i_usr_reconfig_write,
    input   logic                           i_usr_reconfig_read,
    output  logic   [DW-1:0]                o_usr_reconfig_readdata,
    output  logic                           o_usr_reconfig_readdata_valid,
    output  logic                           o_usr_reconfig_waitrequest,

    output  logic                           o_ehip_shadow
);

//=============================================================================
// Declarations

    //State assignments for the sequencer (uses 1-hot, could be binary)
    localparam      STATES                  =   6;
    localparam      ST_IDLE                 =   0;
    localparam      ST_DISABLE_MAC          =   1;
    localparam      ST_WAIT_DATA_BLOCKED    =   2;
    localparam      ST_DATA_BLOCKED         =   3;
    localparam      ST_ENABLE_MAC           =   4;
    localparam      ST_ERROR                =   5;

    //Counter constants
    localparam      MAX_COUNT               =   8'hFF;
    localparam      MIN_COUNT               =   8'h00;

    //Filter constants; 6 cycles of o_tx_ready = 0 means blocked
    localparam      FW                      =   6;

	//Pass to the module that will do the actual enable/disable of the MAC
	localparam BLOCK_TRAFFIC = (FLOW_CONTROL == "both")? 1 : 0;

    logic   [7:0]                           count;          //Tracks PAUSE required
    logic                                   do_pause;       //Trigger PAUSE
    logic   [STATES-1:0]                    state;          //State register
    logic   [STATES-1:0]                    nextstate;      //Nextstate wire
    logic                                   inc;            //increment PAUSE count, registered
    logic                                   dec;            //decrement PAUSE count, registered
    logic                                   disable_mac;    //Request MAC disable, registered
    logic                                   enable_mac;     //Request MAC enable, registered
    logic                                   inc_c;          //increment PAUSE count
    logic                                   dec_c;          //decrement PAUSE count
    logic                                   disable_mac_c;  //Request MAC disable
    logic                                   enable_mac_c;   //Request MAC enable
    logic                                   disabled_rc;    //MAC disabled (reconfig clk)
    logic                                   enabled_rc;     //MAC enabled (reconfig clk)
    logic                                   mac_disabled;   //MAC disabled (i_clk)
    logic                                   mac_enabled;    //MAC enabled (i_clk)
    logic                                   data_blocked;   //TX datapath appears to be disabled
    logic 				    tx_ready_sync;
    logic   [FW-1:0]                        tx_ready_filter;//Collects i_tx_ready to detect block

    logic   [AW-1:0] 			    ma_eth_reconfig_addr;
    logic 				    ma_eth_reconfig_read_write;
    logic   [DW-1:0] 			    ma_eth_reconfig_writedata;
    logic 				    ma_eth_reconfig_write;
    logic 				    ma_eth_reconfig_read;
    logic   [DW-1:0] 			    ma_eth_reconfig_readdata;
    logic 				    ma_eth_reconfig_readdata_valid;
    logic 				    ma_eth_reconfig_waitrequest;
    logic 				    error;
	//logic i_rx_pause_r;

   //=============================================================================
   //Main Body of Code


    //=========================================================================
    //Track the i_pause signal with an up/down counter

    //The up down counter freezes when it hits its MAX or MIN values, and when
    //either both or neither inc and dec are asserted.
    always_ff @(posedge i_clk)
    if(~i_rst_n)    count   <=  '0;
    else            count   <=  inc ?                   8'(count + 1):
                                (dec && count != 8'h00) ?                   8'(count - 1):
                                                        count;

    //Assert do_pause when the counter is greater than 0
    always_ff @(posedge i_clk)
    if(~i_rst_n)    do_pause    <=  1'b0;
    else            do_pause    <=  (count > 8'd0);


    //=========================================================================
    //Assert data blocked after the AVMM operation to disable the MAC is
    //complete when o_tx_ready from EHIP is deasserted for at least 6 cycles
    //in a row (longer than an AM deassertion).

    //Collect FW bits of tx_ready in tx_ready_filter (a shift register)

   // synchronize i_tx_ready
   alt_xcvr_resync_std #(
			 .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
			 )
   u_sync_txready (
	       .clk    (i_clk),
	       .reset  (1'b0),
	       .d  (i_tx_ready),
	       .q  (tx_ready_sync)
	       );



    always_ff @(posedge i_clk)
    if(~i_rst_n)    tx_ready_filter <=  '0;
    else            tx_ready_filter <=  {tx_ready_filter[0+:(FW-1)],tx_ready_sync};

    //Set data blocked high when all bits in the tx ready filter are low
    assign  data_blocked    =    &(~tx_ready_filter);


    //=========================================================================
    //Use a small state machine to respond to PAUSE

      // State machine recovery logic in case it goes to illegal state

   alt_ehipc3_fm_sm_recover #(
			   .SWIDTH(6)
			   ) sm_recover_inst (
					      .clk(i_clk),
					      .rst_n(i_rst_n),
					      .state(state),
					      .error(error)
					      );


    //State and output registers
    always_ff @(posedge i_clk)
      begin
	 if(~i_rst_n) begin
            state       <=  f_1hot(ST_IDLE);
            inc         <=  '0;
            dec         <=  '0;
            disable_mac <=  '0;
            enable_mac  <=  '0;
			//i_rx_pause_r <= 1'b0;
	 end
	 else
           begin
	      state       <=  error ? f_1hot(ST_ERROR) : nextstate;
	      inc         <=  inc_c;
	      dec         <=  dec_c;
	      disable_mac <=  disable_mac_c;
	      enable_mac  <=  enable_mac_c;
		  //i_rx_pause_r <= i_rx_pause;
	   end // else: !if(~i_rst_n)
      end // always_ff @




    always_comb begin:nextstate_logic
       //This case statement implements a 1-hot state machine, using the fact
       //that case statement tests are symmetric. 1 is checked against each
       //of the state bits in the conditions below. For example, the ST_IDLE
       //logic is used when state[ST_IDLE] = 1'b1
       case(1'b1)

         //The State machine waits in the IDLE state until do_pause goes
         //high, then it switches off traffic in the MAC. Note that we wait
         //here to complete the mac_enabled handshake (mac_enabled low)
         state[ST_IDLE]:    begin
            nextstate       =   mac_enabled ?   f_1hot(ST_IDLE):
                                do_pause ?      f_1hot(ST_DISABLE_MAC):
                                f_1hot(ST_IDLE);

            dec_c           =                   1'b0;
            inc_c           =                   i_rx_pause;// | i_rx_pause_r;
            disable_mac_c   =                   1'b0;
            enable_mac_c    =                   1'b0;
         end

         //Disable the flow of traffic through the MAC using a write to the
         //AVMM
         state[ST_DISABLE_MAC]: begin
            nextstate       =   mac_disabled ?  f_1hot(ST_WAIT_DATA_BLOCKED):
                                f_1hot(ST_DISABLE_MAC);

            dec_c           =                   1'b0;
            inc_c           =                   i_rx_pause;// | i_rx_pause_r;
            disable_mac_c   =                   1'b1;
            enable_mac_c    =                   1'b0;

         end

         //Wait for TX Ready to go low for a few cycles, indicating
         //unambiguously that the TX MAC's traffic is frozen. Note that we
         //wait here to complete the mac_disabled handshake
         state[ST_WAIT_DATA_BLOCKED]: begin
            nextstate       =   mac_disabled ?  f_1hot(ST_WAIT_DATA_BLOCKED):
                                data_blocked ?  f_1hot(ST_DATA_BLOCKED):
                                f_1hot(ST_WAIT_DATA_BLOCKED);

            dec_c           =                   1'b0;
            inc_c           =                   i_rx_pause;
            disable_mac_c   =                   1'b0;
            enable_mac_c    =                   1'b0;
         end

         //Wait for the up_down counter to stop indicating that more pause
         //cycles are needed...
         state[ST_DATA_BLOCKED]: begin
            nextstate       =   do_pause ?      f_1hot(ST_DATA_BLOCKED):
                                f_1hot(ST_ENABLE_MAC);

            dec_c           =                   (!i_rx_pause && count >= 1);
            inc_c           =                   1'b0;
            disable_mac_c   =                   1'b0;
            enable_mac_c    =                   1'b0;

         end

         //Then enable the TX MAC
         state[ST_ENABLE_MAC]: begin
            nextstate       =   mac_enabled ?   f_1hot(ST_IDLE):
                                f_1hot(ST_ENABLE_MAC);

            dec_c           =                   1'b0;
            inc_c           =                   i_rx_pause;// | i_rx_pause_r;
            disable_mac_c   =                   1'b0;
            enable_mac_c    =                   1'b1;
         end

         //The default state is used to capture x and z input in
         //simulation
         default:    begin
	    nextstate       =                   f_1hot(ST_IDLE);
            dec_c           =                   1'b0;
            inc_c           =                   i_rx_pause;
            disable_mac_c   =                   1'b0;
            enable_mac_c    =                   1'b0;
         end

       endcase

    end // block: nextstate_logic



    //=========================================================================
    //Use a module in the reconfiguration clock domain to enable and disable
    //the MAC

    //Invert the reconfig reset signal so that it is active low
   assign reconfig_reset_n               = ~i_reconfig_reset;
   assign ma_eth_reconfig_readdata       =  i_eth_reconfig_readdata;
   assign ma_eth_reconfig_readdata_valid =  i_eth_reconfig_readdata_valid;
   assign ma_eth_reconfig_read_write     =  ma_eth_reconfig_read || ma_eth_reconfig_write;




    alt_ehipc3_fm_mac_enable_avmm #(
        .AW                 (AW                             ),  //AVMM Address width
        .DW                 (DW                             ),  //AVMM Data width
        .TXMAC_CONTROL_ADDR (TXMAC_CONTROL_ADDR             ),  //Address for register with disable bit
        .DISABLE_MAC_BIT    (DISABLE_MAC_BIT                ),  //Bit address for disable_tx_mac
        .SHADOW_MAX         (SHADOW_MAX                     ),  //Upper bit for shadow register
        .SHADOW_MIN         (SHADOW_MIN                     ),   //Lower bit for shadow register
		.FLOW_CONTROL       (BLOCK_TRAFFIC)                     //Based on flow_control setting from top level determine whether or not to block traffic on pause
    )
     u_avmm (
        .i_clk              (i_reconfig_clk                 ),
        .i_rst_n            (reconfig_reset_n               ),
	.i_ehip_ready       (i_ehip_ready),

        //AVMM Interface to EHIP, this goes to the arbiter
        .o_addr             (ma_eth_reconfig_addr            ),
        .o_writedata        (ma_eth_reconfig_writedata       ),
        .o_write            (ma_eth_reconfig_write           ),
        .o_read             (ma_eth_reconfig_read            ),
        .i_readdata         (ma_eth_reconfig_readdata        ),
        .i_readdata_valid   (ma_eth_reconfig_readdata_valid  ),
        .i_waitrequest      (ma_eth_reconfig_waitrequest     ),


        //AVMM Interface to Application
	// Replacing this with Arbiter

        .i_addr             ({AW{1'b0}}),
        .i_writedata        (32'd0),
        .i_write            (1'd0),
        .i_read             (1'd0),
        .o_waitrequest      (),


        .o_readdata         (o_usr_reconfig_readdata        ),
        .o_readdata_valid   (o_usr_reconfig_readdata_valid  ),

        //Interface to PAUSE sequencer SM
        .i_disable_mac      (disable_mac                    ),
        .i_enable_mac       (enable_mac                     ),
        .o_mac_disabled     (disabled_rc                    ),
        .o_mac_enabled      (enabled_rc                     ),
        .o_ehip_shadow      (o_ehip_shadow                  ),

	//case: 16018019092
	//to hold the immediate read of mac registers once the ehip_ready is asserted, until the current read/write transation is completed

	.i_usr_reconfig_read		(i_usr_reconfig_read)
    );


// Arbiter arbitrates between User AVMM and Pause AVMM
   alt_ehipc3_rcfg_arb #(
			 .total_masters  (3),
			 .channels       (1),
			 .address_width  (AW),
			 .data_width     (32)
			 )
   u_arbiter_inst (
	    // Basic AVMM inputs
	     .reconfig_clk         (i_reconfig_clk),
	     .reconfig_reset       (i_reconfig_reset),

	     // User AVMM input
	     .user_read            (i_usr_reconfig_read),
	     .user_write           (i_usr_reconfig_write),
	     .user_address         (i_usr_reconfig_addr),
	     .user_writedata       (i_usr_reconfig_writedata),
	     .user_read_write      (i_usr_reconfig_read || i_usr_reconfig_write),
	     .user_waitrequest     (o_usr_reconfig_waitrequest),


	     // Training CPU - Tie off this to 0 as not using it
	     .cpu_read             (1'b0),
	     .cpu_write            (1'b0),
	     .cpu_address          ({AW{1'b0}}),
	     .cpu_writedata        (32'd0),
	     .cpu_read_write       (1'b0),
	     .cpu_waitrequest      (),


	     // from mac_enable_avmm_block
	     .adapt_read            (ma_eth_reconfig_read),
	     .adapt_write           (ma_eth_reconfig_write),
	     .adapt_address         (ma_eth_reconfig_addr),
	     .adapt_writedata       (ma_eth_reconfig_writedata),
	     .adapt_read_write      (ma_eth_reconfig_read_write),
	     .adapt_waitrequest     (ma_eth_reconfig_waitrequest),

	     // AVMM output the ehip and the CSR
	     .avmm_waitrequest     (i_eth_reconfig_waitrequest),
	     .avmm_read            (o_eth_reconfig_read),
	     .avmm_write           (o_eth_reconfig_write),
	     .avmm_address         (o_eth_reconfig_addr),
	     .avmm_writedata       (o_eth_reconfig_writedata)
	     );



   //=========================================================================
    //Synchronize the outputs from u_avmm that are used by the state machine


    //Synchronize the mac disabled and mac enabled signals to the local clock
    //domain. Note that the signals are part of a handshake, so we do not have
    //a concern about slow->fast clock or fast->slow clock transition

   alt_xcvr_resync_std #(
			 .SYNC_CHAIN_LENGTH(3),    .WIDTH(2),  .INIT_VALUE(0)
			 )
   u_sync_mac (
	       .clk    (i_clk),
	       .reset  (1'b0),
	       .d  ({enabled_rc, disabled_rc}),
	       .q  ({mac_enabled, mac_disabled})
	       );

   //=========================================================================


   //Return the state encoding as a 1-hot value over STATES bits
   function automatic logic [STATES-1:0] f_1hot(integer state);

      logic   [STATES-1:0]    state0;

      state0      =   '0;
      state0[0]   =   1'b1;
      return      state0 << state;

   endfunction

endmodule
