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

module alt_ehipc3_fm_sl_adapter_tx_async #(
    parameter WORD_WIDTH    = 64,
    parameter EMPTY_BITS    = 3,
    parameter PTP_WIDTH     = 1,
    parameter READY_LATENCY = 1,
    parameter SIM_EMULATE   = 1,
    parameter NUM_CHANNELS  = 1
) (
    input   [NUM_CHANNELS-1:0]                        i_clk,
    input   [NUM_CHANNELS-1:0]                        i_sl_async_clk_tx,
    input   [NUM_CHANNELS-1:0]                        i_reset,
    input   [NUM_CHANNELS-1:0]                        i_reset_async,

    input wire 				                          i_tx_am_pulse,
    input wire 				                          tx_transmit_ready,

    // Client interface
    input   [NUM_CHANNELS-1:0]                        i_valid,
    input   [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]        i_data,
    input   [NUM_CHANNELS-1:0]                        i_sop,
    input   [NUM_CHANNELS-1:0]                        i_eop,
    input   [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]        i_empty,
    input   [NUM_CHANNELS-1:0]                        i_error,
    input   [NUM_CHANNELS-1:0]                        i_skip_crc,
    input   [NUM_CHANNELS-1:0][PTP_WIDTH-1:0]         i_ptp,
    output reg [NUM_CHANNELS-1:0]                     o_ready,

    output  [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]        o_data,
    output  reg  [NUM_CHANNELS-1:0]                   o_valid,
    input   [NUM_CHANNELS-1:0]                        i_ready,
    output  [NUM_CHANNELS-1:0]                        o_inframe,
    output  reg [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]    o_empty,
    output  [NUM_CHANNELS-1:0]                        o_error,
    output  [NUM_CHANNELS-1:0]                        o_skip_crc,
    output  reg [NUM_CHANNELS-1:0][PTP_WIDTH-1:0]     o_ptp
);

    wire [NUM_CHANNELS-1:0]                         o_ready_delay;

    wire [NUM_CHANNELS-1:0][WORD_WIDTH-1:0]         av_data;
    wire [NUM_CHANNELS-1:0]                         av_to_ff_valid;
    wire [NUM_CHANNELS-1:0]                         av_inframe;
    wire [NUM_CHANNELS-1:0][EMPTY_BITS-1:0]         av_empty;
    wire [NUM_CHANNELS-1:0]                         av_error;
    wire [NUM_CHANNELS-1:0]                         av_skip_crc;
    wire [NUM_CHANNELS-1:0][PTP_WIDTH-1:0]          av_ptp;
    wire [NUM_CHANNELS-1:0]                         av_ready;

    wire [NUM_CHANNELS-1:0][1+1+1+EMPTY_BITS+WORD_WIDTH+PTP_WIDTH-1:0] ff_din;
    wire [NUM_CHANNELS-1:0][1+1+1+EMPTY_BITS+WORD_WIDTH+PTP_WIDTH-1:0] ff_dout;

    wire   [NUM_CHANNELS-1:0]                        rdempty;
    wire   [NUM_CHANNELS-1:0]                        wrfull;
    wire   [NUM_CHANNELS-1:0][4:0]                   wrusedw;
    wire   [NUM_CHANNELS-1:0][4:0]                   rdusedw;
    wire   [NUM_CHANNELS-1:0][11:0]                  done_care_bits;  // for 256 width match

    reg    [NUM_CHANNELS-1:0]                        rdempty_pulse ;
    reg    [NUM_CHANNELS-1:0]                        rdempty_pulse_r ;

    reg    [NUM_CHANNELS-1:0]                        rdfifo_req ;



    genvar i;
    generate
      for (i=0; i<NUM_CHANNELS; i++) begin: gen_avf

        always @(posedge i_clk[i])
            o_valid[i] <= i_ready[i];

        alt_ehipc3_fm_delay_reg #(
            .CYCLES (READY_LATENCY),
            .WIDTH  (NUM_CHANNELS)
        ) i_ehip_delay_reg (
            .clk    (i_sl_async_clk_tx[i]),
            .din    (o_ready[i]),
            .dout   (o_ready_delay[i])
        );

        alt_ehipc3_fm_sl_avalon_to_if #(
          .WORD_WIDTH (WORD_WIDTH),
          .EMPTY_BITS (EMPTY_BITS),
          .PTP_WIDTH  (PTP_WIDTH)
        ) i_ehip_avalon_to_if (
          .i_reset    (i_reset_async[i]),
          .i_clk      (i_sl_async_clk_tx[i]),

          .i_data     (i_data[i]),
          .i_valid    (i_valid[i]),
          .i_sop      (i_sop[i]),
          .i_eop      (i_eop[i]),
          .i_empty    (i_empty[i]),
          .i_error    (i_error[i]),
          .i_skip_crc (i_skip_crc[i]),
          .i_ptp      (i_ptp[i]),
          .i_ready    (o_ready_delay[i]),

          .o_data     (av_data[i]),
          .o_valid    (av_to_ff_valid[i]),
          .o_inframe  (av_inframe[i]),
          .o_empty    (av_empty[i]),
          .o_error    (av_error[i]),
          .o_skip_crc (av_skip_crc[i]),
          .o_ptp      (av_ptp[i]),
          .o_ready    (av_ready[i])
        );

        assign ff_din[i]      = {av_ptp[i], av_inframe[i], av_skip_crc[i], av_error[i], av_empty[i], av_data[i]};

    dcfifo  dcfifo_txfifo (
                .aclr (i_reset[i]),
                .data ({ff_din[i],12'b0}),
                .rdclk (i_clk[i]),
                // .rdreq (((~rdempty[i]) & i_ready[i])),
                .rdreq ((rdfifo_req[i] && i_ready[i])),
                .wrclk (i_sl_async_clk_tx[i]),
                .wrreq (av_ready[i]),
                .q ({ff_dout[i], done_care_bits[i]}),
                .rdempty (rdempty[i]),
                .wrfull (wrfull[i]),
                .wrusedw (wrusedw[i]),
                .eccstatus (),
                .rdfull (),
                .rdusedw (rdusedw[i]),
                .wrempty ());
    defparam
        dcfifo_txfifo.enable_ecc  = "FALSE",
        dcfifo_txfifo.intended_device_family  = "Stratix 10",
        dcfifo_txfifo.lpm_hint  = "MAXIMUM_DEPTH=32,DISABLE_DCFIFO_EMBEDDED_TIMING_CONSTRAINT=FALSE",
        dcfifo_txfifo.lpm_numwords  = 32,
        dcfifo_txfifo.lpm_showahead  = "OFF",
        dcfifo_txfifo.lpm_type  = "dcfifo",
        dcfifo_txfifo.lpm_width  = 256,
        dcfifo_txfifo.lpm_widthu  = 5,
        dcfifo_txfifo.overflow_checking  = "ON",
        dcfifo_txfifo.rdsync_delaypipe  = 5,
        dcfifo_txfifo.read_aclr_synch  = "ON",
        dcfifo_txfifo.underflow_checking  = "ON",
        dcfifo_txfifo.use_eab  = "ON",
        dcfifo_txfifo.write_aclr_synch  = "ON",
        dcfifo_txfifo.wrsync_delaypipe  = 5;


    always @ (posedge i_clk[i]) begin
        if (i_reset[i])begin
            rdempty_pulse_r[i] <= 0;
        end else begin
            rdempty_pulse_r[i] <= (rdempty[i]);
        end
    end

    assign rdempty_pulse[i] = rdempty_pulse_r[i] & (~rdempty[i]);

    always @ (posedge i_clk[i]) begin
        if (i_reset[i])begin
            rdfifo_req[i] <= 1'b0;
        end else begin
            if ((rdempty_pulse[i] == 1'b1) || (rdempty[i] == 1'b1)) begin
                rdfifo_req[i] <= 1'b0;
            end else if ((rdusedw[i] == 5'h6) && (rdfifo_req[i] == 1'b0) )begin
                rdfifo_req[i] <= 1'b1;
            end
        end
    end



    assign {o_ptp[i], o_inframe[i], o_skip_crc[i], o_error[i], o_empty[i], o_data[i]} = ff_dout[i];

    always @(posedge i_sl_async_clk_tx )begin
        if (i_reset_async[i])begin
            o_ready[i]  <= 1'b0;
        end
        else begin
            o_ready[i]  <= ((~wrfull[i]) && (wrusedw[i] < 5'h19) && (tx_transmit_ready || !i_tx_am_pulse)) ;
        end
    end

      end: gen_avf
    endgenerate



endmodule //alt_ehipc3_adapter_tx
