`timescale 1ns / 1ps
/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module clock_manager(clk_100mhz, clk_100mhz_phase, clk_25mhz, clk_6hz, clk_24hz, clk_50mhz, reset);
	output clk_100mhz;
	output [1:0] clk_100mhz_phase;
	output clk_25mhz;
	output clk_6hz;
	output clk_24hz;
	
	input clk_50mhz;
	input reset;
	
	wire clk_100mhz, clk_6hz, clk_24hz;

	reg clk_25mhz;
	reg [1:0] clk_100mhz_phase;
	
	quad_pump dp1 (
		.CLKIN_IN(clk_50mhz), 
		.RST_IN(1'b0), 
		//.CLK0_OUT(CLK0_OUT), 
		.CLK2X_OUT(clk_100mhz) 
		//.CLK2X180_OUT(clk_100mhz_180),
		//.LOCKED_OUT(LOCKED_OUT)
    );
	 
	always @(posedge clk_50mhz) begin
		clk_25mhz <= ~clk_25mhz;
	end
	
	always @(posedge clk_100mhz) begin
		if(clk_25mhz & clk_50mhz) begin
			clk_100mhz_phase <= 2'b01;
		end else begin
			clk_100mhz_phase <= clk_100mhz_phase + 1;
		end
	end
	
	clock_divider slow_clk(clk_6hz, clk_24hz, clk_50mhz);

endmodule
