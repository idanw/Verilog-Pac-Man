`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:36:10 11/01/2011 
// Design Name: 
// Module Name:    keyboard_buffer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module keyboard_buffer(key_out, ps2d, ps2c, clk_50mhz, reset);
	input ps2d, ps2c, clk_50mhz, reset;
	output [7:0] key_out;
	
	wire ps2d, ps2c, clk_50mhz;
	reg [7:0] key_out;
	reg [7:0] last_key;
	wire [7:0] key_code;
	
	ps2key ps2(clk_50mhz, ps2d, ps2c, key_code);
	reg key_down;

	always @(posedge clk_50mhz) begin
		if(reset) begin
			key_out <= 8'h00;
			key_down <= 0;
			last_key <= key_code;
		end else begin
			//This makes sure we only output for 1 clock cycle
			if((key_out == last_key) || ((last_key == key_code) && key_down)) begin
				key_out <= 8'h00;
				key_down <= 1;
				last_key <= key_code;
			end else begin
				//This is valid for 1 character codes ONLY
				//It ensures that we catch the upcode (F0) and don't modify anything by setting
				//key_down equal to 1
				if(key_code == 8'hE0) begin
					last_key <= key_code;
					key_down <= key_down;
					key_out <= 8'h00;
				end else begin
					if(key_code == 8'hF0) begin
						key_down <= 1;
						key_out <= 8'h00;
						last_key <= key_code;
					end else begin
						if(key_down) begin //this indicates an endcode
							key_down <= 0;
							key_out <= 8'h00;
							last_key <= key_code;
						end else begin
							key_out <= key_code;
							last_key <= key_code;
							key_down <= 1;
						end
					end
				end
			end
		end

	
	end
	
endmodule
