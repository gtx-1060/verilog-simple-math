`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2024 13:58:30
// Design Name: 
// Module Name: clk_divider
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


module clk_divider(
    input clk_i,    
    output reg clk_o
);

localparam DIV = 200000;
reg[31:0] counter = 32'b0;

always @(posedge clk_i) begin
    counter <= counter + 1;
    if (counter >= DIV-1) begin
        counter <= 32'b0;
    end
    clk_o <= (counter < DIV/2) ? 1'b1 : 1'b0;
end

endmodule
