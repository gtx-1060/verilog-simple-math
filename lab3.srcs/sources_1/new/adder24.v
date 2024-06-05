`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 03:39:32
// Design Name: 
// Module Name: adder24
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


module adder24(
    input  wire[23:0] a,
    input  wire[23:0] b,
    output wire[24:0] out // + carry
);

assign out = a + b;

endmodule
