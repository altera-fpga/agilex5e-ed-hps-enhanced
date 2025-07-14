//This module converts 32 bit writedata to 64 bit writedata and 64 bit readdata to 32 bit readdata by
// defining new sets of register that maps 32 bits registers to 64bits register
module csr_reg #(
   parameter DEVICE_FAMILY = "Arria 10",
   parameter CRC_EN        = 0
) (
   input logic                	clk                      	,     // TX FIFO Interface clock
   input logic                	reset                    	,     // Reset signal
   input logic 	[15:0]  		csr_addr_i                  ,     // Register Address
   input logic                 	csr_wr_i                    ,     // Register Write Strobe
   input logic                	csr_rd_i      		     	,     // Register Read Strobe
   input logic 	[31:0] 			csr_wr_data_i               ,     // Register Write Data
   input logic 	[63:0] 			csr_rd_data_i               ,     // Register Read Data
   output logic [31:0]  		csr_rd_data_o               ,     // Register Address
   output logic [63:0]      	csr_wr_data_o               ,     // Register Write Strobe
   output logic [15:0]   		o_cmd_csr_addr              ,     // Register Read Strobe
   output logic             	csr_wr_o						  // Register Read Strobe
);
 // ___________________________________________________________
 //     address parameters
 // ___________________________________________________________
 parameter AFU_DFH_L      	  			= 16'h0060;
 parameter AFU_DFH_H		  			= 16'h0068;
 parameter AFU_ID_Ll		  			= 16'h0070;
 parameter AFU_ID_Lh          			= 16'h0078;
 parameter AFU_ID_Hl          			= 16'h0080;
 parameter AFU_ID_Hh          			= 16'h0088;
 parameter TRAFFIC_CTRL_CMD_L        	= 16'h0090;
 parameter TRAFFIC_CTRL_CMD_H        	= 16'h0098;
 parameter TRAFFIC_CTRL_CH_SEL_L        = 16'h0100;
 parameter TRAFFIC_CTRL_CH_SEL_H 		= 16'h0108;
 parameter AFU_CTRL_DATA_L 				= 16'h0110;
 parameter AFU_CTRL_DATA_H 				= 16'h0118;
 parameter AFU_SCRATCHPAD_L      		= 16'h0120;
 parameter AFU_SCRATCHPAD_H     		= 16'h0128;
 parameter AFU_CROSSBAR_EN_L     		= 16'h0130;
 parameter AFU_CROSSBAR_EN_H       		= 16'h0138;
 parameter LINK_STATUS					= 16'h0140;




logic [31:0] data_wr_h;
logic [15:0] address;
logic [15:0] address_r;
logic [31:0] ctrl_l;
logic [31:0] ctrl_h;
logic [31:0] data_l;
logic [31:0] data_h;
logic [31:0] ch_l;
logic [31:0] scratch_l;
logic [31:0] scratch_h;
logic [31:0] cross_l;
logic csr_rd_q;
logic csr_rd_q1;
logic csr_rd_q2;
logic csr_wr_q;
//logic csr_wr_o;
logic csr_wr_t;



	always_ff @(posedge clk or posedge reset) begin
	   if(reset) begin
		  csr_rd_q  <= '0;
		  csr_rd_q1 <= '0;
		  csr_rd_q2 <= '0;
	   end else begin
		  csr_rd_q <= csr_rd_i;
		  csr_rd_q1 <= csr_rd_q;
		  // csr_rd_q2 <= csr_rd_q1;
	   end
	end

	always_ff @(posedge clk or posedge reset) begin
	   if(reset) begin
		  csr_wr_q  <= '0;
		  csr_wr_t <= '0;
		  csr_wr_o <= '0;
	   end else begin
		  csr_wr_q <= csr_wr_i;
		  csr_wr_t <= csr_wr_q;
		  csr_wr_o <= csr_wr_t;
	   end
	end

	//64 bit to 32 bit readdata
  always@(posedge clk or posedge reset)
   begin
      if(reset)
	  begin
		csr_rd_data_o <= 32'h0;
	  end
      else if (csr_rd_q1) begin
         case (csr_addr_i)
            TRAFFIC_CTRL_CMD_L		: 	csr_rd_data_o <= csr_rd_data_i [31:0];
            TRAFFIC_CTRL_CMD_H		: 	csr_rd_data_o <= csr_rd_data_i [63:32];
            AFU_DFH_L				: 	csr_rd_data_o <= csr_rd_data_i [31:0];
            AFU_DFH_H				: 	csr_rd_data_o <= csr_rd_data_i [63:32];
			AFU_ID_Ll				: 	csr_rd_data_o <= csr_rd_data_i [31:0];
            AFU_ID_Lh				: 	csr_rd_data_o <= csr_rd_data_i [63:32];
			AFU_ID_Hl				: 	csr_rd_data_o <= csr_rd_data_i [31:0];
            AFU_ID_Hh				: 	csr_rd_data_o <= csr_rd_data_i [63:32];
			AFU_CTRL_DATA_L			: 	csr_rd_data_o <= csr_rd_data_i [31:0];
            AFU_CTRL_DATA_H			: 	csr_rd_data_o <= csr_rd_data_i [63:32];
			TRAFFIC_CTRL_CH_SEL_L	: 	csr_rd_data_o <= csr_rd_data_i [31:0];
            TRAFFIC_CTRL_CH_SEL_H	: 	csr_rd_data_o <= csr_rd_data_i [63:32];
			AFU_SCRATCHPAD_L		: 	csr_rd_data_o <= csr_rd_data_i [31:0];
            AFU_SCRATCHPAD_H		: 	csr_rd_data_o <= csr_rd_data_i [63:32];
			AFU_CROSSBAR_EN_L		: 	csr_rd_data_o <= csr_rd_data_i [31:0];
			AFU_CROSSBAR_EN_H		: 	csr_rd_data_o <= csr_rd_data_i [63:32];
			LINK_STATUS 			: 	csr_rd_data_o <= csr_rd_data_i [31:0];
            default					: 	csr_rd_data_o <=32'h0;
         endcase
      end
   end



   // Mapping of 32 bit registers to 64 bit AFU csr registers to
   always@(posedge clk or posedge reset)
   begin
      if(reset)
	  begin
		o_cmd_csr_addr <= 16'h0;
	  end
      else begin
         case (csr_addr_i)
            TRAFFIC_CTRL_CMD_L		: o_cmd_csr_addr <= 16'h0030;
            TRAFFIC_CTRL_CMD_H		: o_cmd_csr_addr <= 16'h0030;
            AFU_DFH_L				: o_cmd_csr_addr <= 16'h0000;
            AFU_DFH_H				: o_cmd_csr_addr <= 16'h0000;
			AFU_ID_Ll				: o_cmd_csr_addr <= 16'h0008;
            AFU_ID_Lh				: o_cmd_csr_addr <= 16'h0008;
			AFU_ID_Hl				: o_cmd_csr_addr <= 16'h0010;
            AFU_ID_Hh				: o_cmd_csr_addr <= 16'h0010;
			AFU_CTRL_DATA_L			: o_cmd_csr_addr <= 16'h0038;
            AFU_CTRL_DATA_H			: o_cmd_csr_addr <= 16'h0038;
			TRAFFIC_CTRL_CH_SEL_L	: o_cmd_csr_addr <= 16'h0040;
            TRAFFIC_CTRL_CH_SEL_H	: o_cmd_csr_addr <= 16'h0040;
			AFU_SCRATCHPAD_L		: o_cmd_csr_addr <= 16'h0048;
            AFU_SCRATCHPAD_H		: o_cmd_csr_addr <= 16'h0048;
			AFU_CROSSBAR_EN_L		: o_cmd_csr_addr <= 16'h0050;
			AFU_CROSSBAR_EN_H		: o_cmd_csr_addr <= 16'h0050;
			LINK_STATUS				: o_cmd_csr_addr <= 16'h0058;
            default					: o_cmd_csr_addr <=16'h0;
         endcase
      end
	end

	//Assigning Jtag writedata to 32 bit registers
	always @ (posedge reset or posedge clk)
	begin
      if (reset)
	  begin
		ctrl_l 						<= 32'h0;
		ctrl_h 						<= 32'h0;
		data_l 						<= 32'h0;
		data_h 						<= 32'h0;
		ch_l 						<= 32'h0;
		scratch_l 					<= 32'h0;
		scratch_h 					<= 32'h0;
		cross_l 					<= 32'h0;
	  end
      else if (csr_wr_i & csr_addr_i == TRAFFIC_CTRL_CMD_L)
	  begin
		ctrl_l <= csr_wr_data_i;
	  end
	  else if (csr_wr_i & csr_addr_i == TRAFFIC_CTRL_CMD_H)
	  begin
		ctrl_h <= csr_wr_data_i;
	  end
	  else if (csr_wr_i & csr_addr_i == AFU_CTRL_DATA_L)
	  begin
		data_l <= csr_wr_data_i;
	  end
	  else if (csr_wr_i & csr_addr_i == AFU_CTRL_DATA_H)
	  begin
		data_h <= csr_wr_data_i;
	  end
	  else if (csr_wr_i & csr_addr_i == TRAFFIC_CTRL_CH_SEL_L)
	  begin
		ch_l <= csr_wr_data_i;
	  end
	  else if (csr_wr_i & csr_addr_i == AFU_SCRATCHPAD_L)
	  begin
		scratch_l <= csr_wr_data_i;
	  end
	  else if (csr_wr_i & csr_addr_i == AFU_SCRATCHPAD_H)
	  begin
		scratch_h <= csr_wr_data_i;
	  end
	  else if (csr_wr_i & csr_addr_i == AFU_CROSSBAR_EN_L)
	  begin
		cross_l <= csr_wr_data_i;
	  end
	end

	//64 bit data output to csr module
	always@(posedge clk or posedge reset)
	begin
      if(reset)
	  begin
		csr_wr_data_o 					<= 64'h0;
	  end
      else if (csr_wr_t)
		begin
         case (csr_addr_i)
            TRAFFIC_CTRL_CMD_L 		: csr_wr_data_o <= {ctrl_h,ctrl_l};
            TRAFFIC_CTRL_CMD_H 		: csr_wr_data_o <= {ctrl_h,ctrl_l};
			AFU_CTRL_DATA_L  		: csr_wr_data_o <= {data_h,data_l};
			AFU_CTRL_DATA_H 		: csr_wr_data_o <= {data_h,data_l};
			TRAFFIC_CTRL_CH_SEL_L	: csr_wr_data_o <= {32'b0,ch_l};
			TRAFFIC_CTRL_CH_SEL_H 	: csr_wr_data_o <= {32'b0,ch_l};
			AFU_SCRATCHPAD_L 		: csr_wr_data_o <= {scratch_h,scratch_l};
			AFU_SCRATCHPAD_H 		: csr_wr_data_o <= {scratch_h,scratch_l};
			AFU_CROSSBAR_EN_L 		: csr_wr_data_o <= {32'b0,cross_l};
			AFU_CROSSBAR_EN_H 		: csr_wr_data_o <= {32'b0,cross_l};
            default					: csr_wr_data_o <=	64'h0;
         endcase
      end
	end




endmodule
