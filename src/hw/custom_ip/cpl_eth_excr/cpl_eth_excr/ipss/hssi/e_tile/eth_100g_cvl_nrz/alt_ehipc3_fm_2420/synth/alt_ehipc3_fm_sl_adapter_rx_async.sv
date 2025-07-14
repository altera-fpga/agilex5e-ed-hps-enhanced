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

module alt_ehipc3_fm_sl_adapter_rx_async #(
    parameter WORD_WIDTH    = 64,
    parameter EMPTY_BITS    = 3,
    parameter PTP_WIDTH     = 1,
    parameter NUM_CHANNELS  = 1
) (
    input   [NUM_CHANNELS-1:0]                    i_clk,
    input   [NUM_CHANNELS-1:0]                    i_sl_async_clk_rx,
    input   [NUM_CHANNELS-1:0]                    i_reset,
    input   [NUM_CHANNELS-1:0]			  i_reset_1,

    // Client interface
    output  [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]    o_data,
    output  [NUM_CHANNELS-1:0]                    o_valid,
    output  [NUM_CHANNELS-1:0]                    o_sop,
    output  [NUM_CHANNELS-1:0]                    o_eop,
    output  [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]    o_empty,
    output  [NUM_CHANNELS-1:0][5:0]               o_error,
    output  [NUM_CHANNELS-1:0][39:0]              o_status,
    output  [NUM_CHANNELS-1:0][PTP_WIDTH-1:0]     o_ptp,

    input   [NUM_CHANNELS-1:0]                    i_valid,
    input   [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]    i_data,
    input   [NUM_CHANNELS-1:0]                    i_inframe,
    input   [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]    i_empty,
    input   [NUM_CHANNELS-1:0][1:0]               i_error,
    input   [NUM_CHANNELS-1:0]                    i_fcs_error,
    input   [NUM_CHANNELS-1:0][2:0]               i_status,
    input   [NUM_CHANNELS-1:0][PTP_WIDTH-1:0]     i_ptp
);

    wire  [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]    o_data_1 ;
    wire  [NUM_CHANNELS-1:0]                    o_valid_1 ;
    wire  [NUM_CHANNELS-1:0]                    o_sop_1 ;
    wire  [NUM_CHANNELS-1:0]                    o_eop_1 ;
    wire  [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]    o_empty_1 ;
    wire  [NUM_CHANNELS-1:0][5:0]               o_error_1 ;
    wire  [NUM_CHANNELS-1:0][39:0]              o_status_1 ;
    wire  [NUM_CHANNELS-1:0][PTP_WIDTH-1:0]     o_ptp_1;

    wire  [NUM_CHANNELS-1:0]                    rdempty;
    wire [NUM_CHANNELS-1:0][7:0]                rdusedw;
    wire  [NUM_CHANNELS-1:0]                    wrfull;
    wire  [NUM_CHANNELS-1:0]                    wrempty;
    wire  [NUM_CHANNELS-1:0]                    rdfull;
    wire [NUM_CHANNELS-1:0][7:0]                wrusedw;
    wire [NUM_CHANNELS-1:0][44:0]               temp1;

    wire [NUM_CHANNELS-1:0][WORD_WIDTH+1+1+EMPTY_BITS+40+6+PTP_WIDTH-1:0] ff_din;
    wire [NUM_CHANNELS-1:0][WORD_WIDTH+1+1+EMPTY_BITS+40+6+PTP_WIDTH-1:0] ff_dout;
    wire [NUM_CHANNELS-1:0][WORD_WIDTH+1+1+EMPTY_BITS+40+6+PTP_WIDTH-1:0] ff_dout_wire;

    reg  [NUM_CHANNELS-1:0]                    rdempty_reg;

    genvar i;
    generate
      for (i=0; i<NUM_CHANNELS; i++) begin: gen_fav
        // Convert to soft IP interface (EOP, SOP, valid)
        alt_ehipc3_fm_sl_if_to_avalon #(
          .WORD_WIDTH (WORD_WIDTH),
          .EMPTY_BITS (EMPTY_BITS),
          .PTP_WIDTH  (PTP_WIDTH)
        ) i_ehip_if_to_avalon (
          .i_clk        (i_clk[i]),
          .i_reset      (i_reset[i]),
	  .i_reset_1	(i_reset_1[i]),
          .i_data       (i_data[i]),
          .i_empty      (i_empty[i]),
          .i_error      (i_error[i]),
          .i_fcs_error  (i_fcs_error[i]),
          .i_status     (i_status[i]),
          .i_valid      (i_valid[i]),
          .i_inframe    (i_inframe[i]),
          .i_ptp        (i_ptp[i]),

          .o_data       (o_data_1[i]),
          .o_valid      (o_valid_1[i]),
          .o_sop        (o_sop_1[i]),
          .o_eop        (o_eop_1[i]),
          .o_empty      (o_empty_1[i]),
          .o_status     (o_status_1[i]),
          .o_error      (o_error_1[i]),
          .o_ptp        (o_ptp_1[i])
        );
    assign ff_din[i]      = {o_data_1[i], o_sop_1[i], o_eop_1[i], o_empty_1[i], o_status_1[i], o_error_1[i], o_ptp_1[i]};

dcfifo  dcfifo_rdfifo (
                .aclr (i_reset[i]),
                .data ({ff_din[i], 45'b0}),
                .rdclk (i_sl_async_clk_rx[i]),
                .rdreq ((~rdempty[i])),
                .wrclk (i_clk[i]),
                .wrreq ((~wrfull[i] & o_valid_1[i])),
                .q ({ff_dout[i], temp1[i]}),
                .rdempty (rdempty[i]),
                .wrfull (wrfull[i]),
                .wrusedw (),
                .eccstatus (),
                .rdfull (),
                .rdusedw (),
                .wrempty ());
    defparam
        dcfifo_rdfifo.enable_ecc  = "FALSE",
        dcfifo_rdfifo.intended_device_family  = "Stratix 10",
        dcfifo_rdfifo.lpm_hint  = "MAXIMUM_DEPTH=32,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE",
        dcfifo_rdfifo.lpm_numwords  = 32,
        dcfifo_rdfifo.lpm_showahead  = "OFF",
        dcfifo_rdfifo.lpm_type  = "dcfifo",
        dcfifo_rdfifo.lpm_width  = 256,
        dcfifo_rdfifo.lpm_widthu  = 5,
        dcfifo_rdfifo.overflow_checking  = "ON",
        dcfifo_rdfifo.rdsync_delaypipe  = 4,
        dcfifo_rdfifo.read_aclr_synch  = "ON",
        dcfifo_rdfifo.underflow_checking  = "ON",
        dcfifo_rdfifo.use_eab  = "ON",
        dcfifo_rdfifo.write_aclr_synch  = "ON",
        dcfifo_rdfifo.wrsync_delaypipe  = 4;

        assign {o_data[i], o_sop[i], o_eop[i], o_empty[i], o_status[i], o_error[i], o_ptp[i]} = ff_dout[i];
        assign o_valid[i] = rdempty_reg[i];

        always @ (posedge i_sl_async_clk_rx[i]) begin
            rdempty_reg[i] <= ~rdempty[i];
        end
        // assign ff_dout_wire = (rdempty_reg == 1'b0) ? 212'h0 : ff_dout;
        // assign {o_data[i], o_valid[i], o_sop[i], o_eop[i], o_empty[i], o_status[i], o_error[i], o_ptp[i]} = ff_dout_wire[i];
      end: gen_fav
    endgenerate

endmodule
