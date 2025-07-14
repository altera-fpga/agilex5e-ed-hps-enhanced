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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)

module alt_ehipc3_fm_hard_salfkeq
   import alt_ehipc3_fm_package::*;
   #(
    parameter MAX_REFCLK = 1,
    parameter MAX_CH = 1,
    parameter MAX_XCVR_CH = 4,
    parameter MAX_CLKOUT_CH = 4,
    parameter SL_LANES = 1,
    parameter LANES  = 6,
    parameter ENABLE_RSFEC=0,
    parameter ENABLE_RSFEC_MODE=0,
    parameter LANES6 = 6,
    parameter LANES4 = 4,
    parameter LANES2 = 2,
    parameter EL_LANES = 1,
    parameter deskew_lanes = 4,
    parameter EHP_WORDS  = 2,
    parameter ENABLE_PCSDIRECT = 0,
    parameter ENABLE_PTP = 0,
    parameter ENABLE_PTP_TOG = 0,
    parameter USE_PTP_PLLCH = 1,
    parameter ENABLE_PTP_RX_DESKEW = 0,
    parameter LOCATION_SEL = 0,
    parameter ECORE_5432_TIEOFF = 0,
    parameter ENABLE_PCS66 = 0,
    parameter enable_external_aib_clocking = 0,
    parameter SL_OPT = 2,
    parameter duplex_mode                       	= "enable" , //                    {"disable" "enable"}
    parameter powerdown_mode                    	= "powerup" , //                  {"powerdown" "powerup"}
    parameter use_factory_settings                	= "true",  //
    parameter sup_mode                          	= "user_mode" , //                  {"advanced_user_mode" "engineering_mode" "user_mode"}
    parameter silicon_rev                       	= "14nm5cr2ea" , //                   {"14nm4cr2" "14nm4cr2ea" "14nm5bcr2b" "14nm5cr2" "14nm5cr2ea"}
    parameter [23:0] am_encoding40g_0                  	= 24'd9467463,     //                 {0:16777215}
    parameter [23:0] am_encoding40g_1                  	= 24'd15779046,     //                {0:16777215}
    parameter [23:0] am_encoding40g_2                  	= 24'd12936603,     //                {0:16777215}
    parameter [23:0] am_encoding40g_3                  	= 24'd10647869,     //                {0:16777215}
    parameter [6:0] ber_invalid_count                 	= 7'd97,           //                {0:127}
    parameter check_random_idles                	= "disable" , //                    {"disable" "enable"}
    parameter crete_type                        	= "crete2e" , //                     {"crete2e" "crete3"}
    parameter deskew_clear                      	= "disable" , //                    {"disable" "enable"}
    parameter disable_link_fault_rf             	= "disable" , //                    {"disable" "enable"}
    parameter [31:0] ehip_clk_hz                       	= 32'd0,              //              {0:2147483647}
    parameter ehip_clk_sel                      	= "no_clock" , //                   {"datapath_clock" "fec_clock" "no_clock" "shared_clock"}
    parameter [2:0] ehip_dist_clk_sel                 	= 3'd0,                //            {0:7}
    parameter ehip_mode                         	= "ehip_disable" , //               {"ehip_bypass" "ehip_disable" "ehip_fec" "ehip_lane_ptp_only" "ehip_lb_rxfec_txfec" "ehip_lb
    parameter ehip_rate                         	= "rate_100gx4" , //                 {"custom_rate_100gx4" "custom_rate_10gx1" "custom_rate_25gx1" "custom_rate_25gx1_fec" "custo
    parameter ehip_type                         	= "multi_lane" , //                 {"multi_lane" "single_lane"}
    parameter enable_rx_stats_snapshot          	= "disable" , //                    {"disable" "enable"}
    parameter enable_tx_stats_snapshot          	= "disable" , //                    {"disable" "enable"}
    parameter enforce_max_frame_size            	= "disable" , //                    {"disable" "enable"}
    parameter [2:0] fec_dist_clk_sel                  	= 3'd0,                    //        {0:7}
    parameter flow_control                      	= "none" , //                       {"both" "both_no_xoff" "none" "pfc" "pfc_no_xoff" "sfc" "sfc_no_xoff"}
    parameter flow_control_holdoff_mode         	= "per_queue" , //                  {"no_holdoff" "per_queue" "uniform"}
    parameter force_deskew_done                 	= "disable" , //                    {"disable" "enable"}
    parameter force_hip_ready                   	= "disable" , //                    {"disable" "enable"}
    parameter force_link_fault_rf               	= "disable" , //                    {"disable" "enable"}
    parameter forward_rx_pause_requests         	= "disable" , //                    {"disable" "enable"}
    parameter func_mode                         	= "disable" , //                    {"disable" "enable"}
    parameter hi_ber_monitor                    	= "enable" , //                     {"disable" "enable"}
    parameter [15:0] holdoff_quanta                    	= 16'd65535,                        //{0:65535}
    parameter [15:0] ipg_removed_per_am_period         	= 16'd20,                           //{0:65535}
    parameter is_usr_avmm                       	= "false" , //                      {"false" "true"}
    parameter keep_rx_crc                       	= "disable" , //                    {"disable" "enable"}
    parameter link_fault_mode                   	= "lf_off" , //                     {"lf_bidir" "lf_off" "lf_unidir"}
    parameter [15:0] pause_quanta                      	= 16'd65535,     //                   {0:65535}
    parameter [15:0] pfc_holdoff_quanta_0              	= 16'd65535,  //                        {0:65535}
    parameter [15:0] pfc_holdoff_quanta_1              	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_holdoff_quanta_2              	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_holdoff_quanta_3              	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_holdoff_quanta_4              	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_holdoff_quanta_5              	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_holdoff_quanta_6              	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_holdoff_quanta_7              	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_pause_quanta_0                	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_pause_quanta_1                	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_pause_quanta_2                	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_pause_quanta_3                	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_pause_quanta_4                	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_pause_quanta_5                	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_pause_quanta_6                	= 16'd65535,  //                      {0:65535}
    parameter [15:0] pfc_pause_quanta_7                	= 16'd65535,  //                      {0:65535}

    parameter sim_mode                          	= "disable" , //                    {"disable" "enable"}
    parameter tx_am_period                      	= "standard_100g_am_period",
                                                                              //    {"no_tx_am_period" "sim_only_100g_fec_am_period" "sim_only_25g_fec_am_period" "sim_only_40g_
    parameter rx_am_interval                    	= "standard_100g_am_interval",
                                                                              //  {"no_rx_am_interval" "sim_only_40g_am_interval" "sim_only_50g_am_interval" "sim_only_am_inte
    parameter powermode_ac_mac                  	= "mac_off" , //                    {"mac_off" "mac_on_1_lane_noptp" "mac_on_1_lane_ptp" "mac_on_2_lane" "mac_on_4_lane_noptp" "
    parameter powermode_ac_misc                 	= "misc_off" , //                   {"misc_off" "misc_on"}
    parameter powermode_ac_pcs                  	= "pcs_off" , //                    {"pcs_off" "pcs_on_1_lane_norsfec" "pcs_on_1_lane_rsfec" "pcs_on_2_lane" "pcs_on_4_lane_rsfec , pcs_on_4_lane_norsfec
    parameter powermode_ac_pld                  	= "pld_off" , //                    {"pld_off" "pld_on_1_lane_noptp" "pld_on_1_lane_ptp" "pld_on_2_lane" "pld_on_4_lane_noptp" "
    parameter powermode_dc                      	= "powerdown_dc" , //               {"powerdown_dc" "powerup_dc"}
    parameter [31:0] ptp_debug                         	= 32'd0 , //   NOVAL
    parameter ptp_timestamp_format              	= "v2" , //                         {"v1" "v2"}
    parameter ptp_tx_timestamp_method           	= "ptp_1step" , //                  {"ptp_1step" "ptp_2step"}
    parameter remove_pads                       	= "disable" , //                    {"disable" "enable"}
    parameter [8:0] request_tx_pause                  	= 9'd0 , //                           {0:511}
    parameter reset_rx_stats                    	= "disable" , //                    {"disable" "enable"}
    parameter reset_rx_stats_parity_error       	= "disable" , //                    {"disable" "enable"}
    parameter reset_tx_stats                    	= "disable" , //                    {"disable" "enable"}
    parameter reset_tx_stats_parity_error       	= "disable" , //                    {"disable" "enable"}
    parameter [31:0] rx_aib_dp_latency                 	= 32'b0000_0000_0000_0000_0000_0000_0000_0000, //  NOVAL
    parameter [19:0] rx_clock_period                   	= 20'd162689, //                       {0:1048575}
    parameter rx_datapath_soft_rst              	= "disable" , //                    {"disable" "enable"}
    parameter rx_length_checking                	= "enable" , //                     {"disable" "enable"}
    parameter rx_mac_soft_rst                   	= "disable" , //                    {"disable" "enable"}
    parameter [15:0] rx_max_frame_size                 	= 16'd1518,  //                         {0:65535}
    parameter [47:0] rx_pause_daddr                    	= 48'd1652522221569, // "1652522221569" ,
    parameter [5:0] rx_pcs_max_skew                   	= 6'd47,           //                 {0:63}
    parameter rx_pcs_soft_rst                   	= "disable" , //                    {"disable" "enable"}
    parameter rx_preamble_passthrough           	= "disable" , //                    {"disable" "enable"}
    parameter [31:0] rx_ptp_dp_latency                 	= 32'b0000_0000_0000_0000_0000_0000_0000_0000, //0
    parameter [31:0] rx_ptp_extra_latency              	= 32'b0000_0000_0000_0000_0000_0000_0000_0000, //0
    parameter rx_vlan_detection                 	= "enable" , //                     {"disable" "enable"}
    parameter rxcrc_covers_preamble             	= "disable" , //                    {"disable" "enable"}
    parameter source_address_insertion          	= "disable" , //                    {"disable" "enable"}
    parameter strict_preamble_checking          	= "disable" , //                    {"disable" "enable"}
    parameter strict_sfd_checking               	= "disable" , //                    {"disable" "enable"}
    parameter [5:0] cfgonly_bypass_select               = 6'd0,         //                {0:127}
    parameter topology                          	= "disabled_block" , //             {"dirfec_100g" "dirfec_1ch" "dirfec_2ch" "dirfec_3ch" "dirfec_4ch" "disabled_block" "disable
    parameter tx_aib_dp_latency                 	= "0" , //                          NOVAL
    parameter [19:0] tx_clock_period                   	= 20'd162689, //                       {0:1048575}
    parameter tx_datapath_soft_rst              	= "disable" , //                    {"disable" "enable"}
    parameter tx_ipg_size                       	= "ipg_12" , //                     {"ipg_1" "ipg_10" "ipg_12" "ipg_8"}
    parameter tx_mac_data_flow                  	= "enable" , //                     {"disable" "enable"}
    parameter tx_mac_soft_rst                   	= "disable" , //                    {"disable" "enable"}
    parameter [15:0] tx_max_frame_size                 	= 16'd1518,   //                      {0:65535}
    parameter [47:0] tx_pause_daddr                    	= 48'd1652522221569, //"1652522221569"
    parameter [47:0] tx_pause_saddr                    	= 48'd247393538562781, //"247393538562781"
    parameter tx_pcs_soft_rst                   	= "disable" , //                    {"disable" "enable"}
    parameter [4:0] tx_pld_fifo_almost_full_level     	= 5'd16,    //                       {0:31}
    parameter tx_preamble_passthrough           	= "disable" , //                    {"disable" "enable"}
    parameter [31:0] tx_ptp_asym_latency               	= 32'b0000_0000_0000_0000_0000_0000_0000_0000, //NOVAL
    parameter [31:0] tx_ptp_dp_latency                 	= 32'b0000_0000_0000_0000_0000_0000_0000_0000, //NOVAL
    parameter [31:0] tx_ptp_extra_latency              	= 32'b0000_0000_0000_0000_0000_0000_0000_0000, // NOVAL
    parameter tx_vlan_detection                 	= "enable" , //                     {"disable" "enable"}
    parameter txcrc_covers_preamble             	= "disable" , //                    {"disable" "enable"}
    parameter [47:0] txmac_saddr                       	= 48'b0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000, //"73588229205"
    parameter [15:0] uniform_holdoff_quanta            	= 16'd65535,       //                 {0:65535}
    parameter use_am_insert                     	= "disable" , //                    {"disable" "enable"}
    parameter use_lane_ptp                      	= "disable" , //                    {"disable" "enable"}
    parameter use_testbus                       	= "disable" , //                    {"disable" "enable"}
    parameter [20:0] xus_timer_window                  	= 21'd201415,     //                  {0:2097151}

    parameter core_variant                      = 0,
    parameter active_channel                    = 0,

    //25G parameters
    parameter include_alternate_ports_sl_0      = 0,
    parameter tx_preamble_passthrough_sl        = "disable",
    parameter rx_preamble_passthrough_sl        = "disable",
    parameter ehip_mode_sl_0                    = "ehip_mac_no_fec",
    parameter ehip_rate_sl                      = "rate_25gx1",
    parameter topology_sl                       = "elane_1ch",
    parameter tx_ipg_size_sl                    = "ipg_1",
    parameter source_address_insertion_sl       = "disable",
    parameter keep_rx_crc_sl                    = "disable",
    parameter ehip_type_sl                      = "single_lane",
    parameter bti_preserve                      = 0,
    parameter FIRST_LANE			= 0
    )
   (
    // clocks
   input wire  [MAX_REFCLK-1:0]   i_refclk,
   input wire                     i_reconfig_clk,
   input wire 			  i_rx_core_clk,
   input wire 			  i_tx_core_clk,
   input wire  [SL_LANES-1:0]     i_sl_clk_tx,
   input wire  [SL_LANES-1:0]     i_sl_clk_rx,
   input wire                     i_aib_clk,
   input wire                     i_aib_2x_clk,
   output wire [MAX_CLKOUT_CH-1:0]  o_tx_clk_div64, // 64 clock = 402.3
   output wire [MAX_CLKOUT_CH-1:0]  o_rx_clk_div64, // 64 clock = 402.3
   output wire [MAX_CLKOUT_CH-1:0]  o_tx_clk_div66, // 66 clock = 390.625
   output wire [MAX_CLKOUT_CH-1:0]  o_rx_clk_div66, // 66 clock = 390.625

   // Configuration
   input wire [SL_LANES-1:0]        i_sl_enable_rsfec,

    // Serial Interface signals
   input wire [MAX_XCVR_CH-1:0]        i_rx_serial_data,
   output wire [MAX_XCVR_CH-1:0]       o_tx_serial_data,
   input wire [MAX_XCVR_CH-1:0]        i_rx_serial_data_n,
   output wire [MAX_XCVR_CH-1:0]       o_tx_serial_data_n,

    // Reset controller interface signals
   input wire 				      i_ehip_rst_n, // this will
   input wire 				      i_ehip_rx_rst_n,
   input wire 				      i_ehip_tx_rst_n,
   input wire 				      i_ehip_pld_ready,
   input wire 				      i_ehip_signal_ok,
   input wire [LANES4-1:0]                    i_rx_pmaif_reset,
   input wire [LANES4-1:0]                    i_tx_pmaif_reset,
   input wire                                 i_rsfec_reset,
   input wire                                 i_rx_rsfec_reset,
   input wire                                 i_tx_rsfec_reset,
   input wire [LANES-1:0] 		      i_tx_aib_reset,
   input wire [LANES-1:0] 		      i_rx_aib_reset,

   input wire [SL_LANES-1:0]          i_sl_rx_pmaif_reset,
   input wire [SL_LANES-1:0]          i_sl_tx_pmaif_reset,
   input wire [SL_LANES-1:0]          i_sl_tx_aib_reset,
   input wire [SL_LANES-1:0]          i_sl_rx_aib_reset,

   output logic [LANES-1:0] 		      o_rx_is_lockedtodata,
   output wire [LANES6-1:0] 		      o_rx_transfer_ready,
   output wire [LANES6-1:0] 		      o_tx_transfer_ready,
   output wire [LANES-1:0] 		      o_tx_dll_lock,
   output logic [LANES-1:0]      o_rx_pma_ready,
   output logic [LANES-1:0]      o_tx_pma_ready,

   output wire [SL_LANES-1:0]         o_sl_rx_is_lockedtodata,
   output wire [SL_LANES-1:0]         o_sl_rx_transfer_ready,
   output wire [SL_LANES-1:0]         o_sl_tx_transfer_ready,

   // Adding following ouput ports to give proper transfer status of ELANE and PTP channels
   output wire [SL_LANES-1:0] 		      o_slch_tx_transfer_ready,
   output wire [SL_LANES-1:0] 		      o_slch_rx_transfer_ready,
   output wire [LANES2-1:0] 		      o_sl_ptpch_tx_transfer_ready,
   output wire [LANES2-1:0] 		      o_sl_ptpch_rx_transfer_ready,



   output wire [SL_LANES-1:0]         o_sl_tx_dll_lock,
   output wire [SL_LANES-1:0]         o_sl_rx_pma_ready,
   output wire [SL_LANES-1:0]         o_sl_tx_pma_ready,

    // EHIP signals
   output wire 				      o_ehip_ready,
   output wire 				      o_ehip_rst_ack_n,
   output wire 				      o_ehip_tx_rst_ack_n, //need to fix the fake adapt.
   output wire 				      o_ehip_rx_rst_ack_n, //need to fix the fake adapt.
    // FEC ack signals
   output wire 				      o_rsfec_tx_rst_ack_n, //need to fix the fake adapt.
   output wire 				      o_rsfec_rx_rst_ack_n, //need to fix the fake adapt.

   output wire 				      o_ehip_cfg_load_done,
   output wire 				      o_ehip_rx_block_lock,
   output wire 				      o_ehip_rx_am_lock,
   output wire 				      o_ehip_rx_dsk_done,
   output wire 				      o_ehip_rx_remote_fault,
   output wire 				      o_ehip_rx_local_fault,
   output wire 				      o_ehip_rx_pcs_fully_aligned,
   output wire 				      o_ehip_rx_hi_ber,

    // MAC Interface
   input wire [LANES-1:0][EHP_MAC_WIDTH-1:0]  i_tx_data,
   input wire [LANES-1:0] 		      i_tx_error,
   input wire [LANES-1:0][2:0] 		      i_tx_empty,
   input wire [LANES-1:0] 		      i_tx_inframe,
    //   input wire [LANES-1:0] 	      i_tx_fifo_wr_en,
   input wire [LANES-1:0] 		      i_tx_skip_crc,
   input wire [LANES6-1:0] 		      i_tx_aib_dsk,
   input wire 				      i_ehip_clear_internal_err,

   input wire [SL_LANES-1:0][63:0]    i_sl_tx_data,
   input wire [SL_LANES-1:0] 		  i_sl_tx_error,
   input wire [SL_LANES-1:0][2:0] 	  i_sl_tx_empty,
   input wire [SL_LANES-1:0] 		  i_sl_tx_inframe,
   input wire [SL_LANES-1:0] 		  i_sl_tx_skip_crc,
   input wire [SL_LANES-1:0]          i_sl_tx_aib_dsk,
   input wire [SL_LANES-1:0]          i_sl_ehip_clear_internal_err,

   input wire [LANES2-1:0]            i_sl_ptp_tx_aib_dsk,

   output wire [LANES-1:0][EHP_MAC_WIDTH-1:0] o_rx_data ,
   output wire [LANES-1:0][2:0] 	      o_rx_empty,
   output wire [LANES-1:0][1:0] 	      o_rx_error,
   output wire [LANES-1:0][2:0] 	      o_rx_status,

   output wire [LANES-1:0] 		      o_rx_fcs_error,
   output wire [LANES-1:0] 		      o_rx_inframe,
   output wire [deskew_lanes-1:0] 	      o_rx_aib_dsk,

   output wire [SL_LANES-1:0][63:0] o_sl_rx_data,
   output wire [SL_LANES-1:0][2:0]  o_sl_rx_empty,
   output wire [SL_LANES-1:0][1:0]  o_sl_rx_error,
   output wire [SL_LANES-1:0][2:0]  o_sl_rx_status,
   output wire [SL_LANES-1:0]       o_sl_rx_fcs_error,
   output wire [SL_LANES-1:0]       o_sl_rx_inframe,
   output wire [SL_LANES-1:0]       o_sl_rx_aib_dsk,
   output wire [SL_LANES-1:0]       o_sl_rx_aib_dsk_done,

   output wire [LANES2-1:0]         o_sl_ptp_rx_aib_dsk,

    // Signals that don't repeat per lane
   input wire 				      i_tx_pause,
   input wire [7:0] 			      i_tx_pfc,
   input wire 				      i_tx_valid,
   input wire 				      i_stats_snapshot,
   input wire 				      i_custom_cadence,
   output wire 				      o_rx_valid,
   output wire 				      o_rx_pause,
   output wire [7:0] 			      o_rx_pfc,
   output wire 				      o_rx_pcs_internal_err,
   output wire 				      o_tx_ready,

   input  wire [SL_LANES-1:0]       i_sl_tx_valid,
   output wire [SL_LANES-1:0]       o_sl_tx_ready,
   output wire [SL_LANES-1:0]       o_sl_rx_valid,

    // Elane Interface
   output wire [SL_LANES-1:0]       o_sl_rx_pcs_fully_aligned,                             //                             o_sl_rx_pcs_fully_aligned.o_sl_rx_pcs_fully_aligned
   output wire [SL_LANES-1:0]       o_sl_rx_block_lock,                            //                            o_sl_rx_block_lock.o_sl_rx_block_lock
   output wire [SL_LANES-1:0]       o_sl_rx_hi_ber,                             //                             o_sl_rx_hi_ber.o_sl_rx_hi_ber
   output wire [SL_LANES-1:0]       o_sl_local_fault_status,                         //                         o_sl_local_fault_status.o_sl_local_fault_status
   output wire [SL_LANES-1:0]       o_sl_rx_pause,                               //                               o_sl_rx_pause.o_sl_rx_pause
   output wire [SL_LANES-1:0][7:0]  o_sl_rx_pfc,                                 //                                 o_sl_rx_pfc.o_sl_rx_pfc
   output wire [SL_LANES-1:0]       o_sl_xcvr_rxfifo_overflow,                 //                 o_sl_xcvr_rxfifo_overflow.o_sl_xcvr_rxfifo_overflow
   output wire [SL_LANES-1:0]       o_sl_remote_fault_status,                        //                        o_sl_remote_fault_status.o_sl_remote_fault_status
   input  wire [SL_LANES-1:0]       i_sl_ehip_signal_ok,                          //                           o_rx_enh_signal_ok.o_rx_enh_signal_ok
   input  wire [SL_LANES-1:0]       i_sl_tx_pause,                               //                               tx_enh_pause.tx_enh_pause
   input  wire [SL_LANES-1:0][7:0]  i_sl_tx_pfc,                                 //                                 tx_enh_pfc.tx_enh_pfc
   output wire [SL_LANES-1:0]       o_sl_xcvr_txfifo_pempty,             //             tx_enh_pmaif_fifo_almost_empty.tx_enh_pmaif_fifo_almost_empty
   output wire [SL_LANES-1:0]       o_sl_xcvr_txfifo_pfull,              //              tx_enh_pmaif_fifo_almost_full.tx_enh_pmaif_fifo_almost_full
   output wire [SL_LANES-1:0]       o_sl_xcvr_txfifo_overflow,                 //                 tx_enh_pmaif_fifo_overflow.tx_enh_pmaif_fifo_overflow
   output wire [SL_LANES-1:0]       o_sl_xcvr_txfifo_underflow,                //                tx_enh_pmaif_fifo_underflow.tx_enh_pmaif_fifo_underflow
   input  wire [SL_LANES-1:0]       i_sl_clear_internal_err,                   //                               .enh_clear_internal_error
   output wire [SL_LANES-1:0]       o_sl_internal_err,                         //
   input  wire [SL_LANES-1:0]       i_sl_force_rcfg_reset,                       //
   output wire [SL_LANES-1:0]       o_sl_cfg_load_done,                            //
   input  wire [SL_LANES-1:0]       i_sl_stats_snapshot,
   input  wire [SL_LANES-1:0]       i_sl_custom_cadence,

   input  wire [SL_LANES-1:0]       i_sl_ehip_reset,
   input  wire [SL_LANES-1:0]       i_sl_ehip_rx_reset,
   input  wire [SL_LANES-1:0]       i_sl_ehip_tx_reset,
   output wire [SL_LANES-1:0]       o_sl_ehip_ready,
   input  wire [SL_LANES-1:0]       i_sl_ehip_pld_ready,
   output wire [SL_LANES-1:0]       o_sl_ehip_reset_stat,
   output wire [SL_LANES-1:0]       o_sl_ehip_rx_reset_stat,
   output wire [SL_LANES-1:0]       o_sl_ehip_tx_reset_stat,

   input  wire                      i_sl_rsfec_reset,
   input  wire                      i_sl_rsfec_rx_reset,
   input  wire                      i_sl_rsfec_tx_reset,

   output wire [LANES-1:0]          o_rx_fifo_ready,
   output wire [LANES-1:0]          o_tx_fifo_ready,
   output wire [SL_LANES-1:0]       o_sl_rx_fifo_ready,
   output wire [SL_LANES-1:0]       o_sl_tx_fifo_ready,

    // MII Interface
   input wire [LANES-1:0] [63:0] 	      i_tx_mii_d, // TX MII data
   input wire [LANES-1:0] [7:0] 	      i_tx_mii_c, // Tx MII control
   input wire 				      i_tx_mii_valid, // Indicates valid data ports, must follow o_tx_mii_ready
   input wire 				      i_tx_mii_am, // Alignment marker insertion bit
   output wire 				      o_tx_mii_ready, // indicates PCS is ready to receive new data
   output wire [LANES-1:0] [63:0] 	      o_rx_mii_d, // RX MII data
   output wire [LANES-1:0] [7:0] 	      o_rx_mii_c, // RX MII control
   output wire 				      o_rx_mii_valid, // Indicates valid datain MII ports
   output wire 				      o_rx_mii_am_valid, // Indicates valid datain MII ports

   input  wire [SL_LANES-1:0][63:0]     i_sl_tx_mii_d,          // TX MII data
   input  wire [SL_LANES-1:0][7:0]      i_sl_tx_mii_c,          // Tx MII control
   input  wire [SL_LANES-1:0]           i_sl_tx_mii_valid,      // Indicates valid data ports, must follow o_tx_mii_ready
   input  wire [SL_LANES-1:0]           i_sl_tx_mii_am,         // Alignment marker insertion bit
   output wire [SL_LANES-1:0]           o_sl_tx_mii_ready,      // indicates PCS is ready to receive new data
   output wire [SL_LANES-1:0][63:0]     o_sl_rx_mii_d,          // RX MII data
   output wire [SL_LANES-1:0][7:0]      o_sl_rx_mii_c,          // RX MII control
   output wire [SL_LANES-1:0]           o_sl_rx_mii_valid,      // Indicates valid datain MII ports
   output wire [SL_LANES-1:0]           o_sl_rx_mii_am_valid,   // Indicates valid datain MII ports

   // PCS66 (OTN, FLEXE) Interface
   input wire [LANES-1:0] [65:0] 	      i_tx_pcs66_d, // TX PCS66 data
   input wire 				                  i_tx_pcs66_valid, // Indicates valid data ports, must follow o_tx_pcs66_ready
   input wire 				                  i_tx_pcs66_am, // Alignment marker insertion bit
   output wire 				                  o_tx_pcs66_ready, // indicates PCS is ready to receive new data
   output wire [LANES-1:0] [65:0] 	    o_rx_pcs66_d, // RX PCS66 data
   output wire 				                  o_rx_pcs66_valid, // Indicates valid datain PCS66 ports
   output wire 				                  o_rx_pcs66_am_valid, // Indicates valid datain PCS66 ports

   // PCS66 (OTN, FLEXE) Interface
   input  wire [SL_LANES-1:0][65:0]     i_sl_tx_pcs66_d,        // TX PCS66 data
   input  wire [SL_LANES-1:0]           i_sl_tx_pcs66_valid,    // Indicates valid data ports, must follow o_tx_pcs66_ready
   input  wire [SL_LANES-1:0]           i_sl_tx_pcs66_am,       // Alignment marker insertion bit
   output wire [SL_LANES-1:0]           o_sl_tx_pcs66_ready,    // indicates PCS is ready to receive new data
   output wire [SL_LANES-1:0][65:0]     o_sl_rx_pcs66_d,        // RX PCS66 data
   output wire [SL_LANES-1:0]           o_sl_rx_pcs66_valid,    // Indicates valid datain PCS66 ports
   output wire [SL_LANES-1:0]           o_sl_rx_pcs66_am_valid, // Indicates valid datain PCS66 ports

   // PMA Direct Interface
   input  wire [SL_LANES-1:0][79:0]     i_sl_tx_pma, // TX PMA direct data
   output wire [SL_LANES-1:0][79:0]     o_sl_rx_pma, // RX PMA direct data
   output wire [SL_LANES-1:0]           o_sl_aib_txfifo_empty,
   output wire [SL_LANES-1:0]           o_sl_aib_txfifo_full,
   output wire [SL_LANES-1:0]           o_sl_aib_txfifo_pempty,
   output wire [SL_LANES-1:0]           o_sl_aib_txfifo_pfull,
   output wire [SL_LANES-1:0]           o_sl_aib_rxfifo_empty,
   output wire [SL_LANES-1:0]           o_sl_aib_rxfifo_full,
   output wire [SL_LANES-1:0]           o_sl_aib_rxfifo_pempty,
   output wire [SL_LANES-1:0]           o_sl_aib_rxfifo_pfull,
   input  wire [SL_LANES-1:0]           i_sl_aib_rxfifo_rd_en,

   // RX AIB deskew debug
   input  wire [SL_LANES-1:0]           i_sl_aib_rxfifo_latency_adj_ena,
   //input  wire [LANES2-1:0]             i_sl_ptp_aib_rxfifo_latency_adj_ena,

   // Datapath mux select
   input  wire [SL_LANES-1:0][2:0]      i_sl_dp_sel,

   // Deterministic Latency Interface
   output wire [SL_LANES-1:0]           o_sl_tx_dl_async_pulse,
   output wire [SL_LANES-1:0]           o_sl_rx_dl_async_pulse,
   input  wire [SL_LANES-1:0]           i_sl_latency_sclk,
   input  wire [SL_LANES-1:0]           i_sl_tx_dl_measure_sel,
   input  wire [SL_LANES-1:0]           i_sl_rx_dl_measure_sel,


    // TEST BUS
   input  wire                                i_testbus_en,
   input  wire [2:0]                          i_testbus_source,
   input  wire [5:0]                          i_testbus_sel,

    // PTP Interface
   input  wire [LANES4-1:0][1:0]	      i_ptp_tx_fp,		//ok
   input  wire [LANES4-1:0][2:0]              i_ptp_byte_offset,
   input  wire [LANES4-1:0][2:0]              i_ptp_ins_type,
   input  wire [LANES4-1:0][23:0]             i_ptp_ts,
   input  wire [4:0] 		              i_select_ptp_vl_data, 	//only for 100G,
   input  wire                  	      i_read_ptp_vl_data,	//only for 100G.

   output wire [LANES4-1:0][20:0] 	      o_ptp_rx_ts,
   output wire                                o_ptp_reading_vl_data,	//only for 100G.
   output wire [LANES4-1:0]                   o_ptp_tx_ts_valid,	//ok
   output wire [LANES4-1:0][11:0]             o_ptp_tx_ts,
   output wire [LANES4-1:0][1:0]	      o_ptp_tx_fp, 		//ok

   // EHIP Interface: TX 1-step and 2-step Command
   input  wire [SL_LANES-1:0][1:0]        i_sl_ptp_tx_fp,
   input  wire [SL_LANES-1:0][2:0]        i_sl_ptp_ins_type,
   input  wire [SL_LANES-1:0][2:0]        i_sl_ptp_byte_offset,
   input  wire [SL_LANES-1:0][23:0]       i_sl_ptp_ts,

   // EHIP Interface: TX 2-step Timestamp
   output wire [SL_LANES-1:0]             o_sl_ptp_tx_ts_valid,
   output wire [SL_LANES-1:0][11:0]       o_sl_ptp_tx_ts,
   output wire [SL_LANES-1:0][1:0]        o_sl_ptp_tx_ts_fp,

   // EHIP Interface: RX Timestamp
   output wire [SL_LANES-1:0][20:0]       o_sl_ptp_rx_ts,

   // EHIP Interface: Reference Timestamp
   input  wire [SL_LANES-1:0]             i_sl_sclk,
   input  wire [SL_LANES-1:0]             i_sl_tx_sel_sclk_return,
   input  wire [SL_LANES-1:0]             i_sl_rx_sel_sclk_return,
   output wire [SL_LANES-1:0]             o_sl_tx_sclk_return,
   output wire [SL_LANES-1:0]             o_sl_rx_sclk_return,
   output wire [SL_LANES-1:0]             o_sl_tx_am,
   output wire [SL_LANES-1:0]             o_sl_rx_am,

   // jerry
   input  wire [LANES-1:0]                i_sclk,
   input  wire [LANES-1:0]                i_tx_sel_sclk_return,
   input  wire [LANES-1:0]                i_rx_sel_sclk_return,
   output wire [LANES-1:0]                o_tx_sclk_return,
   output wire [LANES-1:0]                o_rx_sclk_return,
   output wire [LANES4-1:0]                    o_tx_am,
   output wire [LANES4-1:0]                    o_rx_am,


//AVMM DPRIO Interface
   input 				      i_ehip_reconfig_rst_n,
   input 				      i_ehip_reconfig_read,
   input [20:0] 			      i_ehip_reconfig_address,
   input 				      i_ehip_reconfig_write,
   input [7:0] 				      i_ehip_reconfig_writedata,
   input 				      i_ehip_reconfig_clk,
   output [7:0] 			      o_ehip_reconfig_readdata,
   output 				      o_ehip_reconfig_waitrequest,

  //XCVR Reconfig Interface, seperate one for each lane
   input wire                                 i_rsfec_reconfig_clk,
   input wire                                 i_reconfig_reset,
   input wire                                 i_rsfec_reconfig_write,
   input wire                                 i_rsfec_reconfig_read,
   input wire [11-1:0]                        i_rsfec_reconfig_addr,
   input wire [8-1:0]                         i_rsfec_reconfig_writedata,
   output wire [8-1:0]                        o_rsfec_reconfig_readdata,
   output wire                                o_rsfec_reconfig_waitrequest,

   input  wire                                i_ptp_reconfig_clk,
   input  wire                                i_ptp_reconfig_reset,
   input  wire [LANES2-1:0]                   i_ptp_reconfig_write,
   input  wire [LANES2-1:0]                   i_ptp_reconfig_read,
   input  wire [LANES2*19-1:0]                i_ptp_reconfig_address,
   input  wire [LANES2*8-1:0]                 i_ptp_reconfig_writedata,
   output wire [LANES2*8-1:0]                 o_ptp_reconfig_readdata,
   output wire [LANES2-1:0]                   o_ptp_reconfig_waitrequest,

   input  wire                                i_xcvr_reconfig_clk,
   input  wire                                i_xcvr_reconfig_reset,
   input  wire [MAX_XCVR_CH-1:0]              i_xcvr_reconfig_write,
   input  wire [MAX_XCVR_CH-1:0]              i_xcvr_reconfig_read,
   input  wire [MAX_XCVR_CH*19-1:0]           i_xcvr_reconfig_address,
   input  wire [MAX_XCVR_CH*8-1:0]            i_xcvr_reconfig_writedata,
   output wire [MAX_XCVR_CH*8-1:0]            o_xcvr_reconfig_readdata,
   output wire [MAX_XCVR_CH-1:0]              o_xcvr_reconfig_waitrequest,

   input wire                                 i_xcvr_reconfig_clk_ptp,
   input wire                                 i_xcvr_reconfig_reset_ptp,
   input wire [LANES2-1:0]                    i_xcvr_reconfig_write_ptp,
   input wire [LANES2-1:0]                    i_xcvr_reconfig_read_ptp,
   input wire [LANES2*19-1:0]                 i_xcvr_reconfig_address_ptp,
   input wire [LANES2*8-1:0]                 i_xcvr_reconfig_writedata_ptp,
   output wire [LANES2*8-1:0]                o_xcvr_reconfig_readdata_ptp,
   output wire [LANES2-1:0]                   o_xcvr_reconfig_waitrequest_ptp,

   output wire [32-1:0]		 	      o_rsfec_channel_ssr,
   output wire 				      rsfec_o_fec_ready,
   input  wire                    rsfec_signal_ok_from_top
    );

    // KR mux interface
   wire 				      i_kr_mode;
   wire [66*LANES-1:0] 			      o_kr_rx_parallel_data;
   wire [66*LANES-1:0] 			      i_kr_tx_parallel_data;
   wire [LANES-1:0] 			      o_kr_rx_data_valid;
   wire 				      i_kr_tx_data_valid;


// DESKEW

//


   /***************************************************************************************************************************
    For C2E - EHIP at hssi_tile_3 ( 4th six pack, hssi_tile0, 1, 2 (six packs 1, 2, 3) for PHIP
    Tile 3  0, 1, 3, 4 run at 25G
    For 100G  Tile 3 - LC0, PMA/PCS Ch0, 1, 3, 4 (adapter 0-4). From remaining chs only Ch5 is available in EHIP BYPass mode and can run upto 12.5G
    For 50G  Tile 3 LC0 , PMA/PCS/Adapter - Ch0, 1, running at 25.78125G
    remaining chs(2, 3, 4, 5)  can be used in EHIP bypass mode for other purpose and can run upto 4.5G
    Adapters are in HIP mode similar to PHIP, 2 speed grades -1, -2.
    Internally 17G at -1 speed, ext commn 25.78125G.
    <------------------------  ehipc3  ------------------------->
    |-------------|              |-------------|        |-------|
    |             |              |             |        |       |
    |   XCVR PCS  |------------->| EHIP Core   |------->|  AIB  | => Soft Logic
    |             |<-------------|             |<-------|       |    (Reset controller, ADDapter, CSR)
    |-------------|              |-------------|        |-------|

    EHIP PCS Interface - To transfter data safely from EHIP clock domain to PCS clock domain
    It connects EHIP Core and 4 PCS Interface channels
    1) PCS TX Interface - 4 PH Comp FIFOs and 4 muxes, wrclk =EHIP_CLK, rd_clk = pcs_tx_clkout,
    both clocks are from the same TX PLL and should hvae 0 PPM so TX overflow shouldn't happen.
    Underflow flag assertion does not mean failure. Its considered failure when data is corrupted,
    in which case user should check clock setting to ensure read and write FIFO frequencies
    2) PCS RX Interface - RX FIFO is in elastic mode and handles clk componsation and ph componsation
    between receoverd clock domain and EHIP Clok domain, wrclk =pcs_rx_clkout(recovered clock,rd_clk= ehip_clk
    By design, RX FIFO underflow could never happen because read enable = ~empty flag.
    RX FIFO overflow could only happen when recover clock frequency over EHIP main clock frequency ratio is
    more than 66/64 or 30,000ppm difference. According to IEEE specs, ppm difference should be +/-100ppm.
    When you do see an overflow, user needs to check clocking scheme for any setup issue

    //Following will be ack signals for ehip resets,  which will go to the reset controller
    //o_rx_rst_n
    //o_tx_rst_n
    //o_rst_n
    ****************************************************************************************************************************/

    genvar i;
    genvar ii;
    genvar ig;

    logic [LANES-1:0]            rx_pma_ready;
    logic [LANES-1:0]            tx_pma_ready;
    logic [LANES2-1:0]           ptp_tx_pma_ready;
    logic [LANES2-1:0]           ptp_rx_pma_ready;
    logic [LANES-1:0]            rx_is_lockedtodata;

    generate
        if (!(ENABLE_PTP!=0 && core_variant==3 && active_channel==1)) begin : PTP_TX_PMA_READY
            assign ptp_tx_pma_ready = 2'b11;
            assign ptp_rx_pma_ready = 2'b11;
        end
    endgenerate

    always_comb begin
        o_rx_is_lockedtodata    = rx_is_lockedtodata;
        o_rx_pma_ready          = rx_pma_ready;
        o_tx_pma_ready          = tx_pma_ready & (ECORE_5432_TIEOFF ? {LANES{ptp_tx_pma_ready[1]}} : {LANES{ptp_tx_pma_ready[0]}});

        if (topology == "ehip_4ch_kpfec") begin
            // Duplicate status signals from channels 0 and 2
            o_rx_is_lockedtodata[1] = rx_is_lockedtodata[0];
            o_rx_pma_ready[1]       = rx_pma_ready[0];
            o_tx_pma_ready[1]       = tx_pma_ready[0];

            o_rx_is_lockedtodata[3] = rx_is_lockedtodata[2];
            o_rx_pma_ready[3]       = rx_pma_ready[2];
            o_tx_pma_ready[3]       = tx_pma_ready[2];
        end
    end

    logic [LANES2-1:0]           sl_ptp_tx_pma_ready;
    logic [LANES2-1:0]           sl_ptp_rx_pma_ready;
    logic [SL_LANES-1:0]         sl_tx_pma_ready;

       if (( (core_variant == 0) ||
             (core_variant == 1) ||
            ((core_variant == 3) && (active_channel == 0)) ||
             (core_variant == 4) || (core_variant == 5) || (core_variant == 7)) )
           begin
    assign o_sl_tx_pma_ready = sl_tx_pma_ready & (ENABLE_PTP ? ECORE_5432_TIEOFF ? {SL_LANES{sl_ptp_tx_pma_ready[1]}} : {SL_LANES{sl_ptp_tx_pma_ready[0]}} : {SL_LANES{1'b1}});

         end

   wire 	async_rx_ehip_rst_n;
   wire 	async_tx_ehip_rst_n;
   wire 	h2a_rx_ehip_rst_n;
   wire 	h2a_tx_ehip_rst_n;
   wire 	h2a_ehip_rst_n;
   wire 	ehip_clk;
   wire         ptp_clk;
   wire 	o_ehip_clk;
   wire 	o_ehip_dist_fr_rx_clk;
   wire 	o_fec_dist_fr_rx_clk;
   wire         pll_avmm_clk;

// Using following parameters from ehip_package
// localparam  EHP_PMA_WIDTH       =   66;
// localparam  EHP_PCS_DWIDTH      =   256;
// localparam  EHP_MAC_WIDTH       =   64;
// localparam  EHP_PLD_WIDTH       =   78;
// localparam  EHP_FEC_WIDTH       =   264;
// localparam  EHP_DSK_WIDTH       =   EHP_AIB_WIDTH-1;
// localparam  EHP_VL_DATA_W       =   36;
   localparam  EHP_AIB_WIDTH       =   78;
   localparam  EHP_BLK_WIDTH       =   66;

   localparam FSRIN_WIDTH = 4;
   localparam SSRIN_WIDTH = 40;
   localparam FSROUT_WIDTH = 4;
   localparam SSROUT_WIDTH = 8;
   localparam HIP_AIB_STATUS = 3;
   localparam HIP_AIB_TXEQ_WIDTH = 12;
   localparam TX_PARALLEL_DW = 80;
   localparam RX_PARALLEL_DW = 80;

   // localparam ENABLE_50G = (ehip_rate=="rate_50gx2") ? 1'b1: 1'b0;
   localparam ENABLE_25G = (ehip_rate=="rate_25g") ? 1'b1: 1'b0;
   localparam AIB_DATA_OUT_WIDTH = 132;
   localparam AIB_IN_WIDTH = 105;
   localparam AIB_PLD_TX_DATAOUT_WIDTH = 147;
   localparam PCS_PLD_TX_DATAIN_WIDTH = 147;
   localparam PCS_PLD_RX_DATAOUT_WIDTH = 149;

   wire [4:0]                             sl_refclk;
   generate
        for(i = 0; i < 5; i = i + 1) begin : SL_REFCLK_LOOP
            if(MAX_REFCLK > i) begin : SL_REFCLK_SYNTH
                assign sl_refclk[i] = i_refclk[i];
            end
            else begin : SL_REFCLK_UNUSED
                assign sl_refclk[i] = 1'b0;
            end
        end
   endgenerate

   wire                                   ml_tx_coreclkin;
   wire                                   ml_rx_coreclkin;
   wire                                   ml_tx_coreclkin2;

   wire [SL_LANES-1:0]                    sl_tx_coreclkin;
   wire [SL_LANES-1:0]                    sl_rx_coreclkin;
   wire [SL_LANES-1:0]                    sl_tx_coreclkin2;
   reg [SL_LANES-1:0]                     sl_rx_aib_reset_sync/* synthesis maxfan = 50 */;
   reg                                    sl_rx_aib_reset_all_and/* synthesis maxfan = 50 */;
   wire [SL_LANES-1:0]                    sl_rx_aib_reset_sync_int;
   wire [LANES2-1:0]                      tx_clkout_ptp;
   wire [LANES2-1:0]                      tx_clkout2_ptp;
   wire [LANES2-1:0]                      rx_clkout_ptp;
   wire [LANES2-1:0]                      rx_clkout2_ptp;
   wire [LANES2-1:0]                      ptp_pll_hr_clk;
   wire [LANES2-1:0]                      ptp_pll_hr_clk_100g;
   wire [LANES2-1:0]                      ptp_pll_fr_clk;
   wire [LANES2-1:0]                      ptp_pll_fr_clk_100g;
   wire                                   ptp_ch_hr_clk;
   wire                                   ptp_ch_fr_clk;
   wire [EHP_WORDS*EHP_BLK_WIDTH-1:0]     core_tx_data; // 66*LANES
   wire [EHP_WORDS-1:0] 		  core_tx_data_valid;
   wire [EHP_WORDS-1:0] 		  core_tx_data_am_valid;
   wire [EHP_WORDS*EHP_BLK_WIDTH-1:0] 	  core_rx_data;  //66*LANES
   wire [EHP_WORDS-1:0] 		  core_rx_data_valid;
   wire [EHP_WORDS-1:0] 		  core_rx_data_am_valid;

   wire [EHP_BLK_WIDTH*LANES-1:0] 				  ehip_tx_data; // 66*
   wire [LANES-1:0] 						  ehip_tx_data_valid;

   wire [SL_LANES-1:0]         sl_tx_transfer_ready;
   wire [SL_LANES-1:0]         sl_rx_transfer_ready;
   wire [LANES2-1:0]           sl_ptp_tx_transfer_ready;
   wire [LANES2-1:0]           sl_ptp_rx_transfer_ready;

   assign o_sl_tx_transfer_ready = sl_tx_transfer_ready & {SL_LANES{&sl_ptp_tx_transfer_ready}};
   assign o_sl_rx_transfer_ready = sl_rx_transfer_ready & {SL_LANES{&sl_ptp_rx_transfer_ready}};
   // Adding following ouput ports to give proper transfer status of ELANE and PTP channels
   assign o_slch_tx_transfer_ready = sl_tx_transfer_ready;
   assign o_sl_ptpch_tx_transfer_ready = sl_ptp_tx_transfer_ready;
   assign o_slch_rx_transfer_ready = sl_rx_transfer_ready;
   assign o_sl_ptpch_rx_transfer_ready = sl_ptp_rx_transfer_ready;




   wire [LANES4-1:0]           sl_rsfec_not_align;
   wire [LANES4-1:0]           sl_rsfec_not_align_sync;
   reg                         sl_rsfec_reset_assert_locked;
   wire [LANES4-1:0]           sl_ehip_signal_ok;
   wire [SL_LANES-1:0]         sl_ehip_pld_ready_sync;
   reg                         sl_rsfec_pld_ready;

   localparam                  STM_SL_RSFEC_RESET_INIT          = 7'b0000001;
   localparam                  STM_SL_RSFEC_RX_RESET_ASSERT     = 7'b0000010;
   localparam                  STM_SL_RSFEC_TX_RESET_ASSERT     = 7'b0000100;
   localparam                  STM_SL_RSFEC_RESET_ASSERT        = 7'b0001000;
   localparam                  STM_SL_RSFEC_RESET_DEASSERT      = 7'b0010000;
   localparam                  STM_SL_RSFEC_TX_RESET_DEASSERT   = 7'b0100000;
   localparam                  STM_SL_RSFEC_RX_RESET_DEASSERT   = 7'b1000000;

   reg  [6:0]                  sl_rsfec_reset_nextstate;
   reg  [6:0]                  sl_rsfec_reset_state;
   reg  [7:0]                  sl_rsfec_reset_count;
   wire [8:0]                  sl_rsfec_reset_count_plus_one;
   wire                        sl_rsfec_clock_stable;
   wire                        sl_rsfec_clock_stable_sync;
   reg                         sl_global_rsfec_reset;
   reg                         sl_global_rsfec_tx_reset;
   reg                         sl_global_rsfec_rx_reset;

   // To Native PHY IP
   wire h2a_hip_ready;
   wire h2a_rx_am_lock;
   wire h2a_rx_block_lock;
   wire h2a_rx_dsk_done;
   wire h2a_remote_fault;
   wire h2a_local_fault;
   wire h2a_cfg_load_done;
   wire h2a_hi_ber;
   wire h2a_rx_pcs_fully_aligned;

   // From Native PHY IP
   wire [LANES*HIP_AIB_STATUS-1:0]		a2h_hip_aib_status;  //4ch
   wire [1:0][HIP_AIB_STATUS-1:0]		a2h_hip_aib_status_ptp;  //2ch ptp

   wire a2h_rst_n;
   wire a2h_tx_rst_n;
   wire a2h_rx_rst_n;
   wire a2h_pld_ready;
   wire a2h_signal_ok;
   wire a2h_clear_internal_err;
   wire i_user_avmm_rst_n;

`ifndef  PTP_EN_TMP
   generate if(ENABLE_PTP == 0) begin : AIB_STATUS_PTP
       assign 					a2h_hip_aib_status_ptp = 6'h3f;
     end
   endgenerate
`endif
   wire [LANES6*4-1:0]       hip_aib_fsr_in;
   wire [LANES6*40-1:0]      hip_aib_ssr_in;

   assign hip_aib_fsr_in[23:4] = 20'b0;
   assign hip_aib_fsr_in[3] = i_ehip_pld_ready;
   assign hip_aib_fsr_in[2] = i_ehip_rx_rst_n;
   assign hip_aib_fsr_in[1] = i_ehip_tx_rst_n;
   assign hip_aib_fsr_in[0] = i_ehip_rst_n;
   assign hip_aib_ssr_in[239:3] = 237'b0;
   assign hip_aib_ssr_in[2] = i_ehip_clear_internal_err;
   assign hip_aib_ssr_in[1] = 1'b1;
   assign hip_aib_ssr_in[0] = i_ehip_signal_ok;
// for 100G mac+pcs only
//                                                                        17:12      11:9    8:6     5:3     2:0
   wire [LANES6-1:0][HIP_AIB_STATUS-1:0]	a2h_hip_aib_status_all = {6'b111111, 3'b111, 3'b111, 3'b111, a2h_hip_aib_status[2:0]};	//based on Sujoy's golden

   wire [MAX_CLKOUT_CH-1:0]               rx_clkout;
   wire [MAX_CLKOUT_CH-1:0]               tx_clkout;
   wire [MAX_CLKOUT_CH-1:0]               rx_clkout2;
   wire [MAX_CLKOUT_CH-1:0]               tx_clkout2;
   wire [LANES6-1:0] 			  xcvr_fr_tx_clk;

   assign ml_tx_coreclkin                = enable_external_aib_clocking ? i_aib_clk    : i_tx_core_clk;
   assign ml_rx_coreclkin                = enable_external_aib_clocking ? i_aib_clk    : i_rx_core_clk;
   assign ml_tx_coreclkin2               = enable_external_aib_clocking ? i_aib_2x_clk : ptp_ch_fr_clk;

   assign sl_tx_coreclkin [SL_LANES-1:0] = enable_external_aib_clocking ? {SL_LANES{i_aib_clk}}    : i_sl_clk_tx[SL_LANES-1:0];
   assign sl_rx_coreclkin [SL_LANES-1:0] = enable_external_aib_clocking ? {SL_LANES{i_aib_clk}}    : i_sl_clk_rx[SL_LANES-1:0];
   assign sl_tx_coreclkin2[SL_LANES-1:0] = enable_external_aib_clocking ? {SL_LANES{i_aib_2x_clk}} : {SL_LANES{ptp_ch_fr_clk}};

   assign o_tx_clk_div64 = tx_clkout;
   assign o_rx_clk_div64 = rx_clkout;
   assign o_tx_clk_div66 = tx_clkout2;
   assign o_rx_clk_div66 = rx_clkout2;


   wire [LANES6*80-1:0] 	         tx_parallel_data;
   wire [LANES6*80-1:0] 		 tx_parallel_data_r;
   logic [2*80-1:0] 		 pp;
   wire [LANES6*80-1:0] 	         rx_parallel_data;
   wire [LANES6-1:0][EHP_AIB_WIDTH-1:0] 	 int_tx_parallel_data; // 78*lanes
   wire [LANES6-1:0][EHP_AIB_WIDTH-1:0] 	 int_rx_parallel_data; // 78*lanes

   // Single Lane Datapath
   wire [SL_LANES-1:0][79:0]    sl_tx_parallel_data;
   wire [SL_LANES-1:0][79:0]    sl_rx_parallel_data;
   wire [SL_LANES-1:0][79:0]    sl_rx_parallel_data_dsk;
   reg  [SL_LANES-1:0]          sl_tx_ready_r;
   reg  [SL_LANES-1:0]          sl_tx_ready_rr;
   reg  [SL_LANES-1:0]          sl_tx_ready_rrr;

   // Single Lane PTP
   wire                           sl_rx_aib_dsk_done;
   wire [SL_LANES-1:0][39:0]      sl_ptp_tx_parallel_data;
   wire [LANES4-1:0][39:0]        nphy_sl_ptp_tx_parallel_data;
   wire [SL_LANES-1:0][39:0]      sl_ptp_rx_parallel_data;
   reg  [LANES2-1:0][79:0]      nphy_ptp_tx_parallel_data;
   wire [LANES2-1:0][79:0]      nphy_ptp_rx_parallel_data;
   reg  [LANES2-1:0][79:0]      nphy_ptp_rx_parallel_data_r;
   wire [LANES2-1:0][79:0]      nphy_ptp_rx_parallel_data_dsk;

// ptp signals
   wire [7:0]		 i_u_ehip_core_o_ptp_mac_tx_fp;

   wire [1:0] 	             ptp_ehip_aib_tx_transfer_div2_clk;
   wire [SL_LANES-1:0] 	     ehip_aib_tx_transfer_div2_clk;
   wire [LANES6*78-1:0] 	 ehip_aib_sync_data_out;
   wire [LANES6*78-1:0] 	 ehip_aib_sync_data_in;
   wire [119:0] 		 ext_testbus;

// PTP interface signals
   wire [LANES6-1:0]   ehip_elane_am_detect;                       //                       ehip_elane_am_detect.ehip_elane_am_detect
   wire [LANES6-1:0]   ehip_elane_am_insert;                       //                       ehip_elane_am_insert.ehip_elane_am_insert
   wire [LANES6-1:0]   ehip_elane_ptp_fifo_share_rd_en;            //            ehip_elane_ptp_fifo_share_rd_en.ehip_elane_ptp_fifo_share_rd_en
   wire [LANES6-1:0]   ehip_elane_ptp_fifo_share_wr_en;            //            ehip_elane_ptp_fifo_share_wr_en.ehip_elane_ptp_fifo_share_wr_en
   wire [LANES6*12-1:0]ehip_elane_ptp_tx_ts;                       //                       ehip_elane_ptp_tx_ts.ehip_elane_ptp_tx_ts
   wire [LANES6*2-1:0] ehip_elane_ptp_tx_ts_fp;                    //                    ehip_elane_ptp_tx_ts_fp.ehip_elane_ptp_tx_ts_fp
   wire [LANES6-1:0]   ehip_elane_ptp_tx_ts_valid;                 //                 ehip_elane_ptp_tx_ts_valid.ehip_elane_ptp_tx_ts_valid
   wire [LANES6*24-1:0]ehip_elane_rx_ptp_ts;                       //                       ehip_elane_rx_ptp_ts.ehip_elane_rx_ptp_ts
   wire [LANES6-1:0]   ehip_elane_shared_clear;                    //                    ehip_elane_shared_clear.ehip_elane_shared_clear
   wire [LANES6-1:0]   ehip_elane_shared_dsk_done;                 //                 ehip_elane_shared_dsk_done.ehip_elane_shared_dsk_done
   wire [LANES6*3-1:0] elane_ehip_ptp_deskewed_byte_offset;        //        elane_ehip_ptp_deskewed_byte_offset.elane_ehip_ptp_deskewed_byte_offset
   wire [LANES6*3-1:0] elane_ehip_ptp_deskewed_ins_type;           //           elane_ehip_ptp_deskewed_ins_type.elane_ehip_ptp_deskewed_ins_type
   wire [LANES6*24-1:0]elane_ehip_ptp_deskewed_ts;                 //                 elane_ehip_ptp_deskewed_ts.elane_ehip_ptp_deskewed_ts
   wire [LANES6*2-1:0] elane_ehip_ptp_deskewed_tx_fp;              //              elane_ehip_ptp_deskewed_tx_fp.elane_ehip_ptp_deskewed_tx_fp
   wire [LANES6-1:0]   elane_ehip_ptp_lane_deskew_deskew_marker;   //   elane_ehip_ptp_lane_deskew_deskew_marker.elane_ehip_ptp_lane_deskew_deskew_marker
   wire [LANES6-1:0]   elane_ehip_ptp_lane_deskew_got_marker;      //      elane_ehip_ptp_lane_deskew_got_marker.elane_ehip_ptp_lane_deskew_got_marker
   wire [LANES6*6-1:0] elane_ehip_ptp_lane_deskew_tap_sel_one_hot; // elane_ehip_ptp_lane_deskew_tap_sel_one_hot.elane_ehip_ptp_lane_deskew_tap_sel_one_hot
   wire [LANES6*3-1:0] elane_ehip_ptp_mac_byte_offset;             //             elane_ehip_ptp_mac_byte_offset.elane_ehip_ptp_mac_byte_offset
   wire [LANES6*3-1:0] elane_ehip_ptp_mac_ins_type;                //                elane_ehip_ptp_mac_ins_type.elane_ehip_ptp_mac_ins_type
   wire [LANES6*24-1:0]elane_ehip_ptp_mac_ts;                      //                      elane_ehip_ptp_mac_ts.elane_ehip_ptp_mac_ts
   wire [LANES6*2-1:0] elane_ehip_ptp_mac_tx_fp;                   //                   elane_ehip_ptp_mac_tx_fp.elane_ehip_ptp_mac_tx_fp
   wire [LANES6-1:0]   elane_ehip_shared_clk;                      //                      elane_ehip_shared_clk.elane_ehip_shared_clk
   wire [LANES4-1:0]   rsfec_signal_ok;                            //

   wire [LANES4-1:0]   sl_rsfec_signal_ok;
   wire sl_rsfec_o_fec_ready;

wire	[84-1:0]		o_ptp_rx_ts_tmp;
wire	[4-1:0]			o_rx_am_tmp;
wire				o_ptp_reading_vl_data_tmp;
wire	[4-1:0]			o_tx_am_tmp;
wire	[4-1:0]			o_ptp_tx_ts_valid_tmp;
wire	[48-1:0]		o_ptp_tx_ts_tmp;
wire	[8-1:0]			o_ptp_tx_fp_tmp;

wire 	[7:0]			i_ptp_tx_fp_tmp;
wire 	[11:0]			i_ptp_byte_offset_tmp;
wire 	[11:0] 			i_ptp_ins_type_tmp;
wire 	[95:0]			i_ptp_ts_tmp;
wire 	[4:0]			i_select_ptp_vl_data_tmp;
wire 				i_read_ptp_vl_data_tmp;




   generate
	 for (ig=0; ig<4; ig=ig+1) begin : g_ehip_inst

	    //TX mappings
	    if (ENABLE_PCSDIRECT)
	      begin
		 for(i = 0; i<8;  i=i+1)
		   begin:txrx_bytes
		      assign int_tx_parallel_data[ig][9*i+:8] = i_tx_mii_d[ig][i*8+:8];
		      assign int_tx_parallel_data[ig][9*i+8] = i_tx_mii_c[ig][i];

		      assign o_rx_mii_d[ig][i*8+:8] = int_rx_parallel_data[ig][i*9+:8];
		      assign o_rx_mii_c[ig][i] = int_rx_parallel_data[ig][i*9+8];
		   end:txrx_bytes
		 if (ig == 0)
		   begin
		      assign int_tx_parallel_data[ig][EPRT_TX_AM_VALID]  =   i_tx_mii_am;
		      assign int_tx_parallel_data[ig][EPRT_TX_VALID]     =   i_tx_mii_valid;	// Same mapping as tx_valid
		      assign int_tx_parallel_data[0][EPRT_STATS_SNAPSHOT]        =   i_stats_snapshot;
		      assign int_tx_parallel_data[0][EPRT_CUSTOM_CADENCE]        =   i_custom_cadence;
		      assign o_tx_mii_ready =   int_rx_parallel_data[ig][EPRT_TX_READY];
		      assign o_rx_mii_am_valid =   int_rx_parallel_data[ig][EPRT_RX_AM_VALID];
		      assign o_rx_mii_valid  =   int_rx_parallel_data[ig][EPRT_RX_VALID];
		      //Map the internal error signal
		      assign o_rx_pcs_internal_err  = int_rx_parallel_data[ig][EPRT_RXPCS_INTERR];
		      // for warning free, drive unused data to 0
		      assign int_tx_parallel_data[0][75] = 1'b0;
		   end
		 else
		   begin
		      assign int_tx_parallel_data[ig][72] = 1'b0;
		      assign int_tx_parallel_data[ig][73] = 1'b0;
		      assign int_tx_parallel_data[ig][74] = 1'b0;
		      assign int_tx_parallel_data[ig][75] = 1'b0;
		      assign int_tx_parallel_data[ig][76] = 1'b0;
		   end // else: !if(ig == 0)
	      end // if (ENABLE_PCSDIRECT)

        else if (ENABLE_PCS66)
	      begin
		        assign int_tx_parallel_data[ig][EPRT_TX_MAC_DATA+:66] = i_tx_pcs66_d[ig];
		        assign int_tx_parallel_data[ig][66+:6] = 6'b000000;
		        assign o_rx_pcs66_d[ig]= int_rx_parallel_data[ig][EPRT_RX_DATA+:66];

		        if (ig == 0)
		        begin
		            assign int_tx_parallel_data[ig][EPRT_TX_AM_VALID]  =   i_tx_pcs66_am;
		            assign int_tx_parallel_data[ig][EPRT_TX_VALID]     =   i_tx_pcs66_valid;	// Same mapping as tx_valid
		            assign int_tx_parallel_data[0][EPRT_STATS_SNAPSHOT]        =   i_stats_snapshot;
		            assign int_tx_parallel_data[0][EPRT_CUSTOM_CADENCE]        =   i_custom_cadence;

		            assign o_tx_pcs66_ready =   int_rx_parallel_data[ig][EPRT_TX_READY];
		            assign o_rx_pcs66_am_valid =   int_rx_parallel_data[ig][EPRT_RX_AM_VALID];
		            assign o_rx_pcs66_valid  =   int_rx_parallel_data[ig][EPRT_RX_VALID];
		            //Map the internal error signal
		            assign o_rx_pcs_internal_err  = int_rx_parallel_data[ig][EPRT_RXPCS_INTERR];
		            // for warning free, drive unused data to 0
		            assign int_tx_parallel_data[0][75] = 1'b0;

		        end // if (ig == 0)
		        else
		        begin
		            assign int_tx_parallel_data[ig][72] = 1'b0;
		            assign int_tx_parallel_data[ig][73] = 1'b0;
		            assign int_tx_parallel_data[ig][74] = 1'b0;
		            assign int_tx_parallel_data[ig][75] = 1'b0;
		            assign int_tx_parallel_data[ig][76] = 1'b0;
		        end // else: !if(ig == 0)
	      end // if (ENABLE_PCS66)

	    // IF MAC+PCS is enabled then do following mapping
	    else
	      begin
		 //TX MAC Client Datapath and per-lane control
		 assign int_tx_parallel_data[ig][EPRT_TX_MAC_DATA+:64]  =   i_tx_data[ig];
		 assign int_tx_parallel_data[ig][EPRT_TX_ERROR]         =   i_tx_error[ig];
		 assign int_tx_parallel_data[ig][EPRT_TX_EOP_EMPTY+:3]  =   i_tx_empty[ig];
		 assign int_tx_parallel_data[ig][EPRT_TX_SKIP_CRC]      =   i_tx_skip_crc[ig];
		 assign int_tx_parallel_data[ig][EPRT_TX_INFRAME]       =   i_tx_inframe[ig];
		 //Map the valid signals for TX
		 if (ig == 0)
		   begin
		      assign int_tx_parallel_data[ig][EPRT_TX_VALID]              =   i_tx_valid;
		 //Map the AIB0 PAUSE and PFC signals
		      assign int_tx_parallel_data[ig][EPRT_TX_PAUSE]              =   i_tx_pause;
		      assign int_tx_parallel_data[ig][EPRT_TX_PFC0]               =   i_tx_pfc[0];
		      assign int_tx_parallel_data[ig][EPRT_TX_PFC1]               =   i_tx_pfc[1];
		      assign int_tx_parallel_data[ig][EPRT_TX_PFC2]               =   i_tx_pfc[2];
		      assign int_tx_parallel_data[ig][EPRT_STATS_SNAPSHOT]        =   i_stats_snapshot;
		      assign int_tx_parallel_data[ig][EPRT_CUSTOM_CADENCE]        =   i_custom_cadence;
		      assign o_tx_ready                  =   int_rx_parallel_data[ig][EPRT_TX_READY];
		      assign o_rx_valid                  =   int_rx_parallel_data[ig][EPRT_RX_VALID];
		      assign o_rx_fcs_error[ig]          =   int_rx_parallel_data[0][EPRT_RX_FCS_ERROR];
		      assign o_rx_error[ig]              =   int_rx_parallel_data[0][EPRT_RX_ERROR+:2];
		      assign o_rx_status[ig]             =   int_rx_parallel_data[0][EPRT_RX_STATUS+:3];
		      //Map the internal error signal
		      assign o_rx_pcs_internal_err       =   int_rx_parallel_data[ig][EPRT_RXPCS_INTERR];
		   end
		 else if (ig == 1)
		   begin
		 //PFC3 to 7 are located on AIB 1, but their indices assume the AIBs
		      // Need to terminate following
		      assign int_tx_parallel_data[ig][65]               =  1'b0;
		      assign int_tx_parallel_data[ig][71]               =  1'b0;
		      //PFC3 to 7 are located on AIB 1, but their indices assume the AIBs
		 //are concatenated, so we set the AIB index to 1 and subtract 1 AIB
		 //width from the index
		      assign int_tx_parallel_data[ig][EPRT_TX_PFC3-EHP_PLD_WIDTH] =   i_tx_pfc[3];
		      assign int_tx_parallel_data[ig][EPRT_TX_PFC4-EHP_PLD_WIDTH] =   i_tx_pfc[4];
		      assign int_tx_parallel_data[ig][EPRT_TX_PFC5-EHP_PLD_WIDTH] =   i_tx_pfc[5];
		      assign int_tx_parallel_data[ig][EPRT_TX_PFC6-EHP_PLD_WIDTH] =   i_tx_pfc[6];
		      assign int_tx_parallel_data[ig][EPRT_TX_PFC7-EHP_PLD_WIDTH] =   i_tx_pfc[7];

		 //All of the RX Flow control signals are on RX AIB 1, and need the
		 //same treatment as the TX flow control signals on AIB 1 above
		      assign o_rx_pause                      =   int_rx_parallel_data[ig][EPRT_RX_PAUSE-EHP_PLD_WIDTH];
		      assign o_rx_pfc[0]                     =   int_rx_parallel_data[ig][EPRT_RX_PFC0 -EHP_PLD_WIDTH];
		      assign o_rx_pfc[1]                     =   int_rx_parallel_data[ig][EPRT_RX_PFC1 -EHP_PLD_WIDTH];
		      assign o_rx_pfc[2]                     =   int_rx_parallel_data[ig][EPRT_RX_PFC2 -EHP_PLD_WIDTH];
		      assign o_rx_pfc[3]                     =   int_rx_parallel_data[ig][EPRT_RX_PFC3 -EHP_PLD_WIDTH];
		      assign o_rx_pfc[4]                     =   int_rx_parallel_data[ig][EPRT_RX_PFC4 -EHP_PLD_WIDTH];
		      assign o_rx_pfc[5]                     =   int_rx_parallel_data[ig][EPRT_RX_PFC5 -EHP_PLD_WIDTH];
		      assign o_rx_pfc[6]                     =   int_rx_parallel_data[ig][EPRT_RX_PFC6 -EHP_PLD_WIDTH];
		      assign o_rx_pfc[7]                     =   int_rx_parallel_data[ig][EPRT_RX_PFC7 -EHP_PLD_WIDTH];
		      assign o_rx_fcs_error[ig]              =   int_rx_parallel_data[0][EPRT_RX_FCS_ERROR];
		      assign o_rx_error[ig]                  =   int_rx_parallel_data[0][EPRT_RX_ERROR+:2];
		      assign o_rx_status[ig]                 =   int_rx_parallel_data[0][EPRT_RX_STATUS+:3];
		   end // if (ig == 1)
		 else
		   begin
		      assign int_tx_parallel_data[ig][65] = 1'b0;
		      assign int_tx_parallel_data[ig][71] = 1'b0;
		      assign int_tx_parallel_data[ig][72] = 1'b0;
		      assign int_tx_parallel_data[ig][73] = 1'b0;
		      assign int_tx_parallel_data[ig][74] = 1'b0;
		      assign int_tx_parallel_data[ig][75] = 1'b0;
		      assign int_tx_parallel_data[ig][76] = 1'b0;

		      assign o_rx_fcs_error[ig]           = int_rx_parallel_data[2][EPRT_RX_FCS_ERROR];
		      assign o_rx_error[ig]               = int_rx_parallel_data[2][EPRT_RX_ERROR+:2];
		      assign o_rx_status[ig]              = int_rx_parallel_data[2][EPRT_RX_STATUS+:3];

		   end // else: !if(ig == 1)
		 //RX MAC Client Mappings
		 assign o_rx_data[ig]                   =   int_rx_parallel_data[ig][EPRT_RX_DATA+:64];
		 assign o_rx_empty[ig]                  =   int_rx_parallel_data[ig][EPRT_RX_EOP_EMPTY+:3];
		 assign o_rx_inframe[ig]                =   int_rx_parallel_data[ig][EPRT_RX_INFRAME];

    end // else: !PCS_ONLY and !PCS66

	    //TX Deskew markers
            assign int_tx_parallel_data[ig][EPRT_DESKEW]           =   i_tx_aib_dsk[ig];
            //RX Deskew Mappings
	    assign o_rx_aib_dsk[ig]            =   int_rx_parallel_data[ig][EPRT_DESKEW];

          if(ig==0)//condition is to avoid warnings
            begin

	    // Need to assign tx_parallel_data in split form as follows
	    assign {tx_parallel_data[((0*80)+40) +:39], tx_parallel_data[0*80+:39]} = int_tx_parallel_data[0][EHP_AIB_WIDTH-1:0];
	    assign {tx_parallel_data[((1*80)+40) +:39], tx_parallel_data[1*80+:39]} = int_tx_parallel_data[1][EHP_AIB_WIDTH-1:0];
	    assign {tx_parallel_data[((2*80)+40) +:39], tx_parallel_data[2*80+:39]} = int_tx_parallel_data[2][EHP_AIB_WIDTH-1:0];
	    assign {tx_parallel_data[((3*80)+40) +:39], tx_parallel_data[3*80+:39]} = int_tx_parallel_data[3][EHP_AIB_WIDTH-1:0];
	    // For warning free unused data to 0
	    assign tx_parallel_data [(0*80)+79] = 1'b1;
	    assign tx_parallel_data [(1*80)+79] = 1'b1;
	    assign tx_parallel_data [(2*80)+79] = 1'b1;
	    assign tx_parallel_data [(3*80)+79] = 1'b1;
	    assign tx_parallel_data [(0*80)+39] = 1'b0;
	    assign tx_parallel_data [(1*80)+39] = 1'b0;
	    assign tx_parallel_data [(2*80)+39] = 1'b0;
	    assign tx_parallel_data [(3*80)+39] = 1'b0;

// Need to assign rx_parallel_data in split form as follows
	    assign int_rx_parallel_data[0] = {rx_parallel_data[((0*80)+40) +:39], rx_parallel_data[0*80+:39]};
	    assign int_rx_parallel_data[1] = {rx_parallel_data[((1*80)+40) +:39], rx_parallel_data[1*80+:39]};
	    assign int_rx_parallel_data[2] = {rx_parallel_data[((2*80)+40) +:39], rx_parallel_data[2*80+:39]};
	    assign int_rx_parallel_data[3] = {rx_parallel_data[((3*80)+40) +:39], rx_parallel_data[3*80+:39]};

	  end
            assign o_kr_rx_parallel_data[66*(ig + 1)-1:66*ig] = {rx_parallel_data[(80*ig)+33:(80*ig)+32],
                                                             rx_parallel_data[(80*ig)+71:(80*ig)+40],
                                                             rx_parallel_data[(80*ig)+31:80*ig]};
            assign o_kr_rx_data_valid[ig] = rx_parallel_data[(80*ig)+36];

            assign tx_parallel_data_r[ig*80 +: 80] = tx_parallel_data[ig*80 +: 80];

	   end // block: g_ehip_inst
     endgenerate



   generate
     if (core_variant==3 && active_channel==1 && (ehip_mode == "ehip_mac_ptp" || ehip_mode == "ehip_mac_ptp_no_fec") )
        begin
	 for (ii=4; ii<6; ii=ii+1) begin : g_ehip_inst_45
	    //TX Deskew markers
                assign int_tx_parallel_data[ii][EPRT_DESKEW]        =   i_tx_aib_dsk[ii]; //bit 77
            //RX Deskew Mappings
	            assign o_rx_aib_dsk[ii]                             =   int_rx_parallel_data[ii][EPRT_DESKEW];
	   end // block: g_ehip_inst


            assign o_ptp_reading_vl_data_tmp                  =  int_rx_parallel_data[5][75 +:  1];
            assign o_rx_am_tmp[0             +:  4]           =  int_rx_parallel_data[5][71 +:  4];
            assign o_tx_am_tmp[0             +:  4]           =  int_rx_parallel_data[5][67 +:  4];
            assign o_ptp_rx_ts_tmp[17        +: 67]           =  int_rx_parallel_data[5][0  +: 67];
            assign o_ptp_rx_ts_tmp[0         +: 17]           =  int_rx_parallel_data[4][60 +: 17];
            assign o_ptp_tx_ts_valid_tmp[0   +:  4]           =  int_rx_parallel_data[4][56 +:  4];
            assign o_ptp_tx_ts_tmp[0         +: 48]           =  int_rx_parallel_data[4][8  +: 48];
            assign o_ptp_tx_fp_tmp[0         +:  8]           =  int_rx_parallel_data[4][0  +:  8];

            assign o_ptp_rx_ts[0][20:0]   		=  o_ptp_rx_ts_tmp[0   +: 21];
            assign o_ptp_rx_ts[1][20:0]   		=  o_ptp_rx_ts_tmp[21  +: 21];
            assign o_ptp_rx_ts[2][20:0]   		=  o_ptp_rx_ts_tmp[42  +: 21];
            assign o_ptp_rx_ts[3][20:0]   		=  o_ptp_rx_ts_tmp[63  +: 21];
            assign o_rx_am                		=  o_rx_am_tmp[0 +: 4];
            assign o_ptp_reading_vl_data                =  o_ptp_reading_vl_data_tmp;
            assign o_tx_am                		=  o_tx_am_tmp[0 +: 4];
            assign o_ptp_tx_ts_valid     	 	=  o_ptp_tx_ts_valid_tmp[0 +: 4];
            assign o_ptp_tx_ts[0][11:0]      		=  o_ptp_tx_ts_tmp[0 +: 12];
            assign o_ptp_tx_ts[1][11:0]      		=  o_ptp_tx_ts_tmp[12 +: 12];
            assign o_ptp_tx_ts[2][11:0]      		=  o_ptp_tx_ts_tmp[24 +: 12];
            assign o_ptp_tx_ts[3][11:0]      		=  o_ptp_tx_ts_tmp[36 +: 12];
            assign o_ptp_tx_fp[0][1:0]       		=  o_ptp_tx_fp_tmp[0 +: 2];
            assign o_ptp_tx_fp[1][1:0]       		=  o_ptp_tx_fp_tmp[2 +: 2];
            assign o_ptp_tx_fp[2][1:0]       		=  o_ptp_tx_fp_tmp[4 +: 2];
            assign o_ptp_tx_fp[3][1:0]       		=  o_ptp_tx_fp_tmp[6 +: 2];
            assign i_ptp_tx_fp_tmp			= {i_ptp_tx_fp[3][1:0],i_ptp_tx_fp[2][1:0],i_ptp_tx_fp[1][1:0],i_ptp_tx_fp[0][1:0]};
            assign i_ptp_byte_offset_tmp		= {i_ptp_byte_offset[3][2:0],i_ptp_byte_offset[2][2:0],i_ptp_byte_offset[1][2:0],i_ptp_byte_offset[0][2:0]};
            assign i_ptp_ins_type_tmp			= {i_ptp_ins_type[3][2:0],i_ptp_ins_type[2][2:0],i_ptp_ins_type[1][2:0],i_ptp_ins_type[0][2:0]};
            assign i_ptp_ts_tmp				= {i_ptp_ts[3][23:0],i_ptp_ts[2][23:0],i_ptp_ts[1][23:0],i_ptp_ts[0][23:0]};

         // ptp section -- input section
            assign int_tx_parallel_data[4][75         +: 2]      =   2'b00;

            assign int_tx_parallel_data[4][74         +: 1]      =   i_testbus_en;		//1b
            assign int_tx_parallel_data[4][71         +: 3]      =   i_testbus_source[0 +: 3];	//0-2
            assign int_tx_parallel_data[4][47         +: 24]     =   i_ptp_ts_tmp[24 +: 24]; 	//0-23

            assign int_tx_parallel_data[4][45         +: 2]      =   i_ptp_tx_fp_tmp[2 +: 2];
            assign int_tx_parallel_data[4][42         +: 3]      =   i_ptp_byte_offset_tmp[3 +: 3];
            assign int_tx_parallel_data[4][39         +: 3]      =   i_ptp_ins_type_tmp[3 +: 3];

            assign int_tx_parallel_data[4][38             ]      =   1'b0;

            assign int_tx_parallel_data[4][32         +: 6]      =   i_testbus_sel[0 +: 6];	//0-5
            assign int_tx_parallel_data[4][8          +: 24]     =   i_ptp_ts_tmp[0 +: 24];	//0-23

            assign int_tx_parallel_data[4][6          +: 2]      =   i_ptp_tx_fp_tmp[0 +: 2];
            assign int_tx_parallel_data[4][3          +: 3]      =   i_ptp_byte_offset_tmp[0 +: 3];
            assign int_tx_parallel_data[4][0          +: 3]      =   i_ptp_ins_type_tmp[0 +: 3];

            assign int_tx_parallel_data[5][71         +: 6]      =   6'h0;

            assign int_tx_parallel_data[5][47         +: 24]     =   i_ptp_ts_tmp[72 +: 24];	//0-23
            assign int_tx_parallel_data[5][45         +: 2]      =   i_ptp_tx_fp_tmp[6 +: 2];
            assign int_tx_parallel_data[5][42         +: 3]      =   i_ptp_byte_offset_tmp[9 +: 3];
            assign int_tx_parallel_data[5][39         +: 3]      =   i_ptp_ins_type_tmp[9 +: 3];

            assign int_tx_parallel_data[5][38             ]      =   1'b0;

            assign int_tx_parallel_data[5][33         +: 5]      =   i_select_ptp_vl_data[0 +: 5];	//0-4
            assign int_tx_parallel_data[5][32         +: 1]      =   i_read_ptp_vl_data;	//1b
            assign int_tx_parallel_data[5][8          +: 24]     =   i_ptp_ts_tmp[48 +: 24];	//48-71

            assign int_tx_parallel_data[5][6          +: 2]      =   i_ptp_tx_fp_tmp[4 +: 2];
            assign int_tx_parallel_data[5][3          +: 3]      =   i_ptp_byte_offset_tmp[6 +: 3];
            assign int_tx_parallel_data[5][0          +: 3]      =   i_ptp_ins_type_tmp[6 +: 3];
     end // if (ENABLE_PTP)
     endgenerate

     if (core_variant==3 && active_channel==1 && (ehip_mode == "ehip_mac_ptp" || ehip_mode == "ehip_mac_ptp_no_fec"))
     begin
	    assign {tx_parallel_data[((4*80)+40) +:39], tx_parallel_data[4*80+:39]} = int_tx_parallel_data[4][EHP_AIB_WIDTH-1:0];
	    assign {tx_parallel_data[((5*80)+40) +:39], tx_parallel_data[5*80+:39]} = int_tx_parallel_data[5][EHP_AIB_WIDTH-1:0];
     end
     else
     begin
      assign {tx_parallel_data[((4*80)+40) +:39], tx_parallel_data[4*80+:39]} = 'b0;
	    assign {tx_parallel_data[((5*80)+40) +:39], tx_parallel_data[5*80+:39]} = 'b0;
     end

	    assign tx_parallel_data [(4*80)+39] = 1'b0;
	    assign tx_parallel_data [(5*80)+39] = 1'b0;
	    assign tx_parallel_data [(4*80)+79] = 1'b1;
	    assign tx_parallel_data [(5*80)+79] = 1'b1;

	    assign int_rx_parallel_data[4] = {rx_parallel_data[((4*80)+40) +:39], rx_parallel_data[4*80+:39]};
	    assign int_rx_parallel_data[5] = {rx_parallel_data[((5*80)+40) +:39], rx_parallel_data[5*80+:39]};


            assign pp = {tx_parallel_data[5*80 +: 80], tx_parallel_data[4*80 +: 80]};




    genvar                  sli;
    wire [LANES4-1:0]       int_sl_tx_aib_dsk;
    wire [LANES4-1:0]       sl_ptp_tx_ts_valid;
    wire [LANES4*12-1:0]    sl_ptp_tx_ts;
    wire [LANES4*2-1:0]     sl_ptp_tx_ts_fp;
    wire [LANES4*21-1:0]    sl_ptp_rx_ts;
    wire [LANES4-1:0]       sl_tx_am;
    wire [LANES4-1:0]       sl_rx_am;

    wire [SL_LANES-1:0]     sl_tx_dl_async_pulse;
    wire [SL_LANES-1:0]     sl_rx_dl_async_pulse;
    wire [SL_LANES-1:0]     sl_latency_sclk;
    wire [SL_LANES-1:0]     sl_tx_dl_measure_sel;
    wire [SL_LANES-1:0]     sl_rx_dl_measure_sel;

    //generate if(ENABLE_PTP != 0)
    //    begin : PTP_TX_AIB_DSK
            //assign int_sl_tx_aib_dsk[0] = 1'b0;
            //assign int_sl_tx_aib_dsk[1] = i_sl_ptp_tx_aib_dsk[0];
            //assign int_sl_tx_aib_dsk[2] = 1'b0;
            //assign int_sl_tx_aib_dsk[3] = i_sl_ptp_tx_aib_dsk[1];
            assign int_sl_tx_aib_dsk[3:0] = {2{i_sl_ptp_tx_aib_dsk[1:0]}};
    //    end
    //endgenerate

    generate
    if (( core_variant == 0) ||
        ( core_variant == 1) ||
        ((core_variant == 3) && (active_channel == 0)) ||
        ( core_variant == 4) || (core_variant == 5)|| (core_variant == 7)) begin : SL_PARALLEL_DATA

        for(sli = 0; sli < 4; sli++) begin : SL_PARALLEL_DATA_LOOP
            if(sli < SL_LANES) begin : SL_PARALLEL_DATA_SYNTH
                alt_xcvr_resync_std #(
                    .SYNC_CHAIN_LENGTH  (3),
                    .WIDTH              (1),
                    .INIT_VALUE         (0)
                ) sl_rx_aib_reset_sync_inst (
                    .clk                (i_sl_clk_rx[sli]),
                    .reset              (1'b0),
                    .d                  (i_sl_rx_aib_reset[sli]),
                    .q                  (sl_rx_aib_reset_sync_int[sli])
                );

                always @ (posedge i_sl_clk_rx[sli]) begin
                    sl_rx_aib_reset_sync[sli] <= sl_rx_aib_reset_sync_int[sli];
                end

                alt_ehipc3_fm_dp_mux #(
                    .INCLUDE_ALTERNATE_PORTS    (include_alternate_ports_sl_0),
                    .EHIP_MODE                  (ehip_mode_sl_0), // used when INCLUDE_ALTERNATE_PORTS = 0
                    .REGISTER_TX_OUTPUT         (1),
                    .REGISTER_RX_INPUT          (!(ENABLE_PTP && ENABLE_PTP_RX_DESKEW))
                    ) sl_dp_mux (
                    //Clock, reset, and mux select ports
                    .i_sl_clk_tx                (i_sl_clk_tx            [sli]),
                    .i_sl_clk_rx                (i_sl_clk_rx            [sli]),
                    .i_sl_tx_rst_n              (1'b1                        ), // Do not reset TX path for output register, else TX deskew will not work
                    .i_sl_rx_rst_n              (!sl_rx_aib_reset_sync  [sli]),
                    .i_sl_dp_sel                (i_sl_dp_sel            [sli]), // 0=MAC,1=MAC(PTP),2=PCS,3=PCS66(OTN),4=PCS66,else=PMA
                                                                                // used when INCLUDE_ALTERNATE_PORTS = "enable"

                    //Shared TX ports for the MAC, PCS, and PCS66 modes
                    .i_sl_stats_snapshot        (i_sl_stats_snapshot    [sli]),
                    .i_sl_custom_cadence        (i_sl_custom_cadence    [sli]),
                    .i_sl_deskew                (i_sl_tx_aib_dsk        [sli]),

                    // MAC Interface
                    .i_sl_tx_data               (i_sl_tx_data           [sli]),
                    .i_sl_tx_error              (i_sl_tx_error          [sli]),
                    .i_sl_tx_empty              (i_sl_tx_empty          [sli]),
                    .i_sl_tx_skip_crc           (i_sl_tx_skip_crc       [sli]),
                    .i_sl_tx_valid              (i_sl_tx_valid          [sli]),
                    .i_sl_tx_inframe            (i_sl_tx_inframe        [sli]),
                    .o_sl_tx_ready              (),

                    .o_sl_rx_data               (o_sl_rx_data           [sli]),
                    .o_sl_rx_empty              (o_sl_rx_empty          [sli]),
                    .o_sl_rx_fcs_error          (o_sl_rx_fcs_error      [sli]),
                    .o_sl_rx_error              (o_sl_rx_error          [sli]),
                    .o_sl_rx_status             (o_sl_rx_status         [sli]),
                    .o_sl_rx_inframe            (o_sl_rx_inframe        [sli]),
                    .o_sl_rx_valid              (o_sl_rx_valid          [sli]),

                    // PCS Interface
                    .i_sl_tx_mii_d              (i_sl_tx_mii_d          [sli]),
                    .i_sl_tx_mii_c              (i_sl_tx_mii_c          [sli]),
                    .i_sl_tx_mii_valid          (i_sl_tx_mii_valid      [sli]),
                    .i_sl_tx_mii_am             (i_sl_tx_mii_am         [sli]),
                    .o_sl_tx_mii_ready          (o_sl_tx_mii_ready      [sli]),

                    .o_sl_rx_mii_d              (o_sl_rx_mii_d          [sli]),
                    .o_sl_rx_mii_c              (o_sl_rx_mii_c          [sli]),
                    .o_sl_rx_mii_valid          (o_sl_rx_mii_valid      [sli]),
                    .o_sl_rx_mii_am_valid       (o_sl_rx_mii_am_valid   [sli]),

                    // PCS66 Interface
                    .i_sl_tx_pcs66_d            (i_sl_tx_pcs66_d        [sli]),
                    .i_sl_tx_pcs66_valid        (i_sl_tx_pcs66_valid    [sli]),
                    .i_sl_tx_pcs66_am           (i_sl_tx_pcs66_am       [sli]),
                    .o_sl_tx_pcs66_ready        (o_sl_tx_pcs66_ready    [sli]),

                    .o_sl_rx_pcs66_d            (o_sl_rx_pcs66_d        [sli]),
                    .o_sl_rx_pcs66_valid        (o_sl_rx_pcs66_valid    [sli]),
                    .o_sl_rx_pcs66_am_valid     (o_sl_rx_pcs66_am_valid [sli]),

                    // PMA Direct Interface
                    .i_sl_tx_pma                (i_sl_tx_pma            [sli]),
                    .o_sl_rx_pma                (o_sl_rx_pma            [sli]),

                    // AIB Interface
                    .i_aib_rx_data              (sl_rx_parallel_data_dsk[sli]),
                    .o_aib_tx_data              (sl_tx_parallel_data    [sli]),

                    // PTP Interface
                    .i_sl_ptp_sclk              (i_sl_sclk              [sli]),
                    .i_sl_ptp_tx_sel_sclk_return(i_sl_tx_sel_sclk_return[sli]),
                    .i_sl_ptp_rx_sel_sclk_return(i_sl_rx_sel_sclk_return[sli]),
                    .o_sl_ptp_tx_sclk_return    (o_sl_tx_sclk_return    [sli]),
                    .o_sl_ptp_rx_sclk_return    (o_sl_rx_sclk_return    [sli]),

                    // Deterministic Latency Interface
                    .i_sl_latency_sclk          (i_sl_latency_sclk      [sli]),
                    .i_sl_tx_dl_measure_sel     (i_sl_tx_dl_measure_sel [sli]),
                    .i_sl_rx_dl_measure_sel     (i_sl_rx_dl_measure_sel [sli]),
                    .o_sl_tx_dl_async_pulse     (o_sl_tx_dl_async_pulse [sli]),
                    .o_sl_rx_dl_async_pulse     (o_sl_rx_dl_async_pulse [sli]),

                    // Native PHY Interface for DL
                    .o_sl_latency_sclk          (sl_latency_sclk        [sli]),
                    .o_sl_tx_dl_measure_sel     (sl_tx_dl_measure_sel   [sli]),
                    .o_sl_rx_dl_measure_sel     (sl_rx_dl_measure_sel   [sli]),
                    .i_sl_tx_dl_async_pulse     (sl_tx_dl_async_pulse   [sli]),
                    .i_sl_rx_dl_async_pulse     (sl_rx_dl_async_pulse   [sli])
                );

                always @(posedge i_sl_clk_rx[sli]) begin
                    sl_tx_ready_r[sli] <= sl_rx_parallel_data[sli][76];
                    sl_tx_ready_rr[sli] <= sl_tx_ready_r[sli];
                    sl_tx_ready_rrr[sli] <= sl_tx_ready_rr[sli];
                end

                assign o_sl_tx_ready[sli]                     = sl_tx_ready_rrr[sli];

                assign o_sl_rx_aib_dsk[sli]                   = sl_rx_parallel_data[sli][78];
                assign o_sl_rx_aib_dsk_done[sli]              = sl_rx_aib_dsk_done;

                // PTP Interface
                // TX PTP
                assign sl_ptp_tx_parallel_data[sli][39]       = 1'b0;
                assign sl_ptp_tx_parallel_data[sli][38]       = int_sl_tx_aib_dsk[sli];
                assign sl_ptp_tx_parallel_data[sli][37:32]    = 6'h0;
                assign sl_ptp_tx_parallel_data[sli][31:8]     = i_sl_ptp_ts[sli];
                assign sl_ptp_tx_parallel_data[sli][7:6]      = i_sl_ptp_tx_fp[sli];
                assign sl_ptp_tx_parallel_data[sli][5:3]      = i_sl_ptp_byte_offset[sli];
                assign sl_ptp_tx_parallel_data[sli][2:0]      = i_sl_ptp_ins_type[sli];

                assign nphy_sl_ptp_tx_parallel_data[sli]      = sl_ptp_tx_parallel_data[sli];

                // RX PTP
                //assign sl_ptp_rx_parallel_data[sli] = nphy_ptp_rx_parallel_data[sli[1]][(sli[0]+1)*40-1:sli[0]*40];

                assign o_sl_ptp_tx_ts_valid[sli]    = sl_ptp_tx_ts_valid[(LOCATION_SEL+sli)];
                assign o_sl_ptp_tx_ts[sli]          = sl_ptp_tx_ts[(LOCATION_SEL+sli)*12 +: 12];
                assign o_sl_ptp_tx_ts_fp[sli]       = sl_ptp_tx_ts_fp[(LOCATION_SEL+sli)*2 +: 2];
                assign o_sl_ptp_rx_ts[sli]          = sl_ptp_rx_ts[(LOCATION_SEL+sli)*21 +: 21];
                assign o_sl_tx_am[sli]              = sl_tx_am[(LOCATION_SEL+sli)];
                assign o_sl_rx_am[sli]              = sl_rx_am[(LOCATION_SEL+sli)];

            end
            else begin : SL_PARALLEL_DATA_UNUSED
                assign nphy_sl_ptp_tx_parallel_data [sli]     = {1'b0, i_sl_tx_aib_dsk[0], 38'h0};
                //assign nphy_ptp_tx_parallel_data[sli[1]][(sli[0]+1)*40-1:sli[0]*40] = {1'b0, i_sl_tx_aib_dsk[0], 38'h0};
            end
        end

        for (i=0; i<LANES2; i++) begin : GEN_NPHY_PTP_TX_PARALLEL_DATA_LOOP
            always @(posedge ptp_ch_hr_clk) begin
                if (LOCATION_SEL == 3)
                    nphy_ptp_tx_parallel_data[i][79:0] <= {nphy_sl_ptp_tx_parallel_data[3-(i*2+1)][39:0],nphy_sl_ptp_tx_parallel_data[3-(i*2)][39:0]};
                else if (LOCATION_SEL == 2)
                    nphy_ptp_tx_parallel_data[i][79:0] <= {nphy_sl_ptp_tx_parallel_data[3-(i*2)][39:0],nphy_sl_ptp_tx_parallel_data[3-(i*2+1)][39:0]};
                else if (LOCATION_SEL == 1)
                    nphy_ptp_tx_parallel_data[i][79:0] <= {nphy_sl_ptp_tx_parallel_data[(i+1)*i][39:0],nphy_sl_ptp_tx_parallel_data[3-(i*2)][39:0]};
                else
                    nphy_ptp_tx_parallel_data[i][79:0] <= {nphy_sl_ptp_tx_parallel_data[(i*2+1)][39:0],nphy_sl_ptp_tx_parallel_data[(i*2)][39:0]};
            end
        end

        always @ (posedge ptp_ch_hr_clk) begin
            sl_rx_aib_reset_all_and <= &sl_rx_aib_reset_sync;
        end
        // RX PTP
        if(ENABLE_PTP && ENABLE_PTP_RX_DESKEW) begin : RX_DESKEW
            alt_ehipc3_fm_rx_deskew #(
                .LANES         (SL_LANES+LANES2),
                .WIDTH         (80),    // Per lane width
                .REGISTER_INPUT (0),
                .REGISTER_OUTPUT(1),
                .SIM_EMULATE   (0)
            ) rx_dsk_inst (
                .i_clk          (ptp_ch_hr_clk),
                .i_reset        (sl_rx_aib_reset_all_and),
                .i_data         ({nphy_ptp_rx_parallel_data,sl_rx_parallel_data}),
                .i_sync_pulse   ({o_sl_ptp_rx_aib_dsk,{SL_LANES{o_sl_ptp_rx_aib_dsk[0]}}}),
                .o_data         ({nphy_ptp_rx_parallel_data_dsk,sl_rx_parallel_data_dsk}),
                .o_deskew_done  (sl_rx_aib_dsk_done)
            );
        end
        else begin
            always @(posedge ptp_ch_hr_clk) begin
                nphy_ptp_rx_parallel_data_r <= nphy_ptp_rx_parallel_data;
            end

            assign sl_rx_parallel_data_dsk = sl_rx_parallel_data;
            assign nphy_ptp_rx_parallel_data_dsk = nphy_ptp_rx_parallel_data_r;
            assign sl_rx_aib_dsk_done = 1'b0;
        end

        assign o_sl_ptp_rx_aib_dsk[1]       = nphy_ptp_rx_parallel_data[1][78];
        assign sl_rx_am[3:0]                = nphy_ptp_rx_parallel_data_dsk[1][75:72];
        assign sl_tx_am[3:0]                = nphy_ptp_rx_parallel_data_dsk[1][71:68];
        assign sl_ptp_rx_ts[83:56]          = nphy_ptp_rx_parallel_data_dsk[1][67:40];
        assign sl_ptp_rx_ts[55:17]          = nphy_ptp_rx_parallel_data_dsk[1][38:0];

        assign o_sl_ptp_rx_aib_dsk[0]       = nphy_ptp_rx_parallel_data[0][78];
        assign sl_ptp_rx_ts[16:0]           = nphy_ptp_rx_parallel_data_dsk[0][77:61];
        assign sl_ptp_tx_ts_valid[3:0]      = nphy_ptp_rx_parallel_data_dsk[0][60:57];
        assign sl_ptp_tx_ts[47:31]          = nphy_ptp_rx_parallel_data_dsk[0][56:40];
        assign sl_ptp_tx_ts[30:0]           = nphy_ptp_rx_parallel_data_dsk[0][38:8];
        assign sl_ptp_tx_ts_fp[7:0]         = nphy_ptp_rx_parallel_data_dsk[0][7:0];
    end
    endgenerate

   assign ehip_tx_data = core_tx_data;
   assign ehip_tx_data_valid = core_tx_data_valid;


   wire ehip_aib_avmm_clk;
   wire [30:0] 			ehip_aib_avmm_in_tohip; // 30 bit wide, [0]=>ehip_avmm_wr, [1]=>rd, [2:22] =>ehip_avmm_address, 23:30 => avmm_wrdata
   wire [9:0] 			ehip_aib_avmm_out_fromhip;// 10 bits o/p, [7:0]=>rddata,  [8] => rddata_valid, [9]=>write_done

   wire [467:0]          i_hip_aib_sync_data;
   wire [LANES4*23-1:0]  i_lane_ptp_rx_ptp_ts;
   wire [LANES4*12-1:0]  i_lane_ptp_tx_ts;
   wire [LANES4*2-1:0]   i_lane_ptp_tx_ts_fp;
   wire [LANES4*1-1:0]   i_lane_ptp_tx_ts_valid;
   wire [LANES4*1-1:0]   i_ptp_fifo_share_rd_en;
   wire [LANES4*1-1:0]   i_ptp_fifo_share_wr_en;
   wire [LANES6-1:0]     i_xcvr_fr_tx_clk;
   wire [LANES4-1: 0] i_shared_clear;
   wire [LANES4-1 :0] i_shared_dsk_done;
   wire [LANES4-1:0] i_elane_am_insert;
   wire [LANES4-1:0] i_elane_am_detect;

   generate
      if ( (core_variant == 2) ||
          ((core_variant == 3) && (active_channel == 1)) ||
          ((core_variant == 3) && (active_channel == 0) && (ENABLE_PTP != 0) )
         ) begin : EHIP_CORE
        if (core_variant == 3 && active_channel == 0) begin
//          case (SL_LANES)
//            1,2,3 : begin
                      assign i_hip_aib_sync_data    = {ehip_aib_sync_data_out[467:312], {((4-SL_LANES-LOCATION_SEL)*78){1'b0}}, ehip_aib_sync_data_out[SL_LANES*78-1:0], {(LOCATION_SEL*78){1'b0}}};
                      assign i_lane_ptp_rx_ptp_ts   = {{((4-SL_LANES-LOCATION_SEL)*23){1'b0}}, ehip_elane_rx_ptp_ts[SL_LANES*23-1:0], {(LOCATION_SEL*23){1'b0}}};
                      assign i_lane_ptp_tx_ts       = {{((4-SL_LANES-LOCATION_SEL)*12){1'b0}}, ehip_elane_ptp_tx_ts[SL_LANES*12-1:0], {(LOCATION_SEL*12){1'b0}}};
                      assign i_lane_ptp_tx_ts_fp    = {{((4-SL_LANES-LOCATION_SEL)*2){1'b0}}, ehip_elane_ptp_tx_ts_fp[SL_LANES*2-1:0], {(LOCATION_SEL*2){1'b0}}};
                      assign i_lane_ptp_tx_ts_valid = {{(4-SL_LANES-LOCATION_SEL){1'b0}}, ehip_elane_ptp_tx_ts_valid[SL_LANES*1-1:0], {LOCATION_SEL{1'b0}}};
                      assign i_ptp_fifo_share_rd_en = {{(4-SL_LANES-LOCATION_SEL){1'b0}}, ehip_elane_ptp_fifo_share_rd_en[SL_LANES*1-1:0], {LOCATION_SEL{1'b0}}};
                      assign i_ptp_fifo_share_wr_en = {{(4-SL_LANES-LOCATION_SEL){1'b0}}, ehip_elane_ptp_fifo_share_wr_en[SL_LANES*1-1:0], {LOCATION_SEL{1'b0}}};
                      assign i_xcvr_fr_tx_clk       = {{(4-SL_LANES-LOCATION_SEL+2){1'b0}}, xcvr_fr_tx_clk[SL_LANES*1-1:0], {LOCATION_SEL{1'b0}}};
	              assign i_shared_clear         = {{(4-SL_LANES-LOCATION_SEL){1'b0}}, ehip_elane_shared_clear[SL_LANES*1-1:0], {LOCATION_SEL{1'b0}}};
	              assign i_shared_dsk_done      = {{(4-SL_LANES-LOCATION_SEL){1'b0}}, ehip_elane_shared_dsk_done[SL_LANES*1-1:0], {LOCATION_SEL{1'b0}}};
	              assign i_elane_am_insert      = {{(4-SL_LANES-LOCATION_SEL){1'b0}}, ehip_elane_am_insert[SL_LANES*1-1:0], {LOCATION_SEL{1'b0}}};
	              assign i_elane_am_detect      = {{(4-SL_LANES-LOCATION_SEL){1'b0}}, ehip_elane_am_detect[SL_LANES*1-1:0], {LOCATION_SEL{1'b0}}};
//                    end
/*            4 : begin
                  assign i_hip_aib_sync_data    = {ehip_aib_sync_data_out[467:312], ehip_aib_sync_data_out[SL_LANES*78-1:0]};
                  assign i_lane_ptp_rx_ptp_ts   = {ehip_elane_rx_ptp_ts[SL_LANES*23-1:0]};
                  assign i_lane_ptp_tx_ts       = {ehip_elane_ptp_tx_ts[SL_LANES*12-1:0]};
                  assign i_lane_ptp_tx_ts_fp    = {ehip_elane_ptp_tx_ts_fp[SL_LANES*2-1:0]};
                  assign i_lane_ptp_tx_ts_valid = {ehip_elane_ptp_tx_ts_valid[SL_LANES*1-1:0]};
                  assign i_ptp_fifo_share_rd_en = {ehip_elane_ptp_fifo_share_rd_en[SL_LANES*1-1:0]};
                  assign i_ptp_fifo_share_wr_en = {ehip_elane_ptp_fifo_share_wr_en[SL_LANES*1-1:0]};
                  assign i_xcvr_fr_tx_clk       = {2'bz, xcvr_fr_tx_clk[SL_LANES*1-1:0]};
	          assign i_shared_clear         = {ehip_elane_shared_clear[SL_LANES*1-1:0]};
	          assign i_shared_dsk_done      = {ehip_elane_shared_dsk_done[SL_LANES*1-1:0]};
	          assign i_elane_am_insert      = {ehip_elane_am_insert[SL_LANES*1-1:0]};
	          assign i_elane_am_detect      = {ehip_elane_am_detect[SL_LANES*1-1:0]};
                end
          endcase*/
        end
        else begin

          assign i_hip_aib_sync_data    = (ENABLE_PTP || ENABLE_PTP_TOG) ? ehip_aib_sync_data_out[LANES6*78-1:0] : { {LANES2{1'b0}}, ehip_aib_sync_data_out[LANES4*78-1:0] };   // alvin: temp fix to expand to 6 lanes
          assign i_lane_ptp_rx_ptp_ts   = ehip_elane_rx_ptp_ts[LANES4*23-1:0];
          assign i_lane_ptp_tx_ts       = ehip_elane_ptp_tx_ts[LANES4*12-1:0];
          assign i_lane_ptp_tx_ts_fp    = ehip_elane_ptp_tx_ts_fp[LANES4*2-1:0];
          assign i_lane_ptp_tx_ts_valid = ehip_elane_ptp_tx_ts_valid[LANES4*1-1:0];
          assign i_ptp_fifo_share_rd_en = ehip_elane_ptp_fifo_share_rd_en[LANES4*1-1:0];
          assign i_ptp_fifo_share_wr_en = ehip_elane_ptp_fifo_share_wr_en[LANES4*1-1:0];
          assign i_xcvr_fr_tx_clk       = xcvr_fr_tx_clk;
          assign i_shared_clear         = ehip_elane_shared_clear[LANES4*1-1:0];
          assign i_shared_dsk_done      = ehip_elane_shared_dsk_done[LANES4*1-1:0];
          assign i_elane_am_insert      = ehip_elane_am_insert[LANES4*1-1:0];
          assign i_elane_am_detect      = ehip_elane_am_detect[LANES4*1-1:0];
        end

   ct3_hssi_ehip_core
	   #(
         .silicon_rev                       (silicon_rev                       ),
	     .func_mode                         (func_mode                         ),
	     .powerdown_mode                    (powerdown_mode                    ),
	     .use_factory_settings              (use_factory_settings              ),
	     .is_usr_avmm                       (is_usr_avmm                       ),
	     .crete_type                        (crete_type                        ),
	     .sup_mode                          (sup_mode                          ),
	     .sim_mode                          (sim_mode                          ),
	     .ehip_type                         (ehip_type                         ),
	     .topology                          (topology                          ),
	     .ehip_mode                         (ehip_mode                         ),
	     .ehip_rate                         (ehip_rate                         ),
	     .link_fault_mode                   (link_fault_mode                   ),
	     .ipg_removed_per_am_period         (ipg_removed_per_am_period         ),
	     .tx_max_frame_size                 (tx_max_frame_size                 ),
	     .tx_vlan_detection                 (tx_vlan_detection                 ),
	     .tx_preamble_passthrough           (tx_preamble_passthrough           ),
	     .tx_ipg_size                       (tx_ipg_size                       ),
	     .rx_max_frame_size                 (rx_max_frame_size                 ),
	     .keep_rx_crc                       (keep_rx_crc                       ),
	     .rx_preamble_passthrough           (rx_preamble_passthrough           ),
	     .rx_length_checking                (rx_length_checking                ),
	     .rx_vlan_detection                 (rx_vlan_detection                 ),
	     .flow_control                      (flow_control                      ),
	     .flow_control_holdoff_mode         (flow_control_holdoff_mode         ),
	     .holdoff_quanta                    (holdoff_quanta                    ),
	     .uniform_holdoff_quanta            (uniform_holdoff_quanta            ),
	     .pause_quanta                      (pause_quanta                      ),
	     .forward_rx_pause_requests         (forward_rx_pause_requests         ),
	     .tx_pause_daddr                    (tx_pause_daddr                    ),
	     .tx_pause_saddr                    (tx_pause_saddr                    ),
	     .rx_pause_daddr                    (rx_pause_daddr                    ),
	     .tx_clock_period                   (tx_clock_period                   ),
	     .rx_clock_period                   (rx_clock_period                   ),
	     .tx_ptp_extra_latency              (tx_ptp_extra_latency              ),
	     .rx_ptp_extra_latency              (rx_ptp_extra_latency              ),
	     .tx_ptp_asym_latency               (tx_ptp_asym_latency               ),
	     .tx_ptp_dp_latency                 (tx_ptp_dp_latency                 ),
	     .rx_ptp_dp_latency                 (rx_ptp_dp_latency                 ),
	     .ptp_debug                         (ptp_debug                         ),
	     .ptp_tx_timestamp_method           (ptp_tx_timestamp_method           ),
	     .ptp_timestamp_format              (ptp_timestamp_format              ),
	     .rx_datapath_soft_rst              (rx_datapath_soft_rst              ),
	     .tx_datapath_soft_rst              (tx_datapath_soft_rst              ),
	     .tx_mac_soft_rst                   (tx_mac_soft_rst                   ),
	     .tx_pcs_soft_rst                   (tx_pcs_soft_rst                   ),
	     .rx_mac_soft_rst                   (rx_mac_soft_rst                   ),
	     .rx_pcs_soft_rst                   (rx_pcs_soft_rst                   ),
	     .tx_am_period                      (tx_am_period                      ),
	     .pfc_holdoff_quanta_0              (pfc_holdoff_quanta_0              ),
	     .pfc_holdoff_quanta_1              (pfc_holdoff_quanta_1              ),
	     .pfc_holdoff_quanta_2              (pfc_holdoff_quanta_2              ),
	     .pfc_holdoff_quanta_3              (pfc_holdoff_quanta_3              ),
	     .pfc_holdoff_quanta_4              (pfc_holdoff_quanta_4              ),
	     .pfc_holdoff_quanta_5              (pfc_holdoff_quanta_5              ),
	     .pfc_holdoff_quanta_6              (pfc_holdoff_quanta_6              ),
	     .pfc_holdoff_quanta_7              (pfc_holdoff_quanta_7              ),
	     .pfc_pause_quanta_0                (pfc_pause_quanta_0                ),
	     .pfc_pause_quanta_1                (pfc_pause_quanta_1                ),
	     .pfc_pause_quanta_2                (pfc_pause_quanta_2                ),
	     .pfc_pause_quanta_3                (pfc_pause_quanta_3                ),
	     .pfc_pause_quanta_4                (pfc_pause_quanta_4                ),
	     .pfc_pause_quanta_5                (pfc_pause_quanta_5                ),
	     .pfc_pause_quanta_6                (pfc_pause_quanta_6                ),
	     .pfc_pause_quanta_7                (pfc_pause_quanta_7                ),
	     .rx_am_interval                    (rx_am_interval                    ),
	     .txmac_saddr                       (txmac_saddr                       ),
	     .source_address_insertion          (source_address_insertion          ),
	     .tx_mac_data_flow                  (tx_mac_data_flow                  ),
	     .tx_pld_fifo_almost_full_level     (tx_pld_fifo_almost_full_level     ),
	     .strict_sfd_checking               (strict_sfd_checking               ),
	     .cfgonly_bypass_select             (cfgonly_bypass_select             ),
	     .force_deskew_done                 (force_deskew_done                 ),
	     .force_hip_ready                   (force_hip_ready                   ),
	     .request_tx_pause                  (request_tx_pause                  ),
	     .reset_rx_stats_parity_error       (reset_rx_stats_parity_error       ),
	     .enable_rx_stats_snapshot          (enable_rx_stats_snapshot          ),
	     .reset_rx_stats                    (reset_rx_stats                    ),

	     .reset_tx_stats_parity_error       (reset_tx_stats_parity_error       ),
	     .enable_tx_stats_snapshot          (enable_tx_stats_snapshot          ),
	     .reset_tx_stats                    (reset_tx_stats                    ),
	     .remove_pads                       (remove_pads                       ),
	     .enforce_max_frame_size            (enforce_max_frame_size            ),
	     .rx_pcs_max_skew                   (rx_pcs_max_skew                   ),
	     .hi_ber_monitor                    (hi_ber_monitor                    ),
	     .check_random_idles                (check_random_idles                ),
	     .am_encoding40g_0                  (am_encoding40g_0                  ),
	     .am_encoding40g_1                  (am_encoding40g_1                  ),
	     .am_encoding40g_2                  (am_encoding40g_2                  ),
	     .am_encoding40g_3                  (am_encoding40g_3                  ),
	     .xus_timer_window                  (xus_timer_window                  ),
	     .ber_invalid_count                 (ber_invalid_count                 ),
	     .force_link_fault_rf               (force_link_fault_rf               ),
	     .disable_link_fault_rf             (disable_link_fault_rf             ),
	     .txcrc_covers_preamble             (txcrc_covers_preamble             ),
	     .rxcrc_covers_preamble             (rxcrc_covers_preamble             ),
	     .deskew_clear                      (deskew_clear                      ),
	     .use_lane_ptp                      (use_lane_ptp                      ),
	     .strict_preamble_checking          (strict_preamble_checking          ),
	     .use_testbus                       (use_testbus                       ),
	     .ehip_clk_sel                      (ehip_clk_sel                      ),
	     .ehip_dist_clk_sel                 (ehip_dist_clk_sel                 ),
	     .fec_dist_clk_sel                  (fec_dist_clk_sel                  ),
	     .use_am_insert                     (use_am_insert                     ),
	     .tx_aib_dp_latency                 (tx_aib_dp_latency                 ),
	     .rx_aib_dp_latency                 (rx_aib_dp_latency                 ),
	     .powermode_dc                      (powermode_dc                      ),
	     .powermode_ac_mac                  (powermode_ac_mac                  ),
	     .powermode_ac_misc                 (powermode_ac_misc                 ),
	     .powermode_ac_pcs                  (powermode_ac_pcs                  ),
	     .powermode_ac_pld                  (powermode_ac_pld                  ),
	     .ehip_clk_hz                       (ehip_clk_hz                       )

	     ) c3_ehip_core_inst
	     (
	      // clocks and resets
	      .i_ehip_clk(ehip_clk),				//as ok done, org://tx_pldpcs_clkout[1]
	      .i_ptp_clk(ptp_clk),					//as ok done  1-b
	      .i_xcvr_fr_tx_clk(i_xcvr_fr_tx_clk),		//as ok, new signal or old signal?

	      // Clock outputs
	      .o_ehip_clk(o_ehip_clk),				//as ok 1-b
	      .o_ehip_dist_fr_rx_clk(o_ehip_dist_fr_rx_clk),	//1-b. 6_pk.v: o_n_ehip_dist_fr_rx_clk[5:0]=>i_adapt_rxchnl_rx_ehip_frd_clk, i_adapt_rxchnl_[0:5]_rx_ehip_frd_clk
	      .o_fec_dist_fr_rx_clk(o_fec_dist_fr_rx_clk),	//1-b. 6_pk.v: i_u_ehip_core_o_fec_dist_fr_rx_clk[5:0] & i_adapt_rxchnl_[0:4]_rx_rsfec_frd_clk
	      .o_tx_rst_n(h2a_tx_ehip_rst_n),	      	     	//as ok. 1-b ACK signal for ehip_tx_rst_n
	      .o_rx_rst_n(h2a_rx_ehip_rst_n),	             	//as ok. 1-b ACK signal for ehip_rx_rst_n
	      .o_rst_n(h2a_ehip_rst_n),	                     	//as ok. 1-b ACK port for eth_rst_n ACK signal for ehip_rst_n, this is late add and not there in the current drop
	      .o_fec_tx_data(core_tx_data),			//as ok
	      .o_fec_tx_data_valid(core_tx_data_valid),		//as ok 4b, 66-b per valid
	      .o_fec_tx_data_am_valid(core_tx_data_am_valid),  //as ok 4b
	      .i_fec_rx_data(core_rx_data),			//as ok 264b
	      .i_fec_rx_data_am_valid(core_rx_data_am_valid),	//as ok
	      .i_fec_rx_data_valid(core_rx_data_valid),		//as ok

	      // AIB Interface
	      .i_hip_aib_status(a2h_hip_aib_status_all),		//as ok, 18-b
	      .i_hip_aib_sync_data(i_hip_aib_sync_data),		//as ok done, 468b = 6*78
	      .o_hip_aib_sync_data(ehip_aib_sync_data_in[LANES6*78-1:0]),	//as ok

	      // AIB SSR/FSR Inputs - From Native PHY IP
	      .i_rst_n(a2h_rst_n),        	//as ok. 1-b. From native PHY IP (connect to Reset controller (ehip_rst_n_in))
              .i_tx_rst_n(a2h_tx_rst_n),     	//as ok.  [0][1] => LANE 0 bit 1 From native PHy IP (Reset controller (ehip_tx_rst_n_in))
              .i_rx_rst_n(a2h_rx_rst_n),    	//as ok. From native PHy IP (Reset controller (ehip_rx_rst_n_in))
              .i_pld_ready(a2h_pld_ready),    	//as ok. from Native PHY (reset controller (ehip_pld_ready_in))
              .i_signal_ok(a2h_signal_ok),     	//as ok. 1-b from Native PHY (reset controller (ehip_signal_ok_in))
              .i_clear_internal_err(a2h_clear_internal_err),  //as ok

	      // SSR/FSR outputs - To Native PHy IP
              .o_hip_ready(h2a_hip_ready),
              .o_rx_am_lock(h2a_rx_am_lock),		//as ok
              .o_rx_block_lock(h2a_rx_block_lock),	//as ok
              .o_rx_dsk_done(h2a_rx_dsk_done),	//as ok
              .o_remote_fault(h2a_remote_fault),	//as ok
              .o_local_fault(h2a_local_fault),	//as ok.  Move to ch1 --> back to ch0 ssr
              .o_cfg_load_done(h2a_cfg_load_done),	//as ok.
              .o_hi_ber(h2a_hi_ber),		//as ok
              .o_rx_pcs_fully_aligned(h2a_rx_pcs_fully_aligned), //as ok

	      //.i_ext_testbus(120'h0),  		//as ok. 120-b ?? ignore?
              .i_ext_testbus(),
	      .i_shared_clear(i_shared_clear),			//as ok 4b
	      .i_shared_dsk_done(i_shared_dsk_done),			//as ok 4b
	      .o_async_rx_rst_n(async_rx_ehip_rst_n),   //as ok. to PCS I/F
	      .o_async_tx_rst_n(async_tx_ehip_rst_n),   //as ok. to PCS I/F

	      .o_ptp_mac_tx_fp(elane_ehip_ptp_mac_tx_fp[LANES4*2-1:0]), //as ok 8b
	      .o_ptp_mac_ts(elane_ehip_ptp_mac_ts[LANES4*24-1:0]),			//as ok 96b
	      .o_ptp_mac_ins_type(elane_ehip_ptp_mac_ins_type[LANES4*3-1:0]),		//as ok 12b
	      .o_ptp_mac_byte_offset(elane_ehip_ptp_mac_byte_offset[LANES4*3-1:0]),		//as ok 12b

	      .o_ptp_deskewed_tx_fp( elane_ehip_ptp_deskewed_tx_fp[LANES4*2-1:0] ),		//as ok 8b
	      .o_ptp_deskewed_ts( elane_ehip_ptp_deskewed_ts[LANES4*24-1:0] ),			//as ok 96b
	      .o_ptp_deskewed_ins_type( elane_ehip_ptp_deskewed_ins_type[LANES4*3-1:0] ),		//as ok 12b
	      .o_ptp_deskewed_byte_offset(elane_ehip_ptp_deskewed_byte_offset[LANES4*3-1:0]),	//as ok 12b
	      .o_ptp_lane_deskew_got_marker( elane_ehip_ptp_lane_deskew_got_marker[LANES4*1-1:0] ),	//as ok 4b
	      .o_ptp_lane_deskew_tap_sel_one_hot( elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LANES4*6-1:0] ),	//as ok 24b
	      .o_ptp_lane_deskew_deskew_marker( elane_ehip_ptp_lane_deskew_deskew_marker[LANES4*1-1:0] ),	//as ok 4b

              // No PTP in C2E so connect it to 0
              .i_lane_ptp_rx_ptp_ts( i_lane_ptp_rx_ptp_ts ),		// 92b, rx time stmp(align with sop), spec is 96b.
              .i_lane_ptp_tx_ts(i_lane_ptp_tx_ts),			//48b, tx time stmp. spec is 96b
              .i_lane_ptp_tx_ts_fp(i_lane_ptp_tx_ts_fp),		//8b, finger print. tx. ehip fs have the spec
              .i_lane_ptp_tx_ts_valid(i_lane_ptp_tx_ts_valid),	//4b, 4lanes
              .i_ptp_fifo_share_rd_en(i_ptp_fifo_share_rd_en),	//4b,
              .i_ptp_fifo_share_wr_en(i_ptp_fifo_share_wr_en),	//4b
              .i_elane_am_detect(i_elane_am_detect),			//4b
              .i_elane_am_insert(i_elane_am_insert),			//4b


// AVMM Interface
              // synthesis translate_off

              .i_config_avmm_clk(ehip_aib_avmm_clk)   ,  	//as ok 1-b
              .i_config_avmm_rst_n(1'b0),  	//as ok 1-b
              .i_user_mode    (1'b1),				//as ok.

              .i_config_avmm_addr_id(6'd0),			//as ok 6-b
              .i_config_avmm_wr(55'd0),				//as ok 55-b

	      // synthesis translate_on

              .i_user_avmm_wr(ehip_aib_avmm_in_tohip),  	// 30 bit wide, [0]=>ehip_avmm_wr, [1]=>rd, [2:22] =>ehip_avmm_address, 23:30 => avmm_wrdata
              .o_user_avmm_rd(ehip_aib_avmm_out_fromhip),	//as ok. 10 bitso/p, [7:0]=>rddata,  [8] => rddata_valid, [9]=>write_done
	      .i_user_avmm_rst_n(i_user_avmm_rst_n), 		//as ok.
	      .avmmclk( pll_avmm_clk ),  			//as ok. .i_user_avmm_clk(ehip_aib_avmm_clk),
	      .avmmwrite(),					//as ok.
	      .avmmread(),					//as ok.
              .avmmaddress(),					//as ok. 10-b .i_config_avmm_addr_id(6'd0), ?? tide to 0
              .avmmwritedata(),					//as ok. 8-b
              .avmmreaddata(),					//as ok.

//  --------- new signal not exist in c4 but exist in the internal_wys_
	      .i_user_avmm_clk (ehip_aib_avmm_clk), 		//pll_avmm_clk),  in  1 bit
	      .blockselect (),					//out 1 bit
	      .o_cfgonly_use_testbus (),			//out 1 bit
	      .o_config_avmm_rd (),				//out 35 bit
	      .o_testbus_sel()					//out 6 bit

	      );
    end
    else begin
        assign o_ehip_clk = 1'b0;
        assign o_ehip_dist_fr_rx_clk = 1'b0;
        assign o_fec_dist_fr_rx_clk = 1'b0;
        assign h2a_rx_ehip_rst_n = 1'b0;
        assign elane_ehip_ptp_mac_tx_fp = '0;
        assign elane_ehip_ptp_mac_ts = '0;
        assign elane_ehip_ptp_mac_ins_type = '0;
        assign elane_ehip_ptp_mac_byte_offset = '0;
        assign elane_ehip_ptp_deskewed_tx_fp = '0;
        assign elane_ehip_ptp_deskewed_ts = '0;
        assign elane_ehip_ptp_deskewed_ins_type = '0;
        assign elane_ehip_ptp_deskewed_byte_offset = '0;
        assign elane_ehip_ptp_lane_deskew_got_marker = '0;
        assign elane_ehip_ptp_lane_deskew_tap_sel_one_hot = '0;
        assign elane_ehip_ptp_lane_deskew_deskew_marker = '0;
        assign ehip_aib_sync_data_in = '0;
        assign core_tx_data_valid = '0;
        assign core_tx_data = '0;
    end
    endgenerate


// Do we need these??
   // PCS IF to PCS ech 0,1,2,3 --> ch 0, 1, 3, 4

   //Ch*: to indicate which channel of tiles (its range is 0 to 5)
   // X2y: to indicate the source of the signal and whether it is input or output. E.g: h2p indicates that this signal is an output from ehip_top to PCS channel while a2h implies the signal is an input from AIB adapter to ehip_top


   // AVMM2 ATOM instantiation
    generate
    if ( (core_variant == 2) ||
       ((core_variant == 3) && (active_channel == 1)) ||
       ((core_variant == 3) && (active_channel == 0) && (ENABLE_PTP != 0)) ) begin : AVMM2

        ct3_xcvr_avmm2_core_ip
        #(
          .avmm_interfaces		(1),		//Number of AVMM interfaces required - one for each bonded_lane, PLL, and Master CGB
          .rcfg_enable 			(0),		//Enable/disable reconfig interface in the Native PHY or PLL IP
          .silicon_rev			(silicon_rev), 	//"14nm5bcr3a",             //Virtual.
          .topology 			((topology == "ehip_4ch_kpfec") ? "ehip_4ch_fec" : topology),	// RBC bug workaround
          .func_mode 			("C3ADPT_EHIP"),	//= "not_used",
          .pldadapt_hip_mode 		("user_chnl"),	//PLD Adapt.  To be set by PCIe HIP IP. Indicates if the PCIe HIP is enabled. Valid values:disable_hip,user_chnl,debug_chnl
          .c3adapt_avmm_osc_clock_setting (),  		//HSSI Adapt. Internal oscilator division factor. Common param for AVMM1 and AVMM2 interfaces in hardware, modelled in both the atoms. Valid values:osc_clk_div_by1,osc_clk_div_by2,osc_clk_div_by4
          .pldadapt_avmm_osc_clock_setting("osc_clk_div_by1"),	//PLD Adapt.  Internal oscilator division factor. Common param for AVMM1 and AVMM2 interfaces in hardware, modelled in both the atoms. Valid values:osc_clk_div_by1,osc_clk_div_by2,osc_clk_div_by4
          .c3adapt_avmm_testbus_sel 	(),		//HSSI Adapt. Selects the testmux in the HSSI adapter.Common param for AVMM1 and AVMM2 interfaces in hardware, modelled in both the atoms. Valid values:avmm1_transfer_testbus,avmm2_transfer_testbus,avmm_clk_dcg_testbus,avmm1_cmn_intf_testbus
          .pldadapt_avmm_testbus_sel 	(),       	//PLD Adapt.  Selects the testmux in the PLD adapter.Common param for AVMM1 and AVMM2 interfaces in hardware, modelled in both the atoms. Valid values:avmm1_transfer_testbus,avmm2_transfer_testbus,unused_testbus,avmm1_cmn_intf_testbus
          .pldadapt_gate_dis 		()             //PLD Adapt.  Indicates if AVMM1 write/read/request is gated.
        ) ct3_xcvr_avmm2_inst (
          // AVMM slave interface signals (user)
         .avmm_clk		(i_ehip_reconfig_clk),	//in
         .avmm_reset		(i_xcvr_reconfig_reset),			//in
         .avmm_writedata	(i_ehip_reconfig_writedata),			//in
         .avmm_address		(i_ehip_reconfig_address),			//in //TODO - 9 or 10 bits?
         .avmm_write		(i_ehip_reconfig_write),			//in
         .avmm_read		(i_ehip_reconfig_read),			//in
         .avmm_readdata		(o_ehip_reconfig_readdata),			//out
         .avmm_waitrequest	(o_ehip_reconfig_waitrequest),			//out
							  //AVMM interface busy with calibration
         .avmm_busy		(),			//out

          // Debug port from hdpldadapt_avmm
         .pld_hssi_osc_transfer_en(),	//out

         .avmm_clkchnl( pll_avmm_clk ),		//out, connect to adapter and ehip

          // EHIP AVMM signals
         .ehip_usr_clk		(ehip_aib_avmm_clk),		//out
         .ehip_usr_read		(ehip_aib_avmm_in_tohip[29]),		//out
         .ehip_usr_addr		(ehip_aib_avmm_in_tohip[28:8]),		//out
         .ehip_usr_wdata	(ehip_aib_avmm_in_tohip[7:0]),	//out
         .ehip_usr_write	(ehip_aib_avmm_in_tohip[30]),		//out
         .ehip_usr_wrdone	(ehip_aib_avmm_out_fromhip[0]),		//in
         .ehip_usr_rdata	(ehip_aib_avmm_out_fromhip[9:2]),	//in
         .ehip_usr_rdatavld	(ehip_aib_avmm_out_fromhip[1])		//in
        );
    end
    else begin
        assign o_ehip_reconfig_waitrequest = 1'b0;
        assign o_ehip_reconfig_readdata = '0;
    end
    endgenerate

    generate
      //for (sli=0; sli<SL_LANES; sli++) begin : SL_NPHY
       if (( (core_variant == 0) ||
             (core_variant == 1) ||
            ((core_variant == 3) && (active_channel == 0)) ||
             (core_variant == 4) || (core_variant == 5) || (core_variant == 7)) &&
           ((ENABLE_RSFEC == 0) && (ENABLE_RSFEC_MODE == 0))
           ) begin : SL_NPHY // Single Lane

            assign ehip_clk = 1'b0; /*ehip_aib_tx_transfer_div2_clk[0];*/
            assign elane_ehip_shared_clk = {LANES6{o_ehip_clk}};

            `ifdef ALTERA_RESERVED_QIS
                alt_ehipc3_fm_nphy_elane altera_xcvr_native_inst (
            `else
                alt_ehipc3_fm_nphy_elane_sim altera_xcvr_native_inst (
            `endif

                    .aib_ehip_rx_ehip_clk                       ({SL_LANES{o_ehip_clk}}),                     //input,   width = 1,
                    .aib_ehip_rx_ehip_fr_clk                    ({SL_LANES{o_ehip_dist_fr_rx_clk}}),                     //input,   width = 1,
                    .aib_ehip_rx_fec_fr_clk                     ({SL_LANES{o_fec_dist_fr_rx_clk}}),                      //input,   width = 1,
                    .aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[LOCATION_SEL*78+:SL_LANES*78]),            //input,  width = 78,
                    .aib_ehip_tx_ehip_clk                       ({SL_LANES{o_ehip_clk}}),                     //input,   width = 1,

                    .ehip_aib_aib_status                        (a2h_hip_aib_status[SL_LANES*3-1:0]),                  //output,   width = 3,
                    .ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[SL_LANES*78-1:0]),            //output,  width = 78,
                    .ehip_aib_tx_transfer_div2_clk              (ehip_aib_tx_transfer_div2_clk),                                      //output,   width = 1,
                    .ehip_elane_am_detect                       (ehip_elane_am_detect[SL_LANES-1:0]),             //input,   width = 1,
                    .ehip_elane_am_insert                       (ehip_elane_am_insert[SL_LANES-1:0]),             //input,   width = 1,
                    .ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[SL_LANES-1:0]),         //input,   width = 1,
                    .ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[SL_LANES-1:0]),         //input,   width = 1,
                    .ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[SL_LANES*12-1:0]),             //input,  width = 12,
                    .ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[SL_LANES*2-1:0]),                 //input,   width = 2,
                    .ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[SL_LANES-1:0]),              //input,   width = 1,
                    .ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[SL_LANES*23-1:0]),             //input,  width = 23,
                    .ehip_elane_shared_clear                    (ehip_elane_shared_clear[SL_LANES-1:0]),                 //input,   width = 1,
                    .ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[SL_LANES-1:0]),              //input,   width = 1,

                    .ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[SL_LANES-1:0]),                              //output,   width = 1,
                    .ehip_pmaRsfec_fec_rx_data                  (),                                //output,  width = 66
                    .ehip_pmaRsfec_fec_rx_data_am_valid         (),                                //output,  width = 1
                    .ehip_pmaRsfec_fec_rx_data_valid            (),                                //output,  width = 1

                    .elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LOCATION_SEL*3+:SL_LANES*3]),        //output,   width = 3,
                    .elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LOCATION_SEL*3+:SL_LANES*3]),               //output,   width = 3,
                    .elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LOCATION_SEL*24+:SL_LANES*24]),                //output,  width = 24,
                    .elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LOCATION_SEL*2+:SL_LANES*2]),              //output,   width = 2,
                    .elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LOCATION_SEL+:SL_LANES]),   //output,   width = 1,
                    .elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LOCATION_SEL+:SL_LANES]),      //output,   width = 1,
                    .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LOCATION_SEL*6+:SL_LANES*6]), //output,   width = 6,
                    .elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LOCATION_SEL*3+:SL_LANES*3]),             //output,   width = 3,
                    .elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LOCATION_SEL*3+:SL_LANES*3]),                //output,   width = 3,
                    .elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LOCATION_SEL*24+:SL_LANES*24]),            //output,  width = 24,
                    .elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LOCATION_SEL*2+:SL_LANES*2]),                   //output,   width = 2,
                    .elane_ehip_shared_clk                      (elane_ehip_shared_clk[LOCATION_SEL+:SL_LANES]),            //output,   width = 1,

                    .enh_clear_internal_error                   (i_sl_clear_internal_err),                    //input,   width = 1,
                    .enh_force_rcfg_reset                       (i_sl_force_rcfg_reset),                     //input,   width = 1,
                    .enh_initialized                            (o_sl_cfg_load_done),                          //output,   width = 1,
                    .enh_internal_error                         (o_sl_internal_err),                       //output,   width = 1,
                    .enh_pld_ready                              (i_sl_ehip_pld_ready),                    //input,   width = 1,
                    .enh_ready                                  (o_sl_ehip_ready),                        //output,   width = 1,
                    .enh_reset                                  (~i_sl_ehip_reset),                        //input,   width = 1,
                    .enh_reset_stat                             (o_sl_ehip_reset_stat),                   //output,   width = 1,
                    .hip_aib_fsr_in                             (hip_aib_fsr_in[SL_LANES*4-1:0]),
                    .hip_aib_ssr_in                             (hip_aib_ssr_in[SL_LANES*40-1:0]),
                    .latency_sclk                               (sl_latency_sclk),                               //                               latency_sclk.latency_sclk
                    .osc_transfer_en                            (),                                  //output,   width = 1,
                    .pll_refclk0                                (sl_refclk[0]),                              //input,   width = 1,
                    .pll_refclk1                                (sl_refclk[1]),                              //input,   width = 1,
                    .pll_refclk2                                (sl_refclk[2]),                              //input,   width = 1,
                    .pll_refclk3                                (sl_refclk[3]),                              //input,   width = 1,
                    .pll_refclk4                                (sl_refclk[4]),                              //input,   width = 1,
                    .pma_ehip_rx_ehip_clk_div2                  (),                                //input,   width =
                    .pma_ehip_rx_ehip_fifo_rst_n                ({SL_LANES{h2a_rx_ehip_rst_n}}),                     //input,   width = 1,
                    .pma_ehip_tx_ehip_clk_div2                  (),                                //input,   width = 1
                    .pmaRsfec_ehip_tx_ehip_data                 (),                                //input,   width = 66
                    .pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),                                //input,   width = 1
                    .pmaRsfec_ehip_tx_ehip_dv                   (),                                //input,   width = 1
                    .pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),                                //input,   width = 1

                    .reconfig_clk                               ({SL_LANES{i_reconfig_clk}}),                     //input,   width = 1,
                    .reconfig_reset                             ({SL_LANES{i_xcvr_reconfig_reset}}),                   //input,   width = 1,
                    .reconfig_address                           (i_xcvr_reconfig_address),             //input,  width = 20,
                    .reconfig_write                             (i_xcvr_reconfig_write),                   //input,   width = 1,
                    .reconfig_read                              (i_xcvr_reconfig_read),                    //input,   width = 1,
                    .reconfig_writedata                         (i_xcvr_reconfig_writedata),           //input,  width = 32,
                    .reconfig_readdata                          (o_xcvr_reconfig_readdata),            //output,  width = 32,
                    .reconfig_waitrequest                       (o_xcvr_reconfig_waitrequest),             //output,   width = 1,

                    .RSFEC_ehip_clock                           (o_ehip_clk),                                //input, width=1;
                    .RSFEC_ehip_tx_adpt_clock                   (),                                //input, width=1;

                    .rx_aib_reset                               (i_sl_rx_aib_reset),                             //input,   width = 1,
                    .rx_clkout                                  (rx_clkout[MAX_XCVR_CH-1:0]),                                //output,   width = 1,
                    .rx_clkout2                                 (rx_clkout2[MAX_XCVR_CH-1:0]),                               //output,   width = 1,
                    .rx_coreclkin                               (sl_rx_coreclkin),                         //input,   width = 1,
                    .rx_dl_async_pulse                          (sl_rx_dl_async_pulse),                          //                          rx_dl_async_pulse.rx_dl_async_pulse
                    .rx_dl_measure_sel                          (sl_rx_dl_measure_sel),                          //                          rx_dl_measure_sel.rx_dl_measure_sel
                    .rx_enh_aligned                             (o_sl_rx_pcs_fully_aligned),                           //output,   width = 1,
                    .rx_enh_blk_lock                            (o_sl_rx_block_lock),                          //output,   width = 1,
                    .rx_enh_highber                             (o_sl_rx_hi_ber),                           //output,   width = 1,
                    .rx_enh_local_fault                         (o_sl_local_fault_status),                       //output,   width = 1,
                    .rx_enh_pause                               (o_sl_rx_pause),                             //output,   width = 1,
                    .rx_enh_pfc                                 (o_sl_rx_pfc),                               //output,   width = 8,
                    .rx_enh_pmaif_fifo_overflow                 (o_sl_xcvr_rxfifo_overflow),                         //output,   width = 1,
                    .rx_enh_remote_fault                        (o_sl_remote_fault_status),                      //output,   width = 1,
                    .rx_enh_reset                               (~i_sl_ehip_rx_reset),                        //input,   width = 1,
                    .rx_enh_reset_stat                          (o_sl_ehip_rx_reset_stat),                        //output,   width = 1,
                    .rx_enh_signal_ok                           (i_sl_ehip_signal_ok),                         //input,   width = 1,
                    .rx_fifo_empty                              (o_sl_aib_rxfifo_empty),
                    .rx_fifo_pfull                              (o_sl_aib_rxfifo_pfull),
                    .rx_fifo_full                               (o_sl_aib_rxfifo_full),
                    .rx_fifo_pempty                             (o_sl_aib_rxfifo_pempty),
                    .rx_fifo_ready                              (o_sl_rx_fifo_ready),                            //output,   width = 1,
                    .rx_fifo_rd_en                              (i_sl_aib_rxfifo_rd_en),
                    .rx_fifo_latency_adj_ena                    (i_sl_aib_rxfifo_latency_adj_ena),
                    .rx_is_lockedtodata                         (o_sl_rx_is_lockedtodata),               //output,   width = 1,
                    .rx_parallel_data                           (sl_rx_parallel_data),                 //output,  width = 80,
                    .rx_pma_ready                               (o_sl_rx_pma_ready),                     //output,   width = 1,
                    .rx_pmaif_reset                             (i_sl_rx_pmaif_reset),                           //input,   width = 1,
                    .rx_serial_data                             (i_rx_serial_data),                           //input,   width = 1,
                    .rx_serial_data_n                           (i_rx_serial_data_n),                         //input,   width = 1,
                    .rx_transfer_ready                          (sl_rx_transfer_ready),                //output,   width = 1,
                    .tx_aib_reset                               (i_sl_tx_aib_reset),                             //input,   width = 1,
                    .tx_clkout                                  (tx_clkout[MAX_XCVR_CH-1:0]),                                //output,   width = 1,
                    .tx_clkout2                                 (tx_clkout2[MAX_XCVR_CH-1:0]),                               //output,   width = 1,
                    .tx_coreclkin                               (sl_tx_coreclkin),                         //input,   width = 1,
                    .tx_coreclkin2                              (sl_tx_coreclkin2),                               //   input,    width = 1,                               tx_coreclkin.clk
                    .tx_dl_async_pulse                          (sl_tx_dl_async_pulse),                          //                          tx_dl_async_pulse.tx_dl_async_pulse
                    .tx_dl_measure_sel                          (sl_tx_dl_measure_sel),                          //                          tx_dl_measure_sel.tx_dl_measure_sel
                    .tx_dll_lock                                (o_sl_tx_dll_lock),                      //output,   width = 1,
                    .tx_enh_pause                               (i_sl_tx_pause),                     //input,   width = 1,
                    .tx_enh_pfc                                 (i_sl_tx_pfc),                       //input,   width = 8,
                    .tx_enh_pmaif_fifo_almost_empty             (o_sl_xcvr_txfifo_pempty),            //output,   width = 1,
                    .tx_enh_pmaif_fifo_almost_full              (o_sl_xcvr_txfifo_pfull),             //output,   width = 1,
                    .tx_enh_pmaif_fifo_overflow                 (o_sl_xcvr_txfifo_overflow),                //output,   width = 1,
                    .tx_enh_pmaif_fifo_underflow                (o_sl_xcvr_txfifo_underflow),               //output,   width = 1,
                    .tx_enh_reset                               (~i_sl_ehip_tx_reset),                     //input,   width = 1,
                    .tx_enh_reset_stat                          (o_sl_ehip_tx_reset_stat),                //output,   width = 1,
                    .tx_fifo_empty                              (o_sl_aib_txfifo_empty),
                    .tx_fifo_full                               (o_sl_aib_txfifo_full),
                    .tx_fifo_pempty                             (o_sl_aib_txfifo_pempty),
                    .tx_fifo_pfull                              (o_sl_aib_txfifo_pfull),
                    .tx_fifo_ready                              (o_sl_tx_fifo_ready),                    //output,   width = 1,
                    .tx_parallel_data                           (sl_tx_parallel_data),                 //input,  width = 80,
                    .tx_pma_ready                               (sl_tx_pma_ready),                     //output,   width = 1,
                    .tx_pmaif_reset                             (i_sl_tx_pmaif_reset),                   //input,   width = 1,
                    .tx_serial_data                             (o_tx_serial_data),                   //output,   width = 1,
                    .tx_serial_data_n                           (o_tx_serial_data_n),                                 //output,   width = 1,
                    .tx_transfer_ready                          (sl_tx_transfer_ready)                 //output,   width = 1,
                );

                assign rx_is_lockedtodata = '0;
                assign rx_parallel_data = '0;
                assign rx_pma_ready = '0;
                assign tx_pma_ready = '0;
                assign core_rx_data_valid = '0;
                assign core_rx_data_am_valid = '0;
                assign core_rx_data = '0;
                assign o_rx_transfer_ready = '0;
                assign o_tx_transfer_ready = '0;

        end // Single Lane
      //end
        else
      //for (sli=0; sli<SL_LANES; sli++) begin : SL_NPHY_RSFEC
       if (( (core_variant == 0) ||
             (core_variant == 1) ||
            ((core_variant == 3) && (active_channel == 0)) ||
             (core_variant == 4) || (core_variant == 5) || (core_variant == 7)) &&
           ((ENABLE_RSFEC != 0) || (ENABLE_RSFEC_MODE != 0))
          ) begin : SL_NPHY_RSFEC // Single Lane

            assign ehip_clk = 1'b0; /*ehip_aib_tx_transfer_div2_clk[0];*/
            assign elane_ehip_shared_clk = {LANES6{o_ehip_clk}};

            assign sl_rsfec_not_align[0] = o_rsfec_channel_ssr[8*LOCATION_SEL+2];
            assign sl_rsfec_not_align[1] = o_rsfec_channel_ssr[8*1+2];
            assign sl_rsfec_not_align[2] = o_rsfec_channel_ssr[8*2+2];
            assign sl_rsfec_not_align[3] = o_rsfec_channel_ssr[8*3+2];

            for (sli=0; sli<SL_LANES; sli++) begin : SL_NPHY_RSFEC_SIGNAL_OK_CH
               assign sl_rsfec_signal_ok[sli+FIRST_LANE] = o_sl_rx_is_lockedtodata[sli] && sl_rsfec_o_fec_ready;
               assign sl_ehip_signal_ok[sli] = i_sl_enable_rsfec[sli] ? (i_sl_ehip_signal_ok[sli] && !sl_rsfec_not_align[sli+FIRST_LANE]) : i_sl_ehip_signal_ok[sli];
            end
            for (sli=0; sli<FIRST_LANE; sli++) begin : SL_NPHY_RSFEC_SIGNAL_OK_UNUSED
               assign sl_rsfec_signal_ok[sli] = 1'b1;
            end

            for (sli=FIRST_LANE+SL_LANES; sli<4; sli++) begin : SL_NPHY_RSFEC_SIGNAL_OK_UNUSED1
                assign sl_rsfec_signal_ok[sli] = 1'b1;
            end

            // The tx_pma_ready should be based on the primary clock source for multi-channel design
            // For PTP case, it is distributed from PTP channel-0.
            // For non-PTP case, the distribution depends on selection passed down to Native PHY.
            assign sl_rsfec_clock_stable = ENABLE_PTP ? ECORE_5432_TIEOFF? sl_ptp_tx_pma_ready[1] : sl_ptp_tx_pma_ready[0] : sl_tx_pma_ready[0];

            alt_xcvr_resync_std #(
                .SYNC_CHAIN_LENGTH  (3),
                .WIDTH              (1),
                .INIT_VALUE         (0)
            ) sl_rsfec_clock_stable_sync_inst (
                .clk                (i_reconfig_clk),
                .reset              (1'b0),
                .d                  (sl_rsfec_clock_stable),
                .q                  (sl_rsfec_clock_stable_sync)
            );


            alt_xcvr_resync_std #(
                .SYNC_CHAIN_LENGTH  (3),
                .WIDTH              (LANES4),
                .INIT_VALUE         (0)
            ) sl_rsfec_not_align_sync_inst (
                .clk                (i_reconfig_clk),
                .reset              (1'b0),
                .d                  (sl_rsfec_not_align),
                .q                  (sl_rsfec_not_align_sync)
            );

            always @(posedge i_reconfig_clk) begin
                if(~(&sl_rsfec_not_align_sync)) begin
                    sl_rsfec_reset_assert_locked <= 1'b1;
                end
                else begin
                    sl_rsfec_reset_assert_locked <= 1'b0;
                end
            end

            always @(posedge i_reconfig_clk) begin
                if(!sl_rsfec_clock_stable_sync) begin
                    sl_rsfec_reset_state <= STM_SL_RSFEC_RESET_INIT;
                end
                else begin
                    sl_rsfec_reset_state <= sl_rsfec_reset_nextstate;
                end
            end

            always @(*) begin
                case(sl_rsfec_reset_state)
                    STM_SL_RSFEC_RESET_INIT        : sl_rsfec_reset_nextstate = (&sl_rsfec_reset_count) ? STM_SL_RSFEC_RX_RESET_ASSERT : STM_SL_RSFEC_RESET_INIT;
                    STM_SL_RSFEC_RX_RESET_ASSERT   : sl_rsfec_reset_nextstate = (&sl_rsfec_reset_count) ? STM_SL_RSFEC_TX_RESET_ASSERT : STM_SL_RSFEC_RX_RESET_ASSERT;
                    STM_SL_RSFEC_TX_RESET_ASSERT   : sl_rsfec_reset_nextstate = (&sl_rsfec_reset_count) ? STM_SL_RSFEC_RESET_ASSERT : STM_SL_RSFEC_TX_RESET_ASSERT;
                    STM_SL_RSFEC_RESET_ASSERT      : sl_rsfec_reset_nextstate = (&sl_rsfec_reset_count) ? STM_SL_RSFEC_RESET_DEASSERT : STM_SL_RSFEC_RESET_ASSERT;
                    STM_SL_RSFEC_RESET_DEASSERT    : sl_rsfec_reset_nextstate = (&sl_rsfec_reset_count) ? STM_SL_RSFEC_TX_RESET_DEASSERT : STM_SL_RSFEC_RESET_DEASSERT;
                    STM_SL_RSFEC_TX_RESET_DEASSERT : sl_rsfec_reset_nextstate = (&sl_rsfec_reset_count) ? STM_SL_RSFEC_RX_RESET_DEASSERT : STM_SL_RSFEC_TX_RESET_DEASSERT;
                    STM_SL_RSFEC_RX_RESET_DEASSERT : sl_rsfec_reset_nextstate = STM_SL_RSFEC_RX_RESET_DEASSERT;
                    default                        : sl_rsfec_reset_nextstate = STM_SL_RSFEC_RESET_INIT;
                endcase
            end

            assign sl_rsfec_reset_count_plus_one = sl_rsfec_reset_count[7:0] + 1'b1;

            always @(posedge i_reconfig_clk) begin
                if(!sl_rsfec_clock_stable_sync | sl_rsfec_reset_assert_locked) begin
                    sl_rsfec_reset_count     <= 8'd0;
                    sl_global_rsfec_reset    <= 1'b0;
                    sl_global_rsfec_tx_reset <= 1'b0;
                    sl_global_rsfec_rx_reset <= 1'b0;
                end
                else begin
                    sl_rsfec_reset_count <= sl_rsfec_reset_count_plus_one[7:0];

                    case(sl_rsfec_reset_state)
                        STM_SL_RSFEC_RESET_INIT : begin
                            sl_global_rsfec_reset    <= 1'b0;
                            sl_global_rsfec_tx_reset <= 1'b0;
                            sl_global_rsfec_rx_reset <= 1'b0;
                        end

                        STM_SL_RSFEC_RX_RESET_ASSERT : begin
                            sl_global_rsfec_reset    <= 1'b0;
                            sl_global_rsfec_tx_reset <= 1'b0;
                            sl_global_rsfec_rx_reset <= 1'b1;
                        end

                        STM_SL_RSFEC_TX_RESET_ASSERT : begin
                            sl_global_rsfec_reset    <= 1'b0;
                            sl_global_rsfec_tx_reset <= 1'b1;
                            sl_global_rsfec_rx_reset <= 1'b1;
                        end

                        STM_SL_RSFEC_RESET_ASSERT : begin
                            sl_global_rsfec_reset    <= 1'b1;
                            sl_global_rsfec_tx_reset <= 1'b1;
                            sl_global_rsfec_rx_reset <= 1'b1;
                        end

                        STM_SL_RSFEC_RESET_DEASSERT : begin
                            sl_global_rsfec_reset    <= 1'b0;
                            sl_global_rsfec_tx_reset <= 1'b1;
                            sl_global_rsfec_rx_reset <= 1'b1;
                        end

                        STM_SL_RSFEC_TX_RESET_DEASSERT : begin
                            sl_global_rsfec_reset    <= 1'b0;
                            sl_global_rsfec_tx_reset <= 1'b0;
                            sl_global_rsfec_rx_reset <= 1'b1;
                        end

                        STM_SL_RSFEC_RX_RESET_DEASSERT : begin
                            sl_global_rsfec_reset    <= 1'b0;
                            sl_global_rsfec_tx_reset <= 1'b0;
                            sl_global_rsfec_rx_reset <= 1'b0;
                        end

                        default: begin
                            sl_global_rsfec_reset    <= 1'b0;
                            sl_global_rsfec_tx_reset <= 1'b0;
                            sl_global_rsfec_rx_reset <= 1'b0;
                        end
                    endcase
                end
            end

            alt_xcvr_resync_std #(
                .SYNC_CHAIN_LENGTH  (3),
                .WIDTH              (SL_LANES),
                .INIT_VALUE         (0)
            ) sl_ehip_pld_ready_sync_inst (
                .clk                (sl_tx_coreclkin[0]),
                .reset              (1'b0),
                .d                  (i_sl_ehip_pld_ready),
                .q                  (sl_ehip_pld_ready_sync)
            );

            always @(posedge sl_tx_coreclkin[0]) begin
                if(!(|sl_ehip_pld_ready_sync)) begin
                    sl_rsfec_pld_ready <= 1'b0;
                end
                else if(&sl_ehip_pld_ready_sync) begin
                    sl_rsfec_pld_ready <= 1'b1;
                end
            end

            `ifdef ALTERA_RESERVED_QIS
                alt_ehipc3_fm_nphy_elane altera_xcvr_native_inst (
            `else
                alt_ehipc3_fm_nphy_elane_sim altera_xcvr_native_inst (
            `endif

                    .aib_ehip_rx_ehip_clk                       ({SL_LANES{o_ehip_clk}}),                     //input,   width = 1,
                    .aib_ehip_rx_ehip_fr_clk                    ({SL_LANES{o_ehip_dist_fr_rx_clk}}),                     //input,   width = 1,
                    .aib_ehip_rx_fec_fr_clk                     ({SL_LANES{o_fec_dist_fr_rx_clk}}),                      //input,   width = 1,
                    .aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[LOCATION_SEL*78+:SL_LANES*78]),            //input,  width = 78,
                    .aib_ehip_tx_ehip_clk                       ({SL_LANES{o_ehip_clk}}),                     //input,   width = 1,

                    .ehip_aib_aib_status                        (a2h_hip_aib_status[SL_LANES*3-1:0]),                  //output,   width = 3,
                    .ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[SL_LANES*78-1:0]),            //output,  width = 78,
                    .ehip_aib_tx_transfer_div2_clk              (ehip_aib_tx_transfer_div2_clk),                                      //output,   width = 1,
                    .ehip_elane_am_detect                       (ehip_elane_am_detect[SL_LANES-1:0]),             //input,   width = 1,
                    .ehip_elane_am_insert                       (ehip_elane_am_insert[SL_LANES-1:0]),             //input,   width = 1,
                    .ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[SL_LANES-1:0]),         //input,   width = 1,
                    .ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[SL_LANES-1:0]),         //input,   width = 1,
                    .ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[SL_LANES*12-1:0]),             //input,  width = 12,
                    .ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[SL_LANES*2-1:0]),                 //input,   width = 2,
                    .ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[SL_LANES-1:0]),              //input,   width = 1,
                    .ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[SL_LANES*23-1:0]),             //input,  width = 23,
                    .ehip_elane_shared_clear                    (ehip_elane_shared_clear[SL_LANES-1:0]),                 //input,   width = 1,
                    .ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[SL_LANES-1:0]),              //input,   width = 1,

                    .ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[SL_LANES-1:0]),                              //output,   width = 1,
                    .ehip_pmaRsfec_fec_rx_data                  (),                                //output,  width = 66
                    .ehip_pmaRsfec_fec_rx_data_am_valid         (),                                //output,  width = 1
                    .ehip_pmaRsfec_fec_rx_data_valid            (),                                //output,  width = 1

                    .elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LOCATION_SEL*3+:SL_LANES*3]),        //output,   width = 3,
                    .elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LOCATION_SEL*3+:SL_LANES*3]),               //output,   width = 3,
                    .elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LOCATION_SEL*24+:SL_LANES*24]),                //output,  width = 24,
                    .elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LOCATION_SEL*2+:SL_LANES*2]),              //output,   width = 2,
                    .elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LOCATION_SEL+:SL_LANES]),   //output,   width = 1,
                    .elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LOCATION_SEL+:SL_LANES]),      //output,   width = 1,
                    .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LOCATION_SEL*6+:SL_LANES*6]), //output,   width = 6,
                    .elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LOCATION_SEL*3+:SL_LANES*3]),             //output,   width = 3,
                    .elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LOCATION_SEL*3+:SL_LANES*3]),                //output,   width = 3,
                    .elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LOCATION_SEL*24+:SL_LANES*24]),            //output,  width = 24,
                    .elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LOCATION_SEL*2+:SL_LANES*2]),                   //output,   width = 2,
                    .elane_ehip_shared_clk                      (elane_ehip_shared_clk[LOCATION_SEL+:SL_LANES]),            //output,   width = 1,

                    .enh_clear_internal_error                   (i_sl_clear_internal_err),                    //input,   width = 1,
                    .enh_force_rcfg_reset                       (i_sl_force_rcfg_reset),                     //input,   width = 1,
                    .enh_initialized                            (o_sl_cfg_load_done),                          //output,   width = 1,
                    .enh_internal_error                         (o_sl_internal_err),                       //output,   width = 1,
                    .enh_pld_ready                              (i_sl_ehip_pld_ready),                    //input,   width = 1,
                    .enh_ready                                  (o_sl_ehip_ready),                        //output,   width = 1,
                    .enh_reset                                  (~i_sl_ehip_reset),                        //input,   width = 1,
                    .enh_reset_stat                             (o_sl_ehip_reset_stat),                   //output,   width = 1,
                    .i_rsfec_pld_ready                          (sl_rsfec_pld_ready),
                    .hip_aib_fsr_in                             (hip_aib_fsr_in[SL_LANES*4-1:0]),
                    .hip_aib_ssr_in                             (hip_aib_ssr_in[SL_LANES*40-1:0]),
                    .latency_sclk                               (sl_latency_sclk),                               //                               latency_sclk.latency_sclk
                    .o_rsfec_channel_ssr                        (o_rsfec_channel_ssr),
                    .osc_transfer_en                            (),                                  //output,   width = 1,
                    .pll_refclk0                                (sl_refclk[0]),                              //input,   width = 1,
                    .pll_refclk1                                (sl_refclk[1]),                              //input,   width = 1,
                    .pll_refclk2                                (sl_refclk[2]),                              //input,   width = 1,
                    .pll_refclk3                                (sl_refclk[3]),                              //input,   width = 1,
                    .pll_refclk4                                (sl_refclk[4]),                              //input,   width = 1,
                    .pma_ehip_rx_ehip_clk_div2                  (),                                //input,   width =
                    .pma_ehip_rx_ehip_fifo_rst_n                ({SL_LANES{h2a_rx_ehip_rst_n}}),                     //input,   width = 1,
                    .pma_ehip_tx_ehip_clk_div2                  (),                                //input,   width = 1
                    .pmaRsfec_ehip_tx_ehip_data                 (),                                //input,   width = 66
                    .pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),                                //input,   width = 1
                    .pmaRsfec_ehip_tx_ehip_dv                   (),                                //input,   width = 1
                    .pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),                                //input,   width = 1

                    .reconfig_clk                               ({SL_LANES{i_reconfig_clk}}),                     //input,   width = 1,
                    .reconfig_reset                             ({SL_LANES{i_xcvr_reconfig_reset}}),                   //input,   width = 1,
                    .reconfig_address                           (i_xcvr_reconfig_address),             //input,  width = 20,
                    .reconfig_write                             (i_xcvr_reconfig_write),                   //input,   width = 1,
                    .reconfig_read                              (i_xcvr_reconfig_read),                    //input,   width = 1,
                    .reconfig_writedata                         (i_xcvr_reconfig_writedata),           //input,  width = 32,
                    .reconfig_readdata                          (o_xcvr_reconfig_readdata),            //output,  width = 32,
                    .reconfig_waitrequest                       (o_xcvr_reconfig_waitrequest),             //output,   width = 1,
                    //enable rsfec
                    .reconfig_rsfec_write                       (i_rsfec_reconfig_write),                     //input,   width = 1, //for rsfec enable
                    .reconfig_rsfec_read                        (i_rsfec_reconfig_read),                      //input,   width = 1,
                    .reconfig_rsfec_address                     (i_rsfec_reconfig_addr),                      //input,  width = 11,
                    .reconfig_rsfec_writedata                   (i_rsfec_reconfig_writedata),                 //input,  width = 8,
                    .reconfig_rsfec_readdata                    (o_rsfec_reconfig_readdata),                  //output, width = 8,
                    .reconfig_rsfec_waitrequest                 (o_rsfec_reconfig_waitrequest),                         //output,   width = 1,
                    .reconfig_rsfec_clk                         (i_reconfig_clk),                       //input,   width = 1,
                    .reconfig_rsfec_reset                       (i_xcvr_reconfig_reset),                     //input,   width = 1,

                    .RSFEC_ehip_clock                           (o_ehip_clk),                                //input, width=1;
                    .RSFEC_ehip_tx_adpt_clock                   (i_sl_clk_tx),                                //input, width=1;
                    .rsfec_reset                                (sl_global_rsfec_reset),
                    .rsfec_signal_ok                            (sl_rsfec_signal_ok),
                    .rsfec_usr_avmm2_rst                        (1'b0),
                    .rsfec_o_config_done                        (),
                    .rsfec_o_fec_ready                          (sl_rsfec_o_fec_ready),
                    .rsfec_o_internal_error                     (),
                    .rsfec_o_status_rx_not_align                (),
                    .rsfec_o_status_rx_not_deskew               (),
                    .rsfec_o_tx_dsk_valid                       (),

                    .rx_aib_reset                               (i_sl_rx_aib_reset),                             //input,   width = 1,
                    .rx_clkout                                  (rx_clkout[MAX_XCVR_CH-1:0]),                                //output,   width = 1,
                    .rx_clkout2                                 (rx_clkout2[MAX_XCVR_CH-1:0]),                               //output,   width = 1,
                    .rx_coreclkin                               (sl_rx_coreclkin),                         //input,   width = 1,
                    .rx_dl_async_pulse                          (sl_rx_dl_async_pulse),                          //                          rx_dl_async_pulse.rx_dl_async_pulse
                    .rx_dl_measure_sel                          (sl_rx_dl_measure_sel),                          //                          rx_dl_measure_sel.rx_dl_measure_sel
                    .rx_enh_aligned                             (o_sl_rx_pcs_fully_aligned),                           //output,   width = 1,
                    .rx_enh_blk_lock                            (o_sl_rx_block_lock),                          //output,   width = 1,
                    .rx_enh_highber                             (o_sl_rx_hi_ber),                           //output,   width = 1,
                    .rx_enh_local_fault                         (o_sl_local_fault_status),                       //output,   width = 1,
                    .rx_enh_pause                               (o_sl_rx_pause),                             //output,   width = 1,
                    .rx_enh_pfc                                 (o_sl_rx_pfc),                               //output,   width = 8,
                    .rx_enh_pmaif_fifo_overflow                 (o_sl_xcvr_rxfifo_overflow),                         //output,   width = 1,
                    .rx_enh_remote_fault                        (o_sl_remote_fault_status),                      //output,   width = 1,
                    .rx_enh_reset                               (~i_sl_ehip_rx_reset),                        //input,   width = 1,
                    .rx_enh_reset_stat                          (o_sl_ehip_rx_reset_stat),                        //output,   width = 1,
                    .rx_enh_signal_ok                           (sl_ehip_signal_ok[SL_LANES-1:0]),                         //input,   width = 1,
                    .rx_fifo_empty                              (o_sl_aib_rxfifo_empty),
                    .rx_fifo_pfull                              (o_sl_aib_rxfifo_pfull),
                    .rx_fifo_full                               (o_sl_aib_rxfifo_full),
                    .rx_fifo_pempty                             (o_sl_aib_rxfifo_pempty),
                    .rx_fifo_ready                              (o_sl_rx_fifo_ready),                            //output,   width = 1,
                    .rx_fifo_rd_en                              (i_sl_aib_rxfifo_rd_en),
                    .rx_fifo_latency_adj_ena                    (i_sl_aib_rxfifo_latency_adj_ena),
                    .rx_is_lockedtodata                         (o_sl_rx_is_lockedtodata),               //output,   width = 1,
                    .rx_parallel_data                           (sl_rx_parallel_data),                 //output,  width = 80,
                    .rx_pma_ready                               (o_sl_rx_pma_ready),                     //output,   width = 1,
                    .rx_pmaif_reset                             (i_sl_rx_pmaif_reset),                           //input,   width = 1,
                    .rx_rsfec_reset                             (sl_global_rsfec_rx_reset),
                    .rx_serial_data                             (i_rx_serial_data),                           //input,   width = 1,
                    .rx_serial_data_n                           (i_rx_serial_data_n),                         //input,   width = 1,
                    .rx_transfer_ready                          (sl_rx_transfer_ready),                //output,   width = 1,
                    .tx_aib_reset                               (i_sl_tx_aib_reset),                             //input,   width = 1,
                    .tx_clkout                                  (tx_clkout[MAX_XCVR_CH-1:0]),                                //output,   width = 1,
                    .tx_clkout2                                 (tx_clkout2[MAX_XCVR_CH-1:0]),                               //output,   width = 1,
                    .tx_coreclkin                               (sl_tx_coreclkin),                         //input,   width = 1,
                    .tx_coreclkin2                              (sl_tx_coreclkin2),                               //   input,    width = 2,                               tx_coreclkin.clk
                    .tx_dl_async_pulse                          (sl_tx_dl_async_pulse),                          //                          tx_dl_async_pulse.tx_dl_async_pulse
                    .tx_dl_measure_sel                          (sl_tx_dl_measure_sel),                          //                          tx_dl_measure_sel.tx_dl_measure_sel
                    .tx_dll_lock                                (o_sl_tx_dll_lock),                      //output,   width = 1,
                    .tx_enh_pause                               (i_sl_tx_pause),                     //input,   width = 1,
                    .tx_enh_pfc                                 (i_sl_tx_pfc),                       //input,   width = 8,
                    .tx_enh_pmaif_fifo_almost_empty             (o_sl_xcvr_txfifo_pempty),            //output,   width = 1,
                    .tx_enh_pmaif_fifo_almost_full              (o_sl_xcvr_txfifo_pfull),             //output,   width = 1,
                    .tx_enh_pmaif_fifo_overflow                 (o_sl_xcvr_txfifo_overflow),                //output,   width = 1,
                    .tx_enh_pmaif_fifo_underflow                (o_sl_xcvr_txfifo_underflow),               //output,   width = 1,
                    .tx_enh_reset                               (~i_sl_ehip_tx_reset),                     //input,   width = 1,
                    .tx_enh_reset_stat                          (o_sl_ehip_tx_reset_stat),                //output,   width = 1,
                    .tx_fifo_empty                              (o_sl_aib_txfifo_empty),
                    .tx_fifo_full                               (o_sl_aib_txfifo_full),
                    .tx_fifo_pempty                             (o_sl_aib_txfifo_pempty),
                    .tx_fifo_pfull                              (o_sl_aib_txfifo_pfull),
                    .tx_fifo_ready                              (o_sl_tx_fifo_ready),                    //output,   width = 1,
                    .tx_parallel_data                           (sl_tx_parallel_data),                 //input,  width = 80,
                    .tx_pma_ready                               (sl_tx_pma_ready),                     //output,   width = 1,
                    .tx_pmaif_reset                             (i_sl_tx_pmaif_reset),                   //input,   width = 1,
                    .tx_rsfec_reset                             (sl_global_rsfec_tx_reset),
                    .tx_serial_data                             (o_tx_serial_data),                   //output,   width = 1,
                    .tx_serial_data_n                           (o_tx_serial_data_n),                                 //output,   width = 1,
                    .tx_transfer_ready                          (sl_tx_transfer_ready)                 //output,   width = 1,
                );

                assign rx_is_lockedtodata = '0;
                assign rx_parallel_data = '0;
                assign rx_pma_ready = '0;
                assign tx_pma_ready = '0;
                assign core_rx_data_valid = '0;
                assign core_rx_data_am_valid = '0;
                assign core_rx_data = '0;
                assign o_rx_transfer_ready = '0;
                assign o_tx_transfer_ready = '0;
        end // Single Lane
      //end
        else begin
                assign sl_tx_transfer_ready = '0;
                assign sl_rx_transfer_ready = '0;
                assign o_sl_rx_pcs_fully_aligned = '0;
                assign o_sl_rx_hi_ber = '0;
                assign o_sl_cfg_load_done = '0;
        end
    endgenerate

    generate
        if (((core_variant == 3) && (active_channel == 0)) &&
            (  ENABLE_PTP != 0) &&
            (  USE_PTP_PLLCH == 0)
            ) begin : SL_PTP_NPHY

            assign ptp_clk  = ECORE_5432_TIEOFF ? ptp_ehip_aib_tx_transfer_div2_clk[1] : ptp_ehip_aib_tx_transfer_div2_clk[0];
            assign tx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {tx_clkout_ptp [0],tx_clkout_ptp [1]} : tx_clkout_ptp  : {2{tx_clkout[0]}};
            assign tx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {tx_clkout2_ptp[0],tx_clkout2_ptp[1]} : tx_clkout2_ptp : {2{tx_clkout2[0]}};
            assign rx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {rx_clkout_ptp [0],rx_clkout_ptp [1]} : rx_clkout_ptp  : {2{rx_clkout[0]}};
            assign rx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {rx_clkout2_ptp[0],rx_clkout2_ptp[1]} : rx_clkout2_ptp : {2{rx_clkout2[0]}};
            assign ptp_ch_hr_clk = enable_external_aib_clocking ? i_aib_clk :
                                   USE_PTP_PLLCH                ? ECORE_5432_TIEOFF ? tx_clkout_ptp[1] : tx_clkout_ptp[0] :
                                                                  i_sl_clk_tx[0];
            assign ptp_ch_fr_clk = enable_external_aib_clocking ? i_aib_2x_clk :
                                   USE_PTP_PLLCH                ? ECORE_5432_TIEOFF ? tx_clkout2_ptp[1] : tx_clkout2_ptp[0] :
                                                                  tx_clkout2[0];

		`ifdef ALTERA_RESERVED_QIS
			alt_ehipc3_fm_nphy_elane_ptp nphy_ptp (
		`else
			alt_ehipc3_fm_nphy_elane_ptp_sim nphy_ptp  (
		`endif

                     .aib_ehip_rx_ehip_clk                       ({LANES2{o_ehip_clk}}),                       //   input,    width = 2,                       aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
                     .aib_ehip_rx_ehip_fr_clk                    ({LANES2{o_ehip_dist_fr_rx_clk}}),                    //   input,    width = 2,                    aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
                     .aib_ehip_rx_fec_fr_clk                     ({LANES2{o_fec_dist_fr_rx_clk}}),                     //   input,    width = 2,                     aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
                     .aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*4]),                      //   input,  width = 156,                      aib_ehip_rx_sync_data.aib_ehip_rx_sync_data
                     .aib_ehip_tx_ehip_clk                       ({LANES2{o_ehip_clk}}),                       //   input,    width = 2,                       aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
                     .ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1:0]),                        //  output,    width = 6,                        ehip_aib_aib_status.ehip_aib_aib_status
                     .ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*4]),                      //  output,  width = 156,                      ehip_aib_tx_sync_data.ehip_aib_tx_sync_data
                     .ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk),              //  output,    width = 2,              ehip_aib_tx_transfer_div2_clk.ehip_aib_tx_transfer_div2_clk
                     .ehip_elane_am_detect                       (),                       //  output,    width = 2,                       ehip_elane_am_detect.ehip_elane_am_detect
                     .ehip_elane_am_insert                       (),                       //  output,    width = 2,                       ehip_elane_am_insert.ehip_elane_am_insert
                     .ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_rd_en.ehip_elane_ptp_fifo_share_rd_en
                     .ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_wr_en.ehip_elane_ptp_fifo_share_wr_en
                     .ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,                       ehip_elane_ptp_tx_ts.ehip_elane_ptp_tx_ts
                     .ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,                    ehip_elane_ptp_tx_ts_fp.ehip_elane_ptp_tx_ts_fp
                     .ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,                 ehip_elane_ptp_tx_ts_valid.ehip_elane_ptp_tx_ts_valid
                     .ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,                       ehip_elane_rx_ptp_ts.ehip_elane_rx_ptp_ts
                     .ehip_elane_shared_clear                    (),                    //  output,    width = 2,                    ehip_elane_shared_clear.ehip_elane_shared_clear
                     .ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,                 ehip_elane_shared_dsk_done.ehip_elane_shared_dsk_done
                     .ehip_pma_tx_pma_clk                        (),                        //  output,    width = 2,                        ehip_pma_tx_pma_clk.ehip_pma_tx_pma_clk
                     .ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,                  ehip_pmaRsfec_fec_rx_data.ehip_pmaRsfec_fec_rx_data
                     .ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,         ehip_pmaRsfec_fec_rx_data_am_valid.ehip_pmaRsfec_fec_rx_data_am_valid
                     .ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,            ehip_pmaRsfec_fec_rx_data_valid.ehip_pmaRsfec_fec_rx_data_valid
                     .elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,        elane_ehip_ptp_deskewed_byte_offset.elane_ehip_ptp_deskewed_byte_offset
                     .elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,           elane_ehip_ptp_deskewed_ins_type.elane_ehip_ptp_deskewed_ins_type
                     .elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,                 elane_ehip_ptp_deskewed_ts.elane_ehip_ptp_deskewed_ts
                     .elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,              elane_ehip_ptp_deskewed_tx_fp.elane_ehip_ptp_deskewed_tx_fp
                     .elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,   elane_ehip_ptp_lane_deskew_deskew_marker.elane_ehip_ptp_lane_deskew_deskew_marker
                     .elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,      elane_ehip_ptp_lane_deskew_got_marker.elane_ehip_ptp_lane_deskew_got_marker
                     .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12, elane_ehip_ptp_lane_deskew_tap_sel_one_hot.elane_ehip_ptp_lane_deskew_tap_sel_one_hot
                     .elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,             elane_ehip_ptp_mac_byte_offset.elane_ehip_ptp_mac_byte_offset
                     .elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,                elane_ehip_ptp_mac_ins_type.elane_ehip_ptp_mac_ins_type
                     .elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,                      elane_ehip_ptp_mac_ts.elane_ehip_ptp_mac_ts
                     .elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,                   elane_ehip_ptp_mac_tx_fp.elane_ehip_ptp_mac_tx_fp
                     .elane_ehip_shared_clk                      (elane_ehip_shared_clk[5:4]),                      //   input,    width = 2,                      elane_ehip_shared_clk.elane_ehip_shared_clk
                     .enh_clear_internal_error                   (),                   //   input,    width = 2,                   enh_clear_internal_error.enh_clear_internal_error
                     .enh_force_rcfg_reset                       (),                       //   input,    width = 2,                       enh_force_rcfg_reset.enh_force_rcfg_reset
                     .enh_initialized                            (),                            //  output,    width = 2,                            enh_initialized.enh_initialized
                     .enh_internal_error                         (),                         //  output,    width = 2,                         enh_internal_error.enh_internal_error
                     .enh_pld_ready                              (),                              //   input,    width = 2,                              enh_pld_ready.enh_pld_ready
                     .enh_ready                                  (),                                  //  output,    width = 2,                                  enh_ready.enh_ready
                     .enh_reset                                  (),                                  //   input,    width = 2,                                  enh_reset.enh_reset
                     .enh_reset_stat                             (),                             //  output,    width = 2,                             enh_reset_stat.enh_reset_stat
                     .hip_aib_fsr_in                             (),                             //                             hip_aib_fsr_in.hip_aib_fsr_in
                     .hip_aib_ssr_in                             (),                             //                             hip_aib_ssr_in.hip_aib_ssr_in
                     .osc_transfer_en                            (),                            //  output,    width = 2,                            osc_transfer_en.osc_transfer_en
                     .pma_ehip_rx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_rx_ehip_clk_div2.pma_ehip_rx_ehip_clk_div2
                     .pma_ehip_rx_ehip_fifo_rst_n                (),                //   input,    width = 2,                pma_ehip_rx_ehip_fifo_rst_n.pma_ehip_rx_ehip_fifo_rst_n
                     .pma_ehip_tx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_tx_ehip_clk_div2.pma_ehip_tx_ehip_clk_div2
                     .pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,                 pmaRsfec_ehip_tx_ehip_data.pmaRsfec_ehip_tx_ehip_data
                     .pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,     pmaRsfec_ehip_tx_ehip_data_am_valid_in.pmaRsfec_ehip_tx_ehip_data_am_valid_in
                     .pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,                   pmaRsfec_ehip_tx_ehip_dv.pmaRsfec_ehip_tx_ehip_dv
                     .pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,           pmaRsfec_ehip_tx_ehip_fifo_rst_n.pmaRsfec_ehip_tx_ehip_fifo_rst_n
                     .reconfig_clk                               ({LANES2{i_reconfig_clk}}),                               //   input,    width = 2,                               reconfig_clk.clk
                     .reconfig_reset                             ({LANES2{i_xcvr_reconfig_reset}}),                             //   input,    width = 2,                             reconfig_reset.reset
                     .reconfig_write                             (i_ptp_reconfig_write[LANES2-1:0]),                             //   input,    width = 2,                              reconfig_avmm.write
                     .reconfig_read                              (i_ptp_reconfig_read[LANES2-1:0]),                              //   input,    width = 2,                                           .read
                     .reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:0]),                           //   input,   width = 11**,                                           .address
                     .reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:0]),                         //   input,   width = 64,                                           .writedata
                     .reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:0]),                          //  output,   width = 64,                                           .readdata
                     .reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1:0]),                       //  output,    width = 2,                                           .waitrequest
                     .RSFEC_ehip_clock                           (),                           //   input,    width = 1,                           RSFEC_ehip_clock.RSFEC_ehip_clock
                     .RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,                   RSFEC_ehip_tx_adpt_clock.RSFEC_ehip_tx_adpt_clock
                     .rx_aib_reset                               ({2{&i_sl_rx_aib_reset}}),                               //   input,    width = 2,                               rx_aib_reset.rx_aib_reset
                     .rx_clkout                                  (rx_clkout_ptp),                                  //  output,    width = 2,                                  rx_clkout.clk
                     .rx_clkout2                                 (rx_clkout2_ptp),                                 //                                 rx_clkout2.clk
                     .rx_coreclkin                               ({LANES2{ptp_ch_hr_clk}}),                               //   input,    width = 2,                               rx_coreclkin.clk
                     .rx_enh_aligned                             (),                             //  output,    width = 2,                             rx_enh_aligned.rx_enh_aligned
                     .rx_enh_blk_lock                            (),                            //  output,    width = 2,                            rx_enh_blk_lock.rx_enh_blk_lock
                     .rx_enh_highber                             (),                             //  output,    width = 2,                             rx_enh_highber.rx_enh_highber
                     .rx_enh_local_fault                         (),                         //  output,    width = 2,                         rx_enh_local_fault.rx_enh_local_fault
                     .rx_enh_pause                               (),                               //  output,    width = 2,                               rx_enh_pause.rx_enh_pause
                     .rx_enh_pfc                                 (),                                 //  output,   width = 16,                                 rx_enh_pfc.rx_enh_pfc
                     .rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 rx_enh_pmaif_fifo_overflow.rx_enh_pmaif_fifo_overflow
                     .rx_enh_remote_fault                        (),                        //  output,    width = 2,                        rx_enh_remote_fault.rx_enh_remote_fault
                     .rx_enh_reset                               (),                               //   input,    width = 2,                               rx_enh_reset.rx_enh_reset
                     .rx_enh_reset_stat                          (),                          //  output,    width = 2,                          rx_enh_reset_stat.rx_enh_reset_stat
                     .rx_enh_signal_ok                           (),                           //   input,    width = 2,                           rx_enh_signal_ok.rx_enh_signal_ok
                     .rx_fifo_ready                              (),                              //  output,    width = 2,                              rx_fifo_ready.rx_fifo_ready
                     //.rx_fifo_latency_adj_ena                    (i_sl_ptp_aib_rxfifo_latency_adj_ena),
                     .rx_parallel_data                           (nphy_ptp_rx_parallel_data),                           //  output,  width = 160,                           rx_parallel_data.rx_parallel_data
                     .rx_pma_ready                               (sl_ptp_rx_pma_ready),                               //  output,    width = 2,                               rx_pma_ready.rx_pma_ready
                     .rx_pmaif_reset                             (),                             //   input,    width = 2,                             rx_pmaif_reset.rx_pmaif_reset
                     .rx_transfer_ready                          (sl_ptp_rx_transfer_ready),                          //  output,    width = 2,                          rx_transfer_ready.rx_transfer_ready
                     .tx_aib_reset                               ({2{&i_sl_tx_aib_reset}}),                                //   input,    width = 2,                               tx_aib_reset.tx_aib_reset
                     .tx_clkout                                  (tx_clkout_ptp),                                  //  output,    width = 2,                                  tx_clkout.clk
                     .tx_clkout2                                 (tx_clkout2_ptp),                                 //                                 tx_clkout2.clk
                     .tx_coreclkin                               ({LANES2{ptp_ch_hr_clk}}),                               //   input,    width = 2,                               tx_coreclkin.clk
                     .tx_coreclkin2                              ({LANES2{ptp_ch_fr_clk}}),                               //   input,    width = 2,                               tx_coreclkin.clk
                     .tx_dll_lock                                (),                                //  output,    width = 2,                                tx_dll_lock.tx_dll_lock
                     .tx_enh_pause                               (),                               //   input,    width = 2,                               tx_enh_pause.tx_enh_pause
                     .tx_enh_pfc                                 (),                                 //   input,   width = 16,                                 tx_enh_pfc.tx_enh_pfc
                     .tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,             tx_enh_pmaif_fifo_almost_empty.tx_enh_pmaif_fifo_almost_empty
                     .tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,              tx_enh_pmaif_fifo_almost_full.tx_enh_pmaif_fifo_almost_full
                     .tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 tx_enh_pmaif_fifo_overflow.tx_enh_pmaif_fifo_overflow
                     .tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,                tx_enh_pmaif_fifo_underflow.tx_enh_pmaif_fifo_underflow
                     .tx_enh_reset                               (),                               //   input,    width = 2,                               tx_enh_reset.tx_enh_reset
                     .tx_enh_reset_stat                          (),                          //  output,    width = 2,                          tx_enh_reset_stat.tx_enh_reset_stat
                     .tx_fifo_ready                              (),                              //  output,    width = 2,                              tx_fifo_ready.tx_fifo_ready
                     .tx_parallel_data                           (nphy_ptp_tx_parallel_data),                           //   input,  width = 160,                           tx_parallel_data.tx_parallel_data
                     .tx_pma_ready                               (sl_ptp_tx_pma_ready),                               //  output,    width = 2,                               tx_pma_ready.tx_pma_ready
                     .tx_pmaif_reset                             (),                             //   input,    width = 2,                             tx_pmaif_reset.tx_pmaif_reset
                     .tx_transfer_ready                          (sl_ptp_tx_transfer_ready)                           //  output,    width = 2,                          tx_transfer_ready.tx_transfer_ready
                 );
                assign o_rx_transfer_ready = '0;
                assign o_tx_transfer_ready = '0;
        end
        else
        if (((core_variant == 3) && (active_channel == 0)) &&
            (  ENABLE_PTP != 0) &&
            (  USE_PTP_PLLCH != 0))
        begin : SL_PTP_NPHY_CHPLL

            assign ptp_clk  = ECORE_5432_TIEOFF ? ptp_ehip_aib_tx_transfer_div2_clk[1] : ptp_ehip_aib_tx_transfer_div2_clk[0];
// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// When PTP channel PLL is turned off, the clock out will be X. So the corresponding clock out at IP level needs to be manually tieoff to prevent X propagation.
// ---------------------------------------------------------------------------------------------------------------------------------
//	      assign tx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {tx_clkout_ptp [0],tx_clkout_ptp [1]} : tx_clkout_ptp  : {2{tx_clkout[0]}};
//            assign tx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {tx_clkout2_ptp[0],tx_clkout2_ptp[1]} : tx_clkout2_ptp : {2{tx_clkout2[0]}};
//            assign rx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {rx_clkout_ptp [0],rx_clkout_ptp [1]} : rx_clkout_ptp  : {2{rx_clkout[0]}};
//            assign rx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {rx_clkout2_ptp[0],rx_clkout2_ptp[1]} : rx_clkout2_ptp : {2{rx_clkout2[0]}};
            assign tx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {1'b0, tx_clkout_ptp[1] } : {1'b0, tx_clkout_ptp[0] } : {2{tx_clkout[0]}};
            assign tx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {1'b0, tx_clkout2_ptp[1]} : {1'b0, tx_clkout2_ptp[0]} : {2{tx_clkout2[0]}};
            assign rx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {1'b0, rx_clkout_ptp[1] } : {1'b0, rx_clkout_ptp[0] } : {2{rx_clkout[0]}};
            assign rx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = USE_PTP_PLLCH ? ECORE_5432_TIEOFF ? {1'b0, rx_clkout2_ptp[1]} : {1'b0, rx_clkout2_ptp[0]} : {2{rx_clkout2[0]}};
// ---------------------------------------------------------------------------------------------------------------------------------
            assign ptp_ch_hr_clk = enable_external_aib_clocking ? i_aib_clk :
                                   USE_PTP_PLLCH                ? ECORE_5432_TIEOFF ? tx_clkout_ptp[1] : tx_clkout_ptp[0] :
                                                                  i_sl_clk_tx[0];
            assign ptp_ch_fr_clk = enable_external_aib_clocking ? i_aib_2x_clk :
                                   USE_PTP_PLLCH                ? ECORE_5432_TIEOFF ? tx_clkout2_ptp[1] : tx_clkout2_ptp[0] :
                                                                  tx_clkout2[0];

// ---------------------------------------------------------------------------------------------------------------------------------
// 22/Aug/2019 : HSD#1409425013 : With right NPHY setting, transfer_ready is up and therefore no longer need the remapping.
// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// When PLL is OFF, tx_transfer_ready will not up. So, we have to rely on tx_dll_lock instead to indicate AIB is ready.
// So, have to remap sl_ptp_tx/rx_transfer_ready.
// ---------------------------------------------------------------------------------------------------------------------------------
	    wire [LANES2-1:0]	sl_ptp_tx_transfer_ready_int;
	    wire [LANES2-1:0]	sl_ptp_rx_transfer_ready_int;
	    wire 		sl_ptp_plloff_tx_dll_lock;
//	    assign sl_ptp_tx_transfer_ready = ECORE_5432_TIEOFF ? {sl_ptp_tx_transfer_ready_int[1], sl_ptp_plloff_tx_dll_lock} : {sl_ptp_plloff_tx_dll_lock, sl_ptp_tx_transfer_ready_int[0]};
//	    assign sl_ptp_rx_transfer_ready = ECORE_5432_TIEOFF ? {sl_ptp_rx_transfer_ready_int[1], sl_ptp_plloff_tx_dll_lock} : {sl_ptp_plloff_tx_dll_lock, sl_ptp_rx_transfer_ready_int[0]};
	    assign sl_ptp_tx_transfer_ready = sl_ptp_tx_transfer_ready_int;
	    assign sl_ptp_rx_transfer_ready = sl_ptp_rx_transfer_ready_int;
// ---------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// Creating 2 PTP channels separately with different PLL setting.
// When EHIP_LOCATION_0/2, select PTP_CH[1] to turnoff the PLL.
// When EHIP_LOCATION_1/3, select PTP_CH[0] to turnoff the PLL.
// ---------------------------------------------------------------------------------------------------------------------------------
//            `ifdef ALTERA_RESERVED_QIS
//                alt_ehipc3_fm_nphy_elane_ptp nphy_ptp (
//            `else
//                alt_ehipc3_fm_nphy_elane_ptp_sim nphy_ptp (
//            `endif
//
//                .aib_ehip_rx_ehip_clk                       ({LANES2{o_ehip_clk}}),                       //   input,    width = 2,                       aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
//                .aib_ehip_rx_ehip_fr_clk                    ({LANES2{o_ehip_dist_fr_rx_clk}}),                    //   input,    width = 2,                    aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
//                .aib_ehip_rx_fec_fr_clk                     ({LANES2{o_fec_dist_fr_rx_clk}}),                     //   input,    width = 2,                     aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
//                .aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*4]),                      //   input,  width = 156,                      aib_ehip_rx_sync_data.aib_ehip_rx_sync_data
//                .aib_ehip_tx_ehip_clk                       ({LANES2{o_ehip_clk}}),                       //   input,    width = 2,                       aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
//                .ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1:0]),                        //  output,    width = 6,                        ehip_aib_aib_status.ehip_aib_aib_status
//                .ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*4]),                      //  output,  width = 156,                      ehip_aib_tx_sync_data.ehip_aib_tx_sync_data
//                .ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk),              //  output,    width = 2,              ehip_aib_tx_transfer_div2_clk.ehip_aib_tx_transfer_div2_clk
//                .ehip_elane_am_detect                       (),                       //  output,    width = 2,                       ehip_elane_am_detect.ehip_elane_am_detect
//                .ehip_elane_am_insert                       (),                       //  output,    width = 2,                       ehip_elane_am_insert.ehip_elane_am_insert
//                .ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_rd_en.ehip_elane_ptp_fifo_share_rd_en
//                .ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_wr_en.ehip_elane_ptp_fifo_share_wr_en
//                .ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,                       ehip_elane_ptp_tx_ts.ehip_elane_ptp_tx_ts
//                .ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,                    ehip_elane_ptp_tx_ts_fp.ehip_elane_ptp_tx_ts_fp
//                .ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,                 ehip_elane_ptp_tx_ts_valid.ehip_elane_ptp_tx_ts_valid
//                .ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,                       ehip_elane_rx_ptp_ts.ehip_elane_rx_ptp_ts
//                .ehip_elane_shared_clear                    (),                    //  output,    width = 2,                    ehip_elane_shared_clear.ehip_elane_shared_clear
//                .ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,                 ehip_elane_shared_dsk_done.ehip_elane_shared_dsk_done
//                .ehip_pma_tx_pma_clk                        (),                        //  output,    width = 2,                        ehip_pma_tx_pma_clk.ehip_pma_tx_pma_clk
//                .ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,                  ehip_pmaRsfec_fec_rx_data.ehip_pmaRsfec_fec_rx_data
//                .ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,         ehip_pmaRsfec_fec_rx_data_am_valid.ehip_pmaRsfec_fec_rx_data_am_valid
//                .ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,            ehip_pmaRsfec_fec_rx_data_valid.ehip_pmaRsfec_fec_rx_data_valid
//                .elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,        elane_ehip_ptp_deskewed_byte_offset.elane_ehip_ptp_deskewed_byte_offset
//                .elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,           elane_ehip_ptp_deskewed_ins_type.elane_ehip_ptp_deskewed_ins_type
//                .elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,                 elane_ehip_ptp_deskewed_ts.elane_ehip_ptp_deskewed_ts
//                .elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,              elane_ehip_ptp_deskewed_tx_fp.elane_ehip_ptp_deskewed_tx_fp
//                .elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,   elane_ehip_ptp_lane_deskew_deskew_marker.elane_ehip_ptp_lane_deskew_deskew_marker
//                .elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,      elane_ehip_ptp_lane_deskew_got_marker.elane_ehip_ptp_lane_deskew_got_marker
//                .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12, elane_ehip_ptp_lane_deskew_tap_sel_one_hot.elane_ehip_ptp_lane_deskew_tap_sel_one_hot
//                .elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,             elane_ehip_ptp_mac_byte_offset.elane_ehip_ptp_mac_byte_offset
//                .elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,                elane_ehip_ptp_mac_ins_type.elane_ehip_ptp_mac_ins_type
//                .elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,                      elane_ehip_ptp_mac_ts.elane_ehip_ptp_mac_ts
//                .elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,                   elane_ehip_ptp_mac_tx_fp.elane_ehip_ptp_mac_tx_fp
//                .elane_ehip_shared_clk                      (elane_ehip_shared_clk[5:4]),                      //   input,    width = 2,                      elane_ehip_shared_clk.elane_ehip_shared_clk
//                .enh_clear_internal_error                   (),                   //   input,    width = 2,                   enh_clear_internal_error.enh_clear_internal_error
//                .enh_force_rcfg_reset                       (),                       //   input,    width = 2,                       enh_force_rcfg_reset.enh_force_rcfg_reset
//                .enh_initialized                            (),                            //  output,    width = 2,                            enh_initialized.enh_initialized
//                .enh_internal_error                         (),                         //  output,    width = 2,                         enh_internal_error.enh_internal_error
//                .enh_pld_ready                              (),                              //   input,    width = 2,                              enh_pld_ready.enh_pld_ready
//                .enh_ready                                  (),                                  //  output,    width = 2,                                  enh_ready.enh_ready
//                .enh_reset                                  (),                                  //   input,    width = 2,                                  enh_reset.enh_reset
//                .enh_reset_stat                             (),                             //  output,    width = 2,                             enh_reset_stat.enh_reset_stat
//                .hip_aib_fsr_in                             (),                             //                             hip_aib_fsr_in.hip_aib_fsr_in
//                .hip_aib_ssr_in                             (),                             //                             hip_aib_ssr_in.hip_aib_ssr_in
//                .osc_transfer_en                            (),                            //  output,    width = 2,                            osc_transfer_en.osc_transfer_en
//                .pll_refclk0                                (sl_refclk[0]),                              //input,   width = 1,
//                .pll_refclk1                                (sl_refclk[1]),                              //input,   width = 1,
//                .pll_refclk2                                (sl_refclk[2]),                              //input,   width = 1,
//                .pll_refclk3                                (sl_refclk[3]),                              //input,   width = 1,
//                .pll_refclk4                                (sl_refclk[4]),                              //input,   width = 1,
//                .pma_ehip_rx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_rx_ehip_clk_div2.pma_ehip_rx_ehip_clk_div2
//                .pma_ehip_rx_ehip_fifo_rst_n                (),                //   input,    width = 2,                pma_ehip_rx_ehip_fifo_rst_n.pma_ehip_rx_ehip_fifo_rst_n
//                .pma_ehip_tx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_tx_ehip_clk_div2.pma_ehip_tx_ehip_clk_div2
//                .pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,                 pmaRsfec_ehip_tx_ehip_data.pmaRsfec_ehip_tx_ehip_data
//                .pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,     pmaRsfec_ehip_tx_ehip_data_am_valid_in.pmaRsfec_ehip_tx_ehip_data_am_valid_in
//                .pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,                   pmaRsfec_ehip_tx_ehip_dv.pmaRsfec_ehip_tx_ehip_dv
//                .pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,           pmaRsfec_ehip_tx_ehip_fifo_rst_n.pmaRsfec_ehip_tx_ehip_fifo_rst_n
//                .reconfig_clk                               ({LANES2{i_reconfig_clk}}),                               //   input,    width = 2,                               reconfig_clk.clk
//                .reconfig_reset                             ({LANES2{i_xcvr_reconfig_reset}}),                             //   input,    width = 2,                             reconfig_reset.reset
//                .reconfig_write                             (i_ptp_reconfig_write[LANES2-1:0]),                             //   input,    width = 2,                              reconfig_avmm.write
//                .reconfig_read                              (i_ptp_reconfig_read[LANES2-1:0]),                              //   input,    width = 2,                                           .read
//                .reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:0]),                           //   input,   width = 11**,                                           .address
//                .reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:0]),                         //   input,   width = 64,                                           .writedata
//                .reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:0]),                          //  output,   width = 64,                                           .readdata
//                .reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1:0]),                       //  output,    width = 2,                                           .waitrequest
//                .RSFEC_ehip_clock                           (),                           //   input,    width = 1,                           RSFEC_ehip_clock.RSFEC_ehip_clock
//                .RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,                   RSFEC_ehip_tx_adpt_clock.RSFEC_ehip_tx_adpt_clock
//                .rx_aib_reset                               ({2{&i_sl_rx_aib_reset}}),                               //   input,    width = 2,                               rx_aib_reset.rx_aib_reset
//                .rx_clkout                                  (rx_clkout_ptp),                                  //  output,    width = 2,                                  rx_clkout.clk
//                .rx_clkout2                                 (rx_clkout2_ptp),                                 //                                 rx_clkout2.clk
//                .rx_coreclkin                               ({LANES2{ptp_ch_hr_clk}}),                               //   input,    width = 2,                               rx_coreclkin.clk
//                .rx_enh_aligned                             (),                             //  output,    width = 2,                             rx_enh_aligned.rx_enh_aligned
//                .rx_enh_blk_lock                            (),                            //  output,    width = 2,                            rx_enh_blk_lock.rx_enh_blk_lock
//                .rx_enh_highber                             (),                             //  output,    width = 2,                             rx_enh_highber.rx_enh_highber
//                .rx_enh_local_fault                         (),                         //  output,    width = 2,                         rx_enh_local_fault.rx_enh_local_fault
//                .rx_enh_pause                               (),                               //  output,    width = 2,                               rx_enh_pause.rx_enh_pause
//                .rx_enh_pfc                                 (),                                 //  output,   width = 16,                                 rx_enh_pfc.rx_enh_pfc
//                .rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 rx_enh_pmaif_fifo_overflow.rx_enh_pmaif_fifo_overflow
//                .rx_enh_remote_fault                        (),                        //  output,    width = 2,                        rx_enh_remote_fault.rx_enh_remote_fault
//                .rx_enh_reset                               (),                               //   input,    width = 2,                               rx_enh_reset.rx_enh_reset
//                .rx_enh_reset_stat                          (),                          //  output,    width = 2,                          rx_enh_reset_stat.rx_enh_reset_stat
//                .rx_enh_signal_ok                           (),                           //   input,    width = 2,                           rx_enh_signal_ok.rx_enh_signal_ok
//                .rx_fifo_ready                              (),                              //  output,    width = 2,                              rx_fifo_ready.rx_fifo_ready
//                //.rx_fifo_latency_adj_ena                    (i_sl_ptp_aib_rxfifo_latency_adj_ena),
//                .rx_parallel_data                           (nphy_ptp_rx_parallel_data),                           //  output,  width = 160,                           rx_parallel_data.rx_parallel_data
//                .rx_pma_ready                               (sl_ptp_rx_pma_ready),                               //  output,    width = 2,                               rx_pma_ready.rx_pma_ready
//                .rx_pmaif_reset                             (),                             //   input,    width = 2,                             rx_pmaif_reset.rx_pmaif_reset
//                .rx_transfer_ready                          (sl_ptp_rx_transfer_ready),                          //  output,    width = 2,                          rx_transfer_ready.rx_transfer_ready
//                .tx_aib_reset                               ({2{&i_sl_tx_aib_reset}}),                                //   input,    width = 2,                               tx_aib_reset.tx_aib_reset
//                .tx_clkout                                  (tx_clkout_ptp),                                  //  output,    width = 2,                                  tx_clkout.clk
//                .tx_clkout2                                 (tx_clkout2_ptp),                                 //                                 tx_clkout2.clk
//                .tx_coreclkin                               ({LANES2{ptp_ch_hr_clk}}),                               //   input,    width = 2,                               tx_coreclkin.clk
//                .tx_coreclkin2                              ({LANES2{ptp_ch_fr_clk}}),                               //   input,    width = 2,                               tx_coreclkin.clk
//                .tx_dll_lock                                (),                                //  output,    width = 2,                                tx_dll_lock.tx_dll_lock
//                .tx_enh_pause                               (),                               //   input,    width = 2,                               tx_enh_pause.tx_enh_pause
//                .tx_enh_pfc                                 (),                                 //   input,   width = 16,                                 tx_enh_pfc.tx_enh_pfc
//                .tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,             tx_enh_pmaif_fifo_almost_empty.tx_enh_pmaif_fifo_almost_empty
//                .tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,              tx_enh_pmaif_fifo_almost_full.tx_enh_pmaif_fifo_almost_full
//                .tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 tx_enh_pmaif_fifo_overflow.tx_enh_pmaif_fifo_overflow
//                .tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,                tx_enh_pmaif_fifo_underflow.tx_enh_pmaif_fifo_underflow
//                .tx_enh_reset                               (),                               //   input,    width = 2,                               tx_enh_reset.tx_enh_reset
//                .tx_enh_reset_stat                          (),                          //  output,    width = 2,                          tx_enh_reset_stat.tx_enh_reset_stat
//                .tx_fifo_ready                              (),                              //  output,    width = 2,                              tx_fifo_ready.tx_fifo_ready
//                .tx_parallel_data                           (nphy_ptp_tx_parallel_data),                           //   input,  width = 160,                           tx_parallel_data.tx_parallel_data
//                .tx_pma_ready                               (sl_ptp_tx_pma_ready),                               //  output,    width = 2,                               tx_pma_ready.tx_pma_ready
//                .tx_pmaif_reset                             (),                             //   input,    width = 2,                             tx_pmaif_reset.tx_pmaif_reset
//                .tx_transfer_ready                          (sl_ptp_tx_transfer_ready)                           //  output,    width = 2,                          tx_transfer_ready.tx_transfer_ready
//            );

            if(ECORE_5432_TIEOFF) begin
		    // PTP_CH[0] - lower PTP channel PLL OFF.
	            `ifdef ALTERA_RESERVED_QIS
			alt_ehipc3_fm_nphy_elane_ptp_plloff nphy_ptp0 (
	            `else
			alt_ehipc3_fm_nphy_elane_ptp_plloff_sim nphy_ptp0 (
	            `endif
	                .aib_ehip_rx_ehip_clk                       (o_ehip_clk),                       //   input,    width = 2,                       aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
	                .aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk),                    //   input,    width = 2,                    aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
	                .aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),                     //   input,    width = 2,                     aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
	                .aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*5-1:78*4]),                      //   input,  width = 156,                      aib_ehip_rx_sync_data.aib_ehip_rx_sync_data
	                .aib_ehip_tx_ehip_clk                       (o_ehip_clk),                       //   input,    width = 2,                       aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
	                .ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[0]),                        //  output,    width = 6,                        ehip_aib_aib_status.ehip_aib_aib_status
	                .ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*5-1:78*4]),                      //  output,  width = 156,                      ehip_aib_tx_sync_data.ehip_aib_tx_sync_data
	                .ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[0]),              //  output,    width = 2,              ehip_aib_tx_transfer_div2_clk.ehip_aib_tx_transfer_div2_clk
	                .ehip_elane_am_detect                       (),                       //  output,    width = 2,                       ehip_elane_am_detect.ehip_elane_am_detect
	                .ehip_elane_am_insert                       (),                       //  output,    width = 2,                       ehip_elane_am_insert.ehip_elane_am_insert
	                .ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_rd_en.ehip_elane_ptp_fifo_share_rd_en
	                .ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_wr_en.ehip_elane_ptp_fifo_share_wr_en
	                .ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,                       ehip_elane_ptp_tx_ts.ehip_elane_ptp_tx_ts
	                .ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,                    ehip_elane_ptp_tx_ts_fp.ehip_elane_ptp_tx_ts_fp
	                .ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,                 ehip_elane_ptp_tx_ts_valid.ehip_elane_ptp_tx_ts_valid
	                .ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,                       ehip_elane_rx_ptp_ts.ehip_elane_rx_ptp_ts
	                .ehip_elane_shared_clear                    (),                    //  output,    width = 2,                    ehip_elane_shared_clear.ehip_elane_shared_clear
	                .ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,                 ehip_elane_shared_dsk_done.ehip_elane_shared_dsk_done
	                .ehip_pma_tx_pma_clk                        (),                        //  output,    width = 2,                        ehip_pma_tx_pma_clk.ehip_pma_tx_pma_clk
	                .ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,                  ehip_pmaRsfec_fec_rx_data.ehip_pmaRsfec_fec_rx_data
	                .ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,         ehip_pmaRsfec_fec_rx_data_am_valid.ehip_pmaRsfec_fec_rx_data_am_valid
	                .ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,            ehip_pmaRsfec_fec_rx_data_valid.ehip_pmaRsfec_fec_rx_data_valid
	                .elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,        elane_ehip_ptp_deskewed_byte_offset.elane_ehip_ptp_deskewed_byte_offset
	                .elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,           elane_ehip_ptp_deskewed_ins_type.elane_ehip_ptp_deskewed_ins_type
	                .elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,                 elane_ehip_ptp_deskewed_ts.elane_ehip_ptp_deskewed_ts
	                .elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,              elane_ehip_ptp_deskewed_tx_fp.elane_ehip_ptp_deskewed_tx_fp
	                .elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,   elane_ehip_ptp_lane_deskew_deskew_marker.elane_ehip_ptp_lane_deskew_deskew_marker
	                .elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,      elane_ehip_ptp_lane_deskew_got_marker.elane_ehip_ptp_lane_deskew_got_marker
	                .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12, elane_ehip_ptp_lane_deskew_tap_sel_one_hot.elane_ehip_ptp_lane_deskew_tap_sel_one_hot
	                .elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,             elane_ehip_ptp_mac_byte_offset.elane_ehip_ptp_mac_byte_offset
	                .elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,                elane_ehip_ptp_mac_ins_type.elane_ehip_ptp_mac_ins_type
	                .elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,                      elane_ehip_ptp_mac_ts.elane_ehip_ptp_mac_ts
	                .elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,                   elane_ehip_ptp_mac_tx_fp.elane_ehip_ptp_mac_tx_fp
	                .elane_ehip_shared_clk                      (elane_ehip_shared_clk[4]),                      //   input,    width = 2,                      elane_ehip_shared_clk.elane_ehip_shared_clk
	                .enh_clear_internal_error                   (),                   //   input,    width = 2,                   enh_clear_internal_error.enh_clear_internal_error
	                .enh_force_rcfg_reset                       (),                       //   input,    width = 2,                       enh_force_rcfg_reset.enh_force_rcfg_reset
	                .enh_initialized                            (),                            //  output,    width = 2,                            enh_initialized.enh_initialized
	                .enh_internal_error                         (),                         //  output,    width = 2,                         enh_internal_error.enh_internal_error
	                .enh_pld_ready                              (),                              //   input,    width = 2,                              enh_pld_ready.enh_pld_ready
	                .enh_ready                                  (),                                  //  output,    width = 2,                                  enh_ready.enh_ready
	                .enh_reset                                  (),                                  //   input,    width = 2,                                  enh_reset.enh_reset
	                .enh_reset_stat                             (),                             //  output,    width = 2,                             enh_reset_stat.enh_reset_stat
	                .hip_aib_fsr_in                             (),                             //                             hip_aib_fsr_in.hip_aib_fsr_in
	                .hip_aib_ssr_in                             (),                             //                             hip_aib_ssr_in.hip_aib_ssr_in
	                .osc_transfer_en                            (),                            //  output,    width = 2,                            osc_transfer_en.osc_transfer_en
	                .pll_refclk0                                (sl_refclk[0]),                              //input,   width = 1,
	                .pll_refclk1                                (sl_refclk[1]),                              //input,   width = 1,
	                .pll_refclk2                                (sl_refclk[2]),                              //input,   width = 1,
	                .pll_refclk3                                (sl_refclk[3]),                              //input,   width = 1,
	                .pll_refclk4                                (sl_refclk[4]),                              //input,   width = 1,
	                .pma_ehip_rx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_rx_ehip_clk_div2.pma_ehip_rx_ehip_clk_div2
	                .pma_ehip_rx_ehip_fifo_rst_n                (),                //   input,    width = 2,                pma_ehip_rx_ehip_fifo_rst_n.pma_ehip_rx_ehip_fifo_rst_n
	                .pma_ehip_tx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_tx_ehip_clk_div2.pma_ehip_tx_ehip_clk_div2
	                .pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,                 pmaRsfec_ehip_tx_ehip_data.pmaRsfec_ehip_tx_ehip_data
	                .pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,     pmaRsfec_ehip_tx_ehip_data_am_valid_in.pmaRsfec_ehip_tx_ehip_data_am_valid_in
	                .pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,                   pmaRsfec_ehip_tx_ehip_dv.pmaRsfec_ehip_tx_ehip_dv
	                .pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,           pmaRsfec_ehip_tx_ehip_fifo_rst_n.pmaRsfec_ehip_tx_ehip_fifo_rst_n
	                .reconfig_clk                               (i_reconfig_clk),                               //   input,    width = 2,                               reconfig_clk.clk
	                .reconfig_reset                             (i_xcvr_reconfig_reset),                             //   input,    width = 2,                             reconfig_reset.reset
	                .reconfig_write                             (i_ptp_reconfig_write[0]),                             //   input,    width = 2,                              reconfig_avmm.write
	                .reconfig_read                              (i_ptp_reconfig_read[0]),                              //   input,    width = 2,                                           .read
	                .reconfig_address                           (i_ptp_reconfig_address[19-1:0]),                           //   input,   width = 11**,                                           .address
	                .reconfig_writedata                         (i_ptp_reconfig_writedata[8-1:0]),                         //   input,   width = 64,                                           .writedata
	                .reconfig_readdata                          (o_ptp_reconfig_readdata[8-1:0]),                          //  output,   width = 64,                                           .readdata
	                .reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[0]),                       //  output,    width = 2,                                           .waitrequest
	                .RSFEC_ehip_clock                           (),                           //   input,    width = 1,                           RSFEC_ehip_clock.RSFEC_ehip_clock
	                .RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,                   RSFEC_ehip_tx_adpt_clock.RSFEC_ehip_tx_adpt_clock
	                .rx_aib_reset                               ({&i_sl_rx_aib_reset}),                               //   input,    width = 2,                               rx_aib_reset.rx_aib_reset
	                .rx_clkout                                  (rx_clkout_ptp[0]),                                  //  output,    width = 2,                                  rx_clkout.clk
	                .rx_clkout2                                 (rx_clkout2_ptp[0]),                                 //                                 rx_clkout2.clk
	                .rx_coreclkin                               (ptp_ch_hr_clk),                               //   input,    width = 2,                               rx_coreclkin.clk
	                .rx_enh_aligned                             (),                             //  output,    width = 2,                             rx_enh_aligned.rx_enh_aligned
	                .rx_enh_blk_lock                            (),                            //  output,    width = 2,                            rx_enh_blk_lock.rx_enh_blk_lock
	                .rx_enh_highber                             (),                             //  output,    width = 2,                             rx_enh_highber.rx_enh_highber
	                .rx_enh_local_fault                         (),                         //  output,    width = 2,                         rx_enh_local_fault.rx_enh_local_fault
	                .rx_enh_pause                               (),                               //  output,    width = 2,                               rx_enh_pause.rx_enh_pause
	                .rx_enh_pfc                                 (),                                 //  output,   width = 16,                                 rx_enh_pfc.rx_enh_pfc
	                .rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 rx_enh_pmaif_fifo_overflow.rx_enh_pmaif_fifo_overflow
	                .rx_enh_remote_fault                        (),                        //  output,    width = 2,                        rx_enh_remote_fault.rx_enh_remote_fault
	                .rx_enh_reset                               (),                               //   input,    width = 2,                               rx_enh_reset.rx_enh_reset
	                .rx_enh_reset_stat                          (),                          //  output,    width = 2,                          rx_enh_reset_stat.rx_enh_reset_stat
	                .rx_enh_signal_ok                           (),                           //   input,    width = 2,                           rx_enh_signal_ok.rx_enh_signal_ok
	                .rx_fifo_ready                              (),                              //  output,    width = 2,                              rx_fifo_ready.rx_fifo_ready
	                //.rx_fifo_latency_adj_ena                    (i_sl_ptp_aib_rxfifo_latency_adj_ena),
	                .rx_parallel_data                           (nphy_ptp_rx_parallel_data[0]),                           //  output,  width = 160,                           rx_parallel_data.rx_parallel_data
	                .rx_pma_ready                               (sl_ptp_rx_pma_ready[0]),                               //  output,    width = 2,                               rx_pma_ready.rx_pma_ready
	                .rx_pmaif_reset                             (),                             //   input,    width = 2,                             rx_pmaif_reset.rx_pmaif_reset
	                .rx_transfer_ready                          (sl_ptp_rx_transfer_ready_int[0]),                          //  output,    width = 2,                          rx_transfer_ready.rx_transfer_ready
	                .tx_aib_reset                               ({&i_sl_tx_aib_reset}),                                //   input,    width = 2,                               tx_aib_reset.tx_aib_reset
	                .tx_clkout                                  (tx_clkout_ptp[0]),                                  //  output,    width = 2,                                  tx_clkout.clk
	                .tx_clkout2                                 (tx_clkout2_ptp[0]),                                 //                                 tx_clkout2.clk
	                .tx_coreclkin                               (ptp_ch_hr_clk),                               //   input,    width = 2,                               tx_coreclkin.clk
	                .tx_coreclkin2                              (ptp_ch_fr_clk),                               //   input,    width = 2,                               tx_coreclkin.clk
	                .tx_dll_lock                                (sl_ptp_plloff_tx_dll_lock),                                //  output,    width = 2,                                tx_dll_lock.tx_dll_lock
	                .tx_enh_pause                               (),                               //   input,    width = 2,                               tx_enh_pause.tx_enh_pause
	                .tx_enh_pfc                                 (),                                 //   input,   width = 16,                                 tx_enh_pfc.tx_enh_pfc
	                .tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,             tx_enh_pmaif_fifo_almost_empty.tx_enh_pmaif_fifo_almost_empty
	                .tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,              tx_enh_pmaif_fifo_almost_full.tx_enh_pmaif_fifo_almost_full
	                .tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 tx_enh_pmaif_fifo_overflow.tx_enh_pmaif_fifo_overflow
	                .tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,                tx_enh_pmaif_fifo_underflow.tx_enh_pmaif_fifo_underflow
	                .tx_enh_reset                               (),                               //   input,    width = 2,                               tx_enh_reset.tx_enh_reset
	                .tx_enh_reset_stat                          (),                          //  output,    width = 2,                          tx_enh_reset_stat.tx_enh_reset_stat
	                .tx_fifo_ready                              (),                              //  output,    width = 2,                              tx_fifo_ready.tx_fifo_ready
	                .tx_parallel_data                           (nphy_ptp_tx_parallel_data[0]),                           //   input,  width = 160,                           tx_parallel_data.tx_parallel_data
	                .tx_pma_ready                               (sl_ptp_tx_pma_ready[0]),                               //  output,    width = 2,                               tx_pma_ready.tx_pma_ready
	                .tx_pmaif_reset                             (),                             //   input,    width = 2,                             tx_pmaif_reset.tx_pmaif_reset
	                .tx_transfer_ready                          (sl_ptp_tx_transfer_ready_int[0])                           //  output,    width = 2,                          tx_transfer_ready.tx_transfer_ready
	            );

		    // PTP_CH[1] - upper PTP channel PLL ON.
	            `ifdef ALTERA_RESERVED_QIS
			alt_ehipc3_fm_nphy_elane_ptp nphy_ptp1 (
	            `else
			alt_ehipc3_fm_nphy_elane_ptp_sim nphy_ptp1 (
	            `endif
	                .aib_ehip_rx_ehip_clk                       (o_ehip_clk),                       //   input,    width = 2,                       aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
	                .aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk),                    //   input,    width = 2,                    aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
	                .aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),                     //   input,    width = 2,                     aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
	                .aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*5]),                      //   input,  width = 156,                      aib_ehip_rx_sync_data.aib_ehip_rx_sync_data
	                .aib_ehip_tx_ehip_clk                       (o_ehip_clk),                       //   input,    width = 2,                       aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
	                .ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1]),                        //  output,    width = 6,                        ehip_aib_aib_status.ehip_aib_aib_status
	                .ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*5]),                      //  output,  width = 156,                      ehip_aib_tx_sync_data.ehip_aib_tx_sync_data
	                .ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[1]),              //  output,    width = 2,              ehip_aib_tx_transfer_div2_clk.ehip_aib_tx_transfer_div2_clk
	                .ehip_elane_am_detect                       (),                       //  output,    width = 2,                       ehip_elane_am_detect.ehip_elane_am_detect
	                .ehip_elane_am_insert                       (),                       //  output,    width = 2,                       ehip_elane_am_insert.ehip_elane_am_insert
	                .ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_rd_en.ehip_elane_ptp_fifo_share_rd_en
	                .ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_wr_en.ehip_elane_ptp_fifo_share_wr_en
	                .ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,                       ehip_elane_ptp_tx_ts.ehip_elane_ptp_tx_ts
	                .ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,                    ehip_elane_ptp_tx_ts_fp.ehip_elane_ptp_tx_ts_fp
	                .ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,                 ehip_elane_ptp_tx_ts_valid.ehip_elane_ptp_tx_ts_valid
	                .ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,                       ehip_elane_rx_ptp_ts.ehip_elane_rx_ptp_ts
	                .ehip_elane_shared_clear                    (),                    //  output,    width = 2,                    ehip_elane_shared_clear.ehip_elane_shared_clear
	                .ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,                 ehip_elane_shared_dsk_done.ehip_elane_shared_dsk_done
	                .ehip_pma_tx_pma_clk                        (),                        //  output,    width = 2,                        ehip_pma_tx_pma_clk.ehip_pma_tx_pma_clk
	                .ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,                  ehip_pmaRsfec_fec_rx_data.ehip_pmaRsfec_fec_rx_data
	                .ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,         ehip_pmaRsfec_fec_rx_data_am_valid.ehip_pmaRsfec_fec_rx_data_am_valid
	                .ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,            ehip_pmaRsfec_fec_rx_data_valid.ehip_pmaRsfec_fec_rx_data_valid
	                .elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,        elane_ehip_ptp_deskewed_byte_offset.elane_ehip_ptp_deskewed_byte_offset
	                .elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,           elane_ehip_ptp_deskewed_ins_type.elane_ehip_ptp_deskewed_ins_type
	                .elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,                 elane_ehip_ptp_deskewed_ts.elane_ehip_ptp_deskewed_ts
	                .elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,              elane_ehip_ptp_deskewed_tx_fp.elane_ehip_ptp_deskewed_tx_fp
	                .elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,   elane_ehip_ptp_lane_deskew_deskew_marker.elane_ehip_ptp_lane_deskew_deskew_marker
	                .elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,      elane_ehip_ptp_lane_deskew_got_marker.elane_ehip_ptp_lane_deskew_got_marker
	                .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12, elane_ehip_ptp_lane_deskew_tap_sel_one_hot.elane_ehip_ptp_lane_deskew_tap_sel_one_hot
	                .elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,             elane_ehip_ptp_mac_byte_offset.elane_ehip_ptp_mac_byte_offset
	                .elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,                elane_ehip_ptp_mac_ins_type.elane_ehip_ptp_mac_ins_type
	                .elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,                      elane_ehip_ptp_mac_ts.elane_ehip_ptp_mac_ts
	                .elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,                   elane_ehip_ptp_mac_tx_fp.elane_ehip_ptp_mac_tx_fp
	                .elane_ehip_shared_clk                      (elane_ehip_shared_clk[5]),                      //   input,    width = 2,                      elane_ehip_shared_clk.elane_ehip_shared_clk
	                .enh_clear_internal_error                   (),                   //   input,    width = 2,                   enh_clear_internal_error.enh_clear_internal_error
	                .enh_force_rcfg_reset                       (),                       //   input,    width = 2,                       enh_force_rcfg_reset.enh_force_rcfg_reset
	                .enh_initialized                            (),                            //  output,    width = 2,                            enh_initialized.enh_initialized
	                .enh_internal_error                         (),                         //  output,    width = 2,                         enh_internal_error.enh_internal_error
	                .enh_pld_ready                              (),                              //   input,    width = 2,                              enh_pld_ready.enh_pld_ready
	                .enh_ready                                  (),                                  //  output,    width = 2,                                  enh_ready.enh_ready
	                .enh_reset                                  (),                                  //   input,    width = 2,                                  enh_reset.enh_reset
	                .enh_reset_stat                             (),                             //  output,    width = 2,                             enh_reset_stat.enh_reset_stat
	                .hip_aib_fsr_in                             (),                             //                             hip_aib_fsr_in.hip_aib_fsr_in
	                .hip_aib_ssr_in                             (),                             //                             hip_aib_ssr_in.hip_aib_ssr_in
	                .osc_transfer_en                            (),                            //  output,    width = 2,                            osc_transfer_en.osc_transfer_en
	                .pll_refclk0                                (sl_refclk[0]),                              //input,   width = 1,
	                .pll_refclk1                                (sl_refclk[1]),                              //input,   width = 1,
	                .pll_refclk2                                (sl_refclk[2]),                              //input,   width = 1,
	                .pll_refclk3                                (sl_refclk[3]),                              //input,   width = 1,
	                .pll_refclk4                                (sl_refclk[4]),                              //input,   width = 1,
	                .pma_ehip_rx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_rx_ehip_clk_div2.pma_ehip_rx_ehip_clk_div2
	                .pma_ehip_rx_ehip_fifo_rst_n                (),                //   input,    width = 2,                pma_ehip_rx_ehip_fifo_rst_n.pma_ehip_rx_ehip_fifo_rst_n
	                .pma_ehip_tx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_tx_ehip_clk_div2.pma_ehip_tx_ehip_clk_div2
	                .pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,                 pmaRsfec_ehip_tx_ehip_data.pmaRsfec_ehip_tx_ehip_data
	                .pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,     pmaRsfec_ehip_tx_ehip_data_am_valid_in.pmaRsfec_ehip_tx_ehip_data_am_valid_in
	                .pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,                   pmaRsfec_ehip_tx_ehip_dv.pmaRsfec_ehip_tx_ehip_dv
	                .pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,           pmaRsfec_ehip_tx_ehip_fifo_rst_n.pmaRsfec_ehip_tx_ehip_fifo_rst_n
	                .reconfig_clk                               (i_reconfig_clk),                               //   input,    width = 2,                               reconfig_clk.clk
	                .reconfig_reset                             (i_xcvr_reconfig_reset),                             //   input,    width = 2,                             reconfig_reset.reset
	                .reconfig_write                             (i_ptp_reconfig_write[1]),                             //   input,    width = 2,                              reconfig_avmm.write
	                .reconfig_read                              (i_ptp_reconfig_read[1]),                              //   input,    width = 2,                                           .read
	                .reconfig_address                           (i_ptp_reconfig_address[19*LANES2-1:19]),                           //   input,   width = 11**,                                           .address
	                .reconfig_writedata                         (i_ptp_reconfig_writedata[8*LANES2-1:8]),                         //   input,   width = 64,                                           .writedata
	                .reconfig_readdata                          (o_ptp_reconfig_readdata[8*LANES2-1:8]),                          //  output,   width = 64,                                           .readdata
	                .reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[1]),                       //  output,    width = 2,                                           .waitrequest
	                .RSFEC_ehip_clock                           (),                           //   input,    width = 1,                           RSFEC_ehip_clock.RSFEC_ehip_clock
	                .RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,                   RSFEC_ehip_tx_adpt_clock.RSFEC_ehip_tx_adpt_clock
	                .rx_aib_reset                               ({&i_sl_rx_aib_reset}),                               //   input,    width = 2,                               rx_aib_reset.rx_aib_reset
	                .rx_clkout                                  (rx_clkout_ptp[1]),                                  //  output,    width = 2,                                  rx_clkout.clk
	                .rx_clkout2                                 (rx_clkout2_ptp[1]),                                 //                                 rx_clkout2.clk
	                .rx_coreclkin                               (ptp_ch_hr_clk),                               //   input,    width = 2,                               rx_coreclkin.clk
	                .rx_enh_aligned                             (),                             //  output,    width = 2,                             rx_enh_aligned.rx_enh_aligned
	                .rx_enh_blk_lock                            (),                            //  output,    width = 2,                            rx_enh_blk_lock.rx_enh_blk_lock
	                .rx_enh_highber                             (),                             //  output,    width = 2,                             rx_enh_highber.rx_enh_highber
	                .rx_enh_local_fault                         (),                         //  output,    width = 2,                         rx_enh_local_fault.rx_enh_local_fault
	                .rx_enh_pause                               (),                               //  output,    width = 2,                               rx_enh_pause.rx_enh_pause
	                .rx_enh_pfc                                 (),                                 //  output,   width = 16,                                 rx_enh_pfc.rx_enh_pfc
	                .rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 rx_enh_pmaif_fifo_overflow.rx_enh_pmaif_fifo_overflow
	                .rx_enh_remote_fault                        (),                        //  output,    width = 2,                        rx_enh_remote_fault.rx_enh_remote_fault
	                .rx_enh_reset                               (),                               //   input,    width = 2,                               rx_enh_reset.rx_enh_reset
	                .rx_enh_reset_stat                          (),                          //  output,    width = 2,                          rx_enh_reset_stat.rx_enh_reset_stat
	                .rx_enh_signal_ok                           (),                           //   input,    width = 2,                           rx_enh_signal_ok.rx_enh_signal_ok
	                .rx_fifo_ready                              (),                              //  output,    width = 2,                              rx_fifo_ready.rx_fifo_ready
	                //.rx_fifo_latency_adj_ena                    (i_sl_ptp_aib_rxfifo_latency_adj_ena),
	                .rx_parallel_data                           (nphy_ptp_rx_parallel_data[1]),                           //  output,  width = 160,                           rx_parallel_data.rx_parallel_data
	                .rx_pma_ready                               (sl_ptp_rx_pma_ready[1]),                               //  output,    width = 2,                               rx_pma_ready.rx_pma_ready
	                .rx_pmaif_reset                             (),                             //   input,    width = 2,                             rx_pmaif_reset.rx_pmaif_reset
	                .rx_transfer_ready                          (sl_ptp_rx_transfer_ready_int[1]),                          //  output,    width = 2,                          rx_transfer_ready.rx_transfer_ready
	                .tx_aib_reset                               ({&i_sl_tx_aib_reset}),                                //   input,    width = 2,                               tx_aib_reset.tx_aib_reset
	                .tx_clkout                                  (tx_clkout_ptp[1]),                                  //  output,    width = 2,                                  tx_clkout.clk
	                .tx_clkout2                                 (tx_clkout2_ptp[1]),                                 //                                 tx_clkout2.clk
	                .tx_coreclkin                               (ptp_ch_hr_clk),                               //   input,    width = 2,                               tx_coreclkin.clk
	                .tx_coreclkin2                              (ptp_ch_fr_clk),                               //   input,    width = 2,                               tx_coreclkin.clk
	                .tx_dll_lock                                (),                                //  output,    width = 2,                                tx_dll_lock.tx_dll_lock
	                .tx_enh_pause                               (),                               //   input,    width = 2,                               tx_enh_pause.tx_enh_pause
	                .tx_enh_pfc                                 (),                                 //   input,   width = 16,                                 tx_enh_pfc.tx_enh_pfc
	                .tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,             tx_enh_pmaif_fifo_almost_empty.tx_enh_pmaif_fifo_almost_empty
	                .tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,              tx_enh_pmaif_fifo_almost_full.tx_enh_pmaif_fifo_almost_full
	                .tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 tx_enh_pmaif_fifo_overflow.tx_enh_pmaif_fifo_overflow
	                .tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,                tx_enh_pmaif_fifo_underflow.tx_enh_pmaif_fifo_underflow
	                .tx_enh_reset                               (),                               //   input,    width = 2,                               tx_enh_reset.tx_enh_reset
	                .tx_enh_reset_stat                          (),                          //  output,    width = 2,                          tx_enh_reset_stat.tx_enh_reset_stat
	                .tx_fifo_ready                              (),                              //  output,    width = 2,                              tx_fifo_ready.tx_fifo_ready
	                .tx_parallel_data                           (nphy_ptp_tx_parallel_data[1]),                           //   input,  width = 160,                           tx_parallel_data.tx_parallel_data
	                .tx_pma_ready                               (sl_ptp_tx_pma_ready[1]),                               //  output,    width = 2,                               tx_pma_ready.tx_pma_ready
	                .tx_pmaif_reset                             (),                             //   input,    width = 2,                             tx_pmaif_reset.tx_pmaif_reset
	                .tx_transfer_ready                          (sl_ptp_tx_transfer_ready_int[1])                           //  output,    width = 2,                          tx_transfer_ready.tx_transfer_ready
	            );
            end else begin
		    // PTP_CH[0] - lower PTP channel PLL ON.
	           `ifdef ALTERA_RESERVED_QIS
			alt_ehipc3_fm_nphy_elane_ptp nphy_ptp0 (
	           `else
			alt_ehipc3_fm_nphy_elane_ptp_sim nphy_ptp0 (
	           `endif
	                .aib_ehip_rx_ehip_clk                       (o_ehip_clk),                       //   input,    width = 2,                       aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
	                .aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk),                    //   input,    width = 2,                    aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
	                .aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),                     //   input,    width = 2,                     aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
	                .aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*5-1:78*4]),                      //   input,  width = 156,                      aib_ehip_rx_sync_data.aib_ehip_rx_sync_data
	                .aib_ehip_tx_ehip_clk                       (o_ehip_clk),                       //   input,    width = 2,                       aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
	                .ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[0]),                        //  output,    width = 6,                        ehip_aib_aib_status.ehip_aib_aib_status
	                .ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*5-1:78*4]),                      //  output,  width = 156,                      ehip_aib_tx_sync_data.ehip_aib_tx_sync_data
	                .ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[0]),              //  output,    width = 2,              ehip_aib_tx_transfer_div2_clk.ehip_aib_tx_transfer_div2_clk
	                .ehip_elane_am_detect                       (),                       //  output,    width = 2,                       ehip_elane_am_detect.ehip_elane_am_detect
	                .ehip_elane_am_insert                       (),                       //  output,    width = 2,                       ehip_elane_am_insert.ehip_elane_am_insert
	                .ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_rd_en.ehip_elane_ptp_fifo_share_rd_en
	                .ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_wr_en.ehip_elane_ptp_fifo_share_wr_en
	                .ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,                       ehip_elane_ptp_tx_ts.ehip_elane_ptp_tx_ts
	                .ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,                    ehip_elane_ptp_tx_ts_fp.ehip_elane_ptp_tx_ts_fp
	                .ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,                 ehip_elane_ptp_tx_ts_valid.ehip_elane_ptp_tx_ts_valid
	                .ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,                       ehip_elane_rx_ptp_ts.ehip_elane_rx_ptp_ts
	                .ehip_elane_shared_clear                    (),                    //  output,    width = 2,                    ehip_elane_shared_clear.ehip_elane_shared_clear
	                .ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,                 ehip_elane_shared_dsk_done.ehip_elane_shared_dsk_done
	                .ehip_pma_tx_pma_clk                        (),                        //  output,    width = 2,                        ehip_pma_tx_pma_clk.ehip_pma_tx_pma_clk
	                .ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,                  ehip_pmaRsfec_fec_rx_data.ehip_pmaRsfec_fec_rx_data
	                .ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,         ehip_pmaRsfec_fec_rx_data_am_valid.ehip_pmaRsfec_fec_rx_data_am_valid
	                .ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,            ehip_pmaRsfec_fec_rx_data_valid.ehip_pmaRsfec_fec_rx_data_valid
	                .elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,        elane_ehip_ptp_deskewed_byte_offset.elane_ehip_ptp_deskewed_byte_offset
	                .elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,           elane_ehip_ptp_deskewed_ins_type.elane_ehip_ptp_deskewed_ins_type
	                .elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,                 elane_ehip_ptp_deskewed_ts.elane_ehip_ptp_deskewed_ts
	                .elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,              elane_ehip_ptp_deskewed_tx_fp.elane_ehip_ptp_deskewed_tx_fp
	                .elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,   elane_ehip_ptp_lane_deskew_deskew_marker.elane_ehip_ptp_lane_deskew_deskew_marker
	                .elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,      elane_ehip_ptp_lane_deskew_got_marker.elane_ehip_ptp_lane_deskew_got_marker
	                .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12, elane_ehip_ptp_lane_deskew_tap_sel_one_hot.elane_ehip_ptp_lane_deskew_tap_sel_one_hot
	                .elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,             elane_ehip_ptp_mac_byte_offset.elane_ehip_ptp_mac_byte_offset
	                .elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,                elane_ehip_ptp_mac_ins_type.elane_ehip_ptp_mac_ins_type
	                .elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,                      elane_ehip_ptp_mac_ts.elane_ehip_ptp_mac_ts
	                .elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,                   elane_ehip_ptp_mac_tx_fp.elane_ehip_ptp_mac_tx_fp
	                .elane_ehip_shared_clk                      (elane_ehip_shared_clk[4]),                      //   input,    width = 2,                      elane_ehip_shared_clk.elane_ehip_shared_clk
	                .enh_clear_internal_error                   (),                   //   input,    width = 2,                   enh_clear_internal_error.enh_clear_internal_error
	                .enh_force_rcfg_reset                       (),                       //   input,    width = 2,                       enh_force_rcfg_reset.enh_force_rcfg_reset
	                .enh_initialized                            (),                            //  output,    width = 2,                            enh_initialized.enh_initialized
	                .enh_internal_error                         (),                         //  output,    width = 2,                         enh_internal_error.enh_internal_error
	                .enh_pld_ready                              (),                              //   input,    width = 2,                              enh_pld_ready.enh_pld_ready
	                .enh_ready                                  (),                                  //  output,    width = 2,                                  enh_ready.enh_ready
	                .enh_reset                                  (),                                  //   input,    width = 2,                                  enh_reset.enh_reset
	                .enh_reset_stat                             (),                             //  output,    width = 2,                             enh_reset_stat.enh_reset_stat
	                .hip_aib_fsr_in                             (),                             //                             hip_aib_fsr_in.hip_aib_fsr_in
	                .hip_aib_ssr_in                             (),                             //                             hip_aib_ssr_in.hip_aib_ssr_in
	                .osc_transfer_en                            (),                            //  output,    width = 2,                            osc_transfer_en.osc_transfer_en
	                .pll_refclk0                                (sl_refclk[0]),                              //input,   width = 1,
	                .pll_refclk1                                (sl_refclk[1]),                              //input,   width = 1,
	                .pll_refclk2                                (sl_refclk[2]),                              //input,   width = 1,
	                .pll_refclk3                                (sl_refclk[3]),                              //input,   width = 1,
	                .pll_refclk4                                (sl_refclk[4]),                              //input,   width = 1,
	                .pma_ehip_rx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_rx_ehip_clk_div2.pma_ehip_rx_ehip_clk_div2
	                .pma_ehip_rx_ehip_fifo_rst_n                (),                //   input,    width = 2,                pma_ehip_rx_ehip_fifo_rst_n.pma_ehip_rx_ehip_fifo_rst_n
	                .pma_ehip_tx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_tx_ehip_clk_div2.pma_ehip_tx_ehip_clk_div2
	                .pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,                 pmaRsfec_ehip_tx_ehip_data.pmaRsfec_ehip_tx_ehip_data
	                .pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,     pmaRsfec_ehip_tx_ehip_data_am_valid_in.pmaRsfec_ehip_tx_ehip_data_am_valid_in
	                .pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,                   pmaRsfec_ehip_tx_ehip_dv.pmaRsfec_ehip_tx_ehip_dv
	                .pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,           pmaRsfec_ehip_tx_ehip_fifo_rst_n.pmaRsfec_ehip_tx_ehip_fifo_rst_n
	                .reconfig_clk                               (i_reconfig_clk),                               //   input,    width = 2,                               reconfig_clk.clk
	                .reconfig_reset                             (i_xcvr_reconfig_reset),                             //   input,    width = 2,                             reconfig_reset.reset
	                .reconfig_write                             (i_ptp_reconfig_write[0]),                             //   input,    width = 2,                              reconfig_avmm.write
	                .reconfig_read                              (i_ptp_reconfig_read[0]),                              //   input,    width = 2,                                           .read
	                .reconfig_address                           (i_ptp_reconfig_address[19-1:0]),                           //   input,   width = 11**,                                           .address
	                .reconfig_writedata                         (i_ptp_reconfig_writedata[8-1:0]),                         //   input,   width = 64,                                           .writedata
	                .reconfig_readdata                          (o_ptp_reconfig_readdata[8-1:0]),                          //  output,   width = 64,                                           .readdata
	                .reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[0]),                       //  output,    width = 2,                                           .waitrequest
	                .RSFEC_ehip_clock                           (),                           //   input,    width = 1,                           RSFEC_ehip_clock.RSFEC_ehip_clock
	                .RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,                   RSFEC_ehip_tx_adpt_clock.RSFEC_ehip_tx_adpt_clock
	                .rx_aib_reset                               ({&i_sl_rx_aib_reset}),                               //   input,    width = 2,                               rx_aib_reset.rx_aib_reset
	                .rx_clkout                                  (rx_clkout_ptp[0]),                                  //  output,    width = 2,                                  rx_clkout.clk
	                .rx_clkout2                                 (rx_clkout2_ptp[0]),                                 //                                 rx_clkout2.clk
	                .rx_coreclkin                               (ptp_ch_hr_clk),                               //   input,    width = 2,                               rx_coreclkin.clk
	                .rx_enh_aligned                             (),                             //  output,    width = 2,                             rx_enh_aligned.rx_enh_aligned
	                .rx_enh_blk_lock                            (),                            //  output,    width = 2,                            rx_enh_blk_lock.rx_enh_blk_lock
	                .rx_enh_highber                             (),                             //  output,    width = 2,                             rx_enh_highber.rx_enh_highber
	                .rx_enh_local_fault                         (),                         //  output,    width = 2,                         rx_enh_local_fault.rx_enh_local_fault
	                .rx_enh_pause                               (),                               //  output,    width = 2,                               rx_enh_pause.rx_enh_pause
	                .rx_enh_pfc                                 (),                                 //  output,   width = 16,                                 rx_enh_pfc.rx_enh_pfc
	                .rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 rx_enh_pmaif_fifo_overflow.rx_enh_pmaif_fifo_overflow
	                .rx_enh_remote_fault                        (),                        //  output,    width = 2,                        rx_enh_remote_fault.rx_enh_remote_fault
	                .rx_enh_reset                               (),                               //   input,    width = 2,                               rx_enh_reset.rx_enh_reset
	                .rx_enh_reset_stat                          (),                          //  output,    width = 2,                          rx_enh_reset_stat.rx_enh_reset_stat
	                .rx_enh_signal_ok                           (),                           //   input,    width = 2,                           rx_enh_signal_ok.rx_enh_signal_ok
	                .rx_fifo_ready                              (),                              //  output,    width = 2,                              rx_fifo_ready.rx_fifo_ready
	                //.rx_fifo_latency_adj_ena                    (i_sl_ptp_aib_rxfifo_latency_adj_ena),
	                .rx_parallel_data                           (nphy_ptp_rx_parallel_data[0]),                           //  output,  width = 160,                           rx_parallel_data.rx_parallel_data
	                .rx_pma_ready                               (sl_ptp_rx_pma_ready[0]),                               //  output,    width = 2,                               rx_pma_ready.rx_pma_ready
	                .rx_pmaif_reset                             (),                             //   input,    width = 2,                             rx_pmaif_reset.rx_pmaif_reset
	                .rx_transfer_ready                          (sl_ptp_rx_transfer_ready_int[0]),                          //  output,    width = 2,                          rx_transfer_ready.rx_transfer_ready
	                .tx_aib_reset                               ({&i_sl_tx_aib_reset}),                                //   input,    width = 2,                               tx_aib_reset.tx_aib_reset
	                .tx_clkout                                  (tx_clkout_ptp[0]),                                  //  output,    width = 2,                                  tx_clkout.clk
	                .tx_clkout2                                 (tx_clkout2_ptp[0]),                                 //                                 tx_clkout2.clk
	                .tx_coreclkin                               (ptp_ch_hr_clk),                               //   input,    width = 2,                               tx_coreclkin.clk
	                .tx_coreclkin2                              (ptp_ch_fr_clk),                               //   input,    width = 2,                               tx_coreclkin.clk
	                .tx_dll_lock                                (),                                //  output,    width = 2,                                tx_dll_lock.tx_dll_lock
	                .tx_enh_pause                               (),                               //   input,    width = 2,                               tx_enh_pause.tx_enh_pause
	                .tx_enh_pfc                                 (),                                 //   input,   width = 16,                                 tx_enh_pfc.tx_enh_pfc
	                .tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,             tx_enh_pmaif_fifo_almost_empty.tx_enh_pmaif_fifo_almost_empty
	                .tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,              tx_enh_pmaif_fifo_almost_full.tx_enh_pmaif_fifo_almost_full
	                .tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 tx_enh_pmaif_fifo_overflow.tx_enh_pmaif_fifo_overflow
	                .tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,                tx_enh_pmaif_fifo_underflow.tx_enh_pmaif_fifo_underflow
	                .tx_enh_reset                               (),                               //   input,    width = 2,                               tx_enh_reset.tx_enh_reset
	                .tx_enh_reset_stat                          (),                          //  output,    width = 2,                          tx_enh_reset_stat.tx_enh_reset_stat
	                .tx_fifo_ready                              (),                              //  output,    width = 2,                              tx_fifo_ready.tx_fifo_ready
	                .tx_parallel_data                           (nphy_ptp_tx_parallel_data[0]),                           //   input,  width = 160,                           tx_parallel_data.tx_parallel_data
	                .tx_pma_ready                               (sl_ptp_tx_pma_ready[0]),                               //  output,    width = 2,                               tx_pma_ready.tx_pma_ready
	                .tx_pmaif_reset                             (),                             //   input,    width = 2,                             tx_pmaif_reset.tx_pmaif_reset
	                .tx_transfer_ready                          (sl_ptp_tx_transfer_ready_int[0])                           //  output,    width = 2,                          tx_transfer_ready.tx_transfer_ready
	            );

		    // PTP_CH[1] - upper PTP channel PLL OFF.
	           `ifdef ALTERA_RESERVED_QIS
			alt_ehipc3_fm_nphy_elane_ptp_plloff nphy_ptp1 (
	           `else
			alt_ehipc3_fm_nphy_elane_ptp_plloff_sim nphy_ptp1 (
	           `endif
	                .aib_ehip_rx_ehip_clk                       (o_ehip_clk),                       //   input,    width = 2,                       aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
	                .aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk),                    //   input,    width = 2,                    aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
	                .aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),                     //   input,    width = 2,                     aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
	                .aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*5]),                      //   input,  width = 156,                      aib_ehip_rx_sync_data.aib_ehip_rx_sync_data
	                .aib_ehip_tx_ehip_clk                       (o_ehip_clk),                       //   input,    width = 2,                       aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
	                .ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1]),                        //  output,    width = 6,                        ehip_aib_aib_status.ehip_aib_aib_status
	                .ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*5]),                      //  output,  width = 156,                      ehip_aib_tx_sync_data.ehip_aib_tx_sync_data
	                .ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[1]),              //  output,    width = 2,              ehip_aib_tx_transfer_div2_clk.ehip_aib_tx_transfer_div2_clk
	                .ehip_elane_am_detect                       (),                       //  output,    width = 2,                       ehip_elane_am_detect.ehip_elane_am_detect
	                .ehip_elane_am_insert                       (),                       //  output,    width = 2,                       ehip_elane_am_insert.ehip_elane_am_insert
	                .ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_rd_en.ehip_elane_ptp_fifo_share_rd_en
	                .ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,            ehip_elane_ptp_fifo_share_wr_en.ehip_elane_ptp_fifo_share_wr_en
	                .ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,                       ehip_elane_ptp_tx_ts.ehip_elane_ptp_tx_ts
	                .ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,                    ehip_elane_ptp_tx_ts_fp.ehip_elane_ptp_tx_ts_fp
	                .ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,                 ehip_elane_ptp_tx_ts_valid.ehip_elane_ptp_tx_ts_valid
	                .ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,                       ehip_elane_rx_ptp_ts.ehip_elane_rx_ptp_ts
	                .ehip_elane_shared_clear                    (),                    //  output,    width = 2,                    ehip_elane_shared_clear.ehip_elane_shared_clear
	                .ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,                 ehip_elane_shared_dsk_done.ehip_elane_shared_dsk_done
	                .ehip_pma_tx_pma_clk                        (),                        //  output,    width = 2,                        ehip_pma_tx_pma_clk.ehip_pma_tx_pma_clk
	                .ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,                  ehip_pmaRsfec_fec_rx_data.ehip_pmaRsfec_fec_rx_data
	                .ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,         ehip_pmaRsfec_fec_rx_data_am_valid.ehip_pmaRsfec_fec_rx_data_am_valid
	                .ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,            ehip_pmaRsfec_fec_rx_data_valid.ehip_pmaRsfec_fec_rx_data_valid
	                .elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,        elane_ehip_ptp_deskewed_byte_offset.elane_ehip_ptp_deskewed_byte_offset
	                .elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,           elane_ehip_ptp_deskewed_ins_type.elane_ehip_ptp_deskewed_ins_type
	                .elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,                 elane_ehip_ptp_deskewed_ts.elane_ehip_ptp_deskewed_ts
	                .elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,              elane_ehip_ptp_deskewed_tx_fp.elane_ehip_ptp_deskewed_tx_fp
	                .elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,   elane_ehip_ptp_lane_deskew_deskew_marker.elane_ehip_ptp_lane_deskew_deskew_marker
	                .elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,      elane_ehip_ptp_lane_deskew_got_marker.elane_ehip_ptp_lane_deskew_got_marker
	                .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12, elane_ehip_ptp_lane_deskew_tap_sel_one_hot.elane_ehip_ptp_lane_deskew_tap_sel_one_hot
	                .elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,             elane_ehip_ptp_mac_byte_offset.elane_ehip_ptp_mac_byte_offset
	                .elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,                elane_ehip_ptp_mac_ins_type.elane_ehip_ptp_mac_ins_type
	                .elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,                      elane_ehip_ptp_mac_ts.elane_ehip_ptp_mac_ts
	                .elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,                   elane_ehip_ptp_mac_tx_fp.elane_ehip_ptp_mac_tx_fp
	                .elane_ehip_shared_clk                      (elane_ehip_shared_clk[5]),                      //   input,    width = 2,                      elane_ehip_shared_clk.elane_ehip_shared_clk
	                .enh_clear_internal_error                   (),                   //   input,    width = 2,                   enh_clear_internal_error.enh_clear_internal_error
	                .enh_force_rcfg_reset                       (),                       //   input,    width = 2,                       enh_force_rcfg_reset.enh_force_rcfg_reset
	                .enh_initialized                            (),                            //  output,    width = 2,                            enh_initialized.enh_initialized
	                .enh_internal_error                         (),                         //  output,    width = 2,                         enh_internal_error.enh_internal_error
	                .enh_pld_ready                              (),                              //   input,    width = 2,                              enh_pld_ready.enh_pld_ready
	                .enh_ready                                  (),                                  //  output,    width = 2,                                  enh_ready.enh_ready
	                .enh_reset                                  (),                                  //   input,    width = 2,                                  enh_reset.enh_reset
	                .enh_reset_stat                             (),                             //  output,    width = 2,                             enh_reset_stat.enh_reset_stat
	                .hip_aib_fsr_in                             (),                             //                             hip_aib_fsr_in.hip_aib_fsr_in
	                .hip_aib_ssr_in                             (),                             //                             hip_aib_ssr_in.hip_aib_ssr_in
	                .osc_transfer_en                            (),                            //  output,    width = 2,                            osc_transfer_en.osc_transfer_en
	                .pll_refclk0                                (sl_refclk[0]),                              //input,   width = 1,
	                .pll_refclk1                                (sl_refclk[1]),                              //input,   width = 1,
	                .pll_refclk2                                (sl_refclk[2]),                              //input,   width = 1,
	                .pll_refclk3                                (sl_refclk[3]),                              //input,   width = 1,
	                .pll_refclk4                                (sl_refclk[4]),                              //input,   width = 1,
	                .pma_ehip_rx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_rx_ehip_clk_div2.pma_ehip_rx_ehip_clk_div2
	                .pma_ehip_rx_ehip_fifo_rst_n                (),                //   input,    width = 2,                pma_ehip_rx_ehip_fifo_rst_n.pma_ehip_rx_ehip_fifo_rst_n
	                .pma_ehip_tx_ehip_clk_div2                  (),                  //   input,    width = 2,                  pma_ehip_tx_ehip_clk_div2.pma_ehip_tx_ehip_clk_div2
	                .pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,                 pmaRsfec_ehip_tx_ehip_data.pmaRsfec_ehip_tx_ehip_data
	                .pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,     pmaRsfec_ehip_tx_ehip_data_am_valid_in.pmaRsfec_ehip_tx_ehip_data_am_valid_in
	                .pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,                   pmaRsfec_ehip_tx_ehip_dv.pmaRsfec_ehip_tx_ehip_dv
	                .pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,           pmaRsfec_ehip_tx_ehip_fifo_rst_n.pmaRsfec_ehip_tx_ehip_fifo_rst_n
	                .reconfig_clk                               (i_reconfig_clk),                               //   input,    width = 2,                               reconfig_clk.clk
	                .reconfig_reset                             (i_xcvr_reconfig_reset),                             //   input,    width = 2,                             reconfig_reset.reset
	                .reconfig_write                             (i_ptp_reconfig_write[1]),                             //   input,    width = 2,                              reconfig_avmm.write
	                .reconfig_read                              (i_ptp_reconfig_read[1]),                              //   input,    width = 2,                                           .read
	                .reconfig_address                           (i_ptp_reconfig_address[19*LANES2-1:19]),                           //   input,   width = 11**,                                           .address
	                .reconfig_writedata                         (i_ptp_reconfig_writedata[8*LANES2-1:8]),                         //   input,   width = 64,                                           .writedata
	                .reconfig_readdata                          (o_ptp_reconfig_readdata[8*LANES2-1:8]),                          //  output,   width = 64,                                           .readdata
	                .reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[1]),                       //  output,    width = 2,                                           .waitrequest
	                .RSFEC_ehip_clock                           (),                           //   input,    width = 1,                           RSFEC_ehip_clock.RSFEC_ehip_clock
	                .RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,                   RSFEC_ehip_tx_adpt_clock.RSFEC_ehip_tx_adpt_clock
	                .rx_aib_reset                               ({&i_sl_rx_aib_reset}),                               //   input,    width = 2,                               rx_aib_reset.rx_aib_reset
	                .rx_clkout                                  (rx_clkout_ptp[1]),                                  //  output,    width = 2,                                  rx_clkout.clk
	                .rx_clkout2                                 (rx_clkout2_ptp[1]),                                 //                                 rx_clkout2.clk
	                .rx_coreclkin                               (ptp_ch_hr_clk),                               //   input,    width = 2,                               rx_coreclkin.clk
	                .rx_enh_aligned                             (),                             //  output,    width = 2,                             rx_enh_aligned.rx_enh_aligned
	                .rx_enh_blk_lock                            (),                            //  output,    width = 2,                            rx_enh_blk_lock.rx_enh_blk_lock
	                .rx_enh_highber                             (),                             //  output,    width = 2,                             rx_enh_highber.rx_enh_highber
	                .rx_enh_local_fault                         (),                         //  output,    width = 2,                         rx_enh_local_fault.rx_enh_local_fault
	                .rx_enh_pause                               (),                               //  output,    width = 2,                               rx_enh_pause.rx_enh_pause
	                .rx_enh_pfc                                 (),                                 //  output,   width = 16,                                 rx_enh_pfc.rx_enh_pfc
	                .rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 rx_enh_pmaif_fifo_overflow.rx_enh_pmaif_fifo_overflow
	                .rx_enh_remote_fault                        (),                        //  output,    width = 2,                        rx_enh_remote_fault.rx_enh_remote_fault
	                .rx_enh_reset                               (),                               //   input,    width = 2,                               rx_enh_reset.rx_enh_reset
	                .rx_enh_reset_stat                          (),                          //  output,    width = 2,                          rx_enh_reset_stat.rx_enh_reset_stat
	                .rx_enh_signal_ok                           (),                           //   input,    width = 2,                           rx_enh_signal_ok.rx_enh_signal_ok
	                .rx_fifo_ready                              (),                              //  output,    width = 2,                              rx_fifo_ready.rx_fifo_ready
	                //.rx_fifo_latency_adj_ena                    (i_sl_ptp_aib_rxfifo_latency_adj_ena),
	                .rx_parallel_data                           (nphy_ptp_rx_parallel_data[1]),                           //  output,  width = 160,                           rx_parallel_data.rx_parallel_data
	                .rx_pma_ready                               (sl_ptp_rx_pma_ready[1]),                               //  output,    width = 2,                               rx_pma_ready.rx_pma_ready
	                .rx_pmaif_reset                             (),                             //   input,    width = 2,                             rx_pmaif_reset.rx_pmaif_reset
	                .rx_transfer_ready                          (sl_ptp_rx_transfer_ready_int[1]),                          //  output,    width = 2,                          rx_transfer_ready.rx_transfer_ready
	                .tx_aib_reset                               ({&i_sl_tx_aib_reset}),                                //   input,    width = 2,                               tx_aib_reset.tx_aib_reset
	                .tx_clkout                                  (tx_clkout_ptp[1]),                                  //  output,    width = 2,                                  tx_clkout.clk
	                .tx_clkout2                                 (tx_clkout2_ptp[1]),                                 //                                 tx_clkout2.clk
	                .tx_coreclkin                               (ptp_ch_hr_clk),                               //   input,    width = 2,                               tx_coreclkin.clk
	                .tx_coreclkin2                              (ptp_ch_fr_clk),                               //   input,    width = 2,                               tx_coreclkin.clk
	                .tx_dll_lock                                (sl_ptp_plloff_tx_dll_lock),                                //  output,    width = 2,                                tx_dll_lock.tx_dll_lock
	                .tx_enh_pause                               (),                               //   input,    width = 2,                               tx_enh_pause.tx_enh_pause
	                .tx_enh_pfc                                 (),                                 //   input,   width = 16,                                 tx_enh_pfc.tx_enh_pfc
	                .tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,             tx_enh_pmaif_fifo_almost_empty.tx_enh_pmaif_fifo_almost_empty
	                .tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,              tx_enh_pmaif_fifo_almost_full.tx_enh_pmaif_fifo_almost_full
	                .tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,                 tx_enh_pmaif_fifo_overflow.tx_enh_pmaif_fifo_overflow
	                .tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,                tx_enh_pmaif_fifo_underflow.tx_enh_pmaif_fifo_underflow
	                .tx_enh_reset                               (),                               //   input,    width = 2,                               tx_enh_reset.tx_enh_reset
	                .tx_enh_reset_stat                          (),                          //  output,    width = 2,                          tx_enh_reset_stat.tx_enh_reset_stat
	                .tx_fifo_ready                              (),                              //  output,    width = 2,                              tx_fifo_ready.tx_fifo_ready
	                .tx_parallel_data                           (nphy_ptp_tx_parallel_data[1]),                           //   input,  width = 160,                           tx_parallel_data.tx_parallel_data
	                .tx_pma_ready                               (sl_ptp_tx_pma_ready[1]),                               //  output,    width = 2,                               tx_pma_ready.tx_pma_ready
	                .tx_pmaif_reset                             (),                             //   input,    width = 2,                             tx_pmaif_reset.tx_pmaif_reset
	                .tx_transfer_ready                          (sl_ptp_tx_transfer_ready_int[1])                           //  output,    width = 2,                          tx_transfer_ready.tx_transfer_ready
	            );
            end

                assign o_rx_transfer_ready = '0;
                assign o_tx_transfer_ready = '0;
        end
        else
		begin
    // this is required only in 100G NON PTP modes
if (!(ENABLE_PTP_TOG || (ENABLE_PTP && ((core_variant == 3) && (active_channel == 1))))) begin
            assign ptp_clk  = 1'b0;
            assign ptp_ch_hr_clk = 1'b0;
            assign ptp_ch_fr_clk = 1'b0;
          end
    assign nphy_ptp_rx_parallel_data = 'b0;
    assign sl_ptp_rx_transfer_ready = 2'b11;
    assign sl_ptp_tx_transfer_ready = 2'b11;

		end
    endgenerate

wire  tmp_clk3, tmp_clk2, tmp_clk1;

   generate
      if ((core_variant==2 || (core_variant==3 && active_channel==1)) && ((ehip_mode == "ehip_mac_no_fec" || ehip_mode =="ehip_pcs_no_fec" || ehip_mode == "ehip_otn_no_fec" || ehip_mode == "ehip_pcs66_no_fec")))
        begin : E100GX4_NO_FEC


assign elane_ehip_shared_clk            = {LANES6{o_ehip_clk}};
	assign xcvr_fr_tx_clk[5:4]		= 2'b0;
  assign rx_parallel_data[6*80-1:4*80] = {LANES2{78'b0}};

                eth_100g_cvl_nrz_alt_ehipc3_fm_xcvrnphy_fme_2420_4f4z7my altera_xcvr_native_inst (
		.pll_refclk0(i_refclk[0]),					//in,1b		pll_refclk0.clk
		.rx_coreclkin({LANES4{ml_rx_coreclkin}}),				//in.4b		rx_coreclkin.clk
		.tx_coreclkin({LANES4{ml_tx_coreclkin}}),				//in.4b		tx_coreclkin.clk
		.tx_coreclkin2({LANES4{ml_tx_coreclkin2}}),				//in.4b		tx_coreclkin2.clk
		.aib_ehip_rx_ehip_clk({LANES4{o_ehip_clk}}),			//in,4b		aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
		.aib_ehip_rx_ehip_fr_clk({LANES4{o_ehip_dist_fr_rx_clk}}),	//in,4b		aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
		.aib_ehip_rx_fec_fr_clk({LANES4{o_fec_dist_fr_rx_clk}}),	//in.4b		aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
		.aib_ehip_tx_ehip_clk({LANES4{o_ehip_clk}}),			//in.4b		aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
                .pma_ehip_rx_ehip_clk_div2({4{o_ehip_clk}}), 			//
                .pma_ehip_tx_ehip_clk_div2({4{o_ehip_clk}}), 			//

	        .RSFEC_ehip_clock(o_ehip_clk),					//in, 402mhz ==> connect wrong
	        .pmaRsfec_ehip_tx_ehip_data(core_tx_data),			//in
	        .pmaRsfec_ehip_tx_ehip_dv(core_tx_data_valid),			//in
	        .pmaRsfec_ehip_tx_ehip_fifo_rst_n(core_tx_data_am_valid),	//in
	        .ehip_pmaRsfec_fec_rx_data(core_rx_data),			//out
	        .ehip_pmaRsfec_fec_rx_data_valid(core_rx_data_valid),		//out
	        .ehip_pmaRsfec_fec_rx_data_am_valid(core_rx_data_am_valid),	//out

		.pma_ehip_rx_ehip_fifo_rst_n({LANES4{h2a_rx_ehip_rst_n}}),	//in.4b

		.rx_aib_reset(i_rx_aib_reset),					//in.4b
		.tx_aib_reset(i_tx_aib_reset),					//in.4b
		.rx_pmaif_reset(i_rx_pmaif_reset),				//in.4b
		.tx_pmaif_reset(i_tx_pmaif_reset),				//in.4b
		.enh_reset(4'hf),						//in.4b
		.rx_enh_reset(4'hf),						//in.4b
		.tx_enh_reset(4'hf),						//in.4b

                .ehip_pma_tx_pma_clk(xcvr_fr_tx_clk[LANES4-1:0]),           	//out,4b
		.rx_clkout(rx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
		.tx_clkout(tx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
		.rx_clkout2(rx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
		.tx_clkout2(tx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
		.ehip_aib_tx_transfer_div2_clk({tmp_clk3, tmp_clk2, tmp_clk1, ehip_clk}), //out,4b

		.rx_serial_data(i_rx_serial_data),	 			//in, 4b
		.rx_serial_data_n(i_rx_serial_data_n),			 	//in, 4b
		.tx_serial_data(o_tx_serial_data),				//out,4b
		.tx_serial_data_n(o_tx_serial_data_n),				//out,4b
		.rx_parallel_data(rx_parallel_data[LANES4*80-1:0]),		//out,320b
		.tx_parallel_data(tx_parallel_data_r[LANES4*80-1:0]),		//in, 320b

		.ehip_aib_aib_status(a2h_hip_aib_status), 			//out.12b
		.aib_ehip_rx_sync_data(ehip_aib_sync_data_in[LANES4*78-1:0]),	//in,312b
                .hip_aib_fsr_in(hip_aib_fsr_in[LANES4*4-1:0]),
                .hip_aib_ssr_in(hip_aib_ssr_in[LANES4*40-1:0]),
		.ehip_aib_tx_sync_data(ehip_aib_sync_data_out[LANES4*78-1:0]),	//out.312b

		.enh_pld_ready(4'b0),			//in,4b
		.rx_pma_ready(rx_pma_ready[LANES4-1:0]),			//out,4b
		.tx_pma_ready(tx_pma_ready[LANES4-1:0]),			//out,4b
		.rx_is_lockedtodata(rx_is_lockedtodata[LANES4-1:0]),		//out,4b
		.rx_transfer_ready(o_rx_transfer_ready[LANES4-1:0]),		//out,4b
		.tx_transfer_ready(o_tx_transfer_ready[LANES4-1:0]),		//out,4b

                .elane_ehip_shared_clk                      (elane_ehip_shared_clk[LANES-1:0]),			//in, width = 2,
                .elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LANES4*2-1:0]),		//in, width = 8,
                .elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LANES4*24-1:0]),     	//  in, width = 96,
                .elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LANES4*3-1:0]),	//  in, width = 12,
                .elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LANES4*3-1:0]),	//  in, width = 12,
                .elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LANES4*2-1:0]),	//  in, width = 8,
                .elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LANES4*24-1:0]),  	//  in, width = 96,
                .elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LANES4*3-1:0]),	//  in, width = 12,
                .elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LANES4*3-1:0]),//  in,width = 12,
                .elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LANES4*1-1:0]),      //  in,    width = 4,
                .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LANES4*6-1:0]), //  in,   width = 24,
                .elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LANES4*1-1:0]),   //  in,    width = 4,
                .ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[LANES4*23-1:0]),     		//   out,   width = 92,
                .ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[LANES4*12-1:0]),        	//   out,   width = 48,
                .ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[LANES4*2-1:0]),      	//   out,    width = 8,
                .ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[LANES4*1-1:0]),   	//   out,    width = 4,
                .ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[LANES4*1-1:0]),	//   out,    width = 4,
                .ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[LANES4*1-1:0]),	//   out,    width = 4,
                .ehip_elane_am_detect                       (ehip_elane_am_detect[LANES4*1-1:0]),           	//   out,    width = 4,
                .ehip_elane_am_insert                       (ehip_elane_am_insert[LANES4*1-1:0]),           	//   out,    width = 4,
                .ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[LANES4*1-1:0]),     	//   out,    width = 4,
                .ehip_elane_shared_clear                    (ehip_elane_shared_clear[LANES4*1-1:0]),        	//   out,    width = 4,
		.enh_clear_internal_error		    ({LANES4{i_sl_clear_internal_err[0]}}),			//in, width =4,
		.enh_force_rcfg_reset			    (4'hf),				//in, width =4,
                .enh_initialized                            (), 				//output,    width = 4,
                .enh_internal_error                         (),                    		//  output,    width = 4,
                .osc_transfer_en                            (),                         	//  output,    width = 4,
                .rx_enh_aligned                             (),                         	//  output,    width = 4,
                .rx_enh_blk_lock                            (),                 		//  output,    width = 4,
                .rx_enh_highber                             (),                  		//  output,    width = 4,
                .rx_enh_local_fault                         (),              			//  output,    width = 4,
                .rx_enh_pause                               (),                    		//  output,    width = 4,
                .rx_enh_pfc                                 (),                      		//  output,   width = 32,
                .rx_enh_pmaif_fifo_overflow                 (),            			//  output,    width = 4,
                .rx_enh_remote_fault                        (),                  	 	//  output,    width = 4,
                .rx_enh_reset_stat                          (),                     		//  output,    width = 4,
                .rx_enh_signal_ok                           (4'b0),                       	//   input,    width = 4,
                .rx_fifo_ready                              (o_rx_fifo_ready),                  //  output,    width = 4,
                .tx_dll_lock                                (o_tx_dll_lock[LANES4*1-1:0]),      //  output,    width = 4,
                .tx_enh_pause                               (4'b0),                         	//   input,   width = 1,
                .tx_enh_pfc                                 (32'b0),                         	//   input,   width = 8,
                .tx_enh_pmaif_fifo_almost_empty             (),					//  output,    width = 4,
                .tx_enh_pmaif_fifo_almost_full              (),					//  output,    width = 4,
                .tx_enh_pmaif_fifo_overflow                 (),					//  output,    width = 4,
                .tx_enh_pmaif_fifo_underflow                (),					//  output,    width = 4,
                .tx_fifo_ready                              (o_tx_fifo_ready),			//  output,    width = 4,

              // Reconfig Interface
		.reconfig_clk({LANES4{i_xcvr_reconfig_clk}}),				//in,4b
		.reconfig_reset({LANES4{i_xcvr_reconfig_reset}}),			//in,4b
		.reconfig_write(i_xcvr_reconfig_write[LANES4-1:0]),			//in,4b
		.reconfig_read(i_xcvr_reconfig_read[LANES4-1:0]),			//in,4b
		.reconfig_address(i_xcvr_reconfig_address[LANES4*19-1:0]),		//in,80b
		.reconfig_writedata(i_xcvr_reconfig_writedata[LANES4*8-1:0]),		//in,128b
		.reconfig_readdata(o_xcvr_reconfig_readdata[LANES4*8-1:0]),		//out,128b
		.reconfig_waitrequest(o_xcvr_reconfig_waitrequest[LANES4-1:0])		//out,4b
        );
        end // E100GX4_NO_FEC
   endgenerate



   generate
      if ((core_variant==2 || (core_variant==3 && active_channel==1)) && (ehip_mode == "ehip_mac" || ehip_mode =="ehip_pcs" || ehip_mode == "ehip_otn" || ehip_mode == "ehip_pcs66") && (bti_preserve==0))
        begin : E100GX4_FEC
		 assign xcvr_fr_tx_clk[5:4]		= 2'b0;
                 assign elane_ehip_shared_clk 	= {LANES6{o_ehip_clk}};
  assign rx_parallel_data[6*80-1:4*80] = {LANES2{78'b0}};

                eth_100g_cvl_nrz_alt_ehipc3_fm_xcvrnphy_fme_2420_4f4z7my altera_xcvr_native_inst (
		.rsfec_usr_avmm2_rst(),						//in,1b

		.pll_refclk0(i_refclk[0]),					//in,1b		pll_refclk0.clk
		.rx_coreclkin({LANES4{ml_rx_coreclkin}}),				//in.4b		rx_coreclkin.clk
		.tx_coreclkin({LANES4{ml_tx_coreclkin}}),				//in.4b		tx_coreclkin.clk
		.tx_coreclkin2({LANES4{ml_tx_coreclkin2}}),				//in.4b		tx_coreclkin2.clk
		.aib_ehip_rx_ehip_clk({LANES4{o_ehip_clk}}),			//in,4b		aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
		.aib_ehip_rx_ehip_fr_clk({LANES4{o_ehip_dist_fr_rx_clk}}),	//in,4b		aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
		.aib_ehip_rx_fec_fr_clk({LANES4{o_fec_dist_fr_rx_clk}}),	//in.4b		aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
		.aib_ehip_tx_ehip_clk({LANES4{o_ehip_clk}}),			//in.4b		aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
                .pma_ehip_rx_ehip_clk_div2({4{o_ehip_clk}}),                    //
                .pma_ehip_tx_ehip_clk_div2({4{o_ehip_clk}}),                    //


                .reconfig_rsfec_clk(i_rsfec_reconfig_clk),                      //in,1b
                .reconfig_rsfec_reset(i_xcvr_reconfig_reset),                   //in,1b
                .reconfig_rsfec_write(i_rsfec_reconfig_write),                  //in,1b
                .reconfig_rsfec_read(i_rsfec_reconfig_read),                    //in,1b
                .reconfig_rsfec_address(i_rsfec_reconfig_addr[11-1:0]),         //in,11b
                .reconfig_rsfec_writedata(i_rsfec_reconfig_writedata),   //in,8b
                .reconfig_rsfec_readdata(o_rsfec_reconfig_readdata),     //out,8b
                .reconfig_rsfec_waitrequest(o_rsfec_reconfig_waitrequest),      //out,1b
	        .RSFEC_ehip_clock(o_ehip_clk),					//in, 402mhz
	        .pmaRsfec_ehip_tx_ehip_data(core_tx_data),			//in
	        .pmaRsfec_ehip_tx_ehip_dv(core_tx_data_valid),			//in
	        .pmaRsfec_ehip_tx_ehip_fifo_rst_n(core_tx_data_am_valid),	//in, Ilkay suggest connect to core_tx_data_am_valid, but it may not correct
                .pmaRsfec_ehip_tx_ehip_data_am_valid_in(core_tx_data_am_valid),	//input,   width = 1
	        .ehip_pmaRsfec_fec_rx_data(core_rx_data),			//out
	        .ehip_pmaRsfec_fec_rx_data_valid(core_rx_data_valid),		//out
	        .ehip_pmaRsfec_fec_rx_data_am_valid(core_rx_data_am_valid),	//out

		.pma_ehip_rx_ehip_fifo_rst_n({LANES4{h2a_rx_ehip_rst_n}}),	//in.4b

		.rx_aib_reset(i_rx_aib_reset),					//in.4b
		.tx_aib_reset(i_tx_aib_reset),					//in.4b
		.enh_reset(4'hf), //i_sl_ehip_reset),				//in.4b
		.rx_enh_reset(4'hf), //i_sl_ehip_rx_reset),			//in.4b
		.tx_enh_reset(4'hf), //i_sl_ehip_tx_reset),			//in.4b
		.rx_pmaif_reset(i_rx_pmaif_reset),				//in.4b
		.tx_pmaif_reset(i_tx_pmaif_reset),				//in.4b
		.rsfec_reset(~i_rsfec_reset),					//in.4b
		.rx_rsfec_reset(~i_rx_rsfec_reset),				//in.4b
		.tx_rsfec_reset(~i_tx_rsfec_reset),				//in.4b

                .ehip_pma_tx_pma_clk(xcvr_fr_tx_clk[LANES4-1:0]),     		//out,4b
		.rx_clkout(rx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
		.tx_clkout(tx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
		.rx_clkout2(rx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
		.tx_clkout2(tx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
		.ehip_aib_tx_transfer_div2_clk({tmp_clk3, tmp_clk2, tmp_clk1, ehip_clk}), //out,4b

		.rx_serial_data(i_rx_serial_data),	 			//in, 4b
		.rx_serial_data_n(i_rx_serial_data_n),			 	//in, 4b
		.tx_serial_data(o_tx_serial_data),				//out,4b
		.tx_serial_data_n(o_tx_serial_data_n),				//out,4b
		.rx_parallel_data(rx_parallel_data[LANES4*80-1:0]),		//out,320b
		.tx_parallel_data(tx_parallel_data_r[LANES4*80-1:0]),		//in, 320b

		.ehip_aib_aib_status(a2h_hip_aib_status), 			//out.12b
		.hip_aib_fsr_in(hip_aib_fsr_in[LANES4*4-1:0]),
		.hip_aib_ssr_in(hip_aib_ssr_in[LANES4*40-1:0]),
		.aib_ehip_rx_sync_data(ehip_aib_sync_data_in[LANES4*78-1:0]),	//in,312b
		.ehip_aib_tx_sync_data(ehip_aib_sync_data_out[LANES4*78-1:0]),	//out.312b

		.enh_pld_ready(4'b0),			//in,4b
		.rx_pma_ready(rx_pma_ready[LANES4-1:0]),			//out,4b
		.tx_pma_ready(tx_pma_ready[LANES4-1:0]),			//out,4b
		.rx_is_lockedtodata(rx_is_lockedtodata[LANES4-1:0]),		//out,4b
		.rx_transfer_ready(o_rx_transfer_ready[LANES4-1:0]),		//out,4b
		.tx_transfer_ready(o_tx_transfer_ready[LANES4-1:0]),		//out,4b

                //new signals
		.RSFEC_ehip_tx_adpt_clock(/*RSFEC_ehip_tx_adpt_clock[LANES-1:0]*/),	//in, 4b
		//.delay_measurement_clkout(/*delay_measurement_clkout[LANES-1:0]*/),	//out, 4b
		//.delay_measurement_clkout2(/*delay_measurement_clkout2[LANES-1:0]*/), //out, 4b

                //new rsfec signals
		.o_rsfec_channel_ssr(o_rsfec_channel_ssr),			//out,32b
		.i_rsfec_pld_ready(i_ehip_pld_ready),				//in, tmp connecto to i_ehip_pld_ready(dir from rst_cntl)
		.rsfec_signal_ok({4{rsfec_signal_ok_from_top}}), 		//from the top
		.rsfec_o_config_done(/*rsfec_o_config_done*/),			//out,1b
		.rsfec_o_fec_ready(rsfec_o_fec_ready),				//out 1b
		.rsfec_o_internal_error(/*rsfec_o_internal_error*/),		//out 1b
		.rsfec_o_status_rx_not_align(/*rsfec_o_status_rx_not_align*/),	//out 1b
		.rsfec_o_status_rx_not_deskew(/*rsfec_o_status_rx_not_deskew*/),//out 1b
		.rsfec_o_tx_dsk_valid(/*rsfec_o_tx_dsk_valid*/),		//out 1b
		.enh_ready(/*enh_ready[LANES-1:0]*/),				//out 4b
		.enh_reset_stat(/*enh_reset_stat[LANES-1:0]*/),			//out 4b
		.tx_enh_reset_stat(/*tx_enh_reset_stat[LANES-1:0]*/),		//out 4b

                .elane_ehip_shared_clk                      (elane_ehip_shared_clk[LANES-1:0]),			//in, width = 2,
                .elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LANES4*2-1:0]),		//in, width = 8,
                .elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LANES4*24-1:0]),     	//  in, width = 96,
                .elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LANES4*3-1:0]),	//  in, width = 12,
                .elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LANES4*3-1:0]),	//  in, width = 12,
                .elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LANES4*2-1:0]),	//  in, width = 8,
                .elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LANES4*24-1:0]),  	//  in, width = 96,
                .elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LANES4*3-1:0]),	//  in, width = 12,
                .elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LANES4*3-1:0]),//  in,width = 12,
                .elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LANES4*1-1:0]),      //  in,    width = 4,
                .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LANES4*6-1:0]), //  in,   width = 24,
                .elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LANES4*1-1:0]),   //  in,    width = 4,
                .ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[LANES4*23-1:0]),     		//   out,   width = 92,
                .ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[LANES4*12-1:0]),        	//   out,   width = 48,
                .ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[LANES4*2-1:0]),      	//   out,    width = 8,
                .ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[LANES4*1-1:0]),   	//   out,    width = 4,
                .ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[LANES4*1-1:0]),	//   out,    width = 4,
                .ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[LANES4*1-1:0]),	//   out,    width = 4,
                .ehip_elane_am_detect                       (ehip_elane_am_detect[LANES4*1-1:0]),           	//   out,    width = 4,
                .ehip_elane_am_insert                       (ehip_elane_am_insert[LANES4*1-1:0]),           	//   out,    width = 4,
                .ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[LANES4*1-1:0]),     	//   out,    width = 4,
                .ehip_elane_shared_clear                    (ehip_elane_shared_clear[LANES4*1-1:0]),        	//   out,    width = 4,
		.enh_clear_internal_error		    (4'b0),			//in, width =4,
		.enh_force_rcfg_reset			    (4'hf),			//in, width =4,
                .enh_initialized                            (), 			//output,    width = 4,
                .enh_internal_error                         (),                    	//  output,    width = 4,
                .osc_transfer_en                            (),                         //  output,    width = 4,
                .rx_enh_aligned                             (),                         //  output,    width = 4,
                .rx_enh_blk_lock                            (),                 	//  output,    width = 4,
                .rx_enh_highber                             (),                  	//  output,    width = 4,
                .rx_enh_local_fault                         (),              		//  output,    width = 4,
                .rx_enh_pause                               (),                    	//  output,    width = 4,
                .rx_enh_pfc                                 (),                      	//  output,   width = 32,
                .rx_enh_pmaif_fifo_overflow                 (),            		//  output,    width = 4,
                .rx_enh_remote_fault                        (),                  	//  output,    width = 4,
                .rx_enh_reset_stat                          (),                     	//  output,    width = 4,
                .rx_enh_signal_ok                           (4'b0),                     //   input,    width = 4,
                .rx_fifo_ready                              (o_rx_fifo_ready),                    	//  output,    width = 4,
                .tx_dll_lock                                (o_tx_dll_lock[LANES4*1-1:0]),            	//  output,    width = 4,
                .tx_enh_pause                               (4'b0),                     //   input,   width = 1,
                .tx_enh_pfc                                 (32'b0),                    //   input,   width = 8,
                .tx_enh_pmaif_fifo_almost_empty             (),		//  output,    width = 4,
                .tx_enh_pmaif_fifo_almost_full              (),		//  output,    width = 4,
                .tx_enh_pmaif_fifo_overflow                 (),		//  output,    width = 4,
                .tx_enh_pmaif_fifo_underflow                (),		//  output,    width = 4,
                .tx_fifo_ready                              (o_tx_fifo_ready),				//  output,    width = 4,

              // Reconfig Interface
		.reconfig_clk({LANES4{i_xcvr_reconfig_clk}}),				//in,4b
		.reconfig_reset({LANES4{i_xcvr_reconfig_reset}}),			//in,4b
		.reconfig_write(i_xcvr_reconfig_write[LANES4-1:0]),			//in,4b
		.reconfig_read(i_xcvr_reconfig_read[LANES4-1:0]),			//in,4b
		.reconfig_address(i_xcvr_reconfig_address[LANES4*19-1:0]),		//in,80b
		.reconfig_writedata(i_xcvr_reconfig_writedata[LANES4*8-1:0]),		//in,128b
		.reconfig_readdata(o_xcvr_reconfig_readdata[LANES4*8-1:0]),		//out,128b
		.reconfig_waitrequest(o_xcvr_reconfig_waitrequest[LANES4-1:0])		//out,4b
        );

end // E100GX4_FEC
endgenerate

   generate
      if ((core_variant==2 || (core_variant==3 && active_channel==1)) && (ehip_mode == "ehip_mac" || ehip_mode =="ehip_pcs" || ehip_mode == "ehip_otn" || ehip_mode == "ehip_pcs66") && (bti_preserve==1))
        begin : E100GX4_FEC_BTI_PRESERVE
         assign xcvr_fr_tx_clk[5:4]     = 2'b0;
                 assign elane_ehip_shared_clk   = {LANES6{o_ehip_clk}};
  assign rx_parallel_data[6*80-1:4*80] = {LANES2{78'b0}};

                eth_100g_cvl_nrz_alt_ehipc3_fm_xcvrnphy_fme_2420_4f4z7my altera_xcvr_native_inst (
        .rsfec_usr_avmm2_rst(),                     //in,1b

        .pll_refclk0(i_refclk[0]),                  //in,1b     pll_refclk0.clk
                .pll_refclk1(i_refclk[1]),
        .rx_coreclkin({LANES4{ml_rx_coreclkin}}),             //in.4b     rx_coreclkin.clk
        .tx_coreclkin({LANES4{ml_tx_coreclkin}}),             //in.4b     tx_coreclkin.clk
        .tx_coreclkin2({LANES4{ml_tx_coreclkin2}}),             //in.4b     tx_coreclkin2.clk
        .aib_ehip_rx_ehip_clk({LANES4{o_ehip_clk}}),            //in,4b     aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
        .aib_ehip_rx_ehip_fr_clk({LANES4{o_ehip_dist_fr_rx_clk}}),  //in,4b     aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
        .aib_ehip_rx_fec_fr_clk({LANES4{o_fec_dist_fr_rx_clk}}),    //in.4b     aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
        .aib_ehip_tx_ehip_clk({LANES4{o_ehip_clk}}),            //in.4b     aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
                .pma_ehip_rx_ehip_clk_div2({4{o_ehip_clk}}),                    //
                .pma_ehip_tx_ehip_clk_div2({4{o_ehip_clk}}),                    //


                .reconfig_rsfec_clk(i_rsfec_reconfig_clk),                      //in,1b
                .reconfig_rsfec_reset(i_xcvr_reconfig_reset),                   //in,1b
                .reconfig_rsfec_write(i_rsfec_reconfig_write),                  //in,1b
                .reconfig_rsfec_read(i_rsfec_reconfig_read),                    //in,1b
                .reconfig_rsfec_address(i_rsfec_reconfig_addr[11-1:0]),         //in,11b
                .reconfig_rsfec_writedata(i_rsfec_reconfig_writedata),   //in,8b
                .reconfig_rsfec_readdata(o_rsfec_reconfig_readdata),     //out,8b
                .reconfig_rsfec_waitrequest(o_rsfec_reconfig_waitrequest),      //out,1b
            .RSFEC_ehip_clock(o_ehip_clk),                  //in, 402mhz
            .pmaRsfec_ehip_tx_ehip_data(core_tx_data),          //in
            .pmaRsfec_ehip_tx_ehip_dv(core_tx_data_valid),          //in
            .pmaRsfec_ehip_tx_ehip_fifo_rst_n(core_tx_data_am_valid),   //in, Ilkay suggest connect to core_tx_data_am_valid, but it may not correct
                .pmaRsfec_ehip_tx_ehip_data_am_valid_in(core_tx_data_am_valid), //input,   width = 1
            .ehip_pmaRsfec_fec_rx_data(core_rx_data),           //out
            .ehip_pmaRsfec_fec_rx_data_valid(core_rx_data_valid),       //out
            .ehip_pmaRsfec_fec_rx_data_am_valid(core_rx_data_am_valid), //out

        .pma_ehip_rx_ehip_fifo_rst_n({LANES4{h2a_rx_ehip_rst_n}}),  //in.4b

        .rx_aib_reset(i_rx_aib_reset),                  //in.4b
        .tx_aib_reset(i_tx_aib_reset),                  //in.4b
        .enh_reset(4'hf), //i_sl_ehip_reset),               //in.4b
        .rx_enh_reset(4'hf), //i_sl_ehip_rx_reset),         //in.4b
        .tx_enh_reset(4'hf), //i_sl_ehip_tx_reset),         //in.4b
        .rx_pmaif_reset(i_rx_pmaif_reset),              //in.4b
        .tx_pmaif_reset(i_tx_pmaif_reset),              //in.4b
        .rsfec_reset(~i_rsfec_reset),                   //in.4b
        .rx_rsfec_reset(~i_rx_rsfec_reset),             //in.4b
        .tx_rsfec_reset(~i_tx_rsfec_reset),             //in.4b

                .ehip_pma_tx_pma_clk(xcvr_fr_tx_clk[LANES4-1:0]),           //out,4b
        .rx_clkout(rx_clkout[MAX_XCVR_CH-1:0]),                     //out,4b
        .tx_clkout(tx_clkout[MAX_XCVR_CH-1:0]),                     //out,4b
        .rx_clkout2(rx_clkout2[MAX_XCVR_CH-1:0]),                   //out,4b
        .tx_clkout2(tx_clkout2[MAX_XCVR_CH-1:0]),                   //out,4b
        .ehip_aib_tx_transfer_div2_clk({tmp_clk3, tmp_clk2, tmp_clk1, ehip_clk}), //out,4b

        .rx_serial_data(i_rx_serial_data),              //in, 4b
        .rx_serial_data_n(i_rx_serial_data_n),              //in, 4b
        .tx_serial_data(o_tx_serial_data),              //out,4b
        .tx_serial_data_n(o_tx_serial_data_n),              //out,4b
        .rx_parallel_data(rx_parallel_data[LANES4*80-1:0]),     //out,320b
        .tx_parallel_data(tx_parallel_data_r[LANES4*80-1:0]),       //in, 320b

        .ehip_aib_aib_status(a2h_hip_aib_status),           //out.12b
            .hip_aib_fsr_in(hip_aib_fsr_in[LANES4*4-1:0]),
            .hip_aib_ssr_in(hip_aib_ssr_in[LANES4*40-1:0]),
        .aib_ehip_rx_sync_data(ehip_aib_sync_data_in[LANES4*78-1:0]),   //in,312b
        .ehip_aib_tx_sync_data(ehip_aib_sync_data_out[LANES4*78-1:0]),  //out.312b

        .enh_pld_ready(4'b0),           //in,4b
        .rx_pma_ready(rx_pma_ready[LANES4-1:0]),            //out,4b
        .tx_pma_ready(tx_pma_ready[LANES4-1:0]),            //out,4b
        .rx_is_lockedtodata(rx_is_lockedtodata[LANES4-1:0]),        //out,4b
        .rx_transfer_ready(o_rx_transfer_ready[LANES4-1:0]),        //out,4b
        .tx_transfer_ready(o_tx_transfer_ready[LANES4-1:0]),        //out,4b

                //new signals
        .RSFEC_ehip_tx_adpt_clock(/*RSFEC_ehip_tx_adpt_clock[LANES-1:0]*/), //in, 4b
        //.delay_measurement_clkout(/*delay_measurement_clkout[LANES-1:0]*/),   //out, 4b
        //.delay_measurement_clkout2(/*delay_measurement_clkout2[LANES-1:0]*/), //out, 4b

                //new rsfec signals
        .o_rsfec_channel_ssr(o_rsfec_channel_ssr),          //out,32b
        .i_rsfec_pld_ready(i_ehip_pld_ready),               //in, tmp connecto to i_ehip_pld_ready(dir from rst_cntl)
        .rsfec_signal_ok({4{rsfec_signal_ok_from_top}}),        //from the top
        .rsfec_o_config_done(/*rsfec_o_config_done*/),          //out,1b
        .rsfec_o_fec_ready(rsfec_o_fec_ready),              //out 1b
        .rsfec_o_internal_error(/*rsfec_o_internal_error*/),        //out 1b
        .rsfec_o_status_rx_not_align(/*rsfec_o_status_rx_not_align*/),  //out 1b
        .rsfec_o_status_rx_not_deskew(/*rsfec_o_status_rx_not_deskew*/),//out 1b
        .rsfec_o_tx_dsk_valid(/*rsfec_o_tx_dsk_valid*/),        //out 1b
        .enh_ready(/*enh_ready[LANES-1:0]*/),               //out 4b
        .enh_reset_stat(/*enh_reset_stat[LANES-1:0]*/),         //out 4b
        .tx_enh_reset_stat(/*tx_enh_reset_stat[LANES-1:0]*/),       //out 4b

                .elane_ehip_shared_clk                      (elane_ehip_shared_clk[LANES-1:0]),         //in, width = 2,
                .elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LANES4*2-1:0]),       //in, width = 8,
                .elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LANES4*24-1:0]),         //  in, width = 96,
                .elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LANES4*3-1:0]),    //  in, width = 12,
                .elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LANES4*3-1:0]), //  in, width = 12,
                .elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LANES4*2-1:0]),  //  in, width = 8,
                .elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LANES4*24-1:0]),    //  in, width = 96,
                .elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LANES4*3-1:0]),   //  in, width = 12,
                .elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LANES4*3-1:0]),//  in,width = 12,
                .elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LANES4*1-1:0]),      //  in,    width = 4,
                .elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LANES4*6-1:0]), //  in,   width = 24,
                .elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LANES4*1-1:0]),   //  in,    width = 4,
                .ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[LANES4*23-1:0]),          //   out,   width = 92,
                .ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[LANES4*12-1:0]),          //   out,   width = 48,
                .ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[LANES4*2-1:0]),        //   out,    width = 8,
                .ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[LANES4*1-1:0]),     //   out,    width = 4,
                .ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[LANES4*1-1:0]),    //   out,    width = 4,
                .ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[LANES4*1-1:0]),    //   out,    width = 4,
                .ehip_elane_am_detect                       (ehip_elane_am_detect[LANES4*1-1:0]),               //   out,    width = 4,
                .ehip_elane_am_insert                       (ehip_elane_am_insert[LANES4*1-1:0]),               //   out,    width = 4,
                .ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[LANES4*1-1:0]),         //   out,    width = 4,
                .ehip_elane_shared_clear                    (ehip_elane_shared_clear[LANES4*1-1:0]),            //   out,    width = 4,
        .enh_clear_internal_error           (4'b0),         //in, width =4,
        .enh_force_rcfg_reset               (4'hf),         //in, width =4,
                .enh_initialized                            (),             //output,    width = 4,
                .enh_internal_error                         (),                     //  output,    width = 4,
                .osc_transfer_en                            (),                         //  output,    width = 4,
                .rx_enh_aligned                             (),                         //  output,    width = 4,
                .rx_enh_blk_lock                            (),                     //  output,    width = 4,
                .rx_enh_highber                             (),                     //  output,    width = 4,
                .rx_enh_local_fault                         (),                     //  output,    width = 4,
                .rx_enh_pause                               (),                     //  output,    width = 4,
                .rx_enh_pfc                                 (),                         //  output,   width = 32,
                .rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 4,
                .rx_enh_remote_fault                        (),                     //  output,    width = 4,
                .rx_enh_reset_stat                          (),                         //  output,    width = 4,
                .rx_enh_signal_ok                           (4'b0),                     //   input,    width = 4,
                .rx_fifo_ready                              (o_rx_fifo_ready),                      //  output,    width = 4,
                .tx_dll_lock                                (o_tx_dll_lock[LANES4*1-1:0]),              //  output,    width = 4,
                .tx_enh_pause                               (4'b0),                     //   input,   width = 1,
                .tx_enh_pfc                                 (32'b0),                    //   input,   width = 8,
                .tx_enh_pmaif_fifo_almost_empty             (),     //  output,    width = 4,
                .tx_enh_pmaif_fifo_almost_full              (),     //  output,    width = 4,
                .tx_enh_pmaif_fifo_overflow                 (),     //  output,    width = 4,
                .tx_enh_pmaif_fifo_underflow                (),     //  output,    width = 4,
                .tx_fifo_ready                              (o_tx_fifo_ready),              //  output,    width = 4,

              // Reconfig Interface
        .reconfig_clk({LANES4{i_xcvr_reconfig_clk}}),               //in,4b
        .reconfig_reset({LANES4{i_xcvr_reconfig_reset}}),           //in,4b
        .reconfig_write(i_xcvr_reconfig_write[LANES4-1:0]),         //in,4b
        .reconfig_read(i_xcvr_reconfig_read[LANES4-1:0]),           //in,4b
        .reconfig_address(i_xcvr_reconfig_address[LANES4*19-1:0]),      //in,80b
        .reconfig_writedata(i_xcvr_reconfig_writedata[LANES4*8-1:0]),       //in,128b
        .reconfig_readdata(o_xcvr_reconfig_readdata[LANES4*8-1:0]),     //out,128b
        .reconfig_waitrequest(o_xcvr_reconfig_waitrequest[LANES4-1:0])      //out,4b
        );

end // E100GX4_FEC_BTI_PRESERVE
endgenerate

// 100G PTP

   generate
      if (ENABLE_PTP!=0 && core_variant==3 && active_channel==1 && ehip_mode == "ehip_mac_ptp_no_fec")
        begin : E100GX4_NOFEC_PTP_PR

            assign ptp_clk  = ECORE_5432_TIEOFF ? ptp_ehip_aib_tx_transfer_div2_clk[1] : ptp_ehip_aib_tx_transfer_div2_clk[0];
// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// When PTP channel PLL is turned off, the clock out will be X. So the corresponding clock out at IP level needs to be manually tieoff to prevent X propagation.
// ---------------------------------------------------------------------------------------------------------------------------------
//            assign tx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {ptp_pll_hr_clk_100g[0],ptp_pll_hr_clk_100g[1]} : ptp_pll_hr_clk_100g;
//            assign tx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {ptp_pll_fr_clk_100g[0],ptp_pll_fr_clk_100g[1]} : ptp_pll_fr_clk_100g;
//            assign rx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {rx_clkout_ptp [0],rx_clkout_ptp [1]} : rx_clkout_ptp;
//            assign rx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {rx_clkout2_ptp[0],rx_clkout2_ptp[1]} : rx_clkout2_ptp;
            assign tx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {1'b0,ptp_pll_hr_clk_100g[1]} : {1'b0,ptp_pll_hr_clk_100g[0]};
            assign tx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {1'b0,ptp_pll_fr_clk_100g[1]} : {1'b0,ptp_pll_fr_clk_100g[0]};
            assign rx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {1'b0,rx_clkout_ptp[1] } : {1'b0,rx_clkout_ptp[0] };
            assign rx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {1'b0,rx_clkout2_ptp[1]} : {1'b0,rx_clkout2_ptp[0]};
// ---------------------------------------------------------------------------------------------------------------------------------
            assign ptp_ch_hr_clk = enable_external_aib_clocking ? i_aib_clk :
                                   ENABLE_PTP                   ? ECORE_5432_TIEOFF ? ptp_pll_hr_clk_100g[1] : ptp_pll_hr_clk_100g[0] :
                                                                  i_tx_core_clk;
            assign ptp_ch_fr_clk = enable_external_aib_clocking ? i_aib_2x_clk :
                                   ENABLE_PTP                   ? ECORE_5432_TIEOFF ? ptp_pll_fr_clk_100g[1] : ptp_pll_fr_clk_100g[0] :
                                                                  tx_clkout2[0];

// ---------------------------------------------------------------------------------------------------------------------------------
// 22/Aug/2019 : HSD#1409425013 : With right NPHY setting, transfer_ready is up and therefore no longer need the remapping.
// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// When PLL is OFF, tx_transfer_ready will not up. So, we have to rely on tx_dll_lock instead to indicate AIB is ready.
// So, have to remap sl_ptp_tx/rx_transfer_ready.
// ---------------------------------------------------------------------------------------------------------------------------------
	    wire [LANES2-1:0]	ml_ptp_tx_transfer_ready;
	    wire [LANES2-1:0]	ml_ptp_rx_transfer_ready;
	    wire 		ml_ptp_plloff_tx_dll_lock;
//	    assign o_tx_transfer_ready[5:4] = ECORE_5432_TIEOFF ? {ml_ptp_tx_transfer_ready[1], ml_ptp_plloff_tx_dll_lock} : {ml_ptp_plloff_tx_dll_lock, ml_ptp_tx_transfer_ready[0]};
//	    assign o_rx_transfer_ready[5:4] = ECORE_5432_TIEOFF ? {ml_ptp_rx_transfer_ready[1], ml_ptp_plloff_tx_dll_lock} : {ml_ptp_plloff_tx_dll_lock, ml_ptp_rx_transfer_ready[0]};
	    assign o_tx_transfer_ready[5:4] = ml_ptp_tx_transfer_ready;
	    assign o_rx_transfer_ready[5:4] = ml_ptp_rx_transfer_ready;
// ---------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// Creating 2 PTP channels separately with different PLL setting.
// When EHIP_LOCATION_0/2, select PTP_CH[1] to turnoff the PLL.
// When EHIP_LOCATION_1/3, select PTP_CH[0] to turnoff the PLL.
// ---------------------------------------------------------------------------------------------------------------------------------
//           alt_ehipc3_fm_nphy_elane_ptp
//			 nphy_ptp
//			   (
//				.aib_ehip_rx_ehip_clk                       ({LANES2{o_ehip_clk}}), //   input,    width = 2,
//				.aib_ehip_rx_ehip_fr_clk                    ({LANES2{o_ehip_dist_fr_rx_clk}}), //   input,    width = 2,
//				.aib_ehip_rx_fec_fr_clk                     ({LANES2{o_fec_dist_fr_rx_clk}}),  //   input,    width = 2,
//				.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*4]),//   input,  width = 156,
//				.aib_ehip_tx_ehip_clk                       ({LANES2{o_ehip_clk}}),             //   input,    width = 2,
//				.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1:0]),      //  output,    width = 6,
//				.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*4]),//  output,  width = 156,
//				.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk),  //  output,    width = 2,
//				.ehip_elane_am_detect                       (),                       //  output,    width = 2,
//				.ehip_elane_am_insert                       (),                       //  output,    width = 2,
//				.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
//				.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
//				.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
//				.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
//				.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
//				.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
//				.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
//				.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
//				.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[5:4]),   //  output,
//				.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
//				.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
//				.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
//				.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
//				.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
//				.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
//				.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
//				.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
//				.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
//				.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
//				.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
//				.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
//				.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
//				.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
//				.elane_ehip_shared_clk                      (elane_ehip_shared_clk[5:4]), //   input,    width = 2,
//				.enh_clear_internal_error                   (),                   //   input,    width = 2,
//				.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
//				.enh_initialized                            (),                         //  output,    width = 2,
//				.enh_internal_error                         (),                         //  output,    width = 2,
//				.enh_pld_ready                              (),                         //   input,    width = 2,
//				.enh_ready                                  (),                         //  output,    width = 2,
//				.enh_reset                                  (2'h3),   //   input,    width = 2,
//				.enh_reset_stat                             (),                         //  output,    width = 2,
//				.hip_aib_fsr_in(hip_aib_fsr_in[6*4-1:4*4]),
//				.hip_aib_ssr_in(hip_aib_ssr_in[6*40-1:4*40]),
//				.osc_transfer_en                            (),                         //  output,    width = 2,
//				.pll_refclk0                                (i_refclk),                 //input,   width = 1,
//				.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
//				.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
//				.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
//				.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
//				.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
//				.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
//				.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
//				.reconfig_clk                               ({LANES2{i_reconfig_clk}}),  //   input,    width = 2,
//				.reconfig_reset                             ({LANES2{i_xcvr_reconfig_reset}}), //   input,    width = 2,
//				.reconfig_write                             (i_ptp_reconfig_write[LANES2-1:0]), //   input,    width = 2,
//				.reconfig_read                              (i_ptp_reconfig_read[LANES2-1:0]),  //   input,    width = 2,
//				.reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:0]),//   input,   width = 11**,
//				.reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:0]),//   input,   width = 64,
//				.reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:0]), //  output,   width = 64,
//				.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1:0]),//  output,    width = 2,
//				.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
//				.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
//				.rx_aib_reset                               ({2{i_rx_aib_reset[0]}}), //   input,    width = 2,
//				.rx_clkout                                  (rx_clkout_ptp),                                 //  output,    width = 2,
//				.rx_clkout2                                 (rx_clkout2_ptp),                                 //
//				.rx_coreclkin                               ({LANES2{ml_rx_coreclkin}}),          //   input,    width = 2,
//				.rx_enh_aligned                             (),                                 //  output,    width = 2,
//				.rx_enh_blk_lock                            (),                            //  output,    width = 2,
//				.rx_enh_highber                             (),                             //  output,    width = 2,
//				.rx_enh_local_fault                         (),                         //  output,    width = 2,
//				.rx_enh_pause                               (),                               //  output,    width = 2,
//				.rx_enh_pfc                                 (),                                 //  output,   width = 16,
//				.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
//				.rx_enh_remote_fault                        (),                        //  output,    width = 2,
//				.rx_enh_reset                               (2'h3),  //   input,    width = 2,
//				.rx_enh_reset_stat                          (),                          //  output,    width = 2,
//				.rx_enh_signal_ok                           (),                          //   input,    width = 2,
//				.rx_fifo_ready                              (),                          //  output,    width = 2,
//				.rx_parallel_data                           (rx_parallel_data[6*80-1:4*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
//				.rx_pma_ready                               (ptp_rx_pma_ready),                          //  output,    width = 2,
//				.rx_pmaif_reset                             (i_rx_pmaif_reset[3:2]),  //   input,    width = 2,
//				.rx_transfer_ready                          (o_rx_transfer_ready[5:4]),                          //  output,    width = 2,
//				.tx_aib_reset                               ({2{i_tx_aib_reset[0]}}), //   input,    width = 2,
//				.tx_clkout                                  (ptp_pll_hr_clk_100g),            //  output,    width = 2,
//				.tx_clkout2                                 (ptp_pll_fr_clk_100g),            //
//				.tx_coreclkin                               ({LANES2{ml_tx_coreclkin}}/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
//				.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ {LANES2{ml_tx_coreclkin2}}),//   input,
//				.tx_dll_lock                                (),                                //  output,    width = 2,
//				.tx_enh_pause                               (),                               //   input,    width = 2,
//				.tx_enh_pfc                                 (),                                 //   input,   width = 16,
//				.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
//				.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
//				.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
//				.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
//				.tx_enh_reset                               (2'h3),  //   input,    width = 2,
//				.tx_enh_reset_stat                          (),  //  output,    width = 2,
//				.tx_fifo_ready                              (),  //  output,    width = 2,
//				.tx_parallel_data                           (pp),		//in, 320b
//				.tx_pma_ready                               (ptp_tx_pma_ready),                               //  output,    width = 2,
//				.tx_pmaif_reset                             (i_tx_pmaif_reset[3:2]),  //   input,    width = 2,
//				.tx_transfer_ready                          (o_tx_transfer_ready[5:4]) //  output,    width = 2,
//				);

            if(ECORE_5432_TIEOFF) begin
		   // PTP_CH[0] - lower PTP channel PLL OFF.
	           alt_ehipc3_fm_nphy_elane_ptp_plloff
				 nphy_ptp0
				   (
					.aib_ehip_rx_ehip_clk                       (o_ehip_clk), //   input,    width = 2,
					.aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk), //   input,    width = 2,
					.aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),  //   input,    width = 2,
					.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*5-1:78*4]),//   input,  width = 156,
					.aib_ehip_tx_ehip_clk                       (o_ehip_clk),             //   input,    width = 2,
					.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[0]),      //  output,    width = 6,
					.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*5-1:78*4]),//  output,  width = 156,
					.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[0]),  //  output,    width = 2,
					.ehip_elane_am_detect                       (),                       //  output,    width = 2,
					.ehip_elane_am_insert                       (),                       //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
					.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
					.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
					.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
					.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
					.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
					.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[4]),   //  output,
					.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
					.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
					.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
					.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
					.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
					.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
					.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
					.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
					.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
					.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
					.elane_ehip_shared_clk                      (elane_ehip_shared_clk[4]), //   input,    width = 2,
					.enh_clear_internal_error                   (),                   //   input,    width = 2,
					.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
					.enh_initialized                            (),                         //  output,    width = 2,
					.enh_internal_error                         (),                         //  output,    width = 2,
					.enh_pld_ready                              (),                         //   input,    width = 2,
					.enh_ready                                  (),                         //  output,    width = 2,
					.enh_reset                                  (1'b1),   //   input,    width = 2,
					.enh_reset_stat                             (),                         //  output,    width = 2,
					.hip_aib_fsr_in				    (hip_aib_fsr_in[5*4-1:4*4]),
					.hip_aib_ssr_in			            (hip_aib_ssr_in[5*40-1:4*40]),
					.osc_transfer_en                            (),                         //  output,    width = 2,
					.pll_refclk0                                (i_refclk),                 //input,   width = 1,
					.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
					.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
					.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
					.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
					.reconfig_clk                               (i_reconfig_clk),  //   input,    width = 2,
					.reconfig_reset                             (i_xcvr_reconfig_reset), //   input,    width = 2,
					.reconfig_write                             (i_ptp_reconfig_write[0]), //   input,    width = 2,
					.reconfig_read                              (i_ptp_reconfig_read[0]),  //   input,    width = 2,
					.reconfig_address                           (i_ptp_reconfig_address[19-1:0]),//   input,   width = 11**,
					.reconfig_writedata                         (i_ptp_reconfig_writedata[8-1:0]),//   input,   width = 64,
					.reconfig_readdata                          (o_ptp_reconfig_readdata[8-1:0]), //  output,   width = 64,
					.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[0]),//  output,    width = 2,
					.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
					.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
					.rx_aib_reset                               (i_rx_aib_reset[0]), //   input,    width = 2,
					.rx_clkout                                  (rx_clkout_ptp[0]),                                 //  output,    width = 2,
					.rx_clkout2                                 (rx_clkout2_ptp[0]),                                 //
					.rx_coreclkin                               (ml_rx_coreclkin),          //   input,    width = 2,
					.rx_enh_aligned                             (),                                 //  output,    width = 2,
					.rx_enh_blk_lock                            (),                            //  output,    width = 2,
					.rx_enh_highber                             (),                             //  output,    width = 2,
					.rx_enh_local_fault                         (),                         //  output,    width = 2,
					.rx_enh_pause                               (),                               //  output,    width = 2,
					.rx_enh_pfc                                 (),                                 //  output,   width = 16,
					.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.rx_enh_remote_fault                        (),                        //  output,    width = 2,
					.rx_enh_reset                               (1'b1),  //   input,    width = 2,
					.rx_enh_reset_stat                          (),                          //  output,    width = 2,
					.rx_enh_signal_ok                           (),                          //   input,    width = 2,
					.rx_fifo_ready                              (),                          //  output,    width = 2,
					.rx_parallel_data                           (rx_parallel_data[5*80-1:4*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
					.rx_pma_ready                               (ptp_rx_pma_ready[0]),                          //  output,    width = 2,
					.rx_pmaif_reset                             (i_rx_pmaif_reset[2]),  //   input,    width = 2,
					.rx_transfer_ready                          (ml_ptp_rx_transfer_ready[0]),                          //  output,    width = 2,
					.tx_aib_reset                               (i_tx_aib_reset[0]), //   input,    width = 2,
					.tx_clkout                                  (ptp_pll_hr_clk_100g[0]),            //  output,    width = 2,
					.tx_clkout2                                 (ptp_pll_fr_clk_100g[0]),            //
					.tx_coreclkin                               (ml_tx_coreclkin/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
					.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ ml_tx_coreclkin2),//   input,
					.tx_dll_lock                                (ml_ptp_plloff_tx_dll_lock),                                //  output,    width = 2,
					.tx_enh_pause                               (),                               //   input,    width = 2,
					.tx_enh_pfc                                 (),                                 //   input,   width = 16,
					.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
					.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
					.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
					.tx_enh_reset                               (1'b1),  //   input,    width = 2,
					.tx_enh_reset_stat                          (),  //  output,    width = 2,
					.tx_fifo_ready                              (),  //  output,    width = 2,
					.tx_parallel_data                           (pp[80-1:0]),		//in, 320b
					.tx_pma_ready                               (ptp_tx_pma_ready[0]),                               //  output,    width = 2,
					.tx_pmaif_reset                             (i_tx_pmaif_reset[2]),  //   input,    width = 2,
					.tx_transfer_ready                          (ml_ptp_tx_transfer_ready[0]) //  output,    width = 2,
				 );

		   // PTP_CH[1] - upper PTP channel PLL ON.
	           alt_ehipc3_fm_nphy_elane_ptp
				 nphy_ptp1
				   (
					.aib_ehip_rx_ehip_clk                       (o_ehip_clk), //   input,    width = 2,
					.aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk), //   input,    width = 2,
					.aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),  //   input,    width = 2,
					.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*5]),//   input,  width = 156,
					.aib_ehip_tx_ehip_clk                       (o_ehip_clk),             //   input,    width = 2,
					.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1]),      //  output,    width = 6,
					.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*5]),//  output,  width = 156,
					.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[1]),  //  output,    width = 2,
					.ehip_elane_am_detect                       (),                       //  output,    width = 2,
					.ehip_elane_am_insert                       (),                       //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
					.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
					.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
					.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
					.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
					.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
					.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[5]),   //  output,
					.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
					.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
					.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
					.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
					.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
					.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
					.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
					.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
					.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
					.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
					.elane_ehip_shared_clk                      (elane_ehip_shared_clk[5]), //   input,    width = 2,
					.enh_clear_internal_error                   (),                   //   input,    width = 2,
					.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
					.enh_initialized                            (),                         //  output,    width = 2,
					.enh_internal_error                         (),                         //  output,    width = 2,
					.enh_pld_ready                              (),                         //   input,    width = 2,
					.enh_ready                                  (),                         //  output,    width = 2,
					.enh_reset                                  (1'b1),   //   input,    width = 2,
					.enh_reset_stat                             (),                         //  output,    width = 2,
					.hip_aib_fsr_in                             (hip_aib_fsr_in[6*4-1:5*4]),
					.hip_aib_ssr_in                             (hip_aib_ssr_in[6*40-1:5*40]),
					.osc_transfer_en                            (),                         //  output,    width = 2,
					.pll_refclk0                                (i_refclk),                 //input,   width = 1,
					.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
					.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
					.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
					.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
					.reconfig_clk                               (i_reconfig_clk),  //   input,    width = 2,
					.reconfig_reset                             (i_xcvr_reconfig_reset), //   input,    width = 2,
					.reconfig_write                             (i_ptp_reconfig_write[LANES2-1]), //   input,    width = 2,
					.reconfig_read                              (i_ptp_reconfig_read[LANES2-1]),  //   input,    width = 2,
					.reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:19]),//   input,   width = 11**,
					.reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:8]),//   input,   width = 64,
					.reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:8]), //  output,   width = 64,
					.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1]),//  output,    width = 2,
					.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
					.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
					.rx_aib_reset                               (i_rx_aib_reset[0]), //   input,    width = 2,
					.rx_clkout                                  (rx_clkout_ptp[1]),                                 //  output,    width = 2,
					.rx_clkout2                                 (rx_clkout2_ptp[1]),                                 //
					.rx_coreclkin                               (ml_rx_coreclkin),          //   input,    width = 2,
					.rx_enh_aligned                             (),                                 //  output,    width = 2,
					.rx_enh_blk_lock                            (),                            //  output,    width = 2,
					.rx_enh_highber                             (),                             //  output,    width = 2,
					.rx_enh_local_fault                         (),                         //  output,    width = 2,
					.rx_enh_pause                               (),                               //  output,    width = 2,
					.rx_enh_pfc                                 (),                                 //  output,   width = 16,
					.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.rx_enh_remote_fault                        (),                        //  output,    width = 2,
					.rx_enh_reset                               (1'b1),  //   input,    width = 2,
					.rx_enh_reset_stat                          (),                          //  output,    width = 2,
					.rx_enh_signal_ok                           (),                          //   input,    width = 2,
					.rx_fifo_ready                              (),                          //  output,    width = 2,
					.rx_parallel_data                           (rx_parallel_data[6*80-1:5*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
					.rx_pma_ready                               (ptp_rx_pma_ready[1]),                          //  output,    width = 2,
					.rx_pmaif_reset                             (i_rx_pmaif_reset[3]),  //   input,    width = 2,
					.rx_transfer_ready                          (ml_ptp_rx_transfer_ready[1]),                          //  output,    width = 2,
					.tx_aib_reset                               (i_tx_aib_reset[0]), //   input,    width = 2,
					.tx_clkout                                  (ptp_pll_hr_clk_100g[1]),            //  output,    width = 2,
					.tx_clkout2                                 (ptp_pll_fr_clk_100g[1]),            //
					.tx_coreclkin                               (ml_tx_coreclkin/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
					.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ ml_tx_coreclkin2),//   input,
					.tx_dll_lock                                (),                                //  output,    width = 2,
					.tx_enh_pause                               (),                               //   input,    width = 2,
					.tx_enh_pfc                                 (),                                 //   input,   width = 16,
					.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
					.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
					.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
					.tx_enh_reset                               (1'b1),  //   input,    width = 2,
					.tx_enh_reset_stat                          (),  //  output,    width = 2,
					.tx_fifo_ready                              (),  //  output,    width = 2,
					.tx_parallel_data                           (pp[LANES2*80-1:80]),		//in, 320b
					.tx_pma_ready                               (ptp_tx_pma_ready[1]),                               //  output,    width = 2,
					.tx_pmaif_reset                             (i_tx_pmaif_reset[3]),  //   input,    width = 2,
					.tx_transfer_ready                          (ml_ptp_tx_transfer_ready[1]) //  output,    width = 2,
				 );
            end else begin
		   // PTP_CH[0] - lower PTP channel PLL ON.
	           alt_ehipc3_fm_nphy_elane_ptp
				 nphy_ptp0
				   (
					.aib_ehip_rx_ehip_clk                       (o_ehip_clk), //   input,    width = 2,
					.aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk), //   input,    width = 2,
					.aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),  //   input,    width = 2,
					.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*5-1:78*4]),//   input,  width = 156,
					.aib_ehip_tx_ehip_clk                       (o_ehip_clk),             //   input,    width = 2,
					.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[0]),      //  output,    width = 6,
					.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*5-1:78*4]),//  output,  width = 156,
					.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[0]),  //  output,    width = 2,
					.ehip_elane_am_detect                       (),                       //  output,    width = 2,
					.ehip_elane_am_insert                       (),                       //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
					.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
					.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
					.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
					.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
					.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
					.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[4]),   //  output,
					.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
					.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
					.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
					.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
					.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
					.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
					.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
					.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
					.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
					.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
					.elane_ehip_shared_clk                      (elane_ehip_shared_clk[4]), //   input,    width = 2,
					.enh_clear_internal_error                   (),                   //   input,    width = 2,
					.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
					.enh_initialized                            (),                         //  output,    width = 2,
					.enh_internal_error                         (),                         //  output,    width = 2,
					.enh_pld_ready                              (),                         //   input,    width = 2,
					.enh_ready                                  (),                         //  output,    width = 2,
					.enh_reset                                  (1'b1),   //   input,    width = 2,
					.enh_reset_stat                             (),                         //  output,    width = 2,
					.hip_aib_fsr_in                             (hip_aib_fsr_in[5*4-1:4*4]),
					.hip_aib_ssr_in                             (hip_aib_ssr_in[5*40-1:4*40]),
					.osc_transfer_en                            (),                         //  output,    width = 2,
					.pll_refclk0                                (i_refclk),                 //input,   width = 1,
					.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
					.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
					.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
					.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
					.reconfig_clk                               (i_reconfig_clk),  //   input,    width = 2,
					.reconfig_reset                             (i_xcvr_reconfig_reset), //   input,    width = 2,
					.reconfig_write                             (i_ptp_reconfig_write[0]), //   input,    width = 2,
					.reconfig_read                              (i_ptp_reconfig_read[0]),  //   input,    width = 2,
					.reconfig_address                           (i_ptp_reconfig_address[19-1:0]),//   input,   width = 11**,
					.reconfig_writedata                         (i_ptp_reconfig_writedata[8-1:0]),//   input,   width = 64,
					.reconfig_readdata                          (o_ptp_reconfig_readdata[8-1:0]), //  output,   width = 64,
					.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[0]),//  output,    width = 2,
					.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
					.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
					.rx_aib_reset                               (i_rx_aib_reset[0]), //   input,    width = 2,
					.rx_clkout                                  (rx_clkout_ptp[0]),                                 //  output,    width = 2,
					.rx_clkout2                                 (rx_clkout2_ptp[0]),                                 //
					.rx_coreclkin                               (ml_rx_coreclkin),          //   input,    width = 2,
					.rx_enh_aligned                             (),                                 //  output,    width = 2,
					.rx_enh_blk_lock                            (),                            //  output,    width = 2,
					.rx_enh_highber                             (),                             //  output,    width = 2,
					.rx_enh_local_fault                         (),                         //  output,    width = 2,
					.rx_enh_pause                               (),                               //  output,    width = 2,
					.rx_enh_pfc                                 (),                                 //  output,   width = 16,
					.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.rx_enh_remote_fault                        (),                        //  output,    width = 2,
					.rx_enh_reset                               (1'b1),  //   input,    width = 2,
					.rx_enh_reset_stat                          (),                          //  output,    width = 2,
					.rx_enh_signal_ok                           (),                          //   input,    width = 2,
					.rx_fifo_ready                              (),                          //  output,    width = 2,
					.rx_parallel_data                           (rx_parallel_data[5*80-1:4*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
					.rx_pma_ready                               (ptp_rx_pma_ready[0]),                          //  output,    width = 2,
					.rx_pmaif_reset                             (i_rx_pmaif_reset[2]),  //   input,    width = 2,
					.rx_transfer_ready                          (ml_ptp_rx_transfer_ready[0]),                          //  output,    width = 2,
					.tx_aib_reset                               (i_tx_aib_reset[0]), //   input,    width = 2,
					.tx_clkout                                  (ptp_pll_hr_clk_100g[0]),            //  output,    width = 2,
					.tx_clkout2                                 (ptp_pll_fr_clk_100g[0]),            //
					.tx_coreclkin                               (ml_tx_coreclkin/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
					.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ ml_tx_coreclkin2),//   input,
					.tx_dll_lock                                (),                                //  output,    width = 2,
					.tx_enh_pause                               (),                               //   input,    width = 2,
					.tx_enh_pfc                                 (),                                 //   input,   width = 16,
					.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
					.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
					.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
					.tx_enh_reset                               (1'b1),  //   input,    width = 2,
					.tx_enh_reset_stat                          (),  //  output,    width = 2,
					.tx_fifo_ready                              (),  //  output,    width = 2,
					.tx_parallel_data                           (pp[80-1:0]),		//in, 320b
					.tx_pma_ready                               (ptp_tx_pma_ready[0]),                               //  output,    width = 2,
					.tx_pmaif_reset                             (i_tx_pmaif_reset[2]),  //   input,    width = 2,
					.tx_transfer_ready                          (ml_ptp_tx_transfer_ready[0]) //  output,    width = 2,
				 );

		   // PTP_CH[1] - upper PTP channel PLL OFF.
	           alt_ehipc3_fm_nphy_elane_ptp_plloff
				 nphy_ptp1
				   (
					.aib_ehip_rx_ehip_clk                       (o_ehip_clk), //   input,    width = 2,
					.aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk), //   input,    width = 2,
					.aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),  //   input,    width = 2,
					.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*5]),//   input,  width = 156,
					.aib_ehip_tx_ehip_clk                       (o_ehip_clk),             //   input,    width = 2,
					.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1]),      //  output,    width = 6,
					.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*5]),//  output,  width = 156,
					.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[1]),  //  output,    width = 2,
					.ehip_elane_am_detect                       (),                       //  output,    width = 2,
					.ehip_elane_am_insert                       (),                       //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
					.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
					.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
					.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
					.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
					.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
					.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[5]),   //  output,
					.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
					.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
					.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
					.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
					.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
					.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
					.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
					.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
					.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
					.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
					.elane_ehip_shared_clk                      (elane_ehip_shared_clk[5]), //   input,    width = 2,
					.enh_clear_internal_error                   (),                   //   input,    width = 2,
					.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
					.enh_initialized                            (),                         //  output,    width = 2,
					.enh_internal_error                         (),                         //  output,    width = 2,
					.enh_pld_ready                              (),                         //   input,    width = 2,
					.enh_ready                                  (),                         //  output,    width = 2,
					.enh_reset                                  (1'b1),   //   input,    width = 2,
					.enh_reset_stat                             (),                         //  output,    width = 2,
					.hip_aib_fsr_in				    (hip_aib_fsr_in[6*4-1:5*4]),
					.hip_aib_ssr_in				    (hip_aib_ssr_in[6*40-1:5*40]),
					.osc_transfer_en                            (),                         //  output,    width = 2,
					.pll_refclk0                                (i_refclk),                 //input,   width = 1,
					.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
					.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
					.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
					.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
					.reconfig_clk                               (i_reconfig_clk),  //   input,    width = 2,
					.reconfig_reset                             (i_xcvr_reconfig_reset), //   input,    width = 2,
					.reconfig_write                             (i_ptp_reconfig_write[LANES2-1]), //   input,    width = 2,
					.reconfig_read                              (i_ptp_reconfig_read[LANES2-1]),  //   input,    width = 2,
					.reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:19]),//   input,   width = 11**,
					.reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:8]),//   input,   width = 64,
					.reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:8]), //  output,   width = 64,
					.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1]),//  output,    width = 2,
					.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
					.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
					.rx_aib_reset                               (i_rx_aib_reset[0]), //   input,    width = 2,
					.rx_clkout                                  (rx_clkout_ptp[1]),                                 //  output,    width = 2,
					.rx_clkout2                                 (rx_clkout2_ptp[1]),                                 //
					.rx_coreclkin                               (ml_rx_coreclkin),          //   input,    width = 2,
					.rx_enh_aligned                             (),                                 //  output,    width = 2,
					.rx_enh_blk_lock                            (),                            //  output,    width = 2,
					.rx_enh_highber                             (),                             //  output,    width = 2,
					.rx_enh_local_fault                         (),                         //  output,    width = 2,
					.rx_enh_pause                               (),                               //  output,    width = 2,
					.rx_enh_pfc                                 (),                                 //  output,   width = 16,
					.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.rx_enh_remote_fault                        (),                        //  output,    width = 2,
					.rx_enh_reset                               (1'b1),  //   input,    width = 2,
					.rx_enh_reset_stat                          (),                          //  output,    width = 2,
					.rx_enh_signal_ok                           (),                          //   input,    width = 2,
					.rx_fifo_ready                              (),                          //  output,    width = 2,
					.rx_parallel_data                           (rx_parallel_data[6*80-1:5*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
					.rx_pma_ready                               (ptp_rx_pma_ready[1]),                          //  output,    width = 2,
					.rx_pmaif_reset                             (i_rx_pmaif_reset[3]),  //   input,    width = 2,
					.rx_transfer_ready                          (ml_ptp_rx_transfer_ready[1]),                          //  output,    width = 2,
					.tx_aib_reset                               (i_tx_aib_reset[0]), //   input,    width = 2,
					.tx_clkout                                  (ptp_pll_hr_clk_100g[1]),            //  output,    width = 2,
					.tx_clkout2                                 (ptp_pll_fr_clk_100g[1]),            //
					.tx_coreclkin                               (ml_tx_coreclkin/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
					.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ ml_tx_coreclkin2),//   input,
					.tx_dll_lock                                (ml_ptp_pllof_tx_dll_lock),                                //  output,    width = 2,
					.tx_enh_pause                               (),                               //   input,    width = 2,
					.tx_enh_pfc                                 (),                                 //   input,   width = 16,
					.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
					.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
					.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
					.tx_enh_reset                               (1'b1),  //   input,    width = 2,
					.tx_enh_reset_stat                          (),  //  output,    width = 2,
					.tx_fifo_ready                              (),  //  output,    width = 2,
					.tx_parallel_data                           (pp[LANES2*80-1:80]),		//in, 320b
					.tx_pma_ready                               (ptp_tx_pma_ready[1]),                               //  output,    width = 2,
					.tx_pmaif_reset                             (i_tx_pmaif_reset[3]),  //   input,    width = 2,
					.tx_transfer_ready                          (ml_ptp_tx_transfer_ready[1]) //  output,    width = 2,
				 );
            end


           assign elane_ehip_shared_clk = {LANES6{o_ehip_clk}};



                eth_100g_cvl_nrz_alt_ehipc3_fm_xcvrnphy_fme_2420_4f4z7my altera_xcvr_native_inst (
				.latency_sclk                               (i_sclk),
				.tx_dl_measure_sel                          (i_tx_sel_sclk_return),
				.rx_dl_measure_sel                          (i_rx_sel_sclk_return),
				.tx_dl_async_pulse                          (o_tx_sclk_return),
				.rx_dl_async_pulse                          (o_rx_sclk_return),
				.pll_refclk0(i_refclk[0]),					//in,1b		pll_refclk0.clk
				.rx_coreclkin({LANES4{ml_rx_coreclkin}}),				//in.4b		rx_coreclkin.clk
				.tx_coreclkin({LANES4{ml_tx_coreclkin}}),				//in.4b		tx_coreclkin.clk
				.tx_coreclkin2({LANES4{ml_tx_coreclkin2}}),				//in.4b		tx_coreclkin.clk
				.aib_ehip_rx_ehip_clk({LANES4{o_ehip_clk}}),			//in,4b		aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
				.aib_ehip_rx_ehip_fr_clk({LANES4{o_ehip_dist_fr_rx_clk}}),	//in,4b		aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
				.aib_ehip_rx_fec_fr_clk({LANES4{o_fec_dist_fr_rx_clk}}),	//in.4b		aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
				.aib_ehip_tx_ehip_clk({LANES4{o_ehip_clk}}),			//in.4b		aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
				.pma_ehip_rx_ehip_clk_div2({4{o_ehip_clk}}), 			//
				.pma_ehip_tx_ehip_clk_div2({4{o_ehip_clk}}), 			//

				.RSFEC_ehip_clock(o_ehip_clk),					//in, 402mhz
				.pmaRsfec_ehip_tx_ehip_data(core_tx_data),			//in
				.pmaRsfec_ehip_tx_ehip_dv(core_tx_data_valid),			//in
				.pmaRsfec_ehip_tx_ehip_fifo_rst_n(core_tx_data_am_valid),	//in
				.ehip_pmaRsfec_fec_rx_data(core_rx_data),			//out
				.ehip_pmaRsfec_fec_rx_data_valid(core_rx_data_valid),		//out
				.ehip_pmaRsfec_fec_rx_data_am_valid(core_rx_data_am_valid),	//out

				.pma_ehip_rx_ehip_fifo_rst_n({LANES4{h2a_rx_ehip_rst_n}}),	//in.4b

				.rx_aib_reset(i_rx_aib_reset),					//in.4b
				.tx_aib_reset(i_tx_aib_reset),					//in.4b
				.rx_pmaif_reset(i_rx_pmaif_reset),				//in.4b
				.tx_pmaif_reset(i_tx_pmaif_reset),				//in.4b
				.enh_reset(4'hf),						//in.4b
				.rx_enh_reset(4'hf),						//in.4b
				.tx_enh_reset(4'hf),						//in.4b

				.ehip_pma_tx_pma_clk(xcvr_fr_tx_clk[LANES4-1:0]),           	//out,4b
				.rx_clkout(rx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
				.tx_clkout(tx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
				.rx_clkout2(rx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
				.tx_clkout2(tx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
				.ehip_aib_tx_transfer_div2_clk({tmp_clk3, tmp_clk2, tmp_clk1, ehip_clk}), //out,4b

				.rx_serial_data(i_rx_serial_data[3:0]),	 			//in, 4b
				.rx_serial_data_n(),			 			//in, 4b
				.tx_serial_data(o_tx_serial_data[3:0]),				//out,4b
				.tx_serial_data_n(),						//out,4b
				.rx_parallel_data(rx_parallel_data[LANES4*80-1:0]),		//out,320b
				.tx_parallel_data(tx_parallel_data_r[LANES4*80-1:0]),		//in, 320b

				.ehip_aib_aib_status(a2h_hip_aib_status), 			//out.12b
				.aib_ehip_rx_sync_data(ehip_aib_sync_data_in[LANES4*78-1:0]),	//in,312b
				.hip_aib_fsr_in(hip_aib_fsr_in[LANES4*4-1:0]),
				.hip_aib_ssr_in(hip_aib_ssr_in[LANES4*40-1:0]),
				.ehip_aib_tx_sync_data(ehip_aib_sync_data_out[LANES4*78-1:0]),	//out.312b

				.enh_pld_ready({{(4-SL_LANES){1'b0}},i_sl_ehip_pld_ready}),	//in,4b
				.rx_pma_ready(rx_pma_ready[LANES4-1:0]),			//out,4b
				.tx_pma_ready(tx_pma_ready[LANES4-1:0]),			//out,4b
				.rx_is_lockedtodata(rx_is_lockedtodata[LANES4-1:0]),		//out,4b
				.rx_transfer_ready(o_rx_transfer_ready[LANES4-1:0]),		//out,4b
				.tx_transfer_ready(o_tx_transfer_ready[LANES4-1:0]),		//out,4b

				.elane_ehip_shared_clk                      (elane_ehip_shared_clk[LANES-1:0]),			//in, width = 2,
				.elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LANES4*2-1:0]),		//in, width = 8,
				.elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LANES4*24-1:0]),     	//  in, width = 96,
				.elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LANES4*3-1:0]),	//  in, width = 12,
				.elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LANES4*3-1:0]),	//  in, width = 12,
				.elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LANES4*2-1:0]),	//  in, width = 8,
				.elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LANES4*24-1:0]),  	//  in, width = 96,
				.elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LANES4*3-1:0]),	//  in, width = 12,
				.elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LANES4*3-1:0]),//  in,width = 12,
				.elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LANES4*1-1:0]),      //  in,    width = 4,
				.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LANES4*6-1:0]), //  in,   width = 24,
				.elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LANES4*1-1:0]),   //  in,    width = 4,
				.ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[LANES4*23-1:0]),     		//   out,   width = 92,
				.ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[LANES4*12-1:0]),        	//   out,   width = 48,
				.ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[LANES4*2-1:0]),      	//   out,    width = 8,
				.ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[LANES4*1-1:0]),   	//   out,    width = 4,
				.ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[LANES4*1-1:0]),	//   out,    width = 4,
				.ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[LANES4*1-1:0]),	//   out,    width = 4,
				.ehip_elane_am_detect                       (ehip_elane_am_detect[LANES4*1-1:0]),           	//   out,    width = 4,
				.ehip_elane_am_insert                       (ehip_elane_am_insert[LANES4*1-1:0]),           	//   out,    width = 4,
				.ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[LANES4*1-1:0]),     	//   out,    width = 4,
				.ehip_elane_shared_clear                    (ehip_elane_shared_clear[LANES4*1-1:0]),        	//   out,    width = 4,
				.enh_clear_internal_error		            ({LANES4{i_sl_clear_internal_err[0]}}),				//in, width =4,
				.enh_force_rcfg_reset			            (4'hf),				//in, width =4,
				.enh_initialized                            (), 				//output,    width = 4,
				.enh_internal_error                         (),                    		//  output,    width = 4,
				.osc_transfer_en                            (),                         			//  output,    width = 4,
				.rx_enh_aligned                             (),                        //  output,    width = 4,
				.rx_enh_blk_lock                            (),                 		//  output,    width = 4,
				.rx_enh_highber                             (),                  			//  output,    width = 4,
				.rx_enh_local_fault                         (),              		//  output,    width = 4,
				.rx_enh_pause                               (),                    		//  output,    width = 4,
				.rx_enh_pfc                                 (),                      		//  output,   width = 32,
				.rx_enh_pmaif_fifo_overflow                 (),            		//  output,    width = 4,
				.rx_enh_remote_fault                        (),                  	//  output,    width = 4,
				.rx_enh_reset_stat                          (),                     	//  output,    width = 4,
				.rx_enh_signal_ok                           (4'b0),                      	//  input,    width = 4,
				.rx_fifo_ready                              (o_rx_fifo_ready),                         		//  output,    width = 4,
				.tx_dll_lock                                (o_tx_dll_lock[LANES4*1-1:0]),            		//  output,    width = 4,
				.tx_enh_pause                               (4'b0),                         		//  input,   width = 1,
				.tx_enh_pfc                                 (32'b0),                         		//  input,   width = 8,
				.tx_enh_pmaif_fifo_almost_empty             (),				//  output,    width = 4,
				.tx_enh_pmaif_fifo_almost_full              (),				//  output,    width = 4,
				.tx_enh_pmaif_fifo_overflow                 (),			//  output,    width = 4,
				.tx_enh_pmaif_fifo_underflow                (),			//  output,    width = 4,
				.tx_fifo_ready                              (o_tx_fifo_ready),					//  output,    width = 4,

				// Reconfig Interface
				.reconfig_clk({LANES4{i_xcvr_reconfig_clk}}),				//in,4b
				.reconfig_reset({LANES4{i_xcvr_reconfig_reset}}),			//in,4b
				.reconfig_write(i_xcvr_reconfig_write[LANES4-1:0]),			//in,4b
				.reconfig_read(i_xcvr_reconfig_read[LANES4-1:0]),			//in,4b
				.reconfig_address(i_xcvr_reconfig_address[LANES4*19-1:0]),		//in,80b
				.reconfig_writedata(i_xcvr_reconfig_writedata[LANES4*8-1:0]),		//in,128b
				.reconfig_readdata(o_xcvr_reconfig_readdata[LANES4*8-1:0]),		//out,128b
				.reconfig_waitrequest(o_xcvr_reconfig_waitrequest[LANES4-1:0])		//out,4b
				);
        end // E100GX4_NOFEC_PTP_PR
   endgenerate

// 100G PTP+RSFEC
   generate
      if (ENABLE_PTP!=0 && core_variant==3 && active_channel==1 && ehip_mode == "ehip_mac_ptp" )
        begin : E100GX4_FEC_PTP_PR

           assign ptp_clk  = ECORE_5432_TIEOFF ? ptp_ehip_aib_tx_transfer_div2_clk[1] : ptp_ehip_aib_tx_transfer_div2_clk[0];
// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// When PTP channel PLL is turned off, the clock out will be X. So the corresponding clock out at IP level needs to be manually tieoff to prevent X propagation.
// ---------------------------------------------------------------------------------------------------------------------------------
//           assign tx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {ptp_pll_hr_clk_100g[0],ptp_pll_hr_clk_100g[1]} : ptp_pll_hr_clk_100g;
//           assign tx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {ptp_pll_fr_clk_100g[0],ptp_pll_fr_clk_100g[1]} : ptp_pll_fr_clk_100g;
//           assign rx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {rx_clkout_ptp [0],rx_clkout_ptp [1]} : rx_clkout_ptp;
//           assign rx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {rx_clkout2_ptp[0],rx_clkout2_ptp[1]} : rx_clkout2_ptp;
            assign tx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {1'b0,ptp_pll_hr_clk_100g[1]} : {1'b0,ptp_pll_hr_clk_100g[0]};
            assign tx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {1'b0,ptp_pll_fr_clk_100g[1]} : {1'b0,ptp_pll_fr_clk_100g[0]};
            assign rx_clkout [MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {1'b0,rx_clkout_ptp[1] } : {1'b0,rx_clkout_ptp[0] };
            assign rx_clkout2[MAX_XCVR_CH+1:MAX_XCVR_CH] = ECORE_5432_TIEOFF ? {1'b0,rx_clkout2_ptp[1]} : {1'b0,rx_clkout2_ptp[0]};
// ---------------------------------------------------------------------------------------------------------------------------------
           assign ptp_ch_hr_clk = enable_external_aib_clocking ? i_aib_clk :
                                  ENABLE_PTP                   ? ECORE_5432_TIEOFF ? ptp_pll_hr_clk_100g[1] : ptp_pll_hr_clk_100g[0] :
                                                                 i_tx_core_clk;
           assign ptp_ch_fr_clk = enable_external_aib_clocking ? i_aib_2x_clk :
                                  ENABLE_PTP                   ? ECORE_5432_TIEOFF ? ptp_pll_fr_clk_100g[1] : ptp_pll_fr_clk_100g[0] :
                                                                 tx_clkout2[0];

// ---------------------------------------------------------------------------------------------------------------------------------
// 22/Aug/2019 : HSD#1409425013 : With right NPHY setting, transfer_ready is up and therefore no longer need the remapping.
// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// When PLL is OFF, tx_transfer_ready will not up. So, we have to rely on tx_dll_lock instead to indicate AIB is ready.
// So, have to remap sl_ptp_tx/rx_transfer_ready.
// ---------------------------------------------------------------------------------------------------------------------------------
	    wire [LANES2-1:0]	ml_ptp_tx_transfer_ready;
	    wire [LANES2-1:0]	ml_ptp_rx_transfer_ready;
	    wire 		ml_ptp_plloff_tx_dll_lock;
//	    assign o_tx_transfer_ready[5:4] = ECORE_5432_TIEOFF ? {ml_ptp_tx_transfer_ready[1], ml_ptp_plloff_tx_dll_lock} : {ml_ptp_plloff_tx_dll_lock, ml_ptp_tx_transfer_ready[0]};
//	    assign o_rx_transfer_ready[5:4] = ECORE_5432_TIEOFF ? {ml_ptp_rx_transfer_ready[1], ml_ptp_plloff_tx_dll_lock} : {ml_ptp_plloff_tx_dll_lock, ml_ptp_rx_transfer_ready[0]};
	    assign o_tx_transfer_ready[5:4] = ml_ptp_tx_transfer_ready;
	    assign o_rx_transfer_ready[5:4] = ml_ptp_rx_transfer_ready;
// ---------------------------------------------------------------------------------------------------------------------------------

// ---------------------------------------------------------------------------------------------------------------------------------
// 02/Jul/2019 : HSD#1409425013 : Disable unused PTP_PLL channels for unused XCVR.
// ---------------------------------------------------------------------------------------------------------------------------------
// Creating 2 PTP channels separately with different PLL setting.
// When EHIP_LOCATION_0/2, select PTP_CH[1] to turnoff the PLL.
// When EHIP_LOCATION_1/3, select PTP_CH[0] to turnoff the PLL.
// ---------------------------------------------------------------------------------------------------------------------------------
//          alt_ehipc3_fm_nphy_elane_ptp
//      #(
//         .hssi_rsfec_topology(topology)
//       )
//			 nphy_ptp
//			   (
//
//				.aib_ehip_rx_ehip_clk                       ({LANES2{o_ehip_clk}}), //   input,    width = 2,
//				.aib_ehip_rx_ehip_fr_clk                    ({LANES2{o_ehip_dist_fr_rx_clk}}), //   input,    width = 2,
//				.aib_ehip_rx_fec_fr_clk                     ({LANES2{o_fec_dist_fr_rx_clk}}),  //   input,    width = 2,
//				.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*4]),//   input,  width = 156,
//				.aib_ehip_tx_ehip_clk                       ({LANES2{o_ehip_clk}}),             //   input,    width = 2,
//				.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1:0]),      //  output,    width = 6,
//				.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*4]),//  output,  width = 156,
//				.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk),  //  output,    width = 2,
//				.ehip_elane_am_detect                       (),                       //  output,    width = 2,
//				.ehip_elane_am_insert                       (),                       //  output,    width = 2,
//				.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
//				.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
//				.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
//				.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
//				.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
//				.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
//				.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
//				.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
//				.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[5:4]),   //  output,
//				.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
//				.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
//				.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
//				.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
//				.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
//				.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
//				.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
//				.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
//				.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
//				.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
//				.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
//				.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
//				.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
//				.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
//				.elane_ehip_shared_clk                      (elane_ehip_shared_clk[5:4]), //   input,    width = 2,
//				.enh_clear_internal_error                   (),                   //   input,    width = 2,
//				.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
//				.enh_initialized                            (),                         //  output,    width = 2,
//				.enh_internal_error                         (),                         //  output,    width = 2,
//				.enh_pld_ready                              (),                         //   input,    width = 2,
//				.enh_ready                                  (),                         //  output,    width = 2,
//				.enh_reset                                  (2'h3),   //   input,    width = 2,
//				.enh_reset_stat                             (),                         //  output,    width = 2,
//				.hip_aib_fsr_in(hip_aib_fsr_in[6*4-1:4*4]),
//				.hip_aib_ssr_in(hip_aib_ssr_in[6*40-1:4*40]),
//				.osc_transfer_en                            (),                         //  output,    width = 2,
//				.pll_refclk0                                (i_refclk),                 //input,   width = 1,
//				.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
//				.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
//				.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
//				.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
//				.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
//				.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
//				.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
//				.reconfig_clk                               ({LANES2{i_reconfig_clk}}),  //   input,    width = 2,
//				.reconfig_reset                             ({LANES2{i_xcvr_reconfig_reset}}), //   input,    width = 2,
//				.reconfig_write                             (i_ptp_reconfig_write[LANES2-1:0]), //   input,    width = 2,
//				.reconfig_read                              (i_ptp_reconfig_read[LANES2-1:0]),  //   input,    width = 2,
//				.reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:0]),//   input,   width = 11**,
//				.reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:0]),//   input,   width = 64,
//				.reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:0]), //  output,   width = 64,
//				.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1:0]),//  output,    width = 2,
//				.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
//				.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
//				.rx_aib_reset                               ({2{i_rx_aib_reset[0]}}), //   input,    width = 2,
//				.rx_clkout                                  (rx_clkout_ptp),                                 //  output,    width = 2,
//				.rx_clkout2                                 (rx_clkout2_ptp),                                 //
//				.rx_coreclkin                               ({LANES2{ml_rx_coreclkin}}),          //   input,    width = 2,
//				.rx_enh_aligned                             (),                                 //  output,    width = 2,
//				.rx_enh_blk_lock                            (),                            //  output,    width = 2,
//				.rx_enh_highber                             (),                             //  output,    width = 2,
//				.rx_enh_local_fault                         (),                         //  output,    width = 2,
//				.rx_enh_pause                               (),                               //  output,    width = 2,
//				.rx_enh_pfc                                 (),                                 //  output,   width = 16,
//				.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
//				.rx_enh_remote_fault                        (),                        //  output,    width = 2,
//				.rx_enh_reset                               (2'h3),  //   input,    width = 2,
//				.rx_enh_reset_stat                          (),                          //  output,    width = 2,
//				.rx_enh_signal_ok                           (),                          //   input,    width = 2,
//				.rx_fifo_ready                              (),                          //  output,    width = 2,
//				.rx_parallel_data                           (rx_parallel_data[6*80-1:4*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
//				.rx_pma_ready                               (ptp_rx_pma_ready),                          //  output,    width = 2,
//				.rx_pmaif_reset                             (i_rx_pmaif_reset[3:2]),  //   input,    width = 2,
//				.rx_transfer_ready                          (o_rx_transfer_ready[5:4]),                          //  output,    width = 2,
//				.tx_aib_reset                               ({2{i_tx_aib_reset[0]}}), //   input,    width = 2,
//				.tx_clkout                                  (ptp_pll_hr_clk_100g),            //  output,    width = 2,
//				.tx_clkout2                                 (ptp_pll_fr_clk_100g),            //
//				.tx_coreclkin                               ({LANES2{ml_tx_coreclkin}}/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
//				.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ {LANES2{ml_tx_coreclkin2}}),//   input,
//				.tx_dll_lock                                (),                                //  output,    width = 2,
//				.tx_enh_pause                               (),                               //   input,    width = 2,
//				.tx_enh_pfc                                 (),                                 //   input,   width = 16,
//				.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
//				.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
//				.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
//				.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
//				.tx_enh_reset                               (2'h3),  //   input,    width = 2,
//				.tx_enh_reset_stat                          (),  //  output,    width = 2,
//				.tx_fifo_ready                              (),  //  output,    width = 2,
//				.tx_parallel_data                           (pp),		//in, 320b
//				.tx_pma_ready                               (ptp_tx_pma_ready),                               //  output,    width = 2,
//				.tx_pmaif_reset                             (i_tx_pmaif_reset[3:2]),  //   input,    width = 2,
//				.tx_transfer_ready                          (o_tx_transfer_ready[5:4]) //  output,    width = 2,
//				);

            if(ECORE_5432_TIEOFF) begin
		   // PTP_CH[0] - lower PTP channel PLL OFF.
	           alt_ehipc3_fm_nphy_elane_ptp_plloff
                   #(.hssi_rsfec_topology(topology))
				 nphy_ptp0
				   (
					.aib_ehip_rx_ehip_clk                       (o_ehip_clk), //   input,    width = 2,
					.aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk), //   input,    width = 2,
					.aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),  //   input,    width = 2,
					.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*5-1:78*4]),//   input,  width = 156,
					.aib_ehip_tx_ehip_clk                       (o_ehip_clk),             //   input,    width = 2,
					.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[0]),      //  output,    width = 6,
					.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*5-1:78*4]),//  output,  width = 156,
					.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[0]),  //  output,    width = 2,
					.ehip_elane_am_detect                       (),                       //  output,    width = 2,
					.ehip_elane_am_insert                       (),                       //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
					.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
					.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
					.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
					.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
					.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
					.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[4]),   //  output,
					.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
					.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
					.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
					.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
					.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
					.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
					.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
					.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
					.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
					.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
					.elane_ehip_shared_clk                      (elane_ehip_shared_clk[4]), //   input,    width = 2,
					.enh_clear_internal_error                   (),                   //   input,    width = 2,
					.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
					.enh_initialized                            (),                         //  output,    width = 2,
					.enh_internal_error                         (),                         //  output,    width = 2,
					.enh_pld_ready                              (),                         //   input,    width = 2,
					.enh_ready                                  (),                         //  output,    width = 2,
					.enh_reset                                  (1'b1),   //   input,    width = 2,
					.enh_reset_stat                             (),                         //  output,    width = 2,
					.hip_aib_fsr_in                             (hip_aib_fsr_in[5*4-1:4*4]),
					.hip_aib_ssr_in                             (hip_aib_ssr_in[5*40-1:4*40]),
					.osc_transfer_en                            (),                         //  output,    width = 2,
					.pll_refclk0                                (i_refclk),                 //input,   width = 1,
					.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
					.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
					.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
					.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
					.reconfig_clk                               (i_reconfig_clk),  //   input,    width = 2,
					.reconfig_reset                             (i_xcvr_reconfig_reset), //   input,    width = 2,
					.reconfig_write                             (i_ptp_reconfig_write[0]), //   input,    width = 2,
					.reconfig_read                              (i_ptp_reconfig_read[0]),  //   input,    width = 2,
					.reconfig_address                           (i_ptp_reconfig_address[19-1:0]),//   input,   width = 11**,
					.reconfig_writedata                         (i_ptp_reconfig_writedata[8-1:0]),//   input,   width = 64,
					.reconfig_readdata                          (o_ptp_reconfig_readdata[8-1:0]), //  output,   width = 64,
					.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[0]),//  output,    width = 2,
					.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
					.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
					.rx_aib_reset                               (i_rx_aib_reset[0]), //   input,    width = 2,
					.rx_clkout                                  (rx_clkout_ptp[0]),                                 //  output,    width = 2,
					.rx_clkout2                                 (rx_clkout2_ptp[0]),                                 //
					.rx_coreclkin                               (ml_rx_coreclkin),          //   input,    width = 2,
					.rx_enh_aligned                             (),                                 //  output,    width = 2,
					.rx_enh_blk_lock                            (),                            //  output,    width = 2,
					.rx_enh_highber                             (),                             //  output,    width = 2,
					.rx_enh_local_fault                         (),                         //  output,    width = 2,
					.rx_enh_pause                               (),                               //  output,    width = 2,
					.rx_enh_pfc                                 (),                                 //  output,   width = 16,
					.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.rx_enh_remote_fault                        (),                        //  output,    width = 2,
					.rx_enh_reset                               (1'b1),  //   input,    width = 2,
					.rx_enh_reset_stat                          (),                          //  output,    width = 2,
					.rx_enh_signal_ok                           (),                          //   input,    width = 2,
					.rx_fifo_ready                              (),                          //  output,    width = 2,
					.rx_parallel_data                           (rx_parallel_data[5*80-1:4*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
					.rx_pma_ready                               (ptp_rx_pma_ready[0]),                          //  output,    width = 2,
					.rx_pmaif_reset                             (i_rx_pmaif_reset[2]),  //   input,    width = 2,
					.rx_transfer_ready                          (ml_ptp_rx_transfer_ready[0]),                          //  output,    width = 2,
					.tx_aib_reset                               (i_tx_aib_reset[0]), //   input,    width = 2,
					.tx_clkout                                  (ptp_pll_hr_clk_100g[0]),            //  output,    width = 2,
					.tx_clkout2                                 (ptp_pll_fr_clk_100g[0]),            //
					.tx_coreclkin                               (ml_tx_coreclkin/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
					.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ ml_tx_coreclkin2),//   input,
					.tx_dll_lock                                (ml_ptp_plloff_tx_dll_lock),                                //  output,    width = 2,
					.tx_enh_pause                               (),                               //   input,    width = 2,
					.tx_enh_pfc                                 (),                                 //   input,   width = 16,
					.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
					.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
					.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
					.tx_enh_reset                               (1'b1),  //   input,    width = 2,
					.tx_enh_reset_stat                          (),  //  output,    width = 2,
					.tx_fifo_ready                              (),  //  output,    width = 2,
					.tx_parallel_data                           (pp[80-1:0]),		//in, 320b
					.tx_pma_ready                               (ptp_tx_pma_ready[0]),                               //  output,    width = 2,
					.tx_pmaif_reset                             (i_tx_pmaif_reset[2]),  //   input,    width = 2,
					.tx_transfer_ready                          (ml_ptp_tx_transfer_ready[0]) //  output,    width = 2,
				 );

		   // PTP_CH[1] - upper PTP channel PLL ON.
	           alt_ehipc3_fm_nphy_elane_ptp
                   #(.hssi_rsfec_topology(topology))
				 nphy_ptp1
				   (
					.aib_ehip_rx_ehip_clk                       (o_ehip_clk), //   input,    width = 2,
					.aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk), //   input,    width = 2,
					.aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),  //   input,    width = 2,
					.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*5]),//   input,  width = 156,
					.aib_ehip_tx_ehip_clk                       (o_ehip_clk),             //   input,    width = 2,
					.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1]),      //  output,    width = 6,
					.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*5]),//  output,  width = 156,
					.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[1]),  //  output,    width = 2,
					.ehip_elane_am_detect                       (),                       //  output,    width = 2,
					.ehip_elane_am_insert                       (),                       //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
					.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
					.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
					.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
					.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
					.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
					.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[5]),   //  output,
					.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
					.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
					.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
					.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
					.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
					.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
					.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
					.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
					.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
					.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
					.elane_ehip_shared_clk                      (elane_ehip_shared_clk[5]), //   input,    width = 2,
					.enh_clear_internal_error                   (),                   //   input,    width = 2,
					.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
					.enh_initialized                            (),                         //  output,    width = 2,
					.enh_internal_error                         (),                         //  output,    width = 2,
					.enh_pld_ready                              (),                         //   input,    width = 2,
					.enh_ready                                  (),                         //  output,    width = 2,
					.enh_reset                                  (1'b1),   //   input,    width = 2,
					.enh_reset_stat                             (),                         //  output,    width = 2,
					.hip_aib_fsr_in                             (hip_aib_fsr_in[6*4-1:5*4]),
					.hip_aib_ssr_in                             (hip_aib_ssr_in[6*40-1:5*40]),
					.osc_transfer_en                            (),                         //  output,    width = 2,
					.pll_refclk0                                (i_refclk),                 //input,   width = 1,
					.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
					.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
					.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
					.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
					.reconfig_clk                               (i_reconfig_clk),  //   input,    width = 2,
					.reconfig_reset                             (i_ptp_reconfig_reset), //   input,    width = 2,
					.reconfig_write                             (i_ptp_reconfig_write[LANES2-1]), //   input,    width = 2,
					.reconfig_read                              (i_ptp_reconfig_read[LANES2-1]),  //   input,    width = 2,
					.reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:19]),//   input,   width = 11**,
					.reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:8]),//   input,   width = 64,
					.reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:8]), //  output,   width = 64,
					.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1]),//  output,    width = 2,
					.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
					.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
					.rx_aib_reset                               (i_rx_aib_reset[0]), //   input,    width = 2,
					.rx_clkout                                  (rx_clkout_ptp[1]),                                 //  output,    width = 2,
					.rx_clkout2                                 (rx_clkout2_ptp[1]),                                 //
					.rx_coreclkin                               (ml_rx_coreclkin),          //   input,    width = 2,
					.rx_enh_aligned                             (),                                 //  output,    width = 2,
					.rx_enh_blk_lock                            (),                            //  output,    width = 2,
					.rx_enh_highber                             (),                             //  output,    width = 2,
					.rx_enh_local_fault                         (),                         //  output,    width = 2,
					.rx_enh_pause                               (),                               //  output,    width = 2,
					.rx_enh_pfc                                 (),                                 //  output,   width = 16,
					.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.rx_enh_remote_fault                        (),                        //  output,    width = 2,
					.rx_enh_reset                               (1'b1),  //   input,    width = 2,
					.rx_enh_reset_stat                          (),                          //  output,    width = 2,
					.rx_enh_signal_ok                           (),                          //   input,    width = 2,
					.rx_fifo_ready                              (),                          //  output,    width = 2,
					.rx_parallel_data                           (rx_parallel_data[6*80-1:5*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
					.rx_pma_ready                               (ptp_rx_pma_ready[1]),                          //  output,    width = 2,
					.rx_pmaif_reset                             (i_rx_pmaif_reset[3]),  //   input,    width = 2,
					.rx_transfer_ready                          (ml_ptp_rx_transfer_ready[1]),                          //  output,    width = 2,
					.tx_aib_reset                               (i_tx_aib_reset[0]), //   input,    width = 2,
					.tx_clkout                                  (ptp_pll_hr_clk_100g[1]),            //  output,    width = 2,
					.tx_clkout2                                 (ptp_pll_fr_clk_100g[1]),            //
					.tx_coreclkin                               (ml_tx_coreclkin/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
					.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ ml_tx_coreclkin2),//   input,
					.tx_dll_lock                                (),                                //  output,    width = 2,
					.tx_enh_pause                               (),                               //   input,    width = 2,
					.tx_enh_pfc                                 (),                                 //   input,   width = 16,
					.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
					.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
					.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
					.tx_enh_reset                               (1'b1),  //   input,    width = 2,
					.tx_enh_reset_stat                          (),  //  output,    width = 2,
					.tx_fifo_ready                              (),  //  output,    width = 2,
					.tx_parallel_data                           (pp[LANES2*80-1:80]),		//in, 320b
					.tx_pma_ready                               (ptp_tx_pma_ready[1]),                               //  output,    width = 2,
					.tx_pmaif_reset                             (i_tx_pmaif_reset[3]),  //   input,    width = 2,
					.tx_transfer_ready                          (ml_ptp_tx_transfer_ready[1]) //  output,    width = 2,
				 );
            end else begin
		   // PTP_CH[0] - lower PTP channel PLL ON.
	           alt_ehipc3_fm_nphy_elane_ptp
                   #(.hssi_rsfec_topology(topology))
				 nphy_ptp0
				   (
					.aib_ehip_rx_ehip_clk                       (o_ehip_clk), //   input,    width = 2,
					.aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk), //   input,    width = 2,
					.aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),  //   input,    width = 2,
					.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*5-1:78*4]),//   input,  width = 156,
					.aib_ehip_tx_ehip_clk                       (o_ehip_clk),             //   input,    width = 2,
					.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[0]),      //  output,    width = 6,
					.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*5-1:78*4]),//  output,  width = 156,
					.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[0]),  //  output,    width = 2,
					.ehip_elane_am_detect                       (),                       //  output,    width = 2,
					.ehip_elane_am_insert                       (),                       //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
					.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
					.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
					.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
					.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
					.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
					.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[4]),   //  output,
					.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
					.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
					.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
					.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
					.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
					.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
					.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
					.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
					.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
					.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
					.elane_ehip_shared_clk                      (elane_ehip_shared_clk[4]), //   input,    width = 2,
					.enh_clear_internal_error                   (),                   //   input,    width = 2,
					.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
					.enh_initialized                            (),                         //  output,    width = 2,
					.enh_internal_error                         (),                         //  output,    width = 2,
					.enh_pld_ready                              (),                         //   input,    width = 2,
					.enh_ready                                  (),                         //  output,    width = 2,
					.enh_reset                                  (1'b1),   //   input,    width = 2,
					.enh_reset_stat                             (),                         //  output,    width = 2,
					.hip_aib_fsr_in				    (hip_aib_fsr_in[5*4-1:4*4]),
					.hip_aib_ssr_in				    (hip_aib_ssr_in[5*40-1:4*40]),
					.osc_transfer_en                            (),                         //  output,    width = 2,
					.pll_refclk0                                (i_refclk),                 //input,   width = 1,
					.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
					.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
					.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
					.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
					.reconfig_clk                               (i_reconfig_clk),  //   input,    width = 2,
					.reconfig_reset                             (i_ptp_reconfig_reset), //   input,    width = 2,
					.reconfig_write                             (i_ptp_reconfig_write[0]), //   input,    width = 2,
					.reconfig_read                              (i_ptp_reconfig_read[0]),  //   input,    width = 2,
					.reconfig_address                           (i_ptp_reconfig_address[19-1:0]),//   input,   width = 11**,
					.reconfig_writedata                         (i_ptp_reconfig_writedata[8-1:0]),//   input,   width = 64,
					.reconfig_readdata                          (o_ptp_reconfig_readdata[8-1:0]), //  output,   width = 64,
					.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[0]),//  output,    width = 2,
					.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
					.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
					.rx_aib_reset                               (i_rx_aib_reset[0]), //   input,    width = 2,
					.rx_clkout                                  (rx_clkout_ptp[0]),                                 //  output,    width = 2,
					.rx_clkout2                                 (rx_clkout2_ptp[0]),                                 //
					.rx_coreclkin                               (ml_rx_coreclkin),          //   input,    width = 2,
					.rx_enh_aligned                             (),                                 //  output,    width = 2,
					.rx_enh_blk_lock                            (),                            //  output,    width = 2,
					.rx_enh_highber                             (),                             //  output,    width = 2,
					.rx_enh_local_fault                         (),                         //  output,    width = 2,
					.rx_enh_pause                               (),                               //  output,    width = 2,
					.rx_enh_pfc                                 (),                                 //  output,   width = 16,
					.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.rx_enh_remote_fault                        (),                        //  output,    width = 2,
					.rx_enh_reset                               (1'b1),  //   input,    width = 2,
					.rx_enh_reset_stat                          (),                          //  output,    width = 2,
					.rx_enh_signal_ok                           (),                          //   input,    width = 2,
					.rx_fifo_ready                              (),                          //  output,    width = 2,
					.rx_parallel_data                           (rx_parallel_data[5*80-1:4*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
					.rx_pma_ready                               (ptp_rx_pma_ready[0]),                          //  output,    width = 2,
					.rx_pmaif_reset                             (i_rx_pmaif_reset[2]),  //   input,    width = 2,
					.rx_transfer_ready                          (ml_ptp_rx_transfer_ready[0]),                          //  output,    width = 2,
					.tx_aib_reset                               (i_tx_aib_reset[0]), //   input,    width = 2,
					.tx_clkout                                  (ptp_pll_hr_clk_100g[0]),            //  output,    width = 2,
					.tx_clkout2                                 (ptp_pll_fr_clk_100g[0]),            //
					.tx_coreclkin                               (ml_tx_coreclkin/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
					.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ ml_tx_coreclkin2),//   input,
					.tx_dll_lock                                (),                                //  output,    width = 2,
					.tx_enh_pause                               (),                               //   input,    width = 2,
					.tx_enh_pfc                                 (),                                 //   input,   width = 16,
					.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
					.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
					.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
					.tx_enh_reset                               (1'b1),  //   input,    width = 2,
					.tx_enh_reset_stat                          (),  //  output,    width = 2,
					.tx_fifo_ready                              (),  //  output,    width = 2,
					.tx_parallel_data                           (pp[80-1:0]),		//in, 320b
					.tx_pma_ready                               (ptp_tx_pma_ready[0]),                               //  output,    width = 2,
					.tx_pmaif_reset                             (i_tx_pmaif_reset[2]),  //   input,    width = 2,
					.tx_transfer_ready                          (ml_ptp_tx_transfer_ready[0]) //  output,    width = 2,
				 );

		   // PTP_CH[1] - upper PTP channel PLL OFF.
	           alt_ehipc3_fm_nphy_elane_ptp_plloff
                   #(.hssi_rsfec_topology(topology))
				 nphy_ptp1
				   (
					.aib_ehip_rx_ehip_clk                       (o_ehip_clk), //   input,    width = 2,
					.aib_ehip_rx_ehip_fr_clk                    (o_ehip_dist_fr_rx_clk), //   input,    width = 2,
					.aib_ehip_rx_fec_fr_clk                     (o_fec_dist_fr_rx_clk),  //   input,    width = 2,
					.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*5]),//   input,  width = 156,
					.aib_ehip_tx_ehip_clk                       (o_ehip_clk),             //   input,    width = 2,
					.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1]),      //  output,    width = 6,
					.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*5]),//  output,  width = 156,
					.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk[1]),  //  output,    width = 2,
					.ehip_elane_am_detect                       (),                       //  output,    width = 2,
					.ehip_elane_am_insert                       (),                       //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
					.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
					.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
					.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
					.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
					.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
					.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
					.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[5]),   //  output,
					.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
					.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
					.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
					.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
					.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
					.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
					.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
					.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
					.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
					.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
					.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
					.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
					.elane_ehip_shared_clk                      (elane_ehip_shared_clk[5]), //   input,    width = 2,
					.enh_clear_internal_error                   (),                   //   input,    width = 2,
					.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
					.enh_initialized                            (),                         //  output,    width = 2,
					.enh_internal_error                         (),                         //  output,    width = 2,
					.enh_pld_ready                              (),                         //   input,    width = 2,
					.enh_ready                                  (),                         //  output,    width = 2,
					.enh_reset                                  (1'b1),   //   input,    width = 2,
					.enh_reset_stat                             (),                         //  output,    width = 2,
					.hip_aib_fsr_in				    (hip_aib_fsr_in[6*4-1:5*4]),
					.hip_aib_ssr_in				    (hip_aib_ssr_in[6*40-1:5*40]),
					.osc_transfer_en                            (),                         //  output,    width = 2,
					.pll_refclk0                                (i_refclk),                 //input,   width = 1,
					.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
					.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
					.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
					.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
					.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
					.reconfig_clk                               (i_reconfig_clk),  //   input,    width = 2,
					.reconfig_reset                             (i_ptp_reconfig_reset), //   input,    width = 2,
					.reconfig_write                             (i_ptp_reconfig_write[LANES2-1]), //   input,    width = 2,
					.reconfig_read                              (i_ptp_reconfig_read[LANES2-1]),  //   input,    width = 2,
					.reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:19]),//   input,   width = 11**,
					.reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:8]),//   input,   width = 64,
					.reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:8]), //  output,   width = 64,
					.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1]),//  output,    width = 2,
					.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
					.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
					.rx_aib_reset                               (i_rx_aib_reset[0]), //   input,    width = 2,
					.rx_clkout                                  (rx_clkout_ptp[1]),                                 //  output,    width = 2,
					.rx_clkout2                                 (rx_clkout2_ptp[1]),                                 //
					.rx_coreclkin                               (ml_rx_coreclkin),          //   input,    width = 2,
					.rx_enh_aligned                             (),                                 //  output,    width = 2,
					.rx_enh_blk_lock                            (),                            //  output,    width = 2,
					.rx_enh_highber                             (),                             //  output,    width = 2,
					.rx_enh_local_fault                         (),                         //  output,    width = 2,
					.rx_enh_pause                               (),                               //  output,    width = 2,
					.rx_enh_pfc                                 (),                                 //  output,   width = 16,
					.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.rx_enh_remote_fault                        (),                        //  output,    width = 2,
					.rx_enh_reset                               (1'b1),  //   input,    width = 2,
					.rx_enh_reset_stat                          (),                          //  output,    width = 2,
					.rx_enh_signal_ok                           (),                          //   input,    width = 2,
					.rx_fifo_ready                              (),                          //  output,    width = 2,
					.rx_parallel_data                           (rx_parallel_data[6*80-1:5*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
					.rx_pma_ready                               (ptp_rx_pma_ready[1]),                          //  output,    width = 2,
					.rx_pmaif_reset                             (i_rx_pmaif_reset[3]),  //   input,    width = 2,
					.rx_transfer_ready                          (ml_ptp_rx_transfer_ready[1]),                          //  output,    width = 2,
					.tx_aib_reset                               (i_tx_aib_reset[0]), //   input,    width = 2,
					.tx_clkout                                  (ptp_pll_hr_clk_100g[1]),            //  output,    width = 2,
					.tx_clkout2                                 (ptp_pll_fr_clk_100g[1]),            //
					.tx_coreclkin                               (ml_tx_coreclkin/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
					.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ ml_tx_coreclkin2),//   input,
					.tx_dll_lock                                (ml_ptp_plloff_tx_dll_lock),                                //  output,    width = 2,
					.tx_enh_pause                               (),                               //   input,    width = 2,
					.tx_enh_pfc                                 (),                                 //   input,   width = 16,
					.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
					.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
					.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
					.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
					.tx_enh_reset                               (1'b1),  //   input,    width = 2,
					.tx_enh_reset_stat                          (),  //  output,    width = 2,
					.tx_fifo_ready                              (),  //  output,    width = 2,
					.tx_parallel_data                           (pp[LANES2*80-1:80]),		//in, 320b
					.tx_pma_ready                               (ptp_tx_pma_ready[1]),                               //  output,    width = 2,
					.tx_pmaif_reset                             (i_tx_pmaif_reset[3]),  //   input,    width = 2,
					.tx_transfer_ready                          (ml_ptp_tx_transfer_ready[1]) //  output,    width = 2,
				);
           end
// ---------------------------------------------------------------------------------------------------------------------------------


           assign elane_ehip_shared_clk = {LANES6{o_ehip_clk}};

		   // copied from alvin

                eth_100g_cvl_nrz_alt_ehipc3_fm_xcvrnphy_fme_2420_4f4z7my
       #(
         .hssi_rsfec_topology(topology)
       )
			 altera_xcvr_native_inst
	(
                .latency_sclk                               (i_sclk),
                .tx_dl_measure_sel                          (i_tx_sel_sclk_return),
                .rx_dl_measure_sel                          (i_rx_sel_sclk_return),
                .tx_dl_async_pulse                          (o_tx_sclk_return),
                .rx_dl_async_pulse                          (o_rx_sclk_return),

                .rsfec_reset(~i_rsfec_reset),                                   //in.4b
                .rx_rsfec_reset(~i_rx_rsfec_reset),                             //in.4b
                .tx_rsfec_reset(~i_tx_rsfec_reset),                             //in.4b

                .i_rsfec_pld_ready              (i_ehip_pld_ready),
                .rsfec_signal_ok                ({4{rsfec_signal_ok_from_top}}),
                .rsfec_usr_avmm2_rst            (),
                .rsfec_o_config_done            (),
                .rsfec_o_fec_ready              (rsfec_o_fec_ready),
                .rsfec_o_internal_error         (),
                .rsfec_o_status_rx_not_align    (),
                .rsfec_o_status_rx_not_deskew   (),
                .rsfec_o_tx_dsk_valid           (),
		.o_rsfec_channel_ssr		(o_rsfec_channel_ssr),			//out,32b

                .reconfig_rsfec_clk             (i_rsfec_reconfig_clk),
                .reconfig_rsfec_reset           (i_xcvr_reconfig_reset),
                .reconfig_rsfec_write           (i_rsfec_reconfig_write),
                .reconfig_rsfec_read            (i_rsfec_reconfig_read),
                .reconfig_rsfec_address         (i_rsfec_reconfig_addr[11-1:0]),
                .reconfig_rsfec_writedata       (i_rsfec_reconfig_writedata),
                .reconfig_rsfec_readdata        (o_rsfec_reconfig_readdata),
                .reconfig_rsfec_waitrequest     (o_rsfec_reconfig_waitrequest),

		.pll_refclk0(i_refclk[0]),					//in,1b		pll_refclk0.clk
		.rx_coreclkin({LANES4{ml_rx_coreclkin}}),				//in.4b		rx_coreclkin.clk
		.tx_coreclkin({LANES4{ml_tx_coreclkin}}),				//in.4b		tx_coreclkin.clk
		.tx_coreclkin2({LANES4{ml_tx_coreclkin2}}),				//in.4b		tx_coreclkin.clk
		.aib_ehip_rx_ehip_clk({LANES4{o_ehip_clk}}),			//in,4b		aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
		.aib_ehip_rx_ehip_fr_clk({LANES4{o_ehip_dist_fr_rx_clk}}),	//in,4b		aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
		.aib_ehip_rx_fec_fr_clk({LANES4{o_fec_dist_fr_rx_clk}}),	//in.4b		aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
		.aib_ehip_tx_ehip_clk({LANES4{o_ehip_clk}}),			//in.4b		aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
		.pma_ehip_rx_ehip_clk_div2({4{o_ehip_clk}}), 			//
		.pma_ehip_tx_ehip_clk_div2({4{o_ehip_clk}}), 			//

		.RSFEC_ehip_clock(o_ehip_clk),					//in, 402mhz ==> connect wrong
		.pmaRsfec_ehip_tx_ehip_data(core_tx_data),			//in
		.pmaRsfec_ehip_tx_ehip_dv(core_tx_data_valid),			//in
		.pmaRsfec_ehip_tx_ehip_fifo_rst_n(core_tx_data_am_valid),	//in
		.pmaRsfec_ehip_tx_ehip_data_am_valid_in(core_tx_data_am_valid),	//input,   width = 1
		.ehip_pmaRsfec_fec_rx_data(core_rx_data),			//out
		.ehip_pmaRsfec_fec_rx_data_valid(core_rx_data_valid),		//out
		.ehip_pmaRsfec_fec_rx_data_am_valid(core_rx_data_am_valid),	//out

		.pma_ehip_rx_ehip_fifo_rst_n({LANES4{h2a_rx_ehip_rst_n}}),	//in.4b

		.rx_aib_reset(i_rx_aib_reset),					//in.4b
		.tx_aib_reset(i_tx_aib_reset),					//in.4b
		.rx_pmaif_reset(i_rx_pmaif_reset),				//in.4b
		.tx_pmaif_reset(i_tx_pmaif_reset),				//in.4b
		.enh_reset(4'hf),						//in.4b
		.rx_enh_reset(4'hf),						//in.4b
		.tx_enh_reset(4'hf),						//in.4b

		.ehip_pma_tx_pma_clk(xcvr_fr_tx_clk[LANES4-1:0]),           	//out,4b
		.rx_clkout(rx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
		.tx_clkout(tx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
		.rx_clkout2(rx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
		.tx_clkout2(tx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
		.ehip_aib_tx_transfer_div2_clk({tmp_clk3, tmp_clk2, tmp_clk1, ehip_clk}), //out,4b

		.rx_serial_data(i_rx_serial_data[3:0]),	 			//in, 4b
		.rx_serial_data_n(),			 			//in, 4b
		.tx_serial_data(o_tx_serial_data[3:0]),				//out,4b
		.tx_serial_data_n(),						//out,4b
		.rx_parallel_data(rx_parallel_data[LANES4*80-1:0]),		//out,320b
		.tx_parallel_data(tx_parallel_data_r[LANES4*80-1:0]),		//in, 320b

		.ehip_aib_aib_status(a2h_hip_aib_status), 			//out.12b
		.aib_ehip_rx_sync_data(ehip_aib_sync_data_in[LANES4*78-1:0]),	//in,312b
		.hip_aib_fsr_in(hip_aib_fsr_in[LANES4*4-1:0]),
		.hip_aib_ssr_in(hip_aib_ssr_in[LANES4*40-1:0]),
		.ehip_aib_tx_sync_data(ehip_aib_sync_data_out[LANES4*78-1:0]),	//out.312b

		.enh_pld_ready({{(4-SL_LANES){1'b0}},i_sl_ehip_pld_ready}),	//in,4b
		.rx_pma_ready(rx_pma_ready[LANES4-1:0]),			//out,4b
		.tx_pma_ready(tx_pma_ready[LANES4-1:0]),			//out,4b
		.rx_is_lockedtodata(rx_is_lockedtodata[LANES4-1:0]),		//out,4b
		.rx_transfer_ready(o_rx_transfer_ready[LANES4-1:0]),		//out,4b
		.tx_transfer_ready(o_tx_transfer_ready[LANES4-1:0]),		//out,4b

		.elane_ehip_shared_clk                      (elane_ehip_shared_clk[LANES-1:0]),			//in, width = 2,
		.elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LANES4*2-1:0]),		//in, width = 8,
		.elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LANES4*24-1:0]),     	//  in, width = 96,
		.elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LANES4*3-1:0]),	//  in, width = 12,
		.elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LANES4*3-1:0]),	//  in, width = 12,
		.elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LANES4*2-1:0]),	//  in, width = 8,
		.elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LANES4*24-1:0]),  	//  in, width = 96,
		.elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LANES4*3-1:0]),	//  in, width = 12,
		.elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LANES4*3-1:0]),//  in,width = 12,
		.elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LANES4*1-1:0]),      //  in,    width = 4,
		.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LANES4*6-1:0]), //  in,   width = 24,
		.elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LANES4*1-1:0]),   //  in,    width = 4,
		.ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[LANES4*23-1:0]),     		//   out,   width = 92,
		.ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[LANES4*12-1:0]),        	//   out,   width = 48,
		.ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[LANES4*2-1:0]),      	//   out,    width = 8,
		.ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[LANES4*1-1:0]),   	//   out,    width = 4,
		.ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[LANES4*1-1:0]),	//   out,    width = 4,
		.ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[LANES4*1-1:0]),	//   out,    width = 4,
		.ehip_elane_am_detect                       (ehip_elane_am_detect[LANES4*1-1:0]),           	//   out,    width = 4,
		.ehip_elane_am_insert                       (ehip_elane_am_insert[LANES4*1-1:0]),           	//   out,    width = 4,
		.ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[LANES4*1-1:0]),     	//   out,    width = 4,
		.ehip_elane_shared_clear                    (ehip_elane_shared_clear[LANES4*1-1:0]),        	//   out,    width = 4,
		.enh_clear_internal_error		            (4'b0),				//in, width =4,
		.enh_force_rcfg_reset			            (4'hf),				//in, width =4,
		.enh_initialized                            (), 				//output,    width = 4,
		.enh_internal_error                         (),                    		//  output,    width = 4,
		.osc_transfer_en                            (),                         			//  output,    width = 4,
		.rx_enh_aligned                             (),                        //  output,    width = 4,
		.rx_enh_blk_lock                            (),                 		//  output,    width = 4,
		.rx_enh_highber                             (),                  			//  output,    width = 4,
		.rx_enh_local_fault                         (),              		//  output,    width = 4,
		.rx_enh_pause                               (),                    		//  output,    width = 4,
		.rx_enh_pfc                                 (),                      		//  output,   width = 32,
		.rx_enh_pmaif_fifo_overflow                 (),            		//  output,    width = 4,
		.rx_enh_remote_fault                        (),                  	//  output,    width = 4,
		.rx_enh_reset_stat                          (),                     	//  output,    width = 4,
		.rx_enh_signal_ok                           (4'b0),                      	//   input,    width = 4,
		.rx_fifo_ready                              (o_rx_fifo_ready),                         		//  output,    width = 4,
		.tx_dll_lock                                (o_tx_dll_lock[LANES4*1-1:0]),            		//  output,    width = 4,
		.tx_enh_pause                               (4'b0),                         		//   input,   width = 4,
		.tx_enh_pfc                                 (32'b0),                         		//   input,   width = 8,
		.tx_enh_pmaif_fifo_almost_empty             (),				//  output,    width = 4,
		.tx_enh_pmaif_fifo_almost_full              (),				//  output,    width = 4,
		.tx_enh_pmaif_fifo_overflow                 (),			//  output,    width = 4,
		.tx_enh_pmaif_fifo_underflow                (),			//  output,    width = 4,
		.tx_fifo_ready                              (o_tx_fifo_ready),					//  output,    width = 4,

		// Reconfig Interface
		.reconfig_clk({LANES4{i_xcvr_reconfig_clk}}),				//in,4b
		.reconfig_reset({LANES4{i_xcvr_reconfig_reset}}),			//in,4b
		.reconfig_write(i_xcvr_reconfig_write[LANES4-1:0]),			//in,4b
		.reconfig_read(i_xcvr_reconfig_read[LANES4-1:0]),			//in,4b
		.reconfig_address(i_xcvr_reconfig_address[LANES4*19-1:0]),		//in,80b
		.reconfig_writedata(i_xcvr_reconfig_writedata[LANES4*8-1:0]),		//in,128b
		.reconfig_readdata(o_xcvr_reconfig_readdata[LANES4*8-1:0]),		//out,128b
		.reconfig_waitrequest(o_xcvr_reconfig_waitrequest[LANES4-1:0])		//out,4b
		);


end // E100GX4_FEC_PTP_PR
   endgenerate

// 100G PTP

   generate
      if (ENABLE_PTP==0 && core_variant==3 && active_channel==1 && ehip_mode == "ehip_mac_ptp_no_fec")
        begin : E100GX4_NOFEC_PTP
           assign ptp_clk  = ptp_ehip_aib_tx_transfer_div2_clk[0];
           assign ptp_ch_hr_clk = /*USE_PTP_PLLCH*/ 0 ? ptp_pll_hr_clk_100g : i_sl_clk_tx[0];
           assign ptp_ch_fr_clk = /*USE_PTP_PLLCH ? ptp_pll_fr_clk :*/ tx_clkout2;

           alt_ehipc3_fm_nphy_elane_ptp
			 nphy_ptp
			   (
				.aib_ehip_rx_ehip_clk                       ({LANES2{o_ehip_clk}}), //   input,    width = 2,
				.aib_ehip_rx_ehip_fr_clk                    ({LANES2{o_ehip_dist_fr_rx_clk}}), //   input,    width = 2,
				.aib_ehip_rx_fec_fr_clk                     ({LANES2{o_fec_dist_fr_rx_clk}}),  //   input,    width = 2,
				.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*4]),//   input,  width = 156,
				.aib_ehip_tx_ehip_clk                       ({LANES2{o_ehip_clk}}),             //   input,    width = 2,
				.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1:0]),      //  output,    width = 6,
				.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*4]),//  output,  width = 156,
				.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk),  //  output,    width = 2,
				.ehip_elane_am_detect                       (),                       //  output,    width = 2,
				.ehip_elane_am_insert                       (),                       //  output,    width = 2,
				.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
				.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
				.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
				.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
				.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
				.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
				.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
				.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
				.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[5:4]),   //  output,
				.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
				.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
				.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
				.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
				.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
				.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
				.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
				.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
				.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
				.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
				.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
				.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
				.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
				.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
				.elane_ehip_shared_clk                      (elane_ehip_shared_clk[5:4]), //   input,    width = 2,
				.enh_clear_internal_error                   (),                   //   input,    width = 2,
				.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
				.enh_initialized                            (),                         //  output,    width = 2,
				.enh_internal_error                         (),                         //  output,    width = 2,
				.enh_pld_ready                              (),                         //   input,    width = 2,
				.enh_ready                                  (),                         //  output,    width = 2,
				.enh_reset                                  (2'h3),   //   input,    width = 2,
				.enh_reset_stat                             (),                         //  output,    width = 2,
				.hip_aib_fsr_in(hip_aib_fsr_in[6*4-1:4*4]),
				.hip_aib_ssr_in(hip_aib_ssr_in[6*40-1:4*40]),
				.osc_transfer_en                            (),                         //  output,    width = 2,
// kluge: fix it TODO
//				.pll_refclk0                                (i_refclk),                 //input,   width = 1,
				.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
				.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
				.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
				.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
				.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
				.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
				.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
				.reconfig_clk                               ({LANES2{i_reconfig_clk}}),  //   input,    width = 2,
				.reconfig_reset                             ({LANES2{i_xcvr_reconfig_reset}}), //   input,    width = 2,
				.reconfig_write                             (i_ptp_reconfig_write[LANES2-1:0]), //   input,    width = 2,
				.reconfig_read                              (i_ptp_reconfig_read[LANES2-1:0]),  //   input,    width = 2,
				.reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:0]),//   input,   width = 11**,
				.reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:0]),//   input,   width = 64,
				.reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:0]), //  output,   width = 64,
				.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1:0]),//  output,    width = 2,
				.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
				.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
				.rx_aib_reset                               ({2{i_rx_aib_reset[0]}}), //   input,    width = 2,
				.rx_clkout                                  (),                                 //  output,    width = 2,
				.rx_clkout2                                 (),                                 //
				.rx_coreclkin                               ({LANES2{i_rx_core_clk}}),          //   input,    width = 2,
				.rx_enh_aligned                             (),                                 //  output,    width = 2,
				.rx_enh_blk_lock                            (),                            //  output,    width = 2,
				.rx_enh_highber                             (),                             //  output,    width = 2,
				.rx_enh_local_fault                         (),                         //  output,    width = 2,
				.rx_enh_pause                               (),                               //  output,    width = 2,
				.rx_enh_pfc                                 (),                                 //  output,   width = 16,
				.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
				.rx_enh_remote_fault                        (),                        //  output,    width = 2,
				.rx_enh_reset                               (2'h3),  //   input,    width = 2,
				.rx_enh_reset_stat                          (),                          //  output,    width = 2,
				.rx_enh_signal_ok                           (),                          //   input,    width = 2,
				.rx_fifo_ready                              (),                          //  output,    width = 2,
				.rx_parallel_data                           (rx_parallel_data[6*80-1:4*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
				.rx_pma_ready                               (),                          //  output,    width = 2,
				.rx_pmaif_reset                             (i_rx_pmaif_reset[3:2]),  //   input,    width = 2,
				.rx_transfer_ready                          (),                          //  output,    width = 2,
				.tx_aib_reset                               ({2{i_tx_aib_reset[0]}}), //   input,    width = 2,
				.tx_clkout                                  (ptp_pll_hr_clk_100g),            //  output,    width = 2,
				.tx_clkout2                                 (ptp_pll_fr_clk_100g),            //
				.tx_coreclkin                               ({LANES2{tx_clkout[0]}}/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
				.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ {LANES2{ptp_ch_fr_clk}}),//   input,
				.tx_dll_lock                                (),                                //  output,    width = 2,
				.tx_enh_pause                               (),                               //   input,    width = 2,
				.tx_enh_pfc                                 (),                                 //   input,   width = 16,
				.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
				.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
				.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
				.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
				.tx_enh_reset                               (2'h3),  //   input,    width = 2,
				.tx_enh_reset_stat                          (),  //  output,    width = 2,
				.tx_fifo_ready                              (),  //  output,    width = 2,
				.tx_parallel_data                           (pp),		//in, 320b
				.tx_pma_ready                               (),                               //  output,    width = 2,
				.tx_pmaif_reset                             (i_tx_pmaif_reset[3:2]),  //   input,    width = 2,
				.tx_transfer_ready                          (o_tx_transfer_ready[5:4]) //  output,    width = 2,
				);


           assign elane_ehip_shared_clk = {LANES6{o_ehip_clk}};



                eth_100g_cvl_nrz_alt_ehipc3_fm_xcvrnphy_fme_2420_4f4z7my altera_xcvr_native_inst (
				.latency_sclk                               (i_sclk),
				.tx_dl_measure_sel                          (i_tx_sel_sclk_return),
				.rx_dl_measure_sel                          (i_rx_sel_sclk_return),
				.tx_dl_async_pulse                          (o_tx_sclk_return),
				.rx_dl_async_pulse                          (o_rx_sclk_return),
				.pll_refclk0(i_refclk[0]),					//in,1b		pll_refclk0.clk
				.rx_coreclkin({LANES4{ml_rx_coreclkin}}),				//in.4b		rx_coreclkin.clk
				.tx_coreclkin({LANES4{ml_tx_coreclkin}}),				//in.4b		tx_coreclkin.clk
				.tx_coreclkin2({LANES4{ml_tx_coreclkin2}}),				//in.4b		tx_coreclkin2.clk
				.aib_ehip_rx_ehip_clk({LANES4{o_ehip_clk}}),			//in,4b		aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
				.aib_ehip_rx_ehip_fr_clk({LANES4{o_ehip_dist_fr_rx_clk}}),	//in,4b		aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
				.aib_ehip_rx_fec_fr_clk({LANES4{o_fec_dist_fr_rx_clk}}),	//in.4b		aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
				.aib_ehip_tx_ehip_clk({LANES4{o_ehip_clk}}),			//in.4b		aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
				.pma_ehip_rx_ehip_clk_div2({4{o_ehip_clk}}), 			//
				.pma_ehip_tx_ehip_clk_div2({4{o_ehip_clk}}), 			//

				.RSFEC_ehip_clock(o_ehip_clk),					//in, 402mhz
				.pmaRsfec_ehip_tx_ehip_data(core_tx_data),			//in
				.pmaRsfec_ehip_tx_ehip_dv(core_tx_data_valid),			//in
				.pmaRsfec_ehip_tx_ehip_fifo_rst_n(core_tx_data_am_valid),	//in
				.ehip_pmaRsfec_fec_rx_data(core_rx_data),			//out
				.ehip_pmaRsfec_fec_rx_data_valid(core_rx_data_valid),		//out
				.ehip_pmaRsfec_fec_rx_data_am_valid(core_rx_data_am_valid),	//out

				.pma_ehip_rx_ehip_fifo_rst_n({LANES4{h2a_rx_ehip_rst_n}}),	//in.4b

				.rx_aib_reset(i_rx_aib_reset),					//in.4b
				.tx_aib_reset(i_tx_aib_reset),					//in.4b
				.rx_pmaif_reset(i_rx_pmaif_reset),				//in.4b
				.tx_pmaif_reset(i_tx_pmaif_reset),				//in.4b
				.enh_reset(4'hf),						//in.4b
				.rx_enh_reset(4'hf),						//in.4b
				.tx_enh_reset(4'hf),						//in.4b

				.ehip_pma_tx_pma_clk(xcvr_fr_tx_clk[LANES4-1:0]),           	//out,4b
				.rx_clkout(rx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
				.tx_clkout(tx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
				.rx_clkout2(rx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
				.tx_clkout2(tx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
				.ehip_aib_tx_transfer_div2_clk({tmp_clk3, tmp_clk2, tmp_clk1, ehip_clk}), //out,4b

				.rx_serial_data(i_rx_serial_data[3:0]),	 			//in, 4b
				.rx_serial_data_n(),			 			//in, 4b
				.tx_serial_data(o_tx_serial_data[3:0]),				//out,4b
				.tx_serial_data_n(),						//out,4b
				.rx_parallel_data(rx_parallel_data[LANES4*80-1:0]),		//out,320b
				.tx_parallel_data(tx_parallel_data_r[LANES4*80-1:0]),		//in, 320b

				.ehip_aib_aib_status(a2h_hip_aib_status), 			//out.12b
				.aib_ehip_rx_sync_data(ehip_aib_sync_data_in[LANES4*78-1:0]),	//in,312b
				.hip_aib_fsr_in(hip_aib_fsr_in[LANES4*4-1:0]),
				.hip_aib_ssr_in(hip_aib_ssr_in[LANES4*40-1:0]),
				.ehip_aib_tx_sync_data(ehip_aib_sync_data_out[LANES4*78-1:0]),	//out.312b

				.enh_pld_ready({{(4-SL_LANES){1'b0}},i_sl_ehip_pld_ready}),	//in,4b
				.rx_pma_ready(rx_pma_ready[LANES4-1:0]),			//out,4b
				.tx_pma_ready(tx_pma_ready[LANES4-1:0]),			//out,4b
				.rx_is_lockedtodata(rx_is_lockedtodata[LANES4-1:0]),		//out,4b
				.rx_transfer_ready(o_rx_transfer_ready[LANES4-1:0]),		//out,4b
				.tx_transfer_ready(o_tx_transfer_ready[LANES4-1:0]),		//out,4b

				.elane_ehip_shared_clk                      (elane_ehip_shared_clk[LANES-1:0]),			//in, width = 2,
				.elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LANES4*2-1:0]),		//in, width = 8,
				.elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LANES4*24-1:0]),     	//  in, width = 96,
				.elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LANES4*3-1:0]),	//  in, width = 12,
				.elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LANES4*3-1:0]),	//  in, width = 12,
				.elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LANES4*2-1:0]),	//  in, width = 8,
				.elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LANES4*24-1:0]),  	//  in, width = 96,
				.elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LANES4*3-1:0]),	//  in, width = 12,
				.elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LANES4*3-1:0]),//  in,width = 12,
				.elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LANES4*1-1:0]),      //  in,    width = 4,
				.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LANES4*6-1:0]), //  in,   width = 24,
				.elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LANES4*1-1:0]),   //  in,    width = 4,
				.ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[LANES4*23-1:0]),     		//   out,   width = 92,
				.ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[LANES4*12-1:0]),        	//   out,   width = 48,
				.ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[LANES4*2-1:0]),      	//   out,    width = 8,
				.ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[LANES4*1-1:0]),   	//   out,    width = 4,
				.ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[LANES4*1-1:0]),	//   out,    width = 4,
				.ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[LANES4*1-1:0]),	//   out,    width = 4,
				.ehip_elane_am_detect                       (ehip_elane_am_detect[LANES4*1-1:0]),           	//   out,    width = 4,
				.ehip_elane_am_insert                       (ehip_elane_am_insert[LANES4*1-1:0]),           	//   out,    width = 4,
				.ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[LANES4*1-1:0]),     	//   out,    width = 4,
				.ehip_elane_shared_clear                    (ehip_elane_shared_clear[LANES4*1-1:0]),        	//   out,    width = 4,
				.enh_clear_internal_error		    ({LANES4{i_sl_clear_internal_err[0]}}),				//in, width =4,
				.enh_force_rcfg_reset			    (4'hf),				//in, width =4,
				.enh_initialized                            (), 				//output,    width = 4,
				.enh_internal_error                         (),                    		//  output,    width = 4,
				.osc_transfer_en                            (),                         			//  output,    width = 4,
				.rx_enh_aligned                             (),                        //  output,    width = 4,
				.rx_enh_blk_lock                            (),                 		//  output,    width = 4,
				.rx_enh_highber                             (),                  			//  output,    width = 4,
				.rx_enh_local_fault                         (),              		//  output,    width = 4,
				.rx_enh_pause                               (),                    		//  output,    width = 4,
				.rx_enh_pfc                                 (),                      		//  output,   width = 32,
				.rx_enh_pmaif_fifo_overflow                 (),            		//  output,    width = 4,
				.rx_enh_remote_fault                        (),                  	//  output,    width = 4,
				.rx_enh_reset_stat                          (),                     	//  output,    width = 4,
				.rx_enh_signal_ok                           (4'b0),                      	//  input,    width = 4,
				.rx_fifo_ready                              (o_rx_fifo_ready),                         		//  output,    width = 4,
				.tx_dll_lock                                (o_tx_dll_lock[LANES4*1-1:0]),            		//  output,    width = 4,
				.tx_enh_pause                               (4'b0),                         		//  input,   width = 1,
				.tx_enh_pfc                                 (32'b0),                         		//  input,   width = 8,
				.tx_enh_pmaif_fifo_almost_empty             (),				//  output,    width = 4,
				.tx_enh_pmaif_fifo_almost_full              (),				//  output,    width = 4,
				.tx_enh_pmaif_fifo_overflow                 (),			//  output,    width = 4,
				.tx_enh_pmaif_fifo_underflow                (),			//  output,    width = 4,
				.tx_fifo_ready                              (o_tx_fifo_ready),					//  output,    width = 4,

				// Reconfig Interface
				.reconfig_clk({LANES4{i_xcvr_reconfig_clk}}),				//in,4b
				.reconfig_reset({LANES4{i_xcvr_reconfig_reset}}),			//in,4b
				.reconfig_write(i_xcvr_reconfig_write[LANES4-1:0]),			//in,4b
				.reconfig_read(i_xcvr_reconfig_read[LANES4-1:0]),			//in,4b
				.reconfig_address(i_xcvr_reconfig_address[LANES4*19-1:0]),		//in,80b
				.reconfig_writedata(i_xcvr_reconfig_writedata[LANES4*8-1:0]),		//in,128b
				.reconfig_readdata(o_xcvr_reconfig_readdata[LANES4*8-1:0]),		//out,128b
				.reconfig_waitrequest(o_xcvr_reconfig_waitrequest[LANES4-1:0])		//out,4b
				);
        end // E100GX4_NOFEC_PTP
   endgenerate

// 100G PTP+RSFEC
   generate
      if (ENABLE_PTP==0 && core_variant==3 && active_channel==1 && ehip_mode == "ehip_mac_ptp" )
        begin : E100GX4_FEC_PTP

           assign ptp_clk  = ptp_ehip_aib_tx_transfer_div2_clk[0];
           assign ptp_ch_hr_clk = /*USE_PTP_PLLCH*/ 0 ? ptp_pll_hr_clk_100g : i_sl_clk_tx[0];
           assign ptp_ch_fr_clk = /*USE_PTP_PLLCH ? ptp_pll_fr_clk :*/ tx_clkout2;

           alt_ehipc3_fm_nphy_elane_ptp
      #(
         .hssi_rsfec_topology(topology)
       )
			 nphy_ptp
			   (

				.aib_ehip_rx_ehip_clk                       ({LANES2{o_ehip_clk}}), //   input,    width = 2,
				.aib_ehip_rx_ehip_fr_clk                    ({LANES2{o_ehip_dist_fr_rx_clk}}), //   input,    width = 2,
				.aib_ehip_rx_fec_fr_clk                     ({LANES2{o_fec_dist_fr_rx_clk}}),  //   input,    width = 2,
				.aib_ehip_rx_sync_data                      (ehip_aib_sync_data_in[78*6-1:78*4]),//   input,  width = 156,
				.aib_ehip_tx_ehip_clk                       ({LANES2{o_ehip_clk}}),             //   input,    width = 2,
				.ehip_aib_aib_status                        (a2h_hip_aib_status_ptp[1:0]),      //  output,    width = 6,
				.ehip_aib_tx_sync_data                      (ehip_aib_sync_data_out[78*6-1:78*4]),//  output,  width = 156,
				.ehip_aib_tx_transfer_div2_clk              (ptp_ehip_aib_tx_transfer_div2_clk),  //  output,    width = 2,
				.ehip_elane_am_detect                       (),                       //  output,    width = 2,
				.ehip_elane_am_insert                       (),                       //  output,    width = 2,
				.ehip_elane_ptp_fifo_share_rd_en            (),            //  output,    width = 2,
				.ehip_elane_ptp_fifo_share_wr_en            (),            //  output,    width = 2,
				.ehip_elane_ptp_tx_ts                       (),                       //  output,   width = 24,
				.ehip_elane_ptp_tx_ts_fp                    (),                    //  output,    width = 4,
				.ehip_elane_ptp_tx_ts_valid                 (),                 //  output,    width = 2,
				.ehip_elane_rx_ptp_ts                       (),                       //  output,   width = 46,
				.ehip_elane_shared_clear                    (),                    //  output,    width = 2,
				.ehip_elane_shared_dsk_done                 (),                 //  output,    width = 2,
				.ehip_pma_tx_pma_clk                        (xcvr_fr_tx_clk[5:4]),   //  output,
				.ehip_pmaRsfec_fec_rx_data                  (),                  //  output,  width = 132,
				.ehip_pmaRsfec_fec_rx_data_am_valid         (),         //  output,    width = 2,
				.ehip_pmaRsfec_fec_rx_data_valid            (),            //  output,    width = 2,
				.elane_ehip_ptp_deskewed_byte_offset        (),        //   input,    width = 6,
				.elane_ehip_ptp_deskewed_ins_type           (),           //   input,    width = 6,
				.elane_ehip_ptp_deskewed_ts                 (),                 //   input,   width = 48,
				.elane_ehip_ptp_deskewed_tx_fp              (),              //   input,    width = 4,
				.elane_ehip_ptp_lane_deskew_deskew_marker   (),   //   input,    width = 2,
				.elane_ehip_ptp_lane_deskew_got_marker      (),      //   input,    width = 2,
				.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (), //   input,   width = 12,
				.elane_ehip_ptp_mac_byte_offset             (),             //   input,    width = 6,
				.elane_ehip_ptp_mac_ins_type                (),                //   input,    width = 6,
				.elane_ehip_ptp_mac_ts                      (),                      //   input,   width = 48,
				.elane_ehip_ptp_mac_tx_fp                   (),                   //   input,    width = 4,
				.elane_ehip_shared_clk                      (elane_ehip_shared_clk[5:4]), //   input,    width = 2,
				.enh_clear_internal_error                   (),                   //   input,    width = 2,
				.enh_force_rcfg_reset                       (/*i_sl_force_rcfg_reset*/), //   input,    width = 2, //tmp
				.enh_initialized                            (),                         //  output,    width = 2,
				.enh_internal_error                         (),                         //  output,    width = 2,
				.enh_pld_ready                              (),                         //   input,    width = 2,
				.enh_ready                                  (),                         //  output,    width = 2,
				.enh_reset                                  (2'h3),   //   input,    width = 2,
				.enh_reset_stat                             (),                         //  output,    width = 2,
				.hip_aib_fsr_in(hip_aib_fsr_in[6*4-1:4*4]),
				.hip_aib_ssr_in(hip_aib_ssr_in[6*40-1:4*40]),
				.osc_transfer_en                            (),                         //  output,    width = 2,
// kluge: fix it TODO
//				.pll_refclk0                                (i_refclk),                 //input,   width = 1,
				.pma_ehip_rx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),      //   input,    width = 2,
				.pma_ehip_rx_ehip_fifo_rst_n                (/*{2{h2a_rx_ehip_rst_n}}*/),//   input,    width = 2,
				.pma_ehip_tx_ehip_clk_div2                  (/*{2{o_ehip_clk}}*/),       //   input,    width = 2,
				.pmaRsfec_ehip_tx_ehip_data                 (),                 //   input,  width = 132,
				.pmaRsfec_ehip_tx_ehip_data_am_valid_in     (),     //   input,    width = 2,
				.pmaRsfec_ehip_tx_ehip_dv                   (),                   //   input,    width = 2,
				.pmaRsfec_ehip_tx_ehip_fifo_rst_n           (),           //   input,    width = 2,
				.reconfig_clk                               ({LANES2{i_reconfig_clk}}),  //   input,    width = 2,
				.reconfig_reset                             ({LANES2{i_xcvr_reconfig_reset}}), //   input,    width = 2,
				.reconfig_write                             (i_ptp_reconfig_write[LANES2-1:0]), //   input,    width = 2,
				.reconfig_read                              (i_ptp_reconfig_read[LANES2-1:0]),  //   input,    width = 2,
				.reconfig_address                           (i_ptp_reconfig_address[LANES2*19-1:0]),//   input,   width = 11**,
				.reconfig_writedata                         (i_ptp_reconfig_writedata[LANES2*8-1:0]),//   input,   width = 64,
				.reconfig_readdata                          (o_ptp_reconfig_readdata[LANES2*8-1:0]), //  output,   width = 64,
				.reconfig_waitrequest                       (o_ptp_reconfig_waitrequest[LANES2-1:0]),//  output,    width = 2,
				.RSFEC_ehip_clock                           (o_ehip_clk),     //   input,    width = 1,
				.RSFEC_ehip_tx_adpt_clock                   (),                   //   input,    width = 2,
				.rx_aib_reset                               ({2{i_rx_aib_reset[0]}}), //   input,    width = 2,
				.rx_clkout                                  (),                                 //  output,    width = 2,
				.rx_clkout2                                 (),                                 //
				.rx_coreclkin                               ({LANES2{i_rx_core_clk}}),          //   input,    width = 2,
				.rx_enh_aligned                             (),                                 //  output,    width = 2,
				.rx_enh_blk_lock                            (),                            //  output,    width = 2,
				.rx_enh_highber                             (),                             //  output,    width = 2,
				.rx_enh_local_fault                         (),                         //  output,    width = 2,
				.rx_enh_pause                               (),                               //  output,    width = 2,
				.rx_enh_pfc                                 (),                                 //  output,   width = 16,
				.rx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
				.rx_enh_remote_fault                        (),                        //  output,    width = 2,
				.rx_enh_reset                               (2'h3),  //   input,    width = 2,
				.rx_enh_reset_stat                          (),                          //  output,    width = 2,
				.rx_enh_signal_ok                           (),                          //   input,    width = 2,
				.rx_fifo_ready                              (),                          //  output,    width = 2,
				.rx_parallel_data                           (rx_parallel_data[6*80-1:4*80]/*nphy_ptp_rx_parallel_data*/), //  output,  width = 160,
				.rx_pma_ready                               (),                          //  output,    width = 2,
				.rx_pmaif_reset                             (i_rx_pmaif_reset[3:2]),  //   input,    width = 2,
				.rx_transfer_ready                          (),                          //  output,    width = 2,
				.tx_aib_reset                               ({2{i_tx_aib_reset[0]}}), //   input,    width = 2,
				.tx_clkout                                  (ptp_pll_hr_clk_100g),            //  output,    width = 2,
				.tx_clkout2                                 (ptp_pll_fr_clk_100g),            //
				.tx_coreclkin                               ({LANES2{tx_clkout[0]}}/*{LANES2{ptp_ch_hr_clk}}*/),//   input,
				.tx_coreclkin2                              (/*{LANES2{tx_clkout}}*/ {LANES2{ptp_ch_fr_clk}}),//   input,
				.tx_dll_lock                                (),                                //  output,    width = 2,
				.tx_enh_pause                               (),                               //   input,    width = 2,
				.tx_enh_pfc                                 (),                                 //   input,   width = 16,
				.tx_enh_pmaif_fifo_almost_empty             (),             //  output,    width = 2,
				.tx_enh_pmaif_fifo_almost_full              (),              //  output,    width = 2,
				.tx_enh_pmaif_fifo_overflow                 (),                 //  output,    width = 2,
				.tx_enh_pmaif_fifo_underflow                (),                //  output,    width = 2,
				.tx_enh_reset                               (2'h3),  //   input,    width = 2,
				.tx_enh_reset_stat                          (),  //  output,    width = 2,
				.tx_fifo_ready                              (),  //  output,    width = 2,
				.tx_parallel_data                           (pp),		//in, 320b
				.tx_pma_ready                               (),                               //  output,    width = 2,
				.tx_pmaif_reset                             (i_tx_pmaif_reset[3:2]),  //   input,    width = 2,
				.tx_transfer_ready                          (o_tx_transfer_ready[5:4]) //  output,    width = 2,
				);


           assign elane_ehip_shared_clk = {LANES6{o_ehip_clk}};

		   // copied from alvin

                eth_100g_cvl_nrz_alt_ehipc3_fm_xcvrnphy_fme_2420_4f4z7my
       #(
         .hssi_rsfec_topology(topology)
       )
			 altera_xcvr_native_inst
	(
                .latency_sclk                               (i_sclk),
                .tx_dl_measure_sel                          (i_tx_sel_sclk_return),
                .rx_dl_measure_sel                          (i_rx_sel_sclk_return),
                .tx_dl_async_pulse                          (o_tx_sclk_return),
                .rx_dl_async_pulse                          (o_rx_sclk_return),

                .rsfec_reset(~i_rsfec_reset),                                   //in.4b
                .rx_rsfec_reset(~i_rx_rsfec_reset),                             //in.4b
                .tx_rsfec_reset(~i_tx_rsfec_reset),                             //in.4b

                .i_rsfec_pld_ready              (i_ehip_pld_ready),
                .rsfec_signal_ok                ({4{rsfec_signal_ok_from_top}}),
                .rsfec_usr_avmm2_rst            (),
                .rsfec_o_config_done            (),
                .rsfec_o_fec_ready              (rsfec_o_fec_ready),
                .rsfec_o_internal_error         (),
                .rsfec_o_status_rx_not_align    (),
                .rsfec_o_status_rx_not_deskew   (),
                .rsfec_o_tx_dsk_valid           (),
		.o_rsfec_channel_ssr		(o_rsfec_channel_ssr),			//out,32b

                .reconfig_rsfec_clk             (i_rsfec_reconfig_clk),
                .reconfig_rsfec_reset           (i_xcvr_reconfig_reset),
                .reconfig_rsfec_write           (i_rsfec_reconfig_write),
                .reconfig_rsfec_read            (i_rsfec_reconfig_read),
                .reconfig_rsfec_address         (i_rsfec_reconfig_addr[11-1:0]),
                .reconfig_rsfec_writedata       (i_rsfec_reconfig_writedata),
                .reconfig_rsfec_readdata        (o_rsfec_reconfig_readdata),
                .reconfig_rsfec_waitrequest     (o_rsfec_reconfig_waitrequest),

		.pll_refclk0(i_refclk[0]),					//in,1b		pll_refclk0.clk
		.rx_coreclkin({LANES4{ml_rx_coreclkin}}),				//in.4b		rx_coreclkin.clk
		.tx_coreclkin({LANES4{ml_tx_coreclkin}}),				//in.4b		tx_coreclkin.clk
		.tx_coreclkin2({LANES4{ml_tx_coreclkin2}}),				//in.4b		tx_coreclkin2.clk
		.aib_ehip_rx_ehip_clk({LANES4{o_ehip_clk}}),			//in,4b		aib_ehip_rx_ehip_clk.aib_ehip_rx_ehip_clk
		.aib_ehip_rx_ehip_fr_clk({LANES4{o_ehip_dist_fr_rx_clk}}),	//in,4b		aib_ehip_rx_ehip_fr_clk.aib_ehip_rx_ehip_fr_clk
		.aib_ehip_rx_fec_fr_clk({LANES4{o_fec_dist_fr_rx_clk}}),	//in.4b		aib_ehip_rx_fec_fr_clk.aib_ehip_rx_fec_fr_clk
		.aib_ehip_tx_ehip_clk({LANES4{o_ehip_clk}}),			//in.4b		aib_ehip_tx_ehip_clk.aib_ehip_tx_ehip_clk
		.pma_ehip_rx_ehip_clk_div2({4{o_ehip_clk}}), 			//
		.pma_ehip_tx_ehip_clk_div2({4{o_ehip_clk}}), 			//

		.RSFEC_ehip_clock(o_ehip_clk),					//in, 402mhz ==> connect wrong
		.pmaRsfec_ehip_tx_ehip_data(core_tx_data),			//in
		.pmaRsfec_ehip_tx_ehip_dv(core_tx_data_valid),			//in
		.pmaRsfec_ehip_tx_ehip_fifo_rst_n(core_tx_data_am_valid),	//in
		.pmaRsfec_ehip_tx_ehip_data_am_valid_in(core_tx_data_am_valid),	//input,   width = 1
		.ehip_pmaRsfec_fec_rx_data(core_rx_data),			//out
		.ehip_pmaRsfec_fec_rx_data_valid(core_rx_data_valid),		//out
		.ehip_pmaRsfec_fec_rx_data_am_valid(core_rx_data_am_valid),	//out

		.pma_ehip_rx_ehip_fifo_rst_n({LANES4{h2a_rx_ehip_rst_n}}),	//in.4b

		.rx_aib_reset(i_rx_aib_reset),					//in.4b
		.tx_aib_reset(i_tx_aib_reset),					//in.4b
		.rx_pmaif_reset(i_rx_pmaif_reset),				//in.4b
		.tx_pmaif_reset(i_tx_pmaif_reset),				//in.4b
		.enh_reset(4'hf),						//in.4b
		.rx_enh_reset(4'hf),						//in.4b
		.tx_enh_reset(4'hf),						//in.4b

		.ehip_pma_tx_pma_clk(xcvr_fr_tx_clk[LANES4-1:0]),           	//out,4b
		.rx_clkout(rx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
		.tx_clkout(tx_clkout[MAX_XCVR_CH-1:0]),						//out,4b
		.rx_clkout2(rx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
		.tx_clkout2(tx_clkout2[MAX_XCVR_CH-1:0]),					//out,4b
		.ehip_aib_tx_transfer_div2_clk({tmp_clk3, tmp_clk2, tmp_clk1, ehip_clk}), //out,4b

		.rx_serial_data(i_rx_serial_data[3:0]),	 			//in, 4b
		.rx_serial_data_n(),			 			//in, 4b
		.tx_serial_data(o_tx_serial_data[3:0]),				//out,4b
		.tx_serial_data_n(),						//out,4b
		.rx_parallel_data(rx_parallel_data[LANES4*80-1:0]),		//out,320b
		.tx_parallel_data(tx_parallel_data_r[LANES4*80-1:0]),		//in, 320b

		.ehip_aib_aib_status(a2h_hip_aib_status), 			//out.12b
		.aib_ehip_rx_sync_data(ehip_aib_sync_data_in[LANES4*78-1:0]),	//in,312b
		.hip_aib_fsr_in(hip_aib_fsr_in[LANES4*4-1:0]),
		.hip_aib_ssr_in(hip_aib_ssr_in[LANES4*40-1:0]),
		.ehip_aib_tx_sync_data(ehip_aib_sync_data_out[LANES4*78-1:0]),	//out.312b

		.enh_pld_ready({{(4-SL_LANES){1'b0}},i_sl_ehip_pld_ready}),	//in,4b
		.rx_pma_ready(rx_pma_ready[LANES4-1:0]),			//out,4b
		.tx_pma_ready(tx_pma_ready[LANES4-1:0]),			//out,4b
		.rx_is_lockedtodata(rx_is_lockedtodata[LANES4-1:0]),		//out,4b
		.rx_transfer_ready(o_rx_transfer_ready[LANES4-1:0]),		//out,4b
		.tx_transfer_ready(o_tx_transfer_ready[LANES4-1:0]),		//out,4b

		.elane_ehip_shared_clk                      (elane_ehip_shared_clk[LANES-1:0]),			//in, width = 2,
		.elane_ehip_ptp_mac_tx_fp                   (elane_ehip_ptp_mac_tx_fp[LANES4*2-1:0]),		//in, width = 8,
		.elane_ehip_ptp_mac_ts                      (elane_ehip_ptp_mac_ts[LANES4*24-1:0]),     	//  in, width = 96,
		.elane_ehip_ptp_mac_ins_type                (elane_ehip_ptp_mac_ins_type[LANES4*3-1:0]),	//  in, width = 12,
		.elane_ehip_ptp_mac_byte_offset             (elane_ehip_ptp_mac_byte_offset[LANES4*3-1:0]),	//  in, width = 12,
		.elane_ehip_ptp_deskewed_tx_fp              (elane_ehip_ptp_deskewed_tx_fp[LANES4*2-1:0]),	//  in, width = 8,
		.elane_ehip_ptp_deskewed_ts                 (elane_ehip_ptp_deskewed_ts[LANES4*24-1:0]),  	//  in, width = 96,
		.elane_ehip_ptp_deskewed_ins_type           (elane_ehip_ptp_deskewed_ins_type[LANES4*3-1:0]),	//  in, width = 12,
		.elane_ehip_ptp_deskewed_byte_offset        (elane_ehip_ptp_deskewed_byte_offset[LANES4*3-1:0]),//  in,width = 12,
		.elane_ehip_ptp_lane_deskew_got_marker      (elane_ehip_ptp_lane_deskew_got_marker[LANES4*1-1:0]),      //  in,    width = 4,
		.elane_ehip_ptp_lane_deskew_tap_sel_one_hot (elane_ehip_ptp_lane_deskew_tap_sel_one_hot[LANES4*6-1:0]), //  in,   width = 24,
		.elane_ehip_ptp_lane_deskew_deskew_marker   (elane_ehip_ptp_lane_deskew_deskew_marker[LANES4*1-1:0]),   //  in,    width = 4,
		.ehip_elane_rx_ptp_ts                       (ehip_elane_rx_ptp_ts[LANES4*23-1:0]),     		//   out,   width = 92,
		.ehip_elane_ptp_tx_ts                       (ehip_elane_ptp_tx_ts[LANES4*12-1:0]),        	//   out,   width = 48,
		.ehip_elane_ptp_tx_ts_fp                    (ehip_elane_ptp_tx_ts_fp[LANES4*2-1:0]),      	//   out,    width = 8,
		.ehip_elane_ptp_tx_ts_valid                 (ehip_elane_ptp_tx_ts_valid[LANES4*1-1:0]),   	//   out,    width = 4,
		.ehip_elane_ptp_fifo_share_rd_en            (ehip_elane_ptp_fifo_share_rd_en[LANES4*1-1:0]),	//   out,    width = 4,
		.ehip_elane_ptp_fifo_share_wr_en            (ehip_elane_ptp_fifo_share_wr_en[LANES4*1-1:0]),	//   out,    width = 4,
		.ehip_elane_am_detect                       (ehip_elane_am_detect[LANES4*1-1:0]),           	//   out,    width = 4,
		.ehip_elane_am_insert                       (ehip_elane_am_insert[LANES4*1-1:0]),           	//   out,    width = 4,
		.ehip_elane_shared_dsk_done                 (ehip_elane_shared_dsk_done[LANES4*1-1:0]),     	//   out,    width = 4,
		.ehip_elane_shared_clear                    (ehip_elane_shared_clear[LANES4*1-1:0]),        	//   out,    width = 4,
		.enh_clear_internal_error		    (4'b0),				//in, width =4,
		.enh_force_rcfg_reset			    (4'hf),				//in, width =4,
		.enh_initialized                            (), 				//output,    width = 4,
		.enh_internal_error                         (),                    		//  output,    width = 4,
		.osc_transfer_en                            (),                         			//  output,    width = 4,
		.rx_enh_aligned                             (),                        //  output,    width = 4,
		.rx_enh_blk_lock                            (),                 		//  output,    width = 4,
		.rx_enh_highber                             (),                  			//  output,    width = 4,
		.rx_enh_local_fault                         (),              		//  output,    width = 4,
		.rx_enh_pause                               (),                    		//  output,    width = 4,
		.rx_enh_pfc                                 (),                      		//  output,   width = 32,
		.rx_enh_pmaif_fifo_overflow                 (),            		//  output,    width = 4,
		.rx_enh_remote_fault                        (),                  	//  output,    width = 4,
		.rx_enh_reset_stat                          (),                     	//  output,    width = 4,
		.rx_enh_signal_ok                           (4'b0),                      	//   input,    width = 4,
		.rx_fifo_ready                              (o_rx_fifo_ready),                         		//  output,    width = 4,
		.tx_dll_lock                                (o_tx_dll_lock[LANES4*1-1:0]),            		//  output,    width = 4,
		.tx_enh_pause                               (4'b0),                         		//   input,   width = 4,
		.tx_enh_pfc                                 (32'b0),                         		//   input,   width = 8,
		.tx_enh_pmaif_fifo_almost_empty             (),				//  output,    width = 4,
		.tx_enh_pmaif_fifo_almost_full              (),				//  output,    width = 4,
		.tx_enh_pmaif_fifo_overflow                 (),			//  output,    width = 4,
		.tx_enh_pmaif_fifo_underflow                (),			//  output,    width = 4,
		.tx_fifo_ready                              (o_tx_fifo_ready),					//  output,    width = 4,

		// Reconfig Interface
		.reconfig_clk({LANES4{i_xcvr_reconfig_clk}}),				//in,4b
		.reconfig_reset({LANES4{i_xcvr_reconfig_reset}}),			//in,4b
		.reconfig_write(i_xcvr_reconfig_write[LANES4-1:0]),			//in,4b
		.reconfig_read(i_xcvr_reconfig_read[LANES4-1:0]),			//in,4b
		.reconfig_address(i_xcvr_reconfig_address[LANES4*19-1:0]),		//in,80b
		.reconfig_writedata(i_xcvr_reconfig_writedata[LANES4*8-1:0]),		//in,128b
		.reconfig_readdata(o_xcvr_reconfig_readdata[LANES4*8-1:0]),		//out,128b
		.reconfig_waitrequest(o_xcvr_reconfig_waitrequest[LANES4-1:0])		//out,4b
		);

end // E100GX4_FEC_PTP
   endgenerate
//=============================================================================
//========= new add -- pld adaptor
//=============================================================================
generate
  if ( (core_variant == 2) ||
      ((core_variant == 3) && (active_channel == 1)) ||
      ((core_variant == 3) && (active_channel == 0) && (ENABLE_PTP != 0))
     ) begin : EHIP_CORE_PLD_ADAPT
     `ifndef FAKE_ADAPT_BYPASS_EN_TMP // bypass fake pld adapt

     ct1_hssi_ehip_core_pld_adapt
            #(
            .silicon_rev                       (silicon_rev                       )
            ) c3_pld_adapt_inst
		(
		// Input Ports
		.avmmclk( pll_avmm_clk ),
		.i_clear_internal_err( i_ehip_clear_internal_err ),	//from phy_csr => adapt(aib)
		.i_pld_ready( i_ehip_pld_ready ),			//from phy_csr => adapt(aib)
		.i_rst_n( i_ehip_rst_n ),				//from phy_csr => adapt(aib)
		.i_rx_rst_n( i_ehip_rx_rst_n),				//from phy_csr => adapt(aib)
		.i_signal_ok( i_ehip_signal_ok ),			//from phy_csr => adapt(aib)
		.i_tx_rst_n( i_ehip_tx_rst_n ),				//from phy_csr => adapt(aib)
		.int_o_cfg_load_done( h2a_cfg_load_done ),		//from ehip=>adapt(aib)
		.int_o_hi_ber( h2a_hi_ber ),				//from ehip=>adapt(aib)
		.int_o_hip_ready( h2a_hip_ready),			//from ehip=>adapt(aib)
		.int_o_local_fault( h2a_local_fault ),			//from ehip=>adapt(aib)
		.int_o_remote_fault( h2a_remote_fault ),		//from ehip=>adapt(aib)
		.int_o_rst_n( h2a_ehip_rst_n ),				//??
		.int_o_rx_am_lock( h2a_rx_am_lock ),			//from ehip=>adapt(aib)
		.int_o_rx_block_lock( h2a_rx_block_lock ),		//from ehip=>adapt(aib)
		.int_o_rx_dsk_done( h2a_rx_dsk_done ),			//from ehip=>adapt(aib)
		.int_o_rx_pcs_fully_aligned( h2a_rx_pcs_fully_aligned ),//from ehip=>adapt(aib)
		.int_o_rx_rst_n( h2a_rx_ehip_rst_n ),			//from ehip=>adapt(aib)
		.int_o_tx_rst_n( h2a_tx_ehip_rst_n ),			//from ehip=>adapt(aib)
		.i_user_avmm_rst_n(1'b1),			//a2h, phy_csr=> adapt(aib) => ehip. connect to ehip

		// Output Ports
		.int_i_clear_internal_err(a2h_clear_internal_err),		//a2h, phy_csr=> adapt(aib) => ehip. connect to ehip
		.int_i_pld_ready( a2h_pld_ready ),			//a2h, phy_csr=> adapt(aib) => ehip. connect to ehip
		.int_i_rst_n( a2h_rst_n  ),			//a2h, phy_csr=> adapt(aib) => ehip. connect to ehip
		.int_i_rx_rst_n( a2h_rx_rst_n ),			//a2h, phy_csr=> adapt(aib) => ehip. connect to ehip
		.int_i_signal_ok( a2h_signal_ok ),			//a2h, phy_csr=> adapt(aib) => ehip. connect to ehip
		.int_i_tx_rst_n( a2h_tx_rst_n ),			//a2h, phy_csr=> adapt(aib) => ehip. connect to ehip
		.int_i_user_avmm_rst_n( i_user_avmm_rst_n ),		//a2h, phy_csr=> adapt(aib) => ehip. connect to ehip

		.o_cfg_load_done( o_ehip_cfg_load_done ),			//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_hi_ber( o_ehip_rx_hi_ber ),					//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_hip_ready( o_ehip_ready ),					//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_local_fault( o_ehip_rx_local_fault ),			//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_remote_fault( o_ehip_rx_remote_fault ),			//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_rst_n( o_ehip_rst_ack_n ),    						//? need to check. portname != signal name
		.o_rx_am_lock( o_ehip_rx_am_lock ),				//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_rx_block_lock( o_ehip_rx_block_lock ),			//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_rx_dsk_done( o_ehip_rx_dsk_done ),				//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_rx_pcs_fully_aligned( o_ehip_rx_pcs_fully_aligned ),		//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_rx_rst_n( o_ehip_rx_rst_ack_n ),		//output to top(h2a, from ehip => adapt(aib)=> top )
		.o_tx_rst_n( o_ehip_tx_rst_ack_n )		//output to top(h2a, from ehip => adapt(aib)=> top )

		);
     `else

        assign  a2h_clear_internal_err		=   i_ehip_clear_internal_err;
        assign  a2h_pld_ready			=   i_ehip_pld_ready;
        assign  a2h_rst_n				=   i_ehip_rst_n;
        assign  a2h_rx_rst_n				=   i_ehip_rx_rst_n;
        assign  a2h_signal_ok			=   i_ehip_signal_ok;
        assign  a2h_tx_rst_n				=   i_ehip_tx_rst_n;
        assign  o_ehip_cfg_load_done			=   h2a_cfg_load_done;
        assign  o_ehip_rx_hi_ber			=   h2a_hi_ber;
        assign  o_ehip_ready				=   h2a_hip_ready;
        assign  o_ehip_rx_local_fault		=   h2a_local_fault;
        assign  o_ehip_rx_remote_fault               =   h2a_remote_fault;
        assign  o_ehip_rst_ack_n			=   h2a_ehip_rst_n; //?
        assign  o_ehip_rx_am_lock			=   h2a_rx_am_lock;
        assign  o_ehip_rx_block_lock			=   h2a_rx_block_lock;
        assign  o_ehip_rx_dsk_done			=   h2a_rx_dsk_done;
        assign  o_ehip_rx_pcs_fully_aligned		=   h2a_rx_pcs_fully_aligned;
        assign  o_ehip_tx_rst_ack_n			=   h2a_tx_ehip_rst_n; // h2a=> in_aibhssi
        assign  o_ehip_rx_rst_ack_n			=   h2a_rx_ehip_rst_n;
     `endif
  end
  else begin
     assign o_ehip_ready = 1'b0;
     assign o_ehip_rx_rst_ack_n = 1'b0;
  end
endgenerate

endmodule // alt_ehipc3_fm_hard
