# TCL File Generated by Component Editor 24.1
# Tue Sep 17 20:50:35 PDT 2024
# DO NOT MODIFY


#
# cpl_eth_excr "cpl_eth_excr" v1.0
# Intel Corporation 2024.09.17.20:50:35
#
#

#
# request TCL package from ACDS 24.1
#
package require -exact qsys 24.1


#
# module cpl_eth_excr
#
set_module_property DESCRIPTION ""
set_module_property NAME cpl_eth_excr
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property BSP_CPU false
set_module_property GROUP "CPL Exercisers"
set_module_property AUTHOR "Intel Corporation"
set_module_property DISPLAY_NAME cpl_eth_excr
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK true
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false
set_module_property LOAD_ELABORATION_LIMIT 0
set_module_property PRE_COMP_MODULE_ENABLED false


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL cpl_eth_excr
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file he_hssi_top.sv SYSTEM_VERILOG PATH cpl_eth_excr/he_hssi_top.sv
add_fileset_file csr_reg.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/csr_reg.sv
add_fileset_file eth_rx_axis_cdc_fifo.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/eth_rx_axis_cdc_fifo.sv
add_fileset_file eth_traffic_csr.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/eth_traffic_csr.sv
add_fileset_file eth_traffic_csr_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/eth_traffic_csr_pkg.sv
add_fileset_file eth_traffic_pcie_axil_csr.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/eth_traffic_pcie_axil_csr.sv
add_fileset_file mm_ctrl_xcvr.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/mm_ctrl_xcvr.sv
add_fileset_file multi_port_axi_traffic_ctrl.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/multi_port_axi_traffic_ctrl.sv
add_fileset_file multi_port_traffic_ctrl.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/multi_port_traffic_ctrl.sv
add_fileset_file pulse_sync.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/pulse_sync.sv
add_fileset_file traffic_controller_wrapper.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/common/traffic_controller_wrapper.sv
add_fileset_file crc32_dat16.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat16.v
add_fileset_file crc32_dat24.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat24.v
add_fileset_file crc32_dat32.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat32.v
add_fileset_file crc32_dat32_any_byte.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat32_any_byte.v
add_fileset_file crc32_dat40.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat40.v
add_fileset_file crc32_dat48.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat48.v
add_fileset_file crc32_dat56.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat56.v
add_fileset_file crc32_dat64.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat64.v
add_fileset_file crc32_dat64_any_byte.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat64_any_byte.v
add_fileset_file crc32_dat8.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc32_dat8.v
add_fileset_file crc_ethernet.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc_ethernet.v
add_fileset_file crc_register.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/crc_register.v
add_fileset_file xor6.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_lib/xor6.v
add_fileset_file avalon_st_to_crc_if_bridge.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/avalon_st_to_crc_if_bridge.v
add_fileset_file bit_endian_converter.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/bit_endian_converter.v
add_fileset_file byte_endian_converter.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/byte_endian_converter.v
add_fileset_file crc32.qip OTHER PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32.qip
add_fileset_file crc32.sdc SDC PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32.sdc
add_fileset_file crc32_calculator.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_calculator.v
add_fileset_file crc32_chk.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_chk.v
add_fileset_file crc32_gen.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc32_gen.v
add_fileset_file crc_checksum_aligner.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc_checksum_aligner.v
add_fileset_file crc_comparator.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/crc32/crc_comparator.v
add_fileset_file avalon_st_gen.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/avalon_st_gen.v
add_fileset_file avalon_st_loopback.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/avalon_st_loopback.sv
add_fileset_file avalon_st_loopback_csr.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/avalon_st_loopback_csr.v
add_fileset_file avalon_st_mon.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/avalon_st_mon.v
add_fileset_file avalon_st_prtmux.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/avalon_st_prtmux.v
add_fileset_file eth_std_traffic_controller_top.qip OTHER PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/eth_std_traffic_controller_top.qip
add_fileset_file eth_std_traffic_controller_top.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/eth_std_traffic_controller_top.v
add_fileset_file shiftreg_ctrl.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/shiftreg_ctrl.v
add_fileset_file shiftreg_data.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/eth_traffic_controller/shiftreg_data.v
add_fileset_file alt_aeuex_packet_client_tx.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_aeuex_packet_client_tx.v
add_fileset_file alt_aeuex_pkt_gen_sync.v VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_aeuex_pkt_gen_sync.v
add_fileset_file alt_e100s10_data_block_buffer.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_e100s10_data_block_buffer.sv
add_fileset_file alt_e100s10_data_synchronizer.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_e100s10_data_synchronizer.sv
add_fileset_file alt_e100s10_frame_buffer.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_e100s10_frame_buffer.sv
add_fileset_file alt_e100s10_loopback_client.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_e100s10_loopback_client.sv
add_fileset_file alt_e100s10_packet_client.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_e100s10_packet_client.sv
add_fileset_file alt_e100s10_pointer_synchronizer.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_e100s10_pointer_synchronizer.sv
add_fileset_file alt_e100s10_ready_skid.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/pkt_client_100g/alt_e100s10_ready_skid.sv
add_fileset_file ofs_fim_eth_avst_if.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/inc/ofs_fim_eth_avst_if.sv
add_fileset_file ofs_fim_eth_avst_if_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/inc/ofs_fim_eth_avst_if_pkg.sv
add_fileset_file ofs_fim_eth_if.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/inc/ofs_fim_eth_if.sv
add_fileset_file ofs_fim_eth_if_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/inc/ofs_fim_eth_if_pkg.sv
add_fileset_file ofs_fim_eth_plat_defines.svh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_fim_eth_plat_defines.svh
add_fileset_file ofs_fim_eth_plat_if_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/inc/ofs_fim_eth_plat_if_pkg.sv
add_fileset_file alt_aeuex_user_mode_det.v VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/lib/alt_aeuex_user_mode_det.v
add_fileset_file alt_ehipc3_fm_altera_std_synchronizer_nocut.v VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/lib/alt_ehipc3_fm_altera_std_synchronizer_nocut.v
add_fileset_file alt_ehipc3_fm_mlab.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/lib/alt_ehipc3_fm_mlab.sv
add_fileset_file alt_ehipc3_fm_reset_synchronizer.v VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/lib/alt_ehipc3_fm_reset_synchronizer.v
add_fileset_file alt_ehipc3_fm_status_sync.v VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/lib/alt_ehipc3_fm_status_sync.v
add_fileset_file ofs_fim_eth_afu_avst_to_fim_axis_bridge.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/lib/ofs_fim_eth_afu_avst_to_fim_axis_bridge.sv
add_fileset_file ofs_fim_eth_afu_axi_2_avst_bridge.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/lib/ofs_fim_eth_afu_axi_2_avst_bridge.sv
add_fileset_file ofs_fim_eth_afu_axi_2_avst_bridge.sv.bak OTHER PATH cpl_eth_excr/ipss/hssi/rtl/lib/ofs_fim_eth_afu_axi_2_avst_bridge.sv.bak
add_fileset_file ofs_fim_hssi_axis_connect.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/lib/ofs_fim_hssi_axis_connect.sv
add_fileset_file fpga_defines.vh OTHER PATH cpl_eth_excr/src/includes/fpga_defines.vh
add_fileset_file ofs_avmm_if.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_avmm_if.sv
add_fileset_file ofs_csr_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_csr_pkg.sv
add_fileset_file ofs_fim_axi_lite_if.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_fim_axi_lite_if.sv
add_fileset_file ofs_fim_axi_mmio_if.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_fim_axi_mmio_if.sv
add_fileset_file ofs_fim_if_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_fim_if_pkg.sv
add_fileset_file ofs_ip_cfg_db.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_ip_cfg_db.vh
add_fileset_file ofs_ip_cfg_hssi_ss.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_ip_cfg_hssi_ss.vh
add_fileset_file ofs_ip_cfg_mem_ss.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_ip_cfg_mem_ss.vh
add_fileset_file ofs_ip_cfg_pcie_ss.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_ip_cfg_pcie_ss.vh
add_fileset_file ofs_ip_cfg_soc_pcie_ss.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_ip_cfg_soc_pcie_ss.vh
add_fileset_file ofs_ip_cfg_sys_clk.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_ip_cfg_sys_clk.vh
add_fileset_file ofs_pcie_ss_cfg.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_pcie_ss_cfg.vh
add_fileset_file ofs_pcie_ss_cfg_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/ofs_pcie_ss_cfg_pkg.sv
add_fileset_file pcie_ss_axis_if.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/pcie_ss_axis_if.sv
add_fileset_file pcie_ss_axis_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/pcie_ss_axis_pkg.sv
add_fileset_file pcie_ss_hdr_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/pcie_ss_hdr_pkg.sv
add_fileset_file pcie_ss_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/includes/pcie_ss_pkg.sv
add_fileset_file vendor_defines.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/includes/vendor_defines.vh
add_fileset_file axi_register.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/axi/axi_register.sv
add_fileset_file axis_pipeline.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/axis/axis_pipeline.sv
add_fileset_file axis_register.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/axis/axis_register.sv
add_fileset_file bfifo.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/fifo/bfifo.sv
#add_fileset_file fim_dcfifo.sdc SDC PATH cpl_eth_excr/ofs-common/src/common/lib/fifo/fim_dcfifo.sdc
add_fileset_file Nmux.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/mux/Nmux.sv
add_fileset_file pf_vf_mux_default_rtable.vh OTHER PATH cpl_eth_excr/ofs-common/src/common/lib/mux/pf_vf_mux_default_rtable.vh
add_fileset_file pf_vf_mux_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/mux/pf_vf_mux_pkg.sv
add_fileset_file pf_vf_mux_w_params.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/mux/pf_vf_mux_w_params.sv
add_fileset_file switch.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/mux/switch.sv
add_fileset_file gram_sdp.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/ram/gram_sdp.sv
add_fileset_file ram_1r1w.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/ram/ram_1r1w.sv
add_fileset_file altera_std_synchronizer_nocut.v VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/sync/altera_std_synchronizer_nocut.v
add_fileset_file fim_cross_handshake.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/sync/fim_cross_handshake.sv
add_fileset_file fim_cross_strobe.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/sync/fim_cross_strobe.sv
add_fileset_file fim_resync.sv SYSTEM_VERILOG PATH cpl_eth_excr/ofs-common/src/common/lib/sync/fim_resync.sv
add_fileset_file fabric_width_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/src/includes/fabric_width_pkg.sv
add_fileset_file ofs_fim_cfg_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/src/includes/ofs_fim_cfg_pkg.sv
add_fileset_file ofs_pcie_ss_plat_cfg.vh OTHER PATH cpl_eth_excr/src/includes/ofs_pcie_ss_plat_cfg.vh
add_fileset_file ofs_pcie_ss_plat_cfg_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/src/includes/ofs_pcie_ss_plat_cfg_pkg.sv
add_fileset_file ofs_fim_pcie_pkg.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/inc/ofs_fim_pcie_pkg.sv
add_fileset_file ofs_fim_pcie_hdr_def.sv SYSTEM_VERILOG PATH cpl_eth_excr/ipss/hssi/rtl/inc/ofs_fim_pcie_hdr_def.sv
add_fileset_file axi2avmmbridge.sv SYSTEM_VERILOG PATH cpl_eth_excr/hw/rtl/he_hssi/cpl_bridges/axi2avmmbridge.sv
add_fileset_file cpl_eth_excr.sv SYSTEM_VERILOG PATH cpl_eth_excr/cpl_eth_excr.sv TOP_LEVEL_FILE
add_fileset_file eth100_avst_pkg.vhd VHDL PATH cpl_eth_excr/ipss/hssi/e_tile/eth100_avst_pkg.vhd


#
# parameters
#
add_parameter ETH_PKT_WIDTH INTEGER 64 ""
set_parameter_property ETH_PKT_WIDTH DEFAULT_VALUE 64
set_parameter_property ETH_PKT_WIDTH DISPLAY_NAME ETH_PKT_WIDTH
set_parameter_property ETH_PKT_WIDTH UNITS None
set_parameter_property ETH_PKT_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ETH_PKT_WIDTH DESCRIPTION ""
set_parameter_property ETH_PKT_WIDTH AFFECTS_GENERATION false
set_parameter_property ETH_PKT_WIDTH HDL_PARAMETER true
set_parameter_property ETH_PKT_WIDTH EXPORT true
add_parameter ETH_EOP_WIDTH INTEGER 1 ""
set_parameter_property ETH_EOP_WIDTH DEFAULT_VALUE 1
set_parameter_property ETH_EOP_WIDTH DISPLAY_NAME ETH_EOP_WIDTH
set_parameter_property ETH_EOP_WIDTH UNITS None
set_parameter_property ETH_EOP_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ETH_EOP_WIDTH DESCRIPTION ""
set_parameter_property ETH_EOP_WIDTH AFFECTS_GENERATION false
set_parameter_property ETH_EOP_WIDTH HDL_PARAMETER true
set_parameter_property ETH_EOP_WIDTH EXPORT true
add_parameter AVMM_ADDRW INTEGER 17
set_parameter_property AVMM_ADDRW DEFAULT_VALUE 17
set_parameter_property AVMM_ADDRW DISPLAY_NAME AVMM_ADDRW
set_parameter_property AVMM_ADDRW UNITS None
set_parameter_property AVMM_ADDRW ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AVMM_ADDRW AFFECTS_GENERATION false
set_parameter_property AVMM_ADDRW HDL_PARAMETER true
set_parameter_property AVMM_ADDRW EXPORT true
add_parameter AVMM_DATAW INTEGER 32
set_parameter_property AVMM_DATAW DEFAULT_VALUE 32
set_parameter_property AVMM_DATAW DISPLAY_NAME AVMM_DATAW
set_parameter_property AVMM_DATAW UNITS None
set_parameter_property AVMM_DATAW ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AVMM_DATAW AFFECTS_GENERATION false
set_parameter_property AVMM_DATAW HDL_PARAMETER true
set_parameter_property AVMM_DATAW EXPORT true
add_parameter AVMM_BYTEENW INTEGER 4
set_parameter_property AVMM_BYTEENW DEFAULT_VALUE 4
set_parameter_property AVMM_BYTEENW DISPLAY_NAME AVMM_BYTEENW
set_parameter_property AVMM_BYTEENW UNITS None
set_parameter_property AVMM_BYTEENW ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AVMM_BYTEENW AFFECTS_GENERATION false
set_parameter_property AVMM_BYTEENW HDL_PARAMETER true
set_parameter_property AVMM_BYTEENW EXPORT true
add_parameter MAX_ETH_CH INTEGER 0
set_parameter_property MAX_ETH_CH DEFAULT_VALUE 0
set_parameter_property MAX_ETH_CH DISPLAY_NAME MAX_ETH_CH
set_parameter_property MAX_ETH_CH UNITS None
set_parameter_property MAX_ETH_CH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property MAX_ETH_CH AFFECTS_GENERATION false
set_parameter_property MAX_ETH_CH HDL_PARAMETER true
set_parameter_property MAX_ETH_CH EXPORT true
add_parameter AXI4L_ADDR_WIDTH INTEGER 17
set_parameter_property AXI4L_ADDR_WIDTH DEFAULT_VALUE 17
set_parameter_property AXI4L_ADDR_WIDTH DISPLAY_NAME AXI4L_ADDR_WIDTH
set_parameter_property AXI4L_ADDR_WIDTH UNITS None
set_parameter_property AXI4L_ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AXI4L_ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property AXI4L_ADDR_WIDTH HDL_PARAMETER true
set_parameter_property AXI4L_ADDR_WIDTH EXPORT true
add_parameter AXI4L_DATA_WIDTH INTEGER 32
set_parameter_property AXI4L_DATA_WIDTH DEFAULT_VALUE 32
set_parameter_property AXI4L_DATA_WIDTH DISPLAY_NAME AXI4L_DATA_WIDTH
set_parameter_property AXI4L_DATA_WIDTH UNITS None
set_parameter_property AXI4L_DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AXI4L_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property AXI4L_DATA_WIDTH HDL_PARAMETER true
set_parameter_property AXI4L_DATA_WIDTH EXPORT true
add_parameter AXI4L_RRESP_WIDTH INTEGER 2
set_parameter_property AXI4L_RRESP_WIDTH DEFAULT_VALUE 2
set_parameter_property AXI4L_RRESP_WIDTH DISPLAY_NAME AXI4L_RRESP_WIDTH
set_parameter_property AXI4L_RRESP_WIDTH UNITS None
set_parameter_property AXI4L_RRESP_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AXI4L_RRESP_WIDTH AFFECTS_GENERATION false
set_parameter_property AXI4L_RRESP_WIDTH HDL_PARAMETER true
set_parameter_property AXI4L_RRESP_WIDTH EXPORT true
add_parameter AXI4L_WSTRB_WIDTH INTEGER 4
set_parameter_property AXI4L_WSTRB_WIDTH DEFAULT_VALUE 4
set_parameter_property AXI4L_WSTRB_WIDTH DISPLAY_NAME AXI4L_WSTRB_WIDTH
set_parameter_property AXI4L_WSTRB_WIDTH UNITS None
set_parameter_property AXI4L_WSTRB_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AXI4L_WSTRB_WIDTH AFFECTS_GENERATION false
set_parameter_property AXI4L_WSTRB_WIDTH HDL_PARAMETER true
set_parameter_property AXI4L_WSTRB_WIDTH EXPORT true
add_parameter AXI4L_BRESP_WIDTH INTEGER 2
set_parameter_property AXI4L_BRESP_WIDTH DEFAULT_VALUE 2
set_parameter_property AXI4L_BRESP_WIDTH DISPLAY_NAME AXI4L_BRESP_WIDTH
set_parameter_property AXI4L_BRESP_WIDTH UNITS None
set_parameter_property AXI4L_BRESP_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property AXI4L_BRESP_WIDTH AFFECTS_GENERATION false
set_parameter_property AXI4L_BRESP_WIDTH HDL_PARAMETER true
set_parameter_property AXI4L_BRESP_WIDTH EXPORT true
add_parameter G_QSFP_TYPE STRING NRZ
set_parameter_property G_QSFP_TYPE DEFAULT_VALUE NRZ
set_parameter_property G_QSFP_TYPE DISPLAY_NAME G_QSFP_TYPE
set_parameter_property G_QSFP_TYPE UNITS None
set_parameter_property G_QSFP_TYPE AFFECTS_GENERATION false
set_parameter_property G_QSFP_TYPE HDL_PARAMETER true
set_parameter_property G_QSFP_TYPE EXPORT true
add_parameter G_E_TILE_REFCLK INTEGER 3
set_parameter_property G_E_TILE_REFCLK DEFAULT_VALUE 3
set_parameter_property G_E_TILE_REFCLK DISPLAY_NAME G_E_TILE_REFCLK
set_parameter_property G_E_TILE_REFCLK UNITS None
set_parameter_property G_E_TILE_REFCLK ALLOWED_RANGES -2147483648:2147483647
set_parameter_property G_E_TILE_REFCLK AFFECTS_GENERATION false
set_parameter_property G_E_TILE_REFCLK HDL_PARAMETER true
set_parameter_property G_E_TILE_REFCLK EXPORT true
add_parameter G_FPGA_FAMILY STRING Agilex
set_parameter_property G_FPGA_FAMILY DEFAULT_VALUE Agilex
set_parameter_property G_FPGA_FAMILY DISPLAY_NAME G_FPGA_FAMILY
set_parameter_property G_FPGA_FAMILY UNITS None
set_parameter_property G_FPGA_FAMILY AFFECTS_GENERATION false
set_parameter_property G_FPGA_FAMILY HDL_PARAMETER true
set_parameter_property G_FPGA_FAMILY EXPORT true
add_parameter G_FPGA_PINOUT STRING A0
set_parameter_property G_FPGA_PINOUT DEFAULT_VALUE A0
set_parameter_property G_FPGA_PINOUT DISPLAY_NAME G_FPGA_PINOUT
set_parameter_property G_FPGA_PINOUT UNITS None
set_parameter_property G_FPGA_PINOUT AFFECTS_GENERATION false
set_parameter_property G_FPGA_PINOUT HDL_PARAMETER true
set_parameter_property G_FPGA_PINOUT EXPORT true


#
# display items
#


#
# connection point clock
#
add_interface clock clock end
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""
set_interface_property clock IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property clock SV_INTERFACE_TYPE ""
set_interface_property clock SV_INTERFACE_MODPORT_TYPE ""

add_interface_port clock clk clk Input 1


#
# connection point reset_n
#
add_interface reset_n reset end
set_interface_property reset_n associatedClock ""
set_interface_property reset_n synchronousEdges NONE
set_interface_property reset_n ENABLED true
set_interface_property reset_n EXPORT_OF ""
set_interface_property reset_n PORT_NAME_MAP ""
set_interface_property reset_n CMSIS_SVD_VARIABLES ""
set_interface_property reset_n SVD_ADDRESS_GROUP ""
set_interface_property reset_n IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property reset_n SV_INTERFACE_TYPE ""
set_interface_property reset_n SV_INTERFACE_MODPORT_TYPE ""

add_interface_port reset_n reset_n reset_n Input 1


#
# connection point eth_rx_cmac_clk
#
add_interface eth_rx_cmac_clk clock end
set_interface_property eth_rx_cmac_clk ENABLED true
set_interface_property eth_rx_cmac_clk EXPORT_OF ""
set_interface_property eth_rx_cmac_clk PORT_NAME_MAP ""
set_interface_property eth_rx_cmac_clk CMSIS_SVD_VARIABLES ""
set_interface_property eth_rx_cmac_clk SVD_ADDRESS_GROUP ""
set_interface_property eth_rx_cmac_clk IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property eth_rx_cmac_clk SV_INTERFACE_TYPE ""
set_interface_property eth_rx_cmac_clk SV_INTERFACE_MODPORT_TYPE ""

add_interface_port eth_rx_cmac_clk eth_rx_cmac_avl_clk_0 clk Input 1


#
# connection point eth_rx_cmac_avst_0
#
add_interface eth_rx_cmac_avst_0 avalon_streaming end
set_interface_property eth_rx_cmac_avst_0 associatedClock eth_rx_cmac_clk
set_interface_property eth_rx_cmac_avst_0 associatedReset reset_n
set_interface_property eth_rx_cmac_avst_0 dataBitsPerSymbol 8
set_interface_property eth_rx_cmac_avst_0 errorDescriptor ""
set_interface_property eth_rx_cmac_avst_0 firstSymbolInHighOrderBits true
set_interface_property eth_rx_cmac_avst_0 maxChannel 0
set_interface_property eth_rx_cmac_avst_0 readyAllowance 0
set_interface_property eth_rx_cmac_avst_0 readyLatency 0
set_interface_property eth_rx_cmac_avst_0 ENABLED true
set_interface_property eth_rx_cmac_avst_0 EXPORT_OF ""
set_interface_property eth_rx_cmac_avst_0 PORT_NAME_MAP ""
set_interface_property eth_rx_cmac_avst_0 CMSIS_SVD_VARIABLES ""
set_interface_property eth_rx_cmac_avst_0 SVD_ADDRESS_GROUP ""
set_interface_property eth_rx_cmac_avst_0 IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property eth_rx_cmac_avst_0 SV_INTERFACE_TYPE ""
set_interface_property eth_rx_cmac_avst_0 SV_INTERFACE_MODPORT_TYPE ""

add_interface_port eth_rx_cmac_avst_0 eth_rx_cmac_avl_sop_0 startofpacket Input 1
add_interface_port eth_rx_cmac_avst_0 eth_rx_cmac_avl_valid_0 valid Input 1
add_interface_port eth_rx_cmac_avst_0 eth_rx_cmac_avl_eop_0 endofpacket Input 1
add_interface_port eth_rx_cmac_avst_0 eth_rx_cmac_avl_data_0 data Input 64
add_interface_port eth_rx_cmac_avst_0 eth_rx_cmac_avl_empty_0 empty Input 3


#
# connection point eth_tx_cmac_clk
#
add_interface eth_tx_cmac_clk clock end
set_interface_property eth_tx_cmac_clk ENABLED true
set_interface_property eth_tx_cmac_clk EXPORT_OF ""
set_interface_property eth_tx_cmac_clk PORT_NAME_MAP ""
set_interface_property eth_tx_cmac_clk CMSIS_SVD_VARIABLES ""
set_interface_property eth_tx_cmac_clk SVD_ADDRESS_GROUP ""
set_interface_property eth_tx_cmac_clk IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property eth_tx_cmac_clk SV_INTERFACE_TYPE ""
set_interface_property eth_tx_cmac_clk SV_INTERFACE_MODPORT_TYPE ""

add_interface_port eth_tx_cmac_clk eth_tx_cmac_avl_clk_0 clk Input 1


#
# connection point eth_tx_cmac_avst_0
#
add_interface eth_tx_cmac_avst_0 avalon_streaming start
set_interface_property eth_tx_cmac_avst_0 associatedClock eth_tx_cmac_clk
set_interface_property eth_tx_cmac_avst_0 associatedReset reset_n
set_interface_property eth_tx_cmac_avst_0 dataBitsPerSymbol 8
set_interface_property eth_tx_cmac_avst_0 errorDescriptor ""
set_interface_property eth_tx_cmac_avst_0 firstSymbolInHighOrderBits true
set_interface_property eth_tx_cmac_avst_0 maxChannel 0
set_interface_property eth_tx_cmac_avst_0 readyAllowance 0
set_interface_property eth_tx_cmac_avst_0 readyLatency 0
set_interface_property eth_tx_cmac_avst_0 ENABLED true
set_interface_property eth_tx_cmac_avst_0 EXPORT_OF ""
set_interface_property eth_tx_cmac_avst_0 PORT_NAME_MAP ""
set_interface_property eth_tx_cmac_avst_0 CMSIS_SVD_VARIABLES ""
set_interface_property eth_tx_cmac_avst_0 SVD_ADDRESS_GROUP ""
set_interface_property eth_tx_cmac_avst_0 IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property eth_tx_cmac_avst_0 SV_INTERFACE_TYPE ""
set_interface_property eth_tx_cmac_avst_0 SV_INTERFACE_MODPORT_TYPE ""

add_interface_port eth_tx_cmac_avst_0 eth_tx_cmac_avl_rdy_0 ready Input 1
add_interface_port eth_tx_cmac_avst_0 eth_tx_cmac_avl_sop_0 startofpacket Output 1
add_interface_port eth_tx_cmac_avst_0 eth_tx_cmac_avl_valid_0 valid Output 1
add_interface_port eth_tx_cmac_avst_0 eth_tx_cmac_avl_eop_0 endofpacket Output "((ETH_EOP_WIDTH - 1)) - (0) + 1"
set_port_property eth_tx_cmac_avl_eop_0 VHDL_TYPE STD_LOGIC_VECTOR
add_interface_port eth_tx_cmac_avst_0 eth_tx_cmac_avl_data_0 data Output "((ETH_PKT_WIDTH - 1)) - (0) + 1"
add_interface_port eth_tx_cmac_avst_0 eth_tx_cmac_avl_empty_0 empty Output 3
add_interface_port eth_tx_cmac_avst_0 eth_tx_cmac_avl_err_0 error Output 1


#
# connection point etile_txrx_status
#
add_interface etile_txrx_status conduit end
set_interface_property etile_txrx_status associatedClock clock
set_interface_property etile_txrx_status associatedReset ""
set_interface_property etile_txrx_status ENABLED true
set_interface_property etile_txrx_status EXPORT_OF ""
set_interface_property etile_txrx_status PORT_NAME_MAP ""
set_interface_property etile_txrx_status CMSIS_SVD_VARIABLES ""
set_interface_property etile_txrx_status SVD_ADDRESS_GROUP ""
set_interface_property etile_txrx_status IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property etile_txrx_status SV_INTERFACE_TYPE ""
set_interface_property etile_txrx_status SV_INTERFACE_MODPORT_TYPE ""

add_interface_port etile_txrx_status e_tile_txrx_status conduit Output 32


#
# connection point eth_axi4lite_slave
#
add_interface eth_axi4lite_slave axi4lite end
set_interface_property eth_axi4lite_slave associatedClock clock
set_interface_property eth_axi4lite_slave associatedReset reset_n
set_interface_property eth_axi4lite_slave wakeupSignals false
set_interface_property eth_axi4lite_slave uniqueIdSupport false
set_interface_property eth_axi4lite_slave poison false
set_interface_property eth_axi4lite_slave traceSignals false
set_interface_property eth_axi4lite_slave readAcceptanceCapability 1
set_interface_property eth_axi4lite_slave writeAcceptanceCapability 1
set_interface_property eth_axi4lite_slave combinedAcceptanceCapability 1
set_interface_property eth_axi4lite_slave bridgesToMaster ""
set_interface_property eth_axi4lite_slave dfhFeatureGuid 0
set_interface_property eth_axi4lite_slave dfhGroupId 0
set_interface_property eth_axi4lite_slave dfhParameterId ""
set_interface_property eth_axi4lite_slave dfhParameterName ""
set_interface_property eth_axi4lite_slave dfhParameterVersion ""
set_interface_property eth_axi4lite_slave dfhParameterData ""
set_interface_property eth_axi4lite_slave dfhParameterDataLength ""
set_interface_property eth_axi4lite_slave dfhFeatureMajorVersion 0
set_interface_property eth_axi4lite_slave dfhFeatureMinorVersion 0
set_interface_property eth_axi4lite_slave dfhFeatureId 35
set_interface_property eth_axi4lite_slave dfhFeatureType 3
set_interface_property eth_axi4lite_slave ENABLED true
set_interface_property eth_axi4lite_slave EXPORT_OF ""
set_interface_property eth_axi4lite_slave PORT_NAME_MAP ""
set_interface_property eth_axi4lite_slave CMSIS_SVD_VARIABLES ""
set_interface_property eth_axi4lite_slave SVD_ADDRESS_GROUP ""
set_interface_property eth_axi4lite_slave IPXACT_REGISTER_MAP_VARIABLES ""
set_interface_property eth_axi4lite_slave SV_INTERFACE_TYPE ""
set_interface_property eth_axi4lite_slave SV_INTERFACE_MODPORT_TYPE ""

add_interface_port eth_axi4lite_slave axi_slave_araddr araddr Input "((AXI4L_ADDR_WIDTH - 1)) - (0) + 1"
add_interface_port eth_axi4lite_slave axi_slave_arready arready Output 1
add_interface_port eth_axi4lite_slave axi_slave_arvalid arvalid Input 1
add_interface_port eth_axi4lite_slave axi_slave_awaddr awaddr Input "((AXI4L_ADDR_WIDTH - 1)) - (0) + 1"
add_interface_port eth_axi4lite_slave axi_slave_awvalid awvalid Input 1
add_interface_port eth_axi4lite_slave axi_slave_awready awready Output 1
add_interface_port eth_axi4lite_slave axi_slave_rdata rdata Output "((AXI4L_DATA_WIDTH - 1)) - (0) + 1"
add_interface_port eth_axi4lite_slave axi_slave_rresp rresp Output "((AXI4L_RRESP_WIDTH - 1)) - (0) + 1"
add_interface_port eth_axi4lite_slave axi_slave_rvalid rvalid Output 1
add_interface_port eth_axi4lite_slave axi_slave_rready rready Input 1
add_interface_port eth_axi4lite_slave axi_slave_wdata wdata Input "((AXI4L_DATA_WIDTH - 1)) - (0) + 1"
add_interface_port eth_axi4lite_slave axi_slave_wvalid wvalid Input 1
add_interface_port eth_axi4lite_slave axi_slave_wready wready Output 1
add_interface_port eth_axi4lite_slave axi_slave_wstrb wstrb Input "((AXI4L_WSTRB_WIDTH - 1)) - (0) + 1"
add_interface_port eth_axi4lite_slave axi_slave_bresp bresp Output "((AXI4L_BRESP_WIDTH - 1)) - (0) + 1"
add_interface_port eth_axi4lite_slave axi_slave_bvalid bvalid Output 1
add_interface_port eth_axi4lite_slave axi_slave_bready bready Input 1
