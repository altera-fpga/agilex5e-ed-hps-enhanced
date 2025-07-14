# (C) 2001-2023 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any output
# files from any of the foregoing (including device programming or simulation
# files), and any associated documentation or information are expressly subject
# to the terms and conditions of the Intel Program License Subscription
# Agreement, Intel FPGA IP License Agreement, or other applicable
# license agreement, including, without limitation, that your use is for the
# sole purpose of programming logic devices manufactured by Intel and sold by
# Intel or its authorized distributors.  Please refer to the applicable
# agreement for further details.


# ---------------------------------------------------------------- #
# -                                                              - #
# --- THIS IS AN AUTO-GENERATED FILE!                          --- #
# --- Do not change the contents of this file.                 --- #
# --- Your changes will be lost once the IP is regenerated!    --- #
# ---                                                          --- #
# --- This file contains the timing constraints for Native PHY --- #
# ---    * The helper functions are defined in                 --- #
# ---      alt_xcvr_native_helper_functions_y5roe6q.tcl  --- #
# -                                                              - #
# ---------------------------------------------------------------- #

set script_dir [file dirname [info script]]
set split_qsys_output_name [split eth_100g_nrz_xcvrnphy_fme_411_y5roe6q "_"]
set xcvr_nphy_index [lsearch $split_qsys_output_name "altera"]
if {$xcvr_nphy_index < 0} {
  set list_top_inst_name $split_qsys_output_name
} else {
  set list_top_inst_name [lreplace $split_qsys_output_name $xcvr_nphy_index end]
}
set top_inst_name [join $list_top_inst_name "_"]
source "${script_dir}/${top_inst_name}_ip_parameters_y5roe6q.tcl"
source "${script_dir}/alt_xcvr_native_helper_functions_y5roe6q.tcl"

# Debug switch. Change to 1 in alt_xcvr_native_helper_functions_y5roe6q.tcl to get more run-time debug information
if {![info exists native_debug]} {
  global ::native_debug
}

if {![info exists GLOBAL_corename]} {
  global ::GLOBAL_corename
}

# ---------------------------------------------------------------- #
# -                                                              - #
# --- Build cache for all pins and registers required to apply --- #
# --- timing constraints                                       --- #
# -                                                              - #
# ---------------------------------------------------------------- #
native_initialize_db_y5roe6q nativedb_y5roe6q

# ---------------------------------------------------------------- #
# --- Set all the instances of this core                       --- #
# ---------------------------------------------------------------- #
set alt_xcvr_native_s10_instances [ dict keys $nativedb_y5roe6q ]

if {[info exists alt_xcvr_native_s10_pins]} {
   unset alt_xcvr_native_s10_pins
}
set alt_xcvr_native_s10_pins [dict create]

# ---------------------------------------------------------------- #
# -                                                              - #
# --- Iterate through each instance and apply the necessary    --- #
# --- timing constraints                                       --- #
# -                                                              - #
# ---------------------------------------------------------------- #
foreach inst $alt_xcvr_native_s10_instances {

  if { [ dict exists $alt_xcvr_native_s10_pins $inst ] } {
    dict unset alt_xcvr_native_s10_pins $inst

    if { $native_debug == 1} {
      post_message -type info "IP SDC: Array pins for instance $inst existed before, unsetting them"
    }

  }
  dict set alt_xcvr_native_s10_pins $inst [dict get $nativedb_y5roe6q $inst]

  # Delete the clock names array if it exists
  if [info exists all_profile_clocks_names] {
    unset all_profile_clocks_names
  }
  set all_profile_clocks_names [dict create]

  # -------------------------------------------------------------- #
  # --- Iterate over the profiles                              --- #
  # -------------------------------------------------------------- #
  set profile_cnt [dict get $native_phy_ip_params profile_cnt]
  #--- Init adjacent channel timing arcs condition     --- #
  set tx_enabled_on_any_profile    0
  set rx_enabled_on_any_profile    0
  set max_num_channels             0
  #--- Init MAX_SKEW_VALUE for all profiles        --- #
  set reset_skew_ctrl_req 0
  set tx_transfer_clk_max_skew_value   200.0
  set rx_transfer_clk_max_skew_value   200.0

  for {set i 0} {$i < $profile_cnt} {incr i} {

    if {$native_debug == 1} {
      post_message -type info "========================================================================================"
      post_message -type info "IP SDC: PROFILE $i"
    }

    set num_channels  [dict get $native_phy_ip_params channels_profile$i]
    set max_num_channels  [expr { $num_channels > $max_num_channels? $num_channels : $max_num_channels} ]

    # ----------------------------------------------------------------------------- #
    # --- Set the selected clock from mux for tx/rx_clkout and tx/rx_clkout2    --- #
    # ----------------------------------------------------------------------------- #
    set tx_clkout_sel     [dict get $native_phy_ip_params pldif_tx_clkout_sel_profile$i]
    set enable_tx_clkout2 [dict get $native_phy_ip_params enable_port_tx_clkout2_profile$i]
    set tx_clkout2_sel    [dict get $native_phy_ip_params pldif_tx_clkout2_sel_profile$i]

    set rx_clkout_sel     [dict get $native_phy_ip_params pldif_rx_clkout_sel_profile$i]
    set enable_rx_clkout2 [dict get $native_phy_ip_params enable_port_rx_clkout2_profile$i]
    set rx_clkout2_sel    [dict get $native_phy_ip_params pldif_rx_clkout2_sel_profile$i]

    if {$native_debug == 1} {
      post_message -type info "========================================================================================"
      post_message -type info "IP SDC: Clock output of tx_clkout is $tx_clkout_sel"
      post_message -type info "IP SDC: Clock output of tx_clkout2 is $tx_clkout2_sel"
      post_message -type info "IP SDC: Clock output of rx_clkout is $rx_clkout_sel"
      post_message -type info "IP SDC: Clock output of rx_clkout2 is $rx_clkout2_sel"
    }

    # ------------------------------------------------------------------------------ #
    # --- Determine the datapath based on the selected protocol mode             --- #
    # ------------------------------------------------------------------------------ #
    set protocol_mode [dict get $native_phy_ip_params protocol_mode_profile$i]
    set duplex_mode   [dict get $native_phy_ip_params duplex_mode_profile$i]

    if { $duplex_mode == "duplex" || $duplex_mode == "tx" || $duplex_mode == "rx" } {
      set tx_enable 1
    } else {
      set tx_enable 0
    }

    if { $duplex_mode == "duplex" || $duplex_mode == "rx" || $duplex_mode == "tx"} {
      set rx_enable 1
    } else {
      set rx_enable 0
    }

    # ----------------------------------------------------------------------------- #
    # --- Determine the SerDes factor (PMA interface width)                     --- #
    # ----------------------------------------------------------------------------- #
    set tx_pma_if_width [dict get $native_phy_ip_params pmaif_tx_width_profile$i]
    set rx_pma_if_width [dict get $native_phy_ip_params pmaif_rx_width_profile$i]

    # ----------------------------------------------------------------------------- #
    # --- Determine the PMA modulation encoding                                 --- #
    # ----------------------------------------------------------------------------- #
    set tx_pma_modulation [dict get $native_phy_ip_params pma_tx_modulation_profile$i]
    set rx_pma_modulation [dict get $native_phy_ip_params pma_rx_modulation_profile$i]

    # ----------------------------------------------------------------------------- #
    # --- Determine the refclk frequency                                        --- #
    # ----------------------------------------------------------------------------- #
    set tx_pll_refclk_freq [dict get $native_phy_ip_params pma_tx_pll_refclk_freq_mhz_profile$i]
    set rx_pll_refclk_freq [dict get $native_phy_ip_params pma_rx_pll_refclk_freq_mhz_profile$i]

    # ----------------------------------------------------------------------------- #
    # --- Calculate the parallel PMA clock frequency                            --- #
    # ----------------------------------------------------------------------------- #
    set tx_data_rate [ expr double([dict get $native_phy_ip_params pma_tx_data_rate_profile$i]) ]
    set rx_data_rate [ expr double([dict get $native_phy_ip_params pma_rx_data_rate_profile$i]) ]

    set tx_pma_parallel_freq [ expr double($tx_data_rate / $tx_pma_if_width) ]
    set rx_pma_parallel_freq [ expr double($rx_data_rate / $rx_pma_if_width) ]

    set tx_transfer_clk_freq $tx_pma_parallel_freq
    set rx_transfer_clk_freq $rx_pma_parallel_freq

    # ----------------------------------------------------------------------------- #
    # --- Determine the post PLL divider factor and PLL frequency               --- #
    # ----------------------------------------------------------------------------- #
    set tx_pll_post_divide_factor [dict get $native_phy_ip_params pma_tx_pll_post_divider_profile$i]
    set rx_pll_post_divide_factor [dict get $native_phy_ip_params pma_rx_pll_post_divider_profile$i]

    set tx_pll_freq [dict get $native_phy_ip_params pll_outclk_freq_mhz_profile$i]
    set rx_pll_freq [dict get $native_phy_ip_params pll_outclk_freq_mhz_profile$i]

    set tx_clkdiv66_enable [dict get $native_phy_ip_params pma_tx_clkdiv66_enable_profile$i]
    set rx_clkdiv66_enable [dict get $native_phy_ip_params pma_rx_clkdiv66_enable_profile$i]

    # ----------------------------------------------------------------------------- #
    # --- Calculate the PLD PCS clock frequency                                --- #
    # ----------------------------------------------------------------------------- #
    set tx_pld_pcs_clk_freq [expr ($tx_pma_parallel_freq / 2)]
    set rx_pld_pcs_clk_freq [expr ($rx_pma_parallel_freq / 2)]

    # ----------------------------------------------------------------------------- #
    # --- Calculate the PLD PMA CLKDIV clock frequency                                --- #
    # ----------------------------------------------------------------------------- #
    set tx_pld_pma_clkdiv_clk_freq [expr ($tx_data_rate / 66)]
    set rx_pld_pma_clkdiv_clk_freq [expr ($rx_data_rate / 66)]

    # ----------------------------------------------------------------------------- #
    # --- Initialize variables for clock uncertainty from DCC circuit           --- #
    # ----------------------------------------------------------------------------- #
    set tx_clkout_dcc_uncertainty_percent  0
    set tx_clkout2_dcc_uncertainty_percent 0
    set rx_clkout_dcc_uncertainty_percent  0
    set rx_clkout2_dcc_uncertainty_percent 0

    # ----------------------------------------------------------------------------- #
    # --- Print out the IP parameters when debug is enabled                     --- #
    # ----------------------------------------------------------------------------- #
    if {$native_debug == 1} {
      post_message -type info "IP SDC: The procotol mode is $protocol_mode"
      post_message -type info "IP SDC: The duplex mode is $duplex_mode"
      post_message -type info "IP SDC: The TX PMA interface width is $tx_pma_if_width"
      post_message -type info "IP SDC: The RX PMA interface width is $rx_pma_if_width"
      post_message -type info "IP SDC: The TX PMA modulation $tx_pma_modulation"
      post_message -type info "IP SDC: The RX PMA modulation $rx_pma_modulation"
      post_message -type info "IP SDC: The TX data rate is $tx_data_rate Mbps."
      post_message -type info "IP SDC: The RX data rate is $rx_data_rate Mbps."
      post_message -type info "IP SDC: TX PMA parallel CLK is $tx_pma_parallel_freq MHz"
      post_message -type info "IP SDC: RX PMA parallel CLK is $tx_pma_parallel_freq MHz"
      post_message -type info "IP SDC: TX PLD PCS CLK is $tx_pld_pcs_clk_freq MHz"
      post_message -type info "IP SDC: RX PLD PCS CLK is $tx_pld_pcs_clk_freq MHz"
      post_message -type info "IP SDC: TX PLD PMA CLKDIV CLK is $tx_pld_pma_clkdiv_clk_freq MHz"
      post_message -type info "IP SDC: RX PLD PMA CLKDIV CLK is $rx_pld_pma_clkdiv_clk_freq MHz"
      post_message -type info "IP SDC: Clock output of TX transfer clock is $tx_transfer_clk_freq MHz"
      post_message -type info "IP SDC: Clock output of RX transfer clock is $rx_transfer_clk_freq MHz"
      post_message -type info "IP SDC: TX PLL reference clock frequency $tx_pll_refclk_freq MHz."
      post_message -type info "IP SDC: RX PLL reference clock frequency $rx_pll_refclk_freq MHz."
      post_message -type info "IP SDC: TX PLL post divider $tx_pll_post_divide_factor."
      post_message -type info "IP SDC: RX PLL post divider $rx_pll_post_divide_factor."
      post_message -type info "IP SDC: TX PLL frequency $tx_pll_freq."
      post_message -type info "IP SDC: RX PLL frequency $rx_pll_freq."
      post_message -type info "IP SDC: TX CLKDIV66 enable is $tx_clkdiv66_enable."
      post_message -type info "IP SDC: RX CLKDIV66 enable is $rx_clkdiv66_enable."
    }

    # ----------------------------------------------------------------------------- #
    # --- Unset the profile_clocks dictionary if it exists                      --- #
    # ----------------------------------------------------------------------------- #
    if [info exists profile_clocks] {
      unset profile_clocks
    }
    set profile_clocks [dict create]

    if {[info exists freq] } {
      unset freq
    }
    set freq [dict create]

    if {[info exists multiply_factor_dict] } {
      unset multiply_factor_dict
    }
    set multiply_factor_dict [dict create]

    if {[info exists divide_factor_dict] } {
      unset divide_factor_dict
    }
    set divide_factor_dict [dict create]

    if {[info exists duty_cycle_dict] } {
      unset duty_cycle_dict
    }
    set duty_cycle_dict [dict create]


    # ----------------------------------------------------------------------------- #
    # --- Create TX mode clocks and clock frequencies                           --- #
    # ----------------------------------------------------------------------------- #
    # For each TX clock output (tx_clkout and tx_clkout2), the selected clock from
    # main adapter clock mux is checked.
    #
    # 1. FULL-RATE : Full-rate clock on core adapter
    #      - This clock is driven by TX PMA clock from Crete
    #      - Frequency = TX PMA parallel clock = (TX datarate) / (PMA TX width)
    #
    # 2. HALF-RATE : Half-rate clock on core adapter
    #      - This clock is driven by the div-2 version of TX PMA clock from Crete
    #      - Frequency = (TX PMA parallel clock) / 2
    #
    # 3. DIV66 : 66 clock on core adapter
    #      - This clock is driven by TX PMA /66 clock from the Crete
    #      - NRZ: Frequency = (TX datarate) / 66
    #      - PAM4: Frequency = (TX datarate) / 132
    #
    # 4. REFCLK : //refclk feature is not fully implemented as it was dropped from plans//
    #             reference clock drives to core (PLL in SerDes PMA is disabled)
    #             - Frequency = TX refclk frequency
    #
    # 5. PLL : SerDes PLL (TX PLL) functions as core PLL
    #      - No data transfer is expected in this mode and hence SerDes buffer and
    #       data path along the channel will be disabled
    #      - Frequency = Full-rate clock frequency for TX_CLKOUT
    #                    Half-rate clock frequency for TX_CLKOUT2
    # ----------------------------------------------------------------------------- #

    if { $tx_enable == 1 } {

      set tx_enabled_on_any_profile   1

      # -------------------------------------------------------------------------------
      # AIB TX CLK SOURCE - Determine if it is PMA parallel clock, refclk, or TX PLL
      # -------------------------------------------------------------------------------
      dict set profile_clocks tx_source_clks tx_pma_parallel_clk
      if { $protocol_mode == "pll" } {
        dict set freq tx_pma_parallel_clk $tx_pll_freq
      } elseif { $protocol_mode == "refclk" } {
        dict set freq tx_pma_parallel_clk $tx_pll_refclk_freq
      } else {
        dict set freq tx_pma_parallel_clk $tx_pma_parallel_freq
      }

      # -------------------------------------------------------------------------------
      # AIB TX INTERNAL DIV REG - transfer clock
      # For PLL mode, set transfer clock to PLL clock
      # -------------------------------------------------------------------------------
      dict set profile_clocks tx_internal_div_reg_clks tx_transfer_clk
      if { $protocol_mode == "pll" } {
        dict set freq tx_transfer_clk $tx_pll_freq
      } else {
        dict set freq tx_transfer_clk $tx_pma_parallel_freq
      }


        dict set multiply_factor_dict tx_transfer_clk 1
        dict set divide_factor_dict   tx_transfer_clk 1

     # -------------------------------------------------------------------------------
      # PLD PCS TX CLK
      # -------------------------------------------------------------------------------
      dict set profile_clocks tx_pcs_clks tx_pld_pcs_clk
      if {$protocol_mode == "pll" } {
         dict set freq tx_pld_pcs_clk $tx_pll_freq
      } else {
         dict set freq tx_pld_pcs_clk $tx_pld_pcs_clk_freq
      }


     # -------------------------------------------------------------------------------
      # PLD PCS TX CLK REG
      # -------------------------------------------------------------------------------
      dict set profile_clocks tx_pcs_reg_clks tx_pld_pcs_clk_reg

        dict set multiply_factor_dict tx_pld_pcs_clk_reg 1
        dict set divide_factor_dict   tx_pld_pcs_clk_reg 1


      # -------------------------------------------------------------------------------
      # PLD PMA TX CLKDIV CLK
      # -------------------------------------------------------------------------------
      dict set profile_clocks tx_clkdiv_clks tx_pld_pma_clkdiv_clk
      if {$protocol_mode == "pll" } {
         dict set freq tx_pld_pma_clkdiv_clk $tx_pll_freq
      } else {
         dict set freq tx_pld_pma_clkdiv_clk $tx_pld_pma_clkdiv_clk_freq

      }

      # -------------------------------------------------------------------------------
      # PLD PMA TX CLKDIV CLK REG
      # -------------------------------------------------------------------------------
      dict set profile_clocks tx_clkdiv_reg_clks tx_pld_pma_clkdiv_clk_reg

        dict set multiply_factor_dict tx_pld_pma_clkdiv_clk_reg 1
        dict set divide_factor_dict   tx_pld_pma_clkdiv_clk_reg 1

      # -------------------------------------------------------------------------------
      # TX_CLKOUT - output clocks
      # -------------------------------------------------------------------------------
      if { $protocol_mode == "pll" } {
        dict set profile_clocks       tx_mode_clkout1_clks tx_clkout
        #For PLL mode, TX CLK OUT, set multiply factor and divide factor to 1
        dict set multiply_factor_dict tx_clkout 1
        dict set divide_factor_dict   tx_clkout 1

      } elseif { $tx_clkout_sel == "full-rate" } {
        dict set profile_clocks       tx_mode_clkout1_clks tx_clkout
        dict set multiply_factor_dict tx_clkout 1
        dict set divide_factor_dict   tx_clkout 1

      } elseif { $tx_clkout_sel == "half-rate" } {

        # Half-rate clock is not valid for PMA-direct Refclk Channel Mode
        if { $protocol_mode == "refclk" } {
          post_message -type error "IP SDC: Half-rate clock is not a valid clock option in PMA-direct Refclk Channel Mode. Check the TX Clock Options."
        } else {
          dict set profile_clocks       tx_mode_clkout1_clks tx_clkout
          dict set multiply_factor_dict tx_clkout 1
          dict set divide_factor_dict   tx_clkout 1
        }

      } elseif { $tx_clkout_sel == "div66" } {

        if { $tx_clkdiv66_enable == 0 } {
          post_message -type error "IP SDC: TX CLKDIV66 must be enabled to use div66 clock option. Check the TX PMA options."
        } else {

          dict set profile_clocks tx_mode_clkout1_clks tx_clkout

          # Check is protocol mode is PMA-direct refclk
          if { $protocol_mode == "refclk" } {

            dict set multiply_factor_dict tx_clkout 1
            dict set divide_factor_dict   tx_clkout 1

          } else {

            # Check TX modulation (div factor is different between NRZ and PAM4)
            if { $tx_pma_modulation == "PAM4" } {
              dict set multiply_factor_dict tx_clkout 1
              dict set divide_factor_dict   tx_clkout 2
            } else {
              dict set multiply_factor_dict tx_clkout 1
              dict set divide_factor_dict   tx_clkout 1
            }

          }
        }
      } else {
        post_message -type error "IP SDC: TX CLKOUT did not match any of the valid clock options. Check the TX Clock Options."
      }

      # -------------------------------------------------------------------------------
      # TX_CLKOUT2 - output clocks
      # -------------------------------------------------------------------------------
      if { $protocol_mode == "pll" } {
          dict set profile_clocks  tx_mode_clkout2_clks tx_clkout2
          #For PLL mode, TX CLK OUT2, set multiply factor to 1, divide factor to 2
          dict set multiply_factor_dict tx_clkout2 1
          dict set divide_factor_dict   tx_clkout2 2

        } elseif { $enable_tx_clkout2 == 1 } {

         if {$tx_clkout2_sel == "full-rate" } {
          dict set profile_clocks   tx_mode_clkout2_clks tx_clkout2
          dict set multiply_factor_dict tx_clkout2 1
          dict set divide_factor_dict   tx_clkout2 1

        } elseif {$tx_clkout2_sel == "half-rate" } {

          # Half-rate clock is not valid for PMA-direct Refclk Channel Mode
          if { $protocol_mode == "refclk" } {
            post_message -type error "IP SDC: Half-rate clock is not a valid clock option in PMA-direct Refclk Channel Mode. Check the TX Clock Options."
          } else {
            dict set profile_clocks   tx_mode_clkout2_clks tx_clkout2
            dict set multiply_factor_dict tx_clkout2 1
            dict set divide_factor_dict   tx_clkout2 2
          }

        } elseif {$tx_clkout2_sel == "div66" } {

          if { $tx_clkdiv66_enable == 0 } {
            post_message -type error "IP SDC: TX CLKDIV66 must be enabled to use div66 clock option. Check the TX PMA options."
          } else {

            dict set profile_clocks tx_mode_clkout2_clks tx_clkout2

            # Check is protocol mode is PMA-direct refclk
            if { $protocol_mode == "refclk" } {

                dict set multiply_factor_dict tx_clkout2 1
                dict set divide_factor_dict   tx_clkout2 1

            } else {

              # Check TX modulation (div factor is different between NRZ and PAM4)
              if { $tx_pma_modulation == "PAM4" } {
                dict set multiply_factor_dict tx_clkout2 1
                dict set divide_factor_dict   tx_clkout2 2
              } else {
                dict set multiply_factor_dict tx_clkout2 1
                dict set divide_factor_dict   tx_clkout2 1
              }
            }
          }
        } else {
          post_message -type error "IP SDC: TX CLKOUT2 did not match any of the valid clock options. Check the TX Clock Options."
        }

      } else {
        if {$native_debug == 1} {
          post_message -type info "IP SDC: TX CLKOUT2 port is not enabled"
        }
      }
    } ; # if tx_enable_profile

    # ----------------------------------------------------------------------------- #
    # --- Create RX mode clocks and clock frequencies                           --- #
    # ----------------------------------------------------------------------------- #
    # For each RX clock output (rx_clkout and rx_clkout2), the selected clock from
    # main adapter clock mux is checked.
    #
    # 1. FULL-RATE : Full-rate clock on core adapter
    #      - This clock is driven by RX PMA clock from Crete
    #      - Frequency is RX PMA parallel clock = (RX datarate) / (PMA RX width)
    #
    # 2. HALF-RATE : Half-rate clock on core adapter
    #      - This clock is driven by the div-2 version of RX PMA clock from Crete
    #      - Frequency is (RX PMA parallel clock) / 2
    #
    # 3. DIV66 : 66 clock on core adapter
    #     - This clock is driven by RX PMA /66 clock from the Crete
    #     - NRZ: Frequency is (RX datarate) / 66
    #     - PAM4: Frequency = (RX datarate) / 132
    #
    # 4. REFCLK : //refclk feature is not fully implemented as it was dropped from plans//
    #       reference clock drives to core (PLL in SerDes PMA is disabled)
    #      - Frequency = RX refclk frequency
    #
    # 5. PLL : RX output clock ports are terminated in PLL mode
    # ----------------------------------------------------------------------------- #

    if { $rx_enable == 1 } {

      set rx_enabled_on_any_profile   1
      # -------------------------------------------------------------------------------
      # AIB RX CLK SOURCE - PMA parallel clock
      # -------------------------------------------------------------------------------
      if { $protocol_mode == "refclk" } {
        dict set profile_clocks rx_source_clks rx_reclk_source_clk
        dict set freq rx_pma_parallel_clk $rx_pll_refclk_freq
      } else {
        dict set profile_clocks rx_source_clks rx_pma_parallel_clk
        dict set freq rx_pma_parallel_clk $rx_pma_parallel_freq
      }

      # -------------------------------------------------------------------------------
      # AIB RX INTERNAL DIV REG - transfer clock
      # -------------------------------------------------------------------------------
      dict set profile_clocks rx_internal_div_reg_clks rx_transfer_clk

      dict set multiply_factor_dict rx_transfer_clk 1
      dict set divide_factor_dict   rx_transfer_clk 1

      # -------------------------------------------------------------------------------
      # PLD PCS RX CLK
      # -------------------------------------------------------------------------------
      dict set profile_clocks rx_pcs_clks rx_pld_pcs_clk
      dict set freq rx_pld_pcs_clk $rx_pld_pcs_clk_freq

      # -------------------------------------------------------------------------------
      # PLD PCS RX CLK REG
      # -------------------------------------------------------------------------------
      dict set profile_clocks rx_pcs_reg_clks rx_pld_pcs_clk_reg

        dict set multiply_factor_dict rx_pld_pcs_clk_reg 1
        dict set divide_factor_dict   rx_pld_pcs_clk_reg 1


      # -------------------------------------------------------------------------------
      # PLD PMA RX CLKDIV CLK
      # -------------------------------------------------------------------------------
      dict set profile_clocks rx_clkdiv_clks rx_pld_pma_clkdiv_clk
      dict set freq rx_pld_pma_clkdiv_clk $rx_pld_pma_clkdiv_clk_freq

      # -------------------------------------------------------------------------------
      # PLD PMA RX CLKDIV CLK REG
      # -------------------------------------------------------------------------------
      dict set profile_clocks rx_clkdiv_reg_clks rx_pld_pma_clkdiv_clk_reg

        dict set multiply_factor_dict rx_pld_pma_clkdiv_clk_reg 1
        dict set divide_factor_dict   rx_pld_pma_clkdiv_clk_reg 1

      # -------------------------------------------------------------------------------
      # RX_CLKOUT - output clocks
      # -------------------------------------------------------------------------------
      if { $protocol_mode != "pll" } {
        if { $rx_clkout_sel == "full-rate" } {
          dict set profile_clocks       rx_mode_clkout1_clks rx_clkout
          dict set multiply_factor_dict rx_clkout 1
          dict set divide_factor_dict   rx_clkout 1

        } elseif { $rx_clkout_sel == "half-rate" } {

          # Half-rate clock is not valid for PMA-direct Refclk Channel Mode
          if { $protocol_mode == "refclk" } {
            post_message -type error "IP SDC: Half-rate clock is not a valid clock option in PMA-direct Refclk Channel Mode. Check the RX Clock Options."
          } else {
            dict set profile_clocks       rx_mode_clkout1_clks rx_clkout
            dict set multiply_factor_dict rx_clkout 1
            dict set divide_factor_dict   rx_clkout 1
          }

        } elseif { $rx_clkout_sel == "div66" } {

          if { $rx_clkdiv66_enable == 0 } {
            post_message -type error "IP SDC: RX CLKDIV66 must be enabled to use div66 clock option. Check the RX PMA options."
          } else {

            dict set profile_clocks       rx_mode_clkout1_clks rx_clkout

            # Check is protocol mode is PMA-direct refclk
            if { $protocol_mode == "refclk" } {

              dict set multiply_factor_dict rx_clkout 1
              dict set divide_factor_dict   rx_clkout 1

            } else {

              # Check RX modulation (div factor is different between NRZ and PAM4)
              if { $rx_pma_modulation == "PAM4" } {
                dict set multiply_factor_dict rx_clkout 1
                dict set divide_factor_dict   rx_clkout 2
              } else {
                dict set multiply_factor_dict rx_clkout 1
                dict set divide_factor_dict   rx_clkout 1
              }

            }
          }
        } else {
          post_message -type error "IP SDC: RX CLKOUT did not match any of the valid clock options. Check the RX Clock Options."
        }
      }

      # -------------------------------------------------------------------------------
      # RX_CLKOUT2 - output clocks
      # -------------------------------------------------------------------------------
      if { $enable_rx_clkout2 == 1 && $protocol_mode != "pll"} {

        if {$rx_clkout2_sel == "full-rate" } {
          dict set profile_clocks   rx_mode_clkout2_clks rx_clkout2
          dict set multiply_factor_dict rx_clkout2 1
          dict set divide_factor_dict   rx_clkout2 1

        } elseif {$rx_clkout2_sel == "half-rate" } {

          # Half-rate clock is not valid for PMA-direct Refclk Channel Mode
          if { $protocol_mode == "refclk" } {
            post_message -type error "IP SDC: Half-rate clock is not a valid clock option in PMA-direct Refclk Channel Mode. Check the RX Clock Options."
          } else {
            dict set profile_clocks   rx_mode_clkout2_clks rx_clkout2
            dict set multiply_factor_dict rx_clkout2 1
            dict set divide_factor_dict   rx_clkout2 1
          }

        } elseif {$rx_clkout2_sel == "div66" } {

          if { $rx_clkdiv66_enable == 0 } {
            post_message -type error "IP SDC: TX CLKDIV66 must be enabled to use div66 clock option. Check the RX PMA options."
          } else {

            dict set profile_clocks   rx_mode_clkout2_clks rx_clkout2

            # Check is protocol mode is PMA-direct refclk
            if { $protocol_mode == "refclk" } {

                dict set multiply_factor_dict rx_clkout2 1
                dict set divide_factor_dict   rx_clkout2 1

            } else {

              # Check RX modulation (div factor is different between NRZ and PAM4)
              if { $rx_pma_modulation == "PAM4" } {
                dict set multiply_factor_dict rx_clkout2 1
                dict set divide_factor_dict   rx_clkout2 2
              } else {
                dict set multiply_factor_dict rx_clkout2 1
                dict set divide_factor_dict   rx_clkout2 1
              }

            }
          }
        } else {
          post_message -type error "IP SDC: RX CLKOUT2 did not match any of the valid clock options. Check the RX Clock Options"
        }
      } else {
        if {$native_debug == 1} {
          post_message -type info "IP SDC: RX CLKOUT2 port is not enabled"
        }
      }
    } ; # if rx_enable_profile

    # Set dl_pulse clock in 1st profile
    if { $i == 0 } {
       dict lappend profile_clocks   dl_clks rx_dl_pulse
       dict set freq rx_dl_pulse 100.000
       dict lappend profile_clocks   dl_clks tx_dl_pulse
       dict set freq tx_dl_pulse 100.000
     }

   # add for FM clocks
       dict set profile_clocks  pld_pma_hclks pld_pma_hclk
       dict set freq  pld_pma_hclk 100.000

       dict set profile_clocks  pld_pma_reg_hclks pld_pma_hclk_reg
       dict set multiply_factor_dict  pld_pma_hclk_reg 1
       dict set divide_factor_dict    pld_pma_hclk_reg 1



    if { $native_debug == 1 } {
      dict for {key clocks} $profile_clocks {
        post_message -type info "IP SDC: Profile Clocks are $key: $clocks"
      }
    }

    # ----------------------------------------------------------------------------- #
    # --- Round the clock frequencies to 6 decimal places or less               --- #
    # ----------------------------------------------------------------------------- #
    dict for {clk freq_clk} $freq {
      dict set freq $clk [expr (round($freq_clk*1000000)/1000000.0)]
    }

    # ----------------------------------------------------------------------------- #
    # --- Create clocks for each mode                                           --- #
    # ----------------------------------------------------------------------------- #
    if {$native_debug == 1} {
      post_message -type info "========================================================================================"
      post_message -type info "IP SDC: Creating HSSI clocks for each channel"
    }

    dict for {mode mode_clks} $profile_clocks {
      set list_of_clk_names [list]

      if {$native_debug == 1} {
        post_message -type info "----------------------------------------------------------------------------------------"
        post_message -type info "IP SDC: Creating HSSI clocks for each channel in $mode group"
      }

      set list_of_clk_names [native_prepare_to_create_clocks_all_ch_y5roe6q $inst $num_channels $mode $mode_clks $profile_cnt $i $alt_xcvr_native_s10_pins $freq $multiply_factor_dict $divide_factor_dict $duty_cycle_dict $all_profile_clocks_names $tx_clkout_sel $tx_clkout2_sel $rx_clkout_sel $rx_clkout2_sel $protocol_mode]
      dict set all_profile_clocks_names $i $mode [join [lsort -dictionary $list_of_clk_names]]

      if {$native_debug == 1} {
        post_message -type info "IP SDC: All Profile $i clocks for $mode: [dict get $all_profile_clocks_names $i $mode]"
      }
    } ; # dict for {mode mode_clks}


    #--------------------------------------------- #
    #---                                       --- #
    #--- MAX_SKEW_VALUE FOR BONDED MODE        --- #
    #---                                       --- #
    #--------------------------------------------- #
    if {[dict get $native_phy_ip_params pma_tx_bonding_enable_profile$i] || [dict get $native_phy_ip_params aggregate_rsfec_enable_profile$i] || [dict get $native_phy_ip_params protocol_mode_profile$i] == "pma_direct_dc" } {
      if { $native_debug } {
        post_message -type info "========================================================================================"
        post_message -type info "IP SDC: Setting max skew constraints for xcvrif and aib resets in PMA-PCS bonded mode"
      }
      set reset_skew_ctrl_req 1

      # PMA resets need one transfer clock period
      # Adapter resets need one PMA parallel clock period, transfer clcok is pma parallel clock in etile
      set tx_transfer_clk_max_skew_prof  [expr (1000/$tx_transfer_clk_freq - 0.1) ]
      set rx_transfer_clk_max_skew_prof  [expr (1000/$rx_transfer_clk_freq - 0.1) ]

      # Round the clock frequencies to 6 decimal places or less; assign the mins to variables
      set tx_transfer_clk_max_skew_prof  [expr (int($tx_transfer_clk_max_skew_prof*1000)/1000.0)]
      if { $tx_transfer_clk_max_skew_prof < $tx_transfer_clk_max_skew_value } {
         if {$tx_transfer_clk_max_skew_prof < 2} {
             set tx_transfer_clk_max_skew_value 2
          } else {
             set tx_transfer_clk_max_skew_value $tx_transfer_clk_max_skew_prof
          }
      }
      set rx_transfer_clk_max_skew_prof  [expr (int($rx_transfer_clk_max_skew_prof*1000)/1000.0)]
      if { $rx_transfer_clk_max_skew_prof < $rx_transfer_clk_max_skew_value } {
        if {$rx_transfer_clk_max_skew_prof < 2} {
             set rx_transfer_clk_max_skew_value 2
          } else {
             set rx_transfer_clk_max_skew_value $rx_transfer_clk_max_skew_prof
          }
      }


    }



    #-------------------------------------------------- #
    #---                                            --- #
    #--- DISABLE MIN_PULSE_WIDTH CHECK              --- #
    #---                                            --- #
    #-------------------------------------------------- #
    # Disable min_pulse_width for TX and hclk source clocks
    set tx_source_clks_list [list]
    if {[dict exists $all_profile_clocks_names $i tx_source_clks]} {
      set tx_source_clks_list [dict get $all_profile_clocks_names $i tx_source_clks]
    }
    if {[dict exists $all_profile_clocks_names $i tx_pcs_clks]} {
      set tx_source_clks_list [concat $tx_source_clks_list  [dict get $all_profile_clocks_names $i tx_pcs_clks]]
    }
    if {[dict exists $all_profile_clocks_names $i tx_clkdiv_clks]} {
      set tx_source_clks_list [concat $tx_source_clks_list  [dict get $all_profile_clocks_names $i tx_clkdiv_clks]]
    }
    if {[dict exists $all_profile_clocks_names $i pld_pma_hclks]} {
      set tx_source_clks_list [concat $tx_source_clks_list  [dict get $all_profile_clocks_names $i pld_pma_hclks]]
    }

    foreach tx_src_clk $tx_source_clks_list {
      disable_min_pulse_width $tx_src_clk
    }

    # Disable min_pulse_width for RX source clocks
    set rx_source_clks_list [list]
    if {[dict exists $all_profile_clocks_names $i rx_source_clks]} {
      set rx_source_clks_list [dict get $all_profile_clocks_names $i rx_source_clks]
    }
    if {[dict exists $all_profile_clocks_names $i rx_pcs_clks]} {
      set rx_source_clks_list [concat $rx_source_clks_list  [dict get $all_profile_clocks_names $i rx_pcs_clks]]
    }
    if {[dict exists $all_profile_clocks_names $i rx_clkdiv_clks]} {
      set rx_source_clks_list [concat $rx_source_clks_list  [dict get $all_profile_clocks_names $i rx_clkdiv_clks]]
    }

    foreach rx_src_clk $rx_source_clks_list {
      disable_min_pulse_width $rx_src_clk
    }

    # Disable min_pulse_width for particular failed path of tx_transfer_clk when it's not being used or tx_transfer_clk is running at very high freq(basically the condition is tx_transfer_clk isn't being sent out)
    set tx_transfer_clk_target_regs [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_aibnd_tx~aib_fabric_tx_transfer_clk.reg]
     if {[get_collection_size $tx_transfer_clk_target_regs] > 0} {
      if {$tx_clkout_sel != "full-rate" || ($enable_tx_clkout2 == 1 && $tx_clkout2_sel != "full-rate") } {
             disable_min_pulse_width $tx_transfer_clk_target_regs
       }
     }

  } ; # foreach profile

  #--------------------------------------------- #
  #---                                       --- #
  #--- Adjusting the min pulse width for     --- #
  #--- coreclkin2 requirement to be          --- #
  #--- frequency-dependent                   --- #
  #---                                       --- #
  #--------------------------------------------- #

  # Create dictionary of all the clocks and their nodes
  set min_pulse_all_clocks_list [all_clocks]
  set min_pulse_all_clocks_nodes_dict [dict create]

  foreach_in_collection clk $min_pulse_all_clocks_list {
    set clk_name [get_clock_info -name $clk]
    # Check if clock is declared, but NOT defined (i.e. create_clock or create_generated_clock has NOT been used yet)
    if { [is_clock_defined $clk_name] == 1 } {
      set clk_node_col [get_clock_info -targets $clk_name]

      foreach_in_collection clk_node $clk_node_col {
        set clk_node_name [get_node_info -name $clk_node]
        dict set min_pulse_all_clocks_nodes_dict $clk_node_name $clk_name
      }
    }
  }

  # -------------------------------------------------------------------------------
  # TX coreclkin2
  # -------------------------------------------------------------------------------
  set tx_coreclkin2_col [get_pins -nowarn -compat g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_tx_clk2_dcm]

  # Get fanins for tx_coreclkin2
  if {[get_collection_size $tx_coreclkin2_col] > 0} {
    set tx_coreclkin_fanin_col [get_fanins -clock -stop_at_clocks $tx_coreclkin2_col]

    # Find clock name on the fanin
    if {[get_collection_size $tx_coreclkin_fanin_col]} {

      foreach_in_collection fanin_node $tx_coreclkin_fanin_col {
        set fanin_node_name [get_node_info -name $fanin_node]

        if {[dict exists $min_pulse_all_clocks_nodes_dict $fanin_node_name]} {
          set fanin_clock_name [dict get $min_pulse_all_clocks_nodes_dict $fanin_node_name]
          set_active_clocks [remove_from_collection [get_active_clocks] [get_clocks $fanin_clock_name]]

          # Remap any backward slashes '' in the pins
          set fanin_clock_name [string map {\\ \\\\} $fanin_clock_name]

          # Adjust the min pulse width requirement based on frequency
          add_ddr_report_command "native_check_special_min_pulse_y5roe6q $fanin_clock_name"
        }
      }
    }
  }


  # -------------------------------------------------------------------------------
  # RX coreclkin2
  # -------------------------------------------------------------------------------
  set rx_coreclkin2_col [get_pins -nowarn -compat g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_rx_clk2_dcm]

  # Get fanins for rx_coreclkin2
  if {[get_collection_size $rx_coreclkin2_col] > 0} {
    set rx_coreclkin_fanin_col [get_fanins -clock -stop_at_clocks $rx_coreclkin2_col]

    # Find clock name on the fanin
    if {[get_collection_size $rx_coreclkin_fanin_col]} {

      foreach_in_collection fanin_node $rx_coreclkin_fanin_col {
        set fanin_node_name [get_node_info -name $fanin_node]

	if {[dict exists $min_pulse_all_clocks_nodes_dict $fanin_node_name]} {
	  set fanin_clock_name [dict get $min_pulse_all_clocks_nodes_dict $fanin_node_name]
          set_active_clocks [remove_from_collection [get_active_clocks] [get_clocks $fanin_clock_name]]

          # Remap any backward slashes '' in the pins
          set fanin_clock_name [string map {\\ \\\\} $fanin_clock_name]

          # Adjust the min pulse width requirement based on frequency
          add_ddr_report_command "native_check_special_min_pulse_y5roe6q $fanin_clock_name"
        }
      }
    }
  }


  #--------------------------------------------- #
  #---                                       --- #
  #--- MAX_SKEW on RESETS FOR BONDED MODE    --- #
  #---                                       --- #
  #--------------------------------------------- #
  if ($reset_skew_ctrl_req)  {
      # -------------------------------------------------------------------------------
      # TX set_max_skew
      # -------------------------------------------------------------------------------
      # Set max skew constraint for TX xcvrif and aib resets when bonded

      set tx_xcvrif_reset_reg_col         [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_seq|xcvrif_reset_out_stage*]
      set tx_aib_reset_out_stage_reg_col  [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_seq|aib_reset_out_stage*]
      set tx_transfer_clk_reg_col         [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~*aib_fabric_tx_transfer_clk.reg]
      set tx_pld_adapter_tx_pld_rst_n_col [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n]
      set tx_pld_pma_txpma_rstb_col       [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pma_txpma_rstb]

      set tx_pld_pma_latch_clk            [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~*aib_fabric_pma_aib_tx_clk.reg]
      set tx_pld_dcm_latch_clk            [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~*pld_tx_clk1_dcm.reg]

      # TX xcvrif
      set  tx_pld_pma_reset_max_skew_value  [expr  $tx_transfer_clk_max_skew_value - 0.4]
      if {[get_collection_size $tx_xcvrif_reset_reg_col] > 0 && [get_collection_size $tx_transfer_clk_reg_col] > 0 && [get_collection_size $tx_pld_pma_txpma_rstb_col] > 0} {
        set_max_skew -exclude to_clock -from $tx_xcvrif_reset_reg_col -to $tx_transfer_clk_reg_col $tx_pld_pma_reset_max_skew_value -nowarn
      }


      # TX Adapter
      if {[get_collection_size $tx_aib_reset_out_stage_reg_col] > 0 && [get_collection_size $tx_pld_pma_latch_clk] > 0} {
        set_max_skew -from $tx_aib_reset_out_stage_reg_col -to_clock $tx_pld_pma_latch_clk $tx_transfer_clk_max_skew_value -exclude to_clock -nowarn
      }


      if {[get_collection_size $tx_aib_reset_out_stage_reg_col] > 0 && [get_collection_size $tx_pld_dcm_latch_clk] > 0} {
          set_max_skew -from $tx_aib_reset_out_stage_reg_col -to_clock $tx_pld_dcm_latch_clk $tx_transfer_clk_max_skew_value -exclude to_clock -nowarn
      }


      # -------------------------------------------------------------------------------
      # RX set_max_skew
      # -------------------------------------------------------------------------------
      # Set max skew constraint for RX analog and digital resets when bonded
      set rx_xcvrif_reset_reg_col         [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_seq|xcvrif_reset_out_stage*]
      set rx_aib_reset_out_stage_reg_col  [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_seq|aib_reset_out_stage*]
      set rx_transfer_clk_reg_col         [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx~*aib_fabric_rx_transfer_clk.reg]
      set rx_pld_adapter_rx_pld_rst_n_col [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_adapter_rx_pld_rst_n]
      set rx_pld_pma_rxpma_rstb_col       [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_rxpma_rstb]

      set rx_pld_pma_latch_clk            [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx~*aib_fabric_rx_transfer_clk.reg]
      set rx_pld_dcm_latch_clk            [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx~*pld_rx_clk1_dcm.reg]


      # RX xcvrif
      set  rx_pld_pma_reset_max_skew_value  [expr  $rx_transfer_clk_max_skew_value - 0.4]
      if {[get_collection_size $rx_xcvrif_reset_reg_col] > 0 && [get_collection_size $rx_transfer_clk_reg_col] > 0 && [get_collection_size $rx_pld_pma_rxpma_rstb_col] > 0} {
        set_max_skew -exclude to_clock -from $rx_xcvrif_reset_reg_col -to $rx_transfer_clk_reg_col $rx_pld_pma_reset_max_skew_value -nowarn
      }

      # RX Adapter
       if {[get_collection_size $rx_aib_reset_out_stage_reg_col] > 0 && [get_collection_size $rx_pld_pma_latch_clk] > 0} {
          set_max_skew -from $rx_aib_reset_out_stage_reg_col -to_clock $rx_pld_pma_latch_clk $rx_transfer_clk_max_skew_value -exclude to_clock -nowarn
      }


      if {[get_collection_size $rx_aib_reset_out_stage_reg_col] > 0 && [get_collection_size $rx_pld_dcm_latch_clk] > 0} {
          set_max_skew -from $rx_aib_reset_out_stage_reg_col -to_clock $rx_pld_dcm_latch_clk $rx_transfer_clk_max_skew_value -exclude to_clock -nowarn
      }


  }  ; #  if reset_skew_ctrl_req


  #--------------------------------------------- #
  #---                                       --- #
  #---  Set virtul false path for dl_clks    --- #
  #---                                       --- #
  #--------------------------------------------- #
  set dl_pulse_pin_col [get_pins -compat -nowarn   g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk?_hioint]
  if {[get_collection_size $dl_pulse_pin_col] > 0 } {
    set_max_delay  -from $dl_pulse_pin_col 120
    set_min_delay  -from $dl_pulse_pin_col -120
  }


  #--------------------------------------------- #
  #---                                       --- #
  #--- ASYNC CLOCK GROUP FOR RECONFIGURATION --- #
  #---                                       --- #
  #--------------------------------------------- #
  if {$profile_cnt > 1 } {
    if { $native_debug == 1 } {
      post_message -type info "========================================================================================"
      post_message -type info "IP SDC: Setting async clock groups for multi-profile"
    }

    set arg ""

    for {set i 0} {$i < $profile_cnt} {incr i} {
      set profile_clk_names ""

      dict for {mode clk_name} $profile_clocks {
        # Construct the arguments for set_clock_groups
        # Template: set_clock_groups -asynchronous -group {<profile0 clks>} -group {<profile1 clks>} ...
        if {[dict exists $all_profile_clocks_names $i $mode]} {
          set profile_clk_names [concat $profile_clk_names [dict get $all_profile_clocks_names $i $mode]]
        }
      }

      set profile_clk_names [join $profile_clk_names]
      set group "-group "
      set arg [concat $arg $group]
      set arg [concat $arg "{$profile_clk_names}"]

      if { $native_debug } {
        post_message -type info "IP SDC: Profile $i clocks: $profile_clk_names"
      }
    }

    set cmd ""
    set cmd [concat $cmd "set_clock_groups -physically_exclusive "]
    set cmd [concat $cmd $arg]
    eval $cmd

    if { $native_debug } {
      post_message -type info "IP SDC: Setting async clock groups for reconfiguration: $cmd"
    }

  }


  #-------------------------------------------------- #
  #---                                            --- #
  #--- Internal loopback path                     --- #
  #---                                            --- #
  #-------------------------------------------------- #
  set aib_fabric_pma_aib_tx_clk_col  [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~aib_fabric_pma_aib_tx_clk.reg]
  set aib_fabric_pma_aib_rx_clk_col  [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx~aib_fabric_pma_aib_rx_clk.reg]
  set aib_fabric_tx_data_lpbk_col    [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|aib_fabric_tx_data_lpbk*]
  set aib_fabric_tx_transfer_clk_col [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~aib_fabric_tx_transfer_clk.reg]
  set aib_fabric_rx_transfer_clk_col [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx~aib_fabric_rx_transfer_clk.reg]
  set pld_tx_clk2_dcm_reg_col        [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~pld_tx_clk2_dcm.reg]
  set pld_tx_clk1_dcm_reg_col        [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~pld_tx_clk1_dcm.reg]

  # Cut the paths for the internal loopback paths
  if {[get_collection_size $aib_fabric_pma_aib_tx_clk_col] > 0 && [get_collection_size $aib_fabric_tx_data_lpbk_col] > 0 && [get_collection_size $aib_fabric_rx_transfer_clk_col] > 0} {
    set_false_path -from $aib_fabric_pma_aib_tx_clk_col -through $aib_fabric_tx_data_lpbk_col -to $aib_fabric_rx_transfer_clk_col
  }

  # Cut paths for internal loopback paths when bonding is enabled
  if {[get_collection_size $pld_tx_clk2_dcm_reg_col] > 0 && [get_collection_size $aib_fabric_tx_data_lpbk_col] > 0 && [get_collection_size $aib_fabric_rx_transfer_clk_col] > 0} {
    set_false_path -from $pld_tx_clk2_dcm_reg_col -through $aib_fabric_tx_data_lpbk_col -to $aib_fabric_rx_transfer_clk_col
  }
  if {[get_collection_size $pld_tx_clk1_dcm_reg_col] > 0 && [get_collection_size $aib_fabric_tx_data_lpbk_col] > 0 && [get_collection_size $aib_fabric_rx_transfer_clk_col] > 0} {
    set_false_path -from $pld_tx_clk1_dcm_reg_col -through $aib_fabric_tx_data_lpbk_col -to $aib_fabric_rx_transfer_clk_col
  }



  # -------------------------------------------------------------------------------------------------- #
  # --- Set false path for adjacent channel connections introduced by clock skew control modeling  --- #
  # -------------------------------------------------------------------------------------------------- #
  if { $tx_enabled_on_any_profile && $max_num_channels > 1 } {
      set aib_pld_tx_clk_pin_col [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_tx_clk?_dcm]
      set aib_pld_tx_clk_pin_col  [add_to_collection $aib_pld_tx_clk_pin_col [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_tx_clk?_rowclk] ]
      set aib_tx_internal_div_reg_col [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pma_aib_tx_clk_ch*reg]
      set pld_pcs_tx_clk_col          [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pld_pcs_tx_clk_out_ch*reg]
      set pld_pma_tx_clkdiv_col       [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pld_pma_clkdiv_tx_user_ch*reg]
      set aib_fabric_tx_transfer_clk_col [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~aib_fabric_tx_transfer_clk.reg]
      set aib_fabric_tx_transfer_clk_col_fm [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~aib_fabric_pma_aib_tx_clk.reg]

      set pld_pcs_tx_clk_dcm_col_fm [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out?_dcm]
      set pld_tx_clk_dcm_col_fm [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx~pld_tx_clk?_dcm.reg]


      if { [get_collection_size $aib_fabric_tx_transfer_clk_col] > 0 } {
          if { [get_collection_size $aib_tx_internal_div_reg_col] > 0 } {
             set_false_path -from $aib_tx_internal_div_reg_col -to $aib_fabric_tx_transfer_clk_col
          }

      if { [get_collection_size $pld_pcs_tx_clk_col] > 0 } {
         set_false_path -from $pld_pcs_tx_clk_col -to $aib_fabric_tx_transfer_clk_col
      }

      if { [get_collection_size $pld_pma_tx_clkdiv_col] > 0 } {
         set_false_path -from $pld_pma_tx_clkdiv_col  -to $aib_fabric_tx_transfer_clk_col
      }

      if { [get_collection_size $aib_pld_tx_clk_pin_col] > 0 } {
            set_false_path -through $aib_pld_tx_clk_pin_col -to $aib_fabric_tx_transfer_clk_col
          }
      }



       if { [get_collection_size $aib_fabric_tx_transfer_clk_col_fm] > 0 } {
          if { [get_collection_size $aib_tx_internal_div_reg_col] > 0 } {
             set_false_path -from $aib_tx_internal_div_reg_col -to $aib_fabric_tx_transfer_clk_col_fm
          }

      if { [get_collection_size $pld_pcs_tx_clk_col] > 0 } {
         set_false_path -from $pld_pcs_tx_clk_col -to $aib_fabric_tx_transfer_clk_col_fm
      }

      if { [get_collection_size $pld_pma_tx_clkdiv_col] > 0 } {
         set_false_path -from $pld_pma_tx_clkdiv_col  -to $aib_fabric_tx_transfer_clk_col_fm
      }

      if { [get_collection_size $aib_pld_tx_clk_pin_col] > 0 } {
            set_false_path -through $aib_pld_tx_clk_pin_col -to $aib_fabric_tx_transfer_clk_col_fm
          }
      }

     if { [get_collection_size $pld_tx_clk_dcm_col_fm] > 0 } {
          if { [get_collection_size $pld_pcs_tx_clk_dcm_col_fm ] > 0 } {
             set_false_path -from $pld_pcs_tx_clk_dcm_col_fm -to $pld_tx_clk_dcm_col_fm
          }
    }



  } ; # tx_enabled_on_any_profile && max_num_channels > 1


if { $rx_enabled_on_any_profile && $max_num_channels > 1 } {
      set aib_pld_rx_clk_pin_col [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_rx_clk?_dcm]
      set aib_pld_rx_clk_pin_col  [add_to_collection $aib_pld_rx_clk_pin_col [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_rx_clk?_rowclk] ]
      set aib_rx_internal_div_reg_col [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~rx_transfer_clk_ch*reg]
      set pld_pcs_rx_clk_col          [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~pld_pcs_rx_clk_out_ch*reg]
      set pld_pma_rx_clkdiv_col       [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~pld_pma_clkdiv_rx_user_ch*reg]
      set aib_fabric_rx_transfer_clk_col [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx~aib_fabric_rx_transfer_clk.reg]

      set pld_pcs_rx_clk_dcm_col_fm [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pcs_rx_clk_out?_dcm]
      set pld_rx_clk_dcm_col_fm [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx~pld_rx_clk?_dcm.reg]

      if { [get_collection_size $aib_fabric_rx_transfer_clk_col] > 0 } {
          if { [get_collection_size $aib_rx_internal_div_reg_col] > 0 } {
             set_false_path -from $aib_rx_internal_div_reg_col -to $aib_fabric_rx_transfer_clk_col
          }

          if { [get_collection_size $pld_pcs_rx_clk_col] > 0 } {
             set_false_path -from $pld_pcs_rx_clk_col -to $aib_fabric_rx_transfer_clk_col
          }

          if { [get_collection_size $pld_pma_rx_clkdiv_col] > 0 } {
             set_false_path -from $pld_pma_rx_clkdiv_col  -to $aib_fabric_rx_transfer_clk_col
          }

          if { [get_collection_size $aib_pld_rx_clk_pin_col] > 0 } {
            set_false_path -through $aib_pld_rx_clk_pin_col -to $aib_fabric_rx_transfer_clk_col
          }
      }


        if { [get_collection_size $pld_rx_clk_dcm_col_fm] > 0 } {
             if { [get_collection_size $pld_pcs_rx_clk_dcm_col_fm ] > 0 } {
               set_false_path -from $pld_pcs_rx_clk_dcm_col_fm -to $pld_rx_clk_dcm_col_fm
             }
        }


  } ; # rx_enabled_on_any_profile && max_num_channels > 1


 #-------------------------------------------------- #
  #-----                                       ------ #
  #--- SET_FALSE_PATH to hclk for FM Timing Model --- #
  #------                                       ----- #
  #-------------------------------------------------- #
 set pld_pma_hclk_ch_fm_col [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx~aib_fabric_pld_pma_hclk.reg]

   if { [get_collection_size $pld_pma_hclk_ch_fm_col] > 0 } {
             set_false_path -from $pld_pma_hclk_ch_fm_col
          }

   if { [get_collection_size $pld_pma_hclk_ch_fm_col] > 0 } {
            set_false_path -to $pld_pma_hclk_ch_fm_col
          }




  #--------------------------------------------- #
  #---                                       --- #
  #--- SET_FALSE_PATH to reset synchronizers --- #
  #---                                       --- #
  #--------------------------------------------- #

  # TX and RX reset request synchronizers for manual mode
  set manual_tx_reset_req_resync_reg [get_keepers -nowarn g_pma_rsfec_reset.g_manual_reset.reset_ip_manual_etile_inst|g_reset_sync[*].alt_xcvr_resync_tx_reset_req|resync_chains[0].synchronizer_nocut|din_s1]
  set manual_rx_reset_req_resync_reg [get_keepers -nowarn g_pma_rsfec_reset.g_manual_reset.reset_ip_manual_etile_inst|g_reset_sync[*].alt_xcvr_resync_rx_reset_req|resync_chains[0].synchronizer_nocut|din_s1]

  # Reset controller synchronizers
  set reset_control_reset_resync_din_s1       [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|din_s1]
  set reset_control_reset_resync_dreg         [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|dreg[0]]
  set reset_control_reset_din_s1_clrn_pin     [get_pins -compat -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|din_s1|clrn]
  set reset_control_reset_dreg_clrn_pin       [get_pins -compat -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|dreg[0]|clrn]
  set reset_control_tx_cal_busy_resync_reg    [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|reset_control_inst|g_tx.g_tx[*].g_tx.resync_tx_cal_busy|resync_chains[0].synchronizer_nocut|din_s1]
  set reset_control_rx_cal_busy_resync_reg    [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|reset_control_inst|g_rx.g_rx[*].g_rx.resync_rx_cal_busy|resync_chains[0].synchronizer_nocut|din_s1]

  set tx_reset_control_reset_resync_din_s1    [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|din_s1]
  set tx_reset_control_reset_resync_dreg      [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|dreg[0]]
  set tx_reset_control_reset_din_s1_clrn_pin  [get_pins -compat -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|din_s1|clrn]
  set tx_reset_control_reset_dreg_clrn_pin    [get_pins -compat -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|dreg[0]|clrn]
  set tx_reset_control_tx_cal_busy_resync_reg [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_control_inst|g_tx.g_tx[*].g_tx.resync_tx_cal_busy|resync_chains[0].synchronizer_nocut|din_s1]

  set rx_reset_control_reset_resync_din_s1    [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|din_s1]
  set rx_reset_control_reset_resync_dreg      [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|dreg[0]]
  set rx_reset_control_reset_din_s1_clrn_pin  [get_pins -compat -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|din_s1|clrn]
  set rx_reset_control_reset_dreg_clrn_pin    [get_pins -compat -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_control_inst|g_reset_sync[*].alt_xcvr_resync_reset_1|resync_chains[0].synchronizer_nocut|dreg[0]|clrn]
  set rx_reset_control_rx_cal_busy_resync_reg [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_control_inst|g_rx.g_rx[*].g_rx.resync_rx_cal_busy|resync_chains[0].synchronizer_nocut|din_s1]

  # TX and RX digital reset sequencer synchronizers
  set tx_reset_seq_transfer_ready_resync_reg  [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_seq|transfer_ready_synchronizers|resync_chains[*].synchronizer_nocut|din_s1]
  set rx_reset_seq_transfer_ready_resync_reg  [get_registers    -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_seq|transfer_ready_synchronizers|resync_chains[*].synchronizer_nocut|din_s1]

  # -------------------------------------------------------------------------------
  # Reset controller - No individual TX RX
  # -------------------------------------------------------------------------------
  if {[get_collection_size $reset_control_reset_resync_din_s1]} {
    foreach_in_collection resync_reg $reset_control_reset_resync_din_s1 {
      foreach_in_collection pin $reset_control_reset_din_s1_clrn_pin {
        set_false_path -to $resync_reg -through $pin
      }
    }
  }

  if {[get_collection_size $reset_control_reset_resync_dreg]} {
    foreach_in_collection resync_reg $reset_control_reset_resync_dreg {
      foreach_in_collection pin $reset_control_reset_dreg_clrn_pin {
        set_false_path -to $resync_reg -through $pin
      }
    }
  }

  if {[get_collection_size $reset_control_tx_cal_busy_resync_reg] > 0} {
    foreach_in_collection resync_reg $reset_control_tx_cal_busy_resync_reg {
      set_false_path -to $resync_reg
    }
  }

  if {[get_collection_size $reset_control_rx_cal_busy_resync_reg] > 0} {
    foreach_in_collection resync_reg $reset_control_rx_cal_busy_resync_reg {
      set_false_path -to $resync_reg
    }
  }

  # --------------------------------------------------------------------------
  # TX reset synchronizers
  # --------------------------------------------------------------------------
  if { $tx_enable == 1 } {

    # TX reset request synchronizers for manual mode
    if {[get_collection_size $manual_tx_reset_req_resync_reg] > 0} {
      foreach_in_collection resync_reg $manual_tx_reset_req_resync_reg {
        set_false_path -to $resync_reg
      }
    }

    # TX reset controller synchronizers
    if {[get_collection_size $tx_reset_control_reset_resync_din_s1]} {
      foreach_in_collection resync_reg $tx_reset_control_reset_resync_din_s1 {
        foreach_in_collection pin $tx_reset_control_reset_din_s1_clrn_pin {
          set_false_path -to $resync_reg -through $pin
        }
      }
    }

    if {[get_collection_size $tx_reset_control_reset_resync_dreg]} {
      foreach_in_collection resync_reg $tx_reset_control_reset_resync_dreg {
        foreach_in_collection pin $tx_reset_control_reset_dreg_clrn_pin {
          set_false_path -to $resync_reg -through $pin
        }
      }
    }

    if {[get_collection_size $tx_reset_control_tx_cal_busy_resync_reg] > 0} {
      foreach_in_collection resync_reg $tx_reset_control_tx_cal_busy_resync_reg {
        set_false_path -to $resync_reg
      }
    }

    # TX digital reset sequencer synchronizers
    if {[get_collection_size $tx_reset_seq_transfer_ready_resync_reg] > 0} {
      foreach_in_collection resync_reg $tx_reset_seq_transfer_ready_resync_reg {
        set_false_path -to $resync_reg
      }
    }
  }

  # --------------------------------------------------------------------------
  # RX reset synchronizers
  # --------------------------------------------------------------------------
  if { $rx_enable == 1 } {

    # RX reset request synchronizers for manual mode
    if {[get_collection_size $manual_rx_reset_req_resync_reg] > 0} {
      foreach_in_collection resync_reg $manual_rx_reset_req_resync_reg {
        set_false_path -to $resync_reg
      }
    }

    # RX reset controller synchronizers
    if {[get_collection_size $rx_reset_control_reset_resync_din_s1]} {
      foreach_in_collection resync_reg $rx_reset_control_reset_resync_din_s1 {
        foreach_in_collection pin $rx_reset_control_reset_din_s1_clrn_pin {
          set_false_path -to $resync_reg -through $pin
        }
      }
    }

    if {[get_collection_size $rx_reset_control_reset_resync_dreg]} {
      foreach_in_collection resync_reg $rx_reset_control_reset_resync_dreg {
        foreach_in_collection pin $rx_reset_control_reset_dreg_clrn_pin {
          set_false_path -to $resync_reg -through $pin
        }
      }
    }

    if {[get_collection_size $rx_reset_control_rx_cal_busy_resync_reg] > 0} {
      foreach_in_collection resync_reg $rx_reset_control_rx_cal_busy_resync_reg {
        set_false_path -to $resync_reg
      }
    }

    # RX digital reset sequencer synchronizers
    if {[get_collection_size $rx_reset_seq_transfer_ready_resync_reg] > 0} {
      foreach_in_collection resync_reg $rx_reset_seq_transfer_ready_resync_reg {
        set_false_path -to $resync_reg
      }
    }
  }



  #--------------------------------------------- #
  #---                                       --- #
  #--- MIN & MAX DELAYS FOR RESETS           --- #
  #---                                       --- #
  #--------------------------------------------- #

  if { $tx_enable == 1 } {

    # --------------------------------------------------------------------------
    # TX PMA resets
    # --------------------------------------------------------------------------
    set tx_xcvrif_reset_reg   [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_seq|xcvrif_reset_out_stage*]
    set tx_pld_pma_reset_atom [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pma_txpma_rstb]
    set tx_pld_pma_reset_pins [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pma_txpma_rstb*]

    if {[get_collection_size $tx_xcvrif_reset_reg] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find registers for TX XCVRIF resets"
      }

    } elseif {[get_collection_size $tx_pld_pma_reset_atom] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX PMA reset atom"
      }

    } elseif {[get_collection_size $tx_pld_pma_reset_pins] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for TX PMA reset atom"
      }

    } else {
      set_max_delay -from $tx_xcvrif_reset_reg -through $tx_pld_pma_reset_atom -to $tx_pld_pma_reset_pins 200
      set_min_delay -from $tx_xcvrif_reset_reg -through $tx_pld_pma_reset_atom -to $tx_pld_pma_reset_pins -200
    }


    # --------------------------------------------------------------------------
    # TX AIB/adapter resets
    # --------------------------------------------------------------------------
    set tx_digital_aib_reset_reg   [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|tx_reset_seq|aib_reset_out_stage*]
    set tx_pld_adapter_reset_atom  [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n]
    set tx_pld_adapter_reset_pins  [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n*]

    # Min/max delays for TX AIB/adapter resets
    if {[get_collection_size $tx_digital_aib_reset_reg] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX digital AIB/adapter resets"
      }

    } elseif {[get_collection_size $tx_pld_adapter_reset_atom] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find TX AIB/adapter reset atom"
      }

    } elseif {[get_collection_size $tx_pld_adapter_reset_pins] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for TX AIB/adapter reset atom"
      }

    } else {
      set_max_delay -from $tx_digital_aib_reset_reg -through $tx_pld_adapter_reset_atom -to $tx_pld_adapter_reset_pins 200
      set_min_delay -from $tx_digital_aib_reset_reg -through $tx_pld_adapter_reset_atom -to $tx_pld_adapter_reset_pins -200
    }
  }

  if { $rx_enable == 1 } {

    # --------------------------------------------------------------------------
    # RX PMA resets
    # --------------------------------------------------------------------------
    set rx_xcvrif_reset_reg   [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_seq|xcvrif_reset_out_stage*]
    set rx_pld_pma_reset_atom [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_rxpma_rstb]
    set rx_pld_pma_reset_pins [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_rxpma_rstb*]

    if {[get_collection_size $rx_xcvrif_reset_reg] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find registers for RX XCVRIF resets"
      }

    } elseif {[get_collection_size $rx_pld_pma_reset_atom] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX PMA reset atom"
      }

    } elseif {[get_collection_size $rx_pld_pma_reset_pins] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for RX PMA reset atom"
      }

    } else {
      set_max_delay -from $rx_xcvrif_reset_reg -through $rx_pld_pma_reset_atom -to $rx_pld_pma_reset_pins 200
      set_min_delay -from $rx_xcvrif_reset_reg -through $rx_pld_pma_reset_atom -to $rx_pld_pma_reset_pins -200
    }

    # --------------------------------------------------------------------------
    # RX AIB/adapter resets
    # --------------------------------------------------------------------------
    set rx_digital_aib_reset_reg   [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|rx_reset_seq|aib_reset_out_stage*]
    set rx_pld_adapter_reset_atom  [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_adapter_rx_pld_rst_n]
    set rx_pld_adapter_reset_pins  [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_adapter_rx_pld_rst_n*]

    # Min/max delays for RX AIB/adapter resets
    if {[get_collection_size $rx_digital_aib_reset_reg] == 0} {
       if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX digital AIB/adapter resets"
      }

    } elseif {[get_collection_size $rx_pld_adapter_reset_atom] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find RX AIB/adapter reset atom"
      }

    } elseif {[get_collection_size $rx_pld_adapter_reset_pins] == 0} {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Could not find pins for RX AIB/adapter reset atom"
      }

    } else {
      set_max_delay -from $rx_digital_aib_reset_reg -through $rx_pld_adapter_reset_atom -to $rx_pld_adapter_reset_pins 200
      set_min_delay -from $rx_digital_aib_reset_reg -through $rx_pld_adapter_reset_atom -to $rx_pld_adapter_reset_pins -200
    }
  }


  #------------------------------------------------------- #
  #---                                                 --- #
  #--- Virtually false path async resets to pld_adapt  --- #
  #---                                                 --- #
  #------------------------------------------------------- #

  if { $tx_enable == 1 } {
    set tx_pld_reset_pins [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pma_txpma_rstb]
    set tx_pld_reset_pins [add_to_collection $tx_pld_reset_pins  [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n] ]
    if {[get_collection_size $tx_pld_reset_pins] > 0} {
      set_max_delay  -through $tx_pld_reset_pins  120
      set_min_delay  -through $tx_pld_reset_pins  -120
    }
  }

  if { $rx_enable == 1 } {
    set rx_pld_reset_pins [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_rxpma_rstb]
    set rx_pld_reset_pins [add_to_collection $rx_pld_reset_pins  [get_pins -compat -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_adapter_rx_pld_rst_n] ]
    if {[get_collection_size $rx_pld_reset_pins] > 0} {
      set_max_delay  -through $rx_pld_reset_pins  120
      set_min_delay  -through $rx_pld_reset_pins  -120
    }
  }


  #-------------------------------------------------- #
  #--- TODO                                       --- #
  #--- AVMM wrapper constraints                   --- #
  #---                                            --- #
  #-------------------------------------------------- #
  # Check that reconfiguration is enabled
  if {[dict get $native_phy_ip_params rcfg_enable_profile0]} {

    set ct3_xcvr_avmm_reset_clrn_col [get_pins -nowarn -compat g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_avmm1_soft_logic|avmm_if_soft_logic[*].ct3_xcvr_avmm_soft_logic_core_inst|sync_r[?]|clrn]

    if { [get_collection_size $ct3_xcvr_avmm_reset_clrn_col] > 0 } {
      # Set false path to avmm_reset synchronizer
      set ct3_xcvr_avmm_reset_sync_reg_col [get_registers -nowarn g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_avmm1_soft_logic|avmm_if_soft_logic[*].ct3_xcvr_avmm_soft_logic_core_inst|sync_r[?]]
      set_false_path -through $ct3_xcvr_avmm_reset_clrn_col -to $ct3_xcvr_avmm_reset_sync_reg_col
    } else {
      if {$native_debug == 1} {
        post_message -type warning "IP SDC: Reconfiguration is enabled, but IP SDC is unable to find any matching nodes for AVMM soft logic"
      }

    }
  }


  #-------------------------------------------------- #
  #---                                            --- #
  #--- Optional Reconfig Logic constraints        --- #
  #---                                            --- #
  #-------------------------------------------------- #
  set ct3_xcvr_opt_logic_sync_reg_col [get_registers -nowarn alt_xcvr_native_optional_rcfg_logic|g_optional_chnl_reconfig_logic[*].*|resync_chains[*].synchronizer_nocut|din_s1]
  set ct3_xcvr_opt_logic_clrn_col [get_pins -nowarn -compat alt_xcvr_native_optional_rcfg_logic|g_optional_chnl_reconfig_logic[*].*|resync_chains[*].synchronizer_nocut|din_s1|clrn]
  if { [get_collection_size $ct3_xcvr_opt_logic_sync_reg_col] > 0 } {
     # set false path to 1st stage of sync registers
     set_false_path -to $ct3_xcvr_opt_logic_sync_reg_col
     if { [get_collection_size $ct3_xcvr_opt_logic_clrn_col] > 0 } {
        # set false path through the async reset pins
        set_false_path -through $ct3_xcvr_opt_logic_clrn_col -to $ct3_xcvr_opt_logic_sync_reg_col
     }
  }


  #-------------------------------------------------- #
  #---                                            --- #
  #--- SET_FALSE_PATH for MAIB ASYNC signals      --- #
  #---                                            --- #
  #-------------------------------------------------- #
  # Create a set of all asynchronous signals to be looped over for setting false paths
  # These signals are async input signals to Nadder Adapter
  set altera_xcvr_native_s10_async_signals {
    pld_pma_fpll_up_dn_lc_lf_rstn
    pld_pma_txdetectrx
    pld_ltr
    pld_pma_ltd_b
    pld_txelecidle
    pld_10g_krfec_rx_clr_errblk_cnt
    pld_10g_rx_clr_ber_count
    pld_10g_tx_bitslip
    pld_10g_tx_diag_status
    pld_8g_a1a2_size
    pld_8g_bitloc_rev_en
    pld_8g_byte_rev_en
    pld_8g_encdt
    pld_8g_tx_boundary_sel
    pld_bitslip
    pld_pma_adapt_start
    pld_pma_early_eios
    pld_pma_eye_monitor
    pld_pma_pcie_switch
    pld_pma_rs_lpbk_b
    pld_pmaif_rxclkslip
    pld_pma_tx_qpi_pulldn
    pld_pma_tx_qpi_pullup
    pld_pma_rx_qpi_pullup
    pld_polinv_rx
    pld_polinv_tx
    pld_syncsm_en
    pld_rx_prbs_err_clr
    pld_10g_tx_wordslip
    pld_pma_tx_bitslip
    pld_8g_eidleinfersel
    pld_tx_fifo_latency_adj_en
    pld_rx_fifo_latency_adj_en
  }

  if { [ info exists altera_xcvr_native_s10_async_xcvr_pins ] } {
    unset altera_xcvr_native_s10_async_xcvr_pins
  }

  # Set false paths for each item in the set
  foreach altera_xcvr_native_s10_async_signal_name $altera_xcvr_native_s10_async_signals {
    set altera_xcvr_native_s10_async_xcvr_pins [get_pins -nowarn -compatibility_mode g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_?x|${altera_xcvr_native_s10_async_signal_name}*]
    if { [get_collection_size $altera_xcvr_native_s10_async_xcvr_pins] > 0 } {
      set_false_path -to $altera_xcvr_native_s10_async_xcvr_pins
    }
  }


  #-------------------------------------------------- #
  #---                                            --- #
  #--- TX BURST ENABLE MIN/MAX CONSTRAINTS        --- #
  #---                                            --- #
  #-------------------------------------------------- #
  # For TX burst enable, even though its an asynchronous signal, set a bound, since we need the fitter to place it some-what close to the periphery for interlaken
  set altera_xcvr_native_s10_async_tx_burst_en_pins [get_pins -nowarn -compatibility_mode g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_10g_tx_burst_en*]
  if { [get_collection_size $altera_xcvr_native_s10_async_tx_burst_en_pins] > 0 } {
    set_max_delay -to $altera_xcvr_native_s10_async_tx_burst_en_pins 200ns
    set_min_delay -to $altera_xcvr_native_s10_async_tx_burst_en_pins -200ns
  }

}; #foreach inst

#-------------------------------------------------- #
#---                                            --- #
#--- DISABLE MIN_PULSE_WIDTH CHECK on fPLL      --- #
#---                                            --- #
#-------------------------------------------------- #

# Disable min_width_pulse for fPLL counter nodes
set all_ports_list [get_ports *]
foreach_in_collection port $all_ports_list {

  set fpll_counter_nodes_list [get_nodes -nowarn [get_node_info -name $port]~inputFITTER_INSERTED_FITTER_INSERTED~fpll_c?_div]

  if {[get_collection_size $fpll_counter_nodes_list] > 0} {
    foreach_in_collection fpll_counter_node $fpll_counter_nodes_list {
      disable_min_pulse_width [get_node_info -name $fpll_counter_node]
    }
  }
}

#-----------------------------------------------------------#
#---                                                     ---#
#------------------ add for deskew -------------------------#
#---                                                     ---#
##----------------------------------------------------------#
# deskew resync_reset
set deskew_resync_reset_col [get_pins -nowarn g_pam4_dual.g_deskew[*].altera_xcvr_native_dskw_pam4|alt_xcvr_resync_reset*|resync_chains[*].synchronizer_nocut|d*|clrn]
if {[get_collection_size $deskew_resync_reset_col] > 0} {
  foreach_in_collection resync_reg $deskew_resync_reset_col {
    set_false_path -through $resync_reg
  }
}

# deskew fifo clock
# if user set different clocks for even and odd channel for dual channel, this fifo running as asyn fifo, set false path to disable the fifo timing check.
set deskew_fifo_data_col [get_registers -nowarn g_pam4_dual.g_deskew[*].altera_xcvr_native_dskw_pam4|fifo*|fifo*]
if {[get_collection_size $deskew_fifo_data_col] > 0} {
  foreach_in_collection fifo_data_reg $deskew_fifo_data_col {
    set_false_path -from $fifo_data_reg
  }
}

# set false path to deal with crossing clock domain issue for the rx_ready which coming from reset ctnl and going to de-skew which is in different clock domain
set rx_ready [get_registers -nowarn g_pma_rsfec_reset.g_auto_reset.reset_ip_auto_etile_inst|*reset_control_inst|g_rx.g_rx[*].g_rx.counter_rx_ready|r_reset]
set dskw_st_d1 [get_registers -nowarn g_pam4_dual.g_deskew[*].altera_xcvr_native_dskw_pam4|dskw_start_d1]
if {[get_collection_size $rx_ready] > 0 && [get_collection_size $dskw_st_d1] > 0} {
    set_false_path -from $rx_ready -to $dskw_st_d1
}


msg_vdebug "IP SDC: End of Native PHY IP SDC file!"
