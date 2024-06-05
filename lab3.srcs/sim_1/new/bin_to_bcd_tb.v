`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2024 23:13:37
// Design Name: 
// Module Name: bin_to_bcd_tb
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


module bin_to_bcd_tb;

localparam TEST_SET_SZ = 6;
reg[26:0] bin [0:TEST_SET_SZ];
reg[31:0] bcd [0:TEST_SET_SZ];
integer i = 0;

wire[31:0] bcd_out;
bin_to_bcd m_bcd(
    bin[i],
    bcd_out
);

initial begin
    bin[0] = 27'd5;
    bin[1] = 27'd37;
    bin[2] = 27'd832;
    bin[3] = 27'd1832;
    bin[4] = 27'd621832;
    bin[5] = 27'd98621832;
    
    bcd[0] = 32'b0101;
    bcd[1] = 32'b0011_0111;
    bcd[2] = 32'b1000_0011_0010;
    bcd[3] = 32'b0001_1000_0011_0010;
    bcd[4] = 32'b0110_0010_0001_1000_0011_0010;
    bcd[5] = 32'b1001_1000_0110_0010_0001_1000_0011_0010;
    
    for (i = 0; i < TEST_SET_SZ; i = i + 1) begin
        #10;
        if (bcd[i] != bcd_out) begin
            $display("ERROR! %b != %b", bcd[i], bcd_out);
            $stop;
        end else begin
            $display("OK. for %d (%b)", bin[i], bcd_out);
        end
    end
end

endmodule
