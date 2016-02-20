module CreateLargePulse (
	output large_pulse,
	input small_pulse,
	input rst,
	input clk
	);
	parameter PULSE_SIZE = 25;
	clock_divisor(clk, clk13, clk16, clk22, clk25);
	OnePulse op(large_pulse, small_pulse, clk16);
endmodule

module debounce(	output pb_debounced,
					input pb,
					input clk			
				);
	reg [3:0] shift_reg;
	
	always@(posedge clk)
	begin
		shift_reg[3:1] <= shift_reg[2:0];
		shift_reg[0] <= pb;
	end
	
	assign pb_debounced = (shift_reg == 4'b1111) ? 1'b1 : 1'b0;
endmodule

module Final(
			input clk, 
			input reset, 
			input pause,
			input [1:0] mode,
			inout wire PS2_CLK,
			inout wire PS2_DATA,
			output reg [3:0] DIGIT,
			output wire [6:0] DISPLAY,
			output [3:0] vgaRed,
			output [3:0] vgaGreen,
			output [3:0] vgaBlue,
			output hsync,
			output vsync,
			//output pmod_1,
			//output pmod_2,
			//output pmod_4,
			output [7:0] leftLED,
			output [7:0] rightLED
									);
	wire [2:0] state;
	wire [5:0] countdown;
	wire clk13, clk16,clk20, clk22, clk25,clk_25MHz, clk18;
	wire A_lgd, S_lgd, space_lgd;
    wire A, S, space;
    wire pause_db, rst_db, pause_op, rst_op;
    wire [3:0] STAGE0, STAGE1;
    reg [3:0] value;
    wire [3:0] tmp;
	
    wire valid;
    wire [9:0] h_cnt; //640
    wire [9:0] v_cnt;  //480
	wire [2:0] choose_pic;
	wire wait_for_ball_move_left, wait_for_ball_move_right, warning, ret, tmp2;

	clock_divisor clk_div(
      .clk(clk),
      .clk13(clk13),
	  .clk16(clk16),
	  .clk18(clk18),
	  .clk20(clk20),
      .clk22(clk22),
	  .clk25(clk25),
	  .clk1(clk_25MHz)
    );
	
	
	 pixel_gen pixel_gen_inst(
	   .choose_pic(choose_pic),
	   .wait_for_ball_move_left(wait_for_ball_move_left),
	   .wait_for_ball_move_right(wait_for_ball_move_right),
	   .clk3(clk22),
	   .clk(clk20),
	   .clk2(clk18),
	   .reset(reset),
       .h_cnt(h_cnt),
	   .v_cnt(v_cnt),
       .valid(valid),
       .vgaRed(vgaRed),
       .vgaGreen(vgaGreen),
       .vgaBlue(vgaBlue),
       .warning(warning),
	   .mode(mode),
	   .ret(ret),
	   .friend_left(tmp2)
    );

    vga_controller   vga_inst(
      .pclk(clk_25MHz),
      .reset(reset),
      .hsync(hsync),
      .vsync(vsync),
      .valid(valid),
      .h_cnt(h_cnt),
      .v_cnt(v_cnt)
    );
	
	
	ButtonCtrl b_ctrl (
		.A(A),
		.S(S),
		.space(space),
		.PS2_DATA(PS2_DATA),
		.PS2_CLK(PS2_CLK),
		.rst(reset),
		.clk(clk)
	);
	
	CreateLargePulse #(
		.PULSE_SIZE(25)
	) c_pulse_A (
		.large_pulse(A_lgd),
		.small_pulse(A),
		.rst(reset),
		.clk(clk)
	);
	
	CreateLargePulse #(
		.PULSE_SIZE(25)
	) c_pulse_S (
		.large_pulse(S_lgd),
		.small_pulse(S),
		.rst(reset),
		.clk(clk)
	);

	CreateLargePulse #(
		.PULSE_SIZE(25)
	) c_pulse_space (
		.large_pulse(space_lgd),
		.small_pulse(space),
		.rst(reset),
		.clk(clk)
	);

	
	OnePulse op(pause_op, clk16, en_db);
	debounce db(pause_db, pause, clk16);
	OnePulse op2(rst_op, clk16, rst_db);
	debounce db2(rst_db, reset, clk16);
	
	assign easy = (mode == 2'b01) ? 1 : 0;
	assign middle = (mode == 2'b10) ? 1 : 0;
	assign hard = (mode == 2'b11) ? 1 : 0;
	//wire choose_pic;
	Game_FSM g(
		.easy(easy),
		.middle(middle),
		.hard(hard),
		.start(space_lgd),
		.left(A_lgd),
		.right(S_lgd),
		.clk16(clk16),
		.clk25(clk25),
	//input pause,
		.reset(reset),
	//output reg [1:0] .stage(stage),
		.countdown(countdown),
		//.timer0(TIMER0),
		//.timer1(TIMER1),
	//output reg [3:0] choose_music,
		.choose_pic(choose_pic),
		.state(state),
		.left_side_LED(leftLED),
		.right_side_LED(rightLED),
		.people(tmp),
		.wait_for_ball_move_left(wait_for_ball_move_left),
		.wait_for_ball_move_right(wait_for_ball_move_right),
		.warning(warning),
		.ret(ret),
		.tmp(tmp2)
		);
	
	
	/*Lab9 screen(.clk22(clk22),
	            .clk25(clk25),
				.rst(reset),
				.vgaRed(vgaRed),
				.vgaGreen(vgaGreen),
				.vgaBlue(vgaBlue),
				.en(pause), //might need modification 
				.hsync(hsync),
				.vsync(vsync),
				.choose_pic(choose_pic)
				);*/
				
	
	assign STAGE0 = (mode == 2'b00) ? 0 : (mode == 2'b01) ? 1 : (mode == 2'b10) ? 2 : 3;
	assign STAGE1 = 0;
	always@(negedge clk13)
        begin
            case(DIGIT)
                4'b1110:
                begin
                    value <= countdown / 10;
                    DIGIT <= 4'b0111;
                end
                4'b0111:
                begin
                    value <= countdown % 10;
                    DIGIT <= 4'b1011;
                end
				4'b1011: 
				begin
					value <= tmp;//STAGE1;
					DIGIT <= 4'b1101;
				end
    			4'b1101:
				begin
					value <= STAGE0;
					DIGIT <= 4'b1110;
				end
                default
                begin
                    DIGIT <= 4'b1110;
                end
            endcase
        end
        
        assign DISPLAY = (value == 0) ? 7'b1000000:
                         (value == 1) ? 7'b1111001:
                         (value == 2) ? 7'b0100100:
                         (value == 3) ? 7'b0110000:
                         (value == 4) ? 7'b0011001:
                         (value == 5) ? 7'b0010010:
                         (value == 6) ? 7'b0000010:
                         (value == 7) ? 7'b1111000:
                         (value == 8) ? 7'b0000000:
                         (value == 9) ? 7'b0010000:
                                        7'b1111111;
										
		/*Lab8 audio(
			.clk(clk),
			.PP(pause), // might need modification
			.pmod_1(pmod_1),
			.pmod_2(pmod_2),
			.pmod_4(pmod_4)
							);
*/
endmodule
	