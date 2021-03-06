`timescale 1ns / 1ns
module tb_LO;

	// Inputs
	reg clk;
	reg rst;
	reg start;

	// Outputs
	wire [15:0] sin;
	wire [15:0] cos;

	// DUT
	local_oscillator dut (
		.clk(clk), 
		.rst(rst), 
		.start(start), 
		.sin(sin), 
		.cos(cos)
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
		#20000
			$stop;
	end
endmodule



