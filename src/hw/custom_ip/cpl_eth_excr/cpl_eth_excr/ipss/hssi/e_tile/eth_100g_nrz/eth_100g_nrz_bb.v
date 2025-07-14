module eth_100g_nrz #(
		parameter am_encoding40g_0              = 9467463,
		parameter am_encoding40g_1              = 15779046,
		parameter am_encoding40g_2              = 12936603,
		parameter am_encoding40g_3              = 10647869,
		parameter enforce_max_frame_size        = "disable",
		parameter flow_control                  = "both_no_xoff",
		parameter flow_control_holdoff_mode     = "uniform",
		parameter forward_rx_pause_requests     = "disable",
		parameter hi_ber_monitor                = "enable",
		parameter holdoff_quanta                = 65535,
		parameter ipg_removed_per_am_period     = 20,
		parameter link_fault_mode               = "lf_bidir",
		parameter pause_quanta                  = 65535,
		parameter pfc_holdoff_quanta_0          = 65535,
		parameter pfc_holdoff_quanta_1          = 65535,
		parameter pfc_holdoff_quanta_2          = 65535,
		parameter pfc_holdoff_quanta_3          = 65535,
		parameter pfc_holdoff_quanta_4          = 65535,
		parameter pfc_holdoff_quanta_5          = 65535,
		parameter pfc_holdoff_quanta_6          = 65535,
		parameter pfc_holdoff_quanta_7          = 65535,
		parameter pfc_pause_quanta_0            = 65535,
		parameter pfc_pause_quanta_1            = 65535,
		parameter pfc_pause_quanta_2            = 65535,
		parameter pfc_pause_quanta_3            = 65535,
		parameter pfc_pause_quanta_4            = 65535,
		parameter pfc_pause_quanta_5            = 65535,
		parameter pfc_pause_quanta_6            = 65535,
		parameter pfc_pause_quanta_7            = 65535,
		parameter remove_pads                   = "disable",
		parameter rx_length_checking            = "disable",
		parameter rx_max_frame_size             = 1518,
		parameter rx_pause_daddr                = "17483607389996",
		parameter rx_pcs_max_skew               = 47,
		parameter rx_vlan_detection             = "disable",
		parameter rxcrc_covers_preamble         = "disable",
		parameter sim_mode                      = "enable",
		parameter source_address_insertion      = "disable",
		parameter strict_preamble_checking      = "disable",
		parameter strict_sfd_checking           = "disable",
		parameter tx_ipg_size                   = "ipg_12",
		parameter tx_max_frame_size             = 1518,
		parameter tx_pause_daddr                = "1652522221569",
		parameter tx_pause_saddr                = "247393538562781",
		parameter tx_pld_fifo_almost_full_level = 16,
		parameter tx_vlan_detection             = "disable",
		parameter txcrc_covers_preamble         = "disable",
		parameter txmac_saddr                   = "73588229205",
		parameter uniform_holdoff_quanta        = 51090,
		parameter flow_control_sl_0             = "both_no_xoff"
	) (
		input  wire         i_stats_snapshot,              //            i_stats_snapshot.i_stats_snapshot,            Stats Snapshot
		output wire [0:0]   o_cdr_lock,                    //                  o_cdr_lock.o_cdr_lock,                  RX CDR Locked
		output wire [0:0]   o_tx_pll_locked,               //             o_tx_pll_locked.o_tx_pll_locked,             TX PLL Locked
		input  wire [20:0]  i_eth_reconfig_addr,           //                eth_reconfig.address,                     CSR access address
		input  wire         i_eth_reconfig_read,           //                            .read,                        read signal asserted to start a read cycle
		input  wire         i_eth_reconfig_write,          //                            .write,                       write signal asserted to write data on status_writedata bus
		output wire [31:0]  o_eth_reconfig_readdata,       //                            .readdata,                    data that was read by a read cycle
		output wire         o_eth_reconfig_readdata_valid, //                            .readdatavalid,               signal to indicate a valid read
		input  wire [31:0]  i_eth_reconfig_writedata,      //                            .writedata,                   data to be written on a write cycle
		output wire         o_eth_reconfig_waitrequest,    //                            .waitrequest,                 AVMM stalling signal. The read/write cycle is only complete when this signal goes low
		input  wire [10:0]  i_rsfec_reconfig_addr,         //              rsfec_reconfig.address,                     Ehip FEC's configure:CSR access address
		input  wire         i_rsfec_reconfig_read,         //                            .read,                        Ehip FEC's configure:read signal asserted to start a read cycle
		input  wire         i_rsfec_reconfig_write,        //                            .write,                       Ehip FEC's configure:write signal asserted to write data on status_writedata bus
		output wire [7:0]   o_rsfec_reconfig_readdata,     //                            .readdata,                    Ehip FEC's configure:data that was read by a read cycle
		input  wire [7:0]   i_rsfec_reconfig_writedata,    //                            .writedata,                   Ehip FEC's configure:data to be written on a write cycle
		output wire         o_rsfec_reconfig_waitrequest,  //                            .waitrequest,                 Ehip FEC's configure:AVMM stalling signal. The read/write cycle is only complete when this signal goes low
		output wire         o_tx_lanes_stable,             //           o_tx_lanes_stable.o_tx_lanes_stable,           Asserted when TX MAC is ready to send data
		output wire         o_rx_pcs_ready,                //              o_rx_pcs_ready.o_rx_pcs_ready,              Asserted when RX PCS is ready to receive data
		output wire         o_ehip_ready,                  //                o_ehip_ready.o_ehip_ready,                Signal to indicate EHIP CSRs are ready to access
		output wire         o_rx_block_lock,               //             o_rx_block_lock.o_rx_block_lock,             Asserted when 66b block alignment is finished on all PCS lanes
		output wire         o_rx_am_lock,                  //                o_rx_am_lock.o_rx_am_lock,                Asserted when RX PCS has found detected alignment markers and deskewed PCS lanes.
		output wire         o_rx_hi_ber,                   //                 o_rx_hi_ber.o_rx_hi_ber,                 Asserted when RX PCS detected high BER; in AN/LT mode, this will trigger re-negotiation.
		output wire         o_local_fault_status,          //        o_local_fault_status.o_local_fault_status,        The RX PCS has detected a problem that prevents it from being able to receive data
		output wire         o_remote_fault_status,         //       o_remote_fault_status.o_remote_fault_status,       The remote link partner has sent remote fault ordered sets indicating that it is unable to receive data.
		input  wire         i_clk_tx,                      //                    i_clk_tx.clk,                         TX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div64 to this clock
		input  wire         i_clk_rx,                      //                    i_clk_rx.clk,                         RX Avalon-ST interface clock, in synchronous mode connect o_clk_pll_div64 to this clock
		input  wire         i_csr_rst_n,                   //                 i_csr_rst_n.reset_n,                     Resets the entire Ethernet core. Active low.
		input  wire         i_tx_rst_n,                    //                  i_tx_rst_n.reset_n,                     Resets the TX digital path (MAC, PCS)
		input  wire         i_rx_rst_n,                    //                  i_rx_rst_n.reset_n,                     Resets the RX digital path (MAC, PCS)
		output wire [3:0]   o_tx_serial,                   //                    serial_p.o_tx_serial,                 TX XCVR serial pins
		input  wire [3:0]   i_rx_serial,                   //                            .i_rx_serial,                 RX XCVR serial pins
		output wire [3:0]   o_tx_serial_n,                 //                    serial_n.o_tx_serial_n,               TX XCVR serial pins
		input  wire [3:0]   i_rx_serial_n,                 //                            .i_rx_serial_n,               RX XCVR serial pins
		input  wire         i_reconfig_clk,                //              i_reconfig_clk.clk,                         XCVR reconfiguration bus clock
		input  wire         i_reconfig_reset,              //            i_reconfig_reset.reset,                       XCVR reconfig reset
		output wire         o_tx_ready,                    //                tx_streaming.ready,                       Indicates that the MAC is ready to accept new data
		input  wire         i_tx_valid,                    //                            .valid,                       Indicates data TX data is valid. Must remain high throughout transmission of packet
		input  wire [511:0] i_tx_data,                     //                            .data,                        Input data to the MAC.Bits 0 is the LSB
		input  wire         i_tx_error,                    //                            .error,                       A valid high on this signal aligned with an eop will cause the tx frame to be treated as an error
		input  wire         i_tx_startofpacket,            //                            .startofpacket,               Start of packet (SOP). Asserted for one cycle at the beginning of frame
		input  wire         i_tx_endofpacket,              //                            .endofpacket,                 End of packet (EOP). Asserted for one cycle on the last cycle of the frame
		input  wire [5:0]   i_tx_empty,                    //                            .empty,                       Indicates the number of empty bytes at the end of the frame. Must be valid when EOP is asserted
		output wire         o_rx_valid,                    //                rx_streaming.valid,                       Indicates data RX data, EOP, and SOP are valid
		output wire [511:0] o_rx_data,                     //                            .data,                        Output data from the MAC. Bits 0 is the LSB
		output wire         o_rx_startofpacket,            //                            .startofpacket,               Start of packet (SOP). Asserted for one cycle at the beginning of frame
		output wire         o_rx_endofpacket,              //                            .endofpacket,                 End of packet (EOP). Asserted for one cycle on the last cycle of the frame
		output wire [5:0]   o_rx_empty,                    //                            .empty,                       Indicates the number of empty bytes at the end of the frame.Must be valid when EOP is asserted
		output wire [5:0]   o_rx_error,                    //                            .error,                       RX error bits asserted on the EOP cycle
		input  wire [75:0]  i_xcvr_reconfig_address,       //     i_xcvr_reconfig_address.i_xcvr_reconfig_address,     reconfig access address
		input  wire [3:0]   i_xcvr_reconfig_read,          //        i_xcvr_reconfig_read.i_xcvr_reconfig_read,        read signal asserted to start a read cycle
		input  wire [3:0]   i_xcvr_reconfig_write,         //       i_xcvr_reconfig_write.i_xcvr_reconfig_write,       write signal asserted to write data on reconfig_writedata bus
		output wire [31:0]  o_xcvr_reconfig_readdata,      //    o_xcvr_reconfig_readdata.o_xcvr_reconfig_readdata,    data that was read by a read cycle
		input  wire [31:0]  i_xcvr_reconfig_writedata,     //   i_xcvr_reconfig_writedata.i_xcvr_reconfig_writedata,   data to be written on a write cycle
		output wire [3:0]   o_xcvr_reconfig_waitrequest,   // o_xcvr_reconfig_waitrequest.o_xcvr_reconfig_waitrequest, AVMM stalling signal. The read/write cycle is only complete when this signal goes low
		input  wire [0:0]   i_clk_ref,                     //                   i_clk_ref.i_clk_ref,                   Reference clock used by the RX PHY
		output wire [0:0]   o_clk_pll_div64,               //             o_clk_pll_div64.o_clk_pll_div64,             EHIP system clock, this is /64 clock (402.83 MHz)
		output wire [0:0]   o_clk_pll_div66,               //             o_clk_pll_div66.o_clk_pll_div66,             This is /66 clock (390.625 MHz)
		output wire [0:0]   o_clk_rec_div64,               //             o_clk_rec_div64.o_clk_rec_div64,             This is /64 recovered clock (402.83 MHz)
		output wire [0:0]   o_clk_rec_div66,               //             o_clk_rec_div66.o_clk_rec_div66,             This is /66 recovered clock (390.625 MHz)
		input  wire         i_tx_skip_crc,                 //                nonpcs_ports.i_tx_skip_crc
		output wire [39:0]  o_rxstatus_data,               //                            .o_rxstatus_data
		output wire         o_rxstatus_valid,              //                            .o_rxstatus_valid
		input  wire [7:0]   i_tx_pfc,                      //                   pfc_ports.i_tx_pfc
		output wire [7:0]   o_rx_pfc,                      //                            .o_rx_pfc
		input  wire         i_tx_pause,                    //                 pause_ports.i_tx_pause
		output wire         o_rx_pause                     //                            .o_rx_pause
	);
endmodule
