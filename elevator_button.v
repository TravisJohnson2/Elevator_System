module elevator_button(
	input clk,
	input reset,
	input[7:0] in,		// button input
	input[7:0] clr,		// elevator is at this floor. Will clear current floor with the out register
	
	output reg[7:0] out, 	// buttons pressed
	output reg flag 	// = 1 if any button has been pressed
);

	always@ (posedge clk)
	begin 
		if(reset == 1)
		begin
			out <= 8'b00000000;
			flag <= 0;
		end
		
		else if(in != 8'b00000000)
		begin
			out <= out | in;	// add button pressed to out register
			flag <= 1;
		end
		else if(clr != 8'b00000000)	// clear out buttons based on elevator's current floor
		begin
			out <= out & ~clr;
			if(out == 8'b0000000)
			begin
				flag <= 0;
			end
		end
	end	
endmodule