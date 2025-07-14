module cpl_mem_excr_top #(
    parameter AXI4_ADDR_WIDTH      = 31,
    parameter AXI4_DATA_WIDTH      = 256,
    parameter AXI4_ID_W_WIDTH      = 9,
    parameter AXI4_ID_R_WIDTH      = 9,
    parameter USER_REQ_WIDTH       = 1,
    parameter USER_RESP_WIDTH      = 1,
    parameter USER_DATA_WIDTH      = 1
)(
    input   wire                                emif_usr_reset_n,     // emif_usr_reset_n.reset_n
    input   wire                                emif_usr_clk,         //     emif_usr_clk.clk

    output  wire    [AXI4_ID_W_WIDTH-1:0]       axi_awid,
    output  wire    [AXI4_ADDR_WIDTH-1:0]       axi_awaddr,
    output  wire                                axi_awvalid,
    output  wire    [0:0]                       axi_awuser,
    output  wire    [7:0]                       axi_awlen,
    output  wire    [2:0]                       axi_awsize,
    output  wire    [1:0]                       axi_awburst,
    input   wire                                axi_awready,
    output  wire    [0:0]                       axi_awlock,
    output  wire    [3:0]                       axi_awcache,
    output  wire    [2:0]                       axi_awprot,
    output  wire    [AXI4_ID_R_WIDTH-1:0]       axi_arid,
    output  wire    [AXI4_ADDR_WIDTH-1:0]       axi_araddr,
    output  wire                                axi_arvalid,
    output  wire    [USER_REQ_WIDTH-1:0]        axi_aruser,
    output  wire    [7:0]                       axi_arlen,
    output  wire    [2:0]                       axi_arsize,
    output  wire    [1:0]                       axi_arburst,
    input   wire                                axi_arready,
    output  wire    [0:0]                       axi_arlock,
    output  wire    [3:0]                       axi_arcache,
    output  wire    [2:0]                       axi_arprot,
    output  wire    [AXI4_DATA_WIDTH-1:0]       axi_wdata,
    output  wire    [USER_DATA_WIDTH-1:0]       axi_wuser,
    output  wire    [AXI4_DATA_WIDTH/8-1:0]     axi_wstrb,
    output  wire                                axi_wlast,
    output  wire                                axi_wvalid,
    input   wire                                axi_wready,
    input   wire    [AXI4_ID_W_WIDTH-1:0]       axi_bid,
    input   wire    [1:0]                       axi_bresp,
    input   wire    [USER_RESP_WIDTH-1:0]       axi_buser,
    input   wire                                axi_bvalid,
    output  wire                                axi_bready,
    input   wire    [AXI4_DATA_WIDTH-1:0]       axi_rdata,
    input   wire    [1:0]                       axi_rresp,
    input   wire    [USER_RESP_WIDTH-1:0]       axi_ruser,
    input   wire                                axi_rlast,
    input   wire                                axi_rvalid,
    output  wire                                axi_rready,
    input   wire    [AXI4_ID_R_WIDTH-1:0]       axi_rid,

    output  wire                                traffic_gen_pass,     //        tg_status.traffic_gen_pass
    output  wire                                traffic_gen_fail,     //                 .traffic_gen_fail
    output  wire                                traffic_gen_timeout,  //                 .traffic_gen_timeout

    output  wire                                tg_cfg_waitrequest,   //           tg_cfg.waitrequest
    input   wire                                tg_cfg_read,          //                 .read
    input   wire                                tg_cfg_write,         //                 .write
    input   wire    [9:0]                       tg_cfg_address,       //                 .address
    output  wire    [31:0]                      tg_cfg_readdata,      //                 .readdata
    input   wire    [31:0]                      tg_cfg_writedata,     //                 .writedata
    output  wire                                tg_cfg_readdatavalid  //                 .readdatavalid
);




	pv_ss_mem_msa_tg #(
        .ADDR_WIDTH(AXI4_ADDR_WIDTH),
        .DATA_WIDTH(AXI4_DATA_WIDTH),
        .ID_W_WIDTH(AXI4_ID_W_WIDTH),
        .ID_R_WIDTH(AXI4_ID_R_WIDTH),
        .USER_REQ_WIDTH(USER_REQ_WIDTH),
        .USER_RESP_WIDTH(USER_RESP_WIDTH),
        .USER_DATA_WIDTH(USER_DATA_WIDTH)
    )tg_0 (
		.emif_usr_reset_n                (emif_usr_reset_n),                     //   input,    width = 1, emif_usr_reset_n.reset_n
		.emif_usr_clk                    (emif_usr_clk),                         //   input,    width = 1,     emif_usr_clk.clk

		.ninit_done                      (1'b0),                           //   input,    width = 1,       ninit_done.ninit_done

        .axi_awid                        (axi_awid),                             //  output,    width = 9,         ctrl_axi.awid
		.axi_awaddr                      (axi_awaddr),                           //  output,   width = 32,                 .awaddr
		.axi_awvalid                     (axi_awvalid),                          //  output,    width = 1,                 .awvalid
		.axi_awuser                      (axi_awuser),                           //  output,    width = 1,                 .awuser
		.axi_awlen                       (axi_awlen),                            //  output,    width = 8,                 .awlen
		.axi_awsize                      (axi_awsize),                           //  output,    width = 3,                 .awsize
		.axi_awburst                     (axi_awburst),                          //  output,    width = 2,                 .awburst
		.axi_awready                     (axi_awready),                          //   input,    width = 1,                 .awready
		.axi_awlock                      (axi_awlock),                           //  output,    width = 1,                 .awlock
		.axi_awcache                     (axi_awcache),                          //  output,    width = 4,                 .awcache
		.axi_awprot                      (axi_awprot),                           //  output,    width = 3,                 .awprot
		.axi_arid                        (axi_arid),                             //  output,    width = 9,                 .arid
		.axi_araddr                      (axi_araddr),                           //  output,   width = 32,                 .araddr
		.axi_arvalid                     (axi_arvalid),                          //  output,    width = 1,                 .arvalid
		.axi_aruser                      (axi_aruser),                           //  output,    width = 1,                 .aruser
		.axi_arlen                       (axi_arlen),                            //  output,    width = 8,                 .arlen
		.axi_arsize                      (axi_arsize),                           //  output,    width = 3,                 .arsize
		.axi_arburst                     (axi_arburst),                          //  output,    width = 2,                 .arburst
		.axi_arready                     (axi_arready),                          //   input,    width = 1,                 .arready
		.axi_arlock                      (axi_arlock),                           //  output,    width = 1,                 .arlock
		.axi_arcache                     (axi_arcache),                          //  output,    width = 4,                 .arcache
		.axi_arprot                      (axi_arprot),
		.axi_wuser						 (axi_wuser),                           //  output,    width = 3,                 .arprot
		.axi_wdata                       (axi_wdata),                            //  output,  width = 512,                 .wdata
		.axi_wstrb                       (axi_wstrb),                            //  output,   width = 64,                 .wstrb
		.axi_wlast                       (axi_wlast),                            //  output,    width = 1,                 .wlast
		.axi_wvalid                      (axi_wvalid),                           //  output,    width = 1,                 .wvalid
		.axi_wready                      (axi_wready),                           //   input,    width = 1,                 .wready
		.axi_bid                         (axi_bid),                              //   input,    width = 9,                 .bid
		.axi_bresp                       (axi_bresp),                            //   input,    width = 2,                 .bresp
		.axi_buser                       (axi_buser),                            //   input,    width = 1,                 .buser
		.axi_bvalid                      (axi_bvalid),                           //   input,    width = 1,                 .bvalid
		.axi_bready                      (axi_bready),                           //  output,    width = 1,                 .bready
		.axi_rdata                       (axi_rdata),                            //   input,  width = 512,                 .rdata
		.axi_rresp                       (axi_rresp),                            //   input,    width = 2,                 .rresp
		.axi_ruser                       (axi_ruser),                            //   input,    width = 1,                 .ruser
		.axi_rlast                       (axi_rlast),                            //   input,    width = 1,                 .rlast
		.axi_rvalid                      (axi_rvalid),                           //   input,    width = 1,                 .rvalid
		.axi_rready                      (axi_rready),                           //  output,    width = 1,                 .rready
		.axi_rid                         (axi_rid),

		.tg_cfg_waitrequest              (tg_cfg_waitrequest),                   //  output,    width = 1,           tg_cfg.waitrequest
		.tg_cfg_read                     (tg_cfg_read),                          //   input,    width = 1,                 .read
		.tg_cfg_write                    (tg_cfg_write),                         //   input,    width = 1,                 .write
		.tg_cfg_address                  (tg_cfg_address),                       //   input,   width = 10,                 .address
		.tg_cfg_readdata                 (tg_cfg_readdata),                      //  output,   width = 32,                 .readdata
		.tg_cfg_writedata                (tg_cfg_writedata),                     //   input,   width = 32,                 .writedata
		.tg_cfg_readdatavalid            (tg_cfg_readdatavalid)
	);

endmodule
