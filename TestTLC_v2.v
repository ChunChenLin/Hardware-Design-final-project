module TestTLC;
  reg car_ew, car_lt, car_ns, clk, rst;
  wire [8:0] lights;
  wire ok;
  wire [1:0] dir;
  TLC_Master m(clk, rst, car_ew, car_lt, car_ns, ok, dir);
  TLC_Comdiner c(clk, rst, dir, ok, lights);
  initial begin
    #5 rst=1; car_ew=0; car_lt=0; car_ns=0;
    #10 rst=0;
    #20 car_ew=1;
    #100 car_ns=1;
    #200 car_ew=0;
    #200 car_ns=0;
    #200 car_lt=1;
    #400
    $finish;
  end
  initial
    forever begin
      #5 clk=0;
      $display("%b %b %b %b", car_ew, car_lt, car_ns, lights);
      #5 clk=1;
    end
endmodule
