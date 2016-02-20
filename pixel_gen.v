module pixel_gen(
	input wait_for_ball_move_left,
	input wait_for_ball_move_right,
	input clk,
	input clk2,
	input clk3,
	input reset,
   input [9:0] h_cnt,
   input [9:0] v_cnt,
   input valid,
   input warning,
   input ret,
   input friend_left,
   input [1:0] mode,
   input [2:0] choose_pic,
   output reg [3:0] vgaRed,
   output reg [3:0] vgaGreen,
   output reg [3:0] vgaBlue

   );
   
	reg [9:0] tmp;
	reg [9:0] tmp2;
	reg [9:0] next_tmp;
	reg [9:0] next_tmp2;
	
	reg [9:0] ball_x, x;
    reg [9:0] ball_y, y;
    reg [9:0] next_ball_x, next_x;
    reg [9:0] next_ball_y, next_y;
	
	wire [9:0] pt940, pt980, pt1000, pt1010, pt1020, xpt1005, xpt1010, xpt1020, xpt980, xpt990, xpt995, pt995, pt950, pt955;
    
    reg en, en2;
    integer i;
    wire [15:0] sqrt [30:0];
    genvar j;
    
    generate
       for (j = 0; j <= 15; j = j + 1) begin : gen_loop
          cordic_0 ex(.s_axis_cartesian_tdata(225 - j*j), // input [15 : 0] x_in
            .m_axis_dout_tdata(sqrt[j]), // ouput [8 : 0] x_out
            .aclk(clk));
       end
    endgenerate
    
    always@(posedge clk2 or posedge reset) begin
        if(reset) begin
            ball_x=0;
            ball_y=0;
            x = 0;
            y = 0;
        end else begin
           if(wait_for_ball_move_left == 1) begin
              //if((320 - next_ball_x >= 128 && 320 - next_ball_x <= 168)) begin ball_x = next_ball_x; ball_y = 215; end
              if(ret == 1) begin ball_x = next_ball_x-1; ball_y = next_ball_y-1;end
              else begin ball_x = next_ball_x+1; ball_y = next_ball_y+1; end
              x= next_x + 1;
              y= next_y + 1;
           end
           else if(wait_for_ball_move_right == 1) begin
              //if((320 + next_ball_x >= 472 && 320 + next_ball_x <= 512)) begin ball_x = next_ball_x; ball_y = 215; end
              if(ret == 1) begin ball_x = next_ball_x-1; ball_y = next_ball_y-1; end
              else begin ball_x = next_ball_x+1; ball_y = next_ball_y+1; end
              x= next_x + 1;
                            y= next_y + 1;
           end else begin
              ball_x = 0;
              ball_y = 0;
              x = 0;
              y = 0;
           end
        end
    end
    
    always@(posedge clk or posedge reset)
        if(reset) en = 0; 
        else en = ~en;
    
     always@(posedge clk3 or posedge reset)
               if(reset) en2 = 0; 
               else en2 = ~en2;
    
	always@(posedge clk or posedge reset) 
	begin
		if(reset) begin
			tmp=0;
			tmp2=0;
		end else begin
			if(tmp<240) begin 
				tmp=next_tmp+1;
				if(tmp>=120) tmp2=next_tmp2+1;
			end
			else begin
				tmp2=0;
				tmp=0;
			end
		end
	end
	
	always @ (*) begin
		next_tmp<=tmp;
		next_tmp2<=tmp2;
		next_ball_x<=ball_x;
        next_ball_y<=ball_y;
        next_x <= x;
        next_y <= y;
	end

	assign pt940 = 940 + next_y;
	assign pt980 = 980 + next_y;
	assign pt1010 = 1010 + next_y;
	assign pt1020 = 1020 + next_y;//824 + next_y;
	assign pt1000 = 1000 + next_y;
	assign xpt980 = 980 + next_x;
	assign xpt990 = 990 + next_x;
	assign xpt1005 = 1005 + next_x;
	assign xpt1010 = 1010 + next_x;
	assign xpt1020 = 1020 + next_x;
	assign xpt995 = 995 + next_x;
	assign pt995 = 995 + next_y;
	assign pt990 = 990 + next_y;
	assign pt955 = 955 + next_y;
	
       always @(*) begin
        if(!valid)
             {vgaRed, vgaGreen, vgaBlue} = 12'h0;
		else if(choose_pic == 3'b000) begin	 //menu
			if(h_cnt>=128 && h_cnt<=188 && v_cnt>=200 && v_cnt<=220)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
			else if(h_cnt>=128 && h_cnt<=148 && v_cnt>=220 && v_cnt<=250)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
			else if(h_cnt>=128 && h_cnt<=188 && v_cnt>=250 && v_cnt<=270)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
			else if(h_cnt>=168 && h_cnt<=188 && v_cnt>=270 && v_cnt<=300)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;             
			else if(h_cnt>=128 && h_cnt<=188 && v_cnt>=300 && v_cnt<=320)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
			
			else if(h_cnt>=218 && h_cnt<=238 && v_cnt>=200 && v_cnt<=320)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
			else if(h_cnt>=238 && h_cnt<=268 && v_cnt>=260 && v_cnt<=280)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
			else if(h_cnt>=268 && h_cnt<=288 && v_cnt>=200 && v_cnt<=320)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				
			else if(h_cnt>=318 && h_cnt<=338 && v_cnt>=200 && v_cnt<=320)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
			else if(h_cnt>=338 && h_cnt<=368 && v_cnt>=200 && v_cnt<=220)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
			else if(h_cnt>=368 && h_cnt<=388 && v_cnt>=200 && v_cnt<=320)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
			else if(h_cnt>=338 && h_cnt<=368 && v_cnt>=300 && v_cnt<=320)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				
			else if(h_cnt>=418 && h_cnt<=500 && v_cnt>=200 && v_cnt<=220)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
			else if(h_cnt>=448 && h_cnt<=468 && v_cnt>=220 && v_cnt<=340)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff;				
			else
				{vgaRed, vgaGreen, vgaBlue} = 12'h000;
				
	       if(h_cnt>=128 && h_cnt<=133 && v_cnt>=400 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=153 && h_cnt<=173 && v_cnt>=400 && v_cnt<=405)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=153 && h_cnt<=158 && v_cnt>=400 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=168 && h_cnt<=173 && v_cnt>=400 && v_cnt<=410)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
                else if(h_cnt>=153 && h_cnt<=173 && v_cnt>=408 && v_cnt<=410)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=153 && h_cnt<=173 && v_cnt>=415 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=193 && h_cnt<=198 && v_cnt>=400 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
                else if(h_cnt>=213 && h_cnt<=218 && v_cnt>=400 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=193 && h_cnt<=218 && v_cnt>=415 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=238 && h_cnt<=258 && v_cnt>=400 && v_cnt<=405)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=238 && h_cnt<=243 && v_cnt>=400 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=253 && h_cnt<=258 && v_cnt>=400 && v_cnt<=410)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
                else if(h_cnt>=238 && h_cnt<=258 && v_cnt>=408 && v_cnt<=410)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=238 && h_cnt<=258 && v_cnt>=415 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                else if(h_cnt>=278 && h_cnt<=283 && v_cnt>=400 && v_cnt<=420)
                {vgaRed, vgaGreen, vgaBlue} = 12'hfff;

                //level 1
                if(mode == 2'b01) begin
                     if(h_cnt>=315 && h_cnt<=320 && v_cnt>=400 && v_cnt<=405)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=320 && h_cnt<=325 && v_cnt>=400 && v_cnt<=420)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=313 && h_cnt<=333 && v_cnt>=415 && v_cnt<=420)
                         {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                end
                
                else if(mode == 2'b10) begin
                //level 2
                    if(h_cnt>=315 && h_cnt<=335 && v_cnt>=400 && v_cnt<=405)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=330 && h_cnt<=335 && v_cnt>=405 && v_cnt<=408)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=315 && h_cnt<=335 && v_cnt>=408 && v_cnt<=411)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=315 && h_cnt<=320 && v_cnt>=411 && v_cnt<=420)
                         {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=315 && h_cnt<=335 && v_cnt>=417 && v_cnt<=420)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                end
                //level 3
                else if(mode == 2'b11) begin
                    if(h_cnt>=315 && h_cnt<=335 && v_cnt>=400 && v_cnt<=403)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=315 && h_cnt<=335 && v_cnt>=407 && v_cnt<=410)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=315 && h_cnt<=335 && v_cnt>=417 && v_cnt<=420)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    else if(h_cnt>=330 && h_cnt<=335 && v_cnt>=400 && v_cnt<=420)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                end		
	
		end
		else if(choose_pic == 3'b010) begin //game_over
			 if((h_cnt >= 128 && h_cnt <= 188 && v_cnt >= 200 && v_cnt <= 220)
			|| (h_cnt >= 128 && h_cnt <= 148 && v_cnt >= 200 && v_cnt <= 260)
			|| (h_cnt >= 188 && h_cnt <= 208 && v_cnt >= 200 && v_cnt <= 280)
			|| (h_cnt >= 128 && h_cnt <= 208 && v_cnt >= 260 && v_cnt <= 280)
			|| (h_cnt >= 238 && h_cnt <= 258 && v_cnt >= 200 && v_cnt <= 260)
			|| (h_cnt >= 248 && h_cnt <= 288 && v_cnt >= 260 && v_cnt <= 280)
			|| (h_cnt >= 278 && h_cnt <= 298 && v_cnt >= 200 && v_cnt <= 260)
			|| (h_cnt >= 328 && h_cnt <= 388 && v_cnt >= 200 && v_cnt <= 220)
			|| (h_cnt >= 328 && h_cnt <= 388 && v_cnt >= 230 && v_cnt <= 250)
			|| (h_cnt >= 328 && h_cnt <= 388 && v_cnt >= 260 && v_cnt <= 280)
			|| (h_cnt >= 328 && h_cnt <= 348 && v_cnt >= 200 && v_cnt <= 260)
			|| (h_cnt >= 418 && h_cnt <= 478 && v_cnt >= 200 && v_cnt <= 220)
			|| (h_cnt >= 418 && h_cnt <= 438 && v_cnt >= 200 && v_cnt <= 280)
			|| (h_cnt >= 418 && h_cnt <= 478 && v_cnt >= 230 && v_cnt <= 250)
			|| (h_cnt >= 458 && h_cnt <= 478 && v_cnt >= 200 && v_cnt <= 230) 
			|| (h_cnt >= 448 && h_cnt <= 468 && v_cnt >= 230 && v_cnt <= 280) 
			)
			{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
			else
			{vgaRed, vgaGreen, vgaBlue} = 12'h0;
		end
		else if(choose_pic == 3'b001) begin //game_win
		      if(h_cnt>=90&&h_cnt<=110&&v_cnt>=160&&v_cnt<=260)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=150&&h_cnt<=170&&v_cnt>=160&&v_cnt<=260)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=210&&h_cnt<=230&&v_cnt>=160&&v_cnt<=260)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=90&&h_cnt<=230&&v_cnt>=260&&v_cnt<=280)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=270&&h_cnt<=390&&v_cnt>=160&&v_cnt<=180)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=320&&h_cnt<=340&&v_cnt>=180&&v_cnt<=280)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=270&&h_cnt<=390&&v_cnt>=260&&v_cnt<=280)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=430&&h_cnt<=450&&v_cnt>=160&&v_cnt<=280)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=530&&h_cnt<=550&&v_cnt>=160&&v_cnt<=280)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=430&&h_cnt<=440&&v_cnt>=160&&v_cnt<=170)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=440&&h_cnt<=450&&v_cnt>=170&&v_cnt<=180)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=450&&h_cnt<=460&&v_cnt>=180&&v_cnt<=190)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=460&&h_cnt<=470&&v_cnt>=190&&v_cnt<=200)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=470&&h_cnt<=480&&v_cnt>=200&&v_cnt<=210)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=480&&h_cnt<=490&&v_cnt>=210&&v_cnt<=220)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=490&&h_cnt<=500&&v_cnt>=220&&v_cnt<=230)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=500&&h_cnt<=510&&v_cnt>=230&&v_cnt<=240)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else if(h_cnt>=510&&h_cnt<=520&&v_cnt>=240&&v_cnt<=250)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
				else if(h_cnt>=520&&h_cnt<=530&&v_cnt>=250&&v_cnt<=260)
					{vgaRed, vgaGreen, vgaBlue} = 12'hfff;
				else
					{vgaRed, vgaGreen, vgaBlue} = 12'h0;
		end
		else if(choose_pic == 3'b011) begin //enemy_left
                    if(v_cnt<next_tmp2) {vgaRed, vgaGreen, vgaBlue} = 12'h6d0;
                    else if (v_cnt<next_tmp) {vgaRed, vgaGreen, vgaBlue} = 12'h490;
                    else if(v_cnt<120+next_tmp) {vgaRed, vgaGreen, vgaBlue} = 12'h6d0;
                    else if(v_cnt<240+next_tmp) {vgaRed, vgaGreen, vgaBlue} = 12'h490;
                    else if(v_cnt<360+next_tmp&&v_cnt<480) {vgaRed, vgaGreen, vgaBlue} = 12'h6d0;
                    else {vgaRed, vgaGreen, vgaBlue} = 12'h490;
                    
                    //if(h_cnt>=left_pt &&h_cnt<=right_pt &&v_cnt>=up_pt &&v_cnt<=down_pt ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    
					if(wait_for_ball_move_right) begin
						//friend left
						if(friend_left) begin
								if(h_cnt>=310 - next_x &&h_cnt<=315 - next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                    else if(h_cnt>=325 - next_x &&h_cnt<=340 - next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
							 else if(h_cnt>=300 - next_x &&h_cnt<=340 - next_x &&v_cnt>=pt940 &&v_cnt<=pt980 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=310 - next_x &&h_cnt<=330 - next_x &&v_cnt>=pt980 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
								else if(h_cnt>=310 - next_x &&h_cnt<=315 - next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=325 - next_x &&h_cnt<=330 - next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=300 - next_x &&h_cnt<=310 - next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=330 - next_x &&h_cnt<=340 - next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000; 
						
						//enemy right 
						if(h_cnt>=654 - next_x &&h_cnt<=659 - next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                    else if(h_cnt>=669 - next_x &&h_cnt<=674 - next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
								else if(h_cnt>=644 - next_x &&h_cnt<=684 - next_x &&v_cnt>=pt940 &&v_cnt<=pt980 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=654 - next_x &&h_cnt<=674 - next_x &&v_cnt>=pt980 &&v_cnt<=pt1010  ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=654 - next_x &&h_cnt<=659 - next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=669 - next_x &&h_cnt<=674 - next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=644 - next_x &&h_cnt<=654 - next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=674 - next_x &&h_cnt<=684 - next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
							end
							else begin
								if(h_cnt>=310 - next_x &&h_cnt<=315 - next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                    else if(h_cnt>=325 - next_x &&h_cnt<=340 - next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
								else if(h_cnt>=300 - next_x &&h_cnt<=340 - next_x &&v_cnt>=pt940 &&v_cnt<=pt980 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=310 - next_x &&h_cnt<=330 - next_x &&v_cnt>=pt980 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=310 - next_x &&h_cnt<=315 - next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=325 - next_x &&h_cnt<=330 - next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020  ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=300 - next_x &&h_cnt<=310 - next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=330 - next_x &&h_cnt<=340 - next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ){vgaRed, vgaGreen, vgaBlue} = 12'haaa; 
						
						//enemy right 
								if(h_cnt>=654 - next_x &&h_cnt<=659 - next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                    else if(h_cnt>=669 - next_x &&h_cnt<=674 - next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
								if(h_cnt>=644 - next_x &&h_cnt<=684 - next_x &&v_cnt>=pt940 &&v_cnt<=pt980 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=654 - next_x &&h_cnt<=674 - next_x &&v_cnt>=pt980  &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
								else if(h_cnt>=654 - next_x &&h_cnt<=659 - next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=669 - next_x &&h_cnt<=674 - next_x &&v_cnt>=pt1010  &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=644 - next_x &&h_cnt<=654 - next_x &&v_cnt>=pt1000  &&v_cnt<=pt1010  ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=674 - next_x &&h_cnt<=684 - next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010  ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
							end
					end
					
					/*if(wait_for_ball_move_left) begin
						//friend left
						if(friend_left) begin
							 if(h_cnt>=300 - next_x &&h_cnt<=340 - next_x &&v_cnt>=784 + next_y &&v_cnt<=824 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=310 - next_x &&h_cnt<=330 - next_x &&v_cnt>=824 + next_y &&v_cnt<=854 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
								else if(h_cnt>=310 - next_x &&h_cnt<=315 - next_x &&v_cnt>=854 + next_y &&v_cnt<=864 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=325 - next_x &&h_cnt<=330 - next_x &&v_cnt>=854 + next_y &&v_cnt<=864 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=300 - next_x &&h_cnt<=310 - next_x &&v_cnt>=844 + next_y &&v_cnt<=854 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
								else if(h_cnt>=330 - next_x &&h_cnt<=340 - next_x &&v_cnt>=844 + next_y &&v_cnt<=854 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000; 
						
						//enemy right 
								if(h_cnt>=980 - next_x &&h_cnt<=684 - next_x &&v_cnt>=784 + next_y &&v_cnt<=824 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=654 - next_x &&h_cnt<=674 - next_x &&v_cnt>=824 + next_y &&v_cnt<=854 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=654 - next_x &&h_cnt<=659 - next_x &&v_cnt>=854 + next_y &&v_cnt<=864 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=669 - next_x &&h_cnt<=674 - next_x &&v_cnt>=854 + next_y &&v_cnt<=864 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=644 - next_x &&h_cnt<=654 - next_x &&v_cnt>=844 + next_y &&v_cnt<=854 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
								else if(h_cnt>=674 - next_x &&h_cnt<=684 - next_x &&v_cnt>=844 + next_y &&v_cnt<=854 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
							end
					end*/
					
					
                    //player
                     if(wait_for_ball_move_left) begin
                    if(h_cnt>=300 + next_x &&h_cnt<=340 + next_x &&v_cnt>=340 + next_y &&v_cnt<=380 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    else if(h_cnt>=310 + next_x &&h_cnt<=330 + next_x &&v_cnt>=380 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                    else if(h_cnt>=310 + next_x &&h_cnt<=315 + next_x &&v_cnt>=410 + next_y &&v_cnt<=420 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    else if(h_cnt>=325 + next_x &&h_cnt<=330 + next_x &&v_cnt>=410 + next_y &&v_cnt<=420 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    else if(h_cnt>=300 + next_x &&h_cnt<=310 + next_x &&v_cnt>=400 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    else if(h_cnt>=330 + next_x &&h_cnt<=340 + next_x &&v_cnt>=400 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000; 
                    end
                    else begin
                    if(h_cnt>=300 - next_x &&h_cnt<=340 - next_x &&v_cnt>=340 + next_y &&v_cnt<=380 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=310 - next_x &&h_cnt<=330 - next_x &&v_cnt>=380 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                        else if(h_cnt>=310 - next_x &&h_cnt<=315 - next_x &&v_cnt>=410 + next_y &&v_cnt<=420 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=325 - next_x &&h_cnt<=330 - next_x &&v_cnt>=410 + next_y &&v_cnt<=420 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=300 - next_x &&h_cnt<=310 - next_x &&v_cnt>=400 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=330 - next_x &&h_cnt<=340 - next_x &&v_cnt>=400 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000; 
                    end
                    //ball 
                    if(wait_for_ball_move_left) begin
                                        //if(h_cnt>=305-next_ball_x&&h_cnt<=335-next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                        for(i = 0; i <= 15; i = i + 1) begin
                                            if(h_cnt >= 320-sqrt[i] - next_ball_x && h_cnt <= 320+sqrt[i] - next_ball_x && ((v_cnt >= 310 - i - 1 - next_ball_y && v_cnt <= 310 - i - next_ball_y) || (v_cnt >= 310 + i - 1 - next_ball_y && v_cnt <= 310 + i - next_ball_y))) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                        end
                                    end else 
                                         //if(h_cnt>=305+next_ball_x&&h_cnt<=335+next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                          for(i = 0; i <= 15; i = i + 1) begin
                                             if(h_cnt >= 320-sqrt[i] + next_ball_x && h_cnt <= 320+sqrt[i] + next_ball_x && ((v_cnt >= 310 - i - 1 - next_ball_y && v_cnt <= 310 - i - next_ball_y) || (v_cnt >= 310 + i - 1 - next_ball_y && v_cnt <= 310 + i - next_ball_y))) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                         end
                    //left enmy
                    if(wait_for_ball_move_left) begin
                    if(h_cnt>=138 + next_x &&h_cnt<=143 + next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                    else if(h_cnt>=153 + next_x &&h_cnt<=158 + next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                    else if(h_cnt>=128 + next_x &&h_cnt<=168 + next_x &&v_cnt>=100 + next_y &&v_cnt<=140 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                    else if(h_cnt>=138 + next_x &&h_cnt<=158 + next_x &&v_cnt>=140 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                    else if(h_cnt>=138 + next_x &&h_cnt<=143 + next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                    else if(h_cnt>=153 + next_x &&h_cnt<=158 + next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                    else if(h_cnt>=128 + next_x &&h_cnt<=138 + next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                    else if(h_cnt>=158 + next_x &&h_cnt<=168 + next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                    end
                    else begin
                     if(h_cnt>=138 - next_x &&h_cnt<=143 - next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                       else if(h_cnt>=153 - next_x &&h_cnt<=158 - next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                       else if(h_cnt>=128 - next_x &&h_cnt<=168 - next_x &&v_cnt>=100 + next_y &&v_cnt<=140 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                       else if(h_cnt>=138 - next_x &&h_cnt<=158 - next_x &&v_cnt>=140 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                       else if(h_cnt>=138 - next_x &&h_cnt<=143 - next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                       else if(h_cnt>=153 - next_x &&h_cnt<=158 - next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                       else if(h_cnt>=128 - next_x &&h_cnt<=138 - next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                       else if(h_cnt>=158 - next_x &&h_cnt<=168 - next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                    end
                    //right friend
                    if(wait_for_ball_move_left) begin
                   if(h_cnt>=482 + next_x &&h_cnt<=487 + next_x &&v_cnt>=110 + next_y &&v_cnt<=115+ next_y) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                    else if(h_cnt>=497 + next_x &&h_cnt<=502 + next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                    else if(h_cnt>=472 + next_x &&h_cnt<=512 + next_x &&v_cnt>=100 + next_y &&v_cnt<=140 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    else if(h_cnt>=482 + next_x &&h_cnt<=502 + next_x &&v_cnt>=140 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                    else if(h_cnt>=482 + next_x &&h_cnt<=487 + next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    else if(h_cnt>=497 + next_x &&h_cnt<=502 + next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    else if(h_cnt>=472 + next_x &&h_cnt<=482 + next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    else if(h_cnt>=502 + next_x &&h_cnt<=512 + next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    end
                    else begin
                    if(h_cnt>=482 - next_x &&h_cnt<=487 - next_x &&v_cnt>=110 + next_y &&v_cnt<=115+ next_y) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                                        else if(h_cnt>=497 - next_x &&h_cnt<=502 - next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                                        else if(h_cnt>=472 - next_x &&h_cnt<=512 - next_x &&v_cnt>=100 + next_y &&v_cnt<=140 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=482 - next_x &&h_cnt<=502 - next_x &&v_cnt>=140 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                        else if(h_cnt>=482 - next_x &&h_cnt<=487 - next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=497 - next_x &&h_cnt<=502 - next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=472 - next_x &&h_cnt<=482 - next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=502 - next_x &&h_cnt<=512 - next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                    end
                    
                    if(en == 1 && warning == 1) begin  //red warning frame
                        if(h_cnt >= 0 && h_cnt <= 640 && v_cnt >= 0 && v_cnt <= 5) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                        else if(h_cnt >= 0 && h_cnt <= 640 && v_cnt >= 475 && v_cnt <= 480) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                        else if(h_cnt >= 0 && h_cnt <= 5 && v_cnt >= 0 && v_cnt <= 480) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                        else if(h_cnt >= 635 && h_cnt <= 640 && v_cnt >= 0 && v_cnt <= 480) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                    end
                    
                end
                else if(choose_pic == 3'b100) begin //enemy_right
                    if(v_cnt<next_tmp2) {vgaRed, vgaGreen, vgaBlue} = 12'h6d0;
                    else if (v_cnt<next_tmp) {vgaRed, vgaGreen, vgaBlue} = 12'h490;
                    else if(v_cnt<120+next_tmp) {vgaRed, vgaGreen, vgaBlue} = 12'h6d0;
                    else if(v_cnt<240+next_tmp) {vgaRed, vgaGreen, vgaBlue} = 12'h490;
                    else if(v_cnt<360+next_tmp&&v_cnt<480) {vgaRed, vgaGreen, vgaBlue} = 12'h6d0;
                    else {vgaRed, vgaGreen, vgaBlue} = 12'h490;
                         
                    if(wait_for_ball_move_left) begin
                                            //ene right
                                            if(friend_left) begin
												if(h_cnt>=310 + next_x &&h_cnt<=315 + next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                    else if(h_cnt>=325 + next_x &&h_cnt<=340 + next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                                 else if(h_cnt>=300 + next_x &&h_cnt<=340 + next_x &&v_cnt>=pt940 &&v_cnt<=pt980 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=310 + next_x &&h_cnt<=330 + next_x &&v_cnt>=pt980 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=310 + next_x &&h_cnt<=315 + next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=325 + next_x &&h_cnt<=330 + next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=300 + next_x &&h_cnt<=310 + next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=330 + next_x &&h_cnt<=340 + next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa; 
                                            
                                            //f left 
													if(h_cnt>=xpt990+ next_x &&h_cnt<=xpt995 + next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                    else if(h_cnt>=xpt1005 + next_x &&h_cnt<=xpt1010 + next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                                                    else if(h_cnt>=xpt980 &&h_cnt<=xpt1020 &&v_cnt>=pt940 &&v_cnt<=pt980 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                    else if(h_cnt>=xpt990 &&h_cnt<=xpt1010 &&v_cnt>=pt980 &&v_cnt<=pt1010  ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                                    else if(h_cnt>=xpt990 &&h_cnt<=xpt995 &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                    else if(h_cnt>=xpt1005 &&h_cnt<=xpt1010 &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                    else if(h_cnt>=xpt980 &&h_cnt<=xpt990 &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                    else if(h_cnt>=xpt1010 &&h_cnt<=xpt1020 &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                end
                                                else begin
													if(h_cnt>=xpt990+ next_x &&h_cnt<=xpt995 + next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                    else if(h_cnt>=xpt1005 + next_x &&h_cnt<=xpt1010 + next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                                    else if(h_cnt>=xpt980 &&h_cnt<=xpt1020 &&v_cnt>=pt940 &&v_cnt<=pt980) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=xpt990 &&h_cnt<=xpt1010 &&v_cnt>=pt980 &&v_cnt<=pt1010  ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=xpt990 &&h_cnt<=xpt995 &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=xpt1005 &&h_cnt<=xpt1010 &&v_cnt>=pt1010 &&v_cnt<=pt1020  ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=xpt980 &&h_cnt<=xpt990 &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                    else if(h_cnt>=xpt1010 &&h_cnt<=xpt1020 &&v_cnt>=pt1000 &&v_cnt<=pt1010 ){vgaRed, vgaGreen, vgaBlue} = 12'haaa; 
                                            
                                            //enemy right 
													if(h_cnt>=310 + next_x &&h_cnt<=315 + next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                    else if(h_cnt>=325 + next_x &&h_cnt<=340 + next_x &&v_cnt>=pt950 + next_y &&v_cnt<=pt955 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                                                    else if(h_cnt>=300 + next_x &&h_cnt<=340 + next_x &&v_cnt>=pt940 &&v_cnt<=pt980 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                    else if(h_cnt>=310 + next_x &&h_cnt<=330 + next_x &&v_cnt>=pt980 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                                    else if(h_cnt>=310 + next_x &&h_cnt<=315 + next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                    else if(h_cnt>=325 + next_x &&h_cnt<=330 + next_x &&v_cnt>=pt1010 &&v_cnt<=pt1020 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                    else if(h_cnt>=300 + next_x &&h_cnt<=310 + next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010 ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                    else if(h_cnt>=330 + next_x &&h_cnt<=340 + next_x &&v_cnt>=pt1000 &&v_cnt<=pt1010  ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                end
                                        end     
                         
                         
                    //player
                         if(wait_for_ball_move_left) begin
                                        if(h_cnt>=300 + next_x &&h_cnt<=340 + next_x &&v_cnt>=340 + next_y &&v_cnt<=380 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=310 + next_x &&h_cnt<=330 + next_x &&v_cnt>=380 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                        else if(h_cnt>=310 + next_x &&h_cnt<=315 + next_x &&v_cnt>=410 + next_y &&v_cnt<=420 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=325 + next_x &&h_cnt<=330 + next_x &&v_cnt>=410 + next_y &&v_cnt<=420 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=300 + next_x &&h_cnt<=310 + next_x &&v_cnt>=400 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                        else if(h_cnt>=330 + next_x &&h_cnt<=340 + next_x &&v_cnt>=400 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000; 
                                        end
                                        else begin
                                        if(h_cnt>=300 - next_x &&h_cnt<=340 - next_x &&v_cnt>=340 + next_y &&v_cnt<=380 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                            else if(h_cnt>=310 - next_x &&h_cnt<=330 - next_x &&v_cnt>=380 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                                            else if(h_cnt>=310 - next_x &&h_cnt<=315 - next_x &&v_cnt>=410 + next_y &&v_cnt<=420 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                            else if(h_cnt>=325 - next_x &&h_cnt<=330 - next_x &&v_cnt>=410 + next_y &&v_cnt<=420 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                            else if(h_cnt>=300 - next_x &&h_cnt<=310 - next_x &&v_cnt>=400 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                            else if(h_cnt>=330 - next_x &&h_cnt<=340 - next_x &&v_cnt>=400 + next_y &&v_cnt<=410 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000; 
                                        end
                         
                        //ball 
                                    if(wait_for_ball_move_left) begin
                                        //if(h_cnt>=305-next_ball_x&&h_cnt<=335-next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                    //end else 
                                      //   if(h_cnt>=305+next_ball_x&&h_cnt<=335+next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                    for(i = 0; i <= 15; i = i + 1) begin
                                                                          if(h_cnt >= 320-sqrt[i] - next_ball_x && h_cnt <= 320+sqrt[i] - next_ball_x && ((v_cnt >= 310 - i - 1 - next_ball_y && v_cnt <= 310 - i - next_ball_y) || (v_cnt >= 310 + i - 1 - next_ball_y && v_cnt <= 310 + i - next_ball_y))) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                                      end
                                                                  end else 
                                                                       //if(h_cnt>=305+next_ball_x&&h_cnt<=335+next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                                        for(i = 0; i <= 15; i = i + 1) begin
                                                                           if(h_cnt >= 320-sqrt[i] + next_ball_x && h_cnt <= 320+sqrt[i] + next_ball_x && ((v_cnt >= 310 - i - 1 - next_ball_y && v_cnt <= 310 - i - next_ball_y) || (v_cnt >= 310 + i - 1 - next_ball_y && v_cnt <= 310 + i - next_ball_y))) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                                         end
                      //left friend
                                                if(wait_for_ball_move_left) begin
                                         if(h_cnt>=138 + next_x &&h_cnt<=143 + next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                                         else if(h_cnt>=153 + next_x &&h_cnt<=158 + next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                                         else if(h_cnt>=128 + next_x &&h_cnt<=168 + next_x &&v_cnt>=100 + next_y &&v_cnt<=140 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                         else if(h_cnt>=138 + next_x &&h_cnt<=158 + next_x &&v_cnt>=140 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                         else if(h_cnt>=138 + next_x &&h_cnt<=143 + next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                         else if(h_cnt>=153 + next_x &&h_cnt<=158 + next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                         else if(h_cnt>=128 + next_x &&h_cnt<=138 + next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                         else if(h_cnt>=158 + next_x &&h_cnt<=168 + next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                         end
                                         else begin
                                          if(h_cnt>=138 - next_x &&h_cnt<=143 - next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                                                            else if(h_cnt>=153 - next_x &&h_cnt<=158 - next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;//eye
                                                            else if(h_cnt>=128 - next_x &&h_cnt<=168 - next_x &&v_cnt>=100 + next_y &&v_cnt<=140 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                            else if(h_cnt>=138 - next_x &&h_cnt<=158 - next_x &&v_cnt>=140 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                                            else if(h_cnt>=138 - next_x &&h_cnt<=143 - next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                            else if(h_cnt>=153 - next_x &&h_cnt<=158 - next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                            else if(h_cnt>=128 - next_x &&h_cnt<=138 - next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                                            else if(h_cnt>=158 - next_x &&h_cnt<=168 - next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                                         end
                                                
                   //right enemy
                                                            if(wait_for_ball_move_left) begin
                                     if(h_cnt>=482 + next_x &&h_cnt<=487 + next_x &&v_cnt>=110 + next_y &&v_cnt<=115+ next_y) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                      else if(h_cnt>=497 + next_x &&h_cnt<=502 + next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                      else if(h_cnt>=472 + next_x &&h_cnt<=512 + next_x &&v_cnt>=100 + next_y &&v_cnt<=140 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                      else if(h_cnt>=482 + next_x &&h_cnt<=502 + next_x &&v_cnt>=140 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                      else if(h_cnt>=482 + next_x &&h_cnt<=487 + next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                      else if(h_cnt>=497 + next_x &&h_cnt<=502 + next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                      else if(h_cnt>=472 + next_x &&h_cnt<=482 + next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                      else if(h_cnt>=502 + next_x &&h_cnt<=512 + next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                      end
                                      else begin
                                      if(h_cnt>=482 - next_x &&h_cnt<=487 - next_x &&v_cnt>=110 + next_y &&v_cnt<=115+ next_y) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                                          else if(h_cnt>=497 - next_x &&h_cnt<=502 - next_x &&v_cnt>=110 + next_y &&v_cnt<=115 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                                          else if(h_cnt>=472 - next_x &&h_cnt<=512 - next_x &&v_cnt>=100 + next_y &&v_cnt<=140 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                          else if(h_cnt>=482 - next_x &&h_cnt<=502 - next_x &&v_cnt>=140 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                          else if(h_cnt>=482 - next_x &&h_cnt<=487 - next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                          else if(h_cnt>=497 - next_x &&h_cnt<=502 - next_x &&v_cnt>=170 + next_y &&v_cnt<=180 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                          else if(h_cnt>=472 - next_x &&h_cnt<=482 - next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                                          else if(h_cnt>=502 - next_x &&h_cnt<=512 - next_x &&v_cnt>=160 + next_y &&v_cnt<=170 + next_y ) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                      end
                                                            
                      if(en == 1 && warning == 1) begin  //red warning frame
                                                                            if(h_cnt >= 0 && h_cnt <= 640 && v_cnt >= 0 && v_cnt <= 5) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                                                            else if(h_cnt >= 0 && h_cnt <= 640 && v_cnt >= 475 && v_cnt <= 480) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                                                            else if(h_cnt >= 0 && h_cnt <= 5 && v_cnt >= 0 && v_cnt <= 480) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                                                            else if(h_cnt >= 635 && h_cnt <= 640 && v_cnt >= 0 && v_cnt <= 480) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                                                                        end
                end
                else if(choose_pic == 3'b101) begin //shoot_enemy_left
                    if(v_cnt <= 120 || (v_cnt > 240 && v_cnt <= 360)) {vgaRed, vgaGreen, vgaBlue} = 12'h6d0;
                    else if((v_cnt <= 240 && v_cnt > 120) || (v_cnt <= 480 && v_cnt > 360)) {vgaRed, vgaGreen, vgaBlue} = 12'h490;
                    
                    if((h_cnt >= 128 && h_cnt <= 532 && v_cnt >= 51 && v_cnt <= 54)
                    || (h_cnt > 134 && h_cnt <= 137 && v_cnt >= 60 && v_cnt <= 120)
                    || (h_cnt > 529 && h_cnt <= 532 && v_cnt >= 60 && v_cnt <= 120)) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                    
                    if((h_cnt >= 128 && h_cnt <= 532 && v_cnt > 54 && v_cnt <= 57) || (h_cnt > 131 && h_cnt <= 134 && v_cnt >= 60 && v_cnt <= 120) || (h_cnt > 526 && h_cnt <= 529 && v_cnt >= 60 && v_cnt <= 120)) {vgaRed, vgaGreen, vgaBlue} = 12'h777;
                    if((h_cnt >= 128 && h_cnt <= 532 && v_cnt > 57 && v_cnt <= 60) || (h_cnt > 128 && h_cnt <= 131 && v_cnt >= 60 && v_cnt <= 120) || (h_cnt > 523 && h_cnt <= 526 && v_cnt >= 60 && v_cnt <= 120)) {vgaRed, vgaGreen, vgaBlue} = 12'h555;
                    if(h_cnt > 137 && h_cnt < 523 && v_cnt > 83 && v_cnt <= 85) {vgaRed, vgaGreen, vgaBlue} = 12'h333;
                    
                    //player
                         if(h_cnt>=300&&h_cnt<=340&&v_cnt>=340&&v_cnt<=380) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         else if(h_cnt>=310&&h_cnt<=330&&v_cnt>=380&&v_cnt<=410) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                         else if(h_cnt>=310&&h_cnt<=315&&v_cnt>=410&&v_cnt<=420) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         else if(h_cnt>=325&&h_cnt<=330&&v_cnt>=410&&v_cnt<=420) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         else if(h_cnt>=300&&h_cnt<=310&&v_cnt>=400&&v_cnt<=410) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         else if(h_cnt>=330&&h_cnt<=340&&v_cnt>=400&&v_cnt<=410) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         
                        //ball 
                                     if(wait_for_ball_move_left) begin
                                                       //if(h_cnt>=305-next_ball_x&&h_cnt<=335-next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                       for(i = 0; i <= 15; i = i + 1) begin
                                                           if(h_cnt >= 320-sqrt[i] - next_ball_x && h_cnt <= 320+sqrt[i] - next_ball_x && ((v_cnt >= 310 - i - 1 - next_ball_y && v_cnt <= 310 - i - next_ball_y) || (v_cnt >= 310 + i - 1 - next_ball_y && v_cnt <= 310 + i - next_ball_y))) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                       end
                                                   end else 
                                                        //if(h_cnt>=305+next_ball_x&&h_cnt<=335+next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                         for(i = 0; i <= 15; i = i + 1) begin
                                                            if(h_cnt >= 320-sqrt[i] + next_ball_x && h_cnt <= 320+sqrt[i] + next_ball_x && ((v_cnt >= 310 - i - 1 - next_ball_y && v_cnt <= 310 - i - next_ball_y) || (v_cnt >= 310 + i - 1 - next_ball_y && v_cnt <= 310 + i - next_ball_y))) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                        end
                                    
                      //left friend
                                    if(h_cnt>=138&&h_cnt<=143&&v_cnt>=110&&v_cnt<=115) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                    else if(h_cnt>=153&&h_cnt<=158&&v_cnt>=110&&v_cnt<=115) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                    else if(h_cnt>=128&&h_cnt<=168&&v_cnt>=100&&v_cnt<=140) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                    else if(h_cnt>=138&&h_cnt<=158&&v_cnt>=140&&v_cnt<=170) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                    else if(h_cnt>=138&&h_cnt<=143&&v_cnt>=170&&v_cnt<=180) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                    else if(h_cnt>=153&&h_cnt<=158&&v_cnt>=170&&v_cnt<=180) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                    else if(h_cnt>=128&&h_cnt<=138&&v_cnt>=160&&v_cnt<=170) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                    else if(h_cnt>=158&&h_cnt<=168&&v_cnt>=160&&v_cnt<=170) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                    
                end
                else if(choose_pic == 3'b110) begin //shoot_enemy_right
                    if(v_cnt <= 120 || (v_cnt > 240 && v_cnt <= 360)) {vgaRed, vgaGreen, vgaBlue} = 12'h6d0;
                    else if((v_cnt <= 240 && v_cnt > 120) || (v_cnt <= 480 && v_cnt > 360)) {vgaRed, vgaGreen, vgaBlue} = 12'h490;
                    
                    if((h_cnt >= 128 && h_cnt <= 532 && v_cnt >= 40 && v_cnt <= 43)
                                || (h_cnt > 134 && h_cnt <= 137 && v_cnt >= 60 && v_cnt <= 120)
                                || (h_cnt > 529 && h_cnt <= 532 && v_cnt >= 60 && v_cnt <= 120)) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                
                                if((h_cnt >= 128 && h_cnt <= 532 && v_cnt > 43 && v_cnt <= 46) || (h_cnt > 131 && h_cnt <= 134 && v_cnt >= 60 && v_cnt <= 120) || (h_cnt > 526 && h_cnt <= 529 && v_cnt >= 60 && v_cnt <= 120)) {vgaRed, vgaGreen, vgaBlue} = 12'h777;
                                if((h_cnt >= 128 && h_cnt <= 532 && v_cnt > 46 && v_cnt <= 49) || (h_cnt > 128 && h_cnt <= 131 && v_cnt >= 60 && v_cnt <= 120) || (h_cnt > 523 && h_cnt <= 526 && v_cnt >= 60 && v_cnt <= 120)) {vgaRed, vgaGreen, vgaBlue} = 12'h555;
                                if(h_cnt > 137 && h_cnt < 523 && v_cnt > 83 && v_cnt <= 85) {vgaRed, vgaGreen, vgaBlue} = 12'h333;
                                
                    //player
                         if(h_cnt>=300&&h_cnt<=340&&v_cnt>=340&&v_cnt<=380) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         else if(h_cnt>=310&&h_cnt<=330&&v_cnt>=380&&v_cnt<=410) {vgaRed, vgaGreen, vgaBlue} = 12'hf00;
                         else if(h_cnt>=310&&h_cnt<=315&&v_cnt>=410&&v_cnt<=420) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         else if(h_cnt>=325&&h_cnt<=330&&v_cnt>=410&&v_cnt<=420) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         else if(h_cnt>=300&&h_cnt<=310&&v_cnt>=400&&v_cnt<=410) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         else if(h_cnt>=330&&h_cnt<=340&&v_cnt>=400&&v_cnt<=410) {vgaRed, vgaGreen, vgaBlue} = 12'h000;
                         
                        //ball 
                                     if(wait_for_ball_move_left) begin
                                                       //if(h_cnt>=305-next_ball_x&&h_cnt<=335-next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                       for(i = 0; i <= 15; i = i + 1) begin
                                                           if(h_cnt >= 320-sqrt[i] - next_ball_x && h_cnt <= 320+sqrt[i] - next_ball_x && ((v_cnt >= 310 - i - 1 - next_ball_y && v_cnt <= 310 - i - next_ball_y) || (v_cnt >= 310 + i - 1 - next_ball_y && v_cnt <= 310 + i - next_ball_y))) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                       end
                                                   end else 
                                                        //if(h_cnt>=305+next_ball_x&&h_cnt<=335+next_ball_x&&v_cnt>=295-next_ball_y&&v_cnt<=325-next_ball_y) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                         for(i = 0; i <= 15; i = i + 1) begin
                                                            if(h_cnt >= 320-sqrt[i] + next_ball_x && h_cnt <= 320+sqrt[i] + next_ball_x && ((v_cnt >= 310 - i - 1 - next_ball_y && v_cnt <= 310 - i - next_ball_y) || (v_cnt >= 310 + i - 1 - next_ball_y && v_cnt <= 310 + i - next_ball_y))) {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                                                        end
                                                
                   //right friend
                                       if(h_cnt>=482&&h_cnt<=487&&v_cnt>=110&&v_cnt<=115) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                        else if(h_cnt>=497&&h_cnt<=502&&v_cnt>=110&&v_cnt<=115) {vgaRed, vgaGreen, vgaBlue} = 12'h000;//eye
                                        else if(h_cnt>=472&&h_cnt<=512&&v_cnt>=100&&v_cnt<=140) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                        else if(h_cnt>=482&&h_cnt<=502&&v_cnt>=140&&v_cnt<=170) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                        else if(h_cnt>=482&&h_cnt<=487&&v_cnt>=170&&v_cnt<=180) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                        else if(h_cnt>=497&&h_cnt<=502&&v_cnt>=170&&v_cnt<=180) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                        else if(h_cnt>=472&&h_cnt<=482&&v_cnt>=160&&v_cnt<=170) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;
                                        else if(h_cnt>=502&&h_cnt<=512&&v_cnt>=160&&v_cnt<=170) {vgaRed, vgaGreen, vgaBlue} = 12'haaa;            
                    
                end
                else if(choose_pic == 3'b111) begin //pause
                        if(h_cnt>=30&&h_cnt<=90&&v_cnt>=160&&v_cnt<=180)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=30&&h_cnt<=90&&v_cnt>=210&&v_cnt<=230)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=30&&h_cnt<=50&&v_cnt>=180&&v_cnt<=280)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=70&&h_cnt<=90&&v_cnt>=180&&v_cnt<=230)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=150&&h_cnt<=210&&v_cnt>=160&&v_cnt<=180)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=150&&h_cnt<=210&&v_cnt>=210&&v_cnt<=230)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=150&&h_cnt<=170&&v_cnt>=160&&v_cnt<=280)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=190&&h_cnt<=210&&v_cnt>=160&&v_cnt<=280)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=270&&h_cnt<=290&&v_cnt>=160&&v_cnt<=280)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=330&&h_cnt<=350&&v_cnt>=160&&v_cnt<=280)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=270&&h_cnt<=350&&v_cnt>=260&&v_cnt<=280)
                            {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=410&&h_cnt<=490&&v_cnt>=160&&v_cnt<=180)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=410&&h_cnt<=430&&v_cnt>=160&&v_cnt<=220)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=410&&h_cnt<=490&&v_cnt>=220&&v_cnt<=240)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
                        else if(h_cnt>=470&&h_cnt<=490&&v_cnt>=220&&v_cnt<=280)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=410&&h_cnt<=490&&v_cnt>=260&&v_cnt<=280)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=550&&h_cnt<=630&&v_cnt>=160&&v_cnt<=180)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=550&&h_cnt<=570&&v_cnt>=160&&v_cnt<=280)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else if(h_cnt>=550&&h_cnt<=630&&v_cnt>=200&&v_cnt<=220)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff; 
                        else if(h_cnt>=550&&h_cnt<=630&&v_cnt>=260&&v_cnt<=280)
                        {vgaRed, vgaGreen, vgaBlue} = 12'hfff;
                        else
                        {vgaRed, vgaGreen, vgaBlue} = 12'h0;                
                end
           end
        endmodule


			/*if(h_cnt < 128)
				{vgaRed, vgaGreen, vgaBlue} = 12'h000; black
			else if(h_cnt < 256)
				{vgaRed, vgaGreen, vgaBlue} = 12'h00f; blue
			else if(h_cnt < 384)
				{vgaRed, vgaGreen, vgaBlue} = 12'hf00; red
			else if(h_cnt < 512)
				{vgaRed, vgaGreen, vgaBlue} = 12'h0f0;  yellow            
			else if(h_cnt < 640)
				{vgaRed, vgaGreen, vgaBlue} = 12'hfff; white
			else
				{vgaRed, vgaGreen, vgaBlue} = 12'h0;*/