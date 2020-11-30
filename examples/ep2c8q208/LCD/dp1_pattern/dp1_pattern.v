module dp1_pattern
	(
		////////////////////	Clock Input	 	////////////////////	 
		CLOCK_50,						//	50 MHz
		////////////////////	Push Button		////////////////////
		KEY,							//	Pushbutton[3:0]
		GPIO,							//	GPIO Connection
	);
//===========================================================================
// PORT declarations
//===========================================================================                      

////////////////////////	Clock Input	 	////////////////////////
input			CLOCK_50;				//	50 MHz
////////////////////////	Push Button		////////////////////////
input	[3:0]	KEY;					//	Pushbutton[3:0]

////////////////////////	GPIO	////////////////////////////////
inout	[39:0]	GPIO;					//	GPIO Connection

//	All inout port turn to tri-state
assign	GPIO		=	36'hzzzzzzzzz;
//=============================================================================
// REG/WIRE declarations
//=============================================================================
// Touch panel signal //
wire	[7:0]	ltm_r;		//	LTM Red Data 8 Bits
wire	[7:0]	ltm_g;		//	LTM Green Data 8 Bits
wire	[7:0]	ltm_b;		//	LTM Blue Data 8 Bits
wire			ltm_nclk;	//	LTM Clcok
wire			ltm_hd;		
wire			ltm_vd;		
wire			ltm_den;
wire			ltm_grst;
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
//wire 			adc_ltm_sclk;		

wire	[11:0] 	x_coord;
wire	[11:0] 	y_coord;
wire			new_coord;	
wire	[1:0]	display_mode;
reg 	[31:0] 	div;

//assign	adc_penirq_n  =GPIO[0];
//assign	adc_dout    =GPIO[1];
//assign	adc_busy    =GPIO[2];
//assign	GPIO[3]	=adc_din;
//assign	GPIO[4]	=adc_ltm_sclk;



////////////// GPIO_O //////////////////

assign	GPIO[1] =ltm_r[0];
assign	GPIO[3] =ltm_r[1];
assign	GPIO[4]	=ltm_r[2];
assign	GPIO[5]	=ltm_r[3];
assign	GPIO[6]	=ltm_r[4];
assign	GPIO[7]	=ltm_r[5];
assign	GPIO[8]	=ltm_r[6];
assign	GPIO[9]	=ltm_r[7];


assign	GPIO[12]	=ltm_g[0];
assign	GPIO[13]	=ltm_g[1];
assign	GPIO[14]	=ltm_g[2];
assign	GPIO[15]	=ltm_g[3];
assign	GPIO[16]	=ltm_g[4];
assign	GPIO[17]	=ltm_g[5];
assign	GPIO[18]	=ltm_g[6];
assign	GPIO[19]	=ltm_g[7];

assign	GPIO[20]	=ltm_b[0];
assign	GPIO[21]	=ltm_b[1];
assign	GPIO[22]	=ltm_b[2];
assign	GPIO[23]	=ltm_b[3];
assign	GPIO[24]	=ltm_b[4];
assign	GPIO[25]	=ltm_b[5];
assign	GPIO[26]	=ltm_b[6];
assign	GPIO[27]	=ltm_b[7];

assign	GPIO[34]	=adc_dclk;
assign  GPIO[35] =adc_cs;
assign	adc_busy    =GPIO[37];
assign	GPIO[36]	=adc_din;
assign	adc_penirq_n  =GPIO[39];
assign	adc_dout    =GPIO[38];


assign	GPIO[30]	=ltm_nclk;			//PCLK
assign	GPIO[31]	=ltm_hd;				//HSYNC
assign	GPIO[32]	=ltm_vd;				//VSYNC

//assign adc_ltm_sclk	= ( adc_dclk & ltm_3wirebusy_n )  |  ( ~ltm_3wirebusy_n & ltm_sclk );
assign ltm_nclk = div[0]; // 25 Mhz
assign ltm_grst = KEY[0];
always @(posedge CLOCK_50)
	begin
		div <= div+1;
	end


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
					.oDISPLAY_MODE(display_mode),
					);

lcd_timing_controller		u6  ( 
					.iCLK(ltm_nclk),
					.iRST_n(DLY2),
					// lcd side
					.oLCD_R(ltm_r),
					.oLCD_G(ltm_g),
					.oLCD_B(ltm_b), 
					.oHD(ltm_hd),
					.oVD(ltm_vd),
					.oDEN(ltm_den),
					.iDISPLAY_MODE(display_mode),	
					);

endmodule