`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2024 15:12:24
// Design Name: 
// Module Name: bin_to_bcd_seq
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
// https://www.realdigital.org/doc/6dae6583570fd816d1d675b93578203d 
//////////////////////////////////////////////////////////////////////////////////


module bin_to_bcd_seq(
   input clk,
   input start_i,
   input wire[26:0] bin_i,
   output reg[31:0] out = 32'b0,
   output busy
);

localparam IDLE = 1'b0;
localparam WORK = 1'b1;

reg state = IDLE;
reg[4:0] counter;
reg[26:0] bin;
reg[31:0] bcd;
assign busy = state;

always @(posedge clk) begin
    case (state)
    IDLE:
    begin
        if (start_i) begin
            bcd <= 32'b0;
            bin <= bin_i;
            counter <= 4'b0;
            state <= WORK;
        end
    end
    WORK:
    begin
        if (counter == 27) begin
            state <= IDLE;
            out <= bcd;
        end else begin
            if (bcd[3:0] >= 5)
                bcd[3:0] = bcd[3:0] + 3;        //If any BCD digit is >= 5, add 3
            if (bcd[7:4] >= 5)
                bcd[7:4] = bcd[7:4] + 3;
            if (bcd[11:8] >= 5)
                bcd[11:8] = bcd[11:8] + 3;
            if (bcd[15:12] >= 5)
                bcd[15:12] = bcd[15:12] + 3;
            if (bcd[19:16] >= 5)
                bcd[19:16] = bcd[19:16] + 3;
            if (bcd[23:20] >= 5)
                bcd[23:20] = bcd[23:20] + 3;
            if (bcd[27:24] >= 5)
                bcd[27:24] = bcd[27:24] + 3;
            if (bcd[31:28] >= 5)
                bcd[31:28] = bcd[31:28] + 3;
            bcd <= {bcd[30:0], bin[26-counter]};    
            counter <= counter + 1;
        end 
    end
    endcase	 	
end
endmodule
