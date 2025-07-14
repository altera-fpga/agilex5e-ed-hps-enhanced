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


`timescale 1ns / 1ns

// ---------------------------------------------------------------------------------------------------------------------------------
// 10/Dec/2018 : slim35 : https://hsdes.intel.com/appstore/article/#/2205692107 : Crete 3 hard logic costs too much soft logic.
// Reduce alt_ehipc3_fm_sl_ptp_compute_ts_sn pipeline from 12 to 4 and hence the param needs to be revised.
// Thanks to Gregg for the code enhancement.
// ---------------------------------------------------------------------------------------------------------------------------------
// baeckler - 12-04-2018   revision from original made by (???)

module alt_ehipc3_fm_sl_ptp_compute_ts_sn (
    input                          i_clk,
    input                          i_rst_n,
    input                          i_valid,
    input   [31:0]                 i_correction_value,
    input   [95:0]                 i_input_ts,
    output  [95:0]                 o_corrected_ts
);

wire clk = i_clk;
wire ena = i_valid;

////////////////////////////////////////
// input registers

reg [47:0] sec_r = 48'h0;
reg [31:0] nano_r = 32'h0;
reg [15:0] frac_r = 16'h0;

reg [15:0] fix_nano_r = 32'h0;
reg [15:0] fix_frac_r = 16'h0;

always @(posedge clk) begin
	if (ena) begin
		{sec_r,nano_r,frac_r} <= i_input_ts;
		{fix_nano_r,fix_frac_r} <= i_correction_value;
	end
end

////////////////////////////////////////
// attack terms level 1

reg [15:0] frac_1 = 16'h0 /* synthesis preserve dont_replicate dont_retime */;
reg frac_1_sign = 1'b0;

always @(posedge clk) begin
	if (ena) begin
		{frac_1_sign,frac_1} <= {1'b0,frac_r} - {1'b0,fix_frac_r};
	end
end

// nano minus fix
reg [16:0] nano_lo_a = 17'h0;
reg [16:0] nano_lo_b = 17'h0;
reg [15:0] nano_hi_a = 16'h0;
reg [16:0] nano_hi_b = 17'h0;
always @(posedge clk) begin
	if (ena) begin
		nano_lo_a <= {1'b0,nano_r[15:0]} - {1'b0,fix_nano_r};
		nano_lo_b <= {1'b0,nano_r[15:0]} + ~{1'b0,fix_nano_r};  // like a-(b+1)
		nano_hi_a <= nano_r[31:16];
		nano_hi_b <= {1'b0,nano_r[31:16]} - 1'b1;
	end
end

// seconds
reg [16:0] sec_a = 17'h0;
reg [16:0] sec_b = 17'h0;
reg [16:0] sec_c = 17'h0;
reg [47:0] sec_d = 48'h0;
always @(posedge clk) begin
	if (ena) begin
		sec_a <= {1'b0,sec_r[15:0]} - 1'b1;
		sec_b <= {1'b0,sec_r[31:16]} - 1'b1;
		sec_c <= {1'b0,sec_r[47:32]} - 1'b1;
		sec_d <= sec_r;
	end
end

////////////////////////////////////////
// attack terms level 2

reg [47:0] sec_minus_one = 48'h0;
always @(posedge clk) begin
	if (ena) begin
		sec_minus_one [15:0] <= sec_a[15:0];
		sec_minus_one [31:16] <= sec_a[16] ? sec_b[15:0] : sec_d[31:16];
		sec_minus_one [47:32] <= (sec_a[16] & sec_b[16]) ? sec_c[15:0] : sec_d[47:32];
	end
end

reg [47:0] sec_v2 = 48'h0;
always @(posedge clk) begin
	if (ena) begin
		sec_v2 <= sec_d;
	end
end

reg [15:0] frac_v2 = 16'h0;
always @(posedge clk) begin
	if (ena) begin
		frac_v2 <= frac_1[15:0];
	end
end

reg [31:0] nano_v2 = 32'h0;
reg nano_v2_sign = 1'b0;
always @(posedge clk) begin
	if (ena) begin
		nano_v2[15:0] <= frac_1_sign ? nano_lo_b[15:0] : nano_lo_a[15:0];
		{nano_v2_sign,nano_v2[31:16]} <= (frac_1_sign ? nano_lo_b[16] : nano_lo_a[16]) ?
								nano_hi_b[16:0] : {1'b0,nano_hi_a[15:0]};
	end
end

////////////////////////////////////////
// attack terms level 3

reg [47:0] sec_v3 = 48'h0;
always @(posedge clk) begin
	if (ena) begin
		sec_v3 <= nano_v2_sign ? sec_minus_one : sec_v2;
	end
end

reg [15:0] frac_v3 = 16'h0;
always @(posedge clk) begin
	if (ena) begin
		frac_v3 <= frac_v2;
	end
end

reg [31:0] nano_v3 = 32'h0;
always @(posedge clk) begin
	if (ena) begin
		nano_v3 <= nano_v2 + (nano_v2_sign ? 32'h3b9aca00 : 32'h0);
	end
end

assign o_corrected_ts = {sec_v3,nano_v3,frac_v3};

endmodule
