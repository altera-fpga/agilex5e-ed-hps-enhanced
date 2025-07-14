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


module reset_timer (
   input clk,
   input reset,
   input start,
   output reg pulse1,
   output reg pulse2
);

reg start_r;
always @(posedge clk) begin
   if (reset) begin
      start_r <= 1'b0;
   end else begin
      start_r <= start;
   end
end
wire start_pulse = start & ~start_r;

reg [4:0] count;
reg count_enable;
wire count16 = (count == 16);
always @(posedge clk) begin
   if (reset | count16) begin
      count_enable <= 1'b0;
   end else if (start_pulse) begin
      count_enable <= 1'b1;
   end
end

always @(posedge clk) begin
   if (reset | ~count_enable) begin
      count <= 'd0;
   end else begin
      count <= count + 1'd1;
   end
end

wire count1 = (count == 1);
wire count6 = (count == 6);
always @(posedge clk) begin
   if (reset | count6) begin
      pulse1 <= 1'b0;
   end else if (count1) begin
      pulse1 <= 1'b1;
   end
end

wire count14 = (count == 5'd14);
always @(posedge clk) begin
   if (reset)
   pulse2 <= 1'b0;
   else
   pulse2 <= count14;
end

endmodule
