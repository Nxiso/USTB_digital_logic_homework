//
module segMsg(
input clk190hz,
input [15:0] dataBus, //�������������
output reg [3:0] pos,
output reg[7:0]seg
    );
    reg[1:0]posC=0;//����ܼ�����
    reg[3:0]dataP=0;//���ݵ�һ����
    always@(posedge clk190hz)begin
        case(posC)
        //���������ߵ�3��0λ��ʾ�ڵ�һ���������
        0:begin
            pos<=4'b0001;
            dataP<=dataBus[3:0];
          end
        //���������ߵ�7��4λ��ʾ�ڵڶ����������
        1:begin
            pos<=4'b0010;
            dataP<=dataBus[7:4];
          end          
        //���������ߵ�11��8λ��ʾ�ڵ������������
          2:begin
              pos<=4'b0100;
              dataP<=dataBus[11:8];
            end
        //���������ߵ�15��12λ��ʾ�ڵ��ĸ��������
            3:begin
                pos<=4'b1000;
                dataP<=dataBus[15:12];
              end
        endcase
        posC=posC+1;
end
//������������������ܵ�ÿһ�Σ�����ȡ��0-9ʮ�������������������ʾ��
always@(dataP)
    case(dataP)
        0:seg=8'b0011_1111;
        1:seg=8'b0000_0110;
        2:seg=8'b0101_1011;
        3:seg=8'b0100_1111;
        4:seg=8'b0110_0110;
        5:seg=8'b0110_1101;
        6:seg=8'b0111_1101;
        7:seg=8'b0000_0111;
        8:seg=8'b0111_1111;
        9:seg=8'b0110_1111;
		
        10:seg=8'b0011_1110;//"U"����
        11:seg=8'b0101_1110;//"d"����
		12:seg=8'b0100_0000;//"-"ֹͣ
		13:seg=8'b0111_0011;//"p"����
		14:seg=8'b0011_1001;//"C"����
        default:seg=8'b0000_1000;
     endcase  
endmodule
