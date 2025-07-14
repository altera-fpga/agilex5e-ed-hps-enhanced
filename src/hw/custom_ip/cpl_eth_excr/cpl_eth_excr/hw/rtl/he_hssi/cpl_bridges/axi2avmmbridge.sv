// created for CPL MEM excr project

`timescale 1 ps / 1 ps
module axi2avmmbridge #(
        parameter AVMM_ADDR_WIDTH = 15,
        parameter AVMM_DATA_WIDTH = 32,
        parameter AXI4L_ADDR_WIDTH = 15,
        parameter AXI4L_DATA_WIDTH = 32,
        parameter AXI4L_RRESP_WIDTH = 2,
        parameter AXI4L_WSTRB_WIDTH = 4,
        parameter AXI4L_BRESP_WIDTH = 2

) (
		input  logic                        clk,                         //    clock_sink.clk
		input  logic                        rst_n,                     //    reset_sink.rst_n
		output logic [AVMM_ADDR_WIDTH-1:0] avalon_master_address,       // avalon_master.address
		output logic                        avalon_master_read,          //              .read
		output logic                        avalon_master_write,         //              .write
		input  logic                        avalon_master_readdatavalid, //              .readdatavalid
		input  logic                        avalon_master_waitrequest,   //              .waitrequest
		output logic [AVMM_DATA_WIDTH-1:0] avalon_master_writedata,     //              .writedata
		input  logic [AVMM_DATA_WIDTH-1:0] avalon_master_readdata,      //              .readdata

        input  logic [AXI4L_ADDR_WIDTH-1:0] axi_slave_araddr,            //     axi_slave.araddr
		input  logic                        axi_slave_arvalid,           //              .arvalid
		output logic                        axi_slave_arready,           //              .arready
		input  logic [AXI4L_ADDR_WIDTH-1:0] axi_slave_awaddr,            //              .awaddr
		input  logic                        axi_slave_awvalid,           //              .awvalid
		output logic                        axi_slave_awready,           //              .awready
		output logic [AXI4L_DATA_WIDTH-1:0] axi_slave_rdata,             //              .rdata
		output logic [AXI4L_RRESP_WIDTH-1:0]  axi_slave_rresp,             //              .rresp
		output logic                        axi_slave_rvalid,            //              .rvalid
		input  logic                        axi_slave_rready,            //              .rready
		input  logic [AXI4L_DATA_WIDTH-1:0] axi_slave_wdata,             //              .wdata
		input  logic                        axi_slave_wvalid,            //              .wvalid
		output logic                        axi_slave_wready,            //              .wready
		input  logic [AXI4L_WSTRB_WIDTH-1:0]  axi_slave_wstrb,             //              .wstrb
		output logic [AXI4L_BRESP_WIDTH-1:0]  axi_slave_bresp,             //              .bresp
		output logic                        axi_slave_bvalid,            //              .bvalid
		input  logic                        axi_slave_bready             //              .bready
	);

	// TODO: Auto-generated HDL template

	//assign avalon_master_address = 12'b000000000000;

	//assign avalon_master_read = 1'b0;

	//assign avalon_master_write = 1'b0;

	//assign avalon_master_writedata = 32'b00000000000000000000000000000000;

	//assign axi_slave_arready = 1'b0;

	assign axi_slave_bresp = 2'b00;

	//assign axi_slave_rdata = 32'b00000000000000000000000000000000;

	//assign axi_slave_wready = 1'b0;

	//assign axi_slave_awready = 1'b0;

	assign axi_slave_rresp = 2'b00;

	//assign axi_slave_bvalid = 1'b0;

	//assign axi_slave_rvalid = 1'b0;

	logic [11:0]	avmm_addr;

//
// Address logic
//
	// Address Latching logic.
	always_ff @(posedge clk) begin
		if (axi_slave_arvalid) begin
			avalon_master_address <= axi_slave_araddr;
		end else if (axi_slave_awvalid) begin
			avalon_master_address <= axi_slave_awaddr;
		end

	end


	// Read Address channel Handshake
	always_ff @(posedge clk ) begin
		if (!rst_n || (axi_slave_arready & axi_slave_arvalid)) begin
			axi_slave_arready <= 1'b0;
			// Avalon master read back to 0
			avalon_master_read <= 1'b0;
		end else if (!axi_slave_arready & axi_slave_arvalid) begin
			axi_slave_arready <= 1'b1;
			// Load address and read to Avalon master
			//avalon_master_address <= axi_slave_araddr;
			avalon_master_read <= 1'b1;
		end else begin
			axi_slave_arready <= 1'b0;
			avalon_master_read <= 1'b0;
		end
	end

	//Write address channel Handshake
	always_ff @( posedge clk ) begin : writeAddress
		if (!rst_n || (axi_slave_awready & axi_slave_awvalid)) begin
			axi_slave_awready <= 1'b0;
			avalon_master_write <= 1'b0;

		end else if (!axi_slave_awready & axi_slave_awvalid & !axi_slave_arvalid) begin
			axi_slave_awready <= 1'b1;
			//avalon_master_address <= axi_slave_awaddr;
			avalon_master_write <= 1'b1;
		end
	end




//
// Read Data Logic
//

	// Read data channel Handshake
	always_ff @(posedge clk ) begin
		if (!rst_n || (axi_slave_rready & axi_slave_rvalid & !avalon_master_readdatavalid)) begin
			axi_slave_rvalid <= 1'b0;
			axi_slave_rdata <= 0;
		end else if (avalon_master_readdatavalid) begin
			axi_slave_rvalid <= 1'b1;
			axi_slave_rdata <= avalon_master_readdata;
		end
	end



//
// Write Data Logic
//

	// Write data channel Handshake
	always_ff @( posedge clk ) begin : writeData
		if (!rst_n || (axi_slave_wready & axi_slave_wvalid) ) begin
			axi_slave_wready <= 1'b0;
		end else if (!axi_slave_wready & axi_slave_wvalid) begin
			axi_slave_wready <= 1'b1;
			avalon_master_writedata <= axi_slave_wdata;
		end
	end



//
// Write Addr & Write data Handshake triggers for Write response channel
//

logic awaddr_done;
logic wdata_done;

always_ff @( posedge clk ) begin

	if (!rst_n || (awaddr_done & wdata_done) ) begin
		awaddr_done <= 0;
		wdata_done	<= 0;
	end else begin
		if (axi_slave_awready & axi_slave_awvalid) begin
			awaddr_done <= 1;
		end

		if (axi_slave_wready & axi_slave_wvalid) begin
			wdata_done <= 1;
		end
	end

end


//
// Write Response Channel Handshake
//

always_ff @( posedge clk ) begin

	if (!rst_n || (axi_slave_bvalid & axi_slave_bready)) begin
		axi_slave_bvalid <= 0;
	end else if (!axi_slave_bvalid & (awaddr_done & wdata_done)) begin
		axi_slave_bvalid <= 1;
	end

end




//
// Address logic
//
//	// Comb logic for deciding which addr to put on the AVMM addr bus
//	always_comb begin
//		if (axi_slave_arvalid) begin
//			avmm_addr = axi_slave_araddr;
//		end else if (axi_slave_awvalid) begin
//			avmm_addr = axi_slave_awaddr;
//		end else begin
//			avmm_addr = '0;
//		end
//	end
//
//	// Avmm Addr & avmm write , read handling
//	always @(posedge clk) begin
//		if (!rst_n) begin
//			avalon_master_address <= '0;
//		end
//		else begin
//			avalon_master_address <= avmm_addr;
//			if (axi_slave_arvalid) begin
//				avalon_master_read <= axi_slave_arvalid;
//				avalon_master_write <= 0;
//			end else if (axi_slave_awvalid) begin
//				avalon_master_read <= 0;
//				avalon_master_write <= axi_slave_awvalid;
//			end else begin
//				avalon_master_read <= 0;
//				avalon_master_write <= 0;
//			end
//		end
//	end


//
// Read logic
//

//	always @(posedge clk) begin
//		if (!rst_n) begin
//			axi_slave_rdata <= 0;
//		end else if (!axi_slave_rready & avalon_master_readdatavalid)begin
//			axi_slave_rdata <= avalon_master_readdata;
//			axi_slave_rvalid <= 1'b1;
//		end else begin
//			axi_slave_rdata <= 0;
//			axi_slave_rvalid <= 1'b1;
//		end
//	end

//	// rvalid handshake
//	always @(posedge clk) begin
//		if (!rst_n | (axi_slave_rready & axi_slave_rvalid) ) begin
//			axi_slave_rvalid <= 1'b0;
//		end
//	end



endmodule
