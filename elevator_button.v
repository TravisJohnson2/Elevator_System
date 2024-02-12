module elevator_button(
	input clk,
	input reset,
	input[7:0] in,
	input[7:0] clr,
	
	output reg[7:0] out,
	output reg flag // = 1 if out != 0
);

	always@ (posedge clk)
		begin if(reset == 1)
			begin
				out = 8'b00000000;
				flag = 0;
			end
		
			if(in != 8'b00000000)
				begin
					out = out | in;
					flag = 1;
				end
			if(clr != 8'b00000000)
				begin
					out = out & ~clr;;
					if(out == 8'b0000000)
						begin
							flag = 0;
						end
				end
		end
	
endmodule