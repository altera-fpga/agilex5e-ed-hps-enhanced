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
// Ethernet 64-66 block decoder.

module alt_ehipc3_fm_sl_ethdec #(
    parameter SIM_EMULATE = 1'b0
) (
        input clk,
        input [65:0] din,
        output [7:0] dout_c,
        output [63:0] dout_d // bit 0 first
);


localparam MII_IDLE = 8'h7,            // I
        MII_START = 8'hfb,            // S
        MII_TERMINATE = 8'hfd,        // T
        MII_ERROR = 8'hfe,            // E
        MII_SEQ_ORDERED = 8'h9c,    // Q aka O
        MII_SIG_ORDERED = 8'h5c;    // Fsig aka O

////////////////////////////////////////////////////

wire [65:0] block = din;
reg bad_blk = 1'b0;

//
wire [3:0]   bt_0, bt_1;
assign  bt_0 = block[5:2];
assign  bt_1 = block[9:6];

// Checking mirroring/flipping of control bytes (1/2)
wire    equal, equal_0, equal_1;
wire    rever, rever_0, rever_1;
alt_ehipc3_fm_sl_eq4t1 eq (
    .clk    (clk),
    .dina   (bt_0),
    .dinb   (bt_1),
    .dout   (equal),
    .dout_l (equal_0),
    .dout_h (equal_1)
);

alt_ehipc3_fm_sl_eq4t1 rv (
    .clk    (clk),
    .dina   (bt_0),
    .dinb   (~bt_1),
    .dout   (rever),
    .dout_l (rever_0),
    .dout_h (rever_1)
);


reg valid_bt = 1'b0;
reg odd, even, cblk = 1'b0, cblk_t2;
reg bad_bt = 1'b0;
always @(posedge clk) begin

    // first cycle
    odd     <=   ^bt_0;
    even    <=   ~(^bt_0);
    cblk    <=   block[0];

    bad_blk   <= ~^block[1:0];
    bad_bt    <=   block[0] & (bt_0 == 4'b0000);

    // second cycle (deciding valid block type - 2/2)
    valid_bt <=  (equal_0 & equal_1 & even) | (rever_0 & rever_1 & odd);
    cblk_t2  <=   cblk;

end

// validating correct idle control code
wire or0_t2, or1_t2;
alt_ehipc3_fm_sl_or_r or0 (
    .din    (block[10+:36]),
    .clk    (clk),
    .dout   (or0_t2)
);
defparam or0 .WIDTH=36;

alt_ehipc3_fm_sl_or_r or1 (
    .din    ({block[46+:20], 16'h0}),
    .clk    (clk),
    .dout   (or1_t2)
);
defparam or1 .WIDTH=36;

wire ctrl;
alt_ehipc3_fm_sl_eq8t1 eq1 (
    .clk    (clk),
    .dina   ({bt_1, bt_0}),
    .dinb   (8'h1E),
    .dout   (ctrl)
);
defparam eq1 .SIM_EMULATE = SIM_EMULATE;

// Pipelined de-multiplexing to select proper control/data block type.

wire    [71:0]  mcd0, mcd1, mcd2, mcd3, mcd4, mcd5, mcd6, mcd7, mcd8, mcd9, mcd10, mcd11, mcd12, mcd13, mcd14, mcd15, mcdd;

assign  mcd14 = {8'hff,{8{8'h07}}};                                // Control-Code: 0x00; rest error
assign  mcd8 = {8'h1,block[65:10],MII_START};                      // start - 78
assign  mcd11 = {8'h1, block[65:10], MII_SEQ_ORDERED};             // seq ordered - 4B

assign  mcd7  = {8'hff,{7{MII_IDLE}},MII_TERMINATE};                    // 87
assign  mcd9  = {8'hfe,{6{MII_IDLE}},MII_TERMINATE,block[7+10:0+10]};   // 99
assign  mcd10 = {8'hfc,{5{MII_IDLE}},MII_TERMINATE,block[15+10:0+10]};  // AA
assign  mcd4  = {8'hf8,{4{MII_IDLE}},MII_TERMINATE,block[23+10:0+10]};  // B4
assign  mcd12 = {8'hf0,{3{MII_IDLE}},MII_TERMINATE,block[31+10:0+10]};  // CC
assign  mcd2  = {8'he0,{2{MII_IDLE}},MII_TERMINATE,block[39+10:0+10]};  // D2
assign  mcd1  = {8'hc0,MII_IDLE,MII_TERMINATE,block[47+10:0+10]};       // E1
assign  mcd15 = {8'h80,MII_TERMINATE,block[65:10]};                     // FF

assign  mcd3 =  {8'h1f,block[65:42],MII_START, {4{8'h07}}};
assign  mcd6 =  {8'h11,block[65:42],MII_START, block[33:10] ,MII_SEQ_ORDERED};
assign  mcd5 =  {8'h11,block[65:42],MII_SEQ_ORDERED, block[33:10] ,MII_SEQ_ORDERED};
assign  mcd13 =  {8'h1f,block[65:42],MII_SEQ_ORDERED, {4{8'h07}}};

assign  mcdd = {8'h0,block[65:2]};

wire    [7:0]   mc_t2;
wire    [63:0]  md_t2;
wire    [72*16-1:0] selin = {mcd15,mcd14,mcd13,mcd12,mcd11,mcd10,mcd9,mcd8,mcd7,mcd6,mcd5,mcd4,mcd3,mcd2,mcd1,mcdd};

alt_ehipc3_fm_sl_mx16r sel (
    .clk    (clk),
    .din    (selin),
    .sel    (bt_0 & {4{block[0]}}),
    .dout   ({mc_t2, md_t2})
);
defparam sel .WIDTH = 72;

// delays to align with mux output

reg bad_blk2;
reg bad_bt2;
reg ctrl_t2;

always @(posedge clk) begin
    bad_blk2   <=  bad_blk;
    bad_bt2    <=  bad_bt;
    ctrl_t2     <= ctrl & cblk;
end

// selection of valid/invalid block
reg    [7:0]   mc_t3;
reg    [63:0]  md_t3;
always @(posedge clk) begin

    if (bad_blk2 | bad_bt2 | (~valid_bt & cblk_t2) )
        {mc_t3, md_t3}   <=   {8'hff,{8{MII_ERROR}}};
    else if ((or0_t2 | or1_t2) & ctrl_t2)
        {mc_t3, md_t3}   <=   {8'hff,{8{MII_ERROR}}};
    else
        {mc_t3, md_t3}   <=   {mc_t2, md_t2};

end


assign dout_c = mc_t3;
assign dout_d = md_t3;

endmodule

// BENCHMARK INFO : Date : Fri Aug 14 17:15:25 2015
// BENCHMARK INFO : Quartus version : /tools/acds/15.1/157/linux64/quartus/bin
// BENCHMARK INFO : benchmark P4 version: 16
// BENCHMARK INFO : benchmark path: /tools/ipd_tools/1.22/linux64/bin
// BENCHMARK INFO : Total registers : 447
// BENCHMARK INFO : Total pins : 139
// BENCHMARK INFO : Total virtual pins : 0
// BENCHMARK INFO : Total block memory bits : 0
// BENCHMARK INFO : Number of LUT levels: Max 2.0 LUTs   Average 0.90
// BENCHMARK INFO : Number of Fitter seeds : 3
// BENCHMARK INFO : Device: 10AX115K4F36I3SG
// BENCHMARK INFO : ALM usage: 255
// BENCHMARK INFO : Combinational ALUT usage: 436
// BENCHMARK INFO : Fitter seed 1000: Worst setup slack @ 450 MHz : 0.467 ns, From cb_t2, To mc_t3[0]
// BENCHMARK INFO : Fitter seed 2234: Worst setup slack @ 450 MHz : 0.764 ns, From alt_mx16r:sel|mid_sel[1], To alt_mx16r:sel|alt_mx4r:m|dout_r[63]
// BENCHMARK INFO : Fitter seed 3468: Worst setup slack @ 450 MHz : 0.588 ns, From alt_mx16r:sel|mid_sel[1], To alt_mx16r:sel|alt_mx4r:m|dout_r[29]
// BENCHMARK INFO : Elapsed benchmark time: 571.3 seconds
