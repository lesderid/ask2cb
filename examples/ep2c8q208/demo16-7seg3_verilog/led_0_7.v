//7段数码管测试实验：以动态扫描方式在8位数码管“同时”显示0-7
//实验的目的是向用户介绍多个数码管动态显示的方法。
//动态显示的方法是，按一定的频率轮流向各个数码管的COM端送出低电平，同时送出对应的数据给各段


module led_0_7 (clk,rst,dataout,en);

input clk,rst;
output[7:0] dataout;   //数码管的段码输出
output[7:0] en;        //数码管的位选使能输出
reg[7:0] dataout;      //各段数据输出
reg[7:0] en;

reg[15:0] cnt_scan;//扫描频率计数器
reg[4:0] dataout_buf;

always@(posedge clk or negedge  rst)
begin
	if(!rst) begin
		cnt_scan<=0;
		
	 end
	else begin
		cnt_scan<=cnt_scan+1;
		end
end

always @(cnt_scan)
begin
   case(cnt_scan[15:13])
       3'b000 :
          en = 8'b1111_1110;
       3'b001 :
          en = 8'b1111_1101;
       3'b010 :
          en = 8'b1111_1011;
       3'b011 :
          en = 8'b1111_0111;
       3'b100 :
          en = 8'b1110_1111;
       3'b101 :
          en = 8'b1101_1111;
       3'b110 :
          en = 8'b1011_1111;
       3'b111 :
          en = 8'b0111_1111;
       default :
          en = 8'b1111_1110;
    endcase
end

always@(en) //对应COM信号给出各段数据
begin
	case(en)
		8'b1111_1110:
			dataout_buf=0;
		8'b1111_1101:
			dataout_buf=1;
		8'b1111_1011:
			dataout_buf=2;
		8'b1111_0111:
			dataout_buf=3;	
		8'b1110_1111:
			dataout_buf=4;
		8'b1101_1111:
			dataout_buf=5;
		8'b1011_1111:
			dataout_buf=6;
		8'b0111_1111:
			dataout_buf=7;
		default: 
			dataout_buf=8;
	 endcase
end

always@(dataout_buf)
begin
	case(dataout_buf)
		4'b0000:
			dataout=8'b1100_0000;
		4'b0001:
			dataout=8'b1111_1001;
		4'b0010:
			dataout=8'b1010_0100;
		4'b0011:
			dataout=8'b1011_0000;
		4'b0100:
			dataout=8'b1001_1001;
		4'b0101:
			dataout=8'b1001_0010;
		4'b0110:
			dataout=8'b1000_0010;
		4'b0111:
			dataout=8'b1111_1000;
		4'b1000:
			dataout=8'b1000_0000;
		4'b1001:
			dataout=8'b1001_1000;
		4'b1010:
			dataout=8'b1000_1000;
		4'b1011:
			dataout=8'b1000_0011;
		4'b1100:
			dataout=8'b1100_0110;
		4'b1101:
			dataout=8'b1010_0001;
		4'b1110:
			dataout=8'b1000_0110;
		4'b1111:
			dataout=8'b1000_1110;
	 endcase
end

endmodule 