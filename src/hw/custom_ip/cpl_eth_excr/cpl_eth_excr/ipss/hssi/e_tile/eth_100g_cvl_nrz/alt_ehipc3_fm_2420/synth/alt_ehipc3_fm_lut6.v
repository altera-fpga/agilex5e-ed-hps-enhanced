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

module alt_ehipc3_fm_lut6 #(
    parameter MASK = 64'h80000000_00000000,
    parameter SIM_EMULATE = 1'b0
) (
    input [5:0] din,
    output dout
);

generate
    if (SIM_EMULATE) begin
        assign dout = MASK [din];
    end else begin
        //Note: the S5 cell is 99% the same, and compatible
        //stratixv_lcell_comb a10c (

        tennm_lcell_comb a10c (
            .dataa (din[0]),
            .datab (din[1]),
            .datac (din[2]),
            .datad (din[3]),
            .datae (din[4]),
            .dataf (din[5]),
            .datag(1'b1),

            .cin(1'b1),


            // synthesis translate_off
            // this is for stratix 10 (fourteen) but not the others
            .datah(1'b1),

            // this does not exist in S10, but is partially there in the models right this second
            .sharein(1'b0),
            // synthesis translate_on

            .sumout(),.cout(),.shareout(),
            .combout(dout)
        );
        defparam a10c .lut_mask = MASK;
        defparam a10c .shared_arith = "off";
        defparam a10c .extended_lut = "off";
    end
endgenerate

endmodule
