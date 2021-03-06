`timescale 1ns/1ns

module serial_2_parallel(
  input clk,
  input rst,
  input start,
  input serial_in,
  input data_flag,
  output  [3:0] parallel_data
  );
  
  //parameter
  parameter idle = 2'b00;
  parameter loop = 2'b01;
  parameter shift = 2'b10;
  
  //register
  reg [3:0] shift_reg, data_reg;
  reg [1:0] bit_cnt;
  //control signal
  reg [1:0] state, next_state;
  reg       start_control;
  reg       shift_reg_control, shift_data_control;
  reg       inc_bit_cnt;
  
  //CU
  always @(state or start or data_flag or bit_cnt) begin
    next_state = state;
    start_control = 0;
    shift_reg_control = 0;
    shift_data_control = 0;
    inc_bit_cnt = 0;
    case(state)
      idle:
      if(start) begin
        next_state = loop;
        start_control = 1;
      end
      loop:
      if(data_flag) begin
        next_state = shift;
        shift_reg_control = 1;
      end else next_state = loop;
      shift:
      begin
        if(bit_cnt == 3) shift_data_control = 1;
        inc_bit_cnt = 1;
        next_state = loop;
      end
    endcase
  end
  
  //DU
  always @(posedge clk) begin
    if(rst == 0) begin
      state <= idle;
      bit_cnt <= 0;
      shift_reg <= 4'b0000;
      data_reg <= 4'b0000;
    end else begin
      state = next_state;
      if(start_control) begin
        bit_cnt <= 0;
        shift_reg <= 4'b0000;
        data_reg <= 4'b0000;
      end
      if(shift_reg_control) shift_reg[3:0] <= {shift_reg[2:0], serial_in};
      if(shift_data_control) data_reg <= shift_reg;
      if(inc_bit_cnt) bit_cnt <= bit_cnt + 1;
    end
  end
  
  assign parallel_data = data_reg;
  
endmodule  