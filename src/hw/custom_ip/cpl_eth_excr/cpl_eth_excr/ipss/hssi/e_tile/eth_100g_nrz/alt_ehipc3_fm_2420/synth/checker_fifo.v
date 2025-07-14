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


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module checker_fifo (
	aclr,
	data,
	rdclk,
	rdreq,
	wrclk,
	wrreq,
	q,
	rdempty,
	wrfull);

	input	  aclr;
	input	[287:0]  data;
	input	  rdclk;
	input	  rdreq;
	input	  wrclk;
	input	  wrreq;
	output	[287:0]  q;
	output	  rdempty;
	output	  wrfull;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
	tri0	  aclr;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

/*
	dc_fifo_s10 dcfifo_component (
		.rdclk   (rdclk),   //   input,   width = 1,            .rdclk
		.wrclk   (wrclk),   //   input,   width = 1,            .wrclk
		.wrreq   (wrreq),   //   input,   width = 1,            .wrreq
		.aclr    (aclr),
		.data    (data),    //   input,  width = 72,  fifo_input.datain
		.rdreq   (rdreq),   //   input,   width = 1,            .rdreq
		.wrfull  (wrfull),   //  output,   width = 1,            .wrfull
		.q       (q),       //  output,  width = 72, fifo_output.dataout
		.rdempty (rdempty) //  output,   width = 1,            .rdempty
	);
*/
pcs_scfifo_mlab #(
              .SIM_EMULATE (1),
              .WIDTH       (288)
) Idfifo (
    .clk(wrclk),
    .sclr(aclr),
    .wdata(data[287:0]),
    .wreq(wrreq),
    .full(wrfull),
    .rdata(q[287:0]),
    .rreq(rdreq),
    .empty(rdempty)
);


endmodule
