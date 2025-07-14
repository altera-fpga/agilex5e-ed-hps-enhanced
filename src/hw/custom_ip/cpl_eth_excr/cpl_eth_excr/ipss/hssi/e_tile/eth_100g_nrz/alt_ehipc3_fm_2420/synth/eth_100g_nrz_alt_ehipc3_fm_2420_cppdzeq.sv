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


//------------------------------------------------------------------------------
// 100G Ethernet IP core top level with Avalon Streaming Interface
//------------------------------------------------------------------------------
`timescale 1ps/1ps

(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)

module eth_100g_nrz_alt_ehipc3_fm_2420_cppdzeq
  #(
// TODO Later convert this to terp file and  that time make this as 4 which will be set in hw.tcl
// also empty_bits will be set in hw.tcl, for 50G = 4 (log2(width/8)) and 100G = 5
    parameter num_lanes = 4,  // 4 for 100G, 1,2,3,4 for 10/25G
    parameter sl_num_lanes = 4,
    parameter max_refclk = 1,
    parameter max_ch = 1,
    parameter max_xcvr_ch = 4,
    parameter max_clkout = 1,
    parameter max_clkout_ch = 4,
    parameter empty_bits = 6,
    parameter enable_rsfec_rst_ports = 0,
    parameter silicon_rev  = "10nm6bcr3a",
    parameter bti_preserve = 0,
    //                                                    DEFAULT_VALUE                    ALLOWED_RANGES
    parameter duplex_mode                       	= "enable" ,        //             {"disable" "enable"}
    parameter powerdown_mode                    	= "powerup" ,       //             {"powerdown" "powerup"}
    parameter sup_mode                          	= "user_mode" ,     //             {"advanced_user_mode" "engineering_mode" "user_mode"}
    //parameter silicon_rev                       	= "14NM5CR2" ,      //             {"14nm4cr2" "14nm4cr2ea" "14nm5bcr2b" "14nm5cr2" "14nm5cr2ea"}
    parameter [23:0] am_encoding40g_0                  	= 24'd9467463,      //             {0:16777215}
    parameter [23:0] am_encoding40g_1                  	= 24'd15779046,     //             {0:16777215}
    parameter [23:0] am_encoding40g_2                  	= 24'd12936603,     //             {0:16777215}
    parameter [23:0] am_encoding40g_3                  	= 24'd10647869,     //             {0:16777215}
    parameter [6:0] ber_invalid_count                 	= 7'd97,            //             {0:127}
    parameter [5:0] cfgonly_bypass_select               = 6'd0,             //             {0:127}
    parameter crete_type                        	= "crete3" ,        //             {"crete2e" "crete3"}
    parameter deskew_clear                      	= "disable",        //             {"disable" "enable"}
    parameter disable_link_fault_rf             	= "disable",        //             {"disable" "enable"}
    parameter [31:0] ehip_clk_hz                      	= 32'd0,            //             {0:2147483647}
    parameter ehip_clk_sel                      	= "datapath_clock" ,//             {"datapath_clock" "fec_clock" "no_clock" "shared_clock"}
    parameter [2:0] ehip_dist_clk_sel                 	= 3'd0,             //             {0:7}
    parameter ehip_mode                         	= "ehip_mac_no_fec" ,//            {"ehip_lb_txmac_rxmac" "ehip_lb_txmac_rxmac_ptp" "ehip_lb_txpcs_rxaib" "ehip_lb_txpcs_rxmac" "ehip_lb_txpcs_rxpcs" "ehip_lb_tx_rx" "ehip_lb_tx_rx_ptp" "ehip_mac" "ehip_mac_no_fec" "ehip_mac_ptp" "ehip_mac_ptp_no_fec" "ehip_otn" "ehip_otn_no_fec" "ehip_pcs" "ehip_pcs66" "ehip_pcs66_no_fec" "ehip_pcs_no_fec" "ehip_standby"}
    parameter ehip_rate                         	= "rate_100gx4" ,   //             {"custom_rate_100gx4" "custom_rate_10gx1" "custom_rate_25gx1" "custom_rate_25gx1_fec" "custom_rate_40gx4" "custom_rate_50gx2" "custom_rate_50gx4" "rate_100gx4" "rate_10gx1" "rate_10gx1_25lr" "rate_25gx1" "rate_25gx1_fec" "rate_40gx4" "rate_50gx2" "rate_50gx4"}
    parameter ehip_type                         	= "multi_lane" ,    //             {"multi_lane" "single_lane"}
    parameter enable_rx_stats_snapshot          	= "enable" ,        //             {"disable" "enable"}
    parameter enable_tx_stats_snapshot          	= "enable" ,        //             {"disable" "enable"}
    parameter enforce_max_frame_size            	= "disable" ,       //             {"disable" "enable"}
    parameter [2:0] fec_dist_clk_sel                  	= 3'd4,             //             {0:7}
    parameter flow_control                      	= "both_no_xoff" ,  //             {"both" "both_no_xoff" "none" "pfc" "pfc_no_xoff" "sfc" "sfc_no_xoff"}
    parameter flow_control_sl_0                      	= "both_no_xoff" ,  //             {"both" "both_no_xoff" "none" "pfc" "pfc_no_xoff" "sfc" "sfc_no_xoff"}
    parameter flow_control_holdoff_mode         	= "per_queue" ,     //             {"no_holdoff" "per_queue" "uniform"}
    parameter force_deskew_done                 	= "disable" ,       //             {"disable" "enable"}
    parameter force_hip_ready                   	= "disable" ,       //             {"disable" "enable"}
    parameter force_link_fault_rf               	= "disable" ,       //             {"disable" "enable"}
    parameter forward_rx_pause_requests         	= "disable" ,       //             {"disable" "enable"}
    parameter func_mode                         	= "enable" ,        //             {"disable" "enable"}
    parameter hi_ber_monitor                    	= "enable" ,        //             {"disable" "enable"}
    parameter [15:0] holdoff_quanta                    	= 16'd65535,        //             {0:65535}
    parameter [15:0] ipg_removed_per_am_period         	= 16'd20,           //             {0:65535}
    parameter is_usr_avmm                       	= "false" ,         //             {"false" "true"}
    parameter keep_rx_crc                       	= "disable" ,       //             {"disable" "enable"}
    parameter link_fault_mode                   	= "lf_off" ,        //             {"lf_bidir" "lf_off" "lf_unidir"}
    parameter [15:0] pause_quanta                      	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_holdoff_quanta_0              	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_holdoff_quanta_1              	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_holdoff_quanta_2              	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_holdoff_quanta_3              	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_holdoff_quanta_4              	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_holdoff_quanta_5              	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_holdoff_quanta_6              	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_holdoff_quanta_7              	= 16'd32768,        //             {0:65535}
    parameter [15:0] pfc_pause_quanta_0                	= 16'd65535,        //             {0:65535}
    parameter [15:0] pfc_pause_quanta_1                	= 16'd65535,        //             {0:65535}
    parameter [15:0] pfc_pause_quanta_2                	= 16'd65535,        //             {0:65535}
    parameter [15:0] pfc_pause_quanta_3                	= 16'd65535,        //             {0:65535}
    parameter [15:0] pfc_pause_quanta_4                	= 16'd65535,        //             {0:65535}
    parameter [15:0] pfc_pause_quanta_5                	= 16'd65535,        //             {0:65535}
    parameter [15:0] pfc_pause_quanta_6                	= 16'd65535,        //             {0:65535}
    parameter [15:0] pfc_pause_quanta_7                	= 16'd65535,        //             {0:65535}
    parameter powermode_ac_mac                  	= "mac_off" ,       //             {"mac_off" "mac_on_1_lane_noptp" "mac_on_1_lane_ptp" "mac_on_2_lane" "mac_on_4_lane_noptp"}
    parameter powermode_ac_misc                 	= "misc_off" ,      //             {"misc_off" "misc_on"}
    parameter powermode_ac_pcs                  	= "pcs_on_4_lane_norsfec" , //     {"pcs_off" "pcs_on_1_lane_norsfec" "pcs_on_1_lane_rsfec" "pcs_on_2_lane" "pcs_on_4_lane_norsfec" "pcs_on_4_lane_rsfec"
    parameter powermode_ac_pld                  	= "pld_off" ,       //             {"pld_off" "pld_on_1_lane_noptp" "pld_on_1_lane_ptp" "pld_on_2_lane" "pld_on_4_lane_noptp" }
    parameter powermode_dc                      	= "powerup_dc" ,    //             {"powerdown_dc" "powerup_dc"}
    parameter ptp_debug                         	= "0" ,             //             NOVAL
    parameter rx_aib_dp_latency                 	= "0",              //             NOVAL
    parameter ptp_timestamp_format              	= "v2" ,            //             {"v1" "v2"}
    parameter ptp_tx_timestamp_method           	= "ptp_1step" ,     //             {"ptp_1step" "ptp_2step"}
    parameter remove_pads                       	= "disable" ,       //             {"disable" "enable"}
    parameter rx_am_interval                    	= "standard_100g_am_interval" , // {"no_rx_am_interval" "sim_only_40g_am_interval" "sim_only_50g_am_interval" "sim_only_am_inte}
    parameter [19:0] rx_clock_period                   	= 20'd162689,       //             {0:1048575}
    parameter rx_datapath_soft_rst              	= "disable" ,       //             {"disable" "enable"}
    parameter rx_length_checking                	= "enable" ,        //             {"disable" "enable"}
    parameter rx_mac_soft_rst                   	= "disable" ,       //             {"disable" "enable"}
    parameter [15:0] rx_max_frame_size                 	= 16'd1518,         //             {0:65535}
    parameter rx_pause_daddr                    	= "1652522221569",  //             "1652522221569" ,
    parameter [5:0] rx_pcs_max_skew                   	= 6'd47,            //             {0:63}
    parameter rx_pcs_soft_rst                   	= "disable" ,       //             {"disable" "enable"}
    parameter rx_preamble_passthrough           	= "disable" ,       //             {"disable" "enable"}
    parameter rx_ptp_dp_latency                 	= "0",              //             0
    parameter rx_ptp_extra_latency              	= "0",              //             0
    parameter rx_vlan_detection                 	= "enable" ,        //             {"disable" "enable"}
    parameter rxcrc_covers_preamble             	= "disable" ,       //             {"disable" "enable"}
    parameter sim_mode                          	= "disable" ,       //             {"disable" "enable"}
    parameter source_address_insertion          	= "disable" ,       //             {"disable" "enable"}
    parameter strict_preamble_checking          	= "disable" ,       //             {"disable" "enable"}
    parameter strict_sfd_checking               	= "disable" ,       //             {"disable" "enable"}
    parameter topology                          	= "ehip_ptp" ,      //             {"dirfec_100g" "dirfec_1ch" "dirfec_ptp" "dirfec_3ch" "dirfec_4ch" "disabled_block" "disabled_system" "ehip_ptp" "ehip_ptp_ptp" "ehip_4ch" "ehip_4ch_fec" "ehip_4ch_ptp" "ehip_4ch_ptp_fec" "elane_1ch" "elane_1ch_fec" "elane_1ch_ptp" "elane_1ch_ptp_fec" "elane_ptp_fec" "elane_ptp_ptp" "elane_ptp_ptp_fec" "elane_3ch_fec" "elane_3ch_ptp" "elane_3ch_ptp_fec" "elane_4ch_fec" "elane_4ch_ptp" "elane_4ch_ptp_fec" "pcs_gearbox_ch" "pmadir_1ch" "pmadir_ptp" "pmadir_pllch" "pmadir_refclkch" "ptp_pllch" "rsvd_topo1" "rsvd_topo2"}
    parameter tx_aib_dp_latency                 	= "0" ,             //             NOVAL
    parameter tx_am_period                      	= "standard_100g_am_period" , //   {"no_tx_am_period" "sim_only_100g_fec_am_period" "sim_only_25g_fec_am_period" "sim_only_40g_}
    parameter [19:0] tx_clock_period                   	= 20'd162689,       //             {0:1048575}
    parameter tx_datapath_soft_rst              	= "disable" ,       //             {"disable" "enable"}
    parameter tx_ipg_size                       	= "ipg_12" ,        //             {"ipg_1" "ipg_10" "ipg_12" "ipg_8"}
    parameter tx_mac_data_flow                  	= "enable" ,        //             {"disable" "enable"}
    parameter tx_mac_soft_rst                   	= "disable" ,       //             {"disable" "enable"}
    parameter [15:0] tx_max_frame_size                 	= 16'd1518,         //             {0:65535}
    parameter tx_pause_daddr                    	= "1652522221569",  //             "1652522221569"
    parameter tx_pause_saddr                    	= "247393538562781",//             "247393538562781"
    parameter tx_pcs_soft_rst                   	= "disable" ,       //             {"disable" "enable"}
    parameter [4:0] tx_pld_fifo_almost_full_level     	= 5'd16,            //             {0:31}
    parameter tx_preamble_passthrough           	= "disable" ,       //             {"disable" "enable"}
    parameter tx_ptp_asym_latency               	= "0",              //             NOVAL
    parameter tx_ptp_dp_latency                 	= "0",              //             NOVAL
    parameter tx_ptp_extra_latency              	= "0",              //             NOVAL
    parameter tx_vlan_detection                 	= "enable" ,        //             {"disable" "enable"}
    parameter txcrc_covers_preamble             	= "disable" ,       //             {"disable" "enable"}
    parameter txmac_saddr                       	= "73588229205",    //             "73588229205"
    parameter [15:0] uniform_holdoff_quanta            	= 16'd65535,        //             {0:65535}
    parameter use_am_insert                     	= "disable" ,       //             {"disable" "enable"}
    parameter use_lane_ptp                      	= "disable" ,       //             {"disable" "enable"}
    parameter use_testbus                       	= "disable" ,       //             {"disable" "enable"}
    parameter [20:0] xus_timer_window                  	= 21'd201415,       //             {0:2097151}
    parameter [8:0] request_tx_pause                  	= 9'd0 ,            //             {0:511}
    parameter reset_rx_stats                    	= "disable" ,       //             {"disable" "enable"}
    parameter reset_rx_stats_parity_error       	= "disable" ,       //             {"disable" "enable"}
    parameter reset_tx_stats                    	= "disable" ,       //             {"disable" "enable"}
    parameter reset_tx_stats_parity_error       	= "disable" ,       //             {"disable" "enable"}
    parameter check_random_idles                	= "disable",        //             {"disable" "enable"}
    parameter use_factory_settings                	= "true",           //             {"disable" "enable"}
    // Adapter paremeter
    parameter ready_latency = 1,
    parameter ready_latency_sl = 1,
    // AN/LT parameters
    parameter STATUS_CLK_KHZ        = 100000,
    parameter ENABLE_ANLT           = 0,
    parameter ENABLE_AN              = 1,
    parameter LINK_TIMER_KR         = 504,
    parameter AN_CHAN               = 1,
    parameter AN_PAUSE              = 2,
    parameter ENABLE_LT              = 1,
    parameter REQUEST_RSFEC			= 0,
    parameter ENABLE_RSFEC            = 0,
    parameter EN_DYN_FEC	    = 0,
    parameter TECH_ABL              = 0,
    parameter CR_MODE			= 0,
    parameter ENABLE_ASYNC_ADAPTERS = 0,
    parameter ENABLE_ASYNC_ADAPTERS_SL = 0,
    parameter ENHANCED_PTP_ACCURACY = 0,
    parameter ENHANCED_PTP_DBG = 0,
//adding new C3 parameters -- Kruthika
    parameter core_variant         = 0,
    parameter active_channel        = 0,
    parameter device_revision       = "14nm5bcr3",
    parameter ENABLE_PTP            = 0,
    parameter ENABLE_PTP_TOG        = 0,
    parameter USE_PTP_PLLCH         = 1,
    parameter ENABLE_PTP_RX_DESKEW  = 0,
    parameter ENABLE_PTP_REF_LANE   = 1,
    parameter enable_external_aib_clocking = 0,
    parameter SL_OPT                = 2,               //             {"0:32G" "1:40G" "2:53G" "3:56G"}
    parameter  PHY_REFCLK       = 156.250000,
    parameter  PHY_REFCLK_sl_0       = 156.250000,
    parameter EHIP_LOCATION         = 0,
//adding 25G parameters --Kruthika
    // Single lane specific parameters
    parameter include_alternate_ports_sl_0 = 0,
    parameter tx_preamble_passthrough_sl_0 = "disable" , //                    {"disable" "enable"}
    parameter ehip_mode_sl_0        = "ehip_disable", //            {"ehip_lb_txmac_rxmac" "ehip_lb_txmac_rxmac_ptp" "ehip_lb_txpcs_rxaib" "ehip_lb_txpcs_rxmac" "ehip_lb_txpcs_rxpcs" "ehip_lb_tx_rx" "ehip_lb_tx_rx_ptp" "ehip_mac" "ehip_mac_no_fec" "ehip_mac_ptp" "ehip_mac_ptp_no_fec" "ehip_otn" "ehip_otn_no_fec" "ehip_pcs" "ehip_pcs66" "ehip_pcs66_no_fec" "ehip_pcs_no_fec" "ehip_standby"}
    parameter ehip_rate_sl_0        = "rate_25gx1", //                {"custom_rate_100gx4" "custom_rate_10gx1" "custom_rate_25gx1" "custom_rate_25gx1_fec" "rate_100gx4" "rate_10gx1" "rate_10gx1_25lr" "rate_25gx1" "rate_25gx1_fec"}
    parameter ENABLE_JTAG_AVMM                          = 0,
    parameter ENABLE_SYNCE                              = 0,
    parameter disable_internal_dr                                 =0,
    parameter dis_anlt_std_recipe      = 0
    )
   (


    // Clock and Resets
   input wire [max_refclk-1:0]	            i_clk_ref, //Native PHY IP reference clock

   input wire 				    i_clk_tx, //TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div64 to this
   input wire 				    i_clk_rx, //RX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div64 to this
   input  wire [sl_num_lanes-1:0]           i_sl_clk_tx, //TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div64 to this
   input  wire [sl_num_lanes-1:0]           i_sl_clk_rx, //TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div64 to this
   input  wire [sl_num_lanes-1:0]           i_sl_clk_tx_tod, //TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div66 to this
   input  wire [sl_num_lanes-1:0]           i_sl_clk_rx_tod, //TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div66 to this
   input  wire [sl_num_lanes-1:0]           i_sl_async_clk_tx, //TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div66 to this
   input  wire [sl_num_lanes-1:0]           i_sl_async_clk_rx, //TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div66 to this
   input                                    i_aib_clk,       // External clock input for AIB
   input                                    i_aib_2x_clk,    // External clock input for AIB at 2x frequency of i_aib_clk
   output wire [max_clkout-1:0]		    o_clk_pll_div64, // this is /64 clock (402.83 MHz) EHIP system clock
   output wire [max_clkout-1:0]		    o_clk_pll_div66, // this is /66 clock (390.625 MHz) EHIP system clock times 64/66
   output wire [max_clkout-1:0]		    o_clk_rec_div64, // this is /64 clock (402.83 MHz), receovered clock
   output wire [max_clkout-1:0]		    o_clk_rec_div66, // this is /66 clock (390.625 MHz), receovered clock
   input wire 				    i_csr_rst_n, // Resets the entire Ethernet core. Active low.
   input wire 				    i_tx_rst_n, //Resets the TX digital path (Ethernet MAC and Ethernet PCS)
   input wire 				    i_rx_rst_n, // Resets the RX digital path (Ethernet MAC, PCS)
   input wire [sl_num_lanes-1:0]            i_sl_csr_rst_n, // Resets the entire Ethernet core. Active low.
   input wire [sl_num_lanes-1:0]            i_sl_tx_rst_n, //Resets the TX digital path (Ethernet MAC and Ethernet PCS)
   input wire [sl_num_lanes-1:0]            i_sl_rx_rst_n, // Resets the RX digital path (Ethernet MAC, PCS)
   input wire 				    i_rsfec_rst_n, //Resets the RSFEC block
   input wire 				    i_rsfec_tx_rst_n, //Resets the TX digital path (RSFEC)
   input wire 				    i_rsfec_rx_rst_n, // Resets the RX digital path (RSFEC)

    // High speed serial Pins
   input  wire [max_xcvr_ch-1:0]            i_rx_serial,
   output wire [max_xcvr_ch-1:0]            o_tx_serial,
   input  wire [max_xcvr_ch-1:0]            i_rx_serial_n,
   output wire [max_xcvr_ch-1:0]            o_tx_serial_n,

    // TX MAC Interface
   input wire 			    	    i_tx_pause, //  Only available if pause flow control is enabled. Asserted to send a pause frame.
   input wire [7:0] 			    i_tx_pfc, //  Only available if priority flow control is enabled. Used to send a pfc frame
   output wire 				    o_tx_ready, // Indicates that the MAC is ready to accept new data.

   input wire [23:0]          i_ptp_ins_type,
   input wire [23:0]          i_ptp_byte_offset,
   input wire [95:0]          i_ptp_ing_ts_tb,
   input wire [7:0]           i_ptp_fp_tb,

   input  wire [11:0]         o_ptp_ins_type,
   input  wire [11:0]         o_ptp_byte_offset,
   input  wire [7:0]          o_ptp_fp_tb,
   input  wire [95:0]         o_ptp_ing_ts_tb,


   input  wire [num_lanes-1:0]                i_sclk,
   input  wire [num_lanes-1:0]                i_tx_sel_sclk_return,
   input  wire [num_lanes-1:0]                i_rx_sel_sclk_return,
   output wire [num_lanes-1:0]                o_tx_sclk_return,
   output wire [num_lanes-1:0]                o_rx_sclk_return,
   output wire [4-1:0]                o_tx_am,
   output wire [4-1:0]                o_rx_am,

   input  wire [4:0]                        i_select_ptp_vl_data,       //[4:0]
   input  wire                              i_read_ptp_vl_data,         // input

   output   logic   [4-1:0]                 o_ptp_tx_ts_valid,
   output   logic   [47:0]                  o_ptp_tx_ts,
   output   logic   [7:0]                   o_ptp_tx_fp,
   output   logic   [83:0]                  o_ptp_rx_ts,
   output   logic                           o_ptp_reading_vl_data,


   input      [255:0]                      int_tx_data_0,
   input                                   int_tx_valid_0,
   input      [num_lanes-1:0]              int_tx_inframe_0,
   input      [11:0]                       int_tx_empty_0,
   input      [num_lanes-1:0]              int_tx_error_0,
   input      [num_lanes-1:0]              int_tx_skip_crc_0,
   output                                  int_tx_ready_r_0,

   output [num_lanes-1:0]         dsk_rx_inframe_0,
   output [64*num_lanes-1:0]      dsk_rx_data_0,
   output                         dsk_rx_valid_0,
   output [num_lanes*3-1:0]       dsk_rx_empty_0,
   output [num_lanes*2-1:0]       dsk_rx_error_0,
   output [num_lanes-1:0]         dsk_rx_fcs_error_0,
   output [num_lanes*3-1:0]       dsk_rx_status_0,

    // TX MAC Interface
   input wire [64*8-1:0] 	i_tx_data, //Input data to the MAC. Bits 0 is the LSB.(clk_txmc clk domain)
   input wire 								i_tx_valid, //Indicates data TX data is valid. Must remain high throughout transmission of packet
   input wire 								i_tx_startofpacket, //Start of packet (SOP). Asserted for one cycle at the beginning of frame


   input wire 								i_tx_endofpacket, //End of packet (EOP). Asserted for one cycle on the last cycle of the frame
    // tx_empty depends on number of words or width of the bus, it is 4 bits for 50G [log2(width/8) = log2 (128/8) = log2(16) = 4] for 100G = log2(32) = 5
   input wire [empty_bits-1:0] 						i_tx_empty, // Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted.
   input wire 								i_tx_error, // A valid high on this signal aligned with an eop will cause the tx frame to be treated as an error.
   input wire 								i_tx_skip_crc,

   output wire [64*8-1:0] o_rx_data, // output data from the MAC, Bit 0 is LSB
   output wire                                                          o_rx_valid, // Indicates data RX data, EOP, and SOP are valid.
   output wire                                                          o_rx_startofpacket, // Start of packet (SOP). Asserted for one cycle at the beginning of frame
   output wire                                                          o_rx_endofpacket, // End of packet (EOP). Asserted for one cycle on the last cycle of the frame
   output wire [empty_bits-1:0]                                         o_rx_empty, // Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted.
   output wire [5:0]                                                    o_rx_error, // RX error bits asserted on the EOP cycle.[0] : malformed block, [1] : crc error, [2] : reserved, [3] : reserved, [4] : length error, [5] : reserved
   output wire [39:0]                                                   o_rxstatus_data, //RX frame status information. Valid on EOP cycle.[0:31] : reserved, [32] : stacked vlan frame ,[33] : vlan frame ,[34] : control frame, [35] : pause frame, [36:38] : reserved, [39] : pfc frame
   output wire                                                          o_rxstatus_valid, //asserted to indicate that bits on o_rxstatus_data are valid
   output wire                                                          o_rx_pause, //Indicates that a pause frame was received.
   output wire [7:0]                                                    o_rx_pfc, //Indicates that a pfc frame was received for priority queue n, where n is the bit number that was asserted.

   input  wire [64*sl_num_lanes-1:0]         i_sl_tx_data,          // Input data to the MAC. Bits 0 is the LSB
   input  wire [sl_num_lanes-1:0]            i_sl_tx_valid,         // Indicates data TX data is valid. Must remain high throughout transmission of packet
   input  wire [sl_num_lanes-1:0]            i_sl_tx_startofpacket, // Start of packet (SOP). Asserted for one cycle at the beginning of frame
   input  wire [sl_num_lanes-1:0]            i_sl_tx_endofpacket,   // End of packet (EOP). Asserted for one cycle on the last cycle of the frame
   input  wire [3*sl_num_lanes-1:0]          i_sl_tx_empty,         // Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted.
   input  wire [sl_num_lanes-1:0]            i_sl_tx_error,         // A valid high on this signal aligned with an eop will cause the tx frame to be treated as an error.
   input  wire [sl_num_lanes-1:0]            i_sl_tx_pause,         // Only available if pause flow control is enabled. Asserted to send a pause frame.
   input  wire [8*sl_num_lanes-1:0]          i_sl_tx_pfc,           // Only available if priority flow control is enabled. Used to send a pfc frame
   input  wire [sl_num_lanes-1:0]            i_sl_tx_skip_crc,
   output wire [sl_num_lanes-1:0]            o_sl_tx_ready,         // Indicates that the MAC is ready to accept new data.

   // RX MAC Interface
   output wire [64*sl_num_lanes-1:0]        o_sl_rx_data,           // output data from the MAC, Bit 0 is LSB
   output wire [sl_num_lanes-1:0]           o_sl_rx_valid,          // Indicates data RX data, EOP, and SOP are valid.
   output wire [sl_num_lanes-1:0]           o_sl_rx_startofpacket,  // Start of packet (SOP). Asserted for one cycle at the beginning of frame
   output wire [sl_num_lanes-1:0]           o_sl_rx_endofpacket,    // End of packet (EOP). Asserted for one cycle on the last cycle of the frame
   output wire [3*sl_num_lanes-1:0]         o_sl_rx_empty,          // Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted.
   output wire [6*sl_num_lanes-1:0]         o_sl_rx_error,          // RX error bits asserted on the EOP cycle.[0] : malformed block, [1] : crc error, [2] : reserved, [3] : reserved, [4] : length error, [5] : reserved
   output wire [40*sl_num_lanes-1:0]        o_sl_rxstatus_data,     // RX frame status information. Valid on EOP cycle.[0:31] : reserved, [32] : stacked vlan frame ,[33] : vlan frame ,[34] : control frame, [35] : pause frame, [36:38] : reserved, [39] : pfc frame
   output wire [sl_num_lanes-1:0]           o_sl_rxstatus_valid,    // asserted to indicate that bits on o_rxstatus_data are valid
   output wire [sl_num_lanes-1:0]           o_sl_rx_pause,          // Indicates that a pause frame was received.
   output wire [8*sl_num_lanes-1:0]         o_sl_rx_pfc,            // Indicates that a pfc frame was received for priority queue n, where n is the bit number that was asserted.

   // Status
   output wire 								o_tx_lanes_stable, //Asserted when TX MAC is ready to send data
   output wire 								o_rx_pcs_ready, //Asserted when RX PCS is ready to receive data
   output wire 								o_rx_block_lock, //Asserted when 66b block alignment is finished on all PCS lanes
   output wire 								o_rx_am_lock, // Asserted when RX PCS has found detected alignment markers and deskewed PCS lanes.
   output wire 								o_local_fault_status, //The RX PCS has detected a problem that prevents it from being able to receive data
   output wire 								o_remote_fault_status, // The remote link partner has sent remote fault ordered sets indicating that it is unable to receive data.
   output wire [max_ch-1:0]					o_cdr_lock, //Signal to indicate that the PMA has locked to data.
   output wire 								o_rx_hi_ber, //Signal to indicate that the PMA has locked to data.
   output wire 								o_ehip_ready, //Signal to indicate that EHIP CSRs are ready.
   output wire [max_ch-1:0]					o_tx_pll_locked, //Signal to indicate that the TX PLL has locked.

   output wire [sl_num_lanes-1:0]           o_sl_tx_lanes_stable,       // Asserted when TX MAC is ready to send data
   output wire [sl_num_lanes-1:0]           o_sl_rx_pcs_ready,          // Asserted when RX PCS is ready to receive data
   output wire [sl_num_lanes-1:0]           o_sl_rx_block_lock,         // Asserted when 66b block alignment is finished on all PCS lanes
   output wire [sl_num_lanes-1:0]           o_sl_local_fault_status,    // The RX PCS has detected a problem that prevents it from being able to receive data
   output wire [sl_num_lanes-1:0]           o_sl_remote_fault_status,   // The remote link partner has sent remote fault ordered sets indicating that it is unable to receive data.
   output wire [sl_num_lanes-1:0]           o_sl_rx_hi_ber,             // Indicates RX PCS Hi BER state in the selected channel
   output wire [sl_num_lanes-1:0]           o_sl_ehip_ready,            //Signal to indicate that EHIP CSRs are ready.

    // MII Interface
   input wire [64*num_lanes-1:0] 					i_tx_mii_d, // TX MII data
   input wire [8*num_lanes-1:0] 					i_tx_mii_c, // Tx MII control
   input wire 								i_tx_mii_valid, // Indicates valid data ports, must follow o_tx_mii_ready
   input wire 								i_tx_mii_am, // Alignment marker insertion bit
   output wire 								o_tx_mii_ready, // indicates PCS is ready to receive new data
   output wire [64*num_lanes-1:0] 					o_rx_mii_d, // RX MII data
   output wire [8*num_lanes-1:0] 					o_rx_mii_c, // RX MII control
   output wire 								o_rx_mii_valid, // Indicates valid datain MII ports
   output wire 								o_rx_mii_am_valid, // Indicates valid datain MII ports

   input  wire [64*sl_num_lanes-1:0]        i_sl_tx_mii_d, // TX MII data
   input  wire [8*sl_num_lanes-1:0]         i_sl_tx_mii_c, // Tx MII control
   input  wire [sl_num_lanes-1:0]           i_sl_tx_mii_valid, // Indicates valid data ports, must follow o_sl_tx_mii_ready
   input  wire [sl_num_lanes-1:0]           i_sl_tx_mii_am, // Alignment marker insertion bit
   output wire [sl_num_lanes-1:0]           o_sl_tx_mii_ready, // indicates PCS is ready to receive new data
   output wire [64*sl_num_lanes-1:0]        o_sl_rx_mii_d, // RX MII data
   output wire [8*sl_num_lanes-1:0]         o_sl_rx_mii_c, // RX MII control
   output wire [sl_num_lanes-1:0]           o_sl_rx_mii_valid, // Indicates valid datain MII ports
   output wire [sl_num_lanes-1:0]           o_sl_rx_mii_am_valid, // Indicates valid datain MII ports

   // PCS66 Interface
   input  wire [66*sl_num_lanes-1:0]        i_sl_tx_pcs66_d,        // TX PCS66 data
   input  wire [sl_num_lanes-1:0]           i_sl_tx_pcs66_valid,    // Indicates valid data ports, must follow o_sl_tx_pcs66_ready
   input  wire [sl_num_lanes-1:0]           i_sl_tx_pcs66_am,       // Alignment marker insertion bit
   output wire [sl_num_lanes-1:0]           o_sl_tx_pcs66_ready,    // indicates PCS is ready to receive new data
   output wire [66*sl_num_lanes-1:0]        o_sl_rx_pcs66_d,        // RX PCS66 data
   output wire [sl_num_lanes-1:0]           o_sl_rx_pcs66_valid,    // Indicates valid datain PCS66 ports
   output wire [sl_num_lanes-1:0]           o_sl_rx_pcs66_am_valid, // Indicates valid datain PCS66 ports

   input  wire    [66*num_lanes-1:0]        i_tx_pcs66_d,
   input  wire                              i_tx_pcs66_valid,
   input  wire                              i_tx_pcs66_am,
   output wire                              o_tx_pcs66_ready,
   output wire    [66*num_lanes-1:0]        o_rx_pcs66_d,
   output wire                              o_rx_pcs66_valid,
   output wire                              o_rx_pcs66_am_valid,

   //status signal for both PCS66 and MII interface
   output wire           o_rx_pcs_fully_aligned,

//MAC direct ports
   output wire            o_tx_mac_ready,
   input wire [4-1:0] 	  i_tx_mac_skip_crc,
   input wire [4-1:0] 	  i_tx_mac_inframe,
   input wire [12-1:0] 	  i_tx_mac_eop_empty,
   input wire [4-1:0] 	  i_tx_mac_error,
   input wire [256-1:0] 	i_tx_mac_data,
   input wire            	i_tx_mac_valid,


   output wire  [4-1:0]                           o_rx_mac_inframe,
   output wire  [12-1:0]                          o_rx_mac_eop_empty,
   output wire  [256-1:0]                         o_rx_mac_data,
   output wire  [8-1:0]                           o_rx_mac_error,
   output wire  [12-1:0]                          o_rx_mac_status,
   output wire  [4-1:0]                           o_rx_mac_valid,
   output wire  [4-1:0]                           o_rx_mac_fcs_error,

//ELANE MAC direct ports
   output wire [sl_num_lanes-1:0]           o_sl_tx_mac_ready,
   input  wire [sl_num_lanes-1:0]           i_sl_tx_mac_skip_crc,
   input  wire [sl_num_lanes-1:0]           i_sl_tx_mac_inframe,
   input  wire [3*sl_num_lanes-1:0]         i_sl_tx_mac_eop_empty,
   input  wire [sl_num_lanes-1:0]           i_sl_tx_mac_error,
   input  wire [64*sl_num_lanes-1:0]        i_sl_tx_mac_data,
   input  wire [sl_num_lanes-1:0]           i_sl_tx_mac_valid,


   output wire [sl_num_lanes-1:0]           o_sl_rx_mac_inframe,
   output wire [3*sl_num_lanes-1:0]         o_sl_rx_mac_eop_empty,
   output wire [64*sl_num_lanes-1:0]        o_sl_rx_mac_data,
   output wire [2*sl_num_lanes-1:0]         o_sl_rx_mac_error,
   output wire [3*sl_num_lanes-1:0]         o_sl_rx_mac_status,
   output wire [sl_num_lanes-1:0]           o_sl_rx_mac_valid,
   output wire [sl_num_lanes-1:0]           o_sl_rx_mac_fcs_error,

//AIB direct interface

   input  wire [312-1:0]        i_aib_tx_data,
   output wire [312-1:0]        o_aib_rx_data,



   // PMA Direct Interface
   input  wire [80*sl_num_lanes-1:0]        i_sl_tx_pma, // TX PMA direct data
   output wire [80*sl_num_lanes-1:0]        o_sl_rx_pma, // RX PMA direct data
   output wire [sl_num_lanes-1:0]           o_sl_rx_pma_ready,
   output wire [sl_num_lanes-1:0]           o_sl_tx_pma_ready,
   output wire [sl_num_lanes-1:0]           o_sl_aib_txfifo_empty,
   output wire [sl_num_lanes-1:0]           o_sl_aib_txfifo_full,
   output wire [sl_num_lanes-1:0]           o_sl_aib_txfifo_pempty,
   output wire [sl_num_lanes-1:0]           o_sl_aib_txfifo_pfull,
   output wire [sl_num_lanes-1:0]           o_sl_aib_rxfifo_empty,
   output wire [sl_num_lanes-1:0]           o_sl_aib_rxfifo_full,
   output wire [sl_num_lanes-1:0]           o_sl_aib_rxfifo_pempty,
   output wire [sl_num_lanes-1:0]           o_sl_aib_rxfifo_pfull,
   input  wire [sl_num_lanes-1:0]           i_sl_aib_rxfifo_rd_en,

   // RX AIB deskew debug
   input  wire [sl_num_lanes-1:0]           i_sl_aib_rxfifo_latency_adj_ena,
   //input  wire [2-1:0]                      i_sl_ptp_aib_rxfifo_latency_adj_ena,

   // Custom Rate Interface
   input  wire [sl_num_lanes-1:0]           i_sl_custom_cadence,

   // XCVR FIFO Interface
   output wire [sl_num_lanes-1:0]           o_sl_txfifo_pfull,
   output wire [sl_num_lanes-1:0]           o_sl_txfifo_pempty,
   output wire [sl_num_lanes-1:0]           o_sl_txfifo_overflow,
   output wire [sl_num_lanes-1:0]           o_sl_txfifo_underflow,

   // Deterministic Latency Interface
   output wire [sl_num_lanes-1:0]           o_sl_tx_dl_async_pulse,
   output wire [sl_num_lanes-1:0]           o_sl_rx_dl_async_pulse,
   input  wire [sl_num_lanes-1:0]           i_sl_latency_sclk,
   input  wire [sl_num_lanes-1:0]           i_sl_tx_dl_measure_sel,
   input  wire [sl_num_lanes-1:0]           i_sl_rx_dl_measure_sel,

   //Reconfig interface
   input wire 				i_reconfig_clk,
   input wire 				i_reconfig_reset,
   input wire [20:0] 			i_eth_reconfig_addr,
   input wire 				i_eth_reconfig_read,
   input wire 				i_eth_reconfig_write,
   input wire [31:0] 			i_eth_reconfig_writedata,
   output reg  [31:0] 			o_eth_reconfig_readdata,
   output wire 				o_eth_reconfig_readdata_valid,
   output reg  				o_eth_reconfig_waitrequest,
   input wire 				i_stats_snapshot, // Record snapshot of current state of statistics registers.

   input  wire [19*sl_num_lanes-1:0]        i_sl_eth_reconfig_addr,
   input  wire [sl_num_lanes-1:0]           i_sl_eth_reconfig_read,
   input  wire [sl_num_lanes-1:0]           i_sl_eth_reconfig_write,
   input  wire [32*sl_num_lanes-1:0]        i_sl_eth_reconfig_writedata,
   output wire [32*sl_num_lanes-1:0]        o_sl_eth_reconfig_readdata,
   output wire [sl_num_lanes-1:0]           o_sl_eth_reconfig_readdata_valid,
   output wire [sl_num_lanes-1:0]           o_sl_eth_reconfig_waitrequest,
   input  wire [sl_num_lanes-1:0]           i_sl_stats_snapshot, // Record snapshot of current state of statistics registers.

  //XCVR Reconfig Interface, seperate one for each lane
   input wire                                 				i_rsfec_reconfig_write,
   input wire                                 				i_rsfec_reconfig_read,
   input wire [11-1:0]                        				i_rsfec_reconfig_addr,
   input wire [8-1:0]                        				i_rsfec_reconfig_writedata,
   output wire [8-1:0]                       				o_rsfec_reconfig_readdata,
   output wire                                				o_rsfec_reconfig_waitrequest,

   input  wire [2-1:0]                          i_ptp_reconfig_write,
   input  wire [2-1:0]                          i_ptp_reconfig_read,
   input  wire [19*2-1:0]                       i_ptp_reconfig_address,
   input  wire [8*2-1:0]                        i_ptp_reconfig_writedata,
   output wire [8*2-1:0]                        o_ptp_reconfig_readdata,
   output wire [2-1:0]                          o_ptp_reconfig_waitrequest,

   // Seperate XCVR reconfig Interfaces for each xcvr lane
   input wire [19*max_xcvr_ch-1:0]              i_xcvr_reconfig_address,
   input wire [max_xcvr_ch-1:0]                 i_xcvr_reconfig_read,
   input wire [max_xcvr_ch-1:0]                 i_xcvr_reconfig_write,
   input wire [8*max_xcvr_ch-1:0]               i_xcvr_reconfig_writedata,
   output wire [8*max_xcvr_ch-1:0]              o_xcvr_reconfig_readdata,
   output wire [max_xcvr_ch-1:0]                o_xcvr_reconfig_waitrequest, 	//AVMM stalling signal. The read/write cycle is only complete when this signal goes low

   input wire [19*2-1:0]                                        i_xcvr_reconfig_address_ptp,
   input wire [2-1:0]                                           i_xcvr_reconfig_read_ptp,
   input wire [2-1:0]                                           i_xcvr_reconfig_write_ptp,
   input wire [8*2-1:0]                                        i_xcvr_reconfig_writedata_ptp,
   output wire [8*2-1:0]                                       o_xcvr_reconfig_readdata_ptp,
   output wire [2-1:0]                                          o_xcvr_reconfig_waitrequest_ptp, //AVMM stalling signal. The read/write cycle is only complete when this signal goes low

   // User Interface: TX 2-step Timestamp Request
   input  wire                              i_ptp_ts_req,
   input  wire [7:0]                        i_ptp_fp,

   input  wire [sl_num_lanes-1:0]           i_sl_ptp_ts_req,
   input  wire [8*sl_num_lanes-1:0]         i_sl_ptp_fp,

   // User Interface: TX 2-step Timestamp Return
   output wire                              o_ptp_ets_valid,
   output wire [95:0]                       o_ptp_ets,
   output wire [7:0]                        o_ptp_ets_fp,

   output wire [sl_num_lanes-1:0]           o_sl_ptp_ets_valid,
   output wire [96*sl_num_lanes-1:0]        o_sl_ptp_ets,
   output wire [8*sl_num_lanes-1:0]         o_sl_ptp_ets_fp,

   // User Interface: RX Timestamp
   output wire [95:0]                       o_ptp_rx_its,

   output wire [96*sl_num_lanes-1:0]        o_sl_ptp_rx_its,



   // User Interface: TX 1-step Command
   input  wire                              i_ptp_ins_ets,
   input  wire                              i_ptp_ins_cf,
   input  wire                              i_ptp_zero_csum,
   input  wire                              i_ptp_update_eb,
   input  wire                              i_ptp_ts_format,
   input  wire [15:0]                       i_ptp_ts_offset,
   input  wire [15:0]                       i_ptp_cf_offset,
   input  wire [15:0]                       i_ptp_csum_offset,
   input  wire [15:0]                       i_ptp_eb_offset,
   input  wire [95:0]                       i_ptp_tx_its,

   input  wire [sl_num_lanes-1:0]           i_sl_ptp_ins_ets,
   input  wire [sl_num_lanes-1:0]           i_sl_ptp_ins_cf,
   input  wire [sl_num_lanes-1:0]           i_sl_ptp_zero_csum,
   input  wire [sl_num_lanes-1:0]           i_sl_ptp_update_eb,
   input  wire [sl_num_lanes-1:0]           i_sl_ptp_ts_format,
   input  wire [16*sl_num_lanes-1:0]        i_sl_ptp_ts_offset,
   input  wire [16*sl_num_lanes-1:0]        i_sl_ptp_cf_offset,
   input  wire [16*sl_num_lanes-1:0]        i_sl_ptp_csum_offset,
   input  wire [16*sl_num_lanes-1:0]        i_sl_ptp_eb_offset,
   input  wire [96*sl_num_lanes-1:0]        i_sl_ptp_tx_its,

   // User Interface: PTP Status
   output wire                              o_tx_ptp_ready,
   output wire                              o_rx_ptp_ready,

   //1ns
   input wire [0:0]                         i_clk_ptp_sample,
   output wire [sl_num_lanes-1:0]           o_sl_tx_ptp_ready,
   output wire [sl_num_lanes-1:0]           o_sl_rx_ptp_ready,

   // TOD for 3ns
   input  wire [95:0]                       i_ptp_tod,

   // TOD for 1ns
   input  wire [96*sl_num_lanes-1:0]        i_sl_ptp_tx_tod,
   input  wire [96*sl_num_lanes-1:0]        i_sl_ptp_rx_tod
   );

   localparam PTPADAPT_ENABLE_SIM = ENABLE_PTP_TOG &&((core_variant == 3) && (active_channel == 1));
   localparam RX_ASYNC_ADAPTER_MODE = ENABLE_ASYNC_ADAPTERS;
   localparam TX_ASYNC_ADAPTER_MODE = ENABLE_ASYNC_ADAPTERS;
   localparam  MAX_CONVERSION_SIZE = 128;
   localparam  MAX_STRING_CHARS    = 64;


   function [MAX_CONVERSION_SIZE-1:0] str_2_bin;
      input [MAX_STRING_CHARS*8-1:0] instring;

      integer 			     this_char;
      integer i;
      begin
         this_char = 0;
         i = 0;
         // Initialize accumulator
         str_2_bin = {MAX_CONVERSION_SIZE{1'b0}};
         for(i=MAX_STRING_CHARS-1;i>=0;i=i-1) begin
            this_char = instring[i*8+:8];
            // Add value of this digit
            if(this_char >= 48 && this_char <= 57)
              str_2_bin = (str_2_bin * 10) + (this_char - 48);
         end
      end
   endfunction

   //String to Binary Conversion
   //If parameter Type is STRING and value is some integer "36" that means atom map expects in "bin/bitvector" format
   // so we need to convert those parameters from string to bin

   localparam [127:0]     tlcl_int_ptp_debug                      =   str_2_bin (ptp_debug) ;
   localparam [127:0]     tlcl_int_rx_aib_dp_latency              =   str_2_bin (rx_aib_dp_latency) ;
   localparam [127:0]     tlcl_int_rx_pause_daddr                 =   str_2_bin (rx_pause_daddr) ;
   localparam [127:0]     tlcl_int_rx_ptp_dp_latency              =   str_2_bin (rx_ptp_dp_latency) ;
   localparam [127:0]     tlcl_int_rx_ptp_extra_latency           =   str_2_bin (rx_ptp_extra_latency) ;
   localparam [127:0]     tlcl_int_tx_aib_dp_latency              =   str_2_bin (tx_aib_dp_latency) ;
   localparam [127:0]     tlcl_int_tx_pause_daddr                 =   str_2_bin (tx_pause_daddr) ;
   localparam [127:0]     tlcl_int_tx_pause_saddr                 =   str_2_bin (tx_pause_saddr) ;
   localparam [127:0]     tlcl_int_tx_ptp_dp_latency              =   str_2_bin (tx_ptp_dp_latency) ;
   localparam [127:0]     tlcl_int_tx_ptp_extra_latency           =   str_2_bin (tx_ptp_extra_latency) ;
   localparam [127:0]     tlcl_int_tx_ptp_asym_latency            =   str_2_bin (tx_ptp_asym_latency) ;
   localparam [127:0]     tlcl_int_txmac_saddr                    =   str_2_bin (txmac_saddr) ;

   localparam [31:0]     lcl_int_ptp_debug                      =   tlcl_int_ptp_debug[31:0];
   localparam [31:0]     lcl_int_rx_aib_dp_latency              =   tlcl_int_rx_aib_dp_latency[31:0];
   localparam [47:0]     lcl_int_rx_pause_daddr                 =   tlcl_int_rx_pause_daddr[47:0];
   localparam [31:0]     lcl_int_rx_ptp_dp_latency              =   tlcl_int_rx_ptp_dp_latency[31:0];
   localparam [31:0]     lcl_int_rx_ptp_extra_latency           =   tlcl_int_rx_ptp_extra_latency[31:0];
   localparam [31:0]     lcl_int_tx_aib_dp_latency              =   tlcl_int_tx_aib_dp_latency[31:0];
   localparam [47:0]     lcl_int_tx_pause_daddr                 =   tlcl_int_tx_pause_daddr[47:0];
   localparam [47:0]     lcl_int_tx_pause_saddr                 =   tlcl_int_tx_pause_saddr[47:0];
   localparam [31:0]     lcl_int_tx_ptp_dp_latency              =   tlcl_int_tx_ptp_dp_latency[31:0];
   localparam [31:0]     lcl_int_tx_ptp_extra_latency           =   tlcl_int_tx_ptp_extra_latency[31:0];
   localparam [31:0]     lcl_int_tx_ptp_asym_latency            =   tlcl_int_tx_ptp_asym_latency[31:0];
   localparam [47:0]     lcl_int_txmac_saddr                    =   tlcl_int_txmac_saddr[47:0];


   // For synthesis disable sim_mode and pass sim_mode parameter only for simulation
`ifdef ALTERA_RESERVED_QIS
   localparam lcl_sim_mode = "disable";
   localparam SIM_EMULATE = 1'b0;
   localparam SIM_HURRY = 1'b0;
`else
   localparam lcl_sim_mode = sim_mode;
   localparam SIM_EMULATE = (sim_mode == "enable") ? 1'b1:1'b0;
   localparam SIM_HURRY = (sim_mode == "enable") ? 1'b1:1'b0;
`endif


   localparam lcl_rx_am_interval = (lcl_sim_mode == "enable") ? "sim_only_am_interval":"standard_100g_am_interval";
   localparam lcl_tx_am_period  = (lcl_sim_mode == "enable")&&((ehip_mode == "ehip_mac") || (ehip_mode == "ehip_pcs") || (ehip_mode == "ehip_pcs66") || (ehip_mode == "ehip_otn") ||  (ehip_mode == "ehip_mac_ptp"))       ? "sim_only_100g_fec_am_period" :
                                  (lcl_sim_mode == "enable")&&((ehip_mode == "ehip_mac_no_fec" ) || (ehip_mode == "ehip_pcs_no_fec") || (ehip_mode == "ehip_pcs66_no_fec") || (ehip_mode == "ehip_otn_no_fec") ||  (ehip_mode == "ehip_mac_ptp_no_fec")) ? "sim_only_am_period" :
                                                               "standard_100g_am_period";



   localparam ENABLE_PCSDIRECT = (ehip_mode=="ehip_pcs_no_fec" | ehip_mode=="ehip_pcs") ? 1'b1: 1'b0;
   localparam ENABLE_PCS66 = (ehip_mode=="ehip_otn_no_fec" | ehip_mode=="ehip_pcs66_no_fec" | ehip_mode=="ehip_otn" | ehip_mode=="ehip_pcs66") ? 1'b1: 1'b0;
   localparam ENABLE_RSFEC_MODE = ((core_variant == 2) || ((core_variant == 3) && (active_channel == 1))) ? ((ehip_mode == "ehip_mac") ||
                                                                                                             (ehip_mode == "ehip_mac_ptp") ||
                                                                                                             (ehip_mode == "ehip_pcs") ||
                                                                                                             (ehip_mode == "ehip_pcs66") ||
                                                                                                             (ehip_mode == "ehip_otn")) ? 1'b1: 1'b0:
                                                                                                            ((ehip_mode_sl_0 == "ehip_mac") ||
                                                                                                             (ehip_mode_sl_0 == "ehip_mac_ptp") ||
                                                                                                             (ehip_mode_sl_0 == "ehip_pcs") ||
                                                                                                             (ehip_mode_sl_0 == "ehip_pcs66") ||
                                                                                                             (ehip_mode_sl_0 == "ehip_otn")) ? 1'b1: 1'b0;
   localparam l_enable_ptp_sl                   = ((core_variant == 3) && (active_channel == 0) && (ENABLE_PTP != 0) && ((ehip_mode_sl_0 == "ehip_mac_ptp_no_fec") || (ehip_mode_sl_0 == "ehip_mac_ptp")));
   localparam ehip_core_ehip_mode               = l_enable_ptp_sl ? "ehip_lane_ptp_only" : ehip_mode;
   localparam ehip_core_ehip_rate               = l_enable_ptp_sl ? "rate_100gx4" : ehip_rate;
   localparam ehip_core_topology                = l_enable_ptp_sl ? (ENABLE_RSFEC_MODE == 0) ? (sl_num_lanes == 1) ? "elane_1ch_ptp" :
                                                                                               (sl_num_lanes == 2) ? "elane_2ch_ptp" :
                                                                                               (sl_num_lanes == 3) ? "elane_3ch_ptp" :
                                                                                             /*(sl_num_lanes == 4)*/ "elane_4ch_ptp" :
                                                                  /*(ENABLE_RSFEC_MODE == 1)*/ (sl_num_lanes == 1) ? "elane_1ch_ptp_fec" :
                                                                                               (sl_num_lanes == 2) ? "elane_2ch_ptp_fec" :
                                                                                               (sl_num_lanes == 3) ? "elane_3ch_ptp_fec" :
                                                                                             /*(sl_num_lanes == 4)*/ "elane_4ch_ptp_fec" :
                                                                    topology;
// ---------------------------------------------------------------------------------------------------------------------------------
// 24/May/2019 : slim35 : {HSD#2007758041, HSD#1409361720, HSD#1409327264} : PTP variants 1/3 EHIP_LOCATION Fitter Issue.
// ---------------------------------------------------------------------------------------------------------------------------------
// When PTP is enabled, we need to ensure data channel is as close as possible to PTP channel.
// However, PTP channel location is different depending on the EHIP_CORE selected.
// In EHIP_CORE0, the first data channel has to be shifted upward because PTP channels are located at the top.
// In EHIP_CORE1, the first data channel remains at the bottom because PTP channels are located at the bottom.
// So LOCATION_SEL should be 0 if EHIP_LOCATION is 1/3 as the lowest data channel is closest to the PTP channel located at the bottom of EHIP_CORE1.
// ---------------------------------------------------------------------------------------------------------------------------------
//    localparam LOCATION_SEL                     = l_enable_ptp_sl ? (4 - sl_num_lanes) : 0;
    localparam LOCATION_SEL                     = (l_enable_ptp_sl && !EHIP_LOCATION) ? (4 - sl_num_lanes) : 0;
// ---------------------------------------------------------------------------------------------------------------------------------
    localparam ehip_core_use_lane_ptp           = l_enable_ptp_sl ? "enable" : use_lane_ptp;
    localparam ehip_core_use_am_insert          = l_enable_ptp_sl ? "enable" : use_am_insert;
    localparam ehip_core_ehip_clk_sel           = l_enable_ptp_sl ? "shared_clock" : ehip_clk_sel;
    localparam ehip_core_remove_pads            = l_enable_ptp_sl ? "disable" : remove_pads;
    localparam ehip_core_keep_rx_crc            = l_enable_ptp_sl ? "disable" : keep_rx_crc;
    localparam ehip_core_ipg_removed_per_am_period = l_enable_ptp_sl ? 16'd20 : ipg_removed_per_am_period;
    localparam ehip_core_tx_max_frame_size      = l_enable_ptp_sl ? 16'd1518 : tx_max_frame_size;
    localparam ehip_core_tx_vlan_detection      = l_enable_ptp_sl ? "enable" : tx_vlan_detection;
    localparam ehip_core_tx_preamble_passthrough = l_enable_ptp_sl ? "disable" : tx_preamble_passthrough;
    localparam ehip_core_tx_ipg_size            = l_enable_ptp_sl ? "ipg_12" : tx_ipg_size;
    localparam ehip_core_rx_preamble_passthrough = l_enable_ptp_sl ? "disable" : rx_preamble_passthrough;
    localparam ehip_core_source_address_insertion = l_enable_ptp_sl ? "disable" : source_address_insertion;
    localparam ehip_core_strict_sfd_checking    = l_enable_ptp_sl ? "disable" : strict_sfd_checking;
    localparam ehip_core_rx_vlan_detection      = l_enable_ptp_sl ? "enable" : rx_vlan_detection;
    localparam ehip_core_rx_length_checking     = l_enable_ptp_sl ? "enable" : rx_length_checking;
    localparam ehip_core_rx_max_frame_size      = l_enable_ptp_sl ? 16'd1518 : rx_max_frame_size;
    localparam ehip_core_powermode_ac_mac       = l_enable_ptp_sl ? "mac_off" : powermode_ac_mac;
    localparam ehip_core_powermode_ac_pcs       = l_enable_ptp_sl ? "pcs_off" : powermode_ac_pcs;
    localparam ehip_core_powermode_ac_pld       = l_enable_ptp_sl ? "pld_on_4_lane_ptp" : powermode_ac_pld;
    localparam ehip_core_powermode_ac_misc      = l_enable_ptp_sl ? "misc_on" : powermode_ac_misc;
    localparam ehip_core_flow_control           = l_enable_ptp_sl ? "none" : flow_control;
    localparam ehip_core_flow_control_holdoff_mode = l_enable_ptp_sl ? "per_queue" : flow_control_holdoff_mode;
    localparam ehip_core_holdoff_quanta         = l_enable_ptp_sl ? 16'hFFFF : holdoff_quanta;
    localparam ehip_core_uniform_holdoff_quanta = l_enable_ptp_sl ? 16'hFFFF : uniform_holdoff_quanta;
    localparam ehip_core_pause_quanta           = l_enable_ptp_sl ? 16'hFFFF : pause_quanta;
    localparam ehip_core_tx_mac_data_flow       = l_enable_ptp_sl ? "disable" : tx_mac_data_flow;
    localparam ehip_core_pfc_holdoff_quanta_0   = l_enable_ptp_sl ? 16'hFFFF : pfc_holdoff_quanta_0;
    localparam ehip_core_pfc_holdoff_quanta_1   = l_enable_ptp_sl ? 16'hFFFF : pfc_holdoff_quanta_1;
    localparam ehip_core_pfc_holdoff_quanta_2   = l_enable_ptp_sl ? 16'hFFFF : pfc_holdoff_quanta_2;
    localparam ehip_core_pfc_holdoff_quanta_3   = l_enable_ptp_sl ? 16'hFFFF : pfc_holdoff_quanta_3;
    localparam ehip_core_pfc_holdoff_quanta_4   = l_enable_ptp_sl ? 16'hFFFF : pfc_holdoff_quanta_4;
    localparam ehip_core_pfc_holdoff_quanta_5   = l_enable_ptp_sl ? 16'hFFFF : pfc_holdoff_quanta_5;
    localparam ehip_core_pfc_holdoff_quanta_6   = l_enable_ptp_sl ? 16'hFFFF : pfc_holdoff_quanta_6;
    localparam ehip_core_pfc_holdoff_quanta_7   = l_enable_ptp_sl ? 16'hFFFF : pfc_holdoff_quanta_7;
    localparam ehip_core_pfc_pause_quanta_0     = l_enable_ptp_sl ? 16'hFFFF : pfc_pause_quanta_0;
    localparam ehip_core_pfc_pause_quanta_1     = l_enable_ptp_sl ? 16'hFFFF : pfc_pause_quanta_1;
    localparam ehip_core_pfc_pause_quanta_2     = l_enable_ptp_sl ? 16'hFFFF : pfc_pause_quanta_2;
    localparam ehip_core_pfc_pause_quanta_3     = l_enable_ptp_sl ? 16'hFFFF : pfc_pause_quanta_3;
    localparam ehip_core_pfc_pause_quanta_4     = l_enable_ptp_sl ? 16'hFFFF : pfc_pause_quanta_4;
    localparam ehip_core_pfc_pause_quanta_5     = l_enable_ptp_sl ? 16'hFFFF : pfc_pause_quanta_5;
    localparam ehip_core_pfc_pause_quanta_6     = l_enable_ptp_sl ? 16'hFFFF : pfc_pause_quanta_6;
    localparam ehip_core_pfc_pause_quanta_7     = l_enable_ptp_sl ? 16'hFFFF : pfc_pause_quanta_7;
    localparam ehip_core_txmac_saddr            = l_enable_ptp_sl ? 48'h001122334455 : lcl_int_txmac_saddr;
    localparam ehip_core_tx_pause_daddr         = l_enable_ptp_sl ? 48'h0180C2000001 : lcl_int_tx_pause_daddr;
    localparam ehip_core_tx_pause_saddr         = l_enable_ptp_sl ? 48'hE100CBFC5ADD : lcl_int_tx_pause_saddr;
    localparam ehip_core_rx_pause_daddr         = l_enable_ptp_sl ? 48'h0180C2000001 : lcl_int_rx_pause_daddr;
    localparam ehip_core_xus_timer_window       = l_enable_ptp_sl ? 21'd201415 : xus_timer_window;
    localparam ehip_core_forward_rx_pause_requests = l_enable_ptp_sl ? "disable" : forward_rx_pause_requests;

    localparam SL_DP_SEL_RESET_VALUE            = (ehip_mode_sl_0 == "ehip_mac_no_fec")     ? 3'd0 :
                                                  (ehip_mode_sl_0 == "ehip_mac")            ? 3'd0 :
                                                  (ehip_mode_sl_0 == "ehip_mac_ptp_no_fec") ? 3'd1 :
                                                  (ehip_mode_sl_0 == "ehip_mac_ptp")        ? 3'd1 :
                                                  (ehip_mode_sl_0 == "ehip_pcs_no_fec")     ? 3'd2 :
                                                  (ehip_mode_sl_0 == "ehip_pcs")            ? 3'd2 :
                                                  (ehip_mode_sl_0 == "ehip_pcs66_no_fec")   ? 3'd4 :
                                                  (ehip_mode_sl_0 == "ehip_pcs66")          ? 3'd4 :
                                                  (ehip_mode_sl_0 == "ehip_otn_no_fec")     ? 3'd3 :
                                                  (ehip_mode_sl_0 == "ehip_otn")            ? 3'd3 :
                                                  (ehip_mode_sl_0 == "ehip_disable")        ? 3'd5 :
                                                                                              3'd0;

//    localparam EL_LANES                         = ((ehip_mode == "ehip_mac_ptp" && ehip_rate == "rate_100gx4")||(ehip_mode == "ehip_mac_ptp_no_fec" && ehip_rate == "rate_100gx4")) ? 4  : 1;

   localparam TX_PTP_WIDTH = 1*6+16*4+96+8;

   localparam HIP_FLOW_CONTROL = (ehip_core_flow_control == "none")? "none": "both_no_xoff";
   localparam ELANE_FLOW_CONTROL = (flow_control_sl_0 == "none")? "none": "both_no_xoff";
   // localparam ehip_rate_sl_x = (ENABLE_RSFEC) ? "rate_25gx1_fec" : ehip_rate_sl_0

   wire [TX_PTP_WIDTH-1:0]  usr_tx_ptp_ff_in;
   logic [TX_PTP_WIDTH-1:0] usr_tx_ptp_ff_out_wire;
   logic [TX_PTP_WIDTH-1:0] usr_tx_ptp_ff_out;

   wire                     ml_ptp_ins_ets;
   wire                     ml_ptp_ins_cf;
   wire                     ml_ptp_ins_zero_csum;
   wire                     ml_ptp_ins_update_eb;
   wire                     ml_ptp_ts_format;
   wire [15:0]              ml_ptp_ts_offset;
   wire [15:0]              ml_ptp_cf_offset;
   wire [15:0]              ml_ptp_csum_offset;
   wire [15:0]              ml_ptp_eb_offset;
   wire [95:0]              ml_ptp_tx_its;
   wire                     ml_ptp_ts_req;
   wire [7:0]               ml_ptp_fp;

   wire [95:0]              ml_ptp_rx_its;
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
   wire                     ml_ptp_rx_its_valid;
// ---------------------------------------------------------------------------------------------------------------------------------

   reg  [3:0]               ptp_tx_ff_waddr;
   reg  [3:0]               ptp_tx_ff_raddr;
   reg  [3:0]               ptp_rx_ff_waddr;
   reg  [3:0]               ptp_rx_ff_raddr;

   wire                     tx_ts_ff_write;
   wire                     tx_ts_ff_read;
   wire                     rx_ts_ff_write;
   wire                     rx_ts_ff_read;

   reg                      ml_rx_inframe_r;

   logic   [4-1:0]                 int_ptp_tx_ts_valid;
   logic   [4-1:0][11:0]           int_ptp_tx_ts;
   logic   [4-1:0][20:0]           int_ptp_rx_ts;
   logic   [4-1:0]                 int_ptp_tx_am;
   logic   [4-1:0]                 int_ptp_rx_am;
   logic                           int_ptp_reading_vl_data;
   logic    [6:0]   ptp_unused0;
   logic    [6:0]   ptp_unused1;

   wire [num_lanes-1:0]    tx_aib_reset;
   wire [num_lanes-1:0]    rx_aib_reset;
   wire [num_lanes-1:0]    tx_digitalreset;
   wire [num_lanes-1:0]    rx_digitalreset;
   wire [num_lanes-1:0]    rx_is_lockedtodata;
   wire [2+num_lanes-1:0]    rx_transfer_ready;
   wire [2+num_lanes-1:0]    tx_transfer_ready;
   wire [2+num_lanes-1:0]    int_rx_transfer_ready;
   wire [2+num_lanes-1:0]    int_tx_transfer_ready;
   wire [1:0] 		     ptp_tx_transfer_ready;
   wire [1:0] 		     ptp_rx_transfer_ready;

   wire [num_lanes-1:0]    rx_pma_ready;
   wire [num_lanes-1:0]    tx_pma_ready;
   wire [sl_num_lanes-1:0] sl_rx_is_lockedtodata;
   wire [sl_num_lanes-1:0] sl_rx_transfer_ready;
   wire [sl_num_lanes-1:0] sl_tx_transfer_ready;

   wire [sl_num_lanes-1:0] sl_tx_aib_reset;
   wire [sl_num_lanes-1:0] sl_rx_aib_reset;
   wire [sl_num_lanes-1:0] sl_tx_pcs_reset;
   wire [sl_num_lanes-1:0] sl_rx_pcs_reset;
   wire [sl_num_lanes-1:0] sl_pause_ehip_ready;
   wire            reconfig_reset_sync;
   wire 	       soft_csr_rst;
   wire 	       soft_tx_rst;
   wire 	       soft_rx_rst;
   wire 	       csr_rst_stat;
   wire 	       tx_rst_stat;
   wire 	       rx_rst_stat;
   wire 	       pause_ehip_ready;


   wire                ehip_rst_n_ack;
   wire                ehip_tx_rst_n_ack;
   wire                ehip_rx_rst_n_ack;
   reg                 ehip_rx_rst_n_ack_sync;
   wire                ehip_rx_rst_n_ack_sync_wire;
   reg                 ehip_rx_rst_n_ack_sync_r;
   reg                 ehip_rx_rst_n_ack_sync_rr;
   wire 	       ehip_rst;
   wire 	       ehip_tx_rst;
   wire 	       ehip_rx_rst;
   wire                rsfec_rst_n_ack;
   wire                rsfec_tx_rst_n_ack;
   wire                rsfec_rx_rst_n_ack;
   wire 	       rsfec_rst;
   wire 	       rsfec_tx_rst;
   wire 	       rsfec_rx_rst;
   wire 	       ehip_pld_ready;
   wire 	       ehip_signal_ok;
   wire 	       ehip_signal_ok_p;
   // a_eth_reconfig are connections to the sl_pause arbiter
   reg [20:0] 		   a_eth_reconfig_addr;
   reg 			   a_eth_reconfig_read;
   reg 			   a_eth_reconfig_write;
   reg [31:0] 		   a_eth_reconfig_writedata;
   reg [31:0] 		   a_eth_reconfig_readdata;
   reg 			   a_eth_reconfig_readdata_valid;
   reg 			   a_eth_reconfig_waitrequest;

   wire [19*sl_num_lanes-1:0]   a_sl_eth_reconfig_addr;
   wire [sl_num_lanes-1:0]      a_sl_eth_reconfig_read;
   wire [sl_num_lanes-1:0]      a_sl_eth_reconfig_write;
   wire [32*sl_num_lanes-1:0]   a_sl_eth_reconfig_writedata;
   reg  [32*sl_num_lanes-1:0]   a_sl_eth_reconfig_readdata;
   wire [sl_num_lanes-1:0]      a_sl_eth_reconfig_readdata_valid;
   reg  [sl_num_lanes-1:0]      a_sl_eth_reconfig_waitrequest;

   wire [sl_num_lanes-1:0]  sl_ehip_reset_stat;
   wire [sl_num_lanes-1:0]  sl_ehip_tx_reset_stat;
   wire [sl_num_lanes-1:0]  sl_ehip_rx_reset_stat;
   wire [sl_num_lanes-1:0]  sl_ehip_reset;
   wire [sl_num_lanes-1:0]  sl_ehip_tx_reset;
   wire [sl_num_lanes-1:0]  sl_ehip_rx_reset;
   wire [sl_num_lanes-1:0]  sl_ehip_pld_ready;
   wire [sl_num_lanes-1:0]  sl_ehip_signal_ok;

   wire                     sl_rsfec_reset;
   wire                     sl_rsfec_tx_reset;
   wire                     sl_rsfec_rx_reset;

   wire [sl_num_lanes-1:0]  sl_soft_rsfec_reset;
   wire [sl_num_lanes-1:0]  sl_soft_rsfec_tx_reset;
   wire [sl_num_lanes-1:0]  sl_soft_rsfec_rx_reset;

   // No corresponding ports so where these will go? to CSR registers?

   logic i_custom_cadence;
   wire [num_lanes-1:0]    int_rx_fcs_error;
   // Adater Interface ports
   wire [num_lanes-1:0]       int_tx_error;
   wire [num_lanes-1:0]       int_tx_inframe;
   wire [num_lanes-1:0]       int_tx_skip_crc;
   wire [2+num_lanes-1:0]       int_tx_aib_dsk_w;
   reg  [2+num_lanes-1:0]       int_tx_aib_dsk_r;
   wire [2+num_lanes-1:0]       int_tx_aib_dsk;
   wire 		      int_tx_valid;
   logic              int_tx_early_valid_wire;
   logic              int_tx_early_valid;
   logic              int_tx_valid_ptp_wire;
   logic              int_tx_valid_ptp;
   wire 		      int_tx_ready;

   wire                        int_tx_ready_r;
   wire [num_lanes-1:0]       int_tx_dll_lock;
   wire [sl_num_lanes-1:0]    sl_tx_dll_lock;
   wire [sl_num_lanes-1:0]    sl_cfg_load_done;

   wire ehip_rx_hi_ber_out;
   wire [3:0] kr_mode;
   wire [3:0] kr_rst_req;
   wire [3:0] kr_rst_stat;
   wire [sl_num_lanes-1:0] kr_dyn_fec_en;

    wire   [sl_num_lanes-1:0]                    sl_soft_csr_rst;
    wire   [sl_num_lanes-1:0]                    sl_soft_tx_rst;
    wire   [sl_num_lanes-1:0]                    sl_soft_rx_rst;

   wire [num_lanes-1:0][2:0]  int_tx_empty ;

   wire [num_lanes-1:0]    int_rx_inframe;
   wire [num_lanes-1:0][63:0] int_rx_data  ;
   wire [num_lanes-1:0][2:0]  int_rx_empty ;
   wire [num_lanes-1:0][1:0]  int_rx_error ;
   wire [num_lanes-1:0][2:0]  int_rx_status;
   wire 		      int_rx_valid;

   wire [sl_num_lanes-1:0]          int_sl_tx_valid;
   wire [sl_num_lanes-1:0]          int_sl_tx_ready;
   wire [sl_num_lanes-1:0][63:0]    int_sl_tx_data;
   wire [sl_num_lanes-1:0]          int_sl_tx_error;
   wire [sl_num_lanes-1:0][2:0]     int_sl_tx_empty;
   wire [sl_num_lanes-1:0]          int_sl_tx_inframe;
   wire [sl_num_lanes-1:0]          int_sl_tx_skip_crc;
   wire [sl_num_lanes-1:0]          int_sl_tx_aib_dsk;

   logic   [4-1:0][1:0]            int_ptp_tx_fp;
   wire [sl_num_lanes-1:0][3:0]     int_ptp_byte_offset;
   wire [sl_num_lanes-1:0][3:0]     int_ptp_ins_type;
   wire [sl_num_lanes-1:0][23:0]     int_ptp_ts;


   wire [sl_num_lanes-1:0]          int_sl_rx_valid;
   wire [sl_num_lanes-1:0][63:0]    int_sl_rx_data;
   wire [sl_num_lanes-1:0][1:0]     int_sl_rx_error;
   wire [sl_num_lanes-1:0][2:0]     int_sl_rx_empty;
   wire [sl_num_lanes-1:0]          int_sl_rx_inframe;
   wire [sl_num_lanes-1:0]          int_sl_rx_fcs_error;
   wire [sl_num_lanes-1:0][2:0]     int_sl_rx_status;

   wire [sl_num_lanes-1:0]          sl_rx_pcs_fully_aligned;

   wire                ehip_cfg_load_done_out;
   wire                ehip_rx_dsk_done_out;
   wire                ehip_rx_pcs_fully_aligned_out;

   wire var_i_csr_rst;


   wire [max_clkout_ch-1:0]   tx_clkout_div64;
   wire [max_clkout_ch-1:0]   rx_clkout_div64;
   wire [max_clkout_ch-1:0]   tx_clkout_div66;
   wire [max_clkout_ch-1:0]   rx_clkout_div66;
   localparam deskew_lanes = (ENABLE_PTP_TOG || ENABLE_PTP) ? num_lanes+2 : num_lanes;
   wire [deskew_lanes-1:0]  rx_aib_dsk;
   wire [sl_num_lanes-1:0] sl_rx_aib_dsk;
   wire [sl_num_lanes-1:0] sl_rx_aib_dsk_done;
   wire 		      rsfec_o_fec_ready;
   wire                       dis_rsfec;
   wire                       o_local_fault_status_1;

   // wire [95:0]                       i_ptp_tod_1ns;
   // assign i_ptp_tod_1ns = i_sl_ptp_tx_tod[95:0];
   // ELANE: 2D array wire declaration
   wire [sl_num_lanes-1:0][95:0]     i_sl_ptp_tx_tod_2d;
   wire [sl_num_lanes-1:0][95:0]     i_sl_ptp_rx_tod_2d;
   wire [sl_num_lanes-1:0][63:0]      i_sl_tx_data_2d;
   wire [sl_num_lanes-1:0][2:0]       i_sl_tx_empty_2d;
   wire [sl_num_lanes-1:0][7:0]       i_sl_tx_pfc_2d;
   wire [sl_num_lanes-1:0][63:0]     o_sl_rx_data_2d;
   wire [sl_num_lanes-1:0][2:0]      o_sl_rx_empty_2d;
   wire [sl_num_lanes-1:0][5:0]      o_sl_rx_error_2d;
   wire [sl_num_lanes-1:0][39:0]     o_sl_rxstatus_data_2d;
   wire [sl_num_lanes-1:0][7:0]      o_sl_rx_pfc_2d;
   wire [sl_num_lanes-1:0][63:0]     i_sl_tx_mii_d_2d;
   wire [sl_num_lanes-1:0][7:0]      i_sl_tx_mii_c_2d;
   wire [sl_num_lanes-1:0][63:0]     o_sl_rx_mii_d_2d;
   wire [sl_num_lanes-1:0][7:0]      o_sl_rx_mii_c_2d;
   wire [sl_num_lanes-1:0][65:0]     i_sl_tx_pcs66_d_2d;
   wire [sl_num_lanes-1:0][65:0]     o_sl_rx_pcs66_d_2d;
   wire [sl_num_lanes-1:0][79:0]     i_sl_tx_pma_2d;
   wire [sl_num_lanes-1:0][79:0]     o_sl_rx_pma_2d;
   wire [sl_num_lanes-1:0][18:0]     i_sl_eth_reconfig_addr_2d;
   wire [sl_num_lanes-1:0][31:0]     i_sl_eth_reconfig_writedata_2d;
   reg  [sl_num_lanes-1:0][31:0]     o_sl_eth_reconfig_readdata_2d;
   wire [sl_num_lanes-1:0][7:0]      i_sl_ptp_fp_2d;
   wire [sl_num_lanes-1:0][95:0]     o_sl_ptp_ets_2d;
   wire [sl_num_lanes-1:0][7:0]      o_sl_ptp_ets_fp_2d;
   wire [sl_num_lanes-1:0][95:0]     o_sl_ptp_rx_its_2d;
   wire [sl_num_lanes-1:0][15:0]     i_sl_ptp_ts_offset_2d;
   wire [sl_num_lanes-1:0][15:0]     i_sl_ptp_cf_offset_2d;
   wire [sl_num_lanes-1:0][15:0]     i_sl_ptp_csum_offset_2d;
   wire [sl_num_lanes-1:0][15:0]     i_sl_ptp_eb_offset_2d;
   wire [sl_num_lanes-1:0][95:0]     i_sl_ptp_tx_its_2d;
   reg  [sl_num_lanes-1:0][2:0]      sl_dp_sel;
   reg  [sl_num_lanes-1:0]           sl_rsfec_mode;
   reg  [sl_num_lanes-1:0]           sl_tx_preamble_pass;
   reg  [sl_num_lanes-1:0]           sl_tx_am_pulse;

   reg                               ml_rsfec_mode;
   reg                               ml_tx_preamble_pass;
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
   reg                               ml_rx_preamble_pass;
// ---------------------------------------------------------------------------------------------------------------------------------
   reg                               ml_enforce_max_rx;
   reg                               ml_remove_rx_pad;


    // JTAG AVMM Combined EHIP Reconfig
    wire    [20:0]                  i_eth_reconfig_addr_jtag_arb;
    wire 	                    i_eth_reconfig_read_jtag_arb;
    wire 	                    i_eth_reconfig_write_jtag_arb;
    wire    [31:0]                  i_eth_reconfig_writedata_jtag_arb;
    wire    [31:0]                  o_eth_reconfig_readdata_jtag_arb;
    wire 	                    o_eth_reconfig_readdata_valid_jtag_arb;
    wire  	                    o_eth_reconfig_waitrequest_jtag_arb;

    // JTAG AVMM Combined ELANE Reconfig
    wire    [19*sl_num_lanes-1:0]   i_sl_eth_reconfig_addr_jtag_arb;
    wire    [sl_num_lanes-1:0]      i_sl_eth_reconfig_read_jtag_arb;
    wire    [sl_num_lanes-1:0]      i_sl_eth_reconfig_write_jtag_arb;
    wire    [32*sl_num_lanes-1:0]   i_sl_eth_reconfig_writedata_jtag_arb;
    wire    [32*sl_num_lanes-1:0]   o_sl_eth_reconfig_readdata_jtag_arb;
    wire    [sl_num_lanes-1:0]      o_sl_eth_reconfig_readdata_valid_jtag_arb;
    wire    [sl_num_lanes-1:0]      o_sl_eth_reconfig_waitrequest_jtag_arb;

    // JTAG AVMM Combined FEC Reconfig
    wire    [11-1:0]                i_rsfec_reconfig_addr_jtag_arb;
    wire                            i_rsfec_reconfig_read_jtag_arb;
    wire                            i_rsfec_reconfig_write_jtag_arb;
    wire    [8-1:0]                 i_rsfec_reconfig_writedata_jtag_arb;
    wire    [8-1:0]                 o_rsfec_reconfig_readdata_jtag_arb;
    wire                            o_rsfec_reconfig_waitrequest_jtag_arb;

    // JTAG AVMM Combined XCVR Reconfig
    wire    [19*max_xcvr_ch-1:0]    i_xcvr_reconfig_address_jtag_arb;
    wire    [max_xcvr_ch-1:0]       i_xcvr_reconfig_read_jtag_arb;
    wire    [max_xcvr_ch-1:0]       i_xcvr_reconfig_write_jtag_arb;
    wire    [8*max_xcvr_ch-1:0]     i_xcvr_reconfig_writedata_jtag_arb;
    wire    [8*max_xcvr_ch-1:0]     o_xcvr_reconfig_readdata_jtag_arb;
    wire    [max_xcvr_ch-1:0]       o_xcvr_reconfig_waitrequest_jtag_arb;


    //------------------------------------------------------------------//
    // JTAG Master and Arbiter for System Console

    generate
    if (ENABLE_JTAG_AVMM) begin: GEN_JTAG_AVMM

            alt_ehipc3_fm_jtag_avmm #(
            .MAX_XCVR_CH    (max_xcvr_ch),
            .NUM_LANES_SL   (sl_num_lanes),
            .CORE_VARIANT   (core_variant),
            .ACTIVE_CHANNEL (active_channel)
            ) ehipc3_jtag_inst (

            // Clock and Reset
            .i_reconfig_clk                         (i_reconfig_clk),
            .i_reconfig_reset                       (i_reconfig_reset),

            // EHIP Reconfig Interface
            .i_eth_reconfig_addr                    (i_eth_reconfig_addr),
            .i_eth_reconfig_read                    (i_eth_reconfig_read),
            .i_eth_reconfig_write                   (i_eth_reconfig_write),
            .i_eth_reconfig_writedata               (i_eth_reconfig_writedata),
            .o_eth_reconfig_readdata                (o_eth_reconfig_readdata),
            .o_eth_reconfig_readdata_valid          (o_eth_reconfig_readdata_valid),
            .o_eth_reconfig_waitrequest             (o_eth_reconfig_waitrequest),

            // EHIP Combined Reconfig Interface
            .i_eth_reconfig_addr_jtag_arb           (i_eth_reconfig_addr_jtag_arb),
            .i_eth_reconfig_read_jtag_arb           (i_eth_reconfig_read_jtag_arb),
            .i_eth_reconfig_write_jtag_arb          (i_eth_reconfig_write_jtag_arb),
            .i_eth_reconfig_writedata_jtag_arb      (i_eth_reconfig_writedata_jtag_arb),
            .o_eth_reconfig_readdata_jtag_arb       (o_eth_reconfig_readdata_jtag_arb),
            .o_eth_reconfig_readdata_valid_jtag_arb (o_eth_reconfig_readdata_valid_jtag_arb),
            .o_eth_reconfig_waitrequest_jtag_arb    (o_eth_reconfig_waitrequest_jtag_arb),

            // ELANE Reconfig Interface
            .i_sl_eth_reconfig_addr                     (i_sl_eth_reconfig_addr),
            .i_sl_eth_reconfig_read                     (i_sl_eth_reconfig_read),
            .i_sl_eth_reconfig_write                    (i_sl_eth_reconfig_write),
            .i_sl_eth_reconfig_writedata                (i_sl_eth_reconfig_writedata),
            .o_sl_eth_reconfig_readdata                 (o_sl_eth_reconfig_readdata),
            .o_sl_eth_reconfig_readdata_valid           (o_sl_eth_reconfig_readdata_valid),
            .o_sl_eth_reconfig_waitrequest              (o_sl_eth_reconfig_waitrequest),

            // ELANE Combined Reconfig Interface
            .i_sl_eth_reconfig_addr_jtag_arb            (i_sl_eth_reconfig_addr_jtag_arb),
            .i_sl_eth_reconfig_read_jtag_arb            (i_sl_eth_reconfig_read_jtag_arb),
            .i_sl_eth_reconfig_write_jtag_arb           (i_sl_eth_reconfig_write_jtag_arb),
            .i_sl_eth_reconfig_writedata_jtag_arb       (i_sl_eth_reconfig_writedata_jtag_arb),
            .o_sl_eth_reconfig_readdata_jtag_arb        (o_sl_eth_reconfig_readdata_jtag_arb),
            .o_sl_eth_reconfig_readdata_valid_jtag_arb  (o_sl_eth_reconfig_readdata_valid_jtag_arb),
            .o_sl_eth_reconfig_waitrequest_jtag_arb     (o_sl_eth_reconfig_waitrequest_jtag_arb),

            // FEC Reconfig Interface
            .i_rsfec_reconfig_addr                  (i_rsfec_reconfig_addr),
            .i_rsfec_reconfig_read                  (i_rsfec_reconfig_read),
            .i_rsfec_reconfig_write                 (i_rsfec_reconfig_write),
            .i_rsfec_reconfig_writedata             (i_rsfec_reconfig_writedata),
            .o_rsfec_reconfig_readdata              (o_rsfec_reconfig_readdata),
            .o_rsfec_reconfig_waitrequest           (o_rsfec_reconfig_waitrequest),

            // FEC Combined Reconfig Interface
            .i_rsfec_reconfig_addr_jtag_arb         (i_rsfec_reconfig_addr_jtag_arb),
            .i_rsfec_reconfig_read_jtag_arb         (i_rsfec_reconfig_read_jtag_arb),
            .i_rsfec_reconfig_write_jtag_arb        (i_rsfec_reconfig_write_jtag_arb),
            .i_rsfec_reconfig_writedata_jtag_arb    (i_rsfec_reconfig_writedata_jtag_arb),
            .o_rsfec_reconfig_readdata_jtag_arb     (o_rsfec_reconfig_readdata_jtag_arb),
            .o_rsfec_reconfig_waitrequest_jtag_arb  (o_rsfec_reconfig_waitrequest_jtag_arb),

            // XCVR Reconfig Interface
            .i_xcvr_reconfig_address                (i_xcvr_reconfig_address),
            .i_xcvr_reconfig_read                   (i_xcvr_reconfig_read),
            .i_xcvr_reconfig_write                  (i_xcvr_reconfig_write),
            .i_xcvr_reconfig_writedata              (i_xcvr_reconfig_writedata),
            .o_xcvr_reconfig_readdata               (o_xcvr_reconfig_readdata),
            .o_xcvr_reconfig_waitrequest            (o_xcvr_reconfig_waitrequest),

            // XCVR Combined Reconfig Interface
            .i_xcvr_reconfig_address_jtag_arb       (i_xcvr_reconfig_address_jtag_arb),
            .i_xcvr_reconfig_read_jtag_arb          (i_xcvr_reconfig_read_jtag_arb),
            .i_xcvr_reconfig_write_jtag_arb         (i_xcvr_reconfig_write_jtag_arb),
            .i_xcvr_reconfig_writedata_jtag_arb     (i_xcvr_reconfig_writedata_jtag_arb),
            .o_xcvr_reconfig_readdata_jtag_arb      (o_xcvr_reconfig_readdata_jtag_arb),
            .o_xcvr_reconfig_waitrequest_jtag_arb   (o_xcvr_reconfig_waitrequest_jtag_arb)
        );

    end

    else begin: NO_JTAG_AVMM
        assign  i_eth_reconfig_addr_jtag_arb            =   i_eth_reconfig_addr;
        assign  i_eth_reconfig_read_jtag_arb            =   i_eth_reconfig_read;
        assign  i_eth_reconfig_write_jtag_arb           =   i_eth_reconfig_write;
        assign  i_eth_reconfig_writedata_jtag_arb       =   i_eth_reconfig_writedata;
        assign  o_eth_reconfig_readdata                 =   o_eth_reconfig_readdata_jtag_arb;
        assign  o_eth_reconfig_readdata_valid           =   o_eth_reconfig_readdata_valid_jtag_arb;
        assign  o_eth_reconfig_waitrequest              =   o_eth_reconfig_waitrequest_jtag_arb;

        assign  i_sl_eth_reconfig_addr_jtag_arb         =   i_sl_eth_reconfig_addr;
        assign  i_sl_eth_reconfig_read_jtag_arb         =   i_sl_eth_reconfig_read;
        assign  i_sl_eth_reconfig_write_jtag_arb        =   i_sl_eth_reconfig_write;
        assign  i_sl_eth_reconfig_writedata_jtag_arb    =   i_sl_eth_reconfig_writedata;
        assign  o_sl_eth_reconfig_readdata              =   o_sl_eth_reconfig_readdata_jtag_arb;
        assign  o_sl_eth_reconfig_readdata_valid        =   o_sl_eth_reconfig_readdata_valid_jtag_arb;
        assign  o_sl_eth_reconfig_waitrequest           =   o_sl_eth_reconfig_waitrequest_jtag_arb;

        assign  i_rsfec_reconfig_addr_jtag_arb          =   i_rsfec_reconfig_addr;
        assign  i_rsfec_reconfig_read_jtag_arb          =   i_rsfec_reconfig_read;
        assign  i_rsfec_reconfig_write_jtag_arb         =   i_rsfec_reconfig_write;
        assign  i_rsfec_reconfig_writedata_jtag_arb     =   i_rsfec_reconfig_writedata;
        assign  o_rsfec_reconfig_readdata               =   o_rsfec_reconfig_readdata_jtag_arb;
        assign  o_rsfec_reconfig_waitrequest            =   o_rsfec_reconfig_waitrequest_jtag_arb;

        assign  i_xcvr_reconfig_address_jtag_arb        =   i_xcvr_reconfig_address;
        assign  i_xcvr_reconfig_read_jtag_arb           =   i_xcvr_reconfig_read;
        assign  i_xcvr_reconfig_write_jtag_arb          =   i_xcvr_reconfig_write;
        assign  i_xcvr_reconfig_writedata_jtag_arb      =   i_xcvr_reconfig_writedata;
        assign  o_xcvr_reconfig_readdata                =   o_xcvr_reconfig_readdata_jtag_arb;
        assign  o_xcvr_reconfig_waitrequest             =   o_xcvr_reconfig_waitrequest_jtag_arb;
    end
    endgenerate


   wire [max_refclk-1:0]         i_clk_ref_m; //Native PHY IP reference clock

   logic    [63:0]  rx_adapt_dropped_frames_shadow;
   logic            rx_adapt_clear_dropped_count;
   logic            rx_adapt_clear_dropped_count_sync;
   logic            stats_snapshot_sync;
   logic    [63:0]  rx_adapt_dropped_frames;
   logic    [63:0]  rx_adapt_dropped_frames_sync;
   logic            undersized_frame_csr_rst;


        assign i_clk_ref_m = i_clk_ref;


   // ELANE: 1D to 2D array remapping
   genvar elane_remap_i;
   generate
        for (elane_remap_i=0; elane_remap_i<sl_num_lanes; elane_remap_i=elane_remap_i+1) begin : ELANE_REMAP
        assign i_sl_ptp_tx_tod_2d[elane_remap_i]               = i_sl_ptp_tx_tod[96*elane_remap_i+95:96*elane_remap_i];
        assign i_sl_ptp_rx_tod_2d[elane_remap_i]               = i_sl_ptp_rx_tod[96*elane_remap_i+95:96*elane_remap_i];
        // input ports
        assign i_sl_tx_data_2d[elane_remap_i]                  = i_sl_tx_data[64*elane_remap_i+63:64*elane_remap_i];
        assign i_sl_tx_empty_2d[elane_remap_i]                 = i_sl_tx_empty[3*elane_remap_i+2:3*elane_remap_i];
        assign i_sl_tx_pfc_2d[elane_remap_i]                   = i_sl_tx_pfc[8*elane_remap_i+7:8*elane_remap_i];
        assign i_sl_tx_mii_d_2d[elane_remap_i]                 = i_sl_tx_mii_d[64*elane_remap_i+63:64*elane_remap_i];
        assign i_sl_tx_mii_c_2d[elane_remap_i]                 = i_sl_tx_mii_c[8*elane_remap_i+7:8*elane_remap_i];
        assign i_sl_tx_pcs66_d_2d[elane_remap_i]               = i_sl_tx_pcs66_d[66*elane_remap_i+65:66*elane_remap_i];
        assign i_sl_tx_pma_2d[elane_remap_i]                   = i_sl_tx_pma[80*elane_remap_i+79:80*elane_remap_i];
        assign i_sl_eth_reconfig_addr_2d[elane_remap_i]        = a_sl_eth_reconfig_addr[19*elane_remap_i+18:19*elane_remap_i];
        assign i_sl_eth_reconfig_writedata_2d[elane_remap_i]   = a_sl_eth_reconfig_writedata[32*elane_remap_i+31:32*elane_remap_i];
        assign i_sl_ptp_fp_2d[elane_remap_i]                   = i_sl_ptp_fp[8*elane_remap_i+7:8*elane_remap_i];
        assign i_sl_ptp_ts_offset_2d[elane_remap_i]            = i_sl_ptp_ts_offset[16*elane_remap_i+15:16*elane_remap_i];
        assign i_sl_ptp_cf_offset_2d[elane_remap_i]            = i_sl_ptp_cf_offset[16*elane_remap_i+15:16*elane_remap_i];
        assign i_sl_ptp_csum_offset_2d[elane_remap_i]          = i_sl_ptp_csum_offset[16*elane_remap_i+15:16*elane_remap_i];
        assign i_sl_ptp_eb_offset_2d[elane_remap_i]            = i_sl_ptp_eb_offset[16*elane_remap_i+15:16*elane_remap_i];
        assign i_sl_ptp_tx_its_2d[elane_remap_i]               = i_sl_ptp_tx_its[96*elane_remap_i+95:96*elane_remap_i];

        if (( core_variant == 0) ||
                 ( core_variant == 1) ||
                 ((core_variant == 3) && (active_channel == 0)) ||
                 ( core_variant == 4) || (core_variant == 5) || (core_variant == 7)) begin : READ_ELANE_OUT
        // output ports
        assign o_sl_rx_data[64*elane_remap_i+63:64*elane_remap_i]                 = o_sl_rx_data_2d[elane_remap_i];
        assign o_sl_rx_empty[3*elane_remap_i+2:3*elane_remap_i]                   = o_sl_rx_empty_2d[elane_remap_i];
        assign o_sl_rx_error[6*elane_remap_i+5:6*elane_remap_i]                   = o_sl_rx_error_2d[elane_remap_i];
        assign o_sl_rxstatus_data[40*elane_remap_i+39:40*elane_remap_i]           = o_sl_rxstatus_data_2d[elane_remap_i];
        assign o_sl_rx_pfc[8*elane_remap_i+7:8*elane_remap_i]                     = o_sl_rx_pfc_2d[elane_remap_i];
        assign o_sl_rx_mii_d[64*elane_remap_i+63:64*elane_remap_i]                = o_sl_rx_mii_d_2d[elane_remap_i];
        assign o_sl_rx_mii_c[8*elane_remap_i+7:8*elane_remap_i]                   = o_sl_rx_mii_c_2d[elane_remap_i];
        assign o_sl_rx_pcs66_d[66*elane_remap_i+65:66*elane_remap_i]              = o_sl_rx_pcs66_d_2d[elane_remap_i];
        assign o_sl_rx_pma[80*elane_remap_i+79:80*elane_remap_i]                  = o_sl_rx_pma_2d[elane_remap_i];
        assign a_sl_eth_reconfig_readdata[32*elane_remap_i+31:32*elane_remap_i]   = o_sl_eth_reconfig_readdata_2d[elane_remap_i];
        assign o_sl_ptp_ets[96*elane_remap_i+95:96*elane_remap_i]                 = o_sl_ptp_ets_2d[elane_remap_i];
        assign o_sl_ptp_ets_fp[8*elane_remap_i+7:8*elane_remap_i]                 = o_sl_ptp_ets_fp_2d[elane_remap_i];
        assign o_sl_ptp_rx_its[96*elane_remap_i+95:96*elane_remap_i]              = o_sl_ptp_rx_its_2d[elane_remap_i];
      end
      else begin
        assign o_sl_rx_data[64*elane_remap_i+63:64*elane_remap_i]                 = 0;
        assign o_sl_rx_empty[3*elane_remap_i+2:3*elane_remap_i]                   = 0;
        assign o_sl_rx_error[6*elane_remap_i+5:6*elane_remap_i]                   = 0;
        assign o_sl_rxstatus_data[40*elane_remap_i+39:40*elane_remap_i]           = 0;
        assign o_sl_rx_pfc[8*elane_remap_i+7:8*elane_remap_i]                     = 0;
        assign o_sl_rx_mii_d[64*elane_remap_i+63:64*elane_remap_i]                = 0;
        assign o_sl_rx_mii_c[8*elane_remap_i+7:8*elane_remap_i]                   = 0;
        assign o_sl_rx_pcs66_d[66*elane_remap_i+65:66*elane_remap_i]              = 0;
        assign o_sl_rx_pma[80*elane_remap_i+79:80*elane_remap_i]                  = 0;
        assign a_sl_eth_reconfig_readdata[32*elane_remap_i+31:32*elane_remap_i]   = 0;
        assign o_sl_ptp_ets[96*elane_remap_i+95:96*elane_remap_i]                 = 0;
        assign o_sl_ptp_ets_fp[8*elane_remap_i+7:8*elane_remap_i]                 = 0;
        assign o_sl_ptp_rx_its[96*elane_remap_i+95:96*elane_remap_i]              = 0;
      end
      end
   endgenerate

   wire 		   tx_lanes_stable; //Asserted when TX MAC is ready to send data

   generate
      if ((core_variant == 2) || ((core_variant == 3) && (active_channel == 1))) begin : CDR_LOCK
        assign o_cdr_lock[0]      = &rx_is_lockedtodata;
        assign o_tx_pll_locked[0] = &tx_pma_ready;
      end
      else begin
        assign o_cdr_lock      = sl_rx_is_lockedtodata;
        assign o_tx_pll_locked = o_sl_tx_pma_ready;
      end
   endgenerate

    wire int_tx_clk;
    wire int_rx_clk;

    wire int_tx_clk_w;
    wire int_rx_clk_w;

    generate
        if (topology == "ehip_4ch_kpfec") begin : kpfec_cc_gen
            logic ehip_tx_rst_sync;
            alt_ehipc3_fm_altera_std_synchronizer_nocut cc_timer_reset_sync_inst (
                .clk        (int_tx_clk),
                .reset_n    (1'b1),
                .din        (ehip_tx_rst),
                .dout       (ehip_tx_rst_sync)
            );

            alt_ehipc3_fm_kpfec_cadence_gen cc_gen_inst (
                .clk            (int_tx_clk),
                .reset          (ehip_tx_rst_sync),
                .cadence_pulse  (i_custom_cadence)
            );
        end else begin  : non_kpfec_cc_gen
            assign i_custom_cadence = 1'b0;
        end
    endgenerate

    assign o_local_fault_status =  (!o_rx_pcs_ready) ? 1'b1 : o_local_fault_status_1 ;

    generate
        if((core_variant == 3) && (active_channel == 1) && ENABLE_PTP) begin : INT_CLK_PTP
            assign int_tx_clk_w = tx_clkout_div64[4];
            assign int_rx_clk_w = tx_clkout_div64[4];
        end
        else begin
            assign int_tx_clk_w = tx_clkout_div64[0];
            assign int_rx_clk_w = tx_clkout_div64[0]; // rx and tx sourced from tx-side
        end
    endgenerate

    generate
        if(ENABLE_ASYNC_ADAPTERS) begin : INT_CLK
            assign int_tx_clk = int_tx_clk_w;
            assign int_rx_clk = int_rx_clk_w; // rx and tx sourced from tx-side
        end
        else begin
            assign int_tx_clk = i_clk_tx;
            assign int_rx_clk = i_clk_rx; //support external clock.
        end
    endgenerate

//PLL_DIV64
            assign o_clk_pll_div64    = tx_clkout_div64[max_clkout-1:0];


   assign o_clk_pll_div66 = tx_clkout_div66[max_clkout-1:0];
   assign o_clk_rec_div64 = rx_clkout_div64[max_clkout-1:0];
   assign o_clk_rec_div66 = rx_clkout_div66[max_clkout-1:0];
   assign o_tx_lanes_stable = tx_lanes_stable;
   assign o_rx_hi_ber = ehip_rx_hi_ber_out;
   assign o_rx_pcs_fully_aligned = ehip_rx_pcs_fully_aligned_out;

   wire [num_lanes-1:0] [63:0] int_tx_data;
   wire [num_lanes-1:0] [63:0] int_tx_mii_d; // TX MII data
   wire [num_lanes-1:0] [7:0]  int_tx_mii_c; // Tx MII control
   wire 		   int_tx_mii_valid;
   wire 		   int_tx_mii_am;

   wire [num_lanes-1:0] [63:0] int_rx_mii_d;
   wire [num_lanes-1:0] [7:0]  int_rx_mii_c;
   wire                        int_rx_mii_valid;
   wire                        int_rx_mii_am_valid;
   wire [num_lanes-1:0] [65:0] int_tx_pcs66_d;
   wire 		       int_tx_pcs66_valid;
   wire 		       int_tx_pcs66_am;
   wire [num_lanes-1:0] [65:0] int_rx_pcs66_d;


   wire [4-1:0][7:0]	 	i_ptp_tx_fp = {4{o_ptp_fp_tb[7:0]}}; //[4-1:0][7:0]
   wire [4-1:0][2:0]      	i_ptp_byte_offset_hard = o_ptp_byte_offset[11:0]; //[4-1:0][2:0]
   wire [4-1:0][2:0]      	i_ptp_ins_type_hard = o_ptp_ins_type[11:0]; //[4-1:0][2:0];
   wire [4-1:0][23:0]     	i_ptp_ts = o_ptp_ing_ts_tb[95:0]; //[4-1:0][23:0]


   wire [num_lanes-1:0] [65:0] dsk_rx_pcs66_data;
   wire [num_lanes-1:0]        dsk_rx_pcs66_valid;
   wire [num_lanes-1:0]        dsk_rx_pcs66_am_valid;
   wire [64*num_lanes-1:0]     dsk_rx_pcs64_d;
   wire [8*num_lanes-1:0]      dsk_rx_pcs64_c;
   wire [num_lanes-1:0]        dsk_rx_pcs64_valid;
   wire [num_lanes-1:0]        dsk_rx_pcs64_am_valid;

   assign                      o_rx_mii_d = dsk_rx_pcs64_d;
   assign                      o_rx_mii_c = dsk_rx_pcs64_c;
   assign                      o_rx_mii_valid = dsk_rx_pcs64_valid[0];
   assign                      o_rx_mii_am_valid = dsk_rx_pcs64_am_valid[0];

   assign                      o_rx_pcs66_d ={dsk_rx_pcs66_data[3],dsk_rx_pcs66_data[2],dsk_rx_pcs66_data[1],dsk_rx_pcs66_data[0]};
   assign                      o_rx_pcs66_valid = dsk_rx_pcs66_valid[0];
   assign                      o_rx_pcs66_am_valid = dsk_rx_pcs66_am_valid[0];

   genvar          ig;

   // Assign MII, PCS66  ports
   generate
      for (ig=0; ig<num_lanes; ig=ig+1) begin : g_pcs_inst
	 // MII data and control bits
	 assign int_tx_mii_d[ig] = i_tx_mii_d[ig*64+:64];
	 assign int_tx_mii_c[ig] = i_tx_mii_c[ig*8+:8];

   // PCS66 data
	 assign int_tx_pcs66_d[ig] = i_tx_pcs66_d[ig*66+:66];
      end
   endgenerate

   assign int_tx_mii_valid = i_tx_mii_valid;
   assign int_tx_mii_am = i_tx_mii_am;

   // Assign PCS66 ports
   assign int_tx_pcs66_valid = i_tx_pcs66_valid;
   assign int_tx_pcs66_am = i_tx_pcs66_am;

    logic [num_lanes-1:0][63:0]     ml_tx_data_wire;
    logic [num_lanes-1:0]           ml_tx_inframe_wire;
    logic [num_lanes-1:0][2:0]      ml_tx_empty_wire;
    logic [num_lanes-1:0]           ml_tx_error_wire;
    logic [num_lanes-1:0]           ml_tx_skip_crc_wire;

    logic [num_lanes-1:0][63:0]     ml_tx_data;
    logic [num_lanes-1:0]           ml_tx_inframe;
    logic [num_lanes-1:0][2:0]      ml_tx_empty;
    logic [num_lanes-1:0]           ml_tx_error;
    logic [num_lanes-1:0]           ml_tx_skip_crc;

    reg                             ml_tx_inframe_r;
    wire [num_lanes-1:0]            ml_tx_sop;

    wire                            ml_rx_valid;
    wire [64*num_lanes-1:0]         ml_rx_data;
    wire [num_lanes-1:0]            ml_rx_inframe;
    wire [num_lanes*3-1:0]          ml_rx_empty;
    wire [num_lanes*2-1:0]          ml_rx_error;
    wire [num_lanes-1:0]            ml_rx_fcs_error;
    wire [num_lanes*3-1:0]          ml_rx_status;

    // EHIP Interface: TX 1-step and 2-step Command
    wire [num_lanes-1:0][2:0]       ml_ptp_ins_type;
    wire [num_lanes-1:0][2:0]       ml_ptp_byte_offset;
    wire                [95:0]      ml_ptp_ts;
    wire                [7:0]       ml_ptp_tx_fp;

    // PTP from EHIP
    // EHIP Interface: Reference Timestamp
    wire [num_lanes-1:0]            ml_sclk;
    wire [num_lanes-1:0]            ml_tx_sel_sclk_return;
    wire [num_lanes-1:0]            ml_rx_sel_sclk_return;
    wire [num_lanes-1:0]            ml_tx_sclk_return;
    wire [num_lanes-1:0]            ml_rx_sclk_return;
    wire                            ml_tx_am;
    wire                            ml_rx_am;

    // EHIP Interface: VL Offset Read
    wire                            ml_read_ptp_vl_data;
    wire                [4:0]       ml_select_ptp_vl_data;

    // PTP to EHIP
    // EHIP Interface: TX 1-step and 2-step Command
    wire [sl_num_lanes-1:0][1:0]    sl_ptp_tx_fp_to_ehip;
    wire [sl_num_lanes-1:0][2:0]    sl_ptp_ins_type;
    wire [sl_num_lanes-1:0][2:0]    sl_ptp_byte_offset;
    wire [sl_num_lanes-1:0][23:0]   sl_ptp_ts;

    // PTP from EHIP
    // EHIP Interface: TX 2-step Timestamp
    wire [sl_num_lanes-1:0]         sl_ptp_tx_ts_valid;
    wire [sl_num_lanes-1:0][11:0]   sl_ptp_tx_ts;
    wire [sl_num_lanes-1:0][1:0]    sl_ptp_tx_ts_fp_from_ehip;

    // PTP from EHIP
    // EHIP Interface: RX Timestamp
    wire [sl_num_lanes-1:0][20:0]   sl_ptp_rx_ts;

    // PTP from EHIP
    // EHIP Interface: Reference Timestamp
    wire [sl_num_lanes-1:0]         sl_sclk;
    wire [sl_num_lanes-1:0]         sl_tx_sel_sclk_return;
    wire [sl_num_lanes-1:0]         sl_rx_sel_sclk_return;
    wire [sl_num_lanes-1:0]         sl_tx_sclk_return;
    wire [sl_num_lanes-1:0]         sl_rx_sclk_return;
    wire [sl_num_lanes-1:0]         sl_tx_am;
    wire [sl_num_lanes-1:0]         sl_rx_am;

//AVMM DPRIO Interface
   wire 	       ehip_reconfig_rst_n;
   wire 	       ehip_reconfig_waitrequest;
   wire 	       ehip_reconfig_read;
   wire [20:0] 	       ehip_reconfig_address;
   wire 	       ehip_reconfig_write;
   wire [7:0] 	       ehip_reconfig_writedata;
   wire [7:0] 	       ehip_reconfig_readdata;


  //XCVR Reconfig Interface
   wire 	       xcvr_reconfig_clk;
   wire [max_xcvr_ch-1:0] xcvr_reconfig_write;
   wire [max_xcvr_ch-1:0] xcvr_reconfig_read;
   wire [19*max_xcvr_ch-1:0] xcvr_reconfig_address;
   wire [8*max_xcvr_ch-1:0]  xcvr_reconfig_writedata;
   wire [8*max_xcvr_ch-1:0]  xcvr_reconfig_readdata;
   wire [max_xcvr_ch-1:0]    xcvr_reconfig_waitrequest;

   //XCVR Reconfig Interface based on variants
   wire [max_xcvr_ch-1:0]    var_xcvr_reconfig_write;
   wire [max_xcvr_ch-1:0]    var_xcvr_reconfig_read;
   wire [19*max_xcvr_ch-1:0] var_xcvr_reconfig_address;
   wire [8*max_xcvr_ch-1:0]  var_xcvr_reconfig_writedata;
   wire [8*max_xcvr_ch-1:0]  var_xcvr_reconfig_readdata;
   wire [max_xcvr_ch-1:0]    var_xcvr_reconfig_waitrequest;

  //10G,25G ELANE XCVR Reconfig Interface
   wire 	       sl_xcvr_reconfig_clk;
   wire [sl_num_lanes-1:0] sl_xcvr_reconfig_write;
   wire [sl_num_lanes-1:0] sl_xcvr_reconfig_read;
   wire [19*sl_num_lanes-1:0] sl_xcvr_reconfig_address;
   wire [8*sl_num_lanes-1:0]  sl_xcvr_reconfig_writedata;
   wire [8*sl_num_lanes-1:0]  sl_xcvr_reconfig_readdata;
   wire [sl_num_lanes-1:0]    sl_xcvr_reconfig_waitrequest;

   wire				xcvr_reconfig_clk_ptp;

   wire  		rsfec_reconfig_write;
   wire  		rsfec_reconfig_read;
   wire  [10:0] rsfec_reconfig_address;
   wire  [7:0]          rsfec_reconfig_writedata;
   wire  [7:0]          rsfec_reconfig_readdata;

   wire  		rsfec_reconfig_waitrequest;

   assign ehip_reconfig_clk 	= i_reconfig_clk;
   assign xcvr_reconfig_clk 	= i_reconfig_clk;
   assign xcvr_reconfig_clk_ptp	= i_reconfig_clk;
   assign fec_reconfig_clk	= i_reconfig_clk;
   assign fec_reconfig_clk_ptp	= i_reconfig_clk;

   assign ehip_reconfig_rst_n = ~i_reconfig_reset;

   // AVMM arbitration

    logic   soft_csr_phy_sel;   // PHY registers implemented in soft logic
    logic   kr_sel;             // KR registers
    logic   soft_ptp_sel;       // PTP registers
    logic   ehip_sel;           // Hard EHIP regisers
    logic   other_sel;          // For responses to undefined registers

    always_comb begin
        soft_csr_phy_sel    = 1'b0;
        kr_sel              = 1'b0;
        ehip_sel            = 1'b0;
        soft_ptp_sel        = 1'b0;
        other_sel           = 1'b0;
        case (a_eth_reconfig_addr[15:0]) inside
            [16'h000:16'h0FF]   : kr_sel            = 1'b1;
            [16'h300:16'h30F]   : ehip_sel          = 1'b1;
            [16'h310:16'h322]   : soft_csr_phy_sel  = 1'b1;
            [16'h323:16'h328]   : ehip_sel          = 1'b1;
            [16'h329:16'h329]   : soft_csr_phy_sel  = 1'b1;
            [16'h32A:16'h32A]   : ehip_sel          = 1'b1;
            [16'h32B:16'h32C]   : soft_csr_phy_sel  = 1'b1;      // Added 32B, 32C registers for reset status
            [16'h32D:16'h33F]   : ehip_sel          = 1'b1;
            [16'h340:16'h342]   : soft_csr_phy_sel  = 1'b1;
            [16'h343:16'h50F]   : ehip_sel          = 1'b1;
            [16'h510:16'h512]   : soft_csr_phy_sel  = 1'b1;
            [16'h513:16'h709]   : ehip_sel          = 1'b1;
            [16'h800:16'hBFF]   : ehip_sel          = 1'b1;
            [16'hC00:16'hCFF]   : soft_ptp_sel      = 1'b1;
            default             : other_sel         = 1'b1;
        endcase
    end
   wire ehip_ready;
   // sync ehip_ready
   wire ehip_ready_sync;

    wire    soft_csr_phy_read   = a_eth_reconfig_read && soft_csr_phy_sel;
    wire    kr_read             = a_eth_reconfig_read && kr_sel;
//    wire    ehip_read           = a_eth_reconfig_read && ehip_sel;
//    wire    other_read          = a_eth_reconfig_read && other_sel;
    wire    ehip_read           = a_eth_reconfig_read && ehip_sel && ehip_ready_sync;
    wire    other_read          = a_eth_reconfig_read && (other_sel || (!ehip_ready_sync && ehip_sel)) ;

    wire    soft_ptp_read       = a_eth_reconfig_read && soft_ptp_sel;

    wire    soft_csr_phy_write  = a_eth_reconfig_write && soft_csr_phy_sel;
    wire    kr_write            = a_eth_reconfig_write && kr_sel;
//    wire    ehip_write          = a_eth_reconfig_write && ehip_sel;
//    wire    other_write         = a_eth_reconfig_write && other_sel;
    wire     ehip_write          = a_eth_reconfig_write && ehip_sel && ehip_ready_sync;
    wire     other_write         = a_eth_reconfig_write && (other_sel || (!ehip_ready_sync && ehip_sel));
    wire    soft_ptp_write      = a_eth_reconfig_write && soft_ptp_sel;

    wire [sl_num_lanes-1:0][15:0]  sl_a;
	wire [sl_num_lanes-1:0]   sl_kr_sel;
    wire [sl_num_lanes-1:0] sl_kr_read;
	wire [sl_num_lanes-1:0] sl_kr_write;
	wire [sl_num_lanes-1:0][31:0] sl_kr_read_data;
	wire [sl_num_lanes-1:0] sl_kr_read_valid;
	wire [sl_num_lanes-1:0] sl_kr_wait;
	genvar i;
	generate
      if(ENABLE_ANLT) begin : GENKR_CSR
	for (i = 0; i < sl_num_lanes; i = i + 1) begin : SL_ETH
			assign sl_a[i][15:0]						= {4'h0,i_sl_eth_reconfig_addr_2d[i][11:0]};
			assign sl_kr_sel[i]  	    	 	= ((sl_a[i][15:0] >= 16'h0B0) && (sl_a[i][15:0] <= 16'h0FF));
		assign sl_kr_read[i]   	        = a_sl_eth_reconfig_read[i] & sl_kr_sel[i];
		assign sl_kr_write[i]          	= a_sl_eth_reconfig_write[i] & sl_kr_sel[i];
		end
	  end
	endgenerate

    // Aliased regisers
    logic           phy_clear_dsk_chng_sticky;
	logic 	     stats_snapshot_freeze;	//hsd:2205696595 Adding stats_snapshot_freeze_reg

    // -----------------------------
    // EHIP RX PCS deskew status
    // -----------------------------
    logic           ehip_rx_dsk_done_out_sync;
    logic           ehip_rx_dsk_done_out_sync_last;
    logic           ehip_rx_dsk_done_chng;
    logic           ehip_rx_dsk_done_chng_sticky;

    alt_ehipc3_fm_altera_std_synchronizer_nocut rx_dsk_sync_inst (
        .clk        (i_reconfig_clk),
        .reset_n    (1'b1),
        .din        (ehip_rx_dsk_done_out),
        .dout       (ehip_rx_dsk_done_out_sync)
    );

    always_ff @(posedge i_reconfig_clk) begin
        ehip_rx_dsk_done_out_sync_last  <= ehip_rx_dsk_done_out_sync;
        ehip_rx_dsk_done_chng           <= ehip_rx_dsk_done_out_sync_last ^ ehip_rx_dsk_done_out_sync;

        if (reconfig_reset_sync) begin
            ehip_rx_dsk_done_chng_sticky    <= 1'b0;
        end else begin
            if (phy_clear_dsk_chng_sticky) begin
                ehip_rx_dsk_done_chng_sticky    <= 1'b0;
            end else begin
                ehip_rx_dsk_done_chng_sticky    <= ehip_rx_dsk_done_chng_sticky || ehip_rx_dsk_done_chng;
            end
        end
    end

    // -----------------------------
    // EHIP PCS deskew status end
    // -----------------------------

    logic           kr_read_valid;
    wire    [31:0]  kr_read_data;
    wire            kr_wait;

    wire            ehip_read_valid;
    wire    [31:0]  ehip_read_data;
    wire            ehip_wait;

    wire            soft_csr_phy_read_valid;
    wire    [31:0]  soft_csr_phy_read_data;
    wire            soft_csr_phy_wait   = 1'b0;

    reg             soft_ptp_read_valid;
    wire    [31:0]  soft_ptp_read_data;
    wire            soft_ptp_wait;

    wire    [31:0]  other_read_data = 32'hdeadc0de;
    reg             other_read_data_valid;
    wire            other_wait = 1'b0;

    wire    [31:0]  ehip_sladdress;
    wire            ehip_slread;
    wire            ehip_slwrite;
    wire    [7:0]   ehip_slwrite_data;
    wire    [7:0]   ehip_slread_data;
    wire            ehip_slwait_request;

    // testbus ports : leave for PTP use, tie to 0 temp. Please reference to 10.3. EHIP Testbus
    wire            i_testbus_en =0;
    wire    [5:0]   i_testbus_source=0;
    wire    [5:0]   i_testbus_sel=0;
    wire    [3:0]   csr_rx_is_lockedtodata;

    // Wait request
    always_comb begin
      if (i_reconfig_reset)
	          a_eth_reconfig_waitrequest = 1'b1;
      else begin
        case (1'b1)
            soft_csr_phy_sel    : a_eth_reconfig_waitrequest    = soft_csr_phy_wait;
            ehip_sel            : a_eth_reconfig_waitrequest    = ehip_wait;
            kr_sel              : a_eth_reconfig_waitrequest    = kr_wait;
            soft_ptp_sel        : a_eth_reconfig_waitrequest    = soft_ptp_wait;
            default             : a_eth_reconfig_waitrequest    = other_wait;
        endcase
      end // else : !(i_reconfig_reset)
    end // always_comb

    // data valid
    assign a_eth_reconfig_readdata_valid    = ehip_read_valid | kr_read_valid | soft_csr_phy_read_valid | soft_ptp_read_valid | other_read_data_valid;

    // read data
    always_comb begin
        case (1'b1)
            ehip_read_valid         : a_eth_reconfig_readdata   = ehip_read_data;
            soft_csr_phy_read_valid : a_eth_reconfig_readdata   = soft_csr_phy_read_data;
            kr_read_valid           : a_eth_reconfig_readdata   = kr_read_data;
            soft_ptp_read_valid     : a_eth_reconfig_readdata   = soft_ptp_read_data;
            default                 : a_eth_reconfig_readdata   = other_read_data;
        endcase
    end

    always_ff @(posedge i_reconfig_clk) other_read_data_valid   <= other_read;


   // sync reconfig_reset as in module avmm_32_8 and alt_ehipc2_csr.v and alt_ehipc2_adapt_pma it is used as a synchronous reset
       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_reconfig_reset (
           .clk    (i_reconfig_clk),
           .reset  (1'b0),
           .d  (i_reconfig_reset),
           .q  (reconfig_reset_sync)
       );
   reg tx_lanes_stable_sync_r;
   reg tx_lanes_stable_sync_rr;
   reg tx_lanes_stable_sync_rrr;
   reg tx_lanes_stable_sync;
   wire tx_lanes_stable_sync_wire;

   always @ (posedge int_tx_clk) begin
       tx_lanes_stable_sync_r <= tx_lanes_stable_sync_wire;
       tx_lanes_stable_sync_rr <= tx_lanes_stable_sync_r;
       tx_lanes_stable_sync_rrr <= tx_lanes_stable_sync_rr;
       tx_lanes_stable_sync <= tx_lanes_stable_sync_rrr;
   end

   // tx_lanes_stable_sync is used in alt_ehipc2_50g_adapter_tx_pp, alt_ehipc2_50g_adapter_tx and alt_ehipc2_100g_adapter_tx
       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_tx_lanes_stable (
           .clk    (int_tx_clk),
           .reset  (1'b0),
           .d  (tx_lanes_stable),
           .q  (tx_lanes_stable_sync_wire)
       );

   reg  rx_pcs_ready_sync_r;
   reg  rx_pcs_ready_sync_rr;
   reg  rx_pcs_ready_sync_rr_n;
   reg  rx_pcs_ready_sync_rrr_n;
   reg  rx_pcs_ready_sync_rrrr_n;
   reg  rx_pcs_ready_sync_rrrrr_n;
   wire rx_pcs_ready_as_reset;
   wire rx_pcs_ready_sync_wire;
   always @ (posedge int_rx_clk) begin
       rx_pcs_ready_sync_r <= rx_pcs_ready_sync_wire;
       rx_pcs_ready_sync_rr <= rx_pcs_ready_sync_r;
       rx_pcs_ready_sync_rr_n <= ~rx_pcs_ready_sync_r;
       rx_pcs_ready_sync_rrr_n <= rx_pcs_ready_sync_rr_n;
       rx_pcs_ready_sync_rrrr_n <= rx_pcs_ready_sync_rrr_n;
       rx_pcs_ready_sync_rrrrr_n <= rx_pcs_ready_sync_rrrr_n;
   end
   assign rx_pcs_ready_as_reset = rx_pcs_ready_sync_rrrrr_n;
   // rx_pcs_ready_as_reset is used in alt_ehipc2_50g_adapter_tx_pp, alt_ehipc2_50g_adapter_tx and alt_ehipc2_100g_adapter_tx
       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_o_rx_pcs_ready (
           .clk    (int_rx_clk),
           .reset  (1'b0),
           .d  (o_rx_pcs_ready),
           .q  (rx_pcs_ready_sync_wire)
       );
   wire tx_lanes_stable_int_rx_clk;
       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) tx_lanes_stable_int_rx_clk_sync (
           .clk    (int_rx_clk),
           .reset  (1'b0),
           .d  (&tx_pma_ready),
           .q  (tx_lanes_stable_int_rx_clk)
       );

   wire rx_pcs_ready_sync;
   alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_ehip_ready (
           .clk    (i_reconfig_clk),
           .reset  (1'b0),
           .d  (ehip_ready),
           .q  (ehip_ready_sync)
       );
  /*
       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_csr_rx_is_lockedtodata (
           .clk    (i_reconfig_clk),
           .reset  (1'b0),
           .d  (&csr_rx_is_lockedtodata),
           .q  (csr_rx_is_lockedtodata_sync)
       );
  */
wire txAdpt_to_rxAdpt_loopback_sync_w;
reg  txAdpt_to_rxAdpt_loopback_sync_r;
wire txAdpt_to_rxAdpt_loopback_sync;
       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_txAdpt_to_rxAdpt_loopback (
           .clk    (int_rx_clk),
           .reset  (1'b0),
           .d  (txAdpt_to_rxAdpt_loopback),
           .q  (txAdpt_to_rxAdpt_loopback_sync_w)
       );

       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_o_rx_rst_n_ack (
           .clk    (int_rx_clk),
           .reset  (1'b0),
           .d  (ehip_rx_rst_n_ack),
           .q  (ehip_rx_rst_n_ack_sync_wire)
       );

       always @ (posedge int_rx_clk) begin
           ehip_rx_rst_n_ack_sync_r <= ehip_rx_rst_n_ack_sync_wire;
           ehip_rx_rst_n_ack_sync_rr <= ehip_rx_rst_n_ack_sync_r;
           ehip_rx_rst_n_ack_sync <= ehip_rx_rst_n_ack_sync_rr;
       end


    alt_ehipc3_fm_avmm_32to8 #(
        .TIMEOUT    (1000)
    ) avmm_32b_to_8b (
        .clk                (i_reconfig_clk),
        .reset              (reconfig_reset_sync),
        .master_read        (ehip_read),
        .master_write       (ehip_write),
        .master_address     ({16'd0, a_eth_reconfig_addr[15:0]}),
        .master_write_data  (a_eth_reconfig_writedata),
        .master_byte_enable (4'b1111),  // Need to add byte enable port
        .master_read_valid  (ehip_read_valid),
        .master_wait        (ehip_wait),
        .master_read_data   (ehip_read_data),
        .slave_read         (ehip_slread),
        .slave_write        (ehip_slwrite),
        .slave_address      (ehip_sladdress),
        .slave_write_data   (ehip_slwrite_data),
        .slave_read_valid   (1'b1/*ehip_slread_data_valid*/),
        .slave_wait         (ehip_slwait_request),
        .slave_read_data    (ehip_slread_data[7:0])
    );

   wire   [32-1:0] o_rsfec_channel_ssr; //[0]:rsfec_lane_rx_stat.not_locked, [1]: rsfec_lane_rx_stat.hi_ser, [2]: o_pcs_rx_sf(signal failed from rsfec_core)
   wire rsfec_signal_ok_from_top = dis_rsfec ? (rx_is_lockedtodata==4'hf) : (rx_is_lockedtodata==4'hf) && (rsfec_o_fec_ready);

   generate
        if (ENABLE_RSFEC_MODE) begin : ehip_signal_ok_rsfec
            assign ehip_signal_ok_p= dis_rsfec ? ehip_signal_ok : ehip_signal_ok && (!o_rsfec_channel_ssr[2]);
        end else begin  : ehip_signal_ok_norsfec
            assign ehip_signal_ok_p= ehip_signal_ok;
        end
   endgenerate


    wire    [3:0]   csr_tx_pll_locked;
    generate
        if (num_lanes == 2) begin
            assign csr_tx_pll_locked        = {2'b00, {2{1'b1}}};
            assign csr_rx_is_lockedtodata   = {2'b00, rx_is_lockedtodata};
        end else begin  // 4 lanes
            assign csr_tx_pll_locked        = {{2{1'b1}}, {2{1'b1}}};
            assign csr_rx_is_lockedtodata   = rx_is_lockedtodata;
        end
    endgenerate

   wire [31:0]  khz_ref_phy;
   wire [31:0]  khz_rx_clk64;
   wire [31:0]  khz_tx_clk64;
   wire [15:0] 	int_khz_ref_phy;
   wire [15:0]  int_khz_rx_clk64;
   wire [15:0]  int_khz_tx_clk64;
   assign khz_ref_phy = {16'd0, int_khz_ref_phy};
   assign khz_rx_clk64 = {16'd0, int_khz_rx_clk64};
   assign khz_tx_clk64 = {16'd0, int_khz_tx_clk64};
   alt_ehipc3_fm_clock_mon clk_mon_inst
     (
      .csr_clk(i_reconfig_clk),
      .cdr_ref_clk(i_clk_ref_m[0]),
      // Inputs
      .tx_clk64(o_clk_pll_div64[0]),
      .rx_clk64(o_clk_rec_div64[0]),
      .tx_clk66(o_clk_pll_div66[0]),
      .rx_clk66(o_clk_rec_div66[0]),
      // outputs
      .khz_ref_phy(int_khz_ref_phy),
      .khz_rx_clk64(int_khz_rx_clk64),
      .khz_tx_clk64(int_khz_tx_clk64),
      .khz_rx_clk66(),
      .khz_tx_clk66()
      );
defparam    clk_mon_inst .SIM_HURRY = SIM_HURRY;
defparam    clk_mon_inst .SIM_EMULATE = SIM_EMULATE;

    // -----------------------------
    // EHIP reset status for CSR
    // -----------------------------
   wire [3:0] 	tx_transfer_ready_sync;
   wire [3:0] 	rx_transfer_ready_sync;
   wire [1:0] 	ptp_tx_transfer_ready_sync;
   wire [1:0] 	ptp_rx_transfer_ready_sync;
   wire ehip_rst_sync;
   wire ehip_tx_rst_ssync;
   wire ehip_rx_rst_sync;
   wire rsfec_rst_sync;
   wire rsfec_tx_rst_sync;
   wire rsfec_rx_rst_sync;


   alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH(3),    .WIDTH(4),  .INIT_VALUE(0)
        ) txxfrerrdy_sync_inst (
        .clk     (i_reconfig_clk),
        .reset   (1'b0),
        .d       (tx_transfer_ready[3:0]),
        .q       (tx_transfer_ready_sync)
    );

    alt_xcvr_resync_std #(
       .SYNC_CHAIN_LENGTH(3),    .WIDTH(4),  .INIT_VALUE(0)
     )  rxxfrerrdy_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (rx_transfer_ready[3:0]),
        .q        (rx_transfer_ready_sync)
        );



    alt_xcvr_resync_std #(
       .SYNC_CHAIN_LENGTH(3),    .WIDTH(2),  .INIT_VALUE(0)
    ) ptptxxfrerrdy_sync_inst (
       .clk  (i_reconfig_clk),
       .reset(1'b0),
       .d    (ptp_tx_transfer_ready),
       .q    (ptp_tx_transfer_ready_sync)
       );


    alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH(3),    .WIDTH(2),  .INIT_VALUE(0)
   ) ptprxxfrerrdy_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (ptp_rx_transfer_ready),
        .q        (ptp_rx_transfer_ready_sync)
	);



    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
  ) ehiprst_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (ehip_rst),
        .q        (ehip_rst_sync)
	);


    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
  ) ehiptxrst_sync_inst (
        .clk     (i_reconfig_clk),
        .reset   (1'b0),
        .d       (ehip_tx_rst),
        .q       (ehip_tx_rst_ssync)
        );


    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
  ) ehiprxrst_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (ehip_rx_rst),
        .q        (ehip_rx_rst_sync)
	);




    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
     ) rsfecrst_sync_inst (
        .clk        (i_reconfig_clk),
        .reset      (1'b0),
        .d          (rsfec_rst),
        .q          (rsfec_rst_sync)
    );

    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
     ) rsfectxrst_sync_inst (
        .clk        (i_reconfig_clk),
        .reset      (1'b0),
        .d          (rsfec_tx_rst),
        .q          (rsfec_tx_rst_sync)
    );


    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
     ) rsfecrxrst_sync_inst (
        .clk        (i_reconfig_clk),
        .reset      (1'b0),
        .d          (rsfec_rx_rst),
        .q          (rsfec_rx_rst_sync)
    );





    alt_ehipc3_fm_csr soft_csr (
        .clk                (i_reconfig_clk),
        .reset              (reconfig_reset_sync),
        .writedata          (a_eth_reconfig_writedata),
        .read               (soft_csr_phy_read),
        .write              (soft_csr_phy_write),
        .byteenable         (4'b1111),
        .readdata           (soft_csr_phy_read_data),
        .readdatavalid      (soft_csr_phy_read_valid),
        .address            (a_eth_reconfig_addr[11:0]),

        .rxmac_adapt_dropped_lo_count_i         (rx_adapt_dropped_frames_shadow[31:0]),
        .rxmac_adapt_dropped_hi_count_i         (rx_adapt_dropped_frames_shadow[63:32]),
        .rxmac_adapt_dropped_clear_clear_drops  (rx_adapt_clear_dropped_count),

        .phy_config_eio_sys_rst                 (soft_csr_rst),
        .phy_config_soft_tx_rst                 (soft_tx_rst),
        .phy_config_soft_rx_rst                 (soft_rx_rst),
        .phy_config_set_ref_lock                (),
        .phy_config_set_data_lock               (),
        .phy_pma_sloop_sloop                    (),
        // Need to add frequency counters
        .phy_txclk_khz_khz_tx_i                 (khz_tx_clk64),
        .phy_recclk_khz_khz_rx_i                (khz_rx_clk64),
        .phy_refclk_khz_khz_ref_i               (khz_ref_phy),
        .phy_tx_pll_locked_tx_pll_locked_i      (csr_tx_pll_locked),
        .phy_tx_corepll_locked_tx_pcs_ready_i   (tx_lanes_stable),
        .phy_eiofreq_locked_eio_freq_lock_i     (csr_rx_is_lockedtodata),
        .phy_pma_sloop_mac_adapter_loopback     (txAdpt_to_rxAdpt_loopback),
        .phy_pma_sloop_dis_rsfec                (dis_rsfec),
        .lanes_deskewed_dskew_status_i          (ehip_rx_dsk_done_out_sync),
        .lanes_deskewed_dskew_chng_i            (ehip_rx_dsk_done_chng_sticky),

	//Transfer ready status
	.aib_transfer_ready_status_ehip_tx_transfer_ready_i(tx_transfer_ready_sync),
	.aib_transfer_ready_status_ptp_tx_transfer_ready_i(ptp_tx_transfer_ready_sync),
	.aib_transfer_ready_status_ehip_rx_transfer_ready_i(rx_transfer_ready_sync),
	.aib_transfer_ready_status_ptp_rx_transfer_ready_i(ptp_rx_transfer_ready_sync),
	 //reset status from the reset controller
	.soft_rc_reset_status_ehip_reset_i(ehip_rst_sync),
	.soft_rc_reset_status_ehip_tx_reset_i(ehip_tx_rst_ssync),
	.soft_rc_reset_status_ehip_rx_reset_i(ehip_rx_rst_sync),
	.soft_rc_reset_status_ehip_rsfec_reset_i(rsfec_rst_sync),
	.soft_rc_reset_status_ehip_rsfec_tx_reset_i(rsfec_tx_rst_sync),
	.soft_rc_reset_status_ehip_rsfec_rx_reset_i(rsfec_rx_rst_sync)
    );

    // Copies of registers that live in EHIP
    alt_ehipc3_fm_alias_csr aliased_registers_inst (
        .reset              (reconfig_reset_sync),
        .clk                (i_reconfig_clk),
        .write              (a_eth_reconfig_write),
        .byte_en            (4'b1111),
        .address            (a_eth_reconfig_addr[15:0]),
        .write_data         (a_eth_reconfig_writedata),
        .phy_clear_dsk_chng (phy_clear_dsk_chng_sticky),
	.stats_snapshot_freeze_reg (stats_snapshot_freeze)
    );

   // END AVMM arbitration


   //*********************** PAUSE Work Arround *********************
    wire [sl_num_lanes-1:0] sl_ehip_ready;
    wire [sl_num_lanes-1:0] sl_ehip_ready_sync;
    wire [sl_num_lanes-1:0] o_sl_rx_pcs_ready_sync;
    wire [sl_num_lanes-1:0] sl_rx_pcs_ready_sync;
    wire [sl_num_lanes-1:0] i_sl_csr_rst_n_sync, sl_soft_csr_rst_sync, elane_sl_pause_reset;
    wire [sl_num_lanes-1:0] o_sl_rx_pause_sync;

    generate
        if ((( core_variant == 0) ||
             ( core_variant == 1) ||
             ((core_variant == 3) && (active_channel == 0)) ||
             ( core_variant == 4) || (core_variant == 5) || (core_variant == 7))) begin : SL_PAUSE
    for (i=0; i<sl_num_lanes; i++) begin: gen_alt_ehipc3_fm_sl_pause

       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_sl_ehip_ready (
           .clk    (i_reconfig_clk),
           .reset  (1'b0),
           .d      (sl_ehip_ready[i]),
           .q      (sl_ehip_ready_sync[i])
       );

       // Fixed rx_enh_pause cdc errors by adding synchronizer
       alt_ehipc3_fm_altera_std_synchronizer_nocut o_sl_rx_pause_sync_inst (
           .clk    	(i_sl_clk_rx[i]),
	   .reset_n    	(1'b1),
	   .din        	(o_sl_rx_pause[i]),
	   .dout       	(o_sl_rx_pause_sync[i])
       );

       // o_sl_rx_pcs_ready_sync is used in alt_ehipc2_50g_adapter_tx_pp, alt_ehipc2_50g_adapter_tx and alt_ehipc2_100g_adapter_tx
       alt_xcvr_resync_std #(
           .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
       ) sync_o_sl_rx_pcs_ready (
           .clk    (i_sl_clk_rx[i]),
           .reset  (1'b0),
           .d      (o_sl_rx_pcs_ready[i]),
           .q      (o_sl_rx_pcs_ready_sync[i])
       );

       // Pause workaround module + AVMM module.
       if (RX_ASYNC_ADAPTER_MODE || ENABLE_ANLT) begin
          // sync rx_pcs_ready
          alt_xcvr_resync_std #(
               .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
          ) sync_sl_rxpcs_ready (
               .clk    (i_sl_clk_rx[i]),
               .reset  (1'b0),
               .d      (o_sl_rx_pcs_ready[i]),
               .q      (sl_rx_pcs_ready_sync[i])
          );

       end else begin
         assign sl_rx_pcs_ready_sync[i] = o_sl_rx_pcs_ready_sync[i];
       end // else: !if(RX_ASYNC_ADAPTER_MODE || ENABLE_ANLT)

alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   sl_csr_reset_synchronizers1
     (	.clk	(i_sl_clk_rx[i]),
	.reset	(1'b0),
	.d	(i_sl_csr_rst_n[i]),
	.q	(i_sl_csr_rst_n_sync[i]));

alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   sl_csr_reset_synchronizers2
     (	.clk	(i_sl_clk_rx[i]),
	.reset	(1'b0),
	.d	(sl_soft_csr_rst[i]),
	.q	(sl_soft_csr_rst_sync[i]));
 assign elane_sl_pause_reset[i] = ~i_sl_csr_rst_n_sync[i] | sl_soft_csr_rst_sync[i];
       alt_ehipc3_fm_sl_pause #(
           .AW(19),
           .DW(32),
           .FLOW_CONTROL(flow_control_sl_0)
       ) alt_ehipc3_fm_sl_pause_inst (
             .i_clk                          (i_sl_clk_rx[i]),
             .i_rst_n                        (~elane_sl_pause_reset[i]),
             .i_ehip_ready                   (sl_ehip_ready_sync[i]),
             .i_reconfig_clk                 (i_reconfig_clk),
             .i_reconfig_reset               (reconfig_reset_sync),
             .i_rx_pcs_ready                 (o_sl_rx_pcs_ready[i]),
             .i_rx_pause                     (o_sl_rx_pause_sync[i]),
             .i_tx_ready                     (o_sl_tx_ready[i]),
             //AVMM interface to ELANE
             .o_eth_reconfig_addr            (a_sl_eth_reconfig_addr[i*19+:19]),
             .o_eth_reconfig_writedata       (a_sl_eth_reconfig_writedata[i*32+:32]),
             .o_eth_reconfig_write           (a_sl_eth_reconfig_write[i]),
             .o_eth_reconfig_read            (a_sl_eth_reconfig_read[i]),
             .i_eth_reconfig_readdata        (a_sl_eth_reconfig_readdata[i*32+:32]),
             .i_eth_reconfig_readdata_valid  (a_sl_eth_reconfig_readdata_valid[i]),
             .i_eth_reconfig_waitrequest     (a_sl_eth_reconfig_waitrequest[i]),
             // AVMM interface to Application
             .i_usr_reconfig_addr            (i_sl_eth_reconfig_addr_jtag_arb[i*19+:19]),
             .i_usr_reconfig_writedata       (i_sl_eth_reconfig_writedata_jtag_arb[i*32+:32]),
             .i_usr_reconfig_write           (i_sl_eth_reconfig_write_jtag_arb[i]),
             .i_usr_reconfig_read            (i_sl_eth_reconfig_read_jtag_arb[i]),
             .o_usr_reconfig_readdata        (o_sl_eth_reconfig_readdata_jtag_arb[i*32+:32]),
             .o_usr_reconfig_readdata_valid  (o_sl_eth_reconfig_readdata_valid_jtag_arb[i]),
             .o_usr_reconfig_waitrequest     (o_sl_eth_reconfig_waitrequest_jtag_arb[i]),
             .o_ehip_shadow                  (sl_pause_ehip_ready[i])
       );
/*
       assign a_sl_eth_reconfig_addr[i*19+:19]      = i_sl_eth_reconfig_addr_jtag_arb[i*19+:19];
       assign a_sl_eth_reconfig_writedata[i*32+:32] = i_sl_eth_reconfig_writedata_jtag_arb[i*32+:32];
       assign a_sl_eth_reconfig_write[i]            = i_sl_eth_reconfig_write_jtag_arb[i];
       assign a_sl_eth_reconfig_read[i]             = i_sl_eth_reconfig_read_jtag_arb[i];
       assign o_sl_eth_reconfig_readdata_jtag_arb[i*32+:32]  = a_sl_eth_reconfig_readdata[i*32+:32];
       assign o_sl_eth_reconfig_readdata_valid_jtag_arb[i]   = a_sl_eth_reconfig_readdata_valid[i];
       assign o_sl_eth_reconfig_waitrequest_jtag_arb[i]      = a_sl_eth_reconfig_waitrequest[i];
//       assign o_sl_ehip_ready[i]                    = sl_ehip_ready[i];
       assign sl_pause_ehip_ready[i]                   = sl_ehip_ready[i];*/
   end
   end //SL_PAUSE
   else
   begin : NON_SL_PAUSE
       assign a_sl_eth_reconfig_addr                    = 'b0;
       assign a_sl_eth_reconfig_writedata               = 'b0;
       assign a_sl_eth_reconfig_write                   = 'b0;
       assign a_sl_eth_reconfig_read                    = 'b0;
       assign o_sl_eth_reconfig_readdata_jtag_arb       = {sl_num_lanes{32'hdeadc0de}};
       assign o_sl_eth_reconfig_readdata_valid_jtag_arb = 'b1;
       assign o_sl_eth_reconfig_waitrequest_jtag_arb    = 'b0;

   end //NON_SL_PAUSE
   endgenerate

   //*********************** AVMM Decoding ****************************

    wire  [sl_num_lanes-1:0][31:0]              eth_reconfig_addr_int;
    wire  [sl_num_lanes-1:0]                    eth_reconfig_read_int;
    wire  [sl_num_lanes-1:0]                    eth_reconfig_write_int;
    wire  [sl_num_lanes-1:0][31:0]              eth_reconfig_writedata_int;
    wire  [sl_num_lanes-1:0][31:0]              eth_reconfig_readdata_int;
    wire  [sl_num_lanes-1:0]                    eth_reconfig_readdata_valid_int;
    wire  [sl_num_lanes-1:0]                    eth_reconfig_waitrequest_int;

    wire  [sl_num_lanes-1:0][1:0]               ext_addr;
    wire  [sl_num_lanes-1:0]                    ext_addr_2;
    wire  [sl_num_lanes-1:0]                    o_xcvr_reconfig_readdata_valid;
    wire  [sl_num_lanes-1:0][31:0]              o_xcvr_reconfig_readdata_int;
    wire  [sl_num_lanes-1:0][31:0]              xcvr_reconfig_writedata_int;
    wire  [sl_num_lanes-1:0]                    is_soft_ptp;
    wire  [sl_num_lanes-1:0]                    o_sl_eth_reconfig_readdata_valid_int;
    wire  [sl_num_lanes-1:0]                    o_sl_eth_reconfig_waitrequest_int;
    wire  [sl_num_lanes-1:0][31:0]              o_sl_eth_reconfig_readdata_int;
    wire  [sl_num_lanes-1:0]                    o_reconfig_readdata_valid_int;

    // sl soft PTP AVMM wire
    wire  [sl_num_lanes-1:0][31:0]              sl_avmm_readdata;
    wire  [sl_num_lanes-1:0]                    sl_avmm_waitrequest;
    wire  [sl_num_lanes-1:0]                    sl_avmm_readdata_valid;
    wire  [sl_num_lanes-1:0]                    sl_avmm_read;

    wire  [sl_num_lanes-1:0][31:0]              sl_khz_ref_phy;
    wire  [sl_num_lanes-1:0][31:0]              sl_khz_rx_clk64;
    wire  [sl_num_lanes-1:0][31:0]              sl_khz_tx_clk64;
    wire  [sl_num_lanes-1:0][15:0]              sl_int_khz_ref_phy;
    wire  [sl_num_lanes-1:0][15:0]              sl_int_khz_rx_clk64;
    wire  [sl_num_lanes-1:0][15:0]              sl_int_khz_tx_clk64;
    wire  [sl_num_lanes-1:0]                    sl_csr_rx_is_lockedtodata_sync;
    wire  [sl_num_lanes-1:0] [3:0]              sl_csr_tx_pll_locked;
    wire  [sl_num_lanes-1:0] [3:0]              sl_csr_rx_is_lockedtodata;

    wire  [sl_num_lanes-1:0][31:0]              sl_soft_csr_phy_read_data;
    wire  [sl_num_lanes-1:0]                    sl_soft_csr_phy_read_valid;
    wire  [sl_num_lanes-1:0]                    sl_soft_csr_phy_waitrequest;
    wire  [sl_num_lanes-1:0]                    sl_soft_csr_phy_sel;
    wire  [sl_num_lanes-1:0][18:0]              eth_sl_addr;
    reg   [sl_num_lanes-1:0]                    soft_csr_write_req;
    reg   [sl_num_lanes-1:0]                    soft_csr_read_req;
    reg   [sl_num_lanes-1:0]                    soft_csr_read_req_r;
    wire  [sl_num_lanes-1:0]                    eth_sl_sel;
    reg   [sl_num_lanes-1:0]                    eth_sl_sel_r;
    wire  [sl_num_lanes-1:0]                    eth_sl_32to8_sel;
    wire  [sl_num_lanes-1:0]                    sl_ehip_reset_sync;
    reg   [sl_num_lanes-1:0]                    disable_sl_32to8_slv;
    reg   [sl_num_lanes-1:0]                    sl_ehip_reset_sync_r;
    wire  [sl_num_lanes-1:0]                    sl_cfg_load_done_sync;
    wire  [sl_num_lanes-1:0]                    sl_ehip_reset_stat_sync;
    wire  [sl_num_lanes-1:0]                    sl_tx_aib_reset_sync;

    // Adding RX deskew done signal as qualifier for RX PCS ready from reset controller:

	wire rx_deskew_done_qual;

	//wire		rx_pcs64_deskew_done;
	//wire		rx_pcs66_deskew_done;
	//wire		rx_deskew_done;
	//generate
		//if (ENABLE_PCSDIRECT)begin: rx_deskew_qual
		//assign          rx_deskew_done_qual = rx_pcs64_deskew_done;
		//end
		//else if (ENABLE_PCS66) begin:rx_deskew_qual
		//assign          rx_deskew_done_qual = rx_pcs66_deskew_done;
		//end
		//else begin:rx_deskew_qual
		//assign          rx_deskew_done_qual = rx_deskew_done;
		//end
	//endgenerate

    generate
      for (i=0; i<sl_num_lanes; i++) begin: gen_soft_csr_sel
        assign eth_sl_addr[i]      = i_sl_eth_reconfig_addr_2d[i];
        assign sl_soft_csr_phy_sel[i] = ((eth_sl_addr[i] >= 19'h310) && (eth_sl_addr[i] <= 19'h322)) || (eth_sl_addr[i] == 19'h32c) ||
                                     ((eth_sl_addr[i] >= 19'h340) && (eth_sl_addr[i] <= 19'h342));
        assign eth_sl_sel[i] = (eth_sl_addr[i] >= 19'h300) && (eth_sl_addr[i] <= 19'hFFF);
        assign eth_sl_32to8_sel[i] = !sl_kr_sel[i] && !sl_soft_csr_phy_sel[i] && !is_soft_ptp[i];

       always@(posedge i_reconfig_clk)
        begin
          soft_csr_write_req[i]  <= a_sl_eth_reconfig_write[i] & sl_soft_csr_phy_sel[i];
          soft_csr_read_req[i]   <= a_sl_eth_reconfig_read[i] & sl_soft_csr_phy_sel[i];
          soft_csr_read_req_r[i] <= soft_csr_read_req[i] & sl_soft_csr_phy_sel[i];
          eth_sl_sel_r[i]        <= eth_sl_32to8_sel[i];
        end

       always@(posedge i_reconfig_clk)
        begin
          sl_ehip_reset_sync_r[i] <= sl_ehip_reset_sync[i];
          if (reconfig_reset_sync)
             disable_sl_32to8_slv[i] <= 1'b1;
          else if ((sl_ehip_reset_sync[i] & ~sl_ehip_reset_sync_r[i]) || (sl_ehip_reset_sync_r[i] & ~sl_ehip_reset_stat_sync[i]) || (sl_tx_aib_reset_sync[i]))
             disable_sl_32to8_slv[i] <= 1'b1;
          else if (sl_cfg_load_done_sync[i])
             disable_sl_32to8_slv[i] <= 1'b0;
        end
      end
    endgenerate


    // -----------------------------
    //SL reset status for CSR
    // -----------------------------
   wire [sl_num_lanes-1:0] 	slch_tx_transfer_ready;
   wire [sl_num_lanes-1:0] 	slch_rx_transfer_ready;
   wire [1:0] 	sl_ptpch_tx_transfer_ready		  ;
   wire [1:0] 	sl_ptpch_rx_transfer_ready;
   wire [sl_num_lanes-1:0] 	slch_tx_transfer_ready_sync;
   wire [sl_num_lanes-1:0] 	slch_rx_transfer_ready_sync;
   wire [1:0] 	sl_ptpch_tx_transfer_ready_sync;
   wire [1:0] 	sl_ptpch_rx_transfer_ready_sync;
   wire [sl_num_lanes-1:0] sl_ehip_tx_reset_sync;
   wire [sl_num_lanes-1:0] sl_ehip_rx_reset_sync;
   wire [sl_num_lanes-1:0] sl_soft_rsfec_reset_sync;
   wire [sl_num_lanes-1:0] sl_soft_rsfec_tx_reset_sync;
   wire [sl_num_lanes-1:0] sl_soft_rsfec_rx_reset_sync;


   alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
        ) sltxxfrerrdy_sync_inst (
        .clk     (i_reconfig_clk),
        .reset   (1'b0),
        .d       (slch_tx_transfer_ready),
        .q       (slch_tx_transfer_ready_sync)
    );

    alt_xcvr_resync_std #(
       .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
     )  slrxxfrerrdy_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (slch_rx_transfer_ready),
        .q        (slch_rx_transfer_ready_sync)
        );


    alt_xcvr_resync_std #(
       .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
     )  sl_ehip_reset_stat_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (~sl_ehip_reset_stat),
        .q        (sl_ehip_reset_stat_sync)
        );

    alt_xcvr_resync_std #(
       .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
     )  sl_cfg_load_done_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (sl_cfg_load_done),
        .q        (sl_cfg_load_done_sync)
        );

    alt_xcvr_resync_std #(
       .SYNC_CHAIN_LENGTH(3),    .WIDTH(2),  .INIT_VALUE(0)
    ) slptptxxfrerrdy_sync_inst (
       .clk  (i_reconfig_clk),
       .reset(1'b0),
       .d    (sl_ptpch_tx_transfer_ready),
       .q    (sl_ptpch_tx_transfer_ready_sync)
       );


    alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH(3),    .WIDTH(2),  .INIT_VALUE(0)
   ) slptprxxfrerrdy_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (sl_ptpch_rx_transfer_ready),
        .q        (sl_ptpch_rx_transfer_ready_sync)
    );


    alt_xcvr_resync_std #(
      .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
   ) sl_tx_aib_reset_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (sl_tx_aib_reset),
        .q        (sl_tx_aib_reset_sync)
    );

    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
  ) slrst_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (sl_ehip_reset),
        .q        (sl_ehip_reset_sync)
	);


    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
  ) sltxrst_sync_inst (
        .clk     (i_reconfig_clk),
        .reset   (1'b0),
        .d       (sl_ehip_tx_reset),
        .q       (sl_ehip_tx_reset_sync)
        );


    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
  ) slrxrst_sync_inst (
        .clk      (i_reconfig_clk),
        .reset    (1'b0),
        .d        (sl_ehip_rx_reset),
        .q        (sl_ehip_rx_reset_sync)
	);




    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
     ) slrsfecrst_sync_inst (
        .clk        (i_reconfig_clk),
        .reset      (1'b0),
        .d          (sl_soft_rsfec_reset),
        .q          (sl_soft_rsfec_reset_sync)
    );

    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
     ) slrsfectxrst_sync_inst (
        .clk        (i_reconfig_clk),
        .reset      (1'b0),
        .d          (sl_soft_rsfec_tx_reset),
        .q          (sl_soft_rsfec_tx_reset_sync)
    );


    alt_xcvr_resync_std #(
     .SYNC_CHAIN_LENGTH(3),    .WIDTH(sl_num_lanes),  .INIT_VALUE(0)
     ) slrsfecrxrst_sync_inst (
        .clk        (i_reconfig_clk),
        .reset      (1'b0),
        .d          (sl_soft_rsfec_rx_reset),
        .q          (sl_soft_rsfec_rx_reset_sync)
    );


    genvar j;
    generate
      if ((( core_variant == 0) ||
         ( core_variant == 1) ||
         ((core_variant == 3) && (active_channel == 0)) ||
         ( core_variant == 4) || (core_variant == 5) || (core_variant == 7))) begin : GEN_AVMM_SL_RCFG

    for (j=0; j<sl_num_lanes; j++) begin: gen_avmm_rcfg
      alt_ehipc3_fm_sl_avmm_32to8 #(
        .TIMEOUT(3000)
      ) alt_ehipc3_fm_sl_avmm_32to8_inst (
        .clk                   (i_reconfig_clk),                           //input
        .reset                 (reconfig_reset_sync),                       //input

        .master_read           (eth_sl_32to8_sel[j] && a_sl_eth_reconfig_read[j]),                //input
        .master_write          (eth_sl_32to8_sel[j] && a_sl_eth_reconfig_write[j]),               //input
        .master_address        ({13'h0,i_sl_eth_reconfig_addr_2d[j][18:0]}),  //input       [31:0]
        .master_write_data     (i_sl_eth_reconfig_writedata_2d[j]),           //input       [31:0]
        .master_byte_enable    (4'b1111),                                  //input       [3:0]
        .master_read_valid     (o_sl_eth_reconfig_readdata_valid_int[j]),      //output reg
        .master_wait           (o_sl_eth_reconfig_waitrequest_int[j]),         //output reg
        .master_read_data      (o_sl_eth_reconfig_readdata_int[j]),            //output reg  [31:0]

        .slave_enable          (~disable_sl_32to8_slv[j] && eth_sl_sel[j]),   //input
        .slave_read            (eth_reconfig_read_int[j]),                 //output reg
        .slave_write           (eth_reconfig_write_int[j]),                //output reg
        .slave_address         (eth_reconfig_addr_int[j]),                 //output reg  [31:0]
        .slave_write_data      (eth_reconfig_writedata_int[j][7:0]),       //output reg  [ 7:0]
        .slave_read_valid      (eth_reconfig_readdata_valid_int[j]),       //input
        .slave_wait            (eth_reconfig_waitrequest_int[j]),          //input
        .slave_read_data       (eth_reconfig_readdata_int[j][7:0])         //input       [ 7:0]
      );

      alt_ehipc3_fm_sl_avmm_rcfg avmm_rcfg_inst (
        .clk_clk                                         (i_reconfig_clk),
        .elane_avalon_universal_slave_0_address          ({eth_reconfig_addr_int[j][16:8],3'b100,eth_reconfig_addr_int[j][7:0],2'b00}),
        .elane_avalon_universal_slave_0_burstcount       (1'b1),
        .elane_avalon_universal_slave_0_read             (eth_reconfig_read_int[j]),
        .elane_avalon_universal_slave_0_write            (eth_reconfig_write_int[j]),
        .elane_avalon_universal_slave_0_waitrequest      (eth_reconfig_waitrequest_int[j]),
        .elane_avalon_universal_slave_0_readdatavalid    (),
        .elane_avalon_universal_slave_0_byteenable       (4'b1111),
        .elane_avalon_universal_slave_0_readdata         (eth_reconfig_readdata_int[j]),
        .elane_avalon_universal_slave_0_writedata        ({4{eth_reconfig_writedata_int[j][7:0]}}),
        .elane_avalon_universal_slave_0_lock             (1'b0),
        .elane_avalon_universal_slave_0_debugaccess      (1'b0),
        .master_avalon_universal_master_0_address        ({ext_addr_2[j],sl_xcvr_reconfig_address[19*j+18:19*j],ext_addr[j][1:0]}),
        .master_avalon_universal_master_0_burstcount     (),
        .master_avalon_universal_master_0_read           (sl_xcvr_reconfig_read[j]),
        .master_avalon_universal_master_0_write          (sl_xcvr_reconfig_write[j]),
        .master_avalon_universal_master_0_waitrequest    (var_xcvr_reconfig_waitrequest[j]),
        .master_avalon_universal_master_0_readdatavalid  (o_reconfig_readdata_valid_int[j]),
        .master_avalon_universal_master_0_byteenable     (),
        .master_avalon_universal_master_0_readdata       ({24'b000000000000000000000000, var_xcvr_reconfig_readdata[8*j+7:8*j]}),
        .master_avalon_universal_master_0_writedata      (xcvr_reconfig_writedata_int[j]),
        .master_avalon_universal_master_0_lock           (),
        .master_avalon_universal_master_0_debugaccess    (),
        .reset_reset                                     (reconfig_reset_sync),
        .xcvr_avalon_universal_slave_0_address           ({1'b0,i_xcvr_reconfig_address_jtag_arb[19*j+18:19*j],2'b00}),
        .xcvr_avalon_universal_slave_0_burstcount        (1'b1),
        .xcvr_avalon_universal_slave_0_read              (i_xcvr_reconfig_read_jtag_arb[j]),
        .xcvr_avalon_universal_slave_0_write             (i_xcvr_reconfig_write_jtag_arb[j]),
        .xcvr_avalon_universal_slave_0_waitrequest       (sl_xcvr_reconfig_waitrequest[j]),
        .xcvr_avalon_universal_slave_0_readdatavalid     (o_xcvr_reconfig_readdata_valid[j]),
        .xcvr_avalon_universal_slave_0_byteenable        (4'b1111),
        .xcvr_avalon_universal_slave_0_readdata          (o_xcvr_reconfig_readdata_int[j]),
        .xcvr_avalon_universal_slave_0_writedata         ({24'b000000000000000000000000, i_xcvr_reconfig_writedata_jtag_arb[8*j+7:8*j]}),
        .xcvr_avalon_universal_slave_0_lock              (1'b0),
        .xcvr_avalon_universal_slave_0_debugaccess       (1'b0)
      );
      assign eth_reconfig_readdata_valid_int[j] = eth_reconfig_read_int[j] & ~eth_reconfig_waitrequest_int[j];
      assign sl_xcvr_reconfig_readdata[8*j+7:8*j] = o_xcvr_reconfig_readdata_int[j][7:0];
      assign sl_xcvr_reconfig_writedata[8*j+7:8*j] = xcvr_reconfig_writedata_int[j][7:0];
      assign o_reconfig_readdata_valid_int[j] = sl_xcvr_reconfig_read[j] & ~xcvr_reconfig_waitrequest[j];

        if (ENHANCED_PTP_ACCURACY == 1) begin : ONENS_SUPPORT_IS_SOFT_PTP
            assign is_soft_ptp[j] = ((i_sl_eth_reconfig_addr_2d[j][18:4] >= 15'h00b1) && (i_sl_eth_reconfig_addr_2d[j][18:4] <= 15'h00b5)) ? 1'b1 : 1'b0;
        end else begin
      assign is_soft_ptp[j] = (i_sl_eth_reconfig_addr_2d[j][18:4] == 15'h00b1)? 1'b1 : 1'b0;
        end
   //*********************** EHIP Soft CSR ****************************

     assign sl_khz_ref_phy[j]  = {16'd0, sl_int_khz_ref_phy[j]};
     assign sl_khz_rx_clk64[j] = {16'd0, sl_int_khz_rx_clk64[j]};
     assign sl_khz_tx_clk64[j] = {16'd0, sl_int_khz_tx_clk64[j]};

     assign sl_csr_tx_pll_locked[j]      = {{3{1'b0}},1'b1};
     assign sl_csr_rx_is_lockedtodata[j] = {4{sl_rx_is_lockedtodata[j]}};

     alt_xcvr_resync_std #(
             .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
         ) sync_sl_csr_rx_is_lockedtodata (
             .clk    (i_reconfig_clk),
             .reset  (1'b0),
             .d  (&sl_csr_rx_is_lockedtodata[j]),
             .q  (sl_csr_rx_is_lockedtodata_sync[j])
     );


     alt_ehipc3_fm_clock_mon clk_mon_sl_inst
       (
        .csr_clk(i_reconfig_clk),
        .cdr_ref_clk(i_clk_ref_m[0]),
        // Inputs
        .tx_clk64(o_clk_pll_div64[j]),
        .rx_clk64(o_clk_rec_div64[j]),
        .tx_clk66(o_clk_pll_div66[j]),
        .rx_clk66(o_clk_rec_div66[j]),
        // outputs
        .khz_ref_phy(sl_int_khz_ref_phy[j]),
        .khz_rx_clk64(sl_int_khz_rx_clk64[j]),
        .khz_tx_clk64(sl_int_khz_tx_clk64[j]),
        .khz_rx_clk66(),
        .khz_tx_clk66()
        );

      alt_ehipc3_fm_csr soft_csr_sl_inst (
          .clk                (i_reconfig_clk),
          .reset              (reconfig_reset_sync),
          .writedata          (i_sl_eth_reconfig_writedata_2d[j]),
          .read               (soft_csr_read_req[j]&~soft_csr_read_req_r[j]),
          .write              (a_sl_eth_reconfig_write[j]&sl_soft_csr_phy_sel[j]),
          .byteenable         (4'b1111),
          .readdata           (sl_soft_csr_phy_read_data[j]),
          .readdatavalid      (sl_soft_csr_phy_read_valid[j]),
          .address            (i_sl_eth_reconfig_addr_2d[j][11:0]),

          .rxmac_adapt_dropped_lo_count_i  (32'd0),
          .rxmac_adapt_dropped_hi_count_i  (32'd0),
          .rxmac_adapt_dropped_clear_clear_drops     (/* unused */),

          .phy_config_eio_sys_rst                 (sl_soft_csr_rst[j]),
          .phy_config_soft_tx_rst                 (sl_soft_tx_rst[j]),
          .phy_config_soft_rx_rst                 (sl_soft_rx_rst[j]),
          .phy_config_set_ref_lock                (),
          .phy_config_set_data_lock               (),
          .phy_pma_sloop_sloop                    (),
          // Need to add frequency counters
          .phy_txclk_khz_khz_tx_i                 (sl_khz_tx_clk64[j]),
          .phy_recclk_khz_khz_rx_i                (sl_khz_rx_clk64[j]),
          .phy_refclk_khz_khz_ref_i               (sl_khz_ref_phy[j]),
          .phy_tx_pll_locked_tx_pll_locked_i      (sl_csr_tx_pll_locked[j]),
          .phy_tx_corepll_locked_tx_pcs_ready_i   (o_sl_tx_lanes_stable[j]),
          .phy_eiofreq_locked_eio_freq_lock_i     ({4{sl_csr_rx_is_lockedtodata_sync[j]}}),
          .phy_pma_sloop_mac_adapter_loopback     (),
          .lanes_deskewed_dskew_status_i          (1'b0),
          .lanes_deskewed_dskew_chng_i            (1'b0),

	 //Transfer ready status
	.aib_transfer_ready_status_ehip_tx_transfer_ready_i({3'b000,slch_tx_transfer_ready_sync[j]}),
	.aib_transfer_ready_status_ehip_rx_transfer_ready_i({3'b000,slch_rx_transfer_ready_sync[j]}),
	.aib_transfer_ready_status_ptp_tx_transfer_ready_i(sl_ptpch_tx_transfer_ready_sync),
	.aib_transfer_ready_status_ptp_rx_transfer_ready_i(sl_ptpch_rx_transfer_ready_sync),
        // Reset status from the reset controller
	.soft_rc_reset_status_ehip_reset_i(sl_ehip_reset_sync[j]),
	.soft_rc_reset_status_ehip_tx_reset_i(sl_ehip_tx_reset_sync[j]),
	.soft_rc_reset_status_ehip_rx_reset_i(sl_ehip_rx_reset_sync[j]),
	.soft_rc_reset_status_ehip_rsfec_reset_i(sl_soft_rsfec_reset_sync[j]),
	.soft_rc_reset_status_ehip_rsfec_tx_reset_i(sl_soft_rsfec_tx_reset_sync[j]),
	.soft_rc_reset_status_ehip_rsfec_rx_reset_i(sl_soft_rsfec_rx_reset_sync[j])


      );

      assign sl_soft_csr_phy_waitrequest[j] = (a_sl_eth_reconfig_read[j] & sl_soft_csr_phy_sel[j] & (~soft_csr_read_req[j] | ~soft_csr_read_req_r[j]));

      always_comb begin
      if (reconfig_reset_sync)
	          a_sl_eth_reconfig_waitrequest[j] = 1'b1;
      else begin
        case (1'b1)
            sl_soft_csr_phy_sel[j]  : a_sl_eth_reconfig_waitrequest[j] = sl_soft_csr_phy_waitrequest[j];
            sl_kr_sel[j]         : a_sl_eth_reconfig_waitrequest[j]    = sl_kr_wait[j];
            is_soft_ptp[j]       : a_sl_eth_reconfig_waitrequest[j]    = sl_avmm_waitrequest[j];
            eth_sl_sel_r[j]      : a_sl_eth_reconfig_waitrequest[j]    = o_sl_eth_reconfig_waitrequest_int[j];
            default              : a_sl_eth_reconfig_waitrequest[j]    = 1'b1;

         endcase
      end // else : !(i_reconfig_reset)
    end // always_comb

    // data valid
    assign a_sl_eth_reconfig_readdata_valid[j]   = o_sl_eth_reconfig_readdata_valid_int[j] | sl_avmm_readdata_valid[j] | sl_soft_csr_phy_read_valid[j] | sl_kr_read_valid[j];

    // read data
    always_comb begin
        case (1'b1)
            sl_soft_csr_phy_read_valid[j] : o_sl_eth_reconfig_readdata_2d[j]   = sl_soft_csr_phy_read_data[j];
            sl_avmm_readdata_valid[j]     : o_sl_eth_reconfig_readdata_2d[j]   = sl_avmm_readdata[j];
            sl_kr_read_valid[j]           : o_sl_eth_reconfig_readdata_2d[j]   = sl_kr_read_data[j];
            default                       : o_sl_eth_reconfig_readdata_2d[j]   = o_sl_eth_reconfig_readdata_int[j];
        endcase
    end

     end

    end	else begin : NO_AVMM_SL_RCFG

     // Signals coming out of alt_ehipc3_sl_avmm_32to8_inst
     assign o_sl_eth_reconfig_readdata_valid_int = 'b0;
     assign o_sl_eth_reconfig_waitrequest_int    = 'b0;
     assign o_sl_eth_reconfig_readdata_int       = 'b0;
     assign eth_reconfig_read_int                = 'b0;
     assign eth_reconfig_write_int               = 'b0;
     assign eth_reconfig_addr_int                = 'b0;
     assign eth_reconfig_writedata_int           = 'b0;

     // Signals coming out of alt_ehipc3_sl_avmm_rcfg
     assign eth_reconfig_waitrequest_int         = 'b0;
     assign eth_reconfig_readdata_int            = 'b0;
     assign ext_addr_2                           = 'b0;
     assign sl_xcvr_reconfig_address             = 'b0;
     assign ext_addr                             = 'b0;
     assign sl_xcvr_reconfig_read                = 'b0;
     assign sl_xcvr_reconfig_write               = 'b0;
     assign xcvr_reconfig_writedata_int          = 'b0;
     assign sl_xcvr_reconfig_waitrequest         = 'b0;
     assign o_xcvr_reconfig_readdata_valid       = 'b0;

     // Signals coming out of alt_xcvr_resync_std
     assign sl_csr_rx_is_lockedtodata_sync       = 'b0;

     // Signals coming out of alt_ehipc3_clock_mon
     assign sl_int_khz_ref_phy                   = 'b0;
     assign sl_int_khz_rx_clk64                  = 'b0;
     assign sl_int_khz_tx_clk64                  = 'b0;

     // Signals coming out of alt_ehipc3_csr
     assign sl_soft_csr_phy_read_data            = 'b0;
     assign sl_soft_csr_phy_read_valid           = 'b0;
     assign sl_soft_csr_rst                      = 'b0;
     assign sl_soft_tx_rst                       = 'b0;
     assign sl_soft_rx_rst                       = 'b0;

     assign is_soft_ptp				 = 'b0;

   end //NO_AVMM_SL_RCFG
   endgenerate

// HARD IP instantiation


alt_ehipc3_fm_hard_cppdzeq
    #(
      .LANES (num_lanes),
      .EHP_WORDS (num_lanes),
      .ENABLE_RSFEC(ENABLE_RSFEC),
      .ENABLE_RSFEC_MODE(ENABLE_RSFEC_MODE),
      .ENABLE_PCSDIRECT(ENABLE_PCSDIRECT),
      .ENABLE_PCS66(ENABLE_PCS66),
      .MAX_REFCLK(max_refclk),
      .MAX_CH(max_ch),
      .MAX_XCVR_CH(max_xcvr_ch),
      .MAX_CLKOUT_CH(max_clkout_ch),
      .SL_LANES(sl_num_lanes),
      .bti_preserve                      (bti_preserve                      ),
      .func_mode                         (func_mode                         ),
      .powerdown_mode                    (powerdown_mode                    ),
      .use_factory_settings              (use_factory_settings),
      .is_usr_avmm                       (is_usr_avmm                       ),
      .crete_type                        (crete_type                        ),
      .sup_mode                          (sup_mode                          ),
      .silicon_rev			 (silicon_rev			    ),
      .sim_mode                          (lcl_sim_mode                          ),
      .ehip_type                         (ehip_type                      ),
      .topology                          (ehip_core_topology                ),
      .ehip_mode                         (ehip_core_ehip_mode               ),
      .ehip_rate                         (ehip_core_ehip_rate               ),
      .link_fault_mode                   (link_fault_mode                   ),
      .ipg_removed_per_am_period         (ehip_core_ipg_removed_per_am_period),
      .tx_max_frame_size                 (ehip_core_tx_max_frame_size       ),
      .tx_vlan_detection                 (ehip_core_tx_vlan_detection       ),
      .tx_preamble_passthrough           (ehip_core_tx_preamble_passthrough ),
      .tx_ipg_size                       (ehip_core_tx_ipg_size             ),
      .rx_max_frame_size                 (ehip_core_rx_max_frame_size       ),
      .keep_rx_crc                       (ehip_core_keep_rx_crc             ),
      .rx_preamble_passthrough           (ehip_core_rx_preamble_passthrough ),
      .rx_length_checking                (ehip_core_rx_length_checking      ),
      .rx_vlan_detection                 (ehip_core_rx_vlan_detection       ),
      .flow_control                      (HIP_FLOW_CONTROL            ),
      .flow_control_holdoff_mode         (ehip_core_flow_control_holdoff_mode),
      .holdoff_quanta                    (ehip_core_holdoff_quanta          ),
      .uniform_holdoff_quanta            (ehip_core_uniform_holdoff_quanta  ),
      .pause_quanta                      (ehip_core_pause_quanta            ),
      .forward_rx_pause_requests         (ehip_core_forward_rx_pause_requests),
      .tx_pause_daddr                    (ehip_core_tx_pause_daddr          ),
      .tx_pause_saddr                    (ehip_core_tx_pause_saddr          ),
      .rx_pause_daddr                    (ehip_core_rx_pause_daddr          ),
      .tx_clock_period                   (tx_clock_period                   ),
      .rx_clock_period                   (rx_clock_period                   ),
      .tx_ptp_extra_latency              (lcl_int_tx_ptp_extra_latency      ),
      .rx_ptp_extra_latency              (lcl_int_rx_ptp_extra_latency      ),
      .tx_ptp_asym_latency               (lcl_int_tx_ptp_asym_latency       ),
      .tx_ptp_dp_latency                 (lcl_int_tx_ptp_dp_latency         ),
      .rx_ptp_dp_latency                 (lcl_int_rx_ptp_dp_latency         ),
      .ptp_debug                         (lcl_int_ptp_debug                 ),
      .ptp_tx_timestamp_method           (ptp_tx_timestamp_method           ),
      .ptp_timestamp_format              (ptp_timestamp_format              ),
      .rx_datapath_soft_rst              (rx_datapath_soft_rst              ),
      .tx_datapath_soft_rst              (tx_datapath_soft_rst              ),
      .tx_mac_soft_rst                   (tx_mac_soft_rst                   ),
      .tx_pcs_soft_rst                   (tx_pcs_soft_rst                   ),
      .rx_mac_soft_rst                   (rx_mac_soft_rst                   ),
      .rx_pcs_soft_rst                   (rx_pcs_soft_rst                   ),
      .tx_am_period                      (lcl_tx_am_period                      ),
      .pfc_holdoff_quanta_0              (ehip_core_pfc_holdoff_quanta_0    ),
      .pfc_holdoff_quanta_1              (ehip_core_pfc_holdoff_quanta_1    ),
      .pfc_holdoff_quanta_2              (ehip_core_pfc_holdoff_quanta_2    ),
      .pfc_holdoff_quanta_3              (ehip_core_pfc_holdoff_quanta_3    ),
      .pfc_holdoff_quanta_4              (ehip_core_pfc_holdoff_quanta_4    ),
      .pfc_holdoff_quanta_5              (ehip_core_pfc_holdoff_quanta_5    ),
      .pfc_holdoff_quanta_6              (ehip_core_pfc_holdoff_quanta_6    ),
      .pfc_holdoff_quanta_7              (ehip_core_pfc_holdoff_quanta_7    ),
      .pfc_pause_quanta_0                (ehip_core_pfc_pause_quanta_0      ),
      .pfc_pause_quanta_1                (ehip_core_pfc_pause_quanta_1      ),
      .pfc_pause_quanta_2                (ehip_core_pfc_pause_quanta_2      ),
      .pfc_pause_quanta_3                (ehip_core_pfc_pause_quanta_3      ),
      .pfc_pause_quanta_4                (ehip_core_pfc_pause_quanta_4      ),
      .pfc_pause_quanta_5                (ehip_core_pfc_pause_quanta_5      ),
      .pfc_pause_quanta_6                (ehip_core_pfc_pause_quanta_6      ),
      .pfc_pause_quanta_7                (ehip_core_pfc_pause_quanta_7      ),
      .rx_am_interval                    (lcl_rx_am_interval                    ),
      .txmac_saddr                       (ehip_core_txmac_saddr             ),
      .source_address_insertion          (ehip_core_source_address_insertion),
      .tx_mac_data_flow                  (ehip_core_tx_mac_data_flow        ),
      .tx_pld_fifo_almost_full_level     (tx_pld_fifo_almost_full_level     ),
      .strict_sfd_checking               (ehip_core_strict_sfd_checking     ),
      .force_deskew_done                 (force_deskew_done                 ),
      .force_hip_ready                   (force_hip_ready                   ),
      .remove_pads                       (ehip_core_remove_pads             ),
      .enforce_max_frame_size            (enforce_max_frame_size            ),
      .rx_pcs_max_skew                   (rx_pcs_max_skew                   ),
      .hi_ber_monitor                    (hi_ber_monitor                    ),
      .am_encoding40g_0                  (am_encoding40g_0                  ),
      .am_encoding40g_1                  (am_encoding40g_1                  ),
      .am_encoding40g_2                  (am_encoding40g_2                  ),
      .am_encoding40g_3                  (am_encoding40g_3                  ),
      .xus_timer_window                  (ehip_core_xus_timer_window        ),
      .ber_invalid_count                 (ber_invalid_count                 ),
      .force_link_fault_rf               (force_link_fault_rf               ),
      .txcrc_covers_preamble             (txcrc_covers_preamble             ),
      .rxcrc_covers_preamble             (rxcrc_covers_preamble             ),
      .use_lane_ptp                      (ehip_core_use_lane_ptp            ),
      .strict_preamble_checking          (strict_preamble_checking          ),
      .use_testbus                       (use_testbus                       ),
      .ehip_clk_sel                      (ehip_core_ehip_clk_sel            ),
      .ehip_dist_clk_sel                 (ehip_dist_clk_sel                 ),
      .fec_dist_clk_sel                  (fec_dist_clk_sel                  ),
      .use_am_insert                     (ehip_core_use_am_insert           ),
      .tx_aib_dp_latency                 (lcl_int_tx_aib_dp_latency         ),
      .rx_aib_dp_latency                 (lcl_int_rx_aib_dp_latency         ),
      .powermode_dc                      (powermode_dc                      ),
      .powermode_ac_mac                  (ehip_core_powermode_ac_mac        ),
      .powermode_ac_misc                 (ehip_core_powermode_ac_misc       ),
      .powermode_ac_pcs                  (ehip_core_powermode_ac_pcs        ),
      .powermode_ac_pld                  (ehip_core_powermode_ac_pld        ),
      .ehip_clk_hz                       (ehip_clk_hz                       ),
      // Ser through CSR and initial value will be only one
      .deskew_clear                      (deskew_clear                      ),
      .disable_link_fault_rf             (disable_link_fault_rf             ),
      .enable_rx_stats_snapshot          (enable_rx_stats_snapshot          ),
      .enable_tx_stats_snapshot          (enable_tx_stats_snapshot          ),
      .request_tx_pause                  (request_tx_pause                  ),
      .reset_tx_stats_parity_error       (reset_tx_stats_parity_error       ),
      .reset_rx_stats_parity_error       (reset_rx_stats_parity_error       ),
      .reset_rx_stats                    (reset_rx_stats                    ),
      .reset_tx_stats                    (reset_tx_stats                    ),
      .check_random_idles                (check_random_idles                ),
      .core_variant                      (core_variant                      ),
      .active_channel                    (active_channel                    ),
      .ENABLE_PTP                        (ENABLE_PTP                        ),
      .ENABLE_PTP_TOG                    (ENABLE_PTP_TOG                    ),
      .USE_PTP_PLLCH                     (USE_PTP_PLLCH                     ),
      .ENABLE_PTP_RX_DESKEW              (ENABLE_PTP_RX_DESKEW              ),
      .enable_external_aib_clocking      (enable_external_aib_clocking      ),
      .SL_OPT                            (SL_OPT                            ),
      .ehip_mode_sl_0                    (ehip_mode_sl_0                    ),
      .include_alternate_ports_sl_0      (include_alternate_ports_sl_0      ),
      .LOCATION_SEL                      (LOCATION_SEL                      ),
      .ECORE_5432_TIEOFF                 (EHIP_LOCATION                     ),
//      .EL_LANES                          ('d4                          ),
      .deskew_lanes                      (deskew_lanes                      ),
      .FIRST_LANE                        (0                       )

      )   alt_ehipc3_fm_hard_inst
      (  //100Gptp -- start
        .i_ptp_tx_fp(ml_ptp_tx_fp),
        .i_ptp_byte_offset(ml_ptp_byte_offset),
        .i_ptp_ins_type(ml_ptp_ins_type),
        .i_ptp_ts(ml_ptp_ts),
        .i_select_ptp_vl_data(ml_select_ptp_vl_data),
        .i_read_ptp_vl_data(ml_read_ptp_vl_data),

        .i_sclk                 (ml_sclk),
        .i_tx_sel_sclk_return   (ml_tx_sel_sclk_return),
        .i_rx_sel_sclk_return   (ml_rx_sel_sclk_return),
        .o_tx_sclk_return       (ml_tx_sclk_return),
        .o_rx_sclk_return       (ml_rx_sclk_return),

        .o_ptp_rx_ts(int_ptp_rx_ts),
        .o_rx_am(int_ptp_rx_am),
        .o_ptp_reading_vl_data(int_ptp_reading_vl_data),	//only for 100G.
        .o_tx_am(int_ptp_tx_am),			//
        .o_ptp_tx_ts_valid(int_ptp_tx_ts_valid),	//ok
        .o_ptp_tx_ts(int_ptp_tx_ts),
        .o_ptp_tx_fp(int_ptp_tx_fp), 		//ok
        .o_rx_aib_dsk   (rx_aib_dsk),
        .o_sl_rx_aib_dsk(sl_rx_aib_dsk),
        .o_sl_rx_aib_dsk_done(sl_rx_aib_dsk_done),
       .i_refclk(i_clk_ref_m),
       .i_reconfig_clk(i_reconfig_clk),
       .i_rx_core_clk(int_rx_clk),
       .i_tx_core_clk(int_tx_clk),
       .i_sl_clk_rx(i_sl_clk_rx),
       .i_sl_clk_tx(i_sl_clk_tx),
       .i_aib_clk(i_aib_clk),
       .i_aib_2x_clk(i_aib_2x_clk),
       .o_tx_clk_div64(tx_clkout_div64),
       .o_rx_clk_div64(rx_clkout_div64),
       .o_tx_clk_div66(tx_clkout_div66),
       .o_rx_clk_div66(rx_clkout_div66),

       .i_sl_enable_rsfec(sl_rsfec_mode),

       .i_rx_serial_data(i_rx_serial),
       .o_tx_serial_data(o_tx_serial),
       .i_rx_serial_data_n(i_rx_serial_n),
       .o_tx_serial_data_n(o_tx_serial_n),

       .i_ehip_rst_n(~ehip_rst), // this will
       .i_ehip_rx_rst_n(~ehip_rx_rst),
       .i_ehip_tx_rst_n(~ehip_tx_rst),
       .i_ehip_pld_ready(ehip_pld_ready),
       .i_ehip_signal_ok(ehip_signal_ok_p),
       .i_ehip_clear_internal_err(1'b0),

       .i_rx_pmaif_reset(rx_digitalreset),
       .i_tx_pmaif_reset(tx_digitalreset),
       .i_rsfec_reset(~rsfec_rst),			//temp connection with ehip's reset, need Sangetta add fec support in the reset controller
       .i_rx_rsfec_reset(~rsfec_rx_rst),			//temp connection with ehip's reset
       .i_tx_rsfec_reset(~rsfec_tx_rst),			//temp connection with ehip's reset
       .i_tx_aib_reset(tx_aib_reset),
       .i_rx_aib_reset(rx_aib_reset),

       .i_sl_rx_pmaif_reset(sl_rx_pcs_reset),
       .i_sl_tx_pmaif_reset(sl_tx_pcs_reset),
       .i_sl_rx_aib_reset(sl_rx_aib_reset),
       .i_sl_tx_aib_reset(sl_tx_aib_reset),

       .o_rx_is_lockedtodata(rx_is_lockedtodata),
       .o_rx_transfer_ready(rx_transfer_ready),
       .o_tx_transfer_ready(tx_transfer_ready),
       .o_tx_dll_lock(int_tx_dll_lock),
       .o_rx_pma_ready(rx_pma_ready),
       .o_tx_pma_ready(tx_pma_ready),

       .o_sl_rx_is_lockedtodata(sl_rx_is_lockedtodata),
       .o_sl_rx_transfer_ready(sl_rx_transfer_ready),  //o_sl_tx_transfer_ready is combination of sl_tx_transfer_ready and ptp_tx_transfer_ready
       .o_sl_tx_transfer_ready(sl_tx_transfer_ready), //o_sl_tx_transfer_ready is combination of sl_tx_transfer_ready and ptp_tx_transfer_ready

	 // Adding following ouput ports to give proper transfer status of ELANE and PTP channels
       .o_slch_tx_transfer_ready(slch_tx_transfer_ready), // TX transfer ready for only ELNAE chs
       .o_slch_rx_transfer_ready(slch_rx_transfer_ready), // RX transfer ready for only ELNAE chs
       .o_sl_ptpch_tx_transfer_ready(sl_ptpch_tx_transfer_ready), // TX transfer ready for ELANE PTP chs
       .o_sl_ptpch_rx_transfer_ready(sl_ptpch_rx_transfer_ready), // RX transfer ready for ELANE PTP chs

       .o_sl_tx_dll_lock(sl_tx_dll_lock),
       .o_sl_rx_pma_ready(o_sl_rx_pma_ready),
       .o_sl_tx_pma_ready(o_sl_tx_pma_ready),

       .o_ehip_ready(ehip_ready),
       .o_ehip_rst_ack_n(ehip_rst_n_ack),
       .o_ehip_tx_rst_ack_n(ehip_tx_rst_n_ack),
       .o_ehip_rx_rst_ack_n(ehip_rx_rst_n_ack),
       // RSFEC
       .o_rsfec_tx_rst_ack_n(rsfec_tx_rst_n_ack),
       .o_rsfec_rx_rst_ack_n(rsfec_rx_rst_n_ack),

       .o_ehip_cfg_load_done(ehip_cfg_load_done_out),
       .o_ehip_rx_block_lock(o_rx_block_lock),
       .o_ehip_rx_am_lock(o_rx_am_lock),
       .o_ehip_rx_dsk_done(ehip_rx_dsk_done_out),
       .o_ehip_rx_remote_fault(o_remote_fault_status),
       .o_ehip_rx_local_fault(o_local_fault_status_1),
       .o_ehip_rx_pcs_fully_aligned(ehip_rx_pcs_fully_aligned_out),

       .o_ehip_rx_hi_ber(ehip_rx_hi_ber_out),


       .i_tx_data(int_tx_data),
       .i_tx_error(int_tx_error),
       .i_tx_empty(int_tx_empty),
       .i_tx_inframe(int_tx_inframe),
       .i_tx_skip_crc(int_tx_skip_crc),
       .i_tx_aib_dsk(int_tx_aib_dsk),

       .i_sl_tx_data(int_sl_tx_data),
       .i_sl_tx_error(int_sl_tx_error),
       .i_sl_tx_empty(int_sl_tx_empty),
       .i_sl_tx_inframe(int_sl_tx_inframe),
       .i_sl_tx_skip_crc(int_sl_tx_skip_crc),
       .i_sl_tx_aib_dsk((ENABLE_PTP == 1) ? {sl_num_lanes{int_sl_tx_aib_dsk[0]}} : int_sl_tx_aib_dsk),

       .i_sl_ptp_tx_aib_dsk({2{int_sl_tx_aib_dsk[0]}}), // TODO

       .o_rx_data(int_rx_data),
       .o_rx_empty(int_rx_empty),

       .o_rx_fcs_error(int_rx_fcs_error),
       .o_rx_error(int_rx_error),
       .o_rx_status(int_rx_status),
       .o_rx_inframe(int_rx_inframe),

       .o_sl_rx_data(int_sl_rx_data),
       .o_sl_rx_empty(int_sl_rx_empty),
       .o_sl_rx_fcs_error(int_sl_rx_fcs_error),
       .o_sl_rx_error(int_sl_rx_error),
       .o_sl_rx_status(int_sl_rx_status),
       .o_sl_rx_inframe(int_sl_rx_inframe),

       //Not per lane
       .i_tx_pause(i_tx_pause),
       .i_tx_pfc(i_tx_pfc),
       .i_tx_valid(int_tx_valid),
       .i_stats_snapshot(i_stats_snapshot),
       .i_custom_cadence(i_custom_cadence),
       .o_rx_valid(int_rx_valid),
       .o_rx_pause(o_rx_pause),
       .o_rx_pfc(o_rx_pfc),
       .o_rx_pcs_internal_err(o_rx_pcs_internal_err),
       .o_tx_ready(int_tx_ready),

       .i_sl_tx_valid               (int_sl_tx_valid),
       .o_sl_rx_valid               (int_sl_rx_valid),
       .o_sl_tx_ready               (int_sl_tx_ready),

       // Elane Interface
       .o_sl_rx_pcs_fully_aligned   (sl_rx_pcs_fully_aligned),
       .o_sl_rx_block_lock          (o_sl_rx_block_lock),
       .o_sl_rx_hi_ber              (o_sl_rx_hi_ber),
       .o_sl_local_fault_status     (o_sl_local_fault_status),
       .o_sl_rx_pause               (o_sl_rx_pause),
       .o_sl_rx_pfc                 (o_sl_rx_pfc_2d),
       .o_sl_remote_fault_status    (o_sl_remote_fault_status),
       .i_sl_ehip_signal_ok         (sl_ehip_signal_ok),
       .i_sl_tx_pause               (i_sl_tx_pause),
       .i_sl_tx_pfc                 (i_sl_tx_pfc_2d),
       .o_sl_xcvr_rxfifo_overflow   (), // TODO
       .o_sl_xcvr_txfifo_pempty     (o_sl_txfifo_pempty),
       .o_sl_xcvr_txfifo_pfull      (o_sl_txfifo_pfull),
       .o_sl_xcvr_txfifo_overflow   (o_sl_txfifo_overflow),
       .o_sl_xcvr_txfifo_underflow  (o_sl_txfifo_underflow),
       .i_sl_clear_internal_err     ({sl_num_lanes{1'b0}}), // TODO
       .o_sl_internal_err           (), // TODO
       .i_sl_force_rcfg_reset       ({sl_num_lanes{1'b1}}),
       .o_sl_cfg_load_done          (sl_cfg_load_done),
       .i_sl_stats_snapshot         (i_sl_stats_snapshot),
       .i_sl_custom_cadence         (i_sl_custom_cadence),

       .i_sl_ehip_reset             (sl_ehip_reset),
       .i_sl_ehip_rx_reset          (sl_ehip_rx_reset),
       .i_sl_ehip_tx_reset          (sl_ehip_tx_reset),
       .o_sl_ehip_ready             (sl_ehip_ready),
       .i_sl_ehip_pld_ready         (sl_ehip_pld_ready),
       .o_sl_ehip_reset_stat        (sl_ehip_reset_stat),
       .o_sl_ehip_rx_reset_stat     (sl_ehip_rx_reset_stat),
       .o_sl_ehip_tx_reset_stat     (sl_ehip_tx_reset_stat),

       .i_sl_rsfec_reset            (sl_rsfec_reset),
       .i_sl_rsfec_tx_reset         (sl_rsfec_tx_reset),
       .i_sl_rsfec_rx_reset         (sl_rsfec_rx_reset),

       .o_rx_fifo_ready             (),
       .o_tx_fifo_ready             (),
       .o_sl_rx_fifo_ready          (),
       .o_sl_tx_fifo_ready          (),


       // mii specific interface
       .i_tx_mii_d(int_tx_mii_d),
       .i_tx_mii_c(int_tx_mii_c),
       .i_tx_mii_valid(int_tx_mii_valid),
       .i_tx_mii_am(int_tx_mii_am),
       .o_tx_mii_ready(o_tx_mii_ready),
       .o_rx_mii_d(int_rx_mii_d),
       .o_rx_mii_c(int_rx_mii_c),
       .o_rx_mii_valid(int_rx_mii_valid),
       .o_rx_mii_am_valid(int_rx_mii_am_valid),

       .i_sl_tx_mii_d(i_sl_tx_mii_d_2d),
       .i_sl_tx_mii_c(i_sl_tx_mii_c_2d),
       .i_sl_tx_mii_valid(i_sl_tx_mii_valid),
       .i_sl_tx_mii_am(i_sl_tx_mii_am),
       .o_sl_tx_mii_ready(o_sl_tx_mii_ready),
       .o_sl_rx_mii_d(o_sl_rx_mii_d_2d),
       .o_sl_rx_mii_c(o_sl_rx_mii_c_2d),
       .o_sl_rx_mii_valid(o_sl_rx_mii_valid),
       .o_sl_rx_mii_am_valid(o_sl_rx_mii_am_valid),

        // pcs66 (OTN, FlexE) specific interface
       .i_tx_pcs66_d(int_tx_pcs66_d),
       .i_tx_pcs66_valid(int_tx_pcs66_valid),
       .i_tx_pcs66_am(int_tx_pcs66_am),
       .o_tx_pcs66_ready(o_tx_pcs66_ready),
       .o_rx_pcs66_d(int_rx_pcs66_d),
       .o_rx_pcs66_valid(int_rx_pcs66_valid),
       .o_rx_pcs66_am_valid(int_rx_pcs66_am_valid),

       .i_sl_tx_pcs66_d         (i_sl_tx_pcs66_d_2d),
       .i_sl_tx_pcs66_valid     (i_sl_tx_pcs66_valid),
       .i_sl_tx_pcs66_am        (i_sl_tx_pcs66_am),
       .o_sl_tx_pcs66_ready     (o_sl_tx_pcs66_ready),
       .o_sl_rx_pcs66_d         (o_sl_rx_pcs66_d_2d),
       .o_sl_rx_pcs66_valid     (o_sl_rx_pcs66_valid),
       .o_sl_rx_pcs66_am_valid  (o_sl_rx_pcs66_am_valid),

       // PMA Direct Interface
       .i_sl_tx_pma             (i_sl_tx_pma_2d),
       .o_sl_rx_pma             (o_sl_rx_pma_2d),
       .o_sl_aib_txfifo_empty   (o_sl_aib_txfifo_empty),
       .o_sl_aib_txfifo_full    (o_sl_aib_txfifo_full),
       .o_sl_aib_txfifo_pempty  (o_sl_aib_txfifo_pempty),
       .o_sl_aib_txfifo_pfull   (o_sl_aib_txfifo_pfull),
       .o_sl_aib_rxfifo_empty   (o_sl_aib_rxfifo_empty),
       .o_sl_aib_rxfifo_full    (o_sl_aib_rxfifo_full),
       .o_sl_aib_rxfifo_pempty  (o_sl_aib_rxfifo_pempty),
       .o_sl_aib_rxfifo_pfull   (o_sl_aib_rxfifo_pfull),
       .i_sl_aib_rxfifo_rd_en   (i_sl_aib_rxfifo_rd_en),

       // RX AIB deskew debug
       .i_sl_aib_rxfifo_latency_adj_ena     (i_sl_aib_rxfifo_latency_adj_ena),

       // Datapath mux select
       .i_sl_dp_sel             (sl_dp_sel),

       // Deterministic Latency Interface
       .o_sl_tx_dl_async_pulse  (o_sl_tx_dl_async_pulse),
       .o_sl_rx_dl_async_pulse  (o_sl_rx_dl_async_pulse),
       .i_sl_latency_sclk       (i_sl_latency_sclk),
       .i_sl_tx_dl_measure_sel  (i_sl_tx_dl_measure_sel),
       .i_sl_rx_dl_measure_sel  (i_sl_rx_dl_measure_sel),

       // test bus interface
       .i_testbus_en(i_testbus_en),
       .i_testbus_source(i_testbus_source[2:0]),
       .i_testbus_sel(i_testbus_sel[5:0]),

       // PTP
       // EHIP Interface: TX 1-step and 2-step Command
       .i_sl_ptp_tx_fp          (sl_ptp_tx_fp_to_ehip),
       .i_sl_ptp_ins_type       (sl_ptp_ins_type),
       .i_sl_ptp_byte_offset    (sl_ptp_byte_offset),
       .i_sl_ptp_ts             (sl_ptp_ts),

       // EHIP Interface: TX 2-step Timestamp
       .o_sl_ptp_tx_ts_valid    (sl_ptp_tx_ts_valid),
       .o_sl_ptp_tx_ts          (sl_ptp_tx_ts),
       .o_sl_ptp_tx_ts_fp       (sl_ptp_tx_ts_fp_from_ehip),

       // EHIP Interface: RX Timestamp
       .o_sl_ptp_rx_ts          (sl_ptp_rx_ts),

       // EHIP Interface: Reference Timestamp
       .i_sl_sclk               (sl_sclk),
       .i_sl_tx_sel_sclk_return (sl_tx_sel_sclk_return),
       .i_sl_rx_sel_sclk_return (sl_rx_sel_sclk_return),
       .o_sl_tx_sclk_return     (sl_tx_sclk_return),
       .o_sl_rx_sclk_return     (sl_rx_sclk_return),
       .o_sl_rx_am              (sl_rx_am),
       .o_sl_tx_am              (sl_tx_am),

       // AVMM Interface

       .i_ehip_reconfig_clk(ehip_reconfig_clk),
       .i_ehip_reconfig_rst_n (ehip_reconfig_rst_n),
       .i_ehip_reconfig_read(ehip_reconfig_read),
       .i_ehip_reconfig_address(ehip_reconfig_address),
       .i_ehip_reconfig_write(ehip_reconfig_write),
       .i_ehip_reconfig_writedata(ehip_reconfig_writedata),
       .o_ehip_reconfig_readdata(ehip_reconfig_readdata),
       .o_ehip_reconfig_waitrequest(ehip_reconfig_waitrequest),

       .i_rsfec_reconfig_clk(fec_reconfig_clk),
       .i_reconfig_reset(i_reconfig_reset),
	   .i_rsfec_reconfig_read(rsfec_reconfig_read),
       .i_rsfec_reconfig_addr(rsfec_reconfig_address),
       .i_rsfec_reconfig_write(rsfec_reconfig_write),
       .i_rsfec_reconfig_writedata(rsfec_reconfig_writedata),
       .o_rsfec_reconfig_readdata(rsfec_reconfig_readdata),
       .o_rsfec_reconfig_waitrequest(rsfec_reconfig_waitrequest),

       .i_ptp_reconfig_clk(fec_reconfig_clk_ptp),
       .i_ptp_reconfig_reset(i_reconfig_reset),
       .i_ptp_reconfig_read(i_ptp_reconfig_read),
       .i_ptp_reconfig_address(i_ptp_reconfig_address),
       .i_ptp_reconfig_write(i_ptp_reconfig_write),
       .i_ptp_reconfig_writedata(i_ptp_reconfig_writedata),
       .o_ptp_reconfig_readdata(o_ptp_reconfig_readdata),
       .o_ptp_reconfig_waitrequest(o_ptp_reconfig_waitrequest),

       .i_xcvr_reconfig_clk(xcvr_reconfig_clk),
       .i_xcvr_reconfig_reset(i_reconfig_reset),
       .i_xcvr_reconfig_write(xcvr_reconfig_write),
       .i_xcvr_reconfig_read(xcvr_reconfig_read),
       .i_xcvr_reconfig_address(xcvr_reconfig_address),
       .i_xcvr_reconfig_writedata(xcvr_reconfig_writedata),
       .o_xcvr_reconfig_readdata(xcvr_reconfig_readdata),
       .o_xcvr_reconfig_waitrequest(xcvr_reconfig_waitrequest),

       .i_xcvr_reconfig_clk_ptp(xcvr_reconfig_clk_ptp),
       .i_xcvr_reconfig_reset_ptp(i_reconfig_reset),
       .i_xcvr_reconfig_write_ptp(i_xcvr_reconfig_write_ptp),
       .i_xcvr_reconfig_read_ptp(i_xcvr_reconfig_read_ptp),
       .i_xcvr_reconfig_address_ptp(i_xcvr_reconfig_address_ptp),
       .i_xcvr_reconfig_writedata_ptp(i_xcvr_reconfig_writedata_ptp),
       .o_xcvr_reconfig_readdata_ptp(o_xcvr_reconfig_readdata_ptp),
       .o_xcvr_reconfig_waitrequest_ptp(o_xcvr_reconfig_waitrequest_ptp),
       .o_rsfec_channel_ssr(o_rsfec_channel_ssr),
       .rsfec_o_fec_ready(rsfec_o_fec_ready),
       .rsfec_signal_ok_from_top(rsfec_signal_ok_from_top) 		//to rsfec's signal_ok

       );

    assign var_xcvr_reconfig_write              = ((core_variant == 0) || ( core_variant == 1) || ((core_variant == 3) && (active_channel == 0)) || (core_variant == 4) || (core_variant == 5) || (core_variant == 7))? sl_xcvr_reconfig_write : i_xcvr_reconfig_write_jtag_arb;
    assign var_xcvr_reconfig_writedata          = ((core_variant == 0) || ( core_variant == 1) || ((core_variant == 3) && (active_channel == 0)) || (core_variant == 4) || (core_variant == 5) || (core_variant == 7))? sl_xcvr_reconfig_writedata : i_xcvr_reconfig_writedata_jtag_arb;
    assign var_xcvr_reconfig_read               = ((core_variant == 0) || ( core_variant == 1) || ((core_variant == 3) && (active_channel == 0)) || (core_variant == 4) || (core_variant == 5) || (core_variant == 7))? sl_xcvr_reconfig_read : i_xcvr_reconfig_read_jtag_arb;
    assign var_xcvr_reconfig_address            = ((core_variant == 0) || ( core_variant == 1) || ((core_variant == 3) && (active_channel == 0)) || (core_variant == 4) || (core_variant == 5) || (core_variant == 7))? sl_xcvr_reconfig_address : i_xcvr_reconfig_address_jtag_arb;
    assign o_xcvr_reconfig_readdata_jtag_arb    = ((core_variant == 0) || ( core_variant == 1) || ((core_variant == 3) && (active_channel == 0)) || (core_variant == 4) || (core_variant == 5) || (core_variant == 7))? sl_xcvr_reconfig_readdata : var_xcvr_reconfig_readdata;
    assign o_xcvr_reconfig_waitrequest_jtag_arb = ((core_variant == 0) || ( core_variant == 1) || ((core_variant == 3) && (active_channel == 0)) || (core_variant == 4) || (core_variant == 5) || (core_variant == 7))? sl_xcvr_reconfig_waitrequest : var_xcvr_reconfig_waitrequest;

    assign var_i_csr_rst                = ((core_variant == 0) || ( core_variant == 1) || ((core_variant == 3) && (active_channel == 0)) || (core_variant == 4) || (core_variant == 5) || (core_variant == 7))? (&i_sl_csr_rst_n) : i_csr_rst_n ;
generate
    if(ENABLE_ANLT) begin : GENKR
        wire [sl_num_lanes*2-1:0] ehip_sl_lnk_sts;

        for(i = 0; i < sl_num_lanes; i = i+1) begin : SLSTS
            assign ehip_sl_lnk_sts[i*2] = sl_rx_pcs_fully_aligned[i];
            assign ehip_sl_lnk_sts[i*2+1] = o_sl_rx_hi_ber[i];
        end

        // AN/LT logic
        alt_ehipc3_kr #(
            .core_variant(core_variant),
            .active_channel(active_channel),
            .max_xcvr_ch(max_xcvr_ch),
            .sl_num_lanes(sl_num_lanes),
            .LOCATION_SEL(LOCATION_SEL),
            .ENABLE_AN(ENABLE_AN),
            .ENABLE_LT(ENABLE_LT),
            .ENABLE_RSFEC(ENABLE_RSFEC_MODE),
            .EN_DYN_FEC(EN_DYN_FEC),
            .REQUEST_RSFEC(REQUEST_RSFEC),
            .CR_MODE(CR_MODE),
            .TECH_ABL(TECH_ABL),
            .AN_CHAN(AN_CHAN),
            .AN_PAUSE(AN_PAUSE),
            .STATUS_CLK_KHZ(STATUS_CLK_KHZ),
            .LINK_TIMER_KR(LINK_TIMER_KR),
            .ehip_rate_sl_0(ehip_rate_sl_0),
            .EN_PAM4(((core_variant == 2) || ((core_variant == 3) && (active_channel == 1))) && (topology == "ehip_4ch_kpfec")),
            .dis_anlt_std_recipe(dis_anlt_std_recipe)
        ) alt_ehipc3_fm_kr_inst (
            .i_reconfig_clk(i_reconfig_clk),
            .i_reconfig_reset(reconfig_reset_sync),
            .i_csr_rst_in((~var_i_csr_rst)|soft_csr_rst|(|sl_soft_csr_rst)),

            // Eth reconfig, user-facing side
            .i_eth_reconfig_addr(ehip_sladdress[20:0]),
            .i_eth_reconfig_read(ehip_slread),
            .i_eth_reconfig_write(ehip_slwrite),
            .i_eth_reconfig_writedata(ehip_slwrite_data),
            .o_eth_reconfig_readdata(ehip_slread_data),
            .o_eth_reconfig_readdata_valid(),
            .o_eth_reconfig_waitrequest(ehip_slwait_request),

            // Seperate XCVR reconfig Interfaces for each xcvr lane
            // User-facing side
            .i_xcvr_reconfig_address(var_xcvr_reconfig_address),
            .i_xcvr_reconfig_read(var_xcvr_reconfig_read),
            .i_xcvr_reconfig_write(var_xcvr_reconfig_write),
            .i_xcvr_reconfig_writedata(var_xcvr_reconfig_writedata),
            .o_xcvr_reconfig_readdata(var_xcvr_reconfig_readdata),
            .o_xcvr_reconfig_waitrequest(var_xcvr_reconfig_waitrequest),

            // Eth reconfig, hssi-facing side
            .ehip_reconfig_read(ehip_reconfig_read),
            .ehip_reconfig_address(ehip_reconfig_address),
            .ehip_reconfig_write(ehip_reconfig_write),
            .ehip_reconfig_writedata(ehip_reconfig_writedata),
            .ehip_reconfig_readdatavalid(1'b1),
            .ehip_reconfig_readdata(ehip_reconfig_readdata),
            .ehip_reconfig_waitrequest(ehip_reconfig_waitrequest),

            // XCVR reconfig, hssi-facing side
            .xcvr_reconfig_write(xcvr_reconfig_write),
            .xcvr_reconfig_read(xcvr_reconfig_read),
            .xcvr_reconfig_address(xcvr_reconfig_address),
            .xcvr_reconfig_writedata(xcvr_reconfig_writedata),
            .xcvr_reconfig_readdata(xcvr_reconfig_readdata),
            .xcvr_reconfig_waitrequest(xcvr_reconfig_waitrequest),

            // User-facing side
            .i_rsfec_reconfig_addr(i_rsfec_reconfig_addr_jtag_arb),
            .i_rsfec_reconfig_read(i_rsfec_reconfig_read_jtag_arb),
            .i_rsfec_reconfig_write(i_rsfec_reconfig_write_jtag_arb),
            .i_rsfec_reconfig_writedata(i_rsfec_reconfig_writedata_jtag_arb),
            .o_rsfec_reconfig_readdata(o_rsfec_reconfig_readdata_jtag_arb),
            .o_rsfec_reconfig_waitrequest(o_rsfec_reconfig_waitrequest_jtag_arb),

            // RSFEC reconfig, hssi-facing side
            .rsfec_reconfig_read(rsfec_reconfig_read),
            .rsfec_reconfig_address(rsfec_reconfig_address),
            .rsfec_reconfig_write(rsfec_reconfig_write),
            .rsfec_reconfig_writedata(rsfec_reconfig_writedata),
            .rsfec_reconfig_readdata(rsfec_reconfig_readdata),
            .rsfec_reconfig_waitrequest(rsfec_reconfig_waitrequest),

            // KR Soft CSR Interface
            .eth_status_read(kr_read),
            .eth_status_write(kr_write),
            .eth_status_addr(a_eth_reconfig_addr[7:0]),
            .eth_status_readdata(kr_read_data),
            .eth_status_writedata(a_eth_reconfig_writedata),
            .eth_status_readdata_valid(kr_read_valid),
            .eth_status_waitrequest(kr_wait),

            .sl_eth_status_read(sl_kr_read[sl_num_lanes-1:0]),
            .sl_eth_status_write(sl_kr_write[sl_num_lanes-1:0]),
            .sl_eth_status_addr(i_sl_eth_reconfig_addr_2d[sl_num_lanes-1:0]),
            .sl_eth_status_readdata(sl_kr_read_data[sl_num_lanes-1:0]),
            .sl_eth_status_writedata(i_sl_eth_reconfig_writedata_2d[sl_num_lanes-1:0]),
            .sl_eth_status_readdata_valid(sl_kr_read_valid[sl_num_lanes-1:0]),
            .sl_eth_status_waitrequest(sl_kr_wait[sl_num_lanes-1:0]),

            // Link Status Signals
            .ehip_lnk_sts({ehip_rx_hi_ber_out,ehip_rx_pcs_fully_aligned_out}),
            .ehip_sl_lnk_sts(ehip_sl_lnk_sts),

            // Reset controller interface
            .kr_mode(kr_mode),
            .kr_rst_req(kr_rst_req),
            .kr_rst_stat(kr_rst_stat),

			//RSFEC Enable mode
			.kr_dyn_fec_en(kr_dyn_fec_en)
        );

    end else begin : NOKR
        assign kr_mode = 4'b0;
        assign kr_rst_req = 4'b0;
        assign sl_kr_sel = {sl_num_lanes{1'b0}};
        assign sl_kr_read_valid = {sl_num_lanes{1'b0}};

        assign rsfec_reconfig_write = i_rsfec_reconfig_write_jtag_arb;
        assign rsfec_reconfig_writedata = i_rsfec_reconfig_writedata_jtag_arb;
        assign rsfec_reconfig_read = i_rsfec_reconfig_read_jtag_arb;
        assign rsfec_reconfig_address = i_rsfec_reconfig_addr_jtag_arb;
        assign o_rsfec_reconfig_readdata_jtag_arb = rsfec_reconfig_readdata;
        assign o_rsfec_reconfig_waitrequest_jtag_arb = rsfec_reconfig_waitrequest;

        assign xcvr_reconfig_write           = var_xcvr_reconfig_write;
        assign xcvr_reconfig_writedata       = var_xcvr_reconfig_writedata;
        assign xcvr_reconfig_read            = var_xcvr_reconfig_read;
        assign xcvr_reconfig_address         = var_xcvr_reconfig_address;
        assign var_xcvr_reconfig_readdata    = xcvr_reconfig_readdata;
        assign var_xcvr_reconfig_waitrequest = xcvr_reconfig_waitrequest;

        assign ehip_reconfig_write = ehip_slwrite;
        assign ehip_reconfig_writedata = ehip_slwrite_data;
        assign ehip_reconfig_read = ehip_slread;
        assign ehip_reconfig_address = ehip_sladdress[20:0];
        assign ehip_slread_data = ehip_reconfig_readdata;
        assign ehip_slwait_request = ehip_reconfig_waitrequest;

        assign kr_read_data = 32'd0;
        assign kr_wait = 1'b0;
        assign int_tx_ready_r = int_tx_ready;
        assign sl_kr_read_data = 128'b0;
        assign sl_kr_wait = 4'b0;
        always_ff @(posedge i_reconfig_clk) kr_read_valid  <= kr_read;

    end
endgenerate


   assign ptp_tx_transfer_ready = (ENABLE_PTP ? tx_transfer_ready[5:4] : 2'b00);
   assign ptp_rx_transfer_ready = (ENABLE_PTP ? rx_transfer_ready[5:4] : 2'b00);

   // Reset controller IP
   generate
      if (core_variant==2 || (core_variant==3 && active_channel==1))
	begin : RST_CTRL_100G
   wire kr_rst_stat_int;
   assign int_tx_transfer_ready = tx_transfer_ready[3:0] & (ENABLE_PTP ? {4{&tx_transfer_ready[5:4]}} : {4{1'b1}});
   assign int_rx_transfer_ready = rx_transfer_ready[3:0] & (ENABLE_PTP ? {4{&rx_transfer_ready[5:4]}} : {4{1'b1}});
   alt_ehipc3_fm_reset_controller
     #(
       .CLK_FREQ_IN_HZ(100000000),
       .NUM_CHANNELS(num_lanes),
       .SIM_EMULATE   (SIM_EMULATE),
       .ENABLE_RSFEC(ENABLE_RSFEC_MODE),
       .ENABLE_EXTERNAL_AIB_CLOCKING(enable_external_aib_clocking)
       ) alt_ehipc3_fm_reset_controller_inst
       (

	.csr_rst_in(~i_csr_rst_n), // User reset (~csr_rst
	.tx_rst_in(~i_tx_rst_n), // User reset (~tx_rst_n
	.rx_rst_in(~i_rx_rst_n), // User reset (~rx_rst_n

	// Clock port for generating proper tx_eth_ready, rx_eth_ready signals
	.clk_status(i_reconfig_clk),
	.pll_locked_in(1'b1), //no more atx_pll for C3
	.rx_pcs_fully_aligned_in(ehip_rx_pcs_fully_aligned_out && rx_deskew_done_qual),

	// From CSR registers
	.soft_tx_rst_in(soft_tx_rst),
	.soft_rx_rst_in(soft_rx_rst),
	.soft_csr_rst_in(soft_csr_rst),

	// Native PHY IP Interface

	.tx_pma_ready_in(tx_pma_ready),
	.rx_pma_ready_in(rx_pma_ready),
	.tx_transfer_ready_in(int_tx_transfer_ready[3:0]), // from Native phy
	.tx_dll_lock_in(int_tx_dll_lock),
	.rx_transfer_ready_in(int_rx_transfer_ready[3:0]), // from Nativ
	.tx_cal_busy({num_lanes{1'b0}}), // no signal from Native PHY IP
	.rx_cal_busy({num_lanes{1'b0}}), // no signal from Native PHY IP
	.rx_is_lockedtoref_in(4'b1111/*rx_is_lockedtoref*/), // from Nativ -- temp fix
	.rx_is_lockedtodata_in(rx_is_lockedtodata), // from Nati

	.tx_aib_reset_out(tx_aib_reset), // To native PHY
	.tx_pcs_reset_out(tx_digitalreset), // To Native PHY
	.rx_aib_reset_out(rx_aib_reset), // To native PHY
	.rx_pcs_reset_out(rx_digitalreset), // To native PHY

        .pause_ehip_ready_in(pause_ehip_ready), // EHIP ready from the pause module

        // EHIP Interface
	.ehip_ready_in(ehip_ready),
	.ehip_reset_ack_in(~ehip_rst_n_ack),
	.ehip_tx_reset_ack_in(~ehip_tx_rst_n_ack),
	.ehip_rx_reset_ack_in(~ehip_rx_rst_n_ack),
	.ehip_reset_out(ehip_rst), // To EHIP -
	.ehip_tx_reset_out(ehip_tx_rst), // to EHIP
	.ehip_rx_reset_out(ehip_rx_rst), // to EHIP - con
	// RSFEC
	.rsfec_reset_out(rsfec_rst), // To RSFEC -
	.rsfec_tx_reset_out(rsfec_tx_rst), // to RSFEC
	.rsfec_rx_reset_out(rsfec_rx_rst), // to RSFEC

	.ehip_signal_ok_out(ehip_signal_ok),
	.ehip_pld_ready_out(ehip_pld_ready),

	.csr_rst_stat(csr_rst_stat), // to core csr_rst_st
	.tx_rst_stat(tx_rst_stat), // to core tx_rst_stat
	.rx_rst_stat(rx_rst_stat), // to core rx_rst_stat
	.tx_lanes_stable(tx_lanes_stable),
	.tx_eth_ready(),		//no use
	.rx_eth_ready(o_rx_pcs_ready),

    // KR/reconfiguration interface
	.kr_mode_in(kr_mode[0]),
	.kr_rst_req(kr_rst_req[0]),
	.kr_rst_stat(kr_rst_stat_int),
	.ehip_ready_out(o_ehip_ready)
	);
    assign kr_rst_stat = {4{kr_rst_stat_int}};
    end // RST_CTRL_100G
    else begin
        assign ehip_rst = &sl_ehip_reset;
        assign ehip_tx_rst = &sl_ehip_tx_reset;
        assign ehip_rx_rst = &sl_ehip_rx_reset;
        assign ehip_pld_ready = |sl_ehip_pld_ready;
        assign ehip_signal_ok = |sl_ehip_signal_ok;
        assign rsfec_rst = 1'b0;
        assign tx_aib_reset = '0;
        assign rx_aib_reset = '0;
        assign rx_digitalreset = '0;
        assign tx_digitalreset = '0;
        assign tx_lanes_stable = '0;
        assign rsfec_tx_rst = '0;
        assign rsfec_rx_rst = '0;
        assign o_rx_pcs_ready = 1'b0;
    end
   endgenerate

generate
   if (core_variant==2 || (core_variant==3 && active_channel==1)) begin : TX_DESKEW

wire csr_rst_n_tx_sync;
alt_xcvr_resync_std #(
          .SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0)
          )
  csr_reset_synchronizers3 (
  .clk	(int_tx_clk),
	.reset	(1'b0),
	.d	(i_csr_rst_n),
	.q	(csr_rst_n_tx_sync)
  );

   // TX Deskew logic
   alt_ehipc3_fm_tx_deskew
     #(
       .LANES(num_lanes+2)
       )
   tx_dsk_inst
     (
      .i_clk(int_tx_clk),
      .i_resetn(csr_rst_n_tx_sync),
      .o_dsk(int_tx_aib_dsk_w[6-1:0])
      );

   // Add additional flop for better timing performance
   always @(posedge int_tx_clk) begin
     int_tx_aib_dsk_r <= int_tx_aib_dsk_w;
   end

   assign int_tx_aib_dsk = ENABLE_PTP ? int_tx_aib_dsk_r : int_tx_aib_dsk_w;
end
else begin
    assign int_tx_aib_dsk = '0;
end
endgenerate

wire int_tx_ready_sync;
/*alt_xcvr_resync_std #(
          .SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0)
          )
  tx_ready_synchronizers (
  .clk	(int_tx_clk),
	.reset	(1'b0),
	.d	(int_tx_ready),
	.q	(int_tx_ready_sync)
  );*/
wire tx_ready_sync_fifo_empty;
alt_ehipc3_fm_dcfifo_mlab #(
    .WIDTH(1)
) tx_ready_sync_fifo (
    .aclr(~tx_lanes_stable_sync),

    .wclk(int_rx_clk),
    .write(1'b1),
    .wdata(int_tx_ready),
    .full(),

    .rclk(int_tx_clk),
    .read(~tx_ready_sync_fifo_empty),
    .rdata(int_tx_ready_sync),
    .empty(tx_ready_sync_fifo_empty)
);

   generate
if ((core_variant==2 || (core_variant==3 && active_channel==1)) && (ehip_mode == "ehip_mac_no_fec"|| ehip_mode == "ehip_mac" || ehip_mode == "ehip_mac_ptp_no_fec" || ehip_mode == "ehip_mac_ptp")) begin : TX_ADAPTER_100G

            logic   [31:0]  tx_starts_in;
            logic   [31:0]  tx_starts_out;
            logic   [31:0]  tx_ends_in;
            logic   [31:0]  tx_ends_out;
            logic   [0:7]   tx_mem_underflow;

	   if (TX_ASYNC_ADAPTER_MODE) begin : TX_ADAPTER_ASYNC
                alt_ehipc3_fm_100g_adapter_tx_async #(
                   .READY_LATENCY(ready_latency)
                ) adapter_tx_inst (
                    .i_arst             (~tx_lanes_stable),

                    // User ports
                    .i_clk_w            (i_clk_tx),
                    .i_valid            (i_tx_valid),
                    .i_data             (i_tx_data),
                    .i_sop              (i_tx_startofpacket),
                    .i_eop              (i_tx_endofpacket),
                    .i_empty            (i_tx_empty),
                    .i_error            (i_tx_error),
                    .o_ready            (o_tx_ready),
                    .i_skip_crc         (i_tx_skip_crc),

                    // EHIP Interface
                    .i_clk_r            (o_clk_pll_div64),
                    .o_data             (int_tx_data),
                    .o_valid            (int_tx_valid),
                    .i_ready            (int_tx_ready),
                    .o_inframe          (int_tx_inframe),
                    .o_empty            (int_tx_empty),
                    .o_error            (int_tx_error),
                    .o_skip_crc         (int_tx_skip_crc),
                    .o_starts_in        (tx_starts_in),
                    .o_starts_out       (tx_starts_out),
                    .o_ends_in          (tx_ends_in),
                    .o_ends_out         (tx_ends_out),
                    .o_mem_underflow    (tx_mem_underflow)
                );
     end //TX_ADAPTER_ASYNC
    else begin : TX_ADAPTER_SYNC
          if (ENABLE_PTP_TOG) begin : PTP_TX_ADAPTER_AND_FIFO
          // Generate for TX adapter
          `ifdef ALTERA_RESERVED_QIS
                // NO adapters for HW. int_tx_data and other signals are direct input to DUT
              assign int_tx_data = int_tx_data_0;
              assign int_tx_valid = int_tx_valid_0;
              assign int_tx_inframe = int_tx_inframe_0;
              assign int_tx_empty = int_tx_empty_0;
              assign int_tx_error = int_tx_error_0;
              assign int_tx_skip_crc = int_tx_skip_crc_0;
              assign int_tx_ready_r_0 = int_tx_ready_r; // int_tx_ready_r_0 is output from top
          `else
              logic           if_last;
              logic   [0:3]   sop;
              logic           start_out;
              logic           start_in;
              logic           write;
              logic           read;
              logic           reset;
              assign reset = ~tx_lanes_stable;
              always_ff @(posedge i_clk_tx) begin
                  if (reset) begin
                      if_last <= 1'b0;
                  end else begin
                      if (int_tx_valid) begin
                          if_last <= int_tx_inframe[0];
                      end else begin
                          if_last <= if_last;
                      end
                  end
              end
              assign start_out = |sop;
              assign read = start_out & int_tx_valid;
              assign write = start_in;
              assign sop = int_tx_inframe & ~{if_last, int_tx_inframe[3:1]};
              assign start_in = i_tx_startofpacket && i_tx_valid && o_tx_ready;
	          alt_ehipc3_fm_100g_adapter_tx adater_tx_inst (
			                 .i_clk(i_clk_tx),
		                // User ports
		                .i_reset(~tx_lanes_stable_sync),
		                .i_valid(i_tx_valid),
		                .i_data(i_tx_data),
		                .i_sop(i_tx_startofpacket),
		                .i_eop(i_tx_endofpacket),
		                .i_empty(i_tx_empty),
		                .i_error(i_tx_error),
				.o_ready(o_tx_ready),
		                .i_skip_crc(i_tx_skip_crc),
		                // EHIP Interface
		                .o_data(int_tx_data),
		                .o_valid(int_tx_valid),
		                .o_early_valid(int_tx_early_valid),
		                   .i_ready(int_tx_ready_r),
				.o_inframe(int_tx_inframe),
		                .o_empty(int_tx_empty),
		                .o_error(int_tx_error),
		                .o_skip_crc(int_tx_skip_crc),
                               .o_ptp_tx_fp         (),
                               .o_ptp_byte_offset        (int_ptp_byte_offset),
                               .o_ptp_ins_type         (int_ptp_ins_type),
                               .o_ptp_ts         (int_ptp_ts),
                    .o_starts_in        (tx_starts_in),
                    .o_starts_out       (tx_starts_out),
                    .o_ends_in          (tx_ends_in),
                    .o_ends_out         (tx_ends_out)
//                    .o_mem_underflow    (tx_mem_underflow)
		            );
              alt_ehipc3_fm_100g_adapter_tx
	     #(
                  .DWIDTH(6)
                  ) sideband_adapter_tx_inst (
		.i_clk(i_clk_tx),
		// User ports
                  .i_reset(~tx_lanes_stable_sync),
		.i_valid(i_tx_valid),
                  .i_data({
                  i_ptp_ins_type[23:21], i_ptp_byte_offset[23:21],
                  i_ptp_ins_type[20:18], i_ptp_byte_offset[20:18],
                  i_ptp_ins_type[17:15], i_ptp_byte_offset[17:15],
                  i_ptp_ins_type[14:12], i_ptp_byte_offset[14:12],
                  i_ptp_ins_type[11:9], i_ptp_byte_offset[11:9],
                  i_ptp_ins_type[8:6], i_ptp_byte_offset[8:6],
                  i_ptp_ins_type[5:3], i_ptp_byte_offset[5:3],
                  i_ptp_ins_type[2:0], i_ptp_byte_offset[2:0]
                  }), //Concat of ins_type and byte_offset considering i_tx_data is a 2d packed array of dimensions [7:0][6:0]
		.i_sop(i_tx_startofpacket),
		.i_eop(i_tx_endofpacket),
		.i_empty(i_tx_empty),
		.i_error(i_tx_error),
                  .o_ready(/*not connected*/),
		.i_skip_crc(i_tx_skip_crc),
		// EHIP Interface
                  .o_data({
                     o_ptp_ins_type[11:9], o_ptp_byte_offset[11:9],
                     o_ptp_ins_type[8:6], o_ptp_byte_offset[8:6],
                     o_ptp_ins_type[5:3], o_ptp_byte_offset[5:3],
                     o_ptp_ins_type[2:0], o_ptp_byte_offset[2:0]
                    }),
                  .o_valid(/*not connected*/),
                  .o_early_valid(/*not connected*/),
		.i_ready(int_tx_ready),
                  .o_inframe(/*not connected*/),
                  .o_empty(/*not connected*/),
                  .o_error(/*not connected*/),
                  .o_skip_crc(/*not connected*/),
                  .o_starts_in        (/*not connected*/),
                  .o_starts_out       (/*not connected*/),
                  .o_ends_out         (/*not connected*/)
                  //                    .o_mem_underflow    (/*not connected*/)
        );
             alt_ehipc3_fm_ehip_sync_fifo_rk
         #(
                  .DWIDTH (104),  // FIFO Input data width: 96 (ing_ts) + 8 (fingerprint).
                  .AWIDTH (5)     // FIFO address width
                  ) flf
	       (
                  .rst_n(tx_lanes_stable_sync), //Ask about this.
                  .srst_n(1'b1),
                  .ena(1'b1),
                  .clk(i_clk_tx),
                  .wr_en(write),
                  .wr_data({i_ptp_fp_tb, i_ptp_ing_ts_tb}),
                  .rd_en(read),
                  .r_empty(5'd0),
                  .r_full(5'd12),
                  .rd_data({o_ptp_fp_tb, o_ptp_ing_ts_tb}),
                  .numdata(),     //Left loose purposely
                  .full(),        //Left loose purposely
                  .empty()        //Left loose purposely
                  );
          `endif
      end // PTP_TX_ADAPTER_AND_FIFO
      else if (ENABLE_PTP) begin : PTP_TX_ADAPTER_AND_FIFO_PR

        // The following combinational logic was added by Goose to generate the read_en and
        // write_en signals for the FIFO which holds ingress timestamp (i_ptp_ing_ts_tb) and
        // fingerprint (i_ptp_fp_tb) signals for PTP modules.

        always_ff @(posedge int_tx_clk) begin
            if (~tx_lanes_stable_sync) begin
                ml_tx_inframe_r <= 1'b0;
            end else begin
                if (int_tx_valid_ptp_wire) begin
                    ml_tx_inframe_r <= ml_tx_inframe_wire[0];
                end else begin
                    ml_tx_inframe_r <= ml_tx_inframe_r;
                end
            end
        end

        assign ml_tx_sop = ml_tx_inframe_wire & ~{ml_tx_inframe_r, ml_tx_inframe_wire[3:1]};

        assign tx_ts_ff_write = i_tx_startofpacket && i_tx_valid && o_tx_ready;
        assign tx_ts_ff_read = (|ml_tx_sop) & int_tx_valid_ptp_wire;

        alt_ehipc3_fm_100g_adapter_tx adater_tx_inst (
            .i_clk              (int_tx_clk),

            // User ports
            .i_reset            (~tx_lanes_stable_sync),
            .i_valid            (i_tx_valid),
            .i_data             (i_tx_data),
            .i_sop              (i_tx_startofpacket),
            .i_eop              (i_tx_endofpacket),
            .i_empty            (i_tx_empty),
            .i_error            (i_tx_error),
            .o_ready            (o_tx_ready),
            .i_skip_crc         (i_tx_skip_crc),

            // EHIP Interface
            .o_data             (ml_tx_data_wire),
            .o_valid            (int_tx_valid_ptp_wire),
            .o_early_valid      (int_tx_early_valid_wire),
// ---------------------------------------------------------------------------------------------------------------------------------
// 24/Apr/2019 : slim35 : HSD#2207176525 : o_tx_ready going x on PTP and AN/LT enable.
// i_ready of TX_ADAPTER_100G.TX_ADAPTER_SYNC.PTP_TX_ADAPTER_AND_FIFO_PR.adater_tx_inst should be connected to int_tx_ready instead of int_tx_ready_r.
// ---------------------------------------------------------------------------------------------------------------------------------
//            .i_ready            (int_tx_ready_r),
            .i_ready            (int_tx_ready),
// ----------------------------------------------------------------------------------------------------------
            .o_inframe          (ml_tx_inframe_wire),
            .o_empty            (ml_tx_empty_wire),
            .o_error            (ml_tx_error_wire),
            .o_skip_crc         (ml_tx_skip_crc_wire),
            .o_ptp_tx_fp        (),
            .o_ptp_byte_offset  (),
            .o_ptp_ins_type     (),
            .o_ptp_ts           (),
            .o_starts_in        (tx_starts_in),
            .o_starts_out       (tx_starts_out),
            .o_ends_in          (tx_ends_in),
            .o_ends_out         (tx_ends_out)
        );

        assign usr_tx_ptp_ff_in = {i_ptp_ins_ets,       // 1-bit
                                   i_ptp_ins_cf,        // 1-bit
                                   i_ptp_zero_csum,     // 1-bit
                                   i_ptp_update_eb,     // 1-bit
                                   i_ptp_ts_format,     // 1-bit
                                   i_ptp_ts_offset,     // 16-bit
                                   i_ptp_cf_offset,     // 16-bit
                                   i_ptp_csum_offset,   // 16-bit
                                   i_ptp_eb_offset,     // 16-bit
                                   i_ptp_tx_its,        // 96-bit
                                   i_ptp_ts_req,        // 1-bit
                                   i_ptp_fp             // 8-bit
                                  };

        assign {ml_ptp_ins_ets,       // 1-bit
                ml_ptp_ins_cf,        // 1-bit
                ml_ptp_ins_zero_csum, // 1-bit
                ml_ptp_ins_update_eb, // 1-bit
                ml_ptp_ts_format,     // 1-bit
                ml_ptp_ts_offset,     // 16-bit
                ml_ptp_cf_offset,     // 16-bit
                ml_ptp_csum_offset,   // 16-bit
                ml_ptp_eb_offset,     // 16-bit
                ml_ptp_tx_its,        // 96-bit
                ml_ptp_ts_req,        // 1-bit
                ml_ptp_fp             // 8-bit
               } = usr_tx_ptp_ff_out;

        always_ff @(posedge int_tx_clk) begin
            if (~tx_lanes_stable_sync) begin
                ptp_tx_ff_waddr <= 4'h0;
                ptp_tx_ff_raddr <= 4'h0;
            end else begin
                if (tx_ts_ff_write) begin
                    ptp_tx_ff_waddr <= ptp_tx_ff_waddr + 1'b1;
                end
                else begin
                    ptp_tx_ff_waddr <= ptp_tx_ff_waddr;
                end

                if (tx_ts_ff_read) begin
                    ptp_tx_ff_raddr <= ptp_tx_ff_raddr + 1'b1;
                end
                else begin
                    ptp_tx_ff_raddr <= ptp_tx_ff_raddr;
                end
            end
        end

        alt_ehipc3_fm_mlab #(
            .WIDTH      (TX_PTP_WIDTH),
            .ADDR_WIDTH (4),
            .SIM_EMULATE(0)
        ) ptp_tx_ff (
            .wclk       (int_tx_clk),
            .wdata_reg  (usr_tx_ptp_ff_in),
            .wena       (tx_ts_ff_write),
            .waddr_reg  (ptp_tx_ff_waddr),
            .raddr      (ptp_tx_ff_raddr),
            .rdata      (usr_tx_ptp_ff_out_wire)
        );

        // Pipeline for timing closure
        always_ff @(posedge int_tx_clk) begin
            int_tx_valid_ptp    <= int_tx_valid_ptp_wire;
            int_tx_early_valid  <= int_tx_early_valid_wire;
            ml_tx_data          <= ml_tx_data_wire;
            ml_tx_inframe       <= ml_tx_inframe_wire;
            ml_tx_empty         <= ml_tx_empty_wire;
            ml_tx_error         <= ml_tx_error_wire;
            ml_tx_skip_crc      <= ml_tx_skip_crc_wire;
            usr_tx_ptp_ff_out   <= usr_tx_ptp_ff_out_wire;
        end

      end // PTP_TX_ADAPTER_AND_FIFO_PR
      else begin : NON_PTP_CASE_ADAPTER
	          alt_ehipc3_fm_100g_adapter_tx #(
                   .READY_LATENCY(ready_latency)
                ) adater_tx_inst (
		                .i_clk(int_tx_clk),

		// User ports
		                .i_reset(~tx_lanes_stable_sync),
		.i_valid(i_tx_valid),
		.i_data(i_tx_data),
		.i_sop(i_tx_startofpacket),
		.i_eop(i_tx_endofpacket),
		.i_empty(i_tx_empty),
		.i_error(i_tx_error),
		.o_ready(o_tx_ready),

		.i_skip_crc(i_tx_skip_crc),

		// EHIP Interface
		.o_data(int_tx_data),
		.o_valid(int_tx_valid),
        .o_early_valid(int_tx_early_valid),
		.i_ready(int_tx_ready_sync),
		.o_inframe(int_tx_inframe),
		.o_empty(int_tx_empty),
		.o_error(int_tx_error),
		                .o_skip_crc(int_tx_skip_crc),
                    .o_starts_in        (tx_starts_in),
                    .o_starts_out       (tx_starts_out),
                    .o_ends_in          (tx_ends_in),
                    .o_ends_out         (tx_ends_out)
		            );
    end // NO_PTP_CASE_ADAPTER
    end // TX_ADAPTER_SYNC
    end // TX_ADAPTER_100G
  else begin :SL_ASSIGNMENTS










	   assign int_tx_error = ({num_lanes{1'b0}});
	   assign int_tx_inframe = ({num_lanes{1'b0}});
	   assign int_tx_skip_crc = ({num_lanes{1'b0}});
	   assign int_tx_valid = 1'b0;
	   assign o_tx_ready = 1'b0;
	   for (ig=0; ig<num_lanes; ig=ig+1) begin : g_te
	      assign int_tx_empty[ig] = 3'b000;
        assign int_tx_data[ig] = 64'd0;
	   end
  end // SL_ASSIGNMENTS
   endgenerate
   wire [num_lanes-1:0]         dsk_rx_inframe;
   wire [num_lanes-1:0][63:0]   dsk_rx_data  ;
   wire [num_lanes-1:0][2:0]    dsk_rx_empty ;
   wire [num_lanes-1:0][1:0]    dsk_rx_error ;
   wire [num_lanes-1:0][2:0]    dsk_rx_status;
   wire [num_lanes-1:0]         dsk_rx_valid;
   wire [num_lanes-1:0]         dsk_rx_fcs_error;

// Add additional flop for better timing performance
always @(posedge int_rx_clk) begin
    txAdpt_to_rxAdpt_loopback_sync_r <= txAdpt_to_rxAdpt_loopback_sync_w;
end

assign txAdpt_to_rxAdpt_loopback_sync = ENABLE_PTP ? txAdpt_to_rxAdpt_loopback_sync_r : txAdpt_to_rxAdpt_loopback_sync_w;

assign dsk_rx_inframe_0        = /*txAdpt_to_rxAdpt_loopback_sync ? int_tx_inframe    :*/ dsk_rx_inframe;
assign dsk_rx_data_0           = /*txAdpt_to_rxAdpt_loopback_sync ? int_tx_data       :*/ dsk_rx_data;
assign dsk_rx_valid_0          = /*txAdpt_to_rxAdpt_loopback_sync ? int_tx_valid      :*/ dsk_rx_valid[0];
assign dsk_rx_empty_0          = /*txAdpt_to_rxAdpt_loopback_sync ? int_tx_empty      :*/ dsk_rx_empty;
assign dsk_rx_error_0          = /*txAdpt_to_rxAdpt_loopback_sync ? int_tx_error      :*/ dsk_rx_error;
assign dsk_rx_fcs_error_0      = /*txAdpt_to_rxAdpt_loopback_sync ? {num_lanes{1'b0}} :*/ dsk_rx_fcs_error;
assign dsk_rx_status_0         = /*txAdpt_to_rxAdpt_loopback_sync ? {num_lanes{3'b0}} :*/ dsk_rx_status;


   generate
	if ((core_variant == 2) || ((core_variant == 3) && (active_channel == 1))) begin : DESKEW
//	  localparam deskew_lanes = ENABLE_PTP ? num_lanes+2 : num_lanes;

           wire             rx_deskew_done;
           wire             rx_pcs66_deskew_done;
           wire             rx_pcs64_deskew_done;

    if ((!ENABLE_PCS66)&&(!ENABLE_PCSDIRECT)) begin: MACPCSDIR

    logic [deskew_lanes-1:0][(3+1+2+3+1+1+64)-1:0]  rx_deskew_din;
    logic [deskew_lanes-1:0][(3+1+2+3+1+1+64)-1:0]  rx_deskew_dout_w;
    logic [deskew_lanes-1:0][(3+1+2+3+1+1+64)-1:0]  rx_deskew_dout;
//	   wire 			     rx_deskew_done;

           assign rx_deskew_done_qual = rx_deskew_done;

	   assign rx_deskew_din[0] = {int_rx_status[0],
				      int_rx_fcs_error[0],
				      int_rx_error[0],
				      int_rx_empty[0],
				      int_rx_valid,
				      int_rx_inframe[0],
				      int_rx_data[0]
				      };

	   assign rx_deskew_din[1] = {int_rx_status[1],
				      int_rx_fcs_error[1],
				      int_rx_error[1],
				      int_rx_empty[1],
				      1'b0,
				      int_rx_inframe[1],
				      int_rx_data[1]
				      };
	   assign rx_deskew_din[2] = {int_rx_status[2],
				      int_rx_fcs_error[2],
				      int_rx_error[2],
				      int_rx_empty[2],
				      1'b0,
				      int_rx_inframe[2],
				      int_rx_data[2]
				      };

	   assign rx_deskew_din[3] = {int_rx_status[3],
				      int_rx_fcs_error[3],
				      int_rx_error[3],
				      int_rx_empty[3],
				      1'b0,
				      int_rx_inframe[3],
				      int_rx_data[3]
				      };
if(ENABLE_PTP_TOG || ENABLE_PTP) begin: PTP_LANES
    assign rx_deskew_din[4] =  {1'b0,
                                int_ptp_tx_ts,          // 48
                                int_ptp_tx_fp,          // 8
                                int_ptp_tx_ts_valid[0], // 1
                                int_ptp_rx_ts[0][16:0]  // 17
                               };

    assign rx_deskew_din[5] =  {5'h0,
                                int_ptp_tx_am[0],
                                int_ptp_rx_am[0],
                                int_ptp_rx_ts[3],
                                int_ptp_rx_ts[2],
                                int_ptp_rx_ts[1],
                                int_ptp_rx_ts[0][20:17],
                                int_ptp_reading_vl_data
                               };
end // PTP_LANES

	   alt_ehipc3_fm_rx_deskew #(
        .LANES         (deskew_lanes),
				  .WIDTH         (3+1+2+3+1+1+64),    // Per lane width
                  .REGISTER_INPUT (1),
                  .REGISTER_OUTPUT(1),
				  .SIM_EMULATE   (0)
				  ) rx_dsk_inst (
						 .i_clk          (int_rx_clk),
             .i_reset        (~ehip_rx_rst_n_ack_sync),
						 .i_data         (rx_deskew_din),
						 .i_sync_pulse   (rx_aib_dsk),
						 .o_data         (rx_deskew_dout_w),
						 .o_deskew_done  (rx_deskew_done)
						 );

       if(ENABLE_PTP) begin: RX_DESKEW_PIPELINE
            // Additional pipeline for better timing performance
            always @(posedge int_rx_clk) begin
                rx_deskew_dout <= rx_deskew_dout_w;
            end
       end
       else begin
            assign rx_deskew_dout = rx_deskew_dout_w;
       end

	   assign  {dsk_rx_status[0],
		    dsk_rx_fcs_error[0],
		    dsk_rx_error[0],
		    dsk_rx_empty[0],
		    dsk_rx_valid[0],
		    dsk_rx_inframe[0],
		    dsk_rx_data[0]} = rx_deskew_dout[0];

	   assign  {dsk_rx_status[1],
		    dsk_rx_fcs_error[1],
		    dsk_rx_error[1],
		    dsk_rx_empty[1],
		    dsk_rx_valid[1],
		    dsk_rx_inframe[1],
		    dsk_rx_data[1]} = rx_deskew_dout[1];

	   assign  {dsk_rx_status[2],
		    dsk_rx_fcs_error[2],
		    dsk_rx_error[2],
		    dsk_rx_empty[2],
		    dsk_rx_valid[2],
		    dsk_rx_inframe[2],
		    dsk_rx_data[2]} = rx_deskew_dout[2];

	   assign  {dsk_rx_status[3],
		    dsk_rx_fcs_error[3],
		    dsk_rx_error[3],
		    dsk_rx_empty[3],
		    dsk_rx_valid[3],
		    dsk_rx_inframe[3],
		    dsk_rx_data[3]} = rx_deskew_dout[3];

if(ENABLE_PTP_TOG || ENABLE_PTP) begin: PTP_LANES_2
    assign  {ptp_unused0,
             o_ptp_tx_ts,
             o_ptp_tx_fp,
             o_ptp_tx_ts_valid[0],
             o_ptp_rx_ts[16:0]} = rx_deskew_dout[4];

    assign  {ptp_unused1,
             ml_tx_am,
             ml_rx_am,
             o_ptp_rx_ts[83:63],
             o_ptp_rx_ts[62:42],
             o_ptp_rx_ts[41:21],
             o_ptp_rx_ts[20:17],
             o_ptp_reading_vl_data} = rx_deskew_dout[5];
end // PTP_LANES_2
else begin
    assign ml_tx_am = '0;
    assign ml_rx_am = '0;
end
    end
    else begin
    assign ml_tx_am = '0;
    assign ml_rx_am = '0;
    assign dsk_rx_inframe = '0;
    assign dsk_rx_data = '0;
    assign dsk_rx_valid = '0;
    assign dsk_rx_empty = '0;
    assign dsk_rx_error = '0;
    assign dsk_rx_fcs_error = '0;
    assign dsk_rx_status = '0;
    end // MACPCSDIR, (!ENABLE_PCS66)&&(!ENABLE_PCSDIRECT)




       if (ENABLE_PCS66)
	   begin : PCS66

	   wire [3:0][(1+1+66)-1:0]          rx_pcs66_deskew_din;
	   wire [3:0][(1+1+66)-1:0]          rx_pcs66_deskew_dout;
//	   wire 			     rx_pcs66_deskew_done;

           assign rx_deskew_done_qual = rx_pcs66_deskew_done;

	   assign rx_pcs66_deskew_din[0] = {
				      int_rx_pcs66_valid,
				      int_rx_pcs66_am_valid,
				      int_rx_pcs66_d[0][66-1:0]
				      };
	   assign rx_pcs66_deskew_din[1] = {
				      int_rx_pcs66_valid,
				      int_rx_pcs66_am_valid,
				      int_rx_pcs66_d[1][66-1:0]
				      };
	   assign rx_pcs66_deskew_din[2] = {
				      int_rx_pcs66_valid,
				      int_rx_pcs66_am_valid,
				      int_rx_pcs66_d[2][66-1:0]
				      };
	   assign rx_pcs66_deskew_din[3] = {
				      int_rx_pcs66_valid,
				      int_rx_pcs66_am_valid,
				      int_rx_pcs66_d[3][66-1:0]
				      };

	      alt_ehipc3_fm_rx_deskew #(
				  .LANES         (num_lanes),
				  .WIDTH         (1+1+66),    // Per lane width
				  .SIM_EMULATE   (0)
				  ) rx_pcs66_dsk_inst (
						 .i_clk          (int_rx_clk),
						 .i_reset        (~ehip_rx_rst_n_ack_sync),
						 .i_data         (rx_pcs66_deskew_din),
						 .i_sync_pulse   (rx_aib_dsk),
						 .o_data         (rx_pcs66_deskew_dout),
						 .o_deskew_done  (rx_pcs66_deskew_done)
						 );

	   assign  {
		    dsk_rx_pcs66_valid[0],
		    dsk_rx_pcs66_am_valid[0],
		    dsk_rx_pcs66_data[0]} = rx_pcs66_deskew_dout[0];
	   assign  {
		    dsk_rx_pcs66_valid[1],
		    dsk_rx_pcs66_am_valid[1],
		    dsk_rx_pcs66_data[1]} = rx_pcs66_deskew_dout[1];
	   assign  {
		    dsk_rx_pcs66_valid[2],
		    dsk_rx_pcs66_am_valid[2],
		    dsk_rx_pcs66_data[2]} = rx_pcs66_deskew_dout[2];
	   assign  {
		    dsk_rx_pcs66_valid[3],
		    dsk_rx_pcs66_am_valid[3],
		    dsk_rx_pcs66_data[3]} = rx_pcs66_deskew_dout[3];
    end //PCS66
    else begin
        assign dsk_rx_pcs66_valid = '0;
        assign dsk_rx_pcs66_am_valid = '0;
        assign dsk_rx_pcs66_data = '0;
    end


       if (ENABLE_PCSDIRECT)
	   begin : PCSDIRECT

	   wire [3:0][(1+1+8+64)-1:0]        rx_pcs64_deskew_din;
	   wire [3:0][(1+1+8+64)-1:0]        rx_pcs64_deskew_dout;
//	   wire 			     rx_pcs64_deskew_done;

           assign rx_deskew_done_qual = rx_pcs64_deskew_done;

	   assign rx_pcs64_deskew_din[0] = {
				      int_rx_mii_valid,
				      int_rx_mii_am_valid,
				      int_rx_mii_c[0],
				      int_rx_mii_d[0]
				      };
	   assign rx_pcs64_deskew_din[1] = {
				      int_rx_mii_valid,
				      int_rx_mii_am_valid,
				      int_rx_mii_c[1],
				      int_rx_mii_d[1]
				      };
	   assign rx_pcs64_deskew_din[2] = {
				      int_rx_mii_valid,
				      int_rx_mii_am_valid,
				      int_rx_mii_c[2],
				      int_rx_mii_d[2]
				      };
	   assign rx_pcs64_deskew_din[3] = {
				      int_rx_mii_valid,
				      int_rx_mii_am_valid,
				      int_rx_mii_c[3],
				      int_rx_mii_d[3]
				      };

	      alt_ehipc3_fm_rx_deskew #(
				  .LANES         (num_lanes),
				  .WIDTH         (1+1+8+64),    // Per lane width
				  .SIM_EMULATE   (0)
				  ) rx_pcs64_dsk_inst (
						 .i_clk          (int_rx_clk),
						 .i_reset        (~ehip_rx_rst_n_ack_sync),
						 .i_data         (rx_pcs64_deskew_din),
						 .i_sync_pulse   (rx_aib_dsk),
						 .o_data         (rx_pcs64_deskew_dout),
						 .o_deskew_done  (rx_pcs64_deskew_done)
						 );

	   assign  {
		    dsk_rx_pcs64_valid[0],
		    dsk_rx_pcs64_am_valid[0],
                    dsk_rx_pcs64_c[7:0],
		    dsk_rx_pcs64_d[63:0]} = rx_pcs64_deskew_dout[0];
	   assign  {
		    dsk_rx_pcs64_valid[1],
		    dsk_rx_pcs64_am_valid[1],
                    dsk_rx_pcs64_c[15:8],
		    dsk_rx_pcs64_d[127:64]} = rx_pcs64_deskew_dout[1];
	   assign  {
		    dsk_rx_pcs64_valid[2],
		    dsk_rx_pcs64_am_valid[2],
                    dsk_rx_pcs64_c[23:16],
		    dsk_rx_pcs64_d[191:128]} = rx_pcs64_deskew_dout[2];
	   assign  {
		    dsk_rx_pcs64_valid[3],
		    dsk_rx_pcs64_am_valid[3],
                    dsk_rx_pcs64_c[31:24],
		    dsk_rx_pcs64_d[255:192]} = rx_pcs64_deskew_dout[3];
    end // PCSDIRECT
    else begin : DEFAULT_ELSE
        assign dsk_rx_pcs64_valid = '0;
        assign dsk_rx_pcs64_am_valid = '0;
        assign dsk_rx_pcs64_c = '0;
        assign dsk_rx_pcs64_d = '0;
    end

end // DESKEW
else begin
    assign ml_tx_am = '0;
    assign ml_rx_am = '0;
    assign dsk_rx_inframe = '0;
    assign dsk_rx_data = '0;
    assign dsk_rx_valid = '0;
    assign dsk_rx_empty = '0;
    assign dsk_rx_error = '0;
    assign dsk_rx_fcs_error = '0;
    assign dsk_rx_status = '0;
    assign dsk_rx_pcs66_data = '0;
    assign dsk_rx_pcs66_valid = '0;
    assign dsk_rx_pcs66_am_valid = '0;
    assign dsk_rx_pcs64_valid = '0;
    assign dsk_rx_pcs64_am_valid = '0;
    assign dsk_rx_pcs64_c = '0;
    assign dsk_rx_pcs64_d = '0;
end
  endgenerate

always_ff @(posedge i_reconfig_clk) begin
    undersized_frame_csr_rst <= reconfig_reset_sync || ehip_rst_sync;
end

alt_ehipc3_fm_altera_std_synchronizer_nocut rx_adapt_clr_sync_inst (
    .clk        (int_rx_clk),
    .reset_n    (1'b1),
    .din        (rx_adapt_clear_dropped_count),
    .dout       (rx_adapt_clear_dropped_count_sync)
);

alt_ehipc3_fm_altera_std_synchronizer_nocut stats_snapshot_sync_inst (
    .clk        (i_reconfig_clk),
    .reset_n    (1'b1),
    .din        (i_stats_snapshot),
    .dout       (stats_snapshot_sync)
);



alt_ehipc3_fm_data_sync #(
    .WIDTH      (64)
) rx_adapt_dropped_frame_count_sync_inst (
    .aclr       (undersized_frame_csr_rst),   // async reset
    .clk_in     (int_rx_clk),
    .data_in    (rx_adapt_dropped_frames),
    .clk_out    (i_reconfig_clk),
    .data_out   (rx_adapt_dropped_frames_sync)
);

always_ff @(posedge i_reconfig_clk) begin
    if (stats_snapshot_sync || stats_snapshot_freeze) begin   //hsd:2205696595 Adding stats_snapshot_freeze_reg
        rx_adapt_dropped_frames_shadow  <= rx_adapt_dropped_frames_shadow;
    end else begin
        rx_adapt_dropped_frames_shadow  <= rx_adapt_dropped_frames_sync;
    end
end

   // Generate for RX adapter
   generate
if  ((core_variant==2 || (core_variant==3 && active_channel==1)) && (ehip_mode == "ehip_mac_no_fec" || ehip_mode == "ehip_mac" || ehip_mode == "ehip_mac_ptp_no_fec" || ehip_mode == "ehip_mac_ptp")) begin : RX_ADAPTER_100G

  if (ENABLE_PTP_TOG) begin : PTP_CASE
    `ifdef ALTERA_RESERVED_QIS
     wire  test =  1'b0;
                assign rx_adapt_dropped_frames = '0;
    // RX adapter not part of HW design example
    `else
     if (RX_ASYNC_ADAPTER_MODE) begin : RX_ASYNC_ADAPTER_PTP
            alt_ehipc3_fm_100g_adapter_rx_async adater_rx_inst
            (
                .i_arst             (~o_rx_pcs_ready),

                .i_clk_r            (i_clk_rx),
                .o_data             (o_rx_data),
                .o_valid            (o_rx_valid),
                .o_sop              (o_rx_startofpacket),
                .o_eop              (o_rx_endofpacket),
                .o_empty            (o_rx_empty),
                .o_status           (o_rxstatus_data),
                .o_status_valid     (o_rxstatus_valid),
                .o_error            (o_rx_error),

                .i_clear_counters   (rx_adapt_clear_dropped_count_sync),
                .o_dropped_frames   (rx_adapt_dropped_frames),
                .i_clk_w            (int_rx_clk),
                .i_inframe          (dsk_rx_inframe_0),
                .i_data             (dsk_rx_data_0),
                .i_valid            ({4{dsk_rx_valid_0}}),
                .i_empty            (dsk_rx_empty_0),
                .i_error            ({dsk_rx_error_0[3*2-1:2*2],dsk_rx_error_0[3*2-1:2*2],dsk_rx_error_0[2-1:0],dsk_rx_error_0[2-1:0]}),
                .i_fcs_error        ({dsk_rx_fcs_error_0[2],dsk_rx_fcs_error_0[2],dsk_rx_fcs_error_0[0],dsk_rx_fcs_error_0[0]}),
                .i_status           ({dsk_rx_status_0[3*3-1:2*3],dsk_rx_status_0[3*3-1:2*3],dsk_rx_status_0[3-1:0],dsk_rx_status_0[3-1:0]})
            );
      end // block: RX_ASYNC_ADAPTER_PTP
      else begin : RX_ADAPTER_PTP
            alt_ehipc3_fm_100g_adapter_rx adater_rx_inst (
                .i_reset(rx_pcs_ready_as_reset),
                .i_clk(o_clk_pll_div64),
                .i_clear_counters   (rx_adapt_clear_dropped_count_sync),
                .o_dropped_frames   (rx_adapt_dropped_frames),

                // User Ports
                .o_data(o_rx_data),
                .o_valid(o_rx_valid),
                .o_sop(o_rx_startofpacket),
                .o_eop(o_rx_endofpacket),
                .o_empty(o_rx_empty),
                .o_status(o_rxstatus_data),
                .o_status_valid(o_rxstatus_valid),
                .o_error(o_rx_error),

                // EHIP Interface
                .i_inframe(dsk_rx_inframe_0),
                .i_data(dsk_rx_data_0),
                .i_valid({4{dsk_rx_valid_0}}),
                .i_empty(dsk_rx_empty_0),
                // On EHIP interface rx_error, rx_fcs_error and rx_status is for all lanes but are shared in the mapping
                // thats why connecting only lane[0] to Adapter
                .i_error({dsk_rx_error_0[3*2-1:2*2],dsk_rx_error_0[3*2-1:2*2],dsk_rx_error_0[2-1:0],dsk_rx_error_0[2-1:0]}),
                .i_fcs_error({dsk_rx_fcs_error_0[2],dsk_rx_fcs_error_0[2],dsk_rx_fcs_error_0[0],dsk_rx_fcs_error_0[0]}),
                .i_status({dsk_rx_status_0[3*3-1:2*3],dsk_rx_status_0[3*3-1:2*3],dsk_rx_status_0[3-1:0],dsk_rx_status_0[3-1:0]})
            );

    end // block: RX_ADAPTER_PTP
`endif
  end // PTP_CASE

  else if (ENABLE_PTP) begin : PTP_PR_CASE
     if (RX_ASYNC_ADAPTER_MODE) begin : RX_ASYNC_ADAPTER_PTP_PR
            alt_ehipc3_fm_100g_adapter_rx_async adater_rx_inst (
                .i_arst         (~o_rx_pcs_ready),

                .i_clk_r        (i_clk_rx),
                .o_data         (o_rx_data),
                .o_valid        (o_rx_valid),
                .o_sop          (o_rx_startofpacket),
                .o_eop          (o_rx_endofpacket),
                .o_empty        (o_rx_empty),
                .o_status       (o_rxstatus_data),
                .o_status_valid (o_rxstatus_valid),
                .o_error        (o_rx_error),

                .i_clear_counters(rx_adapt_clear_dropped_count_sync),
                .o_dropped_frames(rx_adapt_dropped_frames),
                .i_clk_w        (int_rx_clk),
                .i_inframe      (ml_rx_inframe),
                .i_data         (ml_rx_data),
                .i_valid        ({4{ml_rx_valid}}),
                .i_empty        (ml_rx_empty),
                .i_error        ({ml_rx_error[3*2-1:2*2],ml_rx_error[3*2-1:2*2],ml_rx_error[2-1:0],ml_rx_error[2-1:0]}),
                .i_fcs_error    ({ml_rx_fcs_error[2],ml_rx_fcs_error[2],ml_rx_fcs_error[0],ml_rx_fcs_error[0]}),
                .i_status       ({ml_rx_status[3*3-1:2*3],ml_rx_status[3*3-1:2*3],ml_rx_status[3-1:0],ml_rx_status[3-1:0]})
            );
      end // block: RX_ASYNC_ADAPTER_PTP_PR
      else begin : RX_ADAPTER_PTP_PR
            alt_ehipc3_fm_100g_adapter_rx adater_rx_inst (
                .i_reset(rx_pcs_ready_as_reset),
                .i_clk(int_rx_clk),

                .i_clear_counters(rx_adapt_clear_dropped_count_sync),
                .o_dropped_frames(rx_adapt_dropped_frames),

                // User Ports
                .o_data(o_rx_data),
                .o_valid(o_rx_valid),
                .o_sop(o_rx_startofpacket),
                .o_eop(o_rx_endofpacket),
                .o_empty(o_rx_empty),
                .o_status(o_rxstatus_data),
                .o_status_valid(o_rxstatus_valid),
                .o_error(o_rx_error),

                // EHIP Interface
                .i_inframe(ml_rx_inframe),
                .i_data(ml_rx_data),
                .i_valid({4{ml_rx_valid}}),
                .i_empty(ml_rx_empty),
                // On EHIP interface rx_error, rx_fcs_error and rx_status is for all lanes but are shared in the mapping
                // thats why connecting only lane[0] to Adapter
                .i_error({ml_rx_error[3*2-1:2*2],ml_rx_error[3*2-1:2*2],ml_rx_error[2-1:0],ml_rx_error[2-1:0]}),
                .i_fcs_error({ml_rx_fcs_error[2],ml_rx_fcs_error[2],ml_rx_fcs_error[0],ml_rx_fcs_error[0]}),
                .i_status({ml_rx_status[3*3-1:2*3],ml_rx_status[3*3-1:2*3],ml_rx_status[3-1:0],ml_rx_status[3-1:0]})
            );

            always @(posedge int_rx_clk) begin
                if(rx_pcs_ready_as_reset) begin
                    ml_rx_inframe_r <= 1'b0;
                end
                else begin
                    if(ml_rx_valid) begin
                        ml_rx_inframe_r <= ml_rx_inframe[0];
                    end
                end
            end

// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
// ml_ptp_rx_its_valid should take care of all the condition to write the RX_TS_FF. There is no need to recreate the SOP logic here.
// Inclusion of ml_rx_valid is just to be conservative.
// ---------------------------------------------------------------------------------------------------------------------------------
//            assign rx_ts_ff_write = |(~{ml_rx_inframe_r,ml_rx_inframe[3:1]} & ml_rx_inframe) && ml_rx_valid;
            assign rx_ts_ff_write = ml_ptp_rx_its_valid && ml_rx_valid;
// ---------------------------------------------------------------------------------------------------------------------------------
            assign rx_ts_ff_read = o_rx_startofpacket && o_rx_valid;

            always_ff @(posedge int_rx_clk) begin
                if (rx_pcs_ready_as_reset) begin
                    ptp_rx_ff_waddr <= 4'h0;
                    ptp_rx_ff_raddr <= 4'h0;
                end else begin
                    if (rx_ts_ff_write) begin
                        ptp_rx_ff_waddr <= ptp_rx_ff_waddr + 1'b1;
                    end
                    else begin
                        ptp_rx_ff_waddr <= ptp_rx_ff_waddr;
                    end

                    if (rx_ts_ff_read) begin
                        ptp_rx_ff_raddr <= ptp_rx_ff_raddr + 1'b1;
                    end
                    else begin
                        ptp_rx_ff_raddr <= ptp_rx_ff_raddr;
                    end
                end
            end

            alt_ehipc3_fm_mlab #(
                .WIDTH      (96),
                .ADDR_WIDTH (4),
                .SIM_EMULATE(0)
            ) ptp_rx_ff (
                .wclk       (int_rx_clk),
                .wdata_reg  (ml_ptp_rx_its),
                .wena       (rx_ts_ff_write),
                .waddr_reg  (ptp_rx_ff_waddr),
                .raddr      (ptp_rx_ff_raddr),
                .rdata      (o_ptp_rx_its)
            );

    end // block: RX_ADAPTER_PTP_PR

  end // PTP_PR_CASE

  else begin : NON_PTP_CASE
	    if (RX_ASYNC_ADAPTER_MODE) begin : RX_ASYNC_ADAPTER
            alt_ehipc3_fm_100g_adapter_rx_async adater_rx_inst
            (
                .i_arst             (~o_rx_pcs_ready),

                .i_clk_r            (i_clk_rx),
                .o_data             (o_rx_data),
                .o_valid            (o_rx_valid),
                .o_sop              (o_rx_startofpacket),
                .o_eop              (o_rx_endofpacket),
                .o_empty            (o_rx_empty),
                .o_status           (o_rxstatus_data),
                .o_status_valid     (o_rxstatus_valid),
                .o_error            (o_rx_error),

                .i_clear_counters   (rx_adapt_clear_dropped_count_sync),
                .o_dropped_frames   (rx_adapt_dropped_frames),
                .i_clk_w            (int_rx_clk),
                .i_inframe          (dsk_rx_inframe_0),
                .i_data             (dsk_rx_data_0),
	            .i_valid            ({4{dsk_rx_valid_0}}),
                .i_empty            (dsk_rx_empty_0),
                .i_error            ({dsk_rx_error_0[3*2-1:2*2],dsk_rx_error_0[3*2-1:2*2],dsk_rx_error_0[2-1:0],dsk_rx_error_0[2-1:0]}),
                .i_fcs_error        ({dsk_rx_fcs_error_0[2],dsk_rx_fcs_error_0[2],dsk_rx_fcs_error_0[0],dsk_rx_fcs_error_0[0]}),
                .i_status           ({dsk_rx_status_0[3*3-1:2*3],dsk_rx_status_0[3*3-1:2*3],dsk_rx_status_0[3-1:0],dsk_rx_status_0[3-1:0]})
            );
      end // block: RX_ASYNC_ADAPTER
      else begin : RX_ADAPTER
            alt_ehipc3_fm_100g_adapter_rx adater_rx_inst (
                .i_reset(rx_pcs_ready_as_reset),
                .i_clk(i_clk_rx),
                .i_clear_counters   (rx_adapt_clear_dropped_count_sync),
                .o_dropped_frames   (rx_adapt_dropped_frames),

                // User Ports
                .o_data(o_rx_data),
                .o_valid(o_rx_valid),
                .o_sop(o_rx_startofpacket),
                .o_eop(o_rx_endofpacket),
                .o_empty(o_rx_empty),
                .o_status(o_rxstatus_data),
                .o_status_valid(o_rxstatus_valid),
                .o_error(o_rx_error),

                // EHIP Interface
                .i_inframe(dsk_rx_inframe_0),
                .i_data(dsk_rx_data_0),
                .i_valid({4{dsk_rx_valid_0}}),
                .i_empty(dsk_rx_empty_0),
                // On EHIP interface rx_error, rx_fcs_error and rx_status is for all lanes but are shared in the mapping
                // thats why connecting only lane[0] to Adapter
                .i_error({dsk_rx_error_0[3*2-1:2*2],dsk_rx_error_0[3*2-1:2*2],dsk_rx_error_0[2-1:0],dsk_rx_error_0[2-1:0]}),
                .i_fcs_error({dsk_rx_fcs_error_0[2],dsk_rx_fcs_error_0[2],dsk_rx_fcs_error_0[0],dsk_rx_fcs_error_0[0]}),
                .i_status({dsk_rx_status_0[3*3-1:2*3],dsk_rx_status_0[3*3-1:2*3],dsk_rx_status_0[3-1:0],dsk_rx_status_0[3-1:0]})
            );

	end // block: RX_ADAPTER
end // NON_PTP_CASE
end //RX_ADAPTER_100G
else begin
    assign rx_adapt_dropped_frames = '0;
end
   endgenerate

    // 100G soft logic for PTP
    generate
    if (((core_variant == 3) && (active_channel == 1)) &&
        (ENABLE_PTP != 0)) begin : ML_SOFT

        alt_ehipc3_fm_ml_soft #(
            .core_variant               (core_variant),
            .active_channel             (active_channel),
            .ENABLE_PTP                 (ENABLE_PTP),
            .ENABLE_PTP_REF_LANE        (ENABLE_PTP_REF_LANE),
            .LANES                      (4)
        ) ml_soft (
            // Configuration
            .i_enable_rsfec             (ml_rsfec_mode),
            .i_tx_preamble_pass         (ml_tx_preamble_pass),
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
            .i_rx_preamble_pass         (ml_rx_preamble_pass),
// ---------------------------------------------------------------------------------------------------------------------------------
            .i_cfg_enforce_max_rx       (ml_enforce_max_rx),
            .i_cfg_remove_rx_pad        (ml_remove_rx_pad),

            // Clock
            .i_reconfig_clk             (i_reconfig_clk),
            .i_ml_clk_tx                (int_tx_clk),
            .i_ml_clk_rx                (int_rx_clk),

            // Reset
            .i_reconfig_reset           (i_reconfig_reset),
            .i_ml_ehip_tx_reset         (~tx_lanes_stable_sync),
            .i_ml_ehip_rx_reset         (rx_pcs_ready_as_reset),

            // Status Input
            .i_ml_tx_pma_ready          (tx_pma_ready),
            .i_ml_rx_pma_ready          (rx_pma_ready),
            .i_ml_rx_transfer_ready     (rx_transfer_ready[num_lanes-1:0]),
            .i_ml_tx_transfer_ready     (tx_transfer_ready[num_lanes-1:0]),
            .i_ml_tx_lanes_stable       (tx_lanes_stable),
            .i_ml_rx_pcs_fully_aligned  (ehip_rx_pcs_fully_aligned_out),
            .i_ml_ehip_ready            (ehip_ready),

            // TX Adapter
            .i_ml_tx_early_valid        (int_tx_early_valid),
            .i_ml_tx_valid              (int_tx_valid_ptp),
            .i_ml_tx_data               (ml_tx_data),
            .i_ml_tx_inframe            (ml_tx_inframe),
            .i_ml_tx_empty              (ml_tx_empty),
            .i_ml_tx_error              (ml_tx_error),
            .i_ml_tx_skip_crc           (ml_tx_skip_crc),

            .o_ml_tx_valid              (int_tx_valid),
            .o_ml_tx_data               (int_tx_data),
            .o_ml_tx_inframe            (int_tx_inframe),
            .o_ml_tx_empty              (int_tx_empty),
            .o_ml_tx_error              (int_tx_error),
            .o_ml_tx_skip_crc           (int_tx_skip_crc),

            // RX Adapter
            .i_ml_rx_valid              (dsk_rx_valid_0),
            .i_ml_rx_data               (dsk_rx_data_0),
            .i_ml_rx_inframe            (dsk_rx_inframe_0),
            .i_ml_rx_empty              (dsk_rx_empty_0),
            .i_ml_rx_error              (dsk_rx_error_0),
            .i_ml_rx_fcs_error          (dsk_rx_fcs_error_0),
            .i_ml_rx_status             (dsk_rx_status_0),

            .o_ml_rx_valid              (ml_rx_valid),
            .o_ml_rx_data               (ml_rx_data),
            .o_ml_rx_inframe            (ml_rx_inframe),
            .o_ml_rx_empty              (ml_rx_empty),
            .o_ml_rx_error              (ml_rx_error),
            .o_ml_rx_fcs_error          (ml_rx_fcs_error),
            .o_ml_rx_status             (ml_rx_status),

            // PTP
            // User Interface: TOD Interface
            .i_ptp_tod                  (i_ptp_tod),

            // User Interface: PTP Status
            .o_ml_tx_ptp_offset_data_valid (),
            .o_ml_rx_ptp_offset_data_valid (),
            .o_ml_tx_ptp_ready          (o_tx_ptp_ready),
            .o_ml_rx_ptp_ready          (o_rx_ptp_ready),

            // User Interface: TX 1-step Command
            .i_ml_ptp_ins_ets           (ml_ptp_ins_ets),
            .i_ml_ptp_ins_cf            (ml_ptp_ins_cf),
            .i_ml_ptp_ins_zero_csum     (ml_ptp_ins_zero_csum),
            .i_ml_ptp_ins_update_eb     (ml_ptp_ins_update_eb),
            .i_ml_ptp_ts_format         (ml_ptp_ts_format),
            .i_ml_ptp_ts_offset         (ml_ptp_ts_offset),
            .i_ml_ptp_cf_offset         (ml_ptp_cf_offset),
            .i_ml_ptp_csum_offset       (ml_ptp_csum_offset),
            .i_ml_ptp_eb_offset         (ml_ptp_eb_offset),
            .i_ml_ptp_tx_its            (ml_ptp_tx_its),

            // User Interface: TX 2-step Timestamp Request
            .i_ml_ptp_ts_req            (ml_ptp_ts_req),
            .i_ml_ptp_fp                (ml_ptp_fp),

            // User Interface: TX 2-step Timestamp Return
            .o_ml_ptp_ets_valid         (o_ptp_ets_valid),
            .o_ml_ptp_ets               (o_ptp_ets),
            .o_ml_ptp_ets_fp            (o_ptp_ets_fp),

            // User Interface: RX Timestamp
            .o_ml_ptp_rx_its            (ml_ptp_rx_its),
            .o_ml_ptp_rx_its_valid      (ml_ptp_rx_its_valid),

            // EHIP Interface: TX 1-step and 2-step Command
            .o_ml_ptp_tx_fp             (ml_ptp_tx_fp),
            .o_ml_ptp_ins_type          (ml_ptp_ins_type),
            .o_ml_ptp_byte_offset       (ml_ptp_byte_offset),
            .o_ml_ptp_ts                (ml_ptp_ts),

            // EHIP Interface: TX 2-step Timestamp
            .i_ml_ptp_tx_ts_valid       (o_ptp_tx_ts_valid[0]),
            .i_ml_ptp_tx_ts             (o_ptp_tx_ts),
            .i_ml_ptp_tx_ts_fp          (o_ptp_tx_fp),

            // EHIP Interface: RX Timestamp
            .i_ml_ptp_rx_ts             (o_ptp_rx_ts),

            // EHIP Interface: Reference Timestamp
            .o_ml_sclk                  (ml_sclk),
            .o_ml_tx_sel_sclk_return    (ml_tx_sel_sclk_return),
            .o_ml_rx_sel_sclk_return    (ml_rx_sel_sclk_return),
            .i_ml_tx_sclk_return        (ml_tx_sclk_return),
            .i_ml_rx_sclk_return        (ml_rx_sclk_return),
            .i_ml_tx_am                 (ml_tx_am),
            .i_ml_rx_am                 (ml_rx_am),

            // EHIP Interface: VL Offset Read
            .o_read_ptp_vl_data         (ml_read_ptp_vl_data),
            .o_select_ptp_vl_data       (ml_select_ptp_vl_data),
            .i_reading_ptp_vl_data      (o_ptp_reading_vl_data),

            // AVMM Interface: PTP
            .o_ml_avmm_readdata         (soft_ptp_read_data),
            .i_ml_avmm_write            (soft_ptp_write),
            .i_ml_avmm_read             (soft_ptp_read),
            .i_ml_avmm_writedata        (a_eth_reconfig_writedata),
            .o_ml_avmm_waitrequest      (soft_ptp_wait),
            .o_ml_avmm_readdatavalid    (soft_ptp_read_valid),
            .i_ml_avmm_address          (a_eth_reconfig_addr[7:0])
        );

        always @(posedge i_reconfig_clk) begin
            if(reconfig_reset_sync) begin
                ml_rsfec_mode       <= ((ehip_mode == "ehip_mac") || (ehip_mode == "ehip_mac_ptp")) ? 1'b1 : 1'b0;
                ml_tx_preamble_pass <= (tx_preamble_passthrough == "enable") ? 1'b1 : 1'b0;
// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
                ml_rx_preamble_pass <= (rx_preamble_passthrough == "enable") ? 1'b1 : 1'b0;
// ---------------------------------------------------------------------------------------------------------------------------------
                ml_enforce_max_rx   <= (enforce_max_frame_size == "enable") ? 1'b1 : 1'b0;
                ml_remove_rx_pad    <= (remove_pads == "enable") ? 1'b1 : 1'b0;
            end
            else begin
                if((a_eth_reconfig_addr[15:0] == 16'h30E) && i_eth_reconfig_write_jtag_arb) begin
                    ml_rsfec_mode       <= (i_eth_reconfig_writedata_jtag_arb[9] == 1'd0) ? 1'b1 : 1'b0;
                end

                if((a_eth_reconfig_addr[15:0] == 16'h40B) && i_eth_reconfig_write_jtag_arb) begin
                    ml_tx_preamble_pass <= (i_eth_reconfig_writedata_jtag_arb[0] == 1'b1) ? 1'b1 : 1'b0;
                end

// ---------------------------------------------------------------------------------------------------------------------------------
// 30/Oct/2018 : slim35 : 606730 : smaller current rx timestamp than previous packet - FEC mode (PP=1)
// ---------------------------------------------------------------------------------------------------------------------------------
                if((a_eth_reconfig_addr[15:0] == 16'h50B) && i_eth_reconfig_write_jtag_arb) begin
                    ml_rx_preamble_pass <= (i_eth_reconfig_writedata_jtag_arb[0] == 1'b1) ? 1'b1 : 1'b0;
                end
// ---------------------------------------------------------------------------------------------------------------------------------

                if((a_eth_reconfig_addr[15:0] == 16'h50A) && i_eth_reconfig_write_jtag_arb) begin
                    ml_enforce_max_rx   <= (i_eth_reconfig_writedata_jtag_arb[7] == 1'b1) ? 1'b1 : 1'b0;
                    ml_remove_rx_pad    <= (i_eth_reconfig_writedata_jtag_arb[8] == 1'b1) ? 1'b1 : 1'b0;
                end
            end
        end
    end
    else begin
        assign ml_ptp_tx_fp             = i_ptp_tx_fp[0];
        assign ml_ptp_ins_type          = i_ptp_ins_type_hard;
        assign ml_ptp_byte_offset       = i_ptp_byte_offset_hard;
        assign ml_ptp_ts                = i_ptp_ts;
        assign ml_read_ptp_vl_data      = i_read_ptp_vl_data;
        assign ml_select_ptp_vl_data    = i_select_ptp_vl_data;

        assign ml_sclk                  = i_sclk;
        assign ml_tx_sel_sclk_return    = i_tx_sel_sclk_return;
        assign ml_rx_sel_sclk_return    = i_rx_sel_sclk_return;
        assign o_tx_sclk_return         = ml_tx_sclk_return;
        assign o_rx_sclk_return         = ml_rx_sclk_return;
        assign o_tx_am                  = ml_tx_am;
        assign o_rx_am                  = ml_rx_am;

        assign soft_ptp_read_data       = 32'h0;
        assign soft_ptp_wait            = 1'b0;
        always_ff @(posedge i_reconfig_clk) soft_ptp_read_valid <= soft_ptp_read;
    end
    endgenerate

    // RSFEC reset for single lane
    assign sl_rsfec_reset    = enable_rsfec_rst_ports ? !i_rsfec_rst_n    : &sl_soft_rsfec_reset;
    assign sl_rsfec_tx_reset = enable_rsfec_rst_ports ? !i_rsfec_tx_rst_n : &sl_soft_rsfec_tx_reset;
    assign sl_rsfec_rx_reset = enable_rsfec_rst_ports ? !i_rsfec_rx_rst_n : &sl_soft_rsfec_rx_reset;

    // Soft logic for single lane
    genvar sl_soft_i;
    generate
        if ((( core_variant == 0) ||
             ( core_variant == 1) ||
             ((core_variant == 3) && (active_channel == 0)) ||
             ( core_variant == 4) || (core_variant == 5) || (core_variant == 7))) begin : SL_SOFT
            for(sl_soft_i = 0; sl_soft_i < sl_num_lanes; sl_soft_i++) begin : SL_SOFT_I

            // wire i_sl_avmm_address_1ns;
            // wire i_sl_avmm_read_1ns;
            wire [sl_num_lanes-1:0][6:0]     i_sl_avmm_address_1ns;
            wire [sl_num_lanes-1:0]           i_sl_avmm_read_1ns;

            if (ENHANCED_PTP_ACCURACY == 1) begin : ONENS_SUPPORT_AVMM_READ_ADDRESS
                assign i_sl_avmm_address_1ns[sl_soft_i] = i_sl_eth_reconfig_addr_2d[sl_soft_i][6:0]; // only address 0xB10 and 0xB11 are targeted to soft PTP. soft PTP offset start from 0. use only LSB 4 bit.
                assign i_sl_avmm_read_1ns[sl_soft_i] = is_soft_ptp[sl_soft_i]? sl_avmm_read[sl_soft_i] : 1'b0;
            end else begin
                assign i_sl_avmm_address_1ns[sl_soft_i] = {3'b000, i_sl_eth_reconfig_addr_2d[sl_soft_i][3:0]}; // only address 0xB10 and 0xB11 are targeted to soft PTP. soft PTP offset start from 0. use only LSB 4 bit.
                assign i_sl_avmm_read_1ns[sl_soft_i] = sl_avmm_read[sl_soft_i];
            end

                alt_ehipc3_fm_sl_soft #(
                    .ehip_mode_sl               (ehip_mode_sl_0), // TODO
                    .ehip_rate_sl               ((ENABLE_RSFEC) ? "rate_25gx1_fec" : ehip_rate_sl_0), // TODO
                    .core_variant               (core_variant),
                    .active_channel             (active_channel),
                    .ENABLE_PTP                 (ENABLE_PTP),
                    .ENABLE_PTP_RX_DESKEW       (ENABLE_PTP_RX_DESKEW),
                    .sim_mode                   (lcl_sim_mode),
                    .SIM_EMULATE                (SIM_EMULATE),
                    .ENABLE_ASYNC_ADAPTERS_SL   (ENABLE_ASYNC_ADAPTERS_SL),
                    .ENABLE_EXTERNAL_AIB_CLOCKING(enable_external_aib_clocking),
                    .ENHANCED_PTP_ACCURACY      (ENHANCED_PTP_ACCURACY),
		    .ENHANCED_PTP_DBG           (ENHANCED_PTP_DBG),
                    .READY_LATENCY              (ready_latency_sl)
                ) sl_soft (
                    // Configuration
                    .i_enable_rsfec             (sl_rsfec_mode[sl_soft_i]),
                    .i_tx_preamble_pass         (sl_tx_preamble_pass[sl_soft_i]),
                    .i_tx_am_pulse              (1'b1),						// tied off the i_tx_am_pulse to fix cdc error as the i_tx_am_pulse will always be 1

                    // Clock
                    .i_reconfig_clk             (i_reconfig_clk),
                    .i_sl_clk_tx                (i_sl_clk_tx[sl_soft_i]),
                    .i_sl_clk_rx                (i_sl_clk_rx[sl_soft_i]),
                    .i_sl_async_clk_tx          (i_sl_async_clk_tx[sl_soft_i]),
                    .i_sl_async_clk_rx          (i_sl_async_clk_rx[sl_soft_i]),
                    .i_sl_clk_tx_tod            (i_sl_clk_tx_tod[sl_soft_i]),
                    .i_sl_clk_rx_tod            (i_sl_clk_rx_tod[sl_soft_i]),
                    // Reset
                    .i_reconfig_reset           (reconfig_reset_sync),
                    .i_sl_csr_rst_n             (i_sl_csr_rst_n[sl_soft_i]),
                    .i_sl_tx_rst_n              (i_sl_tx_rst_n[sl_soft_i]),
                    .i_sl_rx_rst_n              (i_sl_rx_rst_n[sl_soft_i]),

                    .i_sl_soft_csr_rst          (sl_soft_csr_rst[sl_soft_i]),
                    .i_sl_soft_tx_rst           (sl_soft_tx_rst[sl_soft_i]),
                    .i_sl_soft_rx_rst           (sl_soft_rx_rst[sl_soft_i]),

                    // Reset Controller
                    .o_sl_tx_aib_reset          (sl_tx_aib_reset[sl_soft_i]),
                    .o_sl_rx_aib_reset          (sl_rx_aib_reset[sl_soft_i]),
                    .o_sl_tx_pcs_reset          (sl_tx_pcs_reset[sl_soft_i]),
                    .o_sl_rx_pcs_reset          (sl_rx_pcs_reset[sl_soft_i]),
                    .i_sl_tx_pma_ready          (o_sl_tx_pma_ready[sl_soft_i]),
                    .i_sl_rx_pma_ready          (o_sl_rx_pma_ready[sl_soft_i]),
                    .i_sl_tx_dll_lock           (sl_tx_dll_lock[sl_soft_i]),
                    .i_sl_rx_is_lockedtodata    (sl_rx_is_lockedtodata[sl_soft_i]),
                    .i_sl_rx_transfer_ready     (sl_rx_transfer_ready[sl_soft_i]),
                    .i_sl_tx_transfer_ready     (sl_tx_transfer_ready[sl_soft_i]),
                    .i_sl_rx_pcs_fully_aligned  (sl_rx_pcs_fully_aligned[sl_soft_i]),

		    .i_sl_pause_ehip_ready      (sl_pause_ehip_ready[sl_soft_i]),
                    .i_sl_ehip_ready            (sl_ehip_ready[sl_soft_i]),
                    .i_sl_ehip_reset_stat       (sl_ehip_reset_stat[sl_soft_i]),
                    .i_sl_ehip_tx_reset_stat    (sl_ehip_tx_reset_stat[sl_soft_i]),
                    .i_sl_ehip_rx_reset_stat    (sl_ehip_rx_reset_stat[sl_soft_i]),
                    .o_sl_ehip_reset            (sl_ehip_reset[sl_soft_i]),
                    .o_sl_ehip_tx_reset         (sl_ehip_tx_reset[sl_soft_i]),
                    .o_sl_ehip_rx_reset         (sl_ehip_rx_reset[sl_soft_i]),
                    .o_sl_ehip_pld_ready        (sl_ehip_pld_ready[sl_soft_i]),
                    .o_sl_ehip_signal_ok        (sl_ehip_signal_ok[sl_soft_i]),

                    .o_sl_rsfec_reset           (sl_soft_rsfec_reset[sl_soft_i]),
                    .o_sl_rsfec_tx_reset        (sl_soft_rsfec_tx_reset[sl_soft_i]),
                    .o_sl_rsfec_rx_reset        (sl_soft_rsfec_rx_reset[sl_soft_i]),

                    .o_sl_tx_lanes_stable       (o_sl_tx_lanes_stable[sl_soft_i]),
                    .o_sl_rx_pcs_ready          (o_sl_rx_pcs_ready[sl_soft_i]),

                    // TX Adapter
                    .i_sl_tx_data               (i_sl_tx_data_2d[sl_soft_i]),
                    .i_sl_tx_valid              (i_sl_tx_valid[sl_soft_i]),
                    .i_sl_tx_startofpacket      (i_sl_tx_startofpacket[sl_soft_i]),
                    .i_sl_tx_endofpacket        (i_sl_tx_endofpacket[sl_soft_i]),
                    .i_sl_tx_empty              (i_sl_tx_empty_2d[sl_soft_i]),
                    .i_sl_tx_error              (i_sl_tx_error[sl_soft_i]),
                    .i_sl_tx_skip_crc           (i_sl_tx_skip_crc[sl_soft_i]),
                    .o_sl_tx_ready              (o_sl_tx_ready[sl_soft_i]),

                    .o_sl_tx_data               (int_sl_tx_data[sl_soft_i]),
                    .o_sl_tx_valid              (int_sl_tx_valid[sl_soft_i]),
                    .o_sl_tx_inframe            (int_sl_tx_inframe[sl_soft_i]),
                    .o_sl_tx_empty              (int_sl_tx_empty[sl_soft_i]),
                    .o_sl_tx_error              (int_sl_tx_error[sl_soft_i]),
                    .o_sl_tx_skip_crc           (int_sl_tx_skip_crc[sl_soft_i]),
                    .i_sl_tx_ready              (int_sl_tx_ready[sl_soft_i]),
                    .o_sl_tx_aib_dsk            (int_sl_tx_aib_dsk[sl_soft_i]),

                    // RX Adapter
                    .i_sl_rx_data               (int_sl_rx_data[sl_soft_i]),
                    .i_sl_rx_valid              (int_sl_rx_valid[sl_soft_i]),
                    .i_sl_rx_inframe            (int_sl_rx_inframe[sl_soft_i]),
                    .i_sl_rx_empty              (int_sl_rx_empty[sl_soft_i]),
                    .i_sl_rx_error              (int_sl_rx_error[sl_soft_i]),
                    .i_sl_rx_fcs_error          (int_sl_rx_fcs_error[sl_soft_i]),
                    .i_sl_rx_status             (int_sl_rx_status[sl_soft_i]),

                    .o_sl_rx_data               (o_sl_rx_data_2d[sl_soft_i]),
                    .o_sl_rx_valid              (o_sl_rx_valid[sl_soft_i]),
                    .o_sl_rx_startofpacket      (o_sl_rx_startofpacket[sl_soft_i]),
                    .o_sl_rx_endofpacket        (o_sl_rx_endofpacket[sl_soft_i]),
                    .o_sl_rx_empty              (o_sl_rx_empty_2d[sl_soft_i]),
                    .o_sl_rx_error              (o_sl_rx_error_2d[sl_soft_i]),
                    .o_sl_rxstatus_data         (o_sl_rxstatus_data_2d[sl_soft_i]),
                    .o_sl_rxstatus_valid        (o_sl_rxstatus_valid[sl_soft_i]),

                    // PTP
                    // Deskew status
                    .i_sl_ptp_rx_aib_dsk_done   (sl_rx_aib_dsk_done[sl_soft_i]),

                    // User Interface: TOD Interface
                    .i_ptp_tod                  (i_ptp_tod),
                    // User Interface: TOD Interface for 1ns
                    .i_ptp_tx_tod               (i_sl_ptp_tx_tod_2d[sl_soft_i]),
                    .i_ptp_rx_tod               (i_sl_ptp_rx_tod_2d[sl_soft_i]),

                    // User Interface: PTP Status
                    .o_sl_tx_ptp_ready          (o_sl_tx_ptp_ready[sl_soft_i]),
                    .o_sl_rx_ptp_ready          (o_sl_rx_ptp_ready[sl_soft_i]),

                    // User Interface: TX 1-step Command
                    .i_sl_ptp_ins_ets           (i_sl_ptp_ins_ets[sl_soft_i]),
                    .i_sl_ptp_ins_cf            (i_sl_ptp_ins_cf[sl_soft_i]),
                    .i_sl_ptp_ins_zero_csum     (i_sl_ptp_zero_csum[sl_soft_i]),
                    .i_sl_ptp_ins_update_eb     (i_sl_ptp_update_eb[sl_soft_i]),
                    .i_sl_ptp_ts_format         (i_sl_ptp_ts_format[sl_soft_i]),
                    .i_sl_ptp_ts_offset         (i_sl_ptp_ts_offset_2d[sl_soft_i]),
                    .i_sl_ptp_cf_offset         (i_sl_ptp_cf_offset_2d[sl_soft_i]),
                    .i_sl_ptp_csum_offset       (i_sl_ptp_csum_offset_2d[sl_soft_i]),
                    .i_sl_ptp_ed_offset         (i_sl_ptp_eb_offset_2d[sl_soft_i]),
                    .i_sl_ptp_tx_its            (i_sl_ptp_tx_its_2d[sl_soft_i]),

                    // User Interface: TX 2-step Timestamp Request
                    .i_sl_ptp_ts_req            (i_sl_ptp_ts_req[sl_soft_i]),
                    .i_sl_ptp_fp                (i_sl_ptp_fp_2d[sl_soft_i]),

                    // User Interface: TX 2-step Timestamp Return
                    .o_sl_ptp_ets_valid         (o_sl_ptp_ets_valid[sl_soft_i]),
                    .o_sl_ptp_ets               (o_sl_ptp_ets_2d[sl_soft_i]),
                    .o_sl_ptp_ets_fp            (o_sl_ptp_ets_fp_2d[sl_soft_i]),

                    // User Interface: RX Timestamp
                    .o_sl_ptp_rx_its            (o_sl_ptp_rx_its_2d[sl_soft_i]),
                    .o_sl_ptp_rx_its_valid      (),

                    // EHIP Interface: TX 1-step and 2-step Command
                    .o_sl_ptp_tx_fp             (sl_ptp_tx_fp_to_ehip[sl_soft_i]),
                    .o_sl_ptp_ins_type          (sl_ptp_ins_type[sl_soft_i]),
                    .o_sl_ptp_byte_offset       (sl_ptp_byte_offset[sl_soft_i]),
                    .o_sl_ptp_ts                (sl_ptp_ts[sl_soft_i]),

                    // EHIP Interface: TX 2-step Timestamp
                    .i_sl_ptp_tx_ts_valid       (sl_ptp_tx_ts_valid[sl_soft_i]),
                    .i_sl_ptp_tx_ts             (sl_ptp_tx_ts[sl_soft_i]),
                    .i_sl_ptp_tx_ts_fp          (sl_ptp_tx_ts_fp_from_ehip[sl_soft_i]),

                    // EHIP Interface: RX Timestamp
                    .i_sl_ptp_rx_ts             (sl_ptp_rx_ts[sl_soft_i]),

                    // EHIP Interface: Reference Timestamp
                    .o_sl_sclk                  (sl_sclk[sl_soft_i]),
                    .o_sl_tx_sel_sclk_return    (sl_tx_sel_sclk_return[sl_soft_i]),
                    .o_sl_rx_sel_sclk_return    (sl_rx_sel_sclk_return[sl_soft_i]),
                    .i_sl_tx_sclk_return        (sl_tx_sclk_return[sl_soft_i]),
                    .i_sl_rx_sclk_return        (sl_rx_sclk_return[sl_soft_i]),
                    .i_sl_tx_am                 (sl_tx_am[sl_soft_i]),
                    .i_sl_rx_am                 (sl_rx_am[sl_soft_i]),

                    //1ns
                    .i_ptp_sn_sclk              (i_clk_ptp_sample),
                    // AVMM Interface: PTP
                    .o_sl_avmm_readdata         (sl_avmm_readdata[sl_soft_i]),
                    .i_sl_avmm_write            (is_soft_ptp[sl_soft_i]? i_sl_eth_reconfig_write_jtag_arb[sl_soft_i] : 1'b0),
                  //.i_sl_avmm_read             (is_soft_ptp[sl_soft_i]? sl_avmm_read[sl_soft_i] : 1'b0),
                    // .i_sl_avmm_read             (sl_avmm_read[sl_soft_i]),
                    .i_sl_avmm_read             (i_sl_avmm_read_1ns[sl_soft_i]),
                    .i_sl_avmm_writedata        (i_sl_eth_reconfig_writedata_2d[sl_soft_i]),
                    .o_sl_avmm_waitrequest      (sl_avmm_waitrequest[sl_soft_i]),
                    // .i_sl_avmm_address          ({2'b00, i_sl_eth_reconfig_addr_2d[sl_soft_i][3:0]}),
                    // .i_sl_avmm_address          (i_sl_eth_reconfig_addr_2d[sl_soft_i][5:0]),
                    .i_sl_avmm_address          (i_sl_avmm_address_1ns[sl_soft_i]),

                    .kr_mode(kr_mode[sl_soft_i]), // for SL, these should connect to an independent reset controller per lane
                    .kr_rst_req(kr_rst_req[sl_soft_i]),
                    .kr_rst_stat(kr_rst_stat[sl_soft_i]),
		    .o_sl_ehip_ready(o_sl_ehip_ready[sl_soft_i])
                );

                  if (sl_num_lanes < 4)
                   assign  kr_rst_stat[3: sl_num_lanes] = {{4-sl_num_lanes}{1'b0}};             // don't put z to empty channles
                assign sl_avmm_readdata_valid[sl_soft_i] = sl_avmm_read[sl_soft_i] & ~sl_avmm_waitrequest[sl_soft_i];
                assign sl_avmm_read[sl_soft_i] = is_soft_ptp[sl_soft_i]? i_sl_eth_reconfig_read_jtag_arb[sl_soft_i]  : 1'b0;

                if(include_alternate_ports_sl_0) begin : sl_dp_sel_gen
                    always @(posedge i_reconfig_clk) begin
                        if(reconfig_reset_sync) begin
                            sl_dp_sel[sl_soft_i] <= SL_DP_SEL_RESET_VALUE;
                        end
                        else begin
                            if((i_sl_eth_reconfig_addr_jtag_arb[sl_soft_i*19+:12] == 12'h350) && i_sl_eth_reconfig_write_jtag_arb[sl_soft_i]) begin
                                sl_dp_sel[sl_soft_i] <= i_sl_eth_reconfig_writedata_jtag_arb[sl_soft_i*32+:3];
                            end
                        end
                    end
                end
                else begin
                    assign sl_dp_sel[sl_soft_i] = SL_DP_SEL_RESET_VALUE;
                end

                always @(posedge i_reconfig_clk or negedge i_sl_csr_rst_n[sl_soft_i]) begin
                    if(!i_sl_csr_rst_n[sl_soft_i]) begin
                        sl_rsfec_mode[sl_soft_i]        <= ((ehip_mode_sl_0 == "ehip_mac") || (ehip_mode_sl_0 == "ehip_mac_ptp") || (ehip_mode_sl_0 == "ehip_otn") || (ehip_mode_sl_0 == "ehip_pcs66") || (ehip_mode_sl_0 == "ehip_pcs")) ? 1'b1 : 1'b0;
                        sl_tx_preamble_pass[sl_soft_i]  <= (tx_preamble_passthrough_sl_0 == "enable") ? 1'b1 : 1'b0;
                        sl_tx_am_pulse[sl_soft_i]       <= 1'b1;
                    end
                    else begin
						if (ENABLE_ANLT && EN_DYN_FEC) begin
                            sl_rsfec_mode[sl_soft_i]        <= (kr_dyn_fec_en[sl_soft_i]) ? 1'b1 : 1'b0;
                        if((i_sl_eth_reconfig_addr_jtag_arb[sl_soft_i*19+:12] == 12'h40B) && i_sl_eth_reconfig_write_jtag_arb[sl_soft_i]) begin
				sl_tx_preamble_pass[sl_soft_i]  <= (i_sl_eth_reconfig_writedata_jtag_arb[sl_soft_i*32+0] == 1'b1) ? 1'b1 : 1'b0;
				sl_tx_am_pulse[sl_soft_i]       <= (i_sl_eth_reconfig_writedata_jtag_arb[sl_soft_i*32+5:sl_soft_i*32+3] == 3'd0) ? 1'b0 : 1'b1;
							end
						end
                        else if((i_sl_eth_reconfig_addr_jtag_arb[sl_soft_i*19+:12] == 12'h40B) && i_sl_eth_reconfig_write_jtag_arb[sl_soft_i]) begin
                            sl_rsfec_mode[sl_soft_i]        <= (i_sl_eth_reconfig_writedata_jtag_arb[sl_soft_i*32+5:sl_soft_i*32+3] == 3'd4) ? 1'b1 : 1'b0;
                            sl_tx_preamble_pass[sl_soft_i]  <= (i_sl_eth_reconfig_writedata_jtag_arb[sl_soft_i*32+0] == 1'b1) ? 1'b1 : 1'b0;
                            sl_tx_am_pulse[sl_soft_i]       <= (i_sl_eth_reconfig_writedata_jtag_arb[sl_soft_i*32+5:sl_soft_i*32+3] == 3'd0) ? 1'b0 : 1'b1;
                        end
                    end
                end

            end
        end
        else
        begin
            assign sl_rsfec_mode                = 'b0;
            assign sl_ptp_ts 					= 'b0;
            assign sl_ptp_byte_offset 			= 'b0;
            assign sl_ptp_ins_type 				= 'b0;
            assign int_sl_tx_empty 				= 'b0;
            assign int_sl_tx_data 				= 'b0;
            assign sl_tx_sel_sclk_return 		= 'b0;
            assign sl_tx_pcs_reset 				= 'b0;
            assign sl_tx_aib_reset 				= 'b0;
            assign sl_sclk 						= 'b0;
            assign sl_rx_sel_sclk_return 		= 'b0;
            assign sl_rx_pcs_reset 				= 'b0;
            assign sl_rx_aib_reset 				= 'b0;
            assign sl_ehip_tx_reset 			= 'b0;
            assign sl_ehip_signal_ok 			= 'b0;
            assign sl_ehip_rx_reset 			= 'b0;
            assign sl_ehip_reset 				= 'b0;
            assign sl_ehip_pld_ready 			= 'b0;
            assign int_sl_tx_valid 				= 'b0;
            assign int_sl_tx_skip_crc 			= 'b0;
            assign int_sl_tx_inframe 			= 'b0;
            assign int_sl_tx_error 				= 'b0;
            assign int_sl_tx_aib_dsk 			= 'b0;
            assign sl_ptp_tx_fp_to_ehip			= 'b0;
            assign sl_avmm_readdata				= 'b0;
            assign sl_avmm_waitrequest			= 'b0;
            assign sl_avmm_readdata_valid		= 'b0;
            assign sl_dp_sel                    = 'b0;
            assign sl_soft_rsfec_reset          = 'b0;
            assign sl_soft_rsfec_tx_reset       = 'b0;
            assign sl_soft_rsfec_rx_reset       = 'b0;
            assign o_sl_tx_lanes_stable         = 'b0;
        end
    endgenerate



// Pause workaround module + AVMM module.
   generate
      if (RX_ASYNC_ADAPTER_MODE || ENABLE_ANLT) begin
	 // sync rx_pcs_ready
	 alt_xcvr_resync_std #(
			       .SYNC_CHAIN_LENGTH(3),    .WIDTH(1),  .INIT_VALUE(0)
			       )
	 sync_rxpcs_ready (
			   .clk    (int_rx_clk),
			   .reset  (1'b0),
			   .d  (o_rx_pcs_ready),
			   .q  (rx_pcs_ready_sync)
			   );

      end else begin
     assign rx_pcs_ready_sync = rx_pcs_ready_sync_rr;
      end // else: !if(RX_ASYNC_ADAPTER_MODE || ENABLE_ANLT)
   endgenerate



wire o_rx_pause_sync;

if ((!ENABLE_PCS66)&&(!ENABLE_PCSDIRECT)) begin : O_RX_PAUSE_SYNC_ENABLE

    alt_ehipc3_fm_altera_std_synchronizer_nocut o_rx_pause_sync_inst (
        .clk         (int_rx_clk),
        .reset_n     (1'b1),
        .din         (o_rx_pause),
        .dout        (o_rx_pause_sync)
    );
end


// fix for lint error
   wire o_rx_pause_sl_pause = (ENABLE_PCS66 || ENABLE_PCSDIRECT) ? 'b0: o_rx_pause_sync;
   wire o_tx_ready_sl_pause = ENABLE_PCS66 ? 'b1: o_tx_ready;
wire i_csr_rst_n_sync, soft_csr_rst_sync, sl_pause_reset;
alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   csr_reset_synchronizers1
     (	.clk	(int_rx_clk),
	.reset	(1'b0),
	.d	(i_csr_rst_n),
	.q	(i_csr_rst_n_sync));

alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3),	.WIDTH(1),	.INIT_VALUE(0))
   csr_reset_synchronizers2
     (	.clk	(int_rx_clk),
	.reset	(1'b0),
	.d	(soft_csr_rst),
	.q	(soft_csr_rst_sync));

assign sl_pause_reset = ~i_csr_rst_n_sync | soft_csr_rst_sync;

alt_ehipc3_fm_sl_pause #(
  .AW(21),
  .DW(32),
  .FLOW_CONTROL(ehip_core_flow_control)
  ) alt_ehipc3_fm_sl_pause_inst (
			      .i_clk(int_rx_clk),
			      .i_rst_n(~sl_pause_reset),
			      .i_ehip_ready(ehip_ready_sync),
			      .i_reconfig_clk(i_reconfig_clk),
			      .i_reconfig_reset(reconfig_reset_sync),
			      .i_rx_pcs_ready(o_rx_pcs_ready),
			      .i_rx_pause(o_rx_pause_sl_pause),
			      .i_tx_ready(o_tx_ready_sl_pause),
			      //AVMM interface to EHIP
			      .o_eth_reconfig_addr(a_eth_reconfig_addr),
			      .o_eth_reconfig_writedata(a_eth_reconfig_writedata),
			      .o_eth_reconfig_write(a_eth_reconfig_write),
			      .o_eth_reconfig_read(a_eth_reconfig_read),
			      .i_eth_reconfig_readdata(a_eth_reconfig_readdata),
			      .i_eth_reconfig_readdata_valid(a_eth_reconfig_readdata_valid),
			      .i_eth_reconfig_waitrequest(a_eth_reconfig_waitrequest),
			      // AVMM interface to Application
			      .i_usr_reconfig_addr(i_eth_reconfig_addr_jtag_arb),
			      .i_usr_reconfig_writedata(i_eth_reconfig_writedata_jtag_arb),
			      .i_usr_reconfig_write(i_eth_reconfig_write_jtag_arb),
			      .i_usr_reconfig_read(i_eth_reconfig_read_jtag_arb),
			      .o_usr_reconfig_readdata(o_eth_reconfig_readdata_jtag_arb),
			      .o_usr_reconfig_readdata_valid(o_eth_reconfig_readdata_valid_jtag_arb),
			      .o_usr_reconfig_waitrequest(o_eth_reconfig_waitrequest_jtag_arb),
			      .o_ehip_shadow(pause_ehip_ready)
			      );






endmodule // alt_ehipc3_fm_top


//-----------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorized by
// a licensing agreement from ALTERA
// copyright notice must be reproduced on all authorized copies.
//-----------------------------------------------------------------------------
// Copyright ?? 2014 Altera Corporation. All rights reserved.  Altera products are
// protected under numerous U.S. and foreign patents, maskwork rights, copyrights and
// other intellectual property laws.
//-----------------------------------------------------------------------------
//  Project Name:  100G_Ethernet_HIP
//  Module Name :  ehip_top
//  Author      :  gwallich
//  Date        :  Fri Oct 16 13:45:44 2015
//  Description :  This is synchronous FIFO with programmab;e full and empty flags
//-----------------------------------------------------------------------------
