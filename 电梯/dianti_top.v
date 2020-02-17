module dianti_top(
	input 		clk100mhz,
	input 		rst_n,
	input 		kin1			,//1¥���������뿪��
	input 		kin2			,//2¥���������뿪��
	input 		kin3			,//3¥���������뿪��
	input 		kin4			,//4¥���������뿪��
	input 		kin1_up			,//1¥UP������Ϊ1¥�����¥������û��DOWN�������뿪��
	input 		kin2_up			,//2¥UP�������뿪��
	input 		kin2_down		,//2¥DOWN�������뿪��
	input 		kin3_up			,//3¥UP�������뿪��
	input 		kin3_down		,//3¥DOWN�����ᴥ����
	input 		kin4_down		,//4¥DOWN��,��Ϊ4¥���¥������û��UP�����ᴥ����
	output	reg	[7:0]	led		,
	output  [3:0] 	pos			,
	output 	[7:0]	seg	
	);
	reg	kin1_ff1,kin1_ff2;
	reg	kin2_ff1,kin2_ff2;
	reg	kin3_ff1,kin3_ff2;
	reg	kin4_ff1,kin4_ff2;
	reg	kin1_up_ff1,kin1_up_ff2;
	reg	kin2_up_ff1,kin2_up_ff2;
	reg	kin2_down_ff1,kin2_down_ff2;
	reg	kin3_up_ff1,kin3_up_ff2;
	reg	kin3_down_ff1,kin3_down_ff2;
	reg	kin4_down_ff1,kin4_down_ff2;
	wire	clk190hz;
	wire	[15:0]	dataBus;
	wire	[7:0]	curr_st	;
	wire	[7:0]	fl_num	;
	reg		[3:0]	run_state;
	reg		[3:0]	door_state;
	wire			led_close_1;
	wire			led_open_1;
	wire			led_up_1;
	wire			led_down_1;
	wire			kin1_1			;	
	wire			kin2_1		    ;
	wire			kin3_1		    ;
	wire			kin4_1		    ;
	wire			kin1_up_1	    ;
	wire			kin2_up_1	    ;
	wire			kin2_down_1	    ;
	wire			kin3_up_1	    ;
	wire			kin3_down_1	    ;
	wire			kin4_down_1	    ;
	
	
	clkDiv U1(clk100mhz,clk190hz,clk3hz);
	always@(posedge clk190hz)kin1_ff1<=kin1;
	always@(posedge clk190hz)kin1_ff2<=kin1_ff1;
	always@(posedge clk190hz)kin2_ff1<=kin2;
	always@(posedge clk190hz)kin2_ff2<=kin2_ff1;
	always@(posedge clk190hz)kin3_ff1<=kin3;
	always@(posedge clk190hz)kin3_ff2<=kin3_ff1;
	always@(posedge clk190hz)kin4_ff1<=kin4;
	always@(posedge clk190hz)kin4_ff2<=kin4_ff1;
	always@(posedge clk190hz)kin1_up_ff1<=kin1_up;
	always@(posedge clk190hz)kin1_up_ff2<=kin1_up_ff1;
	always@(posedge clk190hz)kin2_up_ff1<=kin2_up;
	always@(posedge clk190hz)kin2_up_ff2<=kin2_up_ff1;
	always@(posedge clk190hz)kin2_down_ff1<=kin2_down;
	always@(posedge clk190hz)kin2_down_ff2<=kin2_down_ff1;
	always@(posedge clk190hz)kin3_up_ff1<=kin3_up;
	always@(posedge clk190hz)kin3_up_ff2<=kin3_up_ff1;
	always@(posedge clk190hz)kin3_down_ff1<=kin3_down;
	always@(posedge clk190hz)kin3_down_ff2<=kin3_down_ff1;
	always@(posedge clk190hz)kin4_down_ff1<=kin4_down;
	always@(posedge clk190hz)kin4_down_ff2<=kin4_down_ff1;
	assign	kin1_1		=(kin1_ff2!=kin1_ff1)?1:0;
	assign	kin2_1		=(kin2_ff2!=kin2_ff1)?1:0;
	assign	kin3_1		=(kin3_ff2!=kin3_ff1)?1:0;
	assign	kin4_1		=(kin4_ff2!=kin4_ff1)?1:0;
	assign	kin1_up_1	=(kin1_up_ff2!=kin1_up_ff1)?1:0;
	assign	kin2_up_1	=(kin2_up_ff2!=kin2_up_ff1)?1:0;
	assign	kin2_down_1	=(kin2_down_ff2!=kin2_down_ff1)?1:0;
	assign	kin3_up_1	=(kin3_up_ff2!=kin3_up_ff1)?1:0;
	assign	kin3_down_1	=kin3_down_ff2;
	assign	kin4_down_1	=kin4_down_ff2;
	assign	dataBus={fl_num[3:0],run_state,curr_st[3:0],door_state};
	reg	[3:0]	led_st=0;
	parameter	IDLE	=4'd0;
	parameter	LED_F1  =4'd1;
	parameter	LED_F2  =4'd2;
	parameter	LED_F3  =4'd3;
	parameter	LED_F4  =4'd4;
	always@(posedge clk190hz)begin
		if(led_up_1)
			run_state<=10;
		else if(led_down_1)
			run_state<=11;
		else
			run_state<=12;
	end
	always@(posedge clk190hz)begin
		if(led_open_1)
			door_state<=13;
		else if(led_close_1)
			door_state<=14;
		else
			;
	end
	always@(posedge clk190hz)begin
		case(led_st)
			IDLE:begin
				if(kin2_1||kin2_up_1||kin2_down_1)
					led_st<=LED_F2;
				if(kin3_1||kin3_up_1||kin3_down_1)
					led_st<=LED_F3;
				if(kin1_1||kin1_up_1)
					led_st<=LED_F1;
				if(kin4_1||kin4_down_1)
					led_st<=LED_F4;
			end
			LED_F2:begin
				if(fl_num==2)
					led_st<=IDLE;
				else
					;
			end
			LED_F3:begin
				if(fl_num==3)
					led_st<=IDLE;
				else
					;
			end
			LED_F4:begin
				if(fl_num==4)
					led_st<=IDLE;
				else
					;
			end
			default:;
		endcase
	end
	always@(posedge clk190hz)begin
		if(led_st==IDLE)
			led<=8'h00;
		else
			led<=8'hff;
	end
		
	// always@(posedge clk190hz)begin
		// if(fl_num==1)
			// begin
				// if(kin2_1||kin3_1||kin4_1||kin2_up_1||kin3_up_1||kin2_down_1||kin3_down_1||kin4_down_1)
					// led<=8'hff;
				// else if(kin1_1||kin1_up_1)
					// led<=8'h00;
				// else
					// ;
			// end
		// else if(fl_num==2)
			// begin
				// if(kin1_1||kin3_1||kin4_1||kin1_up_1||kin3_up_1||kin3_down_1||kin4_down_1)
					// led<=8'hff;
				// else if(kin2_1||kin2_up_1||kin2_down_1)
					// led<=8'h00;
				// else
					// ;
			// end
		// else if(fl_num==3)
			// begin
				// if(kin1_1||kin2_1||kin4_1||kin1_up_1||kin2_up_1||kin2_down_1||kin4_down_1)
					// led<=8'hff;
				// else if(kin3_1||kin3_up_1||kin3_down_1)
					// led<=8'h00;
				// else
					// ;
			// end
		// else if(fl_num==4)
			// begin
				// if(kin1_1||kin3_1||kin2_1||kin1_up_1||kin2_up_1||kin2_down_1||kin3_up_1||kin3_down_1)
					// led<=8'hff;
				// else if(kin4_1||kin4_down_1)
					// led<=8'h00;
				// else
					// ;
			// end
		// else
			// ;
	// end
dianti Udianti_1(
	.clk		(clk190hz),
	.rst_n		(~rst_n),
	.kin1		(kin1_1		),//1¥����
	.kin2		(kin2_1		),//2¥����
	.kin3		(kin3_1		),//3¥����
	.kin4		(kin4_1		),//4¥����
	.kin1_up	(kin1_up_1	),//1¥UP������Ϊ1¥�����¥������û��DOWN��
	.kin2_up	(kin2_up_1	),//2¥UP��
	.kin2_down	(kin2_down_1),//2¥DOWN��
	.kin3_up	(kin3_up_1	),//3¥UP��
	.kin3_down	(kin3_down_1),//3¥DOWN��
	.kin4_down	(kin4_down_1),//4¥DOWN��,��Ϊ4¥���¥������û��UP��
	.led_up		(led_up_1	),//������UPָʾ��
	.led_down	(led_down_1	),//������DOWNָʾ��
	.led_open	(led_open_1	),//���ݿ���ָʾ��
	.led_close	(led_close_1),//���ݹ���ָʾ��
	.led1_up	(led1_up_1	),//1¥UP����ָʾ��
	.led1_down	(led1_down_1),
	.led2_up	(led2_up_1	),//2¥UP����ָʾ��
	.led2_down	(led2_down_1),//2¥DOWN����ָʾ��
	.led3_up	(led3_up_1	),//3¥UP����ָʾ��
	.led3_down	(led3_down_1),//3¥DOWN����ָʾ��
	.led4_up	(led4_up_1	),
	.led4_down	(led4_down_1),//4¥DOWN����ָʾ��
	.curr_st	(curr_st	),
	.fl_num		(fl_num		)
	);
	segMsg UsegMsg(
	.clk190hz		(clk190hz),
	.dataBus		(dataBus), //�������������
	.pos			(pos),
	.seg            (seg)
    );
endmodule