`timescale 1ns / 1ps
/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module score_controller(pixel_color, 
								pixel_x, 
								pixel_y, 
								pacman_x,
								pacman_y,
								i_map_ctrl_is_dot,
								o_map_ctrl_hide_dot,
								map_num,
								clk_100mhz, 
								clk_100mhz_phase, 
								clk_50mhz, 
								clk_25mhz, 
								chip_scope_ctrl);
								
	output [2:0] pixel_color;
	input [9:0] pixel_x;
	input [8:0] pixel_y;
	input [9:0] pacman_x;
	input [8:0] pacman_y;
	input i_map_ctrl_is_dot;
	output o_map_ctrl_hide_dot;
	input [1:0] map_num;
	input clk_100mhz;
	input [1:0] clk_100mhz_phase;
	input clk_50mhz, clk_25mhz;
	inout [35:0] chip_scope_ctrl;

	reg [2:0] pixel_color;

	wire [15:0] score_sprite_out;
	reg [7:0] score_sprite_addr;
	

	wire [32:0] async_out; //27:0 before
	
	parameter FIRST_BLOCK_X = 6'b00_1100; //Start Drawing at X Block 12 = 1100
	parameter NUM_BLOCKS_X = 6'b00_0111;
	parameter FIRST_BLOCK_Y = 5'b1_0111;  //Start Drawing at Y Block 23 = 1_0111
	parameter NUM_BLOCKS_Y = 5'b0_0001;
	
	wire [9:0] pixel_x_remapped;
	assign pixel_x_remapped = pixel_x - {FIRST_BLOCK_X, 4'b0000};
	wire [8:0] pixel_y_remapped;
	assign pixel_y_remapped = pixel_y - {FIRST_BLOCK_Y, 4'b0000};
	
	
	wire [9:0] score_from_dots;

	chip_scope_2 chipy_scopey (
		 .CONTROL(chip_scope_ctrl), // INOUT BUS [35:0]
		 .ASYNC_IN(score_from_dots), // IN BUS [18:0]
		 .ASYNC_OUT(async_out) // OUT BUS [32:0]
	);

	score_sprites score_sprite (
	  .clka(clk_100mhz), // input clka
	  .addra(score_sprite_addr), // input [7 : 0] addra
	  .douta(score_sprite_out) // output [15 : 0] douta
	);
	
	
	
	wire tmp;
	//wire [18:0] tmp;
	assign o_map_ctrl_hide_dot = tmp | async_out[28];// ? async_out[29] : tmp;
	//assign o_map_ctrl_hide_dot = tmp[pixel_x[8:4]];
	
	
	dot_tracker dt (score_from_dots, 
							pacman_x, 
							pacman_y, 
							map_num,
							pixel_x,
							pixel_y,
							i_map_ctrl_is_dot,
							tmp,
							reset, 
							clk_100mhz);
					
	wire [27:0] nums_combined;
	wire [3:0] s1, s2, s3, s4, s5, s6;
	score_bcd_converter sbc(s1,s2,s3,s4,s5,s6, score_from_dots, 0, clk_50mhz, reset);
	//wire [3:0] num_1, num_2, num_3, num_4, num_5;
	assign nums_combined = {4'b0000, s1, s2, s3, s4, s5, s6};//{s6, s5, s4, s3, s2, s1, 4'b0000};
	
	always @(posedge clk_100mhz) begin
		if((pixel_x[9:4] >= FIRST_BLOCK_X) & (pixel_x[9:4] < (FIRST_BLOCK_X + NUM_BLOCKS_X))
			& (pixel_y[8:4] >= FIRST_BLOCK_Y) & (pixel_y[8:4] < (FIRST_BLOCK_Y + NUM_BLOCKS_Y))) begin
			score_sprite_addr <= {
										nums_combined[{pixel_x_remapped[6:4], 2'b11}], 
										nums_combined[{pixel_x_remapped[6:4], 2'b10}], 
										nums_combined[{pixel_x_remapped[6:4], 2'b01}], 
										nums_combined[{pixel_x_remapped[6:4], 2'b00}], 
										pixel_y_remapped[3:0]
										};
			pixel_color <= {score_sprite_out[pixel_x_remapped[3:0]], 
										score_sprite_out[pixel_x_remapped[3:0]],
										score_sprite_out[pixel_x_remapped[3:0]]};
		end else begin
			pixel_color <= 3'b000;
		end
	
	end

endmodule
