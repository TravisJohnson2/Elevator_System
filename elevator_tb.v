`timescale 1ns/100ps

module elevator_tb;
	reg clk;
	reg reset;
	reg[7:0] in_eb;
	reg[7:0] in_up;
	reg[7:0] in_down;
	wire[7:0] q;
	wire[7:0] q_eb;
	wire[7:0] q_up;
	wire[7:0] q_down;
	
	elevator uut(
		.clk(clk),
		.reset(reset),
		.in_eb(in_eb),
		.in_up(in_up),
		.in_down(in_down),
		.q(q),
		.q_eb(q_eb),
		.q_up(q_up),
		.q_down(q_down)
		
	);
	
	initial begin
		$monitor("time: %t. q_eb: %b. q_up: %b. q_down: %b. q: %b", $time, q_eb, q_up,q_down, q);
		reset = 1;
		clk = 0;
		#10 reset = 0;
		#10 in_eb = 255;
		#10 in_eb = 0;
		#20 in_up = 255;
		#10 in_up = 0;
		#20 in_down = 255;
		#10 in_down = 0;
		#1000 in_up = 64;
		#10 in_up = 0;
		#500 in_eb = 32;
		#10 in_eb = 0;
	
	end
	always #5 clk = ~clk;
endmodule