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




`timescale 1ps/1ps

// DESCRIPTION
// Ethernet style descrambler for 64 bit data.

module alt_ehipc3_fm_sl_descram64 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input din_valid,
    input [63:0] din,
    output [63:0] dout,
    output dout_valid
);

localparam WIDTH = 64;

reg [57:0] scram_state = {58{1'b1}};
wire [WIDTH+58-1:0] history;
wire [WIDTH-1:0] dout_w;
reg [WIDTH-1:0] dout_r = {WIDTH{1'b0}};
assign history = {din,scram_state};

genvar i;
generate
	for (i=0; i<WIDTH; i=i+1) begin : lp
		alt_ehipc3_fm_sl_lut6 w (
			.din({history[58+i-58],
			  history[58+i-39],
			  history[58+i],
			  3'b0}),
			.dout(dout_w[i]));
		defparam w .MASK = 64'h6996966996696996;
		defparam w .SIM_EMULATE = SIM_EMULATE;

	end
endgenerate

always @(posedge clk) begin
	if (din_valid) scram_state <= history[WIDTH+58-1:WIDTH];
	dout_r <= dout_w;
end
assign dout = dout_r;

reg din_valid_r = 1'b0;
always @(posedge clk) din_valid_r <= din_valid;
assign dout_valid = din_valid_r;

endmodule
