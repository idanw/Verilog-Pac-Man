`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:57:51 11/28/2011
// Design Name:   sticky_key_smooth_motion
// Module Name:   X:/Desktop/EC551/Project/Lab3/t_sticky_key_smooth_movement.v
// Project Name:  Lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sticky_key_smooth_motion
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_sticky_key_smooth_movement;

	// Inputs
	reg [3:0] move_dir;
	reg [3:0] valid_dir;
	reg reset;
	reg clk;

	// Outputs
	wire [9:0] position_x;
	wire [8:0] position_y;

	// Instantiate the Unit Under Test (UUT)
	sticky_key_smooth_motion uut (
		.position_x(position_x), 
		.position_y(position_y), 
		.move_dir(move_dir), 
		.valid_dir(valid_dir), 
		.reset(reset), 
		.clk(clk)
	);

	initial begin
		// Initialize Inputs
		move_dir = 0;
		valid_dir = 0;
		reset = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100;
      #10 clk = 1; #10 clk = 0;
		reset = 1;
		#10 clk = 1; #10 clk = 0;
		reset = 0;
		#10 clk = 1; #10 clk = 0;
		move_dir = 4'b0010;
		valid_dir = 4'b0111;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		move_dir = 4'b0100;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		valid_dir = 4'b0110;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		move_dir = 4'b0010;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;		
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		move_dir = 4'b0001;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		valid_dir = 4'b0001;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		// Add stimulus here

	end
      
endmodule

