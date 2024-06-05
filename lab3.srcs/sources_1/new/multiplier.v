`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.04.2024 12:52:55
// Design Name: 
// Module Name: multiplier
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


module multiplier(
    input clk,
    input rst,
    
    input wire[15:0] a_i,
    input wire[15:0] b_i,
    input wire start_i,
    
    output busy,
    output reg[31:0] out
);

localparam IDLE = 1'b0;
localparam WORK = 1'b1;

reg[3:0] ctr;
reg state = 1'b0;
reg[31:0] actual_result;
reg [15:0] a;
reg[15:0] b;

wire[15:0] part_sum;
wire[31:0] shifted_part_sum;

assign part_sum = a & {16{b[ctr]}};
assign shifted_part_sum = part_sum << ctr;
assign busy = state;

always @(posedge clk) begin
    if (rst) begin
        out <= 0;
        state <= IDLE;
    end
    else begin
        case (state)
            IDLE:
            if (start_i) begin
                state <= WORK;
                a <= a_i;
                b <= b_i;
                ctr <= 0;
                actual_result <= 0;
            end
            WORK:
            begin
                actual_result = actual_result + shifted_part_sum;
                ctr <= ctr + 1;
                if (ctr == 15) begin
                    state <= IDLE;
                    out <= actual_result;
                end
            end
        endcase
    end
end

endmodule
