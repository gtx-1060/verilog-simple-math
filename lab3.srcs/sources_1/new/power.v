`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2024 15:46:52
// Design Name: 
// Module Name: power
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


module power(
    input clk,
    input rst,
    
    input wire[7:0] base_i,
    input wire[2:0] power_i,
    input wire start_i,

    input wire[31:0] mult_result_i,
    input wire mult_busy_i,

    output wire[15:0] mult_in1_o,
    output wire[15:0] mult_in2_o,
    output wire mult_start_o,
    
    output busy,
    output reg[31:0] out
);

localparam IDLE = 2'd0;
localparam MULT_START = 2'd1;
localparam WORK = 2'd2;

reg[1:0] state = IDLE;
reg mult_start = 1'b0;
reg [7:0] base;
reg[3:0] power;
reg[3:0] actual_power;
reg[31:0] actual_result = 32'h0;

wire[7:0] new_power;

wire[7:0] adder_arg1 = {{4{1'b0}}, actual_power};
adder m_adder(
    adder_arg1,
    8'b1,
    new_power
);

assign busy = (state != IDLE);
assign mult_start_o = mult_start;
assign mult_in1_o = actual_result & {16{busy}};
assign mult_in2_o = base & {16{busy}};



//always @(*) 
//if (mult_busy_i) begin
//    mult_start <= 1'b0;
//end

always @(posedge clk) begin
    if (rst) begin
        out <= 0;
        state <= IDLE;
    end else begin
    case(state)
        IDLE:
        begin
            if (start_i) begin
                if (power_i > 1) begin
                    power <= power_i;
                    actual_power <= 3'h2;
                    base <= base_i;
                    actual_result <= base_i;
                end else begin
                    base <= 8'h1;
                    actual_result <= base_i;
                    actual_power <= 3'b1;
                    power <= 3'b1;
                end
                mult_start <= 1'b1;
                state <= MULT_START;
            end
        end
        MULT_START:
        begin
            if (mult_busy_i) begin
                mult_start <= 1'b0;
                state <= WORK;
            end
        end
        WORK:
        begin
            if (~mult_busy_i && ~mult_start) begin
                actual_result = mult_result_i;
                if (actual_power < power) begin
                    mult_start <= 1'b1;
                    actual_power <= new_power;
                    state <= MULT_START;
                end else begin
                    state <= IDLE;
                    out <= actual_result;
                end
            end
        end
    endcase
    end
end

endmodule
