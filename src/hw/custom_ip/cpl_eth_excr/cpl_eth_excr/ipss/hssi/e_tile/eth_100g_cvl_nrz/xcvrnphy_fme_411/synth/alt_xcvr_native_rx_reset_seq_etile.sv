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


// Module: alt_xcvr_native_rx_reset_seq
//
// Description:
//  Stratix 10 transceiver rx reset local sequencer
//	The rx reset assert sequence:	(RSFEC) AIB XCVRIF
//	             deassert sequence:	XCVRIF AIB (RSFEC)
//
//  Parameters:
//    CLK_FREQ_IN_HZ
//      - Specifies the input clock frequency in HZ
//    DEFAULT_RESET_SEPARATION_NS
//      - Specifies the separation delay guaranteed by Master Transceiver Reset Sequencer
//    RESET_SEPARATION_NS
//      - Specifies the required separation delay for digital reset assertion and deassertion (from xcvrif reset assert and deassert)
//    SPACE_NS (Default 100ns)
//      - Specifies the space for each reset signal (Assertion: from rsfec to aib, from aib to xcvrif; Deassertion: from xcvrif to aib, from aib to rsfec)
//    ENABLE_IND_CHANNEL
//      - 1 : Enable independent channel reset
//	- 0 : Disable independent channel reset (bonded)
//    NUM_CHANNELS
//      - Specifies the number of channels which resets are serviced by the local sequencer
//    ENABLE_RSFEC
//      - 1 : Enable RSFEC reset
//        0 : Disable RSFEC reset
//

`timescale 1ps/1ps

module alt_xcvr_native_rx_reset_seq
#(
	parameter [63:0] CLK_FREQ_IN_HZ = 100000000,
	parameter [63:0] DEFAULT_RESET_SEPARATION_NS = 100,
	parameter [63:0] RESET_SEPARATION_NS = 100,
	parameter [63:0] SPACE_NS = 100,
	parameter REDUCED_RESET_SIM_TIME= 0,
	parameter NUM_CHANNELS = 1,
	parameter ENABLE_IND_CHANNEL = 0,
	parameter ENABLE_RSFEC = 1
)(
	input wire clk,
	input wire reset_n,
	input wire [NUM_CHANNELS-1:0] reset_in,
	input wire [NUM_CHANNELS-1:0] transfer_ready_in,
	output wire [NUM_CHANNELS-1:0] aib_reset_out,
	output wire [NUM_CHANNELS-1:0] xcvrif_reset_out,
	output wire                    rsfec_reset_out,
	output wire [NUM_CHANNELS-1:0] reset_stat,
	output wire [NUM_CHANNELS-1:0] reset_timeout
);

localparam SINGLE_SEQ = (!ENABLE_IND_CHANNEL | ENABLE_RSFEC);
localparam NUM_RESETS = SINGLE_SEQ ? 1 : NUM_CHANNELS;

localparam  SAMPLE_RESET           = 3'd0;
localparam  RESET_REQ	           = 3'd1;
localparam  RESET_ACK	           = 3'd2;
localparam  TRANSFER_READY_TIMEOUT = 3'd3;
localparam  RESUME_RESET           = 3'd4;

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

localparam [63:0] SPACE_COUNT = (CLK_FREQ_IN_HZ * SPACE_NS) / 1000000000;
localparam [63:0] SPACE_ROUNT_COUNT = (((SPACE_COUNT * 1000000000) / CLK_FREQ_IN_HZ) < SPACE_NS)
							? (SPACE_COUNT + 1) : SPACE_COUNT;
localparam SPACE_COUNT_MAX = (SPACE_ROUNT_COUNT > 0) ? SPACE_ROUNT_COUNT - 1 : 0;


localparam RESET_COUNT_SIZE = clogb2_alt_xcvr_native_s10(ADDED_RESET_COUNT_MAX + SPACE_COUNT_MAX);

localparam [RESET_COUNT_SIZE-1:0] ADDED_RESET_COUNT_ADD = {{RESET_COUNT_SIZE-1{1'b0}},1'b1};
localparam [RESET_COUNT_SIZE-1:0] RESET_COUNT_ADD = {{RESET_COUNT_SIZE-1{1'b0}},1'b1};


// Sync signals
wire [NUM_RESETS-1:0] transfer_ready_in_sync;
wire [NUM_RESETS-1:0] reset_in_sync;

// TRE reset signals
reg [NUM_RESETS-1:0] reset_req_comb;
reg [NUM_RESETS-1:0] update_reset;
reg [NUM_RESETS-1:0] reset_req;
reg [NUM_RESETS-1:0] reset_req_stage;
wire [NUM_RESETS-1:0] reset_ack;

// Reset state machine
reg [NUM_RESETS*3-1:0] reset_sm_cs;
reg [NUM_RESETS*3-1:0] reset_sm_ns;

// Reset inputs
reg [NUM_RESETS-1:0] reset_sample;
reg [NUM_RESETS-1:0] sample_data;
reg [NUM_RESETS-1:0] clear_timeout;

wire [NUM_RESETS-1:0] xcvrif_reset_req;
wire [NUM_RESETS-1:0] aib_reset_req;
wire                  rsfec_reset_req;

wire [NUM_RESETS-1:0] reset_match;
wire [NUM_RESETS-1:0] aib_reset_match;
wire [NUM_RESETS-1:0] xcvrif_reset_match;
wire                  rsfec_reset_match;

// Reset output registers (must be synchronized at destination logic)
reg [NUM_RESETS-1:0] aib_reset_out_reg;
reg [NUM_RESETS-1:0] xcvrif_reset_out_reg;
reg                  rsfec_reset_out_reg;
reg [NUM_RESETS-1:0] reset_out_reg;
reg [NUM_RESETS-1:0] int_reset_out_reg;

reg [NUM_RESETS-1:0] aib_reset_out_stage;
reg [NUM_RESETS-1:0] xcvrif_reset_out_stage;
reg                  rsfec_reset_out_stage;
reg [NUM_RESETS-1:0] reset_out_stage;
reg [NUM_RESETS-1:0] reset_timeout_stage;

// error status
reg [NUM_RESETS-1:0] transfer_ready_stat;
reg [NUM_RESETS-1:0] transfer_ready_timeout;

// Reset counters
wire [NUM_RESETS-1:0] aib_reset_timeout;
wire [NUM_RESETS-1:0] xcvrif_reset_timeout;
wire                  rsfec_reset_timeout;
wire [NUM_RESETS-1:0] xcvrif_reset_ext_timeout;
reg [RESET_COUNT_SIZE-1:0] xcvrif_reset_counter [NUM_RESETS-1:0];
reg [RESET_COUNT_SIZE-1:0] aib_reset_counter [NUM_RESETS-1:0];
reg [RESET_COUNT_SIZE-1:0] rsfec_reset_counter;


// Temporary wires
wire [NUM_RESETS-1:0] w_reset_in;
wire [NUM_RESETS-1:0] w_transfer_ready_in;

assign w_reset_in = SINGLE_SEQ ? (|reset_in) : reset_in[NUM_RESETS-1:0];
assign w_transfer_ready_in = SINGLE_SEQ ? (&transfer_ready_in) : transfer_ready_in[NUM_RESETS-1:0];

//***************************************************************************
// Reset output
//***************************************************************************
if (SINGLE_SEQ) begin
    assign aib_reset_out    = {NUM_CHANNELS{aib_reset_out_stage}};
    assign xcvrif_reset_out = {NUM_CHANNELS{xcvrif_reset_out_stage}};
    assign reset_stat       = {NUM_CHANNELS{reset_out_stage}};
    assign reset_timeout    = {NUM_CHANNELS{reset_timeout_stage}};
end else begin
    assign aib_reset_out    = aib_reset_out_stage;
    assign xcvrif_reset_out = xcvrif_reset_out_stage;
    assign reset_stat       = reset_out_stage;
    assign reset_timeout    = reset_timeout_stage;
end
assign rsfec_reset_out = rsfec_reset_out_stage;


// Add register stage to AIB reset and reset_out outputs
always @(posedge clk) begin
	aib_reset_out_stage <= aib_reset_out_reg;
	xcvrif_reset_out_stage <= xcvrif_reset_out_reg;
	rsfec_reset_out_stage <= rsfec_reset_out_reg;
	reset_out_stage <= reset_out_reg;
	reset_timeout_stage <= transfer_ready_timeout;
end

//***************************************************************************
// Synchronizers
//***************************************************************************
alt_xcvr_resync_std #(
		.SYNC_CHAIN_LENGTH(3),
		.WIDTH(NUM_RESETS),
		.INIT_VALUE(0))
transfer_ready_synchronizers (
		.clk	(clk),
		.reset	(~reset_n),
		.d	(w_transfer_ready_in),
		.q	(transfer_ready_in_sync));

alt_xcvr_resync_std #(
		.SYNC_CHAIN_LENGTH(3),
		.WIDTH(NUM_RESETS),
		.INIT_VALUE(0))
reset_in_synchronizers (
		.clk	(clk),
		.reset	(~reset_n),
		.d	(w_reset_in),
		.q	(reset_in_sync));


//***************************************************************************
// User reset sequencer Logic
//***************************************************************************
assign rsfec_reset_match = (rsfec_reset_out_reg == rsfec_reset_req);
assign rsfec_reset_timeout = rsfec_reset_req ? (rsfec_reset_counter == ADDED_RESET_COUNT_MAX) : (rsfec_reset_counter == SPACE_COUNT_MAX);

genvar ig;
generate
	for(ig=0;ig<NUM_RESETS;ig=ig+1) begin : g_dig_trs_inst

		//****************
		// Reset release count max value
		//****************

		//****************
		// TRE instance
		//****************
	`ifdef ALTERA_RESERVED_QIS
		altera_s10_xcvr_reset_endpoint altera_s10_xcvr_reset_endpoint_inst (
			.tre_reset_req(reset_req_stage[ig]),
			.tre_reset_ack(reset_ack[ig]),
			.clk_in()
		);
	`else
		if (REDUCED_RESET_SIM_TIME) begin
			assign reset_ack[ig] = reset_req_stage[ig];
		end else begin
			// TRE instance
			altera_s10_xcvr_reset_endpoint altera_s10_xcvr_reset_endpoint_inst (
				.tre_reset_req(reset_req_stage[ig]),
				.tre_reset_ack(reset_ack[ig]),
				.clk_in()
			);
		end
	`endif  // (NOT ALTERA_RESERVED_QIS)

		assign reset_match[ig] = (int_reset_out_reg[ig] == reset_sample[ig]);

		//********************************************************************
		// Reset State Machine
		//********************************************************************
		always @(posedge clk or negedge reset_n) begin
		   if (~reset_n) begin
		      reset_sm_cs[ig*3 +: 3] <= SAMPLE_RESET;
		   end else begin
		      reset_sm_cs[ig*3 +: 3] <= reset_sm_ns[ig*3 +: 3];
		   end
		end

		always @(*) begin
		   reset_sm_ns[ig*3 +: 3] = reset_sm_cs[ig*3 +: 3];
		   sample_data[ig] = 1'b0;
		   reset_req_comb[ig] = 1'b0;
		   update_reset[ig] = 1'b0;
		   clear_timeout[ig] = 1'b0;

		   case(reset_sm_cs[ig*3 +: 3])
		      SAMPLE_RESET:
		      begin
		         if(!reset_match[ig] && !reset_ack[ig]) begin
                    reset_sm_ns[ig*3 +: 3]  = RESET_REQ;
			     end
			     sample_data[ig] = !reset_ack[ig];
              end

		      RESET_REQ:
              begin
		         if(reset_ack[ig]) begin
                    reset_sm_ns[ig*3 +: 3]  = RESET_ACK;
			     end
			     sample_data[ig] = 1'b1;
			     reset_req_comb[ig] = 1'b1;
		      end

		      RESET_ACK:
		      begin
			     if (transfer_ready_timeout[ig]) begin
				    if (!reset_match[ig]) begin
					   reset_sm_ns[ig*3 +: 3]  = RESET_ACK;
					end else begin
				       reset_sm_ns[ig*3 +: 3]  = TRANSFER_READY_TIMEOUT;
					end
		         end else if (reset_match[ig]) begin
                    reset_sm_ns[ig*3 +: 3]  = SAMPLE_RESET;
				 end
			     reset_req_comb[ig] = 1'b1;
				 update_reset[ig] = 1'b1;
              end

			  TRANSFER_READY_TIMEOUT:
		      begin
			    if (transfer_ready_timeout[ig]) begin
				   reset_sm_ns[ig*3 +: 3]  = TRANSFER_READY_TIMEOUT;
				end else begin
				   reset_sm_ns[ig*3 +: 3]  = RESUME_RESET;
				end
				reset_req_comb[ig] = 1'b1;
				clear_timeout[ig] = 1'b1;
              end

			  RESUME_RESET:
		      begin
			     if (reset_match[ig]) begin
                    reset_sm_ns[ig*3 +: 3]  = SAMPLE_RESET;
				 end
			     reset_req_comb[ig] = 1'b1;
				 update_reset[ig] = 1'b1;
				 clear_timeout[ig] = 1'b1;
              end

		      default:
		      begin
		         reset_sm_ns[ig*3 +: 3] = SAMPLE_RESET;
			     sample_data[ig] = 1'b0;
			     reset_req_comb[ig] = 1'b0;
				 update_reset[ig] = 1'b0;
				 clear_timeout[ig] = 1'b0;
		      end
		   endcase
		end

		//****************
		// Reset sampling
		//****************
		always @(posedge clk or negedge reset_n) begin
			if (~reset_n) begin
				reset_sample[ig] <= 1'b0;
			end else if (clear_timeout[ig]) begin
			    reset_sample[ig] <= 1'b1;
			end else if (sample_data[ig]) begin
				reset_sample[ig] <= reset_in_sync[ig];
			end
		end

		always @(posedge clk or negedge reset_n) begin
			if (~reset_n) begin
				reset_req[ig] <= 1'b0;
				reset_req_stage[ig] <= 1'b0;
			end else begin
				reset_req[ig] <= reset_req_comb[ig];
				reset_req_stage[ig] <= reset_req[ig];
			end
		end

		//****************
		// AIB reset request, XCVRIF reset request and RSFEC reset request update
		//
		//****************
		//reset_req: 1 -- assert timeout	0 -- deassert timeout
		assign aib_reset_match[ig] = (aib_reset_out_reg[ig] == aib_reset_req[ig]);
		assign aib_reset_timeout[ig] = aib_reset_req[ig] ?(ENABLE_RSFEC ? (aib_reset_counter[ig] == SPACE_COUNT_MAX) : (aib_reset_counter[ig] == ADDED_RESET_COUNT_MAX) ) : (aib_reset_counter[ig] == SPACE_COUNT_MAX);

		assign xcvrif_reset_match[ig] = (xcvrif_reset_out_reg[ig] == xcvrif_reset_req[ig]);
		assign xcvrif_reset_timeout[ig] = xcvrif_reset_req[ig] ? (xcvrif_reset_counter[ig] == SPACE_COUNT_MAX) : (xcvrif_reset_counter[ig] == ADDED_RESET_COUNT_MAX);

		assign aib_reset_req[ig] = reset_sample[ig] ? (ENABLE_RSFEC ? rsfec_reset_out_reg : reset_sample[ig]) : xcvrif_reset_out_reg[ig];

		assign xcvrif_reset_req[ig] = reset_sample[ig] ? aib_reset_out_reg[ig] : reset_sample[ig] ;


		//****************
		// AIB reset sequencing
		//****************
		always @(posedge clk or negedge reset_n) begin
			if (~reset_n) begin
				aib_reset_out_reg[ig] <= 1'b0;
				aib_reset_counter[ig] <= {RESET_COUNT_SIZE{1'b0}};
			end else if (update_reset[ig]) begin
				if (aib_reset_timeout[ig] || aib_reset_match[ig]) begin
					aib_reset_out_reg[ig] <= aib_reset_req[ig];
					aib_reset_counter[ig] <= {RESET_COUNT_SIZE{1'b0}};
				end else begin
					aib_reset_counter[ig] <= aib_reset_counter[ig] + RESET_COUNT_ADD;
				end
			end
		end

		if (ig==0)  begin: rsfec_rst
		//****************
		// RSFEC reset sequencing
		//****************
		assign rsfec_reset_req = ENABLE_RSFEC ? (reset_sample ? reset_sample : aib_reset_out_reg) : 0;

		always @(posedge clk or negedge reset_n) begin
			if (~reset_n) begin
				rsfec_reset_out_reg <= 1'b0;
				rsfec_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
			end else if (ENABLE_RSFEC) begin
				if (update_reset && (transfer_ready_stat || transfer_ready_timeout)) begin			//start counter after transfer_ready
					if (rsfec_reset_timeout || rsfec_reset_match || transfer_ready_timeout) begin
						rsfec_reset_out_reg <= rsfec_reset_req;
						rsfec_reset_counter <= {RESET_COUNT_SIZE{1'b0}};
					end else begin
						rsfec_reset_counter <= rsfec_reset_counter + RESET_COUNT_ADD;
					end
				end
			end
		end
		end  // ig==0



		//****************
		// XCVRIF reset sequencing
		//****************
		always @(posedge clk or negedge reset_n) begin
			if (~reset_n) begin
				xcvrif_reset_out_reg[ig] <= 1'b0;
				xcvrif_reset_counter[ig] <= {RESET_COUNT_SIZE{1'b0}};
			end else if (update_reset[ig]) begin
				if (xcvrif_reset_timeout[ig] || xcvrif_reset_match[ig]) begin
					xcvrif_reset_out_reg[ig] <= xcvrif_reset_req[ig];
					xcvrif_reset_counter[ig] <= {RESET_COUNT_SIZE{1'b0}};
				end else begin
					xcvrif_reset_counter[ig] <= xcvrif_reset_counter[ig] + RESET_COUNT_ADD;
				end
			end
		end



		//****************
		// Assert transfer_ready_timeout if reset_ack is deasserted before transfer_ready is asserted after reset is released
		//****************
		always @(posedge clk or negedge reset_n) begin
			if (~reset_n) begin
				transfer_ready_timeout[ig] <= 1'b0;
				transfer_ready_stat[ig] <= 1'b1;
			end else if (reset_sample[ig]) begin
				transfer_ready_timeout[ig] <= 1'b0;
				transfer_ready_stat[ig] <= 1'b1;
			end else if (~transfer_ready_timeout[ig]) begin
				if (reset_ack[ig]) begin
					transfer_ready_stat[ig] <= transfer_ready_in_sync[ig];
				end else begin
					transfer_ready_timeout[ig] <= ~transfer_ready_stat[ig];
				end
			end
		end

		//****************
		// Reset output status reflects the AIB/XCVRIF/RSFEC reset output that is asserted/de-asserted last
		//****************
		always @(posedge clk or negedge reset_n) begin
			if (~reset_n) begin
				int_reset_out_reg[ig] <= 1'b0;
				reset_out_reg[ig] <= 1'b0;
			end else begin
				if (reset_sample[ig]) begin
					int_reset_out_reg[ig] <= xcvrif_reset_out_reg[ig];
					if (!clear_timeout[ig]) begin
					   reset_out_reg[ig] <= int_reset_out_reg[ig];
					end
				end else begin
					if (ENABLE_RSFEC)
						int_reset_out_reg[ig] <= rsfec_reset_out_reg;
					else if (transfer_ready_in_sync[ig] || transfer_ready_timeout[ig])
						int_reset_out_reg[ig] <= aib_reset_out_reg[ig];

					if (transfer_ready_stat[ig]) begin
						reset_out_reg[ig] <= int_reset_out_reg[ig];
					end
				end
			end
		end
	end // End for loop
endgenerate

    function integer clogb2_alt_xcvr_native_s10;
      input integer input_num;
      begin
        for (clogb2_alt_xcvr_native_s10=0; input_num>0; clogb2_alt_xcvr_native_s10=clogb2_alt_xcvr_native_s10+1)
          input_num = input_num >> 1;
        if(clogb2_alt_xcvr_native_s10 == 0)
          clogb2_alt_xcvr_native_s10 = 1;
      end
    endfunction


endmodule
