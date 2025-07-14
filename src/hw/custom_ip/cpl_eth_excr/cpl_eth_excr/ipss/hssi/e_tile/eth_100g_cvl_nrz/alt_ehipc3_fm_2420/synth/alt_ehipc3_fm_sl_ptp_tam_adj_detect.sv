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
module alt_ehipc3_fm_sl_ptp_tam_adj_detect (
    input  logic        i_enable_rsfec,

    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic        i_rx_valid,
    input  logic        i_rx_am,
    input  logic        i_pcs_fully_aligned,
    input logic         i_sl_ptp_rx_aib_dsk_done_b4_dsk,

    output logic        o_modify_ts
);

localparam      ST_IDLE             =   2'd0;
localparam      ST_NORMAL_PERIOD    =   2'd1;
localparam      ST_SHORT_PERIOD     =   2'd2;
localparam      ST_UNUSED           =   2'd3;

logic           first_am;
logic           am_detect_r;
logic           am_detect_rise;
logic   [1:0]   count;
logic   [2:0]   count_plus_one;
logic           am_period_short;
logic           am_period_long;
logic   [1:0]   state;
logic   [1:0]   nextstate;
logic           modify_ts;

always_ff @(posedge i_clk)
if(~i_rst_n)    first_am    <=  1'b0;
else if(!i_pcs_fully_aligned) first_am    <=  1'b0;
else            first_am    <=  first_am ? 1'b1 : (i_rx_am && i_sl_ptp_rx_aib_dsk_done_b4_dsk);

//Sample o_am_valid using the clock to find a 0->1 transition. Do not use
//data valid for this sample
always_ff @(posedge i_clk)
//if(~i_rst_n)    am_detect_r <=  1'b0;
//else            am_detect_r <=  i_rx_am;
            am_detect_r <=  i_rx_am;

assign          am_detect_rise  =   i_rx_am && !am_detect_r && first_am;

//Seperately, count valid cycles between alignement marker indications
assign          count_plus_one = count + 1'b1;
always_ff @(posedge i_clk)
if(~i_rst_n)    count   <=  2'd0;
else            count   <=  !first_am       ?   2'd0:
                            am_detect_rise & i_rx_valid  ?   2'd1:
                            am_detect_rise  ?   2'd0:
                            !i_rx_valid ?       count:
                                                count_plus_one[1:0];

//We determine whether the am count was the right size by checking
//the remainder after effetively dividing by 4
assign  am_period_long      =   (count == 2'd1);
assign  am_period_short     =   (count == 2'd3);

//Use a small sequencer to resolve whether a correction is needed
always_ff @(posedge i_clk)
if(~i_rst_n)    state   <=  ST_IDLE;
else            state   <=  nextstate;

always_comb begin: nextstate_logic

    case(state)
        //Wait in IDLE until alignment is complete.
        //o_rx_am will pulse several times before this happens
        ST_IDLE: begin
            nextstate   =   i_pcs_fully_aligned     ?   ST_NORMAL_PERIOD:
                                                        ST_IDLE;
            modify_ts   =   1'b0;
        end

        //Currently in a normal period; wait for am_detect, then check if the
        //next period will be normal or short
        ST_NORMAL_PERIOD: begin
            nextstate   =   !am_detect_rise     ?   ST_NORMAL_PERIOD :
                            am_period_short     ?   ST_SHORT_PERIOD :
                                                    ST_NORMAL_PERIOD;
            modify_ts   =   1'b0;
        end

        //Currently in a short period; wait for am_detect, then check whether
        //we recover (long period), or continue
        ST_SHORT_PERIOD: begin
            nextstate   =   !am_detect_rise     ?   ST_SHORT_PERIOD :
                            am_period_long      ?   ST_NORMAL_PERIOD:
                                                    ST_SHORT_PERIOD;
            modify_ts   =   1'b1;
        end

        //Unused state, shouldn't ever end up here
        ST_UNUSED: begin
            nextstate   =   ST_IDLE;
            modify_ts   =   1'b0;
        end

        //x-pessmistic unused state
        default :   begin
            nextstate   =   'x;
            modify_ts   =   'x;
        end
    endcase

end: nextstate_logic

assign o_modify_ts = i_enable_rsfec ? modify_ts : 1'b0;

endmodule : alt_ehipc3_fm_sl_ptp_tam_adj_detect
