//���Ƕ���ģ��
module top(
input 				clk100mhz,
input 				clr,
input				key_wei,//����λ���ǰ��������¼�1
input				key_shuzi,//�������ֵİ��������¼�1
input				key_enter,//ȷ�ϰ���
input				key_input,//����ģʽ�����������Ҫ����ѧ�Ű��¸ð�������������״̬
input				key_disp,//��ʾģʽ������������ѭ����ʾѧ��
output 		[3:0] 	pos_f,
output 		[7:0] 	seg_f,
output 		[3:0] 	pos_b,
output 		[7:0] 	seg_b
    );
    /*���������ߣ�
        clk190hz:����Ƶģ���190hz�ź����ӵ��������ʾģ��
        clk3hz:����Ƶģ���3
        hz�ź����ӵ�������ʾGPUģ��
        dataBus��������ģ�鴦�����������ӵ��������ʾģ��
        */
    wire clk190hz,clk3hz;
    wire 	[15:0]	dataBus_f;
	wire	[3:0]	pos_f_tmp;//ǰ�ĸ������
	wire	[15:0]	dataBus_b;
	wire	[3:0]	pos_b_tmp;//���ĸ������
	wire	[31:0]	disp_data;
	wire	[31:0]	disp_data_b;
	wire	[3:0]	shuzi;
	wire	[3:0]	weishu;
	wire			disp_data_en;
	assign	dataBus_f={weishu,4'h0,shuzi,4'h0};
	//assign	dataBus_b={4'h5,4'h6,4'h7,4'h8};
	assign	pos_f={pos_f_tmp[3],1'b0,pos_f_tmp[1],1'b0};
	assign	pos_b={pos_b_tmp[0],pos_b_tmp[1],pos_b_tmp[2],pos_b_tmp[3]};
    //����������ģ�飬������������
	clkDiv U1(clk100mhz,clk190hz,clk3hz);
	key_xd Ukey_wei_xd(
	.clk			(clk100mhz),
	.rst_n			(clr),
	.key_in			(key_wei),
	.key_out        (key_wei_out)
		);
	key_xd Ukey_enter_xd(
	.clk			(clk100mhz),
	.rst_n			(clr),
	.key_in			(key_enter),
	.key_out        (key_enter_out)
		);
	key_xd Ukey_input_xd(
	.clk			(clk100mhz),
	.rst_n			(clr),
	.key_in			(key_input),
	.key_out        (key_input_out)
		);
	key_xd Ukey_shuzi_xd(
	.clk			(clk100mhz),
	.rst_n			(clr),
	.key_in			(key_shuzi),
	.key_out        (key_shuzi_out)
		);
	key_xd Ukey_disp_xd(
	.clk			(clk100mhz),
	.rst_n			(clr),
	.key_in			(key_disp),
	.key_out        (key_disp_out)
		);
	key_ctrl Ukey_ctrl(
	.clk			(clk100mhz),
	.rst_n			(clr),
	.key_wei		(key_wei_out	),//����λ���ǰ��������¼�1
	.key_shuzi		(key_shuzi_out	),//�������ֵİ��������¼�1
	.key_enter		(key_enter_out	),//ȷ�ϰ���
	.key_input		(key_input_out	),//����ģʽ�����������Ҫ����ѧ�Ű��¸ð�������������״̬
	.key_disp		(key_disp_out	),//��ʾģʽ������������ѭ����ʾѧ��
	.weishu			(weishu),//����ѧ�ŵ�λ��
	.shuzi			(shuzi),//ʵʱ���������
	.disp_data		(disp_data_b),//��Ҫ��ʾ������
	.disp_data_en	(disp_data_en)//���ߵ�ƽʱ���ĸ��������ʾ���͵�ƽʱǰ�ĸ��������ʾ
);
    GPU UGPU(
	.clk3hz			(clk3hz),
	.clr			(clr),
	.disp_data_en	(disp_data_en),
	.datain			(disp_data_b),
	.dataBus    	(dataBus_b)
    );
	segMsg UsegMsg_f(
	.clk190hz		(clk190hz),
	.dataBus		(dataBus_f), //�������������
	.pos			(pos_f_tmp),
	.seg            (seg_f)
    );
	segMsg UsegMsg_b(
	.clk190hz		(clk190hz),
	.dataBus		(dataBus_b), //�������������
	.pos			(pos_b_tmp),
	.seg            (seg_b)
    );
endmodule