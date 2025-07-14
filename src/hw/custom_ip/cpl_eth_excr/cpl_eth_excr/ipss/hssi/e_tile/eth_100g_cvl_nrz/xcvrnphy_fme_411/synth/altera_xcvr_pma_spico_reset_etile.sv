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


// File Name: altera_xcvr_pma_spico_reset_etile.sv
//
// Description:
//
//  This module will execute PMA reset or SPICO reset avmm command sequences based on user requests.
//
//
//     Features:
//      - Synchronization of the reset input
//      - Reset control per channel or shared. (ENABLE_IND_CHANNEL E.g. separate rx_reset control for each channel or one rx_reset for all channels)

`timescale 1ns / 1ns
//`timescale 1ps / 1ps


module  altera_xcvr_pma_spico_reset_etile
#(
    parameter AVMM_ADD_WIDTH           = 19,               //XCVR RCFG address width
    parameter AVMM_DATA_WIDTH          = 8,                //XCVR RCFG data width

    parameter AVMM_TIMEOUT                  = 50000000          // Timeout for each avmm request

) (
  // User reconfig interface ports
  input  							user_clk,
  input  							user_reset,
  input  							user_write,
  input  							user_read,
  input  [AVMM_ADD_WIDTH-1:0]		user_address,
  input  [AVMM_DATA_WIDTH-1:0]		user_writedata,
  output [AVMM_DATA_WIDTH-1:0]		user_readdata,
  output 							user_waitrequest,

  // AVMM ports to transceiver Split bychannel
  output 							avmm_write,
  output 							avmm_read,
  output [AVMM_ADD_WIDTH-1:0]		avmm_address,
  output [AVMM_DATA_WIDTH-1:0]		avmm_writedata,
  input  [AVMM_DATA_WIDTH-1:0]		avmm_readdata,
  input  							avmm_waitrequest,

  // User reset input ports and status output ports
  input								pma_reset,
  input								spico_reset,
  output 							pma_reset_busy,
  output reg						pma_spico_reset_timeout

);


//internal avmm interfaces feed to outputs
reg								int_write;
reg								int_read;
reg [AVMM_ADD_WIDTH-1:0]		int_address;
reg [AVMM_DATA_WIDTH-1:0]		int_writedata;
wire [AVMM_DATA_WIDTH-1:0]		int_readdata;
wire 							int_waitrequest;

//execute address and data for all 4bit address
reg [AVMM_ADD_WIDTH-1:0]		exe_address;
reg [31:0]						exe_writedata;
reg [31:0]						exe_readdata;



reg [3:0] ctrl_state, ctrl_nxt;
reg write_req, read_req;

reg [5:0] avmm_state, avmm_nxt;
reg cmd_done;
wire timeout;
reg [31:0] timer;
reg timer_en;

//4bit counter, write and read 4 addr a time.
reg addr_cnt_rst;
reg [2:0] addr_cnt;
reg [2:0] addr_inc;



//synchrounize edge trigger reset inputs
reg pma_assert, pma_assert_sync, pma_reset_assert;
reg pma_deassert, pma_deassert_sync, pma_reset_deassert;
reg spico_assert, spico_assert_sync, spico_reset_assert;

always @(posedge pma_reset or posedge user_reset)
begin
	if (user_reset)
		pma_assert <= 1'b0;
	else
		pma_assert <= 1'b1;
end

always @(negedge pma_reset or posedge user_reset)
begin
	if (user_reset)
		pma_deassert <= 1'b0;
	else
		pma_deassert <= 1'b1;
end

always @(posedge spico_reset or posedge user_reset)
begin
	if (user_reset)
		spico_assert <= 1'b0;
	else
		spico_assert <= 1'b1;
end


always @(posedge user_clk or posedge user_reset)
begin
	if (user_reset)	begin
		pma_assert_sync		<= 1'b0;
		pma_reset_assert	<= 1'b0;
		pma_deassert_sync	<= 1'b0;
		pma_reset_deassert	<= 1'b0;
		spico_assert_sync	<= 1'b0;
		spico_reset_assert	<= 1'b0;
	end else begin
		pma_assert_sync		<= pma_assert && !pma_deassert;
		pma_reset_assert	<= pma_assert_sync;
		pma_deassert_sync	<= pma_deassert;
		pma_reset_deassert	<= pma_deassert_sync;
		spico_assert_sync	<= spico_assert;
		spico_reset_assert	<= spico_assert_sync;
	end
end


//Start of state machine
localparam IDLE           = 4'h0;
localparam PMA_DIS_WR_E8  = 4'h1;
localparam PMA_DIS_WR_90  = 4'h2;
localparam PMA_DIS_RD_88  = 4'h3;
localparam PMA_DISABLED   = 4'h4;
localparam SPICO_WR_200   = 4'h5;
localparam SPICO_RD_204   = 4'h6;
localparam SPICO_DONE     = 4'h7;
localparam PMA_EN_RD_94   = 4'h8;
localparam PMA_EN_MWR_94  = 4'h9;
localparam PMA_EN_WR_90   = 4'ha;


always @(posedge user_clk or posedge user_reset)
begin
	if (user_reset)
		ctrl_state <= IDLE;
	else
		ctrl_state <= ctrl_nxt;
end


always @ (*)
begin
	ctrl_nxt			= IDLE;
	write_req			= 1'b0;
	read_req			= 1'b0;
	timer_en			= 1'b0;
	exe_address			= 19'h00000;
	exe_writedata		= 32'h00000000;

	case (ctrl_state)
	IDLE:			begin
						if (pma_reset_assert)
							ctrl_nxt = PMA_DIS_WR_E8;
						else
							ctrl_nxt = IDLE;
					end
	PMA_DIS_WR_E8:	begin
						exe_address		= 19'h000e8;
						exe_writedata	= 32'h00010000;
						ctrl_nxt		= PMA_DIS_WR_E8;
						write_req		= 1'b1;
						timer_en		= 1'b1;
						if (cmd_done) begin
							ctrl_nxt 	= PMA_DIS_WR_90;
							write_req	= 1'b0;
							timer_en	= 1'b0;
						end
					end

	PMA_DIS_WR_90:	begin
						exe_address		= 19'h00090;
						exe_writedata	= 32'h00000100;
						ctrl_nxt		= PMA_DIS_WR_90;
						write_req		= 1'b1;
						timer_en		= 1'b1;
						if (cmd_done) begin
							ctrl_nxt 	= PMA_DIS_RD_88;
							write_req	= 1'b0;
							timer_en	= 1'b0;
						end
					end

	PMA_DIS_RD_88:	begin
						exe_address		= 19'h00088;
						read_req		= 1'b1;
						ctrl_nxt		= PMA_DIS_RD_88;
						timer_en		= 1'b1;
						if (cmd_done) begin
							read_req	= 1'b0;
							if (exe_readdata[31] == 1'b1) begin
								ctrl_nxt = PMA_DISABLED;
								timer_en = 1'b0;
							end else
								ctrl_nxt = PMA_DIS_RD_88;
						end
					end

	PMA_DISABLED:	begin
						if (spico_reset_assert)
							ctrl_nxt	= SPICO_WR_200;
						else if (pma_reset_deassert)
							ctrl_nxt	= PMA_EN_RD_94;
						else
							ctrl_nxt	= PMA_DISABLED;
					end

	SPICO_WR_200:	begin
						exe_address		= 19'h00200;
						exe_writedata	= 32'h81000000;
						write_req		= 1'b1;
						ctrl_nxt		= SPICO_WR_200;
						timer_en		= 1'b1;
						if (cmd_done) begin
							ctrl_nxt 	= SPICO_RD_204;
							write_req	= 1'b0;
							timer_en	= 1'b0;
						end
					end

	SPICO_RD_204:	begin
						exe_address		= 19'h00204;
						read_req		= 1'b1;
						ctrl_nxt		= SPICO_RD_204;
						timer_en		= 1'b1;
						if (cmd_done) begin
							read_req		= 1'b0;
							if (exe_readdata == 32'h80000000) begin
								ctrl_nxt = SPICO_DONE;
								timer_en = 1'b0;
							end else
								ctrl_nxt = SPICO_RD_204;
						end
					end

	SPICO_DONE:		begin
						if (pma_reset_deassert)
							ctrl_nxt	= PMA_EN_RD_94;
						else
							ctrl_nxt	= SPICO_DONE;
					end

	PMA_EN_RD_94:	begin
						exe_address		= 19'h00094;
						read_req		= 1'b1;
						ctrl_nxt		= PMA_EN_RD_94;
						timer_en		= 1'b1;
						if (cmd_done) begin
							ctrl_nxt = PMA_EN_MWR_94;
							read_req = 1'b0;
							timer_en = 1'b0;
						end
					end

	PMA_EN_MWR_94:	begin
						exe_address		= 19'h00094;
						exe_writedata	= exe_readdata | 32'h00002000;
						write_req		= 1'b1;
						ctrl_nxt		= PMA_EN_MWR_94;
						timer_en		= 1'b1;
						if (cmd_done) begin
							ctrl_nxt 	= PMA_EN_WR_90;
							write_req	= 1'b0;
							timer_en	= 1'b0;
						end
					end

	PMA_EN_WR_90:	begin
						exe_address		= 19'h00090;
						exe_writedata	= 32'h00000100;
						write_req		= 1'b1;
						ctrl_nxt		= PMA_EN_WR_90;
						timer_en		= 1'b1;
						if (cmd_done) begin
							ctrl_nxt 	= IDLE;
							write_req	= 1'b0;
							timer_en	= 1'b0;
						end
					end
	endcase
end


//timer, to count max timeout
always @(posedge user_clk or posedge user_reset)
begin
	if (user_reset)
		timer <= 32'h00000000;
	else begin
		if (timer_en) begin
			if (!timeout)
				timer <= timer + 1;
			else
				timer <= timer;
		end
		else
			timer <= 32'h00000000;
	end
end
//=======================================================================================

//counter, to count address increment to 4
always @(posedge user_clk or posedge user_reset)
begin
	if (user_reset)
		addr_cnt <= 3'h0;
	else begin
		if (addr_cnt_rst)
			addr_cnt <= 3'h0;
		else
			addr_cnt <= addr_cnt + addr_inc;
	end
end





//AVMM read and write state machine
localparam INIT		= 6'b000001;
localparam WR_REQ	= 6'b000010;
localparam WR_WAIT	= 6'b000100;
localparam RD_REQ	= 6'b001000;
localparam RD_WAIT	= 6'b010000;
localparam TIMEOUT	= 6'b100000;


always @(posedge user_clk or posedge user_reset)
begin
	if (user_reset)
		avmm_state <= INIT;
	else
		avmm_state <= avmm_nxt;
end

always @(*)
begin
	avmm_nxt		= INIT;
	addr_inc		= 3'h0;
	addr_cnt_rst	= 1'b0;

	int_write		= 1'b0;
	int_read		= 1'b0;
	int_address		= {AVMM_ADD_WIDTH{1'b0}};
	int_writedata	= {AVMM_DATA_WIDTH{1'b0}};


	case (avmm_state)
	INIT:	begin
				if (write_req)
					avmm_nxt = WR_REQ;
				else if (read_req)
					avmm_nxt = RD_REQ;
			end
	WR_REQ:	begin
				avmm_nxt = WR_WAIT;
				int_write		= 1'b1;
				int_writedata	= exe_writedata[addr_cnt*8+:8];
				int_address		= exe_address + addr_cnt;
			end
	WR_WAIT:begin
				int_write		= 1'b1;
				int_writedata	= exe_writedata[addr_cnt*8+:8];
				int_address		= exe_address + addr_cnt;
				if (int_waitrequest && !timeout)
					avmm_nxt = WR_WAIT;
				else if (int_waitrequest && !timeout)
					avmm_nxt = TIMEOUT;
				else begin
					int_write	= 1'b0;
					if (addr_cnt == 3'h3) begin
						addr_cnt_rst = 1'b1;
						avmm_nxt = INIT;
					end else begin
						addr_inc = 3'h1;
						avmm_nxt = WR_REQ;
					end
				end
			end
	RD_REQ:	begin
				avmm_nxt = RD_WAIT;
				int_read		= 1'b1;
				int_address		= exe_address + addr_cnt;
			end
	RD_WAIT:begin
				int_read		= 1'b1;
				int_address		= exe_address + addr_cnt;
				if (int_waitrequest && !timeout)
					avmm_nxt = RD_WAIT;
				else if (int_waitrequest && timeout)
					avmm_nxt = TIMEOUT;
				else begin
					int_read	= 1'b0;
					if (addr_cnt == 3'h3) begin
						addr_cnt_rst = 1'b1;
						avmm_nxt = INIT;
					end else begin
						addr_inc = 3'h1;
						avmm_nxt = RD_REQ;
					end
				end
			end
	TIMEOUT:begin
				avmm_nxt = TIMEOUT;
			end
	endcase
end

always @(posedge user_clk or posedge user_reset)
begin
	if (user_reset)	begin
		exe_readdata	<= 32'h00000000;
		cmd_done		<= 1'b0;
		pma_spico_reset_timeout <= 1'b0;
	end
	else begin
		case (avmm_state)
		INIT:	begin
					cmd_done		<= 1'b0;
					exe_readdata	<= exe_readdata;
				end
		WR_WAIT:begin
					if (!int_waitrequest && addr_cnt == 3'h3) begin
						cmd_done	<= 1'b1;
					end
				end
		RD_REQ:	begin
					if(addr_cnt == 3'h0)
						exe_readdata	<= 32'h00000000;
				end
		RD_WAIT:begin
					exe_readdata	<= exe_readdata;
					if (!int_waitrequest) begin
						exe_readdata[addr_cnt*8+:8] <= int_readdata;
						if (addr_cnt == 3'h3)
							cmd_done	<= 1'b1;
					end
				end
		TIMEOUT:begin
					pma_spico_reset_timeout <= 1'b1;
				end
		default:begin
					exe_readdata	<= exe_readdata;
					cmd_done		<= 1'b0;
					pma_spico_reset_timeout <= 1'b0;
				end
		endcase
	end

end

//control signals

assign timeout = (timer >= AVMM_TIMEOUT);














assign pma_reset_busy		= (ctrl_state != IDLE) & (ctrl_state != PMA_DISABLED) & (ctrl_state != SPICO_DONE) ;

assign avmm_write			= (pma_reset_busy == 1'b0) ? user_write : int_write;
assign avmm_read			= (pma_reset_busy == 1'b0) ? user_read : int_read;
assign avmm_writedata		= (pma_reset_busy == 1'b0) ? user_writedata : int_writedata;
assign avmm_address  		= (pma_reset_busy == 1'b0) ? user_address : int_address;
assign int_readdata			= (pma_reset_busy == 1'b0) ? 8'h00 : avmm_readdata;
assign int_waitrequest		= (pma_reset_busy == 1'b0) ? 1'b1 : avmm_waitrequest;
assign user_readdata	= (pma_reset_busy == 1'b0) ? avmm_readdata : int_readdata;
assign user_waitrequest	= (pma_reset_busy == 1'b0) ? avmm_waitrequest : 1'b1;






endmodule
