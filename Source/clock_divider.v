`timescale 1ns / 1ps
/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module clock_divider(out, out8x, clk);
	output out, out8x;
	input clk;
	reg out, out8x;
	reg [20:0] counter;

	
	always @(posedge clk) begin
		if(counter == 21'b1_1111_1111_1111_1111_1111) out <= ~out;
		if(counter[17:0] == 18'b11_1111_1111_1111_1111) out8x <= ~out8x;
		counter <= counter + 1;
	end

endmodule
 
