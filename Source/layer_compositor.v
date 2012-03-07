`timescale 1ns / 1ps

module layer_compositor(screenout, blank, scoreval, mazeval, movingval, backval);
	input [2:0] mazeval, movingval, scoreval, backval;
	input blank;
	output [2:0] screenout;
	reg [2:0] screenout;
	
	always begin
		if (blank)
			screenout = 3'b000;
		else if (scoreval != 3'b000)
			screenout = scoreval;
		else if(movingval != 3'b000)
			screenout = movingval;
		else if(mazeval != 3'b000)
			screenout = mazeval;
		else
			screenout = backval;
	end
endmodule
