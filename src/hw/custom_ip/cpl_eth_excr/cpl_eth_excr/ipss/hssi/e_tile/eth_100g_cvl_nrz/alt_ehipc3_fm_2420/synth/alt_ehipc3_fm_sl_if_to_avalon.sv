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

module alt_ehipc3_fm_sl_if_to_avalon #(
    parameter WORD_WIDTH  = 64,
    parameter EMPTY_BITS  = 3,
    parameter PTP_WIDTH   = 1
) (
    input                     i_clk,
    input                     i_reset,

    input		      i_reset_1,

    input  [WORD_WIDTH-1:0]   i_data,
    input  [EMPTY_BITS-1:0]   i_empty,
    input  [1:0]              i_error,
    input                     i_fcs_error,
    input  [2:0]              i_status,
    input                     i_valid,
    input                     i_inframe,
    input  [PTP_WIDTH-1:0]    i_ptp,

    output reg [WORD_WIDTH-1:0]   o_data,
    output reg                    o_valid,
    output reg                    o_sop,
    output reg                    o_eop,
    output reg [EMPTY_BITS-1:0]   o_empty,
    output reg [5:0]              o_error,
    output reg [39:0]             o_status,
    output reg [PTP_WIDTH-1:0]    o_ptp
);

    //capture all incoming signals
    reg                    inframe_cap;
    reg [WORD_WIDTH-1:0]   data_cap;
    reg [WORD_WIDTH-1:0]   data_realigned_cap;
    reg [EMPTY_BITS-1:0]   empty_cap;
    reg [EMPTY_BITS:0]     empty_cap_calc;
    reg [1:0]              error_cap;
    reg [5:0]              error_pp_cap; //post-processed
    reg                    fcs_error_cap;
    reg [2:0]              status_cap;
    reg [39:0]             status_pp_cap; //post-processed
    reg                    valid_cap;
    reg                    sop_cap;
    reg                    eop_cap;
    reg [PTP_WIDTH-1:0]    ptp_cap;

    reg [WORD_WIDTH-1:0]   data_shifted;
    reg [EMPTY_BITS-1:0]   empty_shifted;
    reg [5:0]              error_shifted;
    reg [39:0]             status_shifted;
    reg [PTP_WIDTH-1:0]    ptp_shifted;

    reg [2:0]              shift_state;
    reg                    start_of_shift;
    reg                    end_of_shift;
    reg                    shift;
    reg                    shift_adv_chck;// to prevent SOP missing due to the delay associated by the HOLD_EOP state when the next frame has SOP at nibble of the word.

    localparam  IDLE_SHIFT     = 0,
                START_OF_SHIFT = 1,
                SHIFT          = 2,
                HOLD_EOP       = 3;

    wire                   inframe        = i_valid ? i_inframe : inframe_cap;
    wire [EMPTY_BITS-1:0]  empty          = i_valid ? i_empty : empty_cap;
    wire [1:0]             error          = i_valid ? i_error : error_cap;
    wire                   fcs_error      = i_valid ? i_fcs_error : fcs_error_cap;
    wire [2:0]             status         = i_valid ? i_status : status_cap;
    wire                   valid          = i_valid & ((inframe && i_empty!=3'd4) | inframe_cap | shift_state==HOLD_EOP); //FB524454 - to make valid only high within a frame
    wire                   sop            = {inframe_cap, inframe} == 2'b01 ? 1'b1 : 1'b0;
    wire                   eop            = {inframe_cap, inframe} == 2'b10 ? 1'b1 : 1'b0;
    wire [WORD_WIDTH-1:0]  data           = i_valid ? i_data : data_cap;
    wire [WORD_WIDTH-1:0]  data_realigned = i_valid ? {data_cap[31:0], i_data[63:32]} : data_realigned_cap;

    // Error
    reg [6:0]   counter;
    reg [7:0]   counter_calc;
    reg [1:0]   state;

    localparam IDLE        = 2'b00,
               COUNT       = 2'b01,
               END_COUNT   = 2'b10;

    assign counter_calc = counter + 4'd8 - (empty*4'd8);

    always @(posedge i_clk) begin
      if (i_reset) begin
        state        <= IDLE;
        counter      <= 0;
      end
      else begin
        case (state)
        IDLE : begin
                 counter <= 0;
                 if ({inframe_cap,inframe} == 2'b01)
                   state <= COUNT;
               end
        COUNT : begin
                  if (i_valid)
                    counter <= counter[6] ? counter : counter_calc[6:0];
                  if (inframe == 1'b1)
                    state <= COUNT;
                  else
                    state <= END_COUNT;
                end
        END_COUNT : begin
                      state <= IDLE;
                    end
        endcase
      end
    end //always


    wire        malformed_err  = (error == 2'b01) ? 1'b1 : 1'b0;
    wire        crc_err        = fcs_error;
    wire        length_err     = (error == 2'b11) ? 1'b1 : 1'b0;
    wire        undersized_err = (error == 2'b10 && !counter[6]) ? 1'b1 : 1'b0;
    wire        oversized_err  = (error == 2'b10 && counter[6]) ? 1'b1 : 1'b0;

    wire [5:0]  error_comb  = {1'b0,length_err,oversized_err,undersized_err,crc_err,malformed_err};

    // Status
    wire        stacked_vlan = (status == 3'd5) ? 1'b1 : 1'b0;
    wire        vlan         = (status == 3'd4) ? 1'b1 : 1'b0;
    wire        pause        = (status == 3'd2) ? 1'b1 : 1'b0;
    wire        pfc          = (status == 3'd3) ? 1'b1 : 1'b0;
    wire        control      = (status == 3'd7) ? 1'b1 : 1'b0;
    wire        illegal      = (status == 3'd6) ? 1'b1 : 1'b0; //unused
    wire        nonfc        = (status == 3'd1) ? 1'b1 : 1'b0; //unused
    wire        nonethertype = (status == 3'd0) ? 1'b1 : 1'b0; //unused

    wire [39:0] status_comb = {pfc,3'd0,pause,control,vlan,stacked_vlan,32'd0};

    always @(posedge i_clk) begin
      if (i_reset) begin
        inframe_cap          <= 0;
        empty_cap            <= 0;
        data_cap             <= 0;
        data_realigned_cap   <= 0;
        error_cap            <= 0;
        error_pp_cap         <= 0;
        fcs_error_cap        <= 0;
        status_cap           <= 0;
        status_pp_cap        <= 0;
        valid_cap            <= 0;
        sop_cap              <= 0;
        eop_cap              <= 0;
      end
      else begin
        inframe_cap          <= inframe;
        empty_cap            <= empty;
        data_cap             <= data;
        data_realigned_cap   <= data_realigned;
        error_cap            <= error;
        error_pp_cap         <= error_comb;
        fcs_error_cap        <= fcs_error;
        status_cap           <= status;
        status_pp_cap        <= status_comb;
        valid_cap            <= valid;
        sop_cap              <= sop;
        eop_cap              <= eop;
      end
    end

    reg [EMPTY_BITS-1:0]   empty_realigned;

    assign empty_cap_calc = 4'd8-(3'd4-empty_cap);

    always @(posedge i_clk) begin
      if (i_reset) begin
        shift_state     <= 0;
        start_of_shift  <= 0;
        end_of_shift    <= 0;
        empty_realigned <= 0;
        shift           <= 0;
	shift_adv_chck  <= 0;
      end
      else begin
        case (shift_state)
        IDLE_SHIFT : begin
                       start_of_shift  <= 0;
                       end_of_shift    <= 0;
                       empty_realigned <= 0;
                       shift           <= 0;
		       shift_adv_chck  <= 0;
                       if (({inframe_cap,inframe}==2'b01) || shift_adv_chck ==1'b1)
                         if (empty==3'd4 || shift_adv_chck ==1'b1) begin
                           shift <= 1;
                           //start_of_shift <= 1;
                           shift_state <= START_OF_SHIFT;
                         end
                     end
        START_OF_SHIFT : begin
                           if (i_valid) begin
                             if ({inframe_cap, inframe}==2'b10)
                               shift_state <= IDLE_SHIFT;
                             else
                               shift_state <= SHIFT;
                           end
                           start_of_shift <= 1;
			   shift_adv_chck <= 1'b0;
                         end
        SHIFT : begin
                  start_of_shift <= 0;
                  if ({inframe_cap,inframe}==2'b10) begin
                    if (empty>=4) begin
                      empty_realigned <= empty-3'd4;
                      end_of_shift <= 1;
                      shift_state <= IDLE_SHIFT;
                    end
                    else
                      shift_state <= HOLD_EOP;
                  end
                end
        HOLD_EOP : begin
                     if (i_valid) begin
                       end_of_shift <= 1;
                       empty_realigned <= empty_cap_calc[EMPTY_BITS-1:0];
                       shift_state <= IDLE_SHIFT;
                     end
		     if ({inframe_cap,inframe}==2'b01) begin
                         if (empty==3'd4) begin
                           shift_adv_chck <= 1'b1;          // to prevent SOP missing due to the delay associated by the HOLD_EOP state when the next frame has SOP at nibble of the word.
                         end
                     end

                   end
        endcase
      end //else
    end //always

    always @(posedge i_clk) begin
      if (i_reset) begin
        data_shifted   <= 0;
        empty_shifted  <= 0;
        error_shifted  <= 0;
        status_shifted <= 0;
      end
      else begin
        data_shifted   <= data_realigned;
        empty_shifted  <= empty_realigned;
        error_shifted  <= error_pp_cap;
        status_shifted <= status_pp_cap;
      end
    end

    always @(posedge i_clk) begin
      if (i_reset_1) begin
	ptp_cap        <= 0;
        ptp_shifted    <= 0;
      end
      else begin
        ptp_cap        <= i_valid ? i_ptp : ptp_cap;
        ptp_shifted    <= ptp_cap;
      end
    end

    // Output data
    always @(posedge i_clk) begin
      if (i_reset) begin
        o_sop    <= 0;
        o_eop    <= 0;
        o_data   <= 0;
        o_empty  <= 0;
        o_error  <= 0;
        o_status <= 0;
        o_valid  <= 0;
      end
      else begin
        o_sop    <= shift ? start_of_shift : sop_cap;
        o_eop    <= shift ? end_of_shift : eop_cap;
        o_data   <= shift ? data_shifted : data_cap;
        o_empty  <= shift ? empty_realigned: empty_cap;
        o_error  <= shift ? (empty_cap>=4 ? error_pp_cap : error_shifted) : error_pp_cap;
        o_status <= shift ? (empty_cap>=4 ? status_pp_cap : status_shifted) : status_pp_cap;
        o_valid  <= valid_cap;
      end
    end

    always @(posedge i_clk) begin
      if (i_reset_1) begin
        o_ptp    <= 0;
      end
      else begin
        o_ptp    <= shift ? ptp_shifted : ptp_cap;
      end
    end

endmodule
