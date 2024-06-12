`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2024 10:27:25
// Design Name: 
// Module Name: bist_tb
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


module bist_tb;

reg clk = 1'b0;
always #10 clk = ~clk;

reg start = 1'b0;
reg[7:0] a = 8'd5, b = 8'd13; // 5^3 + 5*13 = 190
wire busy;

wire[7:0] seg;
wire[7:0] seg_disabled;
wire[7:0] crc_o, bist_o;
top_module m_module(
    clk,
    0,
    0,
    start,
    a,
    b,
    seg,
    seg_disabled,
    crc_o,
    bist_o,
    busy
);

reg started = 1'b0;
integer counter = 0;

always @(posedge clk) begin
    if (~start && ~busy && ~started)
        start <= 1'b1;
    if (start && busy) begin
        start <= 1'b0;
        started <= 1'b1;    
    end
    if (started && ~busy && ~start) begin
        start <= 1'b1;
        if (counter == 10) begin
            $display("DONE");
            $stop;
        end else begin
            $display("i : %d", counter);
            $display("bist : %d", bist_o);
            $display("crc : %d", crc_o);
            if (
                crc_o != 193 ||
                bist_o != counter + 1
            ) begin
                $display("ERROR!");
                $stop;
            end
            counter <= counter + 1;
        end
    end
end

endmodule
