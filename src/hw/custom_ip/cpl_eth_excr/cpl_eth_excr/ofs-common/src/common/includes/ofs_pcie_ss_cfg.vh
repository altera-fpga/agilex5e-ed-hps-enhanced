// Copyright 2021 Intel Corporation
// SPDX-License-Identifier: MIT

// Configuration of the PCIe subsystem.
//
// This .vh file, associated with the ofs_pcie_ss_cfg_pkg::, may be used
// for managing updates to parameters imported from platform-specific versions
// of the configuration package. Macros may indicate the version number
// of a platform-specific implementation, which can then be used to
// set suitable defaults in ofs_pcie_ss_cfg_pkg:: without having to
// update old platforms.
//

`ifndef __OFS_PCIE_SS_CFG_VH__
`define __OFS_PCIE_SS_CFG_VH__ 1

// Include the platform-specific version of this file.
//`include "ofs_pcie_ss_plat_cfg.vh"
//
//
// Platform-specific OFS AC configuration of the PCIe subsystem.
//
// This file exists mainly to associate a version tag with the values in
// ofs_pcie_ss_plat_cfg_pkg::. The version tag makes it easier to manage
// varation among platforms when importing the platform-specific configuration
// into the platform-independent ofs_pcie_ss_cfg_pkg::.
//

`ifndef __OFS_PCIE_SS_PLAT_CFG_VH__
`define __OFS_PCIE_SS_PLAT_CFG_VH__ 1

`define OFS_PCIE_SS_PLAT_CFG_AC 1
`define OFS_PCIE_SS_PLAT_CFG_V1 1

// Is completion reordering enabled in the PCIe SS? Set to either 0 (disabled)
// or 1 (enabled).
`define OFS_PCIE_SS_PLAT_CFG_FLAG_CPL_REORDER 0


// PKG_SORT_IGNORE_START --
//  This marker causes the PIM's sort_sv_packages.py to ignore everything
//  from here to the ignore end marker below. The package sorter uses a
//  very simple parser to detect what looks like a SystemVerilog package
//  reference in order to emit packages in dependence order. The code
//  or include files below contain macros that refer to packages but
//  do not represent true package to package dependence.

`define OFS_PCIE_SS_PLAT_CFG_FLAG_CPL_CHAN ofs_pcie_ss_cfg_pkg::PCIE_CHAN_B
`define OFS_PCIE_SS_PLAT_CFG_FLAG_WR_COMMIT_CHAN ofs_pcie_ss_cfg_pkg::PCIE_CHAN_A

// PKG_SORT_IGNORE_END

`endif // __OFS_PCIE_SS_PLAT_CFG_VH__
//
// Map some well-known names from platform-specific to global. This syntactic
// sugar enforced a common namespace across platforms.
//

// Defined when ofs_pcie_ss_cfg_pkg::TUSER_STORE_COMMIT_REQ_BIT is available.
`define OFS_PCIE_SS_CFG_FLAG_TUSER_STORE_COMMIT_REQ 1

// Primarily, this flag indicates that ofs_pcie_ss_cfg_pkg::CPL_REORDER_EN
// is defined. The macro also indicates whether completion reordering is
// enabled in the PCIe SS, set to either 0 (disabled) or 1 (enabled).
`ifdef OFS_PCIE_SS_PLAT_CFG_FLAG_CPL_REORDER
  `define OFS_PCIE_SS_CFG_FLAG_CPL_REORDER `OFS_PCIE_SS_PLAT_CFG_FLAG_CPL_REORDER
`else
  // Default
  `define OFS_PCIE_SS_CFG_FLAG_CPL_REORDER 0
`endif

// Which RX channel is used for read completions?
`ifdef OFS_PCIE_SS_PLAT_CFG_FLAG_CPL_CHAN
  `define OFS_PCIE_SS_CFG_FLAG_CPL_CHAN `OFS_PCIE_SS_PLAT_CFG_FLAG_CPL_CHAN
`else
  // Default
  `define OFS_PCIE_SS_CFG_FLAG_CPL_CHAN ofs_pcie_ss_cfg_pkg::PCIE_CHAN_A
`endif

// Which RX channel is used for FIM-generated write commits?
`ifdef OFS_PCIE_SS_PLAT_CFG_FLAG_WR_COMMIT_CHAN
  `define OFS_PCIE_SS_CFG_FLAG_WR_COMMIT_CHAN `OFS_PCIE_SS_PLAT_CFG_FLAG_WR_COMMIT_CHAN
`else
  // Default
  `define OFS_PCIE_SS_CFG_FLAG_WR_COMMIT_CHAN ofs_pcie_ss_cfg_pkg::PCIE_CHAN_B
`endif

`endif // __OFS_PCIE_SS_CFG_VH__
