module clock_divisor(clk, clk13, clk16, clk20, clk18, clk22, clk25,clk1);
input clk;
output clk13, clk16,clk20, clk22, clk25, clk1, clk18;

reg [24:0] num;
wire [24:0] next_num;

always @(posedge clk) begin
  num <= next_num;
end

assign next_num = num + 1'b1;
assign clk13 = num[12];
assign clk16 = num[15];
assign clk22 = num[21];
assign clk18 = num[17];
assign clk20 = num[19];
assign clk25 = num[24];
assign clk1 = num[1];
endmodule
