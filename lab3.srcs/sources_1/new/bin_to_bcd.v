`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2024 15:12:24
// Design Name: 
// Module Name: bin_to_bcd
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
// https://www.realdigital.org/doc/6dae6583570fd816d1d675b93578203d 
//////////////////////////////////////////////////////////////////////////////////


module bin_to_bcd(
   input wire[26:0] bin,
   output reg[31:0] bcd = 32'b0
);
integer i;
	
always @(bin) begin
    bcd= 32'b0;		 	
    for (i = 0; i < 27; i = i + 1) begin					//Iterate once for each bit in input number
    if (bcd[3:0] >= 5)
        bcd[3:0] = bcd[3:0] + 3;		//If any BCD digit is >= 5, add 3
	if (bcd[7:4] >= 5)
	    bcd[7:4] = bcd[7:4] + 3;
	if (bcd[11:8] >= 5)
	    bcd[11:8] = bcd[11:8] + 3;
	if (bcd[15:12] >= 5)
	    bcd[15:12] = bcd[15:12] + 3;
	if (bcd[19:16] >= 5)
        bcd[19:16] = bcd[19:16] + 3;
	if (bcd[23:20] >= 5)
        bcd[23:20] = bcd[23:20] + 3;
	if (bcd[27:24] >= 5)
        bcd[27:24] = bcd[27:24] + 3;
	if (bcd[31:28] >= 5)
        bcd[31:28] = bcd[31:28] + 3;
	bcd = {bcd[30:0], bin[26-i]};				//Shift one bit, and shift in proper bit from input 
    end
end
endmodule
