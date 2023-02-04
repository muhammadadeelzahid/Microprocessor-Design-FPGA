//Top module with pipelined code for microprocessor design
module NuCore(KEY, HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,result,Data_A,Data_B,LEDR);


wire clock, reset,zero;
input [1:0]KEY;
output [31:0] result;
output [0:6]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
output [0:0]LEDR;


assign clock = KEY[0];
assign reset = KEY[1];

wire [5:0] count;
wire [38:0] instruction;
wire Write_A, Write_B, reset_A, reset_B, read_A, read_B;
wire [3:0] address_A, address_B;
wire [31:0] value_A, value_B;
output [31:0] Data_A, Data_B;

Program_Counter P0 (clock, reset, count); 

Instruction_Queue I0 (count, instruction,reset);

Instruction_update I1 (instruction, Write_A, Write_B,reset, reset_A, reset_B, read_A, read_B);

decoder D0 (instruction, clock,value_A, value_B, address_A, address_B);

Reg A0 (address_A, clock, value_A, Write_A, reset_A, read_A, Data_A);

Reg B0 (address_B, clock, value_B, Write_B, reset_B, read_B, Data_B);

ALU U0 (Data_A, Data_B, instruction[38:36], result, zero );

assign LEDR[0] = zero;

seg_7 s0(Data_A[3:0], HEX0);
seg_7 s1(Data_A[7:4], HEX1);
seg_7 s2(Data_B[3:0], HEX2);
seg_7 s3(Data_B[7:4], HEX3);
seg_7 s4(result[3:0], HEX4);
seg_7 s5(result[7:4], HEX5);

endmodule