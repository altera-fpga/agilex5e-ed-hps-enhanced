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


`timescale 1 ps/1 ps

(* altera_attribute = "-name UNCONNECTED_OUTPUT_PORT_MESSAGE_LEVEL OFF" *)

module eth_100g_cvl_nrz_xcvrnphy_fme_411_isub23q
import altera_xcvr_native_s10_functions_h::*;
  #(
	/*TODO - Added*/ parameter device_revision	= "14nm5cr3a",	// NOVAL
	/*TODO - Added*/ parameter l_pma_func_mode	= "disabled",	// NOVAL
	/*TODO - Added*/ parameter pldif_tx_fast_pipeln_reg_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter pldif_rx_fast_pipeln_reg_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter pldif_tx_coreclkin_clock_network	= "dedicated",	// "dedicated:Dedicated Clock" "rowclk:Global Clock"
	/*TODO - Added*/ parameter rcfg_shared  = 0,	                               // (0,1)
	/*TODO - Added*/ parameter adme_prot_mode	= "basic_tx",
	/*TODO - Added*/ parameter adme_data_rate	= "5000000000",
	/*TODO - Added*/ parameter rcfg_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter rcfg_jtag_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter rcfg_separate_avmm_busy	= 0,	// NOVAL
	/*TODO - Added*/ parameter dbg_embedded_debug_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter dbg_capability_reg_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter dbg_user_identifier	= 0,	// NOVAL
	/*TODO - Added*/ parameter dbg_stat_soft_logic_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter dbg_ctrl_soft_logic_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter rcfg_emb_strm_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter rcfg_profile_cnt	= 2,	//  1 2 3 4 5 6 7 8
	/*TODO - Added*/ parameter silicon_revision	= "14nm5cr3a",	// NOVAL
	/*TODO - Added*/ parameter l_xcvr_native_mode	= "mode_duplex",	// NOVAL
	/*TODO - Added*/ parameter l_channels	= 1,	// NOVAL
	/*TODO - Added*/ parameter l_enable_direct_reset_control	= 0,	// NOVAL
	/*TODO - Added*/ parameter enable_port_tx_clkin2	= 0,	// NOVAL
	/*TODO - Added*/ parameter pldif_tx_coreclkin2_clock_network	= "dedicated",	// "dedicated:Dedicated Clock" "rowclk:Global Clock"
	/*TODO - Added*/ parameter pldif_rx_coreclkin_clock_network	= "dedicated",	// "dedicated:Dedicated Clock" "rowclk:Global Clock"
	/*TODO - Added*/ parameter pma_rx_dedicated_refclk_select	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_pma_rx_dedicated_refclk_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_tx_deskew	= "tx_dsk_dis",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_powermode_ac_serdes_rx	= "ac_rx_serdes_off",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_powermode_ac_serdes_tx	= "ac_tx_serdes_off",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_cfg_hw_mode_sel	= "hwdec_elane_1ch_1",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_tx_post1	= "dis_tx_post1_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_tx_pre1	= "dis_tx_pre1_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_tx_slew	= "dis_tx_slew_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_serdes_en_seq	= "dis_serdes_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_set_int_seq_serd_en	= "seq_dis_all",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_tx_clk_out_sel	= "tx_clk_out_sel_0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_rx_ml_sel	= "rx_ml_sel_0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_tx_dskew_ml_sel	= "ml_dsk_sel_ck_above_ck_below",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_func_mode	= "c3adpt_ehip",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_bitwidth	= "dis_bitwidth_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_crc	= "dis_crc_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_rx_bitrate	= "dis_rx_bitrate_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_tx_amp	= "dis_tx_amp_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_tx_atten	= "dis_tx_atten_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_tx_bitrate	= "dis_tx_bitrate_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_seq_en_tx_broadcast	= "dis_tx_broadcast_seq",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_rx_adapter_sel	= "rx_adapter_sel_data_reg",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_interrupt_window_enable	= "dis_window_logic",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_tx_ml_sel	= "tx_ml_sel_0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_en_tx_deskew	= "dis_tx_deskew",	// NOVAL
	/*TODO - Added*/ parameter reset_separation_ns	= 200,	// NOVAL
	/*TODO - Added*/ parameter space_ns	= 100,	// NOVAL
	/*TODO - Added*/ parameter reduced_sim_time	= 1,	// NOVAL
	/*TODO - Added*/ parameter reduced_reset_sim_time	= 0,	// NOVAL
	/*TODO - Added*/ parameter enable_ind_txrx	= 0,	// NOVAL
	/*TODO - Added*/ parameter enable_seq	= 0,	// NOVAL
	/*TODO - Added*/ parameter t_tx_reset	= 100,	// NOVAL
	/*TODO - Added*/ parameter t_rx_reset	= 100,	// NOVAL
	/*TODO - Added*/ parameter l_enable_ind_channel	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_tx_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_rx_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_rsfec_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter enable_manual_reset	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_num_channels	= 1,	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_int_seq3_refclk_sync_master	= "refclk_sync_master",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_set_refclk_sel	= "i_refclk0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz	= "0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz	= "0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz	= "0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz	= "0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_powermode_dc_serdes_tx	= "0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_xcvr_powermode_dc_serdes_rx	= "0",	// NOVAL
	/*TODO - Added*/ parameter l_hssi_rsfec_is_ehip_mode	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_hssi_rsfec_avmm2_func_mode	= "c3adpt_rsfec",	//  "c3adpt_disable" "c3adpt_rsfec"
	/*TODO - Added*/ parameter l_rcfg_ifaces	= 1,	// NOVAL
	/*TODO - Added*/ parameter l_is_for_ptp_channels	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_pma_ical_enable	= 1,	// NOVAL
	/*TODO - Added*/ parameter l_pma_ical_poweron_enable	= 1,	// NOVAL
	/*TODO - Added*/ parameter rcp_load_enable	= 0,	// NOVAL
        /*TODO - Added*/ parameter pldif_rx_double_width_transfer_enable	= 0,	// NOVAL
        /*TODO - Added*/ parameter deskew_pma_only_enable	= 0,	// NOVAL
	/*TODO - Added*/ parameter enable_deskew_ini	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_pma_txrx_pll_refclk0_div_en	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_pma_txrx_pll_refclk1_div_en	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_pma_txrx_pll_refclk2_div_en	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_pma_txrx_pll_refclk3_div_en	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_pma_txrx_pll_refclk4_div_en	= 0,	// NOVAL


	// FM workaround - needs to be done through gen_terp eventually
	parameter hssi_pldadapt_tx_powermode_dc                                = "powerup" ,
	parameter hssi_pldadapt_rx_powermode_dc                                = "powerup" ,
	parameter hssi_aibnd_rx_aib_ber_margining_ctrl                         = "aib_ber_margining_setting0" ,
	parameter hssi_adapt_rx_c3aibadapt_aib_hssi_rx_sr_clk_in_hz            = 0 ,
	parameter hssi_adapt_tx_c3aibadapt_aib_hssi_tx_sr_clk_in_hz            = 0 ,
	parameter hssi_pldadapt_rx_hdpldadapt_aib_fabric_rx_sr_clk_in_hz       = 0 ,
	parameter hssi_pldadapt_tx_hdpldadapt_aib_fabric_tx_sr_clk_in_hz       = 0 ,

	/*TODO - Added*/ parameter l_hssi_rsfec_pldadapt_avmm_clk_scg_en	= "disable",	// "disable" "enable"
	/*TODO - Added*/ parameter l_hssi_rsfec_hssiadapt_avmm_clk_scg_en	= "disable",	// "disable" "enable"
	/*TODO - Added*/ parameter l_hssi_rsfec_hssiadapt_osc_clk_scg_en	= "disable",	// "disable" "enable"
	/*TODO - Added*/ parameter l_hssi_rsfec_pldadapt_osc_clk_scg_en	= "disable",	// "disable" "enable"
	/*TODO - Added*/ parameter l_hssi_rsfec_hssiadapt_avmm_clk_dcg_en	= "disable",	// "disable" "enable"
	/*TODO - Added*/ parameter l_hssi_rsfec_is_elane_mode	= 0,	// NOVAL
	/*TODO - Added*/ parameter l_hssi_rsfec_is_direct_fec_mode	= 0,	// NOVAL
	/*TODO - Added*/ parameter enable_pma_reset	= 0,	// NOVAL
	/*TODO - Added*/ parameter enable_spico_reset	= 0,	// NOVAL

	/*TODO - Added*/ parameter bti_channels_hssi_xcvr_bti_protected	= 0,	// NOVAL
	/*TODO - Added*/ parameter bti_hssi_xcvr_tx_data_rate_bps	= "2500",	// NOVAL
	/*TODO - Added*/ parameter bti_hssi_xcvr_rx_data_rate_bps	= "2500",	// NOVAL
	/*TODO - Added*/ parameter bti_use_tx_refclk	= 1,	// NOVAL
	/*TODO - Added*/ parameter bti_hssi_xcvr_cfg_rb_dcc_byp	= "dcc_byp_en",	// NOVAL
	/*TODO - Added*/ parameter bti_hssi_xcvr_cfg_rb_dcc_en	= "dcc_mast_dis",	// NOVAL
	/*TODO - Added*/ parameter bti_hssi_xcvr_int_seq3_tx_refclk_ratio	= "5",	// NOVAL
	/*TODO - Added*/ parameter bti_hssi_xcvr_int_seq4_rx_refclk_ratio	= "5",	// NOVAL
	/*TODO - Added*/ parameter bti_powermode_ac_serdes_tx_par_freq_hz	= "2500",	// NOVAL
	/*TODO - Added*/ parameter bti_powermode_ac_serdes_rx_par_freq_hz	= "2500",	// NOVAL
	/*TODO - Added*/ parameter bti_hssi_xcvr_passed_phony_tx_data_rate_bps	= "2500000000",	// NOVAL
	/*TODO - Added*/ parameter bti_hssi_xcvr_passed_phony_tx_data_rate_mbps	= "2500",	// NOVAL
	                 parameter bti_hssi_xcvr_powermode_ac_serdes_tx = "ac_tx_serdes_on",
	                 parameter bti_hssi_xcvr_powermode_ac_serdes_rx = "ac_rx_serdes_on",
                         parameter bti_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz = "2500000000",
                         parameter bti_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz = "2500000000",
                         parameter bti_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz = "78125000",
                         parameter bti_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz = "78125000",

	                 parameter bti_hssi_xcvr_powermode_dc_serdes_tx = "dc_tx_serdes_on",
	                 parameter bti_hssi_xcvr_powermode_dc_serdes_rx = "dc_rx_serdes_on",

	/*TODO - Added*/ parameter hssi_ehip_lane_enable_serialliteiv = "false",
			 parameter hssi_aibnd_rx_powermode_freq_hz_aib_hssi_rx_transfer_clk = 31'd0,
			 parameter hssi_aibnd_tx_powermode_freq_hz_aib_hssi_tx_transfer_clk = 31'd0,
			 parameter hssi_pldadapt_rx_powermode_freq_hz_aib_fabric_rx_sr_clk_in = 31'd0,
			 parameter hssi_pldadapt_rx_powermode_freq_hz_pld_rx_clk1_dcm = 31'd0,
			 parameter hssi_pldadapt_tx_powermode_freq_hz_aib_fabric_rx_sr_clk_in = 31'd0,
			 parameter hssi_pldadapt_tx_powermode_freq_hz_pld_tx_clk1_dcm = 31'd0,
			 parameter hssi_aibnd_tx_aib_hssi_tx_transfer_clk_hz = 31'd0,
			 parameter hssi_pldadapt_rx_is_paired_with = "other",
			 parameter hssi_pldadapt_tx_is_paired_with = "other",

			 parameter bti_channels_hssi_xcvr_bti_ref_clock_sel = "i_refclk0",
			 parameter bti_channels_hssi_xcvr_bti_ref_clock_freq_mhz = "100",
			 parameter bti_channels_hssi_xcvr_bti_ref_clock_freq_hz = "100000000",
			 parameter DR_NRZ_PAM4 = 0,
	parameter          hssi_adapt_rx_adapter_lpbk_mode                                    = "loopback_disabled"                                                            ,//"loopback_1x_mode" "loopback_2x_mode" "loopback_disabled" "loopback_pre_fifo"
	parameter          hssi_adapt_rx_aib_lpbk_mode                                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_async_direct_hip_en                                  = "disable"                                                                      ,//"disable" "enable"
	parameter [30:0]   hssi_adapt_rx_c3aibadapt_aib_hssi_pld_sclk_hz                      = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_rx_c3aibadapt_aib_hssi_rx_transfer_clk_hz               = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_rx_c3aibadapt_csr_clk_hz                                = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_rx_c3aibadapt_hip_aib_clk_2x_hz                         = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_rx_c3aibadapt_icm                                       = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_rx_c3aibadapt_pld_pcs_rx_clk_out_hz                     = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_rx_c3aibadapt_pld_pma_hclk_hz                           = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_rx_c3aibadapt_pma_aib_rx_clk_hz                         = 31'd0                                                                          ,//0:2147483647
	parameter          hssi_adapt_rx_c3aibadapt_powermode_ac_avmm1                        = "avmm1_off"                                                                    ,//"avmm1_off" "avmm1_on"
	parameter          hssi_adapt_rx_c3aibadapt_powermode_ac_avmm2                        = "avmm2_off"                                                                    ,//"avmm2_off" "avmm2_on"
	parameter          hssi_adapt_rx_c3aibadapt_powermode_ac_rx_datapath                  = "rx_datapath_off"                                                              ,//"rx_datapath_hip_full_fifo" "rx_datapath_hip_half_fifo" "rx_datapath_off" "rx_datapath_pmadir"
	parameter          hssi_adapt_rx_c3aibadapt_powermode_ac_sr                           = "sr_off"                                                                       ,//"sr_hip" "sr_off" "sr_pmadir"
	parameter          hssi_adapt_rx_c3aibadapt_powermode_dc                              = "powerdown_dc"                                                                 ,//"powerdown_dc" "powerup_dc"
	parameter          hssi_adapt_rx_c3aibadapt_speed_grade                               = "dash_1"                                                                       ,//"dash_1" "dash_2" "dash_3"
	parameter          hssi_adapt_rx_clock_del_measure_enable                             = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_datapath_mapping_mode                                = "map_rx_pmadir_mode"                                                           ,//"map_rx_ehip_mode" "map_rx_elane_mode" "map_rx_pmadir_mode" "map_rx_rsfec_mode"
	parameter          hssi_adapt_rx_fifo_double_write                                    = "fifo_double_write_dis"                                                        ,//"fifo_double_write_dis" "fifo_double_write_en"
	parameter          hssi_adapt_rx_fifo_mode                                            = "bypass"                                                                       ,//"bypass" "phase_comp"
	parameter          hssi_adapt_rx_fifo_rd_clk_scg_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_fifo_rd_clk_sel                                      = "fifo_rd_rx_ehip_frd_clk"                                                      ,//"fifo_rd_rx_ehip_frd_clk" "fifo_rd_rx_pma_clk" "fifo_rd_rx_rsfec_frd_clk" "fifo_rd_tx_pma_clk" "fifo_rd_tx_transfer_clk"
	parameter          hssi_adapt_rx_fifo_stop_rd                                         = "n_rd_empty"                                                                   ,//"n_rd_empty" "rd_empty"
	parameter          hssi_adapt_rx_fifo_stop_wr                                         = "n_wr_full"                                                                    ,//"n_wr_full" "wr_full"
	parameter          hssi_adapt_rx_fifo_width                                           = "fifo_single_width"                                                            ,//"fifo_double_width" "fifo_single_width"
	parameter          hssi_adapt_rx_fifo_wr_clk_scg_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_fifo_wr_clk_sel                                      = "fifo_wr_ehip_rx_clk"                                                          ,//"fifo_wr_ehip_rx_clk" "fifo_wr_rx_elane_clk" "fifo_wr_rx_pmadiv2_clk" "fifo_wr_rx_rsfec_clk" "fifo_wr_tx_transfer_clk" "fifo_wr_tx_transfer_div2_clk"
	parameter          hssi_adapt_rx_free_run_div_clk                                     = "out_of_reset_sync"                                                            ,//"out_of_reset_async" "out_of_reset_sync"
	parameter          hssi_adapt_rx_fsr_pld_8g_sigdet_out_rst_val                        = "reset_to_zero_sigdet"                                                         ,//"reset_to_one_sigdet" "reset_to_zero_sigdet"
	parameter          hssi_adapt_rx_fsr_pld_10g_rx_crc32_err_rst_val                     = "reset_to_zero_crc32"                                                          ,//"reset_to_one_crc32" "reset_to_zero_crc32"
	parameter          hssi_adapt_rx_fsr_pld_ltd_b_rst_val                                = "reset_to_zero_ltdb"                                                           ,//"reset_to_one_ltdb" "reset_to_zero_ltdb"
	parameter          hssi_adapt_rx_fsr_pld_ltr_rst_val                                  = "reset_to_zero_ltr"                                                            ,//"reset_to_one_ltr" "reset_to_zero_ltr"
	parameter          hssi_adapt_rx_fsr_pld_rx_fifo_align_clr_rst_val                    = "reset_to_zero_alignclr"                                                       ,//"reset_to_one_alignclr" "reset_to_zero_alignclr"
	parameter          hssi_adapt_rx_func_mode                                            = "c3adpt_ehip"                                                                  ,//"c3adpt_disable" "c3adpt_ehip" "c3adpt_elane_pcs_rc" "c3adpt_pmadir" "c3adpt_rsfec"
	parameter          hssi_adapt_rx_hrdrst_dcd_cal_done_bypass                           = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_hrdrst_rst_sm_dis                                    = "enable_rx_rst_sm"                                                             ,//"disable_rx_rst_sm" "enable_rx_rst_sm"
	parameter          hssi_adapt_rx_hrdrst_rx_osc_clk_scg_en                             = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_hrdrst_user_ctl_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_internal_clk1_sel                                    = "feedthru_clk0_clk1"                                                           ,//"avmm1_dcg_clk_clk1" "avmm1_scg_clk_clk1" "feedthru_clk0_clk1" "feedthru_clk1_clk1" "feedthru_clk2_clk1" "feedthru_clk3_clk1" "feedthru_clk4_clk1" "feedthru_clk5_clk1" "fpll_shared_direct_async_in_clk1" "gate_0_clk1" "gate_1_clk1" "sr_tx_osc_clkdiv2_clk1" "sr_tx_osc_clk_or_clkdiv_clk1"
	parameter          hssi_adapt_rx_internal_clk1_sel0                                   = "feedthru_clks_or_txfifowr_post_ct_or_txfiford_pre_or_post_ct_mux_clk1_mux0"   ,//"feedthru_clks_or_txfifowr_post_ct_or_txfiford_pre_or_post_ct_mux_clk1_mux0" "txfifowr_from_aib_mux_clk1_mux0"
	parameter          hssi_adapt_rx_internal_clk1_sel1                                   = "feedthru_clks_or_txfiford_pre_or_post_ct_mux_clk1_mux1"                       ,//"feedthru_clks_or_txfiford_pre_or_post_ct_mux_clk1_mux1" "txfifowr_post_ct_mux_clk1_mux1"
	parameter          hssi_adapt_rx_internal_clk1_sel2                                   = "pma_clks_or_txfiford_pre_ct_mux_clk1_mux2"                                    ,//"pma_clks_or_txfiford_pre_ct_mux_clk1_mux2" "txfiford_post_ct_mux_clk1_mux2"
	parameter          hssi_adapt_rx_internal_clk1_sel3                                   = "pma_clks_clk1_mux3"                                                           ,//"pma_clks_clk1_mux3" "txfiford_pre_ct_mux_clk1_mux3"
	parameter          hssi_adapt_rx_internal_clk2_sel                                    = "feedthru_clk0_clk2"                                                           ,//"feedthru_clk0_clk2" "feedthru_clk1_clk2"
	parameter          hssi_adapt_rx_internal_clk2_sel0                                   = "pma_clks_or_rxfiford_post_ct_or_rxfifowr_pre_or_post_ct_mux_clk2_mux0"        ,//"pma_clks_or_rxfiford_post_ct_or_rxfifowr_pre_or_post_ct_mux_clk2_mux0" "rxfiford_to_aib_mux_clk2_mux0"
	parameter          hssi_adapt_rx_internal_clk2_sel1                                   = "pma_clks_or_rxfifowr_pre_or_post_ct_mux_clk2_mux1"                            ,//"pma_clks_or_rxfifowr_pre_or_post_ct_mux_clk2_mux1" "rxfiford_post_ct_mux_clk2_mux1"
	parameter          hssi_adapt_rx_internal_clk2_sel2                                   = "pma_clks_or_rxfifowr_pre_ct_mux_clk2_mux2"                                    ,//"pma_clks_or_rxfifowr_pre_ct_mux_clk2_mux2" "rxfifowr_post_ct_mux_clk2_mux2"
	parameter          hssi_adapt_rx_internal_clk2_sel3                                   = "pma_clks_clk2_mux3"                                                           ,//"pma_clks_clk2_mux3" "rxfifowr_pre_ct_mux_clk2_mux3"
	parameter          hssi_adapt_rx_loopback_mode                                        = "loopback_disable"                                                             ,//"adpt_dfx_loopback_enable" "adpt_func_loopback_enable" "aib_loopback_enable" "loopback_disable"
	parameter          hssi_adapt_rx_msb_pipeline_byp                                     = "msb_pipe_byp_disable"                                                         ,//"msb_pipe_byp_disable" "msb_pipe_byp_enable"
	parameter          hssi_adapt_rx_osc_clk_scg_en                                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_phcomp_rd_del                                        = "phcomp_rd_del2"                                                               ,//"phcomp_rd_del2" "phcomp_rd_del3" "phcomp_rd_del4" "phcomp_rd_del5" "phcomp_rd_del6"
	parameter          hssi_adapt_rx_pma_aib_rx_clk_expected_setting                      = "not_used"                                                                     ,//"dynamic" "not_used" "x1" "x2"
	parameter          hssi_adapt_rx_pma_coreclkin_sel                                    = "pma_coreclkin_osc_clkdiv2_sel"                                                ,//"pma_coreclkin_osc_clkdiv2_sel" "pma_coreclkin_pld_sel"
	parameter          hssi_adapt_rx_powerdown_mode                                       = "powerdown"                                                                    ,//"powerdown" "powerup"
	parameter          hssi_adapt_rx_rx_10g_krfec_rx_diag_data_status_polling_bypass      = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_datapath_tb_sel                                   = "aib_dcc_dll_tb"                                                               ,//"aib_dcc_dll_tb" "avmm_tb" "hard_reset_tb" "pcs_chnl_tb" "rx_fifo_tb1" "rx_fifo_tb2" "tx_chnl_tb"
	parameter          hssi_adapt_rx_rx_fifo_power_mode                                   = "full_width_full_depth"                                                        ,//"full_width_full_depth" "full_width_half_depth" "half_width_full_depth" "half_width_half_depth"
	parameter          hssi_adapt_rx_rx_fifo_read_latency_adjust                          = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_fifo_write_latency_adjust                         = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_osc_clock_setting                                 = "osc_clk_div_by1"                                                              ,//"osc_clk_div_by1" "osc_clk_div_by2" "osc_clk_div_by4"
	parameter          hssi_adapt_rx_rx_parity_sel                                        = "func_sel"                                                                     ,//"func_sel" "sr_parity1_sel" "sr_parity2_sel"
	parameter          hssi_adapt_rx_rx_pcs_testbus_sel                                   = "direct_tr_tb_bit0_sel"                                                        ,//"direct_tr_tb_bit0_sel" "direct_tr_tb_bit1_sel" "direct_tr_tb_bit2_sel" "direct_tr_tb_bit3_sel" "direct_tr_tb_bit4_sel" "direct_tr_tb_bit5_sel" "direct_tr_tb_bit6_sel" "direct_tr_tb_bit7_sel"
	parameter          hssi_adapt_rx_rx_pcspma_testbus_sel                                = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_pld_8g_a1a2_k1k2_flag_polling_bypass              = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_pld_8g_wa_boundary_polling_bypass                 = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_pld_pma_pcie_sw_done_polling_bypass               = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_pld_pma_reser_in_polling_bypass                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_pld_pma_testbus_polling_bypass                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_pld_test_data_polling_bypass                      = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_rmfflag_stretch_enable                            = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_adapt_rx_rx_rmfflag_stretch_num_stages                        = "rmfflag_zero_stage"                                                           ,//"rmfflag_one_stage" "rmfflag_three_stage" "rmfflag_two_stage" "rmfflag_zero_stage"
	parameter          hssi_adapt_rx_rx_usertest_sel                                      = "direct_tr_usertest3_sel"                                                      ,//"direct_tr_usertest0_sel" "direct_tr_usertest1_sel" "direct_tr_usertest2_sel" "direct_tr_usertest3_sel"
	parameter          hssi_adapt_rx_rxfifo_empty                                         = "empty_default"                                                                ,//"empty_default"
	parameter          hssi_adapt_rx_rxfifo_full                                          = "full_sw"                                                                      ,//"full_dw" "full_sw"
	parameter          hssi_adapt_rx_rxfifo_mode                                          = "rxbypass_mode"                                                                ,//"rxbypass_mode" "rxphase_comp"
	parameter [4:0]    hssi_adapt_rx_rxfifo_pempty                                        = 5'd2                                                                           ,//0:31
	parameter [4:0]    hssi_adapt_rx_rxfifo_pfull                                         = 5'd24                                                                          ,//0:31
	parameter          hssi_adapt_rx_rxfiford_post_ct_sel                                 = "rxfiford_sclk_post_ct"                                                        ,//"rxfiford_post_ct" "rxfiford_sclk_post_ct"
	parameter          hssi_adapt_rx_rxfiford_to_aib_sel                                  = "rxfiford_sclk_to_aib"                                                         ,//"rxfiford_sclk_to_aib" "rxfiford_to_aib"
	parameter          hssi_adapt_rx_rxfifowr_post_ct_sel                                 = "rxfifowr_sclk_post_ct"                                                        ,//"rxfifowr_post_ct" "rxfifowr_sclk_post_ct"
	parameter          hssi_adapt_rx_rxfifowr_pre_ct_sel                                  = "rxfifowr_sclk_pre_ct"                                                         ,//"rxfifowr_pre_ct" "rxfifowr_sclk_pre_ct"
	parameter          hssi_adapt_rx_silicon_rev                                          = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_adapt_rx_stretch_num_stages                                   = "zero_stage"                                                                   ,//"five_stage" "four_stage" "one_stage" "seven_stage" "six_stage" "three_stage" "two_stage" "zero_stage"
	parameter          hssi_adapt_rx_sup_mode                                             = "user_mode"                                                                    ,//"advanced_user_mode" "engineering_mode" "user_mode"
	parameter          hssi_adapt_rx_topology                                             = "disabled_block"                                                               ,//"dirfec_100g" "dirfec_1ch" "dirfec_2ch" "dirfec_3ch" "dirfec_4ch" "dir_kpfec_100g" "disabled_block" "disabled_system" "ehip_2ch" "ehip_2ch_ptp" "ehip_4ch" "ehip_4ch_fec" "ehip_4ch_kpfec" "ehip_4ch_ptp" "ehip_4ch_ptp_fec" "elane_1ch" "elane_1ch_fec" "elane_1ch_ptp" "elane_1ch_ptp_fec" "elane_2ch_fec" "elane_2ch_ptp" "elane_2ch_ptp_fec" "elane_3ch_fec" "elane_3ch_ptp" "elane_3ch_ptp_fec" "elane_4ch_fec" "elane_4ch_ptp" "elane_4ch_ptp_fec" "pcs_gearbox_ch" "pmadir_1ch" "pmadir_2ch" "pmadir_pllch" "pmadir_refclkch" "ptp_pllch" "rsvd_topo1" "rsvd_topo2" "rsvd_topo3" "rsvd_topo4" "rsvd_topo5"
	parameter          hssi_adapt_rx_txfiford_post_ct_sel                                 = "txfiford_sclk_post_ct"                                                        ,//"txfiford_post_ct" "txfiford_sclk_post_ct"
	parameter          hssi_adapt_rx_txfiford_pre_ct_sel                                  = "txfiford_sclk_pre_ct"                                                         ,//"txfiford_pre_ct" "txfiford_sclk_pre_ct"
	parameter          hssi_adapt_rx_txfifowr_from_aib_sel                                = "txfifowr_sclk_from_aib"                                                       ,//"txfifowr_from_aib" "txfifowr_sclk_from_aib"
	parameter          hssi_adapt_rx_txfifowr_post_ct_sel                                 = "txfifowr_sclk_post_ct"                                                        ,//"txfifowr_post_ct" "txfifowr_sclk_post_ct"
	parameter          hssi_adapt_rx_word_align_enable                                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_rx_word_mark                                            = "wm_en"                                                                        ,//"wm_dis" "wm_en"
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_aib_hssi_pld_sclk_hz                      = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_aib_hssi_tx_transfer_clk_hz               = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_csr_clk_hz                                = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_hip_aib_clk_2x_hz                         = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_hip_aib_txeq_clk_out_hz                   = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_icm                                       = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_pld_pcs_tx_clk_out_hz                     = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_pld_pma_hclk_hz                           = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_adapt_tx_c3aibadapt_pma_aib_tx_clk_hz                         = 31'd0                                                                          ,//0:2147483647
	parameter          hssi_adapt_tx_c3aibadapt_powermode_ac_avmm1                        = "avmm1_off"                                                                    ,//"avmm1_off" "avmm1_on"
	parameter          hssi_adapt_tx_c3aibadapt_powermode_ac_avmm2                        = "avmm2_off"                                                                    ,//"avmm2_off" "avmm2_on"
	parameter          hssi_adapt_tx_c3aibadapt_powermode_ac_sr                           = "sr_off"                                                                       ,//"sr_hip" "sr_off" "sr_pmadir"
	parameter          hssi_adapt_tx_c3aibadapt_powermode_ac_tx_datapath                  = "tx_datapath_off"                                                              ,//"tx_datapath_hip_full_fifo" "tx_datapath_hip_half_fifo" "tx_datapath_off" "tx_datapath_pmadir"
	parameter          hssi_adapt_tx_c3aibadapt_powermode_dc                              = "powerdown_dc"                                                                 ,//"powerdown_dc" "powerup_dc"
	parameter          hssi_adapt_tx_c3aibadapt_speed_grade                               = "dash_1"                                                                       ,//"dash_1" "dash_2" "dash_3"
	parameter          hssi_adapt_tx_datapath_mapping_mode                                = "map_tx_pmadir"                                                                ,//"map_tx_dis" "map_tx_ehip" "map_tx_elane" "map_tx_pmadir" "map_tx_rsfec"
	parameter          hssi_adapt_tx_duplex_mode                                          = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_dv_gating                                            = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_fifo_double_read                                     = "fifo_double_read_dis"                                                         ,//"fifo_double_read_dis" "fifo_double_read_en"
	parameter          hssi_adapt_tx_fifo_mode                                            = "phase_comp"                                                                   ,//"bypass" "phase_comp"
	parameter          hssi_adapt_tx_fifo_rd_clk_scg_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_fifo_rd_clk_sel                                      = "fifo_rd_transfer_div2_clk"                                                    ,//"fifo_rd_ehip_tx_clk" "fifo_rd_elane_tx_clk" "fifo_rd_rsfec_tx_clk" "fifo_rd_transfer_div2_clk"
	parameter          hssi_adapt_tx_fifo_stop_rd                                         = "n_rd_empty"                                                                   ,//"n_rd_empty" "rd_empty"
	parameter          hssi_adapt_tx_fifo_stop_wr                                         = "n_wr_full"                                                                    ,//"n_wr_full" "wr_full"
	parameter          hssi_adapt_tx_fifo_width                                           = "fifo_single_width"                                                            ,//"fifo_double_width" "fifo_single_width"
	parameter          hssi_adapt_tx_fifo_wr_clk_scg_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_free_run_div_clk                                     = "out_of_reset_sync"                                                            ,//"out_of_reset_async" "out_of_reset_sync"
	parameter          hssi_adapt_tx_fsr_hip_fsr_in_bit0_rst_val                          = "reset_to_zero_hfsrin0"                                                        ,//"reset_to_one_hfsrin0" "reset_to_zero_hfsrin0"
	parameter          hssi_adapt_tx_fsr_hip_fsr_in_bit1_rst_val                          = "reset_to_zero_hfsrin1"                                                        ,//"reset_to_one_hfsrin1" "reset_to_zero_hfsrin1"
	parameter          hssi_adapt_tx_fsr_hip_fsr_in_bit2_rst_val                          = "reset_to_zero_hfsrin2"                                                        ,//"reset_to_one_hfsrin2" "reset_to_zero_hfsrin2"
	parameter          hssi_adapt_tx_fsr_hip_fsr_in_bit3_rst_val                          = "reset_to_zero_hfsrin3"                                                        ,//"reset_to_one_hfsrin3" "reset_to_zero_hfsrin3"
	parameter          hssi_adapt_tx_fsr_hip_fsr_out_bit0_rst_val                         = "reset_to_zero_hfsrout0"                                                       ,//"reset_to_one_hfsrout0" "reset_to_zero_hfsrout0"
	parameter          hssi_adapt_tx_fsr_hip_fsr_out_bit1_rst_val                         = "reset_to_zero_hfsrout1"                                                       ,//"reset_to_one_hfsrout1" "reset_to_zero_hfsrout1"
	parameter          hssi_adapt_tx_fsr_hip_fsr_out_bit2_rst_val                         = "reset_to_zero_hfsrout2"                                                       ,//"reset_to_one_hfsrout2" "reset_to_zero_hfsrout2"
	parameter          hssi_adapt_tx_fsr_hip_fsr_out_bit3_rst_val                         = "reset_to_zero_hfsrout3"                                                       ,//"reset_to_one_hfsrout3" "reset_to_zero_hfsrout3"
	parameter          hssi_adapt_tx_fsr_mask_tx_pll_rst_val                              = "reset_to_zero_maskpll"                                                        ,//"reset_to_one_maskpll" "reset_to_zero_maskpll"
	parameter          hssi_adapt_tx_fsr_pld_txelecidle_rst_val                           = "reset_to_zero_txelec"                                                         ,//"reset_to_one_txelec" "reset_to_zero_txelec"
	parameter          hssi_adapt_tx_func_mode                                            = "c3adpt_ehip"                                                                  ,//"c3adpt_disable" "c3adpt_ehip" "c3adpt_elane_pcs_rc" "c3adpt_pmadir" "c3adpt_rsfec"
	parameter          hssi_adapt_tx_hip_osc_clk_scg_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_hrdrst_align_bypass                                  = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_hrdrst_dcd_cal_done_bypass                           = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_hrdrst_dll_lock_bypass                               = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_hrdrst_rst_sm_dis                                    = "enable_tx_rst_sm"                                                             ,//"disable_tx_rst_sm" "enable_tx_rst_sm"
	parameter          hssi_adapt_tx_hrdrst_rx_osc_clk_scg_en                             = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_hrdrst_user_ctl_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_loopback_mode                                        = "loopback_disable"                                                             ,//"adpt_dfx_loopback_enable" "adpt_func_loopback_enable" "aib_loopback_enable" "loopback_disable"
	parameter          hssi_adapt_tx_osc_clk_scg_en                                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_phcomp_rd_del                                        = "phcomp_rd_del2"                                                               ,//"phcomp_rd_del2" "phcomp_rd_del3" "phcomp_rd_del4" "phcomp_rd_del5" "phcomp_rd_del6"
	parameter          hssi_adapt_tx_powerdown_mode                                       = "powerdown"                                                                    ,//"powerdown" "powerup"
	parameter          hssi_adapt_tx_silicon_rev                                          = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_adapt_tx_stretch_num_stages                                   = "zero_stage"                                                                   ,//"five_stage" "four_stage" "one_stage" "seven_stage" "six_stage" "three_stage" "two_stage" "zero_stage"
	parameter          hssi_adapt_tx_sup_mode                                             = "user_mode"                                                                    ,//"advanced_user_mode" "engineering_mode" "user_mode"
	parameter          hssi_adapt_tx_topology                                             = "disabled_block"                                                               ,//"dirfec_100g" "dirfec_1ch" "dirfec_2ch" "dirfec_3ch" "dirfec_4ch" "dir_kpfec_100g" "disabled_block" "disabled_system" "ehip_2ch" "ehip_2ch_ptp" "ehip_4ch" "ehip_4ch_fec" "ehip_4ch_kpfec" "ehip_4ch_ptp" "ehip_4ch_ptp_fec" "elane_1ch" "elane_1ch_fec" "elane_1ch_ptp" "elane_1ch_ptp_fec" "elane_2ch_fec" "elane_2ch_ptp" "elane_2ch_ptp_fec" "elane_3ch_fec" "elane_3ch_ptp" "elane_3ch_ptp_fec" "elane_4ch_fec" "elane_4ch_ptp" "elane_4ch_ptp_fec" "pcs_gearbox_ch" "pmadir_1ch" "pmadir_2ch" "pmadir_pllch" "pmadir_refclkch" "ptp_pllch" "rsvd_topo1" "rsvd_topo2" "rsvd_topo3" "rsvd_topo4" "rsvd_topo5"
	parameter          hssi_adapt_tx_tx_datapath_tb_sel                                   = "cp_bond"                                                                      ,//"cp_bond" "hard_reset_tb" "tx_fifo_tb1" "tx_fifo_tb2" "wa"
	parameter          hssi_adapt_tx_tx_fifo_power_mode                                   = "full_width_full_depth"                                                        ,//"full_width_full_depth" "full_width_half_depth" "half_width_full_depth" "half_width_half_depth"
	parameter          hssi_adapt_tx_tx_fifo_read_latency_adjust                          = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_tx_fifo_write_latency_adjust                         = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_tx_osc_clock_setting                                 = "osc_clk_div_by1"                                                              ,//"osc_clk_div_by1" "osc_clk_div_by2" "osc_clk_div_by4"
	parameter          hssi_adapt_tx_tx_rev_lpbk                                          = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_adapt_tx_tx_usertest_sel                                      = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_adapt_tx_txfifo_empty                                         = "empty_default"                                                                ,//"empty_default"
	parameter          hssi_adapt_tx_txfifo_full                                          = "full_sw"                                                                      ,//"full_dw" "full_sw"
	parameter [4:0]    hssi_adapt_tx_txfifo_pempty                                        = 5'd2                                                                           ,//0:31
	parameter [4:0]    hssi_adapt_tx_txfifo_pfull                                         = 5'd24                                                                          ,//0:31
	parameter          hssi_adapt_tx_word_align                                           = "wa_dis"                                                                       ,//"wa_dis" "wa_en"
	parameter          hssi_adapt_tx_word_align_enable                                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_aib_ssm_silicon_rev                                           = "14nm5"                                                                        ,//"10nmacr2ea" "10nmacr2eb" "14nm2acr2ea" "14nm1acr2eb" "14nm0acr2eb" "14nm2acr2eb" "14nm4acr2" "14nm4acr2b" "14nm4acr2ea" "14nm4acr2eb" "14nm4pacr2ea" "14nm4pacr2eb" "14nm5" "14nm5bcr2b" "14nm5bcr2ea" "14nm5bcr2eb" "14nm5cr2" "14nm7cr2b"
	parameter          hssi_aibcr_rx_aib_datasel_gr0                                      = "aib_datasel0_setting0"                                                        ,//"aib_datasel0_setting0"
	parameter          hssi_aibcr_rx_aib_datasel_gr1                                      = "aib_datasel1_setting0"                                                        ,//"aib_datasel1_setting0"
	parameter          hssi_aibcr_rx_aib_datasel_gr2                                      = "aib_datasel2_setting1"                                                        ,//"aib_datasel2_setting1"
	parameter          hssi_aibcr_rx_aib_ddrctrl_gr0                                      = "aib_ddr0_setting1"                                                            ,//"aib_ddr0_setting0" "aib_ddr0_setting1"
	parameter          hssi_aibcr_rx_aib_ddrctrl_gr1                                      = "aib_ddr1_setting1"                                                            ,//"aib_ddr1_setting0" "aib_ddr1_setting1"
	parameter          hssi_aibcr_rx_aib_iinasyncen                                       = "aib_inasyncen_setting2"                                                       ,//"aib_inasyncen_setting0" "aib_inasyncen_setting2"
	parameter          hssi_aibcr_rx_aib_iinclken                                         = "aib_inclken_setting3"                                                         ,//"aib_inclken_setting0" "aib_inclken_setting3"
	parameter          hssi_aibcr_rx_aib_outctrl_gr0                                      = "aib_outen0_setting1"                                                          ,//"aib_outen0_setting0" "aib_outen0_setting1"
	parameter          hssi_aibcr_rx_aib_outctrl_gr1                                      = "aib_outen1_setting1"                                                          ,//"aib_outen1_setting0" "aib_outen1_setting1"
	parameter          hssi_aibcr_rx_aib_outctrl_gr2                                      = "aib_outen2_setting1"                                                          ,//"aib_outen2_setting0" "aib_outen2_setting1"
	parameter          hssi_aibcr_rx_aib_outctrl_gr3                                      = "aib_outen3_setting1"                                                          ,//"aib_outen3_setting0" "aib_outen3_setting1"
	parameter          hssi_aibcr_rx_aib_outndrv_r12                                      = "aib_ndrv12_setting1"                                                          ,//"aib_ndrv12_setting0" "aib_ndrv12_setting1" "aib_ndrv12_setting2" "aib_ndrv12_setting3"
	parameter          hssi_aibcr_rx_aib_outndrv_r56                                      = "aib_ndrv56_setting1"                                                          ,//"aib_ndrv56_setting0" "aib_ndrv56_setting1" "aib_ndrv56_setting2" "aib_ndrv56_setting3"
	parameter          hssi_aibcr_rx_aib_outndrv_r78                                      = "aib_ndrv78_setting1"                                                          ,//"aib_ndrv78_setting0" "aib_ndrv78_setting1" "aib_ndrv78_setting2" "aib_ndrv78_setting3"
	parameter          hssi_aibcr_rx_aib_outpdrv_r12                                      = "aib_pdrv12_setting1"                                                          ,//"aib_pdrv12_setting0" "aib_pdrv12_setting1" "aib_pdrv12_setting2" "aib_pdrv12_setting3"
	parameter          hssi_aibcr_rx_aib_outpdrv_r56                                      = "aib_pdrv56_setting1"                                                          ,//"aib_pdrv56_setting0" "aib_pdrv56_setting1" "aib_pdrv56_setting2" "aib_pdrv56_setting3"
	parameter          hssi_aibcr_rx_aib_outpdrv_r78                                      = "aib_pdrv78_setting1"                                                          ,//"aib_pdrv78_setting0" "aib_pdrv78_setting1" "aib_pdrv78_setting2" "aib_pdrv78_setting3"
	parameter          hssi_aibcr_rx_aib_red_rx_shiften                                   = "aib_red_rx_shift_disable"                                                     ,//"aib_red_rx_shift_disable" "aib_red_rx_shift_enable"
	parameter          hssi_aibcr_rx_aib_rx_clkdiv                                        = "aib_rx_clkdiv_setting1"                                                       ,//"aib_rx_clkdiv_setting0" "aib_rx_clkdiv_setting1" "aib_rx_clkdiv_setting2" "aib_rx_clkdiv_setting3" "aib_rx_clkdiv_setting4" "aib_rx_clkdiv_setting5" "aib_rx_clkdiv_setting6" "aib_rx_clkdiv_setting7"
	parameter          hssi_aibcr_rx_aib_rx_dcc_byp                                       = "aib_rx_dcc_byp_disable"                                                       ,//"aib_rx_dcc_byp_disable" "aib_rx_dcc_byp_enable"
	parameter          hssi_aibcr_rx_aib_rx_dcc_byp_iocsr_unused                          = "aib_rx_dcc_byp_disable_iocsr_unused"                                          ,//"aib_rx_dcc_byp_disable_iocsr_unused"
	parameter          hssi_aibcr_rx_aib_rx_dcc_cont_cal                                  = "aib_rx_dcc_cal_single"                                                        ,//"aib_rx_dcc_cal_cont" "aib_rx_dcc_cal_single"
	parameter          hssi_aibcr_rx_aib_rx_dcc_cont_cal_iocsr_unused                     = "aib_rx_dcc_cal_single_iocsr_unused"                                           ,//"aib_rx_dcc_cal_single_iocsr_unused"
	parameter          hssi_aibcr_rx_aib_rx_dcc_dft                                       = "aib_rx_dcc_dft_disable"                                                       ,//"aib_rx_dcc_dft_disable"
	parameter          hssi_aibcr_rx_aib_rx_dcc_dft_sel                                   = "aib_rx_dcc_dft_mode0"                                                         ,//"aib_rx_dcc_dft_mode0" "aib_rx_dcc_dft_mode1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_dll_entest                                = "aib_rx_dcc_dll_test_disable"                                                  ,//"aib_rx_dcc_dll_test_disable" "aib_rx_dcc_dll_test_enable"
	parameter          hssi_aibcr_rx_aib_rx_dcc_dy_ctl_static                             = "aib_rx_dcc_dy_ctl_static_setting0"                                            ,//"aib_rx_dcc_dy_ctl_static_setting0" "aib_rx_dcc_dy_ctl_static_setting1" "aib_rx_dcc_dy_ctl_static_setting2"
	parameter          hssi_aibcr_rx_aib_rx_dcc_dy_ctlsel                                 = "aib_rx_dcc_dy_ctlsel_setting0"                                                ,//"aib_rx_dcc_dy_ctlsel_setting0" "aib_rx_dcc_dy_ctlsel_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_en                                        = "aib_rx_dcc_enable"                                                            ,//"aib_rx_dcc_disable" "aib_rx_dcc_enable"
	parameter          hssi_aibcr_rx_aib_rx_dcc_en_iocsr_unused                           = "aib_rx_dcc_disable_iocsr_unused"                                              ,//"aib_rx_dcc_disable_iocsr_unused"
	parameter          hssi_aibcr_rx_aib_rx_dcc_manual_dn                                 = "aib_rx_dcc_manual_dn0"                                                        ,//"aib_rx_dcc_manual_dn0"
	parameter          hssi_aibcr_rx_aib_rx_dcc_manual_up                                 = "aib_rx_dcc_manual_up0"                                                        ,//"aib_rx_dcc_manual_up0"
	parameter          hssi_aibcr_rx_aib_rx_dcc_rst_prgmnvrt                              = "aib_rx_dcc_st_rst_prgmnvrt_setting0"                                          ,//"aib_rx_dcc_st_rst_prgmnvrt_setting0" "aib_rx_dcc_st_rst_prgmnvrt_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_core_dn_prgmnvrt                       = "aib_rx_dcc_st_core_dn_prgmnvrt_setting0"                                      ,//"aib_rx_dcc_st_core_dn_prgmnvrt_setting0" "aib_rx_dcc_st_core_dn_prgmnvrt_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_core_up_prgmnvrt                       = "aib_rx_dcc_st_core_up_prgmnvrt_setting0"                                      ,//"aib_rx_dcc_st_core_up_prgmnvrt_setting0" "aib_rx_dcc_st_core_up_prgmnvrt_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_core_updnen                            = "aib_rx_dcc_st_core_updnen_setting0"                                           ,//"aib_rx_dcc_st_core_updnen_setting0" "aib_rx_dcc_st_core_updnen_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_dftmuxsel                              = "aib_rx_dcc_st_dftmuxsel_setting0"                                             ,//"aib_rx_dcc_st_dftmuxsel_setting0" "aib_rx_dcc_st_dftmuxsel_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_dly_pst                                = "aib_rx_dcc_st_dly_pst_setting0"                                               ,//"aib_rx_dcc_st_dly_pst_setting0" "aib_rx_dcc_st_dly_pst_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_en                                     = "aib_rx_dcc_st_en_setting0"                                                    ,//"aib_rx_dcc_st_en_setting0" "aib_rx_dcc_st_en_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_lockreq_muxsel                         = "aib_rx_dcc_st_lockreq_muxsel_setting0"                                        ,//"aib_rx_dcc_st_lockreq_muxsel_setting0" "aib_rx_dcc_st_lockreq_muxsel_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_new_dll                                = "aib_rx_dcc_new_dll_setting0"                                                  ,//"aib_rx_dcc_new_dll_setting0" "aib_rx_dcc_new_dll_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_new_dll2                               = "aib_rx_dcc_new_dll2_setting0"                                                 ,//"aib_rx_dcc_new_dll2_setting0" "aib_rx_dcc_new_dll2_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_st_rst                                    = "aib_rx_dcc_st_rst_setting0"                                                   ,//"aib_rx_dcc_st_rst_setting0" "aib_rx_dcc_st_rst_setting1"
	parameter          hssi_aibcr_rx_aib_rx_dcc_test_clk_pll_en_n                         = "aib_rx_dcc_test_clk_pll_en_n_disable"                                         ,//"aib_rx_dcc_test_clk_pll_en_n_disable" "aib_rx_dcc_test_clk_pll_en_n_enable"
	parameter          hssi_aibcr_rx_aib_rx_halfcode                                      = "aib_rx_halfcode_enable"                                                       ,//"aib_rx_halfcode_disable" "aib_rx_halfcode_enable"
	parameter          hssi_aibcr_rx_aib_rx_selflock                                      = "aib_rx_selflock_enable"                                                       ,//"aib_rx_selflock_disable" "aib_rx_selflock_enable"
	parameter          hssi_aibcr_rx_dft_hssitestip_dll_dcc_en                            = "disable_dft"                                                                  ,//"disable_dft" "enable_hssitestip_dcc" "enable_hssitestip_dll"
	parameter          hssi_aibcr_rx_op_mode                                              = "pwr_down"                                                                     ,//"dynamic_pwr_down" "pwr_down" "rx_dcc_disable" "rx_dcc_enable" "rx_dcc_enable_low_speed" "rx_dcc_manual" "rx_pma_fall_back"
	parameter          hssi_aibcr_rx_powermode_ac                                         = "rxdatapath_low_speed_pwr"                                                     ,//"rxdatapath_high_speed_pwr" "rxdatapath_low_speed_pwr"
	parameter          hssi_aibcr_rx_powermode_dc                                         = "powerdown_rxdatapath"                                                         ,//"powerdown_rxdatapath" "rxdatapath_powerup"
	parameter          hssi_aibcr_rx_redundancy_en                                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_aibcr_rx_rx_transfer_clk_duty_cycle                           = "rx_trsf_clk_dc_50_50"                                                         ,//"rx_trsf_clk_dc_50_50" "rx_trsf_clk_dc_60_40"
	parameter          hssi_aibcr_rx_rx_transfer_clk_freq                                 = "1"                                                                            ,//NOVAL
	parameter          hssi_aibcr_rx_rx_transfer_clk_freq_hz                              = "1"                                                                            ,//NOVAL
	parameter          hssi_aibcr_rx_silicon_rev                                          = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_aibcr_rx_sup_mode                                             = "user_mode"                                                                    ,//"engineering_mode" "user_mode"
	parameter          hssi_aibcr_tx_aib_datasel_gr0                                      = "aib_datasel0_setting0"                                                        ,//"aib_datasel0_setting0"
	parameter          hssi_aibcr_tx_aib_datasel_gr1                                      = "aib_datasel1_setting1"                                                        ,//"aib_datasel1_setting1"
	parameter          hssi_aibcr_tx_aib_datasel_gr2                                      = "aib_datasel2_setting0"                                                        ,//"aib_datasel2_setting0"
	parameter          hssi_aibcr_tx_aib_dllstr_align_clkdiv                              = "aib_dllstr_align_clkdiv_setting0"                                             ,//"aib_dllstr_align_clkdiv_setting0" "aib_dllstr_align_clkdiv_setting1" "aib_dllstr_align_clkdiv_setting2" "aib_dllstr_align_clkdiv_setting3" "aib_dllstr_align_clkdiv_setting4" "aib_dllstr_align_clkdiv_setting5" "aib_dllstr_align_clkdiv_setting6" "aib_dllstr_align_clkdiv_setting7"
	parameter          hssi_aibcr_tx_aib_dllstr_align_dcc_dll_dft_sel                     = "aib_dllstr_align_dcc_dll_dft_sel_setting0"                                    ,//"aib_dllstr_align_dcc_dll_dft_sel_setting0" "aib_dllstr_align_dcc_dll_dft_sel_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_dft_ch_muxsel                       = "aib_dllstr_align_dft_ch_muxsel_setting0"                                      ,//"aib_dllstr_align_dft_ch_muxsel_setting0" "aib_dllstr_align_dft_ch_muxsel_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_dly_pst                             = "aib_dllstr_align_dly_pst_setting0"                                            ,//"aib_dllstr_align_dly_pst_setting0" "aib_dllstr_align_dly_pst_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_dy_ctl_static                       = "aib_dllstr_align_dy_ctl_static_setting0"                                      ,//"aib_dllstr_align_dy_ctl_static_setting0" "aib_dllstr_align_dy_ctl_static_setting1" "aib_dllstr_align_dy_ctl_static_setting2"
	parameter          hssi_aibcr_tx_aib_dllstr_align_dy_ctlsel                           = "aib_dllstr_align_dy_ctlsel_setting0"                                          ,//"aib_dllstr_align_dy_ctlsel_setting0" "aib_dllstr_align_dy_ctlsel_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_entest                              = "aib_dllstr_align_test_disable"                                                ,//"aib_dllstr_align_test_disable" "aib_dllstr_align_test_enable"
	parameter          hssi_aibcr_tx_aib_dllstr_align_halfcode                            = "aib_dllstr_align_halfcode_enable"                                             ,//"aib_dllstr_align_halfcode_disable" "aib_dllstr_align_halfcode_enable"
	parameter          hssi_aibcr_tx_aib_dllstr_align_selflock                            = "aib_dllstr_align_selflock_enable"                                             ,//"aib_dllstr_align_selflock_disable" "aib_dllstr_align_selflock_enable"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_core_dn_prgmnvrt                 = "aib_dllstr_align_st_core_dn_prgmnvrt_setting0"                                ,//"aib_dllstr_align_st_core_dn_prgmnvrt_setting0" "aib_dllstr_align_st_core_dn_prgmnvrt_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_core_up_prgmnvrt                 = "aib_dllstr_align_st_core_up_prgmnvrt_setting0"                                ,//"aib_dllstr_align_st_core_up_prgmnvrt_setting0" "aib_dllstr_align_st_core_up_prgmnvrt_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_core_updnen                      = "aib_dllstr_align_st_core_updnen_setting0"                                     ,//"aib_dllstr_align_st_core_updnen_setting0" "aib_dllstr_align_st_core_updnen_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_dftmuxsel                        = "aib_dllstr_align_st_dftmuxsel_setting0"                                       ,//"aib_dllstr_align_st_dftmuxsel_setting0" "aib_dllstr_align_st_dftmuxsel_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_en                               = "aib_dllstr_align_st_en_setting0"                                              ,//"aib_dllstr_align_st_en_setting0" "aib_dllstr_align_st_en_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_lockreq_muxsel                   = "aib_dllstr_align_st_lockreq_muxsel_setting0"                                  ,//"aib_dllstr_align_st_lockreq_muxsel_setting0" "aib_dllstr_align_st_lockreq_muxsel_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_new_dll                          = "aib_dllstr_align_new_dll_setting0"                                            ,//"aib_dllstr_align_new_dll_setting0" "aib_dllstr_align_new_dll_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_new_dll2                         = "aib_dllstr_align_new_dll2_setting0"                                           ,//"aib_dllstr_align_new_dll2_setting0" "aib_dllstr_align_new_dll2_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_rst                              = "aib_dllstr_align_st_rst_setting0"                                             ,//"aib_dllstr_align_st_rst_setting0" "aib_dllstr_align_st_rst_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_st_rst_prgmnvrt                     = "aib_dllstr_align_st_rst_prgmnvrt_setting0"                                    ,//"aib_dllstr_align_st_rst_prgmnvrt_setting0" "aib_dllstr_align_st_rst_prgmnvrt_setting1"
	parameter          hssi_aibcr_tx_aib_dllstr_align_test_clk_pll_en_n                   = "aib_dllstr_align_test_clk_pll_en_n_disable"                                   ,//"aib_dllstr_align_test_clk_pll_en_n_disable" "aib_dllstr_align_test_clk_pll_en_n_enable"
	parameter          hssi_aibcr_tx_aib_inctrl_gr0                                       = "aib_inctrl0_setting0"                                                         ,//"aib_inctrl0_setting0" "aib_inctrl0_setting1" "aib_inctrl0_setting4"
	parameter          hssi_aibcr_tx_aib_inctrl_gr1                                       = "aib_inctrl1_setting0"                                                         ,//"aib_inctrl1_setting0" "aib_inctrl1_setting3"
	parameter          hssi_aibcr_tx_aib_inctrl_gr2                                       = "aib_inctrl2_setting0"                                                         ,//"aib_inctrl2_setting0" "aib_inctrl2_setting2"
	parameter          hssi_aibcr_tx_aib_inctrl_gr3                                       = "aib_inctrl3_setting0"                                                         ,//"aib_inctrl3_setting0" "aib_inctrl3_setting2"
	parameter          hssi_aibcr_tx_aib_outctrl_gr0                                      = "aib_outen0_setting0"                                                          ,//"aib_outen0_setting0" "aib_outen0_setting1"
	parameter          hssi_aibcr_tx_aib_outctrl_gr1                                      = "aib_outen1_setting0"                                                          ,//"aib_outen1_setting0" "aib_outen1_setting1"
	parameter          hssi_aibcr_tx_aib_outctrl_gr2                                      = "aib_outen2_setting0"                                                          ,//"aib_outen2_setting0" "aib_outen2_setting1"
	parameter          hssi_aibcr_tx_aib_outndrv_r12                                      = "aib_ndrv12_setting1"                                                          ,//"aib_ndrv12_setting0" "aib_ndrv12_setting1" "aib_ndrv12_setting2" "aib_ndrv12_setting3"
	parameter          hssi_aibcr_tx_aib_outndrv_r34                                      = "aib_ndrv34_setting1"                                                          ,//"aib_ndrv34_setting0" "aib_ndrv34_setting1" "aib_ndrv34_setting2" "aib_ndrv34_setting3"
	parameter          hssi_aibcr_tx_aib_outndrv_r56                                      = "aib_ndrv56_setting1"                                                          ,//"aib_ndrv56_setting0" "aib_ndrv56_setting1" "aib_ndrv56_setting2" "aib_ndrv56_setting3"
	parameter          hssi_aibcr_tx_aib_outndrv_r78                                      = "aib_ndrv78_setting1"                                                          ,//"aib_ndrv78_setting0" "aib_ndrv78_setting1" "aib_ndrv78_setting2" "aib_ndrv78_setting3"
	parameter          hssi_aibcr_tx_aib_outpdrv_r12                                      = "aib_pdrv12_setting1"                                                          ,//"aib_pdrv12_setting0" "aib_pdrv12_setting1" "aib_pdrv12_setting2" "aib_pdrv12_setting3"
	parameter          hssi_aibcr_tx_aib_outpdrv_r34                                      = "aib_pdrv34_setting1"                                                          ,//"aib_pdrv34_setting0" "aib_pdrv34_setting1" "aib_pdrv34_setting2" "aib_pdrv34_setting3"
	parameter          hssi_aibcr_tx_aib_outpdrv_r56                                      = "aib_pdrv56_setting1"                                                          ,//"aib_pdrv56_setting0" "aib_pdrv56_setting1" "aib_pdrv56_setting2" "aib_pdrv56_setting3"
	parameter          hssi_aibcr_tx_aib_outpdrv_r78                                      = "aib_pdrv78_setting1"                                                          ,//"aib_pdrv78_setting0" "aib_pdrv78_setting1" "aib_pdrv78_setting2" "aib_pdrv78_setting3"
	parameter          hssi_aibcr_tx_aib_red_dirclkn_shiften                              = "aib_red_dirclkn_shift_disable"                                                ,//"aib_red_dirclkn_shift_disable" "aib_red_dirclkn_shift_enable"
	parameter          hssi_aibcr_tx_aib_red_dirclkp_shiften                              = "aib_red_dirclkp_shift_disable"                                                ,//"aib_red_dirclkp_shift_disable" "aib_red_dirclkp_shift_enable"
	parameter          hssi_aibcr_tx_aib_red_drx_shiften                                  = "aib_red_drx_shift_disable"                                                    ,//"aib_red_drx_shift_disable" "aib_red_drx_shift_enable"
	parameter          hssi_aibcr_tx_aib_red_dtx_shiften                                  = "aib_red_dtx_shift_disable"                                                    ,//"aib_red_dtx_shift_disable" "aib_red_dtx_shift_enable"
	parameter          hssi_aibcr_tx_aib_red_pinp_shiften                                 = "aib_red_pinp_shift_disable"                                                   ,//"aib_red_pinp_shift_disable" "aib_red_pinp_shift_enable"
	parameter          hssi_aibcr_tx_aib_red_rx_shiften                                   = "aib_red_rx_shift_disable"                                                     ,//"aib_red_rx_shift_disable" "aib_red_rx_shift_enable"
	parameter          hssi_aibcr_tx_aib_red_tx_shiften                                   = "aib_red_tx_shift_disable"                                                     ,//"aib_red_tx_shift_disable" "aib_red_tx_shift_enable"
	parameter          hssi_aibcr_tx_aib_red_txferclkout_shiften                          = "aib_red_txferclkout_shift_disable"                                            ,//"aib_red_txferclkout_shift_disable" "aib_red_txferclkout_shift_enable"
	parameter          hssi_aibcr_tx_aib_red_txferclkoutn_shiften                         = "aib_red_txferclkoutn_shift_disable"                                           ,//"aib_red_txferclkoutn_shift_disable" "aib_red_txferclkoutn_shift_enable"
	parameter          hssi_aibcr_tx_dfd_dll_dcc_en                                       = "disable_dfd"                                                                  ,//"disable_dfd" "enable_dfd_dcc" "enable_dfd_dll"
	parameter          hssi_aibcr_tx_dft_hssitestip_dll_dcc_en                            = "disable_dft"                                                                  ,//"disable_dft" "enable_hssitestip_dcc" "enable_hssitestip_dll"
	parameter          hssi_aibcr_tx_op_mode                                              = "pwr_down"                                                                     ,//"dynamic_pwr_down" "pwr_down" "tx_dll_disable" "tx_dll_enable" "tx_pma_fall_back"
	parameter          hssi_aibcr_tx_powermode_ac                                         = "txdatapath_low_speed_pwr"                                                     ,//"txdatapath_high_speed_pwr" "txdatapath_low_speed_pwr"
	parameter          hssi_aibcr_tx_powermode_dc                                         = "powerdown_txdatapath"                                                         ,//"powerdown_txdatapath" "txdatapath_powerup"
	parameter          hssi_aibcr_tx_redundancy_en                                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_aibcr_tx_silicon_rev                                          = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_aibcr_tx_sup_mode                                             = "user_mode"                                                                    ,//"engineering_mode" "user_mode"
	parameter          hssi_aibcr_tx_tx_transfer_clk_freq                                 = "1"                                                                            ,//NOVAL
	parameter          hssi_aibcr_tx_tx_transfer_clk_freq_hz                              = "1"                                                                            ,//NOVAL
	parameter          hssi_aibnd_rx_aib_datasel_gr0                                      = "aib_datasel0_setting0"                                                        ,//"aib_datasel0_setting0"
	parameter          hssi_aibnd_rx_aib_datasel_gr1                                      = "aib_datasel1_setting1"                                                        ,//"aib_datasel1_setting1"
	parameter          hssi_aibnd_rx_aib_datasel_gr2                                      = "aib_datasel2_setting1"                                                        ,//"aib_datasel2_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_clkdiv                              = "aib_dllstr_align_clkdiv_setting0"                                             ,//"aib_dllstr_align_clkdiv_setting0" "aib_dllstr_align_clkdiv_setting1" "aib_dllstr_align_clkdiv_setting2" "aib_dllstr_align_clkdiv_setting3" "aib_dllstr_align_clkdiv_setting4" "aib_dllstr_align_clkdiv_setting5" "aib_dllstr_align_clkdiv_setting6" "aib_dllstr_align_clkdiv_setting7"
	parameter          hssi_aibnd_rx_aib_dllstr_align_dly_pst                             = "aib_dllstr_align_dly_pst_setting0"                                            ,//"aib_dllstr_align_dly_pst_setting0" "aib_dllstr_align_dly_pst_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_dy_ctl_static                       = "aib_dllstr_align_dy_ctl_static_setting0"                                      ,//"aib_dllstr_align_dy_ctl_static_setting0" "aib_dllstr_align_dy_ctl_static_setting1" "aib_dllstr_align_dy_ctl_static_setting2"
	parameter          hssi_aibnd_rx_aib_dllstr_align_dy_ctlsel                           = "aib_dllstr_align_dy_ctlsel_setting0"                                          ,//"aib_dllstr_align_dy_ctlsel_setting0" "aib_dllstr_align_dy_ctlsel_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_entest                              = "aib_dllstr_align_test_disable"                                                ,//"aib_dllstr_align_test_disable" "aib_dllstr_align_test_enable"
	parameter          hssi_aibnd_rx_aib_dllstr_align_halfcode                            = "aib_dllstr_align_halfcode_enable"                                             ,//"aib_dllstr_align_halfcode_disable" "aib_dllstr_align_halfcode_enable"
	parameter          hssi_aibnd_rx_aib_dllstr_align_selflock                            = "aib_dllstr_align_selflock_enable"                                             ,//"aib_dllstr_align_selflock_disable" "aib_dllstr_align_selflock_enable"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_core_dn_prgmnvrt                 = "aib_dllstr_align_st_core_dn_prgmnvrt_setting0"                                ,//"aib_dllstr_align_st_core_dn_prgmnvrt_setting0" "aib_dllstr_align_st_core_dn_prgmnvrt_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_core_up_prgmnvrt                 = "aib_dllstr_align_st_core_up_prgmnvrt_setting0"                                ,//"aib_dllstr_align_st_core_up_prgmnvrt_setting0" "aib_dllstr_align_st_core_up_prgmnvrt_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_core_updnen                      = "aib_dllstr_align_st_core_updnen_setting0"                                     ,//"aib_dllstr_align_st_core_updnen_setting0" "aib_dllstr_align_st_core_updnen_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_dftmuxsel                        = "aib_dllstr_align_st_dftmuxsel_setting0"                                       ,//"aib_dllstr_align_st_dftmuxsel_setting0" "aib_dllstr_align_st_dftmuxsel_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_en                               = "aib_dllstr_align_st_en_setting0"                                              ,//"aib_dllstr_align_st_en_setting0" "aib_dllstr_align_st_en_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_hps_ctrl_en                      = "aib_dllstr_align_hps_ctrl_en_setting0"                                        ,//"aib_dllstr_align_hps_ctrl_en_setting0" "aib_dllstr_align_hps_ctrl_en_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_lockreq_muxsel                   = "aib_dllstr_align_st_lockreq_muxsel_setting0"                                  ,//"aib_dllstr_align_st_lockreq_muxsel_setting0" "aib_dllstr_align_st_lockreq_muxsel_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_new_dll                          = "aib_dllstr_align_new_dll_setting0"                                            ,//"aib_dllstr_align_new_dll_setting0" "aib_dllstr_align_new_dll_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_rst                              = "aib_dllstr_align_st_rst_setting0"                                             ,//"aib_dllstr_align_st_rst_setting0" "aib_dllstr_align_st_rst_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_st_rst_prgmnvrt                     = "aib_dllstr_align_st_rst_prgmnvrt_setting0"                                    ,//"aib_dllstr_align_st_rst_prgmnvrt_setting0" "aib_dllstr_align_st_rst_prgmnvrt_setting1"
	parameter          hssi_aibnd_rx_aib_dllstr_align_test_clk_pll_en_n                   = "aib_dllstr_align_test_clk_pll_en_n_disable"                                   ,//"aib_dllstr_align_test_clk_pll_en_n_disable" "aib_dllstr_align_test_clk_pll_en_n_enable"
	parameter          hssi_aibnd_rx_aib_inctrl_gr0                                       = "aib_inctrl0_setting0"                                                         ,//"aib_inctrl0_setting0" "aib_inctrl0_setting1" "aib_inctrl0_setting4"
	parameter          hssi_aibnd_rx_aib_inctrl_gr1                                       = "aib_inctrl1_setting0"                                                         ,//"aib_inctrl1_setting0" "aib_inctrl1_setting3"
	parameter          hssi_aibnd_rx_aib_inctrl_gr2                                       = "aib_inctrl2_setting0"                                                         ,//"aib_inctrl2_setting0" "aib_inctrl2_setting2"
	parameter          hssi_aibnd_rx_aib_inctrl_gr3                                       = "aib_inctrl3_setting0"                                                         ,//"aib_inctrl3_setting0" "aib_inctrl3_setting3"
	parameter          hssi_aibnd_rx_aib_outctrl_gr0                                      = "aib_outen0_setting0"                                                          ,//"aib_outen0_setting0" "aib_outen0_setting1"
	parameter          hssi_aibnd_rx_aib_outctrl_gr1                                      = "aib_outen1_setting0"                                                          ,//"aib_outen1_setting0" "aib_outen1_setting1"
	parameter          hssi_aibnd_rx_aib_outctrl_gr2                                      = "aib_outen2_setting0"                                                          ,//"aib_outen2_setting0" "aib_outen2_setting1"
	parameter          hssi_aibnd_rx_aib_outndrv_r12                                      = "aib_ndrv12_setting1"                                                          ,//"aib_ndrv12_setting0" "aib_ndrv12_setting1" "aib_ndrv12_setting2" "aib_ndrv12_setting3"
	parameter          hssi_aibnd_rx_aib_outndrv_r34                                      = "aib_ndrv34_setting1"                                                          ,//"aib_ndrv34_setting0" "aib_ndrv34_setting1" "aib_ndrv34_setting2" "aib_ndrv34_setting3"
	parameter          hssi_aibnd_rx_aib_outndrv_r56                                      = "aib_ndrv56_setting1"                                                          ,//"aib_ndrv56_setting0" "aib_ndrv56_setting1" "aib_ndrv56_setting2" "aib_ndrv56_setting3"
	parameter          hssi_aibnd_rx_aib_outndrv_r78                                      = "aib_ndrv78_setting1"                                                          ,//"aib_ndrv78_setting0" "aib_ndrv78_setting1" "aib_ndrv78_setting2" "aib_ndrv78_setting3"
	parameter          hssi_aibnd_rx_aib_outpdrv_r12                                      = "aib_pdrv12_setting1"                                                          ,//"aib_pdrv12_setting0" "aib_pdrv12_setting1" "aib_pdrv12_setting2" "aib_pdrv12_setting3"
	parameter          hssi_aibnd_rx_aib_outpdrv_r34                                      = "aib_pdrv34_setting1"                                                          ,//"aib_pdrv34_setting0" "aib_pdrv34_setting1" "aib_pdrv34_setting2" "aib_pdrv34_setting3"
	parameter          hssi_aibnd_rx_aib_outpdrv_r56                                      = "aib_pdrv56_setting1"                                                          ,//"aib_pdrv56_setting0" "aib_pdrv56_setting1" "aib_pdrv56_setting2" "aib_pdrv56_setting3"
	parameter          hssi_aibnd_rx_aib_outpdrv_r78                                      = "aib_pdrv78_setting1"                                                          ,//"aib_pdrv78_setting0" "aib_pdrv78_setting1" "aib_pdrv78_setting2" "aib_pdrv78_setting3"
	parameter          hssi_aibnd_rx_aib_red_shift_en                                     = "aib_red_shift_disable"                                                        ,//"aib_red_shift_disable" "aib_red_shift_enable"
	parameter          hssi_aibnd_rx_dft_hssitestip_dll_dcc_en                            = "disable_dft"                                                                  ,//"disable_dft" "enable_hssitestip_dcc" "enable_hssitestip_dll"
	parameter          hssi_aibnd_rx_op_mode                                              = "pwr_down"                                                                     ,//"dynamic_pwr_down" "pwr_down" "rx_dll_disable" "rx_dll_enable" "rx_pma_fall_back"
	parameter          hssi_aibnd_rx_powermode_ac                                         = "rxdatapath_low_speed_pwr"                                                     ,//"rxdatapath_high_speed_pwr" "rxdatapath_low_speed_pwr"
	parameter          hssi_aibnd_rx_powermode_dc                                         = "rxdatapath_powerdown"                                                         ,//"powerdown" "powerup" "rxdatapath_powerdown" "rxdatapath_powerup"
	parameter          hssi_aibnd_rx_powerdown_mode                                       = "true"                                                         ,//"true" "false"
	parameter          hssi_aibnd_rx_redundancy_en                                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_aibnd_rx_silicon_rev                                          = "14nm5"                                                                        ,//"10nmacr2ea" "10nmacr2eb" "10nmacr3a" "14nm2acr2ea" "14nm2acr2eb" "14nm2acr3a" "14nm1acr2eb" "14nm1acr3a" "14nm0acr2eb" "14nm0acr3a" "14nm4acr2" "14nm4acr2b" "14nm4acr2ea" "14nm4acr2eb" "14nm4acr3a" "14nm4pacr2ea" "14nm4pacr2eb" "14nm4pacr3a""14nm5" "14nm5bcr2b" "14nm5bcr2ea" "14nm5bcr2eb" "14nm5bcr3a" "14nm5cr2" "14nm7cr2b"
	parameter          hssi_aibnd_rx_sup_mode                                             = "user_mode"                                                                    ,//"engineering_mode" "user_mode"
	parameter          hssi_aibnd_tx_aib_datasel_gr0                                      = "aib_datasel0_setting0"                                                        ,//"aib_datasel0_setting0"
	parameter          hssi_aibnd_tx_aib_datasel_gr1                                      = "aib_datasel1_setting0"                                                        ,//"aib_datasel1_setting0"
	parameter          hssi_aibnd_tx_aib_datasel_gr2                                      = "aib_datasel2_setting1"                                                        ,//"aib_datasel2_setting1"
	parameter          hssi_aibnd_tx_aib_datasel_gr3                                      = "aib_datasel3_setting1"                                                        ,//"aib_datasel3_setting1"
	parameter          hssi_aibnd_tx_aib_ddrctrl_gr0                                      = "aib_ddr0_setting1"                                                            ,//"aib_ddr0_setting0" "aib_ddr0_setting1"
	parameter          hssi_aibnd_tx_aib_iinasyncen                                       = "aib_inasyncen_setting0"                                                       ,//"aib_inasyncen_setting0" "aib_inasyncen_setting2"
	parameter          hssi_aibnd_tx_aib_iinclken                                         = "aib_inclken_setting0"                                                         ,//"aib_inclken_setting0" "aib_inclken_setting3"
	parameter          hssi_aibnd_tx_aib_outctrl_gr0                                      = "aib_outen0_setting0"                                                          ,//"aib_outen0_setting0" "aib_outen0_setting1"
	parameter          hssi_aibnd_tx_aib_outctrl_gr1                                      = "aib_outen1_setting0"                                                          ,//"aib_outen1_setting0" "aib_outen1_setting1"
	parameter          hssi_aibnd_tx_aib_outctrl_gr2                                      = "aib_outen2_setting0"                                                          ,//"aib_outen2_setting0" "aib_outen2_setting1"
	parameter          hssi_aibnd_tx_aib_outctrl_gr3                                      = "aib_outen3_setting0"                                                          ,//"aib_outen3_setting0" "aib_outen3_setting1"
	parameter          hssi_aibnd_tx_aib_outndrv_r34                                      = "aib_ndrv34_setting1"                                                          ,//"aib_ndrv34_setting0" "aib_ndrv34_setting1" "aib_ndrv34_setting2" "aib_ndrv34_setting3"
	parameter          hssi_aibnd_tx_aib_outndrv_r56                                      = "aib_ndrv56_setting1"                                                          ,//"aib_ndrv56_setting0" "aib_ndrv56_setting1" "aib_ndrv56_setting2" "aib_ndrv56_setting3"
	parameter          hssi_aibnd_tx_aib_outpdrv_r34                                      = "aib_pdrv34_setting1"                                                          ,//"aib_pdrv34_setting0" "aib_pdrv34_setting1" "aib_pdrv34_setting2" "aib_pdrv34_setting3"
	parameter          hssi_aibnd_tx_aib_outpdrv_r56                                      = "aib_pdrv56_setting1"                                                          ,//"aib_pdrv56_setting0" "aib_pdrv56_setting1" "aib_pdrv56_setting2" "aib_pdrv56_setting3"
	parameter          hssi_aibnd_tx_aib_red_dirclkn_shiften                              = "aib_red_dirclkn_shift_disable"                                                ,//"aib_red_dirclkn_shift_disable" "aib_red_dirclkn_shift_enable"
	parameter          hssi_aibnd_tx_aib_red_dirclkp_shiften                              = "aib_red_dirclkp_shift_disable"                                                ,//"aib_red_dirclkp_shift_disable" "aib_red_dirclkp_shift_enable"
	parameter          hssi_aibnd_tx_aib_red_drx_shiften                                  = "aib_red_drx_shift_disable"                                                    ,//"aib_red_drx_shift_disable" "aib_red_drx_shift_enable"
	parameter          hssi_aibnd_tx_aib_red_dtx_shiften                                  = "aib_red_dtx_shift_disable"                                                    ,//"aib_red_dtx_shift_disable" "aib_red_dtx_shift_enable"
	parameter          hssi_aibnd_tx_aib_red_pout_shiften                                 = "aib_red_pout_shift_disable"                                                   ,//"aib_red_pout_shift_disable" "aib_red_pout_shift_enable"
	parameter          hssi_aibnd_tx_aib_red_rx_shiften                                   = "aib_red_rx_shift_disable"                                                     ,//"aib_red_rx_shift_disable" "aib_red_rx_shift_enable"
	parameter          hssi_aibnd_tx_aib_red_tx_shiften                                   = "aib_red_tx_shift_disable"                                                     ,//"aib_red_tx_shift_disable" "aib_red_tx_shift_enable"
	parameter          hssi_aibnd_tx_aib_red_txferclkout_shiften                          = "aib_red_txferclkout_shift_disable"                                            ,//"aib_red_txferclkout_shift_disable" "aib_red_txferclkout_shift_enable"
	parameter          hssi_aibnd_tx_aib_red_txferclkoutn_shiften                         = "aib_red_txferclkoutn_shift_disable"                                           ,//"aib_red_txferclkoutn_shift_disable" "aib_red_txferclkoutn_shift_enable"
	parameter          hssi_aibnd_tx_aib_tx_clkdiv                                        = "aib_tx_clkdiv_setting1"                                                       ,//"aib_tx_clkdiv_setting0" "aib_tx_clkdiv_setting1" "aib_tx_clkdiv_setting2" "aib_tx_clkdiv_setting3" "aib_tx_clkdiv_setting4" "aib_tx_clkdiv_setting5" "aib_tx_clkdiv_setting6" "aib_tx_clkdiv_setting7"
	parameter          hssi_aibnd_tx_aib_tx_dcc_byp                                       = "aib_tx_dcc_byp_disable"                                                       ,//"aib_tx_dcc_byp_disable" "aib_tx_dcc_byp_enable"
	parameter          hssi_aibnd_tx_aib_tx_dcc_byp_iocsr_unused                          = "aib_tx_dcc_byp_disable_iocsr_unused"                                          ,//"aib_tx_dcc_byp_disable_iocsr_unused"
	parameter          hssi_aibnd_tx_aib_tx_dcc_cont_cal                                  = "aib_tx_dcc_cal_cont"                                                          ,//"aib_tx_dcc_cal_cont" "aib_tx_dcc_cal_single"
	parameter          hssi_aibnd_tx_aib_tx_dcc_cont_cal_iocsr_unused                     = "aib_tx_dcc_cal_single_iocsr_unused"                                           ,//"aib_tx_dcc_cal_single_iocsr_unused"
	parameter          hssi_aibnd_tx_aib_tx_dcc_dft                                       = "aib_tx_dcc_dft_disable"                                                       ,//"aib_tx_dcc_dft_disable"
	parameter          hssi_aibnd_tx_aib_tx_dcc_dft_sel                                   = "aib_tx_dcc_dft_mode0"                                                         ,//"aib_tx_dcc_dft_mode0" "aib_tx_dcc_dft_mode1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_dll_dft_sel                               = "aib_tx_dcc_dll_dft_sel_setting0"                                              ,//"aib_tx_dcc_dll_dft_sel_setting0" "aib_tx_dcc_dll_dft_sel_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_dll_entest                                = "aib_tx_dcc_dll_test_disable"                                                  ,//"aib_tx_dcc_dll_test_disable" "aib_tx_dcc_dll_test_enable"
	parameter          hssi_aibnd_tx_aib_tx_dcc_dy_ctl_static                             = "aib_tx_dcc_dy_ctl_static_setting0"                                            ,//"aib_tx_dcc_dy_ctl_static_setting0" "aib_tx_dcc_dy_ctl_static_setting1" "aib_tx_dcc_dy_ctl_static_setting2"
	parameter          hssi_aibnd_tx_aib_tx_dcc_dy_ctlsel                                 = "aib_tx_dcc_dy_ctlsel_setting0"                                                ,//"aib_tx_dcc_dy_ctlsel_setting0" "aib_tx_dcc_dy_ctlsel_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_en                                        = "aib_tx_dcc_enable"                                                            ,//"aib_tx_dcc_disable" "aib_tx_dcc_enable"
	parameter          hssi_aibnd_tx_aib_tx_dcc_en_iocsr_unused                           = "aib_tx_dcc_disable_iocsr_unused"                                              ,//"aib_tx_dcc_disable_iocsr_unused"
	parameter          hssi_aibnd_tx_aib_tx_dcc_manual_dn                                 = "aib_tx_dcc_manual_dn0"                                                        ,//"aib_tx_dcc_manual_dn0"
	parameter          hssi_aibnd_tx_aib_tx_dcc_manual_up                                 = "aib_tx_dcc_manual_up0"                                                        ,//"aib_tx_dcc_manual_up0"
	parameter          hssi_aibnd_tx_aib_tx_dcc_rst_prgmnvrt                              = "aib_tx_dcc_st_rst_prgmnvrt_setting0"                                          ,//"aib_tx_dcc_st_rst_prgmnvrt_setting0" "aib_tx_dcc_st_rst_prgmnvrt_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_core_dn_prgmnvrt                       = "aib_tx_dcc_st_core_dn_prgmnvrt_setting0"                                      ,//"aib_tx_dcc_st_core_dn_prgmnvrt_setting0" "aib_tx_dcc_st_core_dn_prgmnvrt_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_core_up_prgmnvrt                       = "aib_tx_dcc_st_core_up_prgmnvrt_setting0"                                      ,//"aib_tx_dcc_st_core_up_prgmnvrt_setting0" "aib_tx_dcc_st_core_up_prgmnvrt_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_core_updnen                            = "aib_tx_dcc_st_core_updnen_setting0"                                           ,//"aib_tx_dcc_st_core_updnen_setting0" "aib_tx_dcc_st_core_updnen_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_dftmuxsel                              = "aib_tx_dcc_st_dftmuxsel_setting0"                                             ,//"aib_tx_dcc_st_dftmuxsel_setting0" "aib_tx_dcc_st_dftmuxsel_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_dly_pst                                = "aib_tx_dcc_st_dly_pst_setting0"                                               ,//"aib_tx_dcc_st_dly_pst_setting0" "aib_tx_dcc_st_dly_pst_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_en                                     = "aib_tx_dcc_st_en_setting0"                                                    ,//"aib_tx_dcc_st_en_setting0" "aib_tx_dcc_st_en_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_hps_ctrl_en                            = "aib_tx_dcc_hps_ctrl_en_setting0"                                              ,//"aib_tx_dcc_hps_ctrl_en_setting0" "aib_tx_dcc_hps_ctrl_en_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_lockreq_muxsel                         = "aib_tx_dcc_st_lockreq_muxsel_setting0"                                        ,//"aib_tx_dcc_st_lockreq_muxsel_setting0" "aib_tx_dcc_st_lockreq_muxsel_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_new_dll                                = "aib_tx_dcc_new_dll_setting0"                                                  ,//"aib_tx_dcc_new_dll_setting0" "aib_tx_dcc_new_dll_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_st_rst                                    = "aib_tx_dcc_st_rst_setting0"                                                   ,//"aib_tx_dcc_st_rst_setting0" "aib_tx_dcc_st_rst_setting1"
	parameter          hssi_aibnd_tx_aib_tx_dcc_test_clk_pll_en_n                         = "aib_tx_dcc_test_clk_pll_en_n_disable"                                         ,//"aib_tx_dcc_test_clk_pll_en_n_disable" "aib_tx_dcc_test_clk_pll_en_n_enable"
	parameter          hssi_aibnd_tx_aib_tx_halfcode                                      = "aib_tx_halfcode_enable"                                                       ,//"aib_tx_halfcode_disable" "aib_tx_halfcode_enable"
	parameter          hssi_aibnd_tx_aib_tx_selflock                                      = "aib_tx_selflock_enable"                                                       ,//"aib_tx_selflock_disable" "aib_tx_selflock_enable"
	parameter          hssi_aibnd_tx_dfd_dll_dcc_en                                       = "disable_dfd"                                                                  ,//"disable_dfd" "enable_dfd_dcc" "enable_dfd_dll"
	parameter          hssi_aibnd_tx_dft_hssitestip_dll_dcc_en                            = "disable_dft"                                                                  ,//"disable_dft" "enable_hssitestip_dcc" "enable_hssitestip_dll"
	parameter          hssi_aibnd_tx_op_mode                                              = "tx_dcc_enable"                                                                ,//"dynamic_pwr_down" "pwr_down" "tx_dcc_disable" "tx_dcc_enable" "tx_dcc_enable_low_speed" "tx_dcc_manual" "tx_pma_fall_back"
	parameter          hssi_aibnd_tx_powermode_ac                                         = "txdatapath_low_speed_pwr"                                                     ,//"txdatapath_high_speed_pwr" "txdatapath_low_speed_pwr"
	parameter          hssi_aibnd_tx_powermode_dc                                         = "txdatapath_powerdown"                                                         ,//"powerdown" "powerup" "txdatapath_powerdown" "txdatapath_powerup"
	parameter          hssi_aibnd_tx_powerdown_mode                                       = "true"                                                         ,//"true" "false"
	parameter          hssi_aibnd_tx_redundancy_en                                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_aibnd_tx_silicon_rev                                          = "14nm5"                                                                        ,//"10nmacr2ea" "10nmacr2eb" "10nmacr3a" "14nm2acr2ea" "14nm2acr2eb" "14nm2acr3a" "14nm1acr2eb" "14nm1acr3a" "14nm0acr2eb" "14nm0acr3a" "14nm4acr2" "14nm4acr2b" "14nm4acr2ea" "14nm4acr2eb" "14nm4acr3a" "14nm4pacr2ea" "14nm4pacr2eb" "14nm4pacr3a" "14nm5" "14nm5bcr2b" "14nm5bcr2ea" "14nm5bcr2eb" "14nm5bcr3a" "14nm5cr2" "14nm7cr2b"
	parameter          hssi_aibnd_tx_sup_mode                                             = "user_mode"                                                                    ,//"engineering_mode" "user_mode"
	parameter          hssi_avmm1_if_calibration_type                                     = "one_time"                                                                     ,//"continuous" "one_time"
	parameter          hssi_avmm1_if_hssiadapt_avmm_osc_clock_setting                     = "osc_clk_div_by1"                                                              ,//"osc_clk_div_by1" "osc_clk_div_by2" "osc_clk_div_by4"
	parameter          hssi_avmm1_if_hssiadapt_avmm_testbus_sel                           = "avmm1_transfer_testbus"                                                       ,//"avmm1_cmn_intf_testbus" "avmm1_transfer_testbus" "avmm2_transfer_testbus" "avmm_clk_dcg_testbus"
	parameter          hssi_avmm1_if_hssiadapt_hip_mode                                   = "disable_hip"                                                                  ,//"debug_chnl" "disable_hip" "user_chnl"
	parameter          hssi_avmm1_if_hssiadapt_nfhssi_calibratio_feature_en               = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_avmm1_if_hssiadapt_read_blocking_enable                       = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_avmm1_if_hssiadapt_uc_blocking_enable                         = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_avmm1_if_pcs_arbiter_ctrl                                     = "avmm1_arbiter_uc_sel"                                                         ,//"avmm1_arbiter_pld_sel" "avmm1_arbiter_uc_sel"
	parameter          hssi_avmm1_if_pcs_cal_done                                         = "avmm1_cal_done_assert"                                                        ,//"avmm1_cal_done_assert" "avmm1_cal_done_deassert"
	parameter [4:0]    hssi_avmm1_if_pcs_cal_reserved                                     = 5'd0                                                                           ,//0:31
	parameter          hssi_avmm1_if_pcs_calibration_feature_en                           = "avmm1_pcs_calibration_dis"                                                    ,//"avmm1_pcs_calibration_dis" "avmm1_pcs_calibration_en"
	parameter          hssi_avmm1_if_pcs_hip_cal_en                                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_avmm1_if_pldadapt_avmm_osc_clock_setting                      = "osc_clk_div_by1"                                                              ,//"osc_clk_div_by1" "osc_clk_div_by2" "osc_clk_div_by4"
	parameter          hssi_avmm1_if_pldadapt_avmm_testbus_sel                            = "avmm1_transfer_testbus"                                                       ,//"avmm1_cmn_intf_testbus" "avmm1_transfer_testbus" "avmm2_transfer_testbus" "unused_testbus"
	parameter          hssi_avmm1_if_pldadapt_gate_dis                                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_avmm1_if_pldadapt_hip_mode                                    = "disable_hip"                                                                  ,//"debug_chnl" "disable_hip" "user_chnl"
	parameter          hssi_avmm1_if_pldadapt_nfhssi_calibratio_feature_en                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_avmm1_if_pldadapt_read_blocking_enable                        = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_avmm1_if_pldadapt_uc_blocking_enable                          = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_avmm1_if_silicon_rev                                          = "14nm5"                                                                        ,//"10nmacr2ea" "10nmacr2eb" "10nmacr3a" "14nm2acr2ea" "14nm2acr2eb" "14nm2acr3a" "14nm1acr2eb" "14nm1acr3a" "14nm0acr2eb" "14nm0acr3a" "14nm4acr2" "14nm4acr2b" "14nm4acr2ea" "14nm4acr2eb" "14nm4acr3a" "14nm4pacr2ea" "14nm4pacr2eb" "14nm4pacr3a" "14nm5" "14nm5bcr2b" "14nm5bcr2ea" "14nm5bcr2eb" "14nm5bcr3a" "14nm5cr2" "14nm7cr2b"
	parameter          hssi_avmm2_if_calibration_type                                     = "one_time"                                                                     ,//"continuous" "one_time"
	parameter          hssi_avmm2_if_hssiadapt_avmm_osc_clock_setting                     = "osc_clk_div_by1"                                                              ,//"osc_clk_div_by1" "osc_clk_div_by2" "osc_clk_div_by4"
	parameter          hssi_avmm2_if_hssiadapt_avmm_testbus_sel                           = "avmm1_transfer_testbus"                                                       ,//"avmm1_cmn_intf_testbus" "avmm1_transfer_testbus" "avmm2_transfer_testbus" "avmm_clk_dcg_testbus"
	parameter          hssi_avmm2_if_hssiadapt_hip_mode                                   = "disable_hip"                                                                  ,//"debug_chnl" "disable_hip" "user_chnl"
	parameter          hssi_avmm2_if_pcs_arbiter_ctrl                                     = "avmm2_arbiter_uc_sel"                                                         ,//"avmm2_arbiter_pld_sel" "avmm2_arbiter_uc_sel"
	parameter          hssi_avmm2_if_pcs_cal_done                                         = "avmm2_cal_done_assert"                                                        ,//"avmm2_cal_done_assert" "avmm2_cal_done_deassert"
	parameter [4:0]    hssi_avmm2_if_pcs_cal_reserved                                     = 5'd0                                                                           ,//0:31
	parameter          hssi_avmm2_if_pcs_calibration_feature_en                           = "avmm2_pcs_calibration_dis"                                                    ,//"avmm2_pcs_calibration_dis" "avmm2_pcs_calibration_en"
	parameter          hssi_avmm2_if_pcs_hip_cal_en                                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_avmm2_if_pldadapt_avmm_osc_clock_setting                      = "osc_clk_div_by1"                                                              ,//"osc_clk_div_by1" "osc_clk_div_by2" "osc_clk_div_by4"
	parameter          hssi_avmm2_if_pldadapt_avmm_testbus_sel                            = "avmm1_transfer_testbus"                                                       ,//"avmm1_cmn_intf_testbus" "avmm1_transfer_testbus" "avmm2_transfer_testbus" "unused_testbus"
	parameter          hssi_avmm2_if_pldadapt_gate_dis                                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_avmm2_if_pldadapt_hip_mode                                    = "disable_hip"                                                                  ,//"debug_chnl" "disable_hip" "user_chnl"
	parameter          hssi_avmm2_if_silicon_rev                                          = "14nm5"                                                                        ,//"10nmacr2ea" "10nmacr2eb" "10nmacr3a" "14nm2acr2ea" "14nm2acr2eb" "14nm2acr3a" "14nm1acr2eb" "14nm1acr3a" "14nm0acr2eb" "14nm0acr3a" "14nm4acr2" "14nm4acr2b" "14nm4acr2ea" "14nm4acr2eb" "14nm4acr3a" "14nm4pacr2ea" "14nm4pacr2eb" "14nm4pacr3a" "14nm5" "14nm5bcr2b" "14nm5bcr2ea" "14nm5bcr2eb" "14nm5bcr3a" "14nm5cr2" "14nm7cr2b"
	parameter [23:0]   hssi_ehip_lane_am_encoding40g_0                                    = 24'd9467463                                                                    ,//0:16777215
	parameter [23:0]   hssi_ehip_lane_am_encoding40g_1                                    = 24'd15779046                                                                   ,//0:16777215
	parameter [23:0]   hssi_ehip_lane_am_encoding40g_2                                    = 24'd12936603                                                                   ,//0:16777215
	parameter [23:0]   hssi_ehip_lane_am_encoding40g_3                                    = 24'd10647869                                                                   ,//0:16777215
	parameter [6:0]    hssi_ehip_lane_ber_invalid_count                                   = 7'd97                                                                          ,//0:127
	parameter [5:0]    hssi_ehip_lane_cfgonly_bypass_select                               = 6'd0                                                                           ,//0:63
	parameter          hssi_ehip_lane_check_random_idles                                  = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_crete_type                                          = "crete3"                                                                       ,//"crete2e" "crete3"
	parameter          hssi_ehip_lane_deskew_clear                                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_disable_link_fault_rf                               = "disable"                                                                      ,//"disable" "enable"
	parameter [30:0]   hssi_ehip_lane_ehip_clk_hz                                         = 31'd0                                                                          ,//0:2147483647
	parameter          hssi_ehip_lane_ehip_clk_sel                                        = "no_clock"                                                                     ,//"datapath_clock" "fec_clock" "no_clock" "shared_clock"
	parameter [2:0]    hssi_ehip_lane_ehip_dist_clk_sel                                   = 3'd0                                                                           ,//0:7
	parameter          hssi_ehip_lane_ehip_mode                                           = "ehip_disable"                                                                 ,//"ehip_bypass" "ehip_disable" "ehip_fec" "ehip_lane_ptp_only" "ehip_lb_rxfec_txfec" "ehip_lb_rxmac_txmac" "ehip_lb_rxpcs_txpcs" "ehip_lb_txaib_rxfec" "ehip_lb_txaib_rxmac" "ehip_lb_txaib_rxpcs" "ehip_lb_txfec_rxaib" "ehip_lb_txfec_rxfec" "ehip_lb_txmac_rxaib" "ehip_lb_txmac_rxmac" "ehip_lb_txmac_rxmac_ptp" "ehip_lb_txpcs_rxaib" "ehip_lb_txpcs_rxmac" "ehip_lb_txpcs_rxpcs" "ehip_lb_tx_rx" "ehip_lb_tx_rx_ptp" "ehip_mac" "ehip_mac_no_fec" "ehip_mac_ptp" "ehip_mac_ptp_no_fec" "ehip_otn" "ehip_otn_no_fec" "ehip_pcs" "ehip_pcs66" "ehip_pcs66_no_fec" "ehip_pcs_no_fec" "ehip_standby"
	parameter          hssi_ehip_lane_ehip_rate                                           = "rate_100gx4"                                                                  ,//"custom_rate_100gx4" "custom_rate_10gx1" "custom_rate_25gx1" "custom_rate_25gx1_fec" "custom_rate_40gx4" "custom_rate_50gx2" "custom_rate_50gx4" "custom_rate_cpri" "custom_rate_cpri_fec" "rate_100gx4" "rate_10gx1" "rate_10gx1_25lr" "rate_25gx1" "rate_25gx1_fec" "rate_40gx4" "rate_50gx2" "rate_50gx4"
	parameter          hssi_ehip_lane_ehip_type                                           = "multi_lane"                                                                   ,//"multi_lane" "single_lane"
	parameter          hssi_ehip_lane_enable_rx_stats_snapshot                            = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_enable_tx_stats_snapshot                            = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_enforce_max_frame_size                              = "disable"                                                                      ,//"disable" "enable"
	parameter [2:0]    hssi_ehip_lane_fec_dist_clk_sel                                    = 3'd0                                                                           ,//0:7
	parameter          hssi_ehip_lane_flow_control                                        = "none"                                                                         ,//"both" "both_no_xoff" "none" "pfc" "pfc_no_xoff" "sfc" "sfc_no_xoff"
	parameter          hssi_ehip_lane_flow_control_holdoff_mode                           = "per_queue"                                                                    ,//"no_holdoff" "per_queue" "uniform"
	parameter          hssi_ehip_lane_force_deskew_done                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_force_hip_ready                                     = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_force_link_fault_rf                                 = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_forward_rx_pause_requests                           = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_func_mode                                           = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_hi_ber_monitor                                      = "enable"                                                                       ,//"disable" "enable"
	parameter [15:0]   hssi_ehip_lane_holdoff_quanta                                      = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_ipg_removed_per_am_period                           = 16'd20                                                                         ,//0:65535
	parameter          hssi_ehip_lane_is_usr_avmm                                         = "false"                                                                        ,//"false" "true"
	parameter          hssi_ehip_lane_keep_rx_crc                                         = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_link_fault_mode                                     = "lf_off"                                                                       ,//"lf_bidir" "lf_off" "lf_unidir"
	parameter [15:0]   hssi_ehip_lane_pause_quanta                                        = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_holdoff_quanta_0                                = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_holdoff_quanta_1                                = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_holdoff_quanta_2                                = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_holdoff_quanta_3                                = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_holdoff_quanta_4                                = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_holdoff_quanta_5                                = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_holdoff_quanta_6                                = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_holdoff_quanta_7                                = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_pause_quanta_0                                  = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_pause_quanta_1                                  = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_pause_quanta_2                                  = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_pause_quanta_3                                  = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_pause_quanta_4                                  = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_pause_quanta_5                                  = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_pause_quanta_6                                  = 16'd65535                                                                      ,//0:65535
	parameter [15:0]   hssi_ehip_lane_pfc_pause_quanta_7                                  = 16'd65535                                                                      ,//0:65535
	parameter          hssi_ehip_lane_powerdown_mode                                      = "powerup"                                                                      ,//"powerdown" "powerup"
	parameter          hssi_ehip_lane_powermode_ac_mac                                    = "mac_off"                                                                      ,//"mac_off" "mac_on_1_lane_noptp" "mac_on_1_lane_ptp" "mac_on_2_lane" "mac_on_4_lane_noptp" "mac_on_4_lane_ptp"
	parameter          hssi_ehip_lane_powermode_ac_misc                                   = "misc_off"                                                                     ,//"misc_off" "misc_on"
	parameter          hssi_ehip_lane_powermode_ac_pcs                                    = "pcs_off"                                                                      ,//"pcs_off" "pcs_on_1_lane_norsfec" "pcs_on_1_lane_rsfec" "pcs_on_2_lane" "pcs_on_4_lane_norsfec" "pcs_on_4_lane_rsfec"
	parameter          hssi_ehip_lane_powermode_ac_pld                                    = "pld_off"                                                                      ,//"pld_off" "pld_on_1_lane_noptp" "pld_on_1_lane_ptp" "pld_on_2_lane" "pld_on_4_lane_noptp" "pld_on_4_lane_ptp"
	parameter          hssi_ehip_lane_powermode_dc                                        = "powerdown_dc"                                                                 ,//"powerdown_dc" "powerup_dc"
	parameter          hssi_ehip_lane_ptp_debug                                           = "0"                                                                            ,//NOVAL
	parameter          hssi_ehip_lane_ptp_timestamp_format                                = "v2"                                                                           ,//"v1" "v2"
	parameter          hssi_ehip_lane_ptp_tx_timestamp_method                             = "ptp_1step"                                                                    ,//"ptp_1step" "ptp_2step"
	parameter          hssi_ehip_lane_remove_pads                                         = "disable"                                                                      ,//"disable" "enable"
	parameter [8:0]    hssi_ehip_lane_request_tx_pause                                    = 9'd0                                                                           ,//0:511
	parameter          hssi_ehip_lane_reset_rx_stats                                      = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_reset_rx_stats_parity_error                         = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_reset_tx_stats                                      = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_reset_tx_stats_parity_error                         = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_rx_aib_dp_latency                                   = "0"                                                                            ,//NOVAL
	parameter          hssi_ehip_lane_rx_am_interval                                      = "standard_100g_am_interval"                                                    ,//"no_rx_am_interval" "sim_only_40g_am_interval" "sim_only_50g_am_interval" "sim_only_am_interval" "standard_100g_am_interval" "standard_25g_fec_am_interval" "standard_40g_am_interval" "standard_50g_am_interval" "standard_50g_fec_am_interval"
	parameter [19:0]   hssi_ehip_lane_rx_clock_period                                     = 20'd162689                                                                     ,//0:1048575
	parameter          hssi_ehip_lane_rx_datapath_soft_rst                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_rx_length_checking                                  = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_ehip_lane_rx_mac_soft_rst                                     = "disable"                                                                      ,//"disable" "enable"
	parameter [15:0]   hssi_ehip_lane_rx_max_frame_size                                   = 16'd1518                                                                       ,//0:65535
	parameter          hssi_ehip_lane_rx_pause_daddr                                      = "1652522221569"                                                                ,//NOVAL
	parameter [5:0]    hssi_ehip_lane_rx_pcs_max_skew                                     = 6'd47                                                                          ,//0:63
	parameter          hssi_ehip_lane_rx_pcs_soft_rst                                     = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_rx_preamble_passthrough                             = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_rx_ptp_dp_latency                                   = "0"                                                                            ,//NOVAL
	parameter          hssi_ehip_lane_rx_ptp_extra_latency                                = "0"                                                                            ,//NOVAL
	parameter          hssi_ehip_lane_rx_vlan_detection                                   = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_ehip_lane_rxcrc_covers_preamble                               = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_silicon_rev                                         = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_ehip_lane_sim_mode                                            = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_ehip_lane_source_address_insertion                            = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_strict_preamble_checking                            = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_strict_sfd_checking                                 = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_sup_mode                                            = "user_mode"                                                                    ,//"engineering_mode" "user_mode"
	parameter          hssi_ehip_lane_topology                                            = "disabled_block"                                                               ,//"dirfec_100g" "dirfec_1ch" "dirfec_2ch" "dirfec_3ch" "dirfec_4ch" "dir_kpfec_100g" "disabled_block" "disabled_system" "ehip_2ch" "ehip_2ch_ptp" "ehip_4ch" "ehip_4ch_fec" "ehip_4ch_kpfec" "ehip_4ch_ptp" "ehip_4ch_ptp_fec" "elane_1ch" "elane_1ch_fec" "elane_1ch_ptp" "elane_1ch_ptp_fec" "elane_2ch_fec" "elane_2ch_ptp" "elane_2ch_ptp_fec" "elane_3ch_fec" "elane_3ch_ptp" "elane_3ch_ptp_fec" "elane_4ch_fec" "elane_4ch_ptp" "elane_4ch_ptp_fec" "pcs_gearbox_ch" "pmadir_1ch" "pmadir_2ch" "pmadir_pllch" "pmadir_refclkch" "ptp_pllch" "rsvd_topo1" "rsvd_topo2" "rsvd_topo3" "rsvd_topo4" "rsvd_topo5"
	parameter          hssi_ehip_lane_tx_aib_dp_latency                                   = "0"                                                                            ,//NOVAL
	parameter          hssi_ehip_lane_tx_am_period                                        = "standard_100g_am_period"                                                      ,//"no_tx_am_period" "sim_only_100g_fec_am_period" "sim_only_25g_am_period" "sim_only_25g_fec_am_period" "sim_only_40g_am_period" "sim_only_50g_am_period" "sim_only_am_period" "standard_100g_am_period" "standard_25g_am_period" "standard_25g_fec_am_period" "standard_40g_am_period" "standard_50g_am_period" "standard_50g_fec_am_period"
	parameter [19:0]   hssi_ehip_lane_tx_clock_period                                     = 20'd162689                                                                     ,//0:1048575
	parameter          hssi_ehip_lane_tx_datapath_soft_rst                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_tx_ipg_size                                         = "ipg_12"                                                                       ,//"ipg_1" "ipg_10" "ipg_12" "ipg_8"
	parameter          hssi_ehip_lane_tx_mac_data_flow                                    = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_ehip_lane_tx_mac_soft_rst                                     = "disable"                                                                      ,//"disable" "enable"
	parameter [15:0]   hssi_ehip_lane_tx_max_frame_size                                   = 16'd1518                                                                       ,//0:65535
	parameter          hssi_ehip_lane_tx_pause_daddr                                      = "1652522221569"                                                                ,//NOVAL
	parameter          hssi_ehip_lane_tx_pause_saddr                                      = "247393538562781"                                                              ,//NOVAL
	parameter          hssi_ehip_lane_tx_pcs_soft_rst                                     = "disable"                                                                      ,//"disable" "enable"
	parameter [4:0]    hssi_ehip_lane_tx_pld_fifo_almost_full_level                       = 5'd16                                                                          ,//0:31
	parameter          hssi_ehip_lane_tx_preamble_passthrough                             = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_tx_ptp_asym_latency                                 = "0"                                                                            ,//NOVAL
	parameter          hssi_ehip_lane_tx_ptp_dp_latency                                   = "0"                                                                            ,//NOVAL
	parameter          hssi_ehip_lane_tx_ptp_extra_latency                                = "0"                                                                            ,//NOVAL
	parameter          hssi_ehip_lane_tx_vlan_detection                                   = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_ehip_lane_txcrc_covers_preamble                               = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_txmac_saddr                                         = "73588229205"                                                                  ,//NOVAL
	parameter [15:0]   hssi_ehip_lane_uniform_holdoff_quanta                              = 16'd65535                                                                      ,//0:65535
	parameter          hssi_ehip_lane_use_am_insert                                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_use_factory_settings                                = "true"                                                                         ,//"false" "true"
	parameter          hssi_ehip_lane_use_lane_ptp                                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_ehip_lane_use_testbus                                         = "disable"                                                                      ,//"disable" "enable"
	parameter [20:0]   hssi_ehip_lane_xus_timer_window                                    = 21'd201415                                                                     ,//0:2097151
	parameter          hssi_pldadapt_rx_aib_clk1_sel                                      = "aib_clk1_rx_transfer_clk"                                                     ,//"aib_clk1_pld_pcs_rx_clk_out" "aib_clk1_pld_pma_clkdiv_rx_user" "aib_clk1_rx_transfer_clk"
	parameter          hssi_pldadapt_rx_aib_clk2_sel                                      = "aib_clk2_rx_transfer_clk"                                                     ,//"aib_clk2_pld_pcs_rx_clk_out" "aib_clk2_pld_pma_clkdiv_rx_user" "aib_clk2_rx_transfer_clk"
	parameter          hssi_pldadapt_rx_asn_bypass_pma_pcie_sw_done                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_asn_en                                            = "disable"                                                                      ,//"disable" "enable"
	parameter [7:0]    hssi_pldadapt_rx_asn_wait_for_dll_reset_cnt                        = 8'd0                                                                           ,//0:255
	parameter [7:0]    hssi_pldadapt_rx_asn_wait_for_fifo_flush_cnt                       = 8'd0                                                                           ,//0:255
	parameter [7:0]    hssi_pldadapt_rx_asn_wait_for_pma_pcie_sw_done_cnt                 = 8'd0                                                                           ,//0:255
	parameter          hssi_pldadapt_rx_bonding_dft_en                                    = "dft_dis"                                                                      ,//"dft_dis" "dft_en"
	parameter          hssi_pldadapt_rx_bonding_dft_val                                   = "dft_0"                                                                        ,//"dft_0" "dft_1"
	parameter          hssi_pldadapt_rx_chnl_bonding                                      = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_clock_del_measure_enable                          = "disable"                                                                      ,//"disable" "enable"
	parameter [7:0]    hssi_pldadapt_rx_comp_cnt                                          = 8'd0                                                                           ,//0:255
	parameter          hssi_pldadapt_rx_compin_sel                                        = "compin_master"                                                                ,//"compin_default" "compin_master" "compin_slave_bot" "compin_slave_top"
	parameter          hssi_pldadapt_rx_ctrl_plane_bonding                                = "individual"                                                                   ,//"ctrl_master" "ctrl_master_bot" "ctrl_master_top" "ctrl_slave_abv" "ctrl_slave_blw" "ctrl_slave_bot" "ctrl_slave_top" "individual"
	parameter          hssi_pldadapt_rx_ds_bypass_pipeln                                  = "ds_bypass_pipeln_dis"                                                         ,//"ds_bypass_pipeln_dis" "ds_bypass_pipeln_en"
	parameter          hssi_pldadapt_rx_ds_last_chnl                                      = "ds_not_last_chnl"                                                             ,//"ds_last_chnl" "ds_not_last_chnl"
	parameter          hssi_pldadapt_rx_ds_master                                         = "ds_master_en"                                                                 ,//"ds_master_dis" "ds_master_en"
	parameter          hssi_pldadapt_rx_duplex_mode                                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_dv_mode                                           = "dv_mode_dis"                                                                  ,//"dv_mode_dis" "dv_mode_en"
	parameter          hssi_pldadapt_rx_fifo_double_read                                  = "fifo_double_read_dis"                                                         ,//"fifo_double_read_dis" "fifo_double_read_en"
	parameter          hssi_pldadapt_rx_fifo_mode                                         = "phase_comp"                                                                   ,//"clk_comp_10g" "generic_basic" "generic_interlaken" "phase_comp" "register_mode"
	parameter          hssi_pldadapt_rx_fifo_rd_clk_ins_sm_scg_en                         = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_fifo_rd_clk_scg_en                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_fifo_rd_clk_sel                                   = "fifo_rd_clk_rx_transfer_clk"                                                  ,//"fifo_rd_clk_pld_rx_clk1" "fifo_rd_clk_rx_transfer_clk" "fifo_rd_clk_tx_transfer_clk"
	parameter          hssi_pldadapt_rx_fifo_stop_rd                                      = "n_rd_empty"                                                                   ,//"n_rd_empty" "rd_empty"
	parameter          hssi_pldadapt_rx_fifo_stop_wr                                      = "n_wr_full"                                                                    ,//"n_wr_full" "wr_full"
	parameter          hssi_pldadapt_rx_fifo_width                                        = "fifo_single_width"                                                            ,//"fifo_double_width" "fifo_single_width"
	parameter          hssi_pldadapt_rx_fifo_wr_clk_del_sm_scg_en                         = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_fifo_wr_clk_scg_en                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_fifo_wr_clk_sel                                   = "fifo_wr_clk_rx_transfer_clk"                                                  ,//"fifo_wr_clk_rx_transfer_clk" "fifo_wr_clk_tx_transfer_clk"
	parameter          hssi_pldadapt_rx_free_run_div_clk                                  = "out_of_reset_sync"                                                            ,//"out_of_reset_async" "out_of_reset_sync"
	parameter          hssi_pldadapt_rx_fsr_pld_8g_sigdet_out_rst_val                     = "reset_to_zero_sigdet"                                                         ,//"reset_to_one_sigdet" "reset_to_zero_sigdet"
	parameter          hssi_pldadapt_rx_fsr_pld_10g_rx_crc32_err_rst_val                  = "reset_to_zero_crc32"                                                          ,//"reset_to_one_crc32" "reset_to_zero_crc32"
	parameter          hssi_pldadapt_rx_fsr_pld_ltd_b_rst_val                             = "reset_to_zero_ltdb"                                                           ,//"reset_to_one_ltdb" "reset_to_zero_ltdb"
	parameter          hssi_pldadapt_rx_fsr_pld_ltr_rst_val                               = "reset_to_zero_ltr"                                                            ,//"reset_to_one_ltr" "reset_to_zero_ltr"
	parameter          hssi_pldadapt_rx_fsr_pld_rx_fifo_align_clr_rst_val                 = "reset_to_zero_alignclr"                                                       ,//"reset_to_one_alignclr" "reset_to_zero_alignclr"
	parameter          hssi_pldadapt_rx_gb_rx_idwidth                                     = "idwidth_32"                                                                   ,//"idwidth_32" "idwidth_40" "idwidth_64"
	parameter          hssi_pldadapt_rx_gb_rx_odwidth                                     = "odwidth_66"                                                                   ,//"odwidth_32" "odwidth_40" "odwidth_50" "odwidth_64" "odwidth_66" "odwidth_67"
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_aib_fabric_pld_pma_hclk_hz             = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_aib_fabric_rx_transfer_clk_hz          = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_csr_clk_hz                             = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_pld_avmm1_clk_rowclk_hz                = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_pld_avmm2_clk_rowclk_hz                = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz                     = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz                  = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_pld_sclk1_rowclk_hz                    = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_rx_hdpldadapt_pld_sclk2_rowclk_hz                    = 31'd0                                                                          ,//0:2147483647
	parameter          hssi_pldadapt_rx_hdpldadapt_speed_grade                            = "dash_1"                                                                       ,//"dash_1" "dash_2" "dash_3"
	parameter          hssi_pldadapt_rx_hip_mode                                          = "disable_hip"                                                                  ,//"debug_chnl" "disable_hip" "user_chnl"
	parameter          hssi_pldadapt_rx_hrdrst_align_bypass                               = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_hrdrst_dll_lock_bypass                            = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_hrdrst_rst_sm_dis                                 = "enable_rx_rst_sm"                                                             ,//"disable_rx_rst_sm" "enable_rx_rst_sm"
	parameter          hssi_pldadapt_rx_hrdrst_rx_osc_clk_scg_en                          = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_hrdrst_user_ctl_en                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_indv                                              = "indv_en"                                                                      ,//"indv_dis" "indv_en"
	parameter          hssi_pldadapt_rx_internal_clk1_sel1                                = "pma_clks_or_txfiford_post_ct_mux_clk1_mux1"                                   ,//"pma_clks_or_txfiford_post_ct_mux_clk1_mux1" "txfifowr_post_ct_mux_clk1_mux1"
	parameter          hssi_pldadapt_rx_internal_clk1_sel2                                = "pma_clks_clk1_mux2"                                                           ,//"pma_clks_clk1_mux2" "txfiford_post_ct_mux_clk1_mux2"
	parameter          hssi_pldadapt_rx_internal_clk2_sel1                                = "pma_clks_or_rxfifowr_post_ct_mux_clk2_mux1"                                   ,//"pma_clks_or_rxfifowr_post_ct_mux_clk2_mux1" "rxfiford_post_ct_mux_clk2_mux1"
	parameter          hssi_pldadapt_rx_internal_clk2_sel2                                = "pma_clks_clk2_mux2"                                                           ,//"pma_clks_clk2_mux2" "rxfifowr_post_ct_mux_clk2_mux2"
	parameter          hssi_pldadapt_rx_loopback_mode                                     = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_low_latency_en                                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_lpbk_mode                                         = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_osc_clk_scg_en                                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_phcomp_rd_del                                     = "phcomp_rd_del2"                                                               ,//"phcomp_rd_del2" "phcomp_rd_del3" "phcomp_rd_del4" "phcomp_rd_del5" "phcomp_rd_del6"
	parameter          hssi_pldadapt_rx_pipe_enable                                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_pipe_mode                                         = "disable_pipe"                                                                 ,//"disable_pipe" "enable_g1" "enable_g2" "enable_g3"
	parameter          hssi_pldadapt_rx_pld_clk1_delay_en                                 = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_pld_clk1_delay_sel                                = "delay_path0"                                                                  ,//"delay_path0" "delay_path1" "delay_path10" "delay_path11" "delay_path12" "delay_path13" "delay_path14" "delay_path15" "delay_path2" "delay_path3" "delay_path4" "delay_path5" "delay_path6" "delay_path7" "delay_path8" "delay_path9"
	parameter          hssi_pldadapt_rx_pld_clk1_inv_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_pld_clk1_sel                                      = "pld_clk1_rowclk"                                                              ,//"pld_clk1_dcm" "pld_clk1_rowclk"
	parameter          hssi_pldadapt_rx_pma_hclk_scg_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_powerdown_mode                                    = "powerdown"                                                                    ,//"powerdown" "powerup"
	parameter          hssi_pldadapt_rx_reconfig_settings                                 = "{}"                                                                           ,//NOVAL
	parameter          hssi_pldadapt_rx_rx_datapath_tb_sel                                = "cp_bond"                                                                      ,//"asn_tb" "avmm_tb" "cp_bond" "del_sm_tb" "hard_reset_tb" "insert_sm_tb" "parity_error_tb" "pcs_chnl_tb" "rx_fifo_tb1" "rx_fifo_tb2" "sr_tb" "tx_chnl_tb" "wa"
	parameter          hssi_pldadapt_rx_rx_fastbond_rden                                  = "rden_ds_del_us_del"                                                           ,//"rden_ds_del_us_del" "rden_ds_del_us_fast" "rden_ds_fast_us_del" "rden_ds_fast_us_fast"
	parameter          hssi_pldadapt_rx_rx_fastbond_wren                                  = "wren_ds_del_us_del"                                                           ,//"wren_ds_del_us_del" "wren_ds_del_us_fast" "wren_ds_fast_us_del" "wren_ds_fast_us_fast"
	parameter          hssi_pldadapt_rx_rx_fifo_power_mode                                = "full_width_full_depth"                                                        ,//"full_width_full_depth" "full_width_ps_dw" "full_width_ps_sw" "half_width_full_depth" "half_width_ps_dw" "half_width_ps_sw"
	parameter          hssi_pldadapt_rx_rx_fifo_read_latency_adjust                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_rx_fifo_write_ctrl                                = "blklock_stops"                                                                ,//"blklock_ignore" "blklock_stops"
	parameter          hssi_pldadapt_rx_rx_fifo_write_latency_adjust                      = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_rx_osc_clock_setting                              = "osc_clk_div_by1"                                                              ,//"osc_clk_div_by1" "osc_clk_div_by2" "osc_clk_div_by4"
	parameter          hssi_pldadapt_rx_rx_pld_8g_eidleinfersel_polling_bypass            = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_rx_pld_pma_eye_monitor_polling_bypass             = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_rx_pld_pma_pcie_switch_polling_bypass             = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_rx_pld_pma_reser_out_polling_bypass               = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_rx_prbs_flags_sr_enable                           = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_rx_true_b2b                                       = "b2b"                                                                          ,//"b2b" "single"
	parameter          hssi_pldadapt_rx_rx_usertest_sel                                   = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_pldadapt_rx_rxfifo_empty                                      = "empty_sw"                                                                     ,//"empty_dw" "empty_sw"
	parameter          hssi_pldadapt_rx_rxfifo_full                                       = "full_pc_sw"                                                                   ,//"full_non_pc_dw" "full_non_pc_sw" "full_pc_dw" "full_pc_sw"
	parameter          hssi_pldadapt_rx_rxfifo_mode                                       = "rxphase_comp"                                                                 ,//"rxclk_comp_10g" "rxgeneric_basic" "rxgeneric_interlaken" "rxphase_comp" "rxregister_mode"
	parameter [5:0]    hssi_pldadapt_rx_rxfifo_pempty                                     = 6'd2                                                                           ,//0:63
	parameter [5:0]    hssi_pldadapt_rx_rxfifo_pfull                                      = 6'd48                                                                          ,//0:63
	parameter          hssi_pldadapt_rx_rxfiford_post_ct_sel                              = "rxfiford_sclk_post_ct"                                                        ,//"rxfiford_post_ct" "rxfiford_sclk_post_ct"
	parameter          hssi_pldadapt_rx_rxfifowr_post_ct_sel                              = "rxfifowr_sclk_post_ct"                                                        ,//"rxfifowr_post_ct" "rxfifowr_sclk_post_ct"
	parameter          hssi_pldadapt_rx_sclk_sel                                          = "sclk1_rowclk"                                                                 ,//"sclk1_rowclk" "sclk2_rowclk"
	parameter          hssi_pldadapt_rx_silicon_rev                                       = "14nm5"                                                                        ,//"10nmacr2ea" "10nmacr2eb" "10nmacr3a" "14nm2acr2ea" "14nm2acr2eb" "14nm2acr3a" "14nm1acr2eb" "14nm1acr3a" "14nm0acr2eb" "14nm0acr3a" "14nm4acr2" "14nm4acr2b" "14nm4acr2ea" "14nm4acr2eb" "14nm4acr3a" "14nm4pacr2ea" "14nm4pacr2eb" "14nm4pacr3a""14nm5" "14nm5bcr2b" "14nm5bcr2ea" "14nm5bcr2eb" "14nm5bcr3a" "14nm5cr2" "14nm7cr2b"
	parameter          hssi_pldadapt_rx_stretch_num_stages                                = "zero_stage"                                                                   ,//"five_stage" "four_stage" "one_stage" "six_stage" "three_stage" "two_stage" "zero_stage"
	parameter          hssi_pldadapt_rx_sup_mode                                          = "user_mode"                                                                    ,//"advanced_user_mode" "engineering_mode" "user_mode"
	parameter          hssi_pldadapt_rx_txfiford_post_ct_sel                              = "txfiford_sclk_post_ct"                                                        ,//"txfiford_post_ct" "txfiford_sclk_post_ct"
	parameter          hssi_pldadapt_rx_txfifowr_post_ct_sel                              = "txfifowr_sclk_post_ct"                                                        ,//"txfifowr_post_ct" "txfifowr_sclk_post_ct"
	parameter          hssi_pldadapt_rx_us_bypass_pipeln                                  = "us_bypass_pipeln_dis"                                                         ,//"us_bypass_pipeln_dis" "us_bypass_pipeln_en"
	parameter          hssi_pldadapt_rx_us_last_chnl                                      = "us_not_last_chnl"                                                             ,//"us_last_chnl" "us_not_last_chnl"
	parameter          hssi_pldadapt_rx_us_master                                         = "us_master_en"                                                                 ,//"us_master_dis" "us_master_en"
	parameter          hssi_pldadapt_rx_word_align                                        = "wa_en"                                                                        ,//"wa_dis" "wa_en"
	parameter          hssi_pldadapt_rx_word_align_enable                                 = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_aib_clk1_sel                                      = "aib_clk1_pld_pcs_tx_clk_out"                                                  ,//"aib_clk1_pld_pcs_tx_clk_out" "aib_clk1_pld_pma_clkdiv_tx_user" "aib_clk1_pma_aib_tx_clk"
	parameter          hssi_pldadapt_tx_aib_clk2_sel                                      = "aib_clk2_pld_pcs_tx_clk_out"                                                  ,//"aib_clk2_pld_pcs_tx_clk_out" "aib_clk2_pld_pma_clkdiv_tx_user" "aib_clk2_pma_aib_tx_clk"
	parameter          hssi_pldadapt_tx_bonding_dft_en                                    = "dft_dis"                                                                      ,//"dft_dis" "dft_en"
	parameter          hssi_pldadapt_tx_bonding_dft_val                                   = "dft_0"                                                                        ,//"dft_0" "dft_1"
	parameter          hssi_pldadapt_tx_chnl_bonding                                      = "disable"                                                                      ,//"disable" "enable"
	parameter [7:0]    hssi_pldadapt_tx_comp_cnt                                          = 8'd0                                                                           ,//0:255
	parameter          hssi_pldadapt_tx_compin_sel                                        = "compin_master"                                                                ,//"compin_default" "compin_master" "compin_slave_bot" "compin_slave_top"
	parameter          hssi_pldadapt_tx_ctrl_plane_bonding                                = "individual"                                                                   ,//"ctrl_master" "ctrl_master_bot" "ctrl_master_top" "ctrl_slave_abv" "ctrl_slave_blw" "ctrl_slave_bot" "ctrl_slave_top" "individual"
	parameter          hssi_pldadapt_tx_ds_bypass_pipeln                                  = "ds_bypass_pipeln_dis"                                                         ,//"ds_bypass_pipeln_dis" "ds_bypass_pipeln_en"
	parameter          hssi_pldadapt_tx_ds_last_chnl                                      = "ds_not_last_chnl"                                                             ,//"ds_last_chnl" "ds_not_last_chnl"
	parameter          hssi_pldadapt_tx_ds_master                                         = "ds_master_en"                                                                 ,//"ds_master_dis" "ds_master_en"
	parameter          hssi_pldadapt_tx_duplex_mode                                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_dv_bond                                           = "dv_bond_dis"                                                                  ,//"dv_bond_dis" "dv_bond_en"
	parameter          hssi_pldadapt_tx_dv_gen                                            = "dv_gen_dis"                                                                   ,//"dv_gen_dis" "dv_gen_en"
	parameter          hssi_pldadapt_tx_fifo_double_write                                 = "fifo_double_write_dis"                                                        ,//"fifo_double_write_dis" "fifo_double_write_en"
	parameter          hssi_pldadapt_tx_fifo_mode                                         = "phase_comp"                                                                   ,//"generic_basic" "generic_interlaken" "phase_comp" "register_mode"
	parameter          hssi_pldadapt_tx_fifo_rd_clk_frm_gen_scg_en                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_fifo_rd_clk_scg_en                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_fifo_rd_clk_sel                                   = "fifo_rd_pma_aib_tx_clk"                                                       ,//"fifo_rd_pld_tx_clk1" "fifo_rd_pld_tx_clk2" "fifo_rd_pma_aib_tx_clk"
	parameter          hssi_pldadapt_tx_fifo_stop_rd                                      = "n_rd_empty"                                                                   ,//"n_rd_empty" "rd_empty"
	parameter          hssi_pldadapt_tx_fifo_stop_wr                                      = "n_wr_full"                                                                    ,//"n_wr_full" "wr_full"
	parameter          hssi_pldadapt_tx_fifo_width                                        = "fifo_single_width"                                                            ,//"fifo_double_width" "fifo_single_width"
	parameter          hssi_pldadapt_tx_fifo_wr_clk_scg_en                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_fpll_shared_direct_async_in_sel                   = "fpll_shared_direct_async_in_rowclk"                                           ,//"fpll_shared_direct_async_in_dcm" "fpll_shared_direct_async_in_rowclk"
	parameter          hssi_pldadapt_tx_frmgen_burst                                      = "frmgen_burst_dis"                                                             ,//"frmgen_burst_dis" "frmgen_burst_en"
	parameter          hssi_pldadapt_tx_frmgen_bypass                                     = "frmgen_bypass_dis"                                                            ,//"frmgen_bypass_dis" "frmgen_bypass_en"
	parameter [15:0]   hssi_pldadapt_tx_frmgen_mfrm_length                                = 16'd2048                                                                       ,//0:65535
	parameter          hssi_pldadapt_tx_frmgen_pipeln                                     = "frmgen_pipeln_dis"                                                            ,//"frmgen_pipeln_dis" "frmgen_pipeln_en"
	parameter          hssi_pldadapt_tx_frmgen_pyld_ins                                   = "frmgen_pyld_ins_dis"                                                          ,//"frmgen_pyld_ins_dis" "frmgen_pyld_ins_en"
	parameter          hssi_pldadapt_tx_frmgen_wordslip                                   = "frmgen_wordslip_dis"                                                          ,//"frmgen_wordslip_dis" "frmgen_wordslip_en"
	parameter          hssi_pldadapt_tx_fsr_hip_fsr_in_bit0_rst_val                       = "reset_to_zero_hfsrin0"                                                        ,//"reset_to_one_hfsrin0" "reset_to_zero_hfsrin0"
	parameter          hssi_pldadapt_tx_fsr_hip_fsr_in_bit1_rst_val                       = "reset_to_zero_hfsrin1"                                                        ,//"reset_to_one_hfsrin1" "reset_to_zero_hfsrin1"
	parameter          hssi_pldadapt_tx_fsr_hip_fsr_in_bit2_rst_val                       = "reset_to_zero_hfsrin2"                                                        ,//"reset_to_one_hfsrin2" "reset_to_zero_hfsrin2"
	parameter          hssi_pldadapt_tx_fsr_hip_fsr_in_bit3_rst_val                       = "reset_to_zero_hfsrin3"                                                        ,//"reset_to_one_hfsrin3" "reset_to_zero_hfsrin3"
	parameter          hssi_pldadapt_tx_fsr_hip_fsr_out_bit0_rst_val                      = "reset_to_zero_hfsrout0"                                                       ,//"reset_to_one_hfsrout0" "reset_to_zero_hfsrout0"
	parameter          hssi_pldadapt_tx_fsr_hip_fsr_out_bit1_rst_val                      = "reset_to_zero_hfsrout1"                                                       ,//"reset_to_one_hfsrout1" "reset_to_zero_hfsrout1"
	parameter          hssi_pldadapt_tx_fsr_hip_fsr_out_bit2_rst_val                      = "reset_to_zero_hfsrout2"                                                       ,//"reset_to_one_hfsrout2" "reset_to_zero_hfsrout2"
	parameter          hssi_pldadapt_tx_fsr_hip_fsr_out_bit3_rst_val                      = "reset_to_zero_hfsrout3"                                                       ,//"reset_to_one_hfsrout3" "reset_to_zero_hfsrout3"
	parameter          hssi_pldadapt_tx_fsr_mask_tx_pll_rst_val                           = "reset_to_zero_maskpll"                                                        ,//"reset_to_one_maskpll" "reset_to_zero_maskpll"
	parameter          hssi_pldadapt_tx_fsr_pld_txelecidle_rst_val                        = "reset_to_zero_txelec"                                                         ,//"reset_to_one_txelec" "reset_to_zero_txelec"
	parameter          hssi_pldadapt_tx_gb_tx_idwidth                                     = "idwidth_66"                                                                   ,//"idwidth_32" "idwidth_40" "idwidth_50" "idwidth_64" "idwidth_66" "idwidth_67"
	parameter          hssi_pldadapt_tx_gb_tx_odwidth                                     = "odwidth_32"                                                                   ,//"odwidth_32" "odwidth_40" "odwidth_64"
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_aib_fabric_pld_pma_hclk_hz             = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz           = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_csr_clk_hz                             = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_pld_avmm1_clk_rowclk_hz                = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_pld_avmm2_clk_rowclk_hz                = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_pld_sclk1_rowclk_hz                    = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_pld_sclk2_rowclk_hz                    = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz                     = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_rowclk_hz                  = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz                     = 31'd0                                                                          ,//0:2147483647
	parameter [30:0]   hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_rowclk_hz                  = 31'd0                                                                          ,//0:2147483647
	parameter          hssi_pldadapt_tx_hdpldadapt_speed_grade                            = "dash_1"                                                                       ,//"dash_1" "dash_2" "dash_3"
	parameter          hssi_pldadapt_tx_hip_mode                                          = "disable_hip"                                                                  ,//"debug_chnl" "disable_hip" "user_chnl"
	parameter          hssi_pldadapt_tx_hip_osc_clk_scg_en                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_hrdrst_dcd_cal_done_bypass                        = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_hrdrst_rst_sm_dis                                 = "enable_tx_rst_sm"                                                             ,//"disable_tx_rst_sm" "enable_tx_rst_sm"
	parameter          hssi_pldadapt_tx_hrdrst_rx_osc_clk_scg_en                          = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_hrdrst_user_ctl_en                                = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_indv                                              = "indv_en"                                                                      ,//"indv_dis" "indv_en"
	parameter          hssi_pldadapt_tx_loopback_mode                                     = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_low_latency_en                                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_osc_clk_scg_en                                    = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_phcomp_rd_del                                     = "phcomp_rd_del2"                                                               ,//"phcomp_rd_del2" "phcomp_rd_del3" "phcomp_rd_del4" "phcomp_rd_del5" "phcomp_rd_del6" "phcomp_rd_del7" "phcomp_rd_del8"
	parameter          hssi_pldadapt_tx_pipe_mode                                         = "disable_pipe"                                                                 ,//"disable_pipe" "enable_g1" "enable_g2" "enable_g3"
	parameter          hssi_pldadapt_tx_pld_clk1_delay_en                                 = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_pld_clk1_delay_sel                                = "delay_path0"                                                                  ,//"delay_path0" "delay_path1" "delay_path10" "delay_path11" "delay_path12" "delay_path13" "delay_path14" "delay_path15" "delay_path2" "delay_path3" "delay_path4" "delay_path5" "delay_path6" "delay_path7" "delay_path8" "delay_path9"
	parameter          hssi_pldadapt_tx_pld_clk1_inv_en                                   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_pld_clk1_sel                                      = "pld_clk1_rowclk"                                                              ,//"pld_clk1_dcm" "pld_clk1_rowclk"
	parameter          hssi_pldadapt_tx_pld_clk2_sel                                      = "pld_clk2_rowclk"                                                              ,//"pld_clk2_dcm" "pld_clk2_rowclk"
	parameter          hssi_pldadapt_tx_pma_aib_tx_clk_expected_setting                   = "not_used"                                                                     ,//"dynamic" "not_used" "x1" "x2" "x2_not_from_chnl"
	parameter          hssi_pldadapt_tx_powerdown_mode                                    = "powerdown"                                                                    ,//"powerdown" "powerup"
	parameter          hssi_pldadapt_tx_reconfig_settings                                 = "{}"                                                                           ,//NOVAL
	parameter          hssi_pldadapt_tx_sh_err                                            = "sh_err_dis"                                                                   ,//"sh_err_dis" "sh_err_en"
	parameter          hssi_pldadapt_tx_silicon_rev                                       = "14nm5"                                                                        ,//"10nmacr2ea" "10nmacr2eb" "10nmacr3a" "14nm2acr2ea" "14nm2acr2eb" "14nm2acr3a" "14nm1acr2eb" "14nm1acr3a" "14nm0acr2eb" "14nm0acr3a" "14nm4acr2" "14nm4acr2b" "14nm4acr2ea" "14nm4acr2eb" "14nm4acr3a" "14nm4pacr2ea" "14nm4pacr2eb" "14nm4pacr3a" "14nm5" "14nm5bcr2b" "14nm5bcr2ea" "14nm5bcr2eb" "14nm5bcr3a" "14nm5cr2" "14nm7cr2b"
	parameter          hssi_pldadapt_tx_stretch_num_stages                                = "zero_stage"                                                                   ,//"five_stage" "four_stage" "one_stage" "six_stage" "three_stage" "two_stage" "zero_stage"
	parameter          hssi_pldadapt_tx_sup_mode                                          = "user_mode"                                                                    ,//"advanced_user_mode" "engineering_mode" "user_mode"
	parameter          hssi_pldadapt_tx_tx_datapath_tb_sel                                = "cp_bond"                                                                      ,//"cp_bond" "dv_gen_tb" "frm_gen_tb1" "frm_gen_tb2" "har_reset_tb" "tx_fifo_tb1" "tx_fifo_tb2"
	parameter          hssi_pldadapt_tx_tx_fastbond_rden                                  = "rden_ds_del_us_del"                                                           ,//"rden_ds_del_us_del" "rden_ds_del_us_fast" "rden_ds_fast_us_del" "rden_ds_fast_us_fast"
	parameter          hssi_pldadapt_tx_tx_fastbond_wren                                  = "wren_ds_del_us_del"                                                           ,//"wren_ds_del_us_del" "wren_ds_del_us_fast" "wren_ds_fast_us_del" "wren_ds_fast_us_fast"
	parameter          hssi_pldadapt_tx_tx_fifo_power_mode                                = "full_width_full_depth"                                                        ,//"full_width_full_depth" "full_width_ps_dw" "full_width_ps_sw" "half_width_full_depth" "half_width_ps_dw" "half_width_ps_sw"
	parameter          hssi_pldadapt_tx_tx_fifo_read_latency_adjust                       = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_tx_fifo_write_latency_adjust                      = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_tx_hip_aib_ssr_in_polling_bypass                  = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_tx_osc_clock_setting                              = "osc_clk_div_by1"                                                              ,//"osc_clk_div_by1" "osc_clk_div_by2" "osc_clk_div_by4"
	parameter          hssi_pldadapt_tx_tx_pld_8g_tx_boundary_sel_polling_bypass          = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_tx_pld_10g_tx_bitslip_polling_bypass              = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_tx_pld_pma_fpll_cnt_sel_polling_bypass            = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_tx_pld_pma_fpll_num_phase_shifts_polling_bypass   = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_tx_usertest_sel                                   = "enable"                                                                       ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_txfifo_empty                                      = "empty_default"                                                                ,//"empty_default"
	parameter          hssi_pldadapt_tx_txfifo_full                                       = "full_pc_sw"                                                                   ,//"full_non_pc_dw" "full_non_pc_sw" "full_pc_dw" "full_pc_sw"
	parameter          hssi_pldadapt_tx_txfifo_mode                                       = "txphase_comp"                                                                 ,//"txgeneric_basic" "txgeneric_interlaken" "txphase_comp" "txregister_mode"
	parameter [4:0]    hssi_pldadapt_tx_txfifo_pempty                                     = 5'd2                                                                           ,//0:31
	parameter [4:0]    hssi_pldadapt_tx_txfifo_pfull                                      = 5'd24                                                                          ,//0:31
	parameter          hssi_pldadapt_tx_us_bypass_pipeln                                  = "us_bypass_pipeln_dis"                                                         ,//"us_bypass_pipeln_dis" "us_bypass_pipeln_en"
	parameter          hssi_pldadapt_tx_us_last_chnl                                      = "us_not_last_chnl"                                                             ,//"us_last_chnl" "us_not_last_chnl"
	parameter          hssi_pldadapt_tx_us_master                                         = "us_master_en"                                                                 ,//"us_master_dis" "us_master_en"
	parameter          hssi_pldadapt_tx_word_align_enable                                 = "disable"                                                                      ,//"disable" "enable"
	parameter          hssi_pldadapt_tx_word_mark                                         = "wm_en"                                                                        ,//"wm_dis" "wm_en"
	parameter          hssi_rsfec_clocking_mode                                           = "no_clk"                                                                       ,//"ehip_common_clk" "fec_dir_adp_clk_0" "fec_dir_adp_clk_1" "fec_dir_adp_clk_2" "fec_dir_adp_clk_3" "no_clk"
	parameter          hssi_rsfec_core_eng_2lane_ena                                      = "false"                                                                        ,//"false" "true"
	parameter [3:0]    hssi_rsfec_core_eng_am_5bad_dis                                    = 4'd0                                                                           ,//0:15
	parameter [3:0]    hssi_rsfec_core_eng_blk_chk_dis                                    = 4'd0                                                                           ,//0:15
	parameter [3:0]    hssi_rsfec_core_eng_cons_25g                                       = 4'd15                                                                          ,//0:15
	parameter [23:0]   hssi_rsfec_core_eng_cust_am_1st_0                                  = 24'd0                                                                          ,//0:16777215
	parameter [23:0]   hssi_rsfec_core_eng_cust_am_1st_1                                  = 24'd0                                                                          ,//0:16777215
	parameter [23:0]   hssi_rsfec_core_eng_cust_am_1st_2                                  = 24'd0                                                                          ,//0:16777215
	parameter [23:0]   hssi_rsfec_core_eng_cust_am_1st_3                                  = 24'd0                                                                          ,//0:16777215
	parameter [23:0]   hssi_rsfec_core_eng_cust_am_2nd_0                                  = 24'd0                                                                          ,//0:16777215
	parameter [23:0]   hssi_rsfec_core_eng_cust_am_2nd_1                                  = 24'd0                                                                          ,//0:16777215
	parameter [23:0]   hssi_rsfec_core_eng_cust_am_2nd_2                                  = 24'd0                                                                          ,//0:16777215
	parameter [23:0]   hssi_rsfec_core_eng_cust_am_2nd_3                                  = 24'd0                                                                          ,//0:16777215
	parameter [3:0]    hssi_rsfec_core_eng_cust_am_en                                     = 4'd0                                                                           ,//0:15
	parameter [15:0]   hssi_rsfec_core_eng_cust_log2_mrk                                  = 16'd0                                                                          ,//0:65535
	parameter [3:0]    hssi_rsfec_core_eng_enter_align                                    = 4'd0                                                                           ,//0:15
	parameter [3:0]    hssi_rsfec_core_eng_exit_align                                     = 4'd0                                                                           ,//0:15
	parameter [3:0]    hssi_rsfec_core_eng_fec_3bad_dis                                   = 4'd0                                                                           ,//0:15
	parameter [3:0]    hssi_rsfec_core_eng_sf_dis                                         = 4'd0                                                                           ,//0:15
	parameter [15:0]   hssi_rsfec_core_eng_swaps                                          = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_rsfec_core_eng_test                                           = 16'd0                                                                          ,//0:65535
	parameter [3:0]    hssi_rsfec_core_eng_trans_byp                                      = 4'd0                                                                           ,//0:15
	parameter          hssi_rsfec_core_fibre_channel0                                     = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_fibre_channel1                                     = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_fibre_channel2                                     = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_fibre_channel3                                     = "false"                                                                        ,//"false" "true"
	parameter [3:0]    hssi_rsfec_core_indic_byp                                          = 4'd0                                                                           ,//0:15
	parameter          hssi_rsfec_core_rs544_0                                            = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_rs544_1                                            = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_rs544_2                                            = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_rs544_3                                            = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_scrambling0                                        = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_scrambling1                                        = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_scrambling2                                        = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_scrambling3                                        = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_tx_pcs_bypass0                                     = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_tx_pcs_bypass1                                     = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_tx_pcs_bypass2                                     = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_core_tx_pcs_bypass3                                     = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_deskew_channels_active                                  = "dsk_ln_none"                                                                  ,//"dsk_ln_all" "dsk_ln_none"
	parameter          hssi_rsfec_deskew_channels_clear                                   = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_fec_tx2rx_loopback0                                     = "tx_rx_loopback_none0"                                                         ,//"tx_rx_loopback_ena0" "tx_rx_loopback_none0"
	parameter          hssi_rsfec_fec_tx2rx_loopback1                                     = "tx_rx_loopback_none1"                                                         ,//"tx_rx_loopback_ena1" "tx_rx_loopback_none1"
	parameter          hssi_rsfec_fec_tx2rx_loopback2                                     = "tx_rx_loopback_none2"                                                         ,//"tx_rx_loopback_ena2" "tx_rx_loopback_none2"
	parameter          hssi_rsfec_fec_tx2rx_loopback3                                     = "tx_rx_loopback_none3"                                                         ,//"tx_rx_loopback_ena3" "tx_rx_loopback_none3"
	parameter          hssi_rsfec_first_lane_sel                                          = "first_lane0"                                                                  ,//"first_lane0" "first_lane1" "first_lane2" "first_lane3"
	parameter          hssi_rsfec_force_deskew_done                                       = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_force_fec_ready                                         = "false"                                                                        ,//"false" "true"
	parameter          hssi_rsfec_func_mode                                               = "disabled"                                                                     ,//"disabled" "ehip_aggr" "elane_frac" "fec_dir_aggr" "fec_dir_frac"
	parameter          hssi_rsfec_hwcfg_ena                                               = "false"                                                                        ,//"false" "true"
	parameter [14:0]   hssi_rsfec_hwcfg_mode                                              = 15'd0                                                                          ,//0:32767
	parameter          hssi_rsfec_lane_func_mode0                                         = "lane_mode_ehip0"                                                              ,//"lane_mode_disable0" "lane_mode_ehip0" "lane_mode_elane0" "lane_mode_fec_dir_dsk0" "lane_mode_fec_dir_no_dsk0"
	parameter          hssi_rsfec_lane_func_mode1                                         = "lane_mode_ehip1"                                                              ,//"lane_mode_disable1" "lane_mode_ehip1" "lane_mode_elane1" "lane_mode_fec_dir_dsk1" "lane_mode_fec_dir_no_dsk1"
	parameter          hssi_rsfec_lane_func_mode2                                         = "lane_mode_ehip2"                                                              ,//"lane_mode_disable2" "lane_mode_ehip2" "lane_mode_elane2" "lane_mode_fec_dir_dsk2" "lane_mode_fec_dir_no_dsk2"
	parameter          hssi_rsfec_lane_func_mode3                                         = "lane_mode_ehip3"                                                              ,//"lane_mode_disable3" "lane_mode_ehip3" "lane_mode_elane3" "lane_mode_fec_dir_dsk3" "lane_mode_fec_dir_no_dsk3"
	parameter          hssi_rsfec_operation_mode                                          = "oper_aggr"                                                                    ,//"oper_aggr" "oper_frac"
	parameter          hssi_rsfec_powerdown_mode                                          = "true"                                                                         ,//"false" "true"
	parameter          hssi_rsfec_silicon_rev                                             = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_rsfec_source_clk_sel                                          = "ehip_clk"                                                                     ,//"adp0_clk" "adp1_clk" "adp2_clk" "adp3_clk" "ehip_clk"
	parameter          hssi_rsfec_source_lane_ena0                                        = "true"                                                                         ,//"false" "true"
	parameter          hssi_rsfec_source_lane_ena1                                        = "true"                                                                         ,//"false" "true"
	parameter          hssi_rsfec_source_lane_ena2                                        = "true"                                                                         ,//"false" "true"
	parameter          hssi_rsfec_source_lane_ena3                                        = "true"                                                                         ,//"false" "true"
	parameter [7:0]    hssi_rsfec_spare_bits                                              = 8'd0                                                                           ,//0:255
	parameter          hssi_rsfec_sup_mode                                                = "user_mode"                                                                    ,//"advanced_user_mode" "advanced_user_mode2" "engineering_mode" "user_mode"
	parameter          hssi_rsfec_topology                                                = "disabled_block"                                                               ,//"dirfec_100g" "dirfec_1ch" "dirfec_2ch" "dirfec_3ch" "dirfec_4ch" "dir_kpfec_100g" "disabled_block" "disabled_system" "ehip_2ch" "ehip_2ch_ptp" "ehip_4ch" "ehip_4ch_fec" "ehip_4ch_kpfec" "ehip_4ch_ptp" "ehip_4ch_ptp_fec" "elane_1ch" "elane_1ch_fec" "elane_1ch_ptp" "elane_1ch_ptp_fec" "elane_2ch_fec" "elane_2ch_ptp" "elane_2ch_ptp_fec" "elane_3ch_fec" "elane_3ch_ptp" "elane_3ch_ptp_fec" "elane_4ch_fec" "elane_4ch_ptp" "elane_4ch_ptp_fec" "pcs_gearbox_ch" "pmadir_1ch" "pmadir_2ch" "pmadir_pllch" "pmadir_refclkch" "ptp_pllch" "rsvd_topo1" "rsvd_topo2" "rsvd_topo3" "rsvd_topo4" "rsvd_topo5"
	parameter          hssi_rsfec_tx_data_source_sel0                                     = "ehip_tx_data0"                                                                ,//"ehip_tx_data0" "elane_tx_data0" "fec_dir_tx_data_dsk0" "fec_dir_tx_data_no_dsk0" "fec_lb_rx2tx_dat0" "fec_tx_lane_off0"
	parameter          hssi_rsfec_tx_data_source_sel1                                     = "ehip_tx_data1"                                                                ,//"ehip_tx_data1" "elane_tx_data1" "fec_dir_tx_data_dsk1" "fec_dir_tx_data_no_dsk1" "fec_lb_rx2tx_dat1" "fec_tx_lane_off1"
	parameter          hssi_rsfec_tx_data_source_sel2                                     = "ehip_tx_data2"                                                                ,//"ehip_tx_data2" "elane_tx_data2" "fec_dir_tx_data_dsk2" "fec_dir_tx_data_no_dsk2" "fec_lb_rx2tx_dat2" "fec_tx_lane_off2"
	parameter          hssi_rsfec_tx_data_source_sel3                                     = "ehip_tx_data3"                                                                ,//"ehip_tx_data3" "elane_tx_data3" "fec_dir_tx_data_dsk3" "fec_dir_tx_data_no_dsk3" "fec_lb_rx2tx_dat3" "fec_tx_lane_off3"
	parameter          hssi_rsfec_u_rsfec_rx_mux0_rx_data_source                          = "xcvr_rx_data"                                                                 ,//"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
	parameter          hssi_rsfec_u_rsfec_rx_mux1_rx_data_source                          = "xcvr_rx_data"                                                                 ,//"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
	parameter          hssi_rsfec_u_rsfec_rx_mux2_rx_data_source                          = "xcvr_rx_data"                                                                 ,//"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
	parameter          hssi_rsfec_u_rsfec_rx_mux3_rx_data_source                          = "xcvr_rx_data"                                                                 ,//"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
	parameter          hssi_rsfecrx_mux_rx_data_source                                    = "xcvr_rx_data"                                                                 ,//"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
	parameter          hssi_rsfecrx_mux_silicon_rev                                       = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_xcvr_an_mode                                                  = "an_mode_dis"                                                                  ,//"an_mode_dis" "an_mode_en"
	parameter          hssi_xcvr_bonding_mode                                             = "nonbonded"                                                                    ,//"bonded" "nonbonded"
	parameter          hssi_xcvr_enable_lowpower_mode                                     = "false"                                                                    ,//"bonded" "nonbonded"
	parameter          hssi_xcvr_cfg_c_revbitorder                                        = "rev_bit_order_false"                                                          ,//"rev_bit_order_false" "rev_bit_order_true"
	parameter          hssi_xcvr_cfg_clk_en_div66_tx                                      = "tx_clk_en_div66_dis"                                                          ,//"tx_clk_en_div66_dis" "tx_clk_en_div66_en"
	parameter          hssi_xcvr_cfg_clk_en_sclk_rx                                       = "det_lat_en_sclk_rx"                                                           ,//"det_lat_dis_sclk_rx" "det_lat_en_sclk_rx"
	parameter          hssi_xcvr_cfg_clk_en_sclk_tx                                       = "det_lat_tx_sclk_dis"                                                          ,//"det_lat_tx_sclk_dis" "det_lat_tx_sclk_en"
	parameter          hssi_xcvr_cfg_core_int_request                                     = "core_int_req_dis"                                                             ,//"core_int_req_assert" "core_int_req_dis"
	parameter          hssi_xcvr_cfg_dcc_csr_core_rst_en                                  = "dcc_core_rst_dis"                                                             ,//"dcc_core_rst_dis" "dcc_core_rst_en"
	parameter [21:0]   hssi_xcvr_cfg_dcc_csr_dft_msel                                     = 22'd0                                                                          ,//0:4194303
	parameter          hssi_xcvr_cfg_dcc_csr_dll_sel                                      = "dcc_dll_follow_fsm"                                                           ,//"dcc_dll_follow_fsm" "dcc_dll_ovr_fsm"
	parameter [9:0]    hssi_xcvr_cfg_dcc_csr_dly_ovr                                      = 10'd0                                                                          ,//0:1023
	parameter          hssi_xcvr_cfg_dcc_csr_dly_ovr_10                                   = "dcc_dly_ovr_msb_0"                                                            ,//"dcc_dly_ovr_msb_0" "dcc_dly_ovr_msb_1"
	parameter          hssi_xcvr_cfg_dcc_csr_dn_invert                                    = "dcc_no_invert_dn"                                                             ,//"dcc_invert_dn" "dcc_no_invert_dn"
	parameter          hssi_xcvr_cfg_dcc_csr_en_fsm                                       = "dcc_en_fsm"                                                                   ,//"dcc_dis_fsm" "dcc_en_fsm"
	parameter          hssi_xcvr_cfg_dcc_csr_mux_sel                                      = "dcc_req_sel_adapter"                                                          ,//"dcc_req_sel_adapter" "dcc_req_sel_dft"
	parameter [9:0]    hssi_xcvr_cfg_dcc_csr_resv                                         = 10'd0                                                                          ,//0:1023
	parameter          hssi_xcvr_cfg_dcc_csr_resv_10                                      = "dcc_resv_msb_0"                                                               ,//"dcc_resv_msb_0" "dcc_resv_msb_1"
	parameter          hssi_xcvr_cfg_dcc_csr_rst_invert                                   = "dcc_no_invert_rst"                                                            ,//"dcc_invert_rst" "dcc_no_invert_rst"
	parameter          hssi_xcvr_cfg_dcc_csr_up_invert                                    = "dcc_no_invert_up"                                                             ,//"dcc_invert_up" "dcc_no_invert_up"
	parameter          hssi_xcvr_cfg_dcc_csr_updn_en                                      = "dcc_updn_dis"                                                                 ,//"dcc_updn_dis" "dcc_updn_en"
	parameter          hssi_xcvr_cfg_idll_entest                                          = "dcc_test_dis"                                                                 ,//"dcc_test_dis" "dcc_test_en"
	parameter [19:0]   hssi_xcvr_cfg_mem_pbist                                            = 20'd0                                                                          ,//0:1048575
	parameter [9:0]    hssi_xcvr_cfg_mem_ulp_tmg_mode                                     = 10'd0                                                                          ,//0:1023
	parameter          hssi_xcvr_cfg_rb_clkdiv                                            = "dcc_ckdiv_16"                                                                 ,//"dcc_ckdiv_1024" "dcc_ckdiv_128" "dcc_ckdiv_16" "dcc_ckdiv_256" "dcc_ckdiv_32" "dcc_ckdiv_512" "dcc_ckdiv_64" "dcc_ckdiv_8"
	parameter          hssi_xcvr_cfg_rb_cont_cal                                          = "dcc_cont_cal_en"                                                              ,//"dcc_cont_cal_dis" "dcc_cont_cal_en"
	parameter          hssi_xcvr_cfg_rb_dcc_byp                                           = "dcc_byp_dis"                                                                  ,//"dcc_byp_dis" "dcc_byp_en"
	parameter          hssi_xcvr_cfg_rb_dcc_dft                                           = "dcc_dft_dis"                                                                  ,//"dcc_dft_dis" "dcc_dft_en"
	parameter          hssi_xcvr_cfg_rb_dcc_dft_sel                                       = "dcc_dft_mode1"                                                                ,//"dcc_dft_mode0" "dcc_dft_mode1"
	parameter          hssi_xcvr_cfg_rb_dcc_en                                            = "dcc_mast_en"                                                                  ,//"dcc_mast_dis" "dcc_mast_en"
	parameter [4:0]    hssi_xcvr_cfg_rb_dcc_manual_dn                                     = 5'd0                                                                           ,//0:31
	parameter [4:0]    hssi_xcvr_cfg_rb_dcc_manual_up                                     = 5'd0                                                                           ,//0:31
	parameter          hssi_xcvr_cfg_rb_dcc_req                                           = "dcc_req_dis"                                                                  ,//"dcc_req_dis" "dcc_req_en"
	parameter          hssi_xcvr_cfg_rb_dcc_req_ovr                                       = "dcc_req_no_ovr"                                                               ,//"dcc_req_no_ovr" "dcc_req_ovr"
	parameter          hssi_xcvr_cfg_rb_half_code                                         = "dcc_en_half_code"                                                             ,//"dcc_dis_half_code" "dcc_en_half_code"
	parameter          hssi_xcvr_cfg_rb_nfrzdrv                                           = "dcc_freeze"                                                                   ,//"dcc_drv" "dcc_freeze"
	parameter          hssi_xcvr_cfg_rb_selflock                                          = "dcc_en_cntr_lock"                                                             ,//"dcc_dis_cntr_lock" "dcc_en_cntr_lock"
	parameter          hssi_xcvr_cfg_reset_rx_bit_counter                                 = "reset_rxbit_cnt"                                                              ,//"noreset_rxbit_cnt" "reset_rxbit_cnt"
	parameter          hssi_xcvr_cfg_restart_seq_sm                                       = "seq_sm_idle"                                                                  ,//"seq_sm_idle" "seq_sm_restart"
	parameter          hssi_xcvr_cfg_revbitorder                                          = "rev_bit_order_dis"                                                            ,//"rev_bit_order_dis" "rev_bit_order_en"
	parameter [12:0]   hssi_xcvr_cfg_rx_bit_counter_rollover                              = 13'd0                                                                          ,//0:8191
	parameter [1:0]    hssi_xcvr_cfg_rx_fifo_lat_en                                       = 2'd0                                                                           ,//0:3
	parameter          hssi_xcvr_cfg_rx_pcs_data_sel                                      = "sel_rx_fifo_data"                                                             ,//"sel_rx_fifo_data" "sel_rx_pcs_data"
	parameter          hssi_xcvr_cfg_rxbit_cntr_pma                                       = "sel_async_cnt_fec"                                                            ,//"sel_async_cnt_fec" "sel_async_cnt_pma"
	parameter          hssi_xcvr_cfg_sel_bit_counter_adder                                = "ser_fact_32"                                                                  ,//"ser_fact_16" "ser_fact_20" "ser_fact_32" "ser_fact_dis"
	parameter          hssi_xcvr_cfg_sel_hw_decode_mode                                   = "hwdec_disable"                                                                ,//"hwdec_disable" "hwdec_enable"
	parameter          hssi_xcvr_cfg_tbus_sel                                             = "tbus_sel_txfifo"                                                              ,//"tbus_sel_pwrseq" "tbus_sel_rxfifo" "tbus_sel_rxfifo_stat" "tbus_sel_rxgbx1" "tbus_sel_rxgbx2" "tbus_sel_txfifo" "tbus_sel_txfifo_stat" "tbus_sel_txgbx" "tbus_sel_zero"
	parameter          hssi_xcvr_cfg_test_clk_pll_en_n                                    = "dcc_tclk_pll_en"                                                              ,//"dcc_tclk_pll_dis" "dcc_tclk_pll_en"
	parameter [1:0]    hssi_xcvr_cfg_tx_fifo_lat_en                                       = 2'd0                                                                           ,//0:3
	parameter          hssi_xcvr_channel_mode                                             = "xcvr_duplex"                                                                  ,//"xcvr_duplex" "xcvr_rxonly" "xcvr_txonly"
	parameter          hssi_xcvr_clk_en_direct_tx                                         = "en_tx_direct_clk"                                                             ,//"dis_tx_direct_clk" "en_tx_direct_clk"
	parameter          hssi_xcvr_clk_en_div66_rx                                          = "dis_rx_div66_clk"                                                             ,//"dis_rx_div66_clk" "en_rx_div66_clk"
	parameter          hssi_xcvr_clk_en_ehip_d2_tx                                        = "en_tx_ehip_clk"                                                               ,//"dis_tx_ehip_clk" "en_tx_ehip_clk"
	parameter          hssi_xcvr_clk_en_fec_d2_tx                                         = "en_tx_fec_clk"                                                                ,//"dis_tx_fec_clk" "en_tx_fec_clk"
	parameter          hssi_xcvr_clk_en_fifo_rd_rx                                        = "en_rx_fifo_rd_clk"                                                            ,//"dis_rx_fifo_rd_clk" "en_rx_fifo_rd_clk"
	parameter          hssi_xcvr_clk_en_fifo_rx                                           = "en_fifo_clk_rx"                                                               ,//"dis_fifo_clk_rx" "en_fifo_clk_rx"
	parameter          hssi_xcvr_clk_en_full_rx                                           = "dis_rx_full_clk"                                                              ,//"dis_rx_full_clk" "en_rx_full_clk"
	parameter          hssi_xcvr_clk_en_full_tx                                           = "dis_tx_full_clk"                                                              ,//"dis_tx_full_clk" "en_tx_full_clk"
	parameter          hssi_xcvr_clk_en_half_rx                                           = "dis_rx_half_clk"                                                              ,//"dis_rx_half_clk" "en_rx_half_clk"
	parameter          hssi_xcvr_clk_en_pcs_d2_tx                                         = "en_tx_pcs_clk"                                                                ,//"dis_tx_pcs_clk" "en_tx_pcs_clk"
	parameter          hssi_xcvr_clk_en_rx                                                = "dis_rx_clk"                                                                   ,//"dis_rx_clk" "en_rx_clk"
	parameter          hssi_xcvr_clk_en_rx_adapt                                          = "en_rx_adapt_clk"                                                              ,//"dis_rx_adapt_clk" "en_rx_adapt_clk"
	parameter          hssi_xcvr_clk_en_tx                                                = "dis_tx_clk"                                                                   ,//"dis_tx_clk" "en_tx_clk"
	parameter          hssi_xcvr_clk_en_tx_datapath                                       = "en_tx_datapath_clk"                                                           ,//"dis_tx_datapath_clk" "en_tx_datapath_clk"
	parameter          hssi_xcvr_clk_en_tx_gbx                                            = "en_tx_gb_clk"                                                                 ,//"dis_tx_gb_clk" "en_tx_gb_clk"
	parameter [15:0]   hssi_xcvr_int_core_to_cntl                                         = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_int_if_code                                              = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_int_if_data                                              = 16'd0                                                                          ,//0:65535
	parameter [4:0]    hssi_xcvr_int_seq1_tx_clk_slip_cnt                                 = 5'd0                                                                           ,//0:31
	parameter [3:0]    hssi_xcvr_int_seq1_tx_phase_load_cnt                               = 4'd0                                                                           ,//0:15
	parameter          hssi_xcvr_int_seq1_tx_slip_always_on                               = "dis_tx_always_on"                                                             ,//"dis_tx_always_on" "en_tx_always_on"
	parameter [5:0]    hssi_xcvr_int_seq2_rx_clk_slip_cnt                                 = 6'd0                                                                           ,//0:63
	parameter [4:0]    hssi_xcvr_int_seq2_rx_phase_load_cnt                               = 5'd0                                                                           ,//0:31
	parameter          hssi_xcvr_int_seq2_rx_slip_always_on                               = "dis_rx_always_on"                                                             ,//"dis_rx_always_on" "en_rx_always_on"
	parameter          hssi_xcvr_int_seq3_refclk_cfg_both                                 = "refclk_cfg_tx"                                                                ,//"refclk_cfg_tx" "refclk_tcfg_both"
	parameter          hssi_xcvr_int_seq3_tx_bit_rate                                     = "tx_full_rate"                                                                 ,//"tx_eighth_rate" "tx_full_rate" "tx_half_rate" "tx_quarter_rate" "tx_sixteenth_rate"
	parameter [7:0]    hssi_xcvr_int_seq3_tx_refclk_ratio                                 = 8'd0                                                                           ,//0:255
	parameter          hssi_xcvr_int_seq3_txpll_refclk_sel                                = "tx_refclk_sel_rck0"                                                           ,//"tx_refclk_sel_rck0" "tx_refclk_sel_rck1"
	parameter          hssi_xcvr_int_seq4_refclk_cfg_both                                 = "refclk_cfg_rx"                                                                ,//"refclk_cfg_rx" "refclk_rcfg_both"
	parameter          hssi_xcvr_int_seq4_rx_bit_rate                                     = "rx_full_rate"                                                                 ,//"rx_eighth_rate" "rx_full_rate" "rx_half_rate" "rx_quarter_rate" "rx_sixteenth_rate"
	parameter [7:0]    hssi_xcvr_int_seq4_rx_refclk_ratio                                 = 8'd0                                                                           ,//0:255
	parameter          hssi_xcvr_int_seq4_rxpll_refclk_sel                                = "rx_refclk_sel_rck0"                                                           ,//"rx_refclk_sel_rck0" "rx_refclk_sel_rck1"
	parameter          hssi_xcvr_int_seq5_ph_opt                                          = "dis_phase_opt"                                                                ,//"dis_phase_opt" "en_phase_opt"
	parameter          hssi_xcvr_int_seq6_rx_sr_enc                                       = "rx_enc_is_nrz"                                                                ,//"rx_enc_is_nrz" "rx_enc_is_pam4"
	parameter          hssi_xcvr_int_seq6_rx_width                                        = "rx_width_32b"                                                                 ,//"rx_width_16b" "rx_width_20b" "rx_width_32b" "rx_width_40b" "rx_width_64b"
	parameter          hssi_xcvr_int_seq6_tx_sr_enc                                       = "tx_enc_is_nrz"                                                                ,//"tx_enc_is_nrz" "tx_enc_is_pam4"
	parameter          hssi_xcvr_int_seq6_tx_width                                        = "tx_width_32b"                                                                 ,//"tx_width_16b" "tx_width_20b" "tx_width_32b" "tx_width_40b" "tx_width_64b"
	parameter [7:0]    hssi_xcvr_int_seq7_txeq_pre1                                       = 8'd0                                                                           ,//0:255
	parameter [7:0]    hssi_xcvr_int_seq8_txeq_slew                                       = 8'd0                                                                           ,//0:255
	parameter [7:0]    hssi_xcvr_int_seq9_txeq_atten                                      = 8'd0                                                                           ,//0:255
	parameter [7:0]    hssi_xcvr_int_seq10_txeq_amp                                       = 8'd0                                                                           ,//0:255
	parameter [7:0]    hssi_xcvr_int_seq11_txeq_post                                      = 8'd0                                                                           ,//0:255
	parameter [7:0]    hssi_xcvr_int_seq12_txeq_broadcast                                 = 8'd0                                                                           ,//0:255
	parameter          hssi_xcvr_int_seq13_rx_pll_recal                                   = "rx_pll_recal_en"                                                              ,//"rx_pll_recal_dis" "rx_pll_recal_en"
	parameter          hssi_xcvr_int_seq13_tx_pll_recal                                   = "tx_pll_recal_en"                                                              ,//"tx_pll_recal_dis" "tx_pll_recal_en"
	parameter          hssi_xcvr_interrupt_cntl_ovr_en                                    = "config_core_ovr_if_cntl"                                                      ,//"aib_ovr_if_cntl" "config_core_ovr_if_cntl"
	parameter          hssi_xcvr_interrupt_core_stat_sel_msw                              = "sel_core_stat_lsw"                                                            ,//"sel_core_stat_lsw" "sel_core_stat_msw"
	parameter          hssi_xcvr_interrupt_in_prog_assert                                 = "dis_int_in_prog_assert"                                                       ,//"dis_int_in_prog_assert" "en_int_in_prog_assert"
	parameter          hssi_xcvr_lpbk_mode                                                = "lpbk_disable"                                                                 ,//"link_lpbk" "lpbk_disable" "par_lpbk"
	parameter          hssi_xcvr_powerdown_mode                                           = "true"                                                                         ,//"false" "true"
	parameter          hssi_xcvr_powermode_ac_avmm_freq_hz                                = "1"                                                                            ,//NOVAL
	parameter          hssi_xcvr_powermode_ac_csr                                         = "ac_xcvr_csr_off"                                                              ,//"ac_xcvr_csr_off" "ac_xcvr_csr_on"
	parameter          hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz                       = "1"                                                                            ,//NOVAL
	parameter          hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz                       = "1"                                                                            ,//NOVAL
	parameter          hssi_xcvr_powermode_ac_xcvrif_rx                                   = "ac_rxif_off"                                                                  ,//"ac_rxif_hip" "ac_rxif_off" "ac_rxif_pma_dir"
	parameter          hssi_xcvr_powermode_ac_xcvrif_tx                                   = "ac_txif_off"                                                                  ,//"ac_txif_hip" "ac_txif_off" "ac_txif_pma_dir"
	parameter          hssi_xcvr_powermode_dc_csr                                         = "powerdown_dc_xcvr_csr"                                                        ,//"dc_xcvr_csr_on" "powerdown_dc_xcvr_csr"
	parameter          hssi_xcvr_powermode_dc_xcvrif_rx                                   = "powerdown_dc_rxif"                                                            ,//"dc_rxif_on" "powerdown_dc_rxif"
	parameter          hssi_xcvr_powermode_dc_xcvrif_tx                                   = "powerdown_dc_txif"                                                            ,//"dc_txif_on" "powerdown_dc_txif"
	parameter          hssi_xcvr_refclk_mux_powerdown_mode                                = "false"                                                                        ,//"false" "true"
	parameter          hssi_xcvr_refclk_mux_silicon_rev                                   = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_xcvr_refclk_mux_topology                                      = "disabled_block"                                                               ,//"dirfec_100g" "dirfec_1ch" "dirfec_2ch" "dirfec_3ch" "dirfec_4ch" "disabled_block" "disabled_system" "ehip_2ch" "ehip_2ch_ptp" "ehip_4ch" "ehip_4ch_fec" "ehip_4ch_ptp" "ehip_4ch_ptp_fec" "elane_1ch" "elane_1ch_fec" "elane_1ch_ptp" "elane_1ch_ptp_fec" "elane_2ch_fec" "elane_2ch_ptp" "elane_2ch_ptp_fec" "elane_3ch_fec" "elane_3ch_ptp" "elane_3ch_ptp_fec" "elane_4ch_fec" "elane_4ch_ptp" "elane_4ch_ptp_fec" "pcs_gearbox_ch" "pmadir_1ch" "pmadir_2ch" "pmadir_pllch" "pmadir_refclkch" "ptp_pllch" "rsvd_topo1" "rsvd_topo2"
	parameter          hssi_xcvr_rst_en_rx                                                = "rx_dis_ehip_fec_pcs"                                                          ,//"rx_dis_ehip_fec_pcs" "rx_ehip_only" "rx_en_ehip_fec" "rx_en_ehip_fec_pcs" "rx_en_ehip_pcs" "rx_en_fec_pcs" "rx_fec_only" "rx_pcs_only"
	parameter          hssi_xcvr_rx_adapt_order_sel                                       = "rx_adapt_order_sel_0"                                                         ,//"rx_adapt_order_sel_0" "rx_adapt_order_sel_1"
	parameter          hssi_xcvr_rx_bitslip                                               = "dis_rx_user_bitslip"                                                          ,//"dis_rx_user_bitslip" "en_rx_user_bitslip"
	parameter          hssi_xcvr_rx_c_revbitorder                                         = "dis_rx_c_revbitorder"                                                         ,//"dis_rx_c_revbitorder" "en_rx_c_revbitorder"
	parameter          hssi_xcvr_rx_datarate_bps                                          = "1"                                                                            ,//NOVAL
	parameter          hssi_xcvr_rx_det_latency_en                                        = "rx_det_dis"                                                                   ,//"rx_det_dis" "rx_det_en"
	parameter          hssi_xcvr_rx_fifo_clk_sel                                          = "fifo_clk_sel3"                                                                ,//"fifo_clk_sel0" "fifo_clk_sel1" "fifo_clk_sel2" "fifo_clk_sel3"
	parameter          hssi_xcvr_rx_gb_idwidth                                            = "rx_gb_idwidth_64b"                                                            ,//"rx_gb_idwidth_32b" "rx_gb_idwidth_40b" "rx_gb_idwidth_64b"
	parameter          hssi_xcvr_rx_gb_mode                                               = "rx_gb_66_64"                                                                  ,//"rx_gb_32_32" "rx_gb_40_40" "rx_gb_64_32" "rx_gb_64_64" "rx_gb_66_64" "rx_gb_67_64"
	parameter          hssi_xcvr_rx_gb_odwidth                                            = "rx_gb_odwidth_66b"                                                            ,//"rx_gb_odwidth_32b" "rx_gb_odwidth_40b" "rx_gb_odwidth_50b" "rx_gb_odwidth_64b" "rx_gb_odwidth_66b" "rx_gb_odwidth_67b"
	parameter          hssi_xcvr_rx_interleave_mode                                       = "rx_il_disable"                                                                ,//"rx_il_disable" "rx_il_enable"
	parameter          hssi_xcvr_rx_pma_width                                             = "rx_width_16"                                                                  ,//"rx_width_16" "rx_width_20" "rx_width_32" "rx_width_40" "rx_width_64"
	parameter          hssi_xcvr_rx_pma_width_sd                                          = "1"                                                                            ,//NOVAL
	parameter          hssi_xcvr_rx_rden_sel                                              = "rden_frm_fifo"                                                                ,//"rden_frm_ehip_fec" "rden_frm_fifo"
	parameter          hssi_xcvr_rx_refclk_freq                                           = "125"                                                                          ,//NOVAL
	parameter          hssi_xcvr_rx_revbitorder                                           = "dis_rx_revbitorder"                                                           ,//"dis_rx_revbitorder" "en_rx_revbitorder"
	parameter          hssi_xcvr_rx_sh_location                                           = "rx_sh_location_1_0"                                                           ,//"rx_sh_location_1_0" "rx_sh_location_65_64"
	parameter          hssi_xcvr_rx_tag_sel                                               = "rx_tag_sel_lat_tag"                                                           ,//"rx_tag_sel_b67" "rx_tag_sel_lat_tag"
	parameter          hssi_xcvr_rx_width_adapt                                           = "rx_width_adp_dis"                                                             ,//"rx_width_adp_dis" "rx_width_adp_en"
	parameter [4:0]    hssi_xcvr_rxfifo_ae_thld                                           = 5'd0                                                                           ,//0:31
	parameter [4:0]    hssi_xcvr_rxfifo_af_thld                                           = 5'd0                                                                           ,//0:31
	parameter [4:0]    hssi_xcvr_rxfifo_e_thld                                            = 5'd0                                                                           ,//0:31
	parameter [4:0]    hssi_xcvr_rxfifo_f_thld                                            = 5'd0                                                                           ,//0:31
	parameter          hssi_xcvr_rxfifo_rd_empty                                          = "prevent_rd_rx_fifo_empty"                                                     ,//"allow_rd_rx_fifo_empty" "prevent_rd_rx_fifo_empty"
	parameter          hssi_xcvr_rxfifo_wr_full                                           = "prevent_wr_rx_fifo_full"                                                      ,//"allow_wr_rx_fifo_full" "prevent_wr_rx_fifo_full"
	parameter          hssi_xcvr_seq_en_phaseopt                                          = "dis_ph_opt_seq"                                                               ,//"dis_ph_opt_seq" "en_ph_opt_seq"
	parameter          hssi_xcvr_seq_en_reserved1                                         = "dis_reserved1_seq"                                                            ,//"dis_reserved1_seq" "en_reserved1_seq"
	parameter          hssi_xcvr_seq_en_reserved2                                         = "dis_reserved2_seq"                                                            ,//"dis_reserved2_seq" "en_reserved2_seq"
	parameter          hssi_xcvr_seq_en_reserved3                                         = "dis_reserved3_seq"                                                            ,//"dis_reserved3_seq" "en_reserved3_seq"
	parameter          hssi_xcvr_seq_en_reserved4                                         = "dis_reserved4_seq"                                                            ,//"dis_reserved4_seq" "en_reserved4_seq"
	parameter          hssi_xcvr_seq_en_reserved5                                         = "dis_reserved5_seq"                                                            ,//"dis_reserved5_seq" "en_reserved5_seq"
	parameter          hssi_xcvr_seq_en_reserved6                                         = "dis_reserved6_seq"                                                            ,//"dis_reserved6_seq" "en_reserved6_seq"
	parameter          hssi_xcvr_seq_en_reserved7                                         = "dis_reserved7_seq"                                                            ,//"dis_reserved7_seq" "en_reserved7_seq"
	parameter          hssi_xcvr_seq_en_rx_phase_slip                                     = "dis_rx_phase_slip_seq"                                                        ,//"dis_rx_phase_slip_seq" "en_rx_phase_slip_seq"
	parameter          hssi_xcvr_seq_en_tx_phase_slip                                     = "dis_tx_phase_slip_seq"                                                        ,//"dis_tx_phase_slip_seq" "en_tx_phase_slip_seq"
	parameter          hssi_xcvr_serdes_rx_enc                                            = "rx_nrz"                                                                       ,//"rx_nrz" "rx_pam4"
	parameter          hssi_xcvr_serdes_tx_enc                                            = "tx_nrz"                                                                       ,//"tx_nrz" "tx_pam4"
	parameter          hssi_xcvr_set_int_seq0                                             = "set_int_seq0"                                                                 ,//"set_int_seq0"
	parameter          hssi_xcvr_set_int_seq1                                             = "set_int_seq1"                                                                 ,//"set_int_seq1"
	parameter          hssi_xcvr_set_int_seq2                                             = "set_int_seq2"                                                                 ,//"set_int_seq2"
	parameter          hssi_xcvr_set_int_seq3                                             = "set_int_seq3"                                                                 ,//"set_int_seq3"
	parameter          hssi_xcvr_set_int_seq4                                             = "set_int_seq4"                                                                 ,//"set_int_seq4"
	parameter          hssi_xcvr_set_int_seq5                                             = "set_int_seq5"                                                                 ,//"set_int_seq5"
	parameter          hssi_xcvr_set_int_seq6                                             = "set_int_seq6"                                                                 ,//"set_int_seq6"
	parameter          hssi_xcvr_set_int_seq7                                             = "set_int_seq7"                                                                 ,//"set_int_seq7"
	parameter          hssi_xcvr_set_int_seq8                                             = "set_int_seq8"                                                                 ,//"set_int_seq8"
	parameter          hssi_xcvr_set_int_seq9                                             = "set_int_seq9"                                                                 ,//"set_int_seq9"
	parameter          hssi_xcvr_set_int_seq10                                            = "set_int_seq10"                                                                ,//"set_int_seq10"
	parameter          hssi_xcvr_set_int_seq11                                            = "set_int_seq11"                                                                ,//"set_int_seq11"
	parameter          hssi_xcvr_set_int_seq12                                            = "set_int_seq12"                                                                ,//"set_int_seq12"
	parameter          hssi_xcvr_set_int_seq13                                            = "set_int_seq13"                                                                ,//"set_int_seq13"
	parameter [15:0]   hssi_xcvr_set_int_seq14_code                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq14_data                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq15_code                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq15_data                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq16_code                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq16_data                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq17_code                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq17_data                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq18_code                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq18_data                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq19_code                                       = 16'd0                                                                          ,//0:65535
	parameter [15:0]   hssi_xcvr_set_int_seq19_data                                       = 16'd0                                                                          ,//0:65535
	parameter          hssi_xcvr_set_refclk_scratch0                                      = "i_refclk0"                                                                    ,//"i_refclk0" "i_refclk1" "i_refclk10" "i_refclk11" "i_refclk12" "i_refclk13" "i_refclk14" "i_refclk15" "i_refclk2" "i_refclk3" "i_refclk4" "i_refclk5" "i_refclk6" "i_refclk7" "i_refclk8" "i_refclk9"
	parameter          hssi_xcvr_set_refclk_scratch1                                      = "i_refclk0"                                                                    ,//"i_refclk0" "i_refclk1" "i_refclk10" "i_refclk11" "i_refclk12" "i_refclk13" "i_refclk14" "i_refclk15" "i_refclk2" "i_refclk3" "i_refclk4" "i_refclk5" "i_refclk6" "i_refclk7" "i_refclk8" "i_refclk9"
	parameter          hssi_xcvr_set_refclk_scratch2                                      = "i_refclk0"                                                                    ,//"i_refclk0" "i_refclk1" "i_refclk10" "i_refclk11" "i_refclk12" "i_refclk13" "i_refclk14" "i_refclk15" "i_refclk2" "i_refclk3" "i_refclk4" "i_refclk5" "i_refclk6" "i_refclk7" "i_refclk8" "i_refclk9"
	parameter          hssi_xcvr_set_refclk_scratch3                                      = "i_refclk0"                                                                    ,//"i_refclk0" "i_refclk1" "i_refclk10" "i_refclk11" "i_refclk12" "i_refclk13" "i_refclk14" "i_refclk15" "i_refclk2" "i_refclk3" "i_refclk4" "i_refclk5" "i_refclk6" "i_refclk7" "i_refclk8" "i_refclk9"
	parameter          hssi_xcvr_set_refclk_scratch4                                      = "i_refclk0"                                                                    ,//"i_refclk0" "i_refclk1" "i_refclk10" "i_refclk11" "i_refclk12" "i_refclk13" "i_refclk14" "i_refclk15" "i_refclk2" "i_refclk3" "i_refclk4" "i_refclk5" "i_refclk6" "i_refclk7" "i_refclk8" "i_refclk9"
	parameter          hssi_xcvr_sh_location                                              = "tx_sh_location_1_0"                                                           ,//"tx_sh_location_1_0" "tx_sh_location_65_64"
	parameter          hssi_xcvr_silicon_rev                                              = "14nm5bcr3a"                                                                   ,//"10nmacr3a" "14nm2acr3a" "14nm1acr3a" "14nm0acr3a" "14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
	parameter          hssi_xcvr_soft_reset_rx                                            = "dis_sft_rst_rx"                                                               ,//"dis_sft_rst_rx" "en_sft_rst_rx"
	parameter          hssi_xcvr_soft_reset_tx                                            = "dis_sft_rst_tx"                                                               ,//"dis_sft_rst_tx" "en_sft_rst_tx"
	parameter          hssi_xcvr_sup_mode                                                 = "user_mode"                                                                    ,//"engineering_mode" "user_mode"
	parameter          hssi_xcvr_topology                                                 = "disabled_block"                                                               ,//"dirfec_100g" "dirfec_1ch" "dirfec_2ch" "dirfec_3ch" "dirfec_4ch" "dir_kpfec_100g" "disabled_block" "disabled_system" "ehip_2ch" "ehip_2ch_ptp" "ehip_4ch" "ehip_4ch_fec" "ehip_4ch_kpfec" "ehip_4ch_ptp" "ehip_4ch_ptp_fec" "elane_1ch" "elane_1ch_fec" "elane_1ch_ptp" "elane_1ch_ptp_fec" "elane_2ch_fec" "elane_2ch_ptp" "elane_2ch_ptp_fec" "elane_3ch_fec" "elane_3ch_ptp" "elane_3ch_ptp_fec" "elane_4ch_fec" "elane_4ch_ptp" "elane_4ch_ptp_fec" "pcs_gearbox_ch" "pmadir_1ch" "pmadir_2ch" "pmadir_pllch" "pmadir_refclkch" "ptp_pllch" "rsvd_topo1" "rsvd_topo2" "rsvd_topo3" "rsvd_topo4" "rsvd_topo5"
	parameter          hssi_xcvr_tx_adapt_order_sel                                       = "tx_adapt_order_sel_0"                                                         ,//"tx_adapt_order_sel_0" "tx_adapt_order_sel_1"
	parameter          hssi_xcvr_tx_bitslip                                               = "dis_tx_user_bitslip"                                                          ,//"dis_tx_user_bitslip" "en_tx_user_bitslip"
	parameter          hssi_xcvr_tx_clk_dp_sel                                            = "tx_clk_dp_sel_0"                                                              ,//"tx_clk_dp_sel_0" "tx_clk_dp_sel_1"
	parameter          hssi_xcvr_tx_data_in_sel                                           = "tx_data_in_sel_0"                                                             ,//"tx_data_in_sel_0" "tx_data_in_sel_1" "tx_data_in_sel_2" "tx_data_in_sel_3" "tx_data_in_sel_4"
	parameter          hssi_xcvr_tx_datarate_bps                                          = "1"                                                                            ,//NOVAL
	parameter          hssi_xcvr_tx_det_latency_en                                        = "tx_det_dis"                                                                   ,//"tx_det_dis" "tx_det_en"
	parameter          hssi_xcvr_tx_gb_idwidth                                            = "tx_gb_idwidth_66b"                                                            ,//"tx_gb_idwidth_32b" "tx_gb_idwidth_40b" "tx_gb_idwidth_50b" "tx_gb_idwidth_64b" "tx_gb_idwidth_66b" "tx_gb_idwidth_67b"
	parameter          hssi_xcvr_tx_gb_mode                                               = "tx_gb_66_64"                                                                  ,//"tx_gb_32_32" "tx_gb_40_40" "tx_gb_64_32" "tx_gb_64_64" "tx_gb_66_64" "tx_gb_67_64"
	parameter          hssi_xcvr_tx_gb_odwidth                                            = "tx_gb_odwidth_64b"                                                            ,//"tx_gb_odwidth_32b" "tx_gb_odwidth_40b" "tx_gb_odwidth_64b"
	parameter          l_hssi_xcvr_tx_if_slv_bonding_config                               = "dis_tx_if_slv_bonding_config"                                                 ,//"dis_tx_if_slv_bonding_config" "en_tx_if_slv_bonding_config"
	parameter          hssi_xcvr_tx_interleave_mode                                       = "tx_il_disable"                                                                ,//"tx_il_disable" "tx_il_enable"
	parameter          hssi_xcvr_tx_pma_width                                             = "tx_width_16"                                                                  ,//"tx_width_16" "tx_width_20" "tx_width_32" "tx_width_40" "tx_width_64"
	parameter          hssi_xcvr_tx_pma_width_sd                                          = "1"                                                                            ,//NOVAL
	parameter          hssi_xcvr_tx_refclk_freq                                           = "125"                                                                          ,//NOVAL
	parameter          hssi_xcvr_tx_reset_val_31_0                                        = "0"                                                                            ,//NOVAL
	parameter          hssi_xcvr_tx_reset_val_63_32                                       = "0"                                                                            ,//NOVAL
	parameter [2:0]    hssi_xcvr_tx_reset_val_66_64                                       = 3'd0                                                                           ,//0:7
	parameter          hssi_xcvr_tx_width_adapt                                           = "tx_width_adp_dis"                                                             ,//"tx_width_adp_dis" "tx_width_adp_en"
	parameter [4:0]    hssi_xcvr_txfifo_ae_thld                                           = 5'd0                                                                           ,//0:31
	parameter [4:0]    hssi_xcvr_txfifo_af_thld                                           = 5'd0                                                                           ,//0:31
	parameter [4:0]    hssi_xcvr_txfifo_e_thld                                            = 5'd0                                                                           ,//0:31
	parameter [4:0]    hssi_xcvr_txfifo_f_thld                                            = 5'd0                                                                           ,//0:31
	parameter          hssi_xcvr_txfifo_ph_comp                                           = "dis_ph_comp"                                                                  ,//"dis_ph_comp" "en_ph_comp_2r" "en_ph_comp_3r" "en_ph_comp_4r"
	parameter          hssi_xcvr_txfifo_rd_empty                                          = "prevent_rd_tx_fifo_empty"                                                     ,//"allow_rd_tx_fifo_empty" "prevent_rd_tx_fifo_empty"
	parameter          hssi_xcvr_txfifo_wr_full                                           = "prevent_wr_tx_fifo_full"                                                      ,//"allow_wr_tx_fifo_full" "prevent_wr_tx_fifo_full"
	parameter          hssi_xcvr_xcvr_spare_ctrl0                                         = "0"                                                                            ,//NOVAL
	parameter          hssi_xcvr_xcvr_spare_ctrl1                                         = "0"                                                                            ,//NOVAL
	parameter          hssi_xcvr_is_dyn_reconfigurable                                    = "false"
  ) (
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_serial_data,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_serial_data,
	// parallel data ports
	/*TODO - Added*/ input	wire	[l_channels*80-1:0]	tx_parallel_data,		// PCS TX parallel data interface
	/*TODO - Added*/ output	wire	[l_channels*80-1:0]	rx_parallel_data,		// PCS RX parallel data interface
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_transfer_ready,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_transfer_ready,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	osc_transfer_en,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_fifo_ready,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_fifo_ready,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_dll_lock,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_pma_ready,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_pma_ready,
	/*TODO - Added*/ input	wire			            rsfec_reset,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_is_lockedtodata,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_pma_clkslip,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	tx_pma_en,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_pma_en,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_pma_elecidle,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	pma_initialized,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_pmaif_fifo_underflow,
	/*TODO - Added*/ input	wire	[l_channels*7-1:0]	tx_pmaif_bitslip,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_pmaif_bitslip,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	tx_coreclkin,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_coreclkin,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	tx_coreclkin2,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_clkout,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_clkout2,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_clkout_hioint,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_clkout2_hioint,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_clkout,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_clkout2,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_clkout_hioint,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_clkout2_hioint,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_fifo_full,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_fifo_empty,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_fifo_full,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_fifo_empty,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_pcs_fifo_full,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_pcs_fifo_empty,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_pcs_fifo_full,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_pcs_fifo_empty,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	tx_pmaif_reset,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_pmaif_reset,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	enh_reset,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	enh_reset_stat,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	enh_ready,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	enh_pld_ready,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	tx_enh_reset,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_enh_reset_stat,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_enh_reset,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_enh_reset_stat,
	/*TODO - Added*/ input	wire			            tx_rsfec_reset,
	/*TODO - Added*/ input	wire			            rx_rsfec_reset,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	tx_aib_reset,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_aib_reset,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	enh_force_rcfg_reset,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	enh_initialized,
	/*TODO - Added*/ input	wire	[l_channels*8-1:0]	tx_enh_pfc,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	tx_enh_pause,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_enh_aligned,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_enh_blk_lock,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_enh_highber,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_enh_signal_ok,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_enh_local_fault,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_enh_remote_fault,
	/*TODO - Added*/ output	wire	[l_channels*8-1:0]	rx_enh_pfc,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_enh_pause,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_enh_pmaif_fifo_overflow,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_enh_pmaif_fifo_almost_full,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_enh_pmaif_fifo_almost_empty,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_enh_pmaif_fifo_overflow,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_enh_pmaif_fifo_underflow,
/*<TODO: Changed [0:0] -> []	*/    input	wire	[0:0]	pll_refclk0,
/*<TODO: Changed [0:0] -> []	*/    input	wire	[0:0]	pll_refclk1,
/*<TODO: Changed [0:0] -> []	*/    input	wire	[0:0]	pll_refclk2,
/*<TODO: Changed [0:0] -> []	*/    input	wire	[0:0]	pll_refclk3,
/*<TODO: Changed [0:0] -> []	*/    input	wire	[0:0]	pll_refclk4,
	/*TODO - Added*/ input 	wire	[l_num_channels-1:0]	pma_reset,
	/*TODO - Added*/ input 	wire	[l_num_channels-1:0]	spico_reset,
	/*TODO - Added*/ input	wire	[l_num_channels-1:0]	reset,
	/*TODO - Added*/ input	wire	[l_num_channels-1:0]	tx_reset,
	/*TODO - Added*/ input	wire	[l_num_channels-1:0]	rx_reset,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	tx_ready,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	rx_ready,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	tx_reset_timeout,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	rx_reset_timeout,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	tx_reset_stat,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	rx_reset_stat,
	/*TODO - Added*/ input	wire	[l_num_channels-1:0]	tx_reset_req,
	/*TODO - Added*/ input	wire	[l_num_channels-1:0]	rx_reset_req,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	tx_reset_ack,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	rx_reset_ack,
	/*TODO - Added*/ output	wire	[l_num_channels-1:0]	rx_dskw_ready,

	// Reconfiguration ports for the xcvr
/*<TODO: Changed [(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0] -> [l_rcfg_ifaces]	*/    input	 wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0]	reconfig_clk,
/*<TODO: Changed [(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0] -> [l_rcfg_ifaces]	*/    input	 wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0]	reconfig_reset,
/*<TODO: Changed [(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0] -> [l_rcfg_ifaces]	*/    input	 wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0]	reconfig_write,
/*<TODO: Changed [(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0] -> [l_rcfg_ifaces]	*/    input	 wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0]	reconfig_read,
/*<TODO: Changed [(rcfg_enable&&rcfg_shared ? (19+altera_xcvr_native_s10_functions_h::clogb2_alt_xcvr_native_s10(l_channels-1)) : (19*l_channels))-1:0] -> [l_rcfg_ifaces*l_rcfg_addr_bits]	*/    input	 wire	[(rcfg_enable&&rcfg_shared ? (19+altera_xcvr_native_s10_functions_h::clogb2_alt_xcvr_native_s10(l_channels-1)) : (19*l_channels))-1:0]	reconfig_address,
/*<TODO: Changed [(rcfg_enable&&rcfg_shared ? 1 : l_channels)*8-1:0] -> [l_rcfg_ifaces*8-1:0]	*/    input	 wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)*8-1:0]	reconfig_writedata,
/*<TODO: Changed [(rcfg_enable&&rcfg_shared ? 1 : l_channels)*8-1:0] -> [l_rcfg_ifaces*8-1:0]	*/    output wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)*8-1:0]	reconfig_readdata,
/*<TODO: Changed [(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0] -> [l_rcfg_ifaces]	*/    output wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)-1:0]	reconfig_waitrequest,

  // Reconfiguration ports for rsfec
/*<TODO: Changed [] -> [(rcfg_enable&&rcfg_shared ? 1 : channels)-1:0]	*/ input	 wire	        reconfig_rsfec_clk,
/*<TODO: Changed [] -> [(rcfg_enable&&rcfg_shared ? 1 : channels)-1:0]	*/ input	 wire	        reconfig_rsfec_reset,
/*<TODO: Changed [] -> [(rcfg_enable&&rcfg_shared ? 1 : channels)-1:0]	*/ input	 wire	        reconfig_rsfec_write,
/*<TODO: Changed [] -> [(rcfg_enable&&rcfg_shared ? 1 : channels)-1:0]	*/ input	 wire	        reconfig_rsfec_read,
/*<TODO: Changed [10:0] -> []	*/   input	 wire	[10:0]	reconfig_rsfec_address,
/*<TODO: Changed [7:0] -> [31:0]	*/     input	 wire	[7:0]  reconfig_rsfec_writedata,
/*<TODO: Changed [7:0] -> [31:0]	*/     output wire	[7:0]  reconfig_rsfec_readdata,
/*<TODO: Changed [] -> [(rcfg_enable&&rcfg_shared ? 1 : channels)-1:0]	*/ output wire	        reconfig_rsfec_waitrequest,

	/*TODO - Added*/ input	wire	[l_channels-1:0]	enh_clear_internal_error,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	enh_internal_error,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_aib_tx_transfer_div2_clk,
	/*TODO - Added*/ output	wire	[l_channels*78-1:0]	ehip_aib_tx_sync_data,
	/*TODO - Added*/ output	wire	[l_channels*3-1:0]	ehip_aib_aib_status,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	aib_ehip_rx_ehip_fr_clk,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	aib_ehip_rx_fec_fr_clk,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	aib_ehip_tx_ehip_clk,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	aib_ehip_rx_ehip_clk,
	/*TODO - Added*/ input	wire	[l_channels*78-1:0]	aib_ehip_rx_sync_data,
	/*TODO - Added*/ input	wire	[l_channels*4-1:0]	hip_aib_fsr_in,
	/*TODO - Added*/ input	wire	[l_channels*40-1:0]	hip_aib_ssr_in,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_pma_tx_pma_clk,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	pma_ehip_rx_ehip_fifo_rst_n,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	elane_ehip_shared_clk,
	/*TODO - Added*/ input	wire	[l_channels*2-1:0]	elane_ehip_ptp_mac_tx_fp,
	/*TODO - Added*/ input	wire	[l_channels*24-1:0]	elane_ehip_ptp_mac_ts,
	/*TODO - Added*/ input	wire	[l_channels*3-1:0]	elane_ehip_ptp_mac_ins_type,
	/*TODO - Added*/ input	wire	[l_channels*3-1:0]	elane_ehip_ptp_mac_byte_offset,
	/*TODO - Added*/ input	wire	[l_channels*2-1:0]	elane_ehip_ptp_deskewed_tx_fp,
	/*TODO - Added*/ input	wire	[l_channels*24-1:0]	elane_ehip_ptp_deskewed_ts,
	/*TODO - Added*/ input	wire	[l_channels*3-1:0]	elane_ehip_ptp_deskewed_ins_type,
	/*TODO - Added*/ input	wire	[l_channels*3-1:0]	elane_ehip_ptp_deskewed_byte_offset,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	elane_ehip_ptp_lane_deskew_got_marker,
	/*TODO - Added*/ input	wire	[l_channels*6-1:0]	elane_ehip_ptp_lane_deskew_tap_sel_one_hot,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	elane_ehip_ptp_lane_deskew_deskew_marker,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_elane_ptp_tx_ts_valid,
	/*TODO - Added*/ output	wire	[l_channels*12-1:0]	ehip_elane_ptp_tx_ts,
	/*TODO - Added*/ output	wire	[l_channels*2-1:0]	ehip_elane_ptp_tx_ts_fp,
	/*TODO - Added*/ output	wire	[l_channels*23-1:0]	ehip_elane_rx_ptp_ts,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_elane_ptp_fifo_share_wr_en,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_elane_ptp_fifo_share_rd_en,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_elane_shared_dsk_done,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_elane_shared_clear,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_elane_am_insert,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_elane_am_detect,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_serial_data_n,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_serial_data_n,
	/*TODO - Added*/ output	wire	[31:0]	o_rsfec_channel_ssr,
    /*TODO - Added*/ input	wire	i_rsfec_pld_ready,
	/*TODO - Added*/ input	wire	[3:0]	rsfec_signal_ok,
    /*TODO - Added*/ input	wire	rsfec_usr_avmm2_rst,
    /*TODO - Added*/ output	wire	rsfec_o_config_done,
    /*TODO - Added*/ output	wire	rsfec_o_fec_ready,
    /*TODO - Added*/ output	wire	rsfec_o_status_rx_not_align,
    /*TODO - Added*/ output	wire	rsfec_o_status_rx_not_deskew,
    /*TODO - Added*/ output	wire	rsfec_o_tx_dsk_valid,
	/*TODO - Added*/ output	wire	[l_channels*66-1:0]	ehip_pmaRsfec_fec_rx_data,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_pmaRsfec_fec_rx_data_valid,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	ehip_pmaRsfec_fec_rx_data_am_valid,
	/*TODO - Added*/ input	wire	[l_channels*66-1:0]	pmaRsfec_ehip_tx_ehip_data,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	pmaRsfec_ehip_tx_ehip_dv,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	pmaRsfec_ehip_tx_ehip_fifo_rst_n,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	pmaRsfec_ehip_tx_ehip_data_am_valid_in,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	RSFEC_ehip_tx_adpt_clock,

    /*JRJ - Added for Fogbugz case 517233.  TODO: go back and add this connection in to interface.xls
      This interface has been added to interface.xls in changelist 5022251*/
                     output wire    [l_channels-1:0]     EHIP_out_o_xcvrif_aib_fsr_out,
    /*Add above connection to interface.xls - done*/

	/*TODO - Added*/ input	wire		RSFEC_ehip_clock,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	pma_ehip_tx_ehip_clk_div2,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	pma_ehip_rx_ehip_clk_div2,
	/*TODO - Added*/ output	wire		rsfec_o_internal_error,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_fifo_pfull,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_fifo_pempty,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_fifo_pfull,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_fifo_pempty,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_fifo_rd_en,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	tx_dl_async_pulse,
	/*TODO - Added*/ output	wire	[l_channels-1:0]	rx_dl_async_pulse,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	latency_sclk,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	tx_dl_measure_sel,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_dl_measure_sel,
	/*TODO - Added*/ input	wire	[l_channels-1:0]	rx_fifo_latency_adj_ena,
	// /*TODO - Removed*/	/*TODO - Added*/ input	wire        rsfec_avmm2_avmmclk_in,
	// /*TODO - Removed*/	/*TODO - Added*/ input	wire		rsfec_avmm2_avmmread_in,
	// /*TODO - Removed*/	/*TODO - Added*/ input	wire		rsfec_avmm2_avmmrequest_in,
	// /*TODO - Removed*/	/*TODO - Added*/ input	wire		rsfec_avmm2_avmmwrite_in,
/*<TODO: Changed [] -> [NOVAL]	*/    output	wire		rcp_load_finish,
/*<TODO: Changed [] -> [NOVAL]	*/    output	wire		rcp_load_timeout
);


//REFCLK DIV2

//END OF REFCLK DIV2


// Localparams
// AVMM data and address bus widths
localparam RSFEC_RCFG_ADDR_BITS  = 11;
localparam RCFG_ADDR_BITS        = 19; //{[18]: soft_csr; [17:10]: elane; [9:0]: channel} , reduce 1bit address due to ADME limit,adding a hard-coded "0" for hardware
localparam AVMM_WDATA_WIDTH      = 8;
localparam AVMM_RDATA_WIDTH      = 8;
localparam AVMM_CHNL_ADDR_WIDTH  = 10;
localparam AVMM_ELANE_START_BIT  = 10;
localparam AVMM_ELANE_WIDTH      = 8; //MSB is always "0", doing tie-off


// TODO - is_dual_channel need to be resolved before its used pulled from line 1737
localparam is_dual_channel_dir = (l_pma_func_mode == "pma_dir_dc_mst") ? 1 : 0;
localparam is_dual_channel_fec = (l_pma_func_mode == "rsfec_dc_mst") ? 1 : 0;
localparam is_dual_channel     = (is_dual_channel_dir || is_dual_channel_fec) ? 1 : 0;

//***************************************************************************
//************* Embedded JTAG, AVMM and Embedded Streamer Expansion *********
// Slave map for the ADME
localparam  temp_hssi_xcvr_serdes_tx_enc = (hssi_xcvr_serdes_tx_enc=="tx_nrz") ? "nrz" : ( (hssi_xcvr_serdes_tx_enc=="tx_pam4") ? "pam4" : "nrz");
localparam  temp_hssi_xcvr_serdes_rx_enc = (hssi_xcvr_serdes_rx_enc=="rx_nrz") ? "nrz" : ( (hssi_xcvr_serdes_rx_enc=="rx_pam4") ? "pam4" : "nrz");
localparam  lcl_adme_assgn_map       = {" assignments {dataRate ",adme_data_rate," protMode ",adme_prot_mode," device_revision ",device_revision," tx_line_encoding ",temp_hssi_xcvr_serdes_tx_enc," rx_line_encoding ",temp_hssi_xcvr_serdes_rx_enc," tx_data_rate ",hssi_xcvr_tx_datarate_bps," rx_data_rate ",hssi_xcvr_rx_datarate_bps,"}"};
localparam  lcl_rsfec_adme_assgn_map = {" assignments {dataRate ",adme_data_rate," protMode ",adme_prot_mode," device_revision ",device_revision," tx_line_encoding ",temp_hssi_xcvr_serdes_tx_enc," rx_line_encoding ",temp_hssi_xcvr_serdes_rx_enc," tx_data_rate ",hssi_xcvr_tx_datarate_bps," rx_data_rate ",hssi_xcvr_rx_datarate_bps,"}"};

// Wires for resets
wire [l_channels-1:0]	int_tx_pmaif_reset;
wire [l_channels-1:0]	int_rx_pmaif_reset;
wire [l_channels-1:0]	int_tx_aib_reset;
wire [l_channels-1:0]	int_rx_aib_reset;
wire [l_channels-1:0]	tx_ready_csr;
wire [l_channels-1:0]	rx_ready_csr;
wire [l_num_channels-1:0]	int_pma_reset;
wire [l_num_channels-1:0]	int_spico_reset;

assign int_pma_reset	= (enable_pma_reset == 1) ? pma_reset : {(l_num_channels){1'b0}};
assign int_spico_reset	= (enable_spico_reset == 1) ? spico_reset : {(l_num_channels){1'b0}};

//***************************************************************************
//************* RSFEC Instantiation Parameter *******************************
//***************************************************************************
// This local parameter is used as a conditional for instantiation of the RSFEC block.  It can
// be replaced by a dynamic conditional if conditional instantiation of the RSFEC block is
// required in the future.
// Until the fitter works for the RSFEC, we will not instantiate it if it's not used
// localparam  lcl_instantiate_RSFEC_block = 1'b1;
localparam  lcl_instantiate_RSFEC_block = l_rsfec_enable;

// AVMM reconfiguration interface signals
wire [l_channels-1:0]                        avmm_clk;
wire [l_channels-1:0]                        avmm_reset;
wire [l_channels-1:0]                        avmm_write;
wire [l_channels-1:0]                        avmm_read;
wire [l_channels-1:0]                        avmm_waitrequest;
wire [l_channels*RCFG_ADDR_BITS-1:0]         avmm_address;
wire [l_channels*AVMM_WDATA_WIDTH-1:0]       avmm_writedata;
wire [l_channels*AVMM_RDATA_WIDTH-1:0]       avmm_readdata;

// AVMM2 RSFEC reconfiguration interface signals
wire                                         arb_avmm_clk;
wire                                         arb_avmm_reset;
wire                                         arb_avmm_write;
wire                                         arb_avmm_read;
wire                                         arb_avmm_waitrequest;
wire  [RSFEC_RCFG_ADDR_BITS-1:0]             arb_avmm_address;
wire  [AVMM_WDATA_WIDTH-1:0]                 arb_avmm_writedata;
wire  [AVMM_RDATA_WIDTH-1:0]                 arb_avmm_readdata;

wire                                         avmm_rsfec_clk;
wire                                         avmm_rsfec_reset;
wire                                         avmm_rsfec_write;
wire                                         avmm_rsfec_read;
wire                                         avmm_rsfec_waitrequest;
wire  [RSFEC_RCFG_ADDR_BITS-1:0]             avmm_rsfec_address;
wire  [AVMM_WDATA_WIDTH-1:0]                 avmm_rsfec_writedata;
wire  [AVMM_RDATA_WIDTH-1:0]                 avmm_rsfec_readdata;

// Wires from the rcfg_opt_logic to the periphery
wire [l_channels-1:0]   int_rx_pmaif_reset_csr;
wire [l_channels-1:0]   int_rx_aib_reset_csr;
wire [l_channels-1:0]   int_tx_pmaif_reset_csr;
wire [l_channels-1:0]   int_tx_aib_reset_csr;

// Scan test wires
wire                    int_adapter_clk_sel_n;
wire                    int_adapter_scan_mode_n;
wire                    int_adapter_scan_shift_n;

//Wires for ical IP.
wire 	int_rcp_load_finish;
wire 	int_rcp_load_timeout;

assign rcp_load_finish      =    int_rcp_load_finish;
assign rcp_load_timeout     =    int_rcp_load_timeout;


// TODO - Resolve this with helen
//assign int_tx_release_aib_first =  enable_rcfg_tx_digitalreset_release_ctrl ? rcfg_tx_digitalreset_release_ctrl
//									                : l_release_aib_reset_first ? 1'b1 : 1'b0;

// Ensure scan settings are tied off but disabled
assign int_adapter_clk_sel_n    = 1'b1;
assign int_adapter_scan_mode_n  = 1'b1;
assign int_adapter_scan_shift_n = 1'b1;


wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)*32-1:0]	int_reconfig_writedata;
wire	[(rcfg_enable&&rcfg_shared ? 1 : l_channels)*32-1:0]	int_reconfig_readdata;
logic	[31:0]	int_reconfig_rsfec_writedata;
logic	[31:0]	int_reconfig_rsfec_readdata;

// rx de-skew error status csr
wire [l_channels-1:0]    rx_dskw_min_mkr_csr;


//***************************************************************************
//************* Embedded JTAG, AVMM and Embedded Streamer Expansion *********
alt_xcvr_native_rcfg_opt_logic_isub23q #(
  .dbg_user_identifier                            ( dbg_user_identifier                 ),
  .duplex_mode                                    ( "duplex"                            ),
  .dbg_embedded_debug_enable                      ( dbg_embedded_debug_enable           ),
  .dbg_capability_reg_enable                      ( dbg_capability_reg_enable           ),
  .dbg_stat_soft_logic_enable                     ( dbg_stat_soft_logic_enable          ),
  .dbg_ctrl_soft_logic_enable                     ( dbg_ctrl_soft_logic_enable          ),
  .CHANNELS                                       ( l_channels                          ),
  .DUAL_CHANNELS                                  ( l_num_channels                      ),
  .is_dual_channel                                (is_dual_channel                   ),
  .ADDR_BITS                                      ( RCFG_ADDR_BITS                      ),
  .ADME_SLAVE_MAP                                 ( "altera_xcvr_native_s10_etile"      ),
  .ADME_ASSGN_MAP                                 ( lcl_adme_assgn_map                  ),
  .RECONFIG_SHARED                                ( rcfg_enable && rcfg_shared          ),
  .JTAG_ENABLED                                   ( rcfg_enable && rcfg_jtag_enable     ),
  .RCFG_EMB_STRM_ENABLED                          ( rcfg_enable && rcfg_emb_strm_enable ),
  .RCFG_PROFILE_CNT                               ( rcfg_profile_cnt                    ),
  .RCP_LOAD_ENABLE                                ( rcp_load_enable                     ),
  .ENABLE_PMA_RESET                               ( enable_pma_reset                    )
) alt_xcvr_native_optional_rcfg_logic (
  // User reconfig interface ports
  .reconfig_clk                                   ( reconfig_clk                        ),
  .reconfig_reset                                 ( reconfig_reset                      ),
  .reconfig_write                                 ( reconfig_write                      ),
  .reconfig_read                                  ( reconfig_read                       ),
  .reconfig_address                               ( reconfig_address                    ),
  .reconfig_writedata                             ( int_reconfig_writedata                  ),
  .reconfig_readdata                              ( int_reconfig_readdata                   ),
  .reconfig_waitrequest                           ( reconfig_waitrequest                ),

  // AVMM ports to transceiver
  .avmm_clk                                       ( avmm_clk                            ),
  .avmm_reset                                     ( avmm_reset                          ),
  .avmm_write                                     ( avmm_write                          ),
  .avmm_read                                      ( avmm_read                           ),
  .avmm_address                                   ( avmm_address                        ),
  .avmm_writedata                                 ( avmm_writedata                      ),
  .avmm_readdata                                  ( avmm_readdata                       ),
  .avmm_waitrequest                               ( avmm_waitrequest                    ),

  // input status signals from the transceiver
  .in_tx_pma_ready                                ( tx_pma_ready                        ),
  .in_rx_pma_ready                                ( rx_pma_ready                        ),
  .in_rx_is_lockedtodata                          ( rx_is_lockedtodata                  ),
  .in_tx_transfer_ready                           ( tx_transfer_ready                   ),
  .in_rx_transfer_ready                           ( rx_transfer_ready                   ),

  // input reset signals to the transciever
  .in_rx_analogreset                              ( int_rx_pmaif_reset                  ),
  .in_rx_digitalreset                             ( int_rx_aib_reset                    ),
  .in_tx_analogreset                              ( int_tx_pmaif_reset                  ),
  .in_tx_digitalreset                             ( int_tx_aib_reset                    ),

  // Input status from the reset controller
  .in_tx_ready                                    ( tx_ready_csr                        ),
  .in_rx_ready                                    ( rx_ready_csr                        ),

  //pma spico reset inputs
  .pma_reset                                      ( int_pma_reset                       ),
  .spico_reset                                    ( int_spico_reset                     ),

  //inputs from rx de-skew block
  .in_rx_dskw_min_mkr                             ( rx_dskw_min_mkr_csr                 ),

  // output control signals to the phy
  .out_rx_analogreset                             ( int_rx_pmaif_reset_csr              ),
  .out_rx_digitalreset                            ( int_rx_aib_reset_csr                ),
  .out_tx_analogreset                             ( int_tx_pmaif_reset_csr              ),
  .out_tx_digitalreset                            ( int_tx_aib_reset_csr                ),

  //output
  .rcp_load_finish                                    ( int_rcp_load_finish                     ),
  .rcp_load_timeout                                   ( int_rcp_load_timeout                    )
);


//***************** End Embedded JTAG and AVMM Expansion ********************
//***************************************************************************


//***************************************************************************
//************* Datapath connections *******************************************
// Datapath wires
wire [l_channels*80-1:0] int_tx_parallel_data;
wire [l_channels*80-1:0] int_rx_parallel_data;

wire [l_channels*80-1:0] rx_parallel_data_deskew;
wire [l_num_channels-1:0] rx_dskw_min_mkr_temp;

genvar ig;
generate
  if(!(rcfg_enable && rcfg_shared))
    begin : not_shared
      for(ig=0;ig<l_channels;ig=ig+1)
        begin : assign_data_not_shared
          assign int_reconfig_writedata[ig*32 +:32] = {24'd0,reconfig_writedata[ig*8 +:8]};
          assign reconfig_readdata[ig*8 +:8] = int_reconfig_readdata[ig*32 +:8];
        end : assign_data_not_shared
    end : not_shared
  else
    begin: shared
      assign int_reconfig_writedata[0 +:32] = {24'd0,reconfig_writedata[0 +:8]};
      assign reconfig_readdata[0 +:8] = int_reconfig_readdata[0 +:8];
    end : shared
	// TX parallel data
	if (pldif_tx_fast_pipeln_reg_enable) begin
		(* altera_attribute = "-name FORCE_HYPER_REGISTER_FOR_CORE_PERIPHERY_TRANSFER ON" *)
		reg [l_channels*80-1:0] tx_parallel_data_fast_pipeln_reg;

		for(ig=0;ig<l_channels;ig=ig+1) begin : g_tx_fast_pipeln_reg
			always @(posedge tx_coreclkin[ig]) begin
				tx_parallel_data_fast_pipeln_reg[ig*80+:80] <= tx_parallel_data[ig*80+:80];
			end
		end
		assign int_tx_parallel_data = tx_parallel_data_fast_pipeln_reg;
	end else begin
		assign int_tx_parallel_data = tx_parallel_data;
	end

	// RX parallel data
	if (pldif_rx_fast_pipeln_reg_enable) begin
		(* altera_attribute = "-name FORCE_HYPER_REGISTER_FOR_PERIPHERY_CORE_TRANSFER ON" *)
		reg [l_channels*80-1:0] rx_parallel_data_fast_pipeln_reg;

		for(ig=0;ig<l_channels;ig=ig+1) begin : g_rx_fast_pipeln_reg
			always @(posedge rx_coreclkin[ig]) begin
				rx_parallel_data_fast_pipeln_reg[ig*80+:80] <= int_rx_parallel_data[ig*80+:80];
			end
		end
		assign rx_parallel_data_deskew = rx_parallel_data_fast_pipeln_reg;
	end else begin
		assign rx_parallel_data_deskew = int_rx_parallel_data;
	end
endgenerate

//***************************************************************************

generate
  // deskew_pma_only_enable : user enable in GUI
  // is_dual_channel_dir : PAM4 high data rate mode dual channel PMA direct only
   if (deskew_pma_only_enable & is_dual_channel_dir) begin: g_pam4_dual
	for(ig=0;ig<l_channels;ig=ig+2) begin:g_deskew
            altera_xcvr_native_dskw_pam4 #(
            . DOUBLE_WIDTH_SEL             (pldif_rx_double_width_transfer_enable)
            ) altera_xcvr_native_dskw_pam4 (
            .clk                        (rx_coreclkin[ig]), // clock, even channel
            .reset_ev                      (int_rx_aib_reset_csr[ig]), //reset, even channel
            .reset_od                      (int_rx_aib_reset_csr[ig+1]), //reset, odd channel
            .dskw_start                      (rx_ready[ig>>1]), //rx data ready, even channel(master channel)
            .data_in_ln0                   (rx_parallel_data_deskew[ig*80+:80]), //data, even channel
            .data_in_ln1                   (rx_parallel_data_deskew[(ig+1)*80+:80]), //data, odd channel
            .dskw_done                     (rx_dskw_ready[ig>>1]), //rx data ds-skew ready, even channel(master channel)
            .err_status_min_mk             (rx_dskw_min_mkr_temp[ig>>1]),
            .dout_ln0                      (rx_parallel_data[ig*80+:80]),
            .dout_ln1                      (rx_parallel_data[(ig+1)*80+:80])
            );

       assign rx_dskw_min_mkr_csr[ig+1:ig] = {2{rx_dskw_min_mkr_temp[ig>>1]}};

        end
   end else begin
       assign rx_parallel_data = rx_parallel_data_deskew;
       assign rx_dskw_min_mkr_csr = {(l_channels){1'b0}};
       assign rx_dskw_ready = {(l_num_channels){1'b0}};

   end


endgenerate

//***************************************************************************




//***************** End Datapath connections ***********************************
//******************************************************************************

wire [3:0]  int_hip_aib_fsr_in [l_channels-1:0];
wire [39:0] int_hip_aib_ssr_in [l_channels-1:0];

//******************************************************************************
//******************* Dual Channel connections *********************************
	//************
	// Dual Channel Connections
	//************
        wire [l_channels-1:0]       l_in_rx_ch0_dskw_pulse;
        wire [l_channels-1:0]       l_in_rx_ch0_clk;
        wire [l_channels-1:0]       l_in_tx_ch0_clk;
        wire [l_channels-1:0]       l_out_rx_deskew_pulse;
        wire [l_channels-1:0]       l_out_rx_fifo_clk;
        wire [l_channels-1:0]       l_out_tx_ch0_clk;
        wire [31:0]                 l_in_rx_ch0_in [l_channels-1:0];
        wire [31:0]                 l_in_rx_multi_ln_inter [l_channels-1:0];
        wire [31:0]                 l_out_tx_ml_inter [l_channels-1:0];
        wire [31:0]                 l_out_tx_multi_ln_data [l_channels-1:0];
        wire [79:0]                 l_out_rx_out [l_channels-1:0];
        wire [31:0]                 l_out_rx_multi_ln_inter [l_channels-1:0];
        wire [31:0]                 l_in_tx_ml_inter [l_channels-1:0];
        wire [31:0]                 l_in_tx_multi_ln_data [l_channels-1:0];



//***************** End Dual Channel connections *******************************
//******************************************************************************


//******************************************************************************
//******************* bonding connections *********************************
wire [l_channels-1:0] l_in_tx_refclk_sync_nrz;
wire [l_channels-1:0] l_in_tx_refclk_sync_pam4;
wire [l_channels-1:0] l_in_tx_bonding_pulse_below;
wire [l_channels-1:0] l_in_tx_bonding_pulse_above;
wire [l_channels-1:0] l_out_tx_refclk_sync_out;
wire [l_channels-1:0] l_out_tx_bonding_pulse_cpy;
wire [l_channels-1:0] l_out_tx_bonding_pulse_out;
//***************** End bonding connections *******************************
//******************************************************************************


//***************************************************************************
//************* Reset connections & reset sequencer *************************

	// reset wires and parameters
	localparam  CLK_FREQ_IN_MHZ                = 125;
	localparam  DEFAULT_RESET_SEPARATION_NS    = 200;
	localparam  T_RX_LOCKTODATA                = 180000;

	wire			            int_tx_rsfec_reset;
	wire			            int_rx_rsfec_reset;
	wire			            int_rsfec_reset;

	// Add wires to be used for inverting the outputs of the reset sequencer if it is used
    // These wires are all on the FPGA side of the PLD adapter
	wire   		 	   			int_tx_rsfec_reset_reset_seq;
	wire                        int_rx_rsfec_reset_reset_seq;
    wire						int_rsfec_reset_reset_seq;

	wire	[l_num_channels-1:0]	int_dual_tx_pmaif_reset;
	wire	[l_num_channels-1:0]	int_dual_rx_pmaif_reset;
	wire	[l_num_channels-1:0]	int_dual_tx_aib_reset;
	wire	[l_num_channels-1:0]	int_dual_rx_aib_reset;
	wire	[l_num_channels-1:0]	int_tx_transfer_ready;
	wire	[l_num_channels-1:0]	int_rx_transfer_ready;
	wire	[l_num_channels-1:0]	int_tx_pma_ready;
	wire	[l_num_channels-1:0]	int_rx_pma_ready;
	wire	[l_num_channels-1:0]	int_rx_is_lockedtodata;
	wire	[l_num_channels-1:0]	int_tx_ready;
	wire	[l_num_channels-1:0]	int_rx_ready;
	wire	[l_num_channels-1:0]	int_tx_reset_timeout;
	wire	[l_num_channels-1:0]	int_rx_reset_timeout;
	wire	[l_num_channels-1:0]	int_tx_reset_stat;
	wire	[l_num_channels-1:0]	int_rx_reset_stat;
	wire	[l_num_channels-1:0]	int_tx_reset_req;
	wire	[l_num_channels-1:0]	int_rx_reset_req;
	wire	[l_num_channels-1:0]	int_tx_reset_ack;
	wire	[l_num_channels-1:0]	int_rx_reset_ack;
	wire	[l_num_channels-1:0]	int_tx_reset;
	wire	[l_num_channels-1:0]	int_rx_reset;
	wire	[l_num_channels-1:0]	int_reset;
    generate

	// reset sequencer
	if (l_enable_direct_reset_control) begin : g_direct_reset // direct reset
		assign int_tx_pmaif_reset      = tx_pmaif_reset;
		assign int_rx_pmaif_reset      = rx_pmaif_reset;
		assign int_tx_aib_reset        = tx_aib_reset;
		assign int_rx_aib_reset        = rx_aib_reset;

		// Change direct reset inputs to active high.  These inputs will now be active high at the Native PHY level.
		assign int_tx_rsfec_reset      = ~tx_rsfec_reset;
		assign int_rx_rsfec_reset      = ~rx_rsfec_reset;
		assign int_rsfec_reset         = ~rsfec_reset;

		assign tx_ready_csr            = {(l_channels){1'b0}};
		assign rx_ready_csr            = {(l_channels){1'b0}};

	end else begin: g_pma_rsfec_reset //pma direct and rsfec reset
		if (enable_manual_reset) begin: g_manual_reset
			assign int_tx_reset_req      = tx_reset_req;
			assign int_rx_reset_req      = rx_reset_req;
			assign tx_reset_ack          = int_tx_reset_ack;
			assign rx_reset_ack          = int_rx_reset_ack;
            assign tx_ready_csr          = {(l_channels){1'b0}};
            assign rx_ready_csr          = {(l_channels){1'b0}};
			assign int_tx_pmaif_reset    = tx_pmaif_reset;
			assign int_rx_pmaif_reset    = rx_pmaif_reset;
			assign int_tx_aib_reset      = tx_aib_reset;
			assign int_rx_aib_reset      = rx_aib_reset;
			assign int_tx_rsfec_reset    = ~tx_rsfec_reset;
			assign int_rx_rsfec_reset    = ~rx_rsfec_reset;
			assign int_rsfec_reset       = ~rsfec_reset;



			altera_xcvr_reset_top_etile #(
				.NUM_CHANNELS(l_num_channels),
				.REDUCED_RESET_SIM_TIME(reduced_reset_sim_time),
				.ENABLE_MANUAL(1'b1),
				.TX_ENABLE(l_tx_enable),
				.RX_ENABLE(l_rx_enable)
			) reset_ip_manual_etile_inst(
				.tx_reset_req           (int_tx_reset_req),
				.rx_reset_req           (int_rx_reset_req),
				.tx_reset_ack           (int_tx_reset_ack),
				.rx_reset_ack           (int_rx_reset_ack)
				);
			//end manual_reset

		end else begin: g_auto_reset
			if (is_dual_channel) begin : g_pma_dual
				for(ig=0;ig<l_num_channels;ig=ig+1) begin : g_dual_channel_signals
					//inputs
					assign int_tx_transfer_ready[ig]            = tx_transfer_ready[2*ig] & tx_transfer_ready[2*ig+1];
					assign int_rx_transfer_ready[ig]            = rx_transfer_ready[2*ig] & rx_transfer_ready[2*ig+1];
					assign int_tx_pma_ready[ig]                 = tx_pma_ready[2*ig];
					assign int_rx_pma_ready[ig]                 = rx_pma_ready[2*ig];
					assign int_rx_is_lockedtodata[ig]           = rx_is_lockedtodata[2*ig];
					assign int_tx_reset[ig]                     = tx_reset[ig];
					assign int_rx_reset[ig]                     = rx_reset[ig];
					assign int_reset[ig]                        = reset[ig];
					//outputs
					assign int_tx_pmaif_reset[2*ig+1:2*ig]      = {2{int_dual_tx_pmaif_reset[ig]}};
					assign int_rx_pmaif_reset[2*ig+1:2*ig]      = {2{int_dual_rx_pmaif_reset[ig]}};
					assign int_tx_aib_reset[2*ig+1:2*ig]        = {2{int_dual_tx_aib_reset[ig]}};
					assign int_rx_aib_reset[2*ig+1:2*ig]        = {2{int_dual_rx_aib_reset[ig]}};
					assign tx_ready[ig]                         = int_tx_ready[ig];
					assign rx_ready[ig]                         = int_rx_ready[ig];
					assign tx_ready_csr[2*ig+1:2*ig]            = {2{int_tx_ready[ig]}};
					assign rx_ready_csr[2*ig+1:2*ig]            = {2{int_rx_ready[ig]}};
					assign tx_reset_timeout[ig]                 = int_tx_reset_timeout[ig];
					assign rx_reset_timeout[ig]                 = int_rx_reset_timeout[ig];
					assign tx_reset_stat[ig]                    = int_tx_reset_stat[ig];
					assign rx_reset_stat[ig]                    = int_rx_reset_stat[ig];
				end
				// In this mode, there is only an RSFEC block if "is_dual_channel_fec" is true.  If not tie these signals off to 0.  Set to 1'b0 to avoid synthesis warning.
		        assign int_tx_rsfec_reset      = (is_dual_channel_fec) ? ~int_tx_rsfec_reset_reset_seq : 1'b0;
		        assign int_rx_rsfec_reset      = (is_dual_channel_fec) ? ~int_rx_rsfec_reset_reset_seq : 1'b0;
		        assign int_rsfec_reset         = (is_dual_channel_fec) ? ~int_rsfec_reset_reset_seq : 1'b0;
			end else begin : g_pma_single_rsfec_signals
				//inputs
				assign int_tx_reset            = tx_reset;
				assign int_rx_reset            = rx_reset;
				assign int_reset               = reset;
				assign int_tx_pma_ready        = tx_pma_ready;
				assign int_rx_pma_ready        = rx_pma_ready;
				assign int_rx_is_lockedtodata  = rx_is_lockedtodata;
				assign int_tx_transfer_ready   = tx_transfer_ready;
				assign int_rx_transfer_ready   = rx_transfer_ready;
				//outputs
				assign int_tx_pmaif_reset      = int_dual_tx_pmaif_reset;
				assign int_rx_pmaif_reset      = int_dual_rx_pmaif_reset;
				assign int_tx_aib_reset        = int_dual_tx_aib_reset;
				assign int_rx_aib_reset        = int_dual_rx_aib_reset;
				assign tx_ready                = int_tx_ready;
				assign rx_ready                = int_rx_ready;
				assign tx_ready_csr            = int_tx_ready;
				assign rx_ready_csr            = int_rx_ready;
				assign tx_reset_timeout        = int_tx_reset_timeout;
				assign rx_reset_timeout        = int_rx_reset_timeout;
				assign tx_reset_stat           = int_tx_reset_stat;
				assign rx_reset_stat           = int_rx_reset_stat;

				// Invert the outputs of the reset controller for the RSFEC resets
				assign int_tx_rsfec_reset      = ~int_tx_rsfec_reset_reset_seq;
				assign int_rx_rsfec_reset      = ~int_rx_rsfec_reset_reset_seq;
				assign int_rsfec_reset         = ~int_rsfec_reset_reset_seq;

			end

			altera_xcvr_reset_top_etile #(
				.NUM_CHANNELS(l_num_channels),
				.SYS_CLK_IN_MHZ(CLK_FREQ_IN_MHZ),
				.DEFAULT_RESET_SEPARATION_NS(DEFAULT_RESET_SEPARATION_NS),
				.RESET_SEPARATION_NS(reset_separation_ns),
				.SPACE_NS(space_ns),
				.REDUCED_SIM_TIME(reduced_sim_time),
				.REDUCED_RESET_SIM_TIME(reduced_reset_sim_time),
				.ENABLE_IND_TXRX(enable_ind_txrx),
				.ENABLE_IND_CHANNEL(l_enable_ind_channel),
				.ENABLE_MANUAL(1'b0),
				.ENABLE_RSFEC(l_rsfec_enable),
				.ENABLE_SEQ(enable_seq),
				.TX_ENABLE(l_tx_enable),
				.T_TX_RESET(t_tx_reset),
				.RX_ENABLE(l_rx_enable),
				.T_RX_LOCKTODATA(T_RX_LOCKTODATA),
				.T_RX_RESET(t_rx_reset)
			) reset_ip_auto_etile_inst(
				.tx_reset               (int_tx_reset),
				.rx_reset               (int_rx_reset),
				.reset_in               (int_reset),
				.tx_reset_req           ({(l_num_channels){1'b0}}),
				.rx_reset_req           ({(l_num_channels){1'b0}}),
				.tx_reset_ack           (),
				.rx_reset_ack           (),
				.tx_transfer_ready      (int_tx_transfer_ready),
				.rx_transfer_ready      (int_rx_transfer_ready),
				.tx_ready               (int_tx_ready),
				.rx_ready               (int_rx_ready),
				.rx_is_lockedtodata     (int_rx_is_lockedtodata),
				.tx_serdes_rdy          (int_tx_pma_ready),
				.rx_serdes_rdy          (int_rx_pma_ready),
				.tx_reset_timeout       (int_tx_reset_timeout),
				.rx_reset_timeout       (int_rx_reset_timeout),
				.tx_reset_stat          (int_tx_reset_stat   ),
				.rx_reset_stat          (int_rx_reset_stat   ),
				.tx_aib_reset_out       (int_dual_tx_aib_reset),
				.rx_aib_reset_out       (int_dual_rx_aib_reset),
				.tx_xcvrif_reset_out    (int_dual_tx_pmaif_reset),
				.rx_xcvrif_reset_out    (int_dual_rx_pmaif_reset),
				.tx_rsfec_reset_out     (int_tx_rsfec_reset_reset_seq),
				.rx_rsfec_reset_out     (int_rx_rsfec_reset_reset_seq),
				.rsfec_reset_out        (int_rsfec_reset_reset_seq)
				);
		end	//end auto_reset
	end	//end pma_rsfec both manual and auto reset

endgenerate

//***************** End reset connectopms ***********************************
//***************************************************************************

//***************************************************************************
//************* RSFEC & AVMM2 IF ****************************

    localparam  I_O_NUMBER_LANES = 4;
    localparam  TX_DATA_INPUT_WIDTH_PER_LANE = 78;
    localparam  I_EHIP_ELANE_TX_DATA_WIDTH = 312; // TX_DATA_INPUT_WIDTH_PER_LANE * I_O_NUMBER_LANES;
    localparam  EHIP_TX_DATA_INPUT_WIDTH_PER_LANE = 66;
    localparam  EHIP_TX_DATA_VALID_BIT_OFFSET = 67;
    localparam  EHIP_TX_DATA_AM_VALID_BIT_OFFSET = 68;
    localparam  RX_DATA_INPUT_WIDTH_PER_LANE = 66;
    localparam  I_FEC_RX_DATA_WIDTH = 264; //RX_DATA_INPUT_WIDTH_PER_LANE * I_O_NUMBER_LANES;
    localparam  RX_PCS_DATA_INPUT_WIDTH_PER_LANE = 67;
    localparam  I_PCS_RX_DATA_WIDTH = 268; //RX_PCS_DATA_INPUT_WIDTH_PER_LANE * I_O_NUMBER_LANES;
    localparam  I_HIP_AIB_STATUS_WIDTH_PER_LANE = 3;
    localparam  I_HIP_AIB_STATUS_WIDTH = 12; //I_HIP_AIB_STATUS_WIDTH_PER_LANE * I_O_NUMBER_LANES;
    localparam  O_PMA_RX_CW_POS_WIDTH_PER_LANE = 13;
    localparam  O_PMA_RX_CW_POS_WIDTH = 52; //O_PMA_RX_CW_POS_WIDTH_PER_LANE * I_O_NUMBER_LANES;
    localparam  TX_PMA_DATA_OUTPUT_WIDTH_PER_LANE = 66;
    localparam  O_FEC_TX_DATA_WIDTH = 264; //TX_PMA_DATA_OUTPUT_WIDTH_PER_LANE * I_O_NUMBER_LANES;
    localparam  O_FEC_ELANE_RX_DATA_WIDTH_PER_LANE = 78;
    localparam  O_FEC_ELANE_RX_DATA_WIDTH = O_FEC_ELANE_RX_DATA_WIDTH_PER_LANE * I_O_NUMBER_LANES;
    localparam  O_N_FEC_CHNL_SSR_WIDTH = 32;
    localparam  O_FEC_RX_MUX_DATA_WIDTH = 264;
    localparam  O_FEC_PCS_RX_DATA_WIDTH = 268;
    localparam  FEC_LANE_RX_DATA_WIDTH = 66;
    localparam  PCS_LANE_RX_DATA_WIDTH = 67;
    localparam  FEC_LANE_RX_OUT_SEL_WIDTH = 2;

    // This is really clunky but I can't immediately think of another way to do this.  You can't pass parameters or, apparently, strings to SystemVerilog functions.  I could pack the
    // hssi_rsfec_first_lane parameter into a packed array or I could use hw_tcl to convert it.  I will come back and see if there is a cleaner way to do this later.

    localparam ZEROTH_CHANNEL_NUMBER = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? 0 :
								      ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? 1 :
									  ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? 2 :
									  ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? 3 : 0;
    localparam FIRST_UNUSED_CHANNEL_NUMBER = ZEROTH_CHANNEL_NUMBER + l_channels;
    localparam IS_USED_FEC_CHANNEL_3 = (ZEROTH_CHANNEL_NUMBER<=3 && FIRST_UNUSED_CHANNEL_NUMBER>3) ?1:0;
    localparam FEC_CHANNEL_3 = 3-ZEROTH_CHANNEL_NUMBER;

    localparam ZEROTH_CHANNEL_TX_ASSIGNMENT_OFFSET = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? TX_DATA_INPUT_WIDTH_PER_LANE - 1 :
										             ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 2) - 1 :
												     ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 3) - 1 :
												     ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 4) - 1 : 0;

    localparam UNUSED_CHANNEL_TX_TIEOFF_OFFSET = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? 0 :
											     ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 1) - 1 :
											     ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 2) - 1 :
											     ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 3) - 1 : 0;

    localparam UNUSED_CHANNEL_TX_TIEOFF_WIDTH = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? 0 :
											    ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 1) :
											    ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 2) :
											    ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (TX_DATA_INPUT_WIDTH_PER_LANE * 3) : 0;

    localparam LAST_CHANNEL_TX_TIEOFF_OFFSET = (ZEROTH_CHANNEL_TX_ASSIGNMENT_OFFSET + 1) + ((l_channels - 1) * TX_DATA_INPUT_WIDTH_PER_LANE);

    localparam LAST_CHANNEL_TX_TIEOFF_WIDTH = (LAST_CHANNEL_TX_TIEOFF_OFFSET < I_EHIP_ELANE_TX_DATA_WIDTH) ? I_EHIP_ELANE_TX_DATA_WIDTH - LAST_CHANNEL_TX_TIEOFF_OFFSET : 0;

    localparam ZEROTH_CHANNEL_RX_ASSIGNMENT_OFFSET = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? RX_DATA_INPUT_WIDTH_PER_LANE - 1 :
										             ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 2) - 1 :
												     ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 3) - 1 :
												     ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 4) - 1 : 0;

    localparam UNUSED_CHANNEL_RX_TIEOFF_OFFSET = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? 0 :
											     ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 1) - 1 :
											     ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 2) - 1 :
											     ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 3) - 1 : 0;

    localparam UNUSED_CHANNEL_RX_TIEOFF_WIDTH = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? 0 :
											    ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 1) :
											    ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 2) :
											    ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (RX_DATA_INPUT_WIDTH_PER_LANE * 3) : 0;

    localparam LAST_CHANNEL_RX_TIEOFF_OFFSET = (ZEROTH_CHANNEL_RX_ASSIGNMENT_OFFSET + 1) + ((l_channels - 1) * RX_DATA_INPUT_WIDTH_PER_LANE);

    localparam LAST_CHANNEL_RX_TIEOFF_WIDTH = (LAST_CHANNEL_RX_TIEOFF_OFFSET < I_FEC_RX_DATA_WIDTH) ? I_FEC_RX_DATA_WIDTH - LAST_CHANNEL_RX_TIEOFF_OFFSET : 0;

    localparam ZEROTH_CHANNEL_PCS_RX_ASSIGNMENT_OFFSET = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? RX_PCS_DATA_INPUT_WIDTH_PER_LANE - 1 :
										                 ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 2) - 1 :
												         ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 3) - 1 :
												         ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 4) - 1 : 0;

    localparam UNUSED_CHANNEL_PCS_RX_TIEOFF_OFFSET = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? 0 :
											         ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 1) - 1 :
											         ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 2) - 1 :
											         ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 3) - 1 : 0;

    localparam UNUSED_CHANNEL_PCS_RX_TIEOFF_WIDTH = ( hssi_rsfec_first_lane_sel == "first_lane0" ) ? 0 :
											        ( hssi_rsfec_first_lane_sel == "first_lane1" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 1) :
											        ( hssi_rsfec_first_lane_sel == "first_lane2" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 2) :
											        ( hssi_rsfec_first_lane_sel == "first_lane3" ) ? (RX_PCS_DATA_INPUT_WIDTH_PER_LANE * 3) : 0;

    localparam LAST_CHANNEL_PCS_RX_TIEOFF_OFFSET = (ZEROTH_CHANNEL_PCS_RX_ASSIGNMENT_OFFSET + 1) + ((l_channels - 1) * RX_PCS_DATA_INPUT_WIDTH_PER_LANE);

    localparam LAST_CHANNEL_PCS_RX_TIEOFF_WIDTH = (LAST_CHANNEL_PCS_RX_TIEOFF_OFFSET < I_PCS_RX_DATA_WIDTH) ? I_PCS_RX_DATA_WIDTH - LAST_CHANNEL_PCS_RX_TIEOFF_OFFSET : 0;

    localparam ZEROTH_EHIP_STATUS_OFFSET = ((ZEROTH_CHANNEL_NUMBER + 1) * I_HIP_AIB_STATUS_WIDTH_PER_LANE) - 1;

    localparam UNUSED_CHANNEL_EHIP_STATUS_TIEOFF_OFFSET = (ZEROTH_CHANNEL_NUMBER > 0) ? ZEROTH_CHANNEL_NUMBER * I_HIP_AIB_STATUS_WIDTH_PER_LANE - 1 : 0;

    localparam UNUSED_CHANNEL_EHIP_STATUS_TIEOFF_WIDTH = ZEROTH_CHANNEL_NUMBER * I_HIP_AIB_STATUS_WIDTH_PER_LANE;

    localparam LAST_CHANNEL_EHIP_STATUS_TIEOFF_WIDTH = (ZEROTH_CHANNEL_NUMBER + l_channels < I_O_NUMBER_LANES) ? (I_HIP_AIB_STATUS_WIDTH - ((ZEROTH_CHANNEL_NUMBER + l_channels) * I_HIP_AIB_STATUS_WIDTH_PER_LANE)) : 0;

    localparam ZEROTH_PMA_RX_CW_POS_OFFSET = ((ZEROTH_CHANNEL_NUMBER + 1) * O_PMA_RX_CW_POS_WIDTH_PER_LANE) - 1;

    localparam ZEROTH_PMA_RSFEC_TX_DATA_OFFSET = ((ZEROTH_CHANNEL_NUMBER + 1) * TX_PMA_DATA_OUTPUT_WIDTH_PER_LANE) - 1;

    localparam ZEROTH_RSFEC_RX_DATA_OFFSET = ((ZEROTH_CHANNEL_NUMBER + 1) * FEC_LANE_RX_DATA_WIDTH) - 1;

    localparam ZEROTH_RSFEC_ELANE_RX_DATA_OFFSET = ((ZEROTH_CHANNEL_NUMBER + 1) * PCS_LANE_RX_DATA_WIDTH) - 1;

    localparam l_hssi_rsfec_u_rsfec_rx_mux0_rx_data_source = (ZEROTH_CHANNEL_NUMBER <= 0 && (ZEROTH_CHANNEL_NUMBER + l_channels > 0)) ? hssi_rsfecrx_mux_rx_data_source : "xcvr_rx_data";
    localparam l_hssi_rsfec_u_rsfec_rx_mux1_rx_data_source = (ZEROTH_CHANNEL_NUMBER <= 1 && (ZEROTH_CHANNEL_NUMBER + l_channels > 1)) ? hssi_rsfecrx_mux_rx_data_source : "xcvr_rx_data";
    localparam l_hssi_rsfec_u_rsfec_rx_mux2_rx_data_source = (ZEROTH_CHANNEL_NUMBER <= 2 && (ZEROTH_CHANNEL_NUMBER + l_channels > 2)) ? hssi_rsfecrx_mux_rx_data_source : "xcvr_rx_data";
    localparam l_hssi_rsfec_u_rsfec_rx_mux3_rx_data_source = (ZEROTH_CHANNEL_NUMBER <= 3 && (ZEROTH_CHANNEL_NUMBER + l_channels > 3)) ? hssi_rsfecrx_mux_rx_data_source : "xcvr_rx_data";

// genvar ig is already declared
/* Naming convention for logic nets connected to the RSFEC block:
   first letter is either i or o, denotes input to the RSFEC block or output from the RSFEC block
   for inputs, the next string denotes the source of the signal.  For outputs, the string denotes the destination of the signal.
   The remainder of the string denotes the function of the signal.
   Example: i_coreip_elane_out_rsfec_tx_data_in:
			i denotes input to the rsfec block
			coreip indicates that the signal comes from the core IP
			elane_out_rsfec_tx_data_in indicates that this is transmit data comes from the ELANE of the core IP and goes to the RSFEC
   When the source or destination string is labeled "port", this means that it connects to a port at the top level of the native phy.
*/
      logic [I_EHIP_ELANE_TX_DATA_WIDTH - 1 : 0]    i_coreip_elane_out_rsfec_tx_data_in;
      logic [I_EHIP_ELANE_TX_DATA_WIDTH - 1 : 0]    i_coreip_hssi_adapter_out_rsfec_tx_data_in;
      logic [I_EHIP_ELANE_TX_DATA_WIDTH - 1 : 0]    i_port_ehip_out_tx_data_rsfec_in;
      logic [I_FEC_RX_DATA_WIDTH - 1 : 0]           i_coreip_pma_out_rx_data_in_rsfec;
      logic [I_O_NUMBER_LANES - 1 : 0]              i_coreip_pma_out_rx_rsfec_in_data_valid;
      logic [I_O_NUMBER_LANES - 1 : 0]              i_coreip_pma_out_rx_rsfec_bit0_tag;
	  logic [I_O_NUMBER_LANES - 1 : 0]              i_coreip_ehip_port_adapter_tx_clock_in;
	  logic [I_O_NUMBER_LANES - 1 : 0]              i_adapt_tx_clock;
	  logic [I_HIP_AIB_STATUS_WIDTH - 1 : 0]        i_coreip_hip_aib_status_out_rsfec_in;
      logic [I_O_NUMBER_LANES - 1 : 0]              o_coreip_rsfec_out_tx_pma_clk;
      logic [I_O_NUMBER_LANES - 1 : 0]              o_coreip_rsfec_out_rx_pma_clk;
      logic [I_O_NUMBER_LANES - 1 : 0]              o_adapt_ehip_clock_rsfec;
      logic [I_O_NUMBER_LANES - 1 : 0]              o_coreip_rsfec_out_pma_tx_bit0_tag;
      logic [O_PMA_RX_CW_POS_WIDTH - 1 : 0]         o_coreip_rsfec_out_pma_rx_cw_pos;
      logic [O_FEC_TX_DATA_WIDTH - 1 : 0]           o_coreip_rsfec_out_pma_tx_data;
      logic [I_O_NUMBER_LANES - 1 : 0]              o_coreip_rsfec_out_pma_tx_data_valid;
	  logic                                         i_pld_adapt_out_rsfec_in_reset_n;
      logic                                         i_pld_adapt_out_rsfec_in_tx_reset_n;
      logic                                         i_pld_adapt_out_rsfec_in_rx_reset_n;
      logic                                         i_pld_adapt_out_rsfec_in_pld_ready;
      logic [I_O_NUMBER_LANES - 1 : 0]              i_pld_adapt_out_rsfec_in_signal_ok;
      logic                                         i_pld_adapt_out_rsfec_in_usr_avmm2_rst;
      logic                                         o_pld_adapt_in_rsfec_out_config_done;
	  logic                                         o_pld_adapt_in_rsfec_out_fec_ready;
	  logic                                         o_pld_adapt_in_rsfec_out_internal_error;
      logic [O_N_FEC_CHNL_SSR_WIDTH - 1 : 0]        o_pld_adapt_in_rsfec_out_n_fec_channel_ssr;
	  // JRJ 1-29-2018 - These wires are used to connect just the bits of the o_n_fec_chnl_ssr port on the RSFEC that actually connect to the PLD adapt atom
      // This change is to fix the fitter problem in Fogbugz case 530770
	  logic [O_N_FEC_CHNL_SSR_WIDTH - 1 : 0]        pld_adapt_rsfec_channel_ssr_connection;
      logic [O_N_FEC_CHNL_SSR_WIDTH - 1 : 0]        pld_adapt_native_phy_output_port_connection;
      logic                                         o_pld_adapt_in_rsfec_out_status_rx_not_align;
      logic                                         o_pld_adapt_in_rsfec_out_status_rx_not_deskew;
      logic                                         o_pld_adapt_in_rsfec_out_tx_dsk_valid;
      logic                                         i_port_ehip_out_rsfec_clock_in;
      logic                                         o_rsfecrx_mux_rsfec_out_rx_dsk_marker;  // Fogbugz case 542193
      logic 			        o_rsfec_out_rx_dsk_marker;              // Fogbugz case 528321
      logic [I_O_NUMBER_LANES - 1 : 0]              o_rsfecrx_mux_rsfec_out_rx_am_sync;
      logic [I_O_NUMBER_LANES - 1 : 0]              o_rsfecrx_mux_rsfec_out_rx_data_valid;
      logic [O_FEC_RX_MUX_DATA_WIDTH - 1 : 0]       o_rsfecrx_mux_rsfec_out_rx_data_in_rsfecrx_mux;
      logic [I_O_NUMBER_LANES*FEC_LANE_RX_OUT_SEL_WIDTH - 1 : 0] o_rsfecrx_mux_rsfec_out_rx_out_sel;


      //*****************************
      // If the RSFEC is instantiated, only four lanes of native phy output are permitted
      //*****************************
	  // I don't like the magic numbers (77), but the same magic number 77 is used in the
	  // core IP.  Since this is really describing hardware that already exists, it is less important
	  // that it be easy to change.  The same goes for the magic number 65, which is used in the Core IP.
	  /* The connections to the core IP are declared below.  The naming convention for these is as follows:
		 The first character is either o or i, indicating whether or not the net is an input to or an output from the core IP
		 The next string indicates the destination of the signal (for outputs from the core IP) or the source
		 of the signal (for inputs to the core IP)
		 The remainder of the string denotes the function of the signal
		 Example: o_rsfec_elane_tx_data_out:
		 o - This indicates that this signal is an output from the core IP
		 rsfec - Since this is an output from the core IP, rsfec indicates the destination of the signal
		 elane_tx_data_out - This indicates that the signal is transmit data (tx_data) from the elane block in the core IP

		 Note that the data signals below are two-dimensional arrays.  There is a packed array for each channel and the
		 unpacked array index is used to connect to the single-channel port of the core IP.
	  */
	  logic [77:0] o_rsfec_elane_tx_data_out [l_channels - 1 : 0];
	  logic [77:0] o_rsfec_ct3_hssi_aibadapt_tx_data [l_channels - 1 : 0];
	  logic [l_channels - 1 : 0] o_ehip_port_rsfec_rx_out_data_valid;
	  logic [65:0] o_ehip_port_rsfec_rx_out_data [l_channels - 1 : 0];
      logic [l_channels - 1 : 0] o_ehip_port_rsfec_pma_rx_bit0_tag_out;
	  logic [66:0] o_rsfec_pma_pcs_rx_data_out [l_channels - 1 : 0];
      logic [l_channels - 1 : 0] o_rsfec_pma_pcs_rx_data_valid_out;
      logic [l_channels - 1 : 0] i_rsfec_coreip_tx_rsfec_clk_div2;
      logic [l_channels - 1 : 0] i_rsfec_coreip_rx_rsfec_clk_div2;
      logic [l_channels - 1 : 0] i_adapt_ehip_rsfec_clock;
      logic [l_channels - 1 : 0] i_rsfec_coreip_tx_pma_bit0_tag;
      logic [12 : 0] i_rsfec_coreip_rx_latency_bit_cw_pos [l_channels - 1 : 0];
	  logic [65:0] i_rsfec_coreip_tx_data_pma_in_rsfec_out [l_channels - 1 : 0];
      logic [l_channels - 1 : 0] i_rsfec_coreip_tx_data_valid;
	  logic [77:0] i_rsfec_coreip_rx_data_in [l_channels - 1 : 0];
	  logic [77:0] i_rsfec_coreip_rx_elane_data_in [l_channels - 1 : 0];
	  logic [l_channels - 1 : 0] i_rsfec_rxfecrx_mux_rx_am_sync;
	  logic [l_channels - 1 : 0] i_rsfec_rxfecrx_mux_rx_data_valid;
	  logic [65:0] i_rsfec_rsfecrx_mux_rx_data [l_channels - 1 : 0];
	  logic [FEC_LANE_RX_OUT_SEL_WIDTH - 1:0] i_rsfec_rsfecrx_mux_rx_out_sel [l_channels - 1 : 0];
	  logic [65:0] o_rsfecrx_mux_coreip_in_fec_rx_mux_data [l_channels - 1 : 0];
      logic [65:0] o_coreip_rsfec_out_rx_data [l_channels - 1 : 0];
      logic [l_channels - 1 : 0] o_coreip_rsfec_out_rx_data_valid;
      logic [l_channels - 1 : 0] o_coreip_rsfec_out_rx_data_sync;
      logic [66:0] o_coreip_rsfec_out_rx_elane_data [l_channels - 1 : 0];
      logic [l_channels - 1 : 0] o_coreip_rsfec_out_rx_elane_data_valid;
      logic [l_channels - 1 : 0] o_coreip_rsfec_out_rx_elane_data_sync;
      logic [65:0] i_port_ehip_out_tx_data_rsfecrx_mux_in[l_channels - 1 : 0];
      logic [l_channels - 1 : 0] i_port_ehip_out_rsfecrx_mux_in_tx_data_valid;
      logic [l_channels - 1 : 0] i_port_ehip_out_rsfecrx_mux_in_tx_data_sync;
      logic [66:0] i_coreip_out_rxfecrx_mux_in_tx_elane_data [l_channels - 1 : 0];
      logic [l_channels - 1 : 0] i_coreip_out_rxfecrx_mux_in_tx_elane_data_valid;
      logic [l_channels - 1 : 0] i_coreip_out_rxfecrx_mux_in_tx_elane_data_sync;
      logic [65:0] i_coreip_pma_out_rsfecrx_mux_in_rx_data [l_channels - 1 : 0];
      logic [l_channels - 1 : 0] i_coreip_pma_out_rsfecrx_mux_in_rx_data_valid;
      logic [l_channels - 1 : 0] i_coreip_pma_out_rsfecrx_mux_in_rx_data_bit0_tag;

	    //// AVMM clock lines
      //logic i_port_avmm2_avmmclk;
      //logic i_port_avmm2_avmmread;
      //logic i_port_avmm2_avmmrequest;
      //logic i_port_avmm2_write;
      logic o_rsfec_rsfecrx_mux_avmm2_clk;

generate

     //******************************EHIP TX Data Input****************************************************************************
	  // When the RSFEC is instantiated, we connect the ehip TX data inputs directly from the EHIP data in port of the native PHY to the RSFEC block
	  // When the RSFEC is not instantiated, we connect the EHIP data in port to the core IP
	  // Connect EHIP tx inputs from the i_ehip_rsfec_tx_data_in port of the native phy to the EHIP tx data input of the RSFEC block when the RSFEC block is instantiated.
	  // All four channels are always connected to the port of the native phy.  The data lines are mapped to the appropriate data
	  // lines of the RSFEC block and the data valid and alignment marker bits from the native phy input ports, which connect to
      // the EHIP atom are connected to the correct data lines on the RSFEC block
	  // When we are in an EHIP mode, the number of channels will always be four.
	  // Connect the EHIP data lines.  This is the 66 LSBs of all ports.  Also connect the data valid and alignment marker lines.

      if (lcl_instantiate_RSFEC_block) begin : generate_EHIP_TX_data_input_to_RSFEC_block
          for(ig=0; ig<l_channels; ig=ig+1) begin : ehip_rsfec_data_connect
              assign i_port_ehip_out_tx_data_rsfec_in[ ig * TX_DATA_INPUT_WIDTH_PER_LANE + EHIP_TX_DATA_INPUT_WIDTH_PER_LANE - 1 -: EHIP_TX_DATA_INPUT_WIDTH_PER_LANE ] =
                  pmaRsfec_ehip_tx_ehip_data [ (ig + 1) * EHIP_TX_DATA_INPUT_WIDTH_PER_LANE - 1 -: EHIP_TX_DATA_INPUT_WIDTH_PER_LANE];
              assign i_port_ehip_out_tx_data_rsfec_in[ ig * TX_DATA_INPUT_WIDTH_PER_LANE + EHIP_TX_DATA_VALID_BIT_OFFSET] = pmaRsfec_ehip_tx_ehip_dv[ig];
              assign i_port_ehip_out_tx_data_rsfec_in[ ig * TX_DATA_INPUT_WIDTH_PER_LANE + EHIP_TX_DATA_AM_VALID_BIT_OFFSET] = pmaRsfec_ehip_tx_ehip_data_am_valid_in[ig];
          end : ehip_rsfec_data_connect
      end : generate_EHIP_TX_data_input_to_RSFEC_block

      //******************************ELANE TX Data Input****************************************************************************
      // Connect ELANE tx output from core IP to input of RSFEC block.  Also tie off the unused data inputs below the first channel and after the last channel.
      // We don't need begin and end on the ifs, but if we add other stuff later we won't forget to put the begin and end because they will already be there.
      if (lcl_instantiate_RSFEC_block) begin : generate_ELANE_TX_data_input_to_RSFEC_block
             for(ig=0; ig<l_channels; ig=ig+1) begin : elane_rsfec_data_connect
                 assign i_coreip_elane_out_rsfec_tx_data_in[(TX_DATA_INPUT_WIDTH_PER_LANE * ig) + ZEROTH_CHANNEL_TX_ASSIGNMENT_OFFSET -: TX_DATA_INPUT_WIDTH_PER_LANE] = o_rsfec_elane_tx_data_out[ig];
             end : elane_rsfec_data_connect
             if (UNUSED_CHANNEL_TX_TIEOFF_OFFSET > 0) begin
	         assign i_coreip_elane_out_rsfec_tx_data_in[UNUSED_CHANNEL_TX_TIEOFF_OFFSET -: UNUSED_CHANNEL_TX_TIEOFF_WIDTH] = 'b0;  // A lower index of 0 for this slice would work, too.
             end
             if (LAST_CHANNEL_TX_TIEOFF_OFFSET < I_EHIP_ELANE_TX_DATA_WIDTH) begin
                 assign i_coreip_elane_out_rsfec_tx_data_in[I_EHIP_ELANE_TX_DATA_WIDTH - 1 -: LAST_CHANNEL_TX_TIEOFF_WIDTH] = 'b0;
             end
      end : generate_ELANE_TX_data_input_to_RSFEC_block
      //******************************ELANE TX Data Input****************************************************************************

     //******************************PMA Direct TX Data Input****************************************************************************
     // Connect the PMA direct TX data from the core IP to the input of the RSFEC block.
      if (lcl_instantiate_RSFEC_block) begin : generate_PMA_Direct_TX_data_input_to_RSFEC_block
             for(ig=0; ig<l_channels; ig=ig+1) begin : AIB_rsfec_data_connect
	         assign i_coreip_hssi_adapter_out_rsfec_tx_data_in[(TX_DATA_INPUT_WIDTH_PER_LANE * ig) + ZEROTH_CHANNEL_TX_ASSIGNMENT_OFFSET -: TX_DATA_INPUT_WIDTH_PER_LANE] = o_rsfec_ct3_hssi_aibadapt_tx_data[ig];
             end : AIB_rsfec_data_connect
             if (UNUSED_CHANNEL_TX_TIEOFF_OFFSET > 0) begin
	         assign i_coreip_hssi_adapter_out_rsfec_tx_data_in[UNUSED_CHANNEL_TX_TIEOFF_OFFSET -: UNUSED_CHANNEL_TX_TIEOFF_WIDTH] = 'b0;  // A lower index of 0 for this slice would work, too.
             end
             if (LAST_CHANNEL_TX_TIEOFF_OFFSET < I_EHIP_ELANE_TX_DATA_WIDTH) begin
                 assign i_coreip_hssi_adapter_out_rsfec_tx_data_in[I_EHIP_ELANE_TX_DATA_WIDTH - 1 -: LAST_CHANNEL_TX_TIEOFF_WIDTH] = 'b0;
             end
      end : generate_PMA_Direct_TX_data_input_to_RSFEC_block
     //******************************PMA Direct TX Data Input****************************************************************************

     //******************************RX data input from the core IP****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_core_IP_data_input_to_RSFEC_block
             for(ig=0; ig<l_channels; ig=ig+1) begin : CoreIP_rx_rsfec_data_connect
                 assign i_coreip_pma_out_rx_data_in_rsfec[(RX_DATA_INPUT_WIDTH_PER_LANE * ig) + ZEROTH_CHANNEL_RX_ASSIGNMENT_OFFSET -: RX_DATA_INPUT_WIDTH_PER_LANE] = o_ehip_port_rsfec_rx_out_data[ig];
	         assign i_coreip_pma_out_rx_rsfec_in_data_valid[ZEROTH_CHANNEL_NUMBER + ig] = o_ehip_port_rsfec_rx_out_data_valid[ig];
                 assign i_coreip_pma_out_rx_rsfec_bit0_tag[ZEROTH_CHANNEL_NUMBER + ig] = o_ehip_port_rsfec_pma_rx_bit0_tag_out[ig];
             end : CoreIP_rx_rsfec_data_connect
             if (UNUSED_CHANNEL_RX_TIEOFF_OFFSET > 0) begin
	         assign i_coreip_pma_out_rx_data_in_rsfec[UNUSED_CHANNEL_RX_TIEOFF_OFFSET -: UNUSED_CHANNEL_RX_TIEOFF_WIDTH] = 'b0;  // A lower index of 0 for this slice would work, too.
	         assign i_coreip_pma_out_rx_rsfec_in_data_valid[ZEROTH_CHANNEL_NUMBER - 1 : 0] = 'b0;
	         assign i_coreip_pma_out_rx_rsfec_bit0_tag[ZEROTH_CHANNEL_NUMBER - 1 : 0] = 'b0;
             end
             if (LAST_CHANNEL_RX_TIEOFF_OFFSET < I_FEC_RX_DATA_WIDTH) begin
                 assign i_coreip_pma_out_rx_data_in_rsfec[I_FEC_RX_DATA_WIDTH - 1 -: LAST_CHANNEL_RX_TIEOFF_WIDTH] = 'b0;
	         assign i_coreip_pma_out_rx_rsfec_in_data_valid[I_O_NUMBER_LANES - 1 : FIRST_UNUSED_CHANNEL_NUMBER] = 'b0;
	         assign i_coreip_pma_out_rx_rsfec_bit0_tag[I_O_NUMBER_LANES - 1 : ZEROTH_CHANNEL_NUMBER + l_channels] = 'b0;
             end
      end : generate_core_IP_data_input_to_RSFEC_block
             for(ig=0; ig<l_channels; ig=ig+1) begin : CoreIP_rx_EHIP_data_connect
         assign ehip_pmaRsfec_fec_rx_data[ig*66+:66] = o_coreip_rsfec_out_rx_data[ig];
	 assign ehip_pmaRsfec_fec_rx_data_am_valid[ig] = o_coreip_rsfec_out_rx_data_sync[ig];
         assign ehip_pmaRsfec_fec_rx_data_valid[ig] = o_coreip_rsfec_out_rx_data_valid[ig];
             end : CoreIP_rx_EHIP_data_connect
     //******************************RX data input from the core IP****************************************************************************

     //******************************HIP AIB Status Input****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_HIP_AIB_status_input
             for(ig=0; ig<l_channels; ig=ig+1) begin : HIP_AIB_status_input_connect
                 // I'm not sure about this one.  This is an output from the core IP and it also goes directly to the output of the native PHY
	         assign i_coreip_hip_aib_status_out_rsfec_in[(I_HIP_AIB_STATUS_WIDTH_PER_LANE * ig) + ZEROTH_EHIP_STATUS_OFFSET -: I_HIP_AIB_STATUS_WIDTH_PER_LANE] = ehip_aib_aib_status[((ig + 1) * 3) - 1 -: 3];
             end : HIP_AIB_status_input_connect
             // case:554933 - i_hip_aib_status[11] needs to be tied to vcc
             if (UNUSED_CHANNEL_RX_TIEOFF_OFFSET > 0) begin
	         assign i_coreip_hip_aib_status_out_rsfec_in[UNUSED_CHANNEL_EHIP_STATUS_TIEOFF_OFFSET -: UNUSED_CHANNEL_EHIP_STATUS_TIEOFF_WIDTH] = {ZEROTH_CHANNEL_NUMBER{3'b111}};
             end
             if (LAST_CHANNEL_RX_TIEOFF_OFFSET < I_FEC_RX_DATA_WIDTH) begin
	         assign i_coreip_hip_aib_status_out_rsfec_in[I_HIP_AIB_STATUS_WIDTH - 1 -: LAST_CHANNEL_EHIP_STATUS_TIEOFF_WIDTH] = {(I_O_NUMBER_LANES - (ZEROTH_CHANNEL_NUMBER + l_channels)){3'b111}};
             end
      end : generate_HIP_AIB_status_input
     //******************************HIP AIB Status Input****************************************************************************

     //******************************RSFEC TX output clock****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_TX_to_coreIP_output_clock
             for(ig=0; ig<l_channels; ig=ig+1) begin : TX_output_clock_connect
                 assign i_rsfec_coreip_tx_rsfec_clk_div2[ig] = o_coreip_rsfec_out_tx_pma_clk[ig + ZEROTH_CHANNEL_NUMBER];
             end : TX_output_clock_connect
      end : generate_TX_to_coreIP_output_clock
      else begin : generate_TX_output_clock_tieoff  // Added by JRJ 4/9/2018 - Fogbugz case 528321
             for(ig=0; ig<l_channels; ig=ig+1) begin : TX_output_clock_tieoff
                 assign i_rsfec_coreip_tx_rsfec_clk_div2[ig] = 1'b0;
             end : TX_output_clock_tieoff
      end : generate_TX_output_clock_tieoff
     //******************************RSFEC TX output clock****************************************************************************

     //******************************RSFEC RX output clock to transceiver****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_RX_to_coreIP_output_clock
             for(ig=0; ig<l_channels; ig=ig+1) begin : RX_output_clock_connect
                 assign i_rsfec_coreip_rx_rsfec_clk_div2[ig] = o_coreip_rsfec_out_rx_pma_clk[ig + ZEROTH_CHANNEL_NUMBER];
             end : RX_output_clock_connect
      end : generate_RX_to_coreIP_output_clock
      else begin : generate_RX_output_clock_tieoff  // Added by JRJ 4/9/2018 - Fogbugz case 528321
             for(ig=0; ig<l_channels; ig=ig+1) begin : RX_output_clock_tieoff
                 assign i_rsfec_coreip_rx_rsfec_clk_div2[ig] = 1'b0;
             end : RX_output_clock_tieoff
      end  : generate_RX_output_clock_tieoff
     //******************************RSFEC RX output clock to transceiver****************************************************************************

     //******************************RSFEC TX output bit0 tag to transceiver****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_TX_bit0_tag_to_coreIP
             for(ig=0; ig<l_channels; ig=ig+1) begin : TX_output_bit0_tag_connect
                 assign i_rsfec_coreip_tx_pma_bit0_tag[ig] = o_coreip_rsfec_out_pma_tx_bit0_tag[ig + ZEROTH_CHANNEL_NUMBER];
             end : TX_output_bit0_tag_connect
      end : generate_TX_bit0_tag_to_coreIP
      else begin : generate_TX_bit0_tag_tieoff  // Added by JRJ 4/9/2018 - Fogbugz case 528321
             for(ig=0; ig<l_channels; ig=ig+1) begin : TX_bit0_tag_tieoff
                 assign i_rsfec_coreip_tx_pma_bit0_tag[ig] = 1'b0;
             end : TX_bit0_tag_tieoff
      end : generate_TX_bit0_tag_tieoff
     //******************************RSFEC TX output bit0 tag to transceiver****************************************************************************

     //******************************RSFEC RX output RSFEC code word first bit position****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_RX_output_first_bit_position
             for(ig=0; ig<l_channels; ig=ig+1) begin : RX_output_code_word_first_bit_position_connect
	         assign i_rsfec_coreip_rx_latency_bit_cw_pos[ig] = o_coreip_rsfec_out_pma_rx_cw_pos[(O_PMA_RX_CW_POS_WIDTH_PER_LANE * ig) + ZEROTH_PMA_RX_CW_POS_OFFSET -: O_PMA_RX_CW_POS_WIDTH_PER_LANE];
             end : RX_output_code_word_first_bit_position_connect
      end : generate_RX_output_first_bit_position
	  else begin : RSFEC_not_instantiated
             for(ig=0; ig<l_channels; ig=ig+1) begin : RX_output_code_word_first_bit_position_terminate
	         assign i_rsfec_coreip_rx_latency_bit_cw_pos[ig] = 'b0;
             end : RX_output_code_word_first_bit_position_terminate
	  end : RSFEC_not_instantiated
     //******************************RSFEC RX output RSFEC code word first bit position****************************************************************************

     //******************************RSFEC TX data output to transceiver****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_TX_data_output_to_transceiver
             for(ig=0; ig<l_channels; ig=ig+1) begin : TX_output_data_to_PMA_connect
	         assign i_rsfec_coreip_tx_data_pma_in_rsfec_out[ig] = o_coreip_rsfec_out_pma_tx_data[(TX_PMA_DATA_OUTPUT_WIDTH_PER_LANE * ig) + ZEROTH_PMA_RSFEC_TX_DATA_OFFSET -: TX_PMA_DATA_OUTPUT_WIDTH_PER_LANE];
             end : TX_output_data_to_PMA_connect
      end : generate_TX_data_output_to_transceiver
      else begin : generate_TX_output_data_tieoff  // Added by JRJ 4/9/2018 - Fogbugz case 528321
             for(ig=0; ig<l_channels; ig=ig+1) begin : TX_output_data_tieoff
                 assign i_rsfec_coreip_tx_data_pma_in_rsfec_out[ig] = 'b0;
             end : TX_output_data_tieoff
      end : generate_TX_output_data_tieoff
     //******************************RSFEC TX data output to transceiver****************************************************************************

     //******************************RSFEC TX data valid output to transceiver****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_TX_data_valid_output_to_transceiver
             for(ig=0; ig<l_channels; ig=ig+1) begin : TX_output_data_valid_to_PMA_connect
                 assign i_rsfec_coreip_tx_data_valid[ig] = o_coreip_rsfec_out_pma_tx_data_valid[ig + ZEROTH_CHANNEL_NUMBER];
             end : TX_output_data_valid_to_PMA_connect
      end : generate_TX_data_valid_output_to_transceiver
      else begin : generate_TX_data_valid_tieoff  // Added by JRJ 4/9/2018 - Fogbugz case 528321
             for(ig=0; ig<l_channels; ig=ig+1) begin : TX_data_valid_tieoff
                 assign i_rsfec_coreip_tx_data_valid[ig] = 1'b0;
             end : TX_data_valid_tieoff
      end : generate_TX_data_valid_tieoff
     //******************************RSFEC TX data valid output to transceiver****************************************************************************

     //******************************EHIP Adapter TX Clock Input****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_EHIP_Adapter_TX_Clock_input
	     if (l_hssi_rsfec_is_ehip_mode) begin : TX_adapt_clock_from_EHIP
		     for (ig=0; ig<l_channels; ig=ig+1) begin : Connect_TX_adapt_clocks_to_port
                     // l_channels will always be four in EHIP mode and ZEROTH_CHANNEL_NUMBER will always be zero
			     assign i_coreip_ehip_port_adapter_tx_clock_in[ig + ZEROTH_CHANNEL_NUMBER] = RSFEC_ehip_tx_adpt_clock[ig];
		     end : Connect_TX_adapt_clocks_to_port
		     assign i_port_ehip_out_rsfec_clock_in = RSFEC_ehip_clock;
             end : TX_adapt_clock_from_EHIP
             else begin : TX_adapt_clock_from_coreIP
		     for (ig=0; ig<l_channels; ig=ig+1) begin : Connect_TX_adapt_clocks_to_coreIP
			     assign i_coreip_ehip_port_adapter_tx_clock_in[ig + ZEROTH_CHANNEL_NUMBER] = ehip_aib_tx_transfer_div2_clk[ig];
                 end : Connect_TX_adapt_clocks_to_coreIP
		 // Tie off unused i_coreip_ehip_port_adapter_tx_clock_in
		 if (ZEROTH_CHANNEL_NUMBER > 0) begin : Zeroth_channel_greater_than_0
		    for (ig=0; ig<ZEROTH_CHANNEL_NUMBER; ig=ig+1) begin : Tie_off_low_order_channels
			assign i_coreip_ehip_port_adapter_tx_clock_in[ig] = 1'b0;
		    end : Tie_off_low_order_channels
		 end : Zeroth_channel_greater_than_0
		 if (FIRST_UNUSED_CHANNEL_NUMBER < I_O_NUMBER_LANES) begin : First_unused_channel_less_than_4
		    for (ig=FIRST_UNUSED_CHANNEL_NUMBER; ig<I_O_NUMBER_LANES; ig=ig+1) begin : Tie_off_high_order_channels
			assign i_coreip_ehip_port_adapter_tx_clock_in[ig] = 1'b0;
		    end : Tie_off_high_order_channels
		 end : First_unused_channel_less_than_4
//  				 assign i_port_ehip_out_rsfec_clock_in = 'b0;
		     assign i_port_ehip_out_rsfec_clock_in = RSFEC_ehip_clock;
	     end : TX_adapt_clock_from_coreIP
      end : generate_EHIP_Adapter_TX_Clock_input
     //******************************EHIP Adapter TX Clock Input****************************************************************************

     //******************************RSFEC RX data output to RSFEC RX Mux****************************************************************************
      if (lcl_instantiate_RSFEC_block) begin : generate_RX_data_to_RSFEC_RX_Mux
             for(ig=0; ig<l_channels; ig=ig+1) begin : RX_output_data_to_RSFEC_RX_Mux_connect
                 assign i_rsfec_rsfecrx_mux_rx_data[ig] = o_rsfecrx_mux_rsfec_out_rx_data_in_rsfecrx_mux[(FEC_LANE_RX_DATA_WIDTH * ig) + ZEROTH_RSFEC_RX_DATA_OFFSET -: FEC_LANE_RX_DATA_WIDTH];
	         assign i_rsfec_rxfecrx_mux_rx_am_sync[ig] = o_rsfecrx_mux_rsfec_out_rx_am_sync[ig + ZEROTH_CHANNEL_NUMBER];
	         assign i_rsfec_rxfecrx_mux_rx_data_valid[ig] = o_rsfecrx_mux_rsfec_out_rx_data_valid[ig + ZEROTH_CHANNEL_NUMBER];
                 assign i_rsfec_rsfecrx_mux_rx_out_sel[ig] = o_rsfecrx_mux_rsfec_out_rx_out_sel[((ig + ZEROTH_CHANNEL_NUMBER) * FEC_LANE_RX_OUT_SEL_WIDTH) +: FEC_LANE_RX_OUT_SEL_WIDTH];
             end : RX_output_data_to_RSFEC_RX_Mux_connect
      end : generate_RX_data_to_RSFEC_RX_Mux
      else begin : generate_RSFEC_RX_Mux_tieoff  // Added by KM 5/11/2018 - Fogbugz case 553457
             for(ig=0; ig<l_channels; ig=ig+1) begin : RSFEC_RX_Mux_rx_out_sel_tieoff
                 assign i_rsfec_rsfecrx_mux_rx_out_sel[ig] = 2'b0;
             end : RSFEC_RX_Mux_rx_out_sel_tieoff
      end : generate_RSFEC_RX_Mux_tieoff
     //******************************RSFEC RX data output to RSFEC RX Mux****************************************************************************
// Added manually by JRJ 1/2/2018
     //******************************RSFEC RX data output to RSFEC RX Mux****************************************************************************
   if (lcl_instantiate_RSFEC_block) begin : generate_rsfec_adpt_clock_to_core_IP
             for(ig=0; ig<l_channels; ig=ig+1) begin : adapt_ehip_clock_connect
                 assign i_adapt_ehip_rsfec_clock[ig] = o_adapt_ehip_clock_rsfec[ig + ZEROTH_CHANNEL_NUMBER];
             end : adapt_ehip_clock_connect
      end : generate_rsfec_adpt_clock_to_core_IP
      else begin : generate_adapt_ehip_clock_tieoff  // Added by JRJ 4/9/2018 - Fogbugz case 528321
             for(ig=0; ig<l_channels; ig=ig+1) begin : adapt_ehip_clock_tieoff
                 assign i_adapt_ehip_rsfec_clock[ig] = 1'b0;
             end : adapt_ehip_clock_tieoff
      end : generate_adapt_ehip_clock_tieoff
     //******************************RSFEC RX data output to RSFEC RX Mux****************************************************************************
// End of manually added section JRJ 1/2/2018
// Added manually by JRJ 4/9/2018 - Fogbugz case 528321
     //******************************RSFEC RX deskew output to Core IP - tieoff if RSFEC is not instantiated ****************************************
     if (lcl_instantiate_RSFEC_block) begin : generate_rsfec_deskew_output_to_core_IP
        assign o_rsfecrx_mux_rsfec_out_rx_dsk_marker = o_rsfec_out_rx_dsk_marker;
     end : generate_rsfec_deskew_output_to_core_IP
     else begin : generate_rsfec_deskew_output_tieoff  // Added by JRJ 4/9/2018 - Fogbugz case 528321
        assign o_rsfecrx_mux_rsfec_out_rx_dsk_marker = 1'b0;
     end : generate_rsfec_deskew_output_tieoff
     //******************************RSFEC RX data output to RSFEC RX Mux****************************************************************************
// End of manually added section JRJ 4/9/2018

// Added manually by JRJ 1/29/2018
// This is meant to fix the fitter problem described in Fogbugz case 530770
     //******************************RSFEC Channel SSR connection to PLD adapt atom****************************************************************************
	 if (lcl_instantiate_RSFEC_block) begin : connect_channel_SSR_to_PLD_adapt
	     assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[0] = pld_adapt_rsfec_channel_ssr_connection[0];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[1] = pld_adapt_rsfec_channel_ssr_connection[1];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[2] = pld_adapt_rsfec_channel_ssr_connection[2];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[4] = pld_adapt_rsfec_channel_ssr_connection[4];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[5] = pld_adapt_rsfec_channel_ssr_connection[5];
	     assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[8] = pld_adapt_rsfec_channel_ssr_connection[8];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[9] = pld_adapt_rsfec_channel_ssr_connection[9];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[10] = pld_adapt_rsfec_channel_ssr_connection[10];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[12] = pld_adapt_rsfec_channel_ssr_connection[12];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[13] = pld_adapt_rsfec_channel_ssr_connection[13];
	     assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[16] = pld_adapt_rsfec_channel_ssr_connection[16];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[17] = pld_adapt_rsfec_channel_ssr_connection[17];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[18] = pld_adapt_rsfec_channel_ssr_connection[18];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[20] = pld_adapt_rsfec_channel_ssr_connection[20];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[21] = pld_adapt_rsfec_channel_ssr_connection[21];
	     assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[24] = pld_adapt_rsfec_channel_ssr_connection[24];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[25] = pld_adapt_rsfec_channel_ssr_connection[25];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[26] = pld_adapt_rsfec_channel_ssr_connection[26];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[28] = pld_adapt_rsfec_channel_ssr_connection[28];
         assign o_pld_adapt_in_rsfec_out_n_fec_channel_ssr[29] = pld_adapt_rsfec_channel_ssr_connection[29];
         assign o_rsfec_channel_ssr[0] = pld_adapt_native_phy_output_port_connection[0];
         assign o_rsfec_channel_ssr[1] = pld_adapt_native_phy_output_port_connection[1];
         assign o_rsfec_channel_ssr[2] = pld_adapt_native_phy_output_port_connection[2];
         assign o_rsfec_channel_ssr[4] = pld_adapt_native_phy_output_port_connection[4];
         assign o_rsfec_channel_ssr[5] = pld_adapt_native_phy_output_port_connection[5];
         assign o_rsfec_channel_ssr[8] = pld_adapt_native_phy_output_port_connection[8];
         assign o_rsfec_channel_ssr[9] = pld_adapt_native_phy_output_port_connection[9];
         assign o_rsfec_channel_ssr[10] = pld_adapt_native_phy_output_port_connection[10];
         assign o_rsfec_channel_ssr[12] = pld_adapt_native_phy_output_port_connection[12];
         assign o_rsfec_channel_ssr[13] = pld_adapt_native_phy_output_port_connection[13];
         assign o_rsfec_channel_ssr[16] = pld_adapt_native_phy_output_port_connection[16];
         assign o_rsfec_channel_ssr[17] = pld_adapt_native_phy_output_port_connection[17];
         assign o_rsfec_channel_ssr[18] = pld_adapt_native_phy_output_port_connection[18];
         assign o_rsfec_channel_ssr[20] = pld_adapt_native_phy_output_port_connection[20];
         assign o_rsfec_channel_ssr[21] = pld_adapt_native_phy_output_port_connection[21];
         assign o_rsfec_channel_ssr[24] = pld_adapt_native_phy_output_port_connection[24];
         assign o_rsfec_channel_ssr[25] = pld_adapt_native_phy_output_port_connection[25];
         assign o_rsfec_channel_ssr[26] = pld_adapt_native_phy_output_port_connection[26];
         assign o_rsfec_channel_ssr[28] = pld_adapt_native_phy_output_port_connection[28];
         assign o_rsfec_channel_ssr[29] = pld_adapt_native_phy_output_port_connection[29];
     end : connect_channel_SSR_to_PLD_adapt
     //******************************RSFEC Channel SSR connection to PLD adapt atom****************************************************************************
// End of manually added section JRJ 1/29/2018
// Conditional generation of RSFEC block
if (lcl_instantiate_RSFEC_block) begin : generate_RSFEC_block

if (rcfg_enable) begin : generate_reconfig_connections
   assign int_reconfig_rsfec_writedata = {24'd0, reconfig_rsfec_writedata};
   assign reconfig_rsfec_readdata = int_reconfig_rsfec_readdata[7:0];
end : generate_reconfig_connections
else begin : tie_off_reconfig_writedata
   assign int_reconfig_rsfec_writedata = {32'd0};
end : tie_off_reconfig_writedata

// RSFEC wrap atom

/* JRJ - 3/1/2018 - remove the MBIST ports to match /swip_build/releases/quartuskit/18.1/12/linux64/quartus/eda/sim_lib/ct1_hssi_atoms.sv changes.
   These ports were removed in changelist 5102378.  */

ct3_hssi_rsfec # (
  .clocking_mode(hssi_rsfec_clocking_mode)                   ,//"ehip_common_clk" "fec_dir_adp_clk_0" "fec_dir_adp_clk_1" "fec_dir_adp_clk_2"
                                                              // "fec_dir_adp_clk_3" "no_clk"
  .core_eng_2lane_ena(hssi_rsfec_core_eng_2lane_ena)         ,// "false","true"
  .core_eng_am_5bad_dis(hssi_rsfec_core_eng_am_5bad_dis)     ,//0:15
  .core_eng_blk_chk_dis(hssi_rsfec_core_eng_blk_chk_dis)     ,//0:15
  .core_eng_cons_25g(hssi_rsfec_core_eng_cons_25g)           ,//0:16777215
  .core_eng_cust_am_1st_0(hssi_rsfec_core_eng_cust_am_1st_0) ,//0:16777215
  .core_eng_cust_am_1st_1(hssi_rsfec_core_eng_cust_am_1st_1) ,//0:16777215
  .core_eng_cust_am_1st_2(hssi_rsfec_core_eng_cust_am_1st_2) ,//0:16777215
  .core_eng_cust_am_1st_3(hssi_rsfec_core_eng_cust_am_1st_3) ,//0:16777215
  .core_eng_cust_am_2nd_0(hssi_rsfec_core_eng_cust_am_2nd_0) ,//0:16777215
  .core_eng_cust_am_2nd_1(hssi_rsfec_core_eng_cust_am_2nd_1) ,//0:16777215
  .core_eng_cust_am_2nd_2(hssi_rsfec_core_eng_cust_am_2nd_2) ,//0:16777215
  .core_eng_cust_am_2nd_3(hssi_rsfec_core_eng_cust_am_2nd_3) ,//0:15
  .core_eng_cust_am_en(hssi_rsfec_core_eng_cust_am_en)       ,//0:65535
  .core_eng_cust_log2_mrk(hssi_rsfec_core_eng_cust_log2_mrk) ,
  .core_eng_enter_align(hssi_rsfec_core_eng_enter_align)     ,//0:15
  .core_eng_exit_align(hssi_rsfec_core_eng_exit_align)       ,//0:15
  .core_eng_fec_3bad_dis(hssi_rsfec_core_eng_fec_3bad_dis)   ,//0:15
  .core_eng_sf_dis(hssi_rsfec_core_eng_sf_dis)               ,//0:15
  .core_eng_swaps(hssi_rsfec_core_eng_swaps)                 ,//0:65535
  .core_eng_test(hssi_rsfec_core_eng_test)                   ,//0:65535
  .core_eng_trans_byp(hssi_rsfec_core_eng_trans_byp)         ,//0:15
  .core_fibre_channel0(hssi_rsfec_core_fibre_channel0)       ,//"false" "true"
  .core_fibre_channel1(hssi_rsfec_core_fibre_channel1)       ,//"false" "true"
  .core_fibre_channel2(hssi_rsfec_core_fibre_channel2)       ,//"false" "true"
  .core_fibre_channel3(hssi_rsfec_core_fibre_channel3)       ,//"false" "true"
  .core_indic_byp(hssi_rsfec_core_indic_byp)                 ,//0:15
  .core_rs544_0(hssi_rsfec_core_rs544_0)                     ,//"false" "true"
  .core_rs544_1(hssi_rsfec_core_rs544_1)                     ,//"false" "true"
  .core_rs544_2(hssi_rsfec_core_rs544_2)                     ,//"false" "true"
  .core_rs544_3(hssi_rsfec_core_rs544_3)                     ,//"false" "true"
  .core_scrambling0(hssi_rsfec_core_scrambling0)             ,//"false" "true"
  .core_scrambling1(hssi_rsfec_core_scrambling1)             ,//"false" "true"
  .core_scrambling2(hssi_rsfec_core_scrambling2)             ,//"false" "true"
  .core_scrambling3(hssi_rsfec_core_scrambling3)             ,//"false" "true"
  .core_tx_pcs_bypass0(hssi_rsfec_core_tx_pcs_bypass0)       ,//"false" "true"
  .core_tx_pcs_bypass1(hssi_rsfec_core_tx_pcs_bypass1)       ,//"false" "true"
  .core_tx_pcs_bypass2(hssi_rsfec_core_tx_pcs_bypass2)       ,//"false" "true"
  .core_tx_pcs_bypass3(hssi_rsfec_core_tx_pcs_bypass3)       ,//"false" "true"
  .deskew_channels_active(hssi_rsfec_deskew_channels_active) ,//"dsk_ln_all" "dsk_ln_none"
  .deskew_channels_clear(hssi_rsfec_deskew_channels_clear)   ,//"false" "true"
  .fec_tx2rx_loopback0(hssi_rsfec_fec_tx2rx_loopback0)       ,//"tx_rx_loopback_ena0" "tx_rx_loopback_none0"
  .fec_tx2rx_loopback1(hssi_rsfec_fec_tx2rx_loopback1)       ,//"tx_rx_loopback_ena1" "tx_rx_loopback_none1"
  .fec_tx2rx_loopback2(hssi_rsfec_fec_tx2rx_loopback2)       ,//"tx_rx_loopback_ena2" "tx_rx_loopback_none2"
  .fec_tx2rx_loopback3(hssi_rsfec_fec_tx2rx_loopback3)       ,//"tx_rx_loopback_ena3" "tx_rx_loopback_none3"
  .first_lane_sel(hssi_rsfec_first_lane_sel)                 ,//"first_lane0" "first_lane1" "first_lane2" "first_lane3"
  .force_deskew_done(hssi_rsfec_force_deskew_done)           ,//"false" "true"
  .force_fec_ready(hssi_rsfec_force_fec_ready)               ,//"false" "true"
  .func_mode(hssi_rsfec_func_mode)                           ,//"disabled" "ehip_aggr" "elane_frac" "fec_dir_aggr" "fec_dir_frac"
  .hwcfg_ena(hssi_rsfec_hwcfg_ena)                           ,//"false" "true"
  .hwcfg_mode(hssi_rsfec_hwcfg_mode)                         ,//0:32767
  .lane_func_mode0(hssi_rsfec_lane_func_mode0)               ,//"lane_mode_disable0" "lane_mode_ehip0" "lane_mode_elane0" "lane_mode_fec_dir_dsk0"
                                                              // "lane_mode_fec_dir_no_dsk0"
  .lane_func_mode1(hssi_rsfec_lane_func_mode1)               ,//"lane_mode_disable1" "lane_mode_ehip1" "lane_mode_elane1" "lane_mode_fec_dir_dsk1"
                                                              // "lane_mode_fec_dir_no_dsk1"
  .lane_func_mode2(hssi_rsfec_lane_func_mode2)               ,//"lane_mode_disable2" "lane_mode_ehip2" "lane_mode_elane2" "lane_mode_fec_dir_dsk2"
                                                              // "lane_mode_fec_dir_no_dsk2"
  .lane_func_mode3(hssi_rsfec_lane_func_mode3)               ,//"lane_mode_disable3" "lane_mode_ehip3" "lane_mode_elane3" "lane_mode_fec_dir_dsk3"
                                                              // "lane_mode_fec_dir_no_dsk3"
  .operation_mode(hssi_rsfec_operation_mode)                 ,//"oper_aggr" "oper_frac"
  .powerdown_mode(hssi_rsfec_powerdown_mode)                 ,//"false" "true"
  .silicon_rev(hssi_rsfec_silicon_rev)                       ,//"14nm4acr3a" "14nm4pacr3a" "14nm5bcr3a"
  .source_clk_sel(hssi_rsfec_source_clk_sel)                 ,//"adp0_clk" "adp1_clk" "adp2_clk" "adp3_clk" "ehip_clk"
  .source_lane_ena0(hssi_rsfec_source_lane_ena0)             ,//"false" "true"
  .source_lane_ena1(hssi_rsfec_source_lane_ena1)             ,//"false" "true"
  .source_lane_ena2(hssi_rsfec_source_lane_ena2)             ,//"false" "true"
  .source_lane_ena3(hssi_rsfec_source_lane_ena3)             ,//"false" "true"
  .spare_bits(hssi_rsfec_spare_bits)                         ,//0:255
  .sup_mode(hssi_rsfec_sup_mode)                             ,//"advanced_user_mode" "advanced_user_mode2" "engineering_mode" "user_mode"
  .topology(hssi_rsfec_topology)                             ,//"dirfec_100g" "dirfec_1ch" "dirfec_2ch" "dirfec_3ch" "dirfec_4ch" "disabled_block"
                                                              // "disabled_system" "ehip_2ch" "ehip_2ch_ptp" "ehip_4ch" "ehip_4ch_fec" "ehip_4ch_ptp"
                                                              // "ehip_4ch_ptp_fec" "elane_1ch" "elane_1ch_fec" "elane_1ch_ptp" "elane_1ch_ptp_fec"
                                                              // "elane_2ch_fec" "elane_2ch_ptp" "elane_2ch_ptp_fec" "elane_3ch_fec" "elane_3ch_ptp"
                                                              // "elane_3ch_ptp_fec" "elane_4ch_fec" "elane_4ch_ptp" "elane_4ch_ptp_fec" "pcs_gearbox_ch"
                                                              // "pmadir_1ch" "pmadir_2ch" "pmadir_pllch" "pmadir_refclkch" "ptp_pllch" "rsvd_topo1"
                                                              // "rsvd_topo2"
  .tx_data_source_sel0(hssi_rsfec_tx_data_source_sel0)       ,//"ehip_tx_data0" "elane_tx_data0" "fec_dir_tx_data_dsk0" "fec_dir_tx_data_no_dsk0"
                                                              // "fec_lb_rx2tx_dat0" "fec_tx_lane_off0"
  .tx_data_source_sel1(hssi_rsfec_tx_data_source_sel1)       ,//"ehip_tx_data1" "elane_tx_data1" "fec_dir_tx_data_dsk1" "fec_dir_tx_data_no_dsk1"
                                                              // "fec_lb_rx2tx_dat1" "fec_tx_lane_off1"
  .tx_data_source_sel2(hssi_rsfec_tx_data_source_sel2)       ,//"ehip_tx_data2" "elane_tx_data2" "fec_dir_tx_data_dsk2" "fec_dir_tx_data_no_dsk2"
                                                              // "fec_lb_rx2tx_dat2" "fec_tx_lane_off2"
  .tx_data_source_sel3(hssi_rsfec_tx_data_source_sel3)       ,//"ehip_tx_data3" "elane_tx_data3" "fec_dir_tx_data_dsk3" "fec_dir_tx_data_no_dsk3"
                                                              // "fec_lb_rx2tx_dat3" "fec_tx_lane_off3"
  .u_rsfec_rx_mux0_rx_data_source(l_hssi_rsfec_u_rsfec_rx_mux0_rx_data_source), //"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
  .u_rsfec_rx_mux1_rx_data_source(l_hssi_rsfec_u_rsfec_rx_mux1_rx_data_source), //"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
  .u_rsfec_rx_mux2_rx_data_source(l_hssi_rsfec_u_rsfec_rx_mux2_rx_data_source), //"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
  .u_rsfec_rx_mux3_rx_data_source(l_hssi_rsfec_u_rsfec_rx_mux3_rx_data_source)  //"fec_rx_data" "lb_tx2rx_data" "xcvr_fec_rx_data" "xcvr_rx_data"
) inst_ct3_hssi_rsfec (
  /* input logic [10:0]                                  */    .avmmaddress(),
  /* input logic                                         */    .avmmclk(o_rsfec_rsfecrx_mux_avmm2_clk),
  /* input logic                                         */    .avmmread(),
  /* input logic                                         */    .avmmwrite(),
  /* input logic [7:0]                                   */    .avmmwritedata(),
  /* input logic [3:0]                                   */    .i_adpt_tx_clk(i_coreip_ehip_port_adapter_tx_clock_in), // I'm not sure where this clock should come from
  /* input logic [311:0]                                 */    .i_adpt_tx_data(i_coreip_hssi_adapter_out_rsfec_tx_data_in),
	/* input logic [16:0]                                  */    .i_cfg_avmm2_addr(),
	/* input logic [5:0]                                   */    .i_cfg_avmm2_addr_id(),
	/* input logic [3:0]                                   */    .i_cfg_avmm2_byte_en(),
	/* input logic                                         */    .i_cfg_avmm2_clk(avmm_rsfec_clk),
	/* input logic                                         */    .i_cfg_avmm2_read(),
	/* input logic                                         */    .i_cfg_avmm2_rst_n(),
	/* input logic [31:0]                                  */    .i_cfg_avmm2_wdata(),
	/* input logic                                         */    .i_cfg_avmm2_write(),
  /* input logic                                         */    .i_ehip_clk(i_port_ehip_out_rsfec_clock_in),
  /* input logic [311:0]                                 */    .i_ehip_tx_data(i_port_ehip_out_tx_data_rsfec_in),
  /* input logic [311:0]                                 */    .i_elane_tx_data(i_coreip_elane_out_rsfec_tx_data_in),
  /* input logic [263:0]                                 */    .i_fec_rx_data(i_coreip_pma_out_rx_data_in_rsfec),
  /* input logic [3:0]                                   */    .i_fec_rx_valid(i_coreip_pma_out_rx_rsfec_in_data_valid),
  /* input logic [11:0]                                  */    .i_hip_aib_status(i_coreip_hip_aib_status_out_rsfec_in),
  /* input logic                                         */    .i_iocsr_rdy_dly(1'b1),
	/* input logic                                         */    .i_mbist0_dft_clk(),
	/* input logic                                         */    .i_mbist1_dft_clk(),
	/* input logic                                         */    .i_mbist2_dft_clk(),
	/* input logic                                         */    .i_mbist3_dft_clk(),
	/* input logic                                         */    .i_mbist4_dft_clk(),
	/* input logic                                         */    .i_mbist5_dft_clk(),
	/* input logic                                         */    .i_mbist6_dft_clk(),
	/* input logic                                         */    .i_mbist7_dft_clk(),
  /* input logic                                         */    .i_pld_ready(i_pld_adapt_out_rsfec_in_pld_ready),
  /* input logic [3:0]                                   */    .i_pma_rx_bit0_tag(i_coreip_pma_out_rx_rsfec_bit0_tag),
  /* input logic                                         */    .i_rst_n(i_pld_adapt_out_rsfec_in_reset_n),
  /* input logic                                         */    .i_rx_rst_n(i_pld_adapt_out_rsfec_in_rx_reset_n),
  /* input logic [3:0]                                   */    .i_signal_ok(i_pld_adapt_out_rsfec_in_signal_ok),
  /* input logic                                         */    .i_tx_rst_n(i_pld_adapt_out_rsfec_in_tx_reset_n),
  /* input logic                                         */    .i_user_mode(1'b1),
	/* output logic                                        */    .blockselect(),
	/* output logic [31:0]                                 */    .o_cfg_avmm2_rdata(),
	/* output logic                                        */    .o_cfg_avmm2_rdatavalid(),
	/* output logic                                        */    .o_cfg_avmm2_slave_active(),
	/* output logic                                        */    .o_cfg_avmm2_waitrequest(),
	/* output logic [1:0]                                  */    .o_cfg_core_rx_out_sel0(o_rsfecrx_mux_rsfec_out_rx_out_sel[0 +: FEC_LANE_RX_OUT_SEL_WIDTH]),
	/* output logic [1:0]                                  */    .o_cfg_core_rx_out_sel1(o_rsfecrx_mux_rsfec_out_rx_out_sel[FEC_LANE_RX_OUT_SEL_WIDTH +: FEC_LANE_RX_OUT_SEL_WIDTH]),
	/* output logic [1:0]                                  */    .o_cfg_core_rx_out_sel2(o_rsfecrx_mux_rsfec_out_rx_out_sel[2*FEC_LANE_RX_OUT_SEL_WIDTH +: FEC_LANE_RX_OUT_SEL_WIDTH]),
	/* output logic [1:0]                                  */    .o_cfg_core_rx_out_sel3(o_rsfecrx_mux_rsfec_out_rx_out_sel[3*FEC_LANE_RX_OUT_SEL_WIDTH +: FEC_LANE_RX_OUT_SEL_WIDTH]),
  /* output logic                                        */    .o_config_done(o_pld_adapt_in_rsfec_out_config_done),
  /* output logic [3:0]                                  */    .o_fec_adpt_clk(o_adapt_ehip_clock_rsfec),
	/* output logic [3:0]                                  */    .o_fec_core_rx_am_sync(o_rsfecrx_mux_rsfec_out_rx_am_sync),
	/* output logic [263:0]                                */    .o_fec_core_rx_data(o_rsfecrx_mux_rsfec_out_rx_data_in_rsfecrx_mux),
	/* output logic [3:0]                                  */    .o_fec_core_rx_valid(o_rsfecrx_mux_rsfec_out_rx_data_valid),
  /* output logic                                        */    .o_fec_ready(o_pld_adapt_in_rsfec_out_fec_ready),
  /* output logic [3:0]                                  */    .o_fec_rx_clk(o_coreip_rsfec_out_rx_pma_clk),
  /* output logic [3:0]                                  */    .o_fec_tx_clk(o_coreip_rsfec_out_tx_pma_clk),
  /* output logic [263:0]                                */    .o_fec_tx_data(o_coreip_rsfec_out_pma_tx_data),
  /* output logic [3:0]                                  */    .o_fec_tx_valid(o_coreip_rsfec_out_pma_tx_data_valid),
  /* output logic                                        */    .o_internal_error(o_pld_adapt_in_rsfec_out_internal_error),
	/* output logic                                        */    .o_irq_rsfec_lanes_rx_hold(),
	/* output logic [2:0]                                  */    .o_mbist0(),
	/* output logic [2:0]                                  */    .o_mbist1(),
	/* output logic [2:0]                                  */    .o_mbist2(),
	/* output logic [2:0]                                  */    .o_mbist3(),
	/* output logic [2:0]                                  */    .o_mbist4(),
	/* output logic [2:0]                                  */    .o_mbist5(),
	/* output logic [2:0]                                  */    .o_mbist6(),
	/* output logic [2:0]                                  */    .o_mbist7(),
  /* output logic [31:0]                                 */    .o_n_fec_chnl_ssr(pld_adapt_rsfec_channel_ssr_connection),
  /* output logic [15:0]                                 */    .o_n_fec_test_bus(),  // If this test bus is supposed to be connected somewhere, I don't know where
  /* output logic [51:0]                                 */    .o_pma_rx_cw_pos(o_coreip_rsfec_out_pma_rx_cw_pos),
  /* output logic [3:0]                                  */    .o_pma_tx_bit0_tag(o_coreip_rsfec_out_pma_tx_bit0_tag),
	/* output logic [21:0]                                 */    .o_rsfec_dft_cfg_pbist(),
  /* output logic                                        */    .o_rsfec_status_rx_not_align(o_pld_adapt_in_rsfec_out_status_rx_not_align),
  /* output logic                                        */    .o_rsfec_status_rx_not_deskew(o_pld_adapt_in_rsfec_out_status_rx_not_deskew),
/* output logic                                        */      .o_rx_dsk_marker(o_rsfec_out_rx_dsk_marker),  // Fogbugz case 542193, 528321
	/* output logic                                        */    .o_rx_fec_rst_n(),
  /* output logic                                        */    .o_tx_dsk_valid(o_pld_adapt_in_rsfec_out_tx_dsk_valid),
	/* output logic                                        */    .o_tx_fec_rst_n(),

  // RSFEC AVMM2 Interface Connections - added by Anthony
	/* input logic                                         */    .i_usr_avmm2_clk        ( avmm_rsfec_clk                         ),
  /* input logic                                         */    .i_usr_avmm2_rst        ( i_pld_adapt_out_rsfec_in_usr_avmm2_rst ),
	/* input logic [20:0]                                  */    .i_usr_avmm2_addr       ( {10'b0,avmm_rsfec_address}             ),
	/* input logic                                         */    .i_usr_avmm2_read       ( avmm_rsfec_read                        ),
	/* input logic                                         */    .i_usr_avmm2_write      ( avmm_rsfec_write                       ),
	/* input logic[7:0]                                    */    .i_usr_avmm2_wdata      ( avmm_rsfec_writedata                   ),
	/* output logic [7:0]                                  */    .o_usr_avmm2_rdata      ( avmm_rsfec_readdata                    ),
	/* output logic                                        */    .o_usr_avmm2_rdatavalid ( avmm_rsfec_rdatavld                    ),
	/* output logic                                        */    .o_usr_avmm2_writedone  ( avmm_rsfec_wrdone                      )
);

ct1_hssi_rsfec_pld_adapt # (
  .silicon_rev (hssi_rsfec_silicon_rev)
) hssi_rsfec_pld_adapt_u0 (
  /* input                */ .i_pld_ready                            (i_rsfec_pld_ready)                             ,
  /* output               */ .int_i_pld_ready                        (i_pld_adapt_out_rsfec_in_pld_ready)            ,
  /* input                */ .i_rst_n                                (int_rsfec_reset)                               ,
  /* output               */ .int_i_rst_n                            (i_pld_adapt_out_rsfec_in_reset_n)              ,
  /* input                */ .i_rx_rst_n                             (int_rx_rsfec_reset)                            ,
  /* output               */ .int_i_rx_rst_n                         (i_pld_adapt_out_rsfec_in_rx_reset_n)           ,
  /* input [3:0]          */ .i_signal_ok                            (rsfec_signal_ok)                               ,
  /* output [3:0]         */ .int_i_signal_ok                        (i_pld_adapt_out_rsfec_in_signal_ok)            ,
  /* input                */ .i_tx_rst_n                             (int_tx_rsfec_reset)                            ,
  /* output               */ .int_i_tx_rst_n                         (i_pld_adapt_out_rsfec_in_tx_reset_n)           ,
  /* input                */ .i_usr_avmm2_rst                        (rsfec_usr_avmm2_rst)                           ,
  /* output               */ .int_i_usr_avmm2_rst                    (i_pld_adapt_out_rsfec_in_usr_avmm2_rst)        ,
  /* input                */ .int_o_config_done                      (o_pld_adapt_in_rsfec_out_config_done)          ,
  /* output               */ .o_config_done                          (rsfec_o_config_done)                           ,
  /* input                */ .int_o_fec_ready                        (o_pld_adapt_in_rsfec_out_fec_ready)            ,
  /* output               */ .o_fec_ready                            (rsfec_o_fec_ready)                             ,
  /* input                */ .int_o_internal_error                   (o_pld_adapt_in_rsfec_out_internal_error)       ,
  /* output               */ .o_internal_error                       (rsfec_o_internal_error)                        ,
  /* input [31:0]         */ .int_o_n_fec_chnl_ssr                   (o_pld_adapt_in_rsfec_out_n_fec_channel_ssr)    ,
  /* output [31:0]        */ .o_n_fec_chnl_ssr                       (pld_adapt_native_phy_output_port_connection)   ,
  /* input                */ .int_o_rsfec_status_rx_not_align        (o_pld_adapt_in_rsfec_out_status_rx_not_align)  ,
  /* output               */ .o_rsfec_status_rx_not_align            (rsfec_o_status_rx_not_align)                   ,
  /* input                */ .int_o_rsfec_status_rx_not_deskew       (o_pld_adapt_in_rsfec_out_status_rx_not_deskew) ,
  /* output               */ .o_rsfec_status_rx_not_deskew           (rsfec_o_status_rx_not_deskew)                  ,
  /* input                */ .int_o_tx_dsk_valid                     (o_pld_adapt_in_rsfec_out_tx_dsk_valid)         ,
  /* output               */ .o_tx_dsk_valid                         (rsfec_o_tx_dsk_valid)                          ,
  /* input                */ .avmmclk                                (o_rsfec_rsfecrx_mux_avmm2_clk)
);


alt_xcvr_native_rcfg_opt_logic_isub23q #(
  .dbg_user_identifier                            ( dbg_user_identifier                 ),
  .dbg_embedded_debug_enable                      ( dbg_embedded_debug_enable           ),
  .dbg_capability_reg_enable                      ( dbg_capability_reg_enable           ),
  .dbg_stat_soft_logic_enable                     ( dbg_stat_soft_logic_enable          ),
  .dbg_ctrl_soft_logic_enable                     ( dbg_ctrl_soft_logic_enable          ),
  .CHANNELS                                       ( 1                                   ),
  .ADDR_BITS                                      ( RSFEC_RCFG_ADDR_BITS                ),
  .ADME_SLAVE_MAP                                 ( "altera_xcvr_rsfec_s10_etile"       ),
  .ADME_ASSGN_MAP                                 ( lcl_rsfec_adme_assgn_map            ),
  .RECONFIG_SHARED                                ( 0                                   ),
  .JTAG_ENABLED                                   ( rcfg_enable && rcfg_jtag_enable     ),
  .RCFG_EMB_STRM_ENABLED                          ( rcfg_enable && rcfg_emb_strm_enable ),
  .RCFG_PROFILE_CNT                               ( rcfg_profile_cnt                    )
) alt_xcvr_rsfec_optional_rcfg_logic (
  // User reconfig interface ports
  .reconfig_clk                                   ( reconfig_rsfec_clk                  ),
  .reconfig_reset                                 ( reconfig_rsfec_reset                ),
  .reconfig_write                                 ( reconfig_rsfec_write                ),
  .reconfig_read                                  ( reconfig_rsfec_read                 ),
  .reconfig_address                               ( reconfig_rsfec_address              ),
  .reconfig_writedata                             ( int_reconfig_rsfec_writedata        ),
  .reconfig_readdata                              ( int_reconfig_rsfec_readdata         ),
  .reconfig_waitrequest                           ( reconfig_rsfec_waitrequest          ),

  // AVMM ports to transceiver
  .avmm_clk                                       ( arb_avmm_clk                        ),
  .avmm_reset                                     ( arb_avmm_reset                      ),
  .avmm_write                                     ( arb_avmm_write                      ),
  .avmm_read                                      ( arb_avmm_read                       ),
  .avmm_address                                   ( arb_avmm_address                    ),
  .avmm_writedata                                 ( arb_avmm_writedata                  ),
  .avmm_readdata                                  ( arb_avmm_readdata                   ),
  .avmm_waitrequest                               ( arb_avmm_waitrequest                ),

  // input status signals from the transceiver
  .in_tx_pma_ready                                (  1'b0                               ),
  .in_rx_pma_ready                                (  1'b0                               ),
  .in_rx_is_lockedtodata                          (  1'b0                               ),
  .in_tx_transfer_ready                           (  1'b0                               ),
  .in_rx_transfer_ready                           (  1'b0                               ),

  // input control signals from the core
  .in_rx_analogreset                              (  1'b0                               ),
  .in_rx_digitalreset                             (  1'b0                               ),
  .in_tx_analogreset                              (  1'b0                               ),
  .in_tx_digitalreset                             (  1'b0                               ),
  .in_tx_ready                                    (  1'b0                               ),
  .in_rx_ready                                    (  1'b0                               ),

  //pma spico reset inputs
  .pma_reset                                      ( 1'b0                                ),
  .spico_reset                                    ( 1'b0                                ),

  //inputs from rx de-skew block
  .in_rx_dskw_min_mkr                             ( 1'b0                                ),

  // output control signals to the phy
  .out_rx_analogreset                             (                                     ),
  .out_rx_digitalreset                            (                                     ),
  .out_tx_analogreset                             (                                     ),
  .out_tx_digitalreset                            (                                     ),
  .rcp_load_finish                                (                  ),
  .rcp_load_timeout                               (                 )

);

//---------------------------------------------------------------------------------------
// Instantiate the AVMM2 Core IP
// This wrapper file contains the Crete 3 AVMM2 atom and the Crete 3 soft
// logic that supports AVMM2
//---------------------------------------------------------------------------------------

    logic [9:0] unused_avmm_addr_bits;

// JRJ - 1/29/2018 - fix for Fogbugz case 530895 from Jerry Giese's modification
    localparam hssi_avmm2_rsfec_topology = (hssi_rsfec_topology == "ehip_4ch_kpfec") ? "ehip_4ch_fec" : (hssi_rsfec_topology == "dir_kpfec_100g") ? "dirfec_100g" : hssi_rsfec_topology;

// JRJ - 5/4/2018 - Resolve same AVMM2 IP in both EHIP and Native PHY RSFEC.  Fogbugz case:546398
ct3_xcvr_avmm2_core_ip #(
  .avmm_interfaces        ( 1           ),
  .pldadapt_hip_mode      ( "user_chnl" ),
  .rcfg_enable            ( 1           ),
  .topology				  ( hssi_avmm2_rsfec_topology	),
  .func_mode			  ( l_hssi_rsfec_avmm2_func_mode   ),
  .pldadapt_osc_clk_scg_en ( l_hssi_rsfec_pldadapt_osc_clk_scg_en ),
  .pldadapt_avmm_clk_scg_en ( l_hssi_rsfec_pldadapt_avmm_clk_scg_en ),     // PLD Adapt. TODO.Valid values:disable,enable
  .hssiadapt_osc_clk_scg_en ( l_hssi_rsfec_hssiadapt_osc_clk_scg_en ),
  .hssiadapt_avmm_clk_scg_en ( l_hssi_rsfec_hssiadapt_avmm_clk_scg_en ),   // PLD Adapt. TODO.Valid values:disable,enable
  .hssiadapt_avmm_clk_dcg_en ( l_hssi_rsfec_hssiadapt_avmm_clk_dcg_en )
) ct3_xcvr_avmm2_inst (
  //"User" Inputs - outputs from rsfec_rcfg_opt_logic arbitration
  .avmm_clk               ( arb_avmm_clk         ),
  .avmm_reset             ( arb_avmm_reset       ),
  .avmm_write             ( arb_avmm_write       ),
  .avmm_read              ( arb_avmm_read        ),
  .avmm_address           ( {10'b0,arb_avmm_address}  ),  // The top ten bits of this port are not connected anyway
  .avmm_writedata         ( arb_avmm_writedata   ),
  //"User" Outputs - inputs to rsfec_rcfg_opt_logic arbitration
  .avmm_readdata          ( arb_avmm_readdata    ),
  .avmm_waitrequest       ( arb_avmm_waitrequest ),
  .avmm_busy              ( /* TODO */           ),
  .avmm_clkchnl           ( o_rsfec_rsfecrx_mux_avmm2_clk ),

  //Outputs to RSFEC atom
  .ehip_usr_clk           (  avmm_rsfec_clk       ),
  .ehip_usr_read          (  avmm_rsfec_read      ),
  .ehip_usr_addr          (  {unused_avmm_addr_bits,avmm_rsfec_address}   ),
  .ehip_usr_wdata         (  avmm_rsfec_writedata ),
  .ehip_usr_write         (  avmm_rsfec_write     ),
  //Inputs from the RSFEC atom
  .ehip_usr_wrdone        (  avmm_rsfec_wrdone    ),
  .ehip_usr_rdata         (  avmm_rsfec_readdata  ),
  .ehip_usr_rdatavld      (  avmm_rsfec_rdatavld  )

);

end: generate_RSFEC_block

endgenerate

//***************** Fixes for Fogbugz 517233 ********************************
/* TODO: Go back and add in the additional interfaces to interface.xls.
   This is a temporary fix for Crete 3 Power On
   JRJ - added to interface.xls in changelist 5022251  */

    wire [2 * l_channels - 1 : 0] w_out_o_xcvrif_aib_fsr_out;

//***************** End reset connections ***********************************
//***************************************************************************

generate

  for(ig=0;ig<l_channels;ig=ig+1) begin : g_xcvr_native_insts
  wire [39:0]  sth;
  if(lcl_instantiate_RSFEC_block && IS_USED_FEC_CHANNEL_3 && ig==FEC_CHANNEL_3) begin
    assign int_hip_aib_fsr_in[ig] = {i_rsfec_pld_ready, int_rx_rsfec_reset, int_tx_rsfec_reset, int_rsfec_reset};
//    assign sth[9]=rsfec_usr_avmm2_rst;
//    assign sth[3:0]=rsfec_signal_ok;
    assign sth = {30'b0,rsfec_usr_avmm2_rst,5'b0,rsfec_signal_ok};
    assign int_hip_aib_ssr_in[ig] = sth;
  end else begin
    assign int_hip_aib_fsr_in[ig] = hip_aib_fsr_in[ig*4+:4];
    assign int_hip_aib_ssr_in[ig] = hip_aib_ssr_in[ig*40+:40];
  end

//***************** Fixes for Fogbugz 517233 ********************************
/* TODO: Go back and add in the additional interfaces to interface.xls.
   This is a temporary fix for Crete 3 Power On
   JRJ - added to interface.xls in changelist 5022251  */

   assign EHIP_out_o_xcvrif_aib_fsr_out[ig] = w_out_o_xcvrif_aib_fsr_out[2 * ig];

//***************** End of temporary fixes for Fogbugz 517233 ********************************

	//****************
	// Clock connections
	//************
	wire	int_tx_coreclkin_rowclk;
	wire	int_tx_coreclkin_dclk;
	wire	int_rx_coreclkin_rowclk;
	wire	int_rx_coreclkin_dclk;
	wire	int_tx_coreclkin2_rowclk;
	wire	int_tx_coreclkin2_dclk;

	assign int_tx_coreclkin_rowclk	= (pldif_tx_coreclkin_clock_network == "rowclk") ? tx_coreclkin[ig] : 1'b0;
	assign int_tx_coreclkin_dclk	  = (pldif_tx_coreclkin_clock_network == "rowclk") ? 1'b0             : tx_coreclkin[ig];
	assign int_rx_coreclkin_rowclk	= (pldif_rx_coreclkin_clock_network == "rowclk") ? rx_coreclkin[ig] : 1'b0;
	assign int_rx_coreclkin_dclk	  = (pldif_rx_coreclkin_clock_network == "rowclk") ? 1'b0             : rx_coreclkin[ig];

	if (enable_port_tx_clkin2) begin
	        assign int_tx_coreclkin2_rowclk	= (pldif_tx_coreclkin2_clock_network == "rowclk") ? tx_coreclkin2[ig] : 1'b0;
	        assign int_tx_coreclkin2_dclk	= (pldif_tx_coreclkin2_clock_network == "rowclk") ? 1'b0                : tx_coreclkin2[ig];
	end else begin
		assign int_tx_coreclkin2_rowclk	= 1'b0;
		assign int_tx_coreclkin2_dclk   = 1'b0;
	end

	//************
	// Dedicated rx pll refclk connection
	//************
	wire int_dedicated_rx_pll_refclk;
        wire pll_refclk0_div, pll_refclk1_div, pll_refclk2_div, pll_refclk3_div, pll_refclk4_div;

       if (l_pma_txrx_pll_refclk0_div_en) begin
           ct3_hssi_cr3_refclk_divider #(
                .enable_div2   ("enable_div2"),
                .powerdown_mode  ("false")
            ) ct3_hssi_cr3_refclk_divider_ref0 (
                 .pad (pll_refclk0), //INPUT PAD
                 .mux_clk (pll_refclk0_div) //OUTPUT
            );
        end else begin
            assign pll_refclk0_div = pll_refclk0;
        end

       if (l_pma_txrx_pll_refclk1_div_en) begin
           ct3_hssi_cr3_refclk_divider #(
                .enable_div2   ("enable_div2"),
                .powerdown_mode  ("false")
            ) ct3_hssi_cr3_refclk_divider_ref1 (
                 .pad (pll_refclk1), //INPUT PAD
                 .mux_clk (pll_refclk1_div) //OUTPUT
            );
        end else begin
            assign pll_refclk1_div = pll_refclk1;
        end


       if (l_pma_txrx_pll_refclk2_div_en) begin
           ct3_hssi_cr3_refclk_divider #(
                .enable_div2   ("enable_div2"),
                .powerdown_mode  ("false")
            ) ct3_hssi_cr3_refclk_divider_ref2 (
                 .pad (pll_refclk2), //INPUT PAD
                 .mux_clk (pll_refclk2_div) //OUTPUT
            );
        end else begin
            assign pll_refclk2_div = pll_refclk2;
        end

       if (l_pma_txrx_pll_refclk3_div_en) begin
           ct3_hssi_cr3_refclk_divider #(
                .enable_div2   ("enable_div2"),
                .powerdown_mode  ("false")
            ) ct3_hssi_cr3_refclk_divider_ref3 (
                 .pad (pll_refclk3), //INPUT PAD
                 .mux_clk (pll_refclk3_div) //OUTPUT
            );
        end else begin
            assign pll_refclk3_div = pll_refclk3;
        end
       if (l_pma_txrx_pll_refclk4_div_en) begin
           ct3_hssi_cr3_refclk_divider #(
                .enable_div2   ("enable_div2"),
                .powerdown_mode  ("false")
            ) ct3_hssi_cr3_refclk_divider_ref4 (
                 .pad (pll_refclk4), //INPUT PAD
                 .mux_clk (pll_refclk4_div) //OUTPUT
            );
        end else begin
            assign pll_refclk4_div = pll_refclk4;
        end

	assign int_dedicated_rx_pll_refclk = (l_pma_rx_dedicated_refclk_enable && pma_rx_dedicated_refclk_select==0) ? pll_refclk0_div
                                           : (l_pma_rx_dedicated_refclk_enable && pma_rx_dedicated_refclk_select==1) ? pll_refclk1_div
                                           : (l_pma_rx_dedicated_refclk_enable && pma_rx_dedicated_refclk_select==2) ? pll_refclk2_div
                                           : (l_pma_rx_dedicated_refclk_enable && pma_rx_dedicated_refclk_select==3) ? pll_refclk3_div
                                           : (l_pma_rx_dedicated_refclk_enable && pma_rx_dedicated_refclk_select==4) ? pll_refclk4_div
                                           : 1'b0;


	//************
	// Dual channel connections
	//************

	//****************
	// EHIP-RSFEC/C3XCVR interface connections
	//****************

	//****************
	// EHIP-Adapter interface connections
	//****************

	//****************
	// Misc connections
	//************
	wire	[15:0] int_pma_core_status;//TODO one level up
	wire	[15:0] int_pma_core_cntl;//TODO one level up
	wire	[11:0] int_pmaif_test_out;

	//**************************
	// Channel level bonding parameters
	//**************************


	//**************************
	// Adapter level bonding parameters
	//**************************

	//**************************
	// String to binary conversions
	//**************************
        localparam [35:0] temp_lcl_hssi_xcvr_rx_datarate_bps = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_rx_datarate_bps);
        localparam [35:0] temp_lcl_hssi_xcvr_rx_refclk_freq = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_rx_refclk_freq);
        localparam [35:0] temp_lcl_hssi_xcvr_tx_datarate_bps = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_tx_datarate_bps);
        localparam [35:0] temp_lcl_hssi_xcvr_tx_refclk_freq = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_tx_refclk_freq);
        localparam [35:0] temp_lcl_hssi_xcvr_powermode_ac_avmm_freq_hz = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_powermode_ac_avmm_freq_hz);
        localparam [35:0] temp_lcl_hssi_xcvr_rx_pma_width_sd = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_rx_pma_width_sd);
        localparam [35:0] temp_lcl_hssi_xcvr_tx_pma_width_sd = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_tx_pma_width_sd);
        localparam [31:0] temp_lcl_hssi_xcvr_tx_reset_val_31_0 = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_tx_reset_val_31_0);
        localparam [31:0] temp_lcl_hssi_xcvr_tx_reset_val_63_32 = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_tx_reset_val_63_32);
        localparam [31:0] temp_lcl_hssi_xcvr_xcvr_spare_ctrl0 = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_xcvr_spare_ctrl0);
        localparam [31:0] temp_lcl_hssi_xcvr_xcvr_spare_ctrl1 = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_xcvr_spare_ctrl1);
        localparam [35:0] temp_lcl_hssi_aibcr_rx_rx_transfer_clk_freq = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_aibcr_rx_rx_transfer_clk_freq);
        localparam [35:0] temp_lcl_hssi_aibcr_rx_rx_transfer_clk_freq_hz = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_aibcr_rx_rx_transfer_clk_freq_hz);
        localparam [35:0] temp_lcl_hssi_aibcr_tx_tx_transfer_clk_freq = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_aibcr_tx_tx_transfer_clk_freq);
        localparam [35:0] temp_lcl_hssi_aibcr_tx_tx_transfer_clk_freq_hz = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_aibcr_tx_tx_transfer_clk_freq_hz);
        localparam [31:0] temp_lcl_hssi_ehip_lane_ptp_debug = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_ptp_debug);
        localparam [31:0] temp_lcl_hssi_ehip_lane_rx_aib_dp_latency = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_rx_aib_dp_latency);
        localparam [47:0] temp_lcl_hssi_ehip_lane_rx_pause_daddr = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_rx_pause_daddr);
        localparam [31:0] temp_lcl_hssi_ehip_lane_rx_ptp_dp_latency = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_rx_ptp_dp_latency);
        localparam [31:0] temp_lcl_hssi_ehip_lane_rx_ptp_extra_latency = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_rx_ptp_extra_latency);
        localparam [31:0] temp_lcl_hssi_ehip_lane_tx_aib_dp_latency = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_tx_aib_dp_latency);
        localparam [47:0] temp_lcl_hssi_ehip_lane_tx_pause_daddr = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_tx_pause_daddr);
        localparam [47:0] temp_lcl_hssi_ehip_lane_tx_pause_saddr = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_tx_pause_saddr);
        localparam [31:0] temp_lcl_hssi_ehip_lane_tx_ptp_asym_latency = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_tx_ptp_asym_latency);
        localparam [31:0] temp_lcl_hssi_ehip_lane_tx_ptp_dp_latency = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_tx_ptp_dp_latency);
        localparam [31:0] temp_lcl_hssi_ehip_lane_tx_ptp_extra_latency = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_tx_ptp_extra_latency);
        localparam [47:0] temp_lcl_hssi_ehip_lane_txmac_saddr = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_ehip_lane_txmac_saddr);

	// * JRJ 11/10/2018 ******************************************************************************
    // * String to binary conversion for bti_protected channels
    // JRJ - 1/15/2019 - change for 19.1 - BTI protected channels are all passed the same phony tx and rx data rate, 2500000000 bps (2.5 Gbps)
		// localparam [35:0] bin_bti_hssi_xcvr_tx_data_rate_bps = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_tx_data_rate_bps);
		// localparam [35:0] bin_bti_hssi_xcvr_rx_data_rate_bps = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_rx_data_rate_bps);
        localparam bti_hssi_xcvr_passed_phony_rx_data_rate_bps = bti_hssi_xcvr_passed_phony_tx_data_rate_bps;
		localparam [35:0] bin_bti_hssi_xcvr_tx_data_rate_bps = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_passed_phony_tx_data_rate_bps);
		localparam [35:0] bin_bti_hssi_xcvr_rx_data_rate_bps = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_passed_phony_rx_data_rate_bps);

// String to binary conversion for hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz and hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz for BTI protected channels

        localparam [35:0] temp_bti_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz      = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz);
        localparam [35:0] temp_bti_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz      = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz);


        localparam [7:0] bin_bti_hssi_xcvr_int_seq3_tx_refclk_ratio = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_int_seq3_tx_refclk_ratio);
        localparam [7:0] bin_bti_hssi_xcvr_int_seq4_rx_refclk_ratio = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_int_seq4_rx_refclk_ratio);
// JRJ - 12/8/2018 Change for BTI protect RBC rule change.  Related to case 1506957458
        localparam [35:0] bti_protect_refclock_freq = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10("125000000");
	//************
	// Bonding and Dual channel parameters
	//************
	localparam is_dual_channel_slave = (ig%2==1) ? 1 : 0;
	localparam is_idx_odd = (ig%2==1) ? 1 : 0;
	localparam is_bonded = (hssi_xcvr_bonding_mode=="bonded") ? 1 : 0;

        localparam temp_l_hssi_xcvr_set_refclk_sel           = l_hssi_xcvr_set_refclk_sel;
	localparam [35:0] temp_l_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(l_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz);
	localparam [35:0] temp_bti_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz = (l_hssi_xcvr_func_mode != "disabled") ? altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz) : 36'd0;
        localparam [35:0] lcl_hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz     = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz);
        localparam [35:0] bin_bti_protect_hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz     = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_powermode_ac_serdes_rx_par_freq_hz);
        localparam [35:0] temp_l_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz      = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(l_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz);
        localparam [35:0] temp_l_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(l_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz);
	localparam [35:0] temp_bti_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz = (l_hssi_xcvr_func_mode != "disabled") ? altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz) : 36'd0;
        localparam [35:0] lcl_hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz     = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz);
	localparam [35:0] bin_bti_protect_hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz     = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_powermode_ac_serdes_tx_par_freq_hz);
        localparam [35:0] temp_l_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz      = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(l_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz);


	localparam        lcl_hssi_xcvr_set_refclk_sel	            = (is_dual_channel&&is_dual_channel_slave) || (l_hssi_xcvr_func_mode=="disabled")  ? "i_refclk9" : temp_l_hssi_xcvr_set_refclk_sel;//TODO once rbc fixed ie no need for 9 this should be changed

	localparam        lcl_hssi_xcvr_int_seq3_refclk_sync_master = (is_bonded && ig==0) ? "refclk_sync_master" : (is_bonded) ? "refclk_sync_slave" : l_hssi_xcvr_int_seq3_refclk_sync_master;
	localparam        lcl_hssi_xcvr_tx_deskew                   = (is_bonded && ig==0)                      ? "tx_dsk_bot" :
	                                                              (is_bonded && ig==(l_channels-1))         ? "tx_dsk_top" :
	                                                              (is_bonded)                               ? "tx_dsk_mid" :
	                                                              (is_dual_channel_dir&&is_dual_channel_slave)  ? "tx_dsk_top" :
	                                                              (is_dual_channel_dir&&!is_dual_channel_slave) ? "tx_dsk_bot" : l_hssi_xcvr_tx_deskew;
	localparam        lcl_hssi_xcvr_tx_dskew_ml_sel             = (is_bonded && is_dual_channel_dir && !is_dual_channel_slave) ? "ml_dsk_sel_ck_above_ckb_below"  :
	                                                              (is_bonded && is_dual_channel_dir && is_dual_channel_slave)  ? "ml_dsk_sel_ckb_above_ck_below"  :
	                                                              (is_bonded && ig==0)                                     ? "ml_dsk_sel_ckb_above_ck_below"  :
	                                                              (is_bonded && ig==(l_channels-1))                        ? "ml_dsk_sel_ck_above_ckb_below"  :
	                                                              (is_bonded)                                              ? "ml_dsk_sel_ckb_above_ckb_below" : "ml_dsk_sel_ck_above_ck_below";
	localparam        lcl_hssi_xcvr_cfg_hw_mode_sel             = (is_dual_channel_dir&&is_dual_channel_slave) ? "hwdec_pma_dir_dc_slv"     : l_hssi_xcvr_cfg_hw_mode_sel;
	localparam        lcl_hssi_xcvr_seq_en_tx_post1             = (is_dual_channel&&is_dual_channel_slave) ? "dis_tx_post1_seq"             : l_hssi_xcvr_seq_en_tx_post1;
	localparam        lcl_hssi_xcvr_seq_en_tx_pre1              = (is_dual_channel&&is_dual_channel_slave) ? "dis_tx_pre1_seq"              : l_hssi_xcvr_seq_en_tx_pre1;
	localparam        lcl_hssi_xcvr_seq_en_tx_slew              = (is_dual_channel&&is_dual_channel_slave) ? "dis_tx_slew_seq"              : l_hssi_xcvr_seq_en_tx_slew;
	localparam        lcl_hssi_xcvr_serdes_en_seq               = (is_dual_channel&&is_dual_channel_slave) ? "dis_serdes_seq"               : l_hssi_xcvr_serdes_en_seq;
	localparam        lcl_hssi_xcvr_set_int_seq_serd_en         = (is_dual_channel&&is_dual_channel_slave) ? "seq_dis_all"                  : l_hssi_xcvr_set_int_seq_serd_en;
	localparam        lcl_hssi_xcvr_tx_clk_out_sel              = (is_dual_channel&&is_dual_channel_slave) ? "tx_clk_out_sel_1"             : l_hssi_xcvr_tx_clk_out_sel;
	localparam        lcl_hssi_xcvr_rx_ml_sel                   = (is_dual_channel_dir&&is_dual_channel_slave) ? "rx_ml_sel_0"              : l_hssi_xcvr_rx_ml_sel;
	localparam        lcl_hssi_xcvr_func_mode                   = (is_dual_channel_dir&&is_dual_channel_slave) ? "pma_dir_dc_slv"           : (is_dual_channel_fec&&is_dual_channel_slave) ? "rsfec_dc_slv" : l_hssi_xcvr_func_mode;

	localparam        lcl_hssi_xcvr_seq_en_bitwidth             = (is_dual_channel&&is_dual_channel_slave) ? "dis_bitwidth_seq"             : l_hssi_xcvr_seq_en_bitwidth;
	localparam        lcl_hssi_xcvr_seq_en_crc                  = (is_dual_channel&&is_dual_channel_slave) ? "dis_crc_seq"                  : l_hssi_xcvr_seq_en_crc;
	localparam        lcl_hssi_xcvr_seq_en_rx_bitrate           = (is_dual_channel&&is_dual_channel_slave) ? "dis_rx_bitrate_seq"           : l_hssi_xcvr_seq_en_rx_bitrate;
	localparam        lcl_hssi_xcvr_seq_en_tx_amp               = (is_dual_channel&&is_dual_channel_slave) ? "dis_tx_amp_seq"               : l_hssi_xcvr_seq_en_tx_amp;
	localparam        lcl_hssi_xcvr_seq_en_tx_atten             = (is_dual_channel&&is_dual_channel_slave) ? "dis_tx_atten_seq"             : l_hssi_xcvr_seq_en_tx_atten;
	localparam        lcl_hssi_xcvr_seq_en_tx_bitrate           = (is_dual_channel&&is_dual_channel_slave) ? "dis_tx_bitrate_seq"           : l_hssi_xcvr_seq_en_tx_bitrate;
	localparam        lcl_hssi_xcvr_seq_en_tx_broadcast         = (is_dual_channel&&is_dual_channel_slave) ? "dis_tx_broadcast_seq"         : l_hssi_xcvr_seq_en_tx_broadcast;
	localparam        lcl_hssi_xcvr_rx_adapter_sel              = (is_dual_channel&&is_dual_channel_slave) ? "rx_adapter_sel_ch0_data_reg"  : l_hssi_xcvr_rx_adapter_sel;
	localparam        lcl_hssi_xcvr_interrupt_window_enable     = (is_dual_channel&&is_dual_channel_slave) ? "dis_window_logic"             : l_hssi_xcvr_interrupt_window_enable;
	localparam        lcl_hssi_xcvr_tx_ml_sel                   = (is_dual_channel_dir&&is_dual_channel_slave) ? "tx_ml_sel_1"              : (is_dual_channel_fec&&is_dual_channel_slave) ? "tx_ml_sel_2" : l_hssi_xcvr_tx_ml_sel;
    //* JRJ 11/10/2018
	// localparam to indicate if this is a bti_protected channel
    //****************
	localparam		  lcl_hssi_xcvr_bti_protected				= (is_dual_channel&&is_dual_channel_slave) ? bti_channels_hssi_xcvr_bti_protected		: 0;
    localparam		  lcl_hssi_xcvr_bti_protected_string        = lcl_hssi_xcvr_bti_protected ? "true" : "false";

    // bti_protected channels have a different value of hssi_xcvr_powermode_ac_serdes_tx depending upon whether lowpower mode is on or not
	localparam        lcl_hssi_xcvr_powermode_ac_serdes_tx = (is_dual_channel&&is_dual_channel_slave) ? ( lcl_hssi_xcvr_bti_protected ? bti_hssi_xcvr_powermode_ac_serdes_tx : "ac_tx_serdes_off" ) : l_hssi_xcvr_powermode_ac_serdes_tx;

    // bti_protected channels have a different value of hssi_xcvr_powermode_ac_serdes_rx depending upon whether lowpower mode is on or not
	localparam        lcl_hssi_xcvr_powermode_ac_serdes_rx = (is_dual_channel&&is_dual_channel_slave) ? ( lcl_hssi_xcvr_bti_protected ? bti_hssi_xcvr_powermode_ac_serdes_rx : "ac_rx_serdes_off" ) : l_hssi_xcvr_powermode_ac_serdes_rx;

// JRJ - 6/1/2019 - change for 19.2 - BTI protected channels have hssi_xcvr_powermode_dc_serdes_tx/rx set to DC_TX/RX_SERDES_LPM_ON
// This is for RBC change from Dinesh Kotti May 31, 2019.  However, I don't think this is right yet because this will always set low-power mode whether the
// transceiver is in low power mode or not.
// JRJ - 6/3/2019 This has been corrected.  Now a new parameter is passed that sets hssi_xcvr_powermode_dc_serdes_tx and hssi_xcvr_powermode_dc_serdes_rx similarly to the way
// the ac powermode parameters are set in the section above.

	localparam        lcl_hssi_xcvr_powermode_dc_serdes_tx      = (is_dual_channel&&is_dual_channel_slave) ? ( lcl_hssi_xcvr_bti_protected ? bti_hssi_xcvr_powermode_dc_serdes_tx : "powerdown_dc_tx_serdes" ) : l_hssi_xcvr_powermode_dc_serdes_tx;
	localparam        lcl_hssi_xcvr_powermode_dc_serdes_rx      = (is_dual_channel&&is_dual_channel_slave) ? ( lcl_hssi_xcvr_bti_protected ? bti_hssi_xcvr_powermode_dc_serdes_rx : "powerdown_dc_rx_serdes" ) : l_hssi_xcvr_powermode_dc_serdes_rx;

//  bti_protected channels are set to a different data rate
    localparam		  bin_hssi_xcvr_tx_datarate_bps = lcl_hssi_xcvr_bti_protected ?  bin_bti_hssi_xcvr_tx_data_rate_bps : temp_lcl_hssi_xcvr_tx_datarate_bps;
    localparam		  bin_hssi_xcvr_rx_datarate_bps = lcl_hssi_xcvr_bti_protected ?  bin_bti_hssi_xcvr_rx_data_rate_bps : temp_lcl_hssi_xcvr_rx_datarate_bps;

// bti_protected channels have a different value for hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz and hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz
        localparam [35:0] lcl_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz = (is_dual_channel&&is_dual_channel_slave) ? ( lcl_hssi_xcvr_bti_protected ? temp_bti_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz : 36'd0 ) : temp_l_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz;

        localparam [35:0] lcl_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz = (is_dual_channel&&is_dual_channel_slave) ? ( lcl_hssi_xcvr_bti_protected ? temp_bti_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz : 36'd0 ) : temp_l_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz;

// bti_protected channels have a different value for bti_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz and bti_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz
        localparam [35:0] lcl_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz = (is_dual_channel && is_dual_channel_slave && lcl_hssi_xcvr_bti_protected) ? temp_bti_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz : temp_l_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz;
        localparam [35:0] lcl_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz = (is_dual_channel && is_dual_channel_slave && lcl_hssi_xcvr_bti_protected) ? temp_bti_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz : temp_l_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz;

    // bti_protected channels use the same refclock for both tx and rx
    //localparam        bin_bti_hssi_xcvr_tx_refclk_freq = bti_use_tx_refclk ? temp_lcl_hssi_xcvr_tx_refclk_freq : temp_lcl_hssi_xcvr_rx_refclk_freq;
    //localparam        bin_bti_hssi_xcvr_rx_refclk_freq = bti_use_tx_refclk ? temp_lcl_hssi_xcvr_tx_refclk_freq : temp_lcl_hssi_xcvr_rx_refclk_freq;

    // JRJ - 3/13/2020 - change for 20.1 - BTI protected channels will use a user-specified reference clock frequency which must match the qsf assignments
    localparam        bin_bti_hssi_xcvr_tx_refclk_freq = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_channels_hssi_xcvr_bti_ref_clock_freq_hz);
    localparam        bin_bti_hssi_xcvr_rx_refclk_freq = altera_xcvr_native_s10_functions_h::str_2_bin_alt_xcvr_native_s10(bti_channels_hssi_xcvr_bti_ref_clock_freq_hz);
// JRJ - 1/15/2019 - change for 19.1 - BTI protected channels use same reference clock frequency as master channels
// JRJ - 3/13/2020 - change for 20.1 - BTI protected channels use a user-specified reference clock frequency
    // localparam	      bin_hssi_xcvr_tx_refclk_freq = lcl_hssi_xcvr_bti_protected ? bti_protect_refclock_freq : temp_lcl_hssi_xcvr_tx_refclk_freq;
    // localparam         bin_hssi_xcvr_rx_refclk_freq = lcl_hssi_xcvr_bti_protected ? bti_protect_refclock_freq : temp_lcl_hssi_xcvr_rx_refclk_freq;
    localparam	      bin_hssi_xcvr_tx_refclk_freq = lcl_hssi_xcvr_bti_protected ? bin_bti_hssi_xcvr_tx_refclk_freq : temp_lcl_hssi_xcvr_tx_refclk_freq;
    localparam        bin_hssi_xcvr_rx_refclk_freq = lcl_hssi_xcvr_bti_protected ? bin_bti_hssi_xcvr_rx_refclk_freq : temp_lcl_hssi_xcvr_rx_refclk_freq;

// JRJ - 1/15/2019 - change for 19.1 - BTI protected channels use same reference clock selection as master channels
// JRJ - 12/8/2018 Change for BTI protect RBC rule change.  Related to case 1506957458
// JRJ - 3/13/2020 Note that the previous version of this always set the reference clock selection to the same value if the slave channel was enabled
//                 Change for 20.1 - BTI protected channels will use a user specified reference clock selection
localparam        lcl_bti_protect_hssi_xcvr_set_refclk_sel = lcl_hssi_xcvr_bti_protected ? "i_refclk0" : lcl_hssi_xcvr_set_refclk_sel;
// localparam        lcl_bti_protect_hssi_xcvr_set_refclk_sel = lcl_hssi_xcvr_bti_protected ? bti_channels_hssi_xcvr_bti_ref_clock_sel : lcl_hssi_xcvr_set_refclk_sel;
    // localparam        lcl_bti_protect_hssi_xcvr_set_refclk_sel = lcl_hssi_xcvr_bti_protected ? temp_l_hssi_xcvr_set_refclk_sel : lcl_hssi_xcvr_set_refclk_sel;
    // localparam        lcl_bti_protect_hssi_xcvr_set_refclk_sel = lcl_hssi_xcvr_bti_protected ? lcl_hssi_xcvr_set_refclk_sel : lcl_hssi_xcvr_set_refclk_sel;
// JRJ - 12/8/2018 End of change for BTI protect RBC rule change.
    // bti_protected channels must be set to xcvr_duplex mode regardless of the setting of the other channels
    localparam        lcl_hssi_xcvr_channel_mode = lcl_hssi_xcvr_bti_protected ? "xcvr_duplex" : hssi_xcvr_channel_mode;
    // bti protected channels must be set to NRZ mode regardless of the setting of the other channels
    localparam        lcl_hssi_xcvr_serdes_tx_enc = lcl_hssi_xcvr_bti_protected ? "tx_nrz" : hssi_xcvr_serdes_tx_enc;
    localparam        lcl_hssi_xcvr_serdes_rx_enc = lcl_hssi_xcvr_bti_protected ? "rx_nrz" : hssi_xcvr_serdes_rx_enc;
    // bti protected channels must have PMA interface width set to 32 for both TX and RX regardless of the setting of the other channels
    localparam        lcl_hssi_xcvr_tx_pma_width = lcl_hssi_xcvr_bti_protected ? "tx_width_32" : hssi_xcvr_tx_pma_width;
    localparam        bti_lcl_hssi_xcvr_tx_pma_width_sd = lcl_hssi_xcvr_bti_protected ? 36'd32 : temp_lcl_hssi_xcvr_tx_pma_width_sd;
    localparam        lcl_hssi_xcvr_rx_pma_width = lcl_hssi_xcvr_bti_protected ? "rx_width_32" : hssi_xcvr_rx_pma_width;
    localparam        bti_lcl_hssi_xcvr_rx_pma_width_sd = lcl_hssi_xcvr_bti_protected ? 36'd32 : temp_lcl_hssi_xcvr_rx_pma_width_sd;
    // bti protected channels must have hssi_xcvr_int_seq3_refclk_cfg_both set to "refclk_cfg_tx".  As of right now, all channels are set this way by the overrides in the validation
    // procedure.  If this changes in the future, the bti protected channels won't be changed unless this section of RTL is changed
    localparam        lcl_hssi_xcvr_int_seq3_refclk_cfg_both = lcl_hssi_xcvr_bti_protected ? "refclk_cfg_tx" : hssi_xcvr_int_seq3_refclk_cfg_both;
    // bti protected channels must have the parameter hssi_xcvr_int_seq3_refclk_sync_master set to "refclk_sync_master".  Currently
    // the RBC rules do not fully resolve this parameter, so
    // it is resolved in the RTL to the parameter lcl_hssi_xcvr_int_seq3_refclk_sync_master which is passed to the channel instance.  The localparam defined here will override
    // lcl_hssi_xcvr_int_seq3_refclk_sync_master for bti protected channels.
    localparam        lcl_bti_protect_hssi_xcvr_int_seq3_refclk_sync_master = lcl_hssi_xcvr_bti_protected ? "refclk_sync_master" : lcl_hssi_xcvr_int_seq3_refclk_sync_master;
    // bti protected channels must have the parameter hssi_xcvr_int_seq3_tx_bit_rate set to "tx_full_rate" regardless of the setting of the other channels.
    localparam        lcl_hssi_xcvr_int_seq3_tx_bit_rate = lcl_hssi_xcvr_bti_protected ? "tx_full_rate" : hssi_xcvr_int_seq3_tx_bit_rate;
    // bti protected channels will always be NRZ encoded and will always have hssi_xcvr_int_seq3_tx_bit_rate set to "tx_full_rate".  This means that they must always have
    // hssi_xcvr_int_seq3_tx_refclk_ratio set to 1*bti_hssi_xcvr_tx_data_rate_bps/hssi_xcvr_tx_refclk_freq.  We will compute this in tcl and pass it in.
    localparam        lcl_hssi_xcvr_int_seq3_tx_refclk_ratio = lcl_hssi_xcvr_bti_protected ? bin_bti_hssi_xcvr_int_seq3_tx_refclk_ratio : hssi_xcvr_int_seq3_tx_refclk_ratio;
    // bti protected channels must have the parameter hssi_xcvr_int_seq4_refclk_cfg_both set to "refclk_cfg_rx".  As of right now, all channels are set this way by the overrides in
    // the validation procedure.  If this changes in the future, the bti protected channels won't be changed unless this section of RTL is changed
    localparam        lcl_hssi_xcvr_int_seq4_refclk_cfg_both = lcl_hssi_xcvr_bti_protected ? "refclk_cfg_rx" : hssi_xcvr_int_seq4_refclk_cfg_both;
    // bti protected channels must have the parameter hssi_xcvr_int_seq4_rx_bit_rate set to "rx_full_rate" regardless of the setting of the other channels.
    localparam        lcl_hssi_xcvr_int_seq4_rx_bit_rate = lcl_hssi_xcvr_bti_protected ? "rx_full_rate" : hssi_xcvr_int_seq4_rx_bit_rate;
    // bti protected channels will always be NRZ encoded and will always have hssi_xcvr_int_seq4_rx_bit_rate set to "rx_full_rate".  This means that they must always have
    // hssi_xcvr_int_seq3_rx_refclk_ratio set to 1*bti_hssi_xcvr_rx_data_rate_bps/hssi_xcvr_rx_refclk_freq.  We will compute this in tcl and pass it in.
    localparam        lcl_hssi_xcvr_int_seq4_rx_refclk_ratio = lcl_hssi_xcvr_bti_protected ? bin_bti_hssi_xcvr_int_seq4_rx_refclk_ratio : hssi_xcvr_int_seq4_rx_refclk_ratio;
    // bti protected channels must have the parameter hssi_xcvr_interrupt_window_enable set to "en_window_logic" regardless of the setting of the other channels.
    localparam        lcl_bti_protect_hssi_xcvr_interrupt_window_enable = lcl_hssi_xcvr_bti_protected ? "en_window_logic" : lcl_hssi_xcvr_interrupt_window_enable;
    // bti protected channels must have the parameter hssi_xcvr_seq_en_bitwidth set to "en_bitwidth_seq" regardless of the setting of the other channels.
    localparam        lcl_bti_protect_hssi_xcvr_seq_en_bitwidth = lcl_hssi_xcvr_bti_protected ? "en_bitwidth_seq" : lcl_hssi_xcvr_seq_en_bitwidth;
    // bti protected channels must have the parameter hssi_xcvr_seq_en_reserved2 set to "en_reserved2_seq" regardless of the setting of the other channels.
    localparam        lcl_hssi_xcvr_seq_en_reserved2 = lcl_hssi_xcvr_bti_protected ? "en_reserved2_seq" : hssi_xcvr_seq_en_reserved2;
    // bti protected channels must have the parameter hssi_xcvr_seq_en_reserved3 set to "en_reserved3_seq" regardless of the setting of the other channels.
    localparam        lcl_hssi_xcvr_seq_en_reserved3 = lcl_hssi_xcvr_bti_protected ? "en_reserved3_seq" : hssi_xcvr_seq_en_reserved3;
    // bti protected channels must have the parameter hssi_xcvr_seq_en_rx_bitrate set to "en_rx_bitrate_seq" regardless of the setting of the other channels.
    localparam        lcl_bti_protect_hssi_xcvr_seq_en_rx_bitrate = lcl_hssi_xcvr_bti_protected ? "en_rx_bitrate_seq" : lcl_hssi_xcvr_seq_en_rx_bitrate;
    // bti protected channels must have the parameter hssi_xcvr_seq_en_tx_bitrate set to "en_tx_bitrate_seq" regardless of the setting of the other channels.
    localparam        lcl_bti_protect_hssi_xcvr_seq_en_tx_bitrate = lcl_hssi_xcvr_bti_protected ? "en_tx_bitrate_seq" : lcl_hssi_xcvr_seq_en_tx_bitrate;
    // bti protected channels must have the parameter hssi_xcvr_serdes_en_seq set to "en_serdes_seq" regardless of the setting of the other channels.
    localparam        lcl_bti_protect_hssi_xcvr_serdes_en_seq = lcl_hssi_xcvr_bti_protected ? "en_serdes_seq" : lcl_hssi_xcvr_serdes_en_seq;
    // bti protected channels must have the parameter hssi_xcvr_set_int_seq14_code set to 2 (decimal) regardless of the setting of the other channels.
    // I may have to revisit this assignment and set the width of the parameter explicitly.
    localparam        lcl_hssi_xcvr_set_int_seq14_code = lcl_hssi_xcvr_bti_protected ? 16'd2 : hssi_xcvr_set_int_seq14_code;
    // bti protected channels must have the parameter hssi_xcvr_set_int_seq14_data set to 288 (decimal) or 0x125 regardless of the setting of the other channels.
    // I may have to revisit this assignment and set the width of the parameter explicitly.
    localparam        lcl_hssi_xcvr_set_int_seq14_data = lcl_hssi_xcvr_bti_protected ? 16'd288 : hssi_xcvr_set_int_seq14_data;
    // bti protected channels must have the parameter hssi_xcvr_set_int_seq15_code set to 8 (decimal) regardless of the setting of the other channels.
    // I may have to revisit this assignment and set the width of the parameter explicitly.
    localparam        lcl_hssi_xcvr_set_int_seq15_code = lcl_hssi_xcvr_bti_protected ? 16'd8 : hssi_xcvr_set_int_seq15_code;
    // bti protected channels must have the parameter hssi_xcvr_set_int_seq15_data set to 257 (decimal) or 0x101 regardless of the setting of the other channels.
    // I may have to revisit this assignment and set the width of the parameter explicitly.
    localparam        lcl_hssi_xcvr_set_int_seq15_data = lcl_hssi_xcvr_bti_protected ? 16'd257 : hssi_xcvr_set_int_seq15_data;
    // bti protected channels must have the parameter hssi_xcvr_set_int_seq_serd_en set to "seq_en_tx_rx" regardless of the setting of the other channels.
    localparam        lcl_bti_protect_hssi_xcvr_set_int_seq_serd_en = lcl_hssi_xcvr_bti_protected ? "seq_en_tx_rx" : lcl_hssi_xcvr_set_int_seq_serd_en;
    // bti protected channels must have parameter hssi_xcvr_cfg_rb_dcc_en set to the value of bti_hssi_xcvr_cfg_rb_dcc_en, which is passed in from the validation procedure.
    localparam        lcl_hssi_xcvr_cfg_rb_dcc_en = lcl_hssi_xcvr_bti_protected ? bti_hssi_xcvr_cfg_rb_dcc_en : hssi_xcvr_cfg_rb_dcc_en;
	localparam        lcl_hssi_xcvr_cfg_rb_dcc_byp = lcl_hssi_xcvr_bti_protected ? bti_hssi_xcvr_cfg_rb_dcc_byp : hssi_xcvr_cfg_rb_dcc_byp;
    // bti protected channels must have parameter hssi_xcvr_clk_en_rx_adapt set to "en_rx_adapt_clk" regardless of the setting of the other channels.
    localparam        lcl_hssi_xcvr_clk_en_rx_adapt = lcl_hssi_xcvr_bti_protected ? "en_rx_adapt_clk" : hssi_xcvr_clk_en_rx_adapt;


// JRJ 8/3/2020 - experiment to fix Interlaken PAM4 with RSFEC - this will not compile, but it should simulate
// JRJ 10/20/2020 - update - The RBC changes required to support this are in ACDS 20.4, build 32.  This should compile with this build and later.

    // bti protected channels must have parameter hssi_xcvr_clk_en_fifo_rd_rx set to "dis_rx_fifo_rd_clk" regardless of the setting of the other channels.
//     localparam        lcl_hssi_xcvr_clk_en_fifo_rd_rx = lcl_hssi_xcvr_bti_protected ? "dis_rx_fifo_rd_clk" : hssi_xcvr_clk_en_fifo_rd_rx;

     localparam        lcl_hssi_xcvr_clk_en_fifo_rd_rx = hssi_xcvr_clk_en_fifo_rd_rx;

     // JRJ 8/3/2020 - end of modifications for experiment

    // bti protected channels must have the parameter hssi_xcvr_clk_en_direct_tx set to "en_tx_direct_clk" for PMA direct dual channel modes and "dis_tx_direct_clk" for FEC direct
    // dual channel modes
    localparam        lcl_hssi_xcvr_clk_en_direct_tx = lcl_hssi_xcvr_bti_protected ? (is_dual_channel_dir ? "en_tx_direct_clk" : "dis_tx_direct_clk") : hssi_xcvr_clk_en_direct_tx;
    // bti protected channels must have the parameter hssi_xcvr_clk_en_ehip_d2_tx set to "dis_tx_ehip_clk" regardless of the setting of the other channels.
	localparam        lcl_hssi_xcvr_clk_en_ehip_d2_tx = lcl_hssi_xcvr_bti_protected ? "dis_tx_ehip_clk" : hssi_xcvr_clk_en_ehip_d2_tx;
    // bti protected channels must have the parameter hssi_xcvr_clk_en_fec_d2_tx set to "en_tx_fec_clk" for RSFEC direct dual channel modes and "dis_tx_fec_clk" for PMA direct
    // dual channel modes
    localparam        lcl_hssi_xcvr_clk_en_fec_d2_tx = lcl_hssi_xcvr_bti_protected ? (is_dual_channel_fec ? "en_tx_fec_clk" : "dis_tx_fec_clk") : hssi_xcvr_clk_en_fec_d2_tx;
    // bti protected channels must have the parameter hssi_xcvr_clk_en_pcs_d2_tx set to "dis_tx_pcs_clk" regardless of the setting of the other channels.
    localparam		  lcl_hssi_xcvr_clk_en_pcs_d2_tx = lcl_hssi_xcvr_bti_protected ? "dis_tx_pcs_clk" : hssi_xcvr_clk_en_pcs_d2_tx;
    // bti protected channels must have the parameter hssi_xcvr_clk_en_tx_datapath set to "en_tx_datapath_clk" regardless of the setting of the other channels.
    localparam		  lcl_hssi_xcvr_clk_en_tx_datapath = lcl_hssi_xcvr_bti_protected ? "en_tx_datapath_clk" : hssi_xcvr_clk_en_tx_datapath;
    // bti protected channels must have the parameter hssi_xcvr_clk_en_tx_gbx set to "en_tx_gb_clk" for RSFEC direct dual channel modes and "dis_tx_gb_clk" for PMA direct
    // dual channel modes
    localparam		  lcl_hssi_xcvr_clk_en_tx_gbx = lcl_hssi_xcvr_bti_protected ? (is_dual_channel_fec ? "en_tx_gb_clk" : "dis_tx_gb_clk") : hssi_xcvr_clk_en_tx_gbx;
	localparam        lcl_hssi_xcvr_int_seq6_rx_sr_enc = lcl_hssi_xcvr_bti_protected ? "rx_enc_is_nrz" : hssi_xcvr_int_seq6_rx_sr_enc;
	localparam        lcl_hssi_xcvr_int_seq6_rx_width = lcl_hssi_xcvr_bti_protected ? "rx_width_32b" : hssi_xcvr_int_seq6_rx_width;
	localparam        lcl_hssi_xcvr_int_seq6_tx_sr_enc = lcl_hssi_xcvr_bti_protected ? "tx_enc_is_nrz" : hssi_xcvr_int_seq6_tx_sr_enc;
	localparam        lcl_hssi_xcvr_int_seq6_tx_width = lcl_hssi_xcvr_bti_protected ? "tx_width_32b" : hssi_xcvr_int_seq6_tx_width;
    localparam        lcl_bti_protect_hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz = lcl_hssi_xcvr_bti_protected ? bin_bti_protect_hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz : lcl_hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz;
    localparam        lcl_bti_protect_hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz = lcl_hssi_xcvr_bti_protected ? bin_bti_protect_hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz : lcl_hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz;
    localparam        lcl_bti_protect_hssi_xcvr_tx_if_slv_bonding_config = lcl_hssi_xcvr_bti_protected ? "dis_tx_if_slv_bonding_config" : l_hssi_xcvr_tx_if_slv_bonding_config;

/* JRJ - 3/17/2020 - This is required for the BTI protection changes for ACDS 20.1
   For BTI protected transceiver channels, only the BTI reference clock is connected.  All the other clock inputs are tied to 1'b0.
   For channels that are not BTI protected, all the usual reference clock connections are made to support dynamic reconfiguation.
   The assignment of pll_refclkn_div is near the top of this generate block around line 2853.  */
   wire  channel_specific_clock_conn_0;
   wire  channel_specific_clock_conn_1;
   wire  channel_specific_clock_conn_2;
   wire  channel_specific_clock_conn_3;
   wire  channel_specific_clock_conn_4;
   if (lcl_hssi_xcvr_bti_protected) begin : bti_channel
      assign channel_specific_clock_conn_0 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk0") ? pll_refclk0_div :
					     (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk1") ? pll_refclk1_div :
					     (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk2") ? pll_refclk2_div :
					     (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk3") ? pll_refclk3_div :
					     (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk4") ? pll_refclk4_div : 1'b0;
      assign channel_specific_clock_conn_1 = 1'b0;
      assign channel_specific_clock_conn_2 = 1'b0;
      assign channel_specific_clock_conn_3 = 1'b0;
      assign channel_specific_clock_conn_4 = 1'b0;
//      assign channel_specific_clock_conn_0 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk0") ? pll_refclk0_div : 1'b0;
//      assign channel_specific_clock_conn_1 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk1") ? pll_refclk1_div : 1'b0;
//      assign channel_specific_clock_conn_2 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk2") ? pll_refclk2_div : 1'b0;
//      assign channel_specific_clock_conn_3 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk3") ? pll_refclk3_div : 1'b0;
//      assign channel_specific_clock_conn_4 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk4") ? pll_refclk4_div : 1'b0;
  end : bti_channel
//  else begin : non_bti_channel
//      if (bti_channels_hssi_xcvr_bti_protected) begin : disconnect_bti_clock
//      	 assign channel_specific_clock_conn_0 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk0") ? 1'b0 : pll_refclk0_div;
//      	 assign channel_specific_clock_conn_1 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk1") ? 1'b0 : int_dedicated_rx_pll_refclk;
//      	 assign channel_specific_clock_conn_2 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk2") ? 1'b0 : pll_refclk2_div;
//      	 assign channel_specific_clock_conn_3 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk3") ? 1'b0 : pll_refclk3_div;
//      	 assign channel_specific_clock_conn_4 = (bti_channels_hssi_xcvr_bti_ref_clock_sel == "i_refclk4") ? 1'b0 : pll_refclk4_div;
//      end : disconnect_bti_clock
      else begin : connect_all_clocks
      assign channel_specific_clock_conn_0 = pll_refclk0_div;
      assign channel_specific_clock_conn_1 = int_dedicated_rx_pll_refclk;
      assign channel_specific_clock_conn_2 = pll_refclk2_div;
      assign channel_specific_clock_conn_3 = pll_refclk3_div;
      assign channel_specific_clock_conn_4 = pll_refclk4_div;
      end : connect_all_clocks
//  end : non_bti_channel
// This needs to be set for simplex mode.
	localparam        lcl_hssi_xcvr_en_tx_deskew                = (lcl_hssi_xcvr_channel_mode=="xcvr_rxonly") ? "dis_tx_deskew" :
								      (lcl_hssi_xcvr_tx_deskew=="tx_dsk_top")   ? "en_tx_deskew_east_ln" :
	                                                              (lcl_hssi_xcvr_tx_deskew=="tx_dsk_bot")   ? "en_tx_deskew_west_ln" :
	                                                              (lcl_hssi_xcvr_tx_deskew=="tx_dsk_mid")   ? "en_tx_deskew_both_ln" : l_hssi_xcvr_en_tx_deskew;
	//************
	// Placement dependent parameter temporarily set for simulations
	//************
	localparam        mod4_ch_idx = ig%4;
	localparam        lcl_hssi_xcvr_serdes_grp_id          = (mod4_ch_idx==0) ? "grp0"           : (mod4_ch_idx==1) ? "grp1"           : (mod4_ch_idx==2) ? "grp2"           : (mod4_ch_idx==3) ? "grp3"           : "grp0";
	localparam        lcl_hssi_xcvr_interrupt_window_grpid = (mod4_ch_idx==0) ? "int_if_en_grp0" : (mod4_ch_idx==1) ? "int_if_en_grp1" : (mod4_ch_idx==2) ? "int_if_en_grp2" : (mod4_ch_idx==3) ? "int_if_en_grp3" : "int_if_en_grp0";

	//************
	// Bonding connections
	//************
        if (is_bonded && ig>0) begin
          assign l_in_tx_refclk_sync_nrz[ig]  =  l_out_tx_refclk_sync_out[ig - 1];
        end else begin
          assign l_in_tx_refclk_sync_nrz[ig]  = 1'b0;
        end

        if (is_bonded && ig>1) begin
          assign l_in_tx_refclk_sync_pam4[ig] =  l_out_tx_refclk_sync_out[ig - 2];
        end else begin
          assign l_in_tx_refclk_sync_pam4[ig] = 1'b0;
        end

        if (is_bonded && ig>0) begin
          if (is_idx_odd) begin
            assign l_in_tx_bonding_pulse_below[ig] =  l_out_tx_bonding_pulse_cpy[ig - 1];
          end else begin
            assign l_in_tx_bonding_pulse_below[ig] =  l_out_tx_bonding_pulse_out[ig - 1];
          end
        end else if (is_dual_channel && ig>0) begin
          if (is_dual_channel_slave) begin
            assign l_in_tx_bonding_pulse_below[ig] =  l_out_tx_bonding_pulse_cpy[ig - 1];
          end else begin
            assign l_in_tx_bonding_pulse_below[ig] = 1'b0;
          end
        end else begin
          assign l_in_tx_bonding_pulse_below[ig] = 1'b0;
        end

        if (is_bonded && ig<(l_channels-1)) begin
          if (is_idx_odd) begin
            assign l_in_tx_bonding_pulse_above[ig] =  l_out_tx_bonding_pulse_out[ig + 1];
          end else begin
            assign l_in_tx_bonding_pulse_above[ig] =  l_out_tx_bonding_pulse_cpy[ig + 1];
          end
        end else if (is_dual_channel && ig<(l_channels-1)) begin
           if (is_dual_channel_slave) begin
            assign l_in_tx_bonding_pulse_above[ig] = 1'b0;
          end else begin
            assign l_in_tx_bonding_pulse_above[ig] =  l_out_tx_bonding_pulse_cpy[ig + 1];
          end
        end else begin
          assign l_in_tx_bonding_pulse_above[ig] = 1'b0;
        end

	//************
	// Dual channel connections
	//************
	if (l_channels ==4 && DR_NRZ_PAM4 == 1) begin
	  if (is_dual_channel_slave  && ig>0) begin
             assign l_in_rx_ch0_dskw_pulse[ig]   = l_out_rx_deskew_pulse[ig-1]   ;
             assign l_in_rx_ch0_clk[ig]          = l_out_rx_fifo_clk[ig-1]       ;
             assign l_in_tx_ch0_clk[ig]          = l_out_tx_ch0_clk[ig-1]        ;
             assign l_in_rx_ch0_in[ig]           = l_out_rx_out[ig-1][63:32]     ;
             assign l_in_rx_multi_ln_inter[ig]   = l_out_rx_multi_ln_inter[ig-1] ;
          end else begin
             assign l_in_rx_ch0_dskw_pulse[ig]   = 1'b0;
             assign l_in_rx_ch0_clk[ig]          = 1'b0;
             assign l_in_tx_ch0_clk[ig]          = 1'b0;
             assign l_in_rx_ch0_in[ig]           = 32'b0;
             assign l_in_rx_multi_ln_inter[ig]   = 32'b0;
          end
          if (!is_dual_channel_slave && ig<(l_channels-1) ) begin
             assign l_in_tx_ml_inter[ig]         = l_out_tx_ml_inter[ig+1]       ;
             assign l_in_tx_multi_ln_data[ig]    = l_out_tx_multi_ln_data[ig+1]  ;
          end else begin
             assign l_in_tx_ml_inter[ig]         = 32'b0;
             assign l_in_tx_multi_ln_data[ig]    = 32'b0;
          end
	end else begin
	  if (is_dual_channel && is_dual_channel_slave  && ig>0) begin
             assign l_in_rx_ch0_dskw_pulse[ig]   = l_out_rx_deskew_pulse[ig-1]   ;
             assign l_in_rx_ch0_clk[ig]          = l_out_rx_fifo_clk[ig-1]       ;
             assign l_in_tx_ch0_clk[ig]          = l_out_tx_ch0_clk[ig-1]        ;
             assign l_in_rx_ch0_in[ig]           = l_out_rx_out[ig-1][63:32]     ;
             assign l_in_rx_multi_ln_inter[ig]   = l_out_rx_multi_ln_inter[ig-1] ;
          end else begin
             assign l_in_rx_ch0_dskw_pulse[ig]   = 1'b0;
             assign l_in_rx_ch0_clk[ig]          = 1'b0;
             assign l_in_tx_ch0_clk[ig]          = 1'b0;
             assign l_in_rx_ch0_in[ig]           = 32'b0;
             assign l_in_rx_multi_ln_inter[ig]   = 32'b0;
          end
          if (is_dual_channel && !is_dual_channel_slave && ig<(l_channels-1) ) begin
             assign l_in_tx_ml_inter[ig]         = l_out_tx_ml_inter[ig+1]       ;
             assign l_in_tx_multi_ln_data[ig]    = l_out_tx_multi_ln_data[ig+1]  ;
          end else begin
             assign l_in_tx_ml_inter[ig]         = 32'b0;
             assign l_in_tx_multi_ln_data[ig]    = 32'b0;
          end
	end

    ct3_xcvr_native #(
        .bonded_lanes (1),
        .bonding_master_ch (0),
        .xcvr_native_mode (l_xcvr_native_mode),
	.avmm_interfaces (1),
        .rcfg_enable (rcfg_enable),
        .hssi_xcvr_powermode_ac_avmm_freq_hz(temp_lcl_hssi_xcvr_powermode_ac_avmm_freq_hz),
        .hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz(lcl_hssi_xcvr_powermode_ac_serdes_rx_enc_par_freq_hz),
        .hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz(lcl_hssi_xcvr_powermode_ac_serdes_rx_ui_freq_hz),
        .hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz(lcl_hssi_xcvr_powermode_ac_serdes_tx_enc_par_freq_hz),
        .hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz(lcl_hssi_xcvr_powermode_ac_serdes_tx_ui_freq_hz),
        .hssi_xcvr_tx_deskew(lcl_hssi_xcvr_tx_deskew),
        .hssi_xcvr_en_tx_deskew(lcl_hssi_xcvr_en_tx_deskew),
        .hssi_xcvr_powermode_ac_serdes_rx(lcl_hssi_xcvr_powermode_ac_serdes_rx),
        .hssi_xcvr_powermode_ac_serdes_tx(lcl_hssi_xcvr_powermode_ac_serdes_tx),
        .hssi_xcvr_cfg_hw_mode_sel(lcl_hssi_xcvr_cfg_hw_mode_sel),
        .hssi_xcvr_seq_en_tx_post1(lcl_hssi_xcvr_seq_en_tx_post1),
        .hssi_xcvr_seq_en_tx_pre1(lcl_hssi_xcvr_seq_en_tx_pre1),
        .hssi_xcvr_seq_en_tx_slew(lcl_hssi_xcvr_seq_en_tx_slew),
        .hssi_xcvr_tx_clk_out_sel(lcl_hssi_xcvr_tx_clk_out_sel),
        .hssi_xcvr_rx_ml_sel(lcl_hssi_xcvr_rx_ml_sel),
        .hssi_xcvr_tx_dskew_ml_sel(lcl_hssi_xcvr_tx_dskew_ml_sel),
        .hssi_xcvr_func_mode(lcl_hssi_xcvr_func_mode),
        .hssi_xcvr_rx_datarate_bps(bin_hssi_xcvr_rx_datarate_bps),
        .hssi_xcvr_tx_datarate_bps(bin_hssi_xcvr_tx_datarate_bps),
        .hssi_xcvr_tx_refclk_freq(bin_hssi_xcvr_tx_refclk_freq),
        .hssi_xcvr_rx_refclk_freq(bin_hssi_xcvr_rx_refclk_freq),
        .hssi_xcvr_int_seq12_txeq_broadcast(hssi_xcvr_int_seq12_txeq_broadcast),
        .hssi_xcvr_int_seq10_txeq_amp(hssi_xcvr_int_seq10_txeq_amp),
        .hssi_xcvr_int_seq11_txeq_post(hssi_xcvr_int_seq11_txeq_post),
        .hssi_xcvr_int_seq7_txeq_pre1(hssi_xcvr_int_seq7_txeq_pre1),
        .hssi_xcvr_int_seq8_txeq_slew(hssi_xcvr_int_seq8_txeq_slew),
        .hssi_xcvr_int_seq9_txeq_atten(hssi_xcvr_int_seq9_txeq_atten),
        .hssi_xcvr_seq_en_crc(lcl_hssi_xcvr_seq_en_crc),
        .hssi_xcvr_seq_en_tx_amp(lcl_hssi_xcvr_seq_en_tx_amp),
        .hssi_xcvr_seq_en_tx_atten(lcl_hssi_xcvr_seq_en_tx_atten),
        .hssi_xcvr_seq_en_tx_broadcast(lcl_hssi_xcvr_seq_en_tx_broadcast),
        .hssi_xcvr_rx_adapter_sel(lcl_hssi_xcvr_rx_adapter_sel),
        .hssi_xcvr_tx_ml_sel(lcl_hssi_xcvr_tx_ml_sel),
        .hssi_xcvr_tx_reset_val_31_0(temp_lcl_hssi_xcvr_tx_reset_val_31_0),
        .hssi_xcvr_tx_reset_val_63_32(temp_lcl_hssi_xcvr_tx_reset_val_63_32),
        .hssi_xcvr_xcvr_spare_ctrl0(temp_lcl_hssi_xcvr_xcvr_spare_ctrl0),
        .hssi_xcvr_xcvr_spare_ctrl1(temp_lcl_hssi_xcvr_xcvr_spare_ctrl1),
        .hssi_xcvr_int_seq13_tx_pll_recal(hssi_xcvr_int_seq13_tx_pll_recal),
        .hssi_xcvr_int_seq13_rx_pll_recal(hssi_xcvr_int_seq13_rx_pll_recal),
        .hssi_xcvr_powermode_dc_serdes_tx(lcl_hssi_xcvr_powermode_dc_serdes_tx),
        .hssi_xcvr_powermode_dc_serdes_rx(lcl_hssi_xcvr_powermode_dc_serdes_rx),
        .hssi_xcvr_serdes_grp_id(lcl_hssi_xcvr_serdes_grp_id),
        .hssi_xcvr_interrupt_window_grpid(lcl_hssi_xcvr_interrupt_window_grpid),
        .hssi_aibcr_rx_rx_transfer_clk_freq(temp_lcl_hssi_aibcr_rx_rx_transfer_clk_freq),
        .hssi_aibcr_rx_rx_transfer_clk_freq_hz(temp_lcl_hssi_aibcr_rx_rx_transfer_clk_freq_hz),
        .hssi_aibcr_tx_tx_transfer_clk_freq(temp_lcl_hssi_aibcr_tx_tx_transfer_clk_freq),
        .hssi_aibcr_tx_tx_transfer_clk_freq_hz(temp_lcl_hssi_aibcr_tx_tx_transfer_clk_freq_hz),
        .hssi_ehip_lane_enable_serialliteiv (hssi_ehip_lane_enable_serialliteiv),
        .hssi_ehip_lane_ptp_debug (temp_lcl_hssi_ehip_lane_ptp_debug),
        .hssi_ehip_lane_rx_aib_dp_latency (temp_lcl_hssi_ehip_lane_rx_aib_dp_latency),
        .hssi_ehip_lane_rx_pause_daddr (temp_lcl_hssi_ehip_lane_rx_pause_daddr),
        .hssi_ehip_lane_rx_ptp_dp_latency (temp_lcl_hssi_ehip_lane_rx_ptp_dp_latency),
        .hssi_ehip_lane_rx_ptp_extra_latency (temp_lcl_hssi_ehip_lane_rx_ptp_extra_latency),
        .hssi_ehip_lane_tx_aib_dp_latency (temp_lcl_hssi_ehip_lane_tx_aib_dp_latency),
        .hssi_ehip_lane_tx_pause_daddr (temp_lcl_hssi_ehip_lane_tx_pause_daddr),
        .hssi_ehip_lane_tx_pause_saddr (temp_lcl_hssi_ehip_lane_tx_pause_saddr),
        .hssi_ehip_lane_tx_ptp_asym_latency (temp_lcl_hssi_ehip_lane_tx_ptp_asym_latency),
        .hssi_ehip_lane_tx_ptp_dp_latency (temp_lcl_hssi_ehip_lane_tx_ptp_dp_latency),
        .hssi_ehip_lane_tx_ptp_extra_latency (temp_lcl_hssi_ehip_lane_tx_ptp_extra_latency),
        .hssi_ehip_lane_txmac_saddr (temp_lcl_hssi_ehip_lane_txmac_saddr),
        .hssi_avmm1_if_hssiadapt_avmm_clk_dcg_en (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_avmm_clk_scg_en (/*TODO - Added*/),
        .hssi_avmm1_if_pldadapt_avmm_clk_scg_en (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_osc_clk_scg_en (/*TODO - Added*/),
        .hssi_avmm1_if_pldadapt_osc_clk_scg_en (/*TODO - Added*/),
        .hssi_avmm1_if_func_mode (/*TODO - Added*/),
        .hssi_avmm1_if_topology (/*TODO - Added*/),
        .hssi_pldadapt_rx_hdpldadapt_sr_sr_testbus_sel (/*TODO - Added*/),
        .hssi_pldadapt_tx_hdpldadapt_sr_sr_testbus_sel (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_hip_mode (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_powerdown_mode (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_sr_free_run_div_clk (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_sr_hip_en (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_sr_osc_clk_div_sel (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_sr_osc_clk_scg_en (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_sr_parity_en (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_sr_reserved_in_en (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_sr_reserved_out_en (/*TODO - Added*/),
        .hssi_avmm1_if_hssiadapt_sr_sup_mode (/*TODO - Added*/),

        // added by Anthony
	      .hssi_avmm1_if_calibration_type                           (hssi_avmm1_if_calibration_type                        ),
	      .hssi_avmm1_if_hssiadapt_avmm_osc_clock_setting           (hssi_avmm1_if_hssiadapt_avmm_osc_clock_setting        ),
	      .hssi_avmm1_if_hssiadapt_avmm_testbus_sel                 (hssi_avmm1_if_hssiadapt_avmm_testbus_sel              ),
	      .hssi_avmm1_if_hssiadapt_hip_mode                         (hssi_avmm1_if_hssiadapt_hip_mode                      ),
	      .hssi_avmm1_if_hssiadapt_nfhssi_calibratio_feature_en     (hssi_avmm1_if_hssiadapt_nfhssi_calibratio_feature_en   ),
	      .hssi_avmm1_if_hssiadapt_read_blocking_enable             (hssi_avmm1_if_hssiadapt_read_blocking_enable          ),
	      .hssi_avmm1_if_hssiadapt_uc_blocking_enable               (hssi_avmm1_if_hssiadapt_uc_blocking_enable            ),
	      .hssi_avmm1_if_pcs_arbiter_ctrl                           (hssi_avmm1_if_pcs_arbiter_ctrl                        ),
	      .hssi_avmm1_if_pcs_cal_done                               (hssi_avmm1_if_pcs_cal_done                            ),
	      .hssi_avmm1_if_pcs_cal_reserved                           (hssi_avmm1_if_pcs_cal_reserved                        ),
	      .hssi_avmm1_if_pcs_calibration_feature_en                 (hssi_avmm1_if_pcs_calibration_feature_en              ),
	      .hssi_avmm1_if_pcs_hip_cal_en                             (hssi_avmm1_if_pcs_hip_cal_en                          ),
	      .hssi_avmm1_if_pldadapt_avmm_osc_clock_setting            (hssi_avmm1_if_pldadapt_avmm_osc_clock_setting         ),
	      .hssi_avmm1_if_pldadapt_avmm_testbus_sel                  (hssi_avmm1_if_pldadapt_avmm_testbus_sel               ),
	      .hssi_avmm1_if_pldadapt_gate_dis                          (hssi_avmm1_if_pldadapt_gate_dis                       ),
	      .hssi_avmm1_if_pldadapt_hip_mode                          (hssi_avmm1_if_pldadapt_hip_mode                       ),
	      .hssi_avmm1_if_pldadapt_read_blocking_enable              (hssi_avmm1_if_pldadapt_read_blocking_enable           ),
	      .hssi_avmm1_if_pldadapt_uc_blocking_enable                (hssi_avmm1_if_pldadapt_uc_blocking_enable             ),
	      .hssi_avmm1_if_silicon_rev                                (hssi_avmm1_if_silicon_rev                             ),
        .hssi_avmm1_if_hssiadapt_write_resp_en                    ("enable"                                              ), // added by anthony

	      .hssi_pldadapt_tx_powermode_dc				(hssi_pldadapt_tx_powermode_dc				),
	      .hssi_pldadapt_rx_powermode_dc				(hssi_pldadapt_rx_powermode_dc				),
	      .hssi_aibnd_rx_aib_ber_margining_ctrl			(hssi_aibnd_rx_aib_ber_margining_ctrl			),
          .hssi_xcvr_bti_protected (lcl_hssi_xcvr_bti_protected_string),
          .hssi_xcvr_channel_mode (lcl_hssi_xcvr_channel_mode),
          .hssi_xcvr_serdes_tx_enc (lcl_hssi_xcvr_serdes_tx_enc),
          .hssi_xcvr_serdes_rx_enc (lcl_hssi_xcvr_serdes_rx_enc),
          .hssi_xcvr_tx_pma_width (lcl_hssi_xcvr_tx_pma_width),
          .hssi_xcvr_rx_pma_width (lcl_hssi_xcvr_rx_pma_width),
          .hssi_xcvr_int_seq3_refclk_cfg_both (lcl_hssi_xcvr_int_seq3_refclk_cfg_both),
          .hssi_xcvr_int_seq3_refclk_sync_master(lcl_bti_protect_hssi_xcvr_int_seq3_refclk_sync_master),
          .hssi_xcvr_int_seq3_tx_bit_rate (lcl_hssi_xcvr_int_seq3_tx_bit_rate),
          .hssi_xcvr_int_seq4_refclk_cfg_both (lcl_hssi_xcvr_int_seq4_refclk_cfg_both),
          .hssi_xcvr_int_seq4_rx_bit_rate (lcl_hssi_xcvr_int_seq4_rx_bit_rate),
          .hssi_xcvr_interrupt_window_enable(lcl_bti_protect_hssi_xcvr_interrupt_window_enable),
          .hssi_xcvr_seq_en_bitwidth(lcl_bti_protect_hssi_xcvr_seq_en_bitwidth),
          .hssi_xcvr_seq_en_reserved2 (lcl_hssi_xcvr_seq_en_reserved2),
          .hssi_xcvr_seq_en_reserved3 (lcl_hssi_xcvr_seq_en_reserved3),
          .hssi_xcvr_seq_en_rx_bitrate(lcl_bti_protect_hssi_xcvr_seq_en_rx_bitrate),
          .hssi_xcvr_seq_en_tx_bitrate(lcl_bti_protect_hssi_xcvr_seq_en_tx_bitrate),
          .hssi_xcvr_serdes_en_seq(lcl_bti_protect_hssi_xcvr_serdes_en_seq),
          .hssi_xcvr_set_int_seq14_code (lcl_hssi_xcvr_set_int_seq14_code),
          .hssi_xcvr_set_int_seq14_data (lcl_hssi_xcvr_set_int_seq14_data),
          .hssi_xcvr_set_int_seq15_code (lcl_hssi_xcvr_set_int_seq15_code),
          .hssi_xcvr_set_int_seq15_data (lcl_hssi_xcvr_set_int_seq15_data),
          .hssi_xcvr_set_int_seq_serd_en (lcl_bti_protect_hssi_xcvr_set_int_seq_serd_en),
          .hssi_xcvr_set_refclk_sel(lcl_bti_protect_hssi_xcvr_set_refclk_sel),
          .hssi_xcvr_refclk_mux_refclk0_sel(lcl_bti_protect_hssi_xcvr_set_refclk_sel),
          .hssi_xcvr_cfg_rb_dcc_en (lcl_hssi_xcvr_cfg_rb_dcc_en),
          .hssi_xcvr_cfg_rb_dcc_byp (lcl_hssi_xcvr_cfg_rb_dcc_byp),
          .hssi_xcvr_clk_en_rx_adapt (lcl_hssi_xcvr_clk_en_rx_adapt),
          .hssi_xcvr_clk_en_fifo_rd_rx (lcl_hssi_xcvr_clk_en_fifo_rd_rx),
          .hssi_xcvr_clk_en_direct_tx (lcl_hssi_xcvr_clk_en_direct_tx),
          .hssi_xcvr_clk_en_ehip_d2_tx (lcl_hssi_xcvr_clk_en_ehip_d2_tx),
          .hssi_xcvr_clk_en_fec_d2_tx (lcl_hssi_xcvr_clk_en_fec_d2_tx),
          .hssi_xcvr_clk_en_pcs_d2_tx (lcl_hssi_xcvr_clk_en_pcs_d2_tx),
          .hssi_xcvr_clk_en_tx_datapath (lcl_hssi_xcvr_clk_en_tx_datapath),
          .hssi_xcvr_clk_en_tx_gbx (lcl_hssi_xcvr_clk_en_tx_gbx),
          .hssi_xcvr_int_seq3_tx_refclk_ratio(lcl_hssi_xcvr_int_seq3_tx_refclk_ratio),
          .hssi_xcvr_int_seq4_rx_refclk_ratio(lcl_hssi_xcvr_int_seq4_rx_refclk_ratio),
          .hssi_xcvr_rx_pma_width_sd(bti_lcl_hssi_xcvr_rx_pma_width_sd),
          .hssi_xcvr_tx_pma_width_sd(bti_lcl_hssi_xcvr_tx_pma_width_sd),
          .hssi_xcvr_int_seq6_rx_sr_enc (lcl_hssi_xcvr_int_seq6_rx_sr_enc),
          .hssi_xcvr_int_seq6_rx_width (lcl_hssi_xcvr_int_seq6_rx_width),
          .hssi_xcvr_int_seq6_tx_sr_enc (lcl_hssi_xcvr_int_seq6_tx_sr_enc),
          .hssi_xcvr_int_seq6_tx_width (lcl_hssi_xcvr_int_seq6_tx_width),
          .hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz(lcl_bti_protect_hssi_xcvr_powermode_ac_serdes_rx_par_freq_hz),
          .hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz(lcl_bti_protect_hssi_xcvr_powermode_ac_serdes_tx_par_freq_hz),
          .hssi_xcvr_tx_if_slv_bonding_config (lcl_bti_protect_hssi_xcvr_tx_if_slv_bonding_config),

// temporary disable revisit after static hdl fix	      .hssi_adapt_rx_c3aibadapt_aib_hssi_rx_sr_clk_in_hz	(hssi_adapt_rx_c3aibadapt_aib_hssi_rx_sr_clk_in_hz	),
// temporary disable revisit after static hdl fix	      .hssi_adapt_tx_c3aibadapt_aib_hssi_tx_sr_clk_in_hz	(hssi_adapt_tx_c3aibadapt_aib_hssi_tx_sr_clk_in_hz	),
// temporary disable revisit after static hdl fix	      .hssi_pldadapt_rx_hdpldadapt_aib_fabric_rx_sr_clk_in_hz	(hssi_pldadapt_rx_hdpldadapt_aib_fabric_rx_sr_clk_in_hz	),
// temporary disable revisit after static hdl fix	      .hssi_pldadapt_tx_hdpldadapt_aib_fabric_tx_sr_clk_in_hz	(hssi_pldadapt_tx_hdpldadapt_aib_fabric_tx_sr_clk_in_hz	),

        .hssi_adapt_rx_adapter_lpbk_mode (hssi_adapt_rx_adapter_lpbk_mode),
        .hssi_adapt_rx_aib_lpbk_mode (hssi_adapt_rx_aib_lpbk_mode),
        .hssi_adapt_rx_async_direct_hip_en (hssi_adapt_rx_async_direct_hip_en),
        .hssi_adapt_rx_c3aibadapt_aib_hssi_pld_sclk_hz (hssi_adapt_rx_c3aibadapt_aib_hssi_pld_sclk_hz),
        .hssi_adapt_rx_c3aibadapt_aib_hssi_rx_transfer_clk_hz (hssi_adapt_rx_c3aibadapt_aib_hssi_rx_transfer_clk_hz),
        .hssi_adapt_rx_c3aibadapt_csr_clk_hz (hssi_adapt_rx_c3aibadapt_csr_clk_hz),
        .hssi_adapt_rx_c3aibadapt_hip_aib_clk_2x_hz (hssi_adapt_rx_c3aibadapt_hip_aib_clk_2x_hz),
        .hssi_adapt_rx_c3aibadapt_icm (hssi_adapt_rx_c3aibadapt_icm),
        .hssi_adapt_rx_c3aibadapt_pld_pcs_rx_clk_out_hz (hssi_adapt_rx_c3aibadapt_pld_pcs_rx_clk_out_hz),
        .hssi_adapt_rx_c3aibadapt_pld_pma_hclk_hz (hssi_adapt_rx_c3aibadapt_pld_pma_hclk_hz),
        .hssi_adapt_rx_c3aibadapt_pma_aib_rx_clk_hz (hssi_adapt_rx_c3aibadapt_pma_aib_rx_clk_hz),
        .hssi_adapt_rx_c3aibadapt_powermode_ac_avmm1 (hssi_adapt_rx_c3aibadapt_powermode_ac_avmm1),
        .hssi_adapt_rx_c3aibadapt_powermode_ac_avmm2 (hssi_adapt_rx_c3aibadapt_powermode_ac_avmm2),
        .hssi_adapt_rx_c3aibadapt_powermode_ac_rx_datapath (hssi_adapt_rx_c3aibadapt_powermode_ac_rx_datapath),
        .hssi_adapt_rx_c3aibadapt_powermode_ac_sr (hssi_adapt_rx_c3aibadapt_powermode_ac_sr),
        .hssi_adapt_rx_c3aibadapt_powermode_dc (hssi_adapt_rx_c3aibadapt_powermode_dc),
        .hssi_adapt_rx_c3aibadapt_speed_grade (hssi_adapt_rx_c3aibadapt_speed_grade),
        .hssi_adapt_rx_clock_del_measure_enable (hssi_adapt_rx_clock_del_measure_enable),
        .hssi_adapt_rx_datapath_mapping_mode (hssi_adapt_rx_datapath_mapping_mode),
        .hssi_adapt_rx_fifo_double_write (hssi_adapt_rx_fifo_double_write),
        .hssi_adapt_rx_fifo_mode (hssi_adapt_rx_fifo_mode),
        .hssi_adapt_rx_fifo_rd_clk_scg_en (hssi_adapt_rx_fifo_rd_clk_scg_en),
        .hssi_adapt_rx_fifo_rd_clk_sel (hssi_adapt_rx_fifo_rd_clk_sel),
        .hssi_adapt_rx_fifo_stop_rd (hssi_adapt_rx_fifo_stop_rd),
        .hssi_adapt_rx_fifo_stop_wr (hssi_adapt_rx_fifo_stop_wr),
        .hssi_adapt_rx_fifo_width (hssi_adapt_rx_fifo_width),
        .hssi_adapt_rx_fifo_wr_clk_scg_en (hssi_adapt_rx_fifo_wr_clk_scg_en),
        .hssi_adapt_rx_fifo_wr_clk_sel (hssi_adapt_rx_fifo_wr_clk_sel),
        .hssi_adapt_rx_free_run_div_clk (hssi_adapt_rx_free_run_div_clk),
        .hssi_adapt_rx_fsr_pld_8g_sigdet_out_rst_val (hssi_adapt_rx_fsr_pld_8g_sigdet_out_rst_val),
        .hssi_adapt_rx_fsr_pld_10g_rx_crc32_err_rst_val (hssi_adapt_rx_fsr_pld_10g_rx_crc32_err_rst_val),
        .hssi_adapt_rx_fsr_pld_ltd_b_rst_val (hssi_adapt_rx_fsr_pld_ltd_b_rst_val),
        .hssi_adapt_rx_fsr_pld_ltr_rst_val (hssi_adapt_rx_fsr_pld_ltr_rst_val),
        .hssi_adapt_rx_fsr_pld_rx_fifo_align_clr_rst_val (hssi_adapt_rx_fsr_pld_rx_fifo_align_clr_rst_val),
        .hssi_adapt_rx_func_mode (hssi_adapt_rx_func_mode),
        .hssi_adapt_rx_hrdrst_dcd_cal_done_bypass (hssi_adapt_rx_hrdrst_dcd_cal_done_bypass),
        .hssi_adapt_rx_hrdrst_rst_sm_dis (hssi_adapt_rx_hrdrst_rst_sm_dis),
        .hssi_adapt_rx_hrdrst_rx_osc_clk_scg_en (hssi_adapt_rx_hrdrst_rx_osc_clk_scg_en),
        .hssi_adapt_rx_hrdrst_user_ctl_en (hssi_adapt_rx_hrdrst_user_ctl_en),
        .hssi_adapt_rx_internal_clk1_sel (hssi_adapt_rx_internal_clk1_sel),
        .hssi_adapt_rx_internal_clk1_sel0 (hssi_adapt_rx_internal_clk1_sel0),
        .hssi_adapt_rx_internal_clk1_sel1 (hssi_adapt_rx_internal_clk1_sel1),
        .hssi_adapt_rx_internal_clk1_sel2 (hssi_adapt_rx_internal_clk1_sel2),
        .hssi_adapt_rx_internal_clk1_sel3 (hssi_adapt_rx_internal_clk1_sel3),
        .hssi_adapt_rx_internal_clk2_sel (hssi_adapt_rx_internal_clk2_sel),
        .hssi_adapt_rx_internal_clk2_sel0 (hssi_adapt_rx_internal_clk2_sel0),
        .hssi_adapt_rx_internal_clk2_sel1 (hssi_adapt_rx_internal_clk2_sel1),
        .hssi_adapt_rx_internal_clk2_sel2 (hssi_adapt_rx_internal_clk2_sel2),
        .hssi_adapt_rx_internal_clk2_sel3 (hssi_adapt_rx_internal_clk2_sel3),
        .hssi_adapt_rx_loopback_mode (hssi_adapt_rx_loopback_mode),
        .hssi_adapt_rx_msb_pipeline_byp (hssi_adapt_rx_msb_pipeline_byp),
        .hssi_adapt_rx_osc_clk_scg_en (hssi_adapt_rx_osc_clk_scg_en),
        .hssi_adapt_rx_phcomp_rd_del (hssi_adapt_rx_phcomp_rd_del),
        .hssi_adapt_rx_pma_aib_rx_clk_expected_setting (hssi_adapt_rx_pma_aib_rx_clk_expected_setting),
        .hssi_adapt_rx_pma_coreclkin_sel (hssi_adapt_rx_pma_coreclkin_sel),
        .hssi_adapt_rx_powerdown_mode (hssi_adapt_rx_powerdown_mode),
        .hssi_adapt_rx_rx_10g_krfec_rx_diag_data_status_polling_bypass (hssi_adapt_rx_rx_10g_krfec_rx_diag_data_status_polling_bypass),
        .hssi_adapt_rx_rx_datapath_tb_sel (hssi_adapt_rx_rx_datapath_tb_sel),
        .hssi_adapt_rx_rx_fifo_power_mode (hssi_adapt_rx_rx_fifo_power_mode),
        .hssi_adapt_rx_rx_fifo_read_latency_adjust (hssi_adapt_rx_rx_fifo_read_latency_adjust),
        .hssi_adapt_rx_rx_fifo_write_latency_adjust (hssi_adapt_rx_rx_fifo_write_latency_adjust),
        .hssi_adapt_rx_rx_osc_clock_setting (hssi_adapt_rx_rx_osc_clock_setting),
        .hssi_adapt_rx_rx_parity_sel (hssi_adapt_rx_rx_parity_sel),
        .hssi_adapt_rx_rx_pcs_testbus_sel (hssi_adapt_rx_rx_pcs_testbus_sel),
        .hssi_adapt_rx_rx_pcspma_testbus_sel (hssi_adapt_rx_rx_pcspma_testbus_sel),
        .hssi_adapt_rx_rx_pld_8g_a1a2_k1k2_flag_polling_bypass (hssi_adapt_rx_rx_pld_8g_a1a2_k1k2_flag_polling_bypass),
        .hssi_adapt_rx_rx_pld_8g_wa_boundary_polling_bypass (hssi_adapt_rx_rx_pld_8g_wa_boundary_polling_bypass),
        .hssi_adapt_rx_rx_pld_pma_pcie_sw_done_polling_bypass (hssi_adapt_rx_rx_pld_pma_pcie_sw_done_polling_bypass),
        .hssi_adapt_rx_rx_pld_pma_reser_in_polling_bypass (hssi_adapt_rx_rx_pld_pma_reser_in_polling_bypass),
        .hssi_adapt_rx_rx_pld_pma_testbus_polling_bypass (hssi_adapt_rx_rx_pld_pma_testbus_polling_bypass),
        .hssi_adapt_rx_rx_pld_test_data_polling_bypass (hssi_adapt_rx_rx_pld_test_data_polling_bypass),
        .hssi_adapt_rx_rx_rmfflag_stretch_enable (hssi_adapt_rx_rx_rmfflag_stretch_enable),
        .hssi_adapt_rx_rx_rmfflag_stretch_num_stages (hssi_adapt_rx_rx_rmfflag_stretch_num_stages),
        .hssi_adapt_rx_rx_usertest_sel (hssi_adapt_rx_rx_usertest_sel),
        .hssi_adapt_rx_rxfifo_empty (hssi_adapt_rx_rxfifo_empty),
        .hssi_adapt_rx_rxfifo_full (hssi_adapt_rx_rxfifo_full),
        .hssi_adapt_rx_rxfifo_mode (hssi_adapt_rx_rxfifo_mode),
        .hssi_adapt_rx_rxfifo_pempty (hssi_adapt_rx_rxfifo_pempty),
        .hssi_adapt_rx_rxfifo_pfull (hssi_adapt_rx_rxfifo_pfull),
        .hssi_adapt_rx_rxfiford_post_ct_sel (hssi_adapt_rx_rxfiford_post_ct_sel),
        .hssi_adapt_rx_rxfiford_to_aib_sel (hssi_adapt_rx_rxfiford_to_aib_sel),
        .hssi_adapt_rx_rxfifowr_post_ct_sel (hssi_adapt_rx_rxfifowr_post_ct_sel),
        .hssi_adapt_rx_rxfifowr_pre_ct_sel (hssi_adapt_rx_rxfifowr_pre_ct_sel),
        .hssi_adapt_rx_silicon_rev (hssi_adapt_rx_silicon_rev),
        .hssi_adapt_rx_stretch_num_stages (hssi_adapt_rx_stretch_num_stages),
        .hssi_adapt_rx_sup_mode (hssi_adapt_rx_sup_mode),
        .hssi_adapt_rx_topology (hssi_adapt_rx_topology),
        .hssi_adapt_rx_txfiford_post_ct_sel (hssi_adapt_rx_txfiford_post_ct_sel),
        .hssi_adapt_rx_txfiford_pre_ct_sel (hssi_adapt_rx_txfiford_pre_ct_sel),
        .hssi_adapt_rx_txfifowr_from_aib_sel (hssi_adapt_rx_txfifowr_from_aib_sel),
        .hssi_adapt_rx_txfifowr_post_ct_sel (hssi_adapt_rx_txfifowr_post_ct_sel),
        .hssi_adapt_rx_word_align_enable (hssi_adapt_rx_word_align_enable),
        .hssi_adapt_rx_word_mark (hssi_adapt_rx_word_mark),
        .hssi_adapt_tx_c3aibadapt_aib_hssi_pld_sclk_hz (hssi_adapt_tx_c3aibadapt_aib_hssi_pld_sclk_hz),
        .hssi_adapt_tx_c3aibadapt_aib_hssi_tx_transfer_clk_hz (hssi_adapt_tx_c3aibadapt_aib_hssi_tx_transfer_clk_hz),
        .hssi_adapt_tx_c3aibadapt_csr_clk_hz (hssi_adapt_tx_c3aibadapt_csr_clk_hz),
        .hssi_adapt_tx_c3aibadapt_hip_aib_clk_2x_hz (hssi_adapt_tx_c3aibadapt_hip_aib_clk_2x_hz),
        .hssi_adapt_tx_c3aibadapt_hip_aib_txeq_clk_out_hz (hssi_adapt_tx_c3aibadapt_hip_aib_txeq_clk_out_hz),
        .hssi_adapt_tx_c3aibadapt_icm (hssi_adapt_tx_c3aibadapt_icm),
        .hssi_adapt_tx_c3aibadapt_pld_pcs_tx_clk_out_hz (hssi_adapt_tx_c3aibadapt_pld_pcs_tx_clk_out_hz),
        .hssi_adapt_tx_c3aibadapt_pld_pma_hclk_hz (hssi_adapt_tx_c3aibadapt_pld_pma_hclk_hz),
        .hssi_adapt_tx_c3aibadapt_pma_aib_tx_clk_hz (hssi_adapt_tx_c3aibadapt_pma_aib_tx_clk_hz),
        .hssi_adapt_tx_c3aibadapt_powermode_ac_avmm1 (hssi_adapt_tx_c3aibadapt_powermode_ac_avmm1),
        .hssi_adapt_tx_c3aibadapt_powermode_ac_avmm2 (hssi_adapt_tx_c3aibadapt_powermode_ac_avmm2),
        .hssi_adapt_tx_c3aibadapt_powermode_ac_sr (hssi_adapt_tx_c3aibadapt_powermode_ac_sr),
        .hssi_adapt_tx_c3aibadapt_powermode_ac_tx_datapath (hssi_adapt_tx_c3aibadapt_powermode_ac_tx_datapath),
        .hssi_adapt_tx_c3aibadapt_powermode_dc (hssi_adapt_tx_c3aibadapt_powermode_dc),
        .hssi_adapt_tx_c3aibadapt_speed_grade (hssi_adapt_tx_c3aibadapt_speed_grade),
        .hssi_adapt_tx_datapath_mapping_mode (hssi_adapt_tx_datapath_mapping_mode),
        .hssi_adapt_tx_duplex_mode (hssi_adapt_tx_duplex_mode),
        .hssi_adapt_tx_dv_gating (hssi_adapt_tx_dv_gating),
        .hssi_adapt_tx_fifo_double_read (hssi_adapt_tx_fifo_double_read),
        .hssi_adapt_tx_fifo_mode (hssi_adapt_tx_fifo_mode),
        .hssi_adapt_tx_fifo_rd_clk_scg_en (hssi_adapt_tx_fifo_rd_clk_scg_en),
        .hssi_adapt_tx_fifo_rd_clk_sel (hssi_adapt_tx_fifo_rd_clk_sel),
        .hssi_adapt_tx_fifo_stop_rd (hssi_adapt_tx_fifo_stop_rd),
        .hssi_adapt_tx_fifo_stop_wr (hssi_adapt_tx_fifo_stop_wr),
        .hssi_adapt_tx_fifo_width (hssi_adapt_tx_fifo_width),
        .hssi_adapt_tx_fifo_wr_clk_scg_en (hssi_adapt_tx_fifo_wr_clk_scg_en),
        .hssi_adapt_tx_free_run_div_clk (hssi_adapt_tx_free_run_div_clk),
        .hssi_adapt_tx_fsr_hip_fsr_in_bit0_rst_val (hssi_adapt_tx_fsr_hip_fsr_in_bit0_rst_val),
        .hssi_adapt_tx_fsr_hip_fsr_in_bit1_rst_val (hssi_adapt_tx_fsr_hip_fsr_in_bit1_rst_val),
        .hssi_adapt_tx_fsr_hip_fsr_in_bit2_rst_val (hssi_adapt_tx_fsr_hip_fsr_in_bit2_rst_val),
        .hssi_adapt_tx_fsr_hip_fsr_in_bit3_rst_val (hssi_adapt_tx_fsr_hip_fsr_in_bit3_rst_val),
        .hssi_adapt_tx_fsr_hip_fsr_out_bit0_rst_val (hssi_adapt_tx_fsr_hip_fsr_out_bit0_rst_val),
        .hssi_adapt_tx_fsr_hip_fsr_out_bit1_rst_val (hssi_adapt_tx_fsr_hip_fsr_out_bit1_rst_val),
        .hssi_adapt_tx_fsr_hip_fsr_out_bit2_rst_val (hssi_adapt_tx_fsr_hip_fsr_out_bit2_rst_val),
        .hssi_adapt_tx_fsr_hip_fsr_out_bit3_rst_val (hssi_adapt_tx_fsr_hip_fsr_out_bit3_rst_val),
        .hssi_adapt_tx_fsr_mask_tx_pll_rst_val (hssi_adapt_tx_fsr_mask_tx_pll_rst_val),
        .hssi_adapt_tx_fsr_pld_txelecidle_rst_val (hssi_adapt_tx_fsr_pld_txelecidle_rst_val),
        .hssi_adapt_tx_func_mode (hssi_adapt_tx_func_mode),
        .hssi_adapt_tx_hip_osc_clk_scg_en (hssi_adapt_tx_hip_osc_clk_scg_en),
        .hssi_adapt_tx_hrdrst_align_bypass (hssi_adapt_tx_hrdrst_align_bypass),
        .hssi_adapt_tx_hrdrst_dcd_cal_done_bypass (hssi_adapt_tx_hrdrst_dcd_cal_done_bypass),
        .hssi_adapt_tx_hrdrst_dll_lock_bypass (hssi_adapt_tx_hrdrst_dll_lock_bypass),
        .hssi_adapt_tx_hrdrst_rst_sm_dis (hssi_adapt_tx_hrdrst_rst_sm_dis),
        .hssi_adapt_tx_hrdrst_rx_osc_clk_scg_en (hssi_adapt_tx_hrdrst_rx_osc_clk_scg_en),
        .hssi_adapt_tx_hrdrst_user_ctl_en (hssi_adapt_tx_hrdrst_user_ctl_en),
        .hssi_adapt_tx_loopback_mode (hssi_adapt_tx_loopback_mode),
        .hssi_adapt_tx_osc_clk_scg_en (hssi_adapt_tx_osc_clk_scg_en),
        .hssi_adapt_tx_phcomp_rd_del (hssi_adapt_tx_phcomp_rd_del),
        .hssi_adapt_tx_powerdown_mode (hssi_adapt_tx_powerdown_mode),
        .hssi_adapt_tx_silicon_rev (hssi_adapt_tx_silicon_rev),
        .hssi_adapt_tx_stretch_num_stages (hssi_adapt_tx_stretch_num_stages),
        .hssi_adapt_tx_sup_mode (hssi_adapt_tx_sup_mode),
        .hssi_adapt_tx_topology (hssi_adapt_tx_topology),
        .hssi_adapt_tx_tx_datapath_tb_sel (hssi_adapt_tx_tx_datapath_tb_sel),
        .hssi_adapt_tx_tx_fifo_power_mode (hssi_adapt_tx_tx_fifo_power_mode),
        .hssi_adapt_tx_tx_fifo_read_latency_adjust (hssi_adapt_tx_tx_fifo_read_latency_adjust),
        .hssi_adapt_tx_tx_fifo_write_latency_adjust (hssi_adapt_tx_tx_fifo_write_latency_adjust),
        .hssi_adapt_tx_tx_osc_clock_setting (hssi_adapt_tx_tx_osc_clock_setting),
        .hssi_adapt_tx_tx_rev_lpbk (hssi_adapt_tx_tx_rev_lpbk),
        .hssi_adapt_tx_tx_usertest_sel (hssi_adapt_tx_tx_usertest_sel),
        .hssi_adapt_tx_txfifo_empty (hssi_adapt_tx_txfifo_empty),
        .hssi_adapt_tx_txfifo_full (hssi_adapt_tx_txfifo_full),
        .hssi_adapt_tx_txfifo_pempty (hssi_adapt_tx_txfifo_pempty),
        .hssi_adapt_tx_txfifo_pfull (hssi_adapt_tx_txfifo_pfull),
        .hssi_adapt_tx_word_align (hssi_adapt_tx_word_align),
        .hssi_adapt_tx_word_align_enable (hssi_adapt_tx_word_align_enable),
        .hssi_aibcr_rx_aib_datasel_gr0 (hssi_aibcr_rx_aib_datasel_gr0),
        .hssi_aibcr_rx_aib_datasel_gr1 (hssi_aibcr_rx_aib_datasel_gr1),
        .hssi_aibcr_rx_aib_datasel_gr2 (hssi_aibcr_rx_aib_datasel_gr2),
        .hssi_aibcr_rx_aib_ddrctrl_gr0 (hssi_aibcr_rx_aib_ddrctrl_gr0),
        .hssi_aibcr_rx_aib_ddrctrl_gr1 (hssi_aibcr_rx_aib_ddrctrl_gr1),
        .hssi_aibcr_rx_aib_iinasyncen (hssi_aibcr_rx_aib_iinasyncen),
        .hssi_aibcr_rx_aib_iinclken (hssi_aibcr_rx_aib_iinclken),
        .hssi_aibcr_rx_aib_outctrl_gr0 (hssi_aibcr_rx_aib_outctrl_gr0),
        .hssi_aibcr_rx_aib_outctrl_gr1 (hssi_aibcr_rx_aib_outctrl_gr1),
        .hssi_aibcr_rx_aib_outctrl_gr2 (hssi_aibcr_rx_aib_outctrl_gr2),
        .hssi_aibcr_rx_aib_outctrl_gr3 (hssi_aibcr_rx_aib_outctrl_gr3),
        .hssi_aibcr_rx_aib_outndrv_r12 (hssi_aibcr_rx_aib_outndrv_r12),
        .hssi_aibcr_rx_aib_outndrv_r56 (hssi_aibcr_rx_aib_outndrv_r56),
        .hssi_aibcr_rx_aib_outndrv_r78 (hssi_aibcr_rx_aib_outndrv_r78),
        .hssi_aibcr_rx_aib_outpdrv_r12 (hssi_aibcr_rx_aib_outpdrv_r12),
        .hssi_aibcr_rx_aib_outpdrv_r56 (hssi_aibcr_rx_aib_outpdrv_r56),
        .hssi_aibcr_rx_aib_outpdrv_r78 (hssi_aibcr_rx_aib_outpdrv_r78),
        .hssi_aibcr_rx_aib_red_rx_shiften (hssi_aibcr_rx_aib_red_rx_shiften),
        .hssi_aibcr_rx_aib_rx_clkdiv (hssi_aibcr_rx_aib_rx_clkdiv),
        .hssi_aibcr_rx_aib_rx_dcc_byp (hssi_aibcr_rx_aib_rx_dcc_byp),
        .hssi_aibcr_rx_aib_rx_dcc_byp_iocsr_unused (hssi_aibcr_rx_aib_rx_dcc_byp_iocsr_unused),
        .hssi_aibcr_rx_aib_rx_dcc_cont_cal (hssi_aibcr_rx_aib_rx_dcc_cont_cal),
        .hssi_aibcr_rx_aib_rx_dcc_cont_cal_iocsr_unused (hssi_aibcr_rx_aib_rx_dcc_cont_cal_iocsr_unused),
        .hssi_aibcr_rx_aib_rx_dcc_dft (hssi_aibcr_rx_aib_rx_dcc_dft),
        .hssi_aibcr_rx_aib_rx_dcc_dft_sel (hssi_aibcr_rx_aib_rx_dcc_dft_sel),
        .hssi_aibcr_rx_aib_rx_dcc_dll_entest (hssi_aibcr_rx_aib_rx_dcc_dll_entest),
        .hssi_aibcr_rx_aib_rx_dcc_dy_ctl_static (hssi_aibcr_rx_aib_rx_dcc_dy_ctl_static),
        .hssi_aibcr_rx_aib_rx_dcc_dy_ctlsel (hssi_aibcr_rx_aib_rx_dcc_dy_ctlsel),
        .hssi_aibcr_rx_aib_rx_dcc_en (hssi_aibcr_rx_aib_rx_dcc_en),
        .hssi_aibcr_rx_aib_rx_dcc_en_iocsr_unused (hssi_aibcr_rx_aib_rx_dcc_en_iocsr_unused),
        .hssi_aibcr_rx_aib_rx_dcc_manual_dn (hssi_aibcr_rx_aib_rx_dcc_manual_dn),
        .hssi_aibcr_rx_aib_rx_dcc_manual_up (hssi_aibcr_rx_aib_rx_dcc_manual_up),
        .hssi_aibcr_rx_aib_rx_dcc_rst_prgmnvrt (hssi_aibcr_rx_aib_rx_dcc_rst_prgmnvrt),
        .hssi_aibcr_rx_aib_rx_dcc_st_core_dn_prgmnvrt (hssi_aibcr_rx_aib_rx_dcc_st_core_dn_prgmnvrt),
        .hssi_aibcr_rx_aib_rx_dcc_st_core_up_prgmnvrt (hssi_aibcr_rx_aib_rx_dcc_st_core_up_prgmnvrt),
        .hssi_aibcr_rx_aib_rx_dcc_st_core_updnen (hssi_aibcr_rx_aib_rx_dcc_st_core_updnen),
        .hssi_aibcr_rx_aib_rx_dcc_st_dftmuxsel (hssi_aibcr_rx_aib_rx_dcc_st_dftmuxsel),
        .hssi_aibcr_rx_aib_rx_dcc_st_dly_pst (hssi_aibcr_rx_aib_rx_dcc_st_dly_pst),
        .hssi_aibcr_rx_aib_rx_dcc_st_en (hssi_aibcr_rx_aib_rx_dcc_st_en),
        .hssi_aibcr_rx_aib_rx_dcc_st_lockreq_muxsel (hssi_aibcr_rx_aib_rx_dcc_st_lockreq_muxsel),
        .hssi_aibcr_rx_aib_rx_dcc_st_new_dll (hssi_aibcr_rx_aib_rx_dcc_st_new_dll),
        .hssi_aibcr_rx_aib_rx_dcc_st_new_dll2 (hssi_aibcr_rx_aib_rx_dcc_st_new_dll2),
        .hssi_aibcr_rx_aib_rx_dcc_st_rst (hssi_aibcr_rx_aib_rx_dcc_st_rst),
        .hssi_aibcr_rx_aib_rx_dcc_test_clk_pll_en_n (hssi_aibcr_rx_aib_rx_dcc_test_clk_pll_en_n),
        .hssi_aibcr_rx_aib_rx_halfcode (hssi_aibcr_rx_aib_rx_halfcode),
        .hssi_aibcr_rx_aib_rx_selflock (hssi_aibcr_rx_aib_rx_selflock),
        .hssi_aibcr_rx_dft_hssitestip_dll_dcc_en (hssi_aibcr_rx_dft_hssitestip_dll_dcc_en),
        .hssi_aibcr_rx_op_mode (hssi_aibcr_rx_op_mode),
        .hssi_aibcr_rx_powermode_ac (hssi_aibcr_rx_powermode_ac),
        .hssi_aibcr_rx_powermode_dc (hssi_aibcr_rx_powermode_dc),
        .hssi_aibcr_rx_redundancy_en (hssi_aibcr_rx_redundancy_en),
        .hssi_aibcr_rx_rx_transfer_clk_duty_cycle (hssi_aibcr_rx_rx_transfer_clk_duty_cycle),
        .hssi_aibcr_rx_silicon_rev (hssi_aibcr_rx_silicon_rev),
        .hssi_aibcr_rx_sup_mode (hssi_aibcr_rx_sup_mode),
        .hssi_aibcr_tx_aib_datasel_gr0 (hssi_aibcr_tx_aib_datasel_gr0),
        .hssi_aibcr_tx_aib_datasel_gr1 (hssi_aibcr_tx_aib_datasel_gr1),
        .hssi_aibcr_tx_aib_datasel_gr2 (hssi_aibcr_tx_aib_datasel_gr2),
        .hssi_aibcr_tx_aib_dllstr_align_clkdiv (hssi_aibcr_tx_aib_dllstr_align_clkdiv),
        .hssi_aibcr_tx_aib_dllstr_align_dcc_dll_dft_sel (hssi_aibcr_tx_aib_dllstr_align_dcc_dll_dft_sel),
        .hssi_aibcr_tx_aib_dllstr_align_dft_ch_muxsel (hssi_aibcr_tx_aib_dllstr_align_dft_ch_muxsel),
        .hssi_aibcr_tx_aib_dllstr_align_dly_pst (hssi_aibcr_tx_aib_dllstr_align_dly_pst),
        .hssi_aibcr_tx_aib_dllstr_align_dy_ctl_static (hssi_aibcr_tx_aib_dllstr_align_dy_ctl_static),
        .hssi_aibcr_tx_aib_dllstr_align_dy_ctlsel (hssi_aibcr_tx_aib_dllstr_align_dy_ctlsel),
        .hssi_aibcr_tx_aib_dllstr_align_entest (hssi_aibcr_tx_aib_dllstr_align_entest),
        .hssi_aibcr_tx_aib_dllstr_align_halfcode (hssi_aibcr_tx_aib_dllstr_align_halfcode),
        .hssi_aibcr_tx_aib_dllstr_align_selflock (hssi_aibcr_tx_aib_dllstr_align_selflock),
        .hssi_aibcr_tx_aib_dllstr_align_st_core_dn_prgmnvrt (hssi_aibcr_tx_aib_dllstr_align_st_core_dn_prgmnvrt),
        .hssi_aibcr_tx_aib_dllstr_align_st_core_up_prgmnvrt (hssi_aibcr_tx_aib_dllstr_align_st_core_up_prgmnvrt),
        .hssi_aibcr_tx_aib_dllstr_align_st_core_updnen (hssi_aibcr_tx_aib_dllstr_align_st_core_updnen),
        .hssi_aibcr_tx_aib_dllstr_align_st_dftmuxsel (hssi_aibcr_tx_aib_dllstr_align_st_dftmuxsel),
        .hssi_aibcr_tx_aib_dllstr_align_st_en (hssi_aibcr_tx_aib_dllstr_align_st_en),
        .hssi_aibcr_tx_aib_dllstr_align_st_lockreq_muxsel (hssi_aibcr_tx_aib_dllstr_align_st_lockreq_muxsel),
        .hssi_aibcr_tx_aib_dllstr_align_st_new_dll (hssi_aibcr_tx_aib_dllstr_align_st_new_dll),
        .hssi_aibcr_tx_aib_dllstr_align_st_new_dll2 (hssi_aibcr_tx_aib_dllstr_align_st_new_dll2),
        .hssi_aibcr_tx_aib_dllstr_align_st_rst (hssi_aibcr_tx_aib_dllstr_align_st_rst),
        .hssi_aibcr_tx_aib_dllstr_align_st_rst_prgmnvrt (hssi_aibcr_tx_aib_dllstr_align_st_rst_prgmnvrt),
        .hssi_aibcr_tx_aib_dllstr_align_test_clk_pll_en_n (hssi_aibcr_tx_aib_dllstr_align_test_clk_pll_en_n),
        .hssi_aibcr_tx_aib_inctrl_gr0 (hssi_aibcr_tx_aib_inctrl_gr0),
        .hssi_aibcr_tx_aib_inctrl_gr1 (hssi_aibcr_tx_aib_inctrl_gr1),
        .hssi_aibcr_tx_aib_inctrl_gr2 (hssi_aibcr_tx_aib_inctrl_gr2),
        .hssi_aibcr_tx_aib_inctrl_gr3 (hssi_aibcr_tx_aib_inctrl_gr3),
        .hssi_aibcr_tx_aib_outctrl_gr0 (hssi_aibcr_tx_aib_outctrl_gr0),
        .hssi_aibcr_tx_aib_outctrl_gr1 (hssi_aibcr_tx_aib_outctrl_gr1),
        .hssi_aibcr_tx_aib_outctrl_gr2 (hssi_aibcr_tx_aib_outctrl_gr2),
        .hssi_aibcr_tx_aib_outndrv_r12 (hssi_aibcr_tx_aib_outndrv_r12),
        .hssi_aibcr_tx_aib_outndrv_r34 (hssi_aibcr_tx_aib_outndrv_r34),
        .hssi_aibcr_tx_aib_outndrv_r56 (hssi_aibcr_tx_aib_outndrv_r56),
        .hssi_aibcr_tx_aib_outndrv_r78 (hssi_aibcr_tx_aib_outndrv_r78),
        .hssi_aibcr_tx_aib_outpdrv_r12 (hssi_aibcr_tx_aib_outpdrv_r12),
        .hssi_aibcr_tx_aib_outpdrv_r34 (hssi_aibcr_tx_aib_outpdrv_r34),
        .hssi_aibcr_tx_aib_outpdrv_r56 (hssi_aibcr_tx_aib_outpdrv_r56),
        .hssi_aibcr_tx_aib_outpdrv_r78 (hssi_aibcr_tx_aib_outpdrv_r78),
        .hssi_aibcr_tx_aib_red_dirclkn_shiften (hssi_aibcr_tx_aib_red_dirclkn_shiften),
        .hssi_aibcr_tx_aib_red_dirclkp_shiften (hssi_aibcr_tx_aib_red_dirclkp_shiften),
        .hssi_aibcr_tx_aib_red_drx_shiften (hssi_aibcr_tx_aib_red_drx_shiften),
        .hssi_aibcr_tx_aib_red_dtx_shiften (hssi_aibcr_tx_aib_red_dtx_shiften),
        .hssi_aibcr_tx_aib_red_pinp_shiften (hssi_aibcr_tx_aib_red_pinp_shiften),
        .hssi_aibcr_tx_aib_red_rx_shiften (hssi_aibcr_tx_aib_red_rx_shiften),
        .hssi_aibcr_tx_aib_red_tx_shiften (hssi_aibcr_tx_aib_red_tx_shiften),
        .hssi_aibcr_tx_aib_red_txferclkout_shiften (hssi_aibcr_tx_aib_red_txferclkout_shiften),
        .hssi_aibcr_tx_aib_red_txferclkoutn_shiften (hssi_aibcr_tx_aib_red_txferclkoutn_shiften),
        .hssi_aibcr_tx_dfd_dll_dcc_en (hssi_aibcr_tx_dfd_dll_dcc_en),
        .hssi_aibcr_tx_dft_hssitestip_dll_dcc_en (hssi_aibcr_tx_dft_hssitestip_dll_dcc_en),
        .hssi_aibcr_tx_op_mode (hssi_aibcr_tx_op_mode),
        .hssi_aibcr_tx_powermode_ac (hssi_aibcr_tx_powermode_ac),
        .hssi_aibcr_tx_powermode_dc (hssi_aibcr_tx_powermode_dc),
        .hssi_aibcr_tx_redundancy_en (hssi_aibcr_tx_redundancy_en),
        .hssi_aibcr_tx_silicon_rev (hssi_aibcr_tx_silicon_rev),
        .hssi_aibcr_tx_sup_mode (hssi_aibcr_tx_sup_mode),
        .hssi_aibnd_rx_aib_datasel_gr0 (hssi_aibnd_rx_aib_datasel_gr0),
        .hssi_aibnd_rx_aib_datasel_gr1 (hssi_aibnd_rx_aib_datasel_gr1),
        .hssi_aibnd_rx_aib_datasel_gr2 (hssi_aibnd_rx_aib_datasel_gr2),
        .hssi_aibnd_rx_aib_dllstr_align_clkdiv (hssi_aibnd_rx_aib_dllstr_align_clkdiv),
        .hssi_aibnd_rx_aib_dllstr_align_dly_pst (hssi_aibnd_rx_aib_dllstr_align_dly_pst),
        .hssi_aibnd_rx_aib_dllstr_align_dy_ctl_static (hssi_aibnd_rx_aib_dllstr_align_dy_ctl_static),
        .hssi_aibnd_rx_aib_dllstr_align_dy_ctlsel (hssi_aibnd_rx_aib_dllstr_align_dy_ctlsel),
        .hssi_aibnd_rx_aib_dllstr_align_entest (hssi_aibnd_rx_aib_dllstr_align_entest),
        .hssi_aibnd_rx_aib_dllstr_align_halfcode (hssi_aibnd_rx_aib_dllstr_align_halfcode),
        .hssi_aibnd_rx_aib_dllstr_align_selflock (hssi_aibnd_rx_aib_dllstr_align_selflock),
        .hssi_aibnd_rx_aib_dllstr_align_st_core_dn_prgmnvrt (hssi_aibnd_rx_aib_dllstr_align_st_core_dn_prgmnvrt),
        .hssi_aibnd_rx_aib_dllstr_align_st_core_up_prgmnvrt (hssi_aibnd_rx_aib_dllstr_align_st_core_up_prgmnvrt),
        .hssi_aibnd_rx_aib_dllstr_align_st_core_updnen (hssi_aibnd_rx_aib_dllstr_align_st_core_updnen),
        .hssi_aibnd_rx_aib_dllstr_align_st_dftmuxsel (hssi_aibnd_rx_aib_dllstr_align_st_dftmuxsel),
        .hssi_aibnd_rx_aib_dllstr_align_st_en (hssi_aibnd_rx_aib_dllstr_align_st_en),
        .hssi_aibnd_rx_aib_dllstr_align_st_hps_ctrl_en (hssi_aibnd_rx_aib_dllstr_align_st_hps_ctrl_en),
        .hssi_aibnd_rx_aib_dllstr_align_st_lockreq_muxsel (hssi_aibnd_rx_aib_dllstr_align_st_lockreq_muxsel),
        .hssi_aibnd_rx_aib_dllstr_align_st_new_dll (hssi_aibnd_rx_aib_dllstr_align_st_new_dll),
        .hssi_aibnd_rx_aib_dllstr_align_st_rst (hssi_aibnd_rx_aib_dllstr_align_st_rst),
        .hssi_aibnd_rx_aib_dllstr_align_st_rst_prgmnvrt (hssi_aibnd_rx_aib_dllstr_align_st_rst_prgmnvrt),
        .hssi_aibnd_rx_aib_dllstr_align_test_clk_pll_en_n (hssi_aibnd_rx_aib_dllstr_align_test_clk_pll_en_n),
        .hssi_aibnd_rx_aib_inctrl_gr0 (hssi_aibnd_rx_aib_inctrl_gr0),
        .hssi_aibnd_rx_aib_inctrl_gr1 (hssi_aibnd_rx_aib_inctrl_gr1),
        .hssi_aibnd_rx_aib_inctrl_gr2 (hssi_aibnd_rx_aib_inctrl_gr2),
        .hssi_aibnd_rx_aib_inctrl_gr3 (hssi_aibnd_rx_aib_inctrl_gr3),
        .hssi_aibnd_rx_aib_outctrl_gr0 (hssi_aibnd_rx_aib_outctrl_gr0),
        .hssi_aibnd_rx_aib_outctrl_gr1 (hssi_aibnd_rx_aib_outctrl_gr1),
        .hssi_aibnd_rx_aib_outctrl_gr2 (hssi_aibnd_rx_aib_outctrl_gr2),
        .hssi_aibnd_rx_aib_outndrv_r12 (hssi_aibnd_rx_aib_outndrv_r12),
        .hssi_aibnd_rx_aib_outndrv_r34 (hssi_aibnd_rx_aib_outndrv_r34),
        .hssi_aibnd_rx_aib_outndrv_r56 (hssi_aibnd_rx_aib_outndrv_r56),
        .hssi_aibnd_rx_aib_outndrv_r78 (hssi_aibnd_rx_aib_outndrv_r78),
        .hssi_aibnd_rx_aib_outpdrv_r12 (hssi_aibnd_rx_aib_outpdrv_r12),
        .hssi_aibnd_rx_aib_outpdrv_r34 (hssi_aibnd_rx_aib_outpdrv_r34),
        .hssi_aibnd_rx_aib_outpdrv_r56 (hssi_aibnd_rx_aib_outpdrv_r56),
        .hssi_aibnd_rx_aib_outpdrv_r78 (hssi_aibnd_rx_aib_outpdrv_r78),
        .hssi_aibnd_rx_aib_red_shift_en (hssi_aibnd_rx_aib_red_shift_en),
        .hssi_aibnd_rx_dft_hssitestip_dll_dcc_en (hssi_aibnd_rx_dft_hssitestip_dll_dcc_en),
        .hssi_aibnd_rx_op_mode (hssi_aibnd_rx_op_mode),
        .hssi_aibnd_rx_powermode_ac (hssi_aibnd_rx_powermode_ac),
        .hssi_aibnd_rx_powermode_dc (hssi_aibnd_rx_powermode_dc),
        .hssi_aibnd_rx_powerdown_mode (hssi_aibnd_rx_powerdown_mode),
        .hssi_aibnd_rx_redundancy_en (hssi_aibnd_rx_redundancy_en),
        .hssi_aibnd_rx_silicon_rev (hssi_aibnd_rx_silicon_rev),
        .hssi_aibnd_rx_sup_mode (hssi_aibnd_rx_sup_mode),
        .hssi_aibnd_tx_aib_datasel_gr0 (hssi_aibnd_tx_aib_datasel_gr0),
        .hssi_aibnd_tx_aib_datasel_gr1 (hssi_aibnd_tx_aib_datasel_gr1),
        .hssi_aibnd_tx_aib_datasel_gr2 (hssi_aibnd_tx_aib_datasel_gr2),
        .hssi_aibnd_tx_aib_datasel_gr3 (hssi_aibnd_tx_aib_datasel_gr3),
        .hssi_aibnd_tx_aib_ddrctrl_gr0 (hssi_aibnd_tx_aib_ddrctrl_gr0),
        .hssi_aibnd_tx_aib_iinasyncen (hssi_aibnd_tx_aib_iinasyncen),
        .hssi_aibnd_tx_aib_iinclken (hssi_aibnd_tx_aib_iinclken),
        .hssi_aibnd_tx_aib_outctrl_gr0 (hssi_aibnd_tx_aib_outctrl_gr0),
        .hssi_aibnd_tx_aib_outctrl_gr1 (hssi_aibnd_tx_aib_outctrl_gr1),
        .hssi_aibnd_tx_aib_outctrl_gr2 (hssi_aibnd_tx_aib_outctrl_gr2),
        .hssi_aibnd_tx_aib_outctrl_gr3 (hssi_aibnd_tx_aib_outctrl_gr3),
        .hssi_aibnd_tx_aib_outndrv_r34 (hssi_aibnd_tx_aib_outndrv_r34),
        .hssi_aibnd_tx_aib_outndrv_r56 (hssi_aibnd_tx_aib_outndrv_r56),
        .hssi_aibnd_tx_aib_outpdrv_r34 (hssi_aibnd_tx_aib_outpdrv_r34),
        .hssi_aibnd_tx_aib_outpdrv_r56 (hssi_aibnd_tx_aib_outpdrv_r56),
        .hssi_aibnd_tx_aib_red_dirclkn_shiften (hssi_aibnd_tx_aib_red_dirclkn_shiften),
        .hssi_aibnd_tx_aib_red_dirclkp_shiften (hssi_aibnd_tx_aib_red_dirclkp_shiften),
        .hssi_aibnd_tx_aib_red_drx_shiften (hssi_aibnd_tx_aib_red_drx_shiften),
        .hssi_aibnd_tx_aib_red_dtx_shiften (hssi_aibnd_tx_aib_red_dtx_shiften),
        .hssi_aibnd_tx_aib_red_pout_shiften (hssi_aibnd_tx_aib_red_pout_shiften),
        .hssi_aibnd_tx_aib_red_rx_shiften (hssi_aibnd_tx_aib_red_rx_shiften),
        .hssi_aibnd_tx_aib_red_tx_shiften (hssi_aibnd_tx_aib_red_tx_shiften),
        .hssi_aibnd_tx_aib_red_txferclkout_shiften (hssi_aibnd_tx_aib_red_txferclkout_shiften),
        .hssi_aibnd_tx_aib_red_txferclkoutn_shiften (hssi_aibnd_tx_aib_red_txferclkoutn_shiften),
        .hssi_aibnd_tx_aib_tx_clkdiv (hssi_aibnd_tx_aib_tx_clkdiv),
        .hssi_aibnd_tx_aib_tx_dcc_byp (hssi_aibnd_tx_aib_tx_dcc_byp),
        .hssi_aibnd_tx_aib_tx_dcc_byp_iocsr_unused (hssi_aibnd_tx_aib_tx_dcc_byp_iocsr_unused),
        .hssi_aibnd_tx_aib_tx_dcc_cont_cal (hssi_aibnd_tx_aib_tx_dcc_cont_cal),
        .hssi_aibnd_tx_aib_tx_dcc_cont_cal_iocsr_unused (hssi_aibnd_tx_aib_tx_dcc_cont_cal_iocsr_unused),
        .hssi_aibnd_tx_aib_tx_dcc_dft (hssi_aibnd_tx_aib_tx_dcc_dft),
        .hssi_aibnd_tx_aib_tx_dcc_dft_sel (hssi_aibnd_tx_aib_tx_dcc_dft_sel),
        .hssi_aibnd_tx_aib_tx_dcc_dll_dft_sel (hssi_aibnd_tx_aib_tx_dcc_dll_dft_sel),
        .hssi_aibnd_tx_aib_tx_dcc_dll_entest (hssi_aibnd_tx_aib_tx_dcc_dll_entest),
        .hssi_aibnd_tx_aib_tx_dcc_dy_ctl_static (hssi_aibnd_tx_aib_tx_dcc_dy_ctl_static),
        .hssi_aibnd_tx_aib_tx_dcc_dy_ctlsel (hssi_aibnd_tx_aib_tx_dcc_dy_ctlsel),
        .hssi_aibnd_tx_aib_tx_dcc_en (hssi_aibnd_tx_aib_tx_dcc_en),
        .hssi_aibnd_tx_aib_tx_dcc_en_iocsr_unused (hssi_aibnd_tx_aib_tx_dcc_en_iocsr_unused),
        .hssi_aibnd_tx_aib_tx_dcc_manual_dn (hssi_aibnd_tx_aib_tx_dcc_manual_dn),
        .hssi_aibnd_tx_aib_tx_dcc_manual_up (hssi_aibnd_tx_aib_tx_dcc_manual_up),
        .hssi_aibnd_tx_aib_tx_dcc_rst_prgmnvrt (hssi_aibnd_tx_aib_tx_dcc_rst_prgmnvrt),
        .hssi_aibnd_tx_aib_tx_dcc_st_core_dn_prgmnvrt (hssi_aibnd_tx_aib_tx_dcc_st_core_dn_prgmnvrt),
        .hssi_aibnd_tx_aib_tx_dcc_st_core_up_prgmnvrt (hssi_aibnd_tx_aib_tx_dcc_st_core_up_prgmnvrt),
        .hssi_aibnd_tx_aib_tx_dcc_st_core_updnen (hssi_aibnd_tx_aib_tx_dcc_st_core_updnen),
        .hssi_aibnd_tx_aib_tx_dcc_st_dftmuxsel (hssi_aibnd_tx_aib_tx_dcc_st_dftmuxsel),
        .hssi_aibnd_tx_aib_tx_dcc_st_dly_pst (hssi_aibnd_tx_aib_tx_dcc_st_dly_pst),
        .hssi_aibnd_tx_aib_tx_dcc_st_en (hssi_aibnd_tx_aib_tx_dcc_st_en),
        .hssi_aibnd_tx_aib_tx_dcc_st_hps_ctrl_en (hssi_aibnd_tx_aib_tx_dcc_st_hps_ctrl_en),
        .hssi_aibnd_tx_aib_tx_dcc_st_lockreq_muxsel (hssi_aibnd_tx_aib_tx_dcc_st_lockreq_muxsel),
        .hssi_aibnd_tx_aib_tx_dcc_st_new_dll (hssi_aibnd_tx_aib_tx_dcc_st_new_dll),
        .hssi_aibnd_tx_aib_tx_dcc_st_rst (hssi_aibnd_tx_aib_tx_dcc_st_rst),
        .hssi_aibnd_tx_aib_tx_dcc_test_clk_pll_en_n (hssi_aibnd_tx_aib_tx_dcc_test_clk_pll_en_n),
        .hssi_aibnd_tx_aib_tx_halfcode (hssi_aibnd_tx_aib_tx_halfcode),
        .hssi_aibnd_tx_aib_tx_selflock (hssi_aibnd_tx_aib_tx_selflock),
        .hssi_aibnd_tx_dfd_dll_dcc_en (hssi_aibnd_tx_dfd_dll_dcc_en),
        .hssi_aibnd_tx_dft_hssitestip_dll_dcc_en (hssi_aibnd_tx_dft_hssitestip_dll_dcc_en),
        .hssi_aibnd_tx_op_mode (hssi_aibnd_tx_op_mode),
        .hssi_aibnd_tx_powermode_ac (hssi_aibnd_tx_powermode_ac),
        .hssi_aibnd_tx_powermode_dc (hssi_aibnd_tx_powermode_dc),
        .hssi_aibnd_tx_powerdown_mode (hssi_aibnd_tx_powerdown_mode),
        .hssi_aibnd_tx_redundancy_en (hssi_aibnd_tx_redundancy_en),
        .hssi_aibnd_tx_silicon_rev (hssi_aibnd_tx_silicon_rev),
        .hssi_aibnd_tx_sup_mode (hssi_aibnd_tx_sup_mode),
        .hssi_ehip_lane_am_encoding40g_0 (hssi_ehip_lane_am_encoding40g_0),
        .hssi_ehip_lane_am_encoding40g_1 (hssi_ehip_lane_am_encoding40g_1),
        .hssi_ehip_lane_am_encoding40g_2 (hssi_ehip_lane_am_encoding40g_2),
        .hssi_ehip_lane_am_encoding40g_3 (hssi_ehip_lane_am_encoding40g_3),
        .hssi_ehip_lane_ber_invalid_count (hssi_ehip_lane_ber_invalid_count),
        .hssi_ehip_lane_cfgonly_bypass_select (hssi_ehip_lane_cfgonly_bypass_select),
        .hssi_ehip_lane_check_random_idles (hssi_ehip_lane_check_random_idles),
        .hssi_ehip_lane_crete_type (hssi_ehip_lane_crete_type),
        .hssi_ehip_lane_deskew_clear (hssi_ehip_lane_deskew_clear),
        .hssi_ehip_lane_disable_link_fault_rf (hssi_ehip_lane_disable_link_fault_rf),
        .hssi_ehip_lane_ehip_clk_hz (hssi_ehip_lane_ehip_clk_hz),
        .hssi_ehip_lane_ehip_clk_sel (hssi_ehip_lane_ehip_clk_sel),
        .hssi_ehip_lane_ehip_dist_clk_sel (hssi_ehip_lane_ehip_dist_clk_sel),
        .hssi_ehip_lane_ehip_mode (hssi_ehip_lane_ehip_mode),
        .hssi_ehip_lane_ehip_rate (hssi_ehip_lane_ehip_rate),
        .hssi_ehip_lane_ehip_type (hssi_ehip_lane_ehip_type),
        .hssi_ehip_lane_enable_rx_stats_snapshot (hssi_ehip_lane_enable_rx_stats_snapshot),
        .hssi_ehip_lane_enable_tx_stats_snapshot (hssi_ehip_lane_enable_tx_stats_snapshot),
        .hssi_ehip_lane_enforce_max_frame_size (hssi_ehip_lane_enforce_max_frame_size),
        .hssi_ehip_lane_fec_dist_clk_sel (hssi_ehip_lane_fec_dist_clk_sel),
        .hssi_ehip_lane_flow_control (hssi_ehip_lane_flow_control),
        .hssi_ehip_lane_flow_control_holdoff_mode (hssi_ehip_lane_flow_control_holdoff_mode),
        .hssi_ehip_lane_force_deskew_done (hssi_ehip_lane_force_deskew_done),
        .hssi_ehip_lane_force_hip_ready (hssi_ehip_lane_force_hip_ready),
        .hssi_ehip_lane_force_link_fault_rf (hssi_ehip_lane_force_link_fault_rf),
        .hssi_ehip_lane_forward_rx_pause_requests (hssi_ehip_lane_forward_rx_pause_requests),
        .hssi_ehip_lane_func_mode (hssi_ehip_lane_func_mode),
        .hssi_ehip_lane_hi_ber_monitor (hssi_ehip_lane_hi_ber_monitor),
        .hssi_ehip_lane_holdoff_quanta (hssi_ehip_lane_holdoff_quanta),
        .hssi_ehip_lane_ipg_removed_per_am_period (hssi_ehip_lane_ipg_removed_per_am_period),
        .hssi_ehip_lane_is_usr_avmm (hssi_ehip_lane_is_usr_avmm),
        .hssi_ehip_lane_keep_rx_crc (hssi_ehip_lane_keep_rx_crc),
        .hssi_ehip_lane_link_fault_mode (hssi_ehip_lane_link_fault_mode),
        .hssi_ehip_lane_pause_quanta (hssi_ehip_lane_pause_quanta),
        .hssi_ehip_lane_pfc_holdoff_quanta_0 (hssi_ehip_lane_pfc_holdoff_quanta_0),
        .hssi_ehip_lane_pfc_holdoff_quanta_1 (hssi_ehip_lane_pfc_holdoff_quanta_1),
        .hssi_ehip_lane_pfc_holdoff_quanta_2 (hssi_ehip_lane_pfc_holdoff_quanta_2),
        .hssi_ehip_lane_pfc_holdoff_quanta_3 (hssi_ehip_lane_pfc_holdoff_quanta_3),
        .hssi_ehip_lane_pfc_holdoff_quanta_4 (hssi_ehip_lane_pfc_holdoff_quanta_4),
        .hssi_ehip_lane_pfc_holdoff_quanta_5 (hssi_ehip_lane_pfc_holdoff_quanta_5),
        .hssi_ehip_lane_pfc_holdoff_quanta_6 (hssi_ehip_lane_pfc_holdoff_quanta_6),
        .hssi_ehip_lane_pfc_holdoff_quanta_7 (hssi_ehip_lane_pfc_holdoff_quanta_7),
        .hssi_ehip_lane_pfc_pause_quanta_0 (hssi_ehip_lane_pfc_pause_quanta_0),
        .hssi_ehip_lane_pfc_pause_quanta_1 (hssi_ehip_lane_pfc_pause_quanta_1),
        .hssi_ehip_lane_pfc_pause_quanta_2 (hssi_ehip_lane_pfc_pause_quanta_2),
        .hssi_ehip_lane_pfc_pause_quanta_3 (hssi_ehip_lane_pfc_pause_quanta_3),
        .hssi_ehip_lane_pfc_pause_quanta_4 (hssi_ehip_lane_pfc_pause_quanta_4),
        .hssi_ehip_lane_pfc_pause_quanta_5 (hssi_ehip_lane_pfc_pause_quanta_5),
        .hssi_ehip_lane_pfc_pause_quanta_6 (hssi_ehip_lane_pfc_pause_quanta_6),
        .hssi_ehip_lane_pfc_pause_quanta_7 (hssi_ehip_lane_pfc_pause_quanta_7),
        .hssi_ehip_lane_powerdown_mode (hssi_ehip_lane_powerdown_mode),
        .hssi_ehip_lane_powermode_ac_mac (hssi_ehip_lane_powermode_ac_mac),
        .hssi_ehip_lane_powermode_ac_misc (hssi_ehip_lane_powermode_ac_misc),
        .hssi_ehip_lane_powermode_ac_pcs (hssi_ehip_lane_powermode_ac_pcs),
        .hssi_ehip_lane_powermode_ac_pld (hssi_ehip_lane_powermode_ac_pld),
        .hssi_ehip_lane_powermode_dc (hssi_ehip_lane_powermode_dc),
        .hssi_ehip_lane_ptp_timestamp_format (hssi_ehip_lane_ptp_timestamp_format),
        .hssi_ehip_lane_ptp_tx_timestamp_method (hssi_ehip_lane_ptp_tx_timestamp_method),
        .hssi_ehip_lane_remove_pads (hssi_ehip_lane_remove_pads),
        .hssi_ehip_lane_request_tx_pause (hssi_ehip_lane_request_tx_pause),
        .hssi_ehip_lane_reset_rx_stats (hssi_ehip_lane_reset_rx_stats),
        .hssi_ehip_lane_reset_rx_stats_parity_error (hssi_ehip_lane_reset_rx_stats_parity_error),
        .hssi_ehip_lane_reset_tx_stats (hssi_ehip_lane_reset_tx_stats),
        .hssi_ehip_lane_reset_tx_stats_parity_error (hssi_ehip_lane_reset_tx_stats_parity_error),
        .hssi_ehip_lane_rx_am_interval (hssi_ehip_lane_rx_am_interval),
        .hssi_ehip_lane_rx_clock_period (hssi_ehip_lane_rx_clock_period),
        .hssi_ehip_lane_rx_datapath_soft_rst (hssi_ehip_lane_rx_datapath_soft_rst),
        .hssi_ehip_lane_rx_length_checking (hssi_ehip_lane_rx_length_checking),
        .hssi_ehip_lane_rx_mac_soft_rst (hssi_ehip_lane_rx_mac_soft_rst),
        .hssi_ehip_lane_rx_max_frame_size (hssi_ehip_lane_rx_max_frame_size),
        .hssi_ehip_lane_rx_pcs_max_skew (hssi_ehip_lane_rx_pcs_max_skew),
        .hssi_ehip_lane_rx_pcs_soft_rst (hssi_ehip_lane_rx_pcs_soft_rst),
        .hssi_ehip_lane_rx_preamble_passthrough (hssi_ehip_lane_rx_preamble_passthrough),
        .hssi_ehip_lane_rx_vlan_detection (hssi_ehip_lane_rx_vlan_detection),
        .hssi_ehip_lane_rxcrc_covers_preamble (hssi_ehip_lane_rxcrc_covers_preamble),
        .hssi_ehip_lane_silicon_rev (hssi_ehip_lane_silicon_rev),
        .hssi_ehip_lane_sim_mode (hssi_ehip_lane_sim_mode),
        .hssi_ehip_lane_source_address_insertion (hssi_ehip_lane_source_address_insertion),
        .hssi_ehip_lane_strict_preamble_checking (hssi_ehip_lane_strict_preamble_checking),
        .hssi_ehip_lane_strict_sfd_checking (hssi_ehip_lane_strict_sfd_checking),
        .hssi_ehip_lane_sup_mode (hssi_ehip_lane_sup_mode),
        .hssi_ehip_lane_topology (hssi_ehip_lane_topology),
        .hssi_ehip_lane_tx_am_period (hssi_ehip_lane_tx_am_period),
        .hssi_ehip_lane_tx_clock_period (hssi_ehip_lane_tx_clock_period),
        .hssi_ehip_lane_tx_datapath_soft_rst (hssi_ehip_lane_tx_datapath_soft_rst),
        .hssi_ehip_lane_tx_ipg_size (hssi_ehip_lane_tx_ipg_size),
        .hssi_ehip_lane_tx_mac_data_flow (hssi_ehip_lane_tx_mac_data_flow),
        .hssi_ehip_lane_tx_mac_soft_rst (hssi_ehip_lane_tx_mac_soft_rst),
        .hssi_ehip_lane_tx_max_frame_size (hssi_ehip_lane_tx_max_frame_size),
        .hssi_ehip_lane_tx_pcs_soft_rst (hssi_ehip_lane_tx_pcs_soft_rst),
        .hssi_ehip_lane_tx_pld_fifo_almost_full_level (hssi_ehip_lane_tx_pld_fifo_almost_full_level),
        .hssi_ehip_lane_tx_preamble_passthrough (hssi_ehip_lane_tx_preamble_passthrough),
        .hssi_ehip_lane_tx_vlan_detection (hssi_ehip_lane_tx_vlan_detection),
        .hssi_ehip_lane_txcrc_covers_preamble (hssi_ehip_lane_txcrc_covers_preamble),
        .hssi_ehip_lane_uniform_holdoff_quanta (hssi_ehip_lane_uniform_holdoff_quanta),
        .hssi_ehip_lane_use_am_insert (hssi_ehip_lane_use_am_insert),
        .hssi_ehip_lane_use_factory_settings (hssi_ehip_lane_use_factory_settings),
        .hssi_ehip_lane_use_lane_ptp (hssi_ehip_lane_use_lane_ptp),
        .hssi_ehip_lane_use_testbus (hssi_ehip_lane_use_testbus),
        .hssi_ehip_lane_xus_timer_window (hssi_ehip_lane_xus_timer_window),
        .hssi_pldadapt_rx_aib_clk1_sel (hssi_pldadapt_rx_aib_clk1_sel),
        .hssi_pldadapt_rx_aib_clk2_sel (hssi_pldadapt_rx_aib_clk2_sel),
        .hssi_pldadapt_rx_asn_bypass_pma_pcie_sw_done (hssi_pldadapt_rx_asn_bypass_pma_pcie_sw_done),
        .hssi_pldadapt_rx_asn_en (hssi_pldadapt_rx_asn_en),
        .hssi_pldadapt_rx_asn_wait_for_dll_reset_cnt (hssi_pldadapt_rx_asn_wait_for_dll_reset_cnt),
        .hssi_pldadapt_rx_asn_wait_for_fifo_flush_cnt (hssi_pldadapt_rx_asn_wait_for_fifo_flush_cnt),
        .hssi_pldadapt_rx_asn_wait_for_pma_pcie_sw_done_cnt (hssi_pldadapt_rx_asn_wait_for_pma_pcie_sw_done_cnt),
        .hssi_pldadapt_rx_bonding_dft_en (hssi_pldadapt_rx_bonding_dft_en),
        .hssi_pldadapt_rx_bonding_dft_val (hssi_pldadapt_rx_bonding_dft_val),
        .hssi_pldadapt_rx_chnl_bonding (hssi_pldadapt_rx_chnl_bonding),
        .hssi_pldadapt_rx_clock_del_measure_enable (hssi_pldadapt_rx_clock_del_measure_enable),
        .hssi_pldadapt_rx_comp_cnt (hssi_pldadapt_rx_comp_cnt),
        .hssi_pldadapt_rx_compin_sel (hssi_pldadapt_rx_compin_sel),
        .hssi_pldadapt_rx_ctrl_plane_bonding (hssi_pldadapt_rx_ctrl_plane_bonding),
        .hssi_pldadapt_rx_ds_bypass_pipeln (hssi_pldadapt_rx_ds_bypass_pipeln),
        .hssi_pldadapt_rx_ds_last_chnl (hssi_pldadapt_rx_ds_last_chnl),
        .hssi_pldadapt_rx_ds_master (hssi_pldadapt_rx_ds_master),
        .hssi_pldadapt_rx_duplex_mode (hssi_pldadapt_rx_duplex_mode),
        .hssi_pldadapt_rx_dv_mode (hssi_pldadapt_rx_dv_mode),
        .hssi_pldadapt_rx_fifo_double_read (hssi_pldadapt_rx_fifo_double_read),
        .hssi_pldadapt_rx_fifo_mode (hssi_pldadapt_rx_fifo_mode),
        .hssi_pldadapt_rx_fifo_rd_clk_ins_sm_scg_en (hssi_pldadapt_rx_fifo_rd_clk_ins_sm_scg_en),
        .hssi_pldadapt_rx_fifo_rd_clk_scg_en (hssi_pldadapt_rx_fifo_rd_clk_scg_en),
        .hssi_pldadapt_rx_fifo_rd_clk_sel (hssi_pldadapt_rx_fifo_rd_clk_sel),
        .hssi_pldadapt_rx_fifo_stop_rd (hssi_pldadapt_rx_fifo_stop_rd),
        .hssi_pldadapt_rx_fifo_stop_wr (hssi_pldadapt_rx_fifo_stop_wr),
        .hssi_pldadapt_rx_fifo_width (hssi_pldadapt_rx_fifo_width),
        .hssi_pldadapt_rx_fifo_wr_clk_del_sm_scg_en (hssi_pldadapt_rx_fifo_wr_clk_del_sm_scg_en),
        .hssi_pldadapt_rx_fifo_wr_clk_scg_en (hssi_pldadapt_rx_fifo_wr_clk_scg_en),
        .hssi_pldadapt_rx_fifo_wr_clk_sel (hssi_pldadapt_rx_fifo_wr_clk_sel),
        .hssi_pldadapt_rx_free_run_div_clk (hssi_pldadapt_rx_free_run_div_clk),
        .hssi_pldadapt_rx_fsr_pld_8g_sigdet_out_rst_val (hssi_pldadapt_rx_fsr_pld_8g_sigdet_out_rst_val),
        .hssi_pldadapt_rx_fsr_pld_10g_rx_crc32_err_rst_val (hssi_pldadapt_rx_fsr_pld_10g_rx_crc32_err_rst_val),
        .hssi_pldadapt_rx_fsr_pld_ltd_b_rst_val (hssi_pldadapt_rx_fsr_pld_ltd_b_rst_val),
        .hssi_pldadapt_rx_fsr_pld_ltr_rst_val (hssi_pldadapt_rx_fsr_pld_ltr_rst_val),
        .hssi_pldadapt_rx_fsr_pld_rx_fifo_align_clr_rst_val (hssi_pldadapt_rx_fsr_pld_rx_fifo_align_clr_rst_val),
        .hssi_pldadapt_rx_gb_rx_idwidth (hssi_pldadapt_rx_gb_rx_idwidth),
        .hssi_pldadapt_rx_gb_rx_odwidth (hssi_pldadapt_rx_gb_rx_odwidth),
        .hssi_pldadapt_rx_hdpldadapt_aib_fabric_pld_pma_hclk_hz (hssi_pldadapt_rx_hdpldadapt_aib_fabric_pld_pma_hclk_hz),
        .hssi_pldadapt_rx_hdpldadapt_aib_fabric_rx_transfer_clk_hz (hssi_pldadapt_rx_hdpldadapt_aib_fabric_rx_transfer_clk_hz),
        .hssi_pldadapt_rx_hdpldadapt_csr_clk_hz (hssi_pldadapt_rx_hdpldadapt_csr_clk_hz),
        .hssi_pldadapt_rx_hdpldadapt_pld_avmm1_clk_rowclk_hz (hssi_pldadapt_rx_hdpldadapt_pld_avmm1_clk_rowclk_hz),
        .hssi_pldadapt_rx_hdpldadapt_pld_avmm2_clk_rowclk_hz (hssi_pldadapt_rx_hdpldadapt_pld_avmm2_clk_rowclk_hz),
        .hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz (hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_dcm_hz),
        .hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz (hssi_pldadapt_rx_hdpldadapt_pld_rx_clk1_rowclk_hz),
        .hssi_pldadapt_rx_hdpldadapt_pld_sclk1_rowclk_hz (hssi_pldadapt_rx_hdpldadapt_pld_sclk1_rowclk_hz),
        .hssi_pldadapt_rx_hdpldadapt_pld_sclk2_rowclk_hz (hssi_pldadapt_rx_hdpldadapt_pld_sclk2_rowclk_hz),
        .hssi_pldadapt_rx_hdpldadapt_speed_grade (hssi_pldadapt_rx_hdpldadapt_speed_grade),
        .hssi_pldadapt_rx_hip_mode (hssi_pldadapt_rx_hip_mode),
        .hssi_pldadapt_rx_hrdrst_align_bypass (hssi_pldadapt_rx_hrdrst_align_bypass),
        .hssi_pldadapt_rx_hrdrst_dll_lock_bypass (hssi_pldadapt_rx_hrdrst_dll_lock_bypass),
        .hssi_pldadapt_rx_hrdrst_rst_sm_dis (hssi_pldadapt_rx_hrdrst_rst_sm_dis),
        .hssi_pldadapt_rx_hrdrst_rx_osc_clk_scg_en (hssi_pldadapt_rx_hrdrst_rx_osc_clk_scg_en),
        .hssi_pldadapt_rx_hrdrst_user_ctl_en (hssi_pldadapt_rx_hrdrst_user_ctl_en),
        .hssi_pldadapt_rx_indv (hssi_pldadapt_rx_indv),
        .hssi_pldadapt_rx_internal_clk1_sel1 (hssi_pldadapt_rx_internal_clk1_sel1),
        .hssi_pldadapt_rx_internal_clk1_sel2 (hssi_pldadapt_rx_internal_clk1_sel2),
        .hssi_pldadapt_rx_internal_clk2_sel1 (hssi_pldadapt_rx_internal_clk2_sel1),
        .hssi_pldadapt_rx_internal_clk2_sel2 (hssi_pldadapt_rx_internal_clk2_sel2),
        .hssi_pldadapt_rx_loopback_mode (hssi_pldadapt_rx_loopback_mode),
        .hssi_pldadapt_rx_low_latency_en (hssi_pldadapt_rx_low_latency_en),
        .hssi_pldadapt_rx_lpbk_mode (hssi_pldadapt_rx_lpbk_mode),
        .hssi_pldadapt_rx_osc_clk_scg_en (hssi_pldadapt_rx_osc_clk_scg_en),
        .hssi_pldadapt_rx_phcomp_rd_del (hssi_pldadapt_rx_phcomp_rd_del),
        .hssi_pldadapt_rx_pipe_enable (hssi_pldadapt_rx_pipe_enable),
        .hssi_pldadapt_rx_pipe_mode (hssi_pldadapt_rx_pipe_mode),
        .hssi_pldadapt_rx_pld_clk1_delay_en (hssi_pldadapt_rx_pld_clk1_delay_en),
        .hssi_pldadapt_rx_pld_clk1_delay_sel (hssi_pldadapt_rx_pld_clk1_delay_sel),
        .hssi_pldadapt_rx_pld_clk1_inv_en (hssi_pldadapt_rx_pld_clk1_inv_en),
        .hssi_pldadapt_rx_pld_clk1_sel (hssi_pldadapt_rx_pld_clk1_sel),
        .hssi_pldadapt_rx_pma_hclk_scg_en (hssi_pldadapt_rx_pma_hclk_scg_en),
        .hssi_pldadapt_rx_powerdown_mode (hssi_pldadapt_rx_powerdown_mode),
        .hssi_pldadapt_rx_rx_datapath_tb_sel (hssi_pldadapt_rx_rx_datapath_tb_sel),
        .hssi_pldadapt_rx_rx_fastbond_rden (hssi_pldadapt_rx_rx_fastbond_rden),
        .hssi_pldadapt_rx_rx_fastbond_wren (hssi_pldadapt_rx_rx_fastbond_wren),
        .hssi_pldadapt_rx_rx_fifo_power_mode (hssi_pldadapt_rx_rx_fifo_power_mode),
        .hssi_pldadapt_rx_rx_fifo_read_latency_adjust (hssi_pldadapt_rx_rx_fifo_read_latency_adjust),
        .hssi_pldadapt_rx_rx_fifo_write_ctrl (hssi_pldadapt_rx_rx_fifo_write_ctrl),
        .hssi_pldadapt_rx_rx_fifo_write_latency_adjust (hssi_pldadapt_rx_rx_fifo_write_latency_adjust),
        .hssi_pldadapt_rx_rx_osc_clock_setting (hssi_pldadapt_rx_rx_osc_clock_setting),
        .hssi_pldadapt_rx_rx_pld_8g_eidleinfersel_polling_bypass (hssi_pldadapt_rx_rx_pld_8g_eidleinfersel_polling_bypass),
        .hssi_pldadapt_rx_rx_pld_pma_eye_monitor_polling_bypass (hssi_pldadapt_rx_rx_pld_pma_eye_monitor_polling_bypass),
        .hssi_pldadapt_rx_rx_pld_pma_pcie_switch_polling_bypass (hssi_pldadapt_rx_rx_pld_pma_pcie_switch_polling_bypass),
        .hssi_pldadapt_rx_rx_pld_pma_reser_out_polling_bypass (hssi_pldadapt_rx_rx_pld_pma_reser_out_polling_bypass),
        .hssi_pldadapt_rx_rx_prbs_flags_sr_enable (hssi_pldadapt_rx_rx_prbs_flags_sr_enable),
        .hssi_pldadapt_rx_rx_true_b2b (hssi_pldadapt_rx_rx_true_b2b),
        .hssi_pldadapt_rx_rx_usertest_sel (hssi_pldadapt_rx_rx_usertest_sel),
        .hssi_pldadapt_rx_rxfifo_empty (hssi_pldadapt_rx_rxfifo_empty),
        .hssi_pldadapt_rx_rxfifo_full (hssi_pldadapt_rx_rxfifo_full),
        .hssi_pldadapt_rx_rxfifo_mode (hssi_pldadapt_rx_rxfifo_mode),
        .hssi_pldadapt_rx_rxfifo_pempty (hssi_pldadapt_rx_rxfifo_pempty),
        .hssi_pldadapt_rx_rxfifo_pfull (hssi_pldadapt_rx_rxfifo_pfull),
        .hssi_pldadapt_rx_rxfiford_post_ct_sel (hssi_pldadapt_rx_rxfiford_post_ct_sel),
        .hssi_pldadapt_rx_rxfifowr_post_ct_sel (hssi_pldadapt_rx_rxfifowr_post_ct_sel),
        .hssi_pldadapt_rx_sclk_sel (hssi_pldadapt_rx_sclk_sel),
        .hssi_pldadapt_rx_silicon_rev (hssi_pldadapt_rx_silicon_rev),
        .hssi_pldadapt_rx_stretch_num_stages (hssi_pldadapt_rx_stretch_num_stages),
        .hssi_pldadapt_rx_sup_mode (hssi_pldadapt_rx_sup_mode),
        .hssi_pldadapt_rx_txfiford_post_ct_sel (hssi_pldadapt_rx_txfiford_post_ct_sel),
        .hssi_pldadapt_rx_txfifowr_post_ct_sel (hssi_pldadapt_rx_txfifowr_post_ct_sel),
        .hssi_pldadapt_rx_us_bypass_pipeln (hssi_pldadapt_rx_us_bypass_pipeln),
        .hssi_pldadapt_rx_us_last_chnl (hssi_pldadapt_rx_us_last_chnl),
        .hssi_pldadapt_rx_us_master (hssi_pldadapt_rx_us_master),
        .hssi_pldadapt_rx_word_align (hssi_pldadapt_rx_word_align),
        .hssi_pldadapt_rx_word_align_enable (hssi_pldadapt_rx_word_align_enable),
        .hssi_pldadapt_tx_aib_clk1_sel (hssi_pldadapt_tx_aib_clk1_sel),
        .hssi_pldadapt_tx_aib_clk2_sel (hssi_pldadapt_tx_aib_clk2_sel),
        .hssi_pldadapt_tx_bonding_dft_en (hssi_pldadapt_tx_bonding_dft_en),
        .hssi_pldadapt_tx_bonding_dft_val (hssi_pldadapt_tx_bonding_dft_val),
        .hssi_pldadapt_tx_chnl_bonding (hssi_pldadapt_tx_chnl_bonding),
        .hssi_pldadapt_tx_comp_cnt (hssi_pldadapt_tx_comp_cnt),
        .hssi_pldadapt_tx_compin_sel (hssi_pldadapt_tx_compin_sel),
        .hssi_pldadapt_tx_ctrl_plane_bonding (hssi_pldadapt_tx_ctrl_plane_bonding),
        .hssi_pldadapt_tx_ds_bypass_pipeln (hssi_pldadapt_tx_ds_bypass_pipeln),
        .hssi_pldadapt_tx_ds_last_chnl (hssi_pldadapt_tx_ds_last_chnl),
        .hssi_pldadapt_tx_ds_master (hssi_pldadapt_tx_ds_master),
        .hssi_pldadapt_tx_duplex_mode (hssi_pldadapt_tx_duplex_mode),
        .hssi_pldadapt_tx_dv_bond (hssi_pldadapt_tx_dv_bond),
        .hssi_pldadapt_tx_dv_gen (hssi_pldadapt_tx_dv_gen),
        .hssi_pldadapt_tx_fifo_double_write (hssi_pldadapt_tx_fifo_double_write),
        .hssi_pldadapt_tx_fifo_mode (hssi_pldadapt_tx_fifo_mode),
        .hssi_pldadapt_tx_fifo_rd_clk_frm_gen_scg_en (hssi_pldadapt_tx_fifo_rd_clk_frm_gen_scg_en),
        .hssi_pldadapt_tx_fifo_rd_clk_scg_en (hssi_pldadapt_tx_fifo_rd_clk_scg_en),
        .hssi_pldadapt_tx_fifo_rd_clk_sel (hssi_pldadapt_tx_fifo_rd_clk_sel),
        .hssi_pldadapt_tx_fifo_stop_rd (hssi_pldadapt_tx_fifo_stop_rd),
        .hssi_pldadapt_tx_fifo_stop_wr (hssi_pldadapt_tx_fifo_stop_wr),
        .hssi_pldadapt_tx_fifo_width (hssi_pldadapt_tx_fifo_width),
        .hssi_pldadapt_tx_fifo_wr_clk_scg_en (hssi_pldadapt_tx_fifo_wr_clk_scg_en),
        .hssi_pldadapt_tx_fpll_shared_direct_async_in_sel (hssi_pldadapt_tx_fpll_shared_direct_async_in_sel),
        .hssi_pldadapt_tx_frmgen_burst (hssi_pldadapt_tx_frmgen_burst),
        .hssi_pldadapt_tx_frmgen_bypass (hssi_pldadapt_tx_frmgen_bypass),
        .hssi_pldadapt_tx_frmgen_mfrm_length (hssi_pldadapt_tx_frmgen_mfrm_length),
        .hssi_pldadapt_tx_frmgen_pipeln (hssi_pldadapt_tx_frmgen_pipeln),
        .hssi_pldadapt_tx_frmgen_pyld_ins (hssi_pldadapt_tx_frmgen_pyld_ins),
        .hssi_pldadapt_tx_frmgen_wordslip (hssi_pldadapt_tx_frmgen_wordslip),
        .hssi_pldadapt_tx_fsr_hip_fsr_in_bit0_rst_val (hssi_pldadapt_tx_fsr_hip_fsr_in_bit0_rst_val),
        .hssi_pldadapt_tx_fsr_hip_fsr_in_bit1_rst_val (hssi_pldadapt_tx_fsr_hip_fsr_in_bit1_rst_val),
        .hssi_pldadapt_tx_fsr_hip_fsr_in_bit2_rst_val (hssi_pldadapt_tx_fsr_hip_fsr_in_bit2_rst_val),
        .hssi_pldadapt_tx_fsr_hip_fsr_in_bit3_rst_val (hssi_pldadapt_tx_fsr_hip_fsr_in_bit3_rst_val),
        .hssi_pldadapt_tx_fsr_hip_fsr_out_bit0_rst_val (hssi_pldadapt_tx_fsr_hip_fsr_out_bit0_rst_val),
        .hssi_pldadapt_tx_fsr_hip_fsr_out_bit1_rst_val (hssi_pldadapt_tx_fsr_hip_fsr_out_bit1_rst_val),
        .hssi_pldadapt_tx_fsr_hip_fsr_out_bit2_rst_val (hssi_pldadapt_tx_fsr_hip_fsr_out_bit2_rst_val),
        .hssi_pldadapt_tx_fsr_hip_fsr_out_bit3_rst_val (hssi_pldadapt_tx_fsr_hip_fsr_out_bit3_rst_val),
        .hssi_pldadapt_tx_fsr_mask_tx_pll_rst_val (hssi_pldadapt_tx_fsr_mask_tx_pll_rst_val),
        .hssi_pldadapt_tx_fsr_pld_txelecidle_rst_val (hssi_pldadapt_tx_fsr_pld_txelecidle_rst_val),
        .hssi_pldadapt_tx_gb_tx_idwidth (hssi_pldadapt_tx_gb_tx_idwidth),
        .hssi_pldadapt_tx_gb_tx_odwidth (hssi_pldadapt_tx_gb_tx_odwidth),
        .hssi_pldadapt_tx_hdpldadapt_aib_fabric_pld_pma_hclk_hz (hssi_pldadapt_tx_hdpldadapt_aib_fabric_pld_pma_hclk_hz),
        .hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz (hssi_pldadapt_tx_hdpldadapt_aib_fabric_pma_aib_tx_clk_hz),
        .hssi_pldadapt_tx_hdpldadapt_csr_clk_hz (hssi_pldadapt_tx_hdpldadapt_csr_clk_hz),
        .hssi_pldadapt_tx_hdpldadapt_pld_avmm1_clk_rowclk_hz (hssi_pldadapt_tx_hdpldadapt_pld_avmm1_clk_rowclk_hz),
        .hssi_pldadapt_tx_hdpldadapt_pld_avmm2_clk_rowclk_hz (hssi_pldadapt_tx_hdpldadapt_pld_avmm2_clk_rowclk_hz),
        .hssi_pldadapt_tx_hdpldadapt_pld_sclk1_rowclk_hz (hssi_pldadapt_tx_hdpldadapt_pld_sclk1_rowclk_hz),
        .hssi_pldadapt_tx_hdpldadapt_pld_sclk2_rowclk_hz (hssi_pldadapt_tx_hdpldadapt_pld_sclk2_rowclk_hz),
        .hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz (hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_dcm_hz),
        .hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_rowclk_hz (hssi_pldadapt_tx_hdpldadapt_pld_tx_clk1_rowclk_hz),
        .hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz (hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_dcm_hz),
        .hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_rowclk_hz (hssi_pldadapt_tx_hdpldadapt_pld_tx_clk2_rowclk_hz),
        .hssi_pldadapt_tx_hdpldadapt_speed_grade (hssi_pldadapt_tx_hdpldadapt_speed_grade),
        .hssi_pldadapt_tx_hip_mode (hssi_pldadapt_tx_hip_mode),
        .hssi_pldadapt_tx_hip_osc_clk_scg_en (hssi_pldadapt_tx_hip_osc_clk_scg_en),
        .hssi_pldadapt_tx_hrdrst_dcd_cal_done_bypass (hssi_pldadapt_tx_hrdrst_dcd_cal_done_bypass),
        .hssi_pldadapt_tx_hrdrst_rst_sm_dis (hssi_pldadapt_tx_hrdrst_rst_sm_dis),
        .hssi_pldadapt_tx_hrdrst_rx_osc_clk_scg_en (hssi_pldadapt_tx_hrdrst_rx_osc_clk_scg_en),
        .hssi_pldadapt_tx_hrdrst_user_ctl_en (hssi_pldadapt_tx_hrdrst_user_ctl_en),
        .hssi_pldadapt_tx_indv (hssi_pldadapt_tx_indv),
        .hssi_pldadapt_tx_loopback_mode (hssi_pldadapt_tx_loopback_mode),
        .hssi_pldadapt_tx_low_latency_en (hssi_pldadapt_tx_low_latency_en),
        .hssi_pldadapt_tx_osc_clk_scg_en (hssi_pldadapt_tx_osc_clk_scg_en),
        .hssi_pldadapt_tx_phcomp_rd_del (hssi_pldadapt_tx_phcomp_rd_del),
        .hssi_pldadapt_tx_pipe_mode (hssi_pldadapt_tx_pipe_mode),
        .hssi_pldadapt_tx_pld_clk1_delay_en (hssi_pldadapt_tx_pld_clk1_delay_en),
        .hssi_pldadapt_tx_pld_clk1_delay_sel (hssi_pldadapt_tx_pld_clk1_delay_sel),
        .hssi_pldadapt_tx_pld_clk1_inv_en (hssi_pldadapt_tx_pld_clk1_inv_en),
        .hssi_pldadapt_tx_pld_clk1_sel (hssi_pldadapt_tx_pld_clk1_sel),
        .hssi_pldadapt_tx_pld_clk2_sel (hssi_pldadapt_tx_pld_clk2_sel),
        .hssi_pldadapt_tx_pma_aib_tx_clk_expected_setting (hssi_pldadapt_tx_pma_aib_tx_clk_expected_setting),
        .hssi_pldadapt_tx_powerdown_mode (hssi_pldadapt_tx_powerdown_mode),
        .hssi_pldadapt_tx_sh_err (hssi_pldadapt_tx_sh_err),
        .hssi_pldadapt_tx_silicon_rev (hssi_pldadapt_tx_silicon_rev),
        .hssi_pldadapt_tx_stretch_num_stages (hssi_pldadapt_tx_stretch_num_stages),
        .hssi_pldadapt_tx_sup_mode (hssi_pldadapt_tx_sup_mode),
        .hssi_pldadapt_tx_tx_datapath_tb_sel (hssi_pldadapt_tx_tx_datapath_tb_sel),
        .hssi_pldadapt_tx_tx_fastbond_rden (hssi_pldadapt_tx_tx_fastbond_rden),
        .hssi_pldadapt_tx_tx_fastbond_wren (hssi_pldadapt_tx_tx_fastbond_wren),
        .hssi_pldadapt_tx_tx_fifo_power_mode (hssi_pldadapt_tx_tx_fifo_power_mode),
        .hssi_pldadapt_tx_tx_fifo_read_latency_adjust (hssi_pldadapt_tx_tx_fifo_read_latency_adjust),
        .hssi_pldadapt_tx_tx_fifo_write_latency_adjust (hssi_pldadapt_tx_tx_fifo_write_latency_adjust),
        .hssi_pldadapt_tx_tx_hip_aib_ssr_in_polling_bypass (hssi_pldadapt_tx_tx_hip_aib_ssr_in_polling_bypass),
        .hssi_pldadapt_tx_tx_osc_clock_setting (hssi_pldadapt_tx_tx_osc_clock_setting),
        .hssi_pldadapt_tx_tx_pld_8g_tx_boundary_sel_polling_bypass (hssi_pldadapt_tx_tx_pld_8g_tx_boundary_sel_polling_bypass),
        .hssi_pldadapt_tx_tx_pld_10g_tx_bitslip_polling_bypass (hssi_pldadapt_tx_tx_pld_10g_tx_bitslip_polling_bypass),
        .hssi_pldadapt_tx_tx_pld_pma_fpll_cnt_sel_polling_bypass (hssi_pldadapt_tx_tx_pld_pma_fpll_cnt_sel_polling_bypass),
        .hssi_pldadapt_tx_tx_pld_pma_fpll_num_phase_shifts_polling_bypass (hssi_pldadapt_tx_tx_pld_pma_fpll_num_phase_shifts_polling_bypass),
        .hssi_pldadapt_tx_tx_usertest_sel (hssi_pldadapt_tx_tx_usertest_sel),
        .hssi_pldadapt_tx_txfifo_empty (hssi_pldadapt_tx_txfifo_empty),
        .hssi_pldadapt_tx_txfifo_full (hssi_pldadapt_tx_txfifo_full),
        .hssi_pldadapt_tx_txfifo_mode (hssi_pldadapt_tx_txfifo_mode),
        .hssi_pldadapt_tx_txfifo_pempty (hssi_pldadapt_tx_txfifo_pempty),
        .hssi_pldadapt_tx_txfifo_pfull (hssi_pldadapt_tx_txfifo_pfull),
        .hssi_pldadapt_tx_us_bypass_pipeln (hssi_pldadapt_tx_us_bypass_pipeln),
        .hssi_pldadapt_tx_us_last_chnl (hssi_pldadapt_tx_us_last_chnl),
        .hssi_pldadapt_tx_us_master (hssi_pldadapt_tx_us_master),
        .hssi_pldadapt_tx_word_align_enable (hssi_pldadapt_tx_word_align_enable),
        .hssi_pldadapt_tx_word_mark (hssi_pldadapt_tx_word_mark),
        .hssi_xcvr_an_mode (hssi_xcvr_an_mode),
        .hssi_xcvr_bonding_mode (hssi_xcvr_bonding_mode),
        .hssi_xcvr_enable_lowpower_mode (hssi_xcvr_enable_lowpower_mode),
        .hssi_xcvr_cfg_c_revbitorder (hssi_xcvr_cfg_c_revbitorder),
        .hssi_xcvr_cfg_clk_en_div66_tx (hssi_xcvr_cfg_clk_en_div66_tx),
        .hssi_xcvr_cfg_clk_en_sclk_rx (hssi_xcvr_cfg_clk_en_sclk_rx),
        .hssi_xcvr_cfg_clk_en_sclk_tx (hssi_xcvr_cfg_clk_en_sclk_tx),
        .hssi_xcvr_cfg_core_int_request (hssi_xcvr_cfg_core_int_request),
        .hssi_xcvr_cfg_dcc_csr_core_rst_en (hssi_xcvr_cfg_dcc_csr_core_rst_en),
        .hssi_xcvr_cfg_dcc_csr_dft_msel (hssi_xcvr_cfg_dcc_csr_dft_msel),
        .hssi_xcvr_cfg_dcc_csr_dll_sel (hssi_xcvr_cfg_dcc_csr_dll_sel),
        .hssi_xcvr_cfg_dcc_csr_dly_ovr (hssi_xcvr_cfg_dcc_csr_dly_ovr),
        .hssi_xcvr_cfg_dcc_csr_dly_ovr_10 (hssi_xcvr_cfg_dcc_csr_dly_ovr_10),
        .hssi_xcvr_cfg_dcc_csr_dn_invert (hssi_xcvr_cfg_dcc_csr_dn_invert),
        .hssi_xcvr_cfg_dcc_csr_en_fsm (hssi_xcvr_cfg_dcc_csr_en_fsm),
        .hssi_xcvr_cfg_dcc_csr_mux_sel (hssi_xcvr_cfg_dcc_csr_mux_sel),
        .hssi_xcvr_cfg_dcc_csr_resv (hssi_xcvr_cfg_dcc_csr_resv),
        .hssi_xcvr_cfg_dcc_csr_resv_10 (hssi_xcvr_cfg_dcc_csr_resv_10),
        .hssi_xcvr_cfg_dcc_csr_rst_invert (hssi_xcvr_cfg_dcc_csr_rst_invert),
        .hssi_xcvr_cfg_dcc_csr_up_invert (hssi_xcvr_cfg_dcc_csr_up_invert),
        .hssi_xcvr_cfg_dcc_csr_updn_en (hssi_xcvr_cfg_dcc_csr_updn_en),
        .hssi_xcvr_cfg_idll_entest (hssi_xcvr_cfg_idll_entest),
        .hssi_xcvr_cfg_mem_pbist (hssi_xcvr_cfg_mem_pbist),
        .hssi_xcvr_cfg_mem_ulp_tmg_mode (hssi_xcvr_cfg_mem_ulp_tmg_mode),
        .hssi_xcvr_cfg_rb_clkdiv (hssi_xcvr_cfg_rb_clkdiv),
        .hssi_xcvr_cfg_rb_cont_cal (hssi_xcvr_cfg_rb_cont_cal),
        .hssi_xcvr_cfg_rb_dcc_dft (hssi_xcvr_cfg_rb_dcc_dft),
        .hssi_xcvr_cfg_rb_dcc_dft_sel (hssi_xcvr_cfg_rb_dcc_dft_sel),
        .hssi_xcvr_cfg_rb_dcc_manual_dn (hssi_xcvr_cfg_rb_dcc_manual_dn),
        .hssi_xcvr_cfg_rb_dcc_manual_up (hssi_xcvr_cfg_rb_dcc_manual_up),
        .hssi_xcvr_cfg_rb_dcc_req (hssi_xcvr_cfg_rb_dcc_req),
        .hssi_xcvr_cfg_rb_dcc_req_ovr (hssi_xcvr_cfg_rb_dcc_req_ovr),
        .hssi_xcvr_cfg_rb_half_code (hssi_xcvr_cfg_rb_half_code),
        .hssi_xcvr_cfg_rb_nfrzdrv (hssi_xcvr_cfg_rb_nfrzdrv),
        .hssi_xcvr_cfg_rb_selflock (hssi_xcvr_cfg_rb_selflock),
        .hssi_xcvr_cfg_reset_rx_bit_counter (hssi_xcvr_cfg_reset_rx_bit_counter),
        .hssi_xcvr_cfg_restart_seq_sm (hssi_xcvr_cfg_restart_seq_sm),
        .hssi_xcvr_cfg_revbitorder (hssi_xcvr_cfg_revbitorder),
        .hssi_xcvr_cfg_rx_bit_counter_rollover (hssi_xcvr_cfg_rx_bit_counter_rollover),
        .hssi_xcvr_cfg_rx_fifo_lat_en (hssi_xcvr_cfg_rx_fifo_lat_en),
        .hssi_xcvr_cfg_rx_pcs_data_sel (hssi_xcvr_cfg_rx_pcs_data_sel),
        .hssi_xcvr_cfg_rxbit_cntr_pma (hssi_xcvr_cfg_rxbit_cntr_pma),
        .hssi_xcvr_cfg_sel_bit_counter_adder (hssi_xcvr_cfg_sel_bit_counter_adder),
        .hssi_xcvr_cfg_sel_hw_decode_mode (hssi_xcvr_cfg_sel_hw_decode_mode),
        .hssi_xcvr_cfg_tbus_sel (hssi_xcvr_cfg_tbus_sel),
        .hssi_xcvr_cfg_test_clk_pll_en_n (hssi_xcvr_cfg_test_clk_pll_en_n),
        .hssi_xcvr_cfg_tx_fifo_lat_en (hssi_xcvr_cfg_tx_fifo_lat_en),
        .hssi_xcvr_clk_en_div66_rx (hssi_xcvr_clk_en_div66_rx),
        .hssi_xcvr_clk_en_fifo_rx (hssi_xcvr_clk_en_fifo_rx),
        .hssi_xcvr_clk_en_full_rx (hssi_xcvr_clk_en_full_rx),
        .hssi_xcvr_clk_en_full_tx (hssi_xcvr_clk_en_full_tx),
        .hssi_xcvr_clk_en_half_rx (hssi_xcvr_clk_en_half_rx),
        .hssi_xcvr_clk_en_rx (hssi_xcvr_clk_en_rx),
        .hssi_xcvr_clk_en_tx (hssi_xcvr_clk_en_tx),
        .hssi_xcvr_int_core_to_cntl (hssi_xcvr_int_core_to_cntl),
        .hssi_xcvr_int_if_code (hssi_xcvr_int_if_code),
        .hssi_xcvr_int_if_data (hssi_xcvr_int_if_data),
        .hssi_xcvr_int_seq1_tx_clk_slip_cnt (hssi_xcvr_int_seq1_tx_clk_slip_cnt),
        .hssi_xcvr_int_seq1_tx_phase_load_cnt (hssi_xcvr_int_seq1_tx_phase_load_cnt),
        .hssi_xcvr_int_seq1_tx_slip_always_on (hssi_xcvr_int_seq1_tx_slip_always_on),
        .hssi_xcvr_int_seq2_rx_clk_slip_cnt (hssi_xcvr_int_seq2_rx_clk_slip_cnt),
        .hssi_xcvr_int_seq2_rx_phase_load_cnt (hssi_xcvr_int_seq2_rx_phase_load_cnt),
        .hssi_xcvr_int_seq2_rx_slip_always_on (hssi_xcvr_int_seq2_rx_slip_always_on),
        .hssi_xcvr_int_seq3_txpll_refclk_sel (hssi_xcvr_int_seq3_txpll_refclk_sel),
        .hssi_xcvr_int_seq4_rxpll_refclk_sel (hssi_xcvr_int_seq4_rxpll_refclk_sel),
        .hssi_xcvr_int_seq5_ph_opt (hssi_xcvr_int_seq5_ph_opt),
        .hssi_xcvr_interrupt_cntl_ovr_en (hssi_xcvr_interrupt_cntl_ovr_en),
        .hssi_xcvr_interrupt_core_stat_sel_msw (hssi_xcvr_interrupt_core_stat_sel_msw),
        .hssi_xcvr_interrupt_in_prog_assert (hssi_xcvr_interrupt_in_prog_assert),
        .hssi_xcvr_lpbk_mode (hssi_xcvr_lpbk_mode),
        .hssi_xcvr_powerdown_mode (hssi_xcvr_powerdown_mode),
        .hssi_xcvr_powermode_ac_csr (hssi_xcvr_powermode_ac_csr),
        .hssi_xcvr_powermode_ac_xcvrif_rx (hssi_xcvr_powermode_ac_xcvrif_rx),
        .hssi_xcvr_powermode_ac_xcvrif_tx (hssi_xcvr_powermode_ac_xcvrif_tx),
        .hssi_xcvr_powermode_dc_csr (hssi_xcvr_powermode_dc_csr),
        .hssi_xcvr_powermode_dc_xcvrif_rx (hssi_xcvr_powermode_dc_xcvrif_rx),
        .hssi_xcvr_powermode_dc_xcvrif_tx (hssi_xcvr_powermode_dc_xcvrif_tx),
        .hssi_xcvr_refclk_mux_powerdown_mode (hssi_xcvr_refclk_mux_powerdown_mode),
        .hssi_xcvr_refclk_mux_silicon_rev (hssi_xcvr_refclk_mux_silicon_rev),
        .hssi_xcvr_refclk_mux_topology (hssi_xcvr_refclk_mux_topology),
        .hssi_xcvr_rst_en_rx (hssi_xcvr_rst_en_rx),
        .hssi_xcvr_rx_adapt_order_sel (hssi_xcvr_rx_adapt_order_sel),
        .hssi_xcvr_rx_bitslip (hssi_xcvr_rx_bitslip),
        .hssi_xcvr_rx_c_revbitorder (hssi_xcvr_rx_c_revbitorder),
        .hssi_xcvr_rx_det_latency_en (hssi_xcvr_rx_det_latency_en),
        .hssi_xcvr_rx_fifo_clk_sel (hssi_xcvr_rx_fifo_clk_sel),
        .hssi_xcvr_rx_gb_idwidth (hssi_xcvr_rx_gb_idwidth),
        .hssi_xcvr_rx_gb_mode (hssi_xcvr_rx_gb_mode),
        .hssi_xcvr_rx_gb_odwidth (hssi_xcvr_rx_gb_odwidth),
        .hssi_xcvr_rx_interleave_mode (hssi_xcvr_rx_interleave_mode),
        .hssi_xcvr_rx_rden_sel (hssi_xcvr_rx_rden_sel),
        .hssi_xcvr_rx_revbitorder (hssi_xcvr_rx_revbitorder),
        .hssi_xcvr_rx_sh_location (hssi_xcvr_rx_sh_location),
        .hssi_xcvr_rx_tag_sel (hssi_xcvr_rx_tag_sel),
        .hssi_xcvr_rx_width_adapt (hssi_xcvr_rx_width_adapt),
        .hssi_xcvr_rxfifo_ae_thld (hssi_xcvr_rxfifo_ae_thld),
        .hssi_xcvr_rxfifo_af_thld (hssi_xcvr_rxfifo_af_thld),
        .hssi_xcvr_rxfifo_e_thld (hssi_xcvr_rxfifo_e_thld),
        .hssi_xcvr_rxfifo_f_thld (hssi_xcvr_rxfifo_f_thld),
        .hssi_xcvr_rxfifo_rd_empty (hssi_xcvr_rxfifo_rd_empty),
        .hssi_xcvr_rxfifo_wr_full (hssi_xcvr_rxfifo_wr_full),
        .hssi_xcvr_seq_en_phaseopt (hssi_xcvr_seq_en_phaseopt),
        .hssi_xcvr_seq_en_reserved1 (hssi_xcvr_seq_en_reserved1),
        .hssi_xcvr_seq_en_reserved4 (hssi_xcvr_seq_en_reserved4),
        .hssi_xcvr_seq_en_reserved5 (hssi_xcvr_seq_en_reserved5),
        .hssi_xcvr_seq_en_reserved6 (hssi_xcvr_seq_en_reserved6),
        .hssi_xcvr_seq_en_reserved7 (hssi_xcvr_seq_en_reserved7),
        .hssi_xcvr_seq_en_rx_phase_slip (hssi_xcvr_seq_en_rx_phase_slip),
        .hssi_xcvr_seq_en_tx_phase_slip (hssi_xcvr_seq_en_tx_phase_slip),
        .hssi_xcvr_set_int_seq0 (hssi_xcvr_set_int_seq0),
        .hssi_xcvr_set_int_seq1 (hssi_xcvr_set_int_seq1),
        .hssi_xcvr_set_int_seq2 (hssi_xcvr_set_int_seq2),
        .hssi_xcvr_set_int_seq3 (hssi_xcvr_set_int_seq3),
        .hssi_xcvr_set_int_seq4 (hssi_xcvr_set_int_seq4),
        .hssi_xcvr_set_int_seq5 (hssi_xcvr_set_int_seq5),
        .hssi_xcvr_set_int_seq6 (hssi_xcvr_set_int_seq6),
        .hssi_xcvr_set_int_seq7 (hssi_xcvr_set_int_seq7),
        .hssi_xcvr_set_int_seq8 (hssi_xcvr_set_int_seq8),
        .hssi_xcvr_set_int_seq9 (hssi_xcvr_set_int_seq9),
        .hssi_xcvr_set_int_seq10 (hssi_xcvr_set_int_seq10),
        .hssi_xcvr_set_int_seq11 (hssi_xcvr_set_int_seq11),
        .hssi_xcvr_set_int_seq12 (hssi_xcvr_set_int_seq12),
        .hssi_xcvr_set_int_seq13 (hssi_xcvr_set_int_seq13),
        .hssi_xcvr_set_int_seq16_code (hssi_xcvr_set_int_seq16_code),
        .hssi_xcvr_set_int_seq16_data (hssi_xcvr_set_int_seq16_data),
        .hssi_xcvr_set_int_seq17_code (hssi_xcvr_set_int_seq17_code),
        .hssi_xcvr_set_int_seq17_data (hssi_xcvr_set_int_seq17_data),
        .hssi_xcvr_set_int_seq18_code (hssi_xcvr_set_int_seq18_code),
        .hssi_xcvr_set_int_seq18_data (hssi_xcvr_set_int_seq18_data),
        .hssi_xcvr_set_int_seq19_code (hssi_xcvr_set_int_seq19_code),
        .hssi_xcvr_set_int_seq19_data (hssi_xcvr_set_int_seq19_data),
        .hssi_xcvr_set_refclk_scratch0 (hssi_xcvr_set_refclk_scratch0),
        .hssi_xcvr_set_refclk_scratch1 (hssi_xcvr_set_refclk_scratch1),
        .hssi_xcvr_set_refclk_scratch2 (hssi_xcvr_set_refclk_scratch2),
        .hssi_xcvr_set_refclk_scratch3 (hssi_xcvr_set_refclk_scratch3),
        .hssi_xcvr_set_refclk_scratch4 (hssi_xcvr_set_refclk_scratch4),
        .hssi_xcvr_sh_location (hssi_xcvr_sh_location),
        .hssi_xcvr_silicon_rev (hssi_xcvr_silicon_rev),
        .hssi_xcvr_soft_reset_rx (hssi_xcvr_soft_reset_rx),
        .hssi_xcvr_soft_reset_tx (hssi_xcvr_soft_reset_tx),
        .hssi_xcvr_sup_mode (hssi_xcvr_sup_mode),
        .hssi_xcvr_topology (hssi_xcvr_topology),
        .hssi_xcvr_tx_adapt_order_sel (hssi_xcvr_tx_adapt_order_sel),
        .hssi_xcvr_tx_bitslip (hssi_xcvr_tx_bitslip),
        .hssi_xcvr_tx_clk_dp_sel (hssi_xcvr_tx_clk_dp_sel),
        .hssi_xcvr_tx_data_in_sel (hssi_xcvr_tx_data_in_sel),
        .hssi_xcvr_tx_det_latency_en (hssi_xcvr_tx_det_latency_en),
        .hssi_xcvr_tx_gb_idwidth (hssi_xcvr_tx_gb_idwidth),
        .hssi_xcvr_tx_gb_mode (hssi_xcvr_tx_gb_mode),
        .hssi_xcvr_tx_gb_odwidth (hssi_xcvr_tx_gb_odwidth),
        .hssi_xcvr_tx_interleave_mode (hssi_xcvr_tx_interleave_mode),
        .hssi_xcvr_tx_reset_val_66_64 (hssi_xcvr_tx_reset_val_66_64),
        .hssi_xcvr_tx_width_adapt (hssi_xcvr_tx_width_adapt),
        .hssi_xcvr_txfifo_ae_thld (hssi_xcvr_txfifo_ae_thld),
        .hssi_xcvr_txfifo_af_thld (hssi_xcvr_txfifo_af_thld),
        .hssi_xcvr_txfifo_e_thld (hssi_xcvr_txfifo_e_thld),
        .hssi_xcvr_txfifo_f_thld (hssi_xcvr_txfifo_f_thld),
        .hssi_xcvr_txfifo_ph_comp (hssi_xcvr_txfifo_ph_comp),
        .hssi_xcvr_txfifo_rd_empty (hssi_xcvr_txfifo_rd_empty),
        .hssi_xcvr_txfifo_wr_full (hssi_xcvr_txfifo_wr_full),
        .hssi_aibnd_tx_aib_hssi_tx_transfer_clk_hz(hssi_aibnd_tx_aib_hssi_tx_transfer_clk_hz),
        .hssi_pldadapt_rx_is_paired_with(hssi_pldadapt_rx_is_paired_with),
        .hssi_pldadapt_tx_is_paired_with(hssi_pldadapt_tx_is_paired_with),
	.hssi_aibnd_rx_powermode_freq_hz_aib_hssi_rx_transfer_clk(int_2_bin(hssi_aibnd_rx_powermode_freq_hz_aib_hssi_rx_transfer_clk)),
	.hssi_aibnd_tx_powermode_freq_hz_aib_hssi_tx_transfer_clk(int_2_bin(hssi_aibnd_tx_powermode_freq_hz_aib_hssi_tx_transfer_clk)),
	.hssi_pldadapt_rx_powermode_freq_hz_aib_fabric_rx_sr_clk_in(int_2_bin(hssi_pldadapt_rx_powermode_freq_hz_aib_fabric_rx_sr_clk_in)),
	.hssi_pldadapt_rx_powermode_freq_hz_pld_rx_clk1_dcm(int_2_bin(hssi_pldadapt_rx_powermode_freq_hz_pld_rx_clk1_dcm)),
	.hssi_pldadapt_tx_powermode_freq_hz_aib_fabric_rx_sr_clk_in(int_2_bin(hssi_pldadapt_tx_powermode_freq_hz_aib_fabric_rx_sr_clk_in)),
	.hssi_pldadapt_tx_powermode_freq_hz_pld_tx_clk1_dcm(int_2_bin(hssi_pldadapt_tx_powermode_freq_hz_pld_tx_clk1_dcm))

  ) ct3_xcvr_native_inst (
      /* input                              */.in_adapter_clk_sel_n                              ( int_adapter_clk_sel_n  ),
      /* input  [19:0]                      */.in_avmm_testbus                                   ( /*TODO: Added*/ {20{1'b0}}  ),
      /* input                              */.in_bond_rx_asn_ds_in_fifo_hold                    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_asn_us_in_fifo_hold                    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_fifo_ds_in_rden                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_fifo_ds_in_wren                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_fifo_us_in_rden                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_fifo_us_in_wren                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_hrdrst_ds_in_fabric_rx_dll_lock        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_hrdrst_ds_in_fabric_rx_dll_lock_req    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_hrdrst_us_in_fabric_rx_dll_lock        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_rx_hrdrst_us_in_fabric_rx_dll_lock_req    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_fifo_ds_in_dv                          ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_fifo_ds_in_rden                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_fifo_ds_in_wren                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_fifo_us_in_dv                          ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_fifo_us_in_rden                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_fifo_us_in_wren                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_done    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_hrdrst_ds_in_fabric_tx_dcd_cal_req     ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_done    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_bond_tx_hrdrst_us_in_fabric_tx_dcd_cal_req     ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_csr_rdy_dly_in                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_adpt_hard_rst_n                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_async_reset_n                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_config_avmm_cfg_active                       ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_config_avmm_rst_n                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_directout_data_chain1_in                     ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_directout_data_chain2_in                     ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_hard_reset_n                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_jtag_clkdr_in                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_red_idataselb_in_chain1                      ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_red_idataselb_in_chain2                      ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_red_shift_en_in_chain1                       ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_red_shift_en_in_chain2                       ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_refclk0                                      ( channel_specific_clock_conn_0 ),
      /* input                              */.in_i_refclk1                                      ( channel_specific_clock_conn_1 ),
      /* input                              */.in_i_refclk2                                      ( channel_specific_clock_conn_2 ),
      /* input                              */.in_i_refclk3                                      ( channel_specific_clock_conn_3 ),
      /* input                              */.in_i_refclk4                                      ( channel_specific_clock_conn_4 ),
      /* input                              */.in_i_refclk5                                      ( 1'b0  ),
      /* input                              */.in_i_refclk6                                      ( 1'b0  ),
      /* input                              */.in_i_refclk7                                      ( 1'b0  ),
      /* input                              */.in_i_refclk8                                      ( 1'b0  ),
      /* input                              */.in_i_rx_ehip_clk                                  ( aib_ehip_rx_ehip_clk[ig]  ),
      /* input                              */.in_i_rx_ehip_clk_div2                             ( pma_ehip_rx_ehip_clk_div2[ig]  ),
      /* input  [77:0]                      */.in_i_rx_ehip_data                                 ( aib_ehip_rx_sync_data[ig*78+:78]  ),
      /* input                              */.in_i_rx_ehip_fifo_rst_n                           ( pma_ehip_rx_ehip_fifo_rst_n[ig]  ),
      /* input                              */.in_i_rx_ehip_frd_clk                              ( aib_ehip_rx_ehip_fr_clk[ig]  ),
      /* input                              */.in_i_rx_fec_clk_div2                              ( i_rsfec_coreip_rx_rsfec_clk_div2[ig]     /*JRJ: Added connection to RSFEC - Is this the right connection?*/  ),
      /* input  [12:0]                      */.in_i_rx_latency_bit_for_async                     ( i_rsfec_coreip_rx_latency_bit_cw_pos[ig] /*JRJ: Added connection to RSFEC*/  ),
      /* input                              */.in_i_rx_n                                         ( rx_serial_data_n[ig]  ),
      /* input                              */.in_i_rx_p                                         ( rx_serial_data[ig]  ),
      /* input                              */.in_i_rx_rsfec_clk                                 ( i_adapt_ehip_rsfec_clock[ig]             /*JRJ: Added connection to RSFEC*/  ),
      /* input  [77:0]                      */.in_i_rx_rsfec_data                                ( i_rsfec_coreip_rx_data_in[ig]                   /*JRJ: Added connection to RSFEC*/  ),
      /* input                              */.in_i_rx_rsfec_frd_clk                             ( aib_ehip_rx_fec_fr_clk[ig]  ),
      /* input  [7:0]                       */.in_i_sbus_address_in                              ( /*TODO: Added*/ {8{1'b0}} ),
      /* input                              */.in_i_sbus_bist_stat_in                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_sbus_clk_in                                  ( /*TODO: Added*/ 1'b0 ),
      /* input  [7:0]                       */.in_i_sbus_data_in                                 ( /*TODO: Added*/ {8{1'b0}} ),
      /* input                              */.in_i_sbus_interrupt_in                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_sbus_mode_in                                 ( /*TODO: Added*/ 1'b0 ),
      // JRJ 1-9-2019 removed for case 1408167614 /* input                              */.in_i_sbus_reset_in                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_tx_bit0_tag                                  ( i_rsfec_coreip_tx_pma_bit0_tag[ig]  ),
	// /*TODO - Removed*/      /* input                              */.in_i_tx_bonding_pulse_e                           ( /*TODO: Added*/  ),
      /* input                              */.in_i_tx_ehip_clk                                  ( aib_ehip_tx_ehip_clk[ig]  ),
      /* input                              */.in_i_tx_ehip_clk_div2                             ( pma_ehip_tx_ehip_clk_div2[ig]  ),
      /* input  [65:0]                      */.in_i_tx_ehip_data                                 ( pmaRsfec_ehip_tx_ehip_data[ig*66+:66] ),
      /* input                              */.in_i_tx_ehip_dv                                   ( pmaRsfec_ehip_tx_ehip_dv[ig] ),
      /* input                              */.in_i_tx_ehip_fifo_rst_n                           ( pmaRsfec_ehip_tx_ehip_fifo_rst_n[ig] ),
      /* input                              */.in_i_tx_fec_clk_div2                              ( i_rsfec_coreip_tx_rsfec_clk_div2[ig]     /*JRJ: Added connection to RSFEC - How do we know this is where this is supposed to go?*/  ),
      /* input  [65:0]                      */.in_i_tx_fec_data                                  ( i_rsfec_coreip_tx_data_pma_in_rsfec_out[ig]               /*JRJ: Added connection to RSFEC*/  ),
      /* input                              */.in_i_tx_fec_dv                                    ( i_rsfec_coreip_tx_data_valid[ig]                /*JRJ: Added connection to RSFEC*/  ),
     /* input                              */.in_i_tx_refclk_sync_nrz_in                        ( l_in_tx_refclk_sync_nrz[ig] ),
      /* input                              */.in_i_tx_refclk_sync_pam4_in                       ( l_in_tx_refclk_sync_pam4[ig] ),
      /* input                              */.in_i_tx_rsfec_clk                                 ( i_adapt_ehip_rsfec_clock[ig]             /*JRJ: Added connection to RSFEC*/  ),
      /* input                              */.in_i_txen_in_chain1                               ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_txen_in_chain2                               ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_iatpg_pipeline_global_en                       ( 1'b1  ),
      /* input                              */.in_iatpg_scan_clk_in0                             ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_iatpg_scan_clk_in1                             ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_iclkin_dist_vinp0                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_iclkin_dist_vinp1                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idat0_voutp00                                  ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idat0_voutp01                                  ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idat1_voutp00                                  ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idat1_voutp01                                  ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idata0_ssrdout                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idata0_ssrldout                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idata1_ssrdout                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idata1_ssrldout                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idataselb_ssrdout                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idataselb_ssrldout                             ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idataselb_voutp00                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_idataselb_voutp01                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_ijtag_clkdr_in_chain                           ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_ilaunch_clk_ssrdout                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_ilaunch_clk_ssrldout                           ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_ilaunch_clk_voutp00                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_ilaunch_clk_voutp01                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_ired_directin_data_in_chain1                   ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_ired_directin_data_in_chain2                   ( /*TODO: Added*/ 1'b0 ),
      /* input  [2:0]                       */.in_ired_irxen_in_chain1                           ( /*TODO: Added*/ {3{1'b0}} ),
      /* input  [2:0]                       */.in_ired_irxen_in_chain2                           ( /*TODO: Added*/ {3{1'b0}} ),
      /* input                              */.in_ired_shift_en_in_chain1                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_ired_shift_en_in_chain2                        ( /*TODO: Added*/ 1'b0 ),
      /* input  [2:0]                       */.in_irxen_vinp0                                    ( /*TODO: Added*/ {3{1'b0}} ),
      /* input  [2:0]                       */.in_irxen_vinp1                                    ( /*TODO: Added*/ {3{1'b0}} ),
      /* input                              */.in_istrbclk_vinp0                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_istrbclk_vinp1                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_itxen_ssrdout                                  ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_itxen_ssrldout                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_itxen_voutp00                                  ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_itxen_voutp01                                  ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_oclk_srclkout                                  ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_oclkb_srclkout                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_odat_async_fsrdin                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_pcs_clk                                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_pcs_clkb                                       ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_pld_10g_krfec_rx_clr_errblk_cnt                ( /*core_cntl[11]*/ 1'b0 ),
      /* input                              */.in_pld_10g_rx_clr_ber_count                       ( /*core_cntl[12]*/ 1'b0 ),
      /* input  [6:0]                       */.in_pld_10g_tx_bitslip                             ( tx_pmaif_bitslip[ig*7+:7]  ),
      /* input                              */.in_pld_10g_tx_burst_en                            ( /*TODO: Added*/ 1'b0 ),
      /* input  [1:0]                       */.in_pld_10g_tx_diag_status                         ( /*TODO: Added*/ {2{1'b0}} ),
      /* input                              */.in_pld_10g_tx_wordslip                            ( 1'b0									),	// engineering mode only
      /* input                              */.in_pld_8g_a1a2_size                               ( rx_pma_en[ig]  ),
      /* input                              */.in_pld_8g_bitloc_rev_en                           ( /*core_cntl[5]*/ 1'b0  ),
      /* input                              */.in_pld_8g_byte_rev_en                             ( /*core_cntl[6]*/ 1'b0 ),
      /* input  [2:0]                       */.in_pld_8g_eidleinfersel                           ( /*core_cntl[9:7]*/{3{1'b0}}  ),
      /* input                              */.in_pld_8g_encdt                                   ( /*core_cntl[10]*/  1'b0),
      /* input  [4:0]                       */.in_pld_8g_tx_boundary_sel                         ( {3'h0,tx_dl_measure_sel[ig],rx_dl_measure_sel[ig]} ),
      /* input                              */.in_pld_adapter_rx_pld_rst_n                       ( ~int_rx_aib_reset_csr[ig]  ),
      /* input                              */.in_pld_adapter_tx_pld_rst_n                       ( ~int_tx_aib_reset_csr[ig]  ),
      /* input                              */.in_pld_aib_fabric_rx_dll_lock_req                 ( 1'b0  ),	// Fallback mode reset signal
      /* input                              */.in_pld_aib_fabric_tx_dcd_cal_req                  ( 1'b0  ),	// Fallback mode reset signal
      /* input                              */.in_pld_aib_hssi_rx_dcd_cal_req                    ( 1'b0  ),	// Fallback mode reset signal
      /* input                              */.in_pld_aib_hssi_tx_dcd_cal_req                    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_pld_aib_hssi_tx_dll_lock_req                   ( 1'b0  ),	// Fallback mode reset signal
      /* input  [3:0]                       */.in_pld_avmm2_reserved_in                          ( /*TODO: Added*/ {4{1'b0}} ),
      /* input                              */.in_pld_bitslip                                    ( /*core_cntl[13]*/ 1'b0 ),
      /* input                              */.in_pld_ltr                                        ( /*unused fsr[1] xcvrif*/ 1'b0 ),
      /* input                              */.in_pld_pcs_rx_pld_rst_n                           ( rx_enh_reset[ig]  ),
      /* input                              */.in_pld_pcs_tx_pld_rst_n                           ( tx_enh_reset[ig]  ),
      /* input                              */.in_pld_pma_adapt_start                            ( enh_clear_internal_error[ig]  ),
      /* input                              */.in_pld_pma_coreclkin_rowclk                       ( 1'b0  ),
      /* input                              */.in_pld_pma_csr_test_dis                           ( /*unused ssr[29]*/ 1'b0 ),
      /* input                              */.in_pld_pma_early_eios                             ( /*unused elane ssr*/ 1'b0 ),
      /* input  [5:0]                       */.in_pld_pma_eye_monitor                            ( /*unused elane ssr*/ {6{1'b0}} ),
      /* input                              */.in_pld_pma_ltd_b                                  ( /*unused elane fsr*/ 1'b0 ),
      /* input  [1:0]                       */.in_pld_pma_pcie_switch                            ( /*unused elane ssr*/ {2{1'b0}} ),
      /* input                              */.in_pld_pma_ppm_lock                               ( /*unused elane ssr*/ 1'b0 ),
      /* input  [4:0]                       */.in_pld_pma_reserved_out                           ( /*unused elane ssr*/ {5{1'b0}} ),
      /* input                              */.in_pld_pma_rs_lpbk_b                              ( /*unused elane ssr*/ 1'b0 ),
      /* input                              */.in_pld_pma_rx_qpi_pullup                          ( tx_pma_en[ig]  ),
      /* input                              */.in_pld_pma_rxpma_rstb                             ( ~int_rx_pmaif_reset_csr[ig]  ),
      /* input                              */.in_pld_pma_tx_bitslip                             ( enh_force_rcfg_reset[ig]  ),
      /* input                              */.in_pld_pma_tx_qpi_pulldn                          ( rx_pma_clkslip[ig]  ),
      /* input                              */.in_pld_pma_tx_qpi_pullup                          ( /*core_cntl[2]*/ 1'b0 ),
      /* input                              */.in_pld_pma_txdetectrx                             ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_pld_pma_txpma_rstb                             ( ~int_tx_pmaif_reset_csr[ig]  ),
      /* input                              */.in_pld_pmaif_rxclkslip                            ( /*unused elane ssr*/ 1'b0 ),
      /* input                              */.in_pld_polinv_rx                                  ( /*core_cntl[14]*/ 1'b0 ),
      /* input                              */.in_pld_polinv_tx                                  ( /*core_cntl[0]*/ 1'b0 ),
      /* input                              */.in_pld_rx_clk1_dcm                                ( int_rx_coreclkin_dclk  ),
      /* input                              */.in_pld_rx_clk1_rowclk                             ( int_rx_coreclkin_rowclk  ),
      /* input                              */.in_pld_rx_clk2_rowclk                             ( 1'b0  ),
      /* input                              */.in_pld_rx_dll_lock_req                            ( ~int_rx_aib_reset_csr[ig]  ),
      /* input                              */.in_pld_rx_fabric_fifo_align_clr                   ( /*rx_fifo_align_clr[ig]*/ 1'b0 ),
      /* input                              */.in_pld_rx_fabric_fifo_rd_en                       ( rx_fifo_rd_en[ig]  ),
      /* input                              */.in_pld_rx_fifo_latency_adj_en                     ( rx_fifo_latency_adj_ena[ig] ),
      /* input                              */.in_pld_rx_prbs_err_clr                            ( /*core_cntl[15]*/ 1'b0 ),
      /* input  [1:0]                       */.in_pld_rx_ssr_reserved_in                         ( /*TODO: Added*/ {2{1'b0}} ),
      /* input                              */.in_pld_sclk1_rowclk                               ( latency_sclk[ig]  ),
      /* input                              */.in_pld_sclk2_rowclk                               ( latency_sclk[ig]  ),
      /* input                              */.in_pld_syncsm_en                                  ( rx_pmaif_bitslip[ig]  ),
      /* input                              */.in_pld_tx_clk1_dcm                                ( int_tx_coreclkin_dclk  ),
      /* input                              */.in_pld_tx_clk1_rowclk                             ( int_tx_coreclkin_rowclk  ),
      /* input                              */.in_pld_tx_clk2_dcm                                ( int_tx_coreclkin2_dclk  ),
      /* input                              */.in_pld_tx_clk2_rowclk                             ( int_tx_coreclkin2_rowclk  ),
      /* input                              */.in_pld_tx_dll_lock_req                            ( ~int_tx_aib_reset_csr[ig]  ),
      /* input  [79:0]                      */.in_pld_tx_fabric_data_in                          ( int_tx_parallel_data	[ig*80+:80]  ),
      /* input                              */.in_pld_tx_fifo_latency_adj_en                     ( /*TODO: Added*/ 1'b0 ),
      /* input  [2:0]                       */.in_pld_tx_ssr_reserved_in                         ( /*TODO: Added*/ {3{1'b0}} ),
      /* input                              */.in_pld_txelecidle                                 ( /*unused fsr[0] xcvrif*/ 1'b0 ),
      /* input  [1:0]                       */.in_r_aib_csr_ctrl_14                              ( /*TODO: Added*/ {2{1'b0}} ),
      /* input  [1:0]                       */.in_r_aib_csr_ctrl_15                              ( /*TODO: Added*/ {2{1'b0}} ),
      /* input                              */.in_r_aib_csr_ctrl_17                              ( /*TODO: Added*/ 1'b0 ),
      /* input  [5:0]                       */.in_r_aib_csr_ctrl_24                              ( /*TODO: Added*/ {6{1'b0}} ),
      /* input                              */.in_r_sr_hip_en                                    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_resetb_sync_buf                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_shift_en_ssrdout                               ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_shift_en_ssrldout                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_shift_en_vinp0                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_shift_en_vinp1                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_shift_en_voutp00                               ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_shift_en_voutp01                               ( /*TODO: Added*/ 1'b0 ),
      /* input  [19:0]                      */.in_sr_testbus                                     ( /*TODO: Added*/ {20{1'b0}} ),
      /* output  [1:0]                      */.out_aib_fabric_avmm1_data_out                     ( /*TODO: Added*/  ),
/*<TODO: Changed ([4:0])> output			*/  .out_aib_fabric_fpll_shared_direct_async_in        ( /*TODO: Added*/  ),
      /* output                             */.out_aib_fabric_tx_transfer_clk                    ( /*TODO: Added*/  ),
      /* output                             */.out_async_dat_outpdir1_1                          ( /*TODO: Added*/  ),
      /* output                             */.out_avmm1_clkchnl                                 ( /*TODO: Added*/  ),
      /* output                             */.out_avmm1_clkchnl_nd                              ( /*TODO: Added*/  ),
      /* output  [1:0]                      */.out_avmm1_idat0                                   ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_asn_ds_out_fifo_hold                  ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_asn_us_out_fifo_hold                  ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_fifo_ds_out_rden                      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_fifo_ds_out_wren                      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_fifo_us_out_rden                      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_fifo_us_out_wren                      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_hrdrst_ds_out_fabric_rx_dll_lock      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_hrdrst_ds_out_fabric_rx_dll_lock_req  ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_hrdrst_us_out_fabric_rx_dll_lock      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_rx_hrdrst_us_out_fabric_rx_dll_lock_req  ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_fifo_ds_out_dv                        ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_fifo_ds_out_rden                      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_fifo_ds_out_wren                      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_fifo_us_out_dv                        ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_fifo_us_out_rden                      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_fifo_us_out_wren                      ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_done  ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_hrdrst_ds_out_fabric_tx_dcd_cal_req   ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_done  ( /*TODO: Added*/  ),
      /* output                             */.out_bond_tx_hrdrst_us_out_fabric_tx_dcd_cal_req   ( /*TODO: Added*/  ),
      /* output  [12:0]                     */.out_dft_fabric_oaibdftdll2core                    ( /*TODO: Added*/  ),
      /* output                             */.out_hip_fsr_parity_checker_in                     ( /*TODO: Added*/  ),
      /* output  [5:0]                      */.out_hip_ssr_parity_checker_in                     ( /*TODO: Added*/  ),
      /* output                             */.out_iasyncdata_oshared2                           ( /*TODO: Added*/  ),
      /* output                             */.out_idataselb_in0_directout2                      ( /*TODO: Added*/  ),
      /* output                             */.out_idataselb_oshared2                            ( /*TODO: Added*/  ),
      /* output                             */.out_idataselb_outpdir1_1                          ( /*TODO: Added*/  ),
      /* output                             */.out_idirectout_data_outpdir2_1                    ( /*TODO: Added*/  ),
      /* output  [2:0]                      */.out_irxen_inpshared4                              ( /*TODO: Added*/  ),
      /* output  [2:0]                      */.out_irxen_ptxclkin                                ( /*TODO: Added*/  ),
      /* output                             */.out_itxen_in0_directout2                          ( /*TODO: Added*/  ),
      /* output                             */.out_itxen_oshared2                                ( /*TODO: Added*/  ),
      /* output                             */.out_itxen_outpdir1_1                              ( /*TODO: Added*/  ),
      /* output  [12:0]                     */.out_o_aibdftdll2adjch                             ( /*TODO: Added*/  ),
      /* output                             */.out_o_bitslip_done                                ( /*TODO: Added*/  ),
      /* output  [2:0]                      */.out_o_chnl_fsr                                    ( /*TODO: Added*/  ),
      /* output  [60:0]                     */.out_o_chnl_ssr                                    ( /*TODO: Added*/  ),
      /* output  [31:0]                     */.out_o_config_avmm_rdata                           ( /*TODO: Added*/  ),
      /* output                             */.out_o_config_avmm_rdatavalid                      ( /*TODO: Added*/  ),
      /* output                             */.out_o_config_avmm_waitrequest                     ( /*TODO: Added*/  ),
      /* output                             */.out_o_directout_data_chain1_out                   ( /*TODO: Added*/  ),
      /* output                             */.out_o_directout_data_chain2_out                   ( /*TODO: Added*/  ),
      /* output  [3:0]                      */.out_o_ehip_fsr                                    ( /*JRJ: Connection to RSFEC is TBD*/  ),
      /* output  [2:0]                      */.out_o_ehip_init_status                            ( ehip_aib_aib_status[ig*3+:3]  ),
      /* output  [39:0]                     */.out_o_ehip_ssr                                    ( /*TODO: Added*/  ),
      /* output  [12:0]                     */.out_o_odll_dll2core                               ( /*TODO: Added*/  ),
      /* output                             */.out_o_red_idataselb_out_chain1                    ( /*TODO: Added*/  ),
      /* output                             */.out_o_red_idataselb_out_chain2                    ( /*TODO: Added*/  ),
      /* output                             */.out_o_red_shift_en_out_chain1                     ( /*TODO: Added*/  ),
      /* output                             */.out_o_red_shift_en_out_chain2                     ( /*TODO: Added*/  ),
//***************************************************************************Resolve with Ilkay*****************************************************************************************************************************
      /* output                             */.out_o_rx_bit0_tag                                 ( o_ehip_port_rsfec_pma_rx_bit0_tag_out[ig]        /*JRJ: Added connection to RSFEC*/  ),
      /* output  [65:0]                     */.out_o_rx_fec_data                                 ( o_ehip_port_rsfec_rx_out_data[ig]                /*JRJ: Added connection to RSFEC*/  ),
      /* output                             */.out_o_rx_fec_dv                                   ( o_ehip_port_rsfec_rx_out_data_valid[ig]          /*JRJ: Added connection to RSFEC*/  ),
//***************************************************************************Resolve with Ilkay*****************************************************************************************************************************
      /* output                             */.out_o_rx_fifo_empty                               ( /*TODO: Added*/  ),
      /* output                             */.out_o_rx_fifo_pfull                               ( /*TODO: Added*/  ),
      /* output  [4:0]                      */.out_o_rx_fifo_used                                ( /*TODO: Added*/  ),
      /* output  [66:0]                     */.out_o_rx_pcs_data                                 ( o_rsfec_pma_pcs_rx_data_out[ig]                    /*JRJ: Added connection to RSFEC*/  ),
      /* output                             */.out_o_rx_pcs_dv                                   ( o_rsfec_pma_pcs_rx_data_valid_out[ig]              /*JRJ: Added connection to RSFEC*/  ),
      /* output                             */.out_o_rx_pma_clk_out                              ( /*TODO: Added*/  ),
      /* output                             */.out_o_sbus_stall_out_to_upstream                  ( /*TODO: Added*/  ),
	// /*TODO - Removed*/      /* output                             */.out_o_tx_bonding_pulse_e                          ( /*TODO: Added*/  ),
      /* output  [77:0]                     */.out_o_tx_ehip_data                                ( ehip_aib_tx_sync_data[ig*78+:78] ),
      /* output                             */.out_o_tx_n                                        ( tx_serial_data_n[ig] ),
      /* output                             */.out_o_tx_p                                        ( tx_serial_data[ig]  ),
      /* output                             */.out_o_tx_pma_clk_out                              ( ehip_pma_tx_pma_clk[ig]  ),
	// /*TODO - Removed*/      /* output                             */.out_o_tx_refclk_sync_pam4_w                       ( /*TODO: Added*/  ),
      /* output  [77:0]                     */.out_o_tx_rsfec_data                               ( o_rsfec_ct3_hssi_aibadapt_tx_data[ig]     /*JRJ: Added connection to RSFEC*/  ),
      /* output                             */.out_o_tx_transfer_clk                             ( /*TODO: Added*/  ),
      /* output                             */.out_o_tx_transfer_div2_clk                        ( ehip_aib_tx_transfer_div2_clk[ig]  ),
      /* output                             */.out_o_txen_out_chain1                             ( /*TODO: Added*/  ),
      /* output                             */.out_o_txen_out_chain2                             ( /*TODO: Added*/  ),
      /* output  [30:0]                     */.out_o_xcvrif_aib_ssr_out                          ( /*TODO: Added*/  ),
      /* output  [3:0]                      */.out_o_xcvrif_refclk_config                        ( /*TODO: Added*/  ),
      /* output  [12:0]                     */.out_oaibdftdll2core                               ( /*TODO: Added*/  ),
      /* output                             */.out_oatpg_scan_out0                               ( /*TODO: Added*/  ),
      /* output                             */.out_odat0_outpclk1_1                              ( /*TODO: Added*/  ),
      /* output                             */.out_odat0_outpdir0_1                              ( /*TODO: Added*/  ),
      /* output                             */.out_odat1_outpclk1_1                              ( /*TODO: Added*/  ),
      /* output                             */.out_odat1_outpdir0_1                              ( /*TODO: Added*/  ),
      /* output                             */.out_ored_directin_data_out0_chain1                ( /*TODO: Added*/  ),
      /* output                             */.out_ored_directin_data_out0_chain2                ( /*TODO: Added*/  ),
      /* output  [2:0]                      */.out_ored_rxen_out_chain1                          ( /*TODO: Added*/  ),
      /* output  [2:0]                      */.out_ored_rxen_out_chain2                          ( /*TODO: Added*/  ),
      /* output                             */.out_ored_shift_en_out_chain1                      ( /*TODO: Added*/  ),
      /* output                             */.out_ored_shift_en_out_chain2                      ( /*TODO: Added*/  ),
      /* output                             */.out_pld_10g_krfec_rx_blk_lock                     ( pma_initialized[ig]  ),
      /* output  [1:0]                      */.out_pld_10g_krfec_rx_diag_data_status             ( {tx_enh_reset_stat[ig], rx_enh_reset_stat[ig]}  ),
      /* output                             */.out_pld_10g_krfec_rx_frame                        ( rx_enh_aligned[ig]  ),
      /* output                             */.out_pld_10g_krfec_tx_frame                        ( /*TODO: Added*/  ),
      /* output                             */.out_pld_10g_rx_crc32_err                          ( rx_pmaif_fifo_underflow[ig]  ),
      /* output                             */.out_pld_10g_rx_frame_lock                         ( rx_enh_blk_lock[ig]  ),
      /* output                             */.out_pld_10g_rx_hi_ber                             ( rx_enh_highber[ig]  ),
      /* output                             */.out_pld_10g_tx_burst_en_exe                       ( /*TODO: Added*/  ),
      /* output  [3:0]                      */.out_pld_8g_a1a2_k1k2_flag                         ( /*unused elane ssr*/  ),
      /* output                             */.out_pld_8g_empty_rmf                              ( rx_enh_pause[ig]  ),
      /* output                             */.out_pld_8g_full_rmf                               ( tx_enh_pmaif_fifo_almost_empty[ig]  ),
      /* output                             */.out_pld_8g_rxelecidle                             ( /*TODO: Added*/  ),
      /* output                             */.out_pld_8g_signal_detect_out                      ( rx_is_lockedtodata[ig]  ),
      /* output  [4:0]                      */.out_pld_8g_wa_boundary                            ( {enh_internal_error[ig], enh_reset_stat[ig], rx_enh_pmaif_fifo_overflow[ig], tx_enh_pmaif_fifo_underflow[ig], tx_enh_pmaif_fifo_overflow[ig] }  ),
      /* output                             */.out_pld_aib_fabric_rx_dll_lock                    ( /*TODO: Added*/  ),
      /* output                             */.out_pld_aib_fabric_tx_dcd_cal_done                ( /*TODO: Added*/  ),
      /* output                             */.out_pld_aib_hssi_rx_dcd_cal_done                  ( /*TODO: Added*/  ),
      /* output                             */.out_pld_aib_hssi_tx_dcd_cal_done                  ( /*TODO: Added*/  ),
      /* output                             */.out_pld_aib_hssi_tx_dll_lock                      ( tx_dll_lock[ig]  ),
      /* output                             */.out_pld_avmm1_busy                                ( /*TODO: Added*/  ),
      /* output                             */.out_pld_avmm1_cmdfifo_wr_full                     ( /*TODO: Added*/  ),
      /* output  [1:0]                      */.out_pld_avmm2_reserved_out                        ( {rx_fifo_ready[ig], tx_fifo_ready[ig]}  ),
      /* output                             */.out_pld_chnl_cal_done                             ( int_pma_core_status[8]  ),
      /* output                             */.out_pld_fabric_asn_dll_lock_en                    ( /*TODO: Added*/  ),
      /* output                             */.out_pld_fabric_tx_transfer_en                     ( tx_transfer_ready	[ig]  ),
      /* output                             */.out_pld_fpll_shared_direct_async_out              ( /*TODO: Added*/  ),
      /* output  [3:0]                      */.out_pld_fpll_shared_direct_async_out_dcm          ( /*TODO: Added*/  ),
      /* output  [3:0]                      */.out_pld_fpll_shared_direct_async_out_hioint       ( /*TODO: Added*/  ),
      /* output                             */.out_pld_fsr_load                                  ( /*TODO: Added*/  ),
      /* output                             */.out_pld_hssi_asn_dll_lock_en                      ( /*TODO: Added*/  ),
      /* output                             */.out_pld_hssi_osc_transfer_en                      ( osc_transfer_en[ig]  ), // internal use only
      /* output                             */.out_pld_hssi_rx_transfer_en                       ( rx_transfer_ready	[ig]  ),
      /* output                             */.out_pld_krfec_tx_alignment                        ( enh_ready[ig]  ),
      /* output                             */.out_pld_pcs_rx_clk_out1_dcm                       ( rx_clkout[ig]  ),
      /* output                             */.out_pld_pcs_rx_clk_out1_hioint                    ( rx_clkout_hioint[ig] ),
      /* output                             */.out_pld_pcs_rx_clk_out2_dcm                       ( rx_clkout2[ig]  ),
      /* output                             */.out_pld_pcs_rx_clk_out2_hioint                    ( rx_clkout2_hioint[ig]  ),
      /* output                             */.out_pld_pcs_tx_clk_out1_dcm                       ( tx_clkout[ig]  ),
      /* output                             */.out_pld_pcs_tx_clk_out1_hioint                    ( tx_clkout_hioint[ig]  ),
      /* output                             */.out_pld_pcs_tx_clk_out2_dcm                       ( tx_clkout2[ig]  ),
      /* output                             */.out_pld_pcs_tx_clk_out2_hioint                    ( tx_clkout2_hioint[ig]  ),
      /* output                             */.out_pld_pma_adapt_done                            ( int_pma_core_status[14]  ),
      /* output                             */.out_pld_pma_fpll_clk0bad                          ( int_pma_core_status[10]  ),
      /* output                             */.out_pld_pma_fpll_clk1bad                          ( int_pma_core_status[11]  ),
      /* output                             */.out_pld_pma_fpll_clksel                           ( int_pma_core_status[12]  ),
      /* output                             */.out_pld_pma_fpll_phase_done                       ( int_pma_core_status[13]  ),
      /* output                             */.out_pld_pma_hclk_hioint                           ( /*TODO: Added*/  ),
      /* output                             */.out_pld_pma_internal_clk1_hioint                  ( rx_dl_async_pulse[ig]  ),
      /* output                             */.out_pld_pma_internal_clk2_hioint                  ( tx_dl_async_pulse[ig]  ),
      /* output  [1:0]                      */.out_pld_pma_pcie_sw_done                          ( {rx_pma_elecidle[ig],int_pma_core_status[15] }  ),
      /* output                             */.out_pld_pma_pfdmode_lock                          ( tx_pma_ready [ig]  ),
      /* output  [4:0]                      */.out_pld_pma_reserved_in                           ( /*unused elane ssr*/  ),
      /* output                             */.out_pld_pma_rx_detect_valid                       ( /*TODO: Added*/  ),
      /* output                             */.out_pld_pma_rx_found                              ( rx_enh_remote_fault[ig]  ),
      /* output                             */.out_pld_pma_rxpll_lock                            ( rx_pma_ready [ig]  ),
      /* output                             */.out_pld_pma_signal_ok                             ( rx_enh_local_fault[ig]  ),
      /* output  [7:0]                      */.out_pld_pma_testbus                               ( rx_enh_pfc[ig*8+:8] ),
      /* output                             */.out_pld_pmaif_mask_tx_pll                         ( tx_enh_pmaif_fifo_almost_full[ig]  ),
      /* output                             */.out_pld_rx_fabric_align_done                      ( /*TODO: Added*/  ),
      /* output  [79:0]                     */.out_pld_rx_fabric_data_out                        ( int_rx_parallel_data	[ig*80+:80]  ),
      /* output                             */.out_pld_rx_fabric_fifo_del                        ( /*rx_fifo_del[ig]*/  ),
      /* output                             */.out_pld_rx_fabric_fifo_empty                      ( rx_fifo_empty[ig]  ),
      /* output                             */.out_pld_rx_fabric_fifo_full                       ( rx_fifo_full[ig]  ),
      /* output                             */.out_pld_rx_fabric_fifo_insert                     ( /*rx_fifo_insert[ig]*/  ),
      /* output                             */.out_pld_rx_fabric_fifo_latency_pulse              ( /*TODO: Added*/  ),
      /* output                             */.out_pld_rx_fabric_fifo_pempty                     ( rx_fifo_pempty[ig]  ),
      /* output                             */.out_pld_rx_fabric_fifo_pfull                      ( rx_fifo_pfull[ig]  ),
      /* output                             */.out_pld_rx_hssi_fifo_empty                        ( rx_pcs_fifo_empty[ig]  ),
      /* output                             */.out_pld_rx_hssi_fifo_full                         ( rx_pcs_fifo_full[ig]  ),
      /* output                             */.out_pld_rx_hssi_fifo_latency_pulse                ( /*TODO: Added*/  ),
      /* output                             */.out_pld_rx_prbs_done                              ( enh_initialized[ig]  ),
      /* output                             */.out_pld_rx_prbs_err                               ( /*unused elane ssr*/  ),
      /* output  [1:0]                      */.out_pld_rx_ssr_reserved_out                       ( /*TODO: Added*/  ),
      /* output                             */.out_pld_ssr_load                                  ( /*TODO: Added*/  ),
      /* output  [19:0]                     */.out_pld_test_data                                 ( {int_pma_core_status[7:0], int_pmaif_test_out}  ),
      /* output                             */.out_pld_tx_fabric_fifo_empty                      ( tx_fifo_empty[ig]  ),
      /* output                             */.out_pld_tx_fabric_fifo_full                       ( tx_fifo_full[ig]  ),
      /* output                             */.out_pld_tx_fabric_fifo_latency_pulse              ( /*TODO: Added*/  ),
      /* output                             */.out_pld_tx_fabric_fifo_pempty                     ( tx_fifo_pempty[ig]  ),
      /* output                             */.out_pld_tx_fabric_fifo_pfull                      ( tx_fifo_pfull[ig]  ),
      /* output                             */.out_pld_tx_hssi_align_done                        ( /*TODO: Added*/  ),
      /* output                             */.out_pld_tx_hssi_fifo_empty                        ( tx_pcs_fifo_empty[ig]  ),
      /* output                             */.out_pld_tx_hssi_fifo_full                         ( tx_pcs_fifo_full[ig]  ),
      /* output                             */.out_pld_tx_hssi_fifo_latency_pulse                ( /*TODO: Added*/  ),
      /* output  [2:0]                      */.out_pld_tx_ssr_reserved_out                       ( /*TODO: Added*/  ),
      /* output  [1:0]                      */.out_rx_fsr_parity_checker_in                      ( /*TODO: Added*/  ),
      /* output  [64:0]                     */.out_rx_ssr_parity_checker_in                      ( /*TODO: Added*/  ),
      /* output                             */.out_shift_en_directout2                           ( /*TODO: Added*/  ),
      /* output                             */.out_shift_en_inpshared4                           ( /*TODO: Added*/  ),
      /* output                             */.out_shift_en_oshared2                             ( /*TODO: Added*/  ),
      /* output                             */.out_shift_en_outpdir1_1                           ( /*TODO: Added*/  ),
      /* output                             */.out_shift_en_ptxclkin                             ( /*TODO: Added*/  ),
      /* output                             */.out_shift_en_ptxclkinn                            ( /*TODO: Added*/  ),
      /* output                             */.out_tx_fsr_parity_checker_in                      ( /*TODO: Added*/  ),
      /* output  [15:0]                     */.out_tx_ssr_parity_checker_in                      ( /*TODO: Added*/  ),

      // added by anthony
/*<TODO: Changed ([channels-1     :0])> input	[avmm_interfaces-1     :0]		*/ .avmm_clk                                          ( avmm_clk         [ig]                                                            ),
/*<TODO: Changed ([channels-1     :0])> input	[avmm_interfaces-1     :0]		*/ .avmm_reset                                        ( avmm_reset       [ig]                                                            ),
/*<TODO: Changed ([channels*19-1  :0])> input	[avmm_interfaces*10-1  :0]		*/ .avmm_address                                      ( avmm_address     [ig*RCFG_ADDR_BITS+:AVMM_CHNL_ADDR_WIDTH]                       ),
/*<TODO: Changed ([channels-1     :0])> input	[avmm_interfaces-1     :0]		*/ .avmm_write                                        ( avmm_write       [ig]                                                            ),
/*<TODO: Changed ([channels-1     :0])> input	[avmm_interfaces-1     :0]		*/ .avmm_read                                         ( avmm_read        [ig]                                                            ),
/*<TODO: Changed ([channels*8-1   :0])> input	[avmm_interfaces*8-1   :0]		*/ .avmm_writedata                                    ( avmm_writedata   [ig*AVMM_WDATA_WIDTH+:AVMM_WDATA_WIDTH]                         ),
/*<TODO: Changed ([channels*8-1   :0])> output	[avmm_interfaces*8-1   :0]		*/ .avmm_readdata                                     ( avmm_readdata    [ig*AVMM_RDATA_WIDTH+:AVMM_RDATA_WIDTH]                         ),
/*<TODO: Changed ([channels-1     :0])> output	[avmm_interfaces-1     :0]		*/ .avmm_waitrequest                                  ( avmm_waitrequest [ig]                                                            ),
      /* input  [8:0]                       */.in_pld_avmm1_reserved_in                          ( {1'b0,avmm_address     [((ig*RCFG_ADDR_BITS)+AVMM_ELANE_START_BIT)+:AVMM_ELANE_WIDTH]}  ),

      /* input                              */.in_i_e_hard_reset_n                               ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_e_user_mode                                  ( /*TODO: Added*/ 1'b0 ),
      /* input  [77:0]                      */.in_i_s_elane_rx_data                              ( i_rsfec_coreip_rx_elane_data_in[ig]             /*JRJ: Added connection to RSFEC*/  ),
      /* input                              */.in_i_s_fec_clk                                    ( i_adapt_ehip_rsfec_clock[ig]             /*JRJ: Added connection to RSFEC*/  ),
      /* output                             */.out_io_aib75                                      ( /*TODO: Added*/  ),
      /* output  [77:0]                     */.out_o_s_elane_tx_data                             ( o_rsfec_elane_tx_data_out[ig]            /*JRJ: Added connection to RSFEC*/  ),
      /* output                             */.out_aib_fabric_pld_pma_pfdmode_lock               ( /*TODO: Added*/  ),
      /* input                              */.in_c3xcvr_refclk_i_refclk1                        ( pll_refclk1_div  ),
      /* input  [2:0]                       */.in_i_idll_core2dll                                ( /*TODO: Added*/ {3{1'b0}} ),
      /* input                              */.in_i_pipeline_global_en                           ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_rx_ch0_clk                                   ( l_in_rx_ch0_clk[ig] ),
      /* input                              */.in_i_rx_ch0_dskw_pulse                            ( l_in_rx_ch0_dskw_pulse[ig] ),
      /* input  [31:0]                      */.in_i_rx_ch0_in                                    ( l_in_rx_ch0_in[ig] ),
      /* input  [31:0]                      */.in_i_rx_multi_ln_inter                            ( l_in_rx_multi_ln_inter[ig] ),
      /* input                              */.in_i_sbus_stall_in_from_downstream                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__acextest_en                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__async_reset_n                          ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__async_reset_n_override                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__atri_l                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__clk_control_reset                      ( /*TODO: Added*/ 1'b0 ),
      /* input  [5:0]                       */.in_i_test__clk_cycles                             ( /*TODO: Added*/ {6{1'b0}} ),
      /* input                              */.in_i_test__clk_gate_disable                       ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__clk_sel_override                       ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__clock_dr                               ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__dft_clk                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__disable_clk_halt                       ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__dtstmode                               ( /*TODO: Added*/ 1'b0 ),
      /* input  [8:0]                       */.in_i_test__execute                                ( /*TODO: Added*/ {9{1'b0}} ),
      /* input                              */.in_i_test__ext_clk_sel                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__freerun                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__func_ext_clk_sel                       ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__haltlow                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__jsin                                   ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__lbist_active                           ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__mem_atpg_active                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__mem_clk_gate_disable                   ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__n_step                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__reg_mem_bypass                         ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__rx_acextest_capture                    ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__rx_par_scan                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__scan_en                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__scan_low_power                         ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__sctest                                 ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__sel_toggle_data                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__sel_toggle_mode                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__sel_toggle_update_dr                   ( /*TODO: Added*/ 1'b0 ),
      /* input  [9:0]                       */.in_i_test__shift_clk                              ( /*TODO: Added*/ {10{1'b0}} ),
      /* input  [9:0]                       */.in_i_test__shift_clk_sel                          ( /*TODO: Added*/ {10{1'b0}} ),
      /* input                              */.in_i_test__shift_dr                               ( /*TODO: Added*/ 1'b0 ),
      /* input  [19:0]                      */.in_i_test__sin                                    ( /*TODO: Added*/ {20{1'b0}} ),
      /* input  [1:0]                       */.in_i_test__sout_par                               ( /*TODO: Added*/ {2{1'b0}} ),
      /* input                              */.in_i_test__tdr_capture                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tdr_rst                                ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tdr_sel_mem                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tdr_sel_serdes                         ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tdr_shift                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tdr_sin_mem                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tdr_sin_serdes                         ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tdr_update                             ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tx_acextest_rti                        ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__tx_par_scan                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test__update_dr                              ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test_clk_div66_rx                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test_clk_div66_tx                            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test_clk_full_rx                             ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test_clk_full_tx                             ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test_clk_half_rx                             ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_i_test_clk_half_tx                             ( /*TODO: Added*/ 1'b0 ),
      /* input  [6:0]                       */.in_i_tst_tcm_ctrl_div66_rx                        ( /*TODO: Added*/ {7{1'b0}} ),
      /* input  [6:0]                       */.in_i_tst_tcm_ctrl_div66_tx                        ( /*TODO: Added*/ {7{1'b0}} ),
      /* input  [6:0]                       */.in_i_tst_tcm_ctrl_full_rx                         ( /*TODO: Added*/ {7{1'b0}} ),
      /* input  [6:0]                       */.in_i_tst_tcm_ctrl_full_tx                         ( /*TODO: Added*/ {7{1'b0}} ),
      /* input  [6:0]                       */.in_i_tst_tcm_ctrl_half_rx                         ( /*TODO: Added*/ {7{1'b0}} ),
      /* input  [6:0]                       */.in_i_tst_tcm_ctrl_half_tx                         ( /*TODO: Added*/ {7{1'b0}} ),
      /* input                              */.in_i_tx_bonding_pulse_above                       ( l_in_tx_bonding_pulse_above[ig] ),
      /* input                              */.in_i_tx_bonding_pulse_below                       ( l_in_tx_bonding_pulse_below[ig] ),
      /* input                              */.in_i_tx_ch0_clk                                   ( l_in_tx_ch0_clk[ig] ),
      /* output  [7:0]                      */.out_avmmreaddata                                  ( /*TODO: Added*/  ),
      /* input  [31:0]                      */.in_i_tx_ml_inter                                  ( l_in_tx_ml_inter[ig] ),
      /* input  [31:0]                      */.in_i_tx_multi_ln_data                             ( l_in_tx_multi_ln_data[ig] ),
      /* output                             */.out_blockselect                                   ( /*TODO: Added*/  ),
      /* output                             */.out_o_rx_deskew_pulse                             ( l_out_rx_deskew_pulse[ig] ),
      /* output  [39:0]                     */.out_o_rx_direct_data                              ( /*TODO: Added*/  ),
      /* output                             */.out_o_rx_fifo_clk                                 ( l_out_rx_fifo_clk[ig] ),
      /* output                             */.out_o_rx_half_clk_out                             ( /*TODO: Added*/  ),
      /* output  [31:0]                     */.out_o_rx_multi_ln_inter                           ( l_out_rx_multi_ln_inter[ig] ),
      /* output  [79:0]                     */.out_o_rx_out                                      ( l_out_rx_out[ig] ),
      /* output                             */.out_o_rx_pcs_fifo_clk_out                         ( /*TODO: Added*/  ),
      /* output                             */.out_o_rx_rdy                                      ( /*TODO: Added*/  ),
      /* output                             */.out_o_rx_sampling_pulse                           ( /*TODO: Added*/  ),
      /* output                             */.out_o_rx_sclk_return                              ( /*TODO: Added*/  ),
      /* output  [7:0]                      */.out_o_sbus_address_out                            ( /*TODO: Added*/  ),
      /* output                             */.out_o_sbus_bist_stat_out                          ( /*TODO: Added*/  ),
      /* output                             */.out_o_sbus_clk_out                                ( /*TODO: Added*/  ),
      /* output  [7:0]                      */.out_o_sbus_data_out                               ( /*TODO: Added*/  ),
      /* output                             */.out_o_sbus_interrupt_out                          ( /*TODO: Added*/  ),
      /* output                             */.out_o_sbus_mode_out                               ( /*TODO: Added*/  ),
      /* output                             */.out_o_sbus_reset_out                              ( /*TODO: Added*/  ),
      /* output                             */.out_o_scan_out                                    ( /*TODO: Added*/  ),
      /* output  [8:0]                      */.out_o_test__halted                                ( /*TODO: Added*/  ),
      /* output                             */.out_o_test__jsout                                 ( /*TODO: Added*/  ),
      /* output  [1:0]                      */.out_o_test__sin_par                               ( /*TODO: Added*/  ),
      /* output  [19:0]                     */.out_o_test__sout                                  ( /*TODO: Added*/  ),
      /* output                             */.out_o_test__tdr_sout_mem                          ( /*TODO: Added*/  ),
      /* output                             */.out_o_test__tdr_sout_serdes                       ( /*TODO: Added*/  ),
      /* output                             */.out_o_tx_bonding_pulse_cpy                        ( l_out_tx_bonding_pulse_cpy[ig] ),
      /* output                             */.out_o_tx_bonding_pulse_out                        ( l_out_tx_bonding_pulse_out[ig] ),
      /* output                             */.out_o_tx_ch0_clk                                  ( l_out_tx_ch0_clk[ig] ),
      /* output  [31:0]                     */.out_o_tx_ml_inter                                 ( l_out_tx_ml_inter[ig] ),
      /* output  [31:0]                     */.out_o_tx_multi_ln_data                            ( l_out_tx_multi_ln_data[ig] ),
      /* output                             */.out_o_tx_pcs_fifo_clk_out                         ( /*TODO: Added*/  ),
      /* output                             */.out_o_tx_rdy                                      ( /*TODO: Added*/  ),
      /* output                             */.out_o_tx_refclk_sync_out                          ( l_out_tx_refclk_sync_out[ig]  ),
      /* output                             */.out_o_tx_sampling_pulse                           ( /*TODO: Added*/  ),
      /* output                             */.out_o_tx_sclk_return                              ( /*TODO: Added*/  ),
      /* output  [1:0]                      */.out_o_xcvrif_aib_fsr_out                          ( w_out_o_xcvrif_aib_fsr_out[2*ig+:2]  /* Added connection to native PHY top level for Fogbugz case 517233*/  ),
      /* output                             */.out_o_tie0                                        ( /*TODO: Added*/  ),
      /* output                             */.out_o_tie1                                        ( /*TODO: Added*/  ),
      /* input  [1:0]                       */.in_i_ehip_fsr                                     ( /*TODO: Added*/ {2{1'b0}} ),
      /* input  [1:0]                       */.in_i_ehip_ssr                                     ( /*TODO: Added*/ {2{1'b0}} ),
      /* input                              */.in_pld_pma_fpll_lc_csr_test_dis                   ( enh_pld_ready[ig]  ),
      /* input                              */.in_pld_pma_fpll_up_dn_lc_lf_rstn                  ( enh_reset[ig]  ),
      /* input                              */.in_pld_pma_nrpi_freeze                            ( rx_enh_signal_ok[ig]  ),
      /* input  [1:0]                       */.in_pld_fpll_shared_direct_async_in                ( /*TODO: Added*/ {2{1'b0}} ),
      /* input                              */.in_pld_fpll_shared_direct_async_in_dcm            ( /*TODO: Added*/ 1'b0 ),
      /* input                              */.in_pld_fpll_shared_direct_async_in_rowclk         ( /*TODO: Added*/ 1'b0 ),
      /* input  [3:0]                       */.in_pld_pma_fpll_cnt_sel                           ( tx_enh_pfc[(ig*8+0)+:4]  ),
      /* input                              */.in_pld_pma_fpll_extswitch                         ( tx_enh_pfc[(ig*8+4)+:1]  ),
      /* input  [2:0]                       */.in_pld_pma_fpll_num_phase_shifts                  ( tx_enh_pfc[(ig*8+5)+:3]  ),
      /* input                              */.in_pld_pma_fpll_pfden                             ( tx_enh_pause[ig]  ),
      /* output  [59:0]                     */.out_o_n_chnl_ssr                                  ( /*TODO: Added*/  ),
      /* output                             */.out_o_s_rx_elane_rst_n                            ( /*TODO: Added*/  ),
      /* output                             */.out_o_s_tx_elane_rst_n                            ( /*TODO: Added*/  ),
      /* input                              */.in_o_ehip_clk                                     ( elane_ehip_shared_clk[ig]  ),
      /* input  [2:0]                       */.in_o_ptp_deskewed_byte_offset                     ( elane_ehip_ptp_deskewed_byte_offset[ig*3+:3]  ),
      /* input  [2:0]                       */.in_o_ptp_deskewed_ins_type                        ( elane_ehip_ptp_deskewed_ins_type[ig*3+:3]  ),
      /* input  [23:0]                      */.in_o_ptp_deskewed_ts                              ( elane_ehip_ptp_deskewed_ts[ig*24+:24]  ),
      /* input  [1:0]                       */.in_o_ptp_deskewed_tx_fp                           ( elane_ehip_ptp_deskewed_tx_fp[ig*2+:2]  ),
      /* input                              */.in_o_ptp_lane_deskew_deskew_marker                ( elane_ehip_ptp_lane_deskew_deskew_marker[ig]  ),
      /* input                              */.in_o_ptp_lane_deskew_got_marker                   ( elane_ehip_ptp_lane_deskew_got_marker[ig]  ),
      /* input  [5:0]                       */.in_o_ptp_lane_deskew_tap_sel_one_hot              ( elane_ehip_ptp_lane_deskew_tap_sel_one_hot[ig*6+:6]  ),
      /* input  [2:0]                       */.in_o_ptp_mac_byte_offset                          ( elane_ehip_ptp_mac_byte_offset[ig*3+:3]  ),
      /* input  [2:0]                       */.in_o_ptp_mac_ins_type                             ( elane_ehip_ptp_mac_ins_type[ig*3+:3]  ),
      /* input  [23:0]                      */.in_o_ptp_mac_ts                                   ( elane_ehip_ptp_mac_ts[ig*24+:24]  ),
      /* input  [1:0]                       */.in_o_ptp_mac_tx_fp                                ( elane_ehip_ptp_mac_tx_fp[ig*2+:2]  ),
      /* output                             */.out_i_elane_am_detect                             ( ehip_elane_am_detect[ig]  ),
      /* output                             */.out_i_elane_am_insert                             ( ehip_elane_am_insert[ig]  ),
      /* output  [22:0]                     */.out_i_lane_ptp_rx_ptp_ts                          ( ehip_elane_rx_ptp_ts[ig*23+:23]  ),
      /* output  [11:0]                     */.out_i_lane_ptp_tx_ts                              ( ehip_elane_ptp_tx_ts[ig*12+:12]  ),
      /* output  [1:0]                      */.out_i_lane_ptp_tx_ts_fp                           ( ehip_elane_ptp_tx_ts_fp[ig*2+:2]  ),
      /* output                             */.out_i_lane_ptp_tx_ts_valid                        ( ehip_elane_ptp_tx_ts_valid[ig]  ),
      /* output                             */.out_i_ptp_fifo_share_rd_en                        ( ehip_elane_ptp_fifo_share_rd_en[ig]  ),
      /* output                             */.out_i_ptp_fifo_share_wr_en                        ( ehip_elane_ptp_fifo_share_wr_en[ig]  ),
      /* output                             */.out_i_shared_clear                                ( ehip_elane_shared_clear[ig]  ),
      /* output                             */.out_i_shared_dsk_done                             ( ehip_elane_shared_dsk_done[ig]  )
  );

// rsfecrx_mux generation

//    assign i_rsfec_coreip_rx_data_in[ig][65:0] = o_coreip_rsfec_out_rx_data[ig];
//    assign i_rsfec_coreip_rx_data_in[ig][67] = o_coreip_rsfec_out_rx_data_valid[ig];
//    assign i_rsfec_coreip_rx_data_in[ig][68] = o_coreip_rsfec_out_rx_data_sync[ig];

// Fix per Luan Bui and Chang Sheng Liew to fix Fogbugz case 542193
    assign i_rsfec_coreip_rx_data_in[ig] = {o_rsfecrx_mux_rsfec_out_rx_dsk_marker,8'b0,o_coreip_rsfec_out_rx_data_sync[ig],o_coreip_rsfec_out_rx_data_valid[ig],1'b0,o_coreip_rsfec_out_rx_data[ig]};

//    assign i_rsfec_coreip_rx_elane_data_in[ig][66:0] = o_coreip_rsfec_out_rx_elane_data[ig];
//    assign i_rsfec_coreip_rx_elane_data_in[ig][67] = o_coreip_rsfec_out_rx_elane_data_valid[ig];
//    assign i_rsfec_coreip_rx_elane_data_in[ig][68] = o_coreip_rsfec_out_rx_elane_data_sync[ig];

    assign i_rsfec_coreip_rx_elane_data_in[ig] = {9'b0,o_coreip_rsfec_out_rx_elane_data_sync[ig],o_coreip_rsfec_out_rx_elane_data_valid[ig],o_coreip_rsfec_out_rx_elane_data[ig]};

    assign i_port_ehip_out_tx_data_rsfecrx_mux_in[ig] =
        pmaRsfec_ehip_tx_ehip_data [ (ig + 1) * EHIP_TX_DATA_INPUT_WIDTH_PER_LANE - 1 -: EHIP_TX_DATA_INPUT_WIDTH_PER_LANE];
    assign i_port_ehip_out_rsfecrx_mux_in_tx_data_valid[ig] = pmaRsfec_ehip_tx_ehip_dv[ig];
//    assign i_port_ehip_out_rsfecrx_mux_in_tx_data_sync[ig] = pmaRsfec_ehip_tx_ehip_data[ig*66+3];
    assign i_port_ehip_out_rsfecrx_mux_in_tx_data_sync[ig] = pmaRsfec_ehip_tx_ehip_data_am_valid_in[ig];

    logic [77:0]internal_o_rsfec_elane_tx_data_out;

    assign internal_o_rsfec_elane_tx_data_out = o_rsfec_elane_tx_data_out[ig];

//    assign i_coreip_out_rxfecrx_mux_in_tx_elane_data[ig] = o_rsfec_elane_tx_data_out[ig][66:0];
      assign i_coreip_out_rxfecrx_mux_in_tx_elane_data_valid[ig] = internal_o_rsfec_elane_tx_data_out[67];
      assign i_coreip_out_rxfecrx_mux_in_tx_elane_data_sync[ig] = internal_o_rsfec_elane_tx_data_out[68];

//    assign i_coreip_out_rxfecrx_mux_in_tx_elane_data[ig] = {9'b0,o_rsfec_elane_tx_data_out[ig][68],o_rsfec_elane_tx_data_out[ig][67],o_rsfec_elane_tx_data_out[ig]};
    assign i_coreip_out_rxfecrx_mux_in_tx_elane_data[ig] = internal_o_rsfec_elane_tx_data_out[66:0];

    assign i_coreip_pma_out_rsfecrx_mux_in_rx_data[ig] = o_ehip_port_rsfec_rx_out_data[ig];
    assign i_coreip_pma_out_rsfecrx_mux_in_rx_data_valid[ig] = o_ehip_port_rsfec_rx_out_data_valid[ig];
    assign i_coreip_pma_out_rsfecrx_mux_in_rx_data_bit0_tag[ig] = o_ehip_port_rsfec_pma_rx_bit0_tag_out[ig];

  ct3_hssi_rsfecrx_mux  #
   (.rx_data_source(hssi_rsfecrx_mux_rx_data_source),
    .silicon_rev(hssi_rsfecrx_mux_silicon_rev)
   ) ct3_hssi_rsfecrx_mux_inst (
    /* input logic [10:0]    */ .avmmaddress(),
    /* input logic           */ .avmmclk(),
    /* input logic           */ .avmmread(),
    /* input logic           */ .avmmwrite(),
    /* input logic [7:0]     */ .avmmwritedata(),
    /* input logic [1:0]     */ .i_cfg_core_rx_out_sel(i_rsfec_rsfecrx_mux_rx_out_sel[ig]),
    /* input logic [65:0]    */ .i_ehip_tx_data(i_port_ehip_out_tx_data_rsfecrx_mux_in[ig]),
    /* input logic           */ .i_ehip_tx_sync(i_port_ehip_out_rsfecrx_mux_in_tx_data_sync[ig]),
    /* input logic           */ .i_ehip_tx_valid(i_port_ehip_out_rsfecrx_mux_in_tx_data_valid[ig]),
    /* input logic [66:0]    */ .i_elane_tx_data(i_coreip_out_rxfecrx_mux_in_tx_elane_data[ig]),
    /* input logic           */ .i_elane_tx_sync(i_coreip_out_rxfecrx_mux_in_tx_elane_data_sync[ig]),
    /* input logic           */ .i_elane_tx_valid(i_coreip_out_rxfecrx_mux_in_tx_elane_data_valid[ig]),
    /* input logic [65:0]    */ .i_fec_rx_data(i_coreip_pma_out_rsfecrx_mux_in_rx_data[ig]),
    /* input logic           */ .i_fec_rx_valid(i_coreip_pma_out_rsfecrx_mux_in_rx_data_valid[ig]),
    /* input logic [65:0]    */ .i_mux_core_rx_data(i_rsfec_rsfecrx_mux_rx_data[ig]),
    /* input logic           */ .i_mux_core_rx_sync(i_rsfec_rxfecrx_mux_rx_am_sync[ig]),
    /* input logic           */ .i_mux_core_rx_valid(i_rsfec_rxfecrx_mux_rx_data_valid[ig]),
    /* input logic [66:0]    */ .i_pcs_rx_data(o_rsfec_pma_pcs_rx_data_out[ig]),
    /* input logic           */ .i_pcs_rx_valid(o_rsfec_pma_pcs_rx_data_valid_out[ig]),
    /* input logic           */ .i_pma_rx_bit0_tag(i_coreip_pma_out_rsfecrx_mux_in_rx_data_bit0_tag[ig]),
    /* output logic [7:0]    */ .avmmreaddata(),
    /* output logic          */ .blockselect(),
    /* output logic [65:0]   */ .o_fec_rx_mux_data(o_coreip_rsfec_out_rx_data[ig]),
    /* output logic          */ .o_fec_rx_mux_sync(o_coreip_rsfec_out_rx_data_sync[ig]),
    /* output logic          */ .o_fec_rx_mux_valid(o_coreip_rsfec_out_rx_data_valid[ig]),
    /* output logic [66:0]   */ .o_pcs_rx_mux_data(o_coreip_rsfec_out_rx_elane_data[ig]),
    /* output logic          */ .o_pcs_rx_mux_sync(o_coreip_rsfec_out_rx_elane_data_sync[ig]),
    /* output logic          */ .o_pcs_rx_mux_valid(o_coreip_rsfec_out_rx_elane_data_valid[ig])
  );

end
endgenerate

//assign i_port_avmm2_avmmclk = rsfec_avmm2_avmmclk_in;
//assign i_port_avmm2_avmmread = rsfec_avmm2_avmmread_in;
//assign i_port_avmm2_avmmrequest = rsfec_avmm2_avmmrequest_in;
//assign i_port_avmm2_write = rsfec_avmm2_avmmwrite_in;
//generate
//    ct1_hssi_avmm2_if
//    #(
//        .avmm2_calibration_feature_en("avmm2_pcs_calibration_en")
//    )
//    ct3_hssi_rsfec_avmm2_inst
//    (
//        .avmmclk( i_port_avmm2_avmmclk ),
//        .avmmread( i_port_avmm2_avmmread ),
//        .avmmrequest( i_port_avmm2_avmmrequest ),
//        .avmmwrite( i_port_avmm2_write ),
//        .clkchnl( o_rsfec_rsfecrx_mux_avmm2_clk )
//    );
//endgenerate

localparam  MAX_CONVERSION_SIZE = 32;
function [MAX_CONVERSION_SIZE-1:0]int_2_bin;
  input [MAX_CONVERSION_SIZE-1:0] integerNum;
  reg [MAX_CONVERSION_SIZE-1:0]temp;
  integer i,j;
  int_2_bin = {MAX_CONVERSION_SIZE{1'b0}};
    begin
      i = MAX_CONVERSION_SIZE - 1;
      while ( i >= 0 ) begin
        //int_2_bin[i] = integerNum & 1;
        temp[i] = integerNum & 1;
        i--;
        integerNum = integerNum >> 1;
      end
      for ( j = 0; j < MAX_CONVERSION_SIZE ; j=j+1 ) begin
        int_2_bin[MAX_CONVERSION_SIZE-j-1] = temp[j];
      end
    end
endfunction

endmodule // altera_xcvr_native_s10_etile
