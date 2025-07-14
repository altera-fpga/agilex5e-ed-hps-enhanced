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


//=============================================================================
//Description:
//  This module connects to an ethernet AVMM interface and
//  provides a second AVMM interface for users.
//  * Normally user operations control the ethernet AVMM interface
//  * The module includes a pair of asynchronous handshake interfaces that can
//    are used to request writes to the disable_tx_mac register in the EHIP
//     * When the write operations are requested, the module waits for any
//     AVMM operations in progress to be completed, then performs an AVMM
//     write to the DISABLE_MAC_BIT in the TXMAC_CONTROL_ADDR CSR to either
//     write 1 or 0 to the disable_tx_mac bit
//  * The handshake interfaces are (i_disable_mac<->o_mac_disabled) and
//  (i_enable_mac <-> o_mac_enabled)
//     * The handshake begins when the input port is asserted. It must be held
//     high until the output port is asserted, and then deasserted; only after
//     it is deasserted will the output port be deasserted
//     * Only one of the two handshakes can be active at the same time
//  * The TXMAC_CONTROL_ADDR has other control bits besides disable_tx_mac
//     * Users are allowed to write to the TXMAC_CONTROL_ADDR whenever the
//     module is not using the AVMM to disable or enable the mac
//     * To avoid having to do a Read-Modify-Write operation every time it
//     writes to TXMAC_CONTROL_ADDR, the module keeps a shadow copy of the CSR
//     * Only the active bits of the register (those between SHADOW_MAX and
//     SHADOW_MIN) are actually stored, to save resources
//     * When the module comes out of reset, the first thing it does when it
//     can access the AVMM is read the value of TXMAC_CONTROL_ADDR to
//     initially load the shadow
//     * Whenever the user writes to TXMAC_CONTROL_ADDR, the shadow is updated

`timescale 1ps/1ps

module alt_ehipc3_fm_mac_enable_avmm #(
    parameter   AW                      =   21,         //AVMM Address width
    parameter   DW                      =   32,         //AVMM Data width
    parameter   TXMAC_CONTROL_ADDR      =   21'h40A,    //Address for register with disable bit
    parameter   DISABLE_MAC_BIT         =   2,          //Bit address for disable_tx_mac
    parameter   SHADOW_MAX              =   3,          //Upper bit for shadow register
    parameter   SHADOW_MIN              =   1,           //Lower bit for shadow register
	parameter   FLOW_CONTROL            =   1
)
(
    input   logic                           i_clk,      //Clock for AVMM interfaces
    input   logic                           i_rst_n,    //Synchronous active low AVMM reset

    //AVMM interface to EHIP
    output logic [AW-1:0] o_addr,
    output logic [DW-1:0] o_writedata,
    output logic 	  o_write,
    output logic 	  o_read,
    input logic [DW-1:0]  i_readdata,
    input logic 	  i_readdata_valid,
    input logic 	  i_waitrequest,
    input logic           i_ehip_ready,

    //AVMM interface to Application
    input   logic   [AW-1:0]                i_addr,
    input   logic   [DW-1:0]                i_writedata,
    input   logic                           i_write,
    input   logic                           i_read,
    output  logic   [DW-1:0]                o_readdata,
    output  logic                           o_readdata_valid,
    output  logic                           o_waitrequest,

    //Handshake Interfaces to PAUSE sequencer SM
    input   logic                           i_disable_mac,
    input   logic                           i_enable_mac,
    output  logic                           o_mac_disabled,
    output  logic                           o_mac_enabled,
    // Following signal indicates that AVMM bus is ready for the user now, this signal goes "1" when ehip_ready is "1" and initial shadow register read is done
    output  logic                           o_ehip_shadow,
    input   logic			    i_usr_reconfig_read

);

//=============================================================================
// Declarations

    //State encoding constants
    localparam      STATES              =   9;
    localparam      ST_FIRST            =   0;
    localparam      ST_READ_SHADOW_1    =   1;
    localparam      ST_READ_SHADOW      =   2;
    localparam      ST_IDLE             =   3;
    localparam      ST_WRITE_DISABLE    =   4;
    localparam      ST_WRITE_ENABLE     =   5;
    localparam      ST_WRITE_SHADOW     =   6;
    localparam      ST_WRITE_DONE       =   7;
    localparam      ST_ERROR            =   8;

    //Shadow register width constant
    localparam      SHW                 =   SHADOW_MAX
                                            - SHADOW_MIN
                                            + 1;

    logic                                   enable_mac_req;     //Synchronized mac enable request
    logic                                   disable_mac_req;    //Synchronized mac disable request
    logic           [STATES-1:0]            state;              //State register
    logic           [STATES-1:0]            nextstate;          //Nextstate value
    logic                                   ehip_read;          //Read signal to ehip
    logic                                   ehip_write;         //Write signal to ehip
    logic           [AW-1:0]                ehip_address;       //Address to ehip
    logic           [DW-1:0]                ehip_writedata;     //Writedata to ehip
    logic                                   user_waitrequest;   //Waitrequest to user
    logic                                   user_readdata_valid;//Read data valid to user
    logic                                   store_shadow;       //Request to store shadow data
    logic                                   disable_mac;        //MAC disable CSR value
    logic           [DW-1:0]                shadow_write;       //shadow register formatted for write
    logic           [SHW-1:0]               shadow;             //shadow register
    logic                                   disable_mac_r;      //shadow register disable mac bit
    logic                                   user_write;         //user write to shadowed CSR detected
    logic                                   mac_enabled;        //mac enabled handshake
    logic                                   mac_disabled;       //mac disabled handshake
    logic 				    error;
    logic 				    avmm_shadow;


//=============================================================================
// Main Body of Code

    //=========================================================================
    //Synchronize requests for AVMM operations to the local clock domain.
    //CDC Note:
    //  i_disable_mac must be asserted until o_mac_disabled is asserted,
    //  and i_enable_mac must be asserted until o_mac_enable is asserted. This
    //  handshake eliminates fast->slow and slow->fast clock issues

   alt_xcvr_resync_std #(
			 .SYNC_CHAIN_LENGTH(3),    .WIDTH(2),  .INIT_VALUE(0)
			 ) u1_sync_mac (
				       .clk    (i_clk),
				       .reset  (1'b0),
				       .d  ({i_enable_mac, i_disable_mac}),
				       .q  ({enable_mac_req, disable_mac_req})
				       );

    //=========================================================================
    //Use a small sequencer to perform AVMM operations when requested

   // State machine recovery logic in case it goes to illegal state

   alt_ehipc3_fm_sm_recover #(
			   .SWIDTH(9)
			   ) sm_recover_inst (
					      .clk(i_clk),
					      .rst_n(i_rst_n),
					      .state(state),
					      .error(error)
					      );



    always_ff @(posedge i_clk)
    if(~i_rst_n) begin
        state       <=  f_1hot(ST_FIRST);
    end
    else begin
       state       <=  error ? f_1hot(ST_ERROR) : nextstate;
    end


    always_comb begin: nextstate_logic

        case(1'b1)

            //Wait for access to load the shadow register
            state[ST_FIRST]: begin
	        nextstate           =   (i_ehip_ready & (~i_usr_reconfig_read)) ?  f_1hot(ST_READ_SHADOW_1) : f_1hot(ST_FIRST);
                ehip_read           =   i_read;
                ehip_write          =   i_write;
                ehip_address        =   i_addr;
                ehip_writedata      =   i_writedata;
                user_waitrequest    =   1'b1;
                user_readdata_valid =   i_readdata_valid;
                store_shadow        =   1'b0;
                disable_mac         =   disable_mac_r;
                mac_enabled         =   1'b0;
                mac_disabled        =   1'b0;
            end

            //Read from the EHIP register that holds disable MAC and store the
            //value in the local shadow register

            state[ST_READ_SHADOW_1]: begin
                nextstate           =   ~i_waitrequest  ?  f_1hot(ST_READ_SHADOW):
                                                            f_1hot(ST_READ_SHADOW_1);
                ehip_read           =   1'b1;

                ehip_write          =   1'b0;
                ehip_address        =   TXMAC_CONTROL_ADDR;
                ehip_writedata      =   i_writedata;
                user_waitrequest    =   1'b1;
                user_readdata_valid =   1'b0;
                store_shadow        =   1'b1;
                disable_mac         =   disable_mac_r;
                mac_enabled         =   1'b0;
                mac_disabled        =   1'b0;
            end

            state[ST_READ_SHADOW]: begin
                nextstate           =   i_readdata_valid ?  f_1hot(ST_IDLE):
                                                            f_1hot(ST_READ_SHADOW);
                ehip_read           =   1'b0;

                ehip_write          =   1'b0;
                ehip_address        =   TXMAC_CONTROL_ADDR;
                ehip_writedata      =   i_writedata;
                user_waitrequest    =   1'b1;
                user_readdata_valid =   1'b0;
                store_shadow        =   1'b1;
                disable_mac         =   disable_mac_r;
                mac_enabled         =   1'b0;
                mac_disabled        =   1'b0;
            end

            //The state machine waits in ST_IDLE until it gets a request for
            //an avmm operation with waitrequest low
            state[ST_IDLE]: begin
                nextstate           =   (FLOW_CONTROL == 0)? f_1hot(ST_IDLE) :disable_mac_req ?   f_1hot(ST_WRITE_DISABLE):
                                        enable_mac_req  ?   f_1hot(ST_WRITE_ENABLE):
                                                            f_1hot(ST_IDLE);

                ehip_read           =   i_read;
                ehip_write          =   i_write;
                ehip_address        =   i_addr;
                ehip_writedata      =   i_writedata;
                user_waitrequest    =   i_waitrequest;
                user_readdata_valid =   i_readdata_valid;
                store_shadow        =   1'b0;
                disable_mac         =   disable_mac_r;
                mac_enabled         =   1'b0;
                mac_disabled        =   1'b0;
            end

            //Write 1 to disable MAC in the shadow register and wait for an
            //opportunity to write
            state[ST_WRITE_DISABLE] : begin
                nextstate           =   f_1hot(ST_WRITE_SHADOW);

                ehip_read           =   i_read;
                ehip_write          =   i_write;
                ehip_address        =   i_addr;
                ehip_writedata      =   i_writedata;
                user_waitrequest    =   i_waitrequest;
                user_readdata_valid =   i_readdata_valid;
                store_shadow        =   1'b0;
                disable_mac         =   1'b1;
                mac_enabled         =   1'b0;
                mac_disabled        =   1'b0;
            end

            //Write 0 to disable MAC in the shadow register and wait for an
            //opportunity to write
            state[ST_WRITE_ENABLE] : begin
                nextstate           =   f_1hot(ST_WRITE_SHADOW);

                ehip_read           =   i_read;
                ehip_write          =   i_write;
                ehip_address        =   i_addr;
                ehip_writedata      =   i_writedata;
                user_waitrequest    =   i_waitrequest;
                user_readdata_valid =   i_readdata_valid;
                store_shadow        =   1'b0;
                disable_mac         =   1'b0;
                mac_enabled         =   1'b0;
                mac_disabled        =   1'b0;
            end

            //Write the contents of the shadow register to the appropriate
            //EHIP register
            state[ST_WRITE_SHADOW] : begin
                nextstate           =   i_waitrequest ? f_1hot(ST_WRITE_SHADOW):
                                                        f_1hot(ST_WRITE_DONE);

                ehip_read           =   1'b0;
                ehip_write          =   1'b1;
                ehip_address        =   TXMAC_CONTROL_ADDR;
                ehip_writedata      =   shadow_write;
                user_waitrequest    =   1'b1;
                user_readdata_valid =   i_readdata_valid;
                store_shadow        =   1'b0;
                disable_mac         =   disable_mac_r;
                mac_enabled         =   1'b0;
                mac_disabled        =   1'b0;
            end

            //When the write is finished, signal the user and wait for them to
            //deassert the request for enable or disable
            state[ST_WRITE_DONE] : begin
                nextstate           =   disable_mac_req ?   f_1hot(ST_WRITE_DONE):
                                        enable_mac_req  ?   f_1hot(ST_WRITE_DONE):
                                                            f_1hot(ST_IDLE);

                ehip_read           =   i_read;
                ehip_write          =   i_write;
                ehip_address        =   i_addr;
                ehip_writedata      =   i_writedata;
                user_waitrequest    =   1'b1;
                user_readdata_valid =   i_readdata_valid;
                store_shadow        =   1'b0;
                disable_mac         =   disable_mac_r;
                mac_enabled         =   enable_mac_req;
                mac_disabled        =   disable_mac_req;
            end

            state[ST_ERROR]: begin
	       nextstate           =   f_1hot(ST_IDLE);
	       ehip_read           =   i_read;
               ehip_write          =   i_write;
               ehip_address        =   i_addr;
               ehip_writedata      =   i_writedata;
               user_waitrequest    =   i_waitrequest;
               user_readdata_valid =   i_readdata_valid;
               store_shadow        =   1'b0;
               disable_mac         =   disable_mac_r;
               mac_enabled         =   1'b0;
               mac_disabled        =   1'b0;
	    end // case: state[ST_ERROR]

            //The default case should only catch 'x' and 'z' input in
            //simulation
            default: begin
	       nextstate           =   f_1hot(ST_IDLE);
	       ehip_read           =   i_read;
               ehip_write          =   i_write;
               ehip_address        =   i_addr;
               ehip_writedata      =   i_writedata;
               user_waitrequest    =   i_waitrequest;
               user_readdata_valid =   i_readdata_valid;
               store_shadow        =   1'b0;
               disable_mac         =   disable_mac_r;
               mac_enabled         =   1'b0;
               mac_disabled        =   1'b0;
	    end // case: default
        endcase

    end: nextstate_logic


    //Assign and register the outputs to the user
    always_ff @(posedge i_clk)
    if(~i_rst_n) begin
        o_readdata_valid    <=  1'b0;
        o_waitrequest       <=  1'b1;
    end
    else begin
        o_readdata_valid    <=  user_readdata_valid;
        o_waitrequest       <=  user_waitrequest;
    end

    //Register the readddata - no reset for this bus
    always_ff @(posedge i_clk)
        o_readdata          <=  i_readdata;


    //Assign the remaining outputs combinationally for now
    always_comb begin:assign_outputs
        o_addr              =   ehip_address;
        o_writedata         =   ehip_writedata;
        o_write             =   ehip_write;
        o_read              =   ehip_read;
    end:assign_outputs


    //Register the outputs to the PAUSE sequencer - these will need to be
    //synchronized to a different clock domain.
    always_ff @(posedge i_clk)
    if(~i_rst_n) begin
       o_mac_disabled  <=  '0;
       o_mac_enabled   <=  '0;
       o_ehip_shadow   <=  '0;
    end
    else begin
       o_mac_disabled  <=  mac_disabled;
       o_mac_enabled   <=  mac_enabled;
       o_ehip_shadow   <=  i_ehip_ready && ~avmm_shadow;

    end

   assign avmm_shadow = ((nextstate == f_1hot(ST_READ_SHADOW_1) || nextstate == f_1hot(ST_READ_SHADOW)) || (nextstate == f_1hot(ST_FIRST))) ? 1'b1 : 1'b0;

    //========================================================================
    //Shadow register

    //Determine the content of the shadow register
    always_comb begin:shadow_content

        //Shadow write is the DW bits wide value that we write to the AVMM when
        //a shadow operation is performed. Start off with all zeros...
        shadow_write    =   '0;

        //Then set the bits that are actually used to the values from the
        //shadow register
        shadow_write[SHADOW_MAX:SHADOW_MIN] =   shadow;

        //Apply the value of the disable bit selected by the state machine to
        //the appropriate bit
        shadow_write[DISABLE_MAC_BIT]   =   disable_mac;

        //If there is a user write to the TXMAC_CONTROL register, or if we are
        //doing the initial store_shadow operation, overwrite any existing
        //shadow content with the appropriate user content
        shadow_write[SHADOW_MAX:SHADOW_MIN] =   user_write  ?   i_writedata[SHADOW_MAX:SHADOW_MIN]:
                                                store_shadow?   i_readdata[SHADOW_MAX:SHADOW_MIN]:
                                                                shadow_write[SHADOW_MAX:SHADOW_MIN];
    end:shadow_content

    //Register the content of the shadow register
    always_ff @(posedge i_clk)begin
        shadow  <=  shadow_write[SHADOW_MAX:SHADOW_MIN];
    end

    assign  disable_mac_r   =   shadow[DISABLE_MAC_BIT - SHADOW_MIN];


    //Trigger a user write to the shadow register if the user has control of
    //the AVMM and writes to the TXMAC_CONTROL register
    assign  user_write  =   !user_waitrequest                   //user is not being asked to wait
                            && i_write                          //user is performing a write
                            && (i_addr == TXMAC_CONTROL_ADDR);   //write is to the TXMAC_CONTROL register


    //=========================================================================

    //Return the state encoding as a 1-hot value over STATES bits
    function automatic logic [STATES-1:0] f_1hot(integer state);

        logic   [STATES-1:0]    state0;

        state0      =   '0;
        state0[0]   =   1'b1;
        return      state0 << state;

    endfunction

endmodule
