`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2024 12:52:55
// Design Name: 
// Module Name: function_module
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


module function_module(
    input clk,
    input rst,
    input start_i,
    input wire[7:0] a_i,
    input wire[7:0] b_i,
    
    output wire busy,
    output reg[23:0] out
);

localparam IDLE = 3'd0;
localparam POWER_START = 3'd1;
localparam POWER_WAIT = 3'd2;
localparam MULTIPLY_START = 3'd3;
localparam MULTIPLY_WAIT = 3'd4;

reg[7:0] a, b;

// to share multiplier between two modules
reg mult_start_here = 1'b0;
wire mult_start_power;
wire mult_start = mult_start_here | mult_start_power;

wire[15:0] mult_in1_power, mult_in2_power;
reg[15:0] mult_in1_here = 16'h0, mult_in2_here = 16'h0;

wire[15:0] mult_in1 = mult_in1_power | mult_in1_here;
wire[15:0] mult_in2 = mult_in2_power | mult_in2_here;

wire mult_busy;
wire[31:0] mult_result;
multiplier mult(
    clk,
    1'b0,
    mult_in1,
    mult_in2,
    mult_start,
    mult_busy,
    mult_result
);

reg power_start = 1'b0;
wire power_busy;
wire[31:0] pow_result;
power m_power(
    clk,
    1'b0,
    
    // [in] base, pow, start
    a,
    3'd3,
    power_start,
    
    // multiplier [out] wires
    mult_result,
    mult_busy,
    // multiplier [in] control wires
    mult_in1_power,
    mult_in2_power,
    mult_start_power,
    
    // result
    power_busy,
    pow_result
);

wire[24:0] adder_result;
adder24 m_adder(
    pow_result,
    mult_result,
    adder_result
);

reg[0:2] state = IDLE;

assign busy = (state != 0);

//always@(*) begin
//    if (power_busy) begin
//        power_start <= 1'b0;
//    end
//    if (mult_busy) begin
//        mult_start_here <= 1'b0;
//    end
//end

always @(posedge clk) begin
    if (rst) begin
        out <= 0;
        state <= IDLE;
    end else begin
    case (state)
        IDLE:
        begin
            if (start_i) begin
                a <= a_i;
                b <= b_i;
                mult_in1_here <= 16'h0;
                mult_in2_here <= 16'h0;
                state <= POWER_START;
                power_start <= 1'b1;
            end
        end
        POWER_START:
        begin
            if (power_busy) begin
                power_start <= 1'b0;
                state <= POWER_WAIT;
            end
        end
        POWER_WAIT:
        begin
            if (~power_busy && ~power_start && ~mult_busy) begin
                mult_start_here <= 1'b1;
                mult_in1_here <= a;
                mult_in2_here <= b;
                state <= MULTIPLY_START;
            end
        end
        MULTIPLY_START:
        begin
            if (mult_busy) begin
                mult_start_here <= 1'b0;
                state <= MULTIPLY_WAIT;
            end
        end
        MULTIPLY_WAIT:
        begin
            if (~mult_busy && ~mult_start_here) begin
                state <= IDLE;
                out <= adder_result;
            end
        end
    endcase
    end
end

endmodule
