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


`timescale 1ns / 1ns
module alt_ehipc3_fm_ml_ptp_opcode_writer #(
    parameter LANES    = 4
) (
    input  logic                    i_enable_rsfec,
    input  logic                    i_tx_preamble_pass,

    input  logic                    i_clk,
    input  logic                    i_rst_n,

    input  logic                    i_pcs_fully_aligned,

    input  logic            [7:0]   i_ptp_fp,

    input  logic                    i_ptp_ins_ets,
    input  logic                    i_ptp_ins_cf,
    input  logic                    i_ptp_zero_csum,
    input  logic                    i_ptp_update_eb,
    input  logic                    i_ptp_ts_format,
    input  logic                    i_ptp_asym,
    input  logic            [15:0]  i_ptp_ts_offset,
    input  logic            [15:0]  i_ptp_cf_offset,
    input  logic            [15:0]  i_ptp_csum_offset,
    input  logic            [15:0]  i_ptp_eb_offset,
    input  logic            [95:0]  i_ptp_tx_its,

    input  logic                    i_ptp_ts_req,

    input  logic                    i_tx_early_valid,
    input  logic                    i_tx_valid,
    input  logic [LANES-1:0]        i_tx_inframe,
    input  logic [LANES-1:0]        i_tx_skip_crc,

    input  logic [LANES-1:0]        i_req_tx_tam_load,
    input  logic [LANES-1:0]        i_req_rx_tam_load,
    input  logic                    i_req_tx_ui_load,
    input  logic                    i_req_rx_ui_load,

    input  logic [LANES-1:0][95:0]  i_tx_tam,
    input  logic [LANES-1:0][31:0]  i_tx_tam_adj,
    input  logic [LANES-1:0][31:0]  i_rx_tam_adj,
    input  logic [LANES-1:0][95:0]  i_rx_tam,

    input  logic            [31:0]  i_tx_ui,
    input  logic            [31:0]  i_rx_ui,

    input  logic [19:0]             i_vl_offset_load,
    input  logic [19:0][38:0]       i_vl_offset,

    output logic [LANES-1:0][2:0]   o_ptp_ins_type,
    output logic [LANES-1:0][2:0]   o_ptp_byte_offset,
    output logic            [95:0]  o_ptp_ts,
    output logic            [7:0]   o_ptp_tx_fp,

    output logic                    o_tx_ptp_ready,
    output logic                    o_rx_ptp_ready
);

    genvar                      i;

    logic [LANES-1:0][95:0]     tx_tam;
    logic [LANES-1:0][95:0]     rx_tam;
    logic [LANES-1:0]           tx_tam_valid;
    logic [LANES-1:0]           rx_tam_valid;

    alt_ehipc3_fm_ml_ptp_convert_commands #(
        .LANES                  (LANES)
    ) ptp_covert_commands_u (
        .i_enable_rsfec         (i_enable_rsfec        ),
        .i_tx_preamble_pass     (i_tx_preamble_pass    ),
        .i_clk                  (i_clk                 ),
        .i_rst_n                (i_rst_n               ),
        .i_pcs_fully_aligned    (i_pcs_fully_aligned   ),
        .i_ptp_ins_ets          (i_ptp_ins_ets         ),
        .i_ptp_ins_cf           (i_ptp_ins_cf          ),
        .i_ptp_zero_csum        (i_ptp_zero_csum       ),
        .i_ptp_update_eb        (i_ptp_update_eb       ),
        .i_ptp_ts_format        (i_ptp_ts_format       ),
        .i_ptp_asym             (i_ptp_asym            ),
        .i_ptp_ts_offset        (i_ptp_ts_offset       ),
        .i_ptp_cf_offset        (i_ptp_cf_offset       ),
        .i_ptp_csum_offset      (i_ptp_csum_offset     ),
        .i_ptp_eb_offset        (i_ptp_eb_offset       ),
        .i_ptp_tx_its           (i_ptp_tx_its          ),
        .i_ptp_ts_req           (i_ptp_ts_req          ),
        .i_ptp_fp               (i_ptp_fp              ),
        .i_tx_early_valid       (i_tx_early_valid      ),
        .i_tx_valid             (i_tx_valid            ),
        .i_tx_inframe           (i_tx_inframe          ),
        .i_tx_skip_crc          (i_tx_skip_crc         ),
        .i_req_tx_tam_load      (tx_tam_valid          ),
        .i_tx_tam               (tx_tam                ),
        .i_req_rx_tam_load      (rx_tam_valid          ),
        .i_rx_tam               (rx_tam                ),
        .i_req_tx_ui_load       (i_req_tx_ui_load      ),
        .i_tx_ui                (i_tx_ui               ),
        .i_req_rx_ui_load       (i_req_rx_ui_load      ),
        .i_rx_ui                (i_rx_ui               ),
        .i_vl_offset_load       (i_vl_offset_load      ),
        .i_vl_offset            (i_vl_offset           ),
        .o_ptp_ins_type         (o_ptp_ins_type        ),
        .o_ptp_byte_offset      (o_ptp_byte_offset     ),
        .o_tx_ptp_ready         (o_tx_ptp_ready        ),
        .o_rx_ptp_ready         (o_rx_ptp_ready        ),
        .o_ptp_ts               (o_ptp_ts              ),
        .o_ptp_tx_fp            (o_ptp_tx_fp           )
    );

    generate
        for(i = 0; i < LANES; i++) begin: LANES_LOOP
            alt_ehipc3_fm_sl_ptp_calc_tam ptp_calc_tam_u (
                .i_clk              (i_clk               ),
                .i_rst_n            (i_rst_n             ),
                .i_tx_tam           (i_tx_tam         [i]),
                .i_rx_tam           (i_rx_tam         [i]),
                .i_tx_tam_adj       (i_tx_tam_adj     [i]),
                .i_rx_tam_adj       (i_rx_tam_adj     [i]),
                .i_req_tx_tam_load  (i_req_tx_tam_load[i]),
                .i_req_rx_tam_load  (i_req_rx_tam_load[i]),
                .o_tx_tam_valid     (tx_tam_valid     [i]),
                .o_rx_tam_valid     (rx_tam_valid     [i]),
                .o_tx_tam           (tx_tam           [i]),
                .o_rx_tam           (rx_tam           [i])
            );
        end
    endgenerate

endmodule
