`timescale 1 ps / 1 ps
	module cpl_eth_excr
	# (
        parameter ETH_PKT_WIDTH   = 64,
        parameter ETH_EOP_WIDTH   = 1,
        parameter AVMM_ADDRW      = 16,
        parameter AVMM_DATAW      = 32,
        parameter AVMM_BYTEENW    = 4,
        parameter MAX_ETH_CH      = ofs_fim_eth_plat_if_pkg::MAX_NUM_ETH_CHANNELS,
		parameter AXI4L_ADDR_WIDTH = 16,
	parameter AXI4L_DATA_WIDTH = 32,
	parameter AXI4L_RRESP_WIDTH = 2,
	parameter AXI4L_WSTRB_WIDTH = 4,
	parameter AXI4L_BRESP_WIDTH = 2,
		parameter string           G_QSFP_TYPE = "NRZ",     // '{"NRZ","PAM4"} NRZ is the default "100G NRZ front ports interfacing with 4 x 25G NRZ "
                                                         //                 PAM4 is a testvariant with 100G interfacing with 2 x 56G PAM4
		parameter integer          G_E_TILE_REFCLK =3,     // The REFCLK_GXER9A_CH(x). Remember to update import list with proper settings file.
		parameter                  G_FPGA_FAMILY = "Agilex",
		parameter string           G_FPGA_PINOUT = "A0"   // '{"A0","X0"} // A0 is the main target for this design. For any subsequent design revisions which has same pinout, please use the same revision code: "A0"
                                                        // X0 has some pinout differences and the PPS control network does not work either
		)
		(
			input wire                            clk,
			input wire                            reset_n,
			//input wire         cr3_eth_refclk_qsfp_cvl_clk,   //156250000 freq
			//input wire         cr3_cpri_reflclk_clk_184_32m,
			//input wire         cr3_cpri_reflclk_clk,

			//AVMM input
			//input	logic [AVMM_ADDRW-1:0] avalon_master_address,
		//input	logic                        avalon_master_read,
		//input	logic                        avalon_master_write,
		//output	logic                        avalon_master_readdatavalid,
		//output	logic                        avalon_master_waitrequest,
		//input	logic [AVMM_DATAW-1:0] avalon_master_writedata,
		//output	logic [AVMM_DATAW-1:0] avalon_master_readdata,

			// AXI4L slave cfg input
		input  logic [AXI4L_ADDR_WIDTH-1:0] axi_slave_araddr,
		input  logic                        axi_slave_arvalid,
		output logic                        axi_slave_arready,
		input  logic [AXI4L_ADDR_WIDTH-1:0] axi_slave_awaddr,
		input  logic                        axi_slave_awvalid,
		output logic                        axi_slave_awready,
		output logic [AXI4L_DATA_WIDTH-1:0] axi_slave_rdata,
		output logic [AXI4L_RRESP_WIDTH-1:0]  axi_slave_rresp,
		output logic                        axi_slave_rvalid,
		input  logic                        axi_slave_rready,
		input  logic [AXI4L_DATA_WIDTH-1:0] axi_slave_wdata,
		input  logic                        axi_slave_wvalid,
		output logic                        axi_slave_wready,
		input  logic [AXI4L_WSTRB_WIDTH-1:0]  axi_slave_wstrb,
		output logic [AXI4L_BRESP_WIDTH-1:0]  axi_slave_bresp,
		output logic                        axi_slave_bvalid,
		input  logic                        axi_slave_bready,

            // AVST intf
            input wire eth_rx_cmac_avl_clk_0,
            input wire eth_tx_cmac_avl_clk_0,
            input wire eth_tx_cmac_avl_rdy_0,

            output wire eth_tx_cmac_avl_sop_0,
            output wire eth_tx_cmac_avl_valid_0,
            output wire [ETH_EOP_WIDTH-1:0] eth_tx_cmac_avl_eop_0 ,
            output wire [ETH_PKT_WIDTH-1:0] eth_tx_cmac_avl_data_0,
            output wire [2:0] eth_tx_cmac_avl_empty_0,
            output wire eth_tx_cmac_avl_err_0,

            input wire eth_rx_cmac_avl_sop_0,
            input wire eth_rx_cmac_avl_valid_0,
            input wire [ETH_PKT_WIDTH-1:0] eth_rx_cmac_avl_eop_0,
            input wire [ETH_EOP_WIDTH-1:0] eth_rx_cmac_avl_data_0,
            input wire [2:0] eth_rx_cmac_avl_empty_0,

            output logic [31:0] e_tile_txrx_status

);
	localparam MAX_NUM_ETH_CHANNELS =16;
	localparam NUM_QSFP_PORTS =2;
	//AXIS interface
	ofs_fim_eth_tx_axis_if        afu_axi_tx_st [MAX_NUM_ETH_CHANNELS-1:0]();
	ofs_fim_eth_rx_axis_if        afu_axi_rx_st [MAX_NUM_ETH_CHANNELS-1:0]();
	//AVST interface
	ofs_fim_eth_tx_avst_if        avst_tx_st [MAX_NUM_ETH_CHANNELS-1:0]();
	ofs_fim_eth_rx_avst_if        avst_rx_st [MAX_NUM_ETH_CHANNELS-1:0]();

	// ofs_fim_hssi_fc_if                hssi_fc [MAX_NUM_ETH_CHANNELS-1:0]();
	//AVMM interface
	ofs_avmm_if				  csr_lite_if();
	//AXI-MM interface
	ofs_fim_axi_mmio_if       csr_if();
	import eth100_avst_pkg::*;
	eth100_avst_t tx_cmac_avl [3:0];
	eth100_avst_t rx_cmac_avl [3:0];

	logic [3:0] tx_cmac_avl_clk;
	logic [3:0] tx_cmac_avl_clk_rst;
	logic [3:0] tx_cmac_avl_rdy;
	logic [3:0] rx_cmac_avl_clk;
	logic [3:0] rx_cmac_avl_clk_rst;

	logic [15:0] e_tile_txrx_status_0;
	logic [15:0] e_tile_txrx_status_1;

	logic [MAX_NUM_ETH_CHANNELS-1:0]  hssi_clk_pll;
	logic 	fpga_usr_100m_clk_rst;
	logic 	fpga_usr_100m_clk;
	logic [1:0] e_tile_async_rst;
	logic   e_tile_ref_clk;
	logic [63:0] misc_debug_0;
	logic [63:0] misc_debug_1;
	logic [3:0] qsfp_recov_clks;
	logic  [3:0] e_tile_rdy;
	logic [63:0] cmac_gen_cfg;        // General E-tile configurations

	assign port_rst_n = ~fpga_usr_100m_clk_rst;
	assign fpga_usr_100m_clk_rst = ~reset_n;
	assign fpga_usr_100m_clk = clk;

	logic [75:0] xcvr_qsfpa_reconfig_address;
	logic [3:0]  xcvr_qsfpa_reconfig_read;
	logic [3:0]  xcvr_qsfpa_reconfig_write;
	logic [31:0] xcvr_qsfpa_reconfig_readdata;
	logic [31:0] xcvr_qsfpa_reconfig_writedata;
	logic [3:0]  xcvr_qsfpa_reconfig_waitrequest;

	logic [75:0] xcvr_qsfpb_reconfig_address    ; // = 'b0;
	logic [3:0]  xcvr_qsfpb_reconfig_read       ; // = 'b0;
	logic [3:0]  xcvr_qsfpb_reconfig_write      ; // = 'b0;
	logic [31:0] xcvr_qsfpb_reconfig_readdata   ; // = 'b0;
	logic [31:0] xcvr_qsfpb_reconfig_writedata  ; // = 'b0;
	logic [3:0]  xcvr_qsfpb_reconfig_waitrequest; // = 'b0;

	// Comment if using AVMM cfg interface

	logic [AVMM_ADDRW-1:0] avalon_master_address;
    logic                        avalon_master_read;
    logic                        avalon_master_write;
    logic                        avalon_master_readdatavalid;
    logic                        avalon_master_waitrequest;
    logic [AVMM_DATAW-1:0] avalon_master_writedata;
    logic [AVMM_DATAW-1:0] avalon_master_readdata;


	axi2avmmbridge #(
	    .AVMM_ADDR_WIDTH   (AVMM_ADDRW),
	    .AVMM_DATA_WIDTH   (AVMM_DATAW),
	    .AXI4L_ADDR_WIDTH  (AXI4L_ADDR_WIDTH),
	    .AXI4L_DATA_WIDTH  (AXI4L_DATA_WIDTH),
	    .AXI4L_RRESP_WIDTH (AXI4L_RRESP_WIDTH),
	    .AXI4L_WSTRB_WIDTH (AXI4L_WSTRB_WIDTH),
	    .AXI4L_BRESP_WIDTH (AXI4L_BRESP_WIDTH)
    ) axi_2_avmmbridge_inst (
	    .clk                         (clk),
	    .rst_n                       (reset_n),

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





	//Assigning jtag_master exported interfaces to avmm interface
	assign csr_lite_if.source.clk = clk;
	assign csr_lite_if.source.write = avalon_master_write;
	assign csr_lite_if.source.read = avalon_master_read;
	assign csr_lite_if.source.writedata = avalon_master_writedata;
	assign csr_lite_if.source.address = avalon_master_address;
	assign csr_lite_if.source.byteenable = 4'b1111;
	assign csr_lite_if.source.rst_n = reset_n;
	assign avalon_master_readdatavalid = csr_lite_if.source.readdatavalid;
	assign avalon_master_readdata = csr_lite_if.source.readdata;
	assign avalon_master_waitrequest = csr_lite_if.source.waitrequest;



	he_hssi_top #(
        .MAX_NUM_ETH_CHANNELS(16)
    ) he_hssi_inst (
	.clk            (clk),
	.softreset      (~reset_n),
	.csr_lite_if	(csr_lite_if	),
	.afu_eth_rx_st  (afu_axi_rx_st), //axt-st-tx
	.afu_eth_tx_st  (afu_axi_tx_st), //axt-st-rx
	.e_tile_txrx_status	(e_tile_txrx_status)
	);


	//AXST	-->	AVST conversion
	ofs_fim_eth_afu_axi_2_avst_bridge axis_to_avst_bridge_inst_0 (
       .avst_tx_st (avst_tx_st[0]),
       .avst_rx_st (avst_rx_st[0]),
       .axi_tx_st  (afu_axi_tx_st[0]),
       .axi_rx_st  (afu_axi_rx_st[0])
        );

	//AXST	-->	AVST conversion
	//ofs_fim_eth_afu_axi_2_avst_bridge axis_to_avst_bridge_inst_1 (
    //   .avst_tx_st (avst_tx_st[1]),
    //   .avst_rx_st (avst_rx_st[1]),
    //   .axi_tx_st  (afu_axi_tx_st[1]),
    //   .axi_rx_st  (afu_axi_rx_st[1])
    //    );

	//assign avst_rx_st[1].clk = rx_cmac_avl_clk[1] ;
	//assign avst_rx_st[1].rst_n = reset_n ;

	assign avst_rx_st[0].clk = rx_cmac_avl_clk[0] ;
	assign avst_rx_st[0].rst_n = reset_n;
//
	assign avst_tx_st[0].clk = tx_cmac_avl_clk[0];
	assign avst_tx_st[0].rst_n = reset_n;
	assign avst_tx_st[0].ready = tx_cmac_avl_rdy[0];
	//
	assign tx_cmac_avl[0].sop = avst_tx_st[0].tx.sop;
	assign tx_cmac_avl[0].valid = avst_tx_st[0].tx.valid;
	assign tx_cmac_avl[0].eop = avst_tx_st[0].tx.eop;
	assign tx_cmac_avl[0].data = avst_tx_st[0].tx.data;
	assign tx_cmac_avl[0].empty = avst_tx_st[0].tx.empty;
	assign tx_cmac_avl[0].err = avst_tx_st[0].tx.user.error;
	//
	//
	assign avst_rx_st[0].rx.sop = rx_cmac_avl[0].sop;
	assign avst_rx_st[0].rx.valid = rx_cmac_avl[0].valid;
	assign avst_rx_st[0].rx.eop = rx_cmac_avl[0].eop;
	assign avst_rx_st[0].rx.data = rx_cmac_avl[0].data;
	assign avst_rx_st[0].rx.empty = rx_cmac_avl[0].empty;

    // Top level port mapping
    assign rx_cmac_avl_clk[0] = eth_rx_cmac_avl_clk_0; //input
    assign tx_cmac_avl_clk[0] = eth_tx_cmac_avl_clk_0; //input
    assign tx_cmac_avl_rdy[0] = eth_tx_cmac_avl_rdy_0; //input

    assign eth_tx_cmac_avl_sop_0    =tx_cmac_avl[0].sop;        // output
    assign eth_tx_cmac_avl_valid_0  =tx_cmac_avl[0].valid;      // output
    assign eth_tx_cmac_avl_eop_0    =tx_cmac_avl[0].eop;        // output
    assign eth_tx_cmac_avl_data_0   =tx_cmac_avl[0].data;       // output
    assign eth_tx_cmac_avl_empty_0  =tx_cmac_avl[0].empty;      // output
    assign eth_tx_cmac_avl_err_0    =tx_cmac_avl[0].err;        // output

    assign   rx_cmac_avl[0].sop     = eth_rx_cmac_avl_sop_0;     // input
    assign   rx_cmac_avl[0].valid   = eth_rx_cmac_avl_valid_0;   // input
    assign   rx_cmac_avl[0].eop     = eth_rx_cmac_avl_eop_0;     // input
    assign   rx_cmac_avl[0].data    = eth_rx_cmac_avl_data_0;    // input
    assign   rx_cmac_avl[0].empty   = eth_rx_cmac_avl_empty_0;   // input





   // port_eth100 #(
         // .G_PHY_CFG          (2)
      // ) cvl_interface_0 (
      // .refclk_i                    (e_tile_ref_clk                ),
      // .e_tile_async_rst_i          (e_tile_async_rst[2]           ),
      // .eth_rx_i                    (  e810_tx[3:0]                ), // ZQSFP_RX first channel
      // .eth_tx_o                    (r_e810_rx[3:0]                ), // ZQSFP_TX first channel
      // .reconfig_clk_i              (fpga_usr_100m_clk             ),
      // .reconfig_clk_rst_i          (fpga_usr_100m_clk_rst         ),
      // .xcvr_reconfig_address_i     (xcvr_cvl0_reconfig_address    ),
      // .xcvr_reconfig_read_i        (xcvr_cvl0_reconfig_read       ),
      // .xcvr_reconfig_write_i       (xcvr_cvl0_reconfig_write      ),
      // .xcvr_reconfig_readdata_o    (xcvr_cvl0_reconfig_readdata   ),
      // .xcvr_reconfig_writedata_i   (xcvr_cvl0_reconfig_writedata  ),
      // .xcvr_reconfig_waitrequest_o (xcvr_cvl0_reconfig_waitrequest),
      // .tx_mac_clk_o                (tx_cmac_avl_clk[2]            ),
      // .tx_mac_clk_rst_o            (tx_cmac_avl_clk_rst[2]        ),
      // .tx_mac_avst_i               (tx_cmac_avl[2]                ),
      // .tx_mac_avst_rdy_o           (tx_cmac_avl_rdy[2]            ),
      // .rx_mac_clk_o                (rx_cmac_avl_clk[2]            ),
      // .rx_mac_clk_rst_o            (rx_cmac_avl_clk_rst[2]        ),
      // .rx_mac_avst_o               (rx_cmac_avl[2]                ),
      // .synce_clk_o                 (qsfp_recov_clks[2]            ),
      // .cnt_mac_rst_clks_o          (misc_debug_1[15:0]            ),
      // .e_tile_rdy_o                (e_tile_rdy[2]                 ),
      // .tx_mac_clk_rst_async_i      (cmac_gen_cfg[4]       ),
      // .e_tile_txrx_status_o        (e_tile_txrx_status_2          )
   // );

endmodule