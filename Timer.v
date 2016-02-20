module Timer(clk, rst, load, in, done);
  parameter n=4;
  input clk, rst, load;
  input [n-1:0] in;
  output done;
  reg [n-1:0] count, next_count;
  wire done;

  always @(posedge clk) begin
    if(rst) count = 0;
    else count = next_count;
  end
  always @(*) begin
    next_count = count-1'b1;
    if(load)
      next_count=in;
    else if(done==1)
      next_count=0;
  end
  assign done = (count==0) ? 1 :0;
endmodule
      
