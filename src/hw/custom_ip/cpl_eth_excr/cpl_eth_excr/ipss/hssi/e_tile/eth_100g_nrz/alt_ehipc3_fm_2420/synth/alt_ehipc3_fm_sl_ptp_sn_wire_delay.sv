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
// Filename         : alt_ehipc3_fm_sl_ptp_sn_wire_delay.sv
// Author           : Shoaib Sial <shoaib.sial@intel.com>
// Created On       : Wed Sep 11/09/2019
//
//------------------------------------------------------------------------------

module alt_ehipc3_fm_sl_ptp_sn_wire_delay #(
  parameter EHIP_RATE_10G_EN = 0,
  parameter nTXRX = 0
)
(
  input  logic  [1:0] i_sn_config,
  // System Interface
  input  logic        i_ptp_clk,
  input  logic        i_ptp_sn_sclk,
  input  logic        i_reset_n,
  input  logic        i_reset_sn_sclk_n,

//  input  logic        i_async_triger,
  input  logic        i_async_pulse_2d_1s,
  input  logic        i_async_pulse_phz_2d_1s,
  input  logic        i_roll_pulse_phz_2d_1s,
  input  logic        i_sn_clb_trig,
  input  logic        i_calibrate,

  input logic [31:0] i_apulse_period,
  input logic [31:0] i_apulse_skip,
  input logic [31:0] i_apulse_roll_dly,
  input logic [31:0] i_apulse_cnt_pow2,
  input logic [31:0] i_apulse_cnt,

//////
  input logic        i_all_ready,
  input logic [31:0] i_ui,
  input logic [31:0] i_sn_pll_sclk_period,

  output logic [31:0]  o_skip_ini,

  output logic [3:0]  o_state_latencyphz,
  output logic [3:0]  o_state_rollover,
  output logic [31:0] o_apulse_count,
  output logic [31:0]  o_apulse_rt_period,
  output logic [31:0]  o_apulse_sn_period,
  output logic [31:0]  o_apulse_period_err,
  output logic [31:0]  o_latency_err2,
  output logic        o_err,
  output logic        o_err2,
  output logic        o_sclk,
  output logic        o_rollover_pulse_minus1,
  output logic        o_calibrate,
  output logic        o_calibrate1,
  output logic [31:0] o_wd_error,
  output logic        o_wd_error_valid_1s,
  output logic        o_wd_error_valid

/////



  );

//////////////////////////////////////////////////////////////////
//  Subnano Environment
/////////////////////////////////////////////////////////////////


  localparam  SYNC_FLOPS       = 4'd3;
  localparam  CLK_DIV          =   66;


////////////////////////////////////////////////////////////
/////   subnano
////////////////////////////////////////////////////////////

//  logic        reset_phz_n;
  logic        all_ready;


  logic        measure_done;
  logic        measure_done_phz;
  logic        measure_done_tam_phz;
  logic [31:0] tam_adjust_avg_phz;
  logic [31:0] tam_adjust_avg_2d;
  logic [31:0] tam_adjust_avg_cc;
  logic        measure_done_tam_phz_d;
  logic        measure_done_tam_phz_1s;
  logic        tam_adjust_avg_cc_valid_1s;
  logic        tam_adjust_avg_2d_valid_1s;

  logic [31:0] async_measured_counter;

  logic        o_roll_over;
  logic        roll_over_trig;
  logic        roll_over_trig_l;
  logic        roll_over_valid;
  logic        roll_over_valid_phz;

  logic         o_roll_over_trig;


  logic [31:0] exp_delay_cyc;
  logic [31:0] exp_delay_cyc_r;
  logic [31:0] exp_delay_f24;
  logic [31:0] exp_delay_s;
  logic [31:0] exp_delay;
//  localparam  exp_delay          =   32'h00170a3e;
///

  logic        carry;
  logic [31:0] wd_full;
  logic [31:0] wd_half;

  logic [31:0] ui_2d;
  logic [15:0] apulse_roll_dly_plus1;

  logic        calibrate_n;
  logic        calibrate_n_r;
  logic        calibrate_n_rr1;
  logic        calibrate_n_rr2;
  logic        calibrate_n_rr1_p1;
  logic        calibrate_n_rr2_p1;
  reg        calibrate_rr1_p2 /* synthesis dont_merge */;
  reg        calibrate_rr2_p2 /* synthesis dont_merge */;

  logic        calibrate;
  logic        calibrate1;

  logic        rate_10g;

//  localparam  exp_delay =  (EHIP_RATE_10G_EN == 1) ? 32'h0039999A : 32'h00170a3e; //

  assign  rate_10g  =  (i_sn_config == 2'b10) ? 1'b1 : 1'b0;
  assign  exp_delay =  (rate_10g == 1'b1) ? 32'h0039999A : 32'h00170a3e; //


    alt_ehipc3_fm_sl_ptp_sn_roll_over #(
             .SYNC_FLOPS(SYNC_FLOPS)
	)  roll_over (
		.i_reset_n          (i_reset_n),
		.i_clk              (i_ptp_clk),
		.i_ptp_ready        (all_ready),
//		.i_async_triger     (i_sn_clb_trig),
		.i_async_pulse_2d_1s     (i_async_pulse_2d_1s),
                .i_apulse_period    (i_apulse_period),
                .i_apulse_skip      (i_apulse_skip),
                .i_apulse_roll_dly  (i_apulse_roll_dly),
		.i_measure_done     (measure_done),
		.i_transit          (1'b0),
		.o_skip_ini         (o_skip_ini),
		.o_state_rollover   (o_state_rollover),
		.o_apulse_count     (o_apulse_count),
                .o_apulse_rt_period (o_apulse_rt_period),
                .o_apulse_sn_period (o_apulse_sn_period),
                .o_apulse_period_err (o_apulse_period_err),
                .o_latency_err2     (o_latency_err2),
		.o_err              (o_err),
		.o_err2             (o_err2),
		.o_roll_over        (o_roll_over),
		.o_rollover_pulse_minus1        (o_rollover_pulse_minus1),
//		.o_roll_over_trig   (roll_over_trig),
		.o_roll_over_trig_l (roll_over_trig_l),
		.o_roll_over_trig_tn (o_roll_over_trig),
		.o_roll_over_valid  (roll_over_valid)
	);



	//counter async
	alt_ehipc3_fm_sl_ptp_sn_latency #(
             .SYNC_FLOPS(SYNC_FLOPS)
	)  async_latency(
		.i_reset_n          (i_reset_sn_sclk_n),
		.i_clk              (i_ptp_sn_sclk),
		.i_async_pulse_phz_2d_1s     (i_async_pulse_phz_2d_1s),
                .i_apulse_cnt       (i_apulse_cnt),
		.i_roll_pulse_phz_2d_1s   (i_roll_pulse_phz_2d_1s),
		.i_roll_over_valid  (roll_over_valid_phz),
		.o_state_latencyphz (o_state_latencyphz),
		.o_counter_out      (async_measured_counter),
		.o_measure_done     (measure_done_phz)
	);



	//latency_measure
	alt_ehipc3_fm_sl_ptp_sn_tam  latency_tam(
		.i_reset_n          (i_reset_sn_sclk_n),
		.i_clk              (i_ptp_sn_sclk),
                .i_sn_pll_sclk_period  (i_sn_pll_sclk_period),
                .i_apulse_cnt_pow2  (i_apulse_cnt_pow2),
		.i_measure_done     (measure_done_phz),
		.i_counter          (async_measured_counter),
		.o_measure_done     (measure_done_tam_phz),
		.o_tam_adjust_avg   (tam_adjust_avg_phz)
	);



	wire measure_done_p;
	latency_module #(
		.LAT(4),
		.WIDTH(1)
	) u_measure_done (
		.clk(i_ptp_clk),
		.i_data(measure_done_p),
		.o_data(measure_done)
	);

`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) measure_done_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (measure_done_tam_phz),
        .q                  (measure_done_p)
    );

/*
`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) tam_adjust_avg_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (tam_adjust_avg_phz),
        .q                  (tam_adjust_avg_2d)
    );
*/


`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (3*SYNC_FLOPS),   // Delaying valid
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) roll_over_valid_phz_2ds (
        .clk                (i_ptp_sn_sclk),
        .reset              (1'b0),
        .d                  (roll_over_valid),
        .q                  (roll_over_valid_phz)
    );

/*

`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) reset_phz_2ds (
        .clk                (i_ptp_sn_sclk),
        .reset              (1'b0),
        .d                  (i_reset_n),
        .q                  (reset_phz_n)
    );
*/
/*
`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) all_ready_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (i_all_ready),
        .q                  (all_ready)
    );
*/
/*
`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (32),
        .INIT_VALUE         (0)
    ) ui_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (i_ui),
        .q                  (ui_2d)
    );
*/
///////////////////////////////////

  assign all_ready = i_all_ready;

    alt_ehipc3_fm_sl_ptp_sn_clb_pulse sn_clb_pulse (
		.i_reset_n          (i_reset_n),
		.i_clk              (i_ptp_clk),
		.i_all_ready        (all_ready),
		.i_calibrate        (i_calibrate),
		.i_apulse_period    (i_apulse_period),
		.o_sclk             (o_sclk)
	);

/*

  assign apulse_roll_dly_plus1 = i_apulse_roll_dly[14:0] + 1;

  always@(posedge i_ptp_clk )
  begin
    exp_delay_cyc  <= (CLK_DIV * apulse_roll_dly_plus1);
  end

  always@(posedge i_ptp_clk )
  begin
    exp_delay_cyc_r  <= exp_delay_cyc;
  end

  always@(posedge i_ptp_clk )
  begin
    exp_delay_f24  <= (ui_2d * exp_delay_cyc);
  end

  always@(posedge i_ptp_clk )
  begin
    exp_delay_s  <= exp_delay_f24 >> 4'h8; // f16
  end

  always@(posedge i_ptp_clk )
  begin
    exp_delay  <= exp_delay_s; // f16
  end
*/

////

  assign {carry, wd_full} = (exp_delay < tam_adjust_avg_phz) ? (tam_adjust_avg_phz - exp_delay) : (exp_delay - tam_adjust_avg_phz);
  assign wd_half = wd_full >> 4'h1;
/*
  always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
      o_wd_error <= 32'd0;
//    else if (exp_delay < tam_adjust_avg_2d)
//      o_wd_error  <= (tam_adjust_avg_2d - exp_delay) >> 4'h1;
//    else
//      o_wd_error  <= (exp_delay - tam_adjust_avg_2d) >> 4'h1;
    else
      o_wd_error  <= wd_half;
  end
*/

  always@(posedge i_ptp_sn_sclk)
  begin
      o_wd_error  <= wd_half;
  end

  /*
  always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
      o_wd_error_valid <= 1'b0;
    else if (tam_adjust_avg_2d_valid_1s)
      o_wd_error_valid <= 1'b1;
  end
  */
  assign o_wd_error_valid = measure_done;

/*
  always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
      o_wd_error_valid_1s <= 1'b0;
    else
      o_wd_error_valid_1s <= tam_adjust_avg_2d_valid_1s;
  end
  */
  assign o_wd_error_valid_1s = measure_done;

 // assign calibrate       = !calibrate_n_rr1;
 // assign calibrate1      = !calibrate_n_rr2;
 // assign calibrate       = !calibrate_n_rr1_p1;
 // assign calibrate1      = !calibrate_n_rr2_p1;
//  assign calibrate        = !calibrate_n_rr1_p2;
//  assign calibrate1       = !calibrate_n_rr2_p2;

  assign o_calibrate     = calibrate_rr1_p2;
  assign o_calibrate1    = calibrate_rr2_p2;

  always @(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
    begin
        calibrate_n   <= 1'b0;
    end
    else
    begin
        if(!calibrate_n &&  o_wd_error_valid && all_ready)
        begin
            calibrate_n <= 1'b1;
        end
    end
  end

  always @(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
    begin
      calibrate_n_r    <= 1'b0;
      calibrate_n_rr1  <= 1'b0;
      calibrate_n_rr2  <= 1'b0;
      calibrate_n_rr1_p1  <= 1'b0;
      calibrate_n_rr2_p1  <= 1'b0;
      calibrate_rr1_p2  <= 1'b1;
      calibrate_rr2_p2  <= 1'b1;
    end
    else
    begin
      calibrate_n_r   <= calibrate_n;
      calibrate_n_rr1 <= calibrate_n_r;
      calibrate_n_rr2 <= calibrate_n_r;
      calibrate_n_rr1_p1 <= calibrate_n_rr1;
      calibrate_n_rr2_p1 <= calibrate_n_rr2;
      calibrate_rr1_p2 <= !calibrate_n_rr1_p1;
      calibrate_rr2_p2 <= !calibrate_n_rr2_p1;
    end
  end

//////////////////////////////////////
/*
    always@(posedge i_ptp_sn_sclk)
    begin
      if(!i_reset_sn_sclk_n)
        measure_done_tam_phz_d <= 1'b0;
      else
        measure_done_tam_phz_d <= measure_done_tam_phz;
    end
*/
/*
    assign measure_done_tam_phz_1s = ~measure_done_tam_phz_d && measure_done_tam_phz;

        alt_ehipc3_fm_clock_crosser_nrd #(
            .SYMBOLS_PER_BEAT       (1),
            .BITS_PER_SYMBOL        (32),
            .FORWARD_SYNC_DEPTH     (2),
            .BACKWARD_SYNC_DEPTH    (2)
        ) tam_adjust_avg_icc (
            .in_clk                 (i_ptp_sn_sclk),
            .in_reset               (!i_reset_sn_sclk_n),
            .in_ready               (),
            .in_valid               (measure_done_tam_phz_1s),
            .in_data                (tam_adjust_avg_phz),
            .out_clk                (i_ptp_clk),
            .out_reset              (!i_reset_n),
            .out_ready              (i_reset_n),

            .out_valid              (tam_adjust_avg_cc_valid_1s),
            .out_data               (tam_adjust_avg_cc)
        );

  always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
      tam_adjust_avg_2d_valid_1s <= 1'b0;
    else
      tam_adjust_avg_2d_valid_1s <= tam_adjust_avg_cc_valid_1s;
  end

 always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
     tam_adjust_avg_2d <= 'd0;
    else if (tam_adjust_avg_cc_valid_1s)
      tam_adjust_avg_2d <= tam_adjust_avg_cc;
  end
  */
endmodule // alt_ehipc3_fm_sl_ptp_sub_nano
