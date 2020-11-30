module SEG7_Driver(oSEG,oCOM,iDIG,iCLK,iRST_n);
input [31:0] iDIG;		//  4 Digital Hex
input iCLK,iRST_n;
output reg [7:0] oSEG;	//	7-SEG LED output
output reg [7:0] oCOM;	//	7-SEG COM output
reg [31:0] Cont_DIV;	//	Scan Clock DIV Counter
reg [3:0] mDEC_in;		//	Hex To 7-SEG Dec reg
reg [2:0] mSCAN;		//	Scan Order Counter
reg mSCAN_CLK;			//	Scan Clock

parameter iCLK_Freq = 50000000;	//	50 MHz
//parameter iCLK_Freq = 27000000;	//	27 MHz

//	Scan Clock Generator
always@(posedge iCLK or negedge iRST_n)
begin
	if(!iRST_n)
	begin
		Cont_DIV<=0;
		mSCAN_CLK<=0;
	end
	else
	begin
		if(Cont_DIV < (iCLK_Freq>>10) )
		Cont_DIV<=Cont_DIV+1;
		else
		begin
			Cont_DIV<=0;
			mSCAN_CLK<=~mSCAN_CLK;
		end
	end
end

//	Scan Order Generator
always@(posedge mSCAN_CLK or negedge iRST_n)
begin
	if(!iRST_n)
	begin
		oCOM<=0;
		mSCAN<=0;
	end
	else
	begin
		mSCAN	<=	mSCAN + 1'b1;
		case(mSCAN)
		0:	oCOM	<=	8'b11111110;
		1:	oCOM	<=	8'b11111101;
		2:	oCOM	<=	8'b11111011;
		3:	oCOM	<=	8'b11110111;
		4:	oCOM	<=	8'b11101111;
		5:	oCOM	<=	8'b11011111;
		6:	oCOM	<=	8'b10111111;
		7:	oCOM	<=	8'b01111111;
		endcase
	end
end

//	Hex To 7-SEG Decoder
always@(posedge iCLK or negedge iRST_n)
begin
	if(!iRST_n)
	begin
		oSEG<=0;
		mDEC_in<=0;
	end
	else
	begin
		case(mSCAN)
		0:	mDEC_in	<=	iDIG[3:0];
		1:	mDEC_in	<=	iDIG[7:4];
		2:	mDEC_in	<=	iDIG[11:8];
		3:	mDEC_in	<=	iDIG[15:12];
		4:	mDEC_in	<=	iDIG[19:16];
		5:	mDEC_in	<=	iDIG[23:20];
		6:	mDEC_in	<=	iDIG[27:24];
		7:	mDEC_in	<=	iDIG[31:28];
		endcase
		case(mDEC_in)
//		4'h1: oSEG <= 8'b11010111; // ---t----
//		4'h2: oSEG <= 8'b01001100; // |		 |
//		4'h3: oSEG <= 8'b01000101; // lt	 rt
//		4'h4: oSEG <= 8'b10000111; // |		 |
//		4'h5: oSEG <= 8'b00100101; // ---m----
//		4'h6: oSEG <= 8'b00100100; // |		 |
//		4'h7: oSEG <= 8'b01010111; // lb	 rb
//		4'h8: oSEG <= 8'b00000100; // |		 |
//		4'h9: oSEG <= 8'b00000111; // ---b----
//		4'ha: oSEG <= 8'b00000110;
//		4'hb: oSEG <= 8'b10100100;
//		4'hc: oSEG <= 8'b00111100;
//		4'hd: oSEG <= 8'b11000100;
//		4'he: oSEG <= 8'b00101100;
//		4'hf: oSEG <= 8'b00101110;
//    4'h0: oSEG <= 8'b00010100;

    4'h0: oSEG <= 8'b11000000;
		4'h1: oSEG <= 8'b11111001; // ---t----
		4'h2: oSEG <= 8'b10100100; // |		 |
		4'h3: oSEG <= 8'b10110000; // lt	 rt
		4'h4: oSEG <= 8'b10011001; // |		 |
		4'h5: oSEG <= 8'b10010010; // ---m----
		4'h6: oSEG <= 8'b10000010; // |		 |
		4'h7: oSEG <= 8'b11111000; // lb	 rb
		4'h8: oSEG <= 8'b10000000; // |		 |
		4'h9: oSEG <= 8'b10010000; // ---b----
		4'ha: oSEG <= 8'b10001000;
		4'hb: oSEG <= 8'b10000011;
		4'hc: oSEG <= 8'b11000110;
		4'hd: oSEG <= 8'b10100001;
		4'he: oSEG <= 8'b10000110;
		4'hf: oSEG <= 8'b10001110;


		endcase
	end
end


////	Bin To 7-SEG Decoder
//always@(posedge iCLK or negedge iRST_n)
//begin
//	if(!iRST_n)
//	begin
//		oSEG<=0;
//		mDEC_in<=0;
//	end
//	else
//	begin
//		case(mSCAN)
//		0:	mDEC_in	<=	iDIG[3:0];
//		1:	mDEC_in	<=	iDIG[7:4];
//		2:	mDEC_in	<=	iDIG[11:8];
//		3:	mDEC_in	<=	iDIG[15:12];
//		endcase
//		case(mDEC_in)
//		4'b0001: oSEG <= 8'b11010111; // ---t----
//		4'b0010: oSEG <= 8'b01001100; // |		 |
//		4'b0011: oSEG <= 8'b01000101; // lt	 rt
//		4'b0100: oSEG <= 8'b10000111; // |		 |
//		4'b0101: oSEG <= 8'b00100101; // ---m----
//		4'b0110: oSEG <= 8'b00100100; // |		 |
//		4'b0111: oSEG <= 8'b01010111; // lb	 rb
//		4'b1000: oSEG <= 8'b00000100; // |		 |
//		4'b1001: oSEG <= 8'b00000111; // ---b----
//		4'b1010: oSEG <= 8'b00000110;
//		4'b1011: oSEG <= 8'b10100100;
//		4'b1100: oSEG <= 8'b00111100;
//		4'b1101: oSEG <= 8'b11000100;
//		4'b1110: oSEG <= 8'b00101100;
//		4'b1111: oSEG <= 8'b00101110;
//		4'b0000: oSEG <= 8'b00010100;
//		endcase
//	end
//end

endmodule