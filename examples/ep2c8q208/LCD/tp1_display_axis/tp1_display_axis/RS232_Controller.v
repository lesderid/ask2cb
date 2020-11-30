module RS232_Controller(oDATA,iDATA,oTxD,oTxD_Busy,iTxD_Start,
						iRxD,oRxD_Ready,iCLK);
input [7:0] iDATA;
input iTxD_Start,iRxD,iCLK;
output [7:0] oDATA;
output oTxD,oTxD_Busy,oRxD_Ready;

async_receiver		u0	(	.clk(iCLK), .RxD(iRxD),
							.RxD_data_ready(oRxD_Ready),
						 	.RxD_data(oDATA));
async_transmitter	u1	(	.clk(iCLK), .TxD_start(iTxD_Start),
							.TxD_data(iDATA), .TxD(oTxD),
							.TxD_busy(oTxD_Busy));
							
endmodule