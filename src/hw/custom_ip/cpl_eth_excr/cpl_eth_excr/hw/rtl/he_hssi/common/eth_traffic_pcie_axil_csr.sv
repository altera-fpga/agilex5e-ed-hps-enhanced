// Copyright 2020 Intel Corporation.
// SPDX-License-Identifier: MIT
//
//-----------------------------------------------------------------------------
// Description
//-----------------------------------------------------------------------------
//
// Ethernet Traffic AFU connection from Jtag Avmm to CSR's
//
//-----------------------------------------------------------------------------

module eth_traffic_pcie_axil_csr
    import ofs_csr_pkg::*;
#(
   parameter AVMM_DATA_W        = 32, // Data width
   parameter AVMM_ADDR_W        = 16  // AVMM address width
)(
   input  logic                         clk,
   input  logic                         rst_n,

   //ofs_fim_axi_lite_if.sink            csr_lite_if,		//Replaced with avmm slave Interface
   ofs_avmm_if.sink						csr_lite_if,
   // Avalon-MM Interface
   output logic [AVMM_ADDR_W-1:0]       o_avmm_addr,        // AVMM address
   output logic                         o_avmm_read,        // AVMM read request
   output logic                         o_avmm_write,       // AVMM write request
   output logic [AVMM_DATA_W-1:0]       o_avmm_writedata,   // AVMM write data
   input  logic [AVMM_DATA_W-1:0]       i_avmm_readdata,    // AVMM read data
   input  logic                         i_avmm_waitrequest, // AVMM wait request
   // Port selection for CSR interface
   output logic [3:0]                   o_csr_port_sel,
   // Enable for crossbar: Tx port swapping between first and second half ports
   input logic [31:0]							e_tile_txrx_status,
   output logic                         o_port_swap_en
);

// ----------- Parameters -------------
localparam AFU_CSR_ADDR_WIDTH    = 16;

logic cmd_csr_rd_q, cmd_csr_rd_q1, cmd_csr_rd_q2, cmd_csr_rd_q3;
csr_access_type_t csr_avmm_if_wr_type;

logic [63:0] csr_wr_data;
logic [63:0] csr_rd_data;
logic [31:0] csr_rd_data_o;
logic [15:0] csr_addr_o;
logic csr_rd;
logic csr_wr;
logic [63:0] csr_wr_data_o;
logic [AFU_CSR_ADDR_WIDTH-1:0] csr_addr;
csr_access_type_t csr_wr_type;
logic csr_wr_o;

// ofs_avmm_if #(
   // .ADDR_W($bits(csr_lite_if.address)),
   // .DATA_W($bits(csr_lite_if.writedata))
// ) csr_avmm_if ();



// AVMM connections to common csr block
always_ff @(posedge clk) begin
   if(~rst_n) begin
      cmd_csr_rd_q  <= '0;
      cmd_csr_rd_q1 <= '0;
      cmd_csr_rd_q2 <= '0;
      cmd_csr_rd_q3 <= '0;
   end else begin
      cmd_csr_rd_q <= csr_lite_if.read;
      cmd_csr_rd_q1 <= cmd_csr_rd_q;
      cmd_csr_rd_q2 <= cmd_csr_rd_q1;
      cmd_csr_rd_q3 <= cmd_csr_rd_q2;
   end
end


	assign csr_avmm_if_wr_type = &csr_lite_if.byteenable ? FULL64
                            : csr_lite_if.address[3] ? UPPER32
                            : LOWER32;

	// Read data available after cycles
	assign csr_lite_if.readdatavalid = cmd_csr_rd_q3;
	assign csr_lite_if.waitrequest = 1'b0;
	assign csr_lite_if.readdata = csr_rd_data_o;

// Latch the address for Rds
always_ff @(posedge clk) begin
   if(~rst_n) begin
      csr_wr        <= '0;
      csr_rd        <= '0;
      csr_wr_type   <=FULL64;
      csr_wr_data   <= '0;
      csr_addr      <= '0;
   end else begin
      csr_wr        <= csr_lite_if.write;
      csr_rd        <= csr_lite_if.read;
      csr_wr_type   <= csr_avmm_if_wr_type;
      csr_wr_data   <= csr_lite_if.writedata;
      csr_addr      <= csr_lite_if.write | csr_lite_if.read ? csr_lite_if.address : csr_addr;
   end
end


eth_traffic_csr #(
   .AFU_CSR_ADDR_WIDTH(AFU_CSR_ADDR_WIDTH),
   .AVMM_DATA_W(AVMM_DATA_W),
   .AVMM_ADDR_W(AVMM_ADDR_W)
) inst_eth_traffic_csr (
   .clk,
   .rst                 (~rst_n),
   .e_tile_txrx_status	(e_tile_txrx_status), //eth link status csr

   .i_cmd_csr_rd        (csr_rd),		//Jtag read signal
   .i_cmd_csr_wr        (csr_wr_o),		//write signal from csr_reg module
   .i_cmd_csr_addr      (csr_addr_o),	//AFU csr address
   .i_cmd_csr_wr_type   (csr_wr_type),
   .i_csr_wr_data       (csr_wr_data_o),//output written data to csr module (64 bit)
   .o_csr_rd_data       (csr_rd_data), 	//64 bit output data

   // Avalon-MM Interface
   .o_avmm_addr,        // AVMM address
   .o_avmm_read,        //  AVMM read request
   .o_avmm_write,       // AVMM write request
   .o_avmm_writedata,   // AVMM write data
   .i_avmm_readdata,    // AVMM read data
   .i_avmm_waitrequest, // AVMM wait request
   // Port selection for CSR interface
   .o_csr_port_sel,
   // Enable for crossbar: Tx port swapping between first and second half ports
   .o_port_swap_en
);


//csr module to convert 32 bits data by jtag master to 64 bits data to csr module (eth_traffic_csr)
csr_reg csr_reg_inst
(
   .clk,
   .reset				(~rst_n),
   .csr_rd_i 	        (csr_rd),			//Jtag read signal
   .csr_wr_i	        (csr_wr),			//Jtag write signal
   .csr_addr_i	      	(csr_addr), 		//Jtag master address input
   .csr_wr_data_i       (csr_wr_data), 		//Jtag master writedata
   .csr_rd_data_i      	(csr_rd_data),   	//64 bit read-data from eth_traffic_csr module
   .csr_rd_data_o      	(csr_rd_data_o), 	//32 bit readdata to Jtag
   .csr_wr_data_o       (csr_wr_data_o),	//output write data to csr module (64 bit)
   .csr_wr_o        	(csr_wr_o),			//write signal to csr module (eth_traffic_csr)
   .o_cmd_csr_addr      (csr_addr_o) 		//AFU reg address selected
);



endmodule // eth_traffic_pcie_axil_csr
