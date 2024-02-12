module elevator(
	input clk,
	input reset,
	input init,
	input[7:0] in_eb,
	input[7:0] in_up,
	input[7:0] in_down,
	output wire[7:0] q,
	output wire[7:0] q_eb,
	output wire[7:0] q_up,
	output wire[7:0] q_down
);

	//wire [7:0] q_eb;
	//wire [7:0] q_up;
	//wire [7:0] q_down;
	reg [7:0] clr_eb;
	reg [7:0] clr_up;
	reg [7:0] clr_down;
	wire f_eb;
	wire f_up;
	wire f_down;
	reg en;
	reg inc;

	parameter s0 = 2'b00; //idle
	parameter s1 = 2'b01; //up
	parameter s2 = 2'b10; //down
	
	reg[1:0] c_state, n_state; // current and next state
	
	elevator_car ec(
		.clk(clk),
		.init(init),
		.en(en),
		.inc(inc),
		.q(q)
	);
	
	elevator_button eb(
		.clk(clk),
		.reset(reset),
		.in(in_eb),
		.clr(clr_eb),
		.out(q_eb),
		.flag(f_eb)
	);
	
	elevator_button up(
		.clk(clk),
		.reset(reset),
		.in(in_up),
		.clr(clr_up),
		.out(q_up),
		.flag(f_up)
	);
	
	elevator_button down(
		.clk(clk),
		.reset(reset),
		.in(in_down),
		.clr(clr_down),
		.out(q_down),
		.flag(f_down)
	);
	
	always@(posedge clk)
		begin
			if (reset == 1)
				begin
					c_state = 0;
					n_state = 0;
				end
			else
				c_state = n_state;
				
			case(c_state)
				s0: begin
					clr_eb <= q;
					if(q_eb > q & f_eb == 1)
						n_state = s1;
					else if(eb.out < ec.q & f_eb == 1)
						n_state = s2;
					else if(up.out > ec.q & f_up == 1)
						n_state = s1;
					else if(up.out < ec.q & f_up == 1)
						n_state = s2;
					else if(down.out > ec.q & f_down == 1)
						if (ec.q < 128)
							n_state = s1;
						else
							n_state = s2;
					else if(down.out < ec.q & f_down == 1)
						n_state = s2;
					end
				s1: begin
					en = 1;
					inc = 1;
					clr_eb <= q;
					clr_up <= q;
					if(eb.out > ec.q & f_eb == 1)
						n_state = s1;
					else if (up.out > ec.q & f_up == 1)
						n_state = s1;
					else if (down.out > ec.q & f_down == 1)
						if (ec.q < 128)
							n_state = s1;
						else
							n_state = s2;
					else
						n_state = s0;
					end
				s2: begin
					en = 1;
					inc = 0; 
					clr_eb <= q;
					clr_down <= q;
					if(eb.out < ec.q & f_eb == 1)
						n_state = s2;
					else if(down.out < ec.q & f_down == 1)
						n_state = s2;
					else if(up.out < ec.q & f_up == 1)
						n_state = s2;
					else
						n_state = s0;
					end
			endcase
		end
	
endmodule