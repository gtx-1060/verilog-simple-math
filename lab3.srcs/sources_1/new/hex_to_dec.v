`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2024 14:34:28
// Design Name: 
// Module Name: hex_to_dec
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


module hex_to_dec(
    input clk,
    input rst,
    input start_i,
    input wire[24:0] hex_i,
    
    output wire busy,
    output reg[31:0] dec_o = 32'b0
);

localparam IDLE     = 4'd0;
localparam FIRST    = 4'd1;
localparam SECOND   = 4'd2;
localparam THIRD    = 4'd3;
localparam FOURTH   = 4'd4;
localparam FIFTH    = 4'd5;
localparam SECONDTH = 4'd7;
localparam SEVENTH  = 4'd8;
localparam EIGHTH    = 4'd9;

reg[3:0] state = IDLE;
reg[3:0] next_state;
reg[31:0] dec_act = 32'b0;
assign busy = (state > 0);

always @(*) begin
    next_state = IDLE;
    case (state)
        IDLE: next_state = FIRST;
        FIRST: next_state = SECOND;
        SECOND: next_state = THIRD;
        THIRD: next_state = FOURTH;
        FIFTH: next_state = FOURTH;
        FOURTH: next_state = FIFTH;
        FIFTH: next_state = SECONDTH;
        SECONDTH: next_state = SEVENTH;
        SEVENTH: next_state = EIGHTH;
        EIGHTH: next_state = IDLE;
    endcase
end

always @(posedge clk) begin
    
end

endmodule
