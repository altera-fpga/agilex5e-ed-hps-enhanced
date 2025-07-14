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


`timescale 1ns / 1ns
module alt_ehipc3_fm_ptp_rx_ts_adj_detect (
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic        i_rx_valid,
    input  logic        i_rx_am,
    input  logic        i_cfg_remove_rx_pad,
    input  logic        i_cfg_enforce_max_rx,

    output logic        o_correct_ts
);

logic   [3:0]   vl_position;
logic           am_detect_r;
logic           am_detect_rise;
logic   [3:0]   count;

//Set the vl_position based on the configuration of the RX MAC. If remove
//pads or enforce max frame size is on, VL_POSITION is 4, otherwise it is
//3, due to the latency added by the pad stripper
assign  vl_position =   i_cfg_remove_rx_pad     ?   4'd4:
                        i_cfg_enforce_max_rx    ?   4'd4:
                                                    4'd3;

//Sample o_rx_am using the clock to find a 0->1 transition. Do not use
//data valid for this sample
always_ff @(posedge i_clk)
if(~i_rst_n)    am_detect_r <=  1'b0;
else            am_detect_r <=  i_rx_am;


assign  am_detect_rise  =   i_rx_am                     //am high
                            && !am_detect_r             //..was low
                            && (count == {4{1'b1}});    //..and was waiting for am


//Count valid cycles to find the first cycle of data after the AMs
always_ff @(posedge i_clk)
if(~i_rst_n) count   <=  '1;
else         count   <=  am_detect_rise         ?   {4{1'b0}}:  //Reset
                         !i_rx_valid            ?   count:      //Freeze
                         (count == {4{1'b1}})   ?   count:      //Saturate
                                                    (count+1'b1);  //Increment

//If sof occurs on a cycle where o_correct_ts is high,
//either subtract 330 UI from the timestamp (about 12.8ns) or drop the
//packet
assign  o_correct_ts  =   (count == vl_position) && i_rx_valid;

endmodule : alt_ehipc3_fm_ptp_rx_ts_adj_detect
