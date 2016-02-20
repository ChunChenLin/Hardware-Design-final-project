module TLC_Comdiner(clk, rst, dir, ok, lights);
  input clk, rst;
  input [1:0] dir;
  output ok;
  output [8:0] lights;
  wire done, on;
  wire [2:0] light;
  reg [8:0] lights;
  reg [1:0] cur_dir, next_dir;

  //DFF #(2) dir_reg(clk, next_dir, cur_dir);
  always @(posedge clk) begin
    if(rst==1) cur_dir=2'b0;
    else cur_dir=next_dir;
  end
  TLC_Light lt(clk, rst, on, done, light);
  assign on = (cur_dir == dir);
  assign ok = on & done;
  always @(*) begin 
	if(~on & ~done)
      next_dir=dir;
    else
	  next_dir=cur_dir;
  end
  always @(*) begin
    case(cur_dir)
      `M_NS: lights = {light, `RED, `RED};
      `M_EW: lights = {`RED, light, `RED};
      `M_LT: lights = {`RED, `RED, light};
      default: lights = {`RED, `RED, `RED};
    endcase
  end
endmodule
