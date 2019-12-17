`timescale 1ns/1ns

module local_oscillator(
  input clk,
  input rst,
  input start,
  output  [15:0]  sin,
  output  [15:0]  cos
  );

//parameter
parameter   idle = 2'b00;
parameter   direction = 2'b01;
parameter   address_0 = 2'b10;
parameter   address_1 = 2'b11;
 
//register  
reg [15:0]  sample[255:0];
reg [15:0]  reg_sin, reg_cos;
reg [7:0]   add_sin, add_cos = 255;
reg [1:0]   part = 0;
reg         dir = 0;
//control signal
reg [1:0]   state, next_state;
reg         start_control, inc_dir_part_control;
reg         add_update_0_control, add_update_1_control; 
reg         assign_control;

//sample data
initial 
  $readmemb("sample.txt", sample);
  
//CU
always @(state or dir or add_sin) begin
  next_state = state;
  start_control = 0;
  inc_dir_part_control = 0;
  add_update_0_control = 0;
  add_update_1_control = 0;
  assign_control = 0;
  case(state)
    idle:
      if(start) begin 
        next_state = direction;
        start_control = 1;
      end
    direction:
      if(dir) next_state = address_1;
      else next_state = address_0;
    address_0:
    begin
      if(add_sin == 254) inc_dir_part_control = 1;
      add_update_0_control = 1;
      assign_control = 1;
      next_state = direction;
      end
    address_1:
    begin
      if(add_sin == 1) inc_dir_part_control = 1;
      add_update_1_control = 1;
      assign_control = 1;
      next_state = direction;
      end
    default: next_state = idle;
  endcase
end

//DU
always @(posedge clk) begin 
  if(rst == 0) begin
    state <= idle;
    add_sin <= 0;
    add_cos <= 255;
    dir <= 0;
    part <= 0;
    end
  else begin
    state <= next_state;
    if(start_control) begin
      add_sin <= 0;
      add_cos <= 255;
      part <= 0;
      dir <= 0;
      end
    if(inc_dir_part_control) begin
      part <= part + 1;
      dir <= dir + 1;
      end
    if(add_update_0_control) begin
      add_sin <= add_sin + 1;
      add_cos <= add_cos - 1;
      end
    if(add_update_1_control) begin 
      add_sin <= add_sin - 1;
      add_cos <= add_cos + 1;
      end
    if(assign_control) begin 
      case(part)
        2'b00: begin reg_sin <= sample[add_sin]; reg_cos <= sample[add_cos]; end
        2'b01: begin reg_sin <= sample[add_sin]; reg_cos <= -sample[add_cos]; end
        2'b10: begin reg_sin <= -sample[add_sin]; reg_cos <= -sample[add_cos]; end
        2'b11: begin reg_sin <= -sample[add_sin]; reg_cos <= sample[add_cos]; end
        default: reg_sin <= sample[0];
        endcase 
      end
    end
  end

assign  sin = reg_sin;
assign  cos = reg_cos;
  
endmodule