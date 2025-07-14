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


// (C) 2001-2019 Intel Corporation. All rights reserved.
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


// (C) 2001-2018 Intel Corporation. All rights reserved.
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


// (C) 2001-2018 Intel Corporation. All rights reserved.
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


// (C) 2001-2018 Intel Corporation. All rights reserved.
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





//============================================================================
// Define Parameters
//============================================================================
`define RXDC_IDLE               72'h8_3c1e_0f07_8_3c1e_0f07
`define XGMII_IDLE_D            64'h0707_0707_0707_0707
`define XGMII_IDLE_C             8'b11111111
`define XGMII_START              8'hFB
`define XGMII_TERMINATE          8'hFD
`define FRAME_TYPE_CONSTANT      4'b0001
`define FRAME_TYPE_CONSTANT_CRC  4'b1001
`define FRAME_TYPE_INCREMENT     4'b0010
`define FRAME_TYPE_RANDOM        4'b0100
`define MAX_FRAME                1600

`define BUS_WIDTH 8
`define PATTERN   8'hBC   // 20'b1010000011_0101111100

`timescale 1 ps/1 ps

module test_harness #(
  parameter SYNTH_GMII          = 1,
  parameter lanes				= 4,
  parameter ENABLE_RSFEC				= 0
  ) (
  input  wire        xgmii_rx_clk        ,
  input  wire        xgmii_tx_clk        ,
  input  wire        rx_ready            ,
  input  wire        rx_ready_gmii       ,
  input  wire		 i_tx_mii_ready		 ,
  input  wire        led_an              ,
  input  wire		 o_tx_lanes_stable	 ,
  input  wire		 o_rx_pcs_ready		 ,
  output reg		 o_tx_mii_valid		 ,
  output reg		 o_tx_mii_am		 ,
  input  wire		 o_rx_mii_am_valid	,
  input  wire		 o_rx_mii_valid	,
  // GMII ports
  input  wire        tx_clkout_1g        ,
  input  wire        rx_clkout_1g        ,
//  output wire [ 7:0] gmii_tx_d           ,
//  input  wire [ 7:0] gmii_rx_d           ,
//  output wire        gmii_tx_en          ,
//  input  wire        gmii_rx_en          ,
//  output wire        gmii_tx_err         ,
//  input  wire        gmii_rx_err         ,
//  input  wire        gmii_rx_dv          ,
  // XMGII ports
  output reg  [64*lanes-1:0] xgmii_tx_d         ,
  output reg  [8*lanes-1:0]  xgmii_tx_c         ,
  input  wire [64*lanes-1:0] xgmii_rx_d         ,
  input  wire [8*lanes-1:0]  xgmii_rx_c         ,
  input  wire [71:0] xgmii_rx_dc_ch1     ,
  // avalon phy master for phy controls
  input  wire [ 7:0] phy_mgmt_address    ,
  input  wire        phy_mgmt_clk        ,
  input  wire        phy_mgmt_clk_reset  ,
  input  wire        phy_mgmt_read       ,
  input  wire [31:0] phy_mgmt_writedata  ,
  input  wire        phy_mgmt_write      ,
  output reg  [31:0] phy_mgmt_readdata   ,
  output wire        phy_mgmt_waitrequest,
  // output for channel control
  output wire        reset_hold
);

//****************************************************************************
// Define Parameters
//****************************************************************************
  `ifdef ALTERA_RESERVED_QIS
    // Enable full-length timers for synthesis.
    // Usually have short timers for sim performance
    `define ALTERA_RESERVED_XCVR_FULL_KR_TIMERS
  `endif // QIS

//***************************************************************************
// Limintation for this test_harness pkt generator and checker
// 1. the min size packet: 64 Byte.
// 2. the max size packet: 9999 Byte.
//***************************************************************************

  //wire [72*lanes-1:0] xgmii_tx_dc			;
  wire [72*lanes-1:0] xgmii_rx_dc			;
  wire        xgmii_tx_clk_from_xgmii_src;
  wire        frame_done                 ; // 10G XXGMII source done sending a frame
  wire [255:0] xgmii_rx_d_mon             ; // monitor signals from XGMII source to XGMII sink
  wire [ 31:0] xgmii_rx_c_mon             ; // monitor signals from XGMII source to XGMII sink
  wire [255:0] xgmii_tx_d_mon             ; // monitor signals from XGMII source to XGMII sink
  wire [ 31:0] xgmii_tx_c_mon             ; // monitor signals from XGMII source to XGMII sink
  wire [ 7:0] tx_parallel_data           ; // PRBS data from generoator for non-GMII mode
  wire [ 7:0] rx_parallel_data           ; // PRBS data from generoator for non-GMII mode
  wire        rx_datak                   ; // PRBS control for non-GMII mode
  reg         tx_datak                   ; // PRBS control for non-GMII mode
  wire        fifo_full                  ; // XGMII sink can't take anymore data
  wire        checker_pass               ; // XGMII sink data matches sent data

  reg            frame_sof_reg       = 0; // XGMII Start of Frame
  reg     [11:0] frame_length_reg    = 0; // specify the XGMII frame length
  reg     [ 3:0] frame_type_reg      = 0; // specify the XGMII frame type
  reg     [15:0] frame_ifg_reg       = 0; // specify the XGMII IPG - inter fame gap
  reg     [255:0] frame_constant_reg = {4{64'h0123_4567_89ab_cdef}}; // specify the XGMII frame data
  reg            test_done           = 0; // XGMII sink is done checking the burst of packets
  wire           rx_mismatch            ; // XGMII sink has at least one error
  reg     [ 7:0] gmii_tx_d1             ; // delay for GMII data
  reg            gmii_tx_en1            ; // enable for GMII data
  wire           test_pass              ; // GMII test pass
  reg            packet_complete_gen = 0;
  reg            packet_complete_chk = 0;
  reg            rx_mismatch_gmii    = 0;
  reg            ch_pass             = 0; // GMII or PRBS checker passes
  wire           error_flag_ch,rx_mismatch_pulse;
  //integer        frame_num           = 0;
  reg     [11:0] frame_num;
  reg     [11:0] frame_num_stp;
  wire    [11:0] match_count;
  wire    [11:0] mismatch_count;
  wire    [11:0] max_frame;
  wire    [11:0] frame_length;
  wire    [3:0]  frame_type;
  wire           xgmii_client_loopback;
  reg [255:0] xgmii_rx_d_mon_2d;
  reg [31:0]  xgmii_rx_c_mon_2d;
  reg         xgmii_am_valid_2d;
  reg         xgmii_valid_2d;
  reg [255:0] xgmii_rx_d_mon_3d;
  reg [31:0]  xgmii_rx_c_mon_3d;
  reg         xgmii_am_valid_3d;
  reg         xgmii_valid_3d;
  reg [255:0] xgmii_rx_d_mon_4d;
  reg [31:0]  xgmii_rx_c_mon_4d;
  reg         xgmii_am_valid_4d;
  reg         xgmii_valid_4d;




  //reg [13:0] FRAME_LENGTH_LIST [0:(`MAX_FRAME)] = {'d50, 'd100, 'd500, 'd1000, 'd1500, 'd80, 'd1000};
  /*reg [3:0]  FRAME_TYPE_LIST   [0:(`MAX_FRAME)] = {`FRAME_TYPE_INCREMENT,
    `FRAME_TYPE_RANDOM,
    `FRAME_TYPE_INCREMENT,
    `FRAME_TYPE_RANDOM,
    `FRAME_TYPE_RANDOM,
    `FRAME_TYPE_RANDOM,
    `FRAME_TYPE_RANDOM
     }; */

  wire       gige_sync_start ; // start sending the gige data
  reg  [3:0] dly_gige_start  ; // delay the reset before starting the gige data
  wire       reset_gige_sync, reset_1g_test; // reset sending of the gige data
  wire       start_xgmii_test, rst_xgmii_test; // start sending the XGMII data
  wire       ch0_idle_err, ch1_idle_err; // idle error signals.  XGMII != idle
  wire       idle            ; // XGMII sink is in the Idle state
  reg        ready_dly, ready_dly2;

  // synchronize the reset
  //   \p4\ip\altera_xcvr_generic\ctrl\alt_xcvr_resync.sv
  wire xgmii_rx_reset, xgmii_tx_reset;

  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
    .WIDTH     (1),
    .INIT_VALUE(1)
  ) rst_rx_sync (
    .clk  (xgmii_rx_clk      ),
    .reset(phy_mgmt_clk_reset),
    .d    (1'b0              ),
    .q    (xgmii_rx_reset    )
  );

  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
    .WIDTH     (1),
    .INIT_VALUE(1)
  ) rst_tx_sync (
    .clk  (xgmii_tx_clk      ),
    .reset(phy_mgmt_clk_reset),
    .d    (1'b0              ),
    .q    (xgmii_tx_reset    )
  );

  wire test_done_rx_sync;
  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
    .WIDTH     (1),
    .INIT_VALUE(0)
  ) test_done_sync (
    .clk  (phy_mgmt_clk      ),
    .reset(phy_mgmt_clk_reset),
    .d    (test_done         ),
    .q    (test_done_rx_sync )
  );

  reg test_done_rx_sync_r;
  always @(posedge phy_mgmt_clk) begin
    test_done_rx_sync_r <= test_done_rx_sync;
  end
  wire test_done_rx_pulse = test_done_rx_sync & ~test_done_rx_sync_r;

  reg       start_request;
  reg [9:0] slave_reg0   ; // address 0 register for reset/start bits
  always @(posedge phy_mgmt_clk) begin
    if (phy_mgmt_clk_reset | test_done_rx_pulse) begin
      start_request <= 1'b0;
    end else if (slave_reg0[0]) begin
      start_request <= 1'b1;
    end
  end

  wire start_request_tx_sync;
  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
    .WIDTH     (1),
    .INIT_VALUE(0)
  ) start_req_sync (
    .clk  (xgmii_tx_clk            ),
    .reset(1'b0                    ),
    .d    (start_request & rx_ready),
    .q    (start_request_tx_sync   )
  );

  wire tx_reset          = !start_request_tx_sync;
  wire rx_reset_raw                              ;
  wire start_first_frame                         ;
  reset_timer reset_ctrl (
    .clk   (xgmii_tx_clk     ),
    .reset (tx_reset         ),
    .start (1'b1             ),
    .pulse1(rx_reset_raw     ),
    .pulse2(start_first_frame)
  );

  wire rx_reset_sync;
  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
    .WIDTH     (1),
    .INIT_VALUE(0)
  ) rx_rst_sync (
    .clk  (xgmii_rx_clk ),
    .reset(1'b0         ),
    .d    (rx_reset_raw ),
    .q    (rx_reset_sync)
  );

  // create an edge detect to signal the beginning of rx_ready
  always @ (posedge xgmii_rx_clk or posedge xgmii_rx_reset) begin
    if (xgmii_rx_reset) begin
      ready_dly  <= 0;
      ready_dly2 <= 0;
    end else begin
      ready_dly  <= rx_ready;
      ready_dly2 <= ready_dly;
    end
  end

  wire idle_tx_sync;
  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
    .WIDTH     (1),
    .INIT_VALUE(0)
  ) idle_rx_sync (
    .clk  (xgmii_tx_clk),
    .reset(1'b0        ),
    .d    (idle        ),
    .q    (idle_tx_sync)
  );

  // create an edge detect to signal the start of XGMII sink  in Idle
  reg idle_tx_sync_r;
  always @ (posedge xgmii_tx_clk) begin
    idle_tx_sync_r <= idle_tx_sync;
  end

  // Generate test_done signal
  wire idle_pulse_tx_sync = idle_tx_sync & ~idle_tx_sync_r;
  always @ (posedge xgmii_tx_clk) begin
    if (xgmii_tx_reset) begin
      test_done <= 0;
    end else if (start_first_frame) begin
      test_done <= 0;
    //end else if (idle_pulse_tx_sync & (frame_num ==(`MAX_FRAME-1) )) begin
    end else if (idle_pulse_tx_sync & (frame_num ==(max_frame) )) begin
      test_done <= 1'b1;
    end
  end

  // get the values for the next packet in the burst from the array
  reg start_next_frame;
  always @ (posedge xgmii_tx_clk) begin
    if (!fifo_full) begin
      frame_sof_reg      <= (start_first_frame | start_next_frame);
      frame_length_reg   <= frame_length;//'d1000; //FRAME_LENGTH_LIST[frame_num];
      frame_type_reg     <= frame_type;  //FRAME_TYPE_LIST[frame_num];
      frame_constant_reg <= {4{64'h0123_4567_89ab_cdef}};
      frame_ifg_reg      <= 20;
    end
  end

  // count the frame number (packet number) in the burst of data packets
  always @ (posedge xgmii_tx_clk) begin
  if (tx_reset)
      frame_num     <= 0;
    //else if (idle_pulse_tx_sync & !fifo_full && (frame_num != (`MAX_FRAME-1)))
    else if (idle_pulse_tx_sync & !fifo_full && (frame_num != (max_frame)))
      frame_num <= frame_num + 1;
  end



  reg start_next_frame_p;
  always @ (posedge xgmii_tx_clk) begin
    if (tx_reset) begin
      start_next_frame_p <= 1'b0;
      frame_num_stp <= 0;
    end else begin
      //start_next_frame_p <= (idle_pulse_tx_sync & !fifo_full && (frame_num != `MAX_FRAME));
      start_next_frame_p <= (idle_pulse_tx_sync & !fifo_full && (frame_num != max_frame));
      frame_num_stp <= frame_num;
    end
  end

  always @ (posedge xgmii_tx_clk) begin
    if (tx_reset) begin
      start_next_frame <= 1'b0;
    end else begin
      start_next_frame <= start_next_frame_p;
    end
  end

  assign test_pass = rx_ready & checker_pass & !rx_mismatch;

  // wait a few clocks after gige_reset to start the data
  always @ (posedge tx_clkout_1g or posedge phy_mgmt_clk_reset) begin
    if (phy_mgmt_clk_reset) dly_gige_start <= 'd0;
    else                    dly_gige_start <= {reset_gige_sync, dly_gige_start[3:1]};
  end
  assign gige_sync_start = dly_gige_start[0];


  `ifdef ALTERA_RESERVED_XCVR_FULL_KR_TIMERS
  `else // not FULL_KR_TIMERS
    //initial
    //  begin
    //  //  #15us
    //    #TEST_HARNESS_TIMOUT
    //    $display("Test case failed: TIMEOUT");
    //    $finish();
    //end
  `endif // FULL_KR_TIMERS


//============================================================================
// Instantiate the XGMII gen/chk
//============================================================================
  reg [255:0] xgmii_rx_d_mon_d             ;
  reg [31:0]  xgmii_rx_c_mon_d             ;
  reg         o_rx_mii_am_valid_d          ;
  reg         o_rx_mii_valid_d          ;
  reg         i_tx_mii_ready_d          ;

  always @ (posedge xgmii_tx_clk) begin
    if (xgmii_rx_reset) begin
      xgmii_rx_d_mon_d <= 0;
      xgmii_rx_c_mon_d <= 0;
      o_rx_mii_am_valid_d <= 0;
      o_rx_mii_valid_d    <= 0;
      i_tx_mii_ready_d    <= 0;
    end
    else begin
      xgmii_rx_d_mon_d <= xgmii_rx_d_mon;
      xgmii_rx_c_mon_d <= xgmii_rx_c_mon;
      o_rx_mii_am_valid_d <= o_rx_mii_am_valid;
      o_rx_mii_valid_d    <= o_rx_mii_valid;
      i_tx_mii_ready_d    <= i_tx_mii_ready;
    end
  end

  reg   xgmii_client_loopback_00, xgmii_client_loopback_01, xgmii_client_loopback_02, xgmii_client_loopback_03;
  always @ (posedge xgmii_rx_clk) begin
      xgmii_client_loopback_00 <= xgmii_client_loopback;
      xgmii_client_loopback_01 <= xgmii_client_loopback;
      xgmii_client_loopback_02 <= xgmii_client_loopback;
      xgmii_client_loopback_03 <= xgmii_client_loopback;
  end


  wire [64*lanes-1:0] xgmii_src_txd;
  wire [8*lanes-1:0]  xgmii_src_txc;
  wire                o_tx_mii_valid_p;
  wire                o_tx_mii_am_p;
  wire                o_tx_mii_valid_0;
  wire                o_tx_mii_am_0;
  wire [8*lanes-1:0]  xgmii_tx_c_0;
  wire [128-1:0]      xgmii_tx_d_0;
  wire [128-1:0]      xgmii_tx_d_1;

  assign xgmii_tx_d_0 = xgmii_client_loopback_00 ? xgmii_rx_d_mon_4d[127:0]   : xgmii_tx_d_mon[127:0];
  assign xgmii_tx_d_1 = xgmii_client_loopback_01 ? xgmii_rx_d_mon_4d[255:128] : xgmii_tx_d_mon[255:128];
  assign xgmii_tx_c_0 = xgmii_client_loopback_02 ? xgmii_rx_c_mon_4d : xgmii_tx_c_mon;
  assign o_tx_mii_valid_0 = xgmii_client_loopback_03 ? xgmii_valid_4d : o_tx_mii_valid_p;
  assign o_tx_mii_am_0    = xgmii_client_loopback_03 ? xgmii_am_valid_4d : o_tx_mii_am_p;

  //assign xgmii_tx_d   = {xgmii_tx_d_1, xgmii_tx_d_0};
  //
    always @ (posedge xgmii_tx_clk) begin
	xgmii_tx_d   <= {xgmii_tx_d_1, xgmii_tx_d_0};
	xgmii_tx_c   <= xgmii_tx_c_0;
	o_tx_mii_valid   <= o_tx_mii_valid_0;
	o_tx_mii_am      <= o_tx_mii_am_0;
    end

  //assign xgmii_tx_d = xgmii_client_loopback ? xgmii_rx_d_mon_4d : xgmii_tx_d_mon;


  xgmii_src #(
  .ENABLE_RSFEC(ENABLE_RSFEC)
  ) tx_generator (
    // CHECK CLOCK ON START_SGMII_TEST
    .reset         (tx_reset          ),
    .frame_sof     (frame_sof_reg     ),
    .frame_length  (frame_length_reg  ),
    .frame_type    (frame_type_reg    ),
    .frame_ifg     (frame_ifg_reg     ),
    .frame_constant(frame_constant_reg),
    .frame_done    (frame_done        ),
    .xgmii_tx_clk  (xgmii_tx_clk      ),
    .xgmii_tx_d      (xgmii_src_txd    ),
    .xgmii_tx_c      (xgmii_src_txc    ),
    .xgmii_rx_clk  (xgmii_rx_clk      ),
    .xgmii_rx_d      (xgmii_rx_d       ),
    .xgmii_rx_c      (xgmii_rx_c       ),
    .xgmii_rx_d_mon	(xgmii_rx_d_mon    ),
    .xgmii_rx_c_mon	(xgmii_rx_c_mon    ),
    .xgmii_tx_d_mon	(xgmii_tx_d_mon    ),
    .xgmii_tx_c_mon	(xgmii_tx_c_mon    ),
	.o_tx_lanes_stable(o_tx_lanes_stable),
	.i_tx_mii_ready	(i_tx_mii_ready_d	),
	.o_tx_mii_valid	(o_tx_mii_valid_p	),
	.o_rx_pcs_ready	(o_rx_pcs_ready		),
	.o_tx_mii_am	(o_tx_mii_am_p		)
  ); // module xgmii_src

  xgmii_sink rx_checker (
    .tx_reset        (xgmii_tx_reset | tx_reset),
    .xgmii_tx_clk    (xgmii_tx_clk             ),
    .xgmii_rx_clk    (xgmii_rx_clk             ),
    .test_done       (test_done                ),
    .rx_reset        (~rx_ready | rx_reset_sync),
    .fifo_full       (fifo_full                ),
    .fifo_empty      (                         ),
    .read_stored_data(                         ),
    .checker_pass    (checker_pass             ),
    .rx_mismatch     (rx_mismatch              ),
    .idle_state      (idle                     ),
    .xgmii_rx_d_mon  (xgmii_rx_d_mon_d         ),
    .xgmii_rx_c_mon  (xgmii_rx_c_mon_d         ),
    .xgmii_tx_d_mon  (xgmii_tx_d_mon           ),
    .xgmii_tx_c_mon  (xgmii_tx_c_mon           ),
	.o_tx_mii_am	(o_tx_mii_am_p           ),
	.o_tx_mii_valid	(o_tx_mii_valid_p        ),
	.o_rx_mii_am_valid(o_rx_mii_am_valid_d ),
	.o_rx_mii_valid	(o_rx_mii_valid_d      ),
	.match_count	(match_count      ),
	.mismatch_count	(mismatch_count      )

  ); // module xgmii_sink

//============================================================================
// XGMII reverse parallel loopback
// Need phase-comp FIFO as TX and RX clocks are different
//============================================================================
  wire        en_rplb                                  ; // Enable
//  reg  [71:0] xgmii_a_reg = 72'h8_3c1e_0f07_8_3c1e_0f07; // input reg
//  reg  [71:0] xgmii_b_reg = 72'h8_3c1e_0f07_8_3c1e_0f07;
//  reg  [71:0] xgmii_c_reg = 72'h8_3c1e_0f07_8_3c1e_0f07;
//  reg  [ 1:0] wr_ptr                                   ; // input pointer
//  reg  [71:0] xgmii_out   = 72'h8_3c1e_0f07_8_3c1e_0f07; // output reg
//  reg  [ 1:0] rd_ptr                                   ; // output pointer
//
//  // capture the input data from the Receiver
//  always @ (posedge xgmii_rx_clk) begin
//    if (wr_ptr == 2'b00) xgmii_a_reg <= xgmii_rx_dc;
//    if (wr_ptr == 2'b01) xgmii_b_reg <= xgmii_rx_dc;
//    if (wr_ptr == 2'b10) xgmii_c_reg <= xgmii_rx_dc;
//  end
//
//  // write/input pointer
//  always @ (posedge xgmii_rx_clk or posedge xgmii_rx_reset) begin
//    if      (xgmii_rx_reset)  wr_ptr <= 2'b0;
//    else if (wr_ptr == 2'b10) wr_ptr <= 2'b0;
//    else                      wr_ptr <= wr_ptr + 1'b1;
//  end
//
//  // read/output pointer
//  always @ (posedge xgmii_tx_clk or posedge xgmii_tx_reset) begin
//    if      (xgmii_tx_reset)  rd_ptr <= 2'b01;  // start reading from diff address
//    else if (rd_ptr == 2'b10) rd_ptr <= 2'b00;
//    else                      rd_ptr <= rd_ptr + 1'b1;
//  end
//
//  // select the output data
//  always @ (posedge xgmii_tx_clk) begin
//    if      (rd_ptr == 2'b00) xgmii_out <= xgmii_a_reg;
//    else if (rd_ptr == 2'b01) xgmii_out <= xgmii_b_reg;
//    else                      xgmii_out <= xgmii_c_reg;
//  end

//  assign xgmii_tx_dc = en_rplb ? xgmii_out : xgmii_src_txdc;
//  assign xgmii_tx_dc = xgmii_src_txdc;

  always @ (posedge xgmii_tx_clk) begin
    begin
      xgmii_rx_d_mon_2d  <= xgmii_rx_d_mon_d;
      xgmii_rx_c_mon_2d  <= xgmii_rx_c_mon_d;
      xgmii_am_valid_2d  <= o_rx_mii_am_valid_d;
      xgmii_valid_2d     <= o_rx_mii_valid_d;

      xgmii_rx_d_mon_3d  <= xgmii_rx_d_mon_2d;
      xgmii_rx_c_mon_3d  <= xgmii_rx_c_mon_2d;
      xgmii_am_valid_3d  <= xgmii_am_valid_2d;
      xgmii_valid_3d     <= xgmii_valid_2d;

      xgmii_rx_d_mon_4d  <= xgmii_rx_d_mon_3d;
      xgmii_rx_c_mon_4d  <= xgmii_rx_c_mon_3d;
      xgmii_am_valid_4d  <= xgmii_am_valid_3d;
      xgmii_valid_4d     <= xgmii_valid_3d;
    end
  end



//============================================================================
// AVMM slave logic
//
// Addr-0 has all-bits as self clearing
//     bit-0 is start xgmii packets
//
// Addr-1 is RW for control
//     bit-0  is reset_hold for the channel
//
// Addr-2 is RO for xgmii status
//     bit-0 is rx_ready
//     bit-1 is checker_pass
//     bit-2 is rx_mismatch
//     bit-3 is fifo_full
//     bit-4 is test_done
//     bit-5 is frame_done
//     bit 6 is test_pass = rx_ready & checker_pass & !rx_mismatch;
//
// Addr-3 is RO for gmii status
//     bit-0 is rx_ready_gmii
//     bit-1 is led_an
//     bit-2 is packet_complete_gen
//     bit-3 is packet_complete_chk
//     bit-4 is rx_mismatch_gmii
//     bit-5 is ch_pass
//
// Addr-4 is RO for xgmii idle error counter it clears on read
// Addr-5 is RO for xgmii channel 1 idle error counter it clears on read
// Addr-6 is max_frame register
// Addr-7 is frame_length register
// Addr-8 is RO for the xgmii_data(256-bit) match count
// Addr-9 is RO for the xgmii_data(256-bit) mismatch count
// Addr-10 is the frame type. bit[2:0]: 3'b001--Constanct. 3'b010--Increment. 3'b100--Random.
// Addr-11 is the xgmii_client_loopback. 0x1: xgmii_rx loopback to xgmii_tx.
//
//============================================================================
  // address 0 register for reset/start bits; declared earlier
  reg [31:0] slave_reg1; // address 1 register for control
  reg [11:0] slave_reg6; // max_frame
  reg [11:0] slave_reg7; // frame_length
  reg [3:0]  slave_rega; // frame_type
  reg        slave_regb; // xgmii_client_loopback

  reg [1:0] clr_reg0; // clear the self_clear bit in reg 0
  reg [1:0] clr_reg4; // clear the self_clear bit in reg 4
  reg [1:0] clr_reg5; // clear the self_clear bit in reg 5

  reg [9:0] ch0_err_cnt_low, ch0_err_cnt_hi; // Idle error counter channel 0
  reg [9:0] ch1_err_cnt_low, ch1_err_cnt_hi; // Idle error counter channel 1

  always @(posedge phy_mgmt_clk or posedge phy_mgmt_clk_reset) begin
    if (phy_mgmt_clk_reset == 1'b1) begin
      slave_reg0 <= 'd0;
      slave_reg1 <= 'd0;
      slave_reg6 <= 'd200;  //200 frames
      slave_reg7 <= 'd96;   //96B per frame
      slave_rega <= 'b0010; //FRAME_TYPE_INCREMENT
      slave_regb <= 'b0;    //xgmii_client_loopback
      clr_reg0   <= 'd0;
    end else begin
      phy_mgmt_readdata <= 32'd0;
      clr_reg0          <= {1'b0, clr_reg0[1]};
      clr_reg4          <= {1'b0, clr_reg4[1]};
      clr_reg5          <= {1'b0, clr_reg5[1]};
      // clear the self_clear register bits
      if (clr_reg0[0]) slave_reg0 <= 'd0;
      // decode read & write for each supported address
      case (phy_mgmt_address)
        8'd0 : begin
          if (phy_mgmt_write) begin
            slave_reg0 <= phy_mgmt_writedata[9:0];
            clr_reg0   <= 2'b10;
          end  // if write
        end  // reg0
        8'd1 : begin
          phy_mgmt_readdata <= slave_reg1;
          if (phy_mgmt_write) slave_reg1 <= phy_mgmt_writedata;
        end // reg1
        8'd2 : begin
          phy_mgmt_readdata[0] <= rx_ready;
          phy_mgmt_readdata[1] <= checker_pass;
          phy_mgmt_readdata[2] <= rx_mismatch;
          phy_mgmt_readdata[3] <= fifo_full;
          phy_mgmt_readdata[4] <= test_done;
          phy_mgmt_readdata[5] <= frame_done;
          phy_mgmt_readdata[6] <= test_pass;
        end  // reg2
        8'd3 : begin
          phy_mgmt_readdata[0] <= rx_ready_gmii;
          phy_mgmt_readdata[1] <= led_an;
          phy_mgmt_readdata[2] <= packet_complete_gen;
          phy_mgmt_readdata[3] <= packet_complete_chk;
          phy_mgmt_readdata[4] <= rx_mismatch_gmii;
          phy_mgmt_readdata[5] <= ch_pass;
        end  // reg3
        8'd4 : begin
          phy_mgmt_readdata <= {12'd0, ch0_err_cnt_hi, ch0_err_cnt_low};
          if (phy_mgmt_read) clr_reg4   <= 2'b11;
        end  // reg4
        8'd5 : begin
          phy_mgmt_readdata <= {12'd0, ch1_err_cnt_hi, ch1_err_cnt_low};
          if (phy_mgmt_read) clr_reg5   <= 2'b11;
        end  // reg5
        8'd6 : begin
            if (phy_mgmt_write) begin
            slave_reg6 <= phy_mgmt_writedata[11:0]; //max_frame reg
            end
            phy_mgmt_readdata <= {20'd0, slave_reg6};
        end  // reg6
        8'd7 : begin
            if (phy_mgmt_write) begin
            slave_reg7 <= phy_mgmt_writedata[11:0]; //frame_length reg
            end
            phy_mgmt_readdata <= {20'd0, slave_reg7};
        end  // reg6
        8'd8 : begin
          phy_mgmt_readdata <= {20'd0, match_count};
        end  // reg6
        8'd9 : begin
          phy_mgmt_readdata <= {20'd0, mismatch_count};
        end  // reg9
        8'd10 : begin
            if (phy_mgmt_write) begin
            slave_rega <= phy_mgmt_writedata[3:0]; //frame_type reg
            end
            phy_mgmt_readdata <= {28'd0, slave_rega[3:0]};
        end  // reg10
        8'd11 : begin
            if (phy_mgmt_write) begin
            slave_regb <= phy_mgmt_writedata[0]; //xgmii_client_loopback reg
            end
            phy_mgmt_readdata <= {31'd0, slave_regb};
        end  // reg11

      endcase
    end // else
  end // always

  // generate wait request for read as always 1 clock delay for read data
  reg read_delay, read_delay1, read_delay2, read_delay3, read_delay4, read_delay5, read_delay6;
  always @(posedge phy_mgmt_clk or posedge phy_mgmt_clk_reset) begin
    if (phy_mgmt_clk_reset) begin
      read_delay  <= 0;
      read_delay1 <= 0;
      read_delay2 <= 0;
      read_delay3 <= 0;
      read_delay4 <= 0;
      read_delay5 <= 0;
      read_delay6 <= 0;
      //wait_delay <= 0;
    end
    else begin
      read_delay  <= phy_mgmt_read || phy_mgmt_write ;
      read_delay1 <= read_delay;
      read_delay2 <= read_delay1;
      read_delay3 <= read_delay2;
      read_delay4 <= read_delay3;
      read_delay5 <= read_delay4;
      read_delay6 <= read_delay5;
      //read_delay <= phy_mgmt_read & ~wait_delay;
      //wait_delay <= phy_mgmt_read & ~read_delay;
    end
  end
  assign phy_mgmt_waitrequest = (phy_mgmt_read||phy_mgmt_write) && (!read_delay6);

  // output RW bits
  assign reset_hold = slave_reg1[0];
  assign en_rplb    = slave_reg1[16];

//============================================================================
// XGMII Error counters
// count when the RX XGMII data != Idle
// clear when read via AVMM
// hold at max count of 1 million
//============================================================================

  assign ch0_idle_err = xgmii_rx_dc     != `RXDC_IDLE;
  assign ch1_idle_err = xgmii_rx_dc_ch1 != `RXDC_IDLE;

  // synchronize the control signals from the AVMM registers
  //   \p4\ip\altera_xcvr_generic\ctrl\alt_xcvr_resync.sv
  wire clr_ch0, clr_ch1;

  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
      .WIDTH        (5)  // Number of bits to resync
  ) xgmii_sync (
    .clk    (xgmii_rx_clk),
    .reset  (xgmii_rx_reset),
    .d      ({slave_regb, slave_reg0[1], slave_reg0[0] | slave_reg1[8],  clr_reg4[0], clr_reg5[0] }),
    .q      ({xgmii_client_loopback, rst_xgmii_test,start_xgmii_test,    clr_ch0,     clr_ch1     })
  );
  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
      .WIDTH        (2)  // Number of bits to resync
  ) gmii_sync (
    .clk    (tx_clkout_1g),
    .reset  (phy_mgmt_clk_reset),
    .d      ({slave_reg0[9], slave_reg0[8] | slave_reg1[8]}),
    .q      ({reset_1g_test, reset_gige_sync})
  );

  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
      .WIDTH        (12)  // Number of bits to resync
  ) max_frame_sync (
    .clk    (xgmii_rx_clk),
    .reset  (xgmii_rx_reset),
    .d      (slave_reg6[11:0]),
    .q      (max_frame)
  );
  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
      .WIDTH        (12)  // Number of bits to resync
  ) frame_length_sync (
    .clk    (xgmii_rx_clk),
    .reset  (xgmii_rx_reset),
    .d      (slave_reg7[11:0]),
    .q      (frame_length)
  );
  alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
      .WIDTH        (4)  // Number of bits to resync
  ) frame_type_sync (
    .clk    (xgmii_rx_clk),
    .reset  (xgmii_rx_reset),
    .d      (slave_rega),
    .q      (frame_type)
  );
  reg ch0_low_max, ch0_hi_max; // counters at max for channel 0
  reg ch1_low_max, ch1_hi_max; // counters at max for channel 1

  // channel 0 low
  always @(posedge xgmii_rx_clk or posedge xgmii_rx_reset) begin
    if (xgmii_rx_reset) begin
      ch0_err_cnt_low <= 'd0;
      ch0_low_max     <= 1'b0;
    end // if
    else begin
      ch0_low_max <= &ch0_err_cnt_low;
      if (clr_ch0)                           ch0_err_cnt_low <= 'd0;
      else if(&ch0_err_cnt_low & ch0_hi_max) ch0_err_cnt_low <= ch0_err_cnt_low;
      else if(ch0_idle_err)           ch0_err_cnt_low <= ch0_err_cnt_low + 1'b1;
    end // else
  end //always

  // channel 0 high
  always @(posedge xgmii_rx_clk or posedge xgmii_rx_reset) begin
    if (xgmii_rx_reset) begin
      ch0_err_cnt_hi <= 'd0;
      ch0_hi_max     <= 1'b0;
    end // if
    else begin
      ch0_hi_max <= &ch0_err_cnt_hi;
      if (clr_ch0)                            ch0_err_cnt_hi <= 'd0;
      else if (ch0_low_max & (&ch0_err_cnt_hi)) ch0_err_cnt_hi <= ch0_err_cnt_hi;
      else if (ch0_idle_err & ch0_low_max)
        ch0_err_cnt_hi <= ch0_err_cnt_hi + 1'b1;
    end // else
  end //always

  // channel 1 low
  always @(posedge xgmii_rx_clk or posedge xgmii_rx_reset) begin
    if (xgmii_rx_reset) begin
      ch1_err_cnt_low <= 'd0;
      ch1_low_max     <= 1'b0;
    end // if
    else begin
      ch1_low_max <= &ch1_err_cnt_low;
      if (clr_ch1)                           ch1_err_cnt_low <= 'd0;
      else if(&ch1_err_cnt_low & ch1_hi_max) ch1_err_cnt_low <= ch1_err_cnt_low;
      else if(ch1_idle_err)           ch1_err_cnt_low <= ch1_err_cnt_low + 1'b1;
    end // else
  end //always

  // channel 1 high
  always @(posedge xgmii_rx_clk or posedge xgmii_rx_reset) begin
    if (xgmii_rx_reset) begin
      ch1_err_cnt_hi <= 'd0;
      ch1_hi_max     <= 1'b0;
    end // if
    else begin
      ch1_hi_max <= &ch1_err_cnt_hi;
      if (clr_ch1)                            ch1_err_cnt_hi <= 'd0;
      else if (ch1_low_max & (&ch1_err_cnt_hi)) ch1_err_cnt_hi <= ch1_err_cnt_hi;
      else if (ch1_idle_err & ch1_low_max)
        ch1_err_cnt_hi <= ch1_err_cnt_hi + 1'b1;
    end // else
  end //always


//============================================================================
endmodule
