-- ***************************************************************************
-- *
-- * COPYRIGHT
-- * This code  is subject to third-party rights.
-- * Restricted use for Intel FPGA based network adaptors is granted.
-- *
-- ***************************************************************************
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.eth100_avst_pkg.all;


entity port_eth100 is
   generic (
      G_PHY_CFG : natural := 0;              -- 0    is original / default   = 100G 4 x 25G NRZ Physical link
                                             -- 1    is first defined variant: 100G 2 x 56G PAM4 Physical link
                                             -- 2 ++ to handle variations like PTP timing support or other
                                             --
      G_ALLOW_USER_RESET : boolean := true
      );
   port (
      -------------------------------------------------------------------------------------
      -- Physical ports
      -------------------------------------------------------------------------------------
      refclk_i           : in std_logic;          -- Serdes reference clock. 322M/644M.
      e_tile_async_rst_i : in  std_logic;         -- Full IP reset. Not syncronized
      eth_rx_i           : in  std_logic_vector(3 downto 0);
      eth_tx_o           : out std_logic_vector(3 downto 0);

      -------------------------------------------------------------------------------------
      -- Reconfiguration interfaces clk/rst - 100MHz
      -------------------------------------------------------------------------------------
      reconfig_clk_i               : in  std_logic;
      reconfig_clk_rst_i           : in  std_logic;
      -- XCVR interface
      xcvr_reconfig_address_i      : in  std_logic_vector(75 downto 0);
      xcvr_reconfig_read_i         : in  std_logic_vector(3 downto 0);
      xcvr_reconfig_write_i        : in  std_logic_vector(3 downto 0);
      xcvr_reconfig_readdata_o     : out std_logic_vector(31 downto 0);
      xcvr_reconfig_writedata_i    : in  std_logic_vector(31 downto 0);
      xcvr_reconfig_waitrequest_o  : out std_logic_vector(3 downto 0);
      -------------------------------------------------------------------------------------
      -- MAC interface signals
      -------------------------------------------------------------------------------------
      tx_mac_clk_o       : out std_logic; -- 402.83203125 MHz ±100 ppm
      tx_mac_clk_rst_o   : out std_logic;
      tx_mac_avst_i      : in  eth100_avst_t;
      tx_mac_avst_rdy_o  : out std_logic;

      rx_mac_clk_o       : out std_logic;  --402.83203125 MHz ±100 ppm
      rx_mac_clk_rst_o   : out std_logic;  -- reconfig_clk_rst_i synced to rx_mac_clk_o
      rx_mac_avst_o      : out eth100_avst_t;

      -------------------------------------------------------------------------------------
      -- SyncE interface signals
      -------------------------------------------------------------------------------------
      synce_clk_o        : out std_logic;
      -------------------------------------------------------------------------------------
      -- debug ports
      -------------------------------------------------------------------------------------
      cnt_mac_rst_clks_o     : out std_logic_vector(15 downto 0);
      e_tile_rdy_o           : out std_logic;
      tx_mac_clk_rst_async_i :  in std_logic;
      -------------------------------------------------------------------------------------
      -- Status signals
      -------------------------------------------------------------------------------------
      e_tile_txrx_status_o : out std_logic_vector(15 downto 0)

      );
end port_eth100;


architecture rtl of port_eth100 is


   signal       tx_mac_avst_s      :   eth100_avst_t;
   signal       rx_mac_avst_s      :   eth100_avst_t;

   component eth_100g_nrz is
      port (
         i_stats_snapshot              : in  std_logic                      := 'X';
         o_cdr_lock                    : out std_logic;
         o_tx_pll_locked               : out std_logic;
         i_eth_reconfig_addr           : in  std_logic_vector(20 downto 0)  := (others => 'X');
         i_eth_reconfig_read           : in  std_logic                      := 'X';
         i_eth_reconfig_write          : in  std_logic                      := 'X';
         o_eth_reconfig_readdata       : out std_logic_vector(31 downto 0);
         o_eth_reconfig_readdata_valid : out std_logic;
         i_eth_reconfig_writedata      : in  std_logic_vector(31 downto 0)  := (others => 'X');
         o_eth_reconfig_waitrequest    : out std_logic;
         i_rsfec_reconfig_addr         : in  std_logic_vector(10 downto 0)  := (others => 'X');
         i_rsfec_reconfig_read         : in  std_logic                      := 'X';
         i_rsfec_reconfig_write        : in  std_logic                      := 'X';
         o_rsfec_reconfig_readdata     : out std_logic_vector(7 downto 0);
         i_rsfec_reconfig_writedata    : in  std_logic_vector(7 downto 0)   := (others => 'X');
         o_rsfec_reconfig_waitrequest  : out std_logic;
         o_tx_lanes_stable             : out std_logic;
         o_rx_pcs_ready                : out std_logic;
         o_ehip_ready                  : out std_logic;
         o_rx_block_lock               : out std_logic;
         o_rx_am_lock                  : out std_logic;
         o_rx_hi_ber                   : out std_logic;
         o_local_fault_status          : out std_logic;
         o_remote_fault_status         : out std_logic;
         i_clk_ref                     : in  std_logic;
         i_clk_tx                      : in  std_logic                      := 'X';
         i_clk_rx                      : in  std_logic                      := 'X';
         o_clk_pll_div64               : out std_logic;--;
         o_clk_pll_div66               : out std_logic;--;
         o_clk_rec_div64               : out std_logic;--;
         o_clk_rec_div66               : out std_logic;--;
         i_csr_rst_n                   : in  std_logic                      := 'X';
         i_tx_rst_n                    : in  std_logic                      := 'X';
         i_rx_rst_n                    : in  std_logic                      := 'X';
         o_tx_serial                   : out std_logic_vector(3 downto 0);
         i_rx_serial                   : in  std_logic_vector(3 downto 0)   := (others => 'X');
         o_tx_serial_n                 : out std_logic_vector(3 downto 0);
         i_rx_serial_n                 : in  std_logic_vector(3 downto 0)   := (others => 'X');
         i_reconfig_clk                : in  std_logic                      := 'X';
         i_reconfig_reset              : in  std_logic                      := 'X';
         i_xcvr_reconfig_address       : in  std_logic_vector(75 downto 0)  := (others => 'X');
         i_xcvr_reconfig_read          : in  std_logic_vector(3 downto 0)   := (others => 'X');
         i_xcvr_reconfig_write         : in  std_logic_vector(3 downto 0)   := (others => 'X');
         o_xcvr_reconfig_readdata      : out std_logic_vector(31 downto 0);
         i_xcvr_reconfig_writedata     : in  std_logic_vector(31 downto 0)  := (others => 'X');
         o_xcvr_reconfig_waitrequest   : out std_logic_vector(3 downto 0);
         o_tx_ready                    : out std_logic;
         i_tx_valid                    : in  std_logic                      := 'X';
         i_tx_data                     : in  std_logic_vector(511 downto 0) := (others => 'X');
         i_tx_error                    : in  std_logic                      := 'X';
         i_tx_startofpacket            : in  std_logic                      := 'X';
         i_tx_endofpacket              : in  std_logic                      := 'X';
         i_tx_empty                    : in  std_logic_vector(5 downto 0)   := (others => 'X');
         i_tx_skip_crc                 : in  std_logic                      := 'X';
         o_rx_valid                    : out std_logic;
         o_rx_data                     : out std_logic_vector(511 downto 0);
         o_rx_startofpacket            : out std_logic;
         o_rx_endofpacket              : out std_logic;
         o_rx_empty                    : out std_logic_vector(5 downto 0);
         o_rx_error                    : out std_logic_vector(5 downto 0);
         o_rxstatus_data               : out std_logic_vector(39 downto 0);
         o_rxstatus_valid              : out std_logic;
         i_tx_pfc                      : in  std_logic_vector(7 downto 0)   := (others => 'X');
         o_rx_pfc                      : out std_logic_vector(7 downto 0);
         i_tx_pause                    : in  std_logic                      := 'X';
         o_rx_pause                    : out std_logic);
   end component eth_100g_nrz;

   component eth_100g_pam4 is
      port (
         i_stats_snapshot              : in  std_logic                      := 'X';
         o_cdr_lock                    : out std_logic;
         o_tx_pll_locked               : out std_logic;
         i_eth_reconfig_addr           : in  std_logic_vector(20 downto 0)  := (others => 'X');
         i_eth_reconfig_read           : in  std_logic                      := 'X';
         i_eth_reconfig_write          : in  std_logic                      := 'X';
         o_eth_reconfig_readdata       : out std_logic_vector(31 downto 0);
         o_eth_reconfig_readdata_valid : out std_logic;
         i_eth_reconfig_writedata      : in  std_logic_vector(31 downto 0)  := (others => 'X');
         o_eth_reconfig_waitrequest    : out std_logic;
         i_rsfec_reconfig_addr         : in  std_logic_vector(10 downto 0)  := (others => 'X');
         i_rsfec_reconfig_read         : in  std_logic                      := 'X';
         i_rsfec_reconfig_write        : in  std_logic                      := 'X';
         o_rsfec_reconfig_readdata     : out std_logic_vector(7 downto 0);
         i_rsfec_reconfig_writedata    : in  std_logic_vector(7 downto 0)   := (others => 'X');
         o_rsfec_reconfig_waitrequest  : out std_logic;
         o_tx_lanes_stable             : out std_logic;
         o_rx_pcs_ready                : out std_logic;
         o_ehip_ready                  : out std_logic;
         o_rx_block_lock               : out std_logic;
         o_rx_am_lock                  : out std_logic;
         o_rx_hi_ber                   : out std_logic;
         o_local_fault_status          : out std_logic;
         o_remote_fault_status         : out std_logic;
         i_clk_ref                     : in  std_logic_vector(1 downto 0);
         i_clk_tx                      : in  std_logic                      := 'X';
         i_clk_rx                      : in  std_logic                      := 'X';
         o_clk_pll_div64               : out std_logic;--;
         o_clk_pll_div66               : out std_logic;--;
         o_clk_rec_div64               : out std_logic;--;
         o_clk_rec_div66               : out std_logic;--;
         i_csr_rst_n                   : in  std_logic                      := 'X';
         i_tx_rst_n                    : in  std_logic                      := 'X';
         i_rx_rst_n                    : in  std_logic                      := 'X';
         o_tx_serial                   : out std_logic_vector(3 downto 0);
         i_rx_serial                   : in  std_logic_vector(3 downto 0)   := (others => 'X');
         o_tx_serial_n                 : out std_logic_vector(3 downto 0);
         i_rx_serial_n                 : in  std_logic_vector(3 downto 0)   := (others => 'X');
         i_reconfig_clk                : in  std_logic                      := 'X';
         i_reconfig_reset              : in  std_logic                      := 'X';
         i_xcvr_reconfig_address       : in  std_logic_vector(75 downto 0)  := (others => 'X');
         i_xcvr_reconfig_read          : in  std_logic_vector(3 downto 0)   := (others => 'X');
         i_xcvr_reconfig_write         : in  std_logic_vector(3 downto 0)   := (others => 'X');
         o_xcvr_reconfig_readdata      : out std_logic_vector(31 downto 0);
         i_xcvr_reconfig_writedata     : in  std_logic_vector(31 downto 0)  := (others => 'X');
         o_xcvr_reconfig_waitrequest   : out std_logic_vector(3 downto 0);
         o_tx_ready                    : out std_logic;
         i_tx_valid                    : in  std_logic                      := 'X';
         i_tx_data                     : in  std_logic_vector(511 downto 0) := (others => 'X');
         i_tx_error                    : in  std_logic                      := 'X';
         i_tx_startofpacket            : in  std_logic                      := 'X';
         i_tx_endofpacket              : in  std_logic                      := 'X';
         i_tx_empty                    : in  std_logic_vector(5 downto 0)   := (others => 'X');
         i_tx_skip_crc                 : in  std_logic                      := 'X';
         o_rx_valid                    : out std_logic;
         o_rx_data                     : out std_logic_vector(511 downto 0);
         o_rx_startofpacket            : out std_logic;
         o_rx_endofpacket              : out std_logic;
         o_rx_empty                    : out std_logic_vector(5 downto 0);
         o_rx_error                    : out std_logic_vector(5 downto 0);
         o_rxstatus_data               : out std_logic_vector(39 downto 0);
         o_rxstatus_valid              : out std_logic;
         i_tx_pfc                      : in  std_logic_vector(7 downto 0)   := (others => 'X');
         o_rx_pfc                      : out std_logic_vector(7 downto 0);
         i_tx_pause                    : in  std_logic                      := 'X';
         o_rx_pause                    : out std_logic);
   end component eth_100g_pam4;

   component eth_100g_cvl_nrz is
      port (
         i_stats_snapshot              : in  std_logic                      := 'X';
         o_cdr_lock                    : out std_logic;
         o_tx_pll_locked               : out std_logic;
         i_eth_reconfig_addr           : in  std_logic_vector(20 downto 0)  := (others => 'X');
         i_eth_reconfig_read           : in  std_logic                      := 'X';
         i_eth_reconfig_write          : in  std_logic                      := 'X';
         o_eth_reconfig_readdata       : out std_logic_vector(31 downto 0);
         o_eth_reconfig_readdata_valid : out std_logic;
         i_eth_reconfig_writedata      : in  std_logic_vector(31 downto 0)  := (others => 'X');
         o_eth_reconfig_waitrequest    : out std_logic;
         i_rsfec_reconfig_addr         : in  std_logic_vector(10 downto 0)  := (others => 'X');
         i_rsfec_reconfig_read         : in  std_logic                      := 'X';
         i_rsfec_reconfig_write        : in  std_logic                      := 'X';
         o_rsfec_reconfig_readdata     : out std_logic_vector(7 downto 0);
         i_rsfec_reconfig_writedata    : in  std_logic_vector(7 downto 0)   := (others => 'X');
         o_rsfec_reconfig_waitrequest  : out std_logic;
         o_tx_lanes_stable             : out std_logic;
         o_rx_pcs_ready                : out std_logic;
         o_ehip_ready                  : out std_logic;
         o_rx_block_lock               : out std_logic;
         o_rx_am_lock                  : out std_logic;
         o_rx_hi_ber                   : out std_logic;
         o_local_fault_status          : out std_logic;
         o_remote_fault_status         : out std_logic;
         i_clk_ref                     : in  std_logic;
         i_clk_tx                      : in  std_logic                      := 'X';
         i_clk_rx                      : in  std_logic                      := 'X';
         o_clk_pll_div64               : out std_logic;
         o_clk_pll_div66               : out std_logic;
         o_clk_rec_div64               : out std_logic;
         o_clk_rec_div66               : out std_logic;
         i_csr_rst_n                   : in  std_logic                      := 'X';
         i_tx_rst_n                    : in  std_logic                      := 'X';
         i_rx_rst_n                    : in  std_logic                      := 'X';
         o_tx_serial                   : out std_logic_vector(3 downto 0);
         i_rx_serial                   : in  std_logic_vector(3 downto 0)   := (others => 'X');
         o_tx_serial_n                 : out std_logic_vector(3 downto 0);
         i_rx_serial_n                 : in  std_logic_vector(3 downto 0)   := (others => 'X');
         i_reconfig_clk                : in  std_logic                      := 'X';
         i_reconfig_reset              : in  std_logic                      := 'X';
         i_xcvr_reconfig_address       : in  std_logic_vector(75 downto 0)  := (others => 'X');
         i_xcvr_reconfig_read          : in  std_logic_vector(3 downto 0)   := (others => 'X');
         i_xcvr_reconfig_write         : in  std_logic_vector(3 downto 0)   := (others => 'X');
         o_xcvr_reconfig_readdata      : out std_logic_vector(31 downto 0);
         i_xcvr_reconfig_writedata     : in  std_logic_vector(31 downto 0)  := (others => 'X');
         o_xcvr_reconfig_waitrequest   : out std_logic_vector(3 downto 0);
         o_tx_ready                    : out std_logic;
         i_tx_valid                    : in  std_logic                      := 'X';
         i_tx_data                     : in  std_logic_vector(511 downto 0) := (others => 'X');
         i_tx_error                    : in  std_logic                      := 'X';
         i_tx_startofpacket            : in  std_logic                      := 'X';
         i_tx_endofpacket              : in  std_logic                      := 'X';
         i_tx_empty                    : in  std_logic_vector(5 downto 0)   := (others => 'X');
         i_tx_skip_crc                 : in  std_logic                      := 'X';
         o_rx_valid                    : out std_logic;
         o_rx_data                     : out std_logic_vector(511 downto 0);
         o_rx_startofpacket            : out std_logic;
         o_rx_endofpacket              : out std_logic;
         o_rx_empty                    : out std_logic_vector(5 downto 0);
         o_rx_error                    : out std_logic_vector(5 downto 0);
         o_rxstatus_data               : out std_logic_vector(39 downto 0);
         o_rxstatus_valid              : out std_logic;
         i_tx_pfc                      : in  std_logic_vector(7 downto 0)   := (others => 'X');
         o_rx_pfc                      : out std_logic_vector(7 downto 0);
         i_tx_pause                    : in  std_logic                      := 'X';
         o_rx_pause                    : out std_logic);
   end component eth_100g_cvl_nrz;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Signals
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

   signal tx_lanes_stable_sr_n : std_logic_vector(7 downto 0);
   signal tx_lanes_stable      : std_logic;
   signal ehip_ready           : std_logic;
   signal rx_hi_ber            : std_logic;
   signal local_fault_status   : std_logic;
   signal remote_fault_status  : std_logic;
   signal rx_pcs_ready         : std_logic;
   signal rx_block_lock        : std_logic;
   signal rx_am_lock           : std_logic;
   signal eth100_rst_n         : std_logic;
   signal tx_pll_locked        : std_logic;
   signal eth_user_clk         : std_logic;
   signal clk_rec_div64        : std_logic;
   signal cdr_lock             : std_logic;
   signal e_tile_rdy_pre       : std_logic;

   signal reconfig_clk_rst_comb_n    : std_logic;
   signal reconfig_clk_rst_comb      : std_logic;
   signal reconfig_clk_rst_comb_d0_r : std_logic;
   signal reset_input_vec            : std_logic_vector(1 downto 0);

   signal tx_mac_clk_rst_async   : std_logic;
   signal tx_mac_clk_rst_async_n : std_logic;
   signal tx_mac_clk_rst_meta    : std_logic;
   signal tx_mac_clk_rst_sync    : std_logic;
   signal tx_mac_clk_rst         : std_logic;
   signal tx_mac_clk_rst_n       : std_logic;

   attribute ALTERA_ATTRIBUTE    : string;
   attribute ALTERA_ATTRIBUTE of tx_mac_clk_rst      : signal is "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON ; -name SYNCHRONIZER_IDENTIFICATION FORCED ";
   attribute ALTERA_ATTRIBUTE of tx_mac_clk_rst_sync : signal is "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON ; -name SYNCHRONIZER_IDENTIFICATION FORCED" ;
   attribute ALTERA_ATTRIBUTE of tx_mac_clk_rst_meta : signal is "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON ; -name SYNCHRONIZER_IDENTIFICATION ""FORCED IF ASYNCHRONOUS""";

   signal cnt_mac_rst_clks    : std_logic_vector(15 downto 0) := (others => '0');
   attribute ALTERA_ATTRIBUTE of cnt_mac_rst_clks    : signal is "-name ADV_NETLIST_OPT_ALLOWED NEVER_ALLOW; -name DONT_MERGE_REGISTER ON; -name PRESERVE_REGISTER ON ; -name SYNCHRONIZER_IDENTIFICATION FORCED ";

   signal eth_reconfig_addr           : std_logic_vector(20 downto 0)  := (others => '0');
   signal eth_reconfig_read           : std_logic                      := '0';
   signal eth_reconfig_write          : std_logic                      := '0';
   signal eth_reconfig_readdata       : std_logic_vector(31 downto 0);
   signal eth_reconfig_readdata_valid : std_logic;
   signal eth_reconfig_writedata      : std_logic_vector(31 downto 0)  := (others => '0');
   signal eth_reconfig_waitrequest    : std_logic;

   signal rsfec_reconfig_addr         : std_logic_vector(10 downto 0)  := (others => '0');
   signal rsfec_reconfig_read         : std_logic                      := '0';
   signal rsfec_reconfig_write        : std_logic                      := '0';
   signal rsfec_reconfig_readdata     : std_logic_vector(7 downto 0);
   signal rsfec_reconfig_writedata    : std_logic_vector(7 downto 0)   := (others => '0');
   signal rsfec_reconfig_waitrequest  : std_logic;

   signal xcvr_reconfig_address       : std_logic_vector(75 downto 0)  := (others => '0');
   signal xcvr_reconfig_read          : std_logic_vector(3 downto 0)   := (others => '0');
   signal xcvr_reconfig_write         : std_logic_vector(3 downto 0)   := (others => '0');
   signal xcvr_reconfig_readdata      : std_logic_vector(31 downto 0);
   signal xcvr_reconfig_writedata     : std_logic_vector(31 downto 0)  := (others => '0');
   signal xcvr_reconfig_waitrequest   : std_logic_vector(3 downto 0);

begin

   -- Pt unused signals
   eth_reconfig_addr           <= (others => '0');
   eth_reconfig_writedata      <= (others => '0');
   rsfec_reconfig_addr         <= (others => '0');
   rsfec_reconfig_writedata    <= (others => '0');

   -- XCVR interface connect
   xcvr_reconfig_address       <= xcvr_reconfig_address_i;
   xcvr_reconfig_read          <= xcvr_reconfig_read_i;
   xcvr_reconfig_write         <= xcvr_reconfig_write_i;
   xcvr_reconfig_writedata     <= xcvr_reconfig_writedata_i;
   xcvr_reconfig_readdata_o    <= xcvr_reconfig_readdata;
   xcvr_reconfig_waitrequest_o <= xcvr_reconfig_waitrequest;
   --

   synce_clk_o      <= clk_rec_div64;
   tx_mac_clk_o     <= eth_user_clk;
   rx_mac_clk_o     <= eth_user_clk;

   tx_mac_avst_s <= tx_mac_avst_i;
   rx_mac_avst_o <= rx_mac_avst_s;

    -- Debug status output vector:
    e_tile_txrx_status_o(15) <= '0';
    e_tile_txrx_status_o(14) <= rx_hi_ber;
    e_tile_txrx_status_o(13) <= remote_fault_status;
    e_tile_txrx_status_o(12) <= local_fault_status;
    e_tile_txrx_status_o(11) <= ehip_ready;
    e_tile_txrx_status_o(10) <= rx_pcs_ready;
    e_tile_txrx_status_o(9)  <= rx_am_lock;
    e_tile_txrx_status_o(8)  <= rx_block_lock;
    e_tile_txrx_status_o(7)  <= '0';
    e_tile_txrx_status_o(6)  <= '0';
    e_tile_txrx_status_o(5)  <= '0';
    e_tile_txrx_status_o(4)  <= cdr_lock;
    e_tile_txrx_status_o(3)  <= '0';
    e_tile_txrx_status_o(2)  <= reconfig_clk_rst_comb_n;
    e_tile_txrx_status_o(1)  <= tx_lanes_stable;
    e_tile_txrx_status_o(0)  <= tx_pll_locked;

   tx_mac_clk_rst_async_n <= '0' when tx_pll_locked = '0' or tx_lanes_stable = '0' or tx_mac_clk_rst_async_i = '1' else
                             '1';

   tx_mac_clk_rst_reset_delay : entity work.alt_reset_delay
   generic map ( CNTR_BITS => 2 )
   port map    ( clk       => eth_user_clk,
                 ready_in  => tx_mac_clk_rst_async_n,
                 ready_out => tx_mac_clk_rst_n  );

   tx_mac_clk_rst   <= not tx_mac_clk_rst_n;
   tx_mac_clk_rst_o <= tx_mac_clk_rst;
   -- In this version RX uses same clock as TX
   rx_mac_clk_rst_o <= tx_mac_clk_rst;

   -- count the number of clock cycles that the reset is active to the core logic:
   count_reset_clock_cycles_proc : process (eth_user_clk) is
   begin
      if rising_edge( eth_user_clk ) then
         if (tx_mac_clk_rst = '1' and cnt_mac_rst_clks /= X"FFFF" ) then
            cnt_mac_rst_clks <= std_logic_vector(unsigned(cnt_mac_rst_clks) + 1);
         else
            cnt_mac_rst_clks <= cnt_mac_rst_clks;
         end if;
      end if;
   end process;
   cnt_mac_rst_clks_o <= cnt_mac_rst_clks;

   -- Generate e_tile_rdy_o signal to indicate that tx_pll_locked is high and the user clock has been running for a while:
   e_tile_rdy_alt_reset_delay : entity work.alt_reset_delay
   generic map ( CNTR_BITS => 20 )
   port map    ( clk       => eth_user_clk,
                 ready_in  => e_tile_rdy_pre,
                 ready_out => e_tile_rdy_o  );

   gen_allow_user_reset_of_e_tile : if G_ALLOW_USER_RESET = true generate
      -- Generating Reset for the entire E-tile and synchronising it to the reconfig_clk_i:
      reset_input_vec <= ( 1 => reconfig_clk_rst_i ,
                           0 => e_tile_async_rst_i  );

      -- The combiner and synchroniser has been implemented to comply with the requirements from UG-20160 2021.03.29:
      --   i_reconfig_reset and i_csr_rst_n should be asserted prior to use of the E-tile
      --   i_csr_rst_n shall be only be deasserted after o_tx_pll_locked is asserted
      --   i_reconfig_reset Should be asserted for at least 10 clock cycles of the reconfig_clk
      etile_reset_combiner_and_synchroniser : entity work.reset_comb_sync (synth)
      generic map(
         G_RESET_I_QUANTITY    => 2,
         G_RESETS_I_ACTIVE     => "11",
         G_RESET_O_QUANTITY    => 1
--         G_DELAY_CNTR_BITS     => 5
      )
      port map(
         clocks_i(0)   => reconfig_clk_i,
         resets_i      => reset_input_vec,
         resets_o(0)   => reconfig_clk_rst_comb,
         resets_n_o(0) => reconfig_clk_rst_comb_n
      );
   else generate  --Do very simple reset connections:
      reconfig_clk_rst_comb   <=     reconfig_clk_rst_i;
      reconfig_clk_rst_comb_n <= not reconfig_clk_rst_i;
   end generate;

   -- Instantiate the 100G core and map user avst i/f + ctrl/status to top

   gen_eth_cfg : if G_PHY_CFG = 1 generate -- PAM4 selected (Option 0 is handled as default)

      e_tile_rdy_pre <= '1'; -- Intended to be o_tx_pll_locked, but that keeps the E-tile from exiting reset if eg. AN/LT is enabled or PAM4 is used

      eth_100g_inst : eth_100g_pam4
         port map (

         i_reconfig_clk   => reconfig_clk_i,        --                //   input,    wire [1-1:0] clk
         i_reconfig_reset => reconfig_clk_rst_comb, --              //   input,    wire [1-1:0] i_reconfig_reset

         -- Ethernet Reconfiguration Interface ------------------------------------------------------
         i_eth_reconfig_addr           => eth_reconfig_addr,            --           --   input,   wire [21-1:0] i_eth_reconfig_addr
         i_eth_reconfig_read           => eth_reconfig_read,            --           --   input,    wire [1-1:0] i_eth_reconfig_read
         i_eth_reconfig_write          => eth_reconfig_write,           --          --   input,    wire [1-1:0] i_eth_reconfig_write
         o_eth_reconfig_readdata       => eth_reconfig_readdata,        --       --  output,   wire [32-1:0] o_eth_reconfig_readdata
         o_eth_reconfig_readdata_valid => eth_reconfig_readdata_valid,  -- --  output,    wire [1-1:0] o_eth_reconfig_readdata_valid
         i_eth_reconfig_writedata      => eth_reconfig_writedata,       --      --   input,   wire [32-1:0] i_eth_reconfig_writedata
         o_eth_reconfig_waitrequest    => eth_reconfig_waitrequest,     --    --  output,    wire [1-1:0] o_eth_reconfig_waitrequest

         -- RS-FEC Reconfiguration Interface ------------------------------------------------------
         i_rsfec_reconfig_addr        => rsfec_reconfig_addr,         --         --   input,   wire [11-1:0] i_rsfec_reconfig_addr
         i_rsfec_reconfig_read        => rsfec_reconfig_read,         --         --   input,    wire [1-1:0] i_rsfec_reconfig_read
         i_rsfec_reconfig_write       => rsfec_reconfig_write,        --        --   input,    wire [1-1:0] i_rsfec_reconfig_write
         o_rsfec_reconfig_readdata    => rsfec_reconfig_readdata,     --     --  output,    wire [8-1:0] o_rsfec_reconfig_readdata
         i_rsfec_reconfig_writedata   => rsfec_reconfig_writedata,    --    --   input,    wire [8-1:0] i_rsfec_reconfig_writedata
         o_rsfec_reconfig_waitrequest => rsfec_reconfig_waitrequest,  --  --  output,    wire [1-1:0] o_rsfec_reconfig_waitrequest

         -- XCVR Reconfiguration Interface ------------------------------------------------------

         i_xcvr_reconfig_address     => xcvr_reconfig_address,      --       --   input,   wire [76-1:0] i_xcvr_reconfig_address
         i_xcvr_reconfig_read        => xcvr_reconfig_read,         --          --   input,    wire [4-1:0] i_xcvr_reconfig_read
         i_xcvr_reconfig_write       => xcvr_reconfig_write,        --         --   input,    wire [4-1:0] i_xcvr_reconfig_write
         o_xcvr_reconfig_readdata    => xcvr_reconfig_readdata,     --      --  output,   wire [32-1:0] o_xcvr_reconfig_readdata
         i_xcvr_reconfig_writedata   => xcvr_reconfig_writedata,    --     --   input,   wire [32-1:0] i_xcvr_reconfig_writedata
         o_xcvr_reconfig_waitrequest => xcvr_reconfig_waitrequest,  --   --  output,    wire [4-1:0] o_xcvr_reconfig_waitrequest

         --Physical interface --------------------------------------------------------------------
         i_clk_ref     => ( 1 => refclk_i, 0 => refclk_i ),       --                     --   input,    wire [1-1:0] i_clk_ref
         --Serial data
         o_tx_serial   => eth_tx_o,     --                   --  output,    wire [4-1:0] o_tx_serial
         o_tx_serial_n => open,            --                 --  output,    wire [4-1:0] o_tx_serial_n
         i_rx_serial   => eth_rx_i,     --                   --   input,    wire [4-1:0] i_rx_serial
         i_rx_serial_n => (others => '0'),  --                 --   input,    wire [4-1:0] i_rx_serial_n

         -- Status -------------------------------------------------------------------------------

         o_tx_lanes_stable     => tx_lanes_stable,      --             --  output,    wire [1-1:0] o_tx_lanes_stable
         o_rx_pcs_ready        => rx_pcs_ready,         --                --  output,    wire [1-1:0] o_rx_pcs_ready
         o_ehip_ready          => ehip_ready,           --                  --  output,    wire [1-1:0] o_ehip_ready
         o_rx_block_lock       => rx_block_lock,        --               --  output,    wire [1-1:0] o_rx_block_lock
         o_rx_am_lock          => rx_am_lock,           --                  --  output,    wire [1-1:0] o_rx_am_lock
         o_rx_hi_ber           => rx_hi_ber,            --                   --  output,    wire [1-1:0] o_rx_hi_ber
         o_local_fault_status  => local_fault_status,   --          --  output,    wire [1-1:0] o_local_fault_status
         o_remote_fault_status => remote_fault_status,  --         --  output,    wire [1-1:0] o_remote_fault_status



         o_tx_pll_locked => tx_pll_locked,  --               --  output,    wire [1-1:0] o_tx_pll_locked
         o_clk_pll_div64 => eth_user_clk,   ---- 402.83203125 MHz. valid when o_tx_pll_locked=1'b1                --  output,    wire [1-1:0] o_clk_pll_div64
         o_clk_pll_div66 => open,           ----390.625 MHz               --  output,    wire [1-1:0] o_clk_pll_div66

         o_cdr_lock      => cdr_lock,   --                    --  output,    wire [1-1:0] o_cdr_lock
         o_clk_rec_div64 => clk_rec_div64,       ----415 MHz ±100 ppm                --  output,    wire [1-1:0] o_clk_rec_div64
         o_clk_rec_div66 => open,       ----?? MHz ±100 ppm                --  output,    wire [1-1:0] o_clk_rec_div66

         i_csr_rst_n => reconfig_clk_rst_comb_n,        ----resets everything                   --   input,    wire [1-1:0] reset
         i_tx_rst_n  => reconfig_clk_rst_comb_n, --'1',
         i_rx_rst_n  => reconfig_clk_rst_comb_n, --'1',

         -- Core user interfaces--------------------------------------------------------------------

         -- Tx
         i_clk_tx           => eth_user_clk,         --                      --   input,    wire [1-1:0] clk
         o_tx_ready         => tx_mac_avst_rdy_o,           --                    --  output,    wire [1-1:0] o_tx_ready
         i_tx_valid         => tx_mac_avst_s.valid,  --                    --   input,    wire [1-1:0] i_tx_valid
         i_tx_data          => tx_mac_avst_s.data,   --                     --   input,  wire [512-1:0] i_tx_data
         i_tx_error         => tx_mac_avst_s.err(0),    --                    --   input,    wire [1-1:0] i_tx_error
         i_tx_startofpacket => tx_mac_avst_s.sop,    --            --   input,    wire [1-1:0] i_tx_startofpacket
         i_tx_endofpacket   => tx_mac_avst_s.eop,    --              --   input,    wire [1-1:0] i_tx_endofpacket
         i_tx_empty         => tx_mac_avst_s.empty,  --                    --   input,    wire [6-1:0] i_tx_empty
         i_tx_skip_crc      => '0',                  --                 --   input,    wire [1-1:0] i_tx_skip_crc

         -- Rx
--    --use tx clock for syncronous clocking
         i_clk_rx           => eth_user_clk,         --                      --   input,    wire [1-1:0] clk
         o_rx_valid         => rx_mac_avst_s.valid,  --                    --  output,    wire [1-1:0] o_rx_valid
         o_rx_data          => rx_mac_avst_s.data,   --                     --  output,  wire [512-1:0] o_rx_data
         o_rx_startofpacket => rx_mac_avst_s.sop,    --            --  output,    wire [1-1:0] o_rx_startofpacket
         o_rx_endofpacket   => rx_mac_avst_s.eop,    --              --  output,    wire [1-1:0] o_rx_endofpacket
         o_rx_empty         => rx_mac_avst_s.empty,  --                    --  output,    wire [6-1:0] o_rx_empty
         o_rx_error         => rx_mac_avst_s.err,    --                    --  output,    wire [6-1:0] o_rx_error
         o_rxstatus_data    => open,
         o_rxstatus_valid   => open,


         -- TBD
         i_stats_snapshot => '0',                      --              --   input,    wire [1-1:0] i_stats_snapshot
         -- Pause interface. TBD
         i_tx_pfc         => (others => '0'), --                                      --   input,    wire [8-1:0] i_tx_pfc
         o_rx_pfc         => open,
         i_tx_pause       => '0',--(others => '0'), --                                      --   input,    wire [1-1:0] i_tx_pause
         o_rx_pause       => open                      --  output,    wire [1-1:0] o_rx_pause
      );

   elsif G_PHY_CFG = 2 generate -- IP specifically design to communicate with CVL

      e_tile_rdy_pre <= '1'; -- Intended to be o_tx_pll_locked, but that keeps the E-tile from exiting reset if eg. AN/LT is enabled

      eth_100g_inst : eth_100g_cvl_nrz
         port map (

         i_reconfig_clk   => reconfig_clk_i,        --                //   input,    wire [1-1:0] clk
         i_reconfig_reset => reconfig_clk_rst_comb, --              //   input,    wire [1-1:0] i_reconfig_reset

         -- Ethernet Reconfiguration Interface ------------------------------------------------------
         i_eth_reconfig_addr           => eth_reconfig_addr,            --           --   input,   wire [21-1:0] i_eth_reconfig_addr
         i_eth_reconfig_read           => eth_reconfig_read,            --           --   input,    wire [1-1:0] i_eth_reconfig_read
         i_eth_reconfig_write          => eth_reconfig_write,           --          --   input,    wire [1-1:0] i_eth_reconfig_write
         o_eth_reconfig_readdata       => eth_reconfig_readdata,        --       --  output,   wire [32-1:0] o_eth_reconfig_readdata
         o_eth_reconfig_readdata_valid => eth_reconfig_readdata_valid,  -- --  output,    wire [1-1:0] o_eth_reconfig_readdata_valid
         i_eth_reconfig_writedata      => eth_reconfig_writedata,       --      --   input,   wire [32-1:0] i_eth_reconfig_writedata
         o_eth_reconfig_waitrequest    => eth_reconfig_waitrequest,     --    --  output,    wire [1-1:0] o_eth_reconfig_waitrequest

         -- RS-FEC Reconfiguration Interface ------------------------------------------------------
         i_rsfec_reconfig_addr        => rsfec_reconfig_addr,         --         --   input,   wire [11-1:0] i_rsfec_reconfig_addr
         i_rsfec_reconfig_read        => rsfec_reconfig_read,         --         --   input,    wire [1-1:0] i_rsfec_reconfig_read
         i_rsfec_reconfig_write       => rsfec_reconfig_write,        --        --   input,    wire [1-1:0] i_rsfec_reconfig_write
         o_rsfec_reconfig_readdata    => rsfec_reconfig_readdata,     --     --  output,    wire [8-1:0] o_rsfec_reconfig_readdata
         i_rsfec_reconfig_writedata   => rsfec_reconfig_writedata,    --    --   input,    wire [8-1:0] i_rsfec_reconfig_writedata
         o_rsfec_reconfig_waitrequest => rsfec_reconfig_waitrequest,  --  --  output,    wire [1-1:0] o_rsfec_reconfig_waitrequest

         -- XCVR Reconfiguration Interface ------------------------------------------------------

         i_xcvr_reconfig_address     => xcvr_reconfig_address,      --       --   input,   wire [76-1:0] i_xcvr_reconfig_address
         i_xcvr_reconfig_read        => xcvr_reconfig_read,         --          --   input,    wire [4-1:0] i_xcvr_reconfig_read
         i_xcvr_reconfig_write       => xcvr_reconfig_write,        --         --   input,    wire [4-1:0] i_xcvr_reconfig_write
         o_xcvr_reconfig_readdata    => xcvr_reconfig_readdata,     --      --  output,   wire [32-1:0] o_xcvr_reconfig_readdata
         i_xcvr_reconfig_writedata   => xcvr_reconfig_writedata,    --     --   input,   wire [32-1:0] i_xcvr_reconfig_writedata
         o_xcvr_reconfig_waitrequest => xcvr_reconfig_waitrequest,  --   --  output,    wire [4-1:0] o_xcvr_reconfig_waitrequest

         --Physical interface --------------------------------------------------------------------
         i_clk_ref     => refclk_i,       --                     --   input,    wire [1-1:0] i_clk_ref
         --Serial data
         o_tx_serial   => eth_tx_o,     --                   --  output,    wire [4-1:0] o_tx_serial
         o_tx_serial_n => open,            --                 --  output,    wire [4-1:0] o_tx_serial_n
         i_rx_serial   => eth_rx_i,     --                   --   input,    wire [4-1:0] i_rx_serial
         i_rx_serial_n => (others => '0'),  --                 --   input,    wire [4-1:0] i_rx_serial_n

         -- Status -------------------------------------------------------------------------------

         o_tx_lanes_stable     => tx_lanes_stable,      --             --  output,    wire [1-1:0] o_tx_lanes_stable
         o_rx_pcs_ready        => rx_pcs_ready,         --                --  output,    wire [1-1:0] o_rx_pcs_ready
         o_ehip_ready          => ehip_ready,           --                  --  output,    wire [1-1:0] o_ehip_ready
         o_rx_block_lock       => rx_block_lock,        --               --  output,    wire [1-1:0] o_rx_block_lock
         o_rx_am_lock          => rx_am_lock,           --                  --  output,    wire [1-1:0] o_rx_am_lock
         o_rx_hi_ber           => rx_hi_ber,            --                   --  output,    wire [1-1:0] o_rx_hi_ber
         o_local_fault_status  => local_fault_status,   --          --  output,    wire [1-1:0] o_local_fault_status
         o_remote_fault_status => remote_fault_status,  --         --  output,    wire [1-1:0] o_remote_fault_status



         o_tx_pll_locked => tx_pll_locked,  --               --  output,    wire [1-1:0] o_tx_pll_locked
         o_clk_pll_div64 => eth_user_clk,   ---- 402.83203125 MHz. valid when o_tx_pll_locked=1'b1                --  output,    wire [1-1:0] o_clk_pll_div64
         o_clk_pll_div66 => open,           ----390.625 MHz               --  output,    wire [1-1:0] o_clk_pll_div66

         o_cdr_lock      => cdr_lock,   --                    --  output,    wire [1-1:0] o_cdr_lock
         o_clk_rec_div64 => clk_rec_div64,       ----402.83203125 MHz ±100 ppm                --  output,    wire [1-1:0] o_clk_rec_div64
         o_clk_rec_div66 => open,       ----390.625 MHz ±100 ppm                --  output,    wire [1-1:0] o_clk_rec_div66

         i_csr_rst_n => reconfig_clk_rst_comb_n,        ----resets everything                   --   input,    wire [1-1:0] reset
         i_tx_rst_n  => reconfig_clk_rst_comb_n, --'1',
         i_rx_rst_n  => reconfig_clk_rst_comb_n, --'1',

         -- Core user interfaces--------------------------------------------------------------------

         -- Tx
         i_clk_tx           => eth_user_clk,         --                      --   input,    wire [1-1:0] clk
         o_tx_ready         => tx_mac_avst_rdy_o,           --                    --  output,    wire [1-1:0] o_tx_ready
         i_tx_valid         => tx_mac_avst_s.valid,  --                    --   input,    wire [1-1:0] i_tx_valid
         i_tx_data          => tx_mac_avst_s.data,   --                     --   input,  wire [512-1:0] i_tx_data
         i_tx_error         => tx_mac_avst_s.err(0),    --                    --   input,    wire [1-1:0] i_tx_error
         i_tx_startofpacket => tx_mac_avst_s.sop,    --            --   input,    wire [1-1:0] i_tx_startofpacket
         i_tx_endofpacket   => tx_mac_avst_s.eop,    --              --   input,    wire [1-1:0] i_tx_endofpacket
         i_tx_empty         => tx_mac_avst_s.empty,  --                    --   input,    wire [6-1:0] i_tx_empty
         i_tx_skip_crc      => '0',                  --                 --   input,    wire [1-1:0] i_tx_skip_crc

         -- Rx
--    --use tx clock for syncronous clocking
         i_clk_rx           => eth_user_clk,         --                      --   input,    wire [1-1:0] clk
         o_rx_valid         => rx_mac_avst_s.valid,  --                    --  output,    wire [1-1:0] o_rx_valid
         o_rx_data          => rx_mac_avst_s.data,   --                     --  output,  wire [512-1:0] o_rx_data
         o_rx_startofpacket => rx_mac_avst_s.sop,    --            --  output,    wire [1-1:0] o_rx_startofpacket
         o_rx_endofpacket   => rx_mac_avst_s.eop,    --              --  output,    wire [1-1:0] o_rx_endofpacket
         o_rx_empty         => rx_mac_avst_s.empty,  --                    --  output,    wire [6-1:0] o_rx_empty
         o_rx_error         => rx_mac_avst_s.err,    --                    --  output,    wire [6-1:0] o_rx_error
         o_rxstatus_data    => open,
         o_rxstatus_valid   => open,


         -- TBD
         i_stats_snapshot => '0',                      --              --   input,    wire [1-1:0] i_stats_snapshot
         -- Pause interface. TBD
         i_tx_pfc         => (others => '0'), --                                      --   input,    wire [8-1:0] i_tx_pfc
         o_rx_pfc         => open,
         i_tx_pause       => '0',--(others => '0'), --                                      --   input,    wire [1-1:0] i_tx_pause
         o_rx_pause       => open                      --  output,    wire [1-1:0] o_rx_pause
      );

   else generate  -- default configuration. Will handle cfg = 0

      e_tile_rdy_pre <= '1'; -- Intended to be o_tx_pll_locked, but that keeps the E-tile from exiting reset if eg. AN/LT is enabled

      eth_100g_inst : eth_100g_nrz
         port map (

         i_reconfig_clk   => reconfig_clk_i,        --                //   input,    wire [1-1:0] clk
         i_reconfig_reset => reconfig_clk_rst_comb, --              //   input,    wire [1-1:0] i_reconfig_reset

         -- Ethernet Reconfiguration Interface ------------------------------------------------------
         i_eth_reconfig_addr           => eth_reconfig_addr,            --           --   input,   wire [21-1:0] i_eth_reconfig_addr
         i_eth_reconfig_read           => eth_reconfig_read,            --           --   input,    wire [1-1:0] i_eth_reconfig_read
         i_eth_reconfig_write          => eth_reconfig_write,           --          --   input,    wire [1-1:0] i_eth_reconfig_write
         o_eth_reconfig_readdata       => eth_reconfig_readdata,        --       --  output,   wire [32-1:0] o_eth_reconfig_readdata
         o_eth_reconfig_readdata_valid => eth_reconfig_readdata_valid,  -- --  output,    wire [1-1:0] o_eth_reconfig_readdata_valid
         i_eth_reconfig_writedata      => eth_reconfig_writedata,       --      --   input,   wire [32-1:0] i_eth_reconfig_writedata
         o_eth_reconfig_waitrequest    => eth_reconfig_waitrequest,     --    --  output,    wire [1-1:0] o_eth_reconfig_waitrequest

         -- RS-FEC Reconfiguration Interface ------------------------------------------------------
         i_rsfec_reconfig_addr        => rsfec_reconfig_addr,         --         --   input,   wire [11-1:0] i_rsfec_reconfig_addr
         i_rsfec_reconfig_read        => rsfec_reconfig_read,         --         --   input,    wire [1-1:0] i_rsfec_reconfig_read
         i_rsfec_reconfig_write       => rsfec_reconfig_write,        --        --   input,    wire [1-1:0] i_rsfec_reconfig_write
         o_rsfec_reconfig_readdata    => rsfec_reconfig_readdata,     --     --  output,    wire [8-1:0] o_rsfec_reconfig_readdata
         i_rsfec_reconfig_writedata   => rsfec_reconfig_writedata,    --    --   input,    wire [8-1:0] i_rsfec_reconfig_writedata
         o_rsfec_reconfig_waitrequest => rsfec_reconfig_waitrequest,  --  --  output,    wire [1-1:0] o_rsfec_reconfig_waitrequest

         -- XCVR Reconfiguration Interface ------------------------------------------------------

         i_xcvr_reconfig_address     => xcvr_reconfig_address,      --       --   input,   wire [76-1:0] i_xcvr_reconfig_address
         i_xcvr_reconfig_read        => xcvr_reconfig_read,         --          --   input,    wire [4-1:0] i_xcvr_reconfig_read
         i_xcvr_reconfig_write       => xcvr_reconfig_write,        --         --   input,    wire [4-1:0] i_xcvr_reconfig_write
         o_xcvr_reconfig_readdata    => xcvr_reconfig_readdata,     --      --  output,   wire [32-1:0] o_xcvr_reconfig_readdata
         i_xcvr_reconfig_writedata   => xcvr_reconfig_writedata,    --     --   input,   wire [32-1:0] i_xcvr_reconfig_writedata
         o_xcvr_reconfig_waitrequest => xcvr_reconfig_waitrequest,  --   --  output,    wire [4-1:0] o_xcvr_reconfig_waitrequest

         --Physical interface --------------------------------------------------------------------
         i_clk_ref     => refclk_i,       --                     --   input,    wire [1-1:0] i_clk_ref
         --Serial data
         o_tx_serial   => eth_tx_o,     --                   --  output,    wire [4-1:0] o_tx_serial
         o_tx_serial_n => open,            --                 --  output,    wire [4-1:0] o_tx_serial_n
         i_rx_serial   => eth_rx_i,     --                   --   input,    wire [4-1:0] i_rx_serial
         i_rx_serial_n => (others => '0'),  --                 --   input,    wire [4-1:0] i_rx_serial_n

         -- Status -------------------------------------------------------------------------------

         o_tx_lanes_stable     => tx_lanes_stable,      --             --  output,    wire [1-1:0] o_tx_lanes_stable
         o_rx_pcs_ready        => rx_pcs_ready,         --                --  output,    wire [1-1:0] o_rx_pcs_ready
         o_ehip_ready          => ehip_ready,           --                  --  output,    wire [1-1:0] o_ehip_ready
         o_rx_block_lock       => rx_block_lock,        --               --  output,    wire [1-1:0] o_rx_block_lock
         o_rx_am_lock          => rx_am_lock,           --                  --  output,    wire [1-1:0] o_rx_am_lock
         o_rx_hi_ber           => rx_hi_ber,            --                   --  output,    wire [1-1:0] o_rx_hi_ber
         o_local_fault_status  => local_fault_status,   --          --  output,    wire [1-1:0] o_local_fault_status
         o_remote_fault_status => remote_fault_status,  --         --  output,    wire [1-1:0] o_remote_fault_status



         o_tx_pll_locked => tx_pll_locked,  --               --  output,    wire [1-1:0] o_tx_pll_locked
         o_clk_pll_div64 => eth_user_clk,   ---- 402.83203125 MHz. valid when o_tx_pll_locked=1'b1                --  output,    wire [1-1:0] o_clk_pll_div64
         o_clk_pll_div66 => open,           ----390.625 MHz               --  output,    wire [1-1:0] o_clk_pll_div66

         o_cdr_lock      => cdr_lock,   --                    --  output,    wire [1-1:0] o_cdr_lock
         o_clk_rec_div64 => clk_rec_div64,       ----402.83203125 MHz ±100 ppm                --  output,    wire [1-1:0] o_clk_rec_div64
         o_clk_rec_div66 => open,       ----390.625 MHz ±100 ppm                --  output,    wire [1-1:0] o_clk_rec_div66

         i_csr_rst_n => reconfig_clk_rst_comb_n,        ----resets everything                   --   input,    wire [1-1:0] reset
         i_tx_rst_n  => reconfig_clk_rst_comb_n, --'1',
         i_rx_rst_n  => reconfig_clk_rst_comb_n, --'1',

         -- Core user interfaces--------------------------------------------------------------------

         -- Tx
         i_clk_tx           => eth_user_clk,         --                      --   input,    wire [1-1:0] clk
         o_tx_ready         => tx_mac_avst_rdy_o,           --                    --  output,    wire [1-1:0] o_tx_ready
         i_tx_valid         => tx_mac_avst_s.valid,  --                    --   input,    wire [1-1:0] i_tx_valid
         i_tx_data          => tx_mac_avst_s.data,   --                     --   input,  wire [512-1:0] i_tx_data
         i_tx_error         => tx_mac_avst_s.err(0),    --                    --   input,    wire [1-1:0] i_tx_error
         i_tx_startofpacket => tx_mac_avst_s.sop,    --            --   input,    wire [1-1:0] i_tx_startofpacket
         i_tx_endofpacket   => tx_mac_avst_s.eop,    --              --   input,    wire [1-1:0] i_tx_endofpacket
         i_tx_empty         => tx_mac_avst_s.empty,  --                    --   input,    wire [6-1:0] i_tx_empty
         i_tx_skip_crc      => '0',                  --                 --   input,    wire [1-1:0] i_tx_skip_crc

         -- Rx
--    --use tx clock for syncronous clocking
         i_clk_rx           => eth_user_clk,         --                      --   input,    wire [1-1:0] clk
         o_rx_valid         => rx_mac_avst_s.valid,  --                    --  output,    wire [1-1:0] o_rx_valid
         o_rx_data          => rx_mac_avst_s.data,   --                     --  output,  wire [512-1:0] o_rx_data
         o_rx_startofpacket => rx_mac_avst_s.sop,    --            --  output,    wire [1-1:0] o_rx_startofpacket
         o_rx_endofpacket   => rx_mac_avst_s.eop,    --              --  output,    wire [1-1:0] o_rx_endofpacket
         o_rx_empty         => rx_mac_avst_s.empty,  --                    --  output,    wire [6-1:0] o_rx_empty
         o_rx_error         => rx_mac_avst_s.err,    --                    --  output,    wire [6-1:0] o_rx_error
         o_rxstatus_data    => open,
         o_rxstatus_valid   => open,


         -- TBD
         i_stats_snapshot => '0',                      --              --   input,    wire [1-1:0] i_stats_snapshot
         -- Pause interface. TBD
         i_tx_pfc         => (others => '0'), --                                      --   input,    wire [8-1:0] i_tx_pfc
         o_rx_pfc         => open,
         i_tx_pause       => '0',--(others => '0'), --                                      --   input,    wire [1-1:0] i_tx_pause
         o_rx_pause       => open                      --  output,    wire [1-1:0] o_rx_pause
      );

   end generate;

end architecture rtl;
