`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    03:25:21 12/10/2011 
// Design Name: 
// Module Name:    ghost_mode 
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
 * File Primary Author: Derek Heyman
 * See LICENSE for license information
 */

module ghost_mode(
						input clk_50mhz,
						input [1:0] GhostMode,
						input [4:0] PacManPosition_x,
						input [4:0] PacManPosition_y,
						input level,
						input [3:0] PacManDirection,
						//send to AI modules as PacMan position
						output reg [4:0] BlinkyPosition_x,
						output reg [4:0] BlinkyPosition_y,
						output reg [4:0] InkyPosition_x,
						output reg [4:0] InkyPosition_y,
						output reg [4:0] ClydePosition_x,
						output reg [4:0] ClydePosition_y,
						output reg [4:0] PinkyPosition_x,
						output reg [4:0] PinkyPosition_y
    );


// make other ghost AI the same for now
// feed position as same 

// need a module to tell you what mode you are in

// once in jail after eaten, switch back to jail mode
// check for ghost coordinates

//scatter start go to corner flag
reg scatterstart;

// if ghost in attack need pacman target
// if ghost in scatter need to pay attention to level map corners 4 targets
// if ghost in jail target needs to be  directly above jail
// if ghost eaten taget needs to be directly above then in the jail

always@(posedge clk_50mhz) begin
	
	case(GhostMode)
		
		// get out of jail
		2'b00: begin
					
					//cooridinates of directly above jail	
					BlinkyPosition_x <= 5'b01010;
					BlinkyPosition_y <= 5'b01001;
					InkyPosition_x <= 5'b01010;
					InkyPosition_y <= 5'b01001;
					ClydePosition_x <= 5'b01010;
					ClydePosition_y <= 5'b01001;
					PinkyPosition_x <= 5'b01010;
					PinkyPosition_y <= 5'b01001;
					
				end
		
		// scatter
		2'b01:
			
				// all levels will have different innermost corners
				if(level == 0) begin
					
					if(scatterstart != 1) begin
					
						// top right corner
						BlinkyPosition_x <= 5'b01110;
						BlinkyPosition_y <= 5'b00011;
						
						// bottom right corner
						InkyPosition_x <= 5'b01110;
						InkyPosition_y <= 5'b10001;
						
						// top left corner
						PinkyPosition_x <= 5'b00100;
						PinkyPosition_y <= 5'b00011;
						
						// bottom left corner
						ClydePosition_x <= 5'b00100;
						ClydePosition_y <= 5'b10001;
						
						scatterstart <= 1;
					
					end
					
					// Blinky corner 1 top right
					if(BlinkyPosition_x == 5'b01110 && BlinkyPosition_y == 5'b00011) begin
					
						BlinkyPosition_x <= 5'b01110;
						BlinkyPosition_y <= 5'b00001;	
						
					end
					
					// Blinky corner 2
					else if(BlinkyPosition_x == 5'b01110 && BlinkyPosition_y == 5'b00001) begin
						
						BlinkyPosition_x <= 5'b10101;
						BlinkyPosition_y <= 5'b00001;	
					
					end
					
					// Blinky corner 3
					else if(BlinkyPosition_x == 5'b10101 && BlinkyPosition_y == 5'b00001) begin

						BlinkyPosition_x <= 5'b10101;
						BlinkyPosition_y <= 5'b00011;	
							
					end
					
					// Blinky corner 4
					else if(BlinkyPosition_x == 5'b10101 && BlinkyPosition_y == 5'b00011) begin
					
						BlinkyPosition_x <= 5'b01110;
						BlinkyPosition_y <= 5'b00011;	
					
					end
					
					// Inky corner 1 bottom right
					if(InkyPosition_x == 5'b01110 && InkyPosition_y == 5'b10001) begin
						
						InkyPosition_x <= 5'b01110;
						InkyPosition_y <= 5'b10101;
						
					end
					
					// Inky corner 2
					else if(InkyPosition_x == 5'b01110 && InkyPosition_y == 5'b10101) begin
						
						InkyPosition_x <= 5'b10001;
						InkyPosition_y <= 5'b10101;
						
					end
					
					// Inky corner 3
					else if(InkyPosition_x == 5'b10001 && InkyPosition_y == 5'b10101) begin
						
						InkyPosition_x <= 5'b10001;
						InkyPosition_y <= 5'b10001;
						
					end
					
					// Inky corner 4
					else if(InkyPosition_x == 5'b10001 && InkyPosition_y == 5'b10001) begin
						
						InkyPosition_x <= 5'b10001;
						InkyPosition_y <= 5'b10001;
						
					end
					
					// Pinky corner 1 top left
					if(PinkyPosition_x == 5'b00100 && PinkyPosition_y == 5'b00011) begin
						
						PinkyPosition_x <= 5'b00100;
						PinkyPosition_y <= 5'b00001;						
					
					end
					
					// Pinky corner 2
					else if(PinkyPosition_x == 5'b00100 && PinkyPosition_y == 5'b00001) begin
						
						PinkyPosition_x <= 5'b00001;
						PinkyPosition_y <= 5'b00001;						
					
					end
					
					// Pinky corner 3
					else if(PinkyPosition_x == 5'b00001 && PinkyPosition_y == 5'b00001) begin
						
						PinkyPosition_x <= 5'b00001;
						PinkyPosition_y <= 5'b00011;						
					
					end
					
					// Pinky corner 4
					else if(PinkyPosition_x == 5'b00001 && PinkyPosition_y == 5'b00011) begin
						
						PinkyPosition_x <= 5'b00100;
						PinkyPosition_y <= 5'b00011;						
					
					end
					
					// Clyde corner 1 bottom left
					if(InkyPosition_x == 5'b00100 && InkyPosition_y == 5'b10001) begin
					
						InkyPosition_x <= 5'b00100;
						InkyPosition_y <= 5'b10101;	
					
					end
					
					// Clyde corner 2
					else if(InkyPosition_x == 5'b00100 && InkyPosition_y == 5'b10101) begin
					
						InkyPosition_x <= 5'b00001;
						InkyPosition_y <= 5'b10101;
					
					end
					
					// Clyde corner 3
					else if(InkyPosition_x == 5'b00001 && InkyPosition_y == 5'b10101) begin
						
						InkyPosition_x <= 5'b00001;
						InkyPosition_y <= 5'b10001;
					
					end
					
					// Clyde corner 4
					else if(InkyPosition_x == 5'b00001 && InkyPosition_y == 5'b10001) begin
						
						InkyPosition_x <= 5'b00100;
						InkyPosition_y <= 5'b10001;
					
					end
										
				end
				
				else begin//if (level == 1) begin
										
					if(scatterstart != 1) begin
						
						// top right corner
						BlinkyPosition_x <= 5'b01111;
						BlinkyPosition_y <= 5'b00100;
						
						// bottom right corner
						InkyPosition_x <= 5'b01100;
						InkyPosition_y <= 5'b10001;
						
						// top left corner
						PinkyPosition_x <= 5'b00011;
						PinkyPosition_y <= 5'b00100;
						
						// bottom left corner
						ClydePosition_x <= 5'b00111;
						ClydePosition_y <= 5'b10011;
						
						scatterstart <= 1;
						
					end

					// Blinky corner 1 top right
					if(BlinkyPosition_x == 5'b01111 && BlinkyPosition_y == 5'b00100) begin
					
						BlinkyPosition_x <= 5'b01101;
						BlinkyPosition_y <= 5'b00011;	
						
					end
					
					// Blinky corner 2
					else if(BlinkyPosition_x == 5'b01101 && BlinkyPosition_y == 5'b00011) begin
						
						BlinkyPosition_x <= 5'b10001;
						BlinkyPosition_y <= 5'b00001;	
					
					end
					
					// Blinky corner 3
					else if(BlinkyPosition_x == 5'b10001 && BlinkyPosition_y == 5'b00001) begin

						BlinkyPosition_x <= 5'b10001;
						BlinkyPosition_y <= 5'b00101;	
							
					end
					
					// Blinky corner 4
					else if(BlinkyPosition_x == 5'b10001 && BlinkyPosition_y == 5'b00101) begin

						BlinkyPosition_x <= 5'b01111;
						BlinkyPosition_y <= 5'b00100;	
							
					end
					
					// Inky corner 1 bottom right
					if(InkyPosition_x == 5'b01100 && InkyPosition_y == 5'b10001) begin
						
						InkyPosition_x <= 5'b01100;
						InkyPosition_y <= 5'b10101;
						
					end
					
					// Inky corner 2
					else if(InkyPosition_x == 5'b01100 && InkyPosition_y == 5'b10101) begin
						
						InkyPosition_x <= 5'b01110;
						InkyPosition_y <= 5'b10101;
						
					end
					
					// Inky corner 3
					else if(InkyPosition_x == 5'b01110 && InkyPosition_y == 5'b10101) begin
						
						InkyPosition_x <= 5'b01110;
						InkyPosition_y <= 5'b10001;
						
					end
					
					// Inky corner 4
					else if(InkyPosition_x == 5'b01110 && InkyPosition_y == 5'b10001) begin
						
						InkyPosition_x <= 5'b01100;
						InkyPosition_y <= 5'b10001;
						
					end
					
					// Pinky corner 1 top left
					if(PinkyPosition_x == 5'b00011 && PinkyPosition_y == 5'b00100) begin
						
						PinkyPosition_x <= 5'b00101;
						PinkyPosition_y <= 5'b00011;						
					
					end
					
					// Pinky corner 2
					else if(PinkyPosition_x == 5'b00101 && PinkyPosition_y == 5'b00011) begin
						
						PinkyPosition_x <= 5'b00001;
						PinkyPosition_y <= 5'b00001;						
					
					end
					
					// Pinky corner 3
					else if(PinkyPosition_x == 5'b00001 && PinkyPosition_y == 5'b00001) begin
						
						PinkyPosition_x <= 5'b00001;
						PinkyPosition_y <= 5'b00101;						
					
					end
					
					// Pinky corner 4
					else if(PinkyPosition_x == 5'b00001 && PinkyPosition_y == 5'b00101) begin
						
						PinkyPosition_x <= 5'b00011;
						PinkyPosition_y <= 5'b00100;						
					
					end
					
					// Clyde corner 1 bottom left
					if(InkyPosition_x == 5'b00111 && InkyPosition_y == 5'b10011) begin
					
						InkyPosition_x <= 5'b00100;
						InkyPosition_y <= 5'b10011;	
					
					end
					
					// Clyde corner 2
					else if(InkyPosition_x == 5'b00100 && InkyPosition_y == 5'b10011) begin
					
						InkyPosition_x <= 5'b00100;
						InkyPosition_y <= 5'b10101;	
					
					end
					
					// Clyde corner 3
					else if(InkyPosition_x == 5'b00100 && InkyPosition_y == 5'b10101) begin
					
						InkyPosition_x <= 5'b00111;
						InkyPosition_y <= 5'b10101;	
					
					end
					
					// Clyde corner 4
					else if(InkyPosition_x == 5'b00111 && InkyPosition_y == 5'b10101) begin
					
						InkyPosition_x <= 5'b00111;
						InkyPosition_y <= 5'b10011;	
					
					end
					
				end
		
		// attack
		2'b10: begin
			
			BlinkyPosition_x <= PacManPosition_x;
			BlinkyPosition_y <= PacManPosition_y;
			InkyPosition_x <= PacManPosition_x;
			InkyPosition_y <= PacManPosition_y;
			
			// have ghost target 4 in front...make sure on map
			//if(PacManDirection == 4'b0001) begin
				PinkyPosition_x <= PacManPosition_x;
				PinkyPosition_y <= PacManPosition_y;
			//end
			ClydePosition_x <= PacManPosition_x;
			ClydePosition_y <= PacManPosition_y;
		
		end
		
		// go back to jail
		2'b11: begin
					
			BlinkyPosition_x <= 5'b01010;
			BlinkyPosition_y <= 5'b01100;
			InkyPosition_x <= 5'b01010;
			InkyPosition_y <= 5'b01100;
			PinkyPosition_x <= 5'b01010;
			PinkyPosition_y <= 5'b01100;
			ClydePosition_x <= 5'b01010;
			ClydePosition_y <= 5'b01100;
			
		end
		
	endcase
end

endmodule
