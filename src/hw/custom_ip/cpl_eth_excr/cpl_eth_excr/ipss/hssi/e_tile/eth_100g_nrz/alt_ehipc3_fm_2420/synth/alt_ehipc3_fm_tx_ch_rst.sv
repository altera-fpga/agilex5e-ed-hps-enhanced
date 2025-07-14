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

module alt_ehipc3_fm_tx_ch_rst
  #(
    parameter [63:0] CLK_FREQ_IN_HZ = 125000000,
    parameter [63:0] DEFAULT_RESET_SEPARATION_NS = 200,
    parameter [63:0] RESET_SEPARATION_NS = 200,
    parameter NUM_CHANNELS = 1,
    parameter [3:0] CTRL_TX_ASSERT = 4'b0011,
    parameter [3:0] CTRL_TX_DEASSERT = 4'b0100,
    parameter [3:0] CTRL_KR_ASSERT = 4'b1001,
    parameter ENABLE_EXTERNAL_AIB_CLOCKING = 0

    )
   (
    input wire 			   clk,
    input wire 			   reset_n,
    input wire 			   reset_ack,
//    input wire 			   assert_req,
    input wire 			   tx_aib_assert_req,
    input wire 			   tx_pcs_assert_req,
    input wire 			   tx_aib_deassert_req,
    input wire 			   tx_pcs_deassert_req,
//    input wire 			   deassert_req,
    input wire [3:0] 		   ctrl_code,
    input wire [NUM_CHANNELS-1:0]  tx_transfer_ready_in,
    input wire [NUM_CHANNELS-1:0]  tx_dll_lock_in,
    input wire 			   all_seq_done,
    output wire [NUM_CHANNELS-1:0] tx_aib_reset_out,
    output wire [NUM_CHANNELS-1:0] tx_pcs_reset_out,
    output wire [NUM_CHANNELS-1:0] tx_dll_lock_req_out,
//    output wire 		   reset_timeout,
    output wire 		   tx_aib_deassert_req_done,
    output reg 			   tx_pcs_deassert_req_done,
    output wire 		   req_done,
    output reg 			   transfer_ready_timeout_err

   );


   localparam NUM_RESETS = NUM_CHANNELS;

   // These parameters calculate the counter width and count for reset separation
   localparam ADDED_RESET_SEPARATION_NS = (RESET_SEPARATION_NS > DEFAULT_RESET_SEPARATION_NS) ? (RESET_SEPARATION_NS - DEFAULT_RESET_SEPARATION_NS) : 0;

   localparam [63:0] ADDED_RESET_COUNT = (CLK_FREQ_IN_HZ * ADDED_RESET_SEPARATION_NS) / 1000000000;
   localparam [63:0] ADDED_RESET_ROUNT_COUNT = (((ADDED_RESET_COUNT * 1000000000) / CLK_FREQ_IN_HZ) < ADDED_RESET_SEPARATION_NS)
     ? (ADDED_RESET_COUNT + 1) : ADDED_RESET_COUNT;
   localparam ADDED_RESET_COUNT_MAX = (ADDED_RESET_ROUNT_COUNT > 0) ? ADDED_RESET_ROUNT_COUNT - 1 : 0;

   localparam [63:0] RESET_COUNT = (CLK_FREQ_IN_HZ * RESET_SEPARATION_NS) / 1000000000;
   localparam [63:0] RESET_ROUNT_COUNT = (((RESET_COUNT * 1000000000) / CLK_FREQ_IN_HZ) < RESET_SEPARATION_NS)
     ? (RESET_COUNT + 1) : RESET_COUNT;
   localparam RESET_COUNT_MAX = (RESET_ROUNT_COUNT > 0) ? RESET_ROUNT_COUNT - 1 : 0;

   localparam RESET_COUNT_SIZE = clogb2_s10(RESET_COUNT_MAX);
   localparam [RESET_COUNT_SIZE-1:0] ADDED_RESET_COUNT_ADD = {{RESET_COUNT_SIZE-1{1'b0}},1'b1};
   localparam [RESET_COUNT_SIZE-1:0] RESET_COUNT_ADD = {{RESET_COUNT_SIZE-1{1'b0}},1'b1};

   wire [NUM_RESETS-1:0] 	   tx_dll_lock_in_sync;
   wire [NUM_RESETS-1:0] 	   tx_transfer_ready_in_sync;

   // Reset state machine
   reg [3:0] 	       txreset_sm_cs;
   reg [3:0] 	       txreset_sm_ns;


   // Reset inputs

   // Reset output registers (must be synchronized at destination logic)
   reg [NUM_RESETS-1:0] 	       tx_aib_reset_out_reg;
   reg [NUM_RESETS-1:0] 	       tx_pcs_reset_out_reg;

   reg [NUM_RESETS-1:0] 	       int_tx_pcs_reset_reg;
	reg [NUM_CHANNELS-1:0] 	       tx_dll_lock_req_out_reg;

   reg [NUM_RESETS-1:0] 	       tx_aib_reset_out_stage;
   reg [NUM_RESETS-1:0] 	       tx_pcs_reset_out_stage;
   reg [NUM_CHANNELS-1:0] 	       tx_dll_lock_req_out_stage;
//   reg [NUM_RESETS-1:0] 	       reset_timeout_stage;

   // error status
   reg [NUM_RESETS-1:0] 	       transfer_ready_stat;

   reg [RESET_COUNT_SIZE-1:0] 	       tx_pcs_reset_counter;
   reg [RESET_COUNT_SIZE-1:0] 	       tx_aib_reset_counter;
   wire [RESET_COUNT_SIZE-1:0] 	       tx_aib_reset_release_count_max;
   wire [RESET_COUNT_SIZE-1:0] 	       tx_pcs_reset_release_count_max;


   //***************************************************************************
   // Reset output
   //***************************************************************************
   assign tx_aib_reset_out = tx_aib_reset_out_stage;
   assign tx_dll_lock_req_out = tx_dll_lock_req_out_stage;
   assign tx_pcs_reset_out = tx_pcs_reset_out_stage;


   // Add register stage to all resets
   always @(posedge clk)
     begin
	tx_aib_reset_out_stage <= tx_aib_reset_out_reg;
	tx_dll_lock_req_out_stage <= tx_dll_lock_req_out_reg;
	tx_pcs_reset_out_stage <= tx_pcs_reset_out_reg;
     end

   //***************************************************************************
   // Synchronizers
   //***************************************************************************
   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(NUM_RESETS),.INIT_VALUE(0))
   tx_transfer_ready_synchronizers
     (.clk	(clk),
      .reset	(~reset_n),
      .d	(tx_transfer_ready_in),
      .q	(tx_transfer_ready_in_sync));


   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(NUM_RESETS),.INIT_VALUE(0))
   tx_dll_lock_synchronizers
     (.clk	(clk),
      .reset	(~reset_n),
      .d	(tx_dll_lock_in),
      .q	(tx_dll_lock_in_sync));


   wire [RESET_COUNT_MAX -1 :0] tx_aib_count;
   wire [RESET_COUNT_MAX -1 :0] tx_pcs_count;

   // Reset sequence state machine
   // State machine parameters
   localparam  SAMPLE_RESET        = 4'd0;
   localparam  RESET_TX_PCS_CHANNELS  = 4'd1;
   localparam  RESET_TX_AIB       = 4'd2;
   localparam  RESET_TX_ANALOG    = 4'd3;
   localparam  DEASSERT_TX_AIB  = 4'd4;
   localparam  WAIT_FOR_DLL_LOCK  = 4'd5;
   localparam  DEASSERT_TX_PCS_CHANNELS  = 4'd6;
   localparam  WAIT_FOR_TRANSFER_READY = 4'd7;
   localparam  RESUME_RESET           = 4'd8;
   localparam DONE_REQ = 4'd9;


   reg 				req_done_comb;
   reg 				transfer_ready_timeout_err_comb;
      always @(*) begin
	 txreset_sm_ns = txreset_sm_cs;
	// update_reset = 1'b0;
//	 clear_timeout = 1'b0;
//	 tx_analogreset_comb = {NUM_RESETS{1'b0}};
	// reset_timeout_comb = 1'b1;
	 req_done_comb = 1'b0;
	 transfer_ready_timeout_err_comb = 1'b0;

	 case(txreset_sm_cs)
	   SAMPLE_RESET:
	     begin
		if (reset_ack)
		  begin
		     if ((tx_aib_assert_req | tx_pcs_assert_req) && !all_seq_done)
		       txreset_sm_ns = RESET_TX_PCS_CHANNELS;
		     else if (tx_aib_deassert_req && !all_seq_done)
		       txreset_sm_ns = DEASSERT_TX_AIB;
		     else if (tx_pcs_deassert_req && !all_seq_done)
		       txreset_sm_ns = DEASSERT_TX_PCS_CHANNELS;
		     /*
		     else if (deassert_req && !all_seq_done)
		       // If deassertion of tx_rst then we just reset the PCS so just deassert the PCS
		       if (ctrl_code == CTRL_TX_DEASSERT)
			 txreset_sm_ns = DEASSERT_TX_PCS_CHANNELS;
		       else
			 txreset_sm_ns = DEASSERT_TX_AIB;
		     */
		  end
	     end
	   RESET_TX_PCS_CHANNELS:
	     begin
		if (&tx_pcs_reset_counter && (&tx_pcs_reset_out_reg) && !all_seq_done) begin
		   if (ctrl_code==CTRL_TX_ASSERT | (ENABLE_EXTERNAL_AIB_CLOCKING && ctrl_code==CTRL_KR_ASSERT))
		     // If tx_rst is requested then just reset TX PCS and come out
		     // If KR assert request is 1 with EXT AIB clocking then just reset TX PCS and come out

		     // If tx_rst is requested then just reset TX PCS and come out
		     txreset_sm_ns = DONE_REQ;
		   else
		     txreset_sm_ns = RESET_TX_AIB;
		end
		if(!tx_aib_assert_req & !tx_pcs_assert_req) begin
		   // bail out if request no longer active
		   txreset_sm_ns = RESUME_RESET;
          end
	     end
	   RESET_TX_AIB :
	     begin
		if (&tx_aib_reset_counter && (&tx_aib_reset_out_reg) && !all_seq_done)
		  begin
		     txreset_sm_ns = DONE_REQ;
           end
		if(!tx_aib_assert_req) begin
		   // bail out if request no longer active
		   txreset_sm_ns = RESUME_RESET;
		end

	     end

	   DEASSERT_TX_AIB:
	     begin
		if (&tx_aib_reset_counter && (tx_aib_reset_out_reg == {NUM_CHANNELS{1'b0}}))
		  begin
		     txreset_sm_ns = WAIT_FOR_DLL_LOCK;
           end
          if(!tx_aib_deassert_req) begin
            // bail out if request no longer active
            txreset_sm_ns = RESUME_RESET;
		  end
	     end

	   WAIT_FOR_DLL_LOCK:
	     begin
         if (&tx_dll_lock_in_sync) begin
		  txreset_sm_ns = WAIT_FOR_TRANSFER_READY;
           end
         if(!tx_aib_deassert_req) begin
            // bail out if request no longer active
            txreset_sm_ns = RESUME_RESET;
         end
        end

	   WAIT_FOR_TRANSFER_READY:  // there is a possibility that transfer ready will not come and ack go away, so watch that
	     begin
		if (&tx_transfer_ready_in_sync)
//		  txreset_sm_ns = DEASSERT_TX_PCS_CHANNELS;
		  txreset_sm_ns = DONE_REQ;
		else
		  begin
		     if (!reset_ack && tx_aib_deassert_req)

		       begin
			  txreset_sm_ns = RESUME_RESET;
			  transfer_ready_timeout_err_comb = 1'b1;
           end
          if(!tx_aib_deassert_req) begin
            // bail out if request no longer active
            txreset_sm_ns = RESUME_RESET;
		       end
		  end
	     end // case: WAIT_FOR_TRANSFER_READY

	   DEASSERT_TX_PCS_CHANNELS:
	     begin
         if (&tx_pcs_reset_counter && (tx_pcs_reset_out_reg == {NUM_CHANNELS{1'b0}}) && !all_seq_done) begin
		  txreset_sm_ns = DONE_REQ;
         end
         if(!tx_pcs_deassert_req) begin
            // bail out if request no longer active
            txreset_sm_ns = RESUME_RESET;
         end
        end

	   DONE_REQ:
	     begin
		if (all_seq_done == 1)
		  txreset_sm_ns = SAMPLE_RESET;
		req_done_comb = 1'b1;
	     end

	   RESUME_RESET:
	     begin
		if (!all_seq_done)
		  begin
		     if (tx_aib_assert_req || tx_pcs_assert_req|| tx_aib_deassert_req || tx_pcs_deassert_req)
		       txreset_sm_ns = SAMPLE_RESET;
		  end
	     end

	     default:
	       begin
		  txreset_sm_ns  = SAMPLE_RESET;
		  transfer_ready_timeout_err_comb = 1'b0;
	       end
	 endcase // case (txreset_sm_cs)
      end // always @ (*)

    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            txreset_sm_cs <= SAMPLE_RESET;
        end else begin
            txreset_sm_cs <= txreset_sm_ns;
        end
    end

// Assert or deassert TX AIB simultaneously
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     tx_aib_reset_out_reg[NUM_RESETS-1:0] <= ({NUM_RESETS{1'b0}});
	     tx_aib_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	     tx_dll_lock_req_out_reg[NUM_RESETS-1:0] <= ({NUM_RESETS{1'b0}});
	  end
	else
	  begin
	     if (txreset_sm_ns == RESET_TX_AIB || txreset_sm_ns == DEASSERT_TX_AIB)
	       begin
		  if (!(&tx_aib_reset_counter))
		    tx_aib_reset_counter <= tx_aib_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (tx_aib_assert_req)
			 begin
			    tx_aib_reset_out_reg <= ({NUM_RESETS{1'b1}});
			    tx_dll_lock_req_out_reg <= {NUM_RESETS{1'b0}};
			 end
		       else if (tx_aib_deassert_req)
			 begin
			    tx_aib_reset_out_reg <= ({NUM_RESETS{1'b0}});
			    tx_dll_lock_req_out_reg <= {NUM_RESETS{1'b1}};
			 end
		    end // else: !if(!(&tx_aib_reset_counter))
	       end // if (txreset_sm_ns == RESET_TX_AIB || txreset_sm_ns == DEASEERT_TX_AIB)
	     else if (all_seq_done)
	       begin
		  tx_aib_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	       end
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)


   // Assert or deassert TX PCS simultaneously
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     tx_pcs_reset_out_reg[NUM_RESETS-1:0] <= ({NUM_RESETS{1'b0}});
	     tx_pcs_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (txreset_sm_ns == RESET_TX_PCS_CHANNELS || txreset_sm_ns == DEASSERT_TX_PCS_CHANNELS)
	       begin
		  if (!(&tx_pcs_reset_counter))
		    tx_pcs_reset_counter <= tx_pcs_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (tx_pcs_assert_req)
			 tx_pcs_reset_out_reg <= {NUM_RESETS{1'b1}};
		       else if (tx_pcs_deassert_req)
			 tx_pcs_reset_out_reg <= ({NUM_RESETS{1'b0}});
		    end
	       end // if (txreset_sm_ns == RESET_TX_PCS_CHANNELS || txreset_sm_ns == DEASSERT_TX_PCS_CHANNELS)
	     else if (all_seq_done)
	       begin
		  tx_pcs_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	       end
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)


   reg 	 req_done_r, tx_aib_deassert_req_done_r;
//   reg 	 tx_pcs_deassert_req_done_r;

   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  begin
	     req_done_r <= 1'b0;
	     tx_aib_deassert_req_done_r <= 1'b0;
	     tx_pcs_deassert_req_done <= 1'b0;
	  end
	else
	  begin
	     req_done_r <= req_done_comb && !all_seq_done;
	     if (tx_aib_deassert_req)
	       tx_aib_deassert_req_done_r <= req_done_comb && !all_seq_done;

	     if (tx_pcs_deassert_req && !(&tx_pcs_reset_out_reg) && req_done_comb)
	       tx_pcs_deassert_req_done <= 1'b1;
	     else if (all_seq_done)
	       begin
		  tx_pcs_deassert_req_done <= req_done_comb;
	       end
	  end // else: !if(!reset_n)
     end // always @ (posedge clk or negedge reset_n)

    assign req_done = req_done_r && !all_seq_done;
    assign tx_aib_deassert_req_done = tx_aib_deassert_req_done_r && !all_seq_done;


   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  transfer_ready_timeout_err <= 1'b0;
	else
	  transfer_ready_timeout_err <= transfer_ready_timeout_err_comb;
     end



// Following if want to assert TX AIB/PCS channels in stagger mode
/*
   // TX side reset Assignments and logic, need to assert reset for TX channels one by one
   genvar ig;
   generate
   for(ig=0;ig<NUM_CHANNELS;ig=ig+1) begin : g_tx_pcs_inst
      always @(posedge clk or negedge reset_n)
	   begin
	      if (~reset_n)
		begin
		   tx_pcs_reset_out_reg[ig] <= 1'b0;
		   tx_pcs_reset_out_reg[ig] <= 1'b0;
		   tx_pcs_reset_counter[ig] <= {RESET_COUNTER_SIZE{1'b0}};
		   tx_pcs_all_done <= 1'b0;
		end
	      else
		begin
		   if (ig==NUM_CHANNLES-1)
		     tx_pcs_all_done <= 1'b1;

		   if (txreset_sm_ns == RESET_TX_CHANNELS || txreset_sm_ns == DEASEERT_TX_CHANNELS)
		     begin
			if (!(&tx_pcs_reset_counter))
			  tx_pcs_reset_counter <= tx_pcs_reset_counter[ig] + RESET_COUNT_ADD;
			else
			  begin
			     if (assert_req)
			       tx_pcs_reset_out_reg[ig] <= 1'b1;
//			     tx_pcs_reset_counter <= {RESET_COUNTER_SIZE{1'b0}};
			     else if (deassert_req)
			       tx_pcs_reset_out_reg[ig] <= 1'b0;

			  end
		     end
		end // else: !if(~reset_n)
	   end // always @ (posedge clk or negedge reset_n)
      end // block: g_tx_pcs_inst
   endgenerate

   generate
      for(ig=0;ig<NUM_CHANNELS;ig=ig+1) begin : g_tx_aib_inst
	 always @(posedge clk or negedge reset_n)
	   begin
	      if (~reset_n)
		begin
		   tx_aib_reset_out_reg[ig] <= 1'b0;
		   tx_aib_reset_out_reg[ig] <= 1'b0;
		   tx_aib_reset_counter[ig] <= {RESET_COUNTER_SIZE{1'b0}};
		   tx_aib_all_done <= 1'b0;
		end
	      else
		begin
		   if (ig==NUM_CHANNLES-1)
		     tx_aib_all_done <= 1'b1;

		   if (txreset_sm_ns == RESET_TX_AIB || txreset_sm_ns == DEASEERT_TX_AIB)
		     begin
			if (!(&tx_aib_reset_counter[ig]))
			  tx_aib_reset_counter[ig] <= tx_aib_reset_counter[ig] + RESET_COUNT_ADD;
			else
			  begin
			     if (assert_req)
			       tx_aib_reset_out_reg[ig] <= 1'b1;
			     //			     tx_aib_reset_counter[ig] <= {RESET_COUNTER_SIZE{1'b0}};
			     else if (deassert_req)
			       tx_aib_reset_out_reg[ig] <= 1'b0;
			  end
		     end
		end // else: !if(~reset_n)
	   end // always @ (posedge clk or negedge reset_n)
      end // block: g_tx_aib_inst
   endgenerate
 */

   ////////////////////////////////////////////////////////////////////
   // Return the number of bits required to represent an integer
   // E.g. 0->1; 1->1; 2->2; 3->2 ... 31->5; 32->6
   // Function from altera_xcvr_native_phy_functions_h.sv
   function integer clogb2_s10;
      input integer input_num;
      begin
         for (clogb2_s10=0; input_num>0; clogb2_s10=clogb2_s10+1)
           input_num = input_num >> 1;
         if(clogb2_s10 == 0)
           clogb2_s10 = 1;
      end
   endfunction


endmodule // alt_ehipc3_fm_tx_ch_rst
