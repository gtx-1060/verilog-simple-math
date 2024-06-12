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
    input crc_refresh,
    input wire[7:0] crc_i,
    
    output wire[7:0] lfsr_a_o,
    output wire[7:0] lfsr_b_o,
    output wire[7:0] counter_o,
    output wire[7:0] crc_o,
    output bist_active_o
);

parameter ITERATIONS = 255;

localparam IDLE = 3'd0;
localparam START = 3'd1;
localparam NEW_ITER = 3'd2;
localparam WAIT_FN = 3'd3;
localparam END = 3'd4;

reg[2:0] state = IDLE;
assign bist_active_o = (state > START);

reg clk_lfsr = 1'b0;
reg rst = 1'b0;

lfsr1 m_lfsr1(
    clk_lfsr,
    rst,
    lfsr_a_o
);

lfsr2 m_lfsr2(
    clk_lfsr,
    rst,
    lfsr_b_o
);

crc m_crc(
    clk_i,
    rst,
    crc_i,
    crc_refresh,
    crc_o
);

reg[7:0] iterations = 8'b0;
reg[7:0] counter = 8'b0;
assign counter_o = counter;

always @(posedge clk_i) begin
    case(state)
        IDLE:
        begin
            if (start_i) begin
                rst <= 1'b1;
                state <= START;
                counter <= counter + 1;
            end
        end
        START:
        begin
            rst <= 1'b0;
            state <= NEW_ITER;
            iterations <= ITERATIONS;
        end
        NEW_ITER:
        begin 
            if (fn_busy_i)
                state <= WAIT_FN;  
        end
        WAIT_FN:
        begin
            clk_lfsr <= 1'b1; 
            if (~fn_busy_i) begin
                state <= END;
                clk_lfsr <= 1'b0; 
            end
        end
        END:
        begin
            if (iterations == 0)
                state <= IDLE;
            else begin
                iterations <= iterations - 1;
                state <= NEW_ITER;
            end
        end
    endcase
end

endmodule
