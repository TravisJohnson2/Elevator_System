module elevator_car(
	input clk,
	input init,
	input inc,
	input en,
	
	output reg[7:0] q
);

integer count = 0;

integer floor = 0;

	initial
		begin
			q = 0;
			q[0] = 1;
			floor = 0;
			count = 0;
		end
	
	always@ (posedge clk)
		if (count < 10)
			count = count + 1;
		else
			begin
				count = 0;
				if (init == 1)
					begin
						q = 0;
						q[0] = 1;
						floor = 0;
					end
				else if(en == 1)
					begin
					if(inc == 1)
						begin
							if (floor < 7)
								begin
									q[floor] = 0;
									floor = floor + 1;
									q[floor] = 1;
								end
						end
					else if (inc == 0)
						begin
							if (floor > 0)
								begin
									floor = floor - 1;
									q[floor] = 1;
									q[floor + 1] = 0;
								end
						end
					end
			end
		
		
endmodule