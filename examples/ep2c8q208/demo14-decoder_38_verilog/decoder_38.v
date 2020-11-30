//学习3 8译码器的原理，key1 key2 key3 作为数据输入，LED作为状态显示
module decoder_38(out,key_in);
output[7:0] out;     //LED作为状态显示
input[2:0] key_in;   //key1 key2 key3 作为数据输入
reg[7:0] out;
always @(key_in)

begin
case(key_in)
3'd0: out=8'b11111110;
3'd1: out=8'b11111101;
3'd2: out=8'b11111011;
3'd3: out=8'b11110111;
3'd4: out=8'b11101111;
3'd5: out=8'b11011111;
3'd6: out=8'b10111111;
3'd7: out=8'b01111111;

endcase 
end 
endmodule
