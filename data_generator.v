`timescale 1ns/1ns

module data_generator(
  input   clk,
  input   rst, 
  input   enable,
  output  serial_in, 
  output  data_flag
  );
  
  reg [9:0]   counter;
  reg [63:0]  shift_reg; 
  reg         flag_reg;        
  
  always @(posedge clk) begin
    flag_reg = 0;
    if(rst == 0) begin
      counter <= 0;
      shift_reg<=64'b1011100110101000001100010010000001110101011001001111110111101100;
    end
    else if(counter == 1019) counter <= 0;
    else begin
      if(counter == 1018) begin
        counter <= counter + 1;
        shift_reg <= {shift_reg[62:0], shift_reg[63]};
        flag_reg = 1;
        end
      else counter <= counter + 1;  
      end 
  end 
  
  assign data_flag = flag_reg;
  assign serial_in = shift_reg[0];
  
endmodule