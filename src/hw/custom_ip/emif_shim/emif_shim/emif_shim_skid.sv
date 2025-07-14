module emif_shim_skid #( parameter P_WIDTH = 10 ) (

  input  wire                  clk,
  input  wire                  rst,

  input  wire                  in_valid,
  input  wire  [P_WIDTH-1:0]   in_data,
  output reg                   in_ready,

  output  reg                  out_valid,
  output  reg   [P_WIDTH-1:0]  out_data /* synthesis dont_merge syn_preserve = 1 */,
  input   wire                 out_ready
);

  (* noprune *) logic [P_WIDTH-1:0]  in_data_hld;
  (* noprune *) logic [P_WIDTH-1:0]  out_data_reg;
  wire                 out_valid_nxt;
  wire                 in_ready_nxt;

  assign out_valid_nxt = in_valid  | (out_valid & (~in_ready  | ~out_ready));
  assign in_ready_nxt  = out_ready | (in_ready &  (~out_valid | ~in_valid));

  always_ff @(posedge clk) begin
    if (rst) begin
      in_ready  <= 1'b1;
      out_valid <= 1'b0;
    end else begin
      out_valid <= out_valid_nxt;
      in_ready  <= in_ready_nxt;
    end

    if (in_ready) begin
      in_data_hld <= in_data;
    end

    if (out_ready | ~out_valid) begin
       if (!in_ready) begin
         out_data_reg <= in_data_hld;
       end else begin
         out_data_reg <= in_data;
       end
    end
   end


  assign out_data = out_data_reg;

endmodule
