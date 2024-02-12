module elevator_car_tb;

	//inputs
	reg clk;
	reg init;
	reg inc;
	reg en;
	wire[7:0] q;
	
	elevator_car uut(
		.clk(clk),
		.init(init),
		.inc(inc),
		.en(en),
		.q(q)
	);
	
	initial begin 
		$monitor("time: %t. init: %b. inc: %b. en: %b. q: %b.",$time,init,inc,en,q);
		
		clk = 0;
		en = 0;
		inc = 0;
		init = 1;
		
		#10 init = 0;
		
		#15 en = 1;
		#30 inc = 1;
		#90 inc = 0;
		#50 en = 0;
		#50 inc = 1;
		#50 en = 1;
		#50 en = 0;
		#50 init = 1;
		#50 init = 0;
		#50 $finish;
	end
	always #5 clk=~clk;
endmodule
		