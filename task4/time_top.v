module time_top(
	input			clk,
	input			rst_n,
	input			key_start,
	input			key_hour_up,//����Сʱ
	input			key_min_up,//���÷���
	input			key_sec_up	,//������
	input			key_enter,
	output 		[3:0] 	pos_f,
	output 		[7:0] 	seg_f,
	output 		[3:0] 	pos_b,
	output 		[7:0] 	seg_b,
	output			led
	);
wire	[7:0]	hour	;
wire	[7:0]	min		;
wire	[7:0]	sec		;
wire	[3:0]	hour_shi;
wire	[3:0]	hour_ge;
wire	[3:0]	min_shi;
wire	[3:0]	min_ge;
wire	[3:0]	sec_shi;
wire	[3:0]	sec_ge;
wire	[15:0]	databus_b;
wire	[15:0]	databus_f;
wire	[7:0]	hour_set	;	
wire	[7:0]	min_set	    ;
wire	[7:0]	sec_set	    ;

assign	hour_shi=hour/10;
assign	hour_ge=hour%10;
assign	min_shi=min/10;
assign	min_ge=min%10;
assign	sec_shi=sec/10;
assign	sec_ge=sec%10;
assign	databus_f={hour_shi,hour_ge,4'd10,min_shi};
assign	databus_b={min_ge,4'd10,sec_shi,sec_ge};
clkDiv U1(clk,clk190hz,clk3hz);
// rst_gen Urst_gen(
	// .clk		(clk),
	// .rst_n		(rst_n)
	// );
key_xd Ukey_xd_hour_up(
	.clk		(clk),
	.rst_n		(rst_n),
	.key_in		(key_hour_up),
	.key_out    (key_hour_up_out)
		);
key_xd Ukey_xd_min_up(
	.clk		(clk),
	.rst_n		(rst_n),
	.key_in		(key_min_up),
	.key_out    (key_min_up_out)
		);
key_xd Ukey_sec_up(
	.clk		(clk),
	.rst_n		(rst_n),
	.key_in		(key_sec_up),
	.key_out    (key_sec_up_out)
		);
key_xd Ukey_enter(
	.clk		(clk),
	.rst_n		(rst_n),
	.key_in		(key_enter),
	.key_out    (key_enter_out)
		);
time_set Utime_set(
	.clk				(clk),
	.rst_n				(rst_n),
	.key_hour_up		(key_hour_up_out),//ʱ����
	.key_min_up			(key_min_up_out ),//�ֵ���
	.key_sec_up			(key_sec_up_out ),
	.key_enter			(key_enter_out),
	.hour_set			(hour_set	),
	.min_set			(min_set	),
	.sec_set		    (sec_set	)
	);
time_calc Utime_calc(
	.clk				(clk),
	.rst_n				(rst_n),
	.key_start			(key_start),
	.key_hour_up		(key_hour_up_out),//ʱ����
	.key_min_up			(key_min_up_out ),//�ֵ���
	.key_sec_up			(key_sec_up_out ),
	.key_enter			(key_enter_out),
	.hour_set			(hour_set	),
	.min_set			(min_set	),
	.sec_set		    (sec_set	),
	.hour				(hour),
	.min				(min),
	.sec    			(sec),
	.led				(led)
	);
segMsg UsegMsg_f(
	.clk190hz		(clk190hz),
	.dataBus		(databus_f), //�������������
	.pos			(pos_f),
	.seg            (seg_f)
    );
segMsg UsegMsg_b(
	.clk190hz		(clk190hz),
	.dataBus		(databus_b), //�������������
	.pos			(pos_b),
	.seg            (seg_b)
    );
endmodule