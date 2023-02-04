module ALU(A,B,Sel,Out,zero_flag);
input [31:0] A,B;
output reg [63:0] Out;
input [2:0] Sel;
output reg zero_flag;
always @(*)
begin

case (Sel) 
 3:       begin  Out = A + B;   end
 4:       begin  Out = A - B;   end
 5:       begin  Out = A | B;   end
 6:       begin  Out = A & B;   end 
 7:       begin  Out = A << B;  end 
 default: begin  Out = 0;   end endcase

if (Out == 0) zero_flag = 1;
else zero_flag = 0;
end



endmodule
