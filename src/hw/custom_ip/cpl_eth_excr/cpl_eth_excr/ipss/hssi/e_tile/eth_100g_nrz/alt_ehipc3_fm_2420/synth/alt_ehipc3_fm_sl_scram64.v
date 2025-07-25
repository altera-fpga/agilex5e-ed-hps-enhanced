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
// Ethernet style scrambler for 64 bit data.

module alt_ehipc3_fm_sl_scram64 #(
    parameter SIM_EMULATE = 1'b0
) (
    input clk,
    input din_valid,
    input [63:0] din,
    output [63:0] dout,
    output dout_valid
);

reg din_valid_r1 = 1'b0;
always @(posedge clk) din_valid_r1 <= din_valid;

reg din_valid_r2 = 1'b0;
always @(posedge clk) din_valid_r2 <= din_valid_r1;

wire [57:0] scram_state;


//////////////////////////////////////////////////
//  dout[0] has 3 terms
//////////////////////////////////////////////////

wire din_terms_58 = {
    din[0]
};

wire din_x_58;
alt_ehipc3_fm_sl_xor1t1 c0 (
    .clk(clk),
    .din(din_terms_58),
    .dout(din_x_58)
);
defparam c0 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_58 = {
    scram_state[0],
    scram_state[19]
};

wire dout_w_58;
alt_ehipc3_fm_sl_xor3t1 c1 (
    .clk(clk),
    .din({din_x_58,scram_terms_58}),
    .dout(dout_w_58)
);
defparam c1 .SIM_EMULATE = SIM_EMULATE;

assign dout[0] = dout_w_58;

//////////////////////////////////////////////////
//  dout[1] has 3 terms
//////////////////////////////////////////////////

wire din_terms_59 = {
    din[1]
};

wire din_x_59;
alt_ehipc3_fm_sl_xor1t1 c2 (
    .clk(clk),
    .din(din_terms_59),
    .dout(din_x_59)
);
defparam c2 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_59 = {
    scram_state[1],
    scram_state[20]
};

wire dout_w_59;
alt_ehipc3_fm_sl_xor3t1 c3 (
    .clk(clk),
    .din({din_x_59,scram_terms_59}),
    .dout(dout_w_59)
);
defparam c3 .SIM_EMULATE = SIM_EMULATE;

assign dout[1] = dout_w_59;

//////////////////////////////////////////////////
//  dout[2] has 3 terms
//////////////////////////////////////////////////

wire din_terms_60 = {
    din[2]
};

wire din_x_60;
alt_ehipc3_fm_sl_xor1t1 c4 (
    .clk(clk),
    .din(din_terms_60),
    .dout(din_x_60)
);
defparam c4 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_60 = {
    scram_state[2],
    scram_state[21]
};

wire dout_w_60;
alt_ehipc3_fm_sl_xor3t1 c5 (
    .clk(clk),
    .din({din_x_60,scram_terms_60}),
    .dout(dout_w_60)
);
defparam c5 .SIM_EMULATE = SIM_EMULATE;

assign dout[2] = dout_w_60;

//////////////////////////////////////////////////
//  dout[3] has 3 terms
//////////////////////////////////////////////////

wire din_terms_61 = {
    din[3]
};

wire din_x_61;
alt_ehipc3_fm_sl_xor1t1 c6 (
    .clk(clk),
    .din(din_terms_61),
    .dout(din_x_61)
);
defparam c6 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_61 = {
    scram_state[3],
    scram_state[22]
};

wire dout_w_61;
alt_ehipc3_fm_sl_xor3t1 c7 (
    .clk(clk),
    .din({din_x_61,scram_terms_61}),
    .dout(dout_w_61)
);
defparam c7 .SIM_EMULATE = SIM_EMULATE;

assign dout[3] = dout_w_61;

//////////////////////////////////////////////////
//  dout[4] has 3 terms
//////////////////////////////////////////////////

wire din_terms_62 = {
    din[4]
};

wire din_x_62;
alt_ehipc3_fm_sl_xor1t1 c8 (
    .clk(clk),
    .din(din_terms_62),
    .dout(din_x_62)
);
defparam c8 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_62 = {
    scram_state[4],
    scram_state[23]
};

wire dout_w_62;
alt_ehipc3_fm_sl_xor3t1 c9 (
    .clk(clk),
    .din({din_x_62,scram_terms_62}),
    .dout(dout_w_62)
);
defparam c9 .SIM_EMULATE = SIM_EMULATE;

assign dout[4] = dout_w_62;

//////////////////////////////////////////////////
//  dout[5] has 3 terms
//////////////////////////////////////////////////

wire din_terms_63 = {
    din[5]
};

wire din_x_63;
alt_ehipc3_fm_sl_xor1t1 c10 (
    .clk(clk),
    .din(din_terms_63),
    .dout(din_x_63)
);
defparam c10 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_63 = {
    scram_state[5],
    scram_state[24]
};

wire dout_w_63;
alt_ehipc3_fm_sl_xor3t1 c11 (
    .clk(clk),
    .din({din_x_63,scram_terms_63}),
    .dout(dout_w_63)
);
defparam c11 .SIM_EMULATE = SIM_EMULATE;

assign dout[5] = dout_w_63;

//////////////////////////////////////////////////
//  dout[6]  next_state[0] has 3 terms
//////////////////////////////////////////////////

wire din_terms_64 = {
    din[6]
};

wire din_x_64;
alt_ehipc3_fm_sl_xor1t1 c12 (
    .clk(clk),
    .din(din_terms_64),
    .dout(din_x_64)
);
defparam c12 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_64 = {
    scram_state[6],
    scram_state[25]
};

wire dout_w_64_i;
alt_ehipc3_fm_sl_xor3t0 c13 (
    .din({din_x_64,scram_terms_64}),
    .dout(dout_w_64_i)
);
defparam c13 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_64 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_64 <= dout_w_64_i;
end

assign dout[6] = dout_w_64;
assign scram_state[0] = dout_w_64;

//////////////////////////////////////////////////
//  dout[7]  next_state[1] has 3 terms
//////////////////////////////////////////////////

wire din_terms_65 = {
    din[7]
};

wire din_x_65;
alt_ehipc3_fm_sl_xor1t1 c14 (
    .clk(clk),
    .din(din_terms_65),
    .dout(din_x_65)
);
defparam c14 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_65 = {
    scram_state[7],
    scram_state[26]
};

wire dout_w_65_i;
alt_ehipc3_fm_sl_xor3t0 c15 (
    .din({din_x_65,scram_terms_65}),
    .dout(dout_w_65_i)
);
defparam c15 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_65 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_65 <= dout_w_65_i;
end

assign dout[7] = dout_w_65;
assign scram_state[1] = dout_w_65;

//////////////////////////////////////////////////
//  dout[8]  next_state[2] has 3 terms
//////////////////////////////////////////////////

wire din_terms_66 = {
    din[8]
};

wire din_x_66;
alt_ehipc3_fm_sl_xor1t1 c16 (
    .clk(clk),
    .din(din_terms_66),
    .dout(din_x_66)
);
defparam c16 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_66 = {
    scram_state[8],
    scram_state[27]
};

wire dout_w_66_i;
alt_ehipc3_fm_sl_xor3t0 c17 (
    .din({din_x_66,scram_terms_66}),
    .dout(dout_w_66_i)
);
defparam c17 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_66 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_66 <= dout_w_66_i;
end

assign dout[8] = dout_w_66;
assign scram_state[2] = dout_w_66;

//////////////////////////////////////////////////
//  dout[9]  next_state[3] has 3 terms
//////////////////////////////////////////////////

wire din_terms_67 = {
    din[9]
};

wire din_x_67;
alt_ehipc3_fm_sl_xor1t1 c18 (
    .clk(clk),
    .din(din_terms_67),
    .dout(din_x_67)
);
defparam c18 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_67 = {
    scram_state[9],
    scram_state[28]
};

wire dout_w_67_i;
alt_ehipc3_fm_sl_xor3t0 c19 (
    .din({din_x_67,scram_terms_67}),
    .dout(dout_w_67_i)
);
defparam c19 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_67 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_67 <= dout_w_67_i;
end

assign dout[9] = dout_w_67;
assign scram_state[3] = dout_w_67;

//////////////////////////////////////////////////
//  dout[10]  next_state[4] has 3 terms
//////////////////////////////////////////////////

wire din_terms_68 = {
    din[10]
};

wire din_x_68;
alt_ehipc3_fm_sl_xor1t1 c20 (
    .clk(clk),
    .din(din_terms_68),
    .dout(din_x_68)
);
defparam c20 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_68 = {
    scram_state[10],
    scram_state[29]
};

wire dout_w_68_i;
alt_ehipc3_fm_sl_xor3t0 c21 (
    .din({din_x_68,scram_terms_68}),
    .dout(dout_w_68_i)
);
defparam c21 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_68 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_68 <= dout_w_68_i;
end

assign dout[10] = dout_w_68;
assign scram_state[4] = dout_w_68;

//////////////////////////////////////////////////
//  dout[11]  next_state[5] has 3 terms
//////////////////////////////////////////////////

wire din_terms_69 = {
    din[11]
};

wire din_x_69;
alt_ehipc3_fm_sl_xor1t1 c22 (
    .clk(clk),
    .din(din_terms_69),
    .dout(din_x_69)
);
defparam c22 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_69 = {
    scram_state[11],
    scram_state[30]
};

wire dout_w_69_i;
alt_ehipc3_fm_sl_xor3t0 c23 (
    .din({din_x_69,scram_terms_69}),
    .dout(dout_w_69_i)
);
defparam c23 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_69 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_69 <= dout_w_69_i;
end

assign dout[11] = dout_w_69;
assign scram_state[5] = dout_w_69;

//////////////////////////////////////////////////
//  dout[12]  next_state[6] has 3 terms
//////////////////////////////////////////////////

wire din_terms_70 = {
    din[12]
};

wire din_x_70;
alt_ehipc3_fm_sl_xor1t1 c24 (
    .clk(clk),
    .din(din_terms_70),
    .dout(din_x_70)
);
defparam c24 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_70 = {
    scram_state[12],
    scram_state[31]
};

wire dout_w_70_i;
alt_ehipc3_fm_sl_xor3t0 c25 (
    .din({din_x_70,scram_terms_70}),
    .dout(dout_w_70_i)
);
defparam c25 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_70 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_70 <= dout_w_70_i;
end

assign dout[12] = dout_w_70;
assign scram_state[6] = dout_w_70;

//////////////////////////////////////////////////
//  dout[13]  next_state[7] has 3 terms
//////////////////////////////////////////////////

wire din_terms_71 = {
    din[13]
};

wire din_x_71;
alt_ehipc3_fm_sl_xor1t1 c26 (
    .clk(clk),
    .din(din_terms_71),
    .dout(din_x_71)
);
defparam c26 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_71 = {
    scram_state[13],
    scram_state[32]
};

wire dout_w_71_i;
alt_ehipc3_fm_sl_xor3t0 c27 (
    .din({din_x_71,scram_terms_71}),
    .dout(dout_w_71_i)
);
defparam c27 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_71 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_71 <= dout_w_71_i;
end

assign dout[13] = dout_w_71;
assign scram_state[7] = dout_w_71;

//////////////////////////////////////////////////
//  dout[14]  next_state[8] has 3 terms
//////////////////////////////////////////////////

wire din_terms_72 = {
    din[14]
};

wire din_x_72;
alt_ehipc3_fm_sl_xor1t1 c28 (
    .clk(clk),
    .din(din_terms_72),
    .dout(din_x_72)
);
defparam c28 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_72 = {
    scram_state[14],
    scram_state[33]
};

wire dout_w_72_i;
alt_ehipc3_fm_sl_xor3t0 c29 (
    .din({din_x_72,scram_terms_72}),
    .dout(dout_w_72_i)
);
defparam c29 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_72 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_72 <= dout_w_72_i;
end

assign dout[14] = dout_w_72;
assign scram_state[8] = dout_w_72;

//////////////////////////////////////////////////
//  dout[15]  next_state[9] has 3 terms
//////////////////////////////////////////////////

wire din_terms_73 = {
    din[15]
};

wire din_x_73;
alt_ehipc3_fm_sl_xor1t1 c30 (
    .clk(clk),
    .din(din_terms_73),
    .dout(din_x_73)
);
defparam c30 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_73 = {
    scram_state[15],
    scram_state[34]
};

wire dout_w_73_i;
alt_ehipc3_fm_sl_xor3t0 c31 (
    .din({din_x_73,scram_terms_73}),
    .dout(dout_w_73_i)
);
defparam c31 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_73 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_73 <= dout_w_73_i;
end

assign dout[15] = dout_w_73;
assign scram_state[9] = dout_w_73;

//////////////////////////////////////////////////
//  dout[16]  next_state[10] has 3 terms
//////////////////////////////////////////////////

wire din_terms_74 = {
    din[16]
};

wire din_x_74;
alt_ehipc3_fm_sl_xor1t1 c32 (
    .clk(clk),
    .din(din_terms_74),
    .dout(din_x_74)
);
defparam c32 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_74 = {
    scram_state[16],
    scram_state[35]
};

wire dout_w_74_i;
alt_ehipc3_fm_sl_xor3t0 c33 (
    .din({din_x_74,scram_terms_74}),
    .dout(dout_w_74_i)
);
defparam c33 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_74 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_74 <= dout_w_74_i;
end

assign dout[16] = dout_w_74;
assign scram_state[10] = dout_w_74;

//////////////////////////////////////////////////
//  dout[17]  next_state[11] has 3 terms
//////////////////////////////////////////////////

wire din_terms_75 = {
    din[17]
};

wire din_x_75;
alt_ehipc3_fm_sl_xor1t1 c34 (
    .clk(clk),
    .din(din_terms_75),
    .dout(din_x_75)
);
defparam c34 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_75 = {
    scram_state[17],
    scram_state[36]
};

wire dout_w_75_i;
alt_ehipc3_fm_sl_xor3t0 c35 (
    .din({din_x_75,scram_terms_75}),
    .dout(dout_w_75_i)
);
defparam c35 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_75 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_75 <= dout_w_75_i;
end

assign dout[17] = dout_w_75;
assign scram_state[11] = dout_w_75;

//////////////////////////////////////////////////
//  dout[18]  next_state[12] has 3 terms
//////////////////////////////////////////////////

wire din_terms_76 = {
    din[18]
};

wire din_x_76;
alt_ehipc3_fm_sl_xor1t1 c36 (
    .clk(clk),
    .din(din_terms_76),
    .dout(din_x_76)
);
defparam c36 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_76 = {
    scram_state[18],
    scram_state[37]
};

wire dout_w_76_i;
alt_ehipc3_fm_sl_xor3t0 c37 (
    .din({din_x_76,scram_terms_76}),
    .dout(dout_w_76_i)
);
defparam c37 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_76 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_76 <= dout_w_76_i;
end

assign dout[18] = dout_w_76;
assign scram_state[12] = dout_w_76;

//////////////////////////////////////////////////
//  dout[19]  next_state[13] has 3 terms
//////////////////////////////////////////////////

wire din_terms_77 = {
    din[19]
};

wire din_x_77;
alt_ehipc3_fm_sl_xor1t1 c38 (
    .clk(clk),
    .din(din_terms_77),
    .dout(din_x_77)
);
defparam c38 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_77 = {
    scram_state[19],
    scram_state[38]
};

wire dout_w_77_i;
alt_ehipc3_fm_sl_xor3t0 c39 (
    .din({din_x_77,scram_terms_77}),
    .dout(dout_w_77_i)
);
defparam c39 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_77 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_77 <= dout_w_77_i;
end

assign dout[19] = dout_w_77;
assign scram_state[13] = dout_w_77;

//////////////////////////////////////////////////
//  dout[20]  next_state[14] has 3 terms
//////////////////////////////////////////////////

wire din_terms_78 = {
    din[20]
};

wire din_x_78;
alt_ehipc3_fm_sl_xor1t1 c40 (
    .clk(clk),
    .din(din_terms_78),
    .dout(din_x_78)
);
defparam c40 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_78 = {
    scram_state[20],
    scram_state[39]
};

wire dout_w_78_i;
alt_ehipc3_fm_sl_xor3t0 c41 (
    .din({din_x_78,scram_terms_78}),
    .dout(dout_w_78_i)
);
defparam c41 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_78 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_78 <= dout_w_78_i;
end

assign dout[20] = dout_w_78;
assign scram_state[14] = dout_w_78;

//////////////////////////////////////////////////
//  dout[21]  next_state[15] has 3 terms
//////////////////////////////////////////////////

wire din_terms_79 = {
    din[21]
};

wire din_x_79;
alt_ehipc3_fm_sl_xor1t1 c42 (
    .clk(clk),
    .din(din_terms_79),
    .dout(din_x_79)
);
defparam c42 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_79 = {
    scram_state[21],
    scram_state[40]
};

wire dout_w_79_i;
alt_ehipc3_fm_sl_xor3t0 c43 (
    .din({din_x_79,scram_terms_79}),
    .dout(dout_w_79_i)
);
defparam c43 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_79 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_79 <= dout_w_79_i;
end

assign dout[21] = dout_w_79;
assign scram_state[15] = dout_w_79;

//////////////////////////////////////////////////
//  dout[22]  next_state[16] has 3 terms
//////////////////////////////////////////////////

wire din_terms_80 = {
    din[22]
};

wire din_x_80;
alt_ehipc3_fm_sl_xor1t1 c44 (
    .clk(clk),
    .din(din_terms_80),
    .dout(din_x_80)
);
defparam c44 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_80 = {
    scram_state[22],
    scram_state[41]
};

wire dout_w_80_i;
alt_ehipc3_fm_sl_xor3t0 c45 (
    .din({din_x_80,scram_terms_80}),
    .dout(dout_w_80_i)
);
defparam c45 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_80 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_80 <= dout_w_80_i;
end

assign dout[22] = dout_w_80;
assign scram_state[16] = dout_w_80;

//////////////////////////////////////////////////
//  dout[23]  next_state[17] has 3 terms
//////////////////////////////////////////////////

wire din_terms_81 = {
    din[23]
};

wire din_x_81;
alt_ehipc3_fm_sl_xor1t1 c46 (
    .clk(clk),
    .din(din_terms_81),
    .dout(din_x_81)
);
defparam c46 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_81 = {
    scram_state[23],
    scram_state[42]
};

wire dout_w_81_i;
alt_ehipc3_fm_sl_xor3t0 c47 (
    .din({din_x_81,scram_terms_81}),
    .dout(dout_w_81_i)
);
defparam c47 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_81 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_81 <= dout_w_81_i;
end

assign dout[23] = dout_w_81;
assign scram_state[17] = dout_w_81;

//////////////////////////////////////////////////
//  dout[24]  next_state[18] has 3 terms
//////////////////////////////////////////////////

wire din_terms_82 = {
    din[24]
};

wire din_x_82;
alt_ehipc3_fm_sl_xor1t1 c48 (
    .clk(clk),
    .din(din_terms_82),
    .dout(din_x_82)
);
defparam c48 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_82 = {
    scram_state[24],
    scram_state[43]
};

wire dout_w_82_i;
alt_ehipc3_fm_sl_xor3t0 c49 (
    .din({din_x_82,scram_terms_82}),
    .dout(dout_w_82_i)
);
defparam c49 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_82 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_82 <= dout_w_82_i;
end

assign dout[24] = dout_w_82;
assign scram_state[18] = dout_w_82;

//////////////////////////////////////////////////
//  dout[25]  next_state[19] has 3 terms
//////////////////////////////////////////////////

wire din_terms_83 = {
    din[25]
};

wire din_x_83;
alt_ehipc3_fm_sl_xor1t1 c50 (
    .clk(clk),
    .din(din_terms_83),
    .dout(din_x_83)
);
defparam c50 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_83 = {
    scram_state[25],
    scram_state[44]
};

wire dout_w_83_i;
alt_ehipc3_fm_sl_xor3t0 c51 (
    .din({din_x_83,scram_terms_83}),
    .dout(dout_w_83_i)
);
defparam c51 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_83 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_83 <= dout_w_83_i;
end

assign dout[25] = dout_w_83;
assign scram_state[19] = dout_w_83;

//////////////////////////////////////////////////
//  dout[26]  next_state[20] has 3 terms
//////////////////////////////////////////////////

wire din_terms_84 = {
    din[26]
};

wire din_x_84;
alt_ehipc3_fm_sl_xor1t1 c52 (
    .clk(clk),
    .din(din_terms_84),
    .dout(din_x_84)
);
defparam c52 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_84 = {
    scram_state[26],
    scram_state[45]
};

wire dout_w_84_i;
alt_ehipc3_fm_sl_xor3t0 c53 (
    .din({din_x_84,scram_terms_84}),
    .dout(dout_w_84_i)
);
defparam c53 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_84 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_84 <= dout_w_84_i;
end

assign dout[26] = dout_w_84;
assign scram_state[20] = dout_w_84;

//////////////////////////////////////////////////
//  dout[27]  next_state[21] has 3 terms
//////////////////////////////////////////////////

wire din_terms_85 = {
    din[27]
};

wire din_x_85;
alt_ehipc3_fm_sl_xor1t1 c54 (
    .clk(clk),
    .din(din_terms_85),
    .dout(din_x_85)
);
defparam c54 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_85 = {
    scram_state[27],
    scram_state[46]
};

wire dout_w_85_i;
alt_ehipc3_fm_sl_xor3t0 c55 (
    .din({din_x_85,scram_terms_85}),
    .dout(dout_w_85_i)
);
defparam c55 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_85 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_85 <= dout_w_85_i;
end

assign dout[27] = dout_w_85;
assign scram_state[21] = dout_w_85;

//////////////////////////////////////////////////
//  dout[28]  next_state[22] has 3 terms
//////////////////////////////////////////////////

wire din_terms_86 = {
    din[28]
};

wire din_x_86;
alt_ehipc3_fm_sl_xor1t1 c56 (
    .clk(clk),
    .din(din_terms_86),
    .dout(din_x_86)
);
defparam c56 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_86 = {
    scram_state[28],
    scram_state[47]
};

wire dout_w_86_i;
alt_ehipc3_fm_sl_xor3t0 c57 (
    .din({din_x_86,scram_terms_86}),
    .dout(dout_w_86_i)
);
defparam c57 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_86 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_86 <= dout_w_86_i;
end

assign dout[28] = dout_w_86;
assign scram_state[22] = dout_w_86;

//////////////////////////////////////////////////
//  dout[29]  next_state[23] has 3 terms
//////////////////////////////////////////////////

wire din_terms_87 = {
    din[29]
};

wire din_x_87;
alt_ehipc3_fm_sl_xor1t1 c58 (
    .clk(clk),
    .din(din_terms_87),
    .dout(din_x_87)
);
defparam c58 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_87 = {
    scram_state[29],
    scram_state[48]
};

wire dout_w_87_i;
alt_ehipc3_fm_sl_xor3t0 c59 (
    .din({din_x_87,scram_terms_87}),
    .dout(dout_w_87_i)
);
defparam c59 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_87 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_87 <= dout_w_87_i;
end

assign dout[29] = dout_w_87;
assign scram_state[23] = dout_w_87;

//////////////////////////////////////////////////
//  dout[30]  next_state[24] has 3 terms
//////////////////////////////////////////////////

wire din_terms_88 = {
    din[30]
};

wire din_x_88;
alt_ehipc3_fm_sl_xor1t1 c60 (
    .clk(clk),
    .din(din_terms_88),
    .dout(din_x_88)
);
defparam c60 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_88 = {
    scram_state[30],
    scram_state[49]
};

wire dout_w_88_i;
alt_ehipc3_fm_sl_xor3t0 c61 (
    .din({din_x_88,scram_terms_88}),
    .dout(dout_w_88_i)
);
defparam c61 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_88 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_88 <= dout_w_88_i;
end

assign dout[30] = dout_w_88;
assign scram_state[24] = dout_w_88;

//////////////////////////////////////////////////
//  dout[31]  next_state[25] has 3 terms
//////////////////////////////////////////////////

wire din_terms_89 = {
    din[31]
};

wire din_x_89;
alt_ehipc3_fm_sl_xor1t1 c62 (
    .clk(clk),
    .din(din_terms_89),
    .dout(din_x_89)
);
defparam c62 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_89 = {
    scram_state[31],
    scram_state[50]
};

wire dout_w_89_i;
alt_ehipc3_fm_sl_xor3t0 c63 (
    .din({din_x_89,scram_terms_89}),
    .dout(dout_w_89_i)
);
defparam c63 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_89 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_89 <= dout_w_89_i;
end

assign dout[31] = dout_w_89;
assign scram_state[25] = dout_w_89;

//////////////////////////////////////////////////
//  dout[32]  next_state[26] has 3 terms
//////////////////////////////////////////////////

wire din_terms_90 = {
    din[32]
};

wire din_x_90;
alt_ehipc3_fm_sl_xor1t1 c64 (
    .clk(clk),
    .din(din_terms_90),
    .dout(din_x_90)
);
defparam c64 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_90 = {
    scram_state[32],
    scram_state[51]
};

wire dout_w_90_i;
alt_ehipc3_fm_sl_xor3t0 c65 (
    .din({din_x_90,scram_terms_90}),
    .dout(dout_w_90_i)
);
defparam c65 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_90 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_90 <= dout_w_90_i;
end

assign dout[32] = dout_w_90;
assign scram_state[26] = dout_w_90;

//////////////////////////////////////////////////
//  dout[33]  next_state[27] has 3 terms
//////////////////////////////////////////////////

wire din_terms_91 = {
    din[33]
};

wire din_x_91;
alt_ehipc3_fm_sl_xor1t1 c66 (
    .clk(clk),
    .din(din_terms_91),
    .dout(din_x_91)
);
defparam c66 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_91 = {
    scram_state[33],
    scram_state[52]
};

wire dout_w_91_i;
alt_ehipc3_fm_sl_xor3t0 c67 (
    .din({din_x_91,scram_terms_91}),
    .dout(dout_w_91_i)
);
defparam c67 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_91 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_91 <= dout_w_91_i;
end

assign dout[33] = dout_w_91;
assign scram_state[27] = dout_w_91;

//////////////////////////////////////////////////
//  dout[34]  next_state[28] has 3 terms
//////////////////////////////////////////////////

wire din_terms_92 = {
    din[34]
};

wire din_x_92;
alt_ehipc3_fm_sl_xor1t1 c68 (
    .clk(clk),
    .din(din_terms_92),
    .dout(din_x_92)
);
defparam c68 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_92 = {
    scram_state[34],
    scram_state[53]
};

wire dout_w_92_i;
alt_ehipc3_fm_sl_xor3t0 c69 (
    .din({din_x_92,scram_terms_92}),
    .dout(dout_w_92_i)
);
defparam c69 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_92 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_92 <= dout_w_92_i;
end

assign dout[34] = dout_w_92;
assign scram_state[28] = dout_w_92;

//////////////////////////////////////////////////
//  dout[35]  next_state[29] has 3 terms
//////////////////////////////////////////////////

wire din_terms_93 = {
    din[35]
};

wire din_x_93;
alt_ehipc3_fm_sl_xor1t1 c70 (
    .clk(clk),
    .din(din_terms_93),
    .dout(din_x_93)
);
defparam c70 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_93 = {
    scram_state[35],
    scram_state[54]
};

wire dout_w_93_i;
alt_ehipc3_fm_sl_xor3t0 c71 (
    .din({din_x_93,scram_terms_93}),
    .dout(dout_w_93_i)
);
defparam c71 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_93 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_93 <= dout_w_93_i;
end

assign dout[35] = dout_w_93;
assign scram_state[29] = dout_w_93;

//////////////////////////////////////////////////
//  dout[36]  next_state[30] has 3 terms
//////////////////////////////////////////////////

wire din_terms_94 = {
    din[36]
};

wire din_x_94;
alt_ehipc3_fm_sl_xor1t1 c72 (
    .clk(clk),
    .din(din_terms_94),
    .dout(din_x_94)
);
defparam c72 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_94 = {
    scram_state[36],
    scram_state[55]
};

wire dout_w_94_i;
alt_ehipc3_fm_sl_xor3t0 c73 (
    .din({din_x_94,scram_terms_94}),
    .dout(dout_w_94_i)
);
defparam c73 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_94 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_94 <= dout_w_94_i;
end

assign dout[36] = dout_w_94;
assign scram_state[30] = dout_w_94;

//////////////////////////////////////////////////
//  dout[37]  next_state[31] has 3 terms
//////////////////////////////////////////////////

wire din_terms_95 = {
    din[37]
};

wire din_x_95;
alt_ehipc3_fm_sl_xor1t1 c74 (
    .clk(clk),
    .din(din_terms_95),
    .dout(din_x_95)
);
defparam c74 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_95 = {
    scram_state[37],
    scram_state[56]
};

wire dout_w_95_i;
alt_ehipc3_fm_sl_xor3t0 c75 (
    .din({din_x_95,scram_terms_95}),
    .dout(dout_w_95_i)
);
defparam c75 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_95 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_95 <= dout_w_95_i;
end

assign dout[37] = dout_w_95;
assign scram_state[31] = dout_w_95;

//////////////////////////////////////////////////
//  dout[38]  next_state[32] has 3 terms
//////////////////////////////////////////////////

wire din_terms_96 = {
    din[38]
};

wire din_x_96;
alt_ehipc3_fm_sl_xor1t1 c76 (
    .clk(clk),
    .din(din_terms_96),
    .dout(din_x_96)
);
defparam c76 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_96 = {
    scram_state[38],
    scram_state[57]
};

wire dout_w_96_i;
alt_ehipc3_fm_sl_xor3t0 c77 (
    .din({din_x_96,scram_terms_96}),
    .dout(dout_w_96_i)
);
defparam c77 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_96 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_96 <= dout_w_96_i;
end

assign dout[38] = dout_w_96;
assign scram_state[32] = dout_w_96;

//////////////////////////////////////////////////
//  dout[39]  next_state[33] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_97 = {
    din[39],
    din[0]
};

wire din_x_97;
alt_ehipc3_fm_sl_xor2t1 c78 (
    .clk(clk),
    .din(din_terms_97),
    .dout(din_x_97)
);
defparam c78 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_97 = {
    scram_state[39],
    scram_state[0],
    scram_state[19]
};

wire dout_w_97_i;
alt_ehipc3_fm_sl_xor4t0 c79 (
    .din({din_x_97,scram_terms_97}),
    .dout(dout_w_97_i)
);
defparam c79 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_97 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_97 <= dout_w_97_i;
end

assign dout[39] = dout_w_97;
assign scram_state[33] = dout_w_97;

//////////////////////////////////////////////////
//  dout[40]  next_state[34] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_98 = {
    din[40],
    din[1]
};

wire din_x_98;
alt_ehipc3_fm_sl_xor2t1 c80 (
    .clk(clk),
    .din(din_terms_98),
    .dout(din_x_98)
);
defparam c80 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_98 = {
    scram_state[40],
    scram_state[1],
    scram_state[20]
};

wire dout_w_98_i;
alt_ehipc3_fm_sl_xor4t0 c81 (
    .din({din_x_98,scram_terms_98}),
    .dout(dout_w_98_i)
);
defparam c81 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_98 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_98 <= dout_w_98_i;
end

assign dout[40] = dout_w_98;
assign scram_state[34] = dout_w_98;

//////////////////////////////////////////////////
//  dout[41]  next_state[35] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_99 = {
    din[41],
    din[2]
};

wire din_x_99;
alt_ehipc3_fm_sl_xor2t1 c82 (
    .clk(clk),
    .din(din_terms_99),
    .dout(din_x_99)
);
defparam c82 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_99 = {
    scram_state[41],
    scram_state[2],
    scram_state[21]
};

wire dout_w_99_i;
alt_ehipc3_fm_sl_xor4t0 c83 (
    .din({din_x_99,scram_terms_99}),
    .dout(dout_w_99_i)
);
defparam c83 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_99 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_99 <= dout_w_99_i;
end

assign dout[41] = dout_w_99;
assign scram_state[35] = dout_w_99;

//////////////////////////////////////////////////
//  dout[42]  next_state[36] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_100 = {
    din[42],
    din[3]
};

wire din_x_100;
alt_ehipc3_fm_sl_xor2t1 c84 (
    .clk(clk),
    .din(din_terms_100),
    .dout(din_x_100)
);
defparam c84 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_100 = {
    scram_state[42],
    scram_state[3],
    scram_state[22]
};

wire dout_w_100_i;
alt_ehipc3_fm_sl_xor4t0 c85 (
    .din({din_x_100,scram_terms_100}),
    .dout(dout_w_100_i)
);
defparam c85 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_100 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_100 <= dout_w_100_i;
end

assign dout[42] = dout_w_100;
assign scram_state[36] = dout_w_100;

//////////////////////////////////////////////////
//  dout[43]  next_state[37] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_101 = {
    din[43],
    din[4]
};

wire din_x_101;
alt_ehipc3_fm_sl_xor2t1 c86 (
    .clk(clk),
    .din(din_terms_101),
    .dout(din_x_101)
);
defparam c86 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_101 = {
    scram_state[43],
    scram_state[4],
    scram_state[23]
};

wire dout_w_101_i;
alt_ehipc3_fm_sl_xor4t0 c87 (
    .din({din_x_101,scram_terms_101}),
    .dout(dout_w_101_i)
);
defparam c87 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_101 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_101 <= dout_w_101_i;
end

assign dout[43] = dout_w_101;
assign scram_state[37] = dout_w_101;

//////////////////////////////////////////////////
//  dout[44]  next_state[38] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_102 = {
    din[44],
    din[5]
};

wire din_x_102;
alt_ehipc3_fm_sl_xor2t1 c88 (
    .clk(clk),
    .din(din_terms_102),
    .dout(din_x_102)
);
defparam c88 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_102 = {
    scram_state[44],
    scram_state[5],
    scram_state[24]
};

wire dout_w_102_i;
alt_ehipc3_fm_sl_xor4t0 c89 (
    .din({din_x_102,scram_terms_102}),
    .dout(dout_w_102_i)
);
defparam c89 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_102 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_102 <= dout_w_102_i;
end

assign dout[44] = dout_w_102;
assign scram_state[38] = dout_w_102;

//////////////////////////////////////////////////
//  dout[45]  next_state[39] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_103 = {
    din[45],
    din[6]
};

wire din_x_103;
alt_ehipc3_fm_sl_xor2t1 c90 (
    .clk(clk),
    .din(din_terms_103),
    .dout(din_x_103)
);
defparam c90 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_103 = {
    scram_state[45],
    scram_state[6],
    scram_state[25]
};

wire dout_w_103_i;
alt_ehipc3_fm_sl_xor4t0 c91 (
    .din({din_x_103,scram_terms_103}),
    .dout(dout_w_103_i)
);
defparam c91 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_103 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_103 <= dout_w_103_i;
end

assign dout[45] = dout_w_103;
assign scram_state[39] = dout_w_103;

//////////////////////////////////////////////////
//  dout[46]  next_state[40] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_104 = {
    din[46],
    din[7]
};

wire din_x_104;
alt_ehipc3_fm_sl_xor2t1 c92 (
    .clk(clk),
    .din(din_terms_104),
    .dout(din_x_104)
);
defparam c92 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_104 = {
    scram_state[46],
    scram_state[7],
    scram_state[26]
};

wire dout_w_104_i;
alt_ehipc3_fm_sl_xor4t0 c93 (
    .din({din_x_104,scram_terms_104}),
    .dout(dout_w_104_i)
);
defparam c93 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_104 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_104 <= dout_w_104_i;
end

assign dout[46] = dout_w_104;
assign scram_state[40] = dout_w_104;

//////////////////////////////////////////////////
//  dout[47]  next_state[41] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_105 = {
    din[47],
    din[8]
};

wire din_x_105;
alt_ehipc3_fm_sl_xor2t1 c94 (
    .clk(clk),
    .din(din_terms_105),
    .dout(din_x_105)
);
defparam c94 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_105 = {
    scram_state[47],
    scram_state[8],
    scram_state[27]
};

wire dout_w_105_i;
alt_ehipc3_fm_sl_xor4t0 c95 (
    .din({din_x_105,scram_terms_105}),
    .dout(dout_w_105_i)
);
defparam c95 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_105 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_105 <= dout_w_105_i;
end

assign dout[47] = dout_w_105;
assign scram_state[41] = dout_w_105;

//////////////////////////////////////////////////
//  dout[48]  next_state[42] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_106 = {
    din[48],
    din[9]
};

wire din_x_106;
alt_ehipc3_fm_sl_xor2t1 c96 (
    .clk(clk),
    .din(din_terms_106),
    .dout(din_x_106)
);
defparam c96 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_106 = {
    scram_state[48],
    scram_state[9],
    scram_state[28]
};

wire dout_w_106_i;
alt_ehipc3_fm_sl_xor4t0 c97 (
    .din({din_x_106,scram_terms_106}),
    .dout(dout_w_106_i)
);
defparam c97 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_106 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_106 <= dout_w_106_i;
end

assign dout[48] = dout_w_106;
assign scram_state[42] = dout_w_106;

//////////////////////////////////////////////////
//  dout[49]  next_state[43] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_107 = {
    din[49],
    din[10]
};

wire din_x_107;
alt_ehipc3_fm_sl_xor2t1 c98 (
    .clk(clk),
    .din(din_terms_107),
    .dout(din_x_107)
);
defparam c98 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_107 = {
    scram_state[49],
    scram_state[10],
    scram_state[29]
};

wire dout_w_107_i;
alt_ehipc3_fm_sl_xor4t0 c99 (
    .din({din_x_107,scram_terms_107}),
    .dout(dout_w_107_i)
);
defparam c99 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_107 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_107 <= dout_w_107_i;
end

assign dout[49] = dout_w_107;
assign scram_state[43] = dout_w_107;

//////////////////////////////////////////////////
//  dout[50]  next_state[44] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_108 = {
    din[50],
    din[11]
};

wire din_x_108;
alt_ehipc3_fm_sl_xor2t1 c100 (
    .clk(clk),
    .din(din_terms_108),
    .dout(din_x_108)
);
defparam c100 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_108 = {
    scram_state[50],
    scram_state[11],
    scram_state[30]
};

wire dout_w_108_i;
alt_ehipc3_fm_sl_xor4t0 c101 (
    .din({din_x_108,scram_terms_108}),
    .dout(dout_w_108_i)
);
defparam c101 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_108 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_108 <= dout_w_108_i;
end

assign dout[50] = dout_w_108;
assign scram_state[44] = dout_w_108;

//////////////////////////////////////////////////
//  dout[51]  next_state[45] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_109 = {
    din[51],
    din[12]
};

wire din_x_109;
alt_ehipc3_fm_sl_xor2t1 c102 (
    .clk(clk),
    .din(din_terms_109),
    .dout(din_x_109)
);
defparam c102 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_109 = {
    scram_state[51],
    scram_state[12],
    scram_state[31]
};

wire dout_w_109_i;
alt_ehipc3_fm_sl_xor4t0 c103 (
    .din({din_x_109,scram_terms_109}),
    .dout(dout_w_109_i)
);
defparam c103 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_109 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_109 <= dout_w_109_i;
end

assign dout[51] = dout_w_109;
assign scram_state[45] = dout_w_109;

//////////////////////////////////////////////////
//  dout[52]  next_state[46] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_110 = {
    din[52],
    din[13]
};

wire din_x_110;
alt_ehipc3_fm_sl_xor2t1 c104 (
    .clk(clk),
    .din(din_terms_110),
    .dout(din_x_110)
);
defparam c104 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_110 = {
    scram_state[52],
    scram_state[13],
    scram_state[32]
};

wire dout_w_110_i;
alt_ehipc3_fm_sl_xor4t0 c105 (
    .din({din_x_110,scram_terms_110}),
    .dout(dout_w_110_i)
);
defparam c105 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_110 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_110 <= dout_w_110_i;
end

assign dout[52] = dout_w_110;
assign scram_state[46] = dout_w_110;

//////////////////////////////////////////////////
//  dout[53]  next_state[47] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_111 = {
    din[53],
    din[14]
};

wire din_x_111;
alt_ehipc3_fm_sl_xor2t1 c106 (
    .clk(clk),
    .din(din_terms_111),
    .dout(din_x_111)
);
defparam c106 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_111 = {
    scram_state[53],
    scram_state[14],
    scram_state[33]
};

wire dout_w_111_i;
alt_ehipc3_fm_sl_xor4t0 c107 (
    .din({din_x_111,scram_terms_111}),
    .dout(dout_w_111_i)
);
defparam c107 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_111 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_111 <= dout_w_111_i;
end

assign dout[53] = dout_w_111;
assign scram_state[47] = dout_w_111;

//////////////////////////////////////////////////
//  dout[54]  next_state[48] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_112 = {
    din[54],
    din[15]
};

wire din_x_112;
alt_ehipc3_fm_sl_xor2t1 c108 (
    .clk(clk),
    .din(din_terms_112),
    .dout(din_x_112)
);
defparam c108 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_112 = {
    scram_state[54],
    scram_state[15],
    scram_state[34]
};

wire dout_w_112_i;
alt_ehipc3_fm_sl_xor4t0 c109 (
    .din({din_x_112,scram_terms_112}),
    .dout(dout_w_112_i)
);
defparam c109 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_112 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_112 <= dout_w_112_i;
end

assign dout[54] = dout_w_112;
assign scram_state[48] = dout_w_112;

//////////////////////////////////////////////////
//  dout[55]  next_state[49] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_113 = {
    din[55],
    din[16]
};

wire din_x_113;
alt_ehipc3_fm_sl_xor2t1 c110 (
    .clk(clk),
    .din(din_terms_113),
    .dout(din_x_113)
);
defparam c110 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_113 = {
    scram_state[55],
    scram_state[16],
    scram_state[35]
};

wire dout_w_113_i;
alt_ehipc3_fm_sl_xor4t0 c111 (
    .din({din_x_113,scram_terms_113}),
    .dout(dout_w_113_i)
);
defparam c111 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_113 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_113 <= dout_w_113_i;
end

assign dout[55] = dout_w_113;
assign scram_state[49] = dout_w_113;

//////////////////////////////////////////////////
//  dout[56]  next_state[50] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_114 = {
    din[56],
    din[17]
};

wire din_x_114;
alt_ehipc3_fm_sl_xor2t1 c112 (
    .clk(clk),
    .din(din_terms_114),
    .dout(din_x_114)
);
defparam c112 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_114 = {
    scram_state[56],
    scram_state[17],
    scram_state[36]
};

wire dout_w_114_i;
alt_ehipc3_fm_sl_xor4t0 c113 (
    .din({din_x_114,scram_terms_114}),
    .dout(dout_w_114_i)
);
defparam c113 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_114 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_114 <= dout_w_114_i;
end

assign dout[56] = dout_w_114;
assign scram_state[50] = dout_w_114;

//////////////////////////////////////////////////
//  dout[57]  next_state[51] has 5 terms
//////////////////////////////////////////////////

wire [1:0] din_terms_115 = {
    din[57],
    din[18]
};

wire din_x_115;
alt_ehipc3_fm_sl_xor2t1 c114 (
    .clk(clk),
    .din(din_terms_115),
    .dout(din_x_115)
);
defparam c114 .SIM_EMULATE = SIM_EMULATE;

wire [2:0] scram_terms_115 = {
    scram_state[57],
    scram_state[18],
    scram_state[37]
};

wire dout_w_115_i;
alt_ehipc3_fm_sl_xor4t0 c115 (
    .din({din_x_115,scram_terms_115}),
    .dout(dout_w_115_i)
);
defparam c115 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_115 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_115 <= dout_w_115_i;
end

assign dout[57] = dout_w_115;
assign scram_state[51] = dout_w_115;

//////////////////////////////////////////////////
//  dout[58]  next_state[52] has 5 terms
//////////////////////////////////////////////////

wire [2:0] din_terms_116 = {
    din[58],
    din[0],
    din[19]
};

wire din_x_116;
alt_ehipc3_fm_sl_xor3t1 c116 (
    .clk(clk),
    .din(din_terms_116),
    .dout(din_x_116)
);
defparam c116 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_116 = {
    scram_state[0],
    scram_state[38]
};

wire dout_w_116_i;
alt_ehipc3_fm_sl_xor3t0 c117 (
    .din({din_x_116,scram_terms_116}),
    .dout(dout_w_116_i)
);
defparam c117 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_116 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_116 <= dout_w_116_i;
end

assign dout[58] = dout_w_116;
assign scram_state[52] = dout_w_116;

//////////////////////////////////////////////////
//  dout[59]  next_state[53] has 5 terms
//////////////////////////////////////////////////

wire [2:0] din_terms_117 = {
    din[59],
    din[1],
    din[20]
};

wire din_x_117;
alt_ehipc3_fm_sl_xor3t1 c118 (
    .clk(clk),
    .din(din_terms_117),
    .dout(din_x_117)
);
defparam c118 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_117 = {
    scram_state[1],
    scram_state[39]
};

wire dout_w_117_i;
alt_ehipc3_fm_sl_xor3t0 c119 (
    .din({din_x_117,scram_terms_117}),
    .dout(dout_w_117_i)
);
defparam c119 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_117 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_117 <= dout_w_117_i;
end

assign dout[59] = dout_w_117;
assign scram_state[53] = dout_w_117;

//////////////////////////////////////////////////
//  dout[60]  next_state[54] has 5 terms
//////////////////////////////////////////////////

wire [2:0] din_terms_118 = {
    din[60],
    din[2],
    din[21]
};

wire din_x_118;
alt_ehipc3_fm_sl_xor3t1 c120 (
    .clk(clk),
    .din(din_terms_118),
    .dout(din_x_118)
);
defparam c120 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_118 = {
    scram_state[2],
    scram_state[40]
};

wire dout_w_118_i;
alt_ehipc3_fm_sl_xor3t0 c121 (
    .din({din_x_118,scram_terms_118}),
    .dout(dout_w_118_i)
);
defparam c121 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_118 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_118 <= dout_w_118_i;
end

assign dout[60] = dout_w_118;
assign scram_state[54] = dout_w_118;

//////////////////////////////////////////////////
//  dout[61]  next_state[55] has 5 terms
//////////////////////////////////////////////////

wire [2:0] din_terms_119 = {
    din[61],
    din[3],
    din[22]
};

wire din_x_119;
alt_ehipc3_fm_sl_xor3t1 c122 (
    .clk(clk),
    .din(din_terms_119),
    .dout(din_x_119)
);
defparam c122 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_119 = {
    scram_state[3],
    scram_state[41]
};

wire dout_w_119_i;
alt_ehipc3_fm_sl_xor3t0 c123 (
    .din({din_x_119,scram_terms_119}),
    .dout(dout_w_119_i)
);
defparam c123 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_119 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_119 <= dout_w_119_i;
end

assign dout[61] = dout_w_119;
assign scram_state[55] = dout_w_119;

//////////////////////////////////////////////////
//  dout[62]  next_state[56] has 5 terms
//////////////////////////////////////////////////

wire [2:0] din_terms_120 = {
    din[62],
    din[4],
    din[23]
};

wire din_x_120;
alt_ehipc3_fm_sl_xor3t1 c124 (
    .clk(clk),
    .din(din_terms_120),
    .dout(din_x_120)
);
defparam c124 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_120 = {
    scram_state[4],
    scram_state[42]
};

wire dout_w_120_i;
alt_ehipc3_fm_sl_xor3t0 c125 (
    .din({din_x_120,scram_terms_120}),
    .dout(dout_w_120_i)
);
defparam c125 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_120 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_120 <= dout_w_120_i;
end

assign dout[62] = dout_w_120;
assign scram_state[56] = dout_w_120;

//////////////////////////////////////////////////
//  dout[63]  next_state[57] has 5 terms
//////////////////////////////////////////////////

wire [2:0] din_terms_121 = {
    din[63],
    din[5],
    din[24]
};

wire din_x_121;
alt_ehipc3_fm_sl_xor3t1 c126 (
    .clk(clk),
    .din(din_terms_121),
    .dout(din_x_121)
);
defparam c126 .SIM_EMULATE = SIM_EMULATE;

wire [1:0] scram_terms_121 = {
    scram_state[5],
    scram_state[43]
};

wire dout_w_121_i;
alt_ehipc3_fm_sl_xor3t0 c127 (
    .din({din_x_121,scram_terms_121}),
    .dout(dout_w_121_i)
);
defparam c127 .SIM_EMULATE = SIM_EMULATE;

reg dout_w_121 = 1'b0;
always @(posedge clk) begin
    if (din_valid_r1) dout_w_121 <= dout_w_121_i;
end

assign dout[63] = dout_w_121;
assign scram_state[57] = dout_w_121;
assign dout_valid = din_valid_r2;

endmodule
