module shumaguan(clk,dataout,en);
input clk;              //输入时钟
output [7:0] dataout;      //数码管的公共段码
output [7:0] en;       //8位数码管的位选信号
reg [7:0] dataout;
reg [7:0] en;
reg [15:0] count;//分频计数器，65536分频
reg  div_clk=0;

reg [3:0] num1,num2;

//分频计数器
always @ ( posedge clk )
begin
if ( count==65535 )
 begin
  div_clk<=~div_clk;
   count<=0;
  end
else
  count<=count+1;
end

//位选信号，每次只选通一位数码管
always @ ( posedge div_clk )
begin
 case ( num1 )
 0:
  begin
en<=8'b01111111;
 num1<=1;
 end
 1:
 begin
en<=8'b10111111;
 num1<=2;
 end
 2:
 begin
en<=8'b11011111;
 num1<=3;
 end
 3:
 begin
en<=8'b11101111;
 num1<=4;
end
 4:
 begin
en<=8'b11110111;
 num1<=5;
 end
 5:
 begin
en<=8'b11111011;
 num1<=6;
 end
 6:
 begin
en<=8'b11111101;
 num1<=7;
 end
 7:
 begin
en<=8'b11111110;
 num1<=0;
 end
endcase
end


//段码，8位数码管分时复用
always @ ( posedge div_clk )
begin
 case ( num2 )
 0:
 begin
dataout<=8'hc0;
 num2<=1;
 end
 1:
 begin
dataout<=8'hf9;
num2<=2;
end
 2:
begin
dataout<=8'ha4;
num2<=3;
 end
 3:
 begin
dataout<=8'hb0;
num2<=4;
end
 4:
 begin
dataout<=8'h99;
 num2<=5;
end
 5:
 begin
dataout<=8'h92;
num2<=6;
end
 6:
 begin
dataout<=8'h82;
 num2<=7;
 end
 7:
 begin
dataout<=8'hf8;
 num2<=0;
 end
 endcase
end
endmodule



