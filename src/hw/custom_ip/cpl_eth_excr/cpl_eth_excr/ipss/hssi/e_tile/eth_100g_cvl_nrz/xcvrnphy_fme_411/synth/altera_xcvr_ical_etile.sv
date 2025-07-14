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



module altera_xcvr_ical_etile #( //This module is per channel based
  parameter INT_STEPS = 10,
  parameter POWER_ON_ICAL = 1
)
(

//CUSTOMER AVMM SIDE
input user_clk,
input user_read,
input user_write,
input [18:0] user_address,
input [7:0] user_writedata,
input user_reset,
output [7:0] user_readdata,
output user_waitrequest,


//CORE-IP AVMM SIDE
output reg avmm_read,
output reg avmm_write,
output reg [18:0] avmm_address,
output reg [7:0] avmm_writedata,
input reg [7:0] avmm_readdata,
input reg avmm_waitrequest,

output avmm_clk,


// iCal SM SERDES STATUS
input pma_rx_ready,
input pma_tx_ready,
input pma_lock2data,

//to CSR, RESET, native phy output
//to CSR
output reg [7:0] ical_cur_state,
output reg [7:0] intrpt_state,
output reg ical_in_progress,

input r_user_ical_req, // "1" to enable recal

output reg ical_finish,
output reg ical_timeout,

// from interrupt table
input [(INT_STEPS*3-1):0] int_type,
input [(INT_STEPS*16-1):0] int_code,
input [(INT_STEPS*16-1):0] int_data,
input [(INT_STEPS*8-1):0] int_expt

);

`ifdef ALTERA_RESERVED_QIS
  localparam  TIMEOUT_CYCLE = 50000000;
`else
  localparam  TIMEOUT_CYCLE = 500; //5us
`endif

//reg pwron_req;
//initial begin
//   pwron_req = POWER_ON_ICAL;
//pwron_req = 1;
//end

localparam ICAL_INITIAL = 8'h00;
localparam ICAL_CHECK_POWER_ON = 8'h01;
localparam ICAL_CHECK_8B = 8'h02;
localparam ICAL_WAIT_8B = 8'h03;
localparam ICAL_WAIT_REQ = 8'h04;
localparam ICAL_STEP1 = 8'h05;
localparam ICAL_STEP_MOVE = 8'h06;
localparam ICAL_FINISH_STAGE = 8'h3F;
localparam ICAL_TIMEOUT_STAGE = 8'h3E;

localparam ICAL_MAX = 8;

reg [63:0] cntr;
reg [7:0] ical_step;
reg [7:0] ical_state;
reg intrpt_req;
reg int_finish, int_timeout;
reg [7:0] intrpt_code1, intrpt_code2, intrpt_data1, intrpt_data2, intrpt_exp_data;
reg [2:0] intrpt_type;

reg ical_read, ical_write;
reg [7:0] ical_writedata, ical_readdata;
reg [10:0] ical_address;

reg ical_check_serdes;
reg [10:0] ical_serdes_address;
reg ical_serdes_read;

assign ical_reset_n = pma_rx_ready & pma_tx_ready & (!user_reset);

always @(posedge avmm_clk or negedge ical_reset_n) begin
   if(ical_reset_n == 0) begin
      ical_state <= 8'h00;
      ical_finish <= 1'b0;
      ical_timeout <= 1'b0;
      ical_in_progress <= 1'b0;
      ical_step <= 8'h00;
      ical_cur_state <= 8'h00;
      ical_check_serdes <= 1'b0;
      ical_serdes_address <= 11'h000;
      ical_serdes_read <= 1'b0;
      intrpt_req <= 1'b0;
   end else begin
      case (ical_state)
      ICAL_INITIAL: begin
         ical_state <= 8'h00;
         ical_finish <= 1'b0;
         ical_timeout <= 1'b0;
         ical_in_progress <= 1'b0;
         ical_step <= 8'h00;
         intrpt_req <= 1'b0;
         ical_cur_state <= ical_state;
         if(pma_rx_ready == 1 && pma_tx_ready == 1) ical_state <= ICAL_CHECK_POWER_ON;
         else ical_state <= ICAL_INITIAL;
      end
      ICAL_CHECK_POWER_ON: begin
         ical_cur_state <= ical_state;
//         if(pwron_req == 0 && r_user_ical_req == 0) ical_state <= ICAL_FINISH_STAGE;
         if(r_user_ical_req == 0) ical_state <= ICAL_FINISH_STAGE;
         else ical_state <= ICAL_WAIT_REQ;
      end

      ICAL_WAIT_REQ: begin
 //         ical_cur_state <= ical_state;
          intrpt_req <= 1'b0;
//          if (pwron_req == 1 | r_user_ical_req == 1) begin
          if (r_user_ical_req == 1) begin
             ical_in_progress <= 1'b1;
             ical_state <= ICAL_CHECK_8B;
             ical_finish <= 1'b0;
             ical_timeout <= 1'b0;

          end else begin
               ical_state <= ICAL_WAIT_REQ;
          end
      end

     ICAL_CHECK_8B: begin
        ical_check_serdes <= 1'b1;
        ical_serdes_read <= 1'b1;
        ical_serdes_address <= 10'h08b;
        ical_state <= ICAL_WAIT_8B;
        ical_cur_state <= ical_state;
     end

     ICAL_WAIT_8B: begin
        ical_cur_state <= ical_state;
        if(avmm_waitrequest == 0) begin
            ical_serdes_read <= 1'b0;
            if (avmm_readdata[0] == 0) begin
                ical_check_serdes <= 1'b0;
                ical_state <= ICAL_STEP1;
                ical_step <= 8'h01;
                intrpt_req <= 1'b1;
	        intrpt_type <= int_type [0 +: 3];
                intrpt_code1 <= int_code [0 +: 8];
                intrpt_code2 <= int_code [8 +: 8];
                intrpt_data1 <= int_data [0 +: 8];
                intrpt_data2 <= int_data [8 +: 8];
                intrpt_exp_data <= int_expt [0 +: 8];

            end else ical_state <= ICAL_CHECK_8B;
        end else ical_state <= ICAL_WAIT_8B;

     end


      ICAL_STEP1: begin
          ical_cur_state <= ical_state;
          if (int_finish == 1 && int_timeout == 0) begin
              ical_state <= ICAL_STEP_MOVE;
//              int_finish <= 1'b0;
//              int_timeout <= 1'b0;
              intrpt_req <= 1'b1;
              ical_step <= ical_step + 1'b1;
	      intrpt_type <= int_type [(ical_step * 3) +: 3];
              intrpt_code1 <= int_code [(ical_step * 16) +: 8];
              intrpt_code2 <= int_code [(ical_step * 16 + 8) +: 8];
              intrpt_data1 <= int_data [(ical_step * 16) +: 8];
              intrpt_data2 <= int_data [(ical_step * 16 + 8) +: 8];
              intrpt_exp_data <= int_expt [(ical_step * 8) +: 8];

          end else if (int_finish == 1 && int_timeout == 1) ical_state <= ICAL_TIMEOUT_STAGE;
          else begin
               ical_state <= ICAL_STEP1;
               intrpt_req <= 1'b0;
          end
      end

      ICAL_STEP_MOVE: begin
          ical_cur_state <= ical_state + ical_step;
          if (int_finish == 1 && int_timeout == 0 && ical_step == ICAL_MAX) begin
              ical_state <= ICAL_FINISH_STAGE;
              intrpt_req <= 1'b0;
          end else if (int_finish == 1 && int_timeout == 0 && intrpt_req == 0) begin
              ical_state <= ICAL_STEP_MOVE;
              ical_step <= ical_step + 1'b1;
              intrpt_req <= 1'b1;
//              int_finish <= 1'b0;
//              int_timeout <= 1'b0;

	      intrpt_type <= int_type [(ical_step * 3) +: 3];
              intrpt_code1 <= int_code [(ical_step * 16) +: 8];
              intrpt_code2 <= int_code [(ical_step * 16 + 8) +: 8];
              intrpt_data1 <= int_data [(ical_step * 16) +: 8];
              intrpt_data2 <= int_data [(ical_step * 16 + 8) +: 8];
              intrpt_exp_data <= int_expt [(ical_step * 8) +: 8];

          end else if (int_finish == 1 && int_timeout == 1) begin
              ical_state <= ICAL_TIMEOUT_STAGE;
          end else if (int_finish == 0) begin
              ical_state <= ICAL_STEP_MOVE;
              intrpt_req <= 1'b0;
          end
      end

      ICAL_FINISH_STAGE: begin
//          pwron_req <= 1'b0;
          ical_finish <= 1'b1;
          ical_timeout <= 1'b0;
          ical_in_progress <= 1'b0;
          intrpt_req <= 1'b0;
          if (r_user_ical_req == 0) ical_state <= ICAL_WAIT_REQ;
          else ical_state <= ICAL_FINISH_STAGE;
      end

      ICAL_TIMEOUT_STAGE: begin
//          pwron_req <= 1'b0;
          ical_finish <= 1'b1;
          ical_timeout <= 1'b1;
          ical_in_progress <= 1'b0;
          intrpt_req <= 1'b0;
          if (r_user_ical_req == 0) ical_state <= ICAL_WAIT_REQ;
          else ical_state <= ICAL_TIMEOUT_STAGE;
      end

      default: ical_state <= ICAL_INITIAL;

      endcase
   end
end

reg [2:0] intrpt_data_code;
reg [2:0] intrpt_step_type;
reg [7:0] int_8a_readdata;


`ifdef ALTERA_RESERVED_QIS
  localparam [63:0] MAX = 64'h0000_0000_FFFF_FFFF; // 2^32 ~ 4*10^9
`else
  localparam [63:0] MAX = 64'h0000_0000_0000_1000; //2^12 = 4096
`endif


localparam INTRPT_INITIAL = 8'h00;
localparam WAIT_REQ = 8'h01;
localparam WAIT_LOCK_2_DATA = 8'h02;
localparam WR_INTRPT_DATA_CODE = 8'h03;
localparam WAIT_WR_INTRPT = 8'h04;
localparam RD_8AB = 8'h05;
localparam WAIT_8AB = 8'h06;
localparam CLEAR_8A = 8'h07;
localparam WAIT_CLEAR_8A = 8'h08;
localparam CHECK_RD_88 = 8'h09;
localparam WAIT_88 = 8'h0a;
localparam INTRPT_FINISH_STAGE = 8'h0b;
localparam INTRPT_TIMEOUT_STAGE = 8'h0c;


always @(posedge avmm_clk or negedge ical_reset_n) begin
   if(ical_reset_n == 0) begin
      intrpt_state <= 8'h00;
      int_finish <= 1'b0;
      int_timeout <= 1'b0;
      intrpt_data_code <= 3'b000;
      cntr <= 64'h0000_0000_0000_0000;
      ical_read <= 1'b0;
      ical_write <= 1'b0;
      ical_writedata <= 8'h00;
      ical_address <= 11'h000;
      ical_readdata <= 8'h00;

   end else begin
      case (intrpt_state)

      INTRPT_INITIAL: begin
         intrpt_state <= 8'h00;
         int_finish <= 1'b0;
         int_timeout <= 1'b0;
         intrpt_data_code <= 2'b00;
         cntr <= 64'h0000_0000_0000_0000;
         ical_read <= 1'b0;
         ical_write <= 1'b0;
         ical_writedata <= 8'h00;
         ical_address <= 11'h000;
         ical_readdata <= 8'h00;
         intrpt_state <= WAIT_REQ;
      end

      WAIT_REQ: begin
         cntr <= 64'h0000_0000_0000_0000;
/*         if ( intrpt_req == 1 && (intrpt_type == 3'b000 || intrpt_type == 3'b001)) begin
            intrpt_state <= WR_INTRPT_DATA_CODE;
            intrpt_data_code <= 3'b000;
         end else if ( intrpt_req == 1 && intrpt_type == 3'b010) begin
            intrpt_state <= WAIT_LOCK_2_DATA;
            int_finish <= 1'b0;
            int_timeout <= 1'b0;
            intrpt_req <= 1'b0;
         end else intrpt_state <= WAIT_REQ;
*/
            int_finish <= 1'b0;
            int_timeout <= 1'b0;
         if ( intrpt_req == 1 ) begin
            intrpt_state <= WR_INTRPT_DATA_CODE;
            intrpt_data_code <= 3'b000;

         end else intrpt_state <= WAIT_REQ;

      end

      WR_INTRPT_DATA_CODE: begin
         cntr <= cntr + 1;
//         intrpt_req <= 1'b0;
         if (intrpt_data_code == 3'b000) begin
            intrpt_step_type <= intrpt_type;
            ical_address <= 10'h084;
            ical_writedata <= intrpt_data1;
         end else if (intrpt_data_code == 3'b001) begin
            ical_address <= 10'h085;
            ical_writedata <= intrpt_data2;
         end else if (intrpt_data_code == 3'b010) begin
            ical_address <= 10'h086;
            ical_writedata <= intrpt_code1;
         end else if (intrpt_data_code == 3'b011) begin
            ical_address <= 10'h087;
            ical_writedata <= intrpt_code2;
         end else if (intrpt_data_code == 3'b100) begin
            ical_address <= 10'h090;
            ical_writedata <= 8'h01;
         end

         if (intrpt_data_code > 4) begin
            intrpt_state <= RD_8AB;
            intrpt_data_code <= 3'b000;
            ical_write <= 1'b0;
         end else begin
            ical_write <= 1'b1;
            intrpt_state <= WAIT_WR_INTRPT;
         end
      end

      WAIT_WR_INTRPT: begin
         cntr <= cntr + 1;
         if (cntr >= MAX && avmm_waitrequest == 0) begin
            intrpt_state <= INTRPT_TIMEOUT_STAGE;
            ical_write <= 1'b0;
         end else if (avmm_waitrequest == 0) begin
//            cntr <= cntr + 1;
            ical_write <= 1'b0;
            ical_address <= 10'b000;
            ical_writedata <= 8'h00;
            intrpt_data_code <= intrpt_data_code + 1'b1;
            intrpt_state <= WR_INTRPT_DATA_CODE;
         end else begin
//            cntr <= cntr + 1;
            intrpt_state <= WAIT_WR_INTRPT;
         end
      end

      RD_8AB: begin
         cntr <= cntr + 1;
         if (intrpt_data_code[2:1] == 2'b00 ) begin
             intrpt_state <= WAIT_8AB;
             ical_read <= 1'b1;
             ical_write <= 1'b0;
             if (intrpt_data_code == 3'b000)    ical_address <= 10'h08a;
             else if (intrpt_data_code == 3'b001)  ical_address <= 10'h08b;
         end else if (intrpt_type == 3'b000) intrpt_state <= CLEAR_8A;
         else if (intrpt_type == 3'b001) intrpt_state <= CHECK_RD_88;
         else if (intrpt_type == 3'b010) intrpt_state <= WAIT_LOCK_2_DATA;
     end

      WAIT_8AB:begin
          cntr <= cntr + 1;
          if (cntr >= MAX && avmm_waitrequest == 0) begin
              intrpt_state <= INTRPT_TIMEOUT_STAGE;
              ical_read <= 1'b0;
          end else if (avmm_waitrequest == 1) intrpt_state <= WAIT_8AB; //cntr <= cntr + 1;
          else if (avmm_waitrequest == 0 && intrpt_data_code == 3'b000 && avmm_readdata[7] ==1 ) begin
              ical_read <= 1'b0;
              intrpt_data_code <= intrpt_data_code + 1;
              int_8a_readdata <= avmm_readdata; //save for later
              intrpt_state <= RD_8AB;
          end else if (avmm_waitrequest == 0 && intrpt_data_code == 3'b001 && avmm_readdata[0] == 0 ) begin
              ical_read <= 1'b0;
              intrpt_data_code <= intrpt_data_code + 1'b1;
              intrpt_state <= RD_8AB;
          end else  begin
//              if (avmm_readdatavalid == 1 && (intrpt_data_code == 3'b000 && avmm_readdata[7] !=1) || (intrpt_data_code == 3'b001 && avmm_readdata[0] != 0 ) )
              intrpt_state <= RD_8AB;
              ical_read <= 1'b0;
          end
      end

      WAIT_LOCK_2_DATA: begin
          if (pma_lock2data == 1) intrpt_state <= CLEAR_8A;
          else if (cntr <= MAX) cntr <= cntr + 1;
          else intrpt_state <= INTRPT_TIMEOUT_STAGE;
      end


     CHECK_RD_88:begin
         cntr <= cntr + 1;
         ical_write <= 1'b0;
         ical_read <= 1'b1;
         ical_address <= 10'h88;
         intrpt_state <= WAIT_88;
     end


     WAIT_88: begin
          cntr <= cntr + 1;
          if (cntr >= MAX && avmm_waitrequest == 0) begin
              intrpt_state <= INTRPT_TIMEOUT_STAGE;
              ical_read <= 1'b1;
          end else if (avmm_waitrequest == 1) intrpt_state <= WAIT_88; // cntr <= cntr + 1;
//          else if (avmm_waitrequest == 0 && (avmm_readdata == intrpt_exp_data || (intrpt_exp_data == 8'h80 && avmm_readdata[7] == 1 ))) begin
          else if (avmm_waitrequest == 0 && avmm_readdata == intrpt_exp_data ) begin
              ical_read <= 1'b0;
              intrpt_state <= CLEAR_8A;
          end else if (avmm_waitrequest == 0 && avmm_readdata != intrpt_exp_data && intrpt_exp_data == 8'h80) begin
              ical_read <= 1'b0;
              intrpt_state <= WR_INTRPT_DATA_CODE;
          end else begin
              intrpt_state <= CHECK_RD_88;
              ical_read <= 1'b0;
          end
     end

      CLEAR_8A: begin
          ical_read <= 1'b0;
          ical_write <= 1'b1;
          ical_address <= 10'h08a;
          ical_writedata <= int_8a_readdata | 8'h01;
          intrpt_state <= WAIT_CLEAR_8A;
          cntr <= cntr + 1;
      end

      WAIT_CLEAR_8A: begin
         cntr <= cntr + 1;
         if (cntr >= MAX && avmm_waitrequest == 0) begin
            intrpt_state <= INTRPT_TIMEOUT_STAGE;
            ical_write <= 1'b0;
         end else if (avmm_waitrequest == 0) begin
            ical_write <= 1'b0;
            ical_address <= 10'b000;
            ical_writedata <= 8'h00;
            intrpt_state <= INTRPT_FINISH_STAGE;

         end

      end


     INTRPT_TIMEOUT_STAGE: begin
        int_finish <= 1'b1;
        int_timeout <= 1'b1;
        ical_read <= 1'b0;
        ical_write <= 1'b0;
        intrpt_state <= WAIT_REQ;
     end

     INTRPT_FINISH_STAGE: begin
        int_finish <= 1'b1;
        int_timeout <= 1'b0;
        ical_read <= 1'b0;
        ical_write <= 1'b0;
        intrpt_state <= WAIT_REQ;
     end

     default: intrpt_state <= INTRPT_INITIAL;

   endcase
  end
end

assign avmm_clk = user_clk;
assign avmm_read = ical_in_progress ? (ical_check_serdes? ical_serdes_read : ical_read) : user_read;
assign avmm_write = ical_in_progress ? ical_write : user_write;
assign avmm_writedata = ical_in_progress ? ical_writedata : user_writedata;
assign avmm_address = ical_in_progress? (ical_check_serdes? {8'h00,ical_serdes_address} : {8'h00,ical_address}) : user_address;
assign user_readdata = ical_in_progress ? 8'h00:avmm_readdata;
assign user_waitrequest = ical_in_progress ? 1'b1 : avmm_waitrequest;

endmodule
