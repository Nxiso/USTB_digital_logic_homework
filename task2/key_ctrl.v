module key_ctrl(
	input		clk,
	input		rst_n,
	input		key_wei,//更改位数的按键，按下加1
	input		key_shuzi,//更改数字的按键，按下加1
	input		key_enter,//确认按键
	input		key_input,//输入模式按键，如果需要输入学号按下该按键，进入输入状态
	input		key_disp,//显示模式按键，按下则循环显示学号
	output	reg	[3:0]	weishu,//输入学号的位数
	output	reg	[3:0]	shuzi=0,//实时输入的数字
	output		[31:0]	disp_data,//需要显示的数字
	output	reg			disp_data_en//当高电平时后四个数码管显示，低电平时前四个数码管显示
);
parameter	IDLE		=4'd0;
parameter	INPUT_ST    =4'd1;
parameter	DISP_ST     =4'd2;
parameter	INPUT_ENTER	=4'd3;
reg	[3:0]	curr_st;
reg	[31:0]	disp_cnt;
reg	[3:0]	shuzi_7=0;//输入第7位的数字
reg	[3:0]	shuzi_6=0;//输入第6位的数字
reg	[3:0]	shuzi_5=0;//输入第5位的数字
reg	[3:0]	shuzi_4=0;//输入第4位的数字
reg	[3:0]	shuzi_3=0;//输入第3位的数字
reg	[3:0]	shuzi_2=0;//输入第2位的数字
reg	[3:0]	shuzi_1=0;//输入第1位的数字
reg	[3:0]	shuzi_0=0;//输入第0位的数字
//assign	disp_data={4'h1,4'h2,4'h3,4'h4,4'h5,4'h6,4'h7,4'h8};
assign	disp_data={shuzi_7,shuzi_6,shuzi_5,shuzi_4,shuzi_3,shuzi_2,shuzi_1,shuzi_0};
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		curr_st<=IDLE;
	end else case(curr_st)
		IDLE:begin
			if(key_input)
				curr_st<=INPUT_ST;
			else if(key_disp)
				curr_st<=DISP_ST;
			else
				;
		end
		INPUT_ST:begin
			if(key_disp)
				curr_st<=DISP_ST;
			else if(key_enter)
				curr_st<=INPUT_ENTER;
			else
				;
		end
		INPUT_ENTER:begin
			curr_st<=IDLE;
		end
		DISP_ST:begin
			if(disp_cnt==50000000)//为了3HZ的时钟域能够检测到
				curr_st<=IDLE;
			else 
				;
		end
		default:;
	endcase
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		disp_cnt<=0;
	else if(curr_st==DISP_ST)
		disp_cnt<=disp_cnt+1;
	else
		disp_cnt<=0;
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		disp_data_en<=0;
	end else if(curr_st==DISP_ST)
		disp_data_en<=1;
	else
		disp_data_en<=0;
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		shuzi<=0;
	end else if(curr_st==IDLE)begin
		shuzi<=0;
	end else if(key_shuzi)begin
		if(shuzi==9)
			shuzi<=0;
		else
			shuzi<=shuzi+1;
	end else ;
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		weishu<=0;
	end else if(curr_st==IDLE)begin
		weishu<=0;
	end else if(key_wei)begin
		if(weishu==7)
			weishu<=0;
		else
			weishu<=weishu+1;
	end else ;
end
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		shuzi_7<=0;//输入第7位的数字
		shuzi_6<=0;//输入第6位的数字
		shuzi_5<=0;//输入第5位的数字
		shuzi_4<=0;//输入第4位的数字
		shuzi_3<=0;//输入第3位的数字
		shuzi_2<=0;//输入第2位的数字
		shuzi_1<=0;//输入第1位的数字
		shuzi_0<=0;//输入第0位的数字
	end else if(curr_st==INPUT_ENTER)begin//当在输入状态时
		case(weishu)
		0:shuzi_0<=shuzi;
		1:shuzi_1<=shuzi;
		2:shuzi_2<=shuzi;
		3:shuzi_3<=shuzi;
		4:shuzi_4<=shuzi;
		5:shuzi_5<=shuzi;
		6:shuzi_6<=shuzi;
		7:shuzi_7<=shuzi;
		default:;
		endcase
	end else ;
end
endmodule
