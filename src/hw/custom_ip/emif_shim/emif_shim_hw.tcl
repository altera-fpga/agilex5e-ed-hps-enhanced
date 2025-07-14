package require -exact qsys 23.4

set_module_property NAME emif_shim
set_module_property DESCRIPTION "EMIF AXI4 Registered Drivers"
set_module_property DISPLAY_NAME "EMIF shim"
set_module_property VERSION                      1.0
set_module_property GROUP                        "EMIF Issue Workaround"
set_module_property EDITABLE                     false
set_module_property AUTHOR                       "Intel Corporation"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property INTERNAL                     false


add_parameter ADDR_WIDTH INTEGER 33 ""
set_parameter_property ADDR_WIDTH DEFAULT_VALUE 33
set_parameter_property ADDR_WIDTH DISPLAY_NAME ADDR_WIDTH
set_parameter_property ADDR_WIDTH UNITS None
set_parameter_property ADDR_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ADDR_WIDTH DESCRIPTION ""
set_parameter_property ADDR_WIDTH AFFECTS_GENERATION false
set_parameter_property ADDR_WIDTH HDL_PARAMETER true
set_parameter_property ADDR_WIDTH EXPORT true
add_parameter DATA_WIDTH INTEGER 256 ""
set_parameter_property DATA_WIDTH DEFAULT_VALUE 256
set_parameter_property DATA_WIDTH DISPLAY_NAME DATA_WIDTH
set_parameter_property DATA_WIDTH UNITS None
set_parameter_property DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property DATA_WIDTH DESCRIPTION ""
set_parameter_property DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property DATA_WIDTH HDL_PARAMETER true
set_parameter_property DATA_WIDTH EXPORT true
add_parameter ID_W_WIDTH INTEGER 7 ""
set_parameter_property ID_W_WIDTH DEFAULT_VALUE 7
set_parameter_property ID_W_WIDTH DISPLAY_NAME ID_W_WIDTH
set_parameter_property ID_W_WIDTH UNITS None
set_parameter_property ID_W_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ID_W_WIDTH DESCRIPTION ""
set_parameter_property ID_W_WIDTH AFFECTS_GENERATION false
set_parameter_property ID_W_WIDTH HDL_PARAMETER true
set_parameter_property ID_W_WIDTH EXPORT true
add_parameter ID_R_WIDTH INTEGER 7 ""
set_parameter_property ID_R_WIDTH DEFAULT_VALUE 7
set_parameter_property ID_R_WIDTH DISPLAY_NAME ID_R_WIDTH
set_parameter_property ID_R_WIDTH UNITS None
set_parameter_property ID_R_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property ID_R_WIDTH DESCRIPTION ""
set_parameter_property ID_R_WIDTH AFFECTS_GENERATION false
set_parameter_property ID_R_WIDTH HDL_PARAMETER true
set_parameter_property ID_R_WIDTH EXPORT true
add_parameter USER_REQ_WIDTH INTEGER 4 ""
set_parameter_property USER_REQ_WIDTH DEFAULT_VALUE 4
set_parameter_property USER_REQ_WIDTH DISPLAY_NAME USER_REQ_WIDTH
set_parameter_property USER_REQ_WIDTH UNITS None
set_parameter_property USER_REQ_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USER_REQ_WIDTH DESCRIPTION ""
set_parameter_property USER_REQ_WIDTH AFFECTS_GENERATION false
set_parameter_property USER_REQ_WIDTH HDL_PARAMETER true
set_parameter_property USER_REQ_WIDTH EXPORT true
add_parameter USER_DATA_WIDTH INTEGER 64 ""
set_parameter_property USER_DATA_WIDTH DEFAULT_VALUE 64
set_parameter_property USER_DATA_WIDTH DISPLAY_NAME USER_DATA_WIDTH
set_parameter_property USER_DATA_WIDTH UNITS None
set_parameter_property USER_DATA_WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property USER_DATA_WIDTH DESCRIPTION ""
set_parameter_property USER_DATA_WIDTH AFFECTS_GENERATION false
set_parameter_property USER_DATA_WIDTH HDL_PARAMETER true
set_parameter_property USER_DATA_WIDTH EXPORT true


proc add_clk { name } {
  add_interface ${name} clock end
  set_interface_property ${name} clockRate 0
  set_interface_property ${name} ENABLED true
  add_interface_port ${name} ${name} clk Input 1
}

proc add_rst { name clk } {

  add_interface ${name} reset end
  set_interface_property ${name} associatedClock $clk
  set_interface_property ${name} synchronousEdges DEASSERT
  set_interface_property ${name} ENABLED true
  add_interface_port ${name} ${name} reset Input 1
}

proc add_axi4_interface { prefix clk rst {dir slave} }  {

  if {$dir == "master"} {
    set master_out "Output"
    set master_in  "Input"
    set direction "start"
  } else {
    set master_out "Input"
    set master_in  "Output"
    set direction "end"
  }

  add_interface $prefix axi4 $direction
  set_interface_property $prefix associatedClock $clk
  set_interface_property $prefix associatedReset $rst

  if {$dir == "master"} {
    set_interface_property $prefix readIssuingCapability 8
    set_interface_property $prefix writeIssuingCapability 8
    set_interface_property $prefix combinedIssuingCapability 8
    set_interface_property $prefix issuesFIXEDBursts 0
    set_interface_property $prefix issuesWRAPBursts 0
  } else {
    set_interface_property $prefix readAcceptanceCapability 8
    set_interface_property $prefix writeAcceptanceCapability 8
    set_interface_property $prefix combinedAcceptanceCapability 8
  }
  set_interface_property $prefix ENABLED true
  set_interface_property $prefix EXPORT_OF ""
  set_interface_property $prefix PORT_NAME_MAP ""
  set_interface_property $prefix CMSIS_SVD_VARIABLES ""
  set_interface_property $prefix SVD_ADDRESS_GROUP ""

  add_interface_port $prefix ${prefix}_awaddr  awaddr $master_out ADDR_WIDTH
  add_interface_port $prefix ${prefix}_awburst awburst $master_out 2
  add_interface_port $prefix ${prefix}_awid    awid $master_out ID_W_WIDTH
  add_interface_port $prefix ${prefix}_awlen   awlen $master_out 8
  add_interface_port $prefix ${prefix}_awlock  awlock $master_out 1
  add_interface_port $prefix ${prefix}_awqos   awqos $master_out 4
  add_interface_port $prefix ${prefix}_awsize  awsize $master_out 3
  add_interface_port $prefix ${prefix}_awvalid awvalid $master_out 1
  add_interface_port $prefix ${prefix}_awuser  awuser $master_out USER_REQ_WIDTH
  add_interface_port $prefix ${prefix}_awprot  awprot $master_out 3
  add_interface_port $prefix ${prefix}_awready awready $master_in 1

  add_interface_port $prefix ${prefix}_araddr  araddr $master_out ADDR_WIDTH
  add_interface_port $prefix ${prefix}_arburst arburst $master_out 2
  add_interface_port $prefix ${prefix}_arid    arid $master_out ID_R_WIDTH
  add_interface_port $prefix ${prefix}_arlen   arlen $master_out 8
  add_interface_port $prefix ${prefix}_arlock  arlock $master_out 1
  add_interface_port $prefix ${prefix}_arqos   arqos $master_out 4
  add_interface_port $prefix ${prefix}_arsize  arsize $master_out 3
  add_interface_port $prefix ${prefix}_arvalid arvalid $master_out 1
  add_interface_port $prefix ${prefix}_aruser  aruser $master_out USER_REQ_WIDTH
  add_interface_port $prefix ${prefix}_arprot  arprot $master_out 3
  add_interface_port $prefix ${prefix}_arready arready $master_in 1

  add_interface_port $prefix ${prefix}_bready bready $master_out 1
  add_interface_port $prefix ${prefix}_bid    bid $master_in 7
  add_interface_port $prefix ${prefix}_bresp  bresp $master_in 2
  add_interface_port $prefix ${prefix}_bvalid bvalid $master_in 1

  add_interface_port $prefix ${prefix}_rready rready $master_out 1
  add_interface_port $prefix ${prefix}_ruser  ruser  $master_in USER_DATA_WIDTH
  add_interface_port $prefix ${prefix}_rid    rid    $master_in ID_R_WIDTH
  add_interface_port $prefix ${prefix}_rlast  rlast  $master_in 1
  add_interface_port $prefix ${prefix}_rresp  rresp  $master_in 2
  add_interface_port $prefix ${prefix}_rvalid rvalid $master_in 1
  add_interface_port $prefix ${prefix}_rdata rdata   $master_in DATA_WIDTH

  add_interface_port $prefix ${prefix}_wuser  wuser  $master_out USER_DATA_WIDTH
  add_interface_port $prefix ${prefix}_wdata  wdata  $master_out DATA_WIDTH
  add_interface_port $prefix ${prefix}_wstrb  wstrb  $master_out DATA_WIDTH/8
  add_interface_port $prefix ${prefix}_wlast  wlast  $master_out 1
  add_interface_port $prefix ${prefix}_wvalid wvalid $master_out 1
  add_interface_port $prefix ${prefix}_wready wready $master_in 1

}

add_fileset          QUARTUS_SYNTH  QUARTUS_SYNTH                    ""    ""
set_fileset_property QUARTUS_SYNTH  TOP_LEVEL                        emif_shim
add_fileset_file     emif_shim.sv          SYSTEM_VERILOG    PATH        emif_shim/emif_shim.sv         TOP_LEVEL_FILE
add_fileset_file     emif_shim_skid.sv     SYSTEM_VERILOG    PATH        emif_shim/emif_shim_skid.sv


add_clk axi_clk
add_rst axi_reset axi_clk
add_axi4_interface s_axi axi_clk axi_reset slave
add_axi4_interface m_axi axi_clk axi_reset master
