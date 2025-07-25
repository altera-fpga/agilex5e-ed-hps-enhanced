	component eth_100g_nrz is
		generic (
			am_encoding40g_0              : integer := 9467463;
			am_encoding40g_1              : integer := 15779046;
			am_encoding40g_2              : integer := 12936603;
			am_encoding40g_3              : integer := 10647869;
			enforce_max_frame_size        : string  := "disable";
			flow_control                  : string  := "both_no_xoff";
			flow_control_holdoff_mode     : string  := "uniform";
			forward_rx_pause_requests     : string  := "disable";
			hi_ber_monitor                : string  := "enable";
			holdoff_quanta                : integer := 65535;
			ipg_removed_per_am_period     : integer := 20;
			link_fault_mode               : string  := "lf_bidir";
			pause_quanta                  : integer := 65535;
			pfc_holdoff_quanta_0          : integer := 65535;
			pfc_holdoff_quanta_1          : integer := 65535;
			pfc_holdoff_quanta_2          : integer := 65535;
			pfc_holdoff_quanta_3          : integer := 65535;
			pfc_holdoff_quanta_4          : integer := 65535;
			pfc_holdoff_quanta_5          : integer := 65535;
			pfc_holdoff_quanta_6          : integer := 65535;
			pfc_holdoff_quanta_7          : integer := 65535;
			pfc_pause_quanta_0            : integer := 65535;
			pfc_pause_quanta_1            : integer := 65535;
			pfc_pause_quanta_2            : integer := 65535;
			pfc_pause_quanta_3            : integer := 65535;
			pfc_pause_quanta_4            : integer := 65535;
			pfc_pause_quanta_5            : integer := 65535;
			pfc_pause_quanta_6            : integer := 65535;
			pfc_pause_quanta_7            : integer := 65535;
			remove_pads                   : string  := "disable";
			rx_length_checking            : string  := "disable";
			rx_max_frame_size             : integer := 1518;
			rx_pause_daddr                : string  := "17483607389996";
			rx_pcs_max_skew               : integer := 47;
			rx_vlan_detection             : string  := "disable";
			rxcrc_covers_preamble         : string  := "disable";
			sim_mode                      : string  := "enable";
			source_address_insertion      : string  := "disable";
			strict_preamble_checking      : string  := "disable";
			strict_sfd_checking           : string  := "disable";
			tx_ipg_size                   : string  := "ipg_12";
			tx_max_frame_size             : integer := 1518;
			tx_pause_daddr                : string  := "1652522221569";
			tx_pause_saddr                : string  := "247393538562781";
			tx_pld_fifo_almost_full_level : integer := 16;
			tx_vlan_detection             : string  := "disable";
			txcrc_covers_preamble         : string  := "disable";
			txmac_saddr                   : string  := "73588229205";
			uniform_holdoff_quanta        : integer := 51090;
			flow_control_sl_0             : string  := "both_no_xoff"
		);
		port (
			i_stats_snapshot              : in  std_logic                      := 'X';             -- i_stats_snapshot
			o_cdr_lock                    : out std_logic_vector(0 downto 0);                      -- o_cdr_lock
			o_tx_pll_locked               : out std_logic_vector(0 downto 0);                      -- o_tx_pll_locked
			i_eth_reconfig_addr           : in  std_logic_vector(20 downto 0)  := (others => 'X'); -- address
			i_eth_reconfig_read           : in  std_logic                      := 'X';             -- read
			i_eth_reconfig_write          : in  std_logic                      := 'X';             -- write
			o_eth_reconfig_readdata       : out std_logic_vector(31 downto 0);                     -- readdata
			o_eth_reconfig_readdata_valid : out std_logic;                                         -- readdatavalid
			i_eth_reconfig_writedata      : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- writedata
			o_eth_reconfig_waitrequest    : out std_logic;                                         -- waitrequest
			i_rsfec_reconfig_addr         : in  std_logic_vector(10 downto 0)  := (others => 'X'); -- address
			i_rsfec_reconfig_read         : in  std_logic                      := 'X';             -- read
			i_rsfec_reconfig_write        : in  std_logic                      := 'X';             -- write
			o_rsfec_reconfig_readdata     : out std_logic_vector(7 downto 0);                      -- readdata
			i_rsfec_reconfig_writedata    : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- writedata
			o_rsfec_reconfig_waitrequest  : out std_logic;                                         -- waitrequest
			o_tx_lanes_stable             : out std_logic;                                         -- o_tx_lanes_stable
			o_rx_pcs_ready                : out std_logic;                                         -- o_rx_pcs_ready
			o_ehip_ready                  : out std_logic;                                         -- o_ehip_ready
			o_rx_block_lock               : out std_logic;                                         -- o_rx_block_lock
			o_rx_am_lock                  : out std_logic;                                         -- o_rx_am_lock
			o_rx_hi_ber                   : out std_logic;                                         -- o_rx_hi_ber
			o_local_fault_status          : out std_logic;                                         -- o_local_fault_status
			o_remote_fault_status         : out std_logic;                                         -- o_remote_fault_status
			i_clk_tx                      : in  std_logic                      := 'X';             -- clk
			i_clk_rx                      : in  std_logic                      := 'X';             -- clk
			i_csr_rst_n                   : in  std_logic                      := 'X';             -- reset_n
			i_tx_rst_n                    : in  std_logic                      := 'X';             -- reset_n
			i_rx_rst_n                    : in  std_logic                      := 'X';             -- reset_n
			o_tx_serial                   : out std_logic_vector(3 downto 0);                      -- o_tx_serial
			i_rx_serial                   : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- i_rx_serial
			o_tx_serial_n                 : out std_logic_vector(3 downto 0);                      -- o_tx_serial_n
			i_rx_serial_n                 : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- i_rx_serial_n
			i_reconfig_clk                : in  std_logic                      := 'X';             -- clk
			i_reconfig_reset              : in  std_logic                      := 'X';             -- reset
			o_tx_ready                    : out std_logic;                                         -- ready
			i_tx_valid                    : in  std_logic                      := 'X';             -- valid
			i_tx_data                     : in  std_logic_vector(511 downto 0) := (others => 'X'); -- data
			i_tx_error                    : in  std_logic                      := 'X';             -- error
			i_tx_startofpacket            : in  std_logic                      := 'X';             -- startofpacket
			i_tx_endofpacket              : in  std_logic                      := 'X';             -- endofpacket
			i_tx_empty                    : in  std_logic_vector(5 downto 0)   := (others => 'X'); -- empty
			o_rx_valid                    : out std_logic;                                         -- valid
			o_rx_data                     : out std_logic_vector(511 downto 0);                    -- data
			o_rx_startofpacket            : out std_logic;                                         -- startofpacket
			o_rx_endofpacket              : out std_logic;                                         -- endofpacket
			o_rx_empty                    : out std_logic_vector(5 downto 0);                      -- empty
			o_rx_error                    : out std_logic_vector(5 downto 0);                      -- error
			i_xcvr_reconfig_address       : in  std_logic_vector(75 downto 0)  := (others => 'X'); -- i_xcvr_reconfig_address
			i_xcvr_reconfig_read          : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- i_xcvr_reconfig_read
			i_xcvr_reconfig_write         : in  std_logic_vector(3 downto 0)   := (others => 'X'); -- i_xcvr_reconfig_write
			o_xcvr_reconfig_readdata      : out std_logic_vector(31 downto 0);                     -- o_xcvr_reconfig_readdata
			i_xcvr_reconfig_writedata     : in  std_logic_vector(31 downto 0)  := (others => 'X'); -- i_xcvr_reconfig_writedata
			o_xcvr_reconfig_waitrequest   : out std_logic_vector(3 downto 0);                      -- o_xcvr_reconfig_waitrequest
			i_clk_ref                     : in  std_logic_vector(0 downto 0)   := (others => 'X'); -- i_clk_ref
			o_clk_pll_div64               : out std_logic_vector(0 downto 0);                      -- o_clk_pll_div64
			o_clk_pll_div66               : out std_logic_vector(0 downto 0);                      -- o_clk_pll_div66
			o_clk_rec_div64               : out std_logic_vector(0 downto 0);                      -- o_clk_rec_div64
			o_clk_rec_div66               : out std_logic_vector(0 downto 0);                      -- o_clk_rec_div66
			i_tx_skip_crc                 : in  std_logic                      := 'X';             -- i_tx_skip_crc
			o_rxstatus_data               : out std_logic_vector(39 downto 0);                     -- o_rxstatus_data
			o_rxstatus_valid              : out std_logic;                                         -- o_rxstatus_valid
			i_tx_pfc                      : in  std_logic_vector(7 downto 0)   := (others => 'X'); -- i_tx_pfc
			o_rx_pfc                      : out std_logic_vector(7 downto 0);                      -- o_rx_pfc
			i_tx_pause                    : in  std_logic                      := 'X';             -- i_tx_pause
			o_rx_pause                    : out std_logic                                          -- o_rx_pause
		);
	end component eth_100g_nrz;

	u0 : component eth_100g_nrz
		generic map (
			am_encoding40g_0              => INTEGER_VALUE_FOR_am_encoding40g_0,
			am_encoding40g_1              => INTEGER_VALUE_FOR_am_encoding40g_1,
			am_encoding40g_2              => INTEGER_VALUE_FOR_am_encoding40g_2,
			am_encoding40g_3              => INTEGER_VALUE_FOR_am_encoding40g_3,
			enforce_max_frame_size        => STRING_VALUE_FOR_enforce_max_frame_size,
			flow_control                  => STRING_VALUE_FOR_flow_control,
			flow_control_holdoff_mode     => STRING_VALUE_FOR_flow_control_holdoff_mode,
			forward_rx_pause_requests     => STRING_VALUE_FOR_forward_rx_pause_requests,
			hi_ber_monitor                => STRING_VALUE_FOR_hi_ber_monitor,
			holdoff_quanta                => INTEGER_VALUE_FOR_holdoff_quanta,
			ipg_removed_per_am_period     => INTEGER_VALUE_FOR_ipg_removed_per_am_period,
			link_fault_mode               => STRING_VALUE_FOR_link_fault_mode,
			pause_quanta                  => INTEGER_VALUE_FOR_pause_quanta,
			pfc_holdoff_quanta_0          => INTEGER_VALUE_FOR_pfc_holdoff_quanta_0,
			pfc_holdoff_quanta_1          => INTEGER_VALUE_FOR_pfc_holdoff_quanta_1,
			pfc_holdoff_quanta_2          => INTEGER_VALUE_FOR_pfc_holdoff_quanta_2,
			pfc_holdoff_quanta_3          => INTEGER_VALUE_FOR_pfc_holdoff_quanta_3,
			pfc_holdoff_quanta_4          => INTEGER_VALUE_FOR_pfc_holdoff_quanta_4,
			pfc_holdoff_quanta_5          => INTEGER_VALUE_FOR_pfc_holdoff_quanta_5,
			pfc_holdoff_quanta_6          => INTEGER_VALUE_FOR_pfc_holdoff_quanta_6,
			pfc_holdoff_quanta_7          => INTEGER_VALUE_FOR_pfc_holdoff_quanta_7,
			pfc_pause_quanta_0            => INTEGER_VALUE_FOR_pfc_pause_quanta_0,
			pfc_pause_quanta_1            => INTEGER_VALUE_FOR_pfc_pause_quanta_1,
			pfc_pause_quanta_2            => INTEGER_VALUE_FOR_pfc_pause_quanta_2,
			pfc_pause_quanta_3            => INTEGER_VALUE_FOR_pfc_pause_quanta_3,
			pfc_pause_quanta_4            => INTEGER_VALUE_FOR_pfc_pause_quanta_4,
			pfc_pause_quanta_5            => INTEGER_VALUE_FOR_pfc_pause_quanta_5,
			pfc_pause_quanta_6            => INTEGER_VALUE_FOR_pfc_pause_quanta_6,
			pfc_pause_quanta_7            => INTEGER_VALUE_FOR_pfc_pause_quanta_7,
			remove_pads                   => STRING_VALUE_FOR_remove_pads,
			rx_length_checking            => STRING_VALUE_FOR_rx_length_checking,
			rx_max_frame_size             => INTEGER_VALUE_FOR_rx_max_frame_size,
			rx_pause_daddr                => STRING_VALUE_FOR_rx_pause_daddr,
			rx_pcs_max_skew               => INTEGER_VALUE_FOR_rx_pcs_max_skew,
			rx_vlan_detection             => STRING_VALUE_FOR_rx_vlan_detection,
			rxcrc_covers_preamble         => STRING_VALUE_FOR_rxcrc_covers_preamble,
			sim_mode                      => STRING_VALUE_FOR_sim_mode,
			source_address_insertion      => STRING_VALUE_FOR_source_address_insertion,
			strict_preamble_checking      => STRING_VALUE_FOR_strict_preamble_checking,
			strict_sfd_checking           => STRING_VALUE_FOR_strict_sfd_checking,
			tx_ipg_size                   => STRING_VALUE_FOR_tx_ipg_size,
			tx_max_frame_size             => INTEGER_VALUE_FOR_tx_max_frame_size,
			tx_pause_daddr                => STRING_VALUE_FOR_tx_pause_daddr,
			tx_pause_saddr                => STRING_VALUE_FOR_tx_pause_saddr,
			tx_pld_fifo_almost_full_level => INTEGER_VALUE_FOR_tx_pld_fifo_almost_full_level,
			tx_vlan_detection             => STRING_VALUE_FOR_tx_vlan_detection,
			txcrc_covers_preamble         => STRING_VALUE_FOR_txcrc_covers_preamble,
			txmac_saddr                   => STRING_VALUE_FOR_txmac_saddr,
			uniform_holdoff_quanta        => INTEGER_VALUE_FOR_uniform_holdoff_quanta,
			flow_control_sl_0             => STRING_VALUE_FOR_flow_control_sl_0
		)
		port map (
			i_stats_snapshot              => CONNECTED_TO_i_stats_snapshot,              --            i_stats_snapshot.i_stats_snapshot
			o_cdr_lock                    => CONNECTED_TO_o_cdr_lock,                    --                  o_cdr_lock.o_cdr_lock
			o_tx_pll_locked               => CONNECTED_TO_o_tx_pll_locked,               --             o_tx_pll_locked.o_tx_pll_locked
			i_eth_reconfig_addr           => CONNECTED_TO_i_eth_reconfig_addr,           --                eth_reconfig.address
			i_eth_reconfig_read           => CONNECTED_TO_i_eth_reconfig_read,           --                            .read
			i_eth_reconfig_write          => CONNECTED_TO_i_eth_reconfig_write,          --                            .write
			o_eth_reconfig_readdata       => CONNECTED_TO_o_eth_reconfig_readdata,       --                            .readdata
			o_eth_reconfig_readdata_valid => CONNECTED_TO_o_eth_reconfig_readdata_valid, --                            .readdatavalid
			i_eth_reconfig_writedata      => CONNECTED_TO_i_eth_reconfig_writedata,      --                            .writedata
			o_eth_reconfig_waitrequest    => CONNECTED_TO_o_eth_reconfig_waitrequest,    --                            .waitrequest
			i_rsfec_reconfig_addr         => CONNECTED_TO_i_rsfec_reconfig_addr,         --              rsfec_reconfig.address
			i_rsfec_reconfig_read         => CONNECTED_TO_i_rsfec_reconfig_read,         --                            .read
			i_rsfec_reconfig_write        => CONNECTED_TO_i_rsfec_reconfig_write,        --                            .write
			o_rsfec_reconfig_readdata     => CONNECTED_TO_o_rsfec_reconfig_readdata,     --                            .readdata
			i_rsfec_reconfig_writedata    => CONNECTED_TO_i_rsfec_reconfig_writedata,    --                            .writedata
			o_rsfec_reconfig_waitrequest  => CONNECTED_TO_o_rsfec_reconfig_waitrequest,  --                            .waitrequest
			o_tx_lanes_stable             => CONNECTED_TO_o_tx_lanes_stable,             --           o_tx_lanes_stable.o_tx_lanes_stable
			o_rx_pcs_ready                => CONNECTED_TO_o_rx_pcs_ready,                --              o_rx_pcs_ready.o_rx_pcs_ready
			o_ehip_ready                  => CONNECTED_TO_o_ehip_ready,                  --                o_ehip_ready.o_ehip_ready
			o_rx_block_lock               => CONNECTED_TO_o_rx_block_lock,               --             o_rx_block_lock.o_rx_block_lock
			o_rx_am_lock                  => CONNECTED_TO_o_rx_am_lock,                  --                o_rx_am_lock.o_rx_am_lock
			o_rx_hi_ber                   => CONNECTED_TO_o_rx_hi_ber,                   --                 o_rx_hi_ber.o_rx_hi_ber
			o_local_fault_status          => CONNECTED_TO_o_local_fault_status,          --        o_local_fault_status.o_local_fault_status
			o_remote_fault_status         => CONNECTED_TO_o_remote_fault_status,         --       o_remote_fault_status.o_remote_fault_status
			i_clk_tx                      => CONNECTED_TO_i_clk_tx,                      --                    i_clk_tx.clk
			i_clk_rx                      => CONNECTED_TO_i_clk_rx,                      --                    i_clk_rx.clk
			i_csr_rst_n                   => CONNECTED_TO_i_csr_rst_n,                   --                 i_csr_rst_n.reset_n
			i_tx_rst_n                    => CONNECTED_TO_i_tx_rst_n,                    --                  i_tx_rst_n.reset_n
			i_rx_rst_n                    => CONNECTED_TO_i_rx_rst_n,                    --                  i_rx_rst_n.reset_n
			o_tx_serial                   => CONNECTED_TO_o_tx_serial,                   --                    serial_p.o_tx_serial
			i_rx_serial                   => CONNECTED_TO_i_rx_serial,                   --                            .i_rx_serial
			o_tx_serial_n                 => CONNECTED_TO_o_tx_serial_n,                 --                    serial_n.o_tx_serial_n
			i_rx_serial_n                 => CONNECTED_TO_i_rx_serial_n,                 --                            .i_rx_serial_n
			i_reconfig_clk                => CONNECTED_TO_i_reconfig_clk,                --              i_reconfig_clk.clk
			i_reconfig_reset              => CONNECTED_TO_i_reconfig_reset,              --            i_reconfig_reset.reset
			o_tx_ready                    => CONNECTED_TO_o_tx_ready,                    --                tx_streaming.ready
			i_tx_valid                    => CONNECTED_TO_i_tx_valid,                    --                            .valid
			i_tx_data                     => CONNECTED_TO_i_tx_data,                     --                            .data
			i_tx_error                    => CONNECTED_TO_i_tx_error,                    --                            .error
			i_tx_startofpacket            => CONNECTED_TO_i_tx_startofpacket,            --                            .startofpacket
			i_tx_endofpacket              => CONNECTED_TO_i_tx_endofpacket,              --                            .endofpacket
			i_tx_empty                    => CONNECTED_TO_i_tx_empty,                    --                            .empty
			o_rx_valid                    => CONNECTED_TO_o_rx_valid,                    --                rx_streaming.valid
			o_rx_data                     => CONNECTED_TO_o_rx_data,                     --                            .data
			o_rx_startofpacket            => CONNECTED_TO_o_rx_startofpacket,            --                            .startofpacket
			o_rx_endofpacket              => CONNECTED_TO_o_rx_endofpacket,              --                            .endofpacket
			o_rx_empty                    => CONNECTED_TO_o_rx_empty,                    --                            .empty
			o_rx_error                    => CONNECTED_TO_o_rx_error,                    --                            .error
			i_xcvr_reconfig_address       => CONNECTED_TO_i_xcvr_reconfig_address,       --     i_xcvr_reconfig_address.i_xcvr_reconfig_address
			i_xcvr_reconfig_read          => CONNECTED_TO_i_xcvr_reconfig_read,          --        i_xcvr_reconfig_read.i_xcvr_reconfig_read
			i_xcvr_reconfig_write         => CONNECTED_TO_i_xcvr_reconfig_write,         --       i_xcvr_reconfig_write.i_xcvr_reconfig_write
			o_xcvr_reconfig_readdata      => CONNECTED_TO_o_xcvr_reconfig_readdata,      --    o_xcvr_reconfig_readdata.o_xcvr_reconfig_readdata
			i_xcvr_reconfig_writedata     => CONNECTED_TO_i_xcvr_reconfig_writedata,     --   i_xcvr_reconfig_writedata.i_xcvr_reconfig_writedata
			o_xcvr_reconfig_waitrequest   => CONNECTED_TO_o_xcvr_reconfig_waitrequest,   -- o_xcvr_reconfig_waitrequest.o_xcvr_reconfig_waitrequest
			i_clk_ref                     => CONNECTED_TO_i_clk_ref,                     --                   i_clk_ref.i_clk_ref
			o_clk_pll_div64               => CONNECTED_TO_o_clk_pll_div64,               --             o_clk_pll_div64.o_clk_pll_div64
			o_clk_pll_div66               => CONNECTED_TO_o_clk_pll_div66,               --             o_clk_pll_div66.o_clk_pll_div66
			o_clk_rec_div64               => CONNECTED_TO_o_clk_rec_div64,               --             o_clk_rec_div64.o_clk_rec_div64
			o_clk_rec_div66               => CONNECTED_TO_o_clk_rec_div66,               --             o_clk_rec_div66.o_clk_rec_div66
			i_tx_skip_crc                 => CONNECTED_TO_i_tx_skip_crc,                 --                nonpcs_ports.i_tx_skip_crc
			o_rxstatus_data               => CONNECTED_TO_o_rxstatus_data,               --                            .o_rxstatus_data
			o_rxstatus_valid              => CONNECTED_TO_o_rxstatus_valid,              --                            .o_rxstatus_valid
			i_tx_pfc                      => CONNECTED_TO_i_tx_pfc,                      --                   pfc_ports.i_tx_pfc
			o_rx_pfc                      => CONNECTED_TO_o_rx_pfc,                      --                            .o_rx_pfc
			i_tx_pause                    => CONNECTED_TO_i_tx_pause,                    --                 pause_ports.i_tx_pause
			o_rx_pause                    => CONNECTED_TO_o_rx_pause                     --                            .o_rx_pause
		);
