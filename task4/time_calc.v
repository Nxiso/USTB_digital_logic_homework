module time_calc(
	input				clk				,
	input				rst_n			,
	input				key_start		,
	input				key_hour_up		,//时调整
	input				key_min_up		,//分调整
	input				key_sec_up		,
	input				key_enter		,
	input	[7:0]		hour_set		,
	input	[7:0]		min_set			,
	input	[7:0]		sec_set		    ,
	output	reg	[7:0]	hour			,
	output	reg	[7:0]	min				,
	output	reg	[7:0]	sec				,
	output				led
	);
	//parameter	time_sec=10;
	//for sim
	parameter	IDLE	=4'd0;
	parameter	DJS_ST  =4'd1;//倒计时状态
	parameter	SET_ST  =4'd2;//设置时间状态
	parameter	DJS_OVER=4'd3;
	parameter	time_sec=100000000;
	reg	[31:0]	time_cnt	;
	reg			pulse_sec	;//秒脉冲，一秒产生一个脉冲信号
	reg	[3:0]	curr_st	;
	reg	[3:0]	curr_st_ff1;
	reg	[31:0]	alarm_cnt;
	assign	led=(curr_st==DJS_OVER)?1:0;
	always@(posedge clk)curr_st_ff1<=curr_st;
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			curr_st<=IDLE;
		else case(curr_st)
			IDLE:begin
				if(key_enter)
					curr_st<=DJS_ST;
				else if(key_hour_up||key_min_up||key_sec_up)
					curr_st<=SET_ST;
				else ;
			end
			DJS_ST:begin
					if(hour==0&&min==0&&sec==0&&pulse_sec)
						curr_st<=DJS_OVER;
					else if(key_hour_up||key_min_up||key_sec_up)
						curr_st<=SET_ST;
					else ;
			end
			SET_ST:begin
				if(key_enter)
					curr_st<=DJS_ST;
				else  ;
			end
			DJS_OVER:begin
				if(alarm_cnt==1000)
					curr_st<=IDLE;
				else;
			end
			default:;
		endcase
	end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				alarm_cnt<=0;
			else if(curr_st==DJS_OVER)
				alarm_cnt<=alarm_cnt+1;
			else
				alarm_cnt<=0;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				time_cnt<=0;
			else if(time_cnt==time_sec-1)
				time_cnt<=0;
			else
				time_cnt<=time_cnt+1;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				pulse_sec<=0;
			else if(time_cnt==time_sec-1)
				pulse_sec<=1;
			else
				pulse_sec<=0;
		end
	//秒计数
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				sec<=0;
			else if(curr_st_ff1==SET_ST)
				sec<=sec_set;
			else if(curr_st==DJS_ST)begin
				if(key_start)begin
					if(pulse_sec&&sec==0)
						sec<=59;
					else if(pulse_sec)
						sec<=sec-1;
				end else ;
			end else
				sec<=0;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				min<=0;
			else if(curr_st_ff1==SET_ST)
				min<=min_set;
			else if(curr_st==DJS_ST)begin
				if(pulse_sec&&min==0&&sec==0)
					min<=59;
				else if(pulse_sec&&sec==0)
					min<=min-1;
			end else
				min<=0;
		end
	always@(posedge clk or negedge rst_n)
		begin
			if(!rst_n)
				hour<=0;
			else if(curr_st_ff1==SET_ST)
				hour<=hour_set;
			else if(curr_st==DJS_ST)begin
				if(pulse_sec&&hour==0&&min==0&&sec==0)
					hour<=23;
				else if(pulse_sec&&min==0&&sec==0)
					hour<=hour-1;
			end else
				hour<=0;
		end
endmodule