module lfsr (out, clk, rst);
  output reg [3:0] out;

  input clk, rst;

  wire feedback;
 
  assign feedback = ~(out[3] ^ out[2]);

  always @(posedge clk, posedge rst)
  begin
    if (rst)
      out = 4'b0;
    else
      out = {feedback,out[3:1]};
  end
endmodule
