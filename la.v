`include "uart_tx.v"
`default_nettype none

module la(
	input 	clk,
    output  LED1,
    output  LED2,
    output  LED3,
    output  LED4,
    output  LED5,
    input   PMOD1,  // reset
	output RS232_Tx
	);
	
	
	reg tx_data_valid_q;
	reg tx_data_valid_d;
	
	reg transmitting;
	
	
	always @ (posedge clk) begin
			bit_q <= bit_d;
			output_q <= output_d;
			count_q <= count_d;
			tx_data_valid_q <= tx_data_valid_d;	
	end
	
	
	always @ (*) begin
			count_d = count_q;
			tx_data_valid_d = tx_data_valid_q;
			
			
			count_d++;
			
			if(pulse) begin
				tx_data_valid_d = 1;
			end
			
			if(tx_data_valid_q) begin
				tx_data_valid_d = 0;
			end
			
			
	end
	
	
		

	uart_tx uut (
		.clk (clk),
		.tx_data ({4'b0,output_q}),
		.tx_data_valid (tx_data_valid_q),
		.tx (RS232_Tx),
		.transmitting (transmitting)
	);



	
	
endmodule 