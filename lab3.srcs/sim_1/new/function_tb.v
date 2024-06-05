`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.05.2024 23:06:32
// Design Name: 
// Module Name: function_tb
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


module function_tb;

reg clk = 1'b0;
always #10 clk = ~clk;

integer i;
reg[7:0] as [0:5];
reg[7:0] bs [0:5];
reg[7:0] a, b;
reg[24:0] results  [0:5];
initial begin
    i = 0;
    as[1] = 8'd1;
    as[0] = 8'd42;
    as[2] = 8'd0;
    as[3] = 8'd21;
    as[4] = 8'd255;

    bs[1] = 8'd32;
    bs[0] = 8'd1;
    bs[2] = 8'd0;
    bs[3] = 8'd80;
    bs[4] = 8'd255;
    
    results[1] = 24'd33;
    results[0] = 24'd74130;
    results[2] = 24'd0;
    results[3] = 24'd10941;
    results[4] = 24'd16646400;
end

reg start = 1'b0;
wire busy;
wire[24:0] result;
function_module func(
    clk,
    1'b0,
    start,
    a,
    b,
    
    busy,
    result
);

always @(*) 
if (busy) begin
    start <= 1'b0;
end


always @(posedge clk) begin
    if (~busy && ~start) begin
        if (i > 0) begin
            if (result == results[i-1]) begin
                $display("OK. (%d*%d + %d^3 = %d)", a, b, a, results[i-1]);
            end else begin
                $display("ERROR! %d*%d + %d^3 = %d (but must be %d)",as[i-1], bs[i-1], as[i-1], result, results[i-1]);
                $stop;
            end
        end
        if (i == 5) begin
            $display("TEST PASSED");
            $stop;
        end
       start <= 1'b1;
       a <= as[i];
       b <= bs[i];
       i <= i + 1;
    end
end

endmodule
