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
    input wire[7:0] a_i,
    input wire[7:0] b_i,

    output wire[7:0] seg_o,
    output wire[7:0] seg_disabled_o,
    output busy
);

wire fn_busy;
wire deb_rst, deb_start;
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

localparam IDLE = 3'd0;
localparam WAIT = 3'd2;
localparam WAIT_START_BCD = 3'd3;
localparam WAIT_BCD = 3'd4;

reg[2:0] state = IDLE;


wire[24:0] fn_result;
//reg[31:0] to_display = 31'b0;
wire[6:0] segs;
assign seg_o = {1'b1, segs};

wire[31:0] bcd_result;
wire bcd_busy;
reg bcd_start = 1'b0;
wire [26:0] to_bcd = {2'b0, fn_result};
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

function_module m_func(
    clk_i,
    deb_rst,
    deb_start,
    a_i,
    b_i,
    fn_busy,
    fn_result
);

always @(posedge clk_i) begin
    case (state) 
        IDLE:
        if (fn_busy)
            state <= WAIT;
        WAIT:
        if (~fn_busy) begin
            state <= WAIT_START_BCD;
            bcd_start <= 1'b1;
        end 
        WAIT_START_BCD:
        if (bcd_busy) begin
            state <= WAIT_BCD;
            bcd_start <= 1'b0;
        end
        WAIT_BCD:
        if (~bcd_busy)
            state <= IDLE;
    endcase
end

assign busy = (state != IDLE);

endmodule
