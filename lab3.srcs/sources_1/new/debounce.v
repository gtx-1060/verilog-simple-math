`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.06.2024 09:04:27
// Design Name: 
// Module Name: debounce
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


module debounce(
    input clk_i,
    input btn_i,
    output reg sig_o = 1'b0
);

localparam K = 32'd100000;

reg tr1 = 1'b0, tr2 = 1'b0;
integer counter = 32'b0;

always @(posedge clk_i) begin
    tr1 <= btn_i;
    tr2 <= tr1;
    
    if (tr2 != sig_o) begin
        counter <= counter + 1;
         if (counter == K) begin
            sig_o <= ~sig_o;
         end
    end else begin
        counter <= 32'b0;
    end
end

endmodule
