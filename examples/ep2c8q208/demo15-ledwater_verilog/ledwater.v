//流水灯试验，分频计数器选得大些，否则显示不出流水灯的 效果
module ledwater (clk,rst,out);
input clk,rst;
output [7:0] out;
reg [7:0] out;
reg [25:0] count; //分频计数器

//分频计数器
always @ ( posedge clk )
 begin
  count<=count+1;
 end

always @ ( posedge clk or negedge rst)

 begin
  case ( count[25:22] )
  0: out<=8'b1111_1110;
  1: out<=8'b1111_1100;
  2: out<=8'b1111_1000;
  3: out<=8'b1111_0000;
  4: out<=8'b1110_0000;
  5: out<=8'b1100_0000;
  6: out<=8'b1000_0000;
  7: out<=8'b0000_0000;//循环
  8: out<=8'b0111_1111; //倒回来
  9: out<=8'b0011_1111;
  10:out<=8'b0001_1111;
  11:out<=8'b0000_1111;
  12:out<=8'b0000_0111;
  13:out<=8'b0000_0011;
  14:out<=8'b0000_0001;
  15:out<=8'b0000_0000;
  endcase
 end
endmodule










