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


module altera_xcvr_ical_top_etile #(
  parameter INT_STEPS = 10,
  parameter POWER_ON_ICAL = 1
)
(

//CUSTOMER AVMM SIDE
input user_clk,
input user_reset,
input user_read,
input user_write,
input [18:0] user_address,
input [7:0] user_writedata,
output [7:0] user_readdata,
output user_waitrequest,


//CORE-IP AVMM SIDE
output reg avmm_read,
output reg avmm_write,
output reg [18:0] avmm_address,
output reg [7:0] avmm_writedata,
input [7:0] avmm_readdata,
input avmm_waitrequest,



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
output reg ical_timeout
);

// from interrupt table
wire [(INT_STEPS*3-1):0]  int_type;
wire [(INT_STEPS*16-1):0] int_code;
wire [(INT_STEPS*16-1):0] int_data;
wire [(INT_STEPS*8-1):0]  int_expt;


      altera_xcvr_ical_etile #(
        .INT_STEPS                           ( INT_STEPS                 ),
        .POWER_ON_ICAL                       ( POWER_ON_ICAL             )
      ) altera_xcvr_ical_etile_inst (
        .user_clk                            ( user_clk                                             ),
        .user_reset                          ( user_reset                                           ),		///// Add reset??
        .user_write                          ( user_write                                      ),
        .user_read                           ( user_read                                       ),
        .user_address                        ( user_address                                    ),
        .user_writedata                      ( user_writedata                                  ),
        .user_readdata                       ( user_readdata                                   ),
        .user_waitrequest                    ( user_waitrequest             ),					//output
        .r_user_ical_req                     ( r_user_ical_req    ) ,								//input

        .avmm_write                          ( avmm_write                                      ),
        .avmm_read                           ( avmm_read                                       ),
        .avmm_address                        ( avmm_address                                   ),
        .avmm_writedata                      ( avmm_writedata                                  ),
        .avmm_readdata                       ( avmm_readdata                                   ),
        .avmm_waitrequest                    ( avmm_waitrequest             ),					//output

        .pma_tx_ready                        ( pma_tx_ready                 )  ,
        .pma_rx_ready                        ( pma_rx_ready                  ),
        .pma_lock2data                       ( pma_lock2data            ),

        .ical_cur_state                      ( ical_cur_state                ),
        .intrpt_state                        ( intrpt_state                  ),
        .ical_in_progress                    ( ical_in_progress              ),
        .ical_finish                         ( ical_finish                   ),
        .ical_timeout                        ( ical_timeout                  ),

        .int_type                            ( int_type                      ),
        .int_code                            ( int_code                      ),
        .int_data                            ( int_data                      ),
        .int_expt                            ( int_expt                      )

      );

      altera_xcvr_ical_int_table #( //This module is per channel based
        .INT_STEPS                           ( INT_STEPS                 )
      ) altera_xcvr_ical_int_table_inst (
        .int_type                            ( int_type                      ),
        .int_code                            ( int_code                      ),
        .int_data                            ( int_data                      ),
        .int_expt                            ( int_expt                      )
      );


endmodule
