//这是一个分频模块
module clkDiv(
input clk100mhz,//100Mhz的式中频率是FPGA的系统时钟
output clk190hz,//分频得到的90hz
output clk3hz,//分频得到的3hz
output	reg	clk10m=0
    );
	reg	[2:0]	cnt=0;
    reg[25:0] count=0;//定义一个计数器
    assign clk190hz = count[18];//根据计数器的第19位变化产生新的时钟
    assign clk3hz = count[25];//根据计数器的第26位变化产生新的时钟
	
	// reg[15:0] count=0;//定义一个计数器
    // assign clk190hz = count[8];//根据计数器的第19位变化产生新的时钟
    // assign clk3hz = count[15];//根据计数器的第26位变化产生新的时钟
	
    always@(posedge clk100mhz)
        count<=count+1;
	always@(posedge clk100mhz)
		begin
			if(cnt==4)
				cnt<=0;
			else
				cnt<=cnt+1;
		end
	always@(posedge clk100mhz)
		begin
			if(cnt==4)
				clk10m<=~clk10m;
			else
				;
		end
endmodule