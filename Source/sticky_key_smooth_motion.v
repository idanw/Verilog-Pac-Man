`timescale 1ns / 1ps

/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 * 
 * This file is non-functional
 */

module sticky_key_smooth_motion(position_x, position_y, move_dir, valid_dir, reset, clk);
	output [9:0] position_x;
	output [8:0] position_y;
	input [3:0] move_dir;
	input [3:0] valid_dir;
	input clk, reset;
	
	reg [9:0] position_x;
	reg [8:0] position_y;
	
	reg [3:0] cur_move_dir;
	reg [3:0] buf_move_dir; //0 = left, 1 = right, 2 = up, 3 = down
	
	reg [18:0] hagga_wagga_wacca_flaca_flame;
	
	reg valid_movement, valid_movement_in_buf;
	wire x_low_zero, y_low_zero;
	
	assign x_low_zero = (position_x[3:0] == 4'b0000);
	assign y_low_zero = (position_y[3:0] == 4'b0000);
	
	
	
	//This feels like LISP with all the parenthesis...
	//Basically. The movement in the buffer can be transfered to our current "sticky" move IF
	//The direction in the buffer is
	// a) valid (first line)
	// b) the object is perfectly aligned to an y block (can be moving left/right) and the  request is
	//    a left or right move
	// c) the object is perfectly aligned to an x block (can be moving up/down in this case) and the request
	//    is an up/down move
	/*assign valid_movement_in_buf = (
												((move_dir & valid_dir) != 4'b0000) 
													& 
													(
														(y_low_zero & (move_dir[0] | move_dir[1]))
															|
														(x_low_zero & (move_dir[2] | move_dir[3]))
													)
												);

	assign valid_movement = (cur_move_dir & valid_dir) != 4'b0000;*/
	
	always @(posedge clk) begin

	//This feels like LISP with all the parenthesis...
	//Basically. The movement in the buffer can be transfered to our current "sticky" move IF
	//The direction in the buffer is
	// a) valid (first line)
	// b) the object is perfectly aligned to an y block (can be moving left/right) and the  request is
	//    a left or right move
	// c) the object is perfectly aligned to an x block (can be moving up/down in this case) and the request
	//    is an up/down move
		valid_movement_in_buf <= (
												((move_dir & valid_dir) != 4'b0000) 
													& 
													(
														(y_low_zero & (move_dir[0] | move_dir[1]))
															|
														(x_low_zero & (move_dir[2] | move_dir[3]))
													)
												);

		valid_movement <= (cur_move_dir & valid_dir) != 4'b0000;
	
		if(reset) begin
			position_x <= 10'b00_1001_0000;///9
			position_y <= 9'b1_0001_0000;//17
			cur_move_dir <= 4'b0000;
			//buf_move_dir <= 4'b0000;
			hagga_wagga_wacca_flaca_flame <= 0; //im not typing out 20 zeros
		end else begin
		
			/*//if we have a non 'stop' move command we'l
			if(move_dir != 4'b0000)
				buf_move_dir <= move_dir;
			else
				buf_move_dir <= buf_move_dir;*/
			
			/*case({valid_movement, valid_movement_in_buf})
				2'b00: begin
					cur_move_dir <= 4'b0000;
				end
				2'b01: begin 
					cur_move_dir <= move_dir;
				end
				2'b10: begin 
					cur_move_dir <= cur_move_dir;
				end
				2'b11: begin 
					cur_move_dir <= move_dir;
				end
			endcase*/
			
			hagga_wagga_wacca_flaca_flame <= hagga_wagga_wacca_flaca_flame + 1;
			
			//We will want to perform a movement if:
			// a) We know there is not a wall there (valid_movement == 1)
			// b) and if the requested movement is not valid (or if the requested 
			//		movement is the same as the direction we want to go
			//if((valid_movement) & (!valid_movement_in_buf | (cur_move_dir == move_dir))) begin
			/*if((valid_movement) & 
				(!valid_movement_in_buf | (cur_move_dir == move_dir)))begin*/ //& 
				//(hagga_wagga_wacca_flaca_flame == 19'b111_1111_1111_1111_1111)) begin
				if(hagga_wagga_wacca_flaca_flame == 19'b111_1111_1111_1111_1111) begin
				case(move_dir)
					4'b0001: begin
						position_x <= position_x - 1;
						position_y <= position_y;
					end
					4'b0010: begin
						position_x <= position_x + 1;
						position_y <= position_y;
					end
					4'b0100: begin
						position_x <= position_x;
						position_y <= position_y - 1;
					end
					4'b1000: begin
						position_x <= position_x;
						position_y <= position_y + 1;
					end
					default: begin
						position_x <= position_x;
						position_y <= position_y;
					end
				endcase
			end else begin
				position_x <= position_x;
				position_y <= position_y;
			end
		
		end
	
	end

endmodule
