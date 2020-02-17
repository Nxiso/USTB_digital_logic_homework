module SRAM(
	input	ctr_r,
	input	ctr_w,
	input	clk,
	input	[31:0]	data_in,
	inout	[15:0]	databus,
	output	reg	[18:0]	addrbus=0,
	output	reg	[31:0]	data_out=0,
	output	reg			data_out_vld=0,
	output	reg			we=1,
	output	reg			oe=1,
	output	reg			ce=1,
	output	reg			ub=0,
	output	reg			lb=0
	);
	parameter	IDLE	=3'd0;
	parameter	WR0_ST  =3'd1;
	parameter	RD0_ST  =3'd2;
	parameter	WR1_ST  =3'd3;
	parameter	RD1_ST  =3'd4;
	parameter	RD_WAIT =3'd5;
	parameter	WR_WAIT	=3'd6;
	parameter	RD0_WAIT=3'd7;
	reg	[15:0]	databus_in=0;
	reg	[15:0]	databus_in_ff1=0;
	reg	[31:0]	databus_out=0;
	reg			ctl_a=0;
	reg	[15:0]	ctl_w1=0;
	reg	[15:0]	ctl_r1=0;
	reg	[2:0]	curr_st=0;
	reg	[2:0]	curr_st_ff1=0;
	reg	[31:0]	data_out_tmp=0;
	reg	[31:0]	rd_wait_cnt=0;
	reg	[15:0]	wr_wait=0;
	assign	databus=(curr_st_ff1==WR0_ST||curr_st_ff1==WR1_ST)?databus_in_ff1:16'hzzzz;
	always@(posedge clk)curr_st_ff1<=curr_st;
	always@(posedge clk)databus_in_ff1<=databus_in;
	always@(posedge clk)begin
		case(curr_st)
			IDLE:begin
				if(ctr_w)
					curr_st<=WR0_ST;
				else if(ctr_r)
					curr_st<=RD0_ST;
				else
					;
			end
			WR0_ST:curr_st<=WR_WAIT;//WR1_ST;
			WR_WAIT:begin
				if(wr_wait==50000)
					curr_st<=WR1_ST;
				else
					;
			end
			RD0_ST:curr_st<=RD0_WAIT;
			WR1_ST:curr_st<=IDLE;
			RD0_WAIT:begin
				if(wr_wait==50000)
					curr_st<=RD1_ST;
				else
					;
			end
			RD1_ST:curr_st<=RD_WAIT;
			RD_WAIT:begin
				if(ctr_r==0&&rd_wait_cnt==10000000)
					curr_st<=IDLE;
				else
					;
			end
			default:;
		endcase
	end
	always@(posedge clk)begin
		if(curr_st==WR_WAIT||curr_st==RD0_WAIT)
			wr_wait<=wr_wait+1;
		else
			wr_wait<=0;
	end
	always@(posedge clk)begin
		if(curr_st==RD_WAIT)
			rd_wait_cnt<=rd_wait_cnt+1;
		else
			rd_wait_cnt<=0;
	end
	always@(posedge clk)begin
		if(curr_st==WR0_ST)begin
			we<=0;
			oe<=1;
			ce<=0;ub<=0;lb<=0;
			addrbus<=0;
			databus_in[15:0]<=data_in[15:0];
		end else if(curr_st==WR1_ST)begin
			we<=0;
			oe<=1;
			ce<=0;ub<=0;lb<=0;
			addrbus<=1;
			databus_in[15:0]<=data_in[31:16];
		end else if(curr_st==RD0_ST)begin
			we<=1;
			oe<=0;
			ce<=0;ub<=0;lb<=0;
			addrbus<=0;
			data_out_tmp[15:0]<=databus[15:0];
		end else if(curr_st==RD1_ST)begin
			we<=1;
			oe<=0;
			ce<=0;ub<=0;lb<=0;
			addrbus<=1;
			data_out_tmp[31:16]<=databus[15:0];
		end else begin
			we<=1;
			oe<=1;
		end
	end
	always@(posedge clk)begin
		if(curr_st==RD_WAIT)begin
			data_out_vld<=1;
			data_out<=data_out_tmp;
		end else
			data_out_vld<=0;
	end
endmodule