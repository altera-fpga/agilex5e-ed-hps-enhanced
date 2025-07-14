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

module alt_ehipc3_fm_100g_adapter_tx_async #(
    parameter DWIDTH        = 64,
    parameter EWIDTH        = 6,
    parameter READY_LATENCY = 0
) (
    input   logic                       i_arst,

    input   logic                       i_clk_w,
    input   logic   [0:7][DWIDTH-1:0]   i_data,
    input   logic        [EWIDTH-1:0]   i_empty,
    input   logic                       i_error,
    input   logic                       i_sop,
    input   logic                       i_eop,
    input   logic                       i_valid,
    input   logic                       i_skip_crc,
    output  logic                       o_ready,

    input   logic                       i_clk_r,
    output  logic   [0:3][DWIDTH-1:0]   o_data,
    output  logic   [0:3]               o_inframe,
    output  logic   [0:3]               o_error,
    output  logic   [0:3][2:0]          o_empty,
    output  logic                       o_valid,
    output  logic   [0:3]               o_skip_crc,
    input   logic                       i_ready,

    output  logic   [31:0]              o_starts_in,
    output  logic   [31:0]              o_starts_out,
    output  logic   [31:0]              o_ends_in,
    output  logic   [31:0]              o_ends_out,
    output  logic   [0:7]               o_mem_underflow
);

    genvar i;

    localparam  BWIDTH = 1+1+1+3+DWIDTH; // if, error, crc, empty, data
    logic                       reset_str_delay;

    logic   [0:7]               if_inframe;
    logic   [0:7]               if_error;
    logic   [0:7][2:0]          if_empty;
    logic   [0:7]               if_skip_crc;
    logic   [3:0]               if_num_valid;
    logic   [0:7][DWIDTH-1:0]   if_data;
    logic   [0:7][4:0]          if_write_pointers;
    logic   [0:7][4:0]          write_pointers_r2;
    logic   [0:7][4:0]          write_pointers_r3;
    logic        [2:0]          if_offset;

    logic   [0:7][BWIDTH-1:0]   write_data;
    logic   [0:7][BWIDTH-1:0]   write_data_rotated;
    logic   [0:7][BWIDTH-1:0]   read_data;
    logic   [0:7][BWIDTH-1:0]   read_data_reg;
    logic   [0:3][BWIDTH-1:0]   read_data_rotated;

    logic                       read_data_reg_valid;
    logic                       read_data_rotated_valid;

    logic                       ready_to_read;
    logic                       read_mem;
    logic   [0:1][4:0]          read_pointers;
    logic                       read_offset;

    logic                       read_offset_r2;

    logic                       ready_int;
    logic                       ready_delay;

    logic   [5:0]               num_written;
    logic   [3:0]               num_valid_delay;

    logic   [0:3]               o_inframe_int;

    logic                       ready_to_read_sync;
    logic   [5:0]               num_read;
    logic   [5:0]               num_read_sync;

    logic   r_reset;
    logic   w_reset;
    logic   r_reset_str;

    alt_ehipc3_fm_reset_synchronizer sync_r_rst (
        .aclr       (i_arst),
        .clk        (i_clk_r),
        .aclr_sync  (r_reset)
    );

    alt_ehipc3_fm_reset_stretch_16a rss (
        .i_reset    (r_reset),
        .i_clk      (i_clk_r),
        .o_reset    (r_reset_str)
    );

    alt_ehipc3_fm_reset_synchronizer sync_w_rst (
        .aclr       (r_reset_str),
        .clk        (i_clk_w),
        .aclr_sync  (w_reset)
    );

    always_ff @(posedge i_clk_w) begin
        if (w_reset) begin
            o_ready <= 1'b0;
        end else begin
            o_ready <= ready_int;
        end
    end

    generate
        for (i = 0; i < 8; i++) begin : mem_loop
            assign write_data[i] = {if_inframe[i], if_error[i], if_skip_crc[i], if_empty[i], if_data[i]};

            alt_ehipc3_fm_mlab #(
                .WIDTH      (BWIDTH),
                .ADDR_WIDTH (5),
                .SIM_EMULATE(0)
            ) mem (
                .wclk       (i_clk_w),
                .wdata_reg  (write_data_rotated[i]),
                .wena       (1'b1),
                .waddr_reg  (write_pointers_r3[i]),
                .raddr      (read_pointers[i[2]]),
                .rdata      (read_data[i])
            );
        end

        for (i = 0; i < 4; i++) begin : o_data_loop
            assign {o_inframe_int[i], o_error[i], o_skip_crc[i], o_empty[i], o_data[i]} = read_data_rotated[i];
            assign o_inframe[i] = read_data_rotated_valid ? o_inframe_int[i] : 1'b0; // Mask inframe bits when !o_valid to prevent reset issues
        end
    endgenerate

    alt_ehipc3_fm_delay_reg #(
        .CYCLES (READY_LATENCY + 1),
        .WIDTH  (1)
    ) dv (
        .clk    (i_clk_w),
        .din    (ready_int),
        .dout   (ready_delay)
    );

    alt_ehipc3_fm_delay_reg #(
        .CYCLES (4),
        .WIDTH  (4)
    ) num_write_blocks_delay_inst (
        .clk    (i_clk_w),
        .din    (if_num_valid),
        .dout   (num_valid_delay)
    );

    alt_ehipc3_fm_pointer_synchronizer #(
        .WIDTH      (6)
    ) read_cnt_sync (
        .clk_in     (i_clk_r),
        .ptr_in     (num_read),
        .clk_out    (i_clk_w),
        .ptr_out    (num_read_sync)
    );

    alt_ehipc3_fm_ready_gen_100g_a #(
        .READY_LATENCY  (READY_LATENCY + 6)
    ) ready_gen_inst (
        .i_reset        (w_reset),
        .i_clk          (i_clk_w),
        .i_num_write    (num_valid_delay),  // if_num_valid
        .i_read_ptr     ({num_read_sync, 2'd0}),
        .o_ready        (ready_int)
    );

    always_ff @(posedge i_clk_r) begin
        read_data_reg       <= read_data;
        read_offset_r2      <= read_offset;
    end

    alt_ehipc3_fm_delay_reg #(
        .CYCLES (3),
        .WIDTH  (1)
    ) valid_out_delay (
        .clk    (i_clk_r),
        .din    (i_ready),
        .dout   (o_valid)
    );

    alt_ehipc3_fm_delay_reg #(
        .CYCLES (READY_LATENCY + 1),
        .WIDTH  (1)
    ) reset_delay (
        .clk    (i_clk_w),
        .din    (w_reset),
        .dout   (reset_str_delay)
    );

    alt_ehipc3_fm_100g_avalon_to_if a2i (
        .i_clk          (i_clk_w),
        .i_reset        (reset_str_delay),

        .i_empty        (i_empty),
        .i_error        (i_error),
        .i_sop          (i_sop && i_valid),
        .i_eop          (i_eop),
        .i_valid        (ready_delay),
        .i_skip_crc     (i_skip_crc),

        .o_inframe      (if_inframe),
        .o_error        (if_error),
        .o_empty        (if_empty),
        .o_skip_crc     (if_skip_crc),
        .o_num_valid    (if_num_valid)
    );

    always_ff @(posedge i_clk_w) if_data <= i_data;

    alt_ehipc3_fm_wptr_gen_tx100a wptr_gen_inst (
        .i_reset            (w_reset),
        .i_clk              (i_clk_w),
        .i_num_write        (if_num_valid),
        .o_write_pointers   (if_write_pointers),
        .offset             (if_offset)
    );

    alt_ehipc3_fm_data_rotate_8to8_tx100a #(
        .WIDTH      (BWIDTH)
    ) w_data_rotate (
        .i_clk      (i_clk_w),
        .i_rotate   (if_offset),
        .i_data     (write_data),
        .o_data     (write_data_rotated)
    );

    always_ff @(posedge i_clk_w) begin
        write_pointers_r2   <= if_write_pointers;
        write_pointers_r3   <= write_pointers_r2;
    end

    always_ff @(posedge i_clk_w) begin
        if (w_reset) begin
            ready_to_read   <= 1'b0;
            num_written     <= 6'd0;
        end else begin
            ready_to_read   <= ready_to_read | (num_written >= 6'd39);
            num_written     <= 6'(num_written + num_valid_delay);
        end
    end

    alt_ehipc3_fm_altera_std_synchronizer_nocut rdy_sync (
        .clk        (i_clk_r),
        .reset_n    (1'b1),
        .din        (ready_to_read),
        .dout       (ready_to_read_sync)
    );

    always_ff @(posedge i_clk_r) begin
        read_mem                <= i_ready && ready_to_read_sync;
        read_data_reg_valid     <= read_mem;
        read_data_rotated_valid <= read_data_reg_valid;

        if (r_reset_str) begin
            num_read    <= 6'd0;
        end else begin
            num_read    <= read_mem ? num_read + 6'd1 : num_read;
        end
    end

    alt_ehipc3_fm_rptr_gen_tx100a rptr_gen_inst (
        .i_reset            (r_reset_str),
        .i_clk              (i_clk_r),
        .i_read             (read_mem),
        .o_read_pointers    (read_pointers),
        .o_rotation         (read_offset)
    );

    alt_ehipc3_fm_data_mux_2to1_tx100a #(
        .WIDTH  (4*BWIDTH)
    ) rd_mux (
        .i_clk  (i_clk_r),
        .i_sel  (read_offset_r2),
        .i_data (read_data_reg),
        .o_data (read_data_rotated)
    );

endmodule // alt_ehipc3_fm_100g_adapter_tx_async


module alt_ehipc3_fm_reset_stretch_16a (
    input   logic   i_reset,
    input   logic   i_clk,
    output  logic   o_reset
);
    logic   [3:0]   timer;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            timer   <= 4'hF;
            o_reset <= 1'b1;
        end else begin
            if (timer == 4'd0) begin
                timer   <= timer;
                o_reset <= 1'b0;
            end else begin
                timer   <= timer - 1'd1;
                o_reset <= 1'b1;
            end
        end
    end
endmodule

module alt_ehipc3_fm_ready_gen_100g_a #(
    parameter READY_LATENCY = 0
) (
    input   logic           i_reset,
    input   logic           i_clk,
    input   logic   [3:0]   i_num_write,
    input   logic   [7:0]   i_read_ptr,
    output  logic           o_ready
);

    logic   [7:0]   virtual_writes;
    logic   [7:0]   virtual_used;
    logic           partial_full;
    logic           ready_delay;

    logic   [7:0]   num_add;
    logic   [7:0]   num_remove;

    assign virtual_used = 8'(virtual_writes - i_read_ptr);
    assign partial_full = (virtual_used >= 8'd39);
    assign o_ready      = !partial_full;

    assign num_add      = {4'd0, !ready_delay, 3'd0};
    assign num_remove   = {4'd0, !o_ready,     3'd0};

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            virtual_writes  <= 8'd0;
        end else begin
            virtual_writes  <= 8'(virtual_writes + i_num_write + num_add - num_remove);
        end
    end

    alt_ehipc3_fm_delay_reg #(
        .CYCLES (READY_LATENCY),
        .WIDTH  (1)
    ) delay_rdy_fb (
        .clk    (i_clk),
        .din    (o_ready),
        .dout   (ready_delay)
    );
endmodule

module alt_ehipc3_fm_data_mux_2to1_tx100a #(
    parameter WIDTH = 8
) (
    input   logic                       i_clk,
    input   logic                       i_sel,
    input   logic   [0:1][WIDTH-1:0]    i_data,
    output  logic        [WIDTH-1:0]    o_data
);

    always_ff @(posedge i_clk) begin
        case (i_sel)
            1'd0 : o_data  <= i_data[0];
            1'd1 : o_data  <= i_data[1];
        endcase
    end
endmodule

module alt_ehipc3_fm_rptr_gen_tx100a (
    input   logic               i_reset,
    input   logic               i_clk,
    input   logic               i_read,
    output  logic   [0:1][4:0]  o_read_pointers,
    output  logic               o_rotation
);
    logic   [0:1][5:0]  phase;

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            phase[0]    <= 6'd1;
            phase[1]    <= 6'd0;
        end else begin
            if (i_read) begin
                phase[0]    <= 6'(phase[0] + 6'd1);
                phase[1]    <= 6'(phase[1] + 6'd1);
            end else begin
                phase[0]    <= phase[0];
                phase[1]    <= phase[1];
            end
        end
    end

    assign o_read_pointers[0] = phase[0][5:1];
    assign o_read_pointers[1] = phase[1][5:1];
    assign o_rotation         = phase[1][0];
endmodule

module alt_ehipc3_fm_data_rotate_8to8_tx100a #(
    parameter WIDTH = 8
) (
    input   logic                       i_clk,
    input   logic        [2:0]          i_rotate,
    input   logic   [0:7][WIDTH-1:0]    i_data,
    output  logic   [0:7][WIDTH-1:0]    o_data
);

    logic   [0:7][WIDTH-1:0]    o_data_reg;

    always_ff @(posedge i_clk) begin
        case (i_rotate)
            3'd0 : o_data_reg   <= i_data;
            3'd1 : o_data_reg   <= {i_data[7], i_data[0:6]};
            3'd2 : o_data_reg   <= {i_data[6:7], i_data[0:5]};
            3'd3 : o_data_reg   <= {i_data[5:7], i_data[0:4]};
            3'd4 : o_data_reg   <= {i_data[4:7], i_data[0:3]};
            3'd5 : o_data_reg   <= {i_data[3:7], i_data[0:2]};
            3'd6 : o_data_reg   <= {i_data[2:7], i_data[0:1]};
            3'd7 : o_data_reg   <= {i_data[1:7], i_data[0]};
        endcase
        o_data <= o_data_reg;
    end
endmodule

module alt_ehipc3_fm_wptr_gen_tx100a (
    input   logic               i_reset,
    input   logic               i_clk,
    input   logic        [3:0]  i_num_write,
    output  logic   [0:7][4:0]  o_write_pointers,
    output  logic        [2:0]  offset
);

    logic   [0:7][7:0]  phase;
    genvar i;
    generate
        for (i = 0; i < 8; i++) begin : wptr_loop
            always_ff @(posedge i_clk) begin
                if (i_reset) begin
                    phase[i]    <= 8'd7 - i[7:0];
                end else begin
                    phase[i]    <= 8'(phase[i] + i_num_write);
                end
            end
            assign o_write_pointers[i] = phase[i][7:3];
        end
    endgenerate

    assign offset           = phase[7][2:0];
endmodule
