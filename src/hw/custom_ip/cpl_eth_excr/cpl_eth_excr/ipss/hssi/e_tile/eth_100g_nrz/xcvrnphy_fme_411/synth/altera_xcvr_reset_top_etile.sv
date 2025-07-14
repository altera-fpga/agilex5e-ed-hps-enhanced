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


`timescale 1ns / 1ns



module  altera_xcvr_reset_top_etile
#(
    // General Options
    parameter NUM_CHANNELS                = 1,		// Number of CHANNELS
    parameter SYS_CLK_IN_MHZ              = 250,	// Clock frequency in MHz. Required for reset timers
    parameter DEFAULT_RESET_SEPARATION_NS = 100,
    parameter RESET_SEPARATION_NS         = 100,
    parameter SPACE_NS                    = 100,
    parameter REDUCED_SIM_TIME            = 1,		// (0,1) 1=Reduced reset timings for simulation
    parameter REDUCED_RESET_SIM_TIME      = 0,		//
    parameter ENABLE_IND_CHANNEL          = 0,   		// (0,1) 1=Enable independent Channel resets.
    parameter ENABLE_IND_TXRX             = 0,   		// (0,1) 1=Enable independent TX RX resets, 0=Tie rx_reset input with tx_reset.
    parameter ENABLE_MANUAL               = 0,
    parameter ENABLE_RSFEC                = 1,
    parameter ENABLE_SEQ                  = 0,		// (0,1) 0=TX and RX resets are independent of each other
							//       1=Enable sequencing of TX and RX resets (TX gates RX) (Need to set to 1 for RSFEC Mode)

    // TX options
    parameter TX_ENABLE         = 0,    // (0,1) Enable TX resets
    parameter T_TX_RESET = 20,   // tx_digitalreset period

    // RX options
    parameter RX_ENABLE         = 0,    // (0,1) Enable RX resets
    parameter T_RX_LOCKTODATA   = 180000,   // rx_analogreset period
    parameter T_RX_RESET = 4000 // rx_digitalreset period,

) (
  //User reset control inputs (must by synchronous with clock)
  input   wire  [NUM_CHANNELS-1:0]  tx_reset, // reset request for tx from User
  input   wire  [NUM_CHANNELS-1:0]  rx_reset, // reset request for rx from User
  input   wire  [NUM_CHANNELS-1:0]  reset_in, // reset request for from User if ENABLE_IND_TXRX=0

  // TX control inputs
  input   wire  [NUM_CHANNELS-1:0]  tx_serdes_rdy,        // TX SERDES calibration status (from PHY/Reconfig)

  // RX control inputs
  input   wire  [NUM_CHANNELS-1:0]  rx_is_lockedtodata, // RX CDR PLL locked-to-data status (from PHY)
  input   wire  [NUM_CHANNELS-1:0]  rx_serdes_rdy,      // RX channel calibration status (from PHY/Reconfig)


  // Reset Sequencer signals
  input  wire [NUM_CHANNELS-1:0] tx_transfer_ready,
  input  wire [NUM_CHANNELS-1:0] rx_transfer_ready,
  output  wire [NUM_CHANNELS-1:0] tx_reset_timeout,
  output  wire [NUM_CHANNELS-1:0] rx_reset_timeout,
  output  wire [NUM_CHANNELS-1:0] tx_aib_reset_out,
  output  wire [NUM_CHANNELS-1:0] rx_aib_reset_out,
  output  wire                    rsfec_reset_out,
  output  wire                    tx_rsfec_reset_out,
  output  wire                    rx_rsfec_reset_out,
  output  wire [NUM_CHANNELS-1:0] tx_xcvrif_reset_out,
  output  wire [NUM_CHANNELS-1:0] rx_xcvrif_reset_out,

  input   reg   [NUM_CHANNELS-1:0]  tx_reset_req,       // TX reset request
  input   reg   [NUM_CHANNELS-1:0]  rx_reset_req,       // RX reset request
  output  reg   [NUM_CHANNELS-1:0]  tx_reset_ack,       // TX reset acknowledge
  output  reg   [NUM_CHANNELS-1:0]  rx_reset_ack,       // RX reset acknowledge
  // Status output
  output  wire  [NUM_CHANNELS-1:0]  tx_reset_stat,      // TX reset status
  output  wire  [NUM_CHANNELS-1:0]  rx_reset_stat,      // RX reset status
  output  wire  [NUM_CHANNELS-1:0]  tx_ready,           // TX is not in reset
  output  wire  [NUM_CHANNELS-1:0]  rx_ready            // RX is not in reset

);


wire reset_n;
wire [NUM_CHANNELS-1:0] tx_reset_out;
wire [NUM_CHANNELS-1:0] rx_reset_out;
reg  [NUM_CHANNELS-1:0] tx_reset_req_sync;
reg  [NUM_CHANNELS-1:0] rx_reset_req_sync;
//***************************************************************************
//*************************** Local Parameters ******************************
localparam  CLK_FREQ_IN_HZ = SYS_CLK_IN_MHZ*1000000;


//***************************************************************************
// Getting the clock from Master TRS
//***************************************************************************
altera_s10_xcvr_clkout_endpoint clock_endpoint (
	.clk_out(clk)
);



//***************************************************************************
// Instantiate TRE for MANUAL Mode
//***************************************************************************

genvar ig;
generate
   for (ig=0;ig<NUM_CHANNELS;ig=ig+1) begin : g_reset_sync
       if (ENABLE_MANUAL) begin

          if (TX_ENABLE) begin
             alt_xcvr_resync_std #(
               .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
               .WIDTH            (1),  // Number of bits to resync
               .INIT_VALUE       (1'b1)
             ) alt_xcvr_resync_tx_reset_req (
               .clk    (clk        ),
               .reset  (tx_reset_req[ig]   ),
               .d      (0       ),
               .q      (tx_reset_req_sync[ig] )
             );
             if (REDUCED_RESET_SIM_TIME) begin
                assign tx_reset_ack[ig] = tx_reset_req_sync[ig];
             end else begin
               altera_s10_xcvr_reset_endpoint altera_s10_xcvr_tx_reset_endpoint_inst (
                  .tre_reset_req(tx_reset_req_sync[ig]),
                  .tre_reset_ack(tx_reset_ack[ig])
                  );
             end
          end	//TX end

          if (RX_ENABLE) begin
             alt_xcvr_resync_std #(
               .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
               .WIDTH            (1),  // Number of bits to resync
               .INIT_VALUE       (1'b1)
             ) alt_xcvr_resync_rx_reset_req (
               .clk    (clk        ),
               .reset  (rx_reset_req[ig]   ),
               .d      (0       ),
               .q      (rx_reset_req_sync[ig] )
             );
             if (REDUCED_RESET_SIM_TIME) begin
                assign rx_reset_ack[ig] = rx_reset_req_sync[ig];
             end else begin
               altera_s10_xcvr_reset_endpoint altera_s10_xcvr_rx_reset_endpoint_inst (
                  .tre_reset_req(rx_reset_req_sync[ig]),
                  .tre_reset_ack(rx_reset_ack[ig])
                  );
             end
          end	//RX end
      end	//g_tre end
   end
endgenerate

//***************************************************************************
// Instantiate RESET IP AUTO Mode
//***************************************************************************
if (!ENABLE_MANUAL) begin


	//***************************************************************************
	// Need to self-generate internal reset signal for Local Sequencers
	//***************************************************************************
	alt_xcvr_resync_std #(
		.SYNC_CHAIN_LENGTH(3),
		.INIT_VALUE(0)
	) reset_n_generator (
		.clk	(clk),
		.reset	(1'b0),
		.d		(1'b1),
		.q		(reset_n)
	);



	//***************
	// RESET CONTROL
	//***************
	if (ENABLE_IND_TXRX) begin
		if (TX_ENABLE)
			altera_xcvr_reset_control_etile #(
			.NUM_CHANNELS(NUM_CHANNELS),
			.SYS_CLK_IN_MHZ(SYS_CLK_IN_MHZ),
			.ENABLE_IND_CHANNEL(ENABLE_IND_CHANNEL),
			.REDUCED_SIM_TIME(REDUCED_SIM_TIME),
			.TX_ENABLE(1'b1),
			.T_TX_RESET(T_TX_RESET)
			) tx_reset_control_inst(
			.clk			(clk),
			.reset_in		(tx_reset),
			.tx_reset_out		(tx_reset_out),
			.rx_reset_out		(),
			.tx_ready		(tx_ready),
			.rx_ready		(),
			.rx_is_lockedtodata	(),
			.tx_serdes_rdy		(tx_serdes_rdy),
			.rx_serdes_rdy		(),
			.tx_reset_stat		(tx_reset_stat),
			.rx_reset_stat		()
			);
		if (RX_ENABLE)
			altera_xcvr_reset_control_etile #(
			.NUM_CHANNELS(NUM_CHANNELS),
			.SYS_CLK_IN_MHZ(SYS_CLK_IN_MHZ),
			.ENABLE_IND_CHANNEL(ENABLE_IND_CHANNEL),
			.REDUCED_SIM_TIME(REDUCED_SIM_TIME),
			.RX_ENABLE(1'b1),
			.T_RX_LOCKTODATA(T_RX_LOCKTODATA),
			.T_RX_RESET(T_RX_RESET)
			) rx_reset_control_inst(
			.clk			(clk),
			.reset_in		(rx_reset),
			.tx_reset_out		(),
			.rx_reset_out		(rx_reset_out),
			.tx_ready		(),
			.rx_ready		(rx_ready),
			.rx_is_lockedtodata	(rx_is_lockedtodata),
			.tx_serdes_rdy		(),
			.rx_serdes_rdy		(rx_serdes_rdy),
			.tx_reset_stat		(),
			.rx_reset_stat		(rx_reset_stat)
			);
	end
	else begin 	//No individual TX RX
		altera_xcvr_reset_control_etile #(
		.NUM_CHANNELS(NUM_CHANNELS),
		.SYS_CLK_IN_MHZ(SYS_CLK_IN_MHZ),
		.REDUCED_SIM_TIME(REDUCED_SIM_TIME),
		.ENABLE_IND_CHANNEL(ENABLE_IND_CHANNEL),
		.ENABLE_SEQ(ENABLE_SEQ),
		.TX_ENABLE(1'b1),
		.T_TX_RESET(T_TX_RESET),
		.RX_ENABLE(1'b1),
		.T_RX_LOCKTODATA(T_RX_LOCKTODATA),
		.T_RX_RESET(T_RX_RESET)
		) reset_control_inst(
		.clk			(clk),
		.reset_in		(reset_in),
		.tx_reset_out		(tx_reset_out),
		.rx_reset_out		(rx_reset_out),
		.tx_ready		(tx_ready),
		.rx_ready		(rx_ready),
		.rx_is_lockedtodata	(rx_is_lockedtodata),
		.tx_serdes_rdy		(tx_serdes_rdy),
		.rx_serdes_rdy		(rx_serdes_rdy),
		.tx_reset_stat		(tx_reset_stat),
		.rx_reset_stat		(rx_reset_stat)
		);
	end

	//****************
	// RESET SEQUENCER
	//****************
	if (TX_ENABLE) begin
		alt_xcvr_native_tx_reset_seq #(
		.CLK_FREQ_IN_HZ					(CLK_FREQ_IN_HZ),
		.DEFAULT_RESET_SEPARATION_NS			(DEFAULT_RESET_SEPARATION_NS),
		.RESET_SEPARATION_NS				(RESET_SEPARATION_NS),
		.REDUCED_RESET_SIM_TIME         		(REDUCED_RESET_SIM_TIME),
		.NUM_CHANNELS					(NUM_CHANNELS),
		.ENABLE_IND_CHANNEL				(ENABLE_IND_CHANNEL),
		.ENABLE_RSFEC					(ENABLE_RSFEC)
		) tx_reset_seq (
		.clk					(clk),
		.reset_n				(reset_n),
		.reset_in				(tx_reset_out),
		.transfer_ready_in			(tx_transfer_ready),
		.aib_reset_out				(tx_aib_reset_out),
		.xcvrif_reset_out			(tx_xcvrif_reset_out),
		.rsfec_reset_out			(tx_rsfec_reset_out),
		.rsfec_dig_reset_out			(rsfec_reset_out),
		.reset_stat				(tx_reset_stat),
		.reset_timeout				(tx_reset_timeout)
		);
	end else begin
		assign tx_aib_reset_out = {NUM_CHANNELS{1'b0}};
		assign tx_xcvrif_reset_out = {NUM_CHANNELS{1'b0}};
		assign tx_rsfec_reset_out = 1'b0;
		assign rsfec_reset_out = 1'b0;
		assign tx_reset_stat = {NUM_CHANNELS{1'b0}};
		assign tx_reset_timeout = {NUM_CHANNELS{1'b0}};
	end

	if (RX_ENABLE) begin
	// rx_reset
		alt_xcvr_native_rx_reset_seq #(
		.CLK_FREQ_IN_HZ					(CLK_FREQ_IN_HZ),
		.DEFAULT_RESET_SEPARATION_NS			(DEFAULT_RESET_SEPARATION_NS),
		.ENABLE_IND_CHANNEL				(ENABLE_IND_CHANNEL),
		.ENABLE_RSFEC					(ENABLE_RSFEC),
		.RESET_SEPARATION_NS				(RESET_SEPARATION_NS),
		.REDUCED_RESET_SIM_TIME				(REDUCED_RESET_SIM_TIME),
		.NUM_CHANNELS					(NUM_CHANNELS)
		) rx_reset_seq (
		.clk					(clk),
		.reset_n				(reset_n),
		.reset_in				(rx_reset_out),
		.transfer_ready_in			(rx_transfer_ready),
		.aib_reset_out				(rx_aib_reset_out),
		.xcvrif_reset_out			(rx_xcvrif_reset_out),
		.rsfec_reset_out			(rx_rsfec_reset_out),
		.reset_stat				(rx_reset_stat),
		.reset_timeout				(rx_reset_timeout)
		);
	end else begin
		assign rx_aib_reset_out = {NUM_CHANNELS{1'b0}};
		assign rx_xcvrif_reset_out = {NUM_CHANNELS{1'b0}};
		assign rx_rsfec_reset_out = {NUM_CHANNELS{1'b0}};
		assign rx_reset_stat = {NUM_CHANNELS{1'b0}};
		assign rx_reset_timeout = {NUM_CHANNELS{1'b0}};
	end

end


endmodule
