//学习按键识别，FPGA检测 key1 key2 key3 key4的状态作为数据输入，LED作为状态显示
module key_led(clk,key,dataout,en);
input clk;
input [3:0] key;       //key为输入的键码的值
output [3:0] en;
output [7:0] dataout;
wire [3:0] key;
reg [7:0] dataout;
reg [3:0] en;
reg [3:0] key_temp;  //设置了一个寄存器

always @ (posedge clk )
begin
key_temp<=key;     //把键码的值赋给寄存器
case ( key_temp )
4'b0111:dataout<=8'b1100_0000;   //段码，按键后，数码管显示0
4'b1011:dataout<=8'b1001_0000;    //段码，数码管显示9
4'b1101:dataout<=8'b1000_0010;    //段码，数码管显示6
4'b1110:dataout<=8'b1011_0000;    //段码，数码管显示3
endcase
end


always @ ( posedge clk )
begin
case( key_temp )
4'b0111:en<=4'b0111;  //位选信号
4'b1011:en<=4'b1011;
4'b1101:en<=4'b1101;
4'b1110:en<=4'b1110;
endcase
end
endmodule


