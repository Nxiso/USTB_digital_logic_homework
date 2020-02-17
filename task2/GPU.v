//�������ݴ�����͸��������ʾ��ģ��
module GPU(
input clk3hz,
input clr,
input	disp_data_en,
input	[31:0]	datain,
output [15:0]dataBus
    );
    //��λ�Ĵ���
    reg[31:0]msgArray;
    //��Ҫ��ʾ�����ݴ�Ϊ����
    //parameter NUMBER=32'h41823205;
    //����λ�Ĵ����ĸ�16λ���ݸ��������ʾģ�飨�ĸ������ÿ���������ʾ��λ���ݣ�
    assign dataBus =msgArray[31:16];
    always @ (posedge clk3hz or negedge clr)
        if(!clr)	
			msgArray<=0;
		else if(disp_data_en)
            msgArray<=datain;//NUMBER;
        else begin
        //��λ������������λ�ƶ�������λ��ͬʱ��27-0λ�ƶ���31-4λ��������ʵ����һ�����ݵ�
            // msgArray[3:0]<=msgArray[31:28];
            // msgArray[31:4]<=msgArray[27:0];
			
			msgArray[31:28]<=msgArray[3:0];
            msgArray[27:0]<=msgArray[31:4];
        end
endmodule