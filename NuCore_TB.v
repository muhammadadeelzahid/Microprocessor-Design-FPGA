module NuCore_TB();
reg [1:0] KEY;
// wires                                               
wire [31:0] Data_A;
wire [31:0] Data_B;
wire [0:6] HEX0;
wire [0:6] HEX1;
wire [0:6] HEX2;
wire [0:6] HEX3;
wire [0:6] HEX4;
wire [0:6] HEX5;
wire [0:0] LEDR;
wire [31:0] result;

NuCore i1 (
	.Data_A(Data_A),
	.Data_B(Data_B),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3),
	.HEX4(HEX4),
	.HEX5(HEX5),
	.KEY(KEY),
	.LEDR(LEDR),
	.result(result)
);
always #10 KEY[0] = ~KEY[0] ;
initial
begin
	KEY[1] = 1'b1;
	KEY[0] = 1'b0;
end 

endmodule

