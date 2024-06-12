`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2024 15:54:26
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk_i,
    input rst_i,
    input start_i,
    input start_bist_i,
    input wire[7:0] a_i,
    input wire[7:0] b_i,

    output wire[7:0] seg_o,
    output wire[7:0] seg_disabled_o,
    output wire[7:0] crc_o,
    output wire[7:0] bist_c_o,
    output busy
);

localparam IDLE             = 4'd0;
localparam FN_WAIT_START    = 4'd1;
localparam FN_WAIT          = 4'd2;
localparam BCD_WAIT_START   = 4'd3;
localparam BCD_WAIT         = 4'd4;
localparam BIST_WAIT_START  = 4'd5;
localparam BIST_WAIT        = 4'd10;
localparam BIST_END_ITER    = 4'd6;
localparam CRC_WORD1        = 4'd7;
localparam CRC_WORD2        = 4'd8;
localparam CRC_WORD3        = 4'd9;

reg[3:0] state = IDLE;

wire fn_busy;
wire deb_rst, deb_start, deb_bist;
debounce rst_debounce(
    clk_i,
    rst_i,
    deb_rst
);
debounce start_debounce(
    clk_i,
    start_i,
    deb_start
);
debounce bist_debounce(
    clk_i,
    start_bist_i,
    deb_bist
);

wire[23:0] fn_result;
wire[6:0] segs;
assign seg_o = {1'b1, segs};

wire[31:0] bcd_result;
wire bcd_busy;
reg bcd_start = 1'b0;
wire [26:0] to_bcd = {3'b0, fn_result};

wire bist_mode;
wire[7:0] bist_a, bist_b;
reg[7:0] a, b;
// select DUP input
always @(*) begin
    if (bist_mode) begin
        a = bist_a;
        b = bist_b;
    end 
    else begin
        a = a_i;
        b = b_i;
    end
end

bin_to_bcd_seq m_b2bcd(
    clk_i,
    bcd_start,
    to_bcd,
    bcd_result,
    bcd_busy
);

display_driver m_display_driver(
    clk_i,
    bcd_result,
    segs,
    seg_disabled_o
);

reg fn_start = 1'b0;
function_module m_func(
    clk_i,
    deb_rst,
    fn_start,
    a,
    b,
    fn_busy,
    fn_result
);

reg start_bist = 1'b0;
reg bist_started = 1'b0;
bist m_bist(
    clk_i,
    start_bist,
    fn_busy,
    bist_a,
    bist_b,
    bist_c_o,
    bist_mode
);

reg[7:0] crc_i = 8'b0;
//wire crc_rst = deb_bist && (~bist_mode);
wire[7:0] crc_val;
crc m_crc(
    clk_i,
    start_bist,
    crc_i,
    crc_val
);

reg[7:0] crc_reg = 8'b0;

always @(posedge clk_i) begin
    case (state) 
        IDLE:
            if (deb_start)
                state <= FN_WAIT_START;
            else if (deb_bist)
                state <= BIST_WAIT_START;
            else if (deb_rst)
                state <= BCD_WAIT_START;
        BIST_WAIT_START: 
        begin
            if (~bist_mode)
                start_bist <= 1'b1;
            else
                state <= BIST_WAIT_START;
        end
        BIST_WAIT: 
        begin
            start_bist <= 1'b0;
            bist_started <= 1'b1;
        end
        BIST_END_ITER:
        begin
            if (bist_mode)
                state <= FN_WAIT_START;
            else begin
                if (bist_started) begin
                    state <= IDLE;
                    bist_started <= 1'b0;
                    crc_reg <= crc_val;
                end 
                else begin
                    state <= BCD_WAIT_START;
                end
            end
        end
        FN_WAIT_START:
        begin
            fn_start <= 1'b1;
            if (fn_busy)
                state <= FN_WAIT;
        end
        FN_WAIT:
        begin
            fn_start <= 1'b0;
            if (~fn_busy)
                state <= CRC_WORD1;
        end
        CRC_WORD1:
        begin
            crc_i <= fn_result[7:0];
            state <= CRC_WORD2;
        end
        CRC_WORD2:
        begin
            crc_i <= fn_result[15:8];
            state <= CRC_WORD3;      
        end
        CRC_WORD3:
        begin
            crc_i <= fn_result[23:16];
            state <= BIST_END_ITER;
        end
        BCD_WAIT_START:
        begin
            bcd_start <= 1'b1;
            if (bcd_busy)
                state <= BCD_WAIT;
            end
        BCD_WAIT:
        begin
            bcd_start <= 1'b0;
            if (~bcd_busy)
                state <= IDLE;
        end
    endcase
end

assign busy = (state != IDLE);
assign crc_o = crc_reg;

endmodule
