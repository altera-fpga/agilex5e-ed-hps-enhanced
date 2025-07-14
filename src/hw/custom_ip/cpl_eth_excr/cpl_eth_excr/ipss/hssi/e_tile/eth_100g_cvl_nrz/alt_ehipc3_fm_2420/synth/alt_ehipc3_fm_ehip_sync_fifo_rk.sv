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


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module alt_ehipc3_fm_ehip_sync_fifo_rk
  #(
    parameter DWIDTH = 8,             // FIFO Input data width
    parameter AWIDTH = 4              // FIFO Depth (address width)
    )
    (
    input  wire                   rst_n,     // Write Domain Active low async Reset
    input  wire                   srst_n,    // Write Domain Active low sync Reset
    input  wire                   clk,       // Write Domain Clock
    input  wire                   ena,       //
    input  wire                   wr_en,        // Write Data Enable
    input  wire [DWIDTH-1:0]      wr_data,      // Write Data In
    input  wire                   rd_en,        // Read Data Enable
    input  wire [AWIDTH-1:0]      r_empty,      // FIFO empty threshold
    input  wire [AWIDTH-1:0]      r_full,       // FIFO full threshold

    output wire [DWIDTH-1:0]      rd_data,      // Read Data Out
    output reg [AWIDTH:0]      numdata,   // Number of Data available in Write clock


    output reg                    full,      // FIFO Full
    output reg                    empty     // FIFO Empty

     );

   //********************************************************************
   // Define variables
   //********************************************************************
   integer                   m;
   // Regs
   reg [DWIDTH-1:0]          fifo_mem [((1<<AWIDTH)-1):0];

   // Wires
   reg [AWIDTH-1:0]         wr_addr;
   reg [AWIDTH-1:0]         rd_addr;
   reg [AWIDTH-1:0]         wr_addr_plus_1;
   reg [AWIDTH-1:0]         rd_addr_plus_1;
   reg [AWIDTH:0] 			 numdata_plus_1;
   reg [AWIDTH:0] 			 numdata_minus_1;

   always @(*)
	 begin
		numdata_plus_1 = numdata + 1'b1;
		numdata_minus_1 = numdata - 1'b1;
		rd_addr_plus_1 = rd_addr + 1'b1;
		wr_addr_plus_1 = wr_addr + 1'b1;
	 end


   //********************************************************************
   // Infer Memory or use Flip-flops
   //********************************************************************

   always @(negedge rst_n or posedge clk) begin
	  if (rst_n == 1'b0) begin
         for (m='d0; m<=((1<<AWIDTH)-1'b1); m=m+1'b1) begin
            fifo_mem[m] <= 'd0;
         end
	  end
	  else
      if (ena) begin
         if (wr_en && ~full) begin
            fifo_mem[wr_addr] <= wr_data;
		 end
	  end
   end // always @ (negedge rst_n or posedge clk)

   assign rd_data = fifo_mem[rd_addr];

   always @(negedge rst_n or posedge clk) begin
      if (rst_n == 1'b0) begin
		 wr_addr <= {AWIDTH{1'b0}};
		 rd_addr <= {AWIDTH{1'b0}};
		 numdata <= {(AWIDTH+1){1'b0}};
         full  <= 1'b0;
         empty <= 1'b1;
      end
      else if (ena) begin
		 case ({wr_en,rd_en})
		   2'b10: begin
			  if (wr_en && ~full)
				begin
				   wr_addr <= wr_addr_plus_1;
				   numdata <= numdata_plus_1;
				   if (numdata_plus_1 >= {1'b0,r_full})
					 full <= 1'b1;
				   else
					 full <= 1'b0;
				   empty <= 1'b0;
				end
			  end
		   2'b01:begin
			  if (rd_en & ~empty)
				begin
				   rd_addr <= rd_addr_plus_1;
				   numdata <= numdata_minus_1;
				   if (numdata_minus_1 <= {1'b0,r_empty})
					 empty <= 1'b1;
				   else
					 empty <= 1'b0;
				   full <= 1'b0;
				end
		   end // case: 2'b01

		   2'b11: begin
			  case ({empty,full})
				2'b10: begin
				   wr_addr <= wr_addr_plus_1;
				   empty <= 1'b0;
				   numdata <= numdata_plus_1;
				end
				2'b01: begin
				   rd_addr <= rd_addr_plus_1;
				   full <= 1'b0;
				   numdata <= numdata_minus_1;
				end
				2'b00: begin
				   rd_addr <= rd_addr_plus_1;
				   wr_addr <= wr_addr_plus_1;
				end
			  endcase // case ({empty,full})
		   end // case: 2'b11
		 endcase // case ({wr_en,rd_en})
	  end // if (ena)
   end // always @ (negedge rst_n or posedge clk)
endmodule // alt_ehipc3_fm_ehip_sync_fifo_rk
