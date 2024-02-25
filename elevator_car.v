module elevator_car(
	input clk,
	input reset,
	input inc,
	input en,
	
	output reg[7:0] q
);
	
	always@ (posedge clk)
	begin
		if (reset == 1)
			q <= 8'b0000_0001;
		else if(en == 1 )
		begin
			if(inc == 1 && q[7] != 1)
				q <= {q[6:0],1'b0};
			else if (inc == 0 && q[0] != 1)
				q <= {1'b0,q[7:1]};
		end
	end
endmodule