// (C) 2001-2024 Intel Corporation. All rights reserved.
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


`timescale 1 ps / 1 ps
module cpl_eth_gts_hw_ip_top #(
        parameter CLIENT_IF_TYPE         = 1,        // 0:Segmented; 1:AvST;
        parameter LANE_NUM               = 1,
        parameter DEV_BOARD              = 1,
        parameter WORDS                  = 8,
        parameter WIDTH                  = 64,
        parameter EMPTY_WIDTH            = 6,
        parameter AVMM_ADDR_WIDTH        = 16,
        parameter AVMM_ETH_START_ADDR    = 24'h00_0000,
        parameter AVMM_XCVR_START_ADDR   = 24'h80_0000,
        parameter AVMM_STATUS_START_ADDR = 24'h10_0000,
        parameter NUMPORTS               = 1,
        parameter SIM_EMULATE            = 0
    )(
        input  logic                   i_clk_sys,
        input  logic                   i_clk_ref_p,
  //      input  logic                   i_clk_ref_n,
        input logic                    i_pma_cu_clk,    //Added for SM
        input  logic                   i_reconfig_clk,
        input  logic                   i_reconfig_reset,

        output wire                    o_src_rs_req,    //added  for SM
        input wire                     i_src_rs_grant,  //added for SM
        input wire                     i_syspll_lock,   //added for SM


        input  logic                   i_clk_tx,
        input  logic                   i_clk_rx,
        output logic                   o_clk_tx_div,
        output logic                   o_clk_pll,
        output logic                   o_clk_rec_div64,
        output logic                   o_clk_rec_div,

        input  logic                   i_tx_rst_n,
        input  logic                   i_rx_rst_n,
        input  logic                   i_rst_n,
        output logic                   o_rst_ack_n,
        output logic                   o_tx_rst_ack_n,
        output logic                   o_rx_rst_ack_n,

        // IO
        input  logic [LANE_NUM-1:0]    i_rx_serial_data,
        input  logic [LANE_NUM-1:0]    i_rx_serial_data_n,
        output logic [LANE_NUM-1:0]    o_tx_serial_data,
        output logic [LANE_NUM-1:0]    o_tx_serial_data_n,
        output logic [9:0]             user_io,
        output logic [7:0]             user_led,

        // QSFP
        output logic                   qsfp_lowpwr,// LPMode
        output logic                   qsfp_rstn,  // ResetL

        //signals to probe
        output logic                    o_rx_pcs_ready,
        output logic                    o_tx_lanes_stable,
        output logic                    o_cdr_lock,
        output logic                    o_tx_pll_locked,



        // Jtag avmm bus
        input   logic   [AVMM_ADDR_WIDTH-1:0]  i_jtag_address,
        input   logic                          i_jtag_read,
        input   logic                          i_jtag_write,
        input   logic   [31:0]                 i_jtag_writedata,
        input   logic   [3:0]                  i_jtag_byteenable,
        output  logic   [31:0]                 o_jtag_readdata,
        output  logic                          o_jtag_readdatavalid,
        output  logic                          o_jtag_waitrequest
);

localparam PKT_ROM_INIT_FILE = (1 == 1 & 0 == 0) ? "../hardware_test_design/common/intel_eth_gts_hw_pkt_gen_rom_init.10G_AVST.hex"     :
                               (1 == 1 & 0 == 1) ? "../hardware_test_design/common/intel_eth_gts_hw_pkt_gen_rom_init.10G_AVST_PTP.hex" :
                               "../hardware_test_design/common/intel_eth_gts_hw_pkt_gen_rom_init.hex";

localparam PKT_ROM_INIT_DATA = "../hardware_test_design/common/init_file_data.10G.hex" ;

localparam PKT_ROM_INIT_DATA_B = "../hardware_test_design/common/init_file_data_b.hex" ;
localparam PKT_ROM_INIT_CTL = "../hardware_test_design/common/init_file_ctrl.10G.hex";

//---Less entries for higher speed which has larger data width;
localparam LPBK_FIFO_ADDR_WIDTH = ("10G" == "10G")  ? 10 :
                                  ("10G" == "25G")  ? 10 : 8;

`ifdef ALTERA_RESERVED_QIS
localparam AM_INS_PERIOD        = ("10G" == "25G")  ? 81920 : 40960;
`else
localparam AM_INS_PERIOD        = ("10G" == "25G")  ? 1280 : 1280;

`endif


localparam AM_INS_CYC         =   ("10G" == "25G") ? 4 : 4;

localparam FEC_TYPE         = 0;
localparam ERATE         = "10G";
//---------------------------------------------------------------

//Temp for warning clean up
assign user_io='0;
assign user_led='0;
assign qsfp_lowpwr='0;

    assign qsfp_rstn='0;

//---------------------------------------------------------------

// [0] = ETH, [1] = Status
localparam  SLAVE_NUM               = 2;
localparam  AVMM_ETH_END_ADDR       = 24'h0C_FFFC; //Need to modify
localparam  AVMM_STATUS_END_ADDR    = 24'hFF_FFFC; //Need to modify

logic   [23:0]       slave_addr;
logic   [31:0]                      slave_writedata;
logic   [3:0]                       slave_byteenable;
logic   [SLAVE_NUM-1:0]             slave_read;
logic   [SLAVE_NUM-1:0]             slave_write;
logic   [SLAVE_NUM*32-1:0]          slave_readdata;
logic   [SLAVE_NUM-1:0]             slave_readdatavalid;
logic   [SLAVE_NUM-1:0]             slave_waitrequest;

//---------------------------------------------------------------


    // TX AVST INTERFACE
    wire  [64*1-1:0]    i_tx_data;
    wire                          i_tx_valid;
    wire                          i_tx_startofpacket;
    wire                          i_tx_endofpacket;
    wire                          o_tx_ready;

    wire  [3-1:0]       i_tx_empty;
    wire                          i_tx_error;
    wire                          i_tx_skip_crc;

    // RX AVST INTERFACE
    wire    [64*1-1:0]  o_rx_data;
    wire                          o_rx_valid;
    wire                          o_rx_startofpacket;
    wire                          o_rx_endofpacket;
    wire    [3-1:0]     o_rx_empty;
    wire    [6-1:0]               o_rx_error;
    wire    [39:0]                o_rxstatus_data;
    wire                          o_rxstatus_valid;



//---------------------------------------------------------------
//---------------------------------------------------------------

    localparam PKT_CYL = 1;
    localparam PTP_FP_WIDTH = 8;
//---------------------------------------------------------------
    //Flow control Interface
    wire                         i_tx_pause = 1'b0;
    wire    [7:0]                i_tx_pfc   = 8'd0;
    wire                         o_rx_pause;
    wire    [7:0]                o_rx_pfc;

    //Status signals
    wire                         i_stats_snapshot            = 1'b0;
    wire                         o_rx_hi_ber;
    wire                         o_rx_block_lock;
    wire                         o_rx_am_lock;

    wire                         o_local_fault_status;
    wire                         o_remote_fault_status;

    wire              o_sys_pll_locked;


//---------------------------------------------------------------
ex_10G dut (
    .i_clk_rx                         (i_clk_rx),
    .i_clk_tx                         (i_clk_tx),
    .o_clk_pll                        (o_clk_pll),
    .o_clk_tx_div                     (o_clk_tx_div                  ),
    .o_clk_rec_div64                  (o_clk_rec_div64),
    .o_clk_rec_div                    (o_clk_rec_div                 ),
    .i_rx_rst_n                       (i_rx_rst_n),
    .i_tx_rst_n                       (i_tx_rst_n),
    .i_rst_n                          (i_rst_n                       ),
    .o_rst_ack_n                      (o_rst_ack_n                   ),
    .o_rx_rst_ack_n                   (o_rx_rst_ack_n                ),
    .o_tx_rst_ack_n                   (o_tx_rst_ack_n                ),
    .i_reconfig_clk                   (i_reconfig_clk),
    .i_reconfig_reset                 (i_reconfig_reset),
    .o_cdr_lock                       (o_cdr_lock                    ),
    .o_tx_pll_locked                  (o_tx_pll_locked               ),
    .o_tx_lanes_stable                (o_tx_lanes_stable             ),
    .o_sys_pll_locked                 (o_sys_pll_locked              ),
    .i_syspll_lock                        (i_syspll_lock                 ),
    .i_pma_cu_clk                            (i_pma_cu_clk                       ),
    .o_src_rs_req                          (o_src_rs_req                     ),
    .i_src_rs_grant                      (i_src_rs_grant                     ),
    .o_rx_pcs_ready                   (o_rx_pcs_ready                ),
    .i_reconfig_eth_addr              (slave_addr[19:2]              ),
    .i_reconfig_eth_byteenable        (slave_byteenable              ),
    .o_reconfig_eth_readdata_valid    (slave_readdatavalid[0]          ),
    .i_reconfig_eth_read              (slave_read[0]             ),
    .i_reconfig_eth_write             (slave_write[0]             ),
    .o_reconfig_eth_readdata          (slave_readdata[31:0]          ),
    .i_reconfig_eth_writedata         (slave_writedata             ),
    .o_reconfig_eth_waitrequest       (slave_waitrequest[0]         ),
    .o_rx_block_lock                  (o_rx_block_lock       ),
    .o_rx_am_lock                     (o_rx_am_lock          ),
    .o_local_fault_status             (o_local_fault_status  ),
    .o_remote_fault_status            (o_remote_fault_status ),
    .o_rx_hi_ber                      (o_rx_hi_ber           ),
    .o_rx_pcs_fully_aligned           (o_rx_pcs_fully_aligned),

    .i_clk_sys                        (i_clk_sys),  //Need to connect with sys_pll IP
    .i_clk_ref_p                        (i_clk_ref_p),
 //   .i_clk_ref_n                        (i_clk_ref_n),
    .i_rx_serial_data                      (i_rx_serial_data  ),
    .i_rx_serial_data_n                    (i_rx_serial_data_n),
    .o_tx_serial_data                      (o_tx_serial_data  ),
    .o_tx_serial_data_n                    (o_tx_serial_data_n),
    .i_tx_data                        (i_tx_data),
    .i_tx_valid                       (i_tx_valid),
    .i_tx_startofpacket               (i_tx_startofpacket),
    .i_tx_endofpacket                 (i_tx_endofpacket),
    .i_tx_error                       (i_tx_error                    ),
    .o_tx_ready                       (o_tx_ready),
    .i_tx_empty                       (i_tx_empty),
    .i_tx_skip_crc                    (i_tx_skip_crc),
    .o_rx_data                        (o_rx_data),
    .o_rx_valid                       (o_rx_valid),
    .o_rx_startofpacket               (o_rx_startofpacket),
    .o_rx_endofpacket                 (o_rx_endofpacket),
    .o_rx_empty                       (o_rx_empty),
    .o_rx_error                       (o_rx_error),
    .o_rxstatus_valid                 (o_rxstatus_valid),
    .o_rxstatus_data                  (o_rxstatus_data),

    .i_stats_snapshot                 (i_stats_snapshot)
);

//---------------------------------------------------------------


// removing this JTAG decoder , only one slave here - CPL ETH TG
/*
intel_eth_gts_hw_avmm_decoder ip_avmm_decoder (
  .clk                      (i_reconfig_clk         ),
  .rst                      (i_reconfig_reset       ),

  //---avmm master from Jtag---
  .master_addr             (i_jtag_address          ),
  .master_read             (i_jtag_read             ),
  .master_write            (i_jtag_write            ),
  .master_writedata        (i_jtag_writedata        ),
  .master_byteenable       (i_jtag_byteenable       ),
  .master_readdata         (o_jtag_readdata         ),
  .master_readdatavalid    (o_jtag_readdatavalid    ),
  .master_waitrequest      (o_jtag_waitrequest      ),

  //---avmm slave IF to HW IP---
  .slave_addr              (slave_addr          ),
  .slave_read              (slave_read          ),
  .slave_write             (slave_write         ),
  .slave_writedata         (slave_writedata     ),
  .slave_byteenable        (slave_byteenable    ),
  .slave_readdata          (slave_readdata      ),
  .slave_readdatavalid     (slave_readdatavalid ),
  .slave_waitrequest       (slave_waitrequest   ),

  //---Ctrl IF---
  .slave_start_addr        ({AVMM_STATUS_START_ADDR, AVMM_ETH_START_ADDR}),
  .slave_end_addr          ({AVMM_STATUS_END_ADDR, AVMM_ETH_END_ADDR})
);

defparam    ip_avmm_decoder.SLAVE_NUM     = SLAVE_NUM;
defparam    ip_avmm_decoder.ADDR_WIDTH    = AVMM_ADDR_WIDTH;

//---------------------------------------------------------------
*/
logic tx_pll_locked_reconfig_sync;
logic cdr_lock_reconfig_sync;
logic rst_n_reconfig_sync;
logic pkt_client_rst_n;

intel_eth_gts_altera_std_synchronizer_nocut tx_pll_locked_reconfig_sync_inst (
    .clk        (i_reconfig_clk),
    .reset_n    (1'b1),
    .din        (o_tx_pll_locked),
    .dout       (tx_pll_locked_reconfig_sync)
);

intel_eth_gts_altera_std_synchronizer_nocut cdr_lock_reconfig_sync_inst (
    .clk        (i_reconfig_clk),
    .reset_n    (1'b1),
    .din        (o_cdr_lock),
    .dout       (cdr_lock_reconfig_sync)
);

intel_eth_gts_altera_std_synchronizer_nocut i_rst_reconfig_sync_inst (
    .clk        (i_reconfig_clk),
    .reset_n    (1'b1),
    .din        (i_rst_n),
    .dout       (rst_n_reconfig_sync)
);

always @(posedge i_reconfig_clk) begin
      pkt_client_rst_n <= tx_pll_locked_reconfig_sync & rst_n_reconfig_sync;
end

intel_eth_gts_altera_std_synchronizer_nocut pkt_client_rst_n_sync_inst (
    .clk        (i_clk_tx),
    .reset_n    (1'b1),
    .din        (pkt_client_rst_n),
    .dout       (pkt_client_rst_n_sync)
);

// CPL ETH TG
    localparam AVMM_ADDRW = 23;
    localparam AVMM_DATAW = 32;

    logic [AVMM_ADDRW-1:0] avalon_master_address;
    logic                        avalon_master_read;
    logic                        avalon_master_write;
    logic                        avalon_master_readdatavalid;
    logic                        avalon_master_waitrequest;
    logic [AVMM_DATAW-1:0] avalon_master_writedata;
    logic [AVMM_DATAW-1:0] avalon_master_readdata;

    //assign avalon_master_address = slave_addr[22:0];
    //assign avalon_master_read = slave_read[1];
    //assign avalon_master_write = slave_write[1];
    //assign avalon_master_writedata = slave_writedata;
    //assign slave_readdata[63:32] = avalon_master_readdata;
    //assign slave_readdatavalid[1] = avalon_master_readdatavalid;
    //assign slave_waitrequest[1] = avalon_master_waitrequest;

    // Connecting JTAG to CPL ETH TG
    assign avalon_master_address = i_jtag_address;
    assign avalon_master_read = i_jtag_read;
    assign avalon_master_write = i_jtag_write;
    assign avalon_master_writedata = i_jtag_writedata;
    assign o_jtag_readdata = avalon_master_readdata;
    assign o_jtag_readdatavalid = avalon_master_readdatavalid;
    assign o_jtag_waitrequest = avalon_master_waitrequest;

    // Connecting CPL ETH TG to Address decoder
    //assign avalon_master_address = slave_addr[22:0];
    //assign avalon_master_read = slave_read[1];
    //assign avalon_master_write = slave_write[1];
    //assign avalon_master_writedata = slave_writedata;
    //assign slave_readdata[63:32] = avalon_master_readdata;
    //assign slave_readdatavalid[1] = avalon_master_readdatavalid;
    //assign slave_waitrequest[1] = avalon_master_waitrequest;

    // AVST RX
    wire eth_rx_cmac_avl_sop_0 = o_rx_startofpacket;
    wire eth_rx_cmac_avl_valid_0 = o_rx_valid;
    wire eth_rx_cmac_avl_eop_0 = o_rx_endofpacket;
    wire [63:0] eth_rx_cmac_avl_data_0 = o_rx_data;
    wire [2:0] eth_rx_cmac_avl_empty_0 = o_rx_empty;

    // AVST TX
    wire eth_tx_cmac_avl_sop_0;
    wire eth_tx_cmac_avl_valid_0;
    wire eth_tx_cmac_avl_eop_0;
    wire [63:0] eth_tx_cmac_avl_data_0;
    wire [2:0] eth_tx_cmac_avl_empty_0;
    wire eth_tx_cmac_avl_err_0;
    wire eth_tx_cmac_avl_rdy_0 = o_tx_ready;
    assign i_tx_startofpacket = eth_tx_cmac_avl_sop_0;
    assign i_tx_valid = eth_tx_cmac_avl_valid_0;
    assign i_tx_endofpacket = eth_tx_cmac_avl_eop_0;
    assign i_tx_data = eth_tx_cmac_avl_data_0;
    assign i_tx_empty = eth_tx_cmac_avl_empty_0;
    assign i_tx_error = eth_tx_cmac_avl_err_0;
    assign i_tx_skip_crc =1'b0;

    // TO DO
    // handle the dangling signals to and from ETH TG and ETH10G IP



cpl_eth_subsys_cpl_eth_tg_0 #(
		.AVMM_ADDRW        (AVMM_ADDRW),
		.AVMM_DATAW        (AVMM_DATAW)
) cpl_eth_tg_u0 (
		.clk                         (i_reconfig_clk),                         //   input,                          width = 1,              clock.clk
		.reset_n                     (~i_reconfig_reset),                     //   input,                          width = 1,            reset_n.reset_n
		.avalon_master_address       (avalon_master_address),       //   input,                         width = 16,       eth_avmm_cfg.address
		.avalon_master_read          (avalon_master_read),          //   input,                          width = 1,                   .read
		.avalon_master_write         (avalon_master_write),         //   input,                          width = 1,                   .write
		.avalon_master_readdatavalid (avalon_master_readdatavalid), //  output,                          width = 1,                   .readdatavalid
		.avalon_master_waitrequest   (avalon_master_waitrequest),   //  output,                          width = 1,                   .waitrequest
		.avalon_master_writedata     (avalon_master_writedata),     //   input,     width = (((AVMM_DATAW-1)-0)+1),                   .writedata
		.avalon_master_readdata      (avalon_master_readdata),      //  output,     width = (((AVMM_DATAW-1)-0)+1),                   .readdata
		.eth_rx_cmac_avl_clk_0       (i_clk_rx),       //   input,                          width = 1,    eth_rx_cmac_clk.clk
		.eth_rx_cmac_avl_sop_0       (eth_rx_cmac_avl_sop_0),       //   input,                          width = 1, eth_rx_cmac_avst_0.startofpacket
		.eth_rx_cmac_avl_valid_0     (eth_rx_cmac_avl_valid_0),     //   input,                          width = 1,                   .valid
		.eth_rx_cmac_avl_eop_0       (eth_rx_cmac_avl_eop_0),       //   input,                          width = 1,                   .endofpacket
		.eth_rx_cmac_avl_data_0      (eth_rx_cmac_avl_data_0),      //   input,                          width = 8,                   .data
		.eth_rx_cmac_avl_empty_0     (eth_rx_cmac_avl_empty_0),     //   input,                          width = 1,                   .empty
		.eth_tx_cmac_avl_clk_0       (i_clk_tx),       //   input,                          width = 1,    eth_tx_cmac_clk.clk
		.eth_tx_cmac_avl_rdy_0       (eth_tx_cmac_avl_rdy_0),       //   input,                          width = 1, eth_tx_cmac_avst_0.ready
		.eth_tx_cmac_avl_sop_0       (eth_tx_cmac_avl_sop_0),       //  output,                          width = 1,                   .startofpacket
		.eth_tx_cmac_avl_valid_0     (eth_tx_cmac_avl_valid_0),     //  output,                          width = 1,                   .valid
		.eth_tx_cmac_avl_eop_0       (eth_tx_cmac_avl_eop_0),       //  output,                          width = 1,                   .endofpacket
		.eth_tx_cmac_avl_data_0      (eth_tx_cmac_avl_data_0),      //  output,  width = (((ETH_PKT_WIDTH-1)-0)+1),                   .data
		.eth_tx_cmac_avl_empty_0     (eth_tx_cmac_avl_empty_0),     //  output,  width = (((ETH_EOP_WIDTH-1)-0)+1),                   .empty
		.eth_tx_cmac_avl_err_0       (eth_tx_cmac_avl_err_0),       //  output,                          width = 1,                   .error
		.e_tile_txrx_status          (e_tile_txrx_status)           //  output,                         width = 32,  etile_txrx_status.conduit
	);

// Replacing this IP with CPL ETH TG
/*
intel_eth_gts_packet_client_top packet_client_top (
        .i_arst                       (!pkt_client_rst_n_sync),
        .i_clk_rx                     (i_clk_rx),
        .i_clk_tx                     (i_clk_tx),
        .i_clk_pll                      (o_clk_pll),
        .i_clk_status                 (i_reconfig_clk),
        .i_clk_status_rst             (i_reconfig_reset),

        .i_tx_ready                   (o_tx_ready),
        .o_tx_valid                   (i_tx_valid),
        .o_tx_sop                     (i_tx_startofpacket),
        .o_tx_eop                     (i_tx_endofpacket),
        .o_tx_empty                   (i_tx_empty),
        .o_tx_data                    (i_tx_data),
        .o_tx_error                   (i_tx_error),
        .o_tx_skip_crc                (i_tx_skip_crc),

        .i_rx_valid                   (o_rx_valid),
        .i_rx_sop                     (o_rx_startofpacket),
        .i_rx_eop                     (o_rx_endofpacket),
        .i_rx_empty                   (o_rx_empty),
        .i_rx_data                    (o_rx_data),
        .i_rx_error                   (o_rx_error),
        .i_rxstatus_valid             (o_rxstatus_valid),
        .i_rxstatus_data              (o_rxstatus_data),


        .i_status_addr                (slave_addr[22:0]),
        .i_status_read                (slave_read[1]),
        .i_status_write               (slave_write[1]),
        .i_status_writedata           (slave_writedata),
        .o_status_readdata            (slave_readdata[63:32]),
        .o_status_readdata_valid      (slave_readdatavalid[1]),
        .o_status_waitrequest         (slave_waitrequest[1])
   );
*/

/*
reg sys_pll_lock_inv;
//wire o_sys_pll_locked_r;
//reg clkdiv2_pll_lock_reg1;


//assign sys_pll_lock_inv = !o_sys_pll_locked;
always @ (posedge o_clk_pll) begin:REGISTER_SYS_PLL_LOCK
  sys_pll_lock_inv <= !o_sys_pll_locked;
end
*/

// Commenting because removed their TG :
//defparam    packet_client_top.ENABLE_PTP           = 0;
//defparam    packet_client_top.PKT_CYL              = PKT_CYL;
//defparam    packet_client_top.PTP_FP_WIDTH         = PTP_FP_WIDTH;
//defparam    packet_client_top.CLIENT_IF_TYPE       = CLIENT_IF_TYPE;
//defparam    packet_client_top.READY_LATENCY        = 0;
//defparam    packet_client_top.WORDS                = 1;
//defparam    packet_client_top.EMPTY_WIDTH          = 3;
//defparam    packet_client_top.LPBK_FIFO_ADDR_WIDTH = LPBK_FIFO_ADDR_WIDTH;
//defparam    packet_client_top.PKT_ROM_INIT_FILE    = PKT_ROM_INIT_FILE;


//---------------------------------------------------------------
//---------------------------------------------------------------

//---------------------------------------------------------------
endmodule
