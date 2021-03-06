`timescale 1ns/1ns

module modulator(
  input clk, 
  input rst,
  input start,
  input [3:0]   parallel_data,
  input signed  [15:0]  sin,
  input signed  [15:0]  cos,
  output signed [20:0]  mixed_output
  );
  
  //parameter
  parameter idle = 1'b0;
  parameter loop = 1'b1;
  parameter signed  D = 3'b001;
  
  //register
  reg [1:0]   I, Q;
  reg signed  [2:0]   I_4level, Q_4level;
  reg signed  [19:0]  I_com, Q_com;
  reg signed  [20:0]  output_reg;  
  //control signal
  reg         state, next_state;
  reg         start_control;
  reg         load_IQ_control, dac_IQ_control;
  reg         compute_output_control;
  
  //CU 
  always @(state or start) begin
    next_state = state;
    start_control = 0;
    load_IQ_control = 0;
    dac_IQ_control = 0;
    compute_output_control = 0;
    case(state)
      idle:
      if(start) begin
        next_state = loop;
        start_control = 1;
      end
      loop:
      begin
        next_state = loop;
        load_IQ_control = 1;
        dac_IQ_control = 1;
        compute_output_control = 1;
      end
    endcase
  end
  
  //DU 
  always @(posedge clk) begin
    if(rst == 0) begin
      state <= idle;
      I <= 2'b00;
      Q <= 2'b00;
      I_4level <= 3'b000;
      Q_4level <= 3'b000;
      output_reg <= 20'b0;
    end else begin
      state = next_state;
      if(start_control) begin
        I <= 2'b00;
        Q <= 2'b00;
        I_4level <= 3'b000;
        Q_4level <= 3'b000;
        output_reg <= 20'b0;
      end
      if(load_IQ_control) begin
        I <= {parallel_data[3], parallel_data[1]};
        Q <= {parallel_data[2], parallel_data[0]};
      end
      if(dac_IQ_control) begin
        case(I)
          2'b00: I_4level <= D;
          2'b01: I_4level <= 3*D;
          2'b10: I_4level <= -D;
          2'b11: I_4level <= -3*D;
        endcase
        case(Q)
          2'b00: Q_4level <= D;
          2'b01: Q_4level <= 3*D;
          2'b10: Q_4level <= -D;
          2'b11: Q_4level <= -3*D;
        endcase
      end
      if(compute_output_control) begin
        I_com = I_4level*sin;
        Q_com = Q_4level*cos;
        output_reg = I_com + Q_com;
      end
    end
  end
  
  assign mixed_output = output_reg;
endmodule