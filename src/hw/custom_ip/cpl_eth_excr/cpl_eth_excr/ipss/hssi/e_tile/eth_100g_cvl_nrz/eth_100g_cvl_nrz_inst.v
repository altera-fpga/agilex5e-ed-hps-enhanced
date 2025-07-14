	eth_100g_cvl_nrz #(
		.am_encoding40g_0              (INTEGER_VALUE_FOR_am_encoding40g_0),
		.am_encoding40g_1              (INTEGER_VALUE_FOR_am_encoding40g_1),
		.am_encoding40g_2              (INTEGER_VALUE_FOR_am_encoding40g_2),
		.am_encoding40g_3              (INTEGER_VALUE_FOR_am_encoding40g_3),
		.enforce_max_frame_size        (STRING_VALUE_FOR_enforce_max_frame_size),
		.flow_control                  (STRING_VALUE_FOR_flow_control),
		.flow_control_holdoff_mode     (STRING_VALUE_FOR_flow_control_holdoff_mode),
		.forward_rx_pause_requests     (STRING_VALUE_FOR_forward_rx_pause_requests),
		.hi_ber_monitor                (STRING_VALUE_FOR_hi_ber_monitor),
		.holdoff_quanta                (INTEGER_VALUE_FOR_holdoff_quanta),
		.ipg_removed_per_am_period     (INTEGER_VALUE_FOR_ipg_removed_per_am_period),
		.link_fault_mode               (STRING_VALUE_FOR_link_fault_mode),
		.pause_quanta                  (INTEGER_VALUE_FOR_pause_quanta),
		.pfc_holdoff_quanta_0          (INTEGER_VALUE_FOR_pfc_holdoff_quanta_0),
		.pfc_holdoff_quanta_1          (INTEGER_VALUE_FOR_pfc_holdoff_quanta_1),
		.pfc_holdoff_quanta_2          (INTEGER_VALUE_FOR_pfc_holdoff_quanta_2),
		.pfc_holdoff_quanta_3          (INTEGER_VALUE_FOR_pfc_holdoff_quanta_3),
		.pfc_holdoff_quanta_4          (INTEGER_VALUE_FOR_pfc_holdoff_quanta_4),
		.pfc_holdoff_quanta_5          (INTEGER_VALUE_FOR_pfc_holdoff_quanta_5),
		.pfc_holdoff_quanta_6          (INTEGER_VALUE_FOR_pfc_holdoff_quanta_6),
		.pfc_holdoff_quanta_7          (INTEGER_VALUE_FOR_pfc_holdoff_quanta_7),
		.pfc_pause_quanta_0            (INTEGER_VALUE_FOR_pfc_pause_quanta_0),
		.pfc_pause_quanta_1            (INTEGER_VALUE_FOR_pfc_pause_quanta_1),
		.pfc_pause_quanta_2            (INTEGER_VALUE_FOR_pfc_pause_quanta_2),
		.pfc_pause_quanta_3            (INTEGER_VALUE_FOR_pfc_pause_quanta_3),
		.pfc_pause_quanta_4            (INTEGER_VALUE_FOR_pfc_pause_quanta_4),
		.pfc_pause_quanta_5            (INTEGER_VALUE_FOR_pfc_pause_quanta_5),
		.pfc_pause_quanta_6            (INTEGER_VALUE_FOR_pfc_pause_quanta_6),
		.pfc_pause_quanta_7            (INTEGER_VALUE_FOR_pfc_pause_quanta_7),
		.remove_pads                   (STRING_VALUE_FOR_remove_pads),
		.rx_length_checking            (STRING_VALUE_FOR_rx_length_checking),
		.rx_max_frame_size             (INTEGER_VALUE_FOR_rx_max_frame_size),
		.rx_pause_daddr                (STRING_VALUE_FOR_rx_pause_daddr),
		.rx_pcs_max_skew               (INTEGER_VALUE_FOR_rx_pcs_max_skew),
		.rx_vlan_detection             (STRING_VALUE_FOR_rx_vlan_detection),
		.rxcrc_covers_preamble         (STRING_VALUE_FOR_rxcrc_covers_preamble),
		.sim_mode                      (STRING_VALUE_FOR_sim_mode),
		.source_address_insertion      (STRING_VALUE_FOR_source_address_insertion),
		.strict_preamble_checking      (STRING_VALUE_FOR_strict_preamble_checking),
		.strict_sfd_checking           (STRING_VALUE_FOR_strict_sfd_checking),
		.tx_ipg_size                   (STRING_VALUE_FOR_tx_ipg_size),
		.tx_max_frame_size             (INTEGER_VALUE_FOR_tx_max_frame_size),
		.tx_pause_daddr                (STRING_VALUE_FOR_tx_pause_daddr),
		.tx_pause_saddr                (STRING_VALUE_FOR_tx_pause_saddr),
		.tx_pld_fifo_almost_full_level (INTEGER_VALUE_FOR_tx_pld_fifo_almost_full_level),
		.tx_vlan_detection             (STRING_VALUE_FOR_tx_vlan_detection),
		.txcrc_covers_preamble         (STRING_VALUE_FOR_txcrc_covers_preamble),
		.txmac_saddr                   (STRING_VALUE_FOR_txmac_saddr),
		.uniform_holdoff_quanta        (INTEGER_VALUE_FOR_uniform_holdoff_quanta),
		.flow_control_sl_0             (STRING_VALUE_FOR_flow_control_sl_0)
	) u0 (
		.i_stats_snapshot              (_connected_to_i_stats_snapshot_),              //   input,    width = 1,            i_stats_snapshot.i_stats_snapshot
		.o_cdr_lock                    (_connected_to_o_cdr_lock_),                    //  output,    width = 1,                  o_cdr_lock.o_cdr_lock
		.o_tx_pll_locked               (_connected_to_o_tx_pll_locked_),               //  output,    width = 1,             o_tx_pll_locked.o_tx_pll_locked
		.i_eth_reconfig_addr           (_connected_to_i_eth_reconfig_addr_),           //   input,   width = 21,                eth_reconfig.address
		.i_eth_reconfig_read           (_connected_to_i_eth_reconfig_read_),           //   input,    width = 1,                            .read
		.i_eth_reconfig_write          (_connected_to_i_eth_reconfig_write_),          //   input,    width = 1,                            .write
		.o_eth_reconfig_readdata       (_connected_to_o_eth_reconfig_readdata_),       //  output,   width = 32,                            .readdata
		.o_eth_reconfig_readdata_valid (_connected_to_o_eth_reconfig_readdata_valid_), //  output,    width = 1,                            .readdatavalid
		.i_eth_reconfig_writedata      (_connected_to_i_eth_reconfig_writedata_),      //   input,   width = 32,                            .writedata
		.o_eth_reconfig_waitrequest    (_connected_to_o_eth_reconfig_waitrequest_),    //  output,    width = 1,                            .waitrequest
		.i_rsfec_reconfig_addr         (_connected_to_i_rsfec_reconfig_addr_),         //   input,   width = 11,              rsfec_reconfig.address
		.i_rsfec_reconfig_read         (_connected_to_i_rsfec_reconfig_read_),         //   input,    width = 1,                            .read
		.i_rsfec_reconfig_write        (_connected_to_i_rsfec_reconfig_write_),        //   input,    width = 1,                            .write
		.o_rsfec_reconfig_readdata     (_connected_to_o_rsfec_reconfig_readdata_),     //  output,    width = 8,                            .readdata
		.i_rsfec_reconfig_writedata    (_connected_to_i_rsfec_reconfig_writedata_),    //   input,    width = 8,                            .writedata
		.o_rsfec_reconfig_waitrequest  (_connected_to_o_rsfec_reconfig_waitrequest_),  //  output,    width = 1,                            .waitrequest
		.o_tx_lanes_stable             (_connected_to_o_tx_lanes_stable_),             //  output,    width = 1,           o_tx_lanes_stable.o_tx_lanes_stable
		.o_rx_pcs_ready                (_connected_to_o_rx_pcs_ready_),                //  output,    width = 1,              o_rx_pcs_ready.o_rx_pcs_ready
		.o_ehip_ready                  (_connected_to_o_ehip_ready_),                  //  output,    width = 1,                o_ehip_ready.o_ehip_ready
		.o_rx_block_lock               (_connected_to_o_rx_block_lock_),               //  output,    width = 1,             o_rx_block_lock.o_rx_block_lock
		.o_rx_am_lock                  (_connected_to_o_rx_am_lock_),                  //  output,    width = 1,                o_rx_am_lock.o_rx_am_lock
		.o_rx_hi_ber                   (_connected_to_o_rx_hi_ber_),                   //  output,    width = 1,                 o_rx_hi_ber.o_rx_hi_ber
		.o_local_fault_status          (_connected_to_o_local_fault_status_),          //  output,    width = 1,        o_local_fault_status.o_local_fault_status
		.o_remote_fault_status         (_connected_to_o_remote_fault_status_),         //  output,    width = 1,       o_remote_fault_status.o_remote_fault_status
		.i_clk_tx                      (_connected_to_i_clk_tx_),                      //   input,    width = 1,                    i_clk_tx.clk
		.i_clk_rx                      (_connected_to_i_clk_rx_),                      //   input,    width = 1,                    i_clk_rx.clk
		.i_csr_rst_n                   (_connected_to_i_csr_rst_n_),                   //   input,    width = 1,                 i_csr_rst_n.reset_n
		.i_tx_rst_n                    (_connected_to_i_tx_rst_n_),                    //   input,    width = 1,                  i_tx_rst_n.reset_n
		.i_rx_rst_n                    (_connected_to_i_rx_rst_n_),                    //   input,    width = 1,                  i_rx_rst_n.reset_n
		.o_tx_serial                   (_connected_to_o_tx_serial_),                   //  output,    width = 4,                    serial_p.o_tx_serial
		.i_rx_serial                   (_connected_to_i_rx_serial_),                   //   input,    width = 4,                            .i_rx_serial
		.o_tx_serial_n                 (_connected_to_o_tx_serial_n_),                 //  output,    width = 4,                    serial_n.o_tx_serial_n
		.i_rx_serial_n                 (_connected_to_i_rx_serial_n_),                 //   input,    width = 4,                            .i_rx_serial_n
		.i_reconfig_clk                (_connected_to_i_reconfig_clk_),                //   input,    width = 1,              i_reconfig_clk.clk
		.i_reconfig_reset              (_connected_to_i_reconfig_reset_),              //   input,    width = 1,            i_reconfig_reset.reset
		.o_tx_ready                    (_connected_to_o_tx_ready_),                    //  output,    width = 1,                tx_streaming.ready
		.i_tx_valid                    (_connected_to_i_tx_valid_),                    //   input,    width = 1,                            .valid
		.i_tx_data                     (_connected_to_i_tx_data_),                     //   input,  width = 512,                            .data
		.i_tx_error                    (_connected_to_i_tx_error_),                    //   input,    width = 1,                            .error
		.i_tx_startofpacket            (_connected_to_i_tx_startofpacket_),            //   input,    width = 1,                            .startofpacket
		.i_tx_endofpacket              (_connected_to_i_tx_endofpacket_),              //   input,    width = 1,                            .endofpacket
		.i_tx_empty                    (_connected_to_i_tx_empty_),                    //   input,    width = 6,                            .empty
		.o_rx_valid                    (_connected_to_o_rx_valid_),                    //  output,    width = 1,                rx_streaming.valid
		.o_rx_data                     (_connected_to_o_rx_data_),                     //  output,  width = 512,                            .data
		.o_rx_startofpacket            (_connected_to_o_rx_startofpacket_),            //  output,    width = 1,                            .startofpacket
		.o_rx_endofpacket              (_connected_to_o_rx_endofpacket_),              //  output,    width = 1,                            .endofpacket
		.o_rx_empty                    (_connected_to_o_rx_empty_),                    //  output,    width = 6,                            .empty
		.o_rx_error                    (_connected_to_o_rx_error_),                    //  output,    width = 6,                            .error
		.i_xcvr_reconfig_address       (_connected_to_i_xcvr_reconfig_address_),       //   input,   width = 76,     i_xcvr_reconfig_address.i_xcvr_reconfig_address
		.i_xcvr_reconfig_read          (_connected_to_i_xcvr_reconfig_read_),          //   input,    width = 4,        i_xcvr_reconfig_read.i_xcvr_reconfig_read
		.i_xcvr_reconfig_write         (_connected_to_i_xcvr_reconfig_write_),         //   input,    width = 4,       i_xcvr_reconfig_write.i_xcvr_reconfig_write
		.o_xcvr_reconfig_readdata      (_connected_to_o_xcvr_reconfig_readdata_),      //  output,   width = 32,    o_xcvr_reconfig_readdata.o_xcvr_reconfig_readdata
		.i_xcvr_reconfig_writedata     (_connected_to_i_xcvr_reconfig_writedata_),     //   input,   width = 32,   i_xcvr_reconfig_writedata.i_xcvr_reconfig_writedata
		.o_xcvr_reconfig_waitrequest   (_connected_to_o_xcvr_reconfig_waitrequest_),   //  output,    width = 4, o_xcvr_reconfig_waitrequest.o_xcvr_reconfig_waitrequest
		.i_clk_ref                     (_connected_to_i_clk_ref_),                     //   input,    width = 1,                   i_clk_ref.i_clk_ref
		.o_clk_pll_div64               (_connected_to_o_clk_pll_div64_),               //  output,    width = 1,             o_clk_pll_div64.o_clk_pll_div64
		.o_clk_pll_div66               (_connected_to_o_clk_pll_div66_),               //  output,    width = 1,             o_clk_pll_div66.o_clk_pll_div66
		.o_clk_rec_div64               (_connected_to_o_clk_rec_div64_),               //  output,    width = 1,             o_clk_rec_div64.o_clk_rec_div64
		.o_clk_rec_div66               (_connected_to_o_clk_rec_div66_),               //  output,    width = 1,             o_clk_rec_div66.o_clk_rec_div66
		.i_tx_skip_crc                 (_connected_to_i_tx_skip_crc_),                 //   input,    width = 1,                nonpcs_ports.i_tx_skip_crc
		.o_rxstatus_data               (_connected_to_o_rxstatus_data_),               //  output,   width = 40,                            .o_rxstatus_data
		.o_rxstatus_valid              (_connected_to_o_rxstatus_valid_),              //  output,    width = 1,                            .o_rxstatus_valid
		.i_tx_pfc                      (_connected_to_i_tx_pfc_),                      //   input,    width = 8,                   pfc_ports.i_tx_pfc
		.o_rx_pfc                      (_connected_to_o_rx_pfc_),                      //  output,    width = 8,                            .o_rx_pfc
		.i_tx_pause                    (_connected_to_i_tx_pause_),                    //   input,    width = 1,                 pause_ports.i_tx_pause
		.o_rx_pause                    (_connected_to_o_rx_pause_)                     //  output,    width = 1,                            .o_rx_pause
	);
