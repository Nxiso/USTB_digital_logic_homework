//这是数据处理后发送给数码管显示的模块
module GPU(
input clk3hz,
input clr,
input	disp_data_en,
input	[31:0]	datain,
output [15:0]dataBus
    );
    //移位寄存器
    reg[31:0]msgArray;
    //将要显示的数据存为常数
    //parameter NUMBER=32'h41823205;
    //把移位寄存器的高16位传递给数码管显示模块（四个数码管每个数码管显示四位数据）
    assign dataBus =msgArray[31:16];
    always @ (posedge clk3hz or negedge clr)
        if(!clr)	
			msgArray<=0;
		else if(disp_data_en)
            msgArray<=datain;//NUMBER;
        else begin
        //移位操作：将高四位移动到低四位，同时将27-0位移动到31-4位，这样便实现了一个数据的
            // msgArray[3:0]<=msgArray[31:28];
            // msgArray[31:4]<=msgArray[27:0];
			
			msgArray[31:28]<=msgArray[3:0];
            msgArray[27:0]<=msgArray[31:4];
        end
endmodule