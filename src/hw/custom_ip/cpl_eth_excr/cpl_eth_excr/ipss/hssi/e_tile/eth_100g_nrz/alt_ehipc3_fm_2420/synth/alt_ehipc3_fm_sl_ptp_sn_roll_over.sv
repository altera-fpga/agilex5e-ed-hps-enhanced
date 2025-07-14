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
// Filename         : alt_ehipc3_fm_sl_ptp_sn_roll_over.sv
// Author           : Shoaib Sial <shoaib.sial@intel.com>
// Created On       : Wed Sep 11/09/2019
//
//------------------------------------------------------------------------------

module	alt_ehipc3_fm_sl_ptp_sn_roll_over #(
  parameter SYNC_FLOPS = 2
)
(
	input wire 											i_reset_n,
	input wire 											i_clk,
	input wire 											i_ptp_ready,
//	input wire											i_pol_dn,
//	input wire											i_pol_sel,
//	input wire											i_async_chg,
//	input wire											i_async_triger,
	input wire											i_async_pulse_2d_1s,
        input wire [31:0]                                                                               i_apulse_period,
        input wire [31:0]                                                                               i_apulse_skip,
        input wire [31:0]                                                                               i_apulse_roll_dly,
	input wire 											i_measure_done,
	input wire 											i_transit,
	output wire [31:0]				   				                o_skip_ini,
	output wire [3:0]				   				                o_state_rollover,
	output reg [31:0]				   				                o_apulse_count,
	output wire [31:0]				   				                o_apulse_rt_period,
	output wire [31:0]				   				                o_apulse_sn_period,
	output wire [31:0]				   				                o_apulse_period_err,
	output reg											o_err,
	output reg											o_err2,
	output wire [31:0]				   				                o_latency_err2,
	output reg											o_roll_over,
	output reg											o_rollover_pulse_minus1,
//	output reg											o_roll_over_trig,
	output reg											o_roll_over_trig_l,
	output reg											o_roll_over_trig_tn,
	output reg											o_roll_over_valid

);




  localparam  INIT 		        = 4'b0000;
  localparam  SKIP_CNT		        = 4'b0001;
  localparam  WAIT_ASYNC   		= 4'b0010;
  localparam  WAIT_ASYNC_ROLL   	= 4'b0011;
  localparam  ROLL_DLY  		= 4'b0100;
  localparam  AP_PR_DET   		= 4'b0101;
  localparam  AP_PR_ERR   		= 4'b0110;
  localparam  AP_PR_STB   		= 4'b0111;
  localparam  ROLL_EN   		= 4'b1000;
  localparam  WAIT_ASYNC2   		= 4'b1001;
  localparam  ROLL_CHK   		= 4'b1010;
  localparam  SKIP_CNT2   		= 4'b1011;
  localparam  AP_PR_ERR2   		= 4'b1100;


  wire [15:0] latency_plus_gap;
  wire [15:0] latency_minus_gap;

  wire [19:0] apulse_period_plus_gap;
  wire [19:0] apulse_period_minus_gap;

  wire [15:0] apulse_roll_dly;
  wire [7:0]  apulse_roll_pos_gap;
  wire [7:0]  apulse_roll_neg_gap;
  wire [7:0]  retry_lim;

  wire        async_pulse_2d_1s_ch;
  wire        async_pulse_2d_1s_a;
  wire        async_pulse_2d_1s;
  wire        async_triger_2d;

  reg        async_triger_3d;

  reg [19:0] roll_over_count;
  reg [19:0] roll_over_count_l;
  reg [19:0] roll_over_count_tn;

  reg [3:0] next_state;
  reg [3:0] state;

  reg [15:0] skip_count_ini;
  reg [15:0] skip_count_calc;
  reg [3:0] dly_count;

  reg        skip_ini_en;
  reg        dly_en;
  reg        roll_restart;

  reg        measure_done_r;
  wire       measure_done_1s;

  reg [19:0] apulse_period_det_rt;
  reg [19:0] apulse_period_det_sn;
  reg [19:0] apulse_period_det_err;
  reg [19:0] apulse_period_det;

  reg [15:0] latency_count;
  reg [15:0] latency_count_err2;

  reg        ap_det_sn_en;
  reg        roll_over_valid;
  reg        err;
  reg        err1;
  reg        err2;
  reg [3:0]  retry;
  reg [3:0]  retry_stb;
  reg        recalc;
  reg        recalc_all;
  reg        retry_inc;
  reg        retry_stb_inc;

  reg   rollover_pulse_minus1 /* synthesis dont_merge */;
  reg   rollover_pulse_minus2 /* synthesis dont_merge */;
  wire  rollover_pulse_minus3;
  wire [19:0] apulse_period_minus_3;
  wire carry;

  wire [19:0] apulse_period_minus_1;
  wire [15:0] apulse_roll_neg_gap_neg_sync_flop;
  wire [19:0] roll_over_count_plus_1;
  wire [19:0] roll_over_count_l_plus_1;
  wire [19:0] roll_over_count_tn_plus_1;

  wire [15:0] skip_count_ini_plus_1;
  wire [3:0]  dly_count_plus_1;

  wire [19:0] apulse_period_det_plus_1;
  wire [3:0]  retry_plus_1;
  wire [3:0]  retry_stb_plus_1;
  wire [15:0] skip_count_calc_plus_1;
  wire [15:0] latency_count_plus_1;
  wire [15:0] latency_count_plus_sync;
  wire [31:0] o_apulse_count_plus_1;

/*
`ifdef __ALTERA_STD__METASTABLE_SIM
    alt_ehipc3_fm_xcvr_resync_norand_std #(
`else
    alt_xcvr_resync_std #(
`endif
        .SYNC_CHAIN_LENGTH  (SYNC_FLOPS),
        .WIDTH              (1),
        .INIT_VALUE         (0)
    ) async_2ds (
        .clk                (i_clk),
        .reset              (1'b0),
        .d                  (i_async_triger),
        .q                  (async_triger_2d)
    );

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      async_triger_3d <= 1'b0;
    else
      async_triger_3d <= async_triger_2d;
  end
*/
/*
    assign async_pulse_2d_1s = (i_async_chg == 1'b1) ? async_pulse_2d_1s_ch : async_pulse_2d_1s_a;
    assign async_pulse_2d_1s_ch = (i_pol_sel) ? async_triger_2d & ~async_triger_3d : ~async_triger_2d & async_triger_3d;
    assign async_pulse_2d_1s_a = async_triger_2d ^ async_triger_3d;
*/
//    assign async_pulse_2d_1s = async_triger_2d ^ async_triger_3d;

    assign async_pulse_2d_1s = i_async_pulse_2d_1s;

  assign {carry,apulse_period_minus_3} = i_apulse_period[19:0] - 2'b11;
  assign apulse_period_minus_1     = i_apulse_period[19:0] - 1'b1;
  assign roll_over_count_plus_1    = roll_over_count[18:0] + 1'b1;
  assign roll_over_count_l_plus_1  = roll_over_count_l[18:0] + 1'b1;
  assign roll_over_count_tn_plus_1 = roll_over_count_tn[18:0] + 1'b1;
  assign skip_count_ini_plus_1     = skip_count_ini + 1'b1;
  assign dly_count_plus_1          = dly_count + 1'b1;
  assign apulse_period_det_plus_1  = apulse_period_det + 1'b1;
  assign retry_plus_1              = retry + 1'b1;
  assign retry_stb_plus_1          = retry_stb + 1'b1;
  assign skip_count_calc_plus_1    = skip_count_calc + 1'b1;
  assign latency_count_plus_1      = latency_count + 1'b1;
  assign latency_count_plus_sync   = latency_count + SYNC_FLOPS;
  assign o_apulse_count_plus_1     = o_apulse_count + 1'b1;

  assign apulse_roll_dly     = i_apulse_roll_dly[15:0];
  assign apulse_roll_pos_gap = i_apulse_roll_dly[23:16];
  // assign apulse_roll_neg_gap = (i_apulse_roll_dly[23:16] > (apulse_roll_dly - SYNC_FLOPS) ) ? (apulse_roll_dly - SYNC_FLOPS) :  i_apulse_roll_dly[23:16];


  assign apulse_roll_neg_gap_neg_sync_flop = (apulse_roll_dly - SYNC_FLOPS);
  assign apulse_roll_neg_gap = (i_apulse_roll_dly[23:16] > apulse_roll_neg_gap_neg_sync_flop[7:0] ) ? apulse_roll_neg_gap_neg_sync_flop[7:0] :  i_apulse_roll_dly[23:16];
  assign retry_lim           = i_apulse_roll_dly[31:24];

  assign o_skip_ini = {i_apulse_skip[15:0], skip_count_ini};


  assign apulse_period_plus_gap[19:0]  = apulse_period_minus_1[18:0] + apulse_roll_pos_gap;
  assign apulse_period_minus_gap = ({12'd0, apulse_roll_pos_gap} < i_apulse_period[19:0]) ? apulse_period_minus_1[18:0] - apulse_roll_pos_gap : 20'd0;

  assign latency_plus_gap  = (apulse_roll_dly - SYNC_FLOPS) + apulse_roll_pos_gap;
  assign latency_minus_gap = (apulse_roll_dly - SYNC_FLOPS) - apulse_roll_neg_gap;



  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      roll_over_count <= 20'd0;
    else if (roll_restart || recalc)
      roll_over_count <= 20'd0;
    else if (rollover_pulse_minus1)
      roll_over_count <= 20'd0;
    else
      roll_over_count <= roll_over_count_plus_1;
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      roll_over_count_l <= 20'd0;
    else if (measure_done_1s)
      roll_over_count_l <= roll_over_count_plus_1;
    else if (roll_over_count_l == apulse_period_minus_1[19:0])
      roll_over_count_l <= 20'd0;
    else
      roll_over_count_l <= roll_over_count_l_plus_1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      roll_over_count_tn <= 20'd0;
    else if (i_transit && (roll_over_count_l == apulse_period_minus_1[19:0]))
      roll_over_count_tn <= 20'd0;
    else if (i_transit)
      roll_over_count_tn <= roll_over_count_l_plus_1;
    else if (roll_over_count_tn == apulse_period_minus_1[19:0])
      roll_over_count_tn <= 20'd0;
    else
      roll_over_count_tn <= roll_over_count_tn_plus_1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      skip_count_ini <= 16'd0;
//    else if (skip_ini_en && async_pulse_2d_1s)
    else if (skip_ini_en )
      skip_count_ini <= skip_count_ini_plus_1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      dly_count <= 4'd0;
    else if(recalc)
      dly_count <= 4'd0;
    else if (dly_en)
      dly_count <= dly_count_plus_1;
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_roll_over <= 1'b0;
    else if (rollover_pulse_minus1)
      o_roll_over <= 1'b1;
    else
      o_roll_over <= 1'b0;
  end

//  assign o_rollover_pulse_minus1 = (roll_over_count == apulse_period_minus_1[19:0]) ? 1'b1 :1'b0;
assign rollover_pulse_minus3 = (roll_over_count == apulse_period_minus_3[19:0]) ? 1'b1 :1'b0;
 always@(posedge i_clk)
  begin
      rollover_pulse_minus2 <= rollover_pulse_minus3;
      rollover_pulse_minus1 <= rollover_pulse_minus2;
  end

 always@(posedge i_clk)
  begin
      o_rollover_pulse_minus1 <= rollover_pulse_minus2;
  end


/*
  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_roll_over_trig <= 1'b0;
    else if (roll_over_count == apulse_period_minus_1[19:0])
      o_roll_over_trig <= ~o_roll_over_trig;
  end
*/
  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_roll_over_trig_l <= 1'b0;
    else if (roll_over_count_l == apulse_period_minus_1[19:0])
      o_roll_over_trig_l <= ~o_roll_over_trig_l;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_roll_over_trig_tn <= 1'b0;
    else if (i_transit && (roll_over_count_l == apulse_period_minus_1[19:0]))
      o_roll_over_trig_tn <= ~o_roll_over_trig_tn;
    else if (roll_over_count_tn == apulse_period_minus_1[19:0])
      o_roll_over_trig_tn <= ~o_roll_over_trig_tn;
  end

  always@(*)
  begin
      next_state         = state;
      skip_ini_en        = 1'b0;
      ap_det_sn_en       = 1'b0;
      dly_en             = 1'b0;
      roll_restart       = 1'b0;
      roll_over_valid    = 1'b0;
      recalc             = 1'b0;
      retry_inc          = 1'b0;
      retry_stb_inc      = 1'b0;
      err                = 1'b0;
      err1               = 1'b0;
      err2               = 1'b0;

      case (state)
        INIT:
        begin
          if (i_ptp_ready)
          next_state    = SKIP_CNT;
        end
        SKIP_CNT:
        begin
          if (async_pulse_2d_1s)
            skip_ini_en     = 1'b1;
          if (skip_count_ini == i_apulse_skip[15:0])
          begin
            skip_ini_en   = 1'b0;
            next_state    = WAIT_ASYNC;
          end
        end
        WAIT_ASYNC:
        begin
//          if (async_pulse_2d_1s && i_pol_dn)
          if (async_pulse_2d_1s)
          begin
           roll_restart     = 1'b1;
           next_state    = WAIT_ASYNC_ROLL;
          end
        end
        WAIT_ASYNC_ROLL:
        begin
          ap_det_sn_en     = 1'b1;
          if (async_pulse_2d_1s)
          begin
           roll_restart     = 1'b1;
           next_state    = ROLL_DLY;
          end
        end
        ROLL_DLY:
        begin
          dly_en        = 1'b1;
          if (dly_count == ((apulse_roll_dly - 1) - SYNC_FLOPS) )
          begin
            dly_en        = 1'b0;
            roll_restart  = 1'b1;
            next_state    = AP_PR_DET;
          end
        end
        AP_PR_DET:
        begin
          if (o_roll_over)
          begin
           next_state    = AP_PR_ERR;
          end
          else if (async_pulse_2d_1s)
          begin
           // if (( (apulse_period_det + apulse_roll_pos_gap) >= (i_apulse_period - 1) ) && ( apulse_period_det <= (i_apulse_period - 1 + apulse_roll_pos_gap) ))
            if (( apulse_period_det >= apulse_period_minus_gap[19:0] ) && ( apulse_period_det <= apulse_period_plus_gap[19:0] ))
              next_state    = AP_PR_STB;
            else
              next_state    = AP_PR_ERR;
          end
        end
        AP_PR_ERR:
        begin
          if (retry < retry_lim[3:0])
          begin
            next_state    = WAIT_ASYNC;
            recalc = 1'b1;
            retry_inc = 1'b1;
          end
          else
          begin
            err  = 1'b1;
            err1 = 1'b1;
            if (recalc_all)
            begin
              recalc = 1'b1;
              next_state    = WAIT_ASYNC;
            end
          end
        end
        AP_PR_STB:
        begin
          if (apulse_period_det_sn == i_apulse_period[19:0])
            next_state    = ROLL_EN;
          else if (retry_stb < retry_lim[3:0])
          begin
            next_state    = WAIT_ASYNC;
            recalc = 1'b1;
            retry_stb_inc = 1'b1;
          end
          else
            next_state    = ROLL_EN;
        end
        ROLL_EN:
        begin
          roll_over_valid  = 1'b1;
          if (recalc_all)
          begin
            recalc = 1'b1;
            next_state    = WAIT_ASYNC;
          end
          else
            next_state    = WAIT_ASYNC2;
        end
        WAIT_ASYNC2:
        begin
          roll_over_valid  = 1'b1;
          if (recalc_all)
          begin
            recalc = 1'b1;
            next_state    = WAIT_ASYNC;
          end
          else if(i_measure_done)
            next_state    = SKIP_CNT2;
          else if(async_pulse_2d_1s)
            next_state    = ROLL_CHK;
        end
        ROLL_CHK:
        begin
          roll_over_valid  = 1'b1;
          if (recalc_all)
          begin
            recalc = 1'b1;
            next_state    = WAIT_ASYNC;
          end
          else if(i_measure_done)
            next_state    = SKIP_CNT2;
      //    else if(o_roll_over && (latency_count > ((apulse_roll_dly - SYNC_FLOPS) + apulse_roll_pos_gap)) )
          else if(o_roll_over && (latency_count > latency_plus_gap) )
          begin
            err2 = 1'b1;
            next_state    = AP_PR_ERR2;
          end
     //     else if(o_roll_over && (latency_count < ((apulse_roll_dly - SYNC_FLOPS) - apulse_roll_neg_gap)) )
          else if(o_roll_over && (latency_count < latency_minus_gap) )
          begin
            err2 = 1'b1;
            next_state    = AP_PR_ERR2;
          end
          else if(o_roll_over)
            next_state    = WAIT_ASYNC2;
        end
        SKIP_CNT2:
        begin
          roll_over_valid  = 1'b1;
          if (recalc_all)
          begin
            recalc = 1'b1;
//            next_state    = WAIT_ASYNC;
          end
        end
        AP_PR_ERR2:
        begin
          err  = 1'b1;
          next_state    = WAIT_ASYNC;
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
    else
      state <= next_state;
  end

  assign o_state_rollover = state;

  assign o_apulse_rt_period = {12'd0,apulse_period_det_rt};
  assign o_apulse_sn_period = {12'd0,apulse_period_det_sn};
  assign o_apulse_period_err = {12'd0,apulse_period_det_err};

  always@(posedge i_clk)
  begin
//    if(!i_reset_n)
//      apulse_period_det_rt <= 20'd0;
//    else if (async_pulse_2d_1s)
    if (async_pulse_2d_1s)
      apulse_period_det_rt <= apulse_period_det_plus_1;
  end


  always@(posedge i_clk)
  begin
 //   if(!i_reset_n)
 //     apulse_period_det_sn <= 20'd0;
//    else if (async_pulse_2d_1s && ap_det_sn_en)
    if (async_pulse_2d_1s && ap_det_sn_en)
      apulse_period_det_sn <= apulse_period_det_plus_1;
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      apulse_period_det_err <= 20'd0;
    else if (err)
      apulse_period_det_err <= apulse_period_det_rt;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      apulse_period_det <= 20'd0;
    else if (async_pulse_2d_1s)
      apulse_period_det <= 20'd0;
    else
      apulse_period_det <= apulse_period_det_plus_1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      retry <= 4'd0;
    else if (recalc_all)
      retry <= 4'd0;
    else if (retry_inc)
      retry <= retry_plus_1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      retry_stb <= 4'd0;
    else if (retry_inc || recalc_all)
      retry_stb <= 4'd0;
    else if (retry_stb_inc)
      retry_stb <= retry_stb_plus_1;
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      skip_count_calc <= 16'd0;
    else if ( (i_measure_done && (skip_count_calc == i_apulse_skip[31:16])) || err )
      skip_count_calc <= 16'd0;
    else if (skip_count_calc == i_apulse_skip[31:16])
      skip_count_calc <= skip_count_calc;
    else if (i_measure_done && async_pulse_2d_1s)
      skip_count_calc <= skip_count_calc_plus_1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      recalc_all <= 1'b0;
//    else if ( (i_measure_done && (skip_count_calc == i_apulse_skip[31:16])) || err )
    else if ( err )
      recalc_all <= 1'b1;
    else
      recalc_all <= 1'b0;
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      measure_done_r <= 1'b0;
    else
      measure_done_r <= i_measure_done;
  end

  assign measure_done_1s = i_measure_done & (~measure_done_r);


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_roll_over_valid <= 1'b0;
    else
      o_roll_over_valid <= roll_over_valid;
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_err <= 1'b0;
    else if (measure_done_1s)
      o_err <= 1'b0;
    else if (err)
      o_err <= 1'b1;
  end


  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_err2 <= 1'b0;
    else if (err1)
      o_err2 <= 1'b0;
    else if (measure_done_1s)
      o_err2 <= 1'b0;
    else if (err2)
      o_err2 <= 1'b1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      latency_count <= 16'd0;
    else if (async_pulse_2d_1s)
      latency_count <= 16'd0;
    else if (o_roll_over)
      latency_count <= 16'd0;
    else
      latency_count <= latency_count_plus_1;
  end

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      latency_count_err2 <= 16'd0;
    else if (err2)
      latency_count_err2 <= latency_count_plus_sync;
  end

  assign o_latency_err2 = {16'd0,latency_count_err2};

  always@(posedge i_clk)
  begin
    if(!i_reset_n)
      o_apulse_count <= 32'd0;
    else if (async_pulse_2d_1s)
      o_apulse_count <= o_apulse_count_plus_1;
  end

endmodule
