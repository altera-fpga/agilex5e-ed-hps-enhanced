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
`define ALTERA_RESERVED_QIS
module cpl_eth_gts_hw # (
    parameter INSTANCE_NUM = 1,
    parameter EHIP_RATE = "10G",
    parameter AVMM_ADDR_WIDTH = 16,
    parameter AVMM_DATA_WIDTH = 32,
    parameter AXI4L_ADDR_WIDTH = 16,
    parameter AXI4L_DATA_WIDTH = 32,
    parameter AXI4L_RRESP_WIDTH = 2,
    parameter AXI4L_WSTRB_WIDTH = 4,
    parameter AXI4L_BRESP_WIDTH = 2
) (
// ---- Ports for IP_TC = 0 begin
        input  wire                  i_refclk2pll_p,

// ---- AXI4Lite CFG input

// AXI4L slave cfg input
    input  wire [AXI4L_ADDR_WIDTH-1:0] axi_slave_araddr,
    input  wire                        axi_slave_arvalid,
    output wire                        axi_slave_arready,
    input  wire [AXI4L_ADDR_WIDTH-1:0] axi_slave_awaddr,
    input  wire                        axi_slave_awvalid,
    output wire                        axi_slave_awready,
    output wire [AXI4L_DATA_WIDTH-1:0] axi_slave_rdata,
    output wire [AXI4L_RRESP_WIDTH-1:0]  axi_slave_rresp,
    output wire                        axi_slave_rvalid,
    input  wire                        axi_slave_rready,
    input  wire [AXI4L_DATA_WIDTH-1:0] axi_slave_wdata,
    input  wire                        axi_slave_wvalid,
    output wire                        axi_slave_wready,
    input  wire [AXI4L_WSTRB_WIDTH-1:0]  axi_slave_wstrb,
    output wire [AXI4L_BRESP_WIDTH-1:0]  axi_slave_bresp,
    output wire                        axi_slave_bvalid,
    input  wire                        axi_slave_bready,

// ----
`ifndef ALTERA_RESERVED_QIS // The code that is not used for Quartus Synthesis
        input  wire                  i_reconfig_reset,
        input  wire                  cpu_resetn,

        input  wire [INSTANCE_NUM-1:0]  i_rst_n,
        input  wire [INSTANCE_NUM-1:0]  i_tx_rst_n,
        input  wire [INSTANCE_NUM-1:0]  i_rx_rst_n,
        output wire [INSTANCE_NUM-1:0]  o_rst_ack_n,
        output wire [INSTANCE_NUM-1:0]  o_tx_rst_ack_n,
        output wire [INSTANCE_NUM-1:0]  o_rx_rst_ack_n,
`endif
	input wire		     i_clk_ref_p,	//added new for SM
//	input wire		     i_clk_ref_n,	//Added new for SM

	input  wire                  i_reconfig_clk,
        output wire                  o_reconfig_reset_new,
	//input  wire                  clk50,
        //---IO---
        input  wire [INSTANCE_NUM*1-1:0]  i_rx_serial_data,
        input  wire [INSTANCE_NUM*1-1:0]  i_rx_serial_data_n,
        output wire [INSTANCE_NUM*1-1:0]  o_tx_serial_data,
        output wire [INSTANCE_NUM*1-1:0]  o_tx_serial_data_n
		  // output wire [9:0]            user_io,
       // output wire [7:0]            user_led,

	//workaround for bcm

        //---QSFP---
       // output wire                  qsfp_lowpwr,   // LPMode
       // output wire                  qsfp_rstn      // ResetL
);

//---------------------------------------------------------------
// Clocks
//---------------------------------------------------------------
    wire [INSTANCE_NUM-1:0] o_clk_pll;
    wire [INSTANCE_NUM-1:0] o_clk_tx_div;
    wire [INSTANCE_NUM-1:0] o_clk_rec_div64;
    wire [INSTANCE_NUM-1:0] o_clk_rec_div;

    // Clock assignment for TEST_SIP=0
    wire [INSTANCE_NUM-1:0] i_clk_tx;
    wire [INSTANCE_NUM-1:0] i_clk_rx;


wire [13:0]     i_kr_reconfig_addr;
wire            i_kr_reconfig_read;
wire            i_kr_reconfig_write;
wire [3:0]      i_kr_reconfig_byte_en;
wire [31:0]     i_kr_reconfig_writedata;
wire [31:0]     o_kr_reconfig_readdata;
wire            o_kr_reconfig_readdata_valid;
wire            o_kr_reconfig_waitrequest;

    genvar inst_i;
    generate
        for (inst_i = 0; inst_i < INSTANCE_NUM; inst_i = inst_i + 1) begin: clks
            assign i_clk_rx     [inst_i] = o_clk_pll[inst_i];
            assign i_clk_tx     [inst_i] = o_clk_pll[inst_i];

        end
    endgenerate

//---------------------------------------------------------------
// jtag_avalon and avmm_decoder
//---------------------------------------------------------------
wire     [31:0]               master_address;
wire                          master_read;
wire                          master_write;
wire     [31:0]               master_writedata;
wire     [3:0]                master_byteenable;
wire     [31:0]               master_readdata;
wire                          master_readdatavalid;
wire                          master_waitrequest;
// ETH_F AVMM signals
wire   [INSTANCE_NUM*24-1:0]  reconfig_hw_ip_addr;
wire   [INSTANCE_NUM-1:0]     reconfig_hw_ip_read;
wire   [INSTANCE_NUM-1:0]     reconfig_hw_ip_write;
wire   [INSTANCE_NUM*32-1:0]  reconfig_hw_ip_writedata;
wire   [INSTANCE_NUM*4-1:0]   reconfig_hw_ip_byteenable;
wire   [INSTANCE_NUM*32-1:0]  reconfig_hw_ip_readdata;
wire   [INSTANCE_NUM-1:0]     reconfig_hw_ip_readdata_valid;
wire   [INSTANCE_NUM-1:0]     reconfig_hw_ip_waitrequest;
// PTP_MASTER_TOD AVMM signals
wire                          ptp_master_tod_csr_read;
wire                          ptp_master_tod_csr_write;
wire                          ptp_master_tod_csr_waitrequest;
wire    [31:0]                ptp_master_tod_csr_writedata;
wire    [31:0]                ptp_master_tod_csr_readdata;
wire    [5:0]                 ptp_master_tod_csr_addr;
wire                          ptp_master_tod_csr_readdata_valid;


//---------------------------------------------------------------
// JTAG master from AXI4lite to AVMM bridge
//---------------------------------------------------------------
wire [AVMM_ADDR_WIDTH-1:0]  avalon_master_address;
wire                        avalon_master_read;
wire                        avalon_master_write;
wire                        avalon_master_readdatavalid;
wire                        avalon_master_waitrequest;
wire [AVMM_DATA_WIDTH-1:0]  avalon_master_writedata;
wire [AVMM_DATA_WIDTH-1:0]  avalon_master_readdata;



wire [INSTANCE_NUM-1:0] rst_n;
wire [INSTANCE_NUM-1:0] tx_rst_n;
wire [INSTANCE_NUM-1:0] rx_rst_n;
wire                    reconfig_reset;
wire [INSTANCE_NUM-1:0] tx_lanes_stable;
wire [INSTANCE_NUM-1:0] rx_pcs_ready;
wire [INSTANCE_NUM-1:0] cdr_lock;
wire [INSTANCE_NUM-1:0] tx_pll_locked;
wire [9:0]            user_io;
wire [7:0]            user_led;

wire reconfig_reset_sync;

intel_eth_gts_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH(3),
    .WIDTH(1),
    .INIT_VALUE(1)
) sync_reconfig_reset (
    .clk    (i_reconfig_clk),
    .reset  (1'b0),
    .d  (reconfig_reset),
    .q  (reconfig_reset_sync)
);

`ifdef ALTERA_RESERVED_QIS // The code that is used for Quartus Synthesis
    wire source_rst_n;
    wire source_rst_n_sync;
    wire source_tx_rst_n;
    wire source_rx_rst_n;
    wire source_reconfig_reset;
    wire ninit_done;
    wire ninit_done_sync;
    reg  arst;

    intel_eth_gts_reset_synchronizer source_rst_sync (
        .clk            (i_reconfig_clk),
        .aclr           (source_rst_n),
        .aclr_sync      (source_rst_n_sync)
    );
    intel_eth_gts_reset_synchronizer ninit_done_rst_sync (
        .clk            (i_reconfig_clk),
        .aclr           (ninit_done),
        .aclr_sync      (ninit_done_sync)
    );

    always @(posedge i_reconfig_clk) begin
          //arst     <= ~(~source_rst_n_sync | ninit_done_sync);
        arst     <= ~(~source_rst_n_sync);
    end


    wire                  i_reconfig_reset;
    wire                  cpu_resetn;

    wire [INSTANCE_NUM-1:0]  i_rst_n;
    wire [INSTANCE_NUM-1:0]  i_tx_rst_n;
    wire [INSTANCE_NUM-1:0]  i_rx_rst_n;
    wire [INSTANCE_NUM-1:0] o_rx_rst_ack_n;
    wire [INSTANCE_NUM-1:0] o_tx_rst_ack_n;
    wire [INSTANCE_NUM-1:0] o_rst_ack_n;

    genvar i;
    generate
        for (i = 0;i < INSTANCE_NUM; i= i + 1) begin: resets
            //assign rst_n[i]     = arst;
            assign rst_n[i]     = source_rst_n;
            assign tx_rst_n[i]  = source_tx_rst_n;
            assign rx_rst_n[i]  = source_rx_rst_n;
        end
    endgenerate

    //assign reconfig_reset = (source_reconfig_reset | ninit_done_sync);
    assign reconfig_reset = (source_reconfig_reset);


    wire [7:0] system_status;
    assign system_status[0] = arst;
    assign system_status[1] = &rx_pcs_ready;
    assign system_status[2] = &tx_lanes_stable;
    assign system_status[3] = &tx_pll_locked;
    assign system_status[4] = &cdr_lock;
    assign system_status[5] = |o_rx_rst_ack_n;
    assign system_status[6] = |o_tx_rst_ack_n;
    assign system_status[7] = |o_rst_ack_n;
    probe8 prb (
        .source  ({source_rst_n, source_tx_rst_n, source_rx_rst_n, source_reconfig_reset}),
        .probe   (system_status)
    );
    reset_ip reset (
        .ninit_done (ninit_done)
    );




reg tx_lanes_stable_all;

always @ (posedge i_clk_tx[0]) begin
tx_lanes_stable_all <= &tx_lanes_stable;
end

// always @ (posedge i_clk_tx) begin
//     tx_lanes_stable_all <= &tx_lanes_stable;
// end

wire  tx_lanes_stable_all_sync;

intel_eth_gts_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH(3),
    .WIDTH(1),
    .INIT_VALUE(1)
) sync_tx_lanes_stable_all (
    .clk    (i_reconfig_clk),
    .reset  (1'b0),
    .d  (tx_lanes_stable_all),
    .q  (tx_lanes_stable_all_sync)
);

reg reset_till_lanes_stable;

 always @ (posedge i_reconfig_clk) begin
		if(ninit_done_sync)
			reset_till_lanes_stable <= 1;
		else if(tx_lanes_stable_all_sync)
			reset_till_lanes_stable <= 0;
 end

assign reconfig_reset_new = (reconfig_reset_sync | reset_till_lanes_stable);
assign o_reconfig_reset_new = reconfig_reset_new;
// Replacing this JTAG master with AXI4Lite to AVMM bridge
//commented jtag Avalon temp till SM  support this IP
/*intel_eth_gts_jtag_avalon jtag_master (
        .clk_clk                  (i_reconfig_clk),
        //.clk_reset_reset          (reconfig_reset_sync),
        .clk_reset_reset          (reconfig_reset_new),
        .master_address           (master_address),
        .master_read              (master_read),
        .master_write             (master_write),
        .master_writedata         (master_writedata),
        .master_byteenable        (master_byteenable),
        .master_readdata          (master_readdata),
        .master_readdatavalid     (master_readdatavalid),
        .master_waitrequest       (master_waitrequest),
        .master_reset_reset       ()
);
*/
    axi2avmmbridge #(
	    .AVMM_ADDR_WIDTH   (AVMM_ADDR_WIDTH),
	    .AVMM_DATA_WIDTH   (AVMM_DATA_WIDTH),
	    .AXI4L_ADDR_WIDTH  (AXI4L_ADDR_WIDTH),
	    .AXI4L_DATA_WIDTH  (AXI4L_DATA_WIDTH),
	    .AXI4L_RRESP_WIDTH (AXI4L_RRESP_WIDTH),
	    .AXI4L_WSTRB_WIDTH (AXI4L_WSTRB_WIDTH),
	    .AXI4L_BRESP_WIDTH (AXI4L_BRESP_WIDTH)
    ) axi_2_avmmbridge_inst (
	    .clk                         (i_reconfig_clk),
	    .rst_n                       (~reconfig_reset_new),

	    .axi_slave_araddr            (axi_slave_araddr),
	    .axi_slave_arvalid           (axi_slave_arvalid),
	    .axi_slave_arready           (axi_slave_arready),
	    .axi_slave_awaddr            (axi_slave_awaddr),
	    .axi_slave_awvalid           (axi_slave_awvalid),
	    .axi_slave_awready           (axi_slave_awready),
	    .axi_slave_rdata             (axi_slave_rdata),
	    .axi_slave_rresp             (axi_slave_rresp),
	    .axi_slave_rvalid            (axi_slave_rvalid),
	    .axi_slave_rready            (axi_slave_rready),
	    .axi_slave_wdata             (axi_slave_wdata),
	    .axi_slave_wvalid            (axi_slave_wvalid),
	    .axi_slave_wready            (axi_slave_wready),
	    .axi_slave_wstrb             (axi_slave_wstrb),
	    .axi_slave_bresp             (axi_slave_bresp),
	    .axi_slave_bvalid            (axi_slave_bvalid),
	    .axi_slave_bready            (axi_slave_bready),

	    .avalon_master_address       (avalon_master_address),
	    .avalon_master_read          (avalon_master_read),
	    .avalon_master_write         (avalon_master_write),
	    .avalon_master_readdatavalid (avalon_master_readdatavalid),
	    .avalon_master_waitrequest   (avalon_master_waitrequest),
	    .avalon_master_writedata     (avalon_master_writedata),
	    .avalon_master_readdata      (avalon_master_readdata)
    );


`else // The code that is used for other software
    assign rst_n             = i_rst_n;
    assign tx_rst_n          = i_tx_rst_n;
    assign rx_rst_n          = i_rx_rst_n;
    assign reconfig_reset    = i_reconfig_reset;
    assign reconfig_reset_new = i_reconfig_reset;


`endif



// PTP is disabled, driving PTP AVMM signals to 0
assign ptp_master_tod_csr_readdata          = 32'h0;
assign ptp_master_tod_csr_readdata_valid    = 1'b0;
assign ptp_master_tod_csr_waitrequest       = 1'b0;

assign o_kr_reconfig_readdata = 32'd0;
assign o_kr_reconfig_readdata_valid = 1'b0;
assign o_kr_reconfig_waitrequest = 1'b0;



//---------------------------------------------------------------
wire [2:0] i_pma_cu_clk;
wire  [INSTANCE_NUM-1:0] i_src_rs_grant;
wire [INSTANCE_NUM-1:0] o_src_rs_req;

wire i_clk_sys;
reg i_clk_ref = 1'b0;
//  always begin
//         #3200 i_clk_ref = ~i_clk_ref;
//    end

//---------------------------------------------------------------
intel_systemclk_gts_0 sys_pll(
	.o_pll_lock(o_pll_lock)     ,
	.o_syspll_c0(i_clk_sys)           ,
//	.q0_flux_clk(),
//	.q1_flux_clk(),
//	.q2_flux_clk(),
//	.q3_flux_clk(),
//	.q4_flux_clk(),
	.i_refclk(i_refclk2pll_p),
	.i_refclk_ready (1'b1)

);

//---------------------------------------------------------------
//Added for shoreline Sequencer
//---------------------------------------------------------------
//`ifdef ALTERA_RESERVED_QIS
intel_srcss_gts_0 src_sss(
.o_src_rs_grant	(i_src_rs_grant),   //   out_shoreline_grant.grant
.i_src_rs_priority	(1'b0), // in_shoreline_priority.in_shoreline_priority
.i_src_rs_req	(o_src_rs_req) ,
.o_pma_cu_clk             (i_pma_cu_clk[0])

);
// `else
// always @ (posedge clk50m)
// begin
     // if(o_src_rs_req)
             // i_src_rs_grant <= 1'b1;
     // else
             // i_src_rs_grant <= 1'b0;
// end
// `endif

//------------------------------------------------------------------

//---------------------------------------------------------------
genvar portid;

generate
    for (portid =0; portid < INSTANCE_NUM; portid = portid+1) begin: IP_INST

    cpl_eth_gts_hw_ip_top hw_ip_top (
            .i_clk_sys                        (i_clk_sys                ),
            .i_clk_ref_p                        ( i_clk_ref_p               ),
		//		.i_clk_ref_p                       (i_refclk2pll_p), //Updated by JS
   //         .i_clk_ref_n                        (                ),
            .i_reconfig_clk                   (i_reconfig_clk           ),
            //.i_reconfig_reset                 (reconfig_reset_sync      ),
            .i_reconfig_reset                 (reconfig_reset_new),
            .i_clk_rx                         (i_clk_rx         [portid]),
            .i_clk_tx                         (i_clk_tx         [portid]),
            .o_clk_pll                        (o_clk_pll        [portid]),
            .o_clk_tx_div                     (o_clk_tx_div     [portid]),
            .o_clk_rec_div64                  (o_clk_rec_div64  [portid]),
            .o_clk_rec_div                    (o_clk_rec_div    [portid]),


            .i_rx_rst_n                       (rx_rst_n         [portid]),
            .i_tx_rst_n                       (tx_rst_n         [portid]),
            .i_rst_n                          (rst_n            [portid]),
            .o_rst_ack_n                      (o_rst_ack_n      [portid]),
            .o_rx_rst_ack_n                   (o_rx_rst_ack_n   [portid]),
            .o_tx_rst_ack_n                   (o_tx_rst_ack_n   [portid]),

            .i_rx_serial_data                      (i_rx_serial_data      [portid*1+:1]),
            .i_rx_serial_data_n                    (i_rx_serial_data_n    [portid*1+:1]),
            .o_tx_serial_data                      (o_tx_serial_data      [portid*1+:1]),
            .o_tx_serial_data_n                    (o_tx_serial_data_n    [portid*1+:1]),
            .user_io                          (user_io                  ),
            .user_led                         (user_led                 ),
            .qsfp_lowpwr                      (qsfp_lowpwr              ),
            .qsfp_rstn                        (qsfp_rstn                ),
            .o_rx_pcs_ready                   (rx_pcs_ready    [portid]),
            .o_tx_lanes_stable                (tx_lanes_stable [portid]),
            .o_cdr_lock                       (cdr_lock        [portid]),
            .o_tx_pll_locked                  (tx_pll_locked   [portid]),
	    .i_syspll_lock		      (o_pll_lock),
	    .i_pma_cu_clk			      (i_pma_cu_clk[portid]),
	    .o_src_rs_req			      (o_src_rs_req[portid]),
	    .i_src_rs_grant		      (i_src_rs_grant[portid]),



            //---avmm master from hw top decoder--
            .i_jtag_address                   (avalon_master_address),
            .i_jtag_read                      (avalon_master_read),
            .i_jtag_write                     (avalon_master_write),
            .i_jtag_writedata                 (avalon_master_writedata),
            .i_jtag_byteenable                (4'b1111),
            .o_jtag_readdata                  (avalon_master_readdata),
            .o_jtag_readdatavalid             (avalon_master_readdatavalid),
            .o_jtag_waitrequest               (avalon_master_waitrequest)
);
    end
endgenerate


// ---- IP_TC = 0 end




endmodule
