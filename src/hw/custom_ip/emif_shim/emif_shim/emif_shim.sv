module emif_shim
  #(
    parameter ADDR_WIDTH      = 33,
    parameter DATA_WIDTH      = 256,
    parameter ID_W_WIDTH      = 7,
    parameter ID_R_WIDTH      = 7,
    parameter USER_REQ_WIDTH  = 4,
    parameter USER_DATA_WIDTH = 64
    )
   (
    input wire [ADDR_WIDTH-1:0]       s_axi_awaddr,
    input wire [1:0]                  s_axi_awburst,
    input wire [ID_W_WIDTH-1:0]       s_axi_awid,
    input wire [7:0]                  s_axi_awlen,
    input wire                        s_axi_awlock,
    input wire [3:0]                  s_axi_awqos,
    input wire [2:0]                  s_axi_awsize,
    input wire                        s_axi_awvalid,
    input wire [USER_REQ_WIDTH-1:0]   s_axi_awuser,
    input wire [2:0]                  s_axi_awprot,
    output wire                       s_axi_awready,

    input wire [ADDR_WIDTH-1:0]       s_axi_araddr,
    input wire [1:0]                  s_axi_arburst,
    input wire [ID_R_WIDTH-1:0]       s_axi_arid,
    input wire [7:0]                  s_axi_arlen,
    input wire                        s_axi_arlock,
    input wire [3:0]                  s_axi_arqos,
    input wire [2:0]                  s_axi_arsize,
    input wire                        s_axi_arvalid,
    input wire [USER_REQ_WIDTH-1:0]   s_axi_aruser,
    input wire [2:0]                  s_axi_arprot,
    output wire                       s_axi_arready,

    input wire                        s_axi_bready,
    output wire [ID_W_WIDTH-1:0]      s_axi_bid,
    output wire [1:0]                 s_axi_bresp,
    output wire                       s_axi_bvalid,

    input wire                        s_axi_rready,
    output wire [USER_DATA_WIDTH-1:0] s_axi_ruser,
    output wire [ID_R_WIDTH-1:0]      s_axi_rid,
    output wire                       s_axi_rlast,
    output wire [1:0]                 s_axi_rresp,
    output wire                       s_axi_rvalid,
    output wire [DATA_WIDTH-1:0]      s_axi_rdata,
    input wire [USER_DATA_WIDTH-1:0]  s_axi_wuser,
    input wire [DATA_WIDTH-1:0]       s_axi_wdata,
    input wire [DATA_WIDTH/8-1:0]     s_axi_wstrb,
    input wire                        s_axi_wlast,
    input wire                        s_axi_wvalid,
    output wire                       s_axi_wready,

    output wire [ADDR_WIDTH-1:0]      m_axi_awaddr,
    output wire [1:0]                 m_axi_awburst,
    output wire [ID_W_WIDTH-1:0]      m_axi_awid,
    output wire [7:0]                 m_axi_awlen,
    output wire                       m_axi_awlock,
    output wire [3:0]                 m_axi_awqos,
    output wire [2:0]                 m_axi_awsize,
    output wire                       m_axi_awvalid,
    output wire [USER_REQ_WIDTH-1:0]  m_axi_awuser,
    output wire [2:0]                 m_axi_awprot,
    input wire                        m_axi_awready,

    output wire [ADDR_WIDTH-1:0]      m_axi_araddr,
    output wire [1:0]                 m_axi_arburst,
    output wire [ID_R_WIDTH-1:0]      m_axi_arid,
    output wire [7:0]                 m_axi_arlen,
    output wire                       m_axi_arlock,
    output wire [3:0]                 m_axi_arqos,
    output wire [2:0]                 m_axi_arsize,
    output wire                       m_axi_arvalid,
    output wire [USER_REQ_WIDTH-1:0]  m_axi_aruser,
    output wire [2:0]                 m_axi_arprot,
    input wire                        m_axi_arready,

    output wire                       m_axi_bready,
    input wire [ID_W_WIDTH-1:0]       m_axi_bid,
    input wire [1:0]                  m_axi_bresp,
    input wire                        m_axi_bvalid,

    output wire                       m_axi_rready,
    input wire [USER_DATA_WIDTH-1:0]  m_axi_ruser,
    input wire [ID_R_WIDTH:0]         m_axi_rid,
    input wire                        m_axi_rlast,
    input wire [1:0]                  m_axi_rresp,
    input wire                        m_axi_rvalid,
    input wire [DATA_WIDTH-1:0]       m_axi_rdata,

    output wire [USER_DATA_WIDTH-1:0] m_axi_wuser,
    output wire [DATA_WIDTH:0]        m_axi_wdata,
    output wire [DATA_WIDTH/8-1:0]    m_axi_wstrb,
    output wire                       m_axi_wlast,
    output wire                       m_axi_wvalid,
    input wire                        m_axi_wready,

    input wire                        axi_clk,
    input wire                        axi_reset
);


localparam AW_WIDTH = ADDR_WIDTH+2+ID_W_WIDTH+8+1+4+3+USER_REQ_WIDTH+3;
localparam AR_WIDTH = ADDR_WIDTH+2+ID_R_WIDTH+8+1+4+3+USER_REQ_WIDTH+3;
localparam W_WIDTH  = USER_DATA_WIDTH+DATA_WIDTH+(DATA_WIDTH/8)+1;
localparam R_WIDTH  = USER_DATA_WIDTH+ID_R_WIDTH+1+2+DATA_WIDTH;
localparam B_WIDTH  = ID_W_WIDTH+2;

logic [AW_WIDTH-1:0] s_aw,m_aw;
logic [AR_WIDTH-1:0] s_ar,m_ar;
logic [W_WIDTH-1:0]  s_w,m_w;
logic [R_WIDTH-1:0]  s_r,m_r;
logic [B_WIDTH-1:0]  s_b,m_b;

  assign s_ar = {s_axi_araddr,s_axi_arburst,s_axi_arid,s_axi_arlen,s_axi_arlock,s_axi_arqos,s_axi_arsize,s_axi_aruser,s_axi_arprot};
  assign s_aw = {s_axi_awaddr,s_axi_awburst,s_axi_awid,s_axi_awlen,s_axi_awlock,s_axi_awqos,s_axi_awsize,s_axi_awuser,s_axi_awprot};
  assign s_w = {s_axi_wuser,s_axi_wdata,s_axi_wstrb,s_axi_wlast};
  assign {s_axi_ruser,s_axi_rid,s_axi_rlast,s_axi_rresp,s_axi_rdata} = s_r;
  assign {s_axi_bid,s_axi_bresp} = s_b;

  assign {m_axi_araddr,m_axi_arburst,m_axi_arid,m_axi_arlen,m_axi_arlock,m_axi_arqos,m_axi_arsize,m_axi_aruser,m_axi_arprot} = m_ar;
  assign {m_axi_awaddr,m_axi_awburst,m_axi_awid,m_axi_awlen,m_axi_awlock,m_axi_awqos,m_axi_awsize,m_axi_awuser,m_axi_awprot} = m_aw;
  assign {m_axi_wuser,m_axi_wdata,m_axi_wstrb,m_axi_wlast} = m_w;
  assign m_r = {m_axi_ruser,m_axi_rid,m_axi_rlast,m_axi_rresp,m_axi_rdata};
  assign m_b = {m_axi_bid,m_axi_bresp};

  emif_shim_skid #( .P_WIDTH(AW_WIDTH)) i_aw (
    .clk           (axi_clk),
    .rst           (axi_reset),
    .in_valid      (s_axi_awvalid),
    .in_data       (s_aw),
    .in_ready      (s_axi_awready),
    .out_valid     (m_axi_awvalid),
    .out_data      (m_aw),
    .out_ready     (m_axi_awready)
  );

  emif_shim_skid #( .P_WIDTH(AW_WIDTH)) i_ar (
    .clk           (axi_clk),
    .rst           (axi_reset),
    .in_valid      (s_axi_arvalid),
    .in_data       (s_ar),
    .in_ready      (s_axi_arready),
    .out_valid     (m_axi_arvalid),
    .out_data      (m_ar),
    .out_ready     (m_axi_arready)
  );

  emif_shim_skid #( .P_WIDTH(W_WIDTH)) i_w (
    .clk           (axi_clk),
    .rst           (axi_reset),
    .in_valid      (s_axi_wvalid),
    .in_data       (s_w),
    .in_ready      (s_axi_wready),
    .out_valid     (m_axi_wvalid),
    .out_data      (m_w),
    .out_ready     (m_axi_wready)
  );

  emif_shim_skid #( .P_WIDTH(R_WIDTH)) i_r (
    .clk           (axi_clk),
    .rst           (axi_reset),
    .in_valid      (m_axi_rvalid),
    .in_data       (m_r),
    .in_ready      (m_axi_rready),
    .out_valid     (s_axi_rvalid),
    .out_data      (s_r),
    .out_ready     (s_axi_rready)
  );

  emif_shim_skid #( .P_WIDTH(B_WIDTH)) i_b (
    .clk           (axi_clk),
    .rst           (axi_reset),
    .in_valid      (m_axi_bvalid),
    .in_data       (m_b),
    .in_ready      (m_axi_bready),
    .out_valid     (s_axi_bvalid),
    .out_data      (s_b),
    .out_ready     (s_axi_bready)
  );

endmodule
