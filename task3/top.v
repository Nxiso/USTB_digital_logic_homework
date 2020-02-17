//这是顶层模块
module top(
input 				clk100mhz,
input 				clr,
input				key_rd,//高电平读SRAM
input				key_wei,//更改位数是按键，按下加1
input				key_shuzi,//更改数字的按键，按下加1
input				key_enter,//确认按键
input				key_input,//输入模式按键，如果需要输入学号按下该按键，进入输入状态
input				key_disp,//显示模式按键，学号写入SRAM
output 		[3:0] 	pos_f,
output 		[7:0] 	seg_f,
output 		[3:0] 	pos_b,
output 		[7:0] 	seg_b,

output				sram_we_n,
output				sram_oe_n,
output				sram_ce_n,
output				sram_ub_n,
output				sram_lb_n,
inout		[15:0]		sram_data,
output		[18:0]		sram_addr

    );
    /*顶层连接线：
        clk190hz:将分频模块的190hz信号连接到数码管显示模块
        clk3hz:将分频模块的3
        hz信号连接到处理显示GPU模块
        dataBus：将处理模块处理后的数据连接到数码管显示模块
        */
    wire clk190hz,clk3hz;
    wire 	[15:0]	dataBus_f;
	wire	[3:0]	pos_f_tmp;//前四个数码管
	wire	[15:0]	dataBus_b;
	wire	[3:0]	pos_b_tmp;//后四个数码管
	wire	[31:0]	disp_data;
	wire	[31:0]	disp_data_b;
	wire	[3:0]	shuzi;
	wire	[3:0]	weishu;
	wire			disp_data_en;
	wire	[31:0]	disp_data_out;
	reg				key_rd_ff1;
	reg				key_rd_ff2;
	assign	dataBus_f={weishu,4'h0,shuzi,4'h0};
	//assign	dataBus_b={4'h5,4'h6,4'h7,4'h8};
	assign	pos_f={pos_f_tmp[3],1'b0,pos_f_tmp[1],1'b0};
	assign	pos_b={pos_b_tmp[0],pos_b_tmp[1],pos_b_tmp[2],pos_b_tmp[3]};
	always@(posedge clk3hz)key_rd_ff1<=key_rd;
	always@(posedge clk3hz)key_rd_ff2<=key_rd_ff1;
	assign	key_rd_rise=key_rd_ff1&(key_rd_ff2==0);
    //例化三个子模块，并将他们连接
	
	clkDiv U1(clk100mhz,clk190hz,clk3hz,clk10m);
	key_xd Ukey_wei_xd(
	.clk			(clk10m),
	.rst_n			(clr),
	.key_in			(key_wei),
	.key_out        (key_wei_out)
		);
	key_xd Ukey_enter_xd(
	.clk			(clk10m),
	.rst_n			(clr),
	.key_in			(key_enter),
	.key_out        (key_enter_out)
		);
	key_xd Ukey_input_xd(
	.clk			(clk10m),
	.rst_n			(clr),
	.key_in			(key_input),
	.key_out        (key_input_out)
		);
	key_xd Ukey_shuzi_xd(
	.clk			(clk10m),
	.rst_n			(clr),
	.key_in			(key_shuzi),
	.key_out        (key_shuzi_out)
		);
	key_xd Ukey_disp_xd(
	.clk			(clk10m),
	.rst_n			(clr),
	.key_in			(key_disp),
	.key_out        (key_disp_out)
		);
	key_ctrl Ukey_ctrl(
	.clk			(clk10m),
	.rst_n			(clr),
	.key_wei		(key_wei_out	),//更改位数是按键，按下加1
	.key_shuzi		(key_shuzi_out	),//更改数字的按键，按下加1
	.key_enter		(key_enter_out	),//确认按键
	.key_input		(key_input_out	),//输入模式按键，如果需要输入学号按下该按键，进入输入状态
	.key_disp		(key_disp_out	),//显示模式按键，按下则循环显示学号
	.weishu			(weishu),//输入学号的位数
	.shuzi			(shuzi),//实时输入的数字
	.disp_data		(disp_data_b),//需要显示的数字
	.disp_data_en	(disp_data_en)//当高电平时后四个数码管显示，低电平时前四个数码管显示
);
	SRAM USRAM(
	.ctr_r			(key_rd_rise),
	.ctr_w			(key_disp_out),
	.clk			(clk10m),
	.data_in		(disp_data_b),
	.databus		(sram_data),
	.addrbus		(sram_addr),
	.data_out		(disp_data_out),
	.data_out_vld	(data_out_vld),
	.we				(sram_we_n),
	.oe				(sram_oe_n),
	.ce				(sram_ce_n),
	.ub				(sram_ub_n),
	.lb				(sram_lb_n)
	);
    GPU UGPU(
	.clk3hz			(clk3hz),
	.clr			(clr),
	.disp_data_en	(data_out_vld),
	.datain			(disp_data_out),
	.dataBus    	(dataBus_b)
    );
	segMsg UsegMsg_f(
	.clk190hz		(clk190hz),
	.dataBus		(dataBus_f), //输入的数据总线
	.pos			(pos_f_tmp),
	.seg            (seg_f)
    );
	segMsg UsegMsg_b(
	.clk190hz		(clk190hz),
	.dataBus		(dataBus_b), //输入的数据总线
	.pos			(pos_b_tmp),
	.seg            (seg_b)
    );
endmodule