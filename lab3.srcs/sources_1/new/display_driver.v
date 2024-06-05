module display_driver(
    input clk,
    input [31:0] data_i,
    output reg [6:0] seg_o,
    output reg [7:0] seg_disabled_o
);

wire div_clk;
clk_divider m_clk_divider(
    clk,
    div_clk
);

reg [2:0] current_seg = 3'b0;
always @(posedge div_clk)
begin
    current_seg <= current_seg + 1'b1;
end



reg [3:0] digit;
always @(posedge clk)
begin
    case (current_seg)
        0: digit <= data_i[3:0];
        1: digit <= data_i[7:4];
        2: digit <= data_i[11:8];
        3: digit <= data_i[15:12];
        4: digit <= data_i[19:16];
        5: digit <= data_i[23:20];
        6: digit <= data_i[27:24];
        7: digit <= data_i[31:28];
    endcase
end



always @(*)
begin
    seg_disabled_o = 8'hFF;
    seg_disabled_o[current_seg] = 1'b0;
end



always @(*)
begin
    case (digit)
        0:       seg_o = 7'b1000000;
        1:       seg_o = 7'b1111001;
        2:       seg_o = 7'b0100100;
        3:       seg_o = 7'b0110000;
        4:       seg_o = 7'b0011001;    
        5:       seg_o = 7'b0010010;
        6:       seg_o = 7'b0000010;
        7:       seg_o = 7'b1111000;
        8:       seg_o = 7'b0000000;
        9:       seg_o = 7'b0010000;
        default: seg_o = 7'b1111111;
    endcase
end

endmodule
