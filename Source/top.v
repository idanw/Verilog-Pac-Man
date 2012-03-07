`timescale 1ns / 1ps
/**
 *      ___         ___           ___           ___           ___           ___     
 *     /  /\       /  /\         /  /\         /__/\         /  /\         /__/\    
 *    /  /::\     /  /::\       /  /:/        |  |::\       /  /::\        \  \:\   
 *   /  /:/\:\   /  /:/\:\     /  /:/         |  |:|:\     /  /:/\:\        \  \:\  
 *  /  /:/~/:/  /  /:/~/::\   /  /:/  ___   __|__|:|\:\   /  /:/~/::\   _____\__\:\ 
 * /__/:/ /:/  /__/:/ /:/\:\ /__/:/  /  /\ /__/::::| \:\ /__/:/ /:/\:\ /__/::::::::\
 * \  \:\/:/   \  \:\/:/__\/ \  \:\ /  /:/ \  \:\~~\__\/ \  \:\/:/__\/ \  \:\~~\~~\/
 *  \  \::/     \  \::/       \  \:\  /:/   \  \:\        \  \::/       \  \:\  ~~~ 
 *   \  \:\      \  \:\        \  \:\/:/     \  \:\        \  \:\        \  \:\     
 *    \  \:\      \  \:\        \  \::/       \  \:\        \  \:\        \  \:\    
 *     \__\/       \__\/         \__\/         \__\/         \__\/         \__\/    
 *
 *
 *
 *                                   The Game
 *                               of Life and Death
 *
 *
 * Copyright 2011 Idan Warsawski, Derek Heyman, Greg Zoeller, and Sergio Shin
 *
 * 
 * Here is an inspirational quote to guide you in your journey through this source:
 *     "People will throw 
 *      their hands up to this; 
 *      club bangerrrrr !!!" 
 *        
 *           -- HouseGalaxy (Found on YouTube)
 *
 */
/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module top(vga_red, vga_green, vga_blue, vga_hsync, vga_vsync, ps2d, ps2c, btns, switches, leds, clk_50mhz);
	output vga_red, vga_green, vga_blue, vga_hsync, vga_vsync;
	input clk_50mhz;
	input [3:0] btns;
	input [7:0] switches;
	output [7:0] leds;
	input ps2d, ps2c;
	
	
	wire [35:0] chip_scope_ctrl_0, chip_scope_ctrl_1;
	chip_scope_icon_core icon (
		 .CONTROL0(chip_scope_ctrl_0), // INOUT BUS [35:0]
		 .CONTROL1(chip_scope_ctrl_1)
	);

	//VGA Counting Variables
	wire [10:0] h_counter;
	wire [10:0] v_counter;
	wire blank;
	
	reg [1:0] map_num;
	
	wire [3:0] pacman_valid_moves;
	
	//Clocking Variables
	wire clk_6hz, clk_24hz, clk_25mhz, clk_100mhz;
	wire [1:0] clk_100mhz_phase;
	wire vga_red, vga_green, vga_blue;
	
	//Keyboard Variables
	wire [7:0] kb_out;
	
	
	//Debug Variables
	reg [7:0] leds;
	reg [2:0] enable_effect;
	
	//Map Controller Variables
	wire [2:0] map_pix_color;

	//Score Controller Variables
	wire [3:0] score_pixel_color;
	
	keyboard_buffer kb(kb_out, ps2d, ps2c, clk_50mhz, btns[3]);



	
	
	reg [3:0] move_dir;
	
	wire [2:0] moving_piece_color;
	wire [2:0] background_pixel_color;




	wire map_ctrl_is_dot;
	wire map_ctrl_hide_dot;
	wire [9:0] pacman_pos_x;
	wire [8:0] pacman_pos_y;

	reg [3:0] enable_ghosts;
	reg [3:0] ghost_1_move;
	always @(posedge clk_50mhz) begin
		leds <= {3'b000, map_ctrl_is_dot, pacman_valid_moves};
	end
	
	always @(posedge clk_50mhz) begin
			
		case(kb_out)
			8'h1D:	begin //up
							move_dir <= 4'b0100;
							//ctl_v <= ctl_v - possible_dir[2];
							//ctl_h <= ctl_h;
						end
			8'h1C:	begin //left
							move_dir <= 4'b0001;
							//ctl_v <= ctl_v;
							//ctl_h <= ctl_h - possible_dir[0];
						end
			8'h1B:	begin  //down
							move_dir <= 4'b1000;
							//ctl_v <= ctl_v + possible_dir[3];
							//ctl_h <= ctl_h;
						end
			8'h23:	begin //right
							move_dir <= 4'b0010;
							//ctl_v <= ctl_v;
							//ctl_h <= ctl_h + possible_dir[1];
						end
			8'h76:	begin //esc
							move_dir <= 4'b0000;
							//ctl_v <= 5'b00000;
							//ctl_h <= 6'b000000;
						end
			8'h16:	begin //1
							//move_dir <= 4'b0000;
							//ctl_v <= 5'b00000;
							//ctl_h <= 6'b000000;
							enable_effect[0] <= 1;
						end
			8'h1E:	begin //2
							//move_dir <= 4'b0000;
							//ctl_v <= 5'b00000;
							//ctl_h <= 6'b000000;
							enable_effect[0] <= 0;
						end
			8'h26:	begin //3
							//move_dir <= 4'b0000;
							map_num <= 2'b00;
							//ctl_v <= 5'b00000;
							//ctl_h <= 6'b0100000;
						end
			8'h25:	begin //4
							//move_dir <= 4'b0000;
							map_num <= 2'b01;
							//ctl_v <= 5'b00000;
							//ctl_h <= 6'b000000;
						end
						
			8'h46: enable_effect[1] <= 0; //key '9'
			8'h45: enable_effect[1] <= 1; //key '0'
			8'h4E: enable_effect[2] <= 0; //key '-'
			8'h55: enable_effect[2] <= 1; //key '='
			//F1 to F4, enable ghosts 1..4
			8'h05: enable_ghosts <= enable_ghosts | 4'b0001; 
			8'h06: enable_ghosts <= enable_ghosts | 4'b0010;
			8'h04: enable_ghosts <= enable_ghosts | 4'b0100;
			8'h0C: enable_ghosts <= enable_ghosts | 4'b1000;
			
			//F5 to F8 disable ghost AI 1..4
			8'h03: enable_ghosts <= enable_ghosts & 4'b1110;
			8'h0B: enable_ghosts <= enable_ghosts & 4'b1101;
			8'h83: enable_ghosts <= enable_ghosts & 4'b1011;
			8'h0A: enable_ghosts <= enable_ghosts & 4'b0111;
			
			
			8'h43: ghost_1_move <= 4'b0100;//I = ghost 1 up
			8'h3B: ghost_1_move <= 4'b0001;//J = ghost 1 left
			8'h42: ghost_1_move <= 4'b1000;//K = ghost 1 down
			8'h4B: ghost_1_move <= 4'b0010;//L = ghost 1 right
			
			default: begin 
							//move_dir <= 4'b0000;
							//ctl_v <= ctl_v;
							//ctl_h <= ctl_h;
							enable_effect <= enable_effect;
						end

		endcase

	end

	
	clock_manager clocking(clk_100mhz, clk_100mhz_phase, clk_25mhz, clk_6hz, clk_24hz, clk_50mhz, btns[3]);
	
	vga_controller_640_60 vga_controller(clk_25mhz, vga_hsync, vga_vsync, h_counter, v_counter, blank);
	map_controller mc(map_pix_color, 
							h_counter[9:0], 
							v_counter[8:0], 
							map_num, 
							map_ctrl_is_dot,
							map_ctrl_hide_dot,
							btns[3], 
							clk_100mhz, 
							clk_100mhz_phase, 
							clk_50mhz, 
							clk_25mhz);
	background_effects be(background_pixel_color, h_counter, v_counter, enable_effect, clk_50mhz, clk_6hz);

	moving_objects mo(moving_piece_color, 
							pacman_pos_x,
							pacman_pos_y,
							h_counter[9:0], v_counter[8:0], 
							move_dir, 
							map_num,
							enable_ghosts,
							ghost_1_move,
							clk_100mhz, clk_100mhz_phase, clk_50mhz, clk_25mhz, clk_24hz, clk_6hz, btns[3], chip_scope_ctrl_0);

						
	score_controller sc(score_pixel_color, 
							h_counter[9:0], 
							v_counter[8:0], 
							pacman_pos_x,
							pacman_pos_y,
							map_ctrl_is_dot,
							map_ctrl_hide_dot,
							map_num,
							clk_100mhz,
							clk_100mhz_phase, 
							clk_50mhz, 
							clk_25mhz, 
							chip_scope_ctrl_1);
	
	layer_compositor layering({vga_blue, vga_green, vga_red}, blank, score_pixel_color, map_pix_color, moving_piece_color, background_pixel_color);

endmodule
