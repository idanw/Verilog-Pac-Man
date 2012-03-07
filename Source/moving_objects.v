`timescale 1ns / 1ps

/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module moving_objects(pixel_color, 
							pacman_pos_x,
							pacman_pos_y,
							pixel_x, 
							pixel_y, 
							move_dir, 
							map_num,
							enable_ghosts,
							ghost_1_move,
							clk_100mhz, 
							clk_100mhz_phase,
							clk_50mhz, 
							clk_25mhz, 
							clk_24hz, 
							clk_6hz, 
							reset, 
							chip_scope_ctrl);
							
	output [2:0] pixel_color;
	input [9:0] pixel_x;
	input [8:0] pixel_y;
	input [3:0] move_dir;
	input [1:0] map_num;
	
	input [3:0] enable_ghosts;
	input [3:0] ghost_1_move;
	
	input clk_100mhz, clk_50mhz, clk_25mhz, clk_24hz, clk_6hz;
	input [1:0] clk_100mhz_phase;
	input reset;
	
	inout [35:0] chip_scope_ctrl;
	
	reg clk_3hz;
	always @(posedge clk_6hz) begin
		clk_3hz <= ~clk_3hz;
	end
	
	//Pacman Location Variables
	output [9:0] pacman_pos_x;
	output [8:0] pacman_pos_y;
	wire [3:0] pacman_cur_dir;
	
	//Ghost1 Location Variables
	wire [9:0] ghost1_pos_x;
	wire [8:0] ghost1_pos_y;
	wire [3:0] ghost1_cur_dir;

	//Ghost2 Location Variables
	wire [9:0] ghost2_pos_x;
	wire [8:0] ghost2_pos_y;
	wire [3:0] ghost2_cur_dir;
	
	//Ghost3 Location Variables
	wire [9:0] ghost3_pos_x;
	wire [8:0] ghost3_pos_y;
	wire [3:0] ghost3_cur_dir;
	
	//Ghost4 Location Variables
	wire [9:0] ghost4_pos_x;
	wire [8:0] ghost4_pos_y;
	wire [3:0] ghost4_cur_dir;

	//Collision Detection
	wire [3:0] pacman_valid_moves;
	wire [3:0] ghost1_valid_moves;
	wire [3:0] ghost2_valid_moves;
	wire [3:0] ghost3_valid_moves;
	wire [3:0] ghost4_valid_moves;
	
	//Debug Variables
	
	wire [63:0] chip_scope_out;
	wire [3:0] move_xor_mask;
	wire [3:0] move_pacman_mask;
	wire non_determined;
	wire [3:0] last_dir, determined_dirs;
	chip_scope chip_scope_probe (
    .CONTROL(chip_scope_ctrl), // INOUT BUS [35:0]
	 .CLK(clk_50mhz), // IN
    .SYNC_IN({16'b0, determined_dirs, last_dir, ghost1_valid_moves, ghost1_cur_dir, move_pacman_mask, move_xor_mask, non_determined, pacman_pos_x, pacman_pos_y, pacman_valid_moves}), // IN BUS [63:0]
    .SYNC_OUT(chip_scope_out) // OUT BUS [63:0]
	);	

	//assign ghost1_pos_x = chip_scope_out[9:0];
	//assign ghost1_pos_y = chip_scope_out[18:10];
	//assign ghost1_cur_dir = chip_scope_out[22:19];
	
	wire [2:0] blinky_dir;
	wire [3:0] blinky_dir_unpacked;
	wire [2:0] blinky_dir_packed;
	wire [4:0] BlinkyTargetPosition_x, BlinkyTargetPosition_y, InkyPosition_x,InkyPosition_y,ClydePosition_x,ClydePosition_y,PinkyPosition_x,PinkyPosition_y;
	
	
	wire [3:0] ghost2_move_dir, ghost3_move_dir, ghost4_move_dir;
	ghost_ai_generic ai_blink(	
				reset,
				clk_25mhz,
				ghost1_pos_x[9:4],
				ghost1_pos_y[8:4],
				pacman_pos_x[8:4],
				pacman_pos_y[8:4],
				//BlinkyTargetPosition_x,
				//BlinkyTargetPosition_y,
				ghost1_valid_moves,
				ghost1_cur_dir,
				blinky_dir_unpacked
				//move_xor_mask, move_pacman_mask, non_determined, last_dir, determined_dirs
				);
				
	ghost_ai_generic ai_pinky(	
				reset,
				clk_25mhz,
				ghost2_pos_x[9:4],
				ghost2_pos_y[8:4],
				pacman_pos_x[8:4],
				pacman_pos_y[8:4],
				//InkyPosition_x,
				//InkyPosition_y,
				ghost2_valid_moves,
				ghost2_cur_dir,
				ghost2_move_dir);

	/*ghost_ai_generic ai_inky(	
				reset,
				clk_25mhz,
				ghost3_pos_x[9:4],
				ghost3_pos_y[8:4],
				pacman_pos_x[9:4],
				pacman_pos_y[8:4],
				ghost3_valid_moves,
				ghost3_cur_dir,
				ghost3_move_dir);*/

	ghost_ai_generic ai_clyde(	
				reset,
				clk_25mhz,
				ghost4_pos_x[9:4],
				ghost4_pos_y[8:4],
				pacman_pos_x[8:4],
				pacman_pos_y[8:4],
				//ClydePosition_x,
				//ClydePosition_y,
				ghost4_valid_moves,
				ghost4_cur_dir,
				ghost4_move_dir);
				
	ghost_ai_blinky ai_inky(	
								reset,
								ghost3_pos_x[9:4],
								ghost3_pos_y[8:4],
								pacman_pos_x[8:4],
								pacman_pos_y[8:4],
								//ClydePosition_x,
								//ClydePosition_y,
								ghost3_valid_moves,
								ghost3_move_dir
								);							
	/*always @(posedge clk_50mhz) begin				
		case(blinky_dir_packed)
			3'b000: blinky_dir_unpacked = 4'b0000;
			3'b001: blinky_dir_unpacked = 4'b0001;
			3'b010: blinky_dir_unpacked = 4'b0010;
			3'b011: blinky_dir_unpacked = 4'b0100;
			3'b100: blinky_dir_unpacked = 4'b1000;
			default: blinky_dir_unpacked = 4'b0000;
		endcase
		
	end*/
	wire ghost_mode;
	assign ghost_mode_bits = chip_scope_out[18:17];
	ghost_mode gm( clk_50mhz,
						ghost_mode_bits,
						pacman_pos_x[8:4],
						pacman_pos_y[8:4],
						map_num[0],
						
						//send to AI modules as PacMan position
						BlinkyTargetPosition_x,
						BlinkyTargetPosition_y,
						InkyPosition_x,
						InkyPosition_y,
						ClydePosition_x,
						ClydePosition_y,
						PinkyPosition_x,
						PinkyPosition_y
						);

	wire pacman_dead;
	wire [3:0] pacman_death_dir;
	pacman_death pd( 	reset,
							clk_3hz,
							clk_50mhz,
							ghost_mode_bits,
							pacman_pos_x[8:2],
							pacman_pos_y[8:2],
							ghost1_pos_x[8:2],
							ghost1_pos_y[8:2],
							ghost2_pos_x[8:2],
							ghost2_pos_y[8:2],
							ghost3_pos_x[8:2],
							ghost3_pos_y[8:2],
							ghost4_pos_x[8:2],
							ghost4_pos_y[8:2],
							pacman_death_dir, 
							pacman_dead
						);


	defparam pacman_motion.def_pos_x = 10'b00_1001_0000;
	defparam pacman_motion.def_pos_y = 9'b1_0001_0000;
	motion_handler pacman_motion(	pacman_pos_x, 
											pacman_pos_y, 
											pacman_cur_dir, 
											pacman_dead ? 4'b0000 : move_dir, 
											pacman_valid_moves,
											10'b00_1001_0000, //9
											9'b1_0001_0000,   //17 pacman default
											clk_24hz, 
											reset);
											
	defparam ghost1_motion.def_pos_x = 10'b00_1000_0000;
	defparam ghost1_motion.def_pos_y = 9'b0_1011_0000;										
	motion_handler ghost1_motion(	ghost1_pos_x, 
											ghost1_pos_y, 
											ghost1_cur_dir, 
											(pacman_dead ? 4'b0000 : (enable_ghosts[0] ? blinky_dir_unpacked : ghost_1_move)),
											//chip_scope_out[16] ? (pacman_dead ? 4'b0000 : blinky_dir_unpacked) : chip_scope_out[3:0], 
											ghost1_valid_moves,
											10'b00_1000_0000, //box far left
											9'b0_1011_0000,   //box bottom row
											clk_24hz, 
											reset);
											
	defparam ghost2_motion.def_pos_x = 10'b00_1001_0000;
	defparam ghost2_motion.def_pos_y = 9'b0_1011_0000;		
	motion_handler ghost2_motion(	ghost2_pos_x, 
											ghost2_pos_y, 
											ghost2_cur_dir, 
											((pacman_dead | ~enable_ghosts[1]) ? 4'b0000 : ghost2_move_dir),
											//pacman_dead ? 4'b0000 : chip_scope_out[7:4], 
											ghost2_valid_moves,
											10'b00_1001_0000, //box middle
											9'b0_1011_0000,   //box bottom row
											clk_24hz, 
											reset);
											
	defparam ghost3_motion.def_pos_x = 10'b00_1010_0000;
	defparam ghost3_motion.def_pos_y = 9'b0_1011_0000;		
	motion_handler ghost3_motion(	ghost3_pos_x, 
											ghost3_pos_y, 
											ghost3_cur_dir, 
											//pacman_dead ? 4'b0000 : chip_scope_out[11:8], 
											((pacman_dead | ~enable_ghosts[2]) ? 4'b0000 : ghost3_move_dir),
											ghost3_valid_moves,
											10'b00_1010_0000, //box far right
											9'b0_1011_0000,   //box bottom row
											clk_24hz, 
											reset);
											
	defparam ghost4_motion.def_pos_x = 10'b00_1001_0000;
	defparam ghost4_motion.def_pos_y = 9'b0_1010_0000;		
	motion_handler ghost4_motion(	ghost4_pos_x, 
											ghost4_pos_y, 
											ghost4_cur_dir, 
											((pacman_dead | ~enable_ghosts[3]) ? 4'b0000 : ghost4_move_dir),
											//pacman_dead ? 4'b0000 : chip_scope_out[15:12], 
											ghost4_valid_moves,
											10'b00_1001_0000, //box middle
											9'b0_1100_0000,   //box top row
											clk_24hz, 
											reset);
											
	moving_object_sprite_gen mo_sg(	pixel_color, 
												pixel_x, 
												pixel_y, 
												pacman_pos_x, 
												pacman_pos_y,  
												pacman_dead ? pacman_death_dir : pacman_cur_dir, 
												ghost1_pos_x, 
												ghost1_pos_y, 
												ghost1_cur_dir,
												ghost2_pos_x, 
												ghost2_pos_y, 
												ghost2_cur_dir,
												ghost3_pos_x, 
												ghost3_pos_y, 
												ghost3_cur_dir,
												ghost4_pos_x, 
												ghost4_pos_y, 
												ghost4_cur_dir,
												clk_3hz, 
												clk_100mhz, 
												clk_100mhz_phase);
												
	collision_detect cd(	pacman_valid_moves, 
								ghost1_valid_moves,
								ghost2_valid_moves,
								ghost3_valid_moves,
								ghost4_valid_moves,
								pacman_pos_x[9:4], 
								pacman_pos_y[8:4],
								ghost1_pos_x[9:4],
								ghost1_pos_y[8:4],
								ghost2_pos_x[9:4],
								ghost2_pos_y[8:4],
								ghost3_pos_x[9:4],
								ghost3_pos_y[8:4],
								ghost4_pos_x[9:4],
								ghost4_pos_y[8:4],
								map_num,
								clk_100mhz, 
								clk_100mhz_phase);
endmodule
