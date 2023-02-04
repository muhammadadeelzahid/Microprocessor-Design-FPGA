module Instruction_Queue(address,instruction,reset);

reg [38:0] memory [63:0];
input [5:0] address;
input reset;
output [38:0]instruction;
//reads the instructions file and stores in a variable 
initial
begin
if (!reset)
$readmemb ("memory.dat",memory);
else

$readmemb ("memory.dat",memory);
end
assign instruction = memory[address]; //returns the instruction that is pointed by the value of Program Counter

endmodule 