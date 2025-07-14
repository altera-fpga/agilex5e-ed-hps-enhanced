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

module alt_ehipc3_fm_sl_avmm_32to8 #(
    parameter TIMEOUT = 1000
) (
    input               clk,
    input               reset,

    input               master_read,
    input               master_write,
    input       [31:0]  master_address,
    input       [31:0]  master_write_data,
    input       [3:0]   master_byte_enable,
    output reg          master_read_valid,
    output reg          master_wait,
    output reg  [31:0]  master_read_data,

    input               slave_enable,
    output reg          slave_read,
    output reg          slave_write,
    output reg  [31:0]  slave_address,
    output reg  [ 7:0]  slave_write_data,
    input               slave_read_valid,
    input               slave_wait,
    input       [ 7:0]  slave_read_data
);

    enum {  IDLE,
            WR_WAIT_0 , WR_WAIT_1 , WR_WAIT_2 , WR_WAIT_3 , WR_DONE,
            RD_WAIT_ACCEPT_0 , RD_WAIT_ACCEPT_1 , RD_WAIT_ACCEPT_2 , RD_WAIT_ACCEPT_3,
            RD_WAIT_VALID_0 , RD_WAIT_VALID_1 , RD_WAIT_VALID_2 , RD_WAIT_VALID_3,
            RD_ACCEPT , RD_VALID } state;

    localparam TIMER_BITS = $clog2(TIMEOUT + 1);

    reg [TIMER_BITS-1:0]    timer;
    reg                     slave_enable_r;
    wire                    slave_enable_redge;
    reg                     master_write_r;
    reg                     master_read_r;

    always_ff @(posedge clk) begin
        if (reset) begin
            slave_enable_r   <= 1'b0;
        end else begin
            slave_enable_r   <= slave_enable;
        end
    end

    assign slave_enable_redge = slave_enable & ~slave_enable_r;

    always_ff @(posedge clk) begin
        if (reset) begin
            state               <= IDLE;
            master_read_valid   <= 1'b0;
            master_wait         <= 1'b1;
            master_read_data    <= 32'd0;
            slave_read          <= 1'b0;
            slave_write         <= 1'b0;
            slave_address       <= 32'd0;
            slave_write_data    <= 8'd0;
            timer               <= {TIMER_BITS{1'b0}};
            master_write_r      <= 1'b0;
            master_read_r       <= 1'b0;
        end else begin
            state               <= state;
            master_read_valid   <= master_read_valid;
            master_wait         <= master_wait;
            master_read_data    <= master_read_data;
            slave_read          <= slave_read;
            slave_write         <= slave_write;
            slave_address       <= slave_address;
            slave_write_data    <= slave_write_data;
            master_write_r      <= master_write_r;
            master_read_r       <= master_read_r;

            // Timeout handler
            if ((state != IDLE) && ~slave_enable_redge) begin
                timer   <= timer + 1'b1;
                if (timer == TIMEOUT[TIMER_BITS-1:0]) begin
                    master_wait         <= 1'b0;
                    slave_write         <= 1'b0;
                    slave_read          <= 1'b0;
                    if (master_write_r) begin
                        state               <= WR_DONE;
                    end else if (master_read_r) begin
                        state               <= RD_ACCEPT;
                    end
                end
            end else begin
                timer   <= {TIMER_BITS{1'b0}};
            end

            case (state)
                IDLE                : begin
                    if (master_write) begin
                        master_read_valid   <= 1'b0;
                        master_wait         <= 1'b1;
                        master_read_data    <= 32'd0;
                        slave_read          <= 1'b0;
                        master_write_r      <= 1'b1;
                        master_read_r       <= 1'b0;
                        casez (master_byte_enable)
                            4'b???1 : begin
                                state               <= WR_WAIT_0;
                                slave_address       <= {master_address[29:0], 2'd0};
                                slave_write_data    <= master_write_data[7:0];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b??10 : begin
                                state               <= WR_WAIT_1;
                                slave_address       <= {master_address[29:0], 2'd1};
                                slave_write_data    <= master_write_data[15:8];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b?100 : begin
                                state               <= WR_WAIT_2;
                                slave_address       <= {master_address[29:0], 2'd2};
                                slave_write_data    <= master_write_data[23:16];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b1000 : begin
                                state               <= WR_WAIT_3;
                                slave_address       <= {master_address[29:0], 2'd3};
                                slave_write_data    <= master_write_data[31:24];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b0000 : begin
                                state               <= WR_DONE;
                                master_wait         <= 1'b0;
                                slave_write         <= 1'b0;
                            end
                        endcase
                    end
                    if (master_read) begin
                        state               <= RD_WAIT_ACCEPT_0;
                        master_read_valid   <= 1'b0;
                        master_wait         <= 1'b1;
                        master_read_data    <= 32'd0;
                        slave_read          <= slave_enable ? 1'b1 : 1'b0;
                        slave_write         <= 1'b0;
                        slave_address       <= {master_address[29:0], 2'd0};
                        slave_write_data    <= 8'd0;
                        master_read_r       <= 1'b1;
                        master_write_r      <= 1'b0;
                    end
                end
                WR_WAIT_0           : begin
                    if (!slave_wait) begin
                        casez (master_byte_enable)
                            4'b??1? : begin
                                state               <= WR_WAIT_1;
                                slave_address       <= {master_address[29:0], 2'd1};
                                slave_write_data    <= master_write_data[15:8];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b?10? : begin
                                state               <= WR_WAIT_2;
                                slave_address       <= {master_address[29:0], 2'd2};
                                slave_write_data    <= master_write_data[23:16];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b100? : begin
                                state               <= WR_WAIT_3;
                                slave_address       <= {master_address[29:0], 2'd3};
                                slave_write_data    <= master_write_data[31:24];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b000? : begin
                                state               <= WR_DONE;
                                master_wait         <= 1'b0;
                                slave_write         <= 1'b0;
                            end
                        endcase
                    end
                end
                WR_WAIT_1           : begin
                    if (!slave_wait) begin
                        casez (master_byte_enable)
                            4'b?1?? : begin
                                state               <= WR_WAIT_2;
                                slave_address       <= {master_address[29:0], 2'd2};
                                slave_write_data    <= master_write_data[23:16];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b10?? : begin
                                state               <= WR_WAIT_3;
                                slave_address       <= {master_address[29:0], 2'd3};
                                slave_write_data    <= master_write_data[31:24];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b00?? : begin
                                state               <= WR_DONE;
                                master_wait         <= 1'b0;
                                slave_write         <= 1'b0;
                            end
                        endcase
                    end
                end
                WR_WAIT_2           : begin
                    if (!slave_wait) begin
                        casez (master_byte_enable)
                            4'b1??? : begin
                                state               <= WR_WAIT_3;
                                slave_address       <= {master_address[29:0], 2'd3};
                                slave_write_data    <= master_write_data[31:24];
                                slave_write         <= slave_enable ? 1'b1 : 1'b0;
                            end
                            4'b0??? : begin
                                state               <= WR_DONE;
                                master_wait         <= 1'b0;
                                slave_write         <= 1'b0;
                            end
                        endcase
                    end
                end
                WR_WAIT_3           : begin
                    if (!slave_wait) begin
                        state               <= WR_DONE;
                        master_wait         <= 1'b0;
                        slave_write         <= 1'b0;
                    end
                end
                WR_DONE             : begin
                    state               <= IDLE;
                    master_wait         <= 1'b1;
                end
                RD_WAIT_ACCEPT_0    : begin
                    if (!slave_wait) begin
                        if (slave_read_valid & slave_enable) begin
                            state                   <= RD_WAIT_ACCEPT_1;
                            master_read_data[7:0]   <= slave_read_data;
                            slave_address           <= {master_address[29:0], 2'd1};
                        end else begin
                            state                   <= RD_WAIT_VALID_0;
                            slave_read              <= 1'b0;
                        end
                    end
                end
                RD_WAIT_ACCEPT_1    : begin
                    if (!slave_wait) begin
                        if (slave_read_valid & slave_enable) begin
                            state                   <= RD_WAIT_ACCEPT_2;
                            master_read_data[15:8]  <= slave_read_data;
                            slave_address           <= {master_address[29:0], 2'd2};
                        end else begin
                            state                   <= RD_WAIT_VALID_1;
                            slave_read              <= 1'b0;
                        end
                    end
                end
                RD_WAIT_ACCEPT_2    : begin
                    if (!slave_wait) begin
                        if (slave_read_valid & slave_enable) begin
                            state                   <= RD_WAIT_ACCEPT_3;
                            master_read_data[23:16] <= slave_read_data;
                            slave_address           <= {master_address[29:0], 2'd3};
                        end else begin
                            state                   <= RD_WAIT_VALID_2;
                            slave_read              <= 1'b0;
                        end
                    end
                end
                RD_WAIT_ACCEPT_3    : begin
                    if (!slave_wait) begin
                        if (slave_read_valid & slave_enable) begin
                            state                   <= RD_ACCEPT;
                            master_wait             <= 1'b0;
                            master_read_data[31:24] <= slave_read_data;
                            slave_read              <= 1'b0;
                        end else begin
                            state                   <= RD_WAIT_VALID_3;
                            slave_read              <= 1'b0;
                        end
                    end
                end
                RD_WAIT_VALID_0     : begin
                    if (slave_read_valid) begin
                        state                   <= RD_WAIT_ACCEPT_1;
                        master_read_data[7:0]   <= slave_read_data;
                        slave_address           <= {master_address[29:0], 2'd1};
                        slave_read              <= slave_enable ? 1'b1 : 1'b0;
                    end
                end
                RD_WAIT_VALID_1     : begin
                    if (slave_read_valid) begin
                        state                   <= RD_WAIT_ACCEPT_2;
                        master_read_data[15:8]  <= slave_read_data;
                        slave_address           <= {master_address[29:0], 2'd2};
                        slave_read              <= slave_enable ? 1'b1 : 1'b0;
                    end
                end
                RD_WAIT_VALID_2     : begin
                    if (slave_read_valid) begin
                        state                   <= RD_WAIT_ACCEPT_3;
                        master_read_data[23:16] <= slave_read_data;
                        slave_address           <= {master_address[29:0], 2'd3};
                        slave_read              <= slave_enable ? 1'b1 : 1'b0;
                    end
                end
                RD_WAIT_VALID_3     : begin
                    if (slave_read_valid) begin
                        state                   <= RD_ACCEPT;
                        master_wait             <= 1'b0;
                        master_read_data[31:24] <= slave_read_data;
                        slave_read              <= 1'b0;
                    end
                end
                RD_ACCEPT           : begin
                    state                       <= RD_VALID;
                    master_read_valid           <= 1'b1;
                    master_wait                 <= 1'b1;
                end
                RD_VALID            : begin
                    state                       <= IDLE;
                    master_read_valid           <= 1'b0;
                end
                default             : begin
                    state               <= IDLE;
                    master_read_valid   <= 1'b0;
                    master_wait         <= 1'b1;
                    master_read_data    <= 32'd0;
                    slave_read          <= 1'b0;
                    slave_write         <= 1'b0;
                    slave_address       <= 32'd0;
                    slave_write_data    <= 8'd0;
                    master_write_r      <= 1'b0;
                    master_read_r       <= 1'b0;
                end
            endcase
        end
    end

endmodule
