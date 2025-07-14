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

module alt_ehipc3_fm_rx_ch_rst
  #(
    parameter [63:0] CLK_FREQ_IN_HZ = 125000000,
    parameter [63:0] DEFAULT_RESET_SEPARATION_NS = 200,
    parameter [63:0] RESET_SEPARATION_NS = 200,
    parameter NUM_CHANNELS = 1
    )
   (
    input wire 			   clk,
    input wire 			   reset_n,
    input wire 			   reset_ack,
    input wire 			   rx_aib_assert_req,
    input wire 			   rx_pcs_assert_req,
    input wire 			   rx_aib_deassert_req,
    input wire 			   rx_pcs_deassert_req,
    input wire [NUM_CHANNELS-1:0]  rx_transfer_ready_in,
    input wire 			   all_seq_done,
    output wire [NUM_CHANNELS-1:0] rx_aib_reset_out,
    output wire [NUM_CHANNELS-1:0] rx_pcs_reset_out,
    output wire [NUM_CHANNELS-1:0] rx_dll_lock_req_out,
    output reg 			   signal_ok_out,

    //    output wire 		   reset_timeout,

    output wire 			   req_done,
    output wire 			   rx_aib_deassert_req_done,
    output wire 			   rx_pcs_deassert_req_done,
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
   localparam [RESET_COUNT_SIZE-1:0] RESET_COUNT_ADD = {{RESET_COUNT_SIZE-1{1'b0}},1'b1};

   localparam RESET_COUNT_SIZE5 = clogb2_s10(RESET_COUNT_MAX*10);
   localparam [RESET_COUNT_SIZE5-1:0] RESET_COUNT_ADD5 = {{RESET_COUNT_SIZE5-1{1'b0}},1'b1};

   wire [NUM_RESETS-1:0] 	   rx_transfer_ready_in_sync;

   // Reset state machine
   reg [3:0] 	       rxreset_sm_cs;
   reg [3:0] 	       rxreset_sm_ns;
//   reg [NUM_RESETS-1:0] 	       rx_analogreset_comb;




//   reg [NUM_RESETS-1:0] 	       clear_timeout;


   // Reset output registers (must be synchronized at destination logic)
   reg [NUM_RESETS-1:0] 	       rx_aib_reset_out_reg;
   reg [NUM_RESETS-1:0] 	       rx_pcs_reset_out_reg;

   reg [NUM_RESETS-1:0] 	       int_rx_pcs_reset_reg;
	reg [NUM_CHANNELS-1:0] 	       rx_dll_lock_req_out_reg;

   reg [NUM_RESETS-1:0] 	       rx_aib_reset_out_stage;
   reg [NUM_RESETS-1:0] 	       rx_pcs_reset_out_stage;
   reg [NUM_CHANNELS-1:0] 	       rx_dll_lock_req_out_stage;
//   reg [NUM_RESETS-1:0] 	       reset_timeout_stage;
   reg 				       signal_ok_out_reg;

   // error status
//   reg [NUM_RESETS-1:0] 	       transfer_ready_stat;
//   reg [NUM_RESETS-1:0] 	       transfer_ready_timeout;

   // Reset counters
//   wire [NUM_RESETS-1:0] 	       rx_pcs_reset_timeout;
//   wire [NUM_RESETS-1:0] 	       rx_aib_reset_timeout;
//   reg [RESET_COUNT_SIZE-1:0] 	       rx_pcs_reset_counter [NUM_RESETS-1:0];
//   reg [RESET_COUNT_SIZE-1:0] 	       rx_aib_reset_counter [NUM_RESETS-1:0];

   reg [RESET_COUNT_SIZE-1:0] 	       rx_pcs_reset_counter;
   reg [RESET_COUNT_SIZE-1:0] 	       rx_aib_reset_counter;
   reg [RESET_COUNT_SIZE5-1:0] 	       sigok_reset_counter;
   wire [RESET_COUNT_SIZE-1:0] 	       rx_aib_reset_release_count_max;
   wire [RESET_COUNT_SIZE-1:0] 	       rx_pcs_reset_release_count_max;

//   wire [RESET_COUNT_SIZE-1:0] 	       rx_aib_reset_release_count_max[NUM_RESETS-1:0];
//   wire [RESET_COUNT_SIZE-1:0] 	       rx_pcs_reset_release_count_max[NUM_RESETS-1:0];

//   assign w_rx_transfer_ready_in = rx_transfer_ready_in;
   //assign w_rx_transfer_ready_in = rx_transfer_ready_in;
   //***************************************************************************
   // Reset output
   //***************************************************************************
   assign rx_aib_reset_out = rx_aib_reset_out_stage;
   assign rx_dll_lock_req_out = rx_dll_lock_req_out_stage;
   assign rx_pcs_reset_out = rx_pcs_reset_out_stage;

//   assign reset_timeout = reset_timeout_stage;
//	reg reset_timeout_comb;

   // Add register stage to all resets
   always @(posedge clk)
     begin
	rx_aib_reset_out_stage <= rx_aib_reset_out_reg;
	rx_dll_lock_req_out_stage <= rx_dll_lock_req_out_reg;
	rx_pcs_reset_out_stage <= rx_pcs_reset_out_reg;
	signal_ok_out <= signal_ok_out_reg;
     end

   //***************************************************************************
   // Synchronizers
   //***************************************************************************
   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(NUM_RESETS),.INIT_VALUE(0))
   rx_transfer_ready_synchronizers
     (.clk	(clk),
      .reset	(~reset_n),
      .d	(rx_transfer_ready_in),
      .q	(rx_transfer_ready_in_sync));

   wire [RESET_COUNT_MAX -1 :0] rx_aib_count;
   wire [RESET_COUNT_MAX -1 :0] rx_pcs_count;

   // Reset sequence state machine
   // State machine parameters
   localparam  SAMPLE_RESET        = 4'd0;
   localparam  RESET_RX_PCS_CHANNELS  = 4'd1;
   localparam  RESET_RX_AIB       = 4'd2;
   localparam  RESET_RX_ANALOG    = 4'd3;
   localparam  DEASSERT_RX_AIB  = 4'd4;
   localparam  DEASSERT_RX_PCS_CHANNELS  = 4'd5;
   //  localparam  RESET_RX_AIB       = 3'd2;
   localparam  WAIT_FOR_TRANSFER_READY = 4'd6;
   localparam  RESUME_RESET           = 4'd7;
   localparam  SIGNAL_OK           = 4'd8;
   localparam  SIGNAL_NOT_OK      = 4'd9;
   localparam DONE_REQ = 4'd10;

   reg 				req_done_comb;
   reg 				transfer_ready_timeout_err_comb;
      always @(*) begin
	 rxreset_sm_ns = rxreset_sm_cs;
	 req_done_comb = 1'b0;
	 transfer_ready_timeout_err_comb = 1'b0;

	 case(rxreset_sm_cs)
	   SAMPLE_RESET:
	     begin
		if (reset_ack)
		  begin
		     if (rx_pcs_assert_req && !all_seq_done)
		       rxreset_sm_ns = SIGNAL_NOT_OK;
		     else if (rx_aib_assert_req && !all_seq_done)
		       rxreset_sm_ns = RESET_RX_AIB;
		     else if (rx_aib_deassert_req && !all_seq_done)
		       rxreset_sm_ns = DEASSERT_RX_AIB;
		     else if (rx_pcs_deassert_req && !all_seq_done)
		       rxreset_sm_ns = DEASSERT_RX_PCS_CHANNELS;
		  end
	     end
	   SIGNAL_NOT_OK:
	     begin
		if (&sigok_reset_counter[RESET_COUNT_SIZE-1:0] && !signal_ok_out_reg)
		  rxreset_sm_ns = RESET_RX_PCS_CHANNELS;
		if(!rx_pcs_assert_req) begin
		   // bail out if request no longer active
		   rxreset_sm_ns = RESUME_RESET;
		end
             end

	   RESET_RX_PCS_CHANNELS:
	     begin
        if (&rx_pcs_reset_counter && (&rx_pcs_reset_out_reg) && !all_seq_done) begin
		  if(rx_aib_assert_req) rxreset_sm_ns = RESET_RX_AIB;
          else rxreset_sm_ns = DONE_REQ;
        end
        if(!rx_pcs_assert_req) begin
            // bail out if request no longer active
            rxreset_sm_ns = RESUME_RESET;
	     end
        end

	   RESET_RX_AIB :
	     begin
		if (&rx_aib_reset_counter && (&rx_aib_reset_out_reg) && !all_seq_done)
		  begin
		     rxreset_sm_ns = DONE_REQ;
//		     rxreset_sm_ns = RESET_RX_ANALOG;
//		     rx_analogreset_comb = {NUM_RESETS{1'b1}};
        end
        if(!rx_aib_assert_req) begin
            // bail out if request no longer active
            rxreset_sm_ns = RESUME_RESET;
		  end

	     end
	   DEASSERT_RX_AIB:
        begin
	     if (&rx_aib_reset_counter && (rx_aib_reset_out_reg == {NUM_CHANNELS{1'b0}}))
	       begin
		  rxreset_sm_ns = WAIT_FOR_TRANSFER_READY;
        end
        if(!rx_aib_deassert_req) begin
            // bail out if request no longer active
            rxreset_sm_ns = RESUME_RESET;
	       end
        end

	   WAIT_FOR_TRANSFER_READY:  // there is a possibility that transfer ready will not come and ack go away, so watch that
	     begin
		if (&rx_transfer_ready_in_sync && !all_seq_done)
		  rxreset_sm_ns = DONE_REQ;
//		  rxreset_sm_ns = SAMPLE_RESET;
		else
		  begin
		     if (!reset_ack && rx_aib_deassert_req)
		       begin
			  rxreset_sm_ns = RESUME_RESET;
			  transfer_ready_timeout_err_comb = 1'b1;
           end
           if(!rx_aib_deassert_req) begin
            // bail out if request no longer active
            rxreset_sm_ns = RESUME_RESET;
		       end
		  end
	     end // case: WAIT_FOR_TRANSFER_READY


	   DEASSERT_RX_PCS_CHANNELS:
	     begin
          if (&rx_pcs_reset_counter && (rx_pcs_reset_out_reg == {NUM_CHANNELS{1'b0}})) begin
		  rxreset_sm_ns = SIGNAL_OK;
//		req_done_comb = 1'b1;
           end
           if(!rx_pcs_deassert_req) begin
            // bail out if request no longer active
            rxreset_sm_ns = RESUME_RESET;
          end
	     end

	   SIGNAL_OK:
	     begin
		if (&sigok_reset_counter && signal_ok_out_reg && !all_seq_done)
		  rxreset_sm_ns = DONE_REQ;
		if(!rx_pcs_deassert_req) begin
		   // bail out if request no longer active
		   rxreset_sm_ns = RESUME_RESET;
		end
	     end


	   DONE_REQ:
	     begin
		if (all_seq_done == 1)
		  begin
		     rxreset_sm_ns = SAMPLE_RESET;
		  end
		else if (rx_pcs_deassert_req)
//		  rxreset_sm_ns = DEASSERT_RX_PCS_CHANNELS;
		  rxreset_sm_ns = SAMPLE_RESET;
		req_done_comb = 1'b1;
	     end

	   RESUME_RESET:
	     begin
		if (!all_seq_done)
		  begin
		     if (rx_pcs_assert_req || rx_aib_assert_req || rx_pcs_deassert_req || rx_aib_deassert_req)
		       rxreset_sm_ns = SAMPLE_RESET;
		  end
	     end


	     default:
	       begin
		  rxreset_sm_ns  = SAMPLE_RESET;
		  transfer_ready_timeout_err_comb = 1'b0;
//		  clear_timeout = 1'b0;
	       end
	 endcase // case (rxreset_sm_cs)
      end // always @ (*)


    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            rxreset_sm_cs <= SAMPLE_RESET;
        end else begin
            rxreset_sm_cs <= rxreset_sm_ns;
        end
    end

   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  transfer_ready_timeout_err <= 1'b0;
	else
	  transfer_ready_timeout_err <= transfer_ready_timeout_err_comb;
     end


// Assert or deassert RX AIB simultaneously
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     rx_aib_reset_out_reg[NUM_RESETS-1:0] <= ({NUM_RESETS{1'b0}});
	     rx_aib_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	     rx_dll_lock_req_out_reg[NUM_RESETS-1:0] <= ({NUM_RESETS{1'b0}});
	  end
	else
	  begin
	     if (rxreset_sm_ns == RESET_RX_AIB || rxreset_sm_ns == DEASSERT_RX_AIB)
	       begin
		  if (!(&rx_aib_reset_counter))
		    rx_aib_reset_counter <= rx_aib_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (rx_aib_assert_req)
			 begin
			    rx_aib_reset_out_reg <= ({NUM_RESETS{1'b1}});
			    rx_dll_lock_req_out_reg <= {NUM_RESETS{1'b0}};
			 end
		       else if (rx_aib_deassert_req)
			 begin
			    rx_aib_reset_out_reg <= ({NUM_RESETS{1'b0}});
			    rx_dll_lock_req_out_reg <= {NUM_RESETS{1'b1}};
			 end
		    end // else: !if(!(&rx_aib_reset_counter))
	       end // if (rxreset_sm_ns == RESET_RX_AIB || rxreset_sm_ns == DEASEERT_RX_AIB)
	     else if (all_seq_done)
	       begin
		  rx_aib_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	       end
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)


   // Assert or deassert RX PCS simultaneously
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     rx_pcs_reset_out_reg[NUM_RESETS-1:0] <= ({NUM_RESETS{1'b0}});
	     rx_pcs_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (rxreset_sm_ns == RESET_RX_PCS_CHANNELS || rxreset_sm_ns == DEASSERT_RX_PCS_CHANNELS)
	       begin
		  if (!(&rx_pcs_reset_counter))
		    rx_pcs_reset_counter <= rx_pcs_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (rx_pcs_assert_req)
			 rx_pcs_reset_out_reg <= {NUM_RESETS{1'b1}};
		       else if (rx_pcs_deassert_req)
			 rx_pcs_reset_out_reg <= ({NUM_RESETS{1'b0}});
		    end
	       end // if (rxreset_sm_ns == RESET_RX_PCS_CHANNELS || rxreset_sm_ns == DEASSERT_RX_PCS_CHANNELS)
	     else if (all_seq_done)
	       begin
		  rx_pcs_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	       end

	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)

   // Control EHIP Signal_OK based on RX PCS status
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     signal_ok_out_reg <= 1'b0;
	     sigok_reset_counter <= {RESET_COUNT_SIZE5{1'b0}};
	  end
	else
	  begin
	     if (rxreset_sm_ns == SIGNAL_OK || rxreset_sm_ns == SIGNAL_NOT_OK)
	       begin
		  if (!(&sigok_reset_counter) && !(rx_pcs_assert_req && (&sigok_reset_counter[RESET_COUNT_SIZE-1:0])))
		    sigok_reset_counter <= sigok_reset_counter + RESET_COUNT_ADD5;
		  else
		    begin
		       if (rx_pcs_assert_req)
                   signal_ok_out_reg <= 1'b0;
		       else if (rx_pcs_deassert_req)
                   signal_ok_out_reg <= 1'b1;
		    end
	       end // if (rxreset_sm_ns == RESET_RX_PCS_CHANNELS || rxreset_sm_ns == DEASSERT_RX_PCS_CHANNELS)
	     else if (all_seq_done)
	       begin
		  sigok_reset_counter <= {RESET_COUNT_SIZE5{1'b0}};
	       end

	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)

     reg req_done_r, rx_aib_deassert_req_done_r;
    reg rx_pcs_deassert_req_done_r;

   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  begin
	     req_done_r <= 1'b0;
	     rx_aib_deassert_req_done_r <= 1'b0;
	     rx_pcs_deassert_req_done_r <= 1'b0;
	  end
	else
	  begin
	     req_done_r <= req_done_comb && !all_seq_done;
	     if (rx_aib_deassert_req)
	       rx_aib_deassert_req_done_r <= req_done_comb;
	     if (rx_pcs_deassert_req && !(&rx_pcs_reset_out_reg))
	       rx_pcs_deassert_req_done_r <= req_done_comb;

             if (all_seq_done) begin
	       rx_aib_deassert_req_done_r <= 1'b0;
	       rx_pcs_deassert_req_done_r <= 1'b0;
             end
       end


     end

    assign req_done = req_done_r && !all_seq_done;
    assign rx_aib_deassert_req_done = rx_aib_deassert_req_done_r && !all_seq_done;
    assign rx_pcs_deassert_req_done = rx_pcs_deassert_req_done_r && !all_seq_done;


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


endmodule // alt_ehipc3_fm_rx_ch_rst
