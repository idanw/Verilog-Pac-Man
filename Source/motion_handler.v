`timescale 1ns / 1ps

/* 
 * File Primary Author: Greg Zoeller
 * See LICENSE for license information
 */

module motion_handler(xpos, ypos, curdir, movdir, validdir, default_pos_x, default_pos_y, clk, rst);
	 input[3:0] movdir, validdir;
	 input clk, rst;
	 output [9:0] xpos;
	 output [8:0] ypos;
	 output [3:0] curdir;
	 input  [9:0] default_pos_x;
	 input  [8:0] default_pos_y;
	 reg [9:0] xpos;
	 reg [8:0] ypos;
	 reg [3:0] nextdir;
	 reg [3:0] curdir;
	 reg [3:0] counter;
	 reg phase;
	 parameter def_pos_x = 10'b00_1001_0000;
	 parameter def_pos_y = 9'b1_0001_0000;
	parameter LEFT =4'b0001;
	parameter RIGHT= 4'b0010;
	parameter UP= 4'b0100;
	parameter DOWN =4'b1000; 
	 

	 
	 always@ (posedge clk) begin
		 if (rst) begin
			xpos <= def_pos_x;//default_pos_x;//10'b00_1001_0000;///9
			ypos <= def_pos_y;//default_pos_y;//9'b1_0001_0000;//17
			nextdir <=0;
			curdir <= 0;
			counter <=0;
			phase <= 0;
		 end else begin
			nextdir <= movdir;
			phase <= ~phase;
			
			if(phase) begin
				if(curdir == LEFT) 
				begin
					if(xpos == 10'b00_0000_0000) xpos <= 10'b01_0010_0000;
					else xpos <= xpos - 1;
					if (counter < 15)
						begin
							counter <= counter -1;
						end
					else if( counter == 15)
						begin
							counter <= 0;
						end
				end
				
				else if(curdir == RIGHT)
					begin
						if(xpos == 10'b01_0010_0000) xpos <= 10'b00_0000_0000;
						else xpos <= xpos + 1;
						if (counter<15)
							begin
								counter <= counter +1;
							end
						else if( counter == 15)
							begin
								counter <= 0;
							end
					end
					
				else if(curdir == UP)
					begin
						if(ypos == 9'b0_0000_0000)  ypos <= 9'b1_0101_1111;
						else ypos <= ypos -1;
						
						if (counter<15)
							begin
								counter <= counter -1;
							end
						else if( counter == 15)
							begin
								counter <= 0;
							end
					end
				else if(curdir == DOWN)
					begin
						if(ypos == 9'b1_0101_1111) ypos <= 9'b0_0000_0000;
						else ypos <= ypos + 1;
						
						if (counter<15)
							begin
								counter <= counter +1;
							end
						else if( counter == 15)
							begin
								counter <= 0;
							end
					end
			end else begin
				if(curdir == LEFT && nextdir == RIGHT)
					begin
						curdir <= nextdir;
					end
				else if(curdir == RIGHT && nextdir == LEFT)
					begin
						curdir <= nextdir;
					end
				else if(curdir == UP && nextdir == DOWN)
					begin
						curdir <= nextdir;
					end
				else if(curdir == DOWN && nextdir == UP)
					begin
						curdir <= nextdir;
					end
				else if((ypos[3:0] == 4'b0000) & (xpos[3:0] == 4'b0000))
					begin
						if(((curdir & validdir) == 4'b0000) & (curdir != 4'b0000))
							begin
								curdir <= 4'b0000;
							end
						else if((nextdir & validdir) != 4'b0000)
							begin
								curdir <= nextdir;
							end
						else if(nextdir == 4'b0000)
							begin
								curdir <= 4'b0000;
							end
					end
			end
		end
	 end
	 
	 
	 
	 
endmodule
