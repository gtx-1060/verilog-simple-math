`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2024 15:44:20
// Design Name: 
// Module Name: bist
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


module bist(
    input clk_i,
    input start_i,
    input fn_busy_i,
    
    output wire[7:0] lfsr_a_o,
    output wire[7:0] lfsr_b_o,
    output wire[7:0] counter_o,
    output bist_mode_o
);

reg lfsr_clk = 1'b0;
lfsr1 m_lfsr1(
    lfsr_clk,
    start_i,
    lfsr_a_o
);

lfsr2 m_lfsr2(
    lfsr_clk,
    start_i,
    lfsr_b_o
);

reg[8:0] iterations = 9'b0;
reg[7:0] counter = 8'b0;

always @(posedge fn_busy_i)
begin
    lfsr_clk <= 1'b1;
end

always @(negedge fn_busy_i or posedge start_i)
begin
    if (start_i) begin
        if (iterations == 0) begin
            iterations <= 9'd256;
            counter <= counter + 1;
        end
    end
    else begin 
        if (iterations > 0) begin
            iterations <= iterations - 1;
        end
    end
end

always @(negedge fn_busy_i) begin
     if (iterations > 0)
        lfsr_clk <= 1'b0;
end

assign bist_mode_o = (iterations > 0);
assign counter_o = counter;

endmodule
