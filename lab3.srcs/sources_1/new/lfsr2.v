`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2024 15:44:45
// Design Name: 
// Module Name: lfsr2
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

module lfsr2(
    input clk_i,
    input rst_i,
    output wire[7:0] lfsr_o
);

parameter INIT_VAL = 8'b10100101;

//reg rst = 1'b0;
reg[7:0] data = INIT_VAL;
wire[0:0] extend = data[1] ^ data[3] ^ data[4] ^ data[7];

assign lfsr_o = data;

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i)
        data = INIT_VAL;
    data <= {data[6:0], extend};
end

endmodule
