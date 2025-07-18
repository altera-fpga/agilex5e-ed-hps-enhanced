// Copyright (C) 2020 Intel Corporation.
// SPDX-License-Identifier: MIT

//
// Description
//-----------------------------------------------------------------------------
//
//  This package defines platform-specific parameters and types for
//  AXI-S interfaces to an Ethernet MAC. It is consumed by a platform-
//  independent wrapper, ofs_fim_eth_if_pkg.sv.
//
//----------------------------------------------------------------------------

`include "ofs_fim_eth_plat_defines.svh"
//`include "ofs_ip_cfg_db.vh" get ready to learn veriog include buddy
//
// Generated by OFS script iopll_get_cfg.tcl using qsys-script
//

`ifndef __OFS_FIM_IP_CFG_SYS_CLK__
`define __OFS_FIM_IP_CFG_SYS_CLK__ 1

//
// Clock frequencies and names
//
`define OFS_FIM_IP_CFG_SYS_CLK_CLK0_NAME     clk_sys
`define OFS_FIM_IP_CFG_SYS_CLK_CLK0_MHZ      470.0
`define OFS_FIM_IP_CFG_SYS_CLK_CLK0_MHZ_INT  470  // Nearest integer frequency

`define OFS_FIM_IP_CFG_SYS_CLK_CLK1_NAME     clk_100m
`define OFS_FIM_IP_CFG_SYS_CLK_CLK1_MHZ      100.0
`define OFS_FIM_IP_CFG_SYS_CLK_CLK1_MHZ_INT  100  // Nearest integer frequency

`define OFS_FIM_IP_CFG_SYS_CLK_CLK2_NAME     clk_sys_div2
`define OFS_FIM_IP_CFG_SYS_CLK_CLK2_MHZ      235.0
`define OFS_FIM_IP_CFG_SYS_CLK_CLK2_MHZ_INT  235  // Nearest integer frequency

`define OFS_FIM_IP_CFG_SYS_CLK_CLK3_NAME     clk_ptp_slv
`define OFS_FIM_IP_CFG_SYS_CLK_CLK3_MHZ      155.555556
`define OFS_FIM_IP_CFG_SYS_CLK_CLK3_MHZ_INT  156  // Nearest integer frequency

`define OFS_FIM_IP_CFG_SYS_CLK_CLK4_NAME     clk_50m
`define OFS_FIM_IP_CFG_SYS_CLK_CLK4_MHZ      50.0
`define OFS_FIM_IP_CFG_SYS_CLK_CLK4_MHZ_INT  50  // Nearest integer frequency

`define OFS_FIM_IP_CFG_SYS_CLK_CLK5_NAME     clk_sys_div4
`define OFS_FIM_IP_CFG_SYS_CLK_CLK5_MHZ      117.5
`define OFS_FIM_IP_CFG_SYS_CLK_CLK5_MHZ_INT  118  // Nearest integer frequency

`endif // `ifndef __OFS_FIM_IP_CFG_SYS_CLK__
//
// Generated by OFS script pcie_ss_get_cfg.tcl using qsys-script
//

`ifndef __OFS_FIM_IP_CFG_PCIE_SS__
`define __OFS_FIM_IP_CFG_PCIE_SS__ 1

//
// The OFS_FIM_IP_CFG_<ip_name>_PF<n>_ACTIVE macro will be defined iff the
// PF is active. The value does not have to be tested.
//
// For each active PF<n>, OFS_FIM_IP_CFG_<ip_name>_PF<n>_NUM_VFS will be
// defined iff there are VFs associated with the PF.
//
`define OFS_FIM_IP_CFG_PCIE_SS_PF0_ACTIVE 1
`define OFS_FIM_IP_CFG_PCIE_SS_PF0_BAR0_ADDR_WIDTH 21

`define OFS_FIM_IP_CFG_PCIE_SS_PF1_ACTIVE 1
`define OFS_FIM_IP_CFG_PCIE_SS_PF1_BAR0_ADDR_WIDTH 12


//
// The macros below represent the raw PF/VF configuration above in
// ways that are easier to process in SystemVerilog loops.
//

// Total number of PFs, not necessarily dense (see MAX_PF_NUM)
`define OFS_FIM_IP_CFG_PCIE_SS_NUM_PFS 2
// Total number of VFs across all PFs
`define OFS_FIM_IP_CFG_PCIE_SS_TOTAL_NUM_VFS 0
// Largest active PF number
`define OFS_FIM_IP_CFG_PCIE_SS_MAX_PF_NUM 1
// Largest number of VFs associated with a single PF
`define OFS_FIM_IP_CFG_PCIE_SS_MAX_VFS_PER_PF 0

// Vector indicating enabled PFs (1 if enabled) with
// index range 0 to OFS_FIM_IP_CFG_PCIE_SS_MAX_PF_NUM
`define OFS_FIM_IP_CFG_PCIE_SS_PF_ENABLED_VEC 1, 1
// Vector with the number of VFs indexed by PF
`define OFS_FIM_IP_CFG_PCIE_SS_NUM_VFS_VEC 0, 0


`endif // `ifndef __OFS_FIM_IP_CFG_PCIE_SS__
//
// Generated by OFS script pcie_ss_get_cfg.tcl using qsys-script
//

`ifndef __OFS_FIM_IP_CFG_SOC_PCIE_SS__
`define __OFS_FIM_IP_CFG_SOC_PCIE_SS__ 1

//
// The OFS_FIM_IP_CFG_<ip_name>_PF<n>_ACTIVE macro will be defined iff the
// PF is active. The value does not have to be tested.
//
// For each active PF<n>, OFS_FIM_IP_CFG_<ip_name>_PF<n>_NUM_VFS will be
// defined iff there are VFs associated with the PF.
//
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_PF0_ACTIVE 1
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_PF0_BAR0_ADDR_WIDTH 21
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_PF0_NUM_VFS 3
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_PF0_VF_BAR0_ADDR_WIDTH 21


//
// The macros below represent the raw PF/VF configuration above in
// ways that are easier to process in SystemVerilog loops.
//

// Total number of PFs, not necessarily dense (see MAX_PF_NUM)
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_NUM_PFS 1
// Total number of VFs across all PFs
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_TOTAL_NUM_VFS 3
// Largest active PF number
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_MAX_PF_NUM 0
// Largest number of VFs associated with a single PF
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_MAX_VFS_PER_PF 3

// Vector indicating enabled PFs (1 if enabled) with
// index range 0 to OFS_FIM_IP_CFG_SOC_PCIE_SS_MAX_PF_NUM
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_PF_ENABLED_VEC 1
// Vector with the number of VFs indexed by PF
`define OFS_FIM_IP_CFG_SOC_PCIE_SS_NUM_VFS_VEC 3


`endif // `ifndef __OFS_FIM_IP_CFG_SOC_PCIE_SS__
//
// Generated by OFS script hssi_ss_get_cfg.tcl using qsys-script
//

`ifndef __OFS_FIM_IP_CFG_HSSI_SS__
`define __OFS_FIM_IP_CFG_HSSI_SS__ 1

//
// The OFS_FIM_IP_CFG_<ip_name>_ETH_PORTS macro will be defined iff the
// port is active. The value does not have to be tested.
//

//
// The macros below represent the raw eth port configuration above in
// ways that are easier to process in SystemVerilog loops.
//

`define ETH_100G


`define INST_ALL_PORTS \
   `HSSI_PORT_INST(0) \
   `HSSI_PORT_INST(4) \


`define INCLUDE_HSSI_PORT_0
`define INCLUDE_HSSI_PORT_4

`define ENUM_PORT_INDEX PORT_0, PORT_4,


`define INST_ALL_LED_0(led_type, led_idx, operator) \
    `INST_LED(``led_type``,0,``led_idx``, operator) \

`define INST_ALL_LED_1(led_type, led_idx, operator) \
    `INST_LED(``led_type``,4,``led_idx``, operator) \


// Total number of ports, not necessarily dense (see MAX_PORT_NUM)
`define OFS_FIM_IP_CFG_HSSI_SS_NUM_ETH_PORTS 2
`define OFS_FIM_IP_CFG_HSSI_SS_ETH_PACKET_WIDTH 512
`define OFS_FIM_IP_CFG_HSSI_SS_NUM_LANES 4


`endif // `ifndef __OFS_FIM_IP_CFG_HSSI_SS__
//
// Generated by OFS script mem_ss_get_cfg.tcl using qsys-script
//

`ifndef __OFS_FIM_IP_CFG_MEM_SS__
`define __OFS_FIM_IP_CFG_MEM_SS__ 1


//
// Flags to enable memory channel instantiation/configuration
//
`define OFS_FIM_IP_CFG_MEM_SS_EN_MEM_3
`define OFS_FIM_IP_CFG_MEM_SS_EN_MEM_2
`define OFS_FIM_IP_CFG_MEM_SS_EN_MEM_1
`define OFS_FIM_IP_CFG_MEM_SS_EN_MEM_0
`define OFS_FIM_IP_CFG_MEM_SS_NUM_MEM_CHANNELS 4

//
// AXI-MM user interface configuration
//
`define OFS_FIM_IP_CFG_MEM_SS_DEFINES_USER_AXI 1
`define OFS_FIM_IP_CFG_MEM_SS_AXI_DATA_WIDTH 512
`define OFS_FIM_IP_CFG_MEM_SS_AXI_USER_WIDTH 1
`define OFS_FIM_IP_CFG_MEM_SS_AXI_LEN_WIDTH 8
`define OFS_FIM_IP_CFG_MEM_SS_AXI_ID_WIDTH 9
`define OFS_FIM_IP_CFG_MEM_SS_AXI_ADDR_WIDTH 32

//
// Fabric EMIF interface configuration
//
`define OFS_FIM_IP_CFG_MEM_SS_DEFINES_EMIF_DDR4 1
`define OFS_FIM_IP_CFG_MEM_SS_DDR4_A_WIDTH 17
`define OFS_FIM_IP_CFG_MEM_SS_DDR4_BA_WIDTH 2
`define OFS_FIM_IP_CFG_MEM_SS_DDR4_BG_WIDTH 1
`define OFS_FIM_IP_CFG_MEM_SS_DDR4_CK_WIDTH 1
`define OFS_FIM_IP_CFG_MEM_SS_DDR4_CKE_WIDTH 1
`define OFS_FIM_IP_CFG_MEM_SS_DDR4_CS_N_WIDTH 1
`define OFS_FIM_IP_CFG_MEM_SS_DDR4_ODT_WIDTH 1
`define OFS_FIM_IP_CFG_MEM_SS_DDR4_DQ_WIDTH 32

`endif // `ifndef __OFS_FIM_IP_CFG_MEM_SS__

package ofs_fim_eth_plat_if_pkg;

localparam MAX_NUM_ETH_CHANNELS = 16;                                    // Ethernet Ports
localparam NUM_QSFP_PORTS       = 2;                                     // QSFP cage on board
localparam NUM_ETH_CHANNELS     = `OFS_FIM_IP_CFG_HSSI_SS_NUM_ETH_PORTS; // Ethernet Ports
localparam NUM_QSFP_LANES       = 4;                                     // Lanes/QSFP
localparam NUM_CVL_LANES        = 0;                                     // Number for Lanes for CVL
localparam NUM_LANES            = `OFS_FIM_IP_CFG_HSSI_SS_NUM_LANES;     // XCVR Lanes/Port
localparam ETH_PACKET_WIDTH     = 64;//`OFS_FIM_IP_CFG_HSSI_SS_ETH_PACKET_WIDTH;

localparam ETH_RX_ERROR_WIDTH = 6;
localparam ETH_TX_ERROR_WIDTH = 1;

localparam ETH_RX_USER_CLIENT_WIDTH       = 7;
localparam ETH_RX_USER_STS_WIDTH          = 5;
localparam ETH_TX_USER_CLIENT_WIDTH       = 2;
localparam ETH_TX_USER_PTP_WIDTH          = 94;
localparam ETH_TX_USER_PTP_EXTENDED_WIDTH = 328;

//----------------HE-HSSI related---------
typedef struct packed {
   // Error
   logic [ETH_RX_ERROR_WIDTH-1:0] error;
} t_axis_eth_rx_tuser;

typedef struct packed {
   // Error
   logic [ETH_TX_ERROR_WIDTH-1:0] error;
} t_axis_eth_tx_tuser;

typedef struct packed {
   // Mapped to MAC's avalon_st_pause_data[1]
   logic pause_xoff;
   // Mapped to MAC's avalon_st_pause_data[0]
   logic pause_xon;
   logic [7:0] pfc_xoff;
} t_eth_sideband_to_mac;

// Not currently used
typedef struct packed {
   logic pfc_pause;
} t_eth_sideband_from_mac;

//----------------HSSI SS related---------

// SS user bits
typedef struct packed {
   logic [ETH_RX_USER_STS_WIDTH-1:0]    sts;
   logic [ETH_RX_USER_CLIENT_WIDTH-1:0] client;
} t_axis_hssi_ss_rx_tuser;

typedef struct packed {
`ifdef INCLUDE_PTP
   logic [ETH_TX_USER_PTP_EXTENDED_WIDTH-1:0] ptp_extended;
   logic [ETH_TX_USER_PTP_WIDTH-1:0]          ptp;
`endif
   logic [ETH_TX_USER_CLIENT_WIDTH-1:0]       client;
} t_axis_hssi_ss_tx_tuser;


// Clocks exported by the MAC for use by the AFU. The primary "clk" is
// guaranteed. Others are platform-specific.
typedef struct packed {
   logic clk;
   logic rst_n;

   logic clkDiv2;
   logic rstDiv2_n;
} t_eth_clocks;

endpackage
