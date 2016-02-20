module Game_FSM(
	input easy,
	input middle,
	input hard,
	input start,
	
	input left,
	input right,
	input clk16,
	input clk25,
	input reset,
	output reg [3:0] state,
	output reg [5:0] countdown,
	output reg [3:0] choose_pic,
	output reg [7:0] left_side_LED,
	output reg [7:0] right_side_LED,
	output reg [3:0] people,
	output reg wait_for_ball_move_left,
	output reg wait_for_ball_move_right,
	output warning,
	output reg ret,
	output reg tmp
);
	reg [5:0] next_countdown;
	//reg [2:0] state;
	reg [3:0] next_state;
	parameter _initial = 4'b0000;
	parameter _start = 4'b0001;
	parameter _over = 4'b0010;
	parameter _pause = 4'b0011;
	parameter _win = 4'b0100;
	parameter _shoot = 4'b0101;
	parameter _over_after_kick_left = 4'b0110;
	parameter _start_after_kick_left = 4'b0111;
	parameter _shoot_over_after_kick_left = 4'b1000;
	parameter _shoot_win_after_kick_left = 4'b1001;
	parameter _over_after_kick_right = 4'b1010;
	parameter _start_after_kick_right = 4'b1011;
	parameter _shoot_over_after_kick_right = 4'b1100;
	parameter _shoot_win_after_kick_right = 4'b1101;
	
	//reg tmp;
	wire [3:0] where_is_friend;
	//wire [3:0] random;
	reg [3:0] next_people;
	
	reg [20:0] counter;
	reg [20:0] next_counter;
	reg [3:0] next_choose_pic;
	
	parameter menu = 3'b000;
	parameter game_win = 3'b001;
	parameter game_over = 3'b010;
	parameter enemy_left = 3'b011;
	parameter enemy_right = 3'b100;
	parameter shoot_enemy_left = 3'b101;
	parameter shoot_enemy_right = 3'b110;
	parameter pause = 3'b111;
	
	assign warning = (countdown <= 7 && (state == _shoot || state == _shoot_over_after_kick_right || state == _shoot_over_after_kick_left || state == _shoot_win_after_kick_right || state == _shoot_win_after_kick_left || state == _shoot || (state == _over && countdown == 1) || state == _start || state == _over_after_kick_left || state == _over_after_kick_right || state == _shoot_over_after_kick_left || state == _shoot_over_after_kick_right || state == _shoot_win_after_kick_left  || state == _shoot_win_after_kick_right || state == _start_after_kick_left || state == _start_after_kick_right)) ? 1 : 0;
	
	lfsr r(where_is_friend, clk16, reset);
	
	always @ (posedge clk16 or posedge reset)
	begin
		if(reset)
			tmp = where_is_friend % 2;
		else if(start && state == _initial)
			tmp = where_is_friend % 2;
		else if(left && state == _start)
			tmp = where_is_friend % 2;
		else if(right && state == _start)
			tmp = where_is_friend % 2; 
	end
	
	always@(negedge clk25 or posedge reset) begin
		if(reset) begin
			//state <= _initial;
			countdown <= 0;
		end else begin
			//state <= next_state;
			if((state == _shoot || state == _shoot_over_after_kick_right || state == _shoot_over_after_kick_left || state == _shoot_win_after_kick_right || state == _shoot_win_after_kick_left || state == _start || state == _over_after_kick_left || state == _over_after_kick_right || state == _shoot_over_after_kick_left || state == _shoot_over_after_kick_right || state == _shoot_win_after_kick_left  || state == _shoot_win_after_kick_right || state == _start_after_kick_left || state == _start_after_kick_right) && next_countdown > 0) countdown <= next_countdown - 1;
			else countdown <= next_countdown;
		end
	end
	
	always@(posedge clk16 or posedge reset)
	begin
	   if(reset) begin
	       state <= _initial;
		   counter <= 0; //reset counter
	       people <= 0;
	   end else begin
	       state <= next_state;
		   counter <= next_counter; //update counter
	       people <= next_people;
	   end
	end
	
	always@(*) begin
		case(state)
			_initial: begin
				ret = 0;
				left_side_LED = 8'b00000000; right_side_LED = 8'b00000000;
				wait_for_ball_move_left = 0;
				wait_for_ball_move_right = 0;
			    next_people = 0;
				left_side_LED = 0;
				right_side_LED = 0;
				if(easy) begin
					next_countdown <= 6'd30;
					if(start) next_state <= _start;
					else next_state <= _initial;
				end
				else if(middle) begin
					next_countdown <= 6'd20;
					if(start) next_state <= _start;
                    else next_state <= _initial;
				end
				else if(hard) begin
					next_countdown <= 6'd15;
					if(start) next_state <= _start;
                    else next_state <= _initial;
				end else begin
				    next_countdown <= 0;
				    next_state <= _initial;
				end
			end
			
			_start: begin
				ret = 0;
				left_side_LED = 8'b00000000; right_side_LED = 8'b00000000;
				if(countdown <= 1) begin
					next_state <= _over;
					next_countdown <= 0;
					next_people <= people;
					wait_for_ball_move_left = 0;
					wait_for_ball_move_right = 0;
				end
				else begin
					/*if(left) begin left_side_LED = 8'b11111111; right_side_LED = 0; end
					else if(right) begin right_side_LED = 8'b11111111; left_side_LED = 0; end
					else begin left_side_LED = 0; right_side_LED = 0; end*/
					next_countdown <= countdown;
					next_people <= people;
					wait_for_ball_move_left = 0;
					wait_for_ball_move_right = 0;
					if(start) next_state <= _pause;
					else if(people >= 5) next_state <= _shoot;
					else if((tmp == 1 && left)) begin 
						wait_for_ball_move_left = 1;
						next_state <= _start_after_kick_left; //translate to vga generation 
						next_counter <= 0; 
					end
					else if((tmp == 0 && right)) begin
					    wait_for_ball_move_right = 1;
                        next_state <= _start_after_kick_right; //translate to vga generation 
                        next_counter <= 0; 
					end
					else if((tmp == 0 && left)) begin
						wait_for_ball_move_left = 1;
						next_state <= _over_after_kick_left; //translate to vga generation
						next_counter <= 0;						
					end
					else if((tmp == 1 && right)) begin
					    wait_for_ball_move_right = 1;
                        next_state <= _over_after_kick_right; //translate to vga generation
                        next_counter <= 0;        
					end
					else next_state <= _start;
				end
			end
			
			_start_after_kick_left: begin //let vga generate animation and delay
				left_side_LED = 8'b11111111; right_side_LED = 8'b00000000;
				wait_for_ball_move_left <= 1;
				wait_for_ball_move_right <= 0;
				next_countdown <= countdown;
				next_counter <= counter+1;
				if (counter >= 800) begin next_state <= _start; next_people <= people + 1; ret = 0; end//translate to outcome , win or lose
				else if(counter >= 400) begin next_state <= _start_after_kick_left; next_people <= people; ret = 1;end
				else begin next_state <= _start_after_kick_left; next_people <= people; ret = 0; end
			end
			
			_start_after_kick_right: begin //let vga generate animation and delay
                            right_side_LED = 8'b11111111; left_side_LED = 8'b00000000;
							wait_for_ball_move_right <= 1;
                            wait_for_ball_move_left <= 0;
                            next_counter <= counter+1;
                            next_countdown <= countdown;
                            if (counter >= 800) begin next_state <= _start; next_people <= people + 1; ret = 0; end//translate to outcome , win or lose
                            else if(counter >= 400) begin next_state <= _start_after_kick_right; next_people <= people; ret = 1; end
							else begin next_state <= _start_after_kick_right; next_people <= people; ret = 0; end
                        end
			
 			_over_after_kick_left: begin //let vga generate animation and delay
				left_side_LED = 8'b11111111; right_side_LED = 8'b00000000;
				wait_for_ball_move_left <= 1;
				wait_for_ball_move_right <= 0;
				next_counter <= counter+1;
				next_people <= people;
				next_countdown <= countdown;
				if (counter >= 800) begin next_state <= _over; ret = 0; end//translate to outcome , win or lose
				else if(counter >= 400) begin next_state <= _over_after_kick_left; ret = 1; end
				else begin next_state <= _over_after_kick_left; ret = 0; end
			end
			
			_over_after_kick_right: begin //let vga generate animation and delay
                            right_side_LED = 8'b11111111; left_side_LED = 8'b00000000;
							wait_for_ball_move_right <= 1;
                            wait_for_ball_move_left <= 0;
                            next_counter <= counter+1;
                            next_people <= people;
                            next_countdown <= countdown;
                            if (counter >= 800) begin next_state <= _over; ret = 0; end//translate to outcome , win or lose
                            else if(counter >= 400) begin next_state <= _over_after_kick_right; ret = 1; end
							else begin next_state <= _over_after_kick_right; ret = 0; end
                        end
				
			
			_shoot: begin
					ret = 0;
			     /*if(left) begin left_side_LED = 8'b11111111; right_side_LED = 0; end
                                else if(right) begin right_side_LED = 8'b11111111; left_side_LED = 0; end
                                else begin left_side_LED = 0; right_side_LED = 0; end*/
								left_side_LED = 8'b00000000; right_side_LED = 8'b00000000;
                                //next_countdown <= countdown;
								wait_for_ball_move_left = 0;
								wait_for_ball_move_right = 0;
				if(countdown <= 1) begin
                                                    next_state <= _over;
                                                    next_countdown <= 0;
                                                    next_people <= people;
                                                    /*wait_for_ball_move_left = 0;
                                                    wait_for_ball_move_right = 0;*/
                                                end
				else begin
				    next_countdown <= countdown;
			     if((tmp == 1 && left)) begin 
						wait_for_ball_move_left = 1; 
						wait_for_ball_move_right = 0; 
						next_state <= _shoot_win_after_kick_left; 
						next_people <= people + 1; 
						next_counter <= 0;
				 end
			     else if((tmp == 0 && right)) begin 
				         wait_for_ball_move_right = 1; 
				         wait_for_ball_move_left = 0; 
				         next_state <= _shoot_win_after_kick_right; 
				         next_people <= people + 1; 
				 end
			     else if((tmp == 0 && left)) begin 
					wait_for_ball_move_left = 1; 
					wait_for_ball_move_right = 0; 
					next_state <= _shoot_over_after_kick_left; 
					next_people <= people; 
					next_counter <= 0;
				 end
			     else if((tmp == 1 && right)) begin 
					wait_for_ball_move_right = 1; 
					wait_for_ball_move_left = 0; 
					next_state <= _shoot_over_after_kick_right; 
					next_people <= people; 
					next_counter <= 0;
				 end
			     else begin 
					next_state <= _shoot; 
					next_people <= people; 
					next_counter <= 0;
				 end
				 end
			end
			
			_shoot_win_after_kick_left: begin //let vga generate animation and delay
				left_side_LED = 8'b11111111; right_side_LED = 8'b00000000;
				wait_for_ball_move_left = 1;
				wait_for_ball_move_right = 0;
				next_counter <= counter+1;
				next_people <= people;
				next_countdown <= countdown;
				if (counter >= 800) next_state <= _win; //translate to outcome , win or lose
				else next_state <= _shoot_win_after_kick_left;
				ret = 0;
			end
			
			_shoot_win_after_kick_right: begin //let vga generate animation and delay
                            right_side_LED = 8'b11111111; left_side_LED = 8'b00000000;
							wait_for_ball_move_left = 0;
                            wait_for_ball_move_right = 1;
                            next_counter <= counter+1;
                            next_people <= people;
                            next_countdown <= countdown;
                            if (counter >= 800) next_state <= _win; //translate to outcome , win or lose
                            else next_state <= _shoot_win_after_kick_right;
                        end
			
 			_shoot_over_after_kick_left: begin //let vga generate animation and delay
				left_side_LED = 8'b11111111; right_side_LED = 8'b00000000;
				wait_for_ball_move_left = 1;
				 wait_for_ball_move_right = 0;
				next_counter <= counter+1;
				next_people <= people;
				next_countdown <= countdown;
				if (counter >= 800) next_state <= _over; //translate to outcome , win or lose
				else next_state <= _shoot_over_after_kick_left;
				ret= 0;
			end
			
			_shoot_over_after_kick_right: begin //let vga generate animation and delay
                            right_side_LED = 8'b11111111; left_side_LED = 8'b00000000;
							wait_for_ball_move_left = 0;
                             wait_for_ball_move_right = 1;
                            next_counter <= counter+1;
                            next_people <= people;
                            next_countdown <= countdown;
                            if (counter >= 800) next_state <= _over; //translate to outcome , win or lose
                            else next_state <= _shoot_over_after_kick_right;
							ret = 0;
						end
			
			_win: begin
				ret = 0;
				left_side_LED = 8'b00000000; right_side_LED = 8'b00000000;
				wait_for_ball_move_right = 0;
				wait_for_ball_move_left = 0;
			     left_side_LED = 0;
                            right_side_LED = 0;
                            next_people = people;
                            if(start) begin
                                next_state <= _initial;
                                next_countdown <= 0;
                            end
                            else begin
                                next_state <= _win;
                                next_countdown <= countdown;
                            end
			end
			
			_pause: begin
				ret = 0;
				left_side_LED = 8'b00000000; right_side_LED = 8'b00000000;
				wait_for_ball_move_left = 0;
				wait_for_ball_move_right = 0;
			     left_side_LED = 0;
                 right_side_LED = 0;
			     next_countdown <= countdown;
			     next_people <= people;
			     if(start) next_state <= _start;
			     else next_state <= _pause;
			end
			
			_over: begin
			ret = 0;
				left_side_LED = 8'b00000000; right_side_LED = 8'b00000000;
				wait_for_ball_move_left = 0;
				wait_for_ball_move_right = 0;
				left_side_LED = 0;
				right_side_LED = 0;
				next_people = 0;
				if(start) begin
					next_state <= _initial;
					next_countdown <= 0;
				end
				else begin
					next_state <= _over;
					next_countdown <= 0;
				end
			end
			
			default: begin
				left_side_LED = 8'b00000000; right_side_LED = 8'b00000000;
				wait_for_ball_move_left = 0;
				wait_for_ball_move_right = 0;
			    left_side_LED = 0;
                right_side_LED = 0;
			    next_state <= _initial;
			    next_countdown <= 0;
			    next_people = 0;
				ret = 0;
			end
		endcase
	end
	
	always@(posedge clk16 or posedge reset)
	begin
		if(reset) choose_pic <= menu;
		else if(state == _win) choose_pic <= game_win;
		else if(state == _over && countdown <= 0) choose_pic <= game_over;
		else if(state == _pause) choose_pic <= pause;
		else if(state == _start && tmp == 1) choose_pic <= enemy_right;
		else if(state == _start && tmp == 0) choose_pic <= enemy_left;
		/*else if(state == _start_after_kick && tmp == 1 && !wait_for_ball_move) choose_pic <= enemy_right;
		else if(state == _start_after_kick && tmp == 0 && !wait_for_ball_move) choose_pic <= enemy_left;
		else if(state == _over_after_kick && tmp == 1 && !wait_for_ball_move) choose_pic <= enemy_right;
		else if(state == _over_after_kick && tmp == 0 && !wait_for_ball_move) choose_pic <= enemy_left;
		else if(state == _shoot_win_after_kick && tmp == 1) choose_pic <= enemy_right;
		else if(state == _shoot_win_after_kick && tmp == 0) choose_pic <= enemy_left;
		else if(state == _shoot_over_after_kick && tmp == 1) choose_pic <= enemy_right;
		else if(state == _shoot_over_after_kick && tmp == 0) choose_pic <= enemy_left;*/
		//else if(state == _start) choose_pic <= grass;
		else if(state == _shoot && tmp == 1) choose_pic <= shoot_enemy_right;
		else if(state == _shoot && tmp == 0) choose_pic <= shoot_enemy_left;
		else if(((state == _start_after_kick_left || state == _start_after_kick_right) || (state == _over_after_kick_left || state == _over_after_kick_right) || state == _shoot_win_after_kick_left || state == _shoot_win_after_kick_right || state == _shoot_over_after_kick_left || state == _shoot_over_after_kick_right) && (wait_for_ball_move_left || wait_for_ball_move_right)) choose_pic <= next_choose_pic;
		else choose_pic <= next_choose_pic;
	end
	
	always@(posedge clk16 or posedge reset)
	begin
	      if(reset) next_choose_pic <= menu;
	      else next_choose_pic <= choose_pic;
	end
	
endmodule