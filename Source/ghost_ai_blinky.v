`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:29:36 11/28/2011 
// Design Name: 
// Module Name:    Ghost_AI_Blinky 
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

module ghost_ai_blinky(	
								input reset,
								input [4:0] GhostPosition_x,
								input [4:0] GhostPosition_y,
								input [5:0] PacManPosition_x,
								input [4:0] PacManPosition_y,
								input [3:0] validDirection,
								//input [3:0] PacManDirection,
								output reg [3:0] BlinkyDirection
								);
								
//max x 19 x 16 = 304 ==> 9 bits
//max y 23 x 16 = 368 ==> 9 bits
	 

// http://home.comcast.net/~jpittman2/pacman/pacmandossier.html#Chapter_4
// http://donhodges.com/pacman_pinky_explanation.htm


// validDirection 4'bxxx1 = Left 
// validDirection 4'bxx1x = Right
// validDirection 4'bx1xx = Up
// validDirection 4'b1xxx = Down

// (x,y) = (0,0) is top left
// (x,y) = (40,30) is bottom right

//Blinky's Target is PacMan's current position
//BlinkyDirection: 0 = Do Nothing, 1 = Left, 2 = Right, 3 = Up, 4 = Down

/*I know most of you probably aren't going to read this, 
but next week I turn 19 and I want to become a walrus. I
know there's a million people out there just like me, but 
I promise you I'm different. On December 14th, I'm moving 
to Antartica (home of the greatest walruses). I've already 
cut off my arms, and now slide on my stomach everywhere I
go as training. I may not be a walrus yet, but I promise 
you if you give me a chance and the support I need, I will
become the greatest walrus ever. -- anonymous */

	wire [3:0] move_xor_mask;
	assign move_xor_mask = (BlinkyDirection == 4'b0010) ? 4'b0001 
							: (BlinkyDirection == 4'b0001) ? 4'b0010 
							: (BlinkyDirection == 4'b0100) ? 4'b1000
							: 4'b0100;

always@ * begin
	
	if(!reset) begin
		
		case(validDirection)
			4'b0000: BlinkyDirection <= 4'b0000;	
			4'b0001: BlinkyDirection <= 4'b0001;
			4'b0010: BlinkyDirection <= 4'b0010;
			4'b0011: begin // can go Left or Right
							
							// if PacMan directly above go Left
							if(((GhostPosition_x == PacManPosition_x)) && ((GhostPosition_y > PacManPosition_y)))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan directly below go Right
							else if(((GhostPosition_x == PacManPosition_x)) && ((PacManPosition_y > GhostPosition_y)))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Right go Right
							else if(PacManPosition_x > GhostPosition_x)
								BlinkyDirection <= 4'b0010;
								
							// if PacMan to the Left go Left
							else if(GhostPosition_x > PacManPosition_x)
								BlinkyDirection <= 4'b0001;
							
							else
								BlinkyDirection <= BlinkyDirection;
															
						end
			4'b0100: BlinkyDirection <= 4'b0100;
			4'b0101: begin // can go Up or Left
			
							// if PacMan directly above go Up
							if((GhostPosition_x == PacManPosition_x)  && (GhostPosition_y > PacManPosition_y))
								BlinkyDirection <= 4'b0100;
							
							// if PacMan directly to the Left go Left
							else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan directly to the Right go Up
							else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0100;
								
							// if PacMan directly below go Left
							else if((GhostPosition_x == PacManPosition_x)  && (PacManPosition_y > GhostPosition_y))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Left and Up and Up is closer go Up
							else if((GhostPosition_y > PacManPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_y - PacManPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan to the Left and Up and Left is closer go Left
							else if((GhostPosition_y > PacManPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (GhostPosition_y - PacManPosition_y)))
							
									BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Down and Right is closer go Go Up
							else if((PacManPosition_y > GhostPosition_y) &&
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (PacManPosition_y - GhostPosition_y)))
								
									BlinkyDirection <= 4'b0100;
									
							// if PacMan Up and to the Right go Up
							else if((GhostPosition_y > PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0100;
							
							//if PacMan Down and to the Left go Left
							else if((PacManPosition_y > GhostPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
	
															
							// if PacMan to the Right and Down and Down is closer go Go Left
							else if((PacManPosition_y > GhostPosition_y) &&
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b0001;
							
							else
								BlinkyDirection <= BlinkyDirection;
				
						end
			4'b0110: begin // can go Up or Right
							
							// if PacMan directly above go Up
							if((GhostPosition_x == PacManPosition_x) && (GhostPosition_y > PacManPosition_y))
								BlinkyDirection <= 4'b0100;
								
							// if PacMan directly to the Right go Right
							else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan directly to the Left go Up
							else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0100;
								
							// if PacMan directly below go Right
							else if((GhostPosition_x == PacManPosition_x)  && (PacManPosition_y > GhostPosition_y))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Right and Up and Up is closer go Up
							else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((GhostPosition_y - PacManPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan to the Right and Up and Right is closer go Right
							else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (GhostPosition_y - PacManPosition_y)))
								
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Down and Left is closer go Up
							else if((PacManPosition_y > GhostPosition_y) &&
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (PacManPosition_y - GhostPosition_y)))
								
									BlinkyDirection <= 4'b0100;
									
							// if PacMan Up and to the Left go Up
							else if((GhostPosition_y > PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0100;
							
							//if PacMan Down and to the Right go Right
							else if((PacManPosition_y > GhostPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Right
							else if((PacManPosition_y > GhostPosition_y) &&
								(GhostPosition_x > PacManPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (GhostPosition_x - PacManPosition_x)))
									
									BlinkyDirection <= 4'b0010;
									
							else
								BlinkyDirection <= BlinkyDirection;
						
						
						end
			4'b0111: begin // can go Left, Right, or Up
			
							// if PacMan directly above go Up
							if((GhostPosition_x == PacManPosition_x) && (GhostPosition_y > PacManPosition_y))
								BlinkyDirection <= 4'b0100;
							
							// if PacMan directly to the Right go Right
							else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan directly to the Left go Left
							else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan directly below go Right
							else if((GhostPosition_x == PacManPosition_x) && (PacManPosition_y > GhostPosition_y))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan below and to the Right go Right
							else if((PacManPosition_y > GhostPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan below and to the Left go Left
							else if((PacManPosition_y > GhostPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
														
							// if PacMan above and to the Right and Right is closer go Right
							else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (GhostPosition_y - PacManPosition_y)))
								
									BlinkyDirection <= 4'b0010;
							
							// if PacMan above and to the Right and Up is closer go Up
							else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((GhostPosition_y - PacManPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan above and to the Left and Left is closer go Left
							else if((GhostPosition_y > PacManPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (GhostPosition_y - PacManPosition_y)))
									
									BlinkyDirection <= 4'b0001;
							
							// if PacMan above and to the Left and Up is closer go Up
							else if((GhostPosition_y > PacManPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_y - PacManPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0100;
								
							else
								BlinkyDirection <= BlinkyDirection;
															
						end
			4'b1000: BlinkyDirection <= 4'b1000;
			4'b1001: begin // can go Down or Left
							
							// if PacMan directly below go Down
							if((GhostPosition_x == PacManPosition_x) && (PacManPosition_y > GhostPosition_y))
								BlinkyDirection <= 4'b1000;

							// if PacMan directly to the Left go Left
							else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan directly to the Right go Down
							else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan directly above go Left
							else if((GhostPosition_x == PacManPosition_x) && (GhostPosition_y > PacManPosition_y))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((PacManPosition_y > GhostPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((PacManPosition_y > GhostPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (PacManPosition_y - GhostPosition_y)))
								
									BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Up and Right is closer go Down
							else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (GhostPosition_y - PacManPosition_y)))
									
									BlinkyDirection <= 4'b1000;
									
							// if PacMan Down and to the Right go Down
							else if((PacManPosition_y > GhostPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan Up and to the Left go Left
							else if((GhostPosition_y > PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Up and Up is closer go Left
							else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((GhostPosition_y - PacManPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b0001;
							
							else
								BlinkyDirection <= BlinkyDirection;
							
						end
			4'b1010: begin // can go Down or Right
			
							// if PacMan directly below go Down
							if((GhostPosition_x == PacManPosition_x) && (PacManPosition_y > GhostPosition_y))
								BlinkyDirection <= 4'b1000;
								
							// if PacMan directly to the Right go Right
							else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
								
							// if PacMan directly above go Right
							else if((GhostPosition_x == PacManPosition_x) && (GhostPosition_y > PacManPosition_y))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan directly to the Left go Down
							else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((PacManPosition_y > GhostPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((PacManPosition_y > GhostPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (PacManPosition_y - GhostPosition_y)))
								
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Up and Left is closer go Down
							else if((GhostPosition_y > PacManPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (GhostPosition_y - PacManPosition_y)))
									
									BlinkyDirection <= 4'b1000;
							
							// if PacMan Down and to the Left go Down
							else if((PacManPosition_y > GhostPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
							
							// if Pacman up and to the Right go Right
							else if((GhostPosition_y > PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Up and Up is closer go Right
							else if((GhostPosition_y > PacManPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_y - PacManPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0010;
							
							else
								BlinkyDirection <= BlinkyDirection;
						
						end
			4'b1011: begin // can go Left, Right, or Down

						// if PacMan directly below go Down
							if((GhostPosition_x == PacManPosition_x) && (PacManPosition_y > GhostPosition_y))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan directly to the Right go Right
							else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan directly to the Left go Left
							else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan directly above go Right
							else if((GhostPosition_x == PacManPosition_x) && (GhostPosition_y > PacManPosition_y))
								BlinkyDirection <= 4'b0010;
															
							// if PacMan above and to the Right go Right
							else if((GhostPosition_y > PacManPosition_y)  && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
							
							// if PacMan above and to the Left go Left
							else if((GhostPosition_y > PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((PacManPosition_y > GhostPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((PacManPosition_y > GhostPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (PacManPosition_y - GhostPosition_y)))
									
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((PacManPosition_y > GhostPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((PacManPosition_y > GhostPosition_y) && 
								(GhostPosition_x - PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (PacManPosition_y - GhostPosition_y)))
									
									BlinkyDirection <= 4'b0001;
					
							else
								BlinkyDirection <= BlinkyDirection;
								
						end
			4'b1100: begin // can go Down or Up
			
							// if PacMan directly to the Right go Up
							if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0100;
							
							// if PacMan directly to the Left go Down
							else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan below go Down
							else if(PacManPosition_y > GhostPosition_y)
								BlinkyDirection <= 4'b1000;
								
							// if PacMan above go Up
							else if(GhostPosition_y > PacManPosition_y)
								BlinkyDirection <= 4'b0100;
							
							else
								BlinkyDirection <= BlinkyDirection;
								
						end
			4'b1101: begin // can go Left, Down, or Up

						// if PacMan directly below go Down
						if((GhostPosition_x == PacManPosition_x) && (PacManPosition_y > GhostPosition_y))
							BlinkyDirection <= 4'b1000;
						
						// if PacMan directly above go Up
						else if((GhostPosition_x == PacManPosition_x) && (GhostPosition_y > PacManPosition_y))
							BlinkyDirection <= 4'b0100;
							
						// if PacMan directly to the Left go Left
						else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
						
						// if PacMan directly to the Right go Down
						else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b1000;
													
						// if PacMan above and to the Right go Up
						else if((GhostPosition_y > PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0100;
						
						// if PacMan below and to the Right go Down
						else if((PacManPosition_y > GhostPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b1000;
						
						// if PacMan to the Left and Down and Down is closer go Down
						else if((PacManPosition_y > GhostPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
						// if PacMan to the Left and Down and Left is closer go Left
						else if((PacManPosition_y > GhostPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (PacManPosition_y - GhostPosition_y)))
									
									BlinkyDirection <= 4'b0001;
						
						// if PacMan to the Left and Up and Up is closer go Up
						else if((GhostPosition_y > PacManPosition_y) && 
							(GhostPosition_x > PacManPosition_x) && 
							((GhostPosition_y - PacManPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
						// if PacMan to the Left and Up and Left is closer go Left
						else if((GhostPosition_y > PacManPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (GhostPosition_y - PacManPosition_y)))
										
									BlinkyDirection <= 4'b0001;
									
						else
								BlinkyDirection <= BlinkyDirection;
												
						end
			4'b1110: begin // can go Right, Down, or Up

						// if PacMan directly below go Down
						if((GhostPosition_x == PacManPosition_x) && (PacManPosition_y > GhostPosition_y))
							BlinkyDirection <= 4'b1000;
						
						// if PacMan directly above go Up
						else if((GhostPosition_x == PacManPosition_x) && (GhostPosition_y > PacManPosition_y))
							BlinkyDirection <= 4'b0100;
							
						// if PacMan directly to the Right go Right
						else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
						
						// if PacMan directly to the Left go Down
						else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
													
						// if PacMan above and to the Left go Up
						else if((GhostPosition_y > PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0100;
						
						// if PacMan below and to the Left go Down
						else if((PacManPosition_y - GhostPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b1000;
						
						// if PacMan to the Right and Down and Down is closer go Down
						else if((PacManPosition_y > GhostPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
						// if PacMan to the Right and Down and Right is closer go Right
						else if((PacManPosition_y > GhostPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (PacManPosition_y - GhostPosition_y)))
									
									BlinkyDirection <= 4'b0010;
						
						// if PacMan to the Right and Up and Up is closer go Up
						else if((GhostPosition_y > PacManPosition_y) && 
							(PacManPosition_x > GhostPosition_x) && 
							((GhostPosition_y - PacManPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
						// if PacMan to the Right and Up and Right is closer go Right
						else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (GhostPosition_y - PacManPosition_y)))
										
									BlinkyDirection <= 4'b0010;
									
						else
								BlinkyDirection <= BlinkyDirection;
							
						end
			4'b1111: begin // can go Right, Left, Down, or Up
							
							// if PacMan directly below go Down
							if((GhostPosition_x == PacManPosition_x) && (PacManPosition_y > GhostPosition_y))
								BlinkyDirection <= 4'b1000;
							
							// if PacMan directly above go Up
							else if((GhostPosition_x == PacManPosition_x) && (GhostPosition_y > PacManPosition_y))
								BlinkyDirection <= 4'b0100;
						
							// if PacMan directly to the Right go Right
							else if((GhostPosition_y == PacManPosition_y) && (PacManPosition_x > GhostPosition_x))
								BlinkyDirection <= 4'b0010;
								
							// if PacMan directly to the Left go Left
							else if((GhostPosition_y == PacManPosition_y) && (GhostPosition_x > PacManPosition_x))
								BlinkyDirection <= 4'b0001;
								
							// if PacMan to the Left and Up and Up is closer go Up
							else if((GhostPosition_y > PacManPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_y - PacManPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan to the Left and Up and Left is closer go Left
							else if((GhostPosition_y > PacManPosition_y) && 
									(GhostPosition_x > PacManPosition_x) && 
									((GhostPosition_x - PacManPosition_x) < (GhostPosition_y - PacManPosition_y)))
										
									BlinkyDirection <= 4'b0001;
							
							// if PacMan to the Right and Up and Up is closer go Up
							else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((GhostPosition_y - PacManPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b0100;
							
							// if PacMan to the Right and Up and Right is closer go Right
							else if((GhostPosition_y > PacManPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (GhostPosition_y - PacManPosition_y)))
								
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Right and Down and Down is closer go Down
							else if((PacManPosition_y > GhostPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (PacManPosition_x - GhostPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Right and Down and Right is closer go Right
							else if((PacManPosition_y > GhostPosition_y) && 
								(PacManPosition_x > GhostPosition_x) && 
								((PacManPosition_x - GhostPosition_x) < (PacManPosition_y - GhostPosition_y)))
									
									BlinkyDirection <= 4'b0010;
							
							// if PacMan to the Left and Down and Down is closer go Down
							else if((PacManPosition_y > GhostPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((PacManPosition_y - GhostPosition_y) < (GhostPosition_x - PacManPosition_x)))
								
									BlinkyDirection <= 4'b1000;
							
							// if PacMan to the Left and Down and Left is closer go Left
							else if((PacManPosition_y > GhostPosition_y) && 
								(GhostPosition_x > PacManPosition_x) && 
								((GhostPosition_x - PacManPosition_x) < (PacManPosition_y - GhostPosition_y)))
									
									BlinkyDirection <= 4'b0001;
							
							else
								BlinkyDirection <= BlinkyDirection;
							
						end
		endcase
	end
	
	else
		BlinkyDirection <= 0;
end


endmodule
