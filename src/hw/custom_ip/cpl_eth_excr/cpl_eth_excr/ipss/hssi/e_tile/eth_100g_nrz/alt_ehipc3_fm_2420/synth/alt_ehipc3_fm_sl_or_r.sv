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



`timescale 1 ps / 1 ps

// DESCRIPTION
//
// This is a registered variable width OR gate. Note that the latency will depend on the input width. The
// Verilog contains some very basic factoring heuristics that may need to be expanded in the future.
// Simulation stops with an error message if the requested width requires additional rules.
//


module alt_ehipc3_fm_sl_or_r #(
	parameter WIDTH = 8
)(
	input clk,
	input [WIDTH-1:0] din,
	output dout
);

genvar i;
generate
	if (WIDTH <= 6) begin
		reg dout_r = 1'b0;
		always @(posedge clk) dout_r <= |din;
		assign dout = dout_r;
	end
	else if ((WIDTH % 6) == 0) begin
		localparam NUM_HEXES = WIDTH / 6;
		wire [NUM_HEXES-1:0] tmp;
		for (i=0; i<NUM_HEXES; i=i+1) begin : lp
			alt_ehipc3_fm_sl_or_r a (.clk(clk),.din(din[(i+1)*6-1:i*6]),.dout(tmp[i]));
			defparam a .WIDTH = 6;
		end
		alt_ehipc3_fm_sl_or_r h (.clk(clk),.din(tmp),.dout(dout));
		defparam h .WIDTH = NUM_HEXES;
	end
	else if ((WIDTH % 5) == 0) begin
		localparam NUM_QUINTS = WIDTH / 5;
		wire [NUM_QUINTS-1:0] tmp;
		for (i=0; i<NUM_QUINTS; i=i+1) begin : lp
			alt_ehipc3_fm_sl_or_r a (.clk(clk),.din(din[(i+1)*5-1:i*5]),.dout(tmp[i]));
			defparam a .WIDTH = 5;
		end
		alt_ehipc3_fm_sl_or_r h (.clk(clk),.din(tmp),.dout(dout));
		defparam h .WIDTH = NUM_QUINTS;
	end
	else if ((WIDTH % 4) == 0) begin
		localparam NUM_QUADS = WIDTH / 4;
		wire [NUM_QUADS-1:0] tmp;
		for (i=0; i<NUM_QUADS; i=i+1) begin : lp
			alt_ehipc3_fm_sl_or_r a (.clk(clk),.din(din[(i+1)*4-1:i*4]),.dout(tmp[i]));
			defparam a .WIDTH = 4;
		end
		alt_ehipc3_fm_sl_or_r h (.clk(clk),.din(tmp),.dout(dout));
		defparam h .WIDTH = NUM_QUADS;
	end
	else begin
		initial begin
			$display ("Oops - no pipelined gate pattern available for width %d",WIDTH);
			$display ("Please add");
			$stop();
		end
	end
endgenerate

endmodule


// BENCHMARK INFO :  10AX115U2F45I2SGE2
// BENCHMARK INFO :  Quartus Prime Version 15.1.0 Internal Build 99 06/10/2015 TO Standard Edition
// BENCHMARK INFO :  Uses helper file :  alt_or_r.v
// BENCHMARK INFO :  Max depth :  1.0 LUTs
// BENCHMARK INFO :  Total registers : 3
// BENCHMARK INFO :  Total pins : 10
// BENCHMARK INFO :  Total virtual pins : 0
// BENCHMARK INFO :  Total block memory bits : 0
// BENCHMARK INFO :  Comb ALUTs :  3
// BENCHMARK INFO :  ALMs : 2 / 427,200 ( < 1 % )
// BENCHMARK INFO :  Worst setup path @ 468.75MHz : 0.484 ns, From alt_or_r:h|dout_r, To dout}
