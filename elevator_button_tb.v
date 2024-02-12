module elevator_button_tb;

	//inputs
	reg clk;
	reg[7:0] in;
	reg[7:0] clr;
	reg reset;

	
	
	//output
	wire[7:0] out;
	wire flag;
	
	elevator_button uut(
		.clk(clk),
		.clr(clr),
		.reset(reset),
		.in(in),
		.out(out),
		.flag(flag)
	);
	
	initial begin
		$monitor("time: %t. reset: %b. in: %b. clr: %b. out: %b",$time,reset,in,clr,out);
		
		reset = 1;
		clr = 0;
		clk = 0;
		
		#10 reset = 0;
		#11 in = 1;
		#20 in = 2;
		#30 in = 4;
		#40 in = 8;
		#45 in = 32;
		#50 in = 0;
		#50 clr = 1;
		#55 clr = 2;
		#60 clr = 4;
		#65 clr = 8;
		#70 clr = 0;
		#100 $finish;
	end
	
	always #5 clk=~clk;
endmodule