`include "uart_tx.v"
`default_nettype none

module la(
	input 	clk,
	input 	J1_3,
	output RS232_Tx
	);
	
	parameter WIDTH = 8;
	
	reg tx_data_valid_q;
	reg tx_data_valid_d;
	
	
	reg [WIDTH-1:0] data_q;
	reg [WIDTH-1:0] data_d;
	
	
	reg action_q;
	reg action_d;
	
	reg transmitting;
	
	
	always @ (posedge clk) begin
			data_q <= data_d;
			tx_data_valid_q <= tx_data_valid_d;	
	end
	
	
	always @ (*) begin
			tx_data_valid_d = tx_data_valid_q;
			
			
			
			if(action_d) begin
				tx_data_valid_d = 1;
			end
			
			if(tx_data_valid_q) begin
				tx_data_valid_d = 0;
			end
			
			
	end
	
	
		

	uart_tx uut (
		.clk (clk),
		.tx_data (data_q),
		.tx_data_valid (tx_data_valid_q),
		.tx (RS232_Tx),
		.transmitting (transmitting)
	);



	
	
endmodule 