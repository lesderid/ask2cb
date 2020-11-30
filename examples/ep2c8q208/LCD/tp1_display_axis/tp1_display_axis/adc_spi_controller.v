// --------------------------------------------------------------------
// Copyright (c) 2005 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	This funtion will config and read Touch Screen Digitizer 
// 					X an Y coordinate form LTM 
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny Fan        :| 06/03/23  :|      Initial Revision
// --------------------------------------------------------------------
module adc_spi_controller	(
					iCLK,
					iRST_n,
					oADC_DIN,
					oADC_DCLK,
					oADC_CS,
					iADC_DOUT,
					iADC_BUSY,
					iADC_PENIRQ_n,
					oTOUCH_IRQ,
					oX_COORD,
					oY_COORD,
					oNEW_COORD,
					///////////////////
					);
					
//adc_spi_controller		u4	(
//					.iCLK(CLOCK_50),
//					.iRST_n(DLY0),
//					.oADC_DIN(adc_din),
//					.oADC_DCLK(adc_dclk),
//					.oADC_CS(adc_cs),
//					.iADC_DOUT(adc_dout),
//					.iADC_BUSY(adc_busy),
//					.iADC_PENIRQ_n(adc_penirq_n),
//					.oTOUCH_IRQ(touch_irq),					//给touch_irq_detector模块使用的
//					.oX_COORD(x_coord),
//					.oY_COORD(y_coord),
//					.oNEW_COORD(new_coord),					//给touch_irq_detector模块使用的
//					);
					
					
//============================================================================
// PARAMETER declarations
//============================================================================	
parameter SYSCLK_FRQ	= 50000000;
parameter ADC_DCLK_FRQ	= 1000;				//ADC频率10KHz
parameter ADC_DCLK_CNT	= SYSCLK_FRQ/(ADC_DCLK_FRQ*2);		//adc计数频率25000,250k
					
//===========================================================================
// PORT declarations
//=========================================================================== 
input			iCLK;							//输入时钟50M			
input			iRST_n;						//复位信号
input			iADC_DOUT;				//adc_din  MISO
input			iADC_PENIRQ_n;		//adc中断脚
input			iADC_BUSY;				//adc busy脚
output			oADC_DIN;				//adc_din  MOSI
output			oADC_DCLK;			//adc_dclk
output			oADC_CS;				//adc_cs
output			oTOUCH_IRQ;			//adc_irq信号, 给touch_irq_detector模块使用的
output	[15:0]	oX_COORD;		//需要输出的X坐标
output	[15:0]	oY_COORD;		//需要输出的Y坐标
output			oNEW_COORD;			//给touch_irq_detector模块使用的		
//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg				d1_PENIRQ_n;
reg				d2_PENIRQ_n;
wire			touch_irq;
reg		[15:0]	dclk_cnt;
wire			dclk;
reg				transmit_en;			///transmit_en使能位,为1时开始传输
reg		[6:0]	spi_ctrl_cnt;
wire			oADC_CS;
reg				mcs;
reg				mdclk;
wire	[7:0]	x_config_reg;
wire	[7:0]	y_config_reg;
wire	[7:0]	ctrl_reg;
reg		[7:0]	mdata_in;
reg				y_coordinate_config;
wire			eof_transmition;	
reg		[5:0]	bit_cnt;	
reg				madc_out;							//内部存放DOUT的寄存器
reg		[15:0]	mx_coordinate;
reg		[15:0]	my_coordinate;	
reg		[15:0]	oX_COORD;
reg		[15:0]	oY_COORD;
wire			rd_coord_strob;
reg				oNEW_COORD;
reg		[5:0]	irq_cnt;
reg		[15:0]	clk_cnt;
//=============================================================================
// Structural coding
//=============================================================================
assign	x_config_reg = 8'h92;  //10010010
assign	y_config_reg = 8'hd2;  //11010010

//在每个iCLK的上升沿或者iRST_n下降沿,将ADC_DOUT数据放到madc_out中
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			madc_out <= 0;
		else
			madc_out <= iADC_DOUT;
	end		


///////////////   pen irq detect  //////// 
//在每个iCLK的上升沿或者iRST_n下降沿,将ADC_PENIRQ_n的值放入d1_PENIRQ_n中,再将d1_PENIRQ_n的值放入d2_PENIRQ_n中

always@(posedge iCLK or negedge iRST_n)
	begin	
		if (!iRST_n)
			begin
				d1_PENIRQ_n	<= 0;
				d2_PENIRQ_n	<= 0;
			end
		else
			begin
				d1_PENIRQ_n	<= iADC_PENIRQ_n;			//第一个时钟时ADC_PENIRQ_n的变化放入d1_PENIRQ_n中
				d2_PENIRQ_n	<= d1_PENIRQ_n;				//第二个时钟时ADC_PENIRQ_n的变化放入d2_PENIRQ_n中
			end
	end

// if iADC_PENIRQ_n form high to low , touch_irq goes high
// 如果iADC_PENIRQ_n 从高到低, touch_irq拉高
assign		touch_irq = d2_PENIRQ_n & ~d1_PENIRQ_n; 
assign		oTOUCH_IRQ = touch_irq;
// if touch_irq goes high , starting transmit procedure ,transmit_en goes high
// if end of transmition and no penirq , transmit procedure stop.


//在每个iCLK的上升沿或者iRST_n下降沿,根据ADC_PENIRQ_n和touch_irq来决定transmit_en使能位的高低
//当eof_transmition逻辑与iADC_PENIRQ_n  为1时,transmit_en为0,表示传输完成并且中断为高
//当touch_irq为低时,开始传输,transmit_en为1
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			transmit_en <= 0;
		else if (eof_transmition&&iADC_PENIRQ_n) 
			transmit_en <= 0;	
		else if (touch_irq) //touch_irq为高,表示中断来了,传输开始
			transmit_en <= 1;
	end			

//如果transmit_en使能位为高,分频
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			dclk_cnt <= 0;
		else if (transmit_en) 
			begin
				if (dclk_cnt == ADC_DCLK_CNT)	//如果dclk_cnt等于25000
					dclk_cnt <= 0;
				else
					dclk_cnt <= dclk_cnt + 1;		
			end
		else
			dclk_cnt <= 0;
	end			

assign	dclk =   (dclk_cnt == ADC_DCLK_CNT)? 1 : 0;				//如果dclk_cnt等于25000, 则dclk为1,否则为0,dclk每隔250k翻转
																													//dclk为一个传输周期

//在每个dclk为高时,每当spi_ctrl_cnt为65时，归零,否则加1
//问题：为什么spi_ctrl_cnt要计数到65, 而不是其它值
//回答：65刚好是DCLK的第65个时钟跳变沿，此时刚好在0XD2开始的第一个上升沿
//dclk为一个传输周期,一个传输周期中又分65个spi_ctrl_cnt
always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			spi_ctrl_cnt <= 0;
		else if (dclk)	
			begin
				if (spi_ctrl_cnt == 65)
					spi_ctrl_cnt <= 0;						
				else
					spi_ctrl_cnt <= spi_ctrl_cnt + 1;		
			end
	end				

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				mcs 	<= 1;
				mdclk	<= 0;
				mdata_in <= 0;
				y_coordinate_config <= 0;
				mx_coordinate <= 0;
				my_coordinate <= 0;
			end
		else if (transmit_en)		//开始传输
			begin
				if (dclk)
					begin
						if (spi_ctrl_cnt == 0)			//如果spi_ctrl_cnt为0,表示SPI计数刚开始
							begin
								mcs 	<= 0;							//片选拉低
								mdata_in <= ctrl_reg;		//赋值0x92
							end	
						//else if (spi_ctrl_cnt == 49)		//如果spi_ctrl_cnt为49,表示切换到y坐标
						else if (spi_ctrl_cnt == 57)		//如果spi_ctrl_cnt为49,表示切换到y坐标
							begin
								mdclk	<= 0;									//时钟拉到低
								y_coordinate_config <= ~y_coordinate_config;		//切换到y坐标模式
								
								if (y_coordinate_config)		//如果为y坐标模式
									mcs 	<= 1;								//片选拉高，否则为低
								else
									mcs 	<= 0;	
							end
						else if (spi_ctrl_cnt != 0)
							mdclk	<= ~mdclk;				
						if (mdclk)														//在mdclk的上升沿，送进去8个数
							mdata_in <= {mdata_in[6:0],1'b0};		//因为控制寄存器只有7个bit,所以要补一位
						if (!mdclk)	
							begin
								if(rd_coord_strob)
									begin
										if(y_coordinate_config)
											my_coordinate <= {my_coordinate[14:0],madc_out};
										else
											mx_coordinate <= {mx_coordinate[14:0],madc_out};	
									end
							end		
					end				
			end
	end

assign	oADC_CS  = mcs;
assign	oADC_DIN = 	mdata_in[7];
assign	oADC_DCLK = mdclk;
assign	ctrl_reg = y_coordinate_config ? y_config_reg : x_config_reg;		//y_coordinate为1吗？如果为1,ctrl_reg赋值为0xd2,否则为0x92
 
//assign	eof_transmition = (y_coordinate_config & (spi_ctrl_cnt == 49) & dclk);
assign	eof_transmition = (y_coordinate_config & (spi_ctrl_cnt == 57) & dclk);

//assign	rd_coord_strob = ((spi_ctrl_cnt>=19)&&(spi_ctrl_cnt<=41)) ? 1 : 0;			//rd_coord_strobe表示一个x坐标锁存阶段
assign	rd_coord_strob = ((spi_ctrl_cnt>=19)&&(spi_ctrl_cnt<=49)) ? 1 : 0;			//rd_coord_strobe表示一个x坐标锁存阶段

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			begin
				oX_COORD <= 0;	
				oY_COORD <= 0;
			end
		else if (eof_transmition&&(my_coordinate!=0))
			begin			
				oX_COORD <= mx_coordinate;	
				oY_COORD <= my_coordinate;
			end	
	end

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			oNEW_COORD <= 0;
		else if (eof_transmition&&(my_coordinate!=0))
			oNEW_COORD <= 1;
		else
			oNEW_COORD <= 0;		
	end

endmodule
