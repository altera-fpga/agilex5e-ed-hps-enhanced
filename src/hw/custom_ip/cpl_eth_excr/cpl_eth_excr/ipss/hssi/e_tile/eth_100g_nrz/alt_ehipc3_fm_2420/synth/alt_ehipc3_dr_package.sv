// (C) 2001-2023 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any output
// files from any of the foregoing (including device programming or simulation
// files), and any associated documentation or information are expressly subject
// to the terms and conditions of the Intel Program License Subscription
// Agreement, Intel FPGA IP License Agreement, or other applicable
// license agreement, including, without limitation, that your use is for the
// sole purpose of programming logic devices manufactured by Intel and sold by
// Intel or its authorized distributors.  Please refer to the applicable
// agreement for further details.


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

package alt_ehipc3_dr_package;
    typedef enum logic [3:0] {
        IDLE,
        CTRL_CSR_ASSERT,
        CTRL_CSR_DEASSERT,
        CTRL_TX_ASSERT,
        CTRL_TX_DEASSERT,
        CTRL_RX_ASSERT,
        CTRL_RX_DEASSERT,
        CTRL_LTD_ASSERT,
        CTRL_LTD_DEASSERT,
        CTRL_KR_ASSERT,
        CTRL_KR_DEASSERT
    } ctrl_code_t;

endpackage
