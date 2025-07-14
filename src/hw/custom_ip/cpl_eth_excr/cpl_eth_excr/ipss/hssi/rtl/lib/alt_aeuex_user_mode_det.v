// ***************************************************************************
// *
// * COPYRIGHT
// * This code  is subject to third-party rights.
// * Restricted use for Intel FPGA based network adaptors is granted.
// *
// ***************************************************************************
//
module alt_reset_delay #(
	parameter CNTR_BITS = 16
)
(
	input clk,
	input ready_in,
	output ready_out
);

reg [2:0] rs_meta = 3'b0 /* synthesis preserve dont_replicate */
/* synthesis ALTERA_ATTRIBUTE = "-name SDC_STATEMENT \"set_false_path -from [get_fanins -async *reset_delay*rs_meta\[*\]] -to [get_keepers *reset_delay*rs_meta\[*\]]\" " */;

always @(posedge clk or negedge ready_in) begin
	if (!ready_in) rs_meta <= 3'b000;
	else rs_meta <= {rs_meta[1:0],1'b1};
end
wire ready_sync = rs_meta[2];

reg [CNTR_BITS-1:0] cntr = {CNTR_BITS{1'b0}} /* synthesis preserve */;
assign ready_out = cntr[CNTR_BITS-1];
always @(posedge clk or negedge ready_sync) begin
	if (!ready_sync) cntr <= {CNTR_BITS{1'b0}};
	else if (!ready_out) cntr <= cntr + 1'b1;
end

endmodule
