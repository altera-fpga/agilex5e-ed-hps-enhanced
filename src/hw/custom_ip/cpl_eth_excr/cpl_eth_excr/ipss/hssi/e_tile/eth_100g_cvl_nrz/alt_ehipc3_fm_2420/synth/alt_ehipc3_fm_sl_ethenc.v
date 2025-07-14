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
// Ethernet 64-66 block encoder.

module alt_ehipc3_fm_sl_ethenc #(
    parameter SIM_EMULATE = 1'b0
) (
        input clk,
        input sclr,
        input [7:0] din_c,
        input [63:0] din_d, // bit 0 first
        output [65:0] dout
);

// Note -
// This is an Ethernet 64/66 encoder operating with the assumption that the TX MAC only sends legal MII
// traffic. The assumption greatly reduces the logic cost, although it will not follow the letter of the
// specification if operated standalone and given an illegal MII sequence (e.g. SOP,SOP,SOP). If the traffic
// is illegal the encoding will be best-effort (but your TX MAC isn't working properly, so there is a larger
// issue to resolve).

localparam MII_IDLE         = 8'h7,     // I
           MII_START        = 8'hfb,    // S
           MII_TERMINATE    = 8'hfd,    // T
           MII_ERROR        = 8'hfe,    // E
           MII_SEQ_ORDERED  = 8'h9c,    // Q aka O
           MII_SIG_ORDERED  = 8'h5c;    // Fsig aka O

localparam BLK_CTRL   = 8'h1e,
           BLK_START  = 8'h78,
           BLK_START2 = 8'h33,
           BLK_OS_2D  = 8'h2d,    //O1,C0 IEEE Fig 49-7
           BLK_OS_66  = 8'h66,    //S1,O0 IEEE Fig 49-7
           BLK_OS_55  = 8'h55,    //O1,O0 IEEE Fig 49-7
           BLK_OS_4B  = 8'h4b,    //C1,O0 IEEE Fig 49-7

           BLK_TERM0 = 8'h87,
           BLK_TERM1 = 8'h99,
           BLK_TERM2 = 8'haa,
           BLK_TERM3 = 8'hb4,
           BLK_TERM4 = 8'hcc,
           BLK_TERM5 = 8'hd2,
           BLK_TERM6 = 8'he1,
           BLK_TERM7 = 8'hff,

           O_CODE_SEQ   = 4'h0;

localparam EBLOCK_T = {{8{7'h1e}},BLK_CTRL,2'b01};
localparam IBLOCK_T = {{8{7'h00}},BLK_CTRL,2'b01};

///////////////////////////////////////////////////
// comparators on the MII input bytes

wire m_start;
alt_ehipc3_fm_sl_eqc9h1fbt2 cmp0 (
    .clk(clk),
    .din({din_c[0],din_d[7:0]}),
    .dout(m_start)
);
defparam cmp0 .SIM_EMULATE = SIM_EMULATE;

wire m_start2;
alt_ehipc3_fm_sl_eqc9h1fbt2 cmp1 (
    .clk(clk),
    .din({din_c[4],din_d[39:32]}),
    .dout(m_start2)
);
defparam cmp1 .SIM_EMULATE = SIM_EMULATE;


wire [7:0] m_term;
genvar i;
generate
        for (i=0; i<8; i=i+1) begin : t
        alt_ehipc3_fm_sl_eqc9h1fdt2 cmp2 (
            .clk(clk),
            .din({din_c[i],din_d[8*(i+1)-1:8*i]}),
            .dout(m_term[i])
        );
        defparam cmp2 .SIM_EMULATE = SIM_EMULATE;

        end
endgenerate

// Check for FE (error) and 9C (ordered set)

wire e0;
alt_ehipc3_fm_sl_eq9t1 cmp3 (
    .clk    (clk),
    .dina   ({din_c[0], din_d[7:0]}),
    .dinb   ({1'b1, 8'hFE}),
    .dout   (e0)
);
defparam cmp3 .SIM_EMULATE = SIM_EMULATE;

wire e1;
alt_ehipc3_fm_sl_eq9t1 cmp4 (
    .clk    (clk),
    .dina   ({din_c[4], din_d[7+32:0+32]}),
    .dinb   ({1'b1, 8'hFE}),
    .dout   (e1)
);
defparam cmp4 .SIM_EMULATE = SIM_EMULATE;

wire o0;
alt_ehipc3_fm_sl_eq9t1 cmp5 (
    .clk    (clk),
    .dina   ({din_c[0], din_d[7:0]}),
    .dinb   ({1'b1, MII_SEQ_ORDERED}),  //MII_SEQ_ORDERED = 8'h9c
    .dout   (o0)
);
defparam cmp5 .SIM_EMULATE = SIM_EMULATE;

wire o1;
alt_ehipc3_fm_sl_eq9t1 cmp6 (
    .clk    (clk),
    .dina   ({din_c[4], din_d[7+32:0+32]}),
    .dinb   ({1'b1, MII_SEQ_ORDERED}),  //MII_SEQ_ORDERED = 8'h9c
    .dout   (o1)
);
defparam cmp6 .SIM_EMULATE = SIM_EMULATE;

reg ord = 1'b0; //ordered sets
reg err = 1'b0;
always @(posedge clk) begin
    ord <=  o0 | o1;
    err <=  e0 | e1;
end

wire m_all_control;
alt_ehipc3_fm_sl_and8t2 c01 (
    .clk(clk),
    .din(din_c),
    .dout(m_all_control)
);
defparam c01 .SIM_EMULATE = SIM_EMULATE;

wire m_any_control_0;
alt_ehipc3_fm_sl_or4t1 c02 (
    .clk(clk),
    .din(din_c[3:0]),
    .dout(m_any_control_0)
);
defparam c02 .SIM_EMULATE = SIM_EMULATE;

wire m_any_control_1;
alt_ehipc3_fm_sl_or4t1 c03 (
    .clk(clk),
    .din(din_c[7:4]),
    .dout(m_any_control_1)
);
defparam c03 .SIM_EMULATE = SIM_EMULATE;

wire m_any_control;
alt_ehipc3_fm_sl_or2t1 c04 (
    .clk(clk),
    .din({m_any_control_1,m_any_control_0}),
    .dout(m_any_control)
);
defparam c04 .SIM_EMULATE = SIM_EMULATE;


wire c0 = m_any_control_0 & (~(m_start  | o0 | m_term[0]| m_term[1] | m_term[2]| m_term[3]));
wire c1 = m_any_control_1 & (~(m_start2 | o1 | m_term[4]| m_term[5] | m_term[6]| m_term[7]));

wire os_2d; //BLK_OS_2D = 8'h2d,//O1,C0 IEEE Fig 49-7
wire os_66; //BLK_OS_66 = 8'h66,//S1,O0 IEEE Fig 49-7
wire os_55; //BLK_OS_55 = 8'h55,//O1,O0 IEEE Fig 49-7
wire os_4b; //BLK_OS_4B = 8'h4b,//C1,O0 IEEE Fig 49-7

reg  os_2d_sel = 1'b0;
reg  os_66_sel = 1'b0;
reg  os_55_sel = 1'b0;
reg  os_4b_sel = 1'b0;


alt_ehipc3_fm_sl_and2t1 order_set_a (
  .clk(clk),
  .din({o1, c0}),
  .dout(os_2d)
);

defparam order_set_a .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_and2t1 order_set_b (
  .clk(clk),
  .din({m_start,o0}),
  .dout(os_66)
);

defparam order_set_b .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_and2t1 order_set_c (
    .clk(clk),
  .din({o1,o0}),
  .dout(os_55)
);

defparam order_set_c .SIM_EMULATE = SIM_EMULATE;

alt_ehipc3_fm_sl_and2t1 order_set_d (
  .clk(clk),
  .din({c1,o0}),
  .dout(os_4b)
);
defparam order_set_d .SIM_EMULATE = SIM_EMULATE;

always @(posedge clk) begin
        os_2d_sel <= os_2d;
        os_66_sel <= os_66;
        os_55_sel <= os_55;
        os_4b_sel <= os_4b;
end

///////////////////////////////////////////////////
// figure out what you want to show

reg [3:0] block_sel = 4'b0;
always @(posedge clk) begin
        block_sel[0] <= (m_term[1] || m_term[3] || m_term[5] || m_term[7] || !m_any_control || err       );
        block_sel[1] <= (m_term[2] || m_term[3] || m_term[6] || m_term[7] || m_start        || err || ord );
        block_sel[2] <= (m_term[4] || m_term[5] || m_term[6] || m_term[7] || m_start2       || err || ord );
        block_sel[3] <= (!m_term[0] && (!m_any_control || m_start || m_start2 || m_all_control ||err )) || ord;
end

///////////////////////////////////////////////////
// match up latency

wire [63:0] raw_data;

alt_ehipc3_fm_sl_delay3w64c d0 (
    .clk(clk),
    .sclr(sclr),
    .din(din_d),
    .dout(raw_data)
);
defparam d0 .SIM_EMULATE = SIM_EMULATE;

///////////////////////////////////////////////////
// output MUX

wire [55:0] packed_control = 56'h0; // idle is 0

wire [65:0] OBLOCK_2D = {raw_data[63:40], O_CODE_SEQ, {4{7'h0}},                   BLK_OS_2D, 2'b01};
wire [65:0] OBLOCK_66 = {raw_data[63:40], 4'h0,       O_CODE_SEQ, raw_data [31:8], BLK_OS_66, 2'b01};
wire [65:0] OBLOCK_55 = {raw_data[63:40], O_CODE_SEQ, O_CODE_SEQ, raw_data [31:8], BLK_OS_55, 2'b01};
wire [65:0] OBLOCK_4B = {{4{7'h0}},                   O_CODE_SEQ, raw_data [31:8], BLK_OS_4B, 2'b01};

reg [65:0] encoded_block = 66'b0 /* synthesis preserve */;
always @(posedge clk) begin
        case (block_sel)
                4'h0 : encoded_block <= {packed_control[55:7],7'b0,BLK_TERM0,2'b01};
                4'h1 : encoded_block <= {packed_control[55:14],6'b0,raw_data[7:0],BLK_TERM1,2'b01};
                4'h2 : encoded_block <= {packed_control[55:21],5'b0,raw_data[15:0],BLK_TERM2,2'b01};
                4'h3 : encoded_block <= {packed_control[55:28],4'b0,raw_data[23:0],BLK_TERM3,2'b01};
                4'h4 : encoded_block <= {packed_control[55:35],3'b0,raw_data[31:0],BLK_TERM4,2'b01};
                4'h5 : encoded_block <= {packed_control[55:42],2'b0,raw_data[39:0],BLK_TERM5,2'b01};
                4'h6 : encoded_block <= {packed_control[55:49],1'b0,raw_data[47:0],BLK_TERM6,2'b01};
                4'h7 : encoded_block <= {raw_data[55:0],BLK_TERM7,2'b01};
                4'h8 : encoded_block <= IBLOCK_T;
                4'h9 : encoded_block <= {raw_data,2'b10};
                4'ha : encoded_block <= {raw_data[63:8],BLK_START,2'b01};
                4'hb : encoded_block <= EBLOCK_T;
                4'hc : encoded_block <= {raw_data[63:40], 4'h0, {4{7'h0}}, BLK_START2,2'b01};
                4'hd : encoded_block <= EBLOCK_T;
                4'he : encoded_block <= os_2d_sel? OBLOCK_2D : os_66_sel? OBLOCK_66 : os_55_sel? OBLOCK_55 : os_4b_sel? OBLOCK_4B : EBLOCK_T;
                4'hf : encoded_block <= EBLOCK_T;
        endcase
end
assign dout = encoded_block;
endmodule
