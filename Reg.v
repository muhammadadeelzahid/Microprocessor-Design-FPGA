module Reg(address,clock, value, write, reset, read, data_out);

input [3:0] address;
input [31:0] value;
input write, reset, read,clock;
output reg [31:0] data_out;
integer i;
reg [31:0] Reg [15:0];
	

	
always @(posedge clock)
	begin
		if (reset==1) begin
			for (i = 0; i < 16; i = i + 1)begin
					Reg[i] = 0; 
					 end 
					 end

					
		else if (write == 1) begin
					Reg[address] = value; end
					
		else if (read == 1) begin
					data_out = Reg[address]; end
					
		else begin
		data_out = data_out; end
		
	end

endmodule

