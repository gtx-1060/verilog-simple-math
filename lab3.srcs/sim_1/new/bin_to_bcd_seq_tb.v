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


module bin_to_bcd_seq_tb;

reg clk = 1'b0;
always #10 clk = ~clk;

localparam TEST_SET_SZ = 6;
localparam TEST_START = 0;


reg[26:0] bin [0:TEST_SET_SZ];
reg[31:0] bcd [0:TEST_SET_SZ];
integer i = TEST_START;
reg start = 1'b0;

wire[31:0] bcd_out;
wire busy;
bin_to_bcd_seq m_bcd(
    clk,
    start,
    bin[i],
    bcd_out,
    busy
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
end

always @(posedge clk) begin
    if (~busy && ~start) begin
        if (i == TEST_SET_SZ) begin
            $display("TEST PASSED");
            $stop;
        end
        if (i > TEST_START) begin
            if (bcd[i-1] == bcd_out) begin
                $display("OK. for %d (%b)", bin[i-1], bcd_out);
            end else begin
                $display("ERROR! %b != %b", bcd[i-1], bcd_out);
                $stop;
            end
        end
        start <= 1'b1;
    end
    if (busy && start) begin
        start <= 1'b0;
        i <= i + 1;
    end
end

endmodule
