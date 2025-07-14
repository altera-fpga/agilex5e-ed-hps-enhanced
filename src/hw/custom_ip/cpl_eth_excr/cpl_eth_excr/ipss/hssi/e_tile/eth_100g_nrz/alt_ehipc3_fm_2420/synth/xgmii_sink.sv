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


// (C) 2001-2019 Intel Corporation. All rights reserved.
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


// (C) 2001-2018 Intel Corporation. All rights reserved.
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


// (C) 2001-2018 Intel Corporation. All rights reserved.
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


// (C) 2001-2018 Intel Corporation. All rights reserved.
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



`timescale 1 ps / 1 ps

`define XGMII_START     8'hFB
`define XGMII_TERMINATE 8'hFD

`define RX_SM_IDLE      1'b0
`define RX_SM_TRANSMIT  1'b1

`define S0_OFFSET				0
`define S4_OFFSET				72/2

module xgmii_sink (
	input          tx_reset,
	input          xgmii_tx_clk,
	input          xgmii_rx_clk,
	input          rx_reset,
	input   [255:0] xgmii_rx_d_mon,
	input    [31:0] xgmii_rx_c_mon,
	input   [255:0] xgmii_tx_d_mon,
	input    [31:0] xgmii_tx_c_mon,
  input  wire		 o_rx_mii_am_valid	,
  input  wire		 o_tx_mii_valid	,
  input  wire		 o_tx_mii_am	,
  input  wire		 o_rx_mii_valid	,
	input          test_done,
	output         fifo_full,
	output         fifo_empty,
	output  [287:0] read_stored_data,
	output reg     checker_pass,
	output reg     rx_mismatch,
	output reg     idle_state,
	output reg [11:0] match_count,
	output reg [11:0] mismatch_count
); // module xgmii_sink

	wire         [287:0] xgmii_rx_compare;
	reg                packet_write;
	reg                packet_read;
	//reg         [15:0] match_count;
	//reg         [15:0] mismatch_count;
	reg          [2:0] rx_sm_reg;
	reg                match_count_min;

	wire               rx_reset_sync_tx;


 alt_xcvr_resync_std #(
    .SYNC_CHAIN_LENGTH     (3),
   .WIDTH        (1),
   .INIT_VALUE   (0)
  ) rx_reset_sync (
    .clk    (xgmii_tx_clk),
    .reset  (tx_reset),
    .d      (rx_reset),
    .q      (rx_reset_sync_tx)
  );
  reg [255:0]   xgmii_tx_d_mon_d;
  reg [31:0]    xgmii_tx_c_mon_d;
  reg           o_tx_mii_valid_d;
  reg           o_tx_mii_am_d;
always @(posedge xgmii_tx_clk) begin
	if (tx_reset | rx_reset_sync_tx) begin
		packet_write <= 0;
                o_tx_mii_valid_d <=0;
                o_tx_mii_am_d <=0;
                xgmii_tx_c_mon_d <=0;
                xgmii_tx_d_mon_d <=0;
	end else begin
		if ((xgmii_tx_d_mon[7:0] == `XGMII_START) && ~fifo_full) begin
			packet_write <= 1;
		end else if (xgmii_tx_d_mon[7:0] == `XGMII_TERMINATE) begin
			packet_write <= 0;
		end
                o_tx_mii_valid_d <=o_tx_mii_valid;
                o_tx_mii_am_d    <=o_tx_mii_am;
                xgmii_tx_c_mon_d <=xgmii_tx_c_mon;
                xgmii_tx_d_mon_d <=xgmii_tx_d_mon;
	end
end
// wire packet_write_pre = ((xgmii_tx_d_mon[7:0] == `XGMII_START) && ~fifo_full)&& (!(tx_reset | rx_reset_sync_tx));

always @(posedge xgmii_rx_clk or posedge rx_reset) begin
	if (rx_reset) begin
		rx_sm_reg      <= `RX_SM_IDLE;
		packet_read    <= 0;
//		match_count    <= 0;
		rx_mismatch    <= 0;
//		mismatch_count <= 0;
		checker_pass   <= 0;
		idle_state     <= 1;
	end else begin
		case (rx_sm_reg)

			`RX_SM_IDLE: begin
		    idle_state  <= 1;
				packet_read <= 0;
				//if ((test_done==1'b1) && (match_count>100) && (mismatch_count < 1)) begin
				if ((test_done==1'b1) && (match_count_min) && (mismatch_count < 1)) begin
					checker_pass <= 1;
				end else if ((test_done==1'b1) && (mismatch_count > 0)) begin
					rx_mismatch <= 1;
				end
				if ((xgmii_rx_d_mon[7:0] == `XGMII_START)	&& ~fifo_empty & o_rx_mii_valid & (~o_rx_mii_am_valid)) begin
				  packet_read <= 1;
					rx_sm_reg <= `RX_SM_TRANSMIT;
				end
			end

			`RX_SM_TRANSMIT: begin
		    idle_state  <= 0;
			//	if (xgmii_rx_compare == read_stored_data) begin
			//		match_count <= match_count + 1;
			//	end
			//	else if (~o_rx_mii_am_valid & o_rx_mii_valid)begin
			//		mismatch_count <= mismatch_count + 1;
			//	end
				if (xgmii_rx_d_mon[7:0] == `XGMII_TERMINATE & ~o_rx_mii_am_valid & o_rx_mii_valid) begin
					packet_read <= 0;
					rx_sm_reg <= `RX_SM_IDLE;
				end else
					packet_read <= 1;
			end

		endcase // case (rx_sm_reg)
	end
end

wire   packet_read_1 =(xgmii_rx_d_mon[7:0] == `XGMII_START)	&& ~fifo_empty & o_rx_mii_valid & (~o_rx_mii_am_valid);
wire   packet_read_0 =(xgmii_rx_d_mon[7:0] == `XGMII_TERMINATE & ~o_rx_mii_am_valid & o_rx_mii_valid) ? 1'b0 : 1'b1;

wire   packet_read_all = packet_read_1 ||(packet_read &&(packet_read_0));

reg    [287:0]  xgmii_rx_compare_d;
reg             rx_sm_reg_d;
reg             o_rx_mii_am_valid_d;
reg             o_rx_mii_valid_d;
reg             match_count_pulse;
reg             mismatch_count_pulse;
always @(posedge xgmii_rx_clk or posedge rx_reset) begin
	if (rx_reset) begin
					match_count <= 0;
					mismatch_count <= 0;
					xgmii_rx_compare_d <= 0;
					rx_sm_reg_d <= 0;
					o_rx_mii_am_valid_d <= 0;
					o_rx_mii_valid_d <= 0;
					mismatch_count_pulse <= 0;
					match_count_pulse <= 0;
					match_count_min <= 0;
                      end
        else          begin
				if ((xgmii_rx_compare_d == read_stored_data) && (rx_sm_reg==`RX_SM_TRANSMIT)) begin
					//match_count <= match_count + 1;
					match_count_pulse <= 1'b1;
					mismatch_count_pulse <= 1'b0;
				end
				else if ((~o_rx_mii_am_valid_d & o_rx_mii_valid_d) && (rx_sm_reg==`RX_SM_TRANSMIT))begin
					//mismatch_count <= mismatch_count + 1;
					match_count_pulse <= 1'b0;
					mismatch_count_pulse <= 1'b1;
				end
                                else begin
					match_count_pulse <= 1'b0;
					mismatch_count_pulse <= 1'b0;
                                end
					xgmii_rx_compare_d <= xgmii_rx_compare;
					rx_sm_reg_d <= rx_sm_reg;
					o_rx_mii_am_valid_d <= o_rx_mii_am_valid;
					o_rx_mii_valid_d <= o_rx_mii_valid;
					match_count <= match_count_pulse ? match_count + 1 : match_count;
					mismatch_count <= mismatch_count_pulse ? mismatch_count + 1 : mismatch_count;
					match_count_min <=  match_count[5] ? 1'b1 : match_count_min;
                      end
end

assign xgmii_rx_compare = {xgmii_rx_d_mon,xgmii_rx_c_mon};

wire dcfifo_aclr = tx_reset | rx_reset;
wire fifo_full_raw;

	checker_fifo checker_fifo_inst (
		.aclr(dcfifo_aclr),
		.data({xgmii_tx_d_mon_d,xgmii_tx_c_mon_d}),
		.rdclk(xgmii_rx_clk),
		.rdreq(packet_read_all && o_rx_mii_valid && ~o_rx_mii_am_valid),
		.wrclk(xgmii_tx_clk),
		.wrreq((packet_write) && o_tx_mii_valid_d && ~o_tx_mii_am_d),
		.q(read_stored_data),
		.rdempty(fifo_empty),
		.wrfull(fifo_full_raw)
	);

// Gate off FIFO full status signal when resetting FIFO
assign fifo_full = fifo_full_raw & ~dcfifo_aclr;

endmodule
