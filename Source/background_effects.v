`timescale 1ns / 1ps
/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module background_effects(pixel_color, x, y, enable_effect, clk, slow_clk);
	output [3:0] pixel_color;
	input [9:0] x;
	input [8:0] y;
	input [2:0] enable_effect;
	input clk, slow_clk;
	reg [2:0] pixel_color;
	
	wire [4:0] h_count_sin;
	
	reg [5:0] h_count_increment;
	reg [5:0] increment;


	wire [6:0] x_shift;
	
	assign x_shift = x[6:0] - 6'b10_0000;
	wire [383:0] image_mem_out;

	image2 image (
	  .clka(clk), // input clka
	  .addra({enable_effect[2], y[6:0]}), // input [6 : 0] addra
	  .douta(image_mem_out) // output [383 : 0] douta
	);	
	sin_lut sin_val(h_count_sin, h_count_increment);
		
	always @(posedge clk) begin
	
		if((y[8:4] < 8) & (x[9:4] > 33) & enable_effect[1]) begin
			pixel_color <= ({image_mem_out[{x_shift[6:0] ,2'b00}],     //9-2 = 7
							image_mem_out[{x_shift[6:0] ,2'b01}],
							image_mem_out[{x_shift[6:0] ,2'b10}]});
		end else begin
			if((y[8:4] == h_count_sin) & enable_effect[0]) begin 
					if(h_count_sin[3:1] == 3'b000) begin
						pixel_color[0] <= 1;
					end else begin
						pixel_color[0] <= h_count_sin[3];
					end
					
					pixel_color[1] <= h_count_sin[1];
					pixel_color[2] <= h_count_sin[2];

			end else begin
					pixel_color <= 3'b000;
			end
			
			
				if((increment + x[9:4]) < 40)
					h_count_increment <= increment + x[9:4];
				else 
					h_count_increment <= increment + x[9:4] - 40;
		end
	end
	
	always @(posedge slow_clk) begin
			if(increment == 39) increment <= 0;
			else increment <= increment + 1;
	end
	
endmodule
