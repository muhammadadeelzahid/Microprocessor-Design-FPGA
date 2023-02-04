module decoder(instruction,clock,value_A,value_B, address_A, address_B);
input  [38:0] instruction ;
output reg [3:0] address_A,address_B;
output reg [31:0] value_A,value_B;
input clock;

wire [38:0] instruction;


always @ (posedge clock)
begin
case(instruction[38:36])
//0 : begin  value_A = 0; value_B = 0; end 
1 :        begin  value_A = instruction [31:0]; address_A = instruction[35:32];  end 
2 :        begin  value_B = instruction [31:0]; address_B = instruction[35:32];  end 
3,4,5,6,7: begin  address_A = instruction[35:32]; address_B = instruction[31:28];end
default:   begin
address_A = 4'bxxxx; address_B = 4'bxxxx;
value_A = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
value_B = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
end

 
endcase

end


endmodule