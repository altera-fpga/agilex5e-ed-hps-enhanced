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

module alt_ehipc3_fm_ehip_rst
  #(
    parameter [63:0] CLK_FREQ_IN_HZ = 125000000,
    parameter [63:0] DEFAULT_RESET_SEPARATION_NS = 200,
    parameter [63:0] RESET_SEPARATION_NS = 200,
    parameter NUM_CHANNELS = 1,
    parameter ENABLE_RSFEC = 0
    )
   (
    input wire 	clk,
    input wire 	reset_n,
    input wire 	reset_ack,
    input wire 	csr_assert_req,
    input wire 	csr_deassert_req,
    input wire 	tx_assert_req,
    input wire 	tx_deassert_req,
    input wire 	rx_assert_req,
    input wire 	rx_deassert_req,
    input wire  kr_assert_req,
    input wire 	all_seq_done,

//    input wire [3:0] ctrl_code,
    input wire 	ehip_reset_ack_in,
    input wire 	ehip_tx_reset_ack_in,
    input wire 	ehip_rx_reset_ack_in,
    input wire 	ehip_ready_in,
    input wire 	rx_pcs_fully_aligned_in,

    output wire ehip_reset_out,
    output wire ehip_tx_reset_out,
    output wire ehip_rx_reset_out,
    output wire rsfec_reset_out,
    output wire rsfec_tx_reset_out,
    output wire rsfec_rx_reset_out,

    output wire ehip_pld_ready_out,

    output wire req_done,
    output reg 	ehip_ready_timeout_err,
    output reg 	ehip_rst_ack_timeout_err,
    output reg 	ehip_txrst_ack_timeout_err,
    output reg 	ehip_rxrst_ack_timeout_err,
    output reg 	signal_ok_out
   );


   localparam NUM_RESETS = 1;

   // These parameters calculate the counter width and count for reset separation
   // Do I need this??
   localparam ADDED_RESET_SEPARATION_NS = (RESET_SEPARATION_NS > DEFAULT_RESET_SEPARATION_NS) ? (RESET_SEPARATION_NS - DEFAULT_RESET_SEPARATION_NS) : 0;

   localparam [63:0] ADDED_RESET_COUNT = (CLK_FREQ_IN_HZ * ADDED_RESET_SEPARATION_NS) / 1000000000;
   localparam [63:0] ADDED_RESET_ROUNT_COUNT = (((ADDED_RESET_COUNT * 1000000000) / CLK_FREQ_IN_HZ) < ADDED_RESET_SEPARATION_NS)
     ? (ADDED_RESET_COUNT + 1) : ADDED_RESET_COUNT;
   localparam ADDED_RESET_COUNT_MAX = (ADDED_RESET_ROUNT_COUNT > 0) ? ADDED_RESET_ROUNT_COUNT - 1 : 0;
   //

   localparam [63:0] RESET_COUNT = (CLK_FREQ_IN_HZ * RESET_SEPARATION_NS) / 1000000000;
   localparam [63:0] RESET_ROUNT_COUNT = (((RESET_COUNT * 1000000000) / CLK_FREQ_IN_HZ) < RESET_SEPARATION_NS)
     ? (RESET_COUNT + 1) : RESET_COUNT;
   localparam RESET_COUNT_MAX = (RESET_ROUNT_COUNT > 0) ? RESET_ROUNT_COUNT - 1 : 0;

   localparam RESET_COUNT_SIZE = clogb2_s10(RESET_COUNT_MAX);
   localparam [RESET_COUNT_SIZE-1:0] ADDED_RESET_COUNT_ADD = {{RESET_COUNT_SIZE-1{1'b0}},1'b1};
   localparam [RESET_COUNT_SIZE-1:0] RESET_COUNT_ADD = {{RESET_COUNT_SIZE-1{1'b0}},1'b1};


   // Reset state machine
   reg [4:0] 	       ehip_reset_sm_cs;
   reg [4:0] 	       ehip_reset_sm_ns;

   // Reset output registers (must be synchronized at destination logic)
   reg ehip_reset_out_reg;
   reg ehip_tx_reset_out_reg;
   reg ehip_rx_reset_out_reg;
   reg signal_ok_out_reg;

   reg ehip_reset_out_stage;
   reg ehip_tx_reset_out_stage;
   reg ehip_rx_reset_out_stage;

   reg rsfec_reset_out_reg;
   reg rsfec_tx_reset_out_reg;
   reg rsfec_rx_reset_out_reg;

   reg rsfec_reset_out_stage;
   reg rsfec_tx_reset_out_stage;
   reg rsfec_rx_reset_out_stage;

   reg ehip_ready_timeout;


   // Reset counters
   reg [RESET_COUNT_SIZE-1:0] ehip_reset_counter;
   reg [RESET_COUNT_SIZE-1:0] ehip_tx_reset_counter;
   reg [RESET_COUNT_SIZE-1:0] ehip_rx_reset_counter;
   reg [RESET_COUNT_SIZE-1:0] ehip_pld_ready_counter;
   reg [RESET_COUNT_SIZE-1:0] rsfec_reset_counter;
   reg [RESET_COUNT_SIZE-1:0] rsfec_tx_reset_counter;
   reg [RESET_COUNT_SIZE-1:0] rsfec_rx_reset_counter;
   reg [RESET_COUNT_SIZE-1:0] sigok_reset_counter;

//   wire [RESET_COUNT_SIZE-1:0] ehip_rx_reset_release_count_max;
//   wire [RESET_COUNT_SIZE-1:0] tx_pcs_reset_release_count_max;

   //   wire [RESET_COUNT_SIZE-1:0] 	       tx_aib_reset_release_count_max[NUM_RESETS-1:0];
   //   wire [RESET_COUNT_SIZE-1:0] 	       tx_pcs_reset_release_count_max[NUM_RESETS-1:0];
   reg 			      ehip_pld_ready_out_reg;
   reg 			      ehip_pld_ready_out_stage;

   // Temporary wires
   assign w_ehip_ready_in = ehip_ready_in;
   //***************************************************************************
   // Reset output
   //***************************************************************************
   assign ehip_reset_out = ehip_reset_out_stage;
   assign ehip_tx_reset_out = ehip_tx_reset_out_stage;
   assign ehip_rx_reset_out = ehip_rx_reset_out_stage;
   assign ehip_pld_ready_out = ehip_pld_ready_out_stage;

   assign rsfec_reset_out = rsfec_reset_out_stage;
   assign rsfec_tx_reset_out = rsfec_tx_reset_out_stage;
   assign rsfec_rx_reset_out = rsfec_rx_reset_out_stage;

   // Add register stage to all resets
   always @(posedge clk)
     begin
	ehip_reset_out_stage <= ehip_reset_out_reg;
	ehip_tx_reset_out_stage <= ehip_tx_reset_out_reg;
	ehip_rx_reset_out_stage <= ehip_rx_reset_out_reg;
	rsfec_reset_out_stage <= rsfec_reset_out_reg;
	rsfec_tx_reset_out_stage <= rsfec_tx_reset_out_reg;
	rsfec_rx_reset_out_stage <= rsfec_rx_reset_out_reg;
	ehip_pld_ready_out_stage <= ehip_pld_ready_out_reg;
	signal_ok_out <= signal_ok_out_reg;
     end

   //***************************************************************************
   // Synchronizers
   //***************************************************************************
   wire  rx_pcs_fully_aligned_in_sync;
   wire  ehip_ready_in_sync;

   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(NUM_RESETS),.INIT_VALUE(0))
   tx_transfer_ready_synchronizers
     (.clk	(clk),
      .reset	(~reset_n),
      .d	(w_ehip_ready_in),
      .q	(ehip_ready_in_sync));

   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(NUM_RESETS),.INIT_VALUE(0))
   rxpfa_synchronizers
     (.clk	(clk),
      .reset	(~reset_n),
      .d	(rx_pcs_fully_aligned_in),
      .q	(rx_pcs_fully_aligned_in_sync));


   wire [RESET_COUNT_MAX -1 :0] ehip_tx_count;
   wire [RESET_COUNT_MAX -1 :0] ehip_rx_count;

   // Reset sequence state machine
   // State machine parameters
   localparam  SAMPLE_RESET     = 5'd0;
   localparam  RESET_EHIP_RX    = 5'd1;
   localparam  RESET_EHIP_TX       = 5'd2;
   localparam  RESET_EHIP  = 5'd3;
   localparam  RESET_RSFEC_RX    = 5'd4;
   localparam  RESET_RSFEC_TX       = 5'd5;
   localparam  RESET_RSFEC  = 5'd6;
   localparam  RESET_EHIP_PLD_READY = 5'd7;
   localparam  ASSERT_EHIP_PLD_READY = 5'd8;
   localparam  DEASSERT_EHIP  = 5'd9;
   localparam  WAIT_FOR_EHIP_READY = 5'd10;
   localparam  DEASSERT_EHIP_TX  = 5'd11;
   localparam  DEASSERT_EHIP_RX  = 5'd12;
   localparam  DEASSERT_RSFEC  = 5'd13;
   localparam  DEASSERT_RSFEC_TX  = 5'd14;
   localparam  DEASSERT_RSFEC_RX  = 5'd15;
   localparam  DONE_REQ  = 5'd16;
   localparam  RESUME_RESET           = 5'd17;
   localparam  WAIT_FOR_RXPFA_0 = 5'd18;
   localparam SIGNAL_NOT_OK= 5'd19;
   localparam SIGNAL_OK= 5'd20;


   reg 				req_done_comb;
   reg 				ehip_ready_timeout_err_comb;
   reg 				ehip_rst_ack_timeout_err_comb;
   reg 				ehip_txrst_ack_timeout_err_comb;
   reg 				ehip_rxrst_ack_timeout_err_comb;

   wire ehip_reset_ack_in_sync;
   wire ehip_tx_reset_ack_in_sync;
   wire ehip_rx_reset_ack_in_sync;


   //***************************************************************************
   // Synchronizers
   //***************************************************************************
   alt_xcvr_resync_std #(.SYNC_CHAIN_LENGTH(3), .WIDTH(3),.INIT_VALUE(0))
   ehip_ack_synchronizers
     (.clk	(clk),
      .reset	(~reset_n),
      .d	({ehip_reset_ack_in, ehip_tx_reset_ack_in, ehip_rx_reset_ack_in}),
      .q	({ehip_reset_ack_in_sync, ehip_tx_reset_ack_in_sync, ehip_rx_reset_ack_in_sync}));



   //reg reset_timeout_comb, reset_timeout_stage;
   // tx_rst assertion sequence with RSFEC = RSFEC TX => EHIP TX
      always @(*) begin
	 ehip_reset_sm_ns = ehip_reset_sm_cs;
	 req_done_comb = 1'b0;
	 ehip_ready_timeout_err_comb = 1'b0;
	 ehip_rst_ack_timeout_err_comb = 1'b0;
	 ehip_txrst_ack_timeout_err_comb = 1'b0;
	 ehip_rxrst_ack_timeout_err_comb = 1'b0;

	 case(ehip_reset_sm_cs)
	   SAMPLE_RESET:
	     begin
		if (reset_ack)
		  begin
		     if (csr_assert_req && !all_seq_done)
		       ehip_reset_sm_ns = SIGNAL_NOT_OK;
		     else if (tx_assert_req && !all_seq_done)
		       begin
			  if (ENABLE_RSFEC)
			    ehip_reset_sm_ns = RESET_RSFEC_TX;
			  else
			    ehip_reset_sm_ns = RESET_EHIP_TX;
		       end
		     else if (rx_assert_req && !all_seq_done)
		       ehip_reset_sm_ns = SIGNAL_NOT_OK;

		     else if (csr_deassert_req && !all_seq_done)
			  ehip_reset_sm_ns = ASSERT_EHIP_PLD_READY;
		     else if (rx_deassert_req && !all_seq_done)
		       begin
			  if (ENABLE_RSFEC)
			    ehip_reset_sm_ns = DEASSERT_RSFEC_RX;
			  else
			    ehip_reset_sm_ns = DEASSERT_EHIP_RX;
		       end
		     else if (tx_deassert_req && !all_seq_done)
		       ehip_reset_sm_ns = DEASSERT_EHIP_TX;
		  end
	     end // case: SAMPLE_RESET

	   SIGNAL_NOT_OK:
	     begin
		if (&sigok_reset_counter && !signal_ok_out_reg)
		  ehip_reset_sm_ns = RESET_EHIP_RX;
		if(!csr_assert_req && !rx_assert_req) begin
		  // bail out if request no longer active
		  ehip_reset_sm_ns = RESUME_RESET;
		  end
	    end


	   RESET_EHIP_RX:  //Sangeeta - add ack timeout code
	     begin
		if (&ehip_rx_reset_counter && ehip_rx_reset_out_reg)
		  begin
		     if (ehip_rx_reset_ack_in_sync)
		       begin
			  if (csr_assert_req)
			    begin
			       if (ENABLE_RSFEC)
				 ehip_reset_sm_ns = RESET_RSFEC_RX;
			       else
				 ehip_reset_sm_ns = RESET_EHIP_TX;
			    end
			  else
			    begin
			       if (ENABLE_RSFEC)
				 ehip_reset_sm_ns = RESET_RSFEC_RX;
			       else
				 ehip_reset_sm_ns = WAIT_FOR_RXPFA_0;
			    end // else: !assert _req)
		       end
		     else
		       begin
			  if (!reset_ack) // If Main ack goes away and ethernet ACK won't come then give error and come out
			    begin
			       ehip_rxrst_ack_timeout_err_comb = 1'b1;
			       ehip_reset_sm_ns = RESUME_RESET;
			    end
		       end // else: !if(ehip_rx_reset_ack_in)
          end // if (&ehip_rx_reset_counter && ehip_rx_reset_out_reg)
          if(!csr_assert_req && !rx_assert_req) begin
              // bail out if request no longer active
              ehip_reset_sm_ns = RESUME_RESET;
		  end
	     end // case: RESET_EHIP_RX


	   RESET_RSFEC_RX:  //Sangeeta - add ack timeout code
	     begin
		if (&rsfec_rx_reset_counter && rsfec_rx_reset_out_reg && !all_seq_done)
		  begin
		     if (csr_assert_req)
		       ehip_reset_sm_ns = RESET_RSFEC_TX;
		     else
		       ehip_reset_sm_ns = WAIT_FOR_RXPFA_0;
		  end
		if(!csr_assert_req && !rx_assert_req) begin
              // bail out if request no longer active
		   ehip_reset_sm_ns = RESUME_RESET;
		end
	     end // case: RESET_RSFEC_RX

	   // wait till rx pcs fully aligned goes low
	   WAIT_FOR_RXPFA_0 :
	     begin
		if (!rx_pcs_fully_aligned_in_sync && !all_seq_done)
		  ehip_reset_sm_ns = DONE_REQ;
          if(!csr_assert_req && !rx_assert_req) begin
              // bail out if request no longer active
              ehip_reset_sm_ns = RESUME_RESET;
		  end
	     end


	   RESET_RSFEC_TX :  //Sangeeta - add ack timeout code
	     begin
		if (&rsfec_tx_reset_counter && rsfec_tx_reset_out_reg)
		  begin
		     ehip_reset_sm_ns = RESET_EHIP_TX;
		  end

		if(!csr_assert_req && !tx_assert_req) begin
		   // bail out if request no longer active
		   ehip_reset_sm_ns = RESUME_RESET;
		end
	     end // case: RESET_RSFEC_TX



	   RESET_EHIP_TX :  //Sangeeta - add ack timeout code
	     begin
		if (&ehip_tx_reset_counter && ehip_tx_reset_out_reg && !all_seq_done)
		  begin
		     if (ehip_tx_reset_ack_in_sync)
		       begin
			  if (csr_assert_req)
			    begin
			       if (ENABLE_RSFEC)
				 ehip_reset_sm_ns = RESET_RSFEC;
			       else
				 ehip_reset_sm_ns = RESET_EHIP;
			    end
//Need to add following to take care of kr_rst_req, need to do it this way as in CTRL_KR_ASSERT ehip_tx_assert and ehip_rx_assert are updated/changed at the same time
			  else if (kr_assert_req && rx_assert_req)
				 ehip_reset_sm_ns = SIGNAL_NOT_OK;
			  else
			    ehip_reset_sm_ns = DONE_REQ;
		       end
		     else
		       begin
			  if (!reset_ack) // If Main ack goes away and ethernet ACK won't come then give error and come out
			    begin
			       ehip_txrst_ack_timeout_err_comb = 1'b1;
			       ehip_reset_sm_ns = RESUME_RESET;
			    end
		       end // else: !if(ehip_tx_reset_ack_in)
          end // if (&ehip_tx_reset_counter && ehip_tx_reset_out_reg)
          if(!csr_assert_req && !tx_assert_req) begin
              // bail out if request no longer active
              ehip_reset_sm_ns = RESUME_RESET;
		  end
	     end // case: RESET_EHIP_TX


	   RESET_RSFEC:   //add ack timeout code after o_rsfec_rst_n port is exposed
	     begin
		if (&rsfec_reset_counter && rsfec_reset_out_reg)
		  ehip_reset_sm_ns = RESET_EHIP;

		if(!csr_assert_req) begin
		   // bail out if request no longer active
		   ehip_reset_sm_ns = RESUME_RESET;
		end // if (&ehip_reset_counter && ehip_reset_out_reg)
	     end // case: RESET_EHIP


	   RESET_EHIP:   //Sangeeta - add ack timeout code
	     begin
		if (&ehip_reset_counter && ehip_reset_out_reg)
		  begin
		     if (ehip_reset_ack_in_sync)
		       ehip_reset_sm_ns = RESET_EHIP_PLD_READY;
		     else
		       begin
			  if (!reset_ack) // If Main ack goes away and ethernet ACK won't come then give error and come out
			    begin
			       ehip_rst_ack_timeout_err_comb = 1'b1;
			       ehip_reset_sm_ns = RESUME_RESET;
			    end
		       end
          end
          if(!csr_assert_req) begin
              // bail out if request no longer active
              ehip_reset_sm_ns = RESUME_RESET;
		  end // if (&ehip_reset_counter && ehip_reset_out_reg)
		// Also reset ehip_pld_ready as this is the last stage in EHIP assertion
		//		     ehip_pld_ready_comb = 1'b0;
	     end // case: RESET_EHIP


	   RESET_EHIP_PLD_READY:
	     begin
        if (&ehip_pld_ready_counter && !ehip_pld_ready_out_reg && !all_seq_done) begin
		  ehip_reset_sm_ns = DONE_REQ;
        end
        if(!csr_assert_req) begin
            // bail out if request no longer active
            ehip_reset_sm_ns = RESUME_RESET;
	     end
        end


	   ASSERT_EHIP_PLD_READY:
	     begin
        if (&ehip_pld_ready_counter && ehip_pld_ready_out_reg) begin
		  ehip_reset_sm_ns = DEASSERT_EHIP;
        end
        if(!csr_deassert_req) begin
            // bail out if request no longer active
            ehip_reset_sm_ns = RESUME_RESET;
	     end
        end

	   DEASSERT_EHIP:    //Sangeeta - add ack timeout code
	     begin
		if (&ehip_reset_counter && !ehip_reset_out_reg && !all_seq_done)
		  begin
		     if (!ehip_reset_ack_in_sync)
		       begin
			  if (ENABLE_RSFEC)
			    ehip_reset_sm_ns = DEASSERT_RSFEC; // TX/RX deassertions will happen on a different request
			  else
			    ehip_reset_sm_ns = DONE_REQ; // TX/RX deassertions will happen on a different request
		       end
		     else
		       begin
			  if (!reset_ack) // If Main ack goes away and ethernet ACK won't come then give error and come out
			    begin
			       ehip_txrst_ack_timeout_err_comb = 1'b1;
			       ehip_reset_sm_ns = RESUME_RESET;
			    end
		       end
          end  // if (&ehip_reset_counter && !ehip_reset_out_reg)
          if(!csr_deassert_req) begin
            // bail out if request no longer active
            ehip_reset_sm_ns = RESUME_RESET;
		  end
	     end // case: DEASSERT_EHIP

	   DEASSERT_RSFEC:
	     begin
		if (&rsfec_reset_counter && !rsfec_reset_out_reg && !all_seq_done)
		  ehip_reset_sm_ns = DONE_REQ; // TX/RX deassertions will happen on a different request

		if(!csr_deassert_req) begin
		   // bail out if request no longer active
		   ehip_reset_sm_ns = RESUME_RESET;
		end
	     end // case: DEASSERT_RSFEC

	   DEASSERT_EHIP_TX:
	     begin
		if (&ehip_tx_reset_counter && !ehip_tx_reset_out_reg)
		  begin
		     if (!ehip_tx_reset_ack_in_sync)
		       begin
			  if (ENABLE_RSFEC)
			    ehip_reset_sm_ns = DEASSERT_RSFEC_TX;
			  else
			    ehip_reset_sm_ns = WAIT_FOR_EHIP_READY; // For some reason the HIP doesn't respond until TX deasserted
		       end
		     else
		       begin
			  if (!reset_ack) // If Main ack goes away and ethernet ACK won't come then give error and come out
			    begin
			       ehip_txrst_ack_timeout_err_comb = 1'b1;
			       ehip_reset_sm_ns = RESUME_RESET;
			    end
		       end // else: !if(!ehip_tx_reset_ack_in)
          end // if (&ehip_tx_reset_counter && !ehip_tx_reset_out_reg)
          if(!tx_deassert_req) begin
            // bail out if request no longer active
            ehip_reset_sm_ns = RESUME_RESET;
		  end
	     end // case: DEASSERT_EHIP_TX

	   DEASSERT_RSFEC_TX:
	     begin
		if (&rsfec_tx_reset_counter && !rsfec_tx_reset_out_reg)
		  begin
		     ehip_reset_sm_ns = WAIT_FOR_EHIP_READY; // For some reason the HIP doesn't respond until TX deasserted
		  end

		if(!tx_deassert_req) begin
		   // bail out if request no longer active
		   ehip_reset_sm_ns = RESUME_RESET;
		end
	     end // case: DEASSERT_RSFEC_TX

	   WAIT_FOR_EHIP_READY:  // there is a possibility that ehip_ready will not come and ack go away, so watch that
	     begin
		if (ehip_ready_in_sync && !all_seq_done)
		  begin
		     ehip_reset_sm_ns = DONE_REQ;
		  end

		else if (!reset_ack)  //there is a possibility that ehip_ready will not come and ack go away, so give error, drop the request and start again
		  begin
		     ehip_ready_timeout_err_comb = 1'b1;
		     ehip_reset_sm_ns = RESUME_RESET;
		  end

          if(!tx_deassert_req) begin
            // bail out if request no longer active
            ehip_reset_sm_ns = RESUME_RESET;
          end
	     end // case: WAIT_FOR_EHIP_READY

	   DEASSERT_RSFEC_RX:  //Sangeeta - add ack timeout code
	     begin

		if (&rsfec_rx_reset_counter && !rsfec_rx_reset_out_reg)
		  ehip_reset_sm_ns = DEASSERT_EHIP_RX;

		if(!rx_deassert_req) begin
		   // bail out if request no longer active
		   ehip_reset_sm_ns = RESUME_RESET;
		end
	     end // case: DEASSERT_EHIP_RX


	   DEASSERT_EHIP_RX:  //Sangeeta - add ack timeout code
	     begin
		if (&ehip_rx_reset_counter && !ehip_rx_reset_out_reg)
		  begin
		     if (!ehip_rx_reset_ack_in_sync)
		       ehip_reset_sm_ns = SIGNAL_OK;
		     else
		       begin
			  if (!reset_ack) // If Main ack goes away and ethernet ACK won't come then give error and come out
			    begin
			       ehip_rxrst_ack_timeout_err_comb = 1'b1;
			       ehip_reset_sm_ns = RESUME_RESET;
			    end
		       end // else: !if(!ehip_rx_reset_ack_in)
          end // if (&ehip_rx_reset_counter && !ehip_rx_reset_out_reg)
          if(!rx_deassert_req) begin
            // bail out if request no longer active
            ehip_reset_sm_ns = RESUME_RESET;
		  end
	     end // case: DEASSERT_EHIP_RX

	   SIGNAL_OK:
	     begin
		if (&sigok_reset_counter && signal_ok_out_reg && !all_seq_done)
		  ehip_reset_sm_ns = DONE_REQ;
          if(!rx_deassert_req) begin
		  // bail out if request no longer active
		  ehip_reset_sm_ns = RESUME_RESET;
		  end
	     end


	   DONE_REQ:
	     begin
		if (all_seq_done)
		  ehip_reset_sm_ns = RESUME_RESET;
		req_done_comb = 1'b1;

	     end

	   RESUME_RESET:
	     begin
		if (!all_seq_done)
		  begin
		     if (csr_assert_req || tx_assert_req || rx_assert_req || csr_deassert_req || tx_deassert_req || rx_deassert_req)
		       ehip_reset_sm_ns = SAMPLE_RESET;
		  end
	     end

	     default:
	       begin
		  ehip_reset_sm_ns  = SAMPLE_RESET;
		  ehip_ready_timeout_err_comb = 1'b0;
		  //clear_timeout = 1'b0;
	       end
	 endcase // case (ehip_reset_sm_cs)
      end // always @ (*)

// Assert or deassert EHIP_TX_RST
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            ehip_reset_sm_cs <= 5'd0;
        end else begin
            ehip_reset_sm_cs <= ehip_reset_sm_ns;
        end
     end


// Assert or deassert EHIP_TX_RST
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     ehip_tx_reset_out_reg <= 1'b0;
	     ehip_tx_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (ehip_reset_sm_ns == RESET_EHIP_TX || ehip_reset_sm_ns == DEASSERT_EHIP_TX)
	       begin
		  if (!(&ehip_tx_reset_counter))
		    ehip_tx_reset_counter <= ehip_tx_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (csr_assert_req || tx_assert_req)
			 ehip_tx_reset_out_reg <= 1'b1;
		       else if (tx_deassert_req)
			 ehip_tx_reset_out_reg <= 1'b0;
		    end
	       end // if (ehip_reset_sm_ns == RESET_EHIP_TX || ehip_reset_sm_ns == DEASSERT_EHIP_TX)
	     else
	       ehip_tx_reset_counter <= ({RESET_COUNT_SIZE{1'b0}});
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)

   // Assert or deassert EHIP_RX_RESET
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     ehip_rx_reset_out_reg <= 1'b0;
	     ehip_rx_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (ehip_reset_sm_ns == RESET_EHIP_RX || ehip_reset_sm_ns == DEASSERT_EHIP_RX)
	       begin
		  if (!(&ehip_rx_reset_counter))
		    ehip_rx_reset_counter <= ehip_rx_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (csr_assert_req || rx_assert_req)
			 ehip_rx_reset_out_reg <= 1'b1;
		       else if (rx_deassert_req)
			 ehip_rx_reset_out_reg <= 1'b0;
		    end
	       end // if (ehip_reset_sm_ns == RESET_EHIP_RX || ehip_reset_sm_ns == DEASSERT_EHIP_RX)
	     else
	       ehip_rx_reset_counter <= ({RESET_COUNT_SIZE{1'b0}});
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)


   // Assert or deassert EHIP_RESET
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     ehip_reset_out_reg <= 1'b0;
	     ehip_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (ehip_reset_sm_ns == RESET_EHIP || ehip_reset_sm_ns == DEASSERT_EHIP)
	       begin
		  if (!(&ehip_reset_counter))
		    ehip_reset_counter <= ehip_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (csr_assert_req)
			 ehip_reset_out_reg <= 1'b1;
		       else if (csr_deassert_req)
			 ehip_reset_out_reg <= 1'b0;
		    end
	       end // if (ehip_reset_sm_ns == RESET_EHIP || ehip_reset_sm_ns == DEASSERT_EHIP)
	     else
	       ehip_reset_counter <= ({RESET_COUNT_SIZE{1'b0}});
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)


// RSFEC
// Assert or deassert RSFEC_TX_RST
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     rsfec_tx_reset_out_reg <= 1'b0;
	     rsfec_tx_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (ehip_reset_sm_ns == RESET_RSFEC_TX || ehip_reset_sm_ns == DEASSERT_RSFEC_TX)
	       begin
		  if (!(&rsfec_tx_reset_counter))
		    rsfec_tx_reset_counter <= rsfec_tx_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (csr_assert_req || tx_assert_req)
			 rsfec_tx_reset_out_reg <= 1'b1;
		       else if (tx_deassert_req)
			 rsfec_tx_reset_out_reg <= 1'b0;
		    end
	       end // if (ehip_reset_sm_ns == RESET_EHIP_TX || ehip_reset_sm_ns == DEASSERT_EHIP_TX)
	     else
	       rsfec_tx_reset_counter <= ({RESET_COUNT_SIZE{1'b0}});
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)

   // Assert or deassert RSFEC_RX_RESET
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     rsfec_rx_reset_out_reg <= 1'b0;
	     rsfec_rx_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (ehip_reset_sm_ns == RESET_RSFEC_RX || ehip_reset_sm_ns == DEASSERT_RSFEC_RX)
	       begin
		  if (!(&rsfec_rx_reset_counter))
		    rsfec_rx_reset_counter <= rsfec_rx_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (csr_assert_req || rx_assert_req)
			 rsfec_rx_reset_out_reg <= 1'b1;
		       else if (rx_deassert_req)
			 rsfec_rx_reset_out_reg <= 1'b0;
		    end
	       end // if (ehip_reset_sm_ns == RESET_RSFEC_RX || ehip_reset_sm_ns == DEASSERT_RSFEC_RX)
	     else
	       rsfec_rx_reset_counter <= ({RESET_COUNT_SIZE{1'b0}});
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)


   // Assert or deassert RSFEC_RESET
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     rsfec_reset_out_reg <= 1'b0;
	     rsfec_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (ehip_reset_sm_ns == RESET_RSFEC || ehip_reset_sm_ns == DEASSERT_RSFEC)
	       begin
		  if (!(&rsfec_reset_counter))
		    rsfec_reset_counter <= rsfec_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (csr_assert_req)
			 rsfec_reset_out_reg <= 1'b1;
		       else if (csr_deassert_req)
			 rsfec_reset_out_reg <= 1'b0;
		    end
	       end // if (ehip_reset_sm_ns == RESET_RSFEC || ehip_reset_sm_ns == DEASSERT_RSFEC)
	     else
	       rsfec_reset_counter <= ({RESET_COUNT_SIZE{1'b0}});
	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)


     reg req_done_r;
   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  req_done_r <= 1'b0;
	else
	  req_done_r <= req_done_comb && !all_seq_done;
     end
    assign req_done = req_done_r && !all_seq_done;


   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  begin
	     ehip_pld_ready_out_reg <= 1'b0;
	     ehip_pld_ready_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (ASSERT_EHIP_PLD_READY || RESET_EHIP_PLD_READY)
	       begin
		  if (!(&ehip_pld_ready_counter))
		    ehip_pld_ready_counter <= ehip_pld_ready_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (csr_assert_req)
			 ehip_pld_ready_out_reg <= 1'b0;
		       else if (csr_deassert_req)
			 ehip_pld_ready_out_reg <= 1'b1;
		    end
	       end // if (ASSERT_EHIP_PLD_READY || RESET_EHIP)
	     else if (all_seq_done)
	       ehip_pld_ready_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end // else: !if(!reset_n)
     end // always @ (posedge clk or negedge reset_n)

// Assert all errors

   always @(posedge clk or negedge reset_n)
     begin
	if (!reset_n)
	  begin
	     ehip_ready_timeout_err <= 1'b0;
	     ehip_rst_ack_timeout_err  <= 1'b0;
	     ehip_txrst_ack_timeout_err  <= 1'b0;
	     ehip_rxrst_ack_timeout_err  <= 1'b0;
	  end
	else
	  begin
	     ehip_ready_timeout_err <= ehip_ready_timeout_err_comb;
	     ehip_rst_ack_timeout_err  <= ehip_rst_ack_timeout_err_comb;
	     ehip_txrst_ack_timeout_err  <= ehip_txrst_ack_timeout_err_comb;
	     ehip_rxrst_ack_timeout_err  <= ehip_rxrst_ack_timeout_err_comb;
	  end // else: !if(!reset_n)
     end // always @ (posedge clk or negedge reset_n)



   // Control Signal_OK based, assert and deassert it only for CSR assertion and deasserion,
   // We need signal ok here as for CSR deassertion sequence signal_ok needs to be "1" at the end which is after EHIP RX
   always @(posedge clk or negedge reset_n)
     begin
	if (~reset_n)
	  begin
	     signal_ok_out_reg <= 1'b0;
	     sigok_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	  end
	else
	  begin
	     if (ehip_reset_sm_ns == SIGNAL_OK || ehip_reset_sm_ns == SIGNAL_NOT_OK)
	       begin
		  if (!(&sigok_reset_counter))
		    sigok_reset_counter <= sigok_reset_counter + RESET_COUNT_ADD;
		  else
		    begin
		       if (csr_assert_req || rx_assert_req)
			 signal_ok_out_reg <= 1'b0;
		       else if (csr_deassert_req || rx_deassert_req)
			 signal_ok_out_reg <= 1'b1;
		    end
	       end // if (rxreset_sm_ns == RESET_RX_PCS_CHANNELS || rxreset_sm_ns == DEASSERT_RX_PCS_CHANNELS)
	     else if (all_seq_done)
	       begin
		  sigok_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
	       end

	  end // else: !if(~reset_n)
     end // always @ (posedge clk or negedge reset_n)




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


endmodule // alt_ehipc3_fm_ehip_rst
