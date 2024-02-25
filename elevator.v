`define IDLE    2'b00
`define UP    	2'b01
`define DOWN 	2'b10

module elevator(
	input clk,
	input reset,
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
	reg at_floor;

	parameter s0 = 2'b00; //idle
	parameter s1 = 2'b01; //up
	parameter s2 = 2'b10; //down
	
	reg[1:0] c_state, n_state; // current and next state
	
	
	elevator_car ec(
		.clk(clk),
		.reset(reset),
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
			c_state <= `IDLE;
			n_state <= `IDLE;
		end
		else
		begin
			c_state <= n_state;
				
			case(c_state)
				`IDLE: begin
					en <= 0;
					inc <= 0;
					clr_eb <= q;			// clear current floor from elevator buttons
					if(q_eb > q && f_eb == 1)	// if elevator button press > current floor, 
						n_state <= `UP;
					else if(q_eb < q && f_eb == 1)	// if elevator button press < current floor
						n_state <= `DOWN;
					else if(q_up > q && f_up == 1)	// if up button press > current floor
						n_state <= `UP;
					else if(q_up < q && f_up == 1)	// if up button press < current floor
						n_state <= `DOWN;
					else if(q_down > q && f_down == 1) // if down button > current floor
						n_state <= `UP;
					else if(q_down < q & f_down == 1) // if down button < current floor
						n_state <= `DOWN;
					else
						n_state <= `IDLE;
				end
				`UP: begin
					en <= 1;
					inc <= 1;
					clr_eb <= q;
					clr_up <= q;
					if(q_eb > q && f_eb == 1)
						n_state <= `UP;
					else if (q_up > q && f_up == 1)
						n_state <= `UP;
					else if (q_down > q && f_down == 1)
						n_state <= `UP;
					else
						n_state <= `IDLE;
				end
				`DOWN: begin
					en <= 1;
					inc <= 0; 
					clr_eb <= q;
					clr_down <= q;
					if(q_eb < q && f_eb == 1)		// if elevator button < current floor
						n_state <= `DOWN;
					else if(q_down < q && f_down == 1)	// if down button < current floor
						n_state <= `DOWN;
					else if(q_up < q && f_up == 1)		// if up button < current floor
						n_state <= `DOWN;
					else
						n_state <= `UP;
				end
			endcase
		end
	end
endmodule