module dianti(
	input 		clk,
	input 		rst_n,
	input 		kin1,//1楼按键
	input 		kin2,//2楼按键
	input 		kin3,//3楼按键
	input 		kin4,//4楼按键
	input 		kin1_up,//1楼UP键，因为1楼是最底楼，所以没有DOWN键
	input 		kin2_up,//2楼UP键
	input 		kin2_down,//2楼DOWN键
	input 		kin3_up,//3楼UP键
	input 		kin3_down,//3楼DOWN键
	input 		kin4_down,//4楼DOWN键,因为4楼是最顶楼，所以没有UP键
	output reg  led_up,//电梯内UP指示灯
	output reg  led_down,//电梯内DOWN指示灯
	output reg  led_open,//电梯开门指示灯
	output reg	led_close,//电梯关门指示灯
	output reg  led1_up,//1楼UP请求指示灯
	output reg	led1_down,
	output reg  led2_up,//2楼UP请求指示灯
	output reg  led2_down,//2楼DOWN请求指示灯
	output reg  led3_up,//3楼UP请求指示灯
	output reg  led3_down,//3楼DOWN请求指示灯
	output reg	led4_up,
	output reg  led4_down,//4楼DOWN请求指示灯
	output	reg [7:0] curr_st,
	output	reg	[7:0] fl_num
	);
	
	//reg [7:0] fl_num;
	reg k1_up_buf ;
	reg k1_buf ;
	reg k2_up_buf ;
	reg k2_down_buf ;
	reg k2_buf ;
	reg k3_up_buf ;
	reg k3_down_buf ;
	reg k3_buf ;
	reg k4_down_buf ;
	reg k4_buf ;
	reg[31:0] wait_open_close_cnt;
	reg[31:0] wait_close_cnt;
	reg[31:0] wait_up_cnt;
	reg[31:0] wait_down_cnt;
	reg[1:0]dir_flag;
	reg		led_open_close;
	parameter stop=0;
	parameter up=1;
	parameter down=2;
	parameter wait_open_close_time=32'd1900;//电梯开门时间,10S
	// parameter wait_close_time=1900;//电梯关门时间,10S
	parameter wait_up_time=190;//电梯上1层楼所需时间,1S
	parameter wait_down_time=190;//电梯下1层楼所需时间,1S
	parameter
	        F1            =8'd0,  
	        F1_OPEN_UP    =8'd1,   
	        F1_READY_UP   =8'd2,  
	        F1_UP         =8'd3,  
	        F2            =8'd4,  
	        F2_OPEN_UP    =8'd5,  
	        F2_READY_UP   =8'd6,  
	        F2_OPEN_DOWN  =8'd7,    
	        F2_READY_DOWN =8'd8,  
	        F2_UP         =8'd9,  
	        F2_DOWN       =8'd10,  
	        F3            =8'd11,  
	        F3_OPEN_UP    =8'd12,   
	        F3_READY_UP   =8'd13,  
	        F3_OPEN_DOWN  =8'd14,    
	        F3_READY_DOWN =8'd15,  
	        F3_UP         =8'd16,  
	        F3_DOWN       =8'd17,  
	        F4            =8'd18,  
	        F4_OPEN_DOWN  =8'd19,   
	        F4_READY_DOWN =8'd20,   
	        F4_DOWN       =8'd21;
	assign	k1=~kin1;
	assign	k2=~kin2;
	assign	k3=~kin3;
	assign	k4=~kin4;
	assign	k1_up=~kin1_up;
	assign	k2_up=~kin2_up;
	assign	k2_down=~kin2_down;
	assign	k3_up=~kin3_up;
	assign	k3_down=~kin3_down;
	assign	k4_down=~kin4_down;
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)begin
				led_open<=0;
				led_close<=0;
			end else if(curr_st==F1_OPEN_UP||curr_st==F2_OPEN_UP||curr_st==F3_OPEN_UP||
						curr_st==F2_OPEN_DOWN||curr_st==F3_OPEN_DOWN||curr_st==F4_OPEN_DOWN)
				begin
					if(wait_open_close_cnt<=wait_open_close_time[31:1])
						begin
							led_open<=1;
							led_close<=0;
						end
					else
						begin
							led_open<=0;
							led_close<=1;
						end
				end
			else
				;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k1_up_buf<=1;
			else if (k1_up==0)
			   k1_up_buf<=0;
			else if (curr_st==F1_READY_UP)
			   k1_up_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					led1_up			<=0;
					led1_down		<=0;
					led2_up     <=0;
					led2_down   <=0;
					led3_up     <=0;
					led3_down   <=0;
					led4_up			<=0;
					led4_down   <=0;
				end
			else 
				begin
					led1_up			<=led_up;
					led1_down		<=led_down;
					led2_up     <=led_up;
					led2_down   <=led_down;
					led3_up     <=led_up;
					led3_down   <=led_down;
					led4_up			<=led_up;
					led4_down   <=led_down;
				end
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k2_up_buf<=1;
			else if (k2_up==0)
			   k2_up_buf<=0;
			else if (curr_st==F2_READY_UP)
			   k2_up_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k2_down_buf<=1;
			else if (k2_down==0)
			   k2_down_buf<=0;
			else if (curr_st==F2_READY_DOWN)
			   k2_down_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k3_up_buf<=1;
			else if (k3_up==0)
			   k3_up_buf<=0;
			else if (curr_st==F3_READY_UP)
			   k3_up_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k3_down_buf<=1;
			else if (k3_down==0)
			   k3_down_buf<=0;
			else if (curr_st==F3_READY_DOWN)
			   k3_down_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k4_down_buf<=1;
			else if (k4_down==0)
			   k4_down_buf<=0;
			else if (curr_st==F4_READY_DOWN)
			   k4_down_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k1_buf<=1;
			else if (k1==0)
			   k1_buf<=0;
			else if (curr_st==F1_OPEN_UP)
			   k1_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k2_buf<=1;
			else if (k2==0)
			   k2_buf<=0;
			else if (curr_st==F2_OPEN_UP|curr_st==F2_OPEN_DOWN)
			   k2_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k3_buf<=1;
			else if (k3==0)
			   k3_buf<=0;
			else if (curr_st==F3_OPEN_UP|curr_st==F3_OPEN_DOWN)
			   k3_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				k4_buf<=1;
			else if (k4==0)
			   k4_buf<=0;
			else if (curr_st==F4_OPEN_DOWN)
			   k4_buf<=1; 
			else
			  ;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				begin
					curr_st<=F1;
					fl_num<=1;
					led_open_close<=0;
					led_up<=0;
					led_down<=0;
					dir_flag<=stop;
				end
			else
				begin
					case(curr_st)
						F1:
							begin
								led_up<=0;
								led_down<=0;
								led_open_close<=0;
								fl_num<=1;
								if(!k1_up_buf|!k1_buf)
									curr_st<=F1_OPEN_UP;
								else if(!k2_up_buf|!k3_up_buf|!k2_down_buf|!k3_down_buf|!k4_down_buf)
									curr_st<=F1_UP;
								else if(!k2_buf|!k3_buf|!k4_buf)
									curr_st<=F1_UP;
								else
									;
							end
						F1_OPEN_UP:
							begin
								led_up<=0;
								led_down<=0;
								led_open_close<=1;
								if(wait_open_close_cnt==wait_open_close_time)
									curr_st<=F1_READY_UP;
								else
									;
							end
						F1_READY_UP:
							begin
								led_up<=0;
								led_down<=0;
								led_open_close<=0;
								if(!k2_buf|!k3_buf|!k4_buf)
									begin
										curr_st<=F1_UP;
									end
								else if(!k2_up_buf|!k3_up_buf|
												!k2_down_buf|!k3_down_buf|!k4_down_buf)
									begin
										curr_st<=F1_UP;
									end
								else if(!k1_up_buf|!k1_buf)
									curr_st<=F1_OPEN_UP;
								else
									;
							end
						F1_UP:
							begin
								led_open_close<=0;
								led_up<=1;
								led_down<=0;
								dir_flag<=up;
								if(wait_up_cnt==wait_up_time)
									curr_st<=F2;
								else
									;
							end
				/////////////////////////////////////////
						F2:
							begin
								led_open_close<=0;
								led_up<=0;
								led_down<=0;
								fl_num<=2;
								if(dir_flag==up)
									begin
										if(!k2_up_buf|!k2_buf)
											curr_st<=F2_OPEN_UP;
										else if(!k3_up_buf|!k3_down_buf|!k4_down_buf)
											curr_st<=F2_UP;
										else if(!k3_buf|!k4_buf)
											curr_st<=F2_UP;
										else if(!k2_down_buf&(k3_up_buf|k3_down_buf|k4_down_buf))
											curr_st<=F2_OPEN_DOWN;
										else if(!k1_up_buf)
											curr_st<=F2_DOWN;
										else if(!k1_buf)
											curr_st<=F2_DOWN;
										else
											;
									end
								else if(dir_flag==down)
									begin
										if(!k2_down_buf|!k2_buf)
											curr_st<=F2_OPEN_DOWN;
										else if(!k1_up_buf)
											curr_st<=F2_DOWN;
										else if(!k1_buf)
											curr_st<=F2_DOWN;
										else if(!k2_up_buf)
											curr_st<=F2_OPEN_UP;
										else if(!k3_up_buf|!k3_down_buf|!k4_down_buf)
											curr_st<=F2_UP;
										else if(!k3_buf|!k4_buf)
											curr_st<=F2_UP;
										else 
											;
									end
								else
									;
							end
					F2_OPEN_UP:
						begin
							led_up<=0;
							led_down<=0;
							led_open_close<=1;
							if(wait_open_close_cnt==wait_open_close_time)
								curr_st<=F2_READY_UP;
							else
								;
						end	
					F2_READY_UP:
						begin
							led_open_close<=0;
							led_up<=0;
							led_down<=0;
							dir_flag<=up;
							if(!k3_up_buf|!k3_down_buf|!k4_down_buf)
								curr_st<=F2_UP;
							else if(!k3_buf|!k4_buf)
								curr_st<=F2_UP;
							else if(!k1_up_buf)
								curr_st<=F2_DOWN;
							else if(!k1_buf)
								curr_st<=F2_DOWN;
							else if(!k2_up_buf|!k2_buf)
									curr_st<=F2_OPEN_UP;
							else
									;
						end
					F2_OPEN_DOWN:
						begin
							led_open_close<=1;
							led_up<=0;
							led_down<=0;
							if(wait_open_close_cnt==wait_open_close_time)
								curr_st<=F2_READY_DOWN;
							else
								;
						end
					F2_READY_DOWN:
						begin
							led_open_close<=0;
							led_up<=0;
							led_down<=0;
							dir_flag<=down;
							if(!k1_up_buf)
								curr_st<=F2_DOWN;
							else if(!k1_buf)
								curr_st<=F2_DOWN;
							else if(!k3_up_buf|!k3_down_buf|!k4_down_buf)
								curr_st<=F2_UP;
							else if(!k3_buf|!k4_buf)
								curr_st<=F2_UP;
							else if(!k2_down_buf|!k2_buf)
								curr_st<=F2_OPEN_DOWN;
								else
									;
						end
					F2_UP:
						begin
							led_open_close<=0;
							led_up<=1;
							led_down<=0;
							dir_flag<=up;
							if(wait_up_cnt==wait_up_time)
								curr_st<=F3;
							else
								;
						end
					F2_DOWN:
						begin
							led_open_close<=0;
							led_up<=0;
							led_down<=1;
							dir_flag<=down;
							if(wait_down_cnt==wait_down_time)
								curr_st<=F1;
							else
								;
						end
				////////////////////////////////////////
					F3:
						begin
								led_open_close<=0;
								led_up<=0;
								led_down<=0;
								fl_num<=3;
								if(dir_flag==down)
									begin
										if(!k3_down_buf|!k3_buf)
											curr_st<=F3_OPEN_DOWN;
										else if(!k1_up_buf|!k2_up_buf|!k2_down_buf)
											curr_st<=F3_DOWN;
										else if(!k2_buf|!k1_buf)
											curr_st<=F3_DOWN;
										else if(!k3_up_buf)
											curr_st<=F3_OPEN_UP;
										else if(!k4_down_buf)
											curr_st<=F3_UP;
										else if(!k4_buf)
											curr_st<=F3_UP;
										else 
											;
									end
								else if(dir_flag==up)
									begin
										if(!k3_up_buf|!k3_buf)
											curr_st<=F3_OPEN_UP;
										else if(!k4_down_buf)
											curr_st<=F3_UP;
										else if(!k4_buf)
											curr_st<=F3_UP;
										else if(!k3_down_buf)
											curr_st<=F3_OPEN_DOWN;
										else if(!k1_up_buf|!k2_up_buf|!k2_down_buf)
											curr_st<=F3_DOWN;
										else if(!k2_buf|!k1_buf)
											curr_st<=F3_DOWN;
										else
											;
									end
								else
									;
						end	
					F3_OPEN_UP:
						begin
							led_up<=0;
							led_down<=0;
							led_open_close<=1;
							if(wait_open_close_cnt==wait_open_close_time)
								curr_st<=F3_READY_UP;
							else
								;
						end
					F3_READY_UP:
						begin
							led_open_close<=0;
							led_up<=0;
							led_down<=0;
							dir_flag<=up;
							if(!k4_down_buf)
								curr_st<=F3_UP;
							else if(!k4_buf)
								curr_st<=F3_UP;
							else if(!k3_down_buf)
								curr_st<=F3_OPEN_DOWN;
							else if(!k1_up_buf|!k2_up_buf|!k2_down_buf)
								curr_st<=F3_DOWN;
							else if(!k2_buf|!k1_buf)
								curr_st<=F3_DOWN;
							else if(!k3_up_buf|!k3_buf)
								curr_st<=F3_OPEN_UP;
							else
								;
						end
					F3_OPEN_DOWN:
						begin
							led_open_close<=1;
							led_up<=0;
							led_down<=0;
							if(wait_open_close_cnt==wait_open_close_time)
								curr_st<=F3_READY_DOWN;
							else
								;
						end
					F3_READY_DOWN:
						begin
							led_open_close<=0;
							led_up<=0;
							led_down<=0;
							dir_flag<=down;
							if(!k1_up_buf|!k2_up_buf|!k2_down_buf)
								curr_st<=F3_DOWN;
							else if(!k2_buf|!k1_buf)
								curr_st<=F3_DOWN;
							else if(!k4_down_buf)
								curr_st<=F3_UP;
							else if(!k4_buf)
								curr_st<=F3_UP;
							else if(!k3_down_buf|!k3_buf)
								curr_st<=F3_OPEN_DOWN;
							else
								;
						end
					F3_UP:
						begin
							led_open_close<=0;
							led_up<=1;
							led_down<=0;
							dir_flag<=up;
							if(wait_up_cnt==wait_up_time)
								curr_st<=F4;
							else
								;
						end
					F3_DOWN:
						begin
							led_open_close<=0;
							led_down<=1;
							led_up<=0;
							dir_flag<=down;
							if(wait_down_cnt==wait_down_time)
								curr_st<=F2;
							else
								;
						end
				////////////////////////////////////////////////
					F4:
						begin
							led_open_close<=0;
							led_up<=0;
							led_down<=0;
							fl_num<=4;
							if(!k4_down_buf|!k4_buf)
								curr_st<=F4_OPEN_DOWN;
							else if(!k1_up_buf|!k2_up_buf|!k2_down_buf|!k3_up_buf|!k3_down_buf)
								curr_st<=F4_DOWN;
							else if(!k3_buf|!k2_buf|!k1_buf)
								curr_st<=F4_DOWN;
							else
								;
						end
					F4_OPEN_DOWN:
						begin
							led_up<=0;
							led_down<=0;
							led_open_close<=1;
							if(wait_open_close_cnt==wait_open_close_time)
								curr_st<=F4_READY_DOWN;
							else
								;
						end
					F4_READY_DOWN:
						begin
							led_open_close<=0;
							led_up<=0;
							led_down<=0;
							if(!k1_buf|!k2_buf|!k3_buf)
								begin
									curr_st<=F4_DOWN;
									dir_flag<=down;
								end
							else if(!k1_up_buf|!k2_up_buf|!k2_down_buf|!k3_up_buf|!k3_down_buf)
								begin
									curr_st<=F4_DOWN;
									dir_flag<=down;
								end
							else if(!k4_down_buf|!k4_buf)
								curr_st<=F4_OPEN_DOWN;
							else
								;
						end
					F4_DOWN:
						begin
							led_open_close<=0;
							led_down<=1;
							led_up<=0;
							dir_flag<=down;
							if(wait_down_cnt==wait_down_time)
								begin
									curr_st<=F3;
									dir_flag<=down;
								end
							else
								;
						end
					default:;
					endcase
				end
		end
		always@(posedge clk or negedge rst_n)
			begin
				if(!rst_n)
					wait_open_close_cnt<=0;
				else if(curr_st==F1_OPEN_UP|curr_st==F2_OPEN_UP|curr_st==F2_OPEN_DOWN|curr_st==F3_OPEN_UP|curr_st==F3_OPEN_DOWN|curr_st==F4_OPEN_DOWN)
					wait_open_close_cnt<=wait_open_close_cnt+1;
				else
					wait_open_close_cnt<=0;
			end
		always@(posedge clk or negedge rst_n)
			begin
				if(!rst_n)
					wait_up_cnt<=0;
				else if(curr_st==F1_UP|curr_st==F2_UP|curr_st==F3_UP)
					wait_up_cnt<=wait_up_cnt+1;
				else
					wait_up_cnt<=0;
			end
		always@(posedge clk or negedge rst_n)
			begin
				if(!rst_n)
					wait_down_cnt<=0;
				else if(curr_st==F2_DOWN|curr_st==F3_DOWN|curr_st==F4_DOWN)
					wait_down_cnt<=wait_down_cnt+1;
				else
					wait_down_cnt<=0;
			end
endmodule
				
				
	

	
		
	
	       
	        
	        
	        
	        
	        
	        
	
	
	
	
	
	
	
	
	
	
	
	
	
	