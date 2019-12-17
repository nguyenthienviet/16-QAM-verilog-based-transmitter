`timescale 1ns / 1ns
module tb_S2P;

	// Inputs
	reg clk;
	reg rst;
	reg start;

	// Outputs
	wire [3:0] parallel_data;
	wire       serial_in;
	wire       data_flag;

	// DUT
	data_generator dat_gen(
	   .clk(clk),
	   .rst(rst),
	   .enable(start),
	   .serial_in(serial_in),
	   .data_flag(data_flag)
	   );
	serial_2_parallel dut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.serial_in(serial_in),
		.data_flag(data_flag),
		.parallel_data(parallel_data)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		start = 1;

		// Wait 10 ns for global reset to finish
		#10;
		rst = 1;
	end
	
	always #5
	clk <= ~clk;
	
	initial begin
		#100000
			$stop;
	end
	
	/*always @(posedge clk) begin
	 data_flag = 0;
	 if(i == 7) begin
	   serial_in = $unsigned($random)%2;
	   data_flag = 1;
	   i = i-1;
	   end
	 else if(i == 0) i = 7;
	   else i = i-1;
	end*/

endmodule