/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module ghost_ai_generic(	
				input reset,
				input clk_25mhz,
				input [4:0] GhostPosition_x,
				input [4:0] GhostPosition_y,
				input [5:0] PacManPosition_x,
				input [4:0] PacManPosition_y,
				input [3:0] validDirection,
				input [3:0] BlinkyDirActual,
				output reg [3:0] BlinkyDirection
				);
	
	reg [3:0] last_valid_dir;

	wire [3:0] move_xor_mask;
	assign move_xor_mask = (last_valid_dir == 4'b0010) ? 4'b0001 
							: (last_valid_dir == 4'b0001) ? 4'b0010 
							: (last_valid_dir == 4'b0100) ? 4'b1000
							: 4'b0100;
	
	wire [3:0] move_pacman_mask;
	assign move_pacman_mask = {	(PacManPosition_y > GhostPosition_y),
								(PacManPosition_y < GhostPosition_y),
								(PacManPosition_x > GhostPosition_x),
								(PacManPosition_x < GhostPosition_x)
							};
	wire non_determined;
	wire [3:0] determined_movement;
	assign determined_movement = (move_pacman_mask & (~move_xor_mask) & validDirection);
	assign non_determined = ~((determined_movement == 4'b0001) | (determined_movement == 4'b0010)
									| (determined_movement == 4'b0100) | (determined_movement == 4'b1000));
	
	always @(posedge clk_25mhz) begin
		case(BlinkyDirActual)
			4'b0001: last_valid_dir <= 4'b0001;
			4'b0010: last_valid_dir <= 4'b0010;
			4'b0100: last_valid_dir <= 4'b0100;
			4'b1000: last_valid_dir <= 4'b1000;
			default: last_valid_dir <= last_valid_dir;
		endcase
	end
	
	
	wire [5:0] x_left_dist, x_right_dist, y_up_dist, y_down_dist;
	assign x_left_dist = (PacManPosition_x - GhostPosition_x);
	assign x_right_dist = (GhostPosition_x - PacManPosition_x);
	assign y_up_dist = (GhostPosition_y - PacManPosition_y);
	assign y_down_dist = (PacManPosition_y - GhostPosition_y);
	
	wire last_valid_dir_still_valid;
	assign last_valid_dir_still_valid = ((last_valid_dir & validDirection) != 4'b0000);
	
	always @(posedge clk_25mhz) begin
			case(validDirection)
				4'b0000: BlinkyDirection <= 4'b0000;
				4'b0001: BlinkyDirection <= 4'b0001;
				4'b0010: BlinkyDirection <= 4'b0010;
				4'b0100: BlinkyDirection <= 4'b0100;
				4'b1000: BlinkyDirection <= 4'b1000;
				4'b1100: BlinkyDirection <= validDirection ^ move_xor_mask;
				4'b0011: BlinkyDirection <= validDirection ^ move_xor_mask;
				4'b1001: BlinkyDirection <= validDirection ^ move_xor_mask;
				4'b1010: BlinkyDirection <= validDirection ^ move_xor_mask;
				4'b0101: BlinkyDirection <= validDirection ^ move_xor_mask;
				4'b0110: BlinkyDirection <= validDirection ^ move_xor_mask;
				4'b1110: begin
					case(determined_movement)
						4'b0010: BlinkyDirection <= 4'b0010;
						4'b0100: BlinkyDirection <= 4'b0100;
						4'b1000: BlinkyDirection <= 4'b1000;
						4'b0110: begin //up, right
							if(y_up_dist > x_right_dist) BlinkyDirection <= 4'b0100;
							else BlinkyDirection <= 4'b0010;
						end
						4'b1010: begin //down, right
							if(y_down_dist > x_right_dist) BlinkyDirection <= 4'b1000;
							else BlinkyDirection <= 4'b0010;
						end
						default: BlinkyDirection <= 4'b0100;
					endcase
				end 
				4'b1101: begin
					case(determined_movement)
						4'b0001: BlinkyDirection <= 4'b0001;
						4'b0100: BlinkyDirection <= 4'b0100;
						4'b1000: BlinkyDirection <= 4'b1000;
						4'b0101: begin //up, left
							if(y_up_dist > x_left_dist) BlinkyDirection <= 4'b0100;
							else BlinkyDirection <= 4'b0001;
						end
						4'b1010: begin //down, left
							if(y_down_dist > x_left_dist) BlinkyDirection <= 4'b1000;
							else BlinkyDirection <= 4'b0010;
						end
						default: BlinkyDirection <= 4'b1000;
					endcase
				end
				4'b1011: begin
					case(determined_movement)
						4'b0001: BlinkyDirection <= 4'b0001;
						4'b0010: BlinkyDirection <= 4'b0010;
						4'b1000: BlinkyDirection <= 4'b1000;
						4'b1001: begin //down, left
							if(y_down_dist > x_left_dist) BlinkyDirection <= 4'b1000;
							else BlinkyDirection <= 4'b0001;
						end
						4'b1010: begin //down, right
							if(y_down_dist > x_right_dist) BlinkyDirection <= 4'b1000;
							else BlinkyDirection <= 4'b0010;
						end
						default: BlinkyDirection <= 4'b1000;
					endcase
				end
				4'b0111: begin
					case(determined_movement)
						4'b0001: BlinkyDirection <= 4'b0001;
						4'b0010: BlinkyDirection <= 4'b0010;
						4'b0100: BlinkyDirection <= 4'b0100;
						4'b0101: begin //up, left
							if(y_up_dist > x_left_dist) BlinkyDirection <= 4'b0100;
							else BlinkyDirection <= 4'b0001;
						end
						4'b0110: begin //up, right
							if(y_up_dist > x_right_dist) BlinkyDirection <= 4'b0100;
							else BlinkyDirection <= 4'b0010;
						end
						default: BlinkyDirection <= 4'b0100;
					endcase
				end
				4'b1111: begin
					case(determined_movement)
						4'b0001: BlinkyDirection <= 4'b0001;
						4'b0010: BlinkyDirection <= 4'b0010;
						4'b0100: BlinkyDirection <= 4'b0100;
						4'b1000: BlinkyDirection <= 4'b1000;
						4'b0101: begin //up, left
							if(y_up_dist > x_left_dist) BlinkyDirection <= 4'b0100;
							else BlinkyDirection <= 4'b0001;
						end
						4'b0110: begin //up, right
							if(y_up_dist > x_right_dist) BlinkyDirection <= 4'b0100;
							else BlinkyDirection <= 4'b0010;
						end
						4'b1001: begin //down, left
							if(y_down_dist > x_left_dist) BlinkyDirection <= 4'b1000;
							else BlinkyDirection <= 4'b0001;
						end
						4'b1010: begin //down, right
							if(y_down_dist > x_right_dist) BlinkyDirection <= 4'b1000;
							else BlinkyDirection <= 4'b0010;
						end
						default: BlinkyDirection <= 4'b0100;
					endcase
				end
				
			endcase
	end
endmodule
