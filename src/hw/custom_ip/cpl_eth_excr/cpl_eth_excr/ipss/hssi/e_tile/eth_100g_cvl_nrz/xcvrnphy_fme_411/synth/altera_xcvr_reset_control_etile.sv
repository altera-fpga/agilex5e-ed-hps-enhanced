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



// File Name: altera_xcvr_reset_control_etile.sv
//
// Description:
//
//    A configurable reset controller for Crete3 intended to drive resets for HSSI transceiver interfaces(FIFO), RSFEC
//  and the AIB adapter blocks. The reset controller makes use of individual reset counters to control reset timing for
//  the various reset outputs.
//
//
//     Features:
//      - Optional TX,RX reset control.
//      - Optional Independent TX RX control
//	- Optional sequnce TX and RX.(use tx_reset to sequentially reset TX then RX)
//      - Synchronization of the reset input
//      - Reset control per channel or shared. (ENABLE_IND_CHANNEL E.g. separate rx_reset control for each channel or one rx_reset for all channels)
//      - Configurable reset timings
//	- Faster reset time for simulation

`timescale 1ns / 1ns
//`timescale 1ps / 1ps


module  altera_xcvr_reset_control_etile
#(
    // General Options
    parameter NUM_CHANNELS           = 1,		// Number of CHANNELS
    parameter SYS_CLK_IN_MHZ         = 250,		// Clock frequency in MHz. Required for reset timers
    parameter REDUCED_SIM_TIME       = 1,		// (0,1) 1=Reduced reset timings for simulation
    parameter ENABLE_IND_CHANNEL     = 0,		// (0,1) 1=Enable independent Channel resets.
    parameter ENABLE_SEQ             = 0,		// (0,1) 0=TX and RX resets are independent of each other
							//       1=Enable sequencing of TX and RX resets (TX gates RX) (Need to set to 1 for RSFEC Mode)


    // TX options
    parameter TX_ENABLE              = 0,    // (0,1) Enable TX resets
    parameter T_TX_RESET             = 20,   // tx_reset period

    // RX options
    parameter RX_ENABLE              = 0,    // (0,1) Enable RX resets
    parameter T_RX_LOCKTODATA        = 180000,   // rx_analogreset period
    parameter T_RX_RESET             = 4000 // rx_reset period

) (
  // User inputs and outputs
  input   wire    clk  ,  // System clock

  //User reset control inputs (must by synchronous with clock)
  input   wire  [NUM_CHANNELS-1:0]  reset_in, // reset request for from User

  // TX control inputs
  input   wire  [NUM_CHANNELS-1:0]  tx_serdes_rdy,        // TX SERDES calibration status (from PHY/Reconfig)

  // RX control inputs
  input   wire  [NUM_CHANNELS-1:0]  rx_is_lockedtodata, // RX CDR PLL locked-to-data status (from PHY)
  input   wire  [NUM_CHANNELS-1:0]  rx_serdes_rdy,      // RX channel calibration status (from PHY/Reconfig)

  // Status input
  input   wire  [NUM_CHANNELS-1:0]  tx_reset_stat,  // TX reset status (from Local Sequencer)
  input   wire  [NUM_CHANNELS-1:0]  rx_reset_stat,  // RX reset status (from Local Sequencer)


  // Reset signals
  output  wire  [NUM_CHANNELS-1:0]  tx_reset_out,    // reset TX (to PHY)
  output  wire  [NUM_CHANNELS-1:0]  rx_reset_out,    // reset RX (to PHY)

  // Status output
  output  wire  [NUM_CHANNELS-1:0]  tx_ready,           // TX is not in reset
  output  wire  [NUM_CHANNELS-1:0]  rx_ready            // RX is not in reset

);

// Faster reset time for simulation if indicated
localparam  SYNTH_CLK_IN_HZ = SYS_CLK_IN_MHZ * 1000000;
localparam  SIM_CLK_IN_HZ = (REDUCED_SIM_TIME == 1)
                            ? 2 * 1000000 : SYNTH_CLK_IN_HZ;
`ifdef ALTERA_RESERVED_QIS
  localparam  SYS_CLK_IN_HZ = SYNTH_CLK_IN_HZ;
`else
  localparam  SYS_CLK_IN_HZ = SIM_CLK_IN_HZ;
`endif


wire [NUM_CHANNELS-1:0]  reset_sync;         // Synchronized reset input

genvar ig;


//**************************************************************************
//************************ Synchronize Reset Input *************************

generate
  for (ig=0;ig<NUM_CHANNELS;ig=ig+1) begin : g_reset_sync
      alt_xcvr_resync_etile #(
        .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
        .WIDTH            (1),  // Number of bits to resync
        .INIT_VALUE       (1'b1)
      ) alt_xcvr_resync_reset_1 (
        .clk    (clk        ),
        .reset  (reset_in[ig]   ),
        .d      (1'b0       ),
        .q      (reset_sync[ig] )
      );
   end
endgenerate

//************************End Synchronize Reset Input **********************
//**************************************************************************


//***************************************************************************
//***************************** TX Reset Logic ******************************

// Local wire needed for the case where TX reset must be deasserted complete before RX reset is deasserted
// Synchronized signals
wire [NUM_CHANNELS-1:0] tx_reset_stat_assert_sync;   // tx_reset_stat after synchronization (used for assertion)
wire [NUM_CHANNELS-1:0] tx_reset_stat_deassert_sync; // tx_reset_stat after synchronization (used for deassertion)
wire [NUM_CHANNELS-1:0] tx_reset_int;
wire [NUM_CHANNELS-1:0] stat_tx_reset;

generate if(TX_ENABLE) begin: g_tx

  for (ig=0;ig<NUM_CHANNELS;ig=ig+1) begin : g_tx
    if(ig == 0 || ENABLE_IND_CHANNEL == 1) begin : g_tx

      wire  lcl_tx_serdes_rdy;                 // tx_serdes_rdy for this channel
      wire  lcl_tx_reset_stat_assert;          // tx_reset_stat used for assertion
      wire  lcl_tx_reset_stat_deassert;        // tx_reset_stat used for deassertion


      // Control signal for this channel. With separate reset control per channel, each channel
      // listens to its own control signal. Otherwise the control signals for all channels are
      // combined for the shared reset control.
      assign  lcl_tx_serdes_rdy                 = ENABLE_IND_CHANNEL ? tx_serdes_rdy[ig]  : &tx_serdes_rdy;
      assign  lcl_tx_reset                      = ENABLE_IND_CHANNEL ? reset_sync [ig]  : |reset_sync;
      assign  lcl_tx_reset_stat_assert          = ENABLE_IND_CHANNEL ? tx_reset_stat[ig] : &tx_reset_stat;
      assign  lcl_tx_reset_stat_deassert        = ENABLE_IND_CHANNEL ? tx_reset_stat[ig] : |tx_reset_stat;


      // Synchonize TX inputs
      wire tx_serdes_rdy_sync;                // tx_serdes_rdy after synchronization
      wire tx_reset_sync;

      alt_xcvr_resync_std #(
          .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
          .WIDTH      (3),
          .INIT_VALUE (0)
      ) resync_tx_cal_busy (
        .clk    (clk              ),
        .reset  (reset_sync[ig]   ),
//        .reset  (lcl_tx_reset   ),
        .d      ({lcl_tx_serdes_rdy, lcl_tx_reset_stat_assert, lcl_tx_reset_stat_deassert}),
        .q      ({tx_serdes_rdy_sync, tx_reset_stat_assert_sync[ig], tx_reset_stat_deassert_sync[ig]})
      );

      // tx_reset_out
      // Assert tx_reset_out while any of the following
      // 1 - tx_serdes_rdy is deasserted.
      // 2 - reset input (asynchronous) is asserted.
      // 3 - tx_reset_stat is deasserted and stat_tx_reset is asserted.
      alt_xcvr_reset_counter_s10_etile #(
          .CLKS_PER_SEC (SYS_CLK_IN_HZ    ), // Clock frequency in Hz
          .RESET_PER_NS (T_TX_RESET )  // Reset period in ns
      ) counter_tx_reset (
        .clk        (clk                     ),
        .async_req  (reset_sync[ig]          ),  // asynchronous reset request
        .sync_req   (~tx_serdes_rdy_sync|(~tx_reset_stat_assert_sync[ig]&stat_tx_reset[ig])),  // synchronous reset request
        .reset_or   (1'b0                    ),  // auxilliary reset override
        .reset      (tx_reset_out[ig]        ),  // synchronous reset out
        .reset_n    (/*unused*/              ),
        .reset_stat (stat_tx_reset[ig]       )
      );

      // tx_ready
      // Assert when tx_reset_out and tx_reset_stat deassert
      alt_xcvr_reset_counter_s10_etile #(
          .RESET_COUNT(3)
      ) counter_tx_ready (
        .clk        (clk                  ),
        .async_req  (reset_sync[ig]           ),  // asynchronous reset request
        .sync_req   (stat_tx_reset[ig] | tx_reset_stat_deassert_sync[ig]),  // synchronous reset request
        .reset_or   (1'b0                 ),  // auxilliary reset override
        .reset      (/*unused*/           ),  // synchronous reset out
        .reset_n    (tx_ready[ig]         ),
        .reset_stat (/*unused*/           )   // reset status
      );
    end else begin : g_fanout_tx
      assign  tx_reset_out    [ig]                   = tx_reset_out    [0];
      assign  tx_ready        [ig]                   = tx_ready        [0];
      assign  stat_tx_reset   [ig]                   = stat_tx_reset   [0];
      assign  tx_reset_stat_assert_sync[ig]               = tx_reset_stat_assert_sync[0];
      assign  tx_reset_stat_deassert_sync[ig]             = tx_reset_stat_deassert_sync[0];
    end
  end
end else begin : g_no_tx
  assign  tx_reset_out    = {NUM_CHANNELS{1'b0}};
  assign  tx_ready        = {NUM_CHANNELS{1'b0}};
end
endgenerate
//*************************** End TX Reset Logic ****************************
//***************************************************************************


//***************************************************************************
//***************************** RX Reset Logic ******************************
generate if (RX_ENABLE) begin : g_rx
  for (ig=0;ig<NUM_CHANNELS;ig=ig+1) begin : g_rx
    if(ig == 0 || ENABLE_IND_CHANNEL == 1) begin : g_rx
      wire  lcl_rx_serdes_rdy;                 // rx_serdes_rdy for this channel
      wire  lcl_rx_is_lockedtodata;            // rx_is_lockedtodata for this channel
      wire  lcl_rx_reset_stat_assert;          // rx_reset_stat used for assertion
      wire  lcl_rx_reset_stat_deassert;        // rx_reset_stat used for deassertion

      // Synchronized signals
      wire  rx_serdes_rdy_sync;                 // rx_serdes_rdy after synchronization
      wire  rx_reset_stat_assert_sync;          // rx_reset_stat after synchronization (used for assertion)
      wire  rx_reset_stat_deassert_sync;        // rx_reset_stat after synchronization (used for deassertion)

      // Reset status signals
      wire  stat_rx_reset;
      wire [NUM_CHANNELS-1:0] rx_reset_int;

      // Control signal for this channel. With separate reset control per channel, each channel
      // listens to its own control signal. Otherwise the control signals for all channels are
      // combined for the shared reset control.
      assign  lcl_rx_serdes_rdy                 = ENABLE_IND_CHANNEL  ? rx_serdes_rdy      [ig]  : &rx_serdes_rdy;
      assign  lcl_rx_is_lockedtodata            = ENABLE_IND_CHANNEL  ? rx_is_lockedtodata [ig]  : &rx_is_lockedtodata;
      assign  lcl_rx_reset_stat_assert          = ENABLE_IND_CHANNEL  ? rx_reset_stat[ig] : &rx_reset_stat;
      assign  lcl_rx_reset_stat_deassert        = ENABLE_IND_CHANNEL  ? rx_reset_stat[ig] : | rx_reset_stat;

      // Synchonize RX inputs
      alt_xcvr_resync_std #(
          .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
          .WIDTH            (4),
          .INIT_VALUE       (4'b0000)
      ) resync_rx_cal_busy (
        .clk    (clk              ),
        .reset  (reset_sync[ig]       ),
        .d      ({lcl_rx_serdes_rdy , lcl_rx_is_lockedtodata, lcl_rx_reset_stat_assert , lcl_rx_reset_stat_deassert }),
        .q      ({rx_serdes_rdy_sync, rx_is_lockedtodata_sync, rx_reset_stat_assert_sync, rx_reset_stat_deassert_sync})
      );

      // Assert after soft IP filter time(180us) when rx_is_lockedtodata assert
      alt_xcvr_reset_counter_s10_etile #(
          .CLKS_PER_SEC (SYS_CLK_IN_HZ    ), // Clock frequency in Hz
          .RESET_PER_NS (T_RX_LOCKTODATA  ), // Delay hold period in ns
          .ACTIVE_LEVEL (0)
      ) counter_locktodata_sync (
        .clk        (clk                  ),
        .async_req  (reset_sync[ig]       ),  // asynchronous reset request
        .sync_req   (~rx_is_lockedtodata_sync),  // asynchronous reset request
        .reset_or   (1'b0                 ),  // auxilliary reset override
        .reset      (rx_is_lockedtodata_delay),  // synchronous reset out
        .reset_n    (/*unused*/           ),
        .reset_stat (/*unused*/           )   // reset status
      );

      // rx_reset_out
      // Assert rx_reset_out while any of the following:
      // 1 - rx_serdes_rdy is low.
      // 2 - rx_reset input (asynchronous) is asserted.
      // 3 - rx_reset_stat is deasserted and stat_rx_reset is asserted.
      // 4 - RX is not locked to data
      //        (meaning user wants us to respond to loss of RX data lock)
      // 5 - ENABLE_SEQ: stat_tx_reset or tx_reset_stat are asserted
      if (TX_ENABLE && ENABLE_SEQ)
        alt_xcvr_reset_counter_s10_etile #(
            .CLKS_PER_SEC (SYS_CLK_IN_HZ    ), // Clock frequency in Hz
            .RESET_PER_NS (T_RX_RESET )  // Reset period in ns
        ) counter_rx_reset (
          .clk        (clk                    ),
          .async_req  (reset_sync[ig]             ),  // asynchronous reset request
          .sync_req   (~rx_serdes_rdy_sync|~rx_is_lockedtodata_delay|(~rx_reset_stat_assert_sync&stat_rx_reset)|tx_reset_stat_deassert_sync[ig]|stat_tx_reset[ig]),  // synchronous reset request
          .reset_or   (1'b0          ),  // auxil0iary reset override
          .reset      (rx_reset_out[ig]    ),  // synchronous reset out
          .reset_n    (/*unused*/             ),
          .reset_stat (stat_rx_reset   )
        );
      else
        alt_xcvr_reset_counter_s10_etile #(
            .CLKS_PER_SEC (SYS_CLK_IN_HZ    ), // Clock frequency in Hz
            .RESET_PER_NS (T_RX_RESET )  // Reset period in ns
        ) counter_rx_reset (
          .clk        (clk                    ),
          .async_req  (reset_sync[ig]             ),  // asynchronous reset request
          .sync_req   (~rx_serdes_rdy_sync|~rx_is_lockedtodata_delay|(~rx_reset_stat_assert_sync&stat_rx_reset)),  // synchronous reset request
          .reset_or   (1'b0          ),  // auxilliary reset override
          .reset      (rx_reset_out[ig]    ),  // synchronous reset out
          .reset_n    (/*unused*/             ),
          .reset_stat (stat_rx_reset   )
        );

      // rx_ready
      alt_xcvr_reset_counter_s10_etile #(
          .RESET_COUNT(3)
      ) counter_rx_ready (
        .clk        (clk                  ),
        .async_req  (reset_sync[ig]       ),  // asynchronous reset request
        .sync_req   (stat_rx_reset | rx_reset_stat_deassert_sync),  // synchronous reset request
        .reset_or   (1'b0                 ),  // auxilliary reset override
        .reset      (/*unused*/           ),  // synchronous reset out
        .reset_n    (rx_ready[ig]         ),
        .reset_stat (/*unused*/           )
      );

    end else begin : g_fanout_rx
      assign  rx_reset_out [ig]  = rx_reset_out [0];
      assign  rx_ready     [ig]  = rx_ready     [0];
    end
  end
end else begin : g_no_rx
  assign  rx_reset_out        = {NUM_CHANNELS{1'b0}};
  assign  rx_ready        = {NUM_CHANNELS{1'b0}};
end
endgenerate
//*************************** End RX Reset Logic ****************************
//***************************************************************************

endmodule
