module uart_tx (
	input clk,
	input [7:0] tx_data,
	input tx_data_valid,
	output reg tx,
	output reg transmitting
);

parameter integer BAUD_RATE = 9600;
parameter integer CLK_FREQ_HZ = 12000000;
localparam integer BAUD_PERIOD_CYCLES = CLK_FREQ_HZ / BAUD_RATE;

reg [$clog2(BAUD_PERIOD_CYCLES):0] cycle_count = 0;
reg [3:0] bit_count = 0;
reg [7:0] data;

initial begin
	tx = 1;
	transmitting = 0;
end

always @(posedge clk) begin
	if (!transmitting) begin
		// keep tx high if not transmitting
		tx <= 1;
		if (tx_data_valid) begin
			data <= tx_data;
			bit_count <= 1;
			cycle_count <= 0;
			transmitting <= 1;
			// transmit start bit
			tx <= 0;
		end
	end else begin
		if (cycle_count == BAUD_PERIOD_CYCLES) begin
			// reached new bit transition
			cycle_count <= 0;
			bit_count <= bit_count + 1;
			if (bit_count == 9) begin
				// transmit stop bit
				tx <= 1;
			end else if (bit_count == 10) begin
				transmitting <= 0;
			end else begin
				tx <= data[0];
				data <= {1'b0, data[7:1]};
			end
		end else begin
			cycle_count <= cycle_count + 1;
		end
	end
end

endmodule