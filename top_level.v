`timescale 1ns / 1ns
module top_level(
  input clk,
  input rst,
  input start,
  
  output  [19:0]  mixed_output
  );

	// Outputs
	wire [3:0] parallel_data;
	wire       serial_in;
	wire       data_flag;
	wire [15:0]  sin, cos;
	integer  mixed_out;

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
	local_oscillator lo(
	   .clk(clk),
	   .rst(rst),
	   .start(start),
	   .sin(sin),
	   .cos(cos)
	   );
	modulator md(
      .clk(clk),
      .rst(rst),
      .start(start),
      .parallel_data(parallel_data),
      .sin(sin),
      .cos(cos),
      .mixed_output(mixed_output)
      );
endmodule


