// (C) 2001-2024 Intel Corporation. All rights reserved.
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


//////////////////////////////////////////////////////////////////////////////
// This module is a wrapper for the address generators.  The generators'
// outputs are multiplexed in this module using the select signals.
// The address generation modes are sequential (from a given start address),
// random, random sequential which produces sequential addresses from a
// random start address, and one-hot
//////////////////////////////////////////////////////////////////////////////
module altera_emif_avl_tg_2_addr_gen # (
   parameter AMM_WORD_ADDRESS_WIDTH                = "",
   parameter SEQ_CNT_WIDTH                         = "",
   parameter RAND_SEQ_CNT_WIDTH                    = "",
   parameter SEQ_ADDR_INCR_WIDTH                   = "",
   parameter AMM_BURST_COUNT_DIVISIBLE_BY    = "",
   parameter AMM_WORD_ADDRESS_DIVISIBLE_BY   = "",

   // If set to true, the unix_id will be added to the MSB bit of the generated address.
   // This is useful to avoid address overlapping when more than one traffic generator
   // being connected to the same slave. Supports 2^UNIX_ID_WIDTH TGs.
   parameter ENABLE_UNIX_ID                        = 0,
   parameter UNIX_ID_WIDTH                         = 3,
   parameter USE_UNIX_ID                           = {UNIX_ID_WIDTH{1'b0}},
   parameter AMM_BURSTCOUNT_WIDTH                  = ""
) (
   // Clock and reset
   input                                           clk,
   input                                           rst,

   // Control and status
   input                                           enable,

   input                                           start,
   input [AMM_WORD_ADDRESS_WIDTH-1:0]              start_addr,
   input [1:0]                                     addr_gen_mode,

   //for sequential mode
   input                                           seq_return_to_start_addr,
   input [SEQ_CNT_WIDTH-1:0]                       seq_addr_num,

   //for random sequential mode
   input [RAND_SEQ_CNT_WIDTH-1:0]                  rand_seq_num_seq_addr,
   input                                           rand_seq_restart_pattern,

   //increment size for sequential and random sequential addressing
   //increments avalon address
   input [SEQ_ADDR_INCR_WIDTH-1:0]                 seq_addr_increment,

   // Address generator outputs
   output   [AMM_WORD_ADDRESS_WIDTH-1:0]           addr_out,
   input    [AMM_BURSTCOUNT_WIDTH-1:0]             burstlength
);
   timeunit 1ns;
   timeprecision 1ps;

   import avl_tg_defs::*;

   localparam TRUNCATED_AMM_WORD_ADDRESS_WIDTH = (ENABLE_UNIX_ID ? AMM_WORD_ADDRESS_WIDTH-UNIX_ID_WIDTH : AMM_WORD_ADDRESS_WIDTH);
   logic [TRUNCATED_AMM_WORD_ADDRESS_WIDTH-1:0]      addr;

   // Sequential address generator signals
   logic                                             seq_addr_gen_enable;
   logic [TRUNCATED_AMM_WORD_ADDRESS_WIDTH-1:0]      seq_addr_gen_addr;
   logic [TRUNCATED_AMM_WORD_ADDRESS_WIDTH-1:0]      seq_start_addr;

   // Random address generator signals
   logic                                             rand_addr_gen_enable;
   logic [TRUNCATED_AMM_WORD_ADDRESS_WIDTH-1:0]      rand_addr_gen_addr;

   //one-hot address generator signals
   logic                                             one_hot_addr_gen_enable;
   logic [TRUNCATED_AMM_WORD_ADDRESS_WIDTH-1:0]      one_hot_addr_gen_addr;

   reg [RAND_SEQ_CNT_WIDTH-1:0] num_rand_seq_addr;
   always @ (posedge clk)
   begin
      if (addr_gen_mode==TG_ADDR_RAND_SEQ) begin
         num_rand_seq_addr <= rand_seq_num_seq_addr;
      end else begin
         num_rand_seq_addr <= 1'b1;
      end
   end

   // When UNIX_IDs are used, addr must be concatenated to the hardcoded USE_UNIX_ID
   // to avoid overwriting the pseudorandom bits and affecting the generated patterns.
   assign addr_out = (ENABLE_UNIX_ID == 1) ? {USE_UNIX_ID[UNIX_ID_WIDTH-1:0], addr} : addr;

   always_comb
   begin
      case (addr_gen_mode)
         TG_ADDR_SEQ:
         begin
            addr  = seq_addr_gen_addr;
         end
         TG_ADDR_RAND:
         begin
            addr  = rand_addr_gen_addr;
         end
         TG_ADDR_ONE_HOT:
         begin
            addr = one_hot_addr_gen_addr;
         end
         TG_ADDR_RAND_SEQ:
         begin
            addr  = rand_addr_gen_addr;
         end
         default: addr = 'x;
      endcase
   end

   // Address generator inputs
   assign seq_addr_gen_enable      = enable & (addr_gen_mode == TG_ADDR_SEQ);
   assign rand_addr_gen_enable     = enable & (addr_gen_mode == TG_ADDR_RAND || addr_gen_mode == TG_ADDR_RAND_SEQ);
   assign one_hot_addr_gen_enable  = enable & (addr_gen_mode == TG_ADDR_ONE_HOT);

   // The sequential start address should be the input start address for sequential mode.
   assign seq_start_addr = start_addr[TRUNCATED_AMM_WORD_ADDRESS_WIDTH-1:0];

   // Sequential address generator
   altera_emif_avl_tg_2_seq_addr_gen # (
      .AMM_WORD_ADDRESS_WIDTH          (TRUNCATED_AMM_WORD_ADDRESS_WIDTH),
      .SEQ_ADDR_INCR_WIDTH             (SEQ_ADDR_INCR_WIDTH),
      .SEQ_CNT_WIDTH                   (SEQ_CNT_WIDTH),
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY)
   ) seq_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (seq_addr_gen_enable),
      .seq_addr                     (seq_addr_gen_addr),
      .start_addr                   (seq_start_addr),
      .start                        (start),
      .return_to_start_addr         (seq_return_to_start_addr),
      .seq_addr_increment           (seq_addr_increment),
      .num_seq_addr                 (seq_addr_num)
   );

   // Random address generator
   altera_emif_avl_tg_2_rand_seq_addr_gen # (
      .AMM_WORD_ADDRESS_WIDTH          (TRUNCATED_AMM_WORD_ADDRESS_WIDTH),
      .SEQ_ADDR_INCR_WIDTH             (SEQ_ADDR_INCR_WIDTH),
      .RAND_SEQ_CNT_WIDTH              (RAND_SEQ_CNT_WIDTH),
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURSTCOUNT_WIDTH            (AMM_BURSTCOUNT_WIDTH)
   ) rand_seq_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (rand_addr_gen_enable),
      .restart_pattern              (rand_seq_restart_pattern),
      .addr_out                     (rand_addr_gen_addr),
      //number of sequential addresses between each random address
      //for full random mode, set to 1
      .num_rand_seq_addr            (num_rand_seq_addr),
      //increment size for sequential addresses
      .rand_seq_addr_increment      (seq_addr_increment),
      .seed                         (seq_start_addr),
      .burstlength                  (burstlength)
   );

   altera_emif_avl_tg_2_one_hot_addr_gen # (
      .ADDR_WIDTH                      (TRUNCATED_AMM_WORD_ADDRESS_WIDTH),
      .AMM_WORD_ADDRESS_DIVISIBLE_BY   (AMM_WORD_ADDRESS_DIVISIBLE_BY),
      .AMM_BURST_COUNT_DIVISIBLE_BY    (AMM_BURST_COUNT_DIVISIBLE_BY)
   ) one_hot_addr_gen_inst (
      .clk                          (clk),
      .rst                          (rst),
      .enable                       (one_hot_addr_gen_enable),
      .one_hot_addr                 (one_hot_addr_gen_addr),
      .start                        (start)
   );

endmodule
