//Program counter that traverses the Instruction Queue and resets once all intructions are read 
module Program_Counter #(parameter n = 6)
(clock, reset, Count);
input clock, reset;
output reg [n-1:0] Count; 

always @(posedge clock, negedge reset)
begin
if (!reset)
Count = 0;
else 
Count = Count + 1;
end

endmodule
