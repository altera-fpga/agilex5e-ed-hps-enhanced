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


# -------------------------------------------------------------------------- #
# -
# --- This file contains helper functions for Native PHY SDC file
# -
# -------------------------------------------------------------------------- #
set script_dir [file dirname [info script]]

load_package sdc_ext
load_package design

if {![info exists native_debug]} {
  global ::native_debug
}

set native_debug 0

# Create dictionary to map clocks to their respective target node
if {[info exists alt_xcvr_native_s10_target_clock_list_dict]} {
   unset alt_xcvr_native_s10_target_clock_list_dict
}
global ::alt_xcvr_native_s10_target_clock_list_dict
set alt_xcvr_native_s10_target_clock_list_dict [dict create]

# -------------------------------------------------------------------------- #
# ---                                                                    --- #
# --- Procedure to initialize the database of all required pins and      --- #
# --- registers to create clocks                                         --- #
# ---                                                                    --- #
# -------------------------------------------------------------------------- #
proc native_initialize_db_isub23q { native_db } {

  # upvar links one variable to another variable at specified level of execution
  upvar $native_db local_native_db

  # Set the GLOBAL_corename in ip_parameters.tcl
  global ::GLOBAL_corename
  global ::native_debug

  # Delete the database if it exists
  if [info exists local_native_db] {
    msg_vdebug "IP SDC: Database existed before, deleting it now"
    unset local_native_db
  }

  set local_native_db [dict create]

  msg_vdebug "IP SDC: Initializing S10 Native PHY database for CORE $::GLOBAL_corename"

  # Find the current Native PHY instance name in the design
  set instance_name [get_current_instance]

  # Create dictionary of pins
  msg_vdebug "IP SDC: Finding port-to-pin mapping for CORE: $::GLOBAL_corename INSTANCE: $instance_name"
  set all_pins [dict create]
  native_get_pins_isub23q $all_pins

  # Set the associative array
  dict set local_native_db $instance_name $all_pins

}


# -------------------------------------------------------------------------- #
# ---                                                                    --- #
# --- Procedure to find all the pins and registers for nodes of interest --- #
# ---                                                                    --- #
# -------------------------------------------------------------------------- #
proc native_get_pins_isub23q { all_pins } {

  global ::GLOBAL_corename
  global ::native_debug

  # We need to make a local copy of the allpins associative array
  upvar all_pins native_pins

  # ------------------------------------------------------------------------- #
  # Define the pins here
  # Include regex to grab pins for multiple channels

    # pma parallel clks & transfer clks
    set aib_tx_clk_source_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pma_aib_tx_clk_ch*ref
    set aib_rx_clk_source_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~rx_transfer_clk_ch*ref
    set aib_tx_internal_div_reg_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pma_aib_tx_clk_ch*reg
    set aib_rx_internal_div_reg_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~rx_transfer_clk_ch*reg

    # pld pcs clks
    set pld_pcs_tx_clk_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pld_pcs_tx_clk_out_ch*ref
    set pld_pcs_rx_clk_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~pld_pcs_rx_clk_out_ch*ref
    set pld_pcs_tx_clk_reg_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pld_pcs_tx_clk_out_ch*reg
    set pld_pcs_rx_clk_reg_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~pld_pcs_rx_clk_out_ch*reg


    # pld pma clkdiv clks
    set pld_pma_clkdiv_tx_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pld_pma_clkdiv_tx_user_ch*ref
    set pld_pma_clkdiv_rx_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~pld_pma_clkdiv_rx_user_ch*ref
    set pld_pma_clkdiv_tx_reg_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_tx~pld_pma_clkdiv_tx_user_ch*reg
    set pld_pma_clkdiv_rx_reg_node g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~pld_pma_clkdiv_rx_user_ch*reg


    #hclk(not use in CR3)
    set pld_pma_hclk_pin                g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~pld_pma_hclk_ch*ref
    set pld_pma_hclk_reg_pin            g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct3_hssi_aibcr_rx~pld_pma_hclk_ch*reg
    set hclk_pin                        g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_hclk_hioint



  # Output clocks from main adapter to core
  set tx_clkout_pin  g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out1_dcm
  set tx_clkout2_pin g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_pcs_tx_clk_out2_dcm
  set rx_clkout_pin  g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pcs_rx_clk_out1_dcm
  set rx_clkout2_pin g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pcs_rx_clk_out2_dcm


  # dl_pulse
  set rx_dl_pulse_pin                g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk1_hioint
  set tx_dl_pulse_pin                g_xcvr_native_insts[*].ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_rx|pld_pma_internal_clk2_hioint


  # ------------------------------------------------------------------------- #
  # Create a dictionary for each clock pin
  set native_pins [dict create]

# ------------------------------------------------------------------------- #
  set pld_pcs_tx_clk_id [get_nodes -nowarn $pld_pcs_tx_clk_node]

  if {[get_collection_size $pld_pcs_tx_clk_id] > 0} {
    foreach_in_collection clk $pld_pcs_tx_clk_id {
      dict lappend native_pins tx_pld_pcs_clk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PCS TX CLK node info: [dict get $native_pins tx_pld_pcs_clk]"
    }

    dict set native_pins tx_pld_pcs_clk [join [lsort -dictionary [dict get $native_pins tx_pld_pcs_clk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for PLD PCS TX CLK"
    }
  }

# ------------------------------------------------------------------------- #
  set pld_pcs_rx_clk_id [get_nodes -nowarn $pld_pcs_rx_clk_node]

  if {[get_collection_size $pld_pcs_rx_clk_id] > 0} {
    foreach_in_collection clk $pld_pcs_rx_clk_id {
      dict lappend native_pins rx_pld_pcs_clk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PCS RX CLK node info: [dict get $native_pins rx_pld_pcs_clk]"
    }

    dict set native_pins rx_pld_pcs_clk [join [lsort -dictionary [dict get $native_pins rx_pld_pcs_clk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for PLD PCS RX CLK"
    }
  }


# ------------------------------------------------------------------------- #
  set pld_pcs_tx_clk_reg_id [get_registers -nowarn $pld_pcs_tx_clk_reg_node]
    if {$native_debug == 1} {
      post_message -type info "IP SDC:pld_pcs_tx_clk_reg_node "
      post_message -type info "pld_pcs_tx_clk_reg_node = $pld_pcs_tx_clk_reg_node"
      post_message -type info "pld_pcs_tx_clk_reg_id = $pld_pcs_tx_clk_reg_id "
    }

  if {[get_collection_size $pld_pcs_tx_clk_reg_id] > 0} {
    foreach_in_collection clk $pld_pcs_tx_clk_reg_id {
      dict lappend native_pins tx_pld_pcs_clk_reg [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PCS TX CLK REG node info: [dict get $native_pins tx_pld_pcs_clk_reg]"
    }

    dict set native_pins tx_pld_pcs_clk_reg [join [lsort -dictionary [dict get $native_pins tx_pld_pcs_clk_reg]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find registers for PLD PCS TX CLK REG"
    }
  }


# ------------------------------------------------------------------------- #
  set pld_pcs_rx_clk_reg_id [get_registers -nowarn $pld_pcs_rx_clk_reg_node]
    if {$native_debug == 1} {
      post_message -type info "IP SDC:pld_pcs_rx_clk_reg_node "
      post_message -type info "pld_pcs_tx_clk_reg_node = $pld_pcs_rx_clk_reg_node"
      post_message -type info "pld_pcs_tx_clk_reg_id = $pld_pcs_rx_clk_reg_id "
    }

  if {[get_collection_size $pld_pcs_rx_clk_reg_id] > 0} {
    foreach_in_collection clk $pld_pcs_rx_clk_reg_id {
      dict lappend native_pins rx_pld_pcs_clk_reg [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PCS RX CLK REG node info: [dict get $native_pins rx_pld_pcs_clk_reg]"
    }

    dict set native_pins rx_pld_pcs_clk_reg [join [lsort -dictionary [dict get $native_pins rx_pld_pcs_clk_reg]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find registers for PLD PCS RX CLK REG"
    }
  }




# ------------------------------------------------------------------------- #
  set pld_pma_clkdiv_tx_id [get_nodes -nowarn $pld_pma_clkdiv_tx_node]

  if {[get_collection_size $pld_pma_clkdiv_tx_id] > 0} {
    foreach_in_collection clk $pld_pma_clkdiv_tx_id {
      dict lappend native_pins tx_pld_pma_clkdiv_clk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PMA TX CLKDIV node info: [dict get $native_pins tx_pld_pma_clkdiv_clk]"
    }

    dict set native_pins tx_pld_pma_clkdiv_clk [join [lsort -dictionary [dict get $native_pins tx_pld_pma_clkdiv_clk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for PLD PMA TX CLKDIV CLK"
    }
  }


# ------------------------------------------------------------------------- #
  set pld_pma_clkdiv_rx_id [get_nodes -nowarn $pld_pma_clkdiv_rx_node]

  if {[get_collection_size $pld_pma_clkdiv_rx_id] > 0} {
    foreach_in_collection clk $pld_pma_clkdiv_rx_id {
      dict lappend native_pins rx_pld_pma_clkdiv_clk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PMA RX CLKDIV node info: [dict get $native_pins rx_pld_pma_clkdiv_clk]"
    }

    dict set native_pins rx_pld_pma_clkdiv_clk [join [lsort -dictionary [dict get $native_pins rx_pld_pma_clkdiv_clk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for PLD PMA RX CLKDIV CLK"
    }
  }

# ------------------------------------------------------------------------- #
  set pld_pma_clkdiv_tx_reg_id [get_registers -nowarn $pld_pma_clkdiv_tx_reg_node]
    if {$native_debug == 1} {
      post_message -type info "IP SDC:pld_pma_clkdiv_tx_reg_node] "
      post_message -type info "pld_pma_clkdiv_tx_reg_node] = $pld_pma_clkdiv_tx_reg_node]"
      post_message -type info "pld_pma_clkdiv_tx_reg_id = $pld_pma_clkdiv_tx_reg_id "
    }

  if {[get_collection_size $pld_pma_clkdiv_tx_reg_id] > 0} {
    foreach_in_collection clk $pld_pma_clkdiv_tx_reg_id {
      dict lappend native_pins tx_pld_pma_clkdiv_clk_reg [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PMA TX CLKDIV CLK REG node info: [dict get $native_pins tx_pld_pma_clkdiv_clk_reg]"
    }

    dict set native_pins tx_pld_pma_clkdiv_clk_reg [join [lsort -dictionary [dict get $native_pins tx_pld_pma_clkdiv_clk_reg ]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find registers for  PLD PMA TX CLKDIV CLK REG"
    }
  }


# ------------------------------------------------------------------------- #
  set pld_pma_clkdiv_rx_reg_id [get_registers -nowarn $pld_pma_clkdiv_rx_reg_node]
    if {$native_debug == 1} {
      post_message -type info "IP SDC:pld_pma_clkdiv_rx_reg_node] "
      post_message -type info "pld_pma_clkdiv_rx_reg_node] = $pld_pma_clkdiv_rx_reg_node]"
      post_message -type info "pld_pma_clkdiv_rx_reg_id = $pld_pma_clkdiv_rx_reg_id "
    }

  if {[get_collection_size $pld_pma_clkdiv_rx_reg_id] > 0} {
    foreach_in_collection clk $pld_pma_clkdiv_rx_reg_id {
      dict lappend native_pins rx_pld_pma_clkdiv_clk_reg [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PMA RX CLKDIV CLK REG node info: [dict get $native_pins rx_pld_pma_clkdiv_clk_reg]"
    }

    dict set native_pins rx_pld_pma_clkdiv_clk_reg [join [lsort -dictionary [dict get $native_pins rx_pld_pma_clkdiv_clk_reg ]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find registers for  PLD PMA RX CLKDIV CLK REG"
    }
  }




 # ------------------------------------------------------------------------- #
  set aib_tx_clk_source_id [get_nodes -nowarn $aib_tx_clk_source_node]

  if {[get_collection_size $aib_tx_clk_source_id] > 0} {
    foreach_in_collection clk $aib_tx_clk_source_id {
      dict lappend native_pins tx_pma_parallel_clk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting AIB TX CLK SOURCE node info: [dict get $native_pins tx_pma_parallel_clk]"
    }

    dict set native_pins tx_pma_parallel_clk [join [lsort -dictionary [dict get $native_pins tx_pma_parallel_clk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for AIB TX CLK SOURCE"
    }
  }

  # ------------------------------------------------------------------------- #
  set aib_rx_clk_source_id [get_nodes -nowarn $aib_rx_clk_source_node]

  if {[get_collection_size $aib_rx_clk_source_id] > 0} {
    foreach_in_collection clk $aib_rx_clk_source_id {
      dict lappend native_pins rx_pma_parallel_clk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting AIB TX CLK SOURCE node info: [dict get $native_pins rx_pma_parallel_clk]"
    }

    dict set native_pins rx_pma_parallel_clk [join [lsort -dictionary [dict get $native_pins rx_pma_parallel_clk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find nodes for AIB RX CLK SOURCE"
    }
  }

  # ------------------------------------------------------------------------- #
  set aib_tx_internal_div_reg_id [get_registers -nowarn $aib_tx_internal_div_reg_node]
    if {$native_debug == 1} {
      post_message -type info "IP SDC: getting aib_tx_internal_div_reg_node"
      post_message -type info "aib_tx_internal_div_reg_node = $aib_tx_internal_div_reg_node"
      post_message -type info "aib_tx_internal_div_reg_id = $aib_tx_internal_div_reg_id"
    }

  if {[get_collection_size $aib_tx_internal_div_reg_id] > 0} {
    foreach_in_collection clk $aib_tx_internal_div_reg_id {
      dict lappend native_pins tx_transfer_clk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting AIB TX INTERNAL DIV REG node info: [dict get $native_pins tx_transfer_clk]"
    }

    dict set native_pins tx_transfer_clk [join [lsort -dictionary [dict get $native_pins tx_transfer_clk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find registers for AIB TX INTERNAL DIV REG"
    }
  }

  # ------------------------------------------------------------------------- #
  set aib_rx_internal_div_reg_id [get_registers -nowarn $aib_rx_internal_div_reg_node]

  if {[get_collection_size $aib_rx_internal_div_reg_id] > 0} {
    foreach_in_collection clk $aib_rx_internal_div_reg_id {
      dict lappend native_pins rx_transfer_clk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting AIB RX INTERNAL DIV REG node info: [dict get $native_pins rx_transfer_clk]"
    }

    dict set native_pins rx_transfer_clk [join [lsort -dictionary [dict get $native_pins rx_transfer_clk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find registers for AIB RX INTERNAL DIV REG"
    }
  }

  # ------------------------------------------------------------------------- #
  set tx_clkout_id [get_pins -compatibility_mode -nowarn $tx_clkout_pin]

  if {[get_collection_size $tx_clkout_id] == 0} {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: pld_pcs_tx_clk_out1_dcm does not exist."
    }
  }

  if {[get_collection_size $tx_clkout_id] > 0} {
    foreach_in_collection clk $tx_clkout_id {
      dict lappend native_pins tx_clkout [get_pin_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting TX CLKOUT node info: [dict get $native_pins tx_clkout]"
    }

    dict set native_pins tx_clkout [join [lsort -dictionary [dict get $native_pins tx_clkout]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for TX CLKOUT"
    }
  }

  # ------------------------------------------------------------------------- #
  set tx_clkout2_id [get_pins -compatibility_mode -nowarn $tx_clkout2_pin]

  if {[get_collection_size $tx_clkout2_id] == 0} {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: pld_pcs_tx_clk_out2_dcm does not exist."
    }
  }

  if {[get_collection_size $tx_clkout2_id] > 0} {
    foreach_in_collection clk $tx_clkout2_id {
      dict lappend native_pins tx_clkout2 [get_pin_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting TX CLKOUT2 node info: [dict get $native_pins tx_clkout2]"
    }

    dict set native_pins tx_clkout2 [join [lsort -dictionary [dict get $native_pins tx_clkout2]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for TX CLKOUT2"
    }
  }

  # ------------------------------------------------------------------------- #
  set rx_clkout_id [get_pins -compatibility_mode -nowarn $rx_clkout_pin]

  if {[get_collection_size $rx_clkout_id] == 0} {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: pld_pcs_rx_clk_out1_dcm does not exist."
    }
  }

  if {[get_collection_size $rx_clkout_id] > 0} {
    foreach_in_collection clk $rx_clkout_id {
      dict lappend native_pins rx_clkout [get_pin_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting RX CLKOUT node info: [dict get $native_pins rx_clkout]"
    }

    dict set native_pins rx_clkout [join [lsort -dictionary [dict get $native_pins rx_clkout]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for RX CLKOUT"
    }
  }

  # ------------------------------------------------------------------------- #
  set rx_clkout2_id [get_pins -compatibility_mode -nowarn $rx_clkout2_pin]

  if {[get_collection_size $rx_clkout2_id] == 0} {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: pld_pcs_rx_clk_out2_dcm does not exist."
    }
  }

  if {[get_collection_size $rx_clkout2_id] > 0} {
    foreach_in_collection clk $rx_clkout2_id {
      dict lappend native_pins rx_clkout2 [get_pin_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting RX CLKOUT2 node info: [dict get $native_pins rx_clkout2]"
    }

    dict set native_pins rx_clkout2 [join [lsort -dictionary [dict get $native_pins rx_clkout2]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for RX CLKOUT2"
    }
  }

  # ------------------------------------------------------------------------- #
  set hclk_pin_id [get_pins -compatibility_mode -nowarn $hclk_pin]

  if {[get_collection_size $hclk_pin_id] > 0} {
    foreach_in_collection clk $hclk_pin_id {
      dict lappend native_pins hclk [get_pin_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting HCLK node info: [dict get $native_pins hclk]"
    }

    dict set native_pins hclk [join [lsort -dictionary [dict get $native_pins hclk]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for HCLK"
    }
  }


  # ------------------------------------------------------------------------- #
  set rx_dl_pulse_pin_id [get_pins -compatibility_mode -nowarn $rx_dl_pulse_pin]

  if {[get_collection_size $rx_dl_pulse_pin_id] > 0} {
    foreach_in_collection pulse $rx_dl_pulse_pin_id {
      dict lappend native_pins rx_dl_pulse [get_pin_info -name $pulse]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting RX_DL_PULSE node info: [dict get $native_pins rx_dl_pulse]"
    }

    dict set native_pins rx_dl_pulse [join [lsort -dictionary [dict get $native_pins rx_dl_pulse]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for RX_DL_PULSE"
    }
  }

  # ------------------------------------------------------------------------- #
  set tx_dl_pulse_pin_id [get_pins -compatibility_mode -nowarn $tx_dl_pulse_pin]

  if {[get_collection_size $tx_dl_pulse_pin_id] > 0} {
    foreach_in_collection pulse $tx_dl_pulse_pin_id {
      dict lappend native_pins tx_dl_pulse [get_pin_info -name $pulse]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting TX_DL_PULSE node info: [dict get $native_pins tx_dl_pulse]"
    }

    dict set native_pins tx_dl_pulse [join [lsort -dictionary [dict get $native_pins tx_dl_pulse]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for TX_DL_PULSE"
    }
  }


# ------------------------------------------------------------------------- #
set pld_pma_hclk_pin_id [get_nodes -nowarn $pld_pma_hclk_pin]

  if {[get_collection_size $pld_pma_hclk_pin_id] > 0} {
    foreach_in_collection clk $pld_pma_hclk_pin_id {
      dict lappend native_pins pld_pma_hclk [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PMA HCLK node info: [dict get $native_pins pld_pma_hclk]"
    }

    dict set native_pins pld_pma_hclk [join [lsort -dictionary [dict get $native_pins pld_pma_hclk ]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for PLD PMA HCLK"
    }
  }

# ------------------------------------------------------------------------- #
  set pld_pma_hclk_reg_pin_id [get_registers -nowarn $pld_pma_hclk_reg_pin]

  if {[get_collection_size $pld_pma_hclk_reg_pin_id] > 0} {
    foreach_in_collection clk $pld_pma_hclk_reg_pin_id {
      dict lappend native_pins pld_pma_hclk_reg [get_node_info -name $clk]
    }

    if {$native_debug == 1} {
      post_message -type info "IP SDC: After getting PLD PMA HCLK REG node info: [dict get $native_pins pld_pma_hclk_reg]"
    }

    dict set native_pins pld_pma_hclk_reg [join [lsort -dictionary [dict get $native_pins pld_pma_hclk_reg]]]

  } else {
    if {$native_debug == 1} {
      post_message -type info "IP SDC: Could not find pins for PLD PMA HCLK REG"
    }
  }






}

# -------------------------------------------------------------------------------- #
# ---                                                                          --- #
# --- Procedure to call procedure to create clocks all channels in an instance --- #
# ---                                                                          --- #
# -------------------------------------------------------------------------------- #
proc native_prepare_to_create_clocks_all_ch_isub23q { instance num_channels mode mode_clks profile_cnt profile alt_xcvr_native_s10_pins clk_freq_dict multiply_factor_dict divide_factor_dict duty_cycle_dict all_profile_clocks_names tx_clkout_sel tx_clkout2_sel rx_clkout_sel rx_clkout2_sel protocol_mode} {
  global ::native_debug

  set list_of_clk_names [list]

  foreach clk_group $mode_clks { # Each mode can have multiple clocks; iterate over them
    if { $native_debug } {
      post_message -type info "IP SDC: Clock group in $mode_clks is: $clk_group"
    }

    if { [dict exists $alt_xcvr_native_s10_pins $instance $clk_group] } {

      set clk_pins [dict get $alt_xcvr_native_s10_pins $instance $clk_group]

      if { $native_debug } {
        post_message -type info "IP SDC: Pins for $clk_group: $clk_pins"
      }

      if { [llength $clk_pins] > 0 } { # Check to see if the corresponding pins exists

        #Remap any backward slashes '' in the pins
        set clk_pins [string map {\\ \\\\} $clk_pins]

	   if { $native_debug } {
		  post_message -type info "IP SDC: before if clause line 403 mode = $mode"
              post_message -type info "IP SDC: keys for alt_xcvr_native_s10_pins = [dict keys [dict get $alt_xcvr_native_s10_pins $instance]]"
              foreach key_string [dict keys [dict get $alt_xcvr_native_s10_pins $instance]] {
			      post_message -type info "IP SDC: value for $key_string = [dict get $alt_xcvr_native_s10_pins $instance $key_string]"
			  }
	   }
        if { $mode == "tx_source_clks" || $mode == "rx_source_clks" || $mode == "dl_clks"|| $mode == "tx_pcs_clks" || $mode == "rx_pcs_clks" || $mode == "tx_clkdiv_clks" || $mode == "rx_clkdiv_clks"  || $mode == "pld_pma_hclks" } {
	   if { $native_debug } {
		  post_message -type info "IP SDC: if clause line 404 mode = $mode"
	   }
          set clk_freq [dict get $clk_freq_dict $clk_group]

          # Create clks for all channels for a clk group in mode clk
          lappend list_of_clk_names [native_create_clocks_all_ch_isub23q $instance $clk_group $num_channels $clk_freq $clk_pins $profile_cnt $profile]

        } else {
          set clk_freq ""
          set multiply_factor   [dict get $multiply_factor_dict $clk_group]
          set divide_factor     [dict get $divide_factor_dict   $clk_group]

          # Check is nominal 60:40 duty cycle distortion (DCD) applies
          if { [dict exists $duty_cycle_dict $clk_group] } {
            set duty_cycle_factor [dict get $duty_cycle_dict $clk_group]
          } else {
            set duty_cycle_factor 50
          }

          if { $clk_group == "tx_transfer_clk" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_pma_parallel_clk]
            set master_clocks [dict get $all_profile_clocks_names $profile  tx_source_clks]

          } elseif { $clk_group == "rx_transfer_clk" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_pma_parallel_clk]
            set master_clocks [dict get $all_profile_clocks_names $profile  rx_source_clks]

          } elseif { $clk_group == "tx_pld_pcs_clk_reg" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_pld_pcs_clk]
            set master_clocks [dict get $all_profile_clocks_names $profile  tx_pcs_clks]

          } elseif { $clk_group == "rx_pld_pcs_clk_reg" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_pld_pcs_clk]
            set master_clocks [dict get $all_profile_clocks_names $profile  rx_pcs_clks]

          } elseif { $clk_group == "tx_pld_pma_clkdiv_clk_reg" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_pld_pma_clkdiv_clk]
            set master_clocks [dict get $all_profile_clocks_names $profile  tx_clkdiv_clks]

          } elseif { $clk_group == "rx_pld_pma_clkdiv_clk_reg" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_pld_pma_clkdiv_clk]
            set master_clocks [dict get $all_profile_clocks_names $profile  rx_clkdiv_clks]

          } elseif { $clk_group == "pld_pma_hclk_reg" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance pld_pma_hclk]
            set master_clocks [dict get $all_profile_clocks_names $profile  pld_pma_hclks]

          } elseif { $clk_group == "hclk_internal_div_reg" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_pma_parallel_clk]
            set master_clocks [dict get $all_profile_clocks_names $profile  rx_source_clks]

          } elseif { $mode == "tx_mode_clkout1_clks" } {
		if { $native_debug } {
		   post_message -type info "IP SDC: tx_mode_clkout1_clks: alt_xcvr_native_s10_pins $instance = $alt_xcvr_native_s10_pins $instance"
		   }

            if { $protocol_mode == "pll" && [dict exists $alt_xcvr_native_s10_pins $instance tx_transfer_clk] } {
              set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_transfer_clk]
            } elseif { $tx_clkout_sel == "full-rate" && [dict exists $alt_xcvr_native_s10_pins $instance tx_transfer_clk] } {
              set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_transfer_clk]
            } elseif { $tx_clkout_sel == "half-rate" && [dict exists $alt_xcvr_native_s10_pins $instance tx_pld_pcs_clk_reg] } {
              set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_pld_pcs_clk_reg]
            } elseif {$tx_clkout_sel == "div66" && [dict exists $alt_xcvr_native_s10_pins $instance tx_pld_pma_clkdiv_clk_reg] } {
              set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_pld_pma_clkdiv_clk_reg]
            } else {
             set source_nodes ""
            }

            if { $protocol_mode == "pll" && [dict exists $all_profile_clocks_names $profile tx_internal_div_reg_clks] } {
              set master_clocks [dict get $all_profile_clocks_names $profile tx_internal_div_reg_clks]
            } elseif {  $tx_clkout_sel == "full-rate" && [dict exists $all_profile_clocks_names $profile tx_internal_div_reg_clks] } {
              set master_clocks [dict get $all_profile_clocks_names $profile tx_internal_div_reg_clks]
            } elseif { $tx_clkout_sel == "half-rate" &&  [dict exists $all_profile_clocks_names $profile tx_pcs_reg_clks]} {
	      set master_clocks [dict get $all_profile_clocks_names $profile tx_pcs_reg_clks]
            } elseif { $tx_clkout_sel == "div66" &&  [dict exists $all_profile_clocks_names $profile tx_clkdiv_reg_clks]} {
	      set master_clocks [dict get $all_profile_clocks_names $profile tx_clkdiv_reg_clks]
            } else {
              set master_clocks ""
            }

           } elseif { $mode == "tx_mode_clkout2_clks" } {
		if { $native_debug } {
		   post_message -type info "IP SDC: tx_mode_clkout2_clks: alt_xcvr_native_s10_pins $instance = $alt_xcvr_native_s10_pins $instance"
		   }

            if { $protocol_mode == "pll" && [dict exists $alt_xcvr_native_s10_pins $instance tx_pld_pcs_clk_reg]} {
               set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_pld_pcs_clk_reg]
            } elseif { $tx_clkout2_sel == "full-rate" && [dict exists $alt_xcvr_native_s10_pins $instance tx_transfer_clk] } {
              set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_transfer_clk]
            } elseif { $tx_clkout2_sel == "half-rate" && [dict exists $alt_xcvr_native_s10_pins $instance tx_pld_pcs_clk_reg] } {
              set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_pld_pcs_clk_reg]
            } elseif { $tx_clkout2_sel == "div66" && [dict exists $alt_xcvr_native_s10_pins $instance tx_pld_pma_clkdiv_clk_reg] } {
              set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance tx_pld_pma_clkdiv_clk_reg]
            } else {
               set source_nodes ""
            }

            if { $protocol_mode == "pll" && [dict exists $all_profile_clocks_names $profile tx_pcs_reg_clks] } {
              set master_clocks [dict get $all_profile_clocks_names $profile tx_pcs_reg_clks]
            } elseif { $tx_clkout2_sel == "full-rate" && [dict exists $all_profile_clocks_names $profile tx_internal_div_reg_clks] } {
              set master_clocks [dict get $all_profile_clocks_names $profile tx_internal_div_reg_clks]
            } elseif { $tx_clkout2_sel == "half-rate" &&  [dict exists $all_profile_clocks_names $profile tx_pcs_reg_clks]} {
	      set master_clocks [dict get $all_profile_clocks_names $profile tx_pcs_reg_clks]
            } elseif { $tx_clkout2_sel == "div66" &&  [dict exists $all_profile_clocks_names $profile tx_clkdiv_reg_clks]} {
	      set master_clocks [dict get $all_profile_clocks_names $profile tx_clkdiv_reg_clks]
            } else {
              set master_clocks ""
            }

           } elseif { $mode == "rx_mode_clkout1_clks" } {
		if { $native_debug } {
		   post_message -type info "IP SDC: rx_mode_clkout1_clks: alt_xcvr_native_s10_pins $instance = $alt_xcvr_native_s10_pins $instance"
		   }
            if { $rx_clkout_sel == "full-rate" && [dict exists $alt_xcvr_native_s10_pins $instance rx_transfer_clk] } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_transfer_clk]
            } elseif { $rx_clkout_sel == "half-rate" && [dict exists $alt_xcvr_native_s10_pins $instance rx_pld_pcs_clk_reg] } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_pld_pcs_clk_reg]
            } elseif {$rx_clkout_sel == "div66" && [dict exists $alt_xcvr_native_s10_pins $instance rx_pld_pma_clkdiv_clk_reg]} {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_pld_pma_clkdiv_clk_reg]
            } else {
             set source_nodes ""
            }

            if {  $rx_clkout_sel == "full-rate" && [dict exists $all_profile_clocks_names $profile  rx_internal_div_reg_clks] } {
              set master_clocks [dict get $all_profile_clocks_names $profile  rx_internal_div_reg_clks]
            } elseif {$rx_clkout_sel == "half-rate" && [dict exists $all_profile_clocks_names $profile rx_pcs_reg_clks] } {
              set master_clocks [dict get $all_profile_clocks_names $profile  rx_pcs_reg_clks]
            } elseif { $rx_clkout_sel == "div66" &&  [dict exists $all_profile_clocks_names $profile rx_clkdiv_reg_clks]} {
	      set master_clocks [dict get $all_profile_clocks_names $profile  rx_clkdiv_reg_clks]
            } else {
              set master_clocks ""
            }

          } elseif { $mode == "rx_mode_clkout2_clks" } {
		if { $native_debug } {
		   post_message -type info "IP SDC: rx_mode_clkout2_clks: alt_xcvr_native_s10_pins $instance = $alt_xcvr_native_s10_pins $instance"
		   }
            if { $rx_clkout2_sel == "full-rate" && [dict exists $alt_xcvr_native_s10_pins $instance rx_transfer_clk] } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_transfer_clk]
            } elseif { $rx_clkout2_sel == "half-rate" && [dict exists $alt_xcvr_native_s10_pins $instance rx_pld_pcs_clk_reg] } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_pld_pcs_clk_reg]
            } elseif {$rx_clkout2_sel == "div66" && [dict exists $alt_xcvr_native_s10_pins $instance rx_pld_pma_clkdiv_clk_reg]} {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance rx_pld_pma_clkdiv_clk_reg]
            } else {
             set source_nodes ""
            }

            if {  $rx_clkout2_sel == "full-rate" && [dict exists $all_profile_clocks_names $profile  rx_internal_div_reg_clks] } {
              set master_clocks [dict get $all_profile_clocks_names $profile  rx_internal_div_reg_clks]
            } elseif {$rx_clkout2_sel == "half-rate" && [dict exists $all_profile_clocks_names $profile rx_pcs_reg_clks] } {
              set master_clocks [dict get $all_profile_clocks_names $profile  rx_pcs_reg_clks]
            } elseif { $rx_clkout2_sel == "div66" &&  [dict exists $all_profile_clocks_names $profile rx_clkdiv_reg_clks]} {
	      set master_clocks [dict get $all_profile_clocks_names $profile  rx_clkdiv_reg_clks]
            } else {
              set master_clocks ""
            }

          } elseif { $mode == "hclk_mode" } {
            set source_nodes  [dict get $alt_xcvr_native_s10_pins $instance hclk_internal_div_reg]
            set master_clocks [dict get $all_profile_clocks_names $profile  hclk_internal_div_reg_clks]

          } else {
            post_message -type warning "IP SDC Warning: Cannot find source node for $clk_group key in group $mode"
          }

          #Remap any backward slashes '' in the source clock nodes
          set source_nodes [string map {\\ \\\\} $source_nodes]

          # Create clks for all channels for a clk group in mode clk
		  if { $native_debug } {
             post_message -type info "IP SDC creating clocks"
             post_message -type info "source_nodes = $source_nodes"
             post_message -type info "master_clocks = $master_clocks"
             post_message -type info "source_nodes is not empty string = [expr [string compare $source_nodes ""]]"
             post_message -type info "master_clocks is not empty string = [expr [string compare $master_clocks ""]]"
	     }
		  if { [expr [string compare $source_nodes ""]] && [expr [string compare $master_clocks ""]] } {
          lappend list_of_clk_names [native_create_clocks_all_ch_isub23q $instance $clk_group $num_channels $clk_freq $clk_pins $profile_cnt $profile $source_nodes $master_clocks $multiply_factor $divide_factor $duty_cycle_factor]
		  }
        }
      }

     } else {
       if {$native_debug == 1} {
         post_message -type warning "IP SDC Warning: $clk_group key does not exist in pins dictionary"
       }
     }
  } ; # foreach clk_group in mode_clks

  return $list_of_clk_names

}

# ----------------------------------------------------------------------------- #
# ---                                                                       --- #
# --- Procedure to create HSSI clocks for all channels in an instance       --- #
# ---                                                                       --- #
# ----------------------------------------------------------------------------- #
proc native_create_clocks_all_ch_isub23q { instance clk_group num_channels freq clk_list profile_cnt profile args } {

  global ::GLOBAL_corename
  global ::native_debug

  set clock_name_list [list]
  set len_inst        [string length $instance]


  # Replace any '[' and ']' characters with with '?' since Tcl string matching doesn't work with explicit '[' and ']' characters
  set regex_instance [regsub -all {\[} $instance {?}]
  set regex_instance [regsub -all {\]} $regex_instance {?}]

  if { $native_debug == 1 } {
      post_message -type info "IP SDC: Instance_name_regex="
      post_message -type info  $regex_instance
  }

 # Iterate through all channels
  for { set channel 0 } { $channel < $num_channels } { incr channel } {

    # Match channel node with nodes in the clock group
    set channel_node_regexp $regex_instance|g_xcvr_native_insts?$channel?.ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct?_hssi*x*

    set channel_node_regexp [string map {\\ \\\\} $channel_node_regexp]
    if { $native_debug == 1 } {
      post_message -type info "IP SDC: clock_list= $clk_list nodes_regex="
      post_message -type info  $channel_node_regexp
    }
    set matching_clk_nodes  [lsearch -inline  $clk_list $channel_node_regexp]
    set matching_clk_nodes  [string map {\\ \\\\} $matching_clk_nodes]

    if { $native_debug == 1 } {
      post_message -type info "IP SDC: Matching Channel $channel nodes with $channel_node_regexp:"
      post_message -type info  $matching_clk_nodes
    }

    # Iterate through all nodes in the clock group
    foreach clk_node $matching_clk_nodes {

      # Remove the instance name from the clock node due to auto promotion in SDC_ENTITY
      set no_inst_clk_node [string replace $clk_node 0 $len_inst]

  if { $native_debug == 1 } {
      post_message -type info "IP SDC: clk_node=$no_inst_clk_node"
  }
      # Shorten the clock name if multiple profiles are not used
      if { $profile_cnt > 1 } {
        set clock_name $instance|profile$profile|$clk_group|ch$channel
      } else {
        set clock_name $instance|$clk_group|ch$channel
      }
      # Add the clock name to the list
      lappend clock_name_list $clock_name

      # Check if clock with same name already exists, if so skip clock creation
      set matching_clocks_list [get_clocks -nowarn $clock_name]

      if { [get_collection_size $matching_clocks_list] > 0 } {
        foreach_in_collection matching_clk $matching_clocks_list {

          # Check if clock is declared AND defined (i.e. create_clock or create_generated_clock was used)
          if { [is_clock_defined $clock_name] == 1 } {
            if { $native_debug == 1 } {
              post_message -type warning "Clock already exists with name $clock_name with period [get_clock_info $matching_clk -period]ns on node [get_object_info -name [get_clock_info $matching_clk -targets]]"
            }

          # Clock was declared, but not defined, so we need to create the clock still (i.e. "declare_clock" command was used)
          } else {

            if { $args != "" } {
              set source_nodes  [lindex $args 0]
              set master_clocks [lindex $args 1]

              set clk_source_node  [lindex $source_nodes  $channel]
              set clk_master_clock [lindex $master_clocks $channel]

              # Remove the instance name from the clock source node due to auto promotion in SDC_ENTITY
              set no_inst_clk_source_node [string replace $clk_source_node 0 $len_inst]

              set multiply_factor   [lindex $args 2]
              set divide_factor     [lindex $args 3]
              set duty_cycle_factor [lindex $args end]

              # Call procedure to create generated clock for given clock node
              native_create_clock_isub23q $clk_group $clock_name $freq $no_inst_clk_node $channel $no_inst_clk_source_node $clk_master_clock $multiply_factor $divide_factor $duty_cycle_factor

            } else {

              # Call procedure to create source clock for given clock node
              native_create_clock_isub23q $clk_group $clock_name $freq $no_inst_clk_node $channel
            }
          }
        }; #foreach_in_collection matching_clk matching_clocks_list

      # Create clock if no clock exists already with same name
      } else {


        if { $args != "" } {
          set source_nodes  [lindex $args 0]
          set master_clocks [lindex $args 1]

          set clk_source_node  [lindex $source_nodes  $channel]
          set clk_master_clock [lindex $master_clocks $channel]

          # Remove the instance name from the clock source node due to auto promotion in SDC_ENTITY
          set no_inst_clk_source_node [string replace $clk_source_node 0 $len_inst]

          set multiply_factor [lindex $args 2]
          set divide_factor     [lindex $args 3]
          set duty_cycle_factor [lindex $args end]

          # Call procedure to create generated clock for given clock node
          native_create_clock_isub23q $clk_group $clock_name $freq $no_inst_clk_node $channel $no_inst_clk_source_node $clk_master_clock $multiply_factor $divide_factor $duty_cycle_factor

        } else {

          # Call procedure to create source clock for given clock node
          native_create_clock_isub23q $clk_group $clock_name $freq $no_inst_clk_node $channel
        }
      }

    }; # foreach clk in clk_list
  }; # foreach channel

  # Return the list of clock names
  return $clock_name_list

}

# ----------------------------------------------------------------------------- #
# ---                                                                       --- #
# --- Procedure to create single HSSI clock for given node and clock name   --- #
# ---                                                                       --- #
# ----------------------------------------------------------------------------- #
proc native_create_clock_isub23q { clk_group clock_name freq clk_node channel args } {
  global ::native_debug
  global ::alt_xcvr_native_s10_target_clock_list_dict

  if { $native_debug == 1 } {
    post_message -type info "IP SDC: Clock name = $clock_name  Clock Node= $clk_node"
  }

  # Use "create_clock" for source nodes
  if { $clk_group == "tx_pma_parallel_clk" || $clk_group == "rx_pma_parallel_clk" || $clk_group == "rx_dl_pulse" || $clk_group == "tx_dl_pulse" || $clk_group == "tx_dl_pulse" || $clk_group == "tx_pld_pcs_clk" || $clk_group == "rx_pld_pcs_clk" || $clk_group == "tx_pld_pma_clkdiv_clk" || $clk_group == "rx_pld_pma_clkdiv_clk" || $clk_group == "pld_pma_hclk"  } {

    create_clock \
        -name    $clock_name \
        -period "$freq MHz" \
                 $clk_node -add

    # Add clock to target node key in the target clock list dictionary
    dict lappend alt_xcvr_native_s10_target_clock_list_dict $clk_node $clock_name

    if { $native_debug == 1 } {
      post_message -type info "IP SDC: Clocks on target node $clk_node"
      post_message -type info "                => [dict get $alt_xcvr_native_s10_target_clock_list_dict $clk_node]"
    }

  # Use "create_generated_clock" for the downstream nodes (*~aib_tx/rx_internal_div.reg and MAIB output pins)
  } elseif { $args != "" } {

    set clk_source_node   [lindex $args 0]
    set clk_master_clock  [lindex $args 1]
    set multiply_factor   [lindex $args 2]
    set divide_factor     [lindex $args 3]
    set duty_cycle_factor [lindex $args end]

    if { $native_debug == 1 } {
            post_message -type info "IP SDC: Source node is $clk_source_node"
            post_message -type info "        Master clock is $clk_master_clock"
    }

    create_generated_clock \
        -name         $clock_name \
        -source       $clk_source_node \
        -master_clock $clk_master_clock \
        -multiply_by  $multiply_factor \
        -divide_by    $divide_factor \
        -duty_cycle   $duty_cycle_factor \
                      $clk_node -add

    # Add clock to target node key in the target clock list dictionary
    dict lappend alt_xcvr_native_s10_target_clock_list_dict $clk_node $clock_name

    if { $native_debug == 1 } {
      post_message -type info "IP SDC: Clocks on target node $clk_node"
      post_message -type info "                => [dict get $alt_xcvr_native_s10_target_clock_list_dict $clk_node]"
    }

  }

}


# ----------------------------------------------------------------------------- #
# ---                                                                       --- #
# --- Procedure to adjust min pulse requirement for coreclkin2 to be        --- #
# --- frequency-dependency                                                  --- #
# ---                                                                       --- #
# ----------------------------------------------------------------------------- #
proc native_check_special_min_pulse_isub23q { clock_name } {
  global ::native_debug
  set pass 1

  # Find old active clocks, and then set all clocks active
  set old_active_clocks [get_active_clocks]
  set_active_clocks [all_clocks]

  set clock_spec_collection [get_clocks $clock_name]
  foreach_in_collection clock_spec $clock_spec_collection { }

  # Get clock period
  set period [get_clock_info -period $clock_spec]
  set frequency [expr 1 / $period * 1000]

  # Determine min pulse adjustment
  set frequency_list [list 0.0         501.0              600.0                 700.0                 800.0                 900.0                1000.0]
  set min_pulse_list [list 0.0 [expr 400.0-400.0] [expr 400.0 - 366.7]  [expr 400.0 - 342.9] [expr 400.0 - 325.0]  [expr 400.0 - 311.1] [expr 400.0 - 300.0] ]

  # Determine min pulse spec adjustment
  set i 0
  set min_pulse_adjustment 0.0
  foreach xfreq $frequency_list {
     if { $frequency <= $xfreq } {
        set min_pulse_adjustment [lindex $min_pulse_list [expr $i - 1]]
        break
     }
     incr i
  }

  # Get min pulse information
  set min_pulse_info [get_min_pulse_width $clock_name]
  set min_pulse_slack [lindex [lindex $min_pulse_info 0] 0]

  # If after the adjusment we are still negative, then output the min pulse report, and indicate the failure
  if {[expr $min_pulse_slack + $min_pulse_adjustment] < 0 } {
     report_min_pulse_width -nworst 100 -detail full_path -panel_name "Minimum Pulse Width: $clock_name" [get_clocks $clock_name]
     post_message -type critical_warning "Min Pulse Requirements on Tile Transfer not met; see DDR report for more details"
     set pass 0
  }


  set hold_only_corner [get_operating_conditions_info [get_operating_conditions] -is_hold_only]

  # Also make sure, nothing else is connected on this clock domain
  if {!$hold_only_corner} {
      set setup_from_paths_col    [get_timing_paths -from $clock_spec -setup]
      set setup_to_paths_col      [get_timing_paths -to   $clock_spec -setup]
      set recovery_from_paths_col [get_timing_paths -from $clock_spec -recovery]
      set recovery_to_paths_col   [get_timing_paths -to   $clock_spec -recovery]
  }

  set hold_from_paths_col     [get_timing_paths -from $clock_spec -hold]
  set hold_to_paths_col       [get_timing_paths -to   $clock_spec -hold]
  set removal_from_paths_col  [get_timing_paths -from $clock_spec -removal]
  set removal_to_paths_col    [get_timing_paths -to   $clock_spec -removal]

  set num_setup_from_paths    0
  set num_setup_to_paths      0
  set num_recovery_from_paths 0
  set num_recovery_to_paths   0

  if {!$hold_only_corner} {
      set num_setup_from_paths    [get_collection_size $setup_from_paths_col]
      set num_setup_to_paths      [get_collection_size $setup_to_paths_col]
      set num_recovery_from_paths [get_collection_size $recovery_from_paths_col]
      set num_recovery_to_paths   [get_collection_size $recovery_to_paths_col]
  }

  set num_hold_from_paths     [get_collection_size $hold_from_paths_col]
  set num_hold_to_paths       [get_collection_size $hold_to_paths_col]
  set num_removal_from_paths  [get_collection_size $removal_from_paths_col]
  set num_removal_to_paths    [get_collection_size $removal_to_paths_col]

  if { $native_debug == 1 } {
    post_message -type info "IP SDC: "
    post_message -type info "       num_setup_from    = $num_setup_from_paths"
    post_message -type info "       num_setup_to      = $num_setup_to_paths"
    post_message -type info "       num_hold_from     = $num_hold_from_paths"
    post_message -type info "       num_hold_to       = $num_hold_to_paths"
    post_message -type info "       num_recovery_from = $num_recovery_from_paths"
    post_message -type info "       num_recovery_to   = $num_recovery_to_paths"
    post_message -type info "       num_removal_from  = $num_removal_from_paths"
    post_message -type info "       num_removal_to    = $num_removal_to_paths"
  }

  if {($num_setup_from_paths > 0) || ($num_setup_to_paths > 0) || ($num_hold_from_paths > 0) || ($num_hold_to_paths > 0) || ($num_recovery_from_paths > 0) || ($num_recovery_to_paths > 0) || ($num_removal_from_paths > 0) || ($num_removal_to_paths > 0)} {
     set pass 1

     # ----------------------------------------------------
     # Print out path information for SETUP FROM paths
     # ----------------------------------------------------
     if { $num_setup_from_paths > 0 } {
       foreach_in_collection path $setup_from_paths_col {
         set source_node [get_node_info  -name [get_path_info -from $path]]
         set dest_node   [get_node_info  -name [get_path_info -to $path]]
         set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
         set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
         post_message -type critical_warning "Unexpected timed setup path
        From: $source_node
        To: $dest_node
        Source Clock: $source_clk
        Destination Clock: $dest_clk"
       }

       # Set pass to zero
			 set pass 0

     }

     # ----------------------------------------------------
     # Print out path information for SETUP TO paths
     # ----------------------------------------------------
     if { $num_setup_to_paths > 0 } {
       foreach_in_collection path $setup_to_paths_col {
         set source_node [get_node_info  -name [get_path_info -from $path]]
         set dest_node   [get_node_info  -name [get_path_info -to $path]]
         set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
         set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
         post_message -type critical_warning "Unexpected timed setup path
        From: $source_node
        To: $dest_node
        Source Clock: $source_clk
        Destination Clock: $dest_clk"
       }

       # Set pass to zero
			 set pass 0

     }

     # ----------------------------------------------------
     # Print out path information for HOLD FROM paths
     # ----------------------------------------------------
     if { $num_hold_from_paths > 0 } {
       foreach_in_collection path $hold_from_paths_col {
         set source_node [get_node_info  -name [get_path_info -from $path]]
         set dest_node   [get_node_info  -name [get_path_info -to $path]]
         set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
         set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
         post_message -type critical_warning "Unexpected timed hold path
        From: $source_node
        To: $dest_node
        Source Clock: $source_clk
        Destination Clock: $dest_clk"
       }

       # Set pass to zero
			 set pass 0

     }

     # ----------------------------------------------------
     # Print out path information for HOLD TO paths
     # ----------------------------------------------------
     if { $num_hold_to_paths > 0 } {
       foreach_in_collection path $hold_to_paths_col {
         set source_node [get_node_info  -name [get_path_info -from $path]]
         set dest_node   [get_node_info  -name [get_path_info -to $path]]
         set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
         set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
         post_message -type critical_warning "Unexpected timed hold path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
       }

       # Set pass to zero
			 set pass 0

     }

     # ----------------------------------------------------
     # Print out path information for RECOVERY FROM paths
     # ----------------------------------------------------
     if { $num_recovery_from_paths > 0 } {
       foreach_in_collection path $recovery_from_paths_col {
         set source_node [get_node_info  -name [get_path_info -from $path]]
         set dest_node   [get_node_info  -name [get_path_info -to $path]]
         set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
         set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
         post_message -type critical_warning "Unexpected timed recovery path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
       }

       # Set pass to zero
			 set pass 0

     }

     # ----------------------------------------------------
     # Print out path information for REMOVAL FROM paths
     # ----------------------------------------------------
     if { $num_removal_from_paths > 0 } {
       foreach_in_collection path $removal_from_paths_col {
         set source_node [get_node_info -name [get_path_info -from $path]]
         set dest_node   [get_node_info -name [get_path_info -to $path]]
         set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
         set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
         post_message -type critical_warning "Unexpected timed removal path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
       }

       # Set pass to zero
			 set pass 0

     }

     # ----------------------------------------------------
     # Print out path information for RECOVERY TO paths
     # ----------------------------------------------------
     if { $num_recovery_to_paths > 0 } {

       # Initialize the number of found reset paths to zero
       set num_reset_recovery_paths 0

       foreach_in_collection path $recovery_to_paths_col {

         # Check the arrival path points to see if one of them is the reset pin (we should ignore this transfer)
         set arrival_pts_col [get_path_info -arrival_points $path]
         set found_reset_recovery_path 0

         foreach_in_collection point $arrival_pts_col {

           # Only check the node points
           set pt_node_id [get_point_info -node $point]

           if { $pt_node_id != "" } {
             set pt_node_name [get_node_info -name $pt_node_id]
             set reset_pin_regex "*|g_xcvr_native_insts*.ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n"

             if {[string match $reset_pin_regex $pt_node_name]} {
               # Increment the number of found reset recovery paths
               incr found_reset_recovery_path
               incr num_reset_recovery_paths
               break
             }

           }
         }; #foreach point in arrival_pts_col

         # Check to ensure the slack is positive
         set path_slack [get_path_info -slack $path]
         if { $path_slack < 0 } {
           set found_reset_recovery_path 0
         }

         # Print out the path info if no reset path was found
         if { $found_reset_recovery_path == 0 } {
           set source_node [get_node_info  -name [get_path_info -from $path]]
           set dest_node   [get_node_info  -name [get_path_info -to $path]]
           set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
           set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
           post_message -type critical_warning "Unexpected timed recovery path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
         }
       }; #foreach path in recovery_to_paths_col

       # If the number of reset paths found matches the number of recovery paths, then we can ignore the transfers
       if { $num_reset_recovery_paths != $num_recovery_to_paths } {
         # Set pass to zero
			   set pass 0

         if { $native_debug == 1 } {
           post_message -type warning "IP SDC: num_reset_recovery_paths = $num_reset_recovery_paths"
         }
       }
     }

     # ----------------------------------------------------
     # Print out path information for REMOVAL TO paths
     # ----------------------------------------------------
     if { $num_removal_to_paths > 0 } {

       # Initialize the number of found reset paths to zero
       set num_reset_removal_paths 0

       foreach_in_collection path $removal_to_paths_col {

         # Check the arrival path points to see if one of them is the reset pin (we should ignore this transfer)
         set arrival_pts_col [get_path_info -arrival_points $path]
         set found_reset_removal_path 0

         foreach_in_collection point $arrival_pts_col {

           # Only check the node points
           set pt_node_id [get_point_info -node $point]

           if { $pt_node_id != "" } {
             set pt_node_name [get_node_info -name $pt_node_id]
             set reset_pin_regex "*|g_xcvr_native_insts*.ct3_xcvr_native_inst|inst_ct3_xcvr_channel|inst_ct1_hssi_pldadapt_tx|pld_adapter_tx_pld_rst_n"


             if {[string match $reset_pin_regex $pt_node_name]} {
               # Increment the number of found reset recovery paths
               incr found_reset_removal_path
               incr num_reset_removal_paths
               break
             }

           }
         }; #foreach point in arrival_pts_col

         # Check to ensure the slack is positive
         set path_slack [get_path_info -slack $path]
         if { $path_slack < 0 } {
           set found_reset_removal_path 0
         }

         # Print out the path info if no reset path was found
         if { $found_reset_removal_path == 0 } {
           set source_node [get_node_info  -name [get_path_info -from $path]]
           set dest_node   [get_node_info  -name [get_path_info -to $path]]
           set source_clk  [get_clock_info -name [get_path_info -from_clock $path]]
           set dest_clk    [get_clock_info -name [get_path_info -to_clock $path]]
           post_message -type critical_warning "Unexpected timed removal path
    From: $source_node
    To: $dest_node
    Source Clock: $source_clk
    Destination Clock: $dest_clk"
         }
       }; #foreach path in removal_to_paths_col

       # If the number of reset paths found matches the number of removal paths, then we can ignore the transfers
       if { $num_reset_removal_paths != $num_removal_to_paths } {
         # Set pass to zero
			   set pass 0

         if { $native_debug == 1 } {
           post_message -type warning "IP SDC: num_reset_removal_paths = $num_reset_removal_paths"
         }
       }
    }

  }; #if { num_setup_from_paths > 0 || ... || ... }

  # Check if min pulse width passed
  if { $pass == 0 } {
     post_message -type critical_warning "Timing requirements not met"
  }

  # Before returning set the active clocks to the ones that were active before entering this function
  set_active_clocks $old_active_clocks
}
