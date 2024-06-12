`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2024 16:21:40
// Design Name: 
// Module Name: crc
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


module crc(
    input clk_i,
    input rst_i,
    input[7:0] data_i,
    input activate,
    output reg[7:0] crc = 8'b10110111
);

parameter INIT = 8'b10110111;
parameter K = 8'b10010101;

integer i;
reg[7:0] lfsr = 8'b0;
reg rst = 1'b0;

always @(posedge activate or posedge rst) begin
    lfsr = crc;
    if (~rst) 
        for (i = 0; i  < 8; i = i + 1) begin
            lfsr = lfsr ^ data_i;
            if (lfsr[7]) begin
                lfsr = {lfsr[6:0], 1'b0};
                lfsr = lfsr ^ K;    
            end 
            else begin
                lfsr = {lfsr[6:0], 1'b0};
            end
        end
//    $display("frm crc: %d, %d", lfsr, data_i);
end

always @(posedge clk_i) begin
    if (rst_i) begin
        crc <= INIT;
        rst <= 1'b1;
    end
    else begin
        crc <= lfsr;
        rst <= 1'b0;
    end
end

endmodule