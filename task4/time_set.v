module time_set(
	input				clk				,
	input				rst_n			,
	input				key_hour_up		,//时调整
	input				key_min_up		,//分调整
	input				key_sec_up		,
	input				key_enter		,
	output	reg	[7:0]	hour_set		,
	output	reg	[7:0]	min_set			,
	output	reg	[7:0]	sec_set		
	);
	reg	[7:0]	hour_set_tmp;
	reg	[7:0]	min_set_tmp;
	reg	[7:0]	sec_set_tmp;
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			sec_set_tmp<=0;
		end else if(key_sec_up)begin
			if(sec_set_tmp==59)
				sec_set_tmp<=0;
			else
				sec_set_tmp<=sec_set_tmp+1;
		end else ;
	end
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			min_set_tmp<=0;
		end else if(key_min_up)begin
			if(min_set_tmp==59)
				min_set_tmp<=0;
			else
				min_set_tmp<=min_set_tmp+1;
		end else ;
	end
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			hour_set_tmp<=0;
		end else if(key_hour_up)begin
			if(hour_set_tmp==23)
				hour_set_tmp<=0;
			else
				hour_set_tmp<=hour_set_tmp+1;
		end else ;
	end
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			hour_set		<=0;
			min_set			<=0;
			sec_set		    <=0;
		end else if(key_enter)begin
			hour_set		<=hour_set_tmp;
			min_set			<=min_set_tmp	;
			sec_set		    <=sec_set_tmp	;
		end else ;
	end
		
endmodule