if {0} {
   unset native_phy_ip_params
}

set native_phy_ip_params [dict create]

dict set native_phy_ip_params profile_cnt "1"
set ::GLOBAL_corename eth_100g_nrz_xcvrnphy_fme_411_y5roe6q
# -------------------------------- #
# --- Default Profile settings --- #
# -------------------------------- #
dict set native_phy_ip_params pma_tx_data_rate_profile0 "25781.25"
dict set native_phy_ip_params pma_rx_data_rate_profile0 "25781.25"
dict set native_phy_ip_params duplex_mode_profile0 "duplex"
dict set native_phy_ip_params protocol_mode_profile0 "hundredg"
dict set native_phy_ip_params channels_profile0 "4"
dict set native_phy_ip_params aggregate_rsfec_enable_profile0 "1"
dict set native_phy_ip_params rcfg_enable_profile0 "1"
dict set native_phy_ip_params pma_tx_bonding_enable_profile0 "0"
dict set native_phy_ip_params pmaif_tx_width_profile0 "32"
dict set native_phy_ip_params pmaif_rx_width_profile0 "32"
dict set native_phy_ip_params pldif_tx_clkout_sel_profile0 "half-rate"
dict set native_phy_ip_params pldif_rx_clkout_sel_profile0 "half-rate"
dict set native_phy_ip_params enable_port_tx_clkout2_profile0 "1"
dict set native_phy_ip_params enable_port_rx_clkout2_profile0 "1"
dict set native_phy_ip_params pldif_tx_clkout2_sel_profile0 "div66"
dict set native_phy_ip_params pldif_rx_clkout2_sel_profile0 "div66"
dict set native_phy_ip_params pma_tx_pll_refclk_freq_mhz_profile0 "156.250000"
dict set native_phy_ip_params pma_tx_pll_post_divider_profile0 "1"
dict set native_phy_ip_params pma_rx_pll_refclk_freq_mhz_profile0 "156.250000"
dict set native_phy_ip_params pma_rx_pll_post_divider_profile0 "1"
dict set native_phy_ip_params pma_tx_clkdiv66_enable_profile0 "1"
dict set native_phy_ip_params pma_rx_clkdiv66_enable_profile0 "1"
dict set native_phy_ip_params pma_rx_clkfullrate_enable_profile0 "1"
dict set native_phy_ip_params pma_tx_modulation_profile0 "NRZ"
dict set native_phy_ip_params pma_rx_modulation_profile0 "NRZ"
dict set native_phy_ip_params pll_outclk_freq_mhz_profile0 "400"
