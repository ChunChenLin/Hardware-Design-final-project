`define LWIDTH 2
`define L_RED 2'b00
`define L_GREEN 2'b01
`define L_YELLOW 2'b10
`define TWIDTH 4
`define T_EXP 4'd12
`define LTWIDTH 4
`define T_RED 4'd3
`define T_YELLOW 4'd4
`define T_GREEN 4'd8
`define RED 3'b100
`define YELLOW 3'b010
`define GREEN 3'b001
module TLC_Light(clk, rst, on, done, light);
  input clk, rst, on;
  output done;
  output [2:0] light;
  reg [2:0] light;
  reg done;
  reg [`LWIDTH-1:0] state, next;
  reg [`LWIDTH-1:0] next1;
  reg tload;
  reg [`TWIDTH-1:0] tin;
  wire tdone;

  //DFF #(`LWIDTH) state_reg(clk, next, state);
  always @(posedge clk) begin
    if(rst)
	   state=`L_RED;
    else 
	  state=next;
  end
  Timer timer(clk, rst, tload, tin, tdone);

  always @(*) begin
    case(state)
      `L_RED: begin
		  tload=(tdone & on);
	      tin=`T_GREEN;
	      light=`RED;
	      done=~tdone;
	      if(tdone & on)
		    next1=`L_GREEN;
	      else
		    next1=`L_RED; end
      `L_GREEN: begin
		    tload=tdone & ~on;
	        tin=`T_YELLOW;
	        light=`GREEN;
	        done=tdone;
	        if(tdone & ~on)
		      next1=`L_YELLOW;
	        else
		      next1=`L_GREEN; end
      `L_YELLOW: begin
             tload=tdone;
	      	 tin=`T_RED;
	      	 light=`YELLOW;
	      	 done=1'b1;
	      	 if(tdone)
		       next1=`L_RED;
	      	 else
		       next1=`L_YELLOW; end
      default: begin
	         tload=tdone;
	         tin=`T_RED;
	         light=`YELLOW;
	         done=1'b1;
	         if(tdone)
	           next1=`L_RED;
	         else
		       next1=`L_YELLOW; end
     endcase
     next=next1;
  end
endmodule
