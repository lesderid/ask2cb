module touch_irq_detector	(
					iCLK,
					iRST_n,
					iTOUCH_IRQ,
					iX_COORD,
					iY_COORD,
					iNEW_COORD,
//					oDISPLAY_MODE,
					);
					
//============================================================================
// PARAMETER declarations
//============================================================================					
parameter	TOUCH_CNT_CLEAR = 24'hffffff;  // total photo numbers 
                    
//===========================================================================
// PORT declarations
//===========================================================================                      
input			iCLK;				// system clock 50Mhz
input			iRST_n;				// system reset
input			iTOUCH_IRQ;		
input	[11:0]	iX_COORD;			// X coordinate form touch panel
input	[11:0]	iY_COORD;			// Y coordinate form touch panel
input			iNEW_COORD;			// new coordinates indicate
//output	[2:0]	oDISPLAY_MODE;		// displaed photo number
//=============================================================================
// REG/WIRE declarations
//=============================================================================
reg				touch_en;
reg				touch_en_clr;
reg 	[24:0] 	touch_delay_cnt;
//reg 	[1:0] 	oDISPLAY_MODE;
//=============================================================================
// Structural coding
//=============================================================================

always@(posedge iCLK or negedge iRST_n)
	begin
		if (!iRST_n)
			touch_en <= 0;
		else if (touch_en_clr)
			touch_en <= 0;	
		else if (iTOUCH_IRQ)
		    touch_en <= 1;
	end
	
	
always@(posedge iCLK or negedge iRST_n)
	begin	
		if (!iRST_n)
			begin
				touch_delay_cnt <= 0;
				touch_en_clr <= 0;
			end		
		else if (touch_delay_cnt == TOUCH_CNT_CLEAR)
			begin
				touch_delay_cnt <= 0;
				touch_en_clr <= 1;
			end	
		else if (touch_en)
			touch_delay_cnt <= touch_delay_cnt + 1;
		else
			begin
				touch_delay_cnt <= 0;
				touch_en_clr <= 0;
			end	
	end					

//always@(posedge iCLK or negedge iRST_n)
//	begin	
//		if (!iRST_n)
//			oDISPLAY_MODE <= 0;
//		else if (iTOUCH_IRQ && !touch_en)	
//			oDISPLAY_MODE <= oDISPLAY_MODE + 1;
//	end		


endmodule




								