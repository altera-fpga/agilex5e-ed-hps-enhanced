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


//////////////////////////////////////////////////////////////////////////////////
// Deskew module
//
// for PAM4 PMA-direct mode MAIB_FIFO_DW mode (in 1/2 rate clock domain)
//////////////////////////////////////////////////////////////////////////////////
module altera_xcvr_native_dskw_pam4 #(
   DOUBLE_WIDTH_SEL=0
) (
clk         ,                           // half-rate Rx clk (1X clock) from MAIB
reset_ev,
reset_od,
//rst         ,                           // reset (!nd_ready for SSDV)
dskw_start         ,                           // rx data ready
data_in_ln0 ,                           // ln#0 data
data_in_ln1 ,                           // ln#1 data

dskw_done         ,                           // de-skew done
dout_ln0,                               // de-skewed ln#0 data
dout_ln1,                              // de-skewed ln#1 data
err_status_min_mk                              //
);

// module parameters
localparam  DATA_WIDTH       = 80;
localparam  EVEN_SYNC_BIT    = 33;
localparam  ODD_SYNC_BIT     = 73;
localparam  DEFAULT_SYNC_POS = 2;        // ref point
localparam  PIPE_DEPTH_LN0       = 3;
localparam  PIPE_DEPTH_LN1       = 5;        // cover max-skew = 2 clk cycs

localparam  ST_WAIT_SYNC_1   = 3'd0,
            ST_WAIT_SYNC_2   = 3'd1,
            ST_PRE_EVAL      = 3'd2,
            ST_EVAL          = 3'd3,
            ST_DONE          = 3'd4;

// module I/O definitions
input                    clk;
//input                    rst;
input                    reset_ev;
input                    reset_od;
input                    dskw_start;
input  [DATA_WIDTH-1:0]  data_in_ln0;
input  [DATA_WIDTH-1:0]  data_in_ln1;

output                   dskw_done;
output [DATA_WIDTH-1:0]  dout_ln0;
output [DATA_WIDTH-1:0]  dout_ln1;
output                 err_status_min_mk; //temp tie to wire
wire [3:0]             err_status;
wire                     rst_sync;
wire                     rst_ev_sync;
wire                     rst_od_sync;

// module internal definitions
reg  [2:0]             cur_state,        nxt_state;
reg                    cur_ln0_even_flg, nxt_ln0_even_flg;
reg                    cur_ln1_even_flg, nxt_ln1_even_flg;
reg                    cur_fsm_err_flg,  nxt_fsm_err_flg;
reg                    cur_dskw_flg,     nxt_dskw_flg;

reg                    dskw_start_d1, dskw_start_sync;

reg  [DATA_WIDTH-1:0]  pipe_ln0_data[PIPE_DEPTH_LN0];
reg  [DATA_WIDTH-1:0]  pipe_ln1_data[PIPE_DEPTH_LN1];

always @ (posedge clk) begin
    dskw_start_d1 <= dskw_start;
    dskw_start_sync <= dskw_start_d1;
end

// reset sync //
  alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
        .WIDTH            (1),  // Number of bits to resync
        .INIT_VALUE       (1'b0)
      ) alt_xcvr_resync_reset_ev (
        .clk    (clk        ),
        .reset  (reset_ev),
        .d      (1'b1       ),
        .q      (rst_ev_sync)
      );

  alt_xcvr_resync_std #(
        .SYNC_CHAIN_LENGTH(2),  // Number of flip-flops for retiming
        .WIDTH            (1),  // Number of bits to resync
        .INIT_VALUE       (1'b0)
      ) alt_xcvr_resync_reset_od (
        .clk    (clk        ),
        .reset  (reset_od),
        .d      (1'b1       ),
        .q      (rst_od_sync)
      );

assign rst_sync = rst_ev_sync & rst_od_sync ;
//
// pipe through data for the 2 lanes
//
always @ (posedge clk or negedge rst_sync) begin
 if (!rst_sync) begin
  pipe_ln0_data[0] <= 80'd0;
  pipe_ln0_data[1] <= 80'd0;
  pipe_ln0_data[2] <= 80'd0;

  pipe_ln1_data[0] <= 80'd0;
  pipe_ln1_data[1] <= 80'd0;
  pipe_ln1_data[2] <= 80'd0;
  pipe_ln1_data[3] <= 80'd0;
  pipe_ln1_data[4] <= 80'd0;
 end
 else begin
  pipe_ln0_data[0] <= data_in_ln0;
  pipe_ln0_data[1] <= pipe_ln0_data[0];
  pipe_ln0_data[2] <= pipe_ln0_data[1];

  pipe_ln1_data[0] <= data_in_ln1;
  pipe_ln1_data[1] <= pipe_ln1_data[0];
  pipe_ln1_data[2] <= pipe_ln1_data[1];
  pipe_ln1_data[3] <= pipe_ln1_data[2];
  pipe_ln1_data[4] <= pipe_ln1_data[3];
 end
end

//
// sync_bit (lane#0 & lane#1) seen at pipe stage#0
//
wire       pipe0_ln0_sync_bit_ev = pipe_ln0_data[0][EVEN_SYNC_BIT];
wire       pipe0_ln0_sync_bit_od = pipe_ln0_data[0][ODD_SYNC_BIT];

wire       pipe0_ln1_sync_bit_ev = pipe_ln1_data[0][EVEN_SYNC_BIT];
wire       pipe0_ln1_sync_bit_od = pipe_ln1_data[0][ODD_SYNC_BIT];

//
// sync_bit vectors for lane#1
//
wire [4:0] ln1_sync_bit_vec =  DOUBLE_WIDTH_SEL ?
	                      {(pipe_ln1_data[4][EVEN_SYNC_BIT] | pipe_ln1_data[4][ODD_SYNC_BIT]),
                               (pipe_ln1_data[3][EVEN_SYNC_BIT] | pipe_ln1_data[3][ODD_SYNC_BIT]),
                               (pipe_ln1_data[2][EVEN_SYNC_BIT] | pipe_ln1_data[2][ODD_SYNC_BIT]),
                               (pipe_ln1_data[1][EVEN_SYNC_BIT] | pipe_ln1_data[1][ODD_SYNC_BIT]),
                               (pipe_ln1_data[0][EVEN_SYNC_BIT] | pipe_ln1_data[0][ODD_SYNC_BIT])} :
			       {(pipe_ln1_data[4][EVEN_SYNC_BIT]),
                                (pipe_ln1_data[3][EVEN_SYNC_BIT]),
                                (pipe_ln1_data[2][EVEN_SYNC_BIT]),
                                (pipe_ln1_data[1][EVEN_SYNC_BIT]),
                                (pipe_ln1_data[0][EVEN_SYNC_BIT])};


//
// deskew calculation, ln1_sync_pos is not valid when there is mkr_err
//
reg [2:0] ln1_sync_pos;
reg [2:0] mkr_err;

always @ (posedge clk or negedge rst_sync) begin
  if (!rst_sync) begin
    ln1_sync_pos <= DEFAULT_SYNC_POS;
    mkr_err      <= 3'h0;
  end
  else if (cur_state == ST_EVAL) begin
    if (DOUBLE_WIDTH_SEL) begin
       mkr_err[0] <= ln1_sync_bit_vec[0] & ~cur_ln1_even_flg; // sync_bit at ODD position & no upper-bank data available
    end
    case (ln1_sync_bit_vec)
      5'b1_0000: ln1_sync_pos <= 3'd4;
      5'b0_1000: ln1_sync_pos <= 3'd3;
      5'b0_0100: ln1_sync_pos <= 3'd2;
      5'b0_0010: ln1_sync_pos <= 3'd1;
      5'b0_0001: ln1_sync_pos <= 3'd0;
      5'b1_0001: begin mkr_err[1] <= 1'b1; ln1_sync_pos <= DEFAULT_SYNC_POS; end  // marker min spacing err

      default:   begin mkr_err[2] <= 1'b1; ln1_sync_pos <= DEFAULT_SYNC_POS; end  // other marker err
    endcase
  end
end

//
// FSM for deskew (use lane#0 as ref)
//
always @ (*) begin

  nxt_state        = cur_state;
  nxt_ln0_even_flg = cur_ln0_even_flg;
  nxt_ln1_even_flg = cur_ln1_even_flg;
  nxt_fsm_err_flg  = cur_fsm_err_flg;
  nxt_dskw_flg     = cur_dskw_flg;

  case (cur_state)
     ST_WAIT_SYNC_1:   // wait state, for ln1 sync_bit
     begin
      if (DOUBLE_WIDTH_SEL) begin
       if (pipe0_ln1_sync_bit_ev || pipe0_ln1_sync_bit_od) begin
           nxt_state        =  ST_WAIT_SYNC_2;
           nxt_ln1_even_flg = ~pipe0_ln1_sync_bit_od & pipe0_ln1_sync_bit_ev;
           nxt_fsm_err_flg  =  pipe0_ln1_sync_bit_od & pipe0_ln1_sync_bit_ev;
       end
      end
      else begin
      if (pipe0_ln1_sync_bit_ev) begin
           nxt_state        =  ST_WAIT_SYNC_2;
           nxt_ln1_even_flg = pipe0_ln1_sync_bit_ev;
       end
      end
     end

     ST_WAIT_SYNC_2:  // pipe stage#0, wait for ln0 sync_bit
     begin
      if (DOUBLE_WIDTH_SEL) begin
       if (pipe0_ln0_sync_bit_ev || pipe0_ln0_sync_bit_od) begin
           nxt_state        =  ST_PRE_EVAL;
           nxt_ln0_even_flg = ~pipe0_ln0_sync_bit_od & pipe0_ln0_sync_bit_ev;
           nxt_fsm_err_flg  =  pipe0_ln0_sync_bit_od & pipe0_ln0_sync_bit_ev;
       end
      end
      else begin
       if (pipe0_ln0_sync_bit_ev) begin
           nxt_state        =  ST_PRE_EVAL;
           nxt_ln0_even_flg = pipe0_ln0_sync_bit_ev;
       end
      end
     end

     ST_PRE_EVAL:     // pipe stage#1, transition state
     begin
           nxt_state = ST_EVAL;
     end

     ST_EVAL:         // pipe stage#2, evaluate other lanes within (-2, +2) range
     begin
           nxt_state = ST_DONE;
	   nxt_dskw_flg = 1'b1;
     end

     ST_DONE:         // stay here & do nothing
     begin
           nxt_state = ST_DONE;
     end
  endcase
end

always @ (posedge clk or negedge rst_sync) begin
  if (!rst_sync) begin
    cur_state        <= ST_WAIT_SYNC_1;
    cur_ln0_even_flg <= 1'b1;
    cur_ln1_even_flg <= 1'b1;
    cur_fsm_err_flg  <= 1'b0;
    cur_dskw_flg     <= 1'b0;
  end
  else if (dskw_start_sync)begin
    cur_state        <= nxt_state;
    cur_ln0_even_flg <= nxt_ln0_even_flg;
    cur_ln1_even_flg <= nxt_ln1_even_flg;
    cur_fsm_err_flg  <= nxt_fsm_err_flg;
    cur_dskw_flg     <= nxt_dskw_flg;
  end
end

//
// generate outputs
//
assign dskw_done = cur_dskw_flg & dskw_start_sync ;
assign err_status = {cur_fsm_err_flg, mkr_err[2:0]};
assign err_status_min_mk = err_status[1];

assign dout_ln1 = (DOUBLE_WIDTH_SEL&cur_ln1_even_flg || !DOUBLE_WIDTH_SEL) ? pipe_ln1_data[ln1_sync_pos] : {pipe_ln1_data[ln1_sync_pos - 1][39:0], pipe_ln1_data[ln1_sync_pos][79:40]};
assign dout_ln0 = (DOUBLE_WIDTH_SEL&cur_ln0_even_flg || !DOUBLE_WIDTH_SEL) ? pipe_ln0_data[DEFAULT_SYNC_POS] : {pipe_ln0_data[DEFAULT_SYNC_POS - 1][39:0], pipe_ln0_data[DEFAULT_SYNC_POS][79:40]};

endmodule // altera_xcvr_native_dskw_pam4
