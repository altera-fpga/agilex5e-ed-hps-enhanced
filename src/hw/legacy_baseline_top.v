//****************************************************************************
//
// SPDX-License-Identifier: MIT-0
// SPDX-FileCopyrightText: Copyright (C) 2025 Altera Corporation
//
//****************************************************************************
// This is a generated system top level RTL file.

// Derive channel and width from hps_emif_topology

// Find and print each number individually


module ghrd_agilex5_top (
    //Additional refclk_bti to preserve Etile XCVR
    // Clock and Reset
    input wire          fpga_clk_100,
    input  wire         fpga_reset_n,

    output wire [4-1:0] fpga_led_pio,
    input  wire [4-1:0] fpga_dipsw_pio,
    input  wire [4-1:0] fpga_button_pio,
    //HPS
    // HPS EMIF
    output wire         emif_hps_emif_mem_0_mem_ck_t,
    output wire         emif_hps_emif_mem_0_mem_ck_c,
    output wire [ 16:0] emif_hps_emif_mem_0_mem_a,
    output wire         emif_hps_emif_mem_0_mem_act_n,
    output wire [  1:0] emif_hps_emif_mem_0_mem_ba,
    output wire [  1:0] emif_hps_emif_mem_0_mem_bg,
    output wire         emif_hps_emif_mem_0_mem_cke,
    output wire         emif_hps_emif_mem_0_mem_cs_n,
    output wire         emif_hps_emif_mem_0_mem_odt,
    output wire         emif_hps_emif_mem_0_mem_reset_n,
    output wire         emif_hps_emif_mem_0_mem_par,
    input  wire         emif_hps_emif_mem_0_mem_alert_n,
    input  wire         emif_hps_emif_oct_0_oct_rzqin,
    input  wire         emif_hps_emif_ref_clk_0_clk,
    inout  wire [  3:0] emif_hps_emif_mem_0_mem_dqs_t,
    inout  wire [  3:0] emif_hps_emif_mem_0_mem_dqs_c,
    inout  wire [ 31:0] emif_hps_emif_mem_0_mem_dq,
    input  wire         hps_jtag_tck,
    input  wire         hps_jtag_tms,
    output wire         hps_jtag_tdo,
    input  wire         hps_jtag_tdi,
    output wire         hps_sdmmc_CCLK,
    inout  wire         hps_sdmmc_CMD,
    inout  wire         hps_sdmmc_D0,
    inout  wire         hps_sdmmc_D1,
    inout  wire         hps_sdmmc_D2,
    inout  wire         hps_sdmmc_D3,

    input  wire         usb31_io_vbus_det,
    input  wire         usb31_io_flt_bar,
    output wire         usb31_io_usb_ctrl,
    input  wire         usb31_io_usb31_id,
    input  wire         usb31_phy_refclk_p_clk,
    //input    wire          usb31_phy_refclk_p_clk(n),
    input  wire         usb31_phy_rx_serial_n_i_rx_serial_n,
    input  wire         usb31_phy_rx_serial_p_i_rx_serial_p,
    output wire         usb31_phy_tx_serial_n_o_tx_serial_n,
    output wire         usb31_phy_tx_serial_p_o_tx_serial_p,
    inout  wire         hps_usb1_DATA0,
    inout  wire         hps_usb1_DATA1,
    inout  wire         hps_usb1_DATA2,
    inout  wire         hps_usb1_DATA3,
    inout  wire         hps_usb1_DATA4,
    inout  wire         hps_usb1_DATA5,
    inout  wire         hps_usb1_DATA6,
    inout  wire         hps_usb1_DATA7,
    input  wire         hps_usb1_CLK,
    output wire         hps_usb1_STP,
    input  wire         hps_usb1_DIR,
    input  wire         hps_usb1_NXT,
    output wire         hps_emac2_TX_CLK,
    input  wire         hps_emac2_RX_CLK,
    output wire         hps_emac2_TX_CTL,
    input  wire         hps_emac2_RX_CTL,
    output wire         hps_emac2_TXD0,
    output wire         hps_emac2_TXD1,
    input  wire         hps_emac2_RXD0,
    input  wire         hps_emac2_RXD1,
    output wire         hps_emac2_PPS,
    input  wire         hps_emac2_PPS_TRIG,
    output wire         hps_emac2_TXD2,
    output wire         hps_emac2_TXD3,
    input  wire         hps_emac2_RXD2,
    input  wire         hps_emac2_RXD3,
    inout  wire         hps_emac2_MDIO,
    output wire         hps_emac2_MDC,
    input  wire         hps_uart0_RX,
    output wire         hps_uart0_TX,
    inout  wire         hps_i3c1_SDA,
    inout  wire         hps_i3c1_SCL,
    inout  wire         hps_gpio0_io0,
    inout  wire         hps_gpio0_io1,
    inout  wire         hps_gpio0_io11,
    inout  wire         hps_gpio1_io3,
    inout  wire         hps_gpio1_io4,
    input  wire         hps_osc_clk,
	 // CPL Related
     // DDR4 COMP1
	output  wire        DDR4_COMP1_CKE,
	output  wire        DDR4_COMP1_ODT,
	output  wire        DDR4_COMP1_CS_N,
	output  wire [16:0] DDR4_COMP1_A,
	output  wire [1:0]  DDR4_COMP1_BA,
	output  wire [1:0]  DDR4_COMP1_BG,
	output  wire        DDR4_COMP1_ACT_N,
	output  wire        DDR4_COMP1_PAR,
	inout   wire [39:0] DDR4_COMP1_DQ,
	inout   wire [4:0]  DDR4_COMP1_DQS_P,
	inout   wire [4:0]  DDR4_COMP1_DQS_N,
	input   wire        DDR4_COMP1_ALERT_N,
	inout   wire [4:0]  DDR4_COMP1_DBI_N,
	output  wire        DDR4_COMP1_CK_P,
	output  wire        DDR4_COMP1_CK_N,
	output  wire        DDR4_COMP1_RESET_N,
	input   wire        RZQ_B_2B_RR,
	input   wire        DDR4_COMP1_REFCLK_P,
    // LPDDR4
	output  wire        LPDDR4_CS_N0,
	output  wire [5:0]  LPDDR4_CA,
	output  wire        LPDDR4_CKE_R0,
	inout   wire [31:0] LPDDR4_DQ,
	inout   wire [3:0]  LPDDR4_DQS_P,
	inout   wire [3:0]  LPDDR4_DQS_N,
	inout   wire [3:0]  LPDDR4_DM,
	output  wire        LPDDR4_CK_P,
	output  wire        LPDDR4_CK_N,
	output  wire        LPDDR4_RESET_N,
	input   wire        RZQ_B_2A_RR,
	input   wire        LPDDR4_REFCLK_P,
//-- ETh TG
//	 input  wire        i_refclk2pll_p,
	 input  wire        i_clk_ref_p,

	 input  wire        i_rx_serial_data,
	 input  wire        i_rx_serial_data_n,
	 output wire        o_tx_serial_data,
	 output wire        o_tx_serial_data_n

);

    wire system_clk_100;
    wire ninit_done;
    wire fpga_reset_n_debounced_wire;
    reg  fpga_reset_n_debounced;
    wire system_reset;

    wire ddr4_comp_usrpll_locked;
    wire memtg_ddr4_comp_sys_rstn;
    wire memtg_ddr4_tg_pass;
    wire memtg_ddr4_tg_fail;
    wire memtg_ddr4_tg_timeout;

    wire lpddr4_comp_usrpll_locked;
    wire memtg_lpddr4_sys_rstn;
    wire memtg_lpddr4_tg_pass;
    wire memtg_lpddr4_tg_fail;
    wire memtg_lpddr4_tg_timeout;

    wire o_pll_lock;
    wire [1:0] usb31_io_usb_ctrl_int;
    wire h2f_reset;

    assign usb31_io_usb_ctrl = usb31_io_usb_ctrl_int[1];

    assign system_clk_100 = fpga_clk_100;
    assign combined_reset_n = fpga_reset_n & ~h2f_reset & ~ninit_done;
    assign memtg_ddr4_comp_sys_rstn = ddr4_comp_usrpll_locked;
    assign memtg_lpddr4_sys_rstn = lpddr4_comp_usrpll_locked;

    altera_reset_synchronizer #(
        .ASYNC_RESET(1),
        .DEPTH      (2)
    ) sys_rst_inst (
        .reset_in (~combined_reset_n),
        .clk      (system_clk_100),
        .reset_out(system_reset)
    );


    wire [4-1:0] fpga_debounced_buttons;
    wire [4-2:0] fpga_led_internal;
    wire heartbeat_led;
    reg [22:0] heartbeat_count;
    assign heartbeat_led = ~heartbeat_count[22];
    assign fpga_led_pio = {heartbeat_led, fpga_led_internal};



    wire [30:0] f2h_irq1_irq;
    wire [1:0] o_pma_cpu_clk;
    //wire i_refclk_bus_out;

    //assign i_refclk_bus_out = 1'b0;

    assign f2h_irq1_irq = {31'b0};

    // Qsys Top module
    qsys_top soc_inst (
        .clk_100_clk                                                    ( system_clk_100            ),
        .ninit_done_ninit_done                                          ( ninit_done                ),
        .led_pio_external_connection_in_port                            ( fpga_led_internal         ),
        .led_pio_external_connection_out_port                           ( fpga_led_internal         ),
        .dipsw_pio_external_connection_export                           ( fpga_dipsw_pio            ),
        .button_pio_external_connection_export                          ( fpga_debounced_buttons    ),

        .emif_hps_emif_mem_ck_0_mem_ck_t                                ( emif_hps_emif_mem_0_mem_ck_t      ),
        .emif_hps_emif_mem_ck_0_mem_ck_c                                ( emif_hps_emif_mem_0_mem_ck_c      ),
        .emif_hps_emif_mem_0_mem_a                                      ( emif_hps_emif_mem_0_mem_a         ),
        .emif_hps_emif_mem_0_mem_act_n                                  ( emif_hps_emif_mem_0_mem_act_n     ),
        .emif_hps_emif_mem_0_mem_ba                                     ( emif_hps_emif_mem_0_mem_ba        ),
        .emif_hps_emif_mem_0_mem_bg                                     ( emif_hps_emif_mem_0_mem_bg        ),
        .emif_hps_emif_mem_0_mem_cke                                    ( emif_hps_emif_mem_0_mem_cke       ),
        .emif_hps_emif_mem_0_mem_cs_n                                   ( emif_hps_emif_mem_0_mem_cs_n      ),
        .emif_hps_emif_mem_0_mem_odt                                    ( emif_hps_emif_mem_0_mem_odt       ),
        .emif_hps_emif_mem_reset_n_mem_reset_n                          ( emif_hps_emif_mem_0_mem_reset_n   ),
        .emif_hps_emif_mem_0_mem_par                                    ( emif_hps_emif_mem_0_mem_par       ),
        .emif_hps_emif_mem_0_mem_alert_n                                ( emif_hps_emif_mem_0_mem_alert_n   ),
        .emif_hps_emif_mem_0_mem_dqs_t                                  ( emif_hps_emif_mem_0_mem_dqs_t     ),
        .emif_hps_emif_mem_0_mem_dqs_c                                  ( emif_hps_emif_mem_0_mem_dqs_c     ),
        .emif_hps_emif_mem_0_mem_dq                                     ( emif_hps_emif_mem_0_mem_dq        ),
        .emif_hps_emif_oct_0_oct_rzqin                                  ( emif_hps_emif_oct_0_oct_rzqin     ),
        .emif_hps_emif_ref_clk_0_clk                                    ( emif_hps_emif_ref_clk_0_clk       ),
        .hps_io_jtag_tck                                                ( hps_jtag_tck              ),
        .hps_io_jtag_tms                                                ( hps_jtag_tms              ),
        .hps_io_jtag_tdo                                                ( hps_jtag_tdo              ),
        .hps_io_jtag_tdi                                                ( hps_jtag_tdi              ),
        .hps_io_emac2_tx_clk                                            ( hps_emac2_TX_CLK          ),
        .hps_io_emac2_rx_clk                                            ( hps_emac2_RX_CLK          ),
        .hps_io_emac2_tx_ctl                                            ( hps_emac2_TX_CTL          ),
        .hps_io_emac2_rx_ctl                                            ( hps_emac2_RX_CTL          ),
        .hps_io_emac2_txd0                                              ( hps_emac2_TXD0            ),
        .hps_io_emac2_txd1                                              ( hps_emac2_TXD1            ),
        .hps_io_emac2_rxd0                                              ( hps_emac2_RXD0            ),
        .hps_io_emac2_rxd1                                              ( hps_emac2_RXD1            ),
        .hps_io_emac2_pps                                               ( hps_emac2_PPS             ),
        .hps_io_emac2_pps_trig                                          ( hps_emac2_PPS_TRIG        ),
        .hps_io_emac2_txd2                                              ( hps_emac2_TXD2            ),
        .hps_io_emac2_txd3                                              ( hps_emac2_TXD3            ),
        .hps_io_emac2_rxd2                                              ( hps_emac2_RXD2            ),
        .hps_io_emac2_rxd3                                              ( hps_emac2_RXD3            ),
        .hps_io_mdio2_mdio                                              ( hps_emac2_MDIO            ),
        .hps_io_mdio2_mdc                                               ( hps_emac2_MDC             ),
        .hps_io_sdmmc_cclk                                              ( hps_sdmmc_CCLK            ),
        .hps_io_sdmmc_cmd                                               ( hps_sdmmc_CMD             ),
        .hps_io_sdmmc_data0                                             ( hps_sdmmc_D0              ),
        .hps_io_sdmmc_data1                                             ( hps_sdmmc_D1              ),
        .hps_io_sdmmc_data2                                             ( hps_sdmmc_D2              ),
        .hps_io_sdmmc_data3                                             ( hps_sdmmc_D3              ),
        .hps_io_i3c1_sda                                                ( hps_i3c1_SDA              ),
        .hps_io_i3c1_scl                                                ( hps_i3c1_SCL              ),
        .hps_io_uart0_rx                                                ( hps_uart0_RX              ),
        .hps_io_uart0_tx                                                ( hps_uart0_TX              ),
        .usb31_io_vbus_det                                              ( usb31_io_vbus_det         ),
        .usb31_io_flt_bar                                               ( usb31_io_flt_bar          ),
        .usb31_io_usb_ctrl                                              ( usb31_io_usb_ctrl_int     ),
        .usb31_io_usb31_id                                              ( usb31_io_usb31_id         ),
        .usb31_phy_refclk_p_clk                                         ( usb31_phy_refclk_p_clk    ),
        //.usb31_phy_refclk_n_clk                                       ( usb31_phy_refclk_p_clk(n)             ),
        .usb31_phy_rx_serial_n_i_rx_serial_n                            ( usb31_phy_rx_serial_n_i_rx_serial_n ),
        .usb31_phy_rx_serial_p_i_rx_serial_p                            ( usb31_phy_rx_serial_p_i_rx_serial_p ),
        .usb31_phy_tx_serial_n_o_tx_serial_n                            ( usb31_phy_tx_serial_n_o_tx_serial_n ),
        .usb31_phy_tx_serial_p_o_tx_serial_p                            ( usb31_phy_tx_serial_p_o_tx_serial_p ),
        .usb31_phy_pma_cpu_clk_clk                                      ( o_pma_cpu_clk[1]          ),

        .o_pma_cu_clk_clk                                               ( o_pma_cpu_clk             ),
        //.i_refclk_bus_out_refclk_bus_out                                ( i_refclk_bus_out          ),
        .gts_inst_o_src_rs_grant_src_rs_grant                           ( o_src_rs_grant            ),      //  output,   width = 1,                           gts_inst_o_src_rs_grant.src_rs_grant
        .gts_inst_i_src_rs_priority_src_rs_priority                     ( 1'b0                      ),      //   input,   width = 1,                        gts_inst_i_src_rs_priority.src_rs_priority
        .gts_inst_i_src_rs_req_src_rs_req                               ( i_src_rs_req              ),      //   input,   width = 1,                             gts_inst_i_src_rs_req.src_rs_req

        .hps_io_usb1_clk                                                ( hps_usb1_CLK              ),
        .hps_io_usb1_stp                                                ( hps_usb1_STP              ),
        .hps_io_usb1_dir                                                ( hps_usb1_DIR              ),
        // Todo clarify for NXT or NXR
        .hps_io_usb1_nxt                                                ( hps_usb1_NXT              ),
        .hps_io_usb1_data0                                              ( hps_usb1_DATA0            ),
        .hps_io_usb1_data1                                              ( hps_usb1_DATA1            ),
        .hps_io_usb1_data2                                              ( hps_usb1_DATA2            ),
        .hps_io_usb1_data3                                              ( hps_usb1_DATA3            ),
        .hps_io_usb1_data4                                              ( hps_usb1_DATA4            ),
        .hps_io_usb1_data5                                              ( hps_usb1_DATA5            ),
        .hps_io_usb1_data6                                              ( hps_usb1_DATA6            ),
        .hps_io_usb1_data7                                              ( hps_usb1_DATA7            ),
        .hps_io_gpio0                                                   ( hps_gpio0_io0             ),
        .hps_io_gpio1                                                   ( hps_gpio0_io1             ),
        .hps_io_gpio11                                                  ( hps_gpio0_io11            ),
        .hps_io_gpio27                                                  ( hps_gpio1_io3             ),
        .hps_io_gpio28                                                  ( hps_gpio1_io4             ),
        .f2h_irq1_in_irq                                                ( f2h_irq1_irq              ),
        .hps_io_hps_osc_clk                                             ( hps_osc_clk               ),
        .h2f_reset_reset                                                ( h2f_reset                 ),
        .reset_reset_n                                                  ( combined_reset_n          ),
        // CPL Releated
		.memtg_ddr4_ss_0_cpl_mem_excr_0_tg_status_traffic_gen_pass      ( memtg_ddr4_tg_pass        ),     //  output,   width = 1,          memtg_ddr4_ss_0_cpl_mem_excr_0_tg_status.traffic_gen_pass
		.memtg_ddr4_ss_0_cpl_mem_excr_0_tg_status_traffic_gen_fail      ( memtg_ddr4_tg_fail        ),     //  output,   width = 1,                                                  .traffic_gen_fail
		.memtg_ddr4_ss_0_cpl_mem_excr_0_tg_status_traffic_gen_timeout   ( memtg_ddr4_tg_timeout     ),     //  output,   width = 1,                                                  .traffic_gen_timeout
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_cke            ( DDR4_COMP1_CKE            ),     //  output,   width = 1,       memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0.mem_cke
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_odt            ( DDR4_COMP1_ODT            ),     //  output,   width = 1,                                                  .mem_odt
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_cs_n           ( DDR4_COMP1_CS_N           ),     //  output,   width = 1,                                                  .mem_cs_n
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_a              ( DDR4_COMP1_A              ),     //  output,  width = 17,                                                  .mem_a
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_ba             ( DDR4_COMP1_BA             ),     //  output,   width = 2,                                                  .mem_ba
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_bg             ( DDR4_COMP1_BG             ),     //  output,   width = 2,                                                  .mem_bg
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_act_n          ( DDR4_COMP1_ACT_N          ),     //  output,   width = 1,                                                  .mem_act_n
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_par            ( DDR4_COMP1_PAR            ),     //  output,   width = 1,                                                  .mem_par
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_dq             ( DDR4_COMP1_DQ             ),     //   inout,  width = 40,                                                  .mem_dq
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_dqs_t          ( DDR4_COMP1_DQS_P          ),     //   inout,   width = 5,                                                  .mem_dqs_t
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_dqs_c          ( DDR4_COMP1_DQS_N          ),     //   inout,   width = 5,                                                  .mem_dqs_c
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_alert_n        ( DDR4_COMP1_ALERT_N        ),     //   input,   width = 1,                                                  .mem_alert_n
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_0_mem_dbi_n          ( DDR4_COMP1_DBI_N          ),     //   inout,   width = 5,                                                  .mem_dbi_n
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_ck_0_mem_ck_t        ( DDR4_COMP1_CK_P           ),     //  output,   width = 1,    memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_ck_0.mem_ck_t
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_ck_0_mem_ck_c        ( DDR4_COMP1_CK_N           ),     //  output,   width = 1,                                                  .mem_ck_c
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_reset_n_mem_reset_n  ( DDR4_COMP1_RESET_N        ),     //  output,   width = 1, memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_mem_reset_n.mem_reset_n
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_oct_0_oct_rzqin          ( RZQ_B_2B_RR               ),     //   input,   width = 1,       memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_oct_0.oct_rzqin
		.memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_ref_clk_clk              ( DDR4_COMP1_REFCLK_P       ),     //   input,   width = 1,     memtg_ddr4_ss_0_emif_io96b_ddr4comp_0_ref_clk.clk
		.memtg_ddr4_ss_0_usr_pll_locked_export                          ( ddr4_comp_usrpll_locked   ),     //  output,   width = 1,                    memtg_ddr4_ss_0_usr_pll_locked.export
		.memtg_ddr4_ss_0_sys_rst_in_reset_reset_n                       ( memtg_ddr4_comp_sys_rstn  ),
		.memtg_lpddr4_ss_0_cpl_mem_excr_0_tg_status_traffic_gen_pass    ( memtg_lpddr4_tg_pass      ),     //  output,   width = 1,        memtg_lpddr4_ss_0_cpl_mem_excr_0_tg_status.traffic_gen_pass
		.memtg_lpddr4_ss_0_cpl_mem_excr_0_tg_status_traffic_gen_fail    ( memtg_lpddr4_tg_fail      ),     //  output,   width = 1,                                                  .traffic_gen_fail
		.memtg_lpddr4_ss_0_cpl_mem_excr_0_tg_status_traffic_gen_timeout ( memtg_lpddr4_tg_timeout   ),     //  output,   width = 1,                                                  .traffic_gen_timeout
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_0_mem_cs             ( LPDDR4_CS_N0              ),     //  output,   width = 1,       memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_0.mem_cs
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_0_mem_ca             ( LPDDR4_CA                 ),     //  output,   width = 6,                                                  .mem_ca
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_0_mem_cke            ( LPDDR4_CKE_R0             ),     //  output,   width = 1,                                                  .mem_cke
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_0_mem_dq             ( LPDDR4_DQ                 ),     //   inout,  width = 32,                                                  .mem_dq
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_0_mem_dqs_t          ( LPDDR4_DQS_P              ),     //   inout,   width = 4,                                                  .mem_dqs_t
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_0_mem_dqs_c          ( LPDDR4_DQS_N              ),     //   inout,   width = 4,                                                  .mem_dqs_c
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_0_mem_dmi            ( LPDDR4_DM                 ),     //   inout,   width = 4,                                                  .mem_dmi
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_ck_0_mem_ck_t        ( LPDDR4_CK_P               ),     //  output,   width = 1,    memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_ck_0.mem_ck_t
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_ck_0_mem_ck_c        ( LPDDR4_CK_N               ),     //  output,   width = 1,                                                  .mem_ck_c
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_reset_n_mem_reset_n  ( LPDDR4_RESET_N            ),     //  output,   width = 1, memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_mem_reset_n.mem_reset_n
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_oct_0_oct_rzqin          ( RZQ_B_2A_RR               ),     //   input,   width = 1,       memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_oct_0.oct_rzqin
		.memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_ref_clk_clk              ( LPDDR4_REFCLK_P           ),     //   input,   width = 1,     memtg_lpddr4_ss_0_emif_io96b_lpddr4_0_ref_clk.clk
		.memtg_lpddr4_ss_0_usr_pll_locked_export                        ( lpddr4_comp_usrpll_locked ),     //  output,   width = 1,                  memtg_lpddr4_ss_0_usr_pll_locked.export
		.memtg_lpddr4_ss_0_sys_rst_in_reset_reset_n					    ( memtg_lpddr4_sys_rstn     ),
		.cpl_eth_tg_ss_0_intel_eth_gts_0_i_syspll_lock_o_pll_lock       ( o_pll_lock                ),   //   input,   width = 1,      cpl_eth_tg_ss_0_intel_eth_gts_0_i_syspll_lock.o_pll_lock
		.cpl_eth_tg_ss_0_intel_eth_gts_0_serial_o_tx_serial_data        ( o_tx_serial_data          ),   //  output,   width = 1,             cpl_eth_tg_ss_0_intel_eth_gts_0_serial.o_tx_serial_data
		.cpl_eth_tg_ss_0_intel_eth_gts_0_serial_i_rx_serial_data        ( i_rx_serial_data          ),   //   input,   width = 1,                                                   .i_rx_serial_data
		.cpl_eth_tg_ss_0_intel_eth_gts_0_serial_o_tx_serial_data_n      ( o_tx_serial_data_n        ),   //  output,   width = 1,                                                   .o_tx_serial_data_n
		.cpl_eth_tg_ss_0_intel_eth_gts_0_serial_i_rx_serial_data_n      ( i_rx_serial_data_n        ),   //   input,   width = 1,                                                   .i_rx_serial_data_n
		.cpl_eth_tg_ss_0_intel_eth_gts_0_i_clk_ref_p_clk                ( i_clk_ref_p               ),   //   input,   width = 1,        cpl_eth_tg_ss_0_intel_eth_gts_0_i_clk_ref_p.clk
		.cpl_eth_tg_ss_0_intel_eth_gts_0_src_rs_req_src_rs_req          ( i_src_rs_req              ),   //  output,   width = 1,         cpl_eth_tg_ss_0_intel_eth_gts_0_src_rs_req.src_rs_req
		.cpl_eth_tg_ss_0_intel_eth_gts_0_src_rs_grant_src_rs_grant      ( o_src_rs_grant            ),   //   input,   width = 1,       cpl_eth_tg_ss_0_intel_eth_gts_0_src_rs_grant.src_rs_grant
		.cpl_eth_tg_ss_0_intel_eth_gts_0_i_pma_cu_clk_clk               ( o_pma_cpu_clk[0]          ),   //   input,   width = 1,       cpl_eth_tg_ss_0_intel_eth_gts_0_i_pma_cu_clk.clk
		.cpl_eth_tg_ss_0_intel_systemclk_gts_0_o_pll_lock_o_pll_lock    ( o_pll_lock                ),   //  output,   width = 1,   cpl_eth_tg_ss_0_intel_systemclk_gts_0_o_pll_lock.o_pll_lock
		.cpl_eth_tg_ss_0_intel_systemclk_gts_0_refclk_xcvr_clk          ( i_clk_ref_p               ),   //   input,   width = 1,  cpl_eth_tg_ss_0_intel_systemclk_gts_0_refclk_xcvr.clk
		.cpl_eth_tg_ss_0_intel_systemclk_gts_0_i_refclk_rdy_data        ( 1'b1                      )    //   input,   width = 1, cpl_eth_tg_ss_0_intel_systemclk_gts_0_i_refclk_rdy.data

    );


    // Debounce logic to clean out glitches within 1ms
    debounce debounce_inst (
        .clk     (system_clk_100),
        .reset_n (~system_reset),
        .data_in (fpga_button_pio),
        .data_out(fpga_debounced_buttons)
    );
    defparam debounce_inst.WIDTH = 4; defparam debounce_inst.POLARITY = "LOW";
        defparam debounce_inst.TIMEOUT = 10000;  // at 100Mhz this is a debounce time of 1ms
    defparam debounce_inst.TIMEOUT_WIDTH = 32;  // ceil(log2(TIMEOUT))

    always @(posedge system_clk_100 or posedge system_reset) begin
        if (system_reset) heartbeat_count <= 23'd0;
        else heartbeat_count <= heartbeat_count + 23'd1;
    end

endmodule
