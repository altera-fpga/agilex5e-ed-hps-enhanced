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

module alt_ehipc3_fm_sl_etag (
   input clk,
   input srst,
   input din_valid,
   input din_am,
   input [65:0] din,
   output reg [65:0] dout,
   output reg dout_valid
);

reg [1:0] ctr;
always @(posedge clk) begin
   if (srst | ~din_am) begin
      ctr <= 2'h0;
   end else if (din_valid) begin
      ctr <= ctr + 2'h1;
   end
end

// Determine if we are going with the IEEE and current consortium
// alignment markers, or the original consortium alignment markers
`ifdef ORIGINAL_CONSORTIUM
localparam M20_0 = 24'h477690;
localparam BIP3_0  = 8'h0;
`else
localparam M20_0 = 24'h2168c1;
localparam BIP3_0  = 8'h33;
`endif

localparam M20_1 = 24'he6c4f0;
localparam M20_2 = 24'h9b65c5;
localparam M20_3 = 24'h3d79a2;
localparam BIP3  = 8'h0;
localparam SH  = 2'b01;

always @(posedge clk) begin
   if (~din_am) begin
      dout <= din;
   end else begin
      case (ctr)
         0: dout <= {~BIP3_0, ~M20_0, BIP3_0, M20_0, SH};
         1: dout <= {~BIP3,   ~M20_1, BIP3,   M20_1, SH};
         2: dout <= {~BIP3,   ~M20_2, BIP3,   M20_2, SH};
         3: dout <= {~BIP3,   ~M20_3, BIP3,   M20_3, SH};
      endcase
   end
end

always @(posedge clk) begin
   dout_valid <= din_valid;
end

endmodule
