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
// Filename         : alt_ehipc3_fm_sl_ptp_sub_nano.sv
// Author           : Shoaib Sial <shoaib.sial@intel.com>
// Created On       : Wed Sep 11/09/2019
//
//------------------------------------------------------------------------------

module alt_ehipc3_fm_sl_ptp_sub_nano #(
  parameter nTXRX = 0
)
(
  // System Interface
  input  logic        i_ptp_clk,
  input  logic        i_ptp_sn_sclk,
  input  logic        i_areset_n,
  input  logic        i_reset_n,
  input  logic        i_reset_sn_sclk_n,

  input  logic        i_ptp_ready,
  input  logic        i_am,
  input  logic        i_tam_valid,

//  input  logic        i_async_triger,
  input  logic        i_async_pulse_2d_1s,
  input  logic        i_async_pulse_phz_2d_1s,
  input  logic        i_roll_pulse_phz_2d_1s,

  input logic [31:0] i_apulse_period,
  input logic [31:0] i_apulse_skip,
  input logic [31:0] i_apulse_roll_dly,
  input logic [31:0] i_apulse_cnt_pow2,
  input logic [31:0] i_apulse_cnt,
  input logic [31:0] i_sn_config,

  input logic [31:0] i_sn_pll_sclk_period,

  output logic [3:0]   o_state_transition,
  output logic [3:0]   o_state_latencyphz,
  output logic [3:0]   o_state_rollover,
  output logic [31:0]  o_apulse_count,

  output logic [31:0]  o_skip_ini,

  output logic [31:0]  o_apulse_rt_period,
  output logic [31:0]  o_apulse_sn_period,
  output logic [31:0]  o_apulse_period_err,
  output logic [31:0]  o_latency_err2,
  output logic         o_am,
  output logic         o_sn_en,
  output logic         o_sn_ready,
  output logic         o_err,
  output logic         o_err2,
  output logic         o_measure_done,
  output logic         o_rollover_pulse_minus1,
  output logic         o_roll_over_trig,
  output logic         o_tam_adjust_valid_1s,
  output logic [31:0]  o_tam_adjust_avg

  );

//////////////////////////////////////////////////////////////////
//  Subnano Environment
/////////////////////////////////////////////////////////////////


  localparam  SYNC_FLOPS       = 4'd3;


  localparam  INIT 		        = 3'b000;
  localparam  TAM_PREV   		= 3'b001;
  localparam  TRANSITION   		= 3'b010;
  localparam  TAM_VALID		        = 3'b011;
  localparam  EXIT_TOD_VALID            = 3'b100;
  localparam  READY		        = 3'b101;


////////////////////////////////////////////////////////////
/////   subnano
////////////////////////////////////////////////////////////

//  logic        reset_phz_n;
//  logic        ptp_ready;

  logic [2:0]  next_state;
  logic [2:0]  state;
  logic        transit;
  logic        ready;

  logic        tam_valid_1s;
  logic        tam_valid_sync;
  logic        tam_valid_sync_d;
  logic        tam_valid_sync_int_n;
  logic        tam_valid_sync_int;

  logic        measure_done;
  logic        measure_done_phz;
  logic        measure_done_tam_phz;
  logic [31:0] tam_adjust_avg_phz;
  logic [31:0] tam_adjust_avg_cc;
  logic [31:0] tam_adjust_avg_x;
  logic        measure_done_tam_phz_d;
  logic        measure_done_tam_phz_1s;
  logic        tam_adjust_avg_cc_valid_1s;
  logic        tam_adjust_avg_valid_1s;

  logic        roll_over_r;

  logic        roll_over_1s;
  logic        o_roll_over;
  logic        roll_over_trig;
  logic        roll_over_trig_l;
  logic        roll_over_valid;
  logic        roll_over_valid_phz;
  logic [31:0] async_measured_counter;

  logic        rate_10g;
  logic        rate_25g;
  logic        rate_25g_fec;


  assign o_sn_en       = i_sn_config[0];

  assign rate_10g      = (i_sn_config[17:16] == 2'b10) ? 1'b1 : 1'b0;
  assign rate_25g_fec  = (i_sn_config[17:16] == 2'b01) ? 1'b1 : 1'b0;
  assign rate_25g      = (rate_25g_fec || rate_10g)    ? 1'b0 : 1'b1;

  assign o_am          = i_am;


  always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
      o_measure_done <= 1'b0;
    else if (transit)
      o_measure_done <= 1'b1;
  end

  always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
      o_tam_adjust_valid_1s <= 1'b0;
    else
      o_tam_adjust_valid_1s <= transit;
  end

  always@(posedge i_ptp_clk)
  begin
    /*if(!i_reset_n)
      o_tam_adjust_avg <= 32'd0;
    else*/ if (transit)
      o_tam_adjust_avg <= tam_adjust_avg_x;
  end

  always@(posedge i_ptp_clk)
  begin
//    if(!i_reset_n)
//      roll_over_r <= 1'b0;
//    else
      roll_over_r <= roll_over_trig_l;
  end

  assign roll_over_1s = roll_over_r ^ roll_over_trig_l;


  always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
      o_sn_ready <= 1'b0;
    else if (ready)
      o_sn_ready <= 1'b1;
  end


  always@(*)
  begin
      next_state         = state;
      transit            = 1'b0;
      ready              = 1'b0;

      case (state)
        INIT:
        begin
//          if (measure_done)
          if (tam_adjust_avg_valid_1s)
            next_state    = TAM_PREV;
        end
        TAM_PREV:
        begin
          if(tam_valid_1s)
            next_state    = TRANSITION;
        end
        TRANSITION:
        begin
          transit     = 1'b1;
          next_state    = TAM_VALID;
        end
        TAM_VALID:
        begin
          if (tam_valid_1s)
          begin
            next_state    = EXIT_TOD_VALID;
          end
        end
        EXIT_TOD_VALID:
        begin
          if (tam_valid_1s)
          begin
            next_state    = READY;
            ready  = 1'b1;
          end
        end
        READY:
        begin
          ready  = 1'b1;
          if (!measure_done)
            next_state    = INIT;
        end
        default:
        begin
          next_state    = INIT;
        end
      endcase
  end


  always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
      state <= INIT;
    else
      state <= next_state;
  end

  assign o_state_transition = {1'b0,state};



    alt_ehipc3_fm_sl_ptp_sn_roll_over #(
             .SYNC_FLOPS(SYNC_FLOPS)
	)  roll_over (
		.i_reset_n          (i_reset_n),
		.i_clk              (i_ptp_clk),
		.i_ptp_ready        (i_ptp_ready),
//		.i_async_triger     (i_async_triger),
		.i_async_pulse_2d_1s     (i_async_pulse_2d_1s),
                .i_apulse_period    (i_apulse_period),
                .i_apulse_skip      (i_apulse_skip),
                .i_apulse_roll_dly  (i_apulse_roll_dly),
		.i_measure_done     (measure_done),
		.i_transit          (transit),
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
//		.i_async_triger     (i_async_triger),
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


	// tam_valid Pulse Catcher
`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
	    .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
	    .WIDTH              (1),
	    .INIT_VALUE         (0)
	) tam_valid_pulse_catcher_sync_0 (
	    .clk    (i_ptp_clk),
	    .reset  (i_tam_valid),
	    .d      (1'b1),
	    .q      (tam_valid_sync_int_n)
	);

	assign tam_valid_sync_int = ~tam_valid_sync_int_n;

`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
	    .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
	    .WIDTH              (1),
	    .INIT_VALUE         (0)
	) tam_valid_pulse_catcher_sync_1 (
	    .clk    (i_ptp_clk),
	    .reset  (1'b0),
	    .d      (tam_valid_sync_int),
	    .q      (tam_valid_sync)
	);

    always@(posedge i_ptp_clk)
    begin
      if(!i_reset_n)
        tam_valid_sync_d <= 1'b0;
      else
        tam_valid_sync_d <= tam_valid_sync;
    end
    assign tam_valid_1s = ~tam_valid_sync_d && tam_valid_sync;



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
        .q                  (measure_done)
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
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
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
    ) ptp_ready_2ds (
        .clk                (i_ptp_clk),
        .reset              (1'b0),
        .d                  (i_ptp_ready),
        .q                  (ptp_ready)
    );
*/


/////



    always@(posedge i_ptp_sn_sclk)
    begin
      if(!i_reset_sn_sclk_n)
        measure_done_tam_phz_d <= 1'b0;
      else
        measure_done_tam_phz_d <= measure_done_tam_phz;
    end
    assign measure_done_tam_phz_1s = ~measure_done_tam_phz_d && measure_done_tam_phz;

        alt_ehipc3_fm_clock_crosser #(
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
            .out_reset              (!i_areset_n),
            .out_ready              (i_areset_n),

            .out_valid              (tam_adjust_avg_cc_valid_1s),
            .out_data               (tam_adjust_avg_cc)
        );

 always@(posedge i_ptp_clk)
  begin
    if(!i_reset_n)
     tam_adjust_avg_valid_1s <= 'd0;
    else
      tam_adjust_avg_valid_1s <= tam_adjust_avg_cc_valid_1s;
  end

 always@(posedge i_ptp_clk)
  begin
    /*if(!i_reset_n)
     tam_adjust_avg_x <= 'd0;
    else*/ if (tam_adjust_avg_cc_valid_1s)
      tam_adjust_avg_x <= tam_adjust_avg_cc;
  end



endmodule // alt_ehipc3_fm_sl_ptp_sub_nano
