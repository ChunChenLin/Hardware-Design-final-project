module DFF(clk, rst, next, state)
  parameter n=2;
  input clk, rst, next;
  output reg [n-1:0] state;
  always @(*) begin
    if(rst==1) state=`M_NS;
	else state=next;
  end
endmodule
