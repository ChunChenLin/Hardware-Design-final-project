module ButtonCtrl(
	output reg A,
	output reg S,
	output reg space,
	inout wire PS2_DATA,
	inout wire PS2_CLK,
	input wire rst,
	input wire clk
	);
	
	parameter [8:0] LEFT_SHIFT_CODES  = 9'b0_0001_0010;
	parameter [8:0] RIGHT_SHIFT_CODES = 9'b0_0101_1001;
	parameter [8:0] KEY_CODES [0:19] = {
		9'b0_0100_0101,	// 0 => 45
		9'b0_0001_0110,	// 1 => 16
		//9'b0_0001_1110,	// 2 => 1E
		//9'b0_0010_0110,	// 3 => 26
		9'b0_0010_0001, // c => 21
		9'b0_0010_1100, // t => 2c
		//9'b0_0010_0101,	// 4 => 25
		9'b0_0111_0110, // esc => 76
		9'b0_0010_1110,	// 5 => 2E
		9'b0_0011_0110,	// 6 => 36
		9'b0_0011_1101,	// 7 => 3D
		9'b0_0011_1110,	// 8 => 3E
		//9'b0_0100_0110,	// 9 => 46
		9'b0_0010_1001, // space => 29
		
		9'b0_0111_0000, // right_0 => 70
		9'b0_0110_1001, // right_1 => 69
		9'b0_0111_0010, // right_2 => 72
		9'b0_0111_1010, // right_3 => 7A
		9'b0_0110_1011, // right_4 => 6B
		9'b0_0111_0011, // right_5 => 73
		9'b0_0111_0100, // right_6 => 74
		9'b0_0110_1100, // right_7 => 6C
		//9'b0_0111_0101, // right_8 => 75
		//9'b0_0111_1101  // right_9 => 7D
		9'b0_0001_1100, // A => 1C
		9'b0_0001_1011 // S => 1B
	};
	
	wire shift_down, clk_16;
	wire [511:0] key_down;
	wire [8:0] last_change;
	wire been_ready;
	
	assign shift_down = (key_down[LEFT_SHIFT_CODES] == 1'b1 || key_down[RIGHT_SHIFT_CODES] == 1'b1) ? 1'b1 : 1'b0;
		
	KeyboardDecoder key_de (
		.key_down(key_down),
		.last_change(last_change),
		.key_valid(been_ready),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(rst),
		.clk(clk)
	);

	always @ (posedge clk, posedge rst) begin
		if (rst) begin
			A <= 0;
			S <= 0;
			space <= 0;
		end else begin
			/*A <= 0;
			S <= 0;
			space <= 0;*/
			if (been_ready && key_down[last_change] == 1'b1) begin
				if(last_change == 9'b0_0001_1100)
					A <= 1;
				else if(last_change == 9'b0_0001_1011)
					S <= 1;
				else if(last_change == 9'b0_0010_1001)
					space <= 1;
			end
            else if (been_ready && key_down[last_change] == 1'b0) begin
                            if(last_change == 9'b0_0001_1100)
                                A <= 0;
                            else if(last_change == 9'b0_0001_1011)
                                S <= 0;
                            else if(last_change == 9'b0_0010_1001)
                                space <= 0;
            end
		end
	end
endmodule
