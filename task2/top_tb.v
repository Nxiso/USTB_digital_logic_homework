`timescale 1ns/1ps
module top_tb;
	reg				clk		;	
	reg				rst_n	=0;
	reg	[31:0]		cnt=0		;
	reg				key_wei		=1;
	reg				key_shuzi	=1;
	reg				key_enter	=1;
	reg				key_input	=1;
	reg				key_disp	=1;
	wire[7:0]		pos;
	wire[7:0]		seg;
// initial
		// begin
			// $fsdbDumpfile("wave.fsdb")	;
			// $fsdbDumpvars				;
		// end

initial
begin
	clk = 0;
	#1000
	rst_n=1;
end
always #10 clk<=~clk;
always@(posedge clk)cnt<=cnt+1;
always@(posedge clk)begin if(cnt<=100000&&cnt> 50000)key_input<=1; else key_input<=0;end
always@(posedge clk)begin if(cnt<=200000&&cnt>150000)key_wei<=1;else key_wei<=0;end
always@(posedge clk)begin if(cnt<=400000&&cnt>350000)key_shuzi<=1; else key_shuzi<=0;end
always@(posedge clk)begin if(cnt<=500000&&cnt>450000)key_enter<=1; else key_enter<=0;end
always@(posedge clk)begin if(cnt<=600000&&cnt>550000)key_disp<=1; else key_disp<=0;end
top Utop(
.clk100mhz	(clk),
.clr		(rst_n),
.key_wei	(key_wei	),//����λ���ǰ��������¼�1
.key_shuzi	(key_shuzi	),//�������ֵİ��������¼�1
.key_enter	(key_enter	),//ȷ�ϰ���
.key_input	(key_input	),//����ģʽ�����������Ҫ����ѧ�Ű��¸ð�������������״̬
.key_disp	(key_disp	),//��ʾģʽ������������ѭ����ʾѧ��
.pos_b		(),
.seg_b      (),
.pos_f		(),
.seg_f      ()
    );
endmodule
