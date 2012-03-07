/* 
 * File Primary Author: Derek Heyman
 * See LICENSE for license information
 */

module pacman_death(
							input reset,
							input animation_clk,
							input clk_50mhz,
							input [1:0] GhostMode,
							input [6:0] PacManPosition_x,
							input [6:0] PacManPosition_y,
							input [6:0] BlinkyPosition_x,
							input [6:0] BlinkyPosition_y,
							input [6:0] InkyPosition_x,
							input [6:0] InkyPosition_y,
							input [6:0] ClydePosition_x,
							input [6:0] ClydePosition_y,
							input [6:0] PinkyPosition_x,
							input [6:0] PinkyPosition_y,
							output reg [3:0] pacman_cur_dir, 
							output reg PacManDead
						);


reg startsequence;
reg [2:0] animation_counter;

always @(posedge animation_clk) begin
		if(PacManDead == 1) begin

			case(animation_counter[1:0])
				2'b00: pacman_cur_dir <= 4'b0001;
				2'b01: pacman_cur_dir <= 4'b0100;
				2'b10: pacman_cur_dir <= 4'b0010;
				2'b11: pacman_cur_dir <= 4'b1000;
			endcase
			animation_counter <= animation_counter + 1;
		end
end

always@ (posedge clk_50mhz) begin
	if(reset) begin
		PacManDead <= 0;
	end else begin
		// if ghosts are not BLUE and heading back to jail
		// check for collision with PacMan
		if(GhostMode != 2'b11) begin
			
			if((PacManPosition_x == BlinkyPosition_x && PacManPosition_y == BlinkyPosition_y) ||
				(PacManPosition_x == InkyPosition_x && PacManPosition_y == InkyPosition_y) ||
				(PacManPosition_x == PinkyPosition_x && PacManPosition_y == PinkyPosition_y) ||
				(PacManPosition_x == ClydePosition_x && PacManPosition_y == ClydePosition_y))
				PacManDead <= 1;
			
		end

	end
end
endmodule
