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


//***********************************************************************************************
// Reconfig ROM parser
// Parses the ROM contents
// Generates DPRIO address and control signals for a single xcvr interface
//   - Performs writes for incoming direct XCVR offsets/data/mask
//   - Performs RMW for incoming direct XCVR offsets/data/mask
//   - Performs RMW for handling logical refclk select and logical PLL (CGB) select
//***********************************************************************************************

`timescale 1 ns / 1 ps

module alt_xcvr_native_rcp_load_ctrl_isub23q #(
  parameter ROM_ADD_WIDTH        = 9,
  parameter ROM_DATA_WIDTH        = 32,
  parameter AVMM_ADD_WIDTH        = 19,  // XCVR AVMM1 Address width
  parameter AVMM_DATA_WIDTH       = 8,        // XCVR RCFG data width
  parameter CHANNELS              = 1         // Number of channels in native phy
) (
  input wire avmm_clk,
  input wire avmm_reset,

  //--------------------------------------
  // User Interface
  //--------------------------------------
  input  wire [7:0]    rcp_sel,      //Select one of the PMA ADAPTATION SETTING
  input  wire          rcp_load,

  output reg rcp_load_busy,
  output reg rcp_load_finish,
  output reg rcp_load_timeout,

  output reg [4:0] rcp_load_state,
  output reg [7:0] rcp_load_mail_state,
  output reg [7:0] chnl_id,


  //--------------------------------------
  // PMA ADAPTATION SETTING ROM Interface
  //--------------------------------------
  output reg  [ROM_ADD_WIDTH-1:0] rom_address,
  input  wire [ROM_DATA_WIDTH-1:0] rom_readdata,

  //------------------------------------------------
  // ARBITER Interface
  //------------------------------------------------
  output wire [CHANNELS-1:0]                           avmm_write,
  output wire [CHANNELS-1:0]                           avmm_read,
  output wire [CHANNELS * AVMM_ADD_WIDTH-1:0]         avmm_address,
  output wire [CHANNELS * AVMM_DATA_WIDTH-1:0]         avmm_writedata,
  input  wire [CHANNELS * AVMM_DATA_WIDTH-1:0]         avmm_readdata,
  input  wire [CHANNELS-1:0]                           avmm_waitrequest

);


`ifdef ALTERA_RESERVED_QIS
  localparam  MAX = 200000;//2ms
`else
  localparam  MAX = 1000; //1us
`endif


  // Parser states
  localparam [4:0] RCP_IDLE        = 5'h00;
  localparam [4:0] INIT_RCP     = 5'h01;
  localparam [4:0] READ_ROM        = 5'h02;
  localparam [4:0] WAIT_ROM_DATA   = 5'h03;
  localparam [4:0] SKIP_TRANSFER   = 5'h04;
  localparam [4:0] SEND_DATA       = 5'h05;
  localparam [4:0] END_OF_RCP      = 5'h06;
  localparam [4:0] QUERY_CHNL_0_ID = 5'h07;
  localparam [4:0] CHNL_INCR       = 5'h08;
  localparam [4:0] COPY_RCP        = 5'h0A;
  localparam [4:0] RCP_TIMEOUT     = 5'h0B;
  localparam [4:0] RCP_FINISH      = 5'h0C;

  localparam [7:0] MAIL_IDLE        = 8'h00;
  localparam [7:0] MAIL_WRITE       = 8'h01;
  localparam [7:0] WAIT_WRITE       = 8'h02;
  localparam [7:0] READ_207         = 8'h03;
  localparam [7:0] WAIT_207         = 8'h04;
  localparam [7:0] READ_204         = 8'h05;
  localparam [7:0] WAIT_204         = 8'h06;
  localparam [7:0] MAIL_TO     = 8'h07;
  localparam [7:0] MAIL_FINISH      = 8'h08;

  localparam [19:0] SEND_MAILBOX_ADDR0   = 19'h0_0200;
  localparam [19:0] SEND_MAILBOX_ADDR1   = 19'h0_0201;
  localparam [19:0] SEND_MAILBOX_ADDR2   = 19'h0_0202;
  localparam [19:0] SEND_MAILBOX_ADDR3   = 19'h0_0203;

  localparam [19:0] RCV_MAILBOX_ADDR0   =  19'h0_0204;
  localparam [19:0] RCV_MAILBOX_ADDR1   =  19'h0_0205;
  localparam [19:0] RCV_MAILBOX_ADDR2   =  19'h0_0206;
  localparam [19:0] RCV_MAILBOX_ADDR3   =  19'h0_0207;

  reg [11:0] timer;

  reg [4:0]  load_state;
  reg [7:0]  mail_state;

  reg [2:0]  addr_incr;
  reg [7:0]  chnl_0_id;
  reg [4:0]  cur_chnl;

  reg new_mail;
  reg chnl_id_query;
  reg  [31:0] mail_data;

  wire [31:0] chnls;

  reg                            rcp_avmm_write;
  reg                            rcp_avmm_read;
  reg [AVMM_ADD_WIDTH-1:0]       rcp_avmm_address;
  reg [AVMM_DATA_WIDTH-1:0]      rcp_avmm_writedata;
  wire[AVMM_DATA_WIDTH-1:0]      rcp_avmm_readdata;
  wire                           rcp_avmm_waitrequest;
  reg mail_timeout, mail_finish;

assign chnls = CHANNELS;
  genvar ig;
  generate
      for(ig=0;ig<CHANNELS;ig=ig+1) begin : g_ifs
        assign avmm_write [ig]  = (ig == cur_chnl)? rcp_avmm_write : 1'b0;
        assign avmm_read  [ig]  = (ig == cur_chnl)? rcp_avmm_read  : 1'b0;
        assign avmm_writedata [ig*AVMM_DATA_WIDTH +: AVMM_DATA_WIDTH]   = (ig == cur_chnl)? rcp_avmm_writedata : 8'h00;
        assign avmm_address [ig*AVMM_ADD_WIDTH +: AVMM_ADD_WIDTH]       = (ig == cur_chnl)? rcp_avmm_address : 19'h0_0000;
      end
  endgenerate
 assign rcp_avmm_readdata[7:0]            = avmm_readdata[cur_chnl*8 +: 8];
 assign rcp_avmm_waitrequest        = avmm_waitrequest[cur_chnl];

  //***********************************************************************
  //*************************ROM LOAD State Machine************************

always@(posedge avmm_clk or posedge avmm_reset) begin
   if (avmm_reset) begin
       load_state                    <= 5'h00;
       rcp_load_state                <= 5'h00;

       new_mail                      <= 1'b0;
       mail_data                     <= 32'h0000_0000;
       chnl_id_query                 <= 1'b0;
       cur_chnl                      <= 5'h00;
       rom_address                   <= {ROM_ADD_WIDTH{1'b0}};  //TO BE FIXED WITH REAL ROM ADD WIDTH
       rcp_load_finish               <= 1'b0;
       rcp_load_busy                 <= 1'b0;
       rcp_load_timeout              <= 1'b0;
       chnl_id                       <= 8'h00;

   end else begin
       case(load_state)

       RCP_IDLE: begin

//         rcp_load_state                <= 5'h00;
          new_mail                      <= 1'b0;
          mail_data                     <= 32'h0000_0000;
          chnl_id_query                 <= 1'b0;
          cur_chnl                      <= 5'h00;
          rom_address                   <= {ROM_ADD_WIDTH{1'b0}};
          if (rcp_load) begin
             rcp_load_finish               <= 1'b0;
             rcp_load_busy                 <= 1'b1;
             rcp_load_timeout              <= 1'b0;
             load_state                    <= INIT_RCP;
          end else begin
             rcp_load_busy                 <= 1'b0;
             load_state                    <= RCP_IDLE;
          end
       end

       INIT_RCP: begin
          new_mail     <= 1'b1;
          mail_data     <= 32'h90_00_00_02; // Initializa PMA ADAPTATION PART A+B
          rcp_load_state <= load_state;
          if (mail_finish) load_state <= READ_ROM;
          else if (mail_timeout) load_state <= RCP_TIMEOUT;
          if (rcp_load_state == load_state) new_mail <= 1'b0;
       end

       READ_ROM: begin
          if ((rom_readdata[ROM_DATA_WIDTH-1]==1'b1) && (&rom_readdata[ROM_DATA_WIDTH-2:0]) != 1'b1) begin //NEW MESSAGE, NOT END OF PMA ADAPTATION SETTINGS
             load_state   <= SEND_DATA;
             rcp_load_state <= load_state;
          end else if (!rom_readdata[31]) begin  //DEFAULT VALUE
             rom_address <= rom_address + 1'b1;
          end else begin
              load_state <= END_OF_RCP;
          end
       end

       SEND_DATA: begin
          new_mail        <= 1'b1;
          mail_data        <= rom_readdata;
          rcp_load_state  <= load_state;
          if (mail_finish) begin
              load_state  <= WAIT_ROM_DATA;
              rom_address <= rom_address + 1'b1;
          end else if (mail_timeout) load_state <= RCP_TIMEOUT;
          if (rcp_load_state == load_state) new_mail <= 1'b0;
       end
       WAIT_ROM_DATA:begin
              load_state  <= READ_ROM;
       end

       END_OF_RCP: begin
          rcp_load_state <= load_state;
          if (CHANNELS == 1) load_state <= RCP_FINISH;
          else load_state <= QUERY_CHNL_0_ID;
       end

       QUERY_CHNL_0_ID: begin
          new_mail       <= 1'b1;
          chnl_id_query  <= 1'b1;
          mail_data       <= 32'h97_00_00_00; //QUERY CHNL0 PHYSICAL CHNL ID
          rcp_load_state <= load_state;
          if (mail_finish) begin
              load_state    <= CHNL_INCR;
              chnl_id_query <= 1'b0;
          end else if (mail_timeout) load_state <= RCP_TIMEOUT;
          if (rcp_load_state == load_state) new_mail <= 1'b0;
       end


       CHNL_INCR: begin
          rcp_load_state <= load_state;
          if (cur_chnl == 5'h00) begin
             load_state <= COPY_RCP;
             cur_chnl <= cur_chnl + 1'b1;
          end else if (cur_chnl < (CHANNELS-1)) begin
              cur_chnl <= cur_chnl + 1'b1;
              load_state <= COPY_RCP;
          end else load_state <= RCP_FINISH;
       end

       COPY_RCP: begin
          new_mail           <= 1'b1;
          mail_data[31:8]     <= 32'h95_00_00;
          mail_data[7:0]      <= chnl_0_id;
          chnl_id            <= chnl_0_id;
          rcp_load_state     <= load_state;
          if (mail_finish) begin
              load_state     <= CHNL_INCR;
//              cur_chnl       <= cur_chnl + 1'b1;
          end else if (mail_timeout) load_state <= RCP_TIMEOUT;
          if (rcp_load_state == load_state) new_mail <= 1'b0;

       end

       RCP_TIMEOUT: begin
          rcp_load_busy     <= 1'b0;
          rcp_load_timeout  <= 1'b1;
          rcp_load_finish   <= 1'b0;
          if(!rcp_load)       load_state        <= RCP_IDLE;
       end

       RCP_FINISH: begin
          rcp_load_busy     <= 1'b0;
          rcp_load_timeout  <= 1'b0;
          rcp_load_finish   <= 1'b1;
          if(!rcp_load)   load_state        <= RCP_IDLE;
       end

       default: load_state <= RCP_IDLE;
       endcase
   end


end



reg [1:0] write_cntr;

  //***********************************************************************
  //*************************ROM LOAD State Machine************************
always@(posedge avmm_clk or posedge avmm_reset) begin
   if (avmm_reset) begin
       mail_state           <= MAIL_IDLE;
       rcp_load_mail_state  <= MAIL_IDLE;
       timer                <= 12'h000;
       chnl_0_id            <= 8'h00;
       write_cntr           <= 2'b00;
       rcp_avmm_write           <= 1'b0;
       rcp_avmm_read            <= 1'b0;
       rcp_avmm_writedata       <= 8'h00;
       rcp_avmm_address         <= 19'h0_0000;
       mail_timeout         <= 1'b0;
       mail_finish          <= 1'b0;
   end else begin
     case (mail_state)
        MAIL_IDLE: begin
//          rcp_load_mail_state  <= MAIL_IDLE;
          timer                <= 12'h000;
//          chnl_0_id            <= 8'h00;
          write_cntr           <= 3'b000;
          rcp_avmm_write           <= 1'b0;
          rcp_avmm_read            <= 1'b0;
          rcp_avmm_writedata       <= 8'h00;
          rcp_avmm_address         <= 19'h0_0000;
              mail_timeout         <= 1'b0;
              mail_finish          <= 1'b0;
          if (new_mail) begin
              mail_state      <= MAIL_WRITE;
          end
        end

        MAIL_WRITE: begin
          timer                    <= timer + 1'b1;
          rcp_avmm_write            <= 1'b1;
          rcp_avmm_read             <= 1'b0;
          rcp_load_mail_state      <= mail_state;
          mail_state               <= WAIT_WRITE;
          if (write_cntr == 2'b00) begin
             rcp_avmm_writedata     <= mail_data[7:0];
             rcp_avmm_address       <= 19'h0_0200;
          end else if (write_cntr == 2'b01) begin
             rcp_avmm_writedata     <= mail_data[15:8];
             rcp_avmm_address       <= 19'h0_0201;
          end else if (write_cntr == 2'b10) begin
             rcp_avmm_writedata     <= mail_data[23:16];
             rcp_avmm_address       <= 19'h0_0202;
          end else if (write_cntr == 2'b11) begin
             rcp_avmm_writedata     <= mail_data[31:24];
             rcp_avmm_address       <= 19'h0_0203;
          end
        end

        WAIT_WRITE: begin
            rcp_load_mail_state  <= mail_state;
            timer                <= timer + 1'b1;
            if (rcp_avmm_waitrequest==1'b0 && write_cntr == 2'b11) begin
               mail_state        <= READ_207;
               write_cntr        <= 2'b00;
               rcp_avmm_write     <= 1'b0;
            end else if (rcp_avmm_waitrequest==1'b0 && write_cntr != 2'b11) begin
               mail_state        <= MAIL_WRITE;
               write_cntr        <= write_cntr + 1'b1;
               rcp_avmm_write     <= 1'b0;
            end else if (rcp_avmm_waitrequest==1'b0 && timer >= MAX) begin
               mail_state        <= MAIL_TO;
               write_cntr        <= 2'b00;
               rcp_avmm_write     <= 1'b0;
            end
        end

       READ_207: begin
          rcp_load_mail_state      <= mail_state;
          timer                    <= timer + 1'b1;
          rcp_avmm_write           <= 1'b0;
          rcp_avmm_read            <= 1'b1;
          mail_state               <= WAIT_207;
          rcp_avmm_writedata       <= 8'h00;
          rcp_avmm_address         <= 19'h0_0207;
       end

        WAIT_207: begin
            rcp_load_mail_state  <= mail_state;
            timer                <= timer + 1'b1;
            if (rcp_avmm_waitrequest==1'b0 && rcp_avmm_readdata[7] == 1'b1 && rcp_avmm_readdata[0] == 1'b0 && chnl_id_query == 1'b0)  begin //FIRMWARE DONE SUCCESSFULLY
               mail_state        <= MAIL_FINISH;
               rcp_avmm_read      <= 1'b0;
               rcp_avmm_address   <= 19'h0_0000;
            end else if (rcp_avmm_waitrequest==1'b0 && rcp_avmm_readdata[7] == 1'b1 && rcp_avmm_readdata[0] == 1'b0 && chnl_id_query == 1'b1) begin //FIRMWARE RETURN CHNL 0 ID
               mail_state        <= READ_204;
               rcp_avmm_read      <= 1'b0;
               rcp_avmm_address   <= 19'h0_0000;
            end else if (rcp_avmm_waitrequest==1'b0 && rcp_avmm_readdata[7] == 1'b1 && rcp_avmm_readdata[0] == 1'b1) begin //FIRMWARE FAILED
               mail_state        <= MAIL_TO;
               rcp_avmm_read      <= 1'b0;
               rcp_avmm_address <= 19'h0_0000;
            end else if (rcp_avmm_waitrequest==1'b0 && rcp_avmm_readdata[7] != 1'b1) begin //FIRMWARE IN PROGRESS
               mail_state        <= READ_207;
               rcp_avmm_read      <= 1'b0;
               rcp_avmm_address   <= 19'h0_0000;
           end else if (rcp_avmm_waitrequest==1'b0 && timer >= MAX) begin
               mail_state        <= MAIL_TO;
               rcp_avmm_read      <= 1'b0;
               rcp_avmm_address   <= 19'h0_0000;
            end
        end

       READ_204: begin
          rcp_load_mail_state      <= mail_state;
          timer                    <= timer + 1'b1;
          rcp_avmm_write           <= 1'b0;
          rcp_avmm_read            <= 1'b1;
          mail_state               <= WAIT_204;
          rcp_avmm_address         <= 19'h0_0204;
       end

        WAIT_204: begin
            rcp_load_mail_state  <= mail_state;
            timer                <= timer + 1'b1;
            if (rcp_avmm_waitrequest==1'b0)  begin //FIRMWARE DONE SUCCESSFULLY
               mail_state        <= MAIL_FINISH;
               rcp_avmm_read     <= 1'b0;
               rcp_avmm_address  <= 19'h0_0000;
               chnl_0_id         <= rcp_avmm_readdata;
           end else if (rcp_avmm_waitrequest==1'b0 && timer >= MAX) begin
               mail_state        <= MAIL_TO;
               rcp_avmm_read      <= 1'b0;
               rcp_avmm_address   <= 19'h0_0000;
            end
        end

        MAIL_TO: begin
          rcp_avmm_write           <= 1'b0;
          rcp_avmm_read            <= 1'b0;
          rcp_avmm_writedata       <= 8'h00;
          rcp_avmm_address         <= 19'h0_0000;
           mail_timeout        <= 1'b1;
           mail_finish         <= 1'b0;
           mail_state          <= MAIL_IDLE;
        end
        MAIL_FINISH: begin
          rcp_avmm_write           <= 1'b0;
          rcp_avmm_read            <= 1'b0;
          rcp_avmm_writedata       <= 8'h00;
          rcp_avmm_address         <= 19'h0_0000;
          mail_timeout         <= 1'b0;
          mail_finish          <= 1'b1;
          mail_state          <= MAIL_IDLE;
        end

        default: mail_state <= MAIL_IDLE;
     endcase
  end
end
endmodule
