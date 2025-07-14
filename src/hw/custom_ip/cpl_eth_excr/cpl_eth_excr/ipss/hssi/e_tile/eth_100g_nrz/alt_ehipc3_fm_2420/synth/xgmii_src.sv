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

`define FRAME_TYPE_CONSTANT  4'b0001
`define FRAME_TYPE_INCREMENT 4'b0010
`define FRAME_TYPE_RANDOM    4'b0100
`define FRAME_TYPE_CRC       4'b1000

`define DSM_INTER_FRAME      3'h0
`define DSM_PREAMBLE         3'h1
`define DSM_SFD              3'h2
`define DSM_DATA             3'h3
`define DSM_EFD              3'h4

`define XGMII_IDLE_D        64'h0707_0707_0707_0707
`define XGMII_IDLE_C         8'b11111111
`define XGMII_PREAMBLE_D    256'hABAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAFB
`define XGMII_PREAMBLE_C     32'h0000_0001
`define XGMII_DATA_C         8'b00000000
`define XGMII_START          8'hFB
`define XGMII_TERMINATE      8'hFD
`define XGMII_TXERROR        8'hFE
`define XGMII_IDLE           8'h07
`define XGMII_SEQOS          8'h9C //sequence order set
`define XGMII_RESERVED0      8'h1C
`define XGMII_RESERVED1      8'h3C
`define XGMII_RESERVED2      8'h7C
`define XGMII_RESERVED3      8'hBC
`define XGMII_RESERVED4      8'hDC
`define XGMII_RESERVED5      8'hFC
`define XGMII_SIGOS          8'h5C //signal order set
`define XGMII_CCNUM          12

`define FRAME_CONSTANT      64'h0000_0000_0000_0000
`define CRC_INIT            64'h2A26F826_2A26F826

`define POLYNOMIAL          33'h104C11DB7
`define PWIDTH              32
`define QWIDTH              32

`define POLYNOMIAL8          9'b1_0000_0111
`define PWIDTH8              8
`define QWIDTH8              8

module xgmii_src
# (
  parameter ENABLE_RSFEC = 0
)

(
	input          xgmii_tx_clk,
	input          reset,
	input          frame_sof,
	input   [11:0] frame_length,
	input    [3:0] frame_type,
	input   [15:0] frame_ifg,
	input   [255:0] frame_constant,
	input			o_tx_lanes_stable,
	input			i_tx_mii_ready,
	input			o_rx_pcs_ready,
	output reg     frame_done,
    output reg	   o_tx_mii_valid,

	output  reg [255:0] xgmii_tx_d,
	output  reg [31:0] xgmii_tx_c,
	output  reg		o_tx_mii_am,
	input          xgmii_rx_clk,
	input   [255:0] xgmii_rx_d,
	input    [31:0] xgmii_rx_c,

	output  [255:0] xgmii_rx_d_mon,
	output   [31:0] xgmii_rx_c_mon,
	output  reg [255:0] xgmii_tx_d_mon,
	output  reg  [31:0] xgmii_tx_c_mon
); // module xgmii_src

	reg         [255:0] last_tx_d;
	reg          [2:0] dsm;
	reg         [11:0] f_length;
	reg          [4:0] f_type;
	reg         [255:0] f_crc;
//	reg        [127:0] align_d_buf;
//	reg         [63:0] align_d;
//	reg         [15:0] align_c_buf;
//	reg          [7:0] align_c;
//	reg        [127:0] align_d_buf2;
//	reg         [15:0] align_c_buf2;
//	integer            bytesent;
	reg         [12:0] bytesent;
//	integer            byteslip;
	integer            i;
    wire 			inc_c;
    reg 				inc;
    reg   			mii_valid;
    reg   			mii_am;
	wire			am_pulse;
  reg       store_frame_sof;

function [0:0] CheckControlCode;
input [(`QWIDTH-1):0] data;
reg		[0:0]						match;
reg		[7:0]						lane;
integer							        i,j;
reg [7:0] XGMII_CONTROL_CODE [0:`XGMII_CCNUM-1];
begin
        XGMII_CONTROL_CODE [0:`XGMII_CCNUM-1]= '{`XGMII_IDLE, `XGMII_START, `XGMII_TERMINATE, `XGMII_TXERROR, `XGMII_SEQOS, `XGMII_RESERVED0, `XGMII_RESERVED1,`XGMII_RESERVED2,`XGMII_RESERVED3,`XGMII_RESERVED4,`XGMII_RESERVED5,`XGMII_SIGOS};
	match=0;
	for (i=0;i<4;i=i+1) begin
		for (j=0;j<`XGMII_CCNUM;j=j+1) begin
			lane = data[(i*8)+:8];
			match = (lane==XGMII_CONTROL_CODE[j])? 1'b1 : match;
	  end
  end
  CheckControlCode=match;
end
endfunction

function [(`QWIDTH-1):0] crc32;
	input [(`PWIDTH-1):0] p;
	input [(`QWIDTH-1):0] ini;

	reg   [(`PWIDTH-1):0] p;
	reg   [(`QWIDTH-1):0] ini;
	reg   [(`PWIDTH+1):0] poly;
	reg   [(`QWIDTH-1):0] r;
	integer               j;

	begin
		r = ini;
		poly = `POLYNOMIAL;

		for (j=0; j<`PWIDTH; j=j+1) begin
			if (r[`QWIDTH-1]) begin
				r[(`QWIDTH-1):1] = r[(`QWIDTH-2):0];
				r[0] = p[(`PWIDTH-1)-j];
				r = r^poly[(`QWIDTH-1):0];
			end else begin
				r[(`QWIDTH-1):1] = r[(`QWIDTH-2):0];
				r[0] = p[(`PWIDTH-1)-j];
			end
		end

		if (CheckControlCode(r)) begin
			r[31: 0] = r[31: 0]>>1;
		end

		crc32 = r;

	end
endfunction

function [(`QWIDTH8-1):0] crc8;
	input [(`PWIDTH8-1):0] p;
	input [(`QWIDTH8-1):0] ini;

	reg   [(`PWIDTH8-1):0] p;
	reg   [(`QWIDTH8-1):0] ini;
	reg   [(`PWIDTH8+1):0] poly;
	reg   [(`QWIDTH8-1):0] r;
	integer                j;

	begin
		r = ini;
		poly = `POLYNOMIAL8;

		for (j=0; j<`PWIDTH8; j=j+1) begin
			if (r[`QWIDTH8-1]) begin
				r[(`QWIDTH8-1):1] = r[(`QWIDTH8-2):0];
				r[0] = p[(`PWIDTH8-1)-j];
				r = r^poly[(`QWIDTH8-1):0];
			end else begin
				r[(`QWIDTH8-1):1] = r[(`QWIDTH8-2):0];
				r[0] = p[(`PWIDTH8-1)-j];
			end
		end

		crc8 = r;

	end
endfunction

wire  [255:0]	last_tx_d_0  = {32{last_tx_d[7:0] + 8'h20}};
wire  [12:0]    f_lenght_new = f_length[11:0] - 12'd32;
wire            frame_over = (bytesent[12:0] < f_lenght_new[12:0]);

always @(posedge xgmii_tx_clk or posedge reset) begin
	if (reset) begin
		dsm        <= `DSM_INTER_FRAME;
		xgmii_tx_c <= {`XGMII_IDLE_C, `XGMII_IDLE_C, `XGMII_IDLE_C, `XGMII_IDLE_C};
		xgmii_tx_d <= {`XGMII_IDLE_D, `XGMII_IDLE_D, `XGMII_IDLE_D, `XGMII_IDLE_D};
		frame_done <= 1'b0;
		last_tx_d  <= 256'h1F1E_1D1C_1B1A_1918_1716_1514_1312_1110_0F0E_0D0C_0B0A_0908_0706_0504_0302_0100;
		bytesent   <= 0;
		f_crc      <= {`CRC_INIT, `CRC_INIT, `CRC_INIT, `CRC_INIT};
    store_frame_sof <= 1'b0;
	end else begin
		case (dsm)

			`DSM_INTER_FRAME: begin
				if (frame_sof & !inc_c) begin
          store_frame_sof <= 1'b1;
        end else if ((store_frame_sof || frame_sof ) & inc_c) begin
					f_length <= frame_length;
					f_type <= frame_type;
					dsm <= `DSM_PREAMBLE;
          store_frame_sof <= 1'b0;
				end else begin
					dsm <= `DSM_INTER_FRAME;
				end
				xgmii_tx_c <= {`XGMII_IDLE_C, `XGMII_IDLE_C, `XGMII_IDLE_C, `XGMII_IDLE_C};
				xgmii_tx_d <= {`XGMII_IDLE_D, `XGMII_IDLE_D, `XGMII_IDLE_D, `XGMII_IDLE_D};
				frame_done <= 1'b0;
			end

			`DSM_PREAMBLE: begin
				if (inc_c)
					dsm <= `DSM_DATA;
				else
					dsm <= `DSM_PREAMBLE;
				xgmii_tx_c <= `XGMII_PREAMBLE_C;
				xgmii_tx_d <= `XGMII_PREAMBLE_D;
				frame_done <= 1'b0;
				bytesent <= 0;
				f_crc      <= {`CRC_INIT, `CRC_INIT, `CRC_INIT, `CRC_INIT};
			end

			`DSM_DATA: begin
				xgmii_tx_c <= {`XGMII_DATA_C, `XGMII_DATA_C,`XGMII_DATA_C,`XGMII_DATA_C};
				frame_done <= 1'b0;
				case (f_type & 4'b0111 & {4{inc_c}})

					`FRAME_TYPE_CONSTANT: begin
						xgmii_tx_d <= frame_constant;
					end

					`FRAME_TYPE_INCREMENT: begin
						xgmii_tx_d <= last_tx_d;
						//last_tx_d  <= last_tx_d + 256'h2020_2020_2020_2020_2020_2020_2020_2020_2020_2020_2020_2020_2020_2020_2020_2020;
						last_tx_d  <= last_tx_d_0;
					end

					`FRAME_TYPE_RANDOM: begin
						xgmii_tx_d       <= last_tx_d;
						//last_tx_d  <= last_tx_d_0;
                                                last_tx_d[255:248] <= crc8(8'h0, last_tx_d[255:248]);
                                                last_tx_d[247:240] <= crc8(8'h0, last_tx_d[247:240]);
                                                last_tx_d[239:232] <= crc8(8'h0, last_tx_d[239:232]);
                                                last_tx_d[231:224] <= crc8(8'h0, last_tx_d[231:224]);
                                                last_tx_d[223:216] <= crc8(8'h0, last_tx_d[223:216]);
                                                last_tx_d[215:208] <= crc8(8'h0, last_tx_d[215:208]);
                                                last_tx_d[207:200] <= crc8(8'h0, last_tx_d[207:200]);
                                                last_tx_d[199:192] <= crc8(8'h0, last_tx_d[199:192]);
                                                last_tx_d[191:184] <= crc8(8'h0, last_tx_d[191:184]);
                                                last_tx_d[183:176] <= crc8(8'h0, last_tx_d[183:176]);
                                                last_tx_d[175:168] <= crc8(8'h0, last_tx_d[175:168]);
                                                last_tx_d[167:160] <= crc8(8'h0, last_tx_d[167:160]);
                                                last_tx_d[159:152] <= crc8(8'h0, last_tx_d[159:152]);
                                                last_tx_d[151:144] <= crc8(8'h0, last_tx_d[151:144]);
                                                last_tx_d[143:136] <= crc8(8'h0, last_tx_d[143:136]);
                                                last_tx_d[135:128] <= crc8(8'h0, last_tx_d[135:128]);
                                                last_tx_d[127:120] <= crc8(8'h0, last_tx_d[127:120]);
                                                last_tx_d[119:112] <= crc8(8'h0, last_tx_d[119:112]);
                                                last_tx_d[111:104] <= crc8(8'h0, last_tx_d[111:104]);
                                                last_tx_d[103: 96] <= crc8(8'h0, last_tx_d[103:96]);
                                                last_tx_d[95 : 88] <= crc8(8'h0, last_tx_d[95:88]);
                                                last_tx_d[87 : 80] <= crc8(8'h0, last_tx_d[87:80]);
                                                last_tx_d[79 : 72] <= crc8(8'h0, last_tx_d[79:72]);
                                                last_tx_d[71 : 64] <= crc8(8'h0, last_tx_d[71:64]);
                                                last_tx_d[63 : 56] <= crc8(8'h0, last_tx_d[63:56]);
                                                last_tx_d[55 : 48] <= crc8(8'h0, last_tx_d[55:48]);
                                                last_tx_d[47 : 40] <= crc8(8'h0, last_tx_d[47:40]);
                                                last_tx_d[39 : 32] <= crc8(8'h0, last_tx_d[39:32]);
                                                last_tx_d[31 : 24] <= crc8(8'h0, last_tx_d[31:24]);
                                                last_tx_d[23 : 16] <= crc8(8'h0, last_tx_d[23:16]);
                                                last_tx_d[15 : 8]  <= crc8(8'h0, last_tx_d[15: 8]);
                                                last_tx_d[7  : 0]  <= crc8(8'h0, last_tx_d[ 7: 0]);
						//last_tx_d[255:224]<= crc32(64'h0, last_tx_d[255:224]);
						//last_tx_d[223:192] <= crc32(64'h0, last_tx_d[223:192]);
						//last_tx_d[191:160] <= crc32(64'h0, last_tx_d[191:160]);
						//last_tx_d[159:128] <= crc32(64'h0, last_tx_d[159:128]);
						//last_tx_d[127: 96] <= crc32(64'h0, last_tx_d[127:96]);
						//last_tx_d[95 : 64] <= crc32(64'h0, last_tx_d[95:64]);
						//last_tx_d[63 : 32] <= crc32(64'h0, last_tx_d[63:32]);
						//last_tx_d[31 : 0] <= crc32(64'h0, last_tx_d[31: 0]);
					end

					default: begin
						xgmii_tx_d <= 'b0;
					end


				endcase // case (f_type & 4'b0111)

						//f_crc[255:224] <= crc32(xgmii_tx_d[255:224], f_crc[255:224]);
						//f_crc[223:192] <= crc32(xgmii_tx_d[223:192], f_crc[223:192]);
						//f_crc[191:160] <= crc32(xgmii_tx_d[191:160], f_crc[191:160]);
						//f_crc[159:128] <= crc32(xgmii_tx_d[159:128], f_crc[159:128]);
						//f_crc[127: 96] <= crc32(xgmii_tx_d[127: 96], f_crc[127: 96]);
						//f_crc[95 : 64] <= crc32(xgmii_tx_d[95 : 64], f_crc[95 : 64]);
						//f_crc[63 : 32] <= crc32(xgmii_tx_d[63 : 32], f_crc[63 : 32]);
						//f_crc[31 :  0] <= crc32(xgmii_tx_d[31 :  0], f_crc[31 :  0]);
//                 f_crc[255:248] <= crc8(xgmii_tx_d[255:248], f_crc[255:248]);
//                 f_crc[247:240] <= crc8(xgmii_tx_d[247:240], f_crc[247:240]);
//                 f_crc[239:232] <= crc8(xgmii_tx_d[239:232], f_crc[239:232]);
//                 f_crc[231:224] <= crc8(xgmii_tx_d[231:224], f_crc[231:224]);
//                 f_crc[223:216] <= crc8(xgmii_tx_d[223:216], f_crc[223:216]);
//                 f_crc[215:208] <= crc8(xgmii_tx_d[215:208], f_crc[215:208]);
//                 f_crc[207:200] <= crc8(xgmii_tx_d[207:200], f_crc[207:200]);
//                 f_crc[199:192] <= crc8(xgmii_tx_d[199:192], f_crc[199:192]);
//                 f_crc[191:184] <= crc8(xgmii_tx_d[191:184], f_crc[191:184]);
//                 f_crc[183:176] <= crc8(xgmii_tx_d[183:176], f_crc[183:176]);
//                 f_crc[175:168] <= crc8(xgmii_tx_d[175:168], f_crc[175:168]);
//                 f_crc[167:160] <= crc8(xgmii_tx_d[167:160], f_crc[167:160]);
//                 f_crc[159:152] <= crc8(xgmii_tx_d[159:152], f_crc[159:152]);
//                 f_crc[151:144] <= crc8(xgmii_tx_d[151:144], f_crc[151:144]);
//                 f_crc[143:136] <= crc8(xgmii_tx_d[143:136], f_crc[143:136]);
//                 f_crc[135:128] <= crc8(xgmii_tx_d[135:128], f_crc[135:128]);
//                 f_crc[127:120] <= crc8(xgmii_tx_d[127:120], f_crc[127:120]);
//                 f_crc[119:112] <= crc8(xgmii_tx_d[119:112], f_crc[119:112]);
//                 f_crc[111:104] <= crc8(xgmii_tx_d[111:104], f_crc[111:104]);
//                 f_crc[103: 96] <= crc8(xgmii_tx_d[103:96], f_crc[103:96]);
//                 f_crc[95 : 88] <= crc8(xgmii_tx_d[95:88], f_crc[95:88]);
//                 f_crc[87 : 80] <= crc8(xgmii_tx_d[87:80], f_crc[87:80]);
//                 f_crc[79 : 72] <= crc8(xgmii_tx_d[79:72], f_crc[79:72]);
//                 f_crc[71 : 64] <= crc8(xgmii_tx_d[71:64], f_crc[71:64]);
//                 f_crc[63 : 56] <= crc8(xgmii_tx_d[63:56], f_crc[63:56]);
//                 f_crc[55 : 48] <= crc8(xgmii_tx_d[55:48], f_crc[55:48]);
//                 f_crc[47 : 40] <= crc8(xgmii_tx_d[47:40], f_crc[47:40]);
//                 f_crc[39 : 32] <= crc8(xgmii_tx_d[39:32], f_crc[39:32]);
//                 f_crc[31 : 24] <= crc8(xgmii_tx_d[31:24], f_crc[31:24]);
//                 f_crc[23 : 16] <= crc8(xgmii_tx_d[23:16], f_crc[23:16]);
//                 f_crc[15 : 8]  <= crc8(xgmii_tx_d[15:8], f_crc[15: 8]);
//                 f_crc[7  : 0]  <= crc8(xgmii_tx_d[7:0], f_crc[ 7: 0]);

				if (frame_over || ~inc_c) begin
					dsm <= `DSM_DATA;
				end else begin
					dsm <= `DSM_EFD;
					//if ((f_type & 4'b1000) == `FRAME_TYPE_CRC) begin
					//	xgmii_tx_d <= ~f_crc;
					//end
				end
				bytesent <= {1'b0,bytesent[11:0]} + 13'd32;
			end

			`DSM_EFD: begin
				if (inc_c)
					dsm <= `DSM_INTER_FRAME;
				else
					dsm <= `DSM_EFD;
				xgmii_tx_c <= 32'hFFFFFFFF;
				xgmii_tx_d <= 256'h07070707_07070707_07070707_07070707_07070707_07070707_07070707_070707FD;
				frame_done <= 1'b1;
			end

		endcase // case (dsm)
	end
end


assign xgmii_rx_d_mon = xgmii_rx_d;
assign xgmii_rx_c_mon = xgmii_rx_c;


assign  inc_c   =   i_tx_mii_ready && (!am_pulse) && o_rx_pcs_ready;

//Register the increment signal, the ready signal, and the valid signal
//for use in the next stage
always @(posedge xgmii_rx_clk) begin
	if(~o_tx_lanes_stable)begin
        inc         	<=  1'b0;
        mii_valid   	<=  1'b0;
        mii_am      	<=  1'b0;
		o_tx_mii_valid  <=  1'b0;
    end
    else begin
        inc         	<=  inc_c && o_rx_pcs_ready;
        mii_am      	<=  am_pulse;     //... and am_pulse becomes am
        mii_valid   	<=  i_tx_mii_ready; //Ready becomes valid
		o_tx_mii_valid  <=  mii_valid;
    end
end

//Register the output
//always @(posedge xgmii_rx_clk) begin
//	o_tx_mii_am 	<= mii_am;
//	xgmii_tx_d_mon 	<= xgmii_tx_d;
//	xgmii_tx_c_mon 	<= xgmii_tx_c;
//end

assign	o_tx_mii_am 	= mii_am;
assign	xgmii_tx_d_mon 	= xgmii_tx_d;
assign 	xgmii_tx_c_mon 	= xgmii_tx_c;



   //An AM counter is used to drive the alignment marker at the required
   //period
   am_counter_simonly
    #(
     .ENABLE_RSFEC(ENABLE_RSFEC)
   ) u_am_count (
		 .i_clk                          (xgmii_rx_clk                 ),
		 .i_rst_n                        (o_tx_lanes_stable            ),
		 .i_valid                        (i_tx_mii_ready               ),
     .o_am                           (am_pulse                   )
		 );

endmodule





//=============================================================================
//=============================================================================
// The am_counter tracks the spaces between alignment markers, and the width
// of the alignment marker itself.
// This one produces a gap of 315 cycles, and a pulse of 5 cycles,
// corresponding to the settings for 100G SIM_ONLY mode
//
//=============================================================================
//Module Declaration

module am_counter_simonly
# (
  parameter ENABLE_RSFEC = 0
)
(
    input   wire               i_clk,
    input   wire               i_rst_n,
    input   wire               i_valid,
    output  reg                o_am
);


//=============================================================================
//Declarations

    reg    [16:0]       gap_count;
    reg                end_gap_r;
    wire               do_pulse;
    logic              st_en;
    logic              st_en_1;

//=============================================================================
//Main Body of Code

    always_ff @(posedge i_clk)
      begin
         if(~i_rst_n)
           begin
              st_en     <= 1'b0;
              st_en_1   <= 1'b0;
          end
         else
           begin
              st_en     <= i_valid ? 1'b1 : st_en;
              st_en_1   <= ((!i_valid)&&st_en) ? 1'b1 : st_en_1;
           end
      end

    //Use a 9bit counter for the sim_only AM gap
    always @(posedge i_clk)
      begin

         if(~i_rst_n)
           begin
              gap_count <= 1'b0;
              end_gap_r <= 1'b0;
           end
         else
           if (i_valid&& st_en_1)
           begin
                localparam  GAPCOUNT = ENABLE_RSFEC ? 11'h4ff : 11'h13F;
      `ifdef ALTERA_RESERVED_QIS
                if (gap_count != 17'h13ffF)     // 13Fff = 81919+1=81920 as am_period is set to 81915 + 5 High = 81920
			`else
              if (gap_count != GAPCOUNT )     // 13F = 320 as am_period is set to 315 + 5 High = 320
			`endif
                  begin
                     gap_count <= gap_count + 1;
                     end_gap_r <= 1'b0;
                  end
                else
                  begin
                     gap_count <= 1'b0;
                     end_gap_r <= 1'b1;
                  end;
             end
           else
             begin
                gap_count <= gap_count;
                end_gap_r <= end_gap_r;
             end
      end // always_ff @




/*
    //Use a tiny counter to generate do_pulse
    always_ff @(posedge i_clk)
    if(~i_rst_n)    end_gap_r <=  1'b0;
    else            end_gap_r <=  !i_valid   ?  end_gap_r:
                                                &gap_count;   //gap_count[8] is the end gap signal
*/
    //Assert do_pulse when the gap count terminal is reached, gap count is 4, we need to keep do_pulse "1" for 5 cycles
	`ifdef ALTERA_RESERVED_QIS
		assign  do_pulse  =   end_gap_r || (gap_count[16:3]== 6'd0 && (gap_count[2:0] == 3'd1 || gap_count[2:0] == 3'd2 || gap_count[2:0] == 3'd3 || gap_count[2:0] == 3'd4));
	`else
		assign  do_pulse    =   gap_count == 11'd5 || gap_count == 11'd6 || gap_count == 11'd2 || gap_count == 11'd3 || gap_count == 11'd4;
	`endif

//    assign  do_pulse    =  gap_count[8:2] == 8'd0

    //========================================================================
    //Register the do_pulse signal

    //Register the output
    always @(posedge i_clk)
    if(~i_rst_n)    o_am    <=  1'b0;
    else            o_am    <=  do_pulse;

endmodule
