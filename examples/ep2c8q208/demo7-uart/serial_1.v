/*
本模块的功能是验证实现和PC机进行基本的串口通信的功能。需要在PC机上安装一个串口调试工具来验证程序的功能。
程序实现了一个收发一帧10个bit（即无奇偶校验位）的串口控制器，10个bit是1位起始位，8个数据位，1个结束位。
串口的波特律由程序中定义的div_par参数决定，更改该参数可以实现相应的波特率。程序当前设定的div_par 的值
是0x145，对应的波特率是9600。用一个8倍波特率的时钟将发送或接受每一位bit的周期时间划分为8个时隙以使通
信同步.

程序的基本工作过程是，按动一个按键key1 控制器向PC的串口发送“welcome"，
PC机接收后显示验证数据是否正确（串口调试工具设成按ASCII码接受方式）.
PC可随时向FPGA发送0-F的十六进制数据，FPGA接受后显示在7段数码管上.
*/
module serial_1(clk,rst,rxd,txd,en,seg_data,key_input);

input clk,rst;
input rxd;//串行数据接收端
input key_input;//按键输入

output[7:0] en;
output[7:0] seg_data;
reg[7:0] seg_data;
output txd;//串行数据发送端

////////////////////inner reg////////////////////
reg[15:0] div_reg;//分频计数器，分频值由波特率决定。分频后得到频率8倍波特率的时钟
reg[2:0]  div8_tras_reg;//该寄存器的计数值对应发送时当前位于的时隙数
reg[2:0]  div8_rec_reg;//该寄存器的计数值对应接收时当前位于的时隙数
reg[3:0] state_tras;//发送状态寄存器
reg[3:0] state_rec;//接受状态寄存器
reg clkbaud_tras;//以波特率为频率的发送使能信号
reg clkbaud_rec;//以波特率为频率的接受使能信号
reg clkbaud8x;//以8倍波特率为频率的时钟，它的作用是将发送或接受一个bit的时钟周期分为8个时隙

reg recstart;//开始发送标志
reg recstart_tmp;

reg trasstart;//开始接受标志

reg rxd_reg1;//接收寄存器1
reg rxd_reg2;//接收寄存器2，因为接收数据为异步信号，故用两级缓存
reg txd_reg;//发送寄存器
reg[7:0] rxd_buf;//接受数据缓存
reg[7:0] txd_buf;//发送数据缓存

reg[2:0] send_state;//每次按键给PC发送"Welcome"字符串，这是发送状态寄存器
reg[19:0] cnt_delay;//延时去抖计数器
reg start_delaycnt;//开始延时计数标志
reg key_entry1,key_entry2;//确定有键按下标志

////////////////////////////////////////////////
parameter div_par=16'h145;//分频参数，其值由对应的波特率计算而得，按此参数分频的时钟频率是波倍特率的8	
		  //倍，此处值对应9600的波特率，即分频出的时钟频率是9600*8  (CLK  50M)

////////////////////////////////////////////////
assign txd=txd_reg;

assign en=0;//7段数码管使能信号赋值

always@(posedge clk )
begin
	if(!rst) begin 
		cnt_delay<=0;
		start_delaycnt<=0;
	 end
	else if(start_delaycnt) begin
		if(cnt_delay!=20'd800000) begin
			cnt_delay<=cnt_delay+1;
		 end
		else begin
			cnt_delay<=0;
			start_delaycnt<=0;
		 end
	 end
	else begin
		if(!key_input&&cnt_delay==0)
				start_delaycnt<=1;
	 end
end

always@(posedge clk)
begin
	if(!rst) 
		key_entry1<=0;
	else begin
		if(key_entry2)
			key_entry1<=0;
		else if(cnt_delay==20'd800000) begin
			if(!key_input)
				key_entry1<=1;
		 end
	 end
end

always@(posedge clk )
begin
	if(!rst)
		div_reg<=0;
	else begin
		if(div_reg==div_par-1)
			div_reg<=0;
		else
			div_reg<=div_reg+1;
	 end
end

always@(posedge clk)//分频得到8倍波特率的时钟
begin
	if(!rst)
		clkbaud8x<=0;
	else if(div_reg==div_par-1)
		clkbaud8x<=~clkbaud8x;
end


always@(posedge clkbaud8x or negedge rst)
begin
	if(!rst)
		div8_rec_reg<=0;
	else if(recstart)//接收开始标志
		div8_rec_reg<=div8_rec_reg+1;//接收开始后，时隙数在8倍波特率的时钟下加1循环
end

always@(posedge clkbaud8x or negedge rst)
begin
	if(!rst)
		div8_tras_reg<=0;
	else if(trasstart)
		div8_tras_reg<=div8_tras_reg+1;//发送开始后，时隙数在8倍波特率的时钟下加1循环
end

always@(div8_rec_reg)
begin
	if(div8_rec_reg==7)
		clkbaud_rec=1;//在第7个时隙，接收使能信号有效，将数据打入
	else
		clkbaud_rec=0;
end

always@(div8_tras_reg)
begin
	if(div8_tras_reg==7)
		clkbaud_tras=1;//在第7个时隙，发送使能信号有效，将数据发出
	else
		clkbaud_tras=0;
end

always@(posedge clkbaud8x or negedge rst)
begin
	if(!rst) begin
		txd_reg<=1;
		trasstart<=0;
		txd_buf<=0;
		state_tras<=0;
		send_state<=0;
		key_entry2<=0;
	 end
	else begin
		if(!key_entry2) begin
			if(key_entry1) begin
				key_entry2<=1;
				txd_buf<=8'd119; //"w"
			 end
		 end
		else  begin
			case(state_tras)
				4'b0000: begin  //发送起始位
					if(!trasstart&&send_state<7) 
						trasstart<=1;
					else if(send_state<7) begin
						if(clkbaud_tras) begin
							txd_reg<=0;
							state_tras<=state_tras+1;
						 end
					 end
					else begin
						key_entry2<=0;
						state_tras<=0;
					 end					
				end		
				4'b0001: begin //发送第1位
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0010: begin //发送第2位
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				 4'b0011: begin //发送第3位
				 	if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0100: begin //发送第4位
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0101: begin //发送第5位
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0110: begin //发送第6位
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b0111: begin //发送第7位
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b1000: begin //发送第8位
					if(clkbaud_tras) begin
						txd_reg<=txd_buf[0];
						txd_buf[6:0]<=txd_buf[7:1];
						state_tras<=state_tras+1;
					 end
				 end
				4'b1001: begin //发送停止位
					if(clkbaud_tras) begin
						txd_reg<=1;
						txd_buf<=8'h55;
						state_tras<=state_tras+1;
					 end
				 end
				4'b1111:begin 
					if(clkbaud_tras) begin
						state_tras<=state_tras+1;
						send_state<=send_state+1;
						trasstart<=0;
						case(send_state)
							3'b000:
								txd_buf<=8'd101;//"e"
							3'b001:
								txd_buf<=8'd108;//"l"
							3'b010:
								txd_buf<=8'd99;//"c"
							3'b011:
								txd_buf<=8'd111;//"o"
							3'b100:
								txd_buf<=8'd109;//"m"
							3'b101:
								txd_buf<=8'd101;//"e"
							default:
								txd_buf<=0;
						 endcase
					 end
				 end
				default: begin
					if(clkbaud_tras) begin
						state_tras<=state_tras+1;
						trasstart<=1;
					 end
				 end
			 endcase
		 end
	 end
end

always@(posedge clkbaud8x or negedge rst)//接受PC机的数据
begin
	if(!rst) begin
		rxd_reg1<=0;
		rxd_reg2<=0;
		rxd_buf<=0;
		state_rec<=0;
		recstart<=0;
		recstart_tmp<=0;
	 end
	else  begin
		 rxd_reg1<=rxd;
		 rxd_reg2<=rxd_reg1;
		 if(state_rec==0) begin
			 if(recstart_tmp==1) begin
		 		recstart<=1;
		 		recstart_tmp<=0;
				state_rec<=state_rec+1;
		  	  end
		 	 else if(!rxd_reg1&&rxd_reg2) //检测到起始位的下降沿，进入接受状态
				recstart_tmp<=1;
		   end
		 else if(state_rec>=1&&state_rec<=8) begin
		 	 if(clkbaud_rec) begin
			 	rxd_buf[7]<=rxd_reg2;
				rxd_buf[6:0]<=rxd_buf[7:1];
				state_rec<=state_rec+1;
			  end
		  end
		 else if(state_rec==9) begin
		 	if(clkbaud_rec) begin
		 		state_rec<=0;
				recstart<=0;
			 end
		  end
	  end
end

always@(rxd_buf) //将接受的数据用数码管显示出来
begin
      case (rxd_buf)
		8'h30:
			seg_data=8'b11000000;
		8'h31:
			seg_data=8'b11111001;
		8'h32:
			seg_data=8'b10100100;
		8'h33:
			seg_data=8'b10110000;
		8'h34:
			seg_data=8'b10011001;
		8'h35:
			seg_data=8'b10010010;
		8'h36:
			seg_data=8'b10000010;
		8'h37:
			seg_data=8'b11111000;
		8'h38:
			seg_data=8'b10000000;
		8'h39:
			seg_data=8'b10010000;
		8'h41:
			seg_data=8'b00010001;
		8'h42:
			seg_data=8'b11000001;
		8'h43:
			seg_data=8'b0110_0011;
		8'h44:
			seg_data=8'b1000_0101;
		8'h45:
			seg_data=8'b0110_0001;
		8'h46:
			seg_data=8'b0111_0001;
		default:
			seg_data=8'b1111_1111;
	 endcase
end	

endmodule
	
