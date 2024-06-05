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

wire[24:0] fn_result;
//reg[31:0] to_display = 31'b0;
wire[6:0] segs;
assign seg_o = {1'b1, segs};

wire[31:0] bcd_result;
wire [26:0] to_bcd = {2'b0, fn_result};
bin_to_bcd m_b2bcd(
    to_bcd,
    bcd_result
);

display_driver m_display_driver(
    clk_i,
    bcd_result,
    segs,
    seg_disabled_o
);

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

wire fn_busy;
function_module m_func(
    clk_i,
    deb_rst,
    deb_start,
    a_i,
    b_i,
    fn_busy,
    fn_result
);

assign busy = fn_busy;

endmodule
