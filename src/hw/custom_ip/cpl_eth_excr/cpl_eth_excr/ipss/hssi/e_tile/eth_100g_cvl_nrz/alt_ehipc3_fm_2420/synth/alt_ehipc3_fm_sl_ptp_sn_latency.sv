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


//------------------------------------------------------------------------------
//
// Filename         : alt_ehipc3_fm_sl_ptp_sn_latency.sv
// Author           : Shoaib Sial <shoaib.sial@intel.com>
// Created On       : Wed Sep 11/09/2019
//
//------------------------------------------------------------------------------

module	alt_ehipc3_fm_sl_ptp_sn_latency #(
  parameter SYNC_FLOPS = 2
)
(
	input wire 											i_reset_n,
	input wire 											i_clk,
//	input wire											i_pol_sel,
//	input wire											i_async_chg,
//	input wire 											i_async_triger,
	input wire 											i_async_pulse_phz_2d_1s,
	input wire      [31:0]	     								        i_apulse_cnt,
	input wire 											i_roll_pulse_phz_2d_1s,
	input wire 											i_roll_over_valid,
	output wire     [3:0]				   				                o_state_latencyphz,
	output reg	[31:0]				   				                o_counter_out,
	output reg											o_measure_done

);



  localparam  INIT 		        = 3'b000;
  localparam  WAIT_ASYNC   		= 3'b001;
  localparam  LAT_CNT  	  		= 3'b010;
  localparam  DONE	   		= 3'b011;

  reg [2:0] next_state;
  reg [2:0] state;

  wire async_pulse_phz_2d_1s_ch;
  wire async_pulse_phz_2d_1s_a;
  wire async_pulse_phz_2d_1s;
  wire async_triger_phz_2d;

  wire roll_pulse_phz_2d_1s;
  wire roll_over_trig_phz_2d;

  reg  async_triger_phz_3d;
  reg  roll_over_trig_phz_3d;

  reg  init;
  reg  cnt_incr;
  reg  start_pulse_incr;
  reg  stop_pulse_incr;
  reg [31:0] latency_count;
  reg [31:0] agr_latency_count;
  reg [31:0] start_pulse_cnt;
  reg [31:0] stop_pulse_cnt;


/*
// i_async_triger

`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) async_phz_2d (
        .clk                (i_clk),
        .reset              (1'b0),
        .d                  (i_async_triger),
        .q                  (async_triger_phz_2d)
    );

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      async_triger_phz_3d <= 1'b0;
    else
      async_triger_phz_3d <= async_triger_phz_2d;
  end
*/
/*
    assign async_pulse_phz_2d_1s = (i_async_chg == 1'b1) ? async_pulse_phz_2d_1s_ch : async_pulse_phz_2d_1s_a;
    assign async_pulse_phz_2d_1s_ch = (i_pol_sel) ? async_triger_phz_2d & ~async_triger_phz_3d : ~async_triger_phz_2d & async_triger_phz_3d;
    assign async_pulse_phz_2d_1s_a = async_triger_phz_2d ^ async_triger_phz_3d;
*/
//    assign async_pulse_phz_2d_1s = async_triger_phz_2d ^ async_triger_phz_3d;
    assign async_pulse_phz_2d_1s = i_async_pulse_phz_2d_1s;

// i_roll_over_trig
/*
`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) roll_over_phz_2d (
        .clk                (i_clk),
        .reset              (1'b0),
        .d                  (i_roll_over_trig),
        .q                  (roll_over_trig_phz_2d)
    );

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      roll_over_trig_phz_3d <= 1'b0;
    else
      roll_over_trig_phz_3d <= roll_over_trig_phz_2d;
  end

  assign roll_pulse_phz_2d_1s = roll_over_trig_phz_2d ^ roll_over_trig_phz_3d;
*/
  assign roll_pulse_phz_2d_1s = i_roll_pulse_phz_2d_1s;


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      latency_count <= 32'd0;
    else if (init)
      latency_count <= 32'd0;
    else if (roll_pulse_phz_2d_1s)
      latency_count <= 32'd0;
    else if (cnt_incr)
      latency_count <= latency_count + 1'b1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      agr_latency_count <= 32'd0;
    else if (init)
      agr_latency_count <= 32'd0;
    else if (cnt_incr)
      agr_latency_count <= agr_latency_count + 1'b1;
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      start_pulse_cnt <= 32'd0;
    else if (init)
      start_pulse_cnt <= 32'd0;
    else if (start_pulse_incr)
      start_pulse_cnt <= start_pulse_cnt + 1'b1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      stop_pulse_cnt <= 32'd0;
    else if (init)
      stop_pulse_cnt <= 32'd0;
    else if (stop_pulse_incr)
      stop_pulse_cnt <= stop_pulse_cnt + 1'b1;
  end

  always@(*)
  begin
      next_state         = state;
      init               = 1'b0;
      cnt_incr           = 1'b0;
      start_pulse_incr   = 1'b0;
      stop_pulse_incr    = 1'b0;
      o_measure_done     = 1'b0;
      o_counter_out      = 32'd0;

      case (state)
        INIT:
        begin
          init         = 1'b1;
          if (i_roll_over_valid)
            next_state    = WAIT_ASYNC;
        end
        WAIT_ASYNC:
        begin
          if (async_pulse_phz_2d_1s)
          begin
            cnt_incr           = 1'b1;
            start_pulse_incr   = 1'b1;
            next_state         = LAT_CNT;
          end
        end
        LAT_CNT:
        begin
          cnt_incr     = 1'b1;
          if (roll_pulse_phz_2d_1s)
          begin
            stop_pulse_incr   = 1'b1;
            cnt_incr          = 1'b0;
            if (stop_pulse_cnt >= i_apulse_cnt -1)
              next_state      = DONE;
            else
              next_state      = WAIT_ASYNC;
          end
        end
        DONE:
        begin
          o_measure_done  = 1'b1;
          o_counter_out   = agr_latency_count;

          if (!i_roll_over_valid)
            next_state    = INIT;
        end
        default:
        begin
          next_state    = INIT;
        end
      endcase
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      state <= INIT;
    else if(!i_roll_over_valid)
      state <= INIT;
    else
      state <= next_state;
  end

  assign o_state_latencyphz = {1'b0,state};





endmodule
