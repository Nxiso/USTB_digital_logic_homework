//����һ����Ƶģ��
module clkDiv(
input clk100mhz,//100Mhz��ʽ��Ƶ����FPGA��ϵͳʱ��
output clk190hz,//��Ƶ�õ���90hz
output clk3hz//��Ƶ�õ���3hz
    );
    reg[25:0] count=0;//����һ��������
    assign clk190hz = count[18];//���ݼ������ĵ�19λ�仯�����µ�ʱ��
    assign clk3hz = count[25];//���ݼ������ĵ�26λ�仯�����µ�ʱ��
    always@(posedge clk100mhz)
        count<=count+1;
endmodule