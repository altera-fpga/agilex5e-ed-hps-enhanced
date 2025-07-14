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

module alt_ehipc3_fm_kpfec_cadence_gen (
    input   logic   clk,
    input   logic   reset,
    output  logic   cadence_pulse
);

    logic [5:0]  cadence_counter;
    always_ff @(posedge clk) begin
        if (reset) begin
            cadence_counter     <= 6'd0;
            cadence_pulse       <= 1'b0;
        end else begin
            if (cadence_counter >= 6'd16) begin
                cadence_counter     <= 6'd0;
                cadence_pulse       <= 1'b0;
            end else begin
                cadence_counter     <= cadence_counter + 1'b1;
                cadence_pulse       <= 1'b1;
            end
        end
    end
endmodule
