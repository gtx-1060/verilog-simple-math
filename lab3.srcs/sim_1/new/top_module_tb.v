`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.06.2024 10:27:25
// Design Name: 
// Module Name: top_module_tb
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


module top_module_tb;

reg clk = 1'b0;
always #10 clk = ~clk;

wire div_clk;
clk_divider m_clk_divider(
    clk,
    div_clk
);

reg start = 1'b0;
reg[7:0] a = 8'd5, b = 8'd13; // 5^3 + 5*13 = 190
wire[7:0] seg;
wire[7:0] seg_disabled;
wire busy;

top_module m_module(
    clk,
    0,
    start,
    a,
    b,
    seg,
    seg_disabled,
    busy
);

reg started = 1'b0;
integer counter = 0;

always @(posedge clk) begin
    if (~start && ~busy && ~started)
        start = 1'b1;
    if (start && busy) begin
        start = 1'b0;
        started = 1'b1;    
    end
end

always @(posedge div_clk) begin
    if (counter == 8) begin
        $display("TEST PASSED");
        $stop;
    end
    if (started && ~busy) begin
        $display("%d", counter);
        $display("seg: %b", seg);
        $display("seg_mask: %b", seg_disabled);
        counter <= counter + 1;
    end
end

always @(seg) begin
    if (started && ~busy) begin
    case (seg_disabled)
        8'b11111110:
        begin
            if (seg != 8'b11000000) begin
                $display("ERROR: WORNG RESULT");
                $stop;
            end
        end
        8'b11111101:
        begin
        if (seg != 8'b10010000) begin
            $display("ERROR: WORNG RESULT");
            $stop;
        end
        end
        8'b11111011:
        begin
        if (seg != 8'b11111001) begin
            $display("ERROR: WORNG RESULT");
            $stop;
        end
        end
        default:
        begin
            if (seg != 8'b11000000) begin
                $display("ERROR: WORNG RESULT");
                $stop;
            end
        end
    endcase
    end
end

endmodule
