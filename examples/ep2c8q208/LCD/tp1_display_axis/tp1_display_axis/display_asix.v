module display_asix
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_50,						//	50 MHz
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
//		SW,								//	Toggle Switch[7:0]
		////////////////////	7-SEG Dispaly	////////////////////
//		HEX0,							//	Seven Segment Digit 0
//		HEX1,							//	Seven Segment Digit 1
//		HEX2,							//	Seven Segment Digit 2
//		HEX3,							//	Seven Segment Digit 3
//		HEX4,							//	Seven Segment Digit 4
//		HEX5,							//	Seven Segment Digit 5
//		HEX6,							//	Seven Segment Digit 6
//		HEX7,							//	Seven Segment Digit 7

		////////////////////////	7SEG		////////////////////////
		COM,								// 7SEG COM
		SEG7,								// 7SEG 
	
		////////////////////////	LED		////////////////////////
//		LED,							//	LED Green[7:0]
		////////////////////////	UART	////////////////////////
//		UART_TXD,						//	UART Transmitter
//		UART_RXD,						//	UART Receiver
		////////////////////	GPIO	////////////////////////////
		GPIO,							//	GPIO Connection
	);
//===========================================================================
// PORT declarations
//===========================================================================                      

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_50;				//	50 MHz
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]
////////////////////////	DPDT Switch		////////////////////////
//input	[7:0]	SW;						//	Toggle Switch[17:0]
////////////////////////	7-SEG Dispaly	////////////////////////
//output	[6:0]	HEX0;					//	Seven Segment Digit 0
//output	[6:0]	HEX1;					//	Seven Segment Digit 1
//output	[6:0]	HEX2;					//	Seven Segment Digit 2
//output	[6:0]	HEX3;					//	Seven Segment Digit 3
//output	[6:0]	HEX4;					//	Seven Segment Digit 4
//output	[6:0]	HEX5;					//	Seven Segment Digit 5
//output	[6:0]	HEX6;					//	Seven Segment Digit 6
//output	[6:0]	HEX7;					//	Seven Segment Digit 7
////////////////////////////	LED		////////////////////////////
//output	[7:0]	LED;					//	LED [7:0]
////////////////////////////	UART	////////////////////////////
//output			UART_TXD;				//	UART Transmitter
//input			UART_RXD;				//	UART Receiver

////////////////////	7-SEG Dispaly	////////////////////
inout [7:0] SEG7;	
inout [7:0] COM;

////////////////////////	GPIO	////////////////////////////////
inout	[39:0]	GPIO;					//	GPIO Connection


//	All inout port turn to tri-state
//assign	DRAM_DQ		=	16'hzzzz;
//assign	FL_DQ		=	8'hzz;
//assign	SRAM_DQ		=	16'hzzzz;
//assign	OTG_DATA	=	16'hzzzz;
//assign	LCD_DATA	=	8'hzz;
//assign	SD_DAT		=	1'bz;
//assign	ENET_DATA	=	16'hzzzz;
//assign	AUD_ADCLRCK	=	1'bz;
//assign	AUD_DACLRCK	=	1'bz;
//assign	AUD_BCLK	=	1'bz;
//assign	GPIO		=	36'hzzzzzzzzz;

//=============================================================================
// REG/WIRE declarations
//=============================================================================
// Touch panel signal //
//wire	[7:0]	ltm_r;		//	LTM Red Data 8 Bits
//wire	[7:0]	ltm_g;		//	LTM Green Data 8 Bits
//wire	[7:0]	ltm_b;		//	LTM Blue Data 8 Bits
//wire			ltm_nclk;	//	LTM Clcok
//wire			ltm_hd;		
//wire			ltm_vd;		
//wire			ltm_den;
//wire			ltm_grst;

// lcd 3wire interface//
//wire			ltm_sclk;		
//wire			ltm_sda;		
//wire			ltm_scen;
//wire 			ltm_3wirebusy_n;	
// Touch Screen Digitizer ADC	
wire 			adc_dclk;
wire 			adc_cs;
wire 			adc_penirq_n;
wire 			adc_busy;
wire 			adc_din;
wire 			adc_dout;
wire 			adc_ltm_sclk;		

wire	[15:0] 	x_coord;
wire	[15:0] 	y_coord;
wire			new_coord;	
//wire	[1:0]	display_mode;
//reg 	[31:0] 	div;

////////////// GPIO //////////////////
assign	GPIO[1]	=adc_dclk;
assign  GPIO[3] =adc_cs;
assign	adc_busy    =GPIO[4];
assign	GPIO[5]	=adc_din;
assign	adc_penirq_n  =GPIO[6];
assign	adc_dout    =GPIO[7];

//assign	GPIO_0[5]	=ltm_b[3];

//assign adc_ltm_sclk	= ( adc_dclk & ltm_3wirebusy_n )  |  ( ~ltm_3wirebusy_n & ltm_sclk );
//assign ltm_nclk = div[0]; // 25 Mhz
//assign ltm_grst = KEY[0];
//always @(posedge CLOCK_50)
//	begin
//		div <= div+1;
//	end

//SEG7_LUT_8 		u1	(	
//					.oSEG0(HEX0),			
//					.oSEG1(HEX1),	
//					.oSEG2(HEX2),	
//					.oSEG3(HEX3),	
//					.oSEG4(HEX4),	
//					.oSEG5(HEX5),	
//					.oSEG6(HEX6),	
//					.oSEG7(HEX7),	
//					.iDIG({ 4'h0 , x_coord , 4'h0 , y_coord }),
//					.ON_OFF(8'b01110111) 
//					);

//	SEG7_Driver seg7_drv (
//			.oSEG(SEG7),
//			.oCOM({wCOM[3], wCOM[2], wCOM[1], wCOM[0]}),
//			.iDIG( {counter_k3, counter_k2, counter_k1, counter_k0} ),
//			.iCLK(OSC_50),
//			.iRST_n(KEY1)
//			);

	SEG7_Driver u1 (
			.oSEG(SEG7),
			.oCOM({COM[0], COM[1], COM[2], COM[3], COM[4], COM[5], COM[6], COM[7]}),
			//.iDIG({ 4'h0 , x_coord , 4'h0 , y_coord }),
			.iDIG({ x_coord , y_coord }),
			//.iDIG({ 4'h0 , x_coord }),
			//.iDIG({ 4'h0 , 4'h1 , 4'h2 , 4'h3 , 4'h4 , 4'h5 , 4'h6 , 4'h7 }),
			.iCLK(CLOCK_50),
			.iRST_n(KEY[0])
			);
			
// lcd 3 wire interface configuration  //
//lcd_spi_cotroller	u2	(	
//					// Host Side
//					.iCLK(CLOCK_50),
//					.iRST_n(DLY0),
//					// 3wire Side
//					.o3WIRE_SCLK(ltm_sclk),
//					.io3WIRE_SDAT(ltm_sda),
//					.o3WIRE_SCEN(ltm_scen),
//					.o3WIRE_BUSY_n(ltm_3wirebusy_n)
//					);	

// system reset  //
Reset_Delay		u3  (.iCLK(CLOCK_50),
					.iRST(KEY[0]),
					.oRST_0(DLY0),
					.oRST_1(DLY1),
					.oRST_2(DLY2)
					);
// Touch Screen Digitizer ADC configuration //
adc_spi_controller		u4	(
					.iCLK(CLOCK_50),
					.iRST_n(DLY0),
					.oADC_DIN(adc_din),
					.oADC_DCLK(adc_dclk),
					.oADC_CS(adc_cs),
					.iADC_DOUT(adc_dout),
					.iADC_BUSY(adc_busy),
					.iADC_PENIRQ_n(adc_penirq_n),
					.oTOUCH_IRQ(touch_irq),
					.oX_COORD(x_coord),
					.oY_COORD(y_coord),
					.oNEW_COORD(new_coord),
					);

touch_irq_detector	u5	(
					.iCLK(CLOCK_50),
					.iRST_n(DLY0),
					.iTOUCH_IRQ(touch_irq),
					.iX_COORD(x_coord),
					.iY_COORD(y_coord),
					.iNEW_COORD(new_coord),
//					.oDISPLAY_MODE(display_mode),
					);

//lcd_timing_controller		u6  ( 
//					.iCLK(ltm_nclk),
//					.iRST_n(DLY2),
//					// lcd side
//					.oLCD_R(ltm_r),
//					.oLCD_G(ltm_g),
//					.oLCD_B(ltm_b), 
//					.oHD(ltm_hd),
//					.oVD(ltm_vd),
//					.oDEN(ltm_den),
//					.iDISPLAY_MODE(display_mode),	
//					);

endmodule