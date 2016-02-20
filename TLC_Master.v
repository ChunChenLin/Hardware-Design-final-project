`define MWIDTH 2
`define M_NS 2'b00
`define M_EW 2'b01
`define M_LT 2'b10
`define TWIDTH 4
`define T_EXP 4'd12
module TLC_Master(clk, rst, car_ew, car_lt, ok, dir);
  input clk, rst , car_ew, car_lt, ok;
  output [1:0] dir;
  reg [`MWIDTH-1:0] state, next;
  reg [`MWIDTH-1:0] next1;
  reg tload;
  reg [1:0] dir;
  wire tdone;

 //DFF #(`MWIDTH) state_reg(clk, rst,  next, state);
  always @(posedge clk) begin
    if(rst==1) state=`M_NS;
    else state=next;
  end
  Timer #(`TWIDTH) timer(clk, rst, tload, `T_EXP, tdone);

  always @(*) begin
    case(state)
      `M_NS:begin 
		    dir=`M_NS;
      		tload=1'b1;
     		if(ok) begin
	   		  if(car_lt) begin
	     	    next1=`M_LT;
			  end else begin
    	  	    if(car_ew)
				  next1=`M_EW;
		 		else
      			  next1=`M_NS;
			  end
	  	    end else
			next1=`M_NS; end
	  `M_EW:begin 
	 	    dir=`M_EW;
	  	 	tload=1'b0;
	  		if(ok & (!car_ew | tdone))
		      next1=`M_NS;
	 	    else
   			  next1=`M_EW; end
      `M_LT:begin 
			dir=`M_LT;
			tload=1'b0;
		    if(ok & (!car_lt | tdone))
			  next1=`M_NS;
			else
			  next1=`M_LT; end
	  default: {dir, tload, next1} = {`M_LT, 1'b0, `M_NS};
	endcase
  next = next1;
  end
endmodule	
