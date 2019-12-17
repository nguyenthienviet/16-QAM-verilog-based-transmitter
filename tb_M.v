`timescale 1ns / 1ns
module tb_M;

	reg clk;
	reg rst;
	reg start;

	wire [19:0]  mixed_output;
	integer  mixed_out;

	// DUT
	top_level  top(
	   .clk(clk),
	   .rst(rst),
	   .start(start),
	   .mixed_output(mixed_output)
	   );

	initial begin
		clk = 0;
		rst = 0;
		start = 1;
		#10;
		rst = 1;
	end
	
	always #5
	clk <= ~clk;
	
	integer i = 0;
	
	always @(posedge clk) begin
	   if(i) begin $fwrite(mixed_out,"%b \n", mixed_output); i = 0;end
	   else i = 1;
	   end
	  
	initial begin
	  #40850
	  mixed_out = $fopen("mixed_out.txt");
	  #652800
	  $fclose(mixed_out);
	  end
	
	initial begin
		#700000
			$stop;
	end

endmodule

