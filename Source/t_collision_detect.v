`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:11:07 12/03/2011
// Design Name:   collision_detect
// Module Name:   X:/Desktop/EC551/Project/Project/t_collision_detect.v
// Project Name:  Project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: collision_detect
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_collision_detect;

	// Inputs
	reg [5:0] pacman_x;
	reg [4:0] pacman_y;
	reg [5:0] ghost1_x;
	reg [4:0] ghost1_y;
	reg [5:0] ghost2_x;
	reg [4:0] ghost2_y;
	reg [5:0] ghost3_x;
	reg [4:0] ghost3_y;
	reg [5:0] ghost4_x;
	reg [4:0] ghost4_y;
	reg clk_100mhz;
	reg [1:0] clk_100mhz_phase;

	// Outputs
	wire [3:0] pacman_valid_moves;
	wire [3:0] ghost1_valid_moves;
	wire [3:0] ghost2_valid_moves;
	wire [3:0] ghost3_valid_moves;
	wire [3:0] ghost4_valid_moves;

	// Instantiate the Unit Under Test (UUT)
	collision_detect uut (
		.pacman_valid_moves(pacman_valid_moves), 
		.ghost1_valid_moves(ghost1_valid_moves), 
		.ghost2_valid_moves(ghost2_valid_moves), 
		.ghost3_valid_moves(ghost3_valid_moves), 
		.ghost4_valid_moves(ghost4_valid_moves), 
		.pacman_x(pacman_x), 
		.pacman_y(pacman_y), 
		.ghost1_x(ghost1_x), 
		.ghost1_y(ghost1_y), 
		.ghost2_x(ghost2_x), 
		.ghost2_y(ghost2_y), 
		.ghost3_x(ghost3_x), 
		.ghost3_y(ghost3_y), 
		.ghost4_x(ghost4_x), 
		.ghost4_y(ghost4_y), 
		.clk_100mhz(clk_100mhz), 
		.clk_100mhz_phase(clk_100mhz_phase)
	);

	initial begin
		// Initialize Inputs
		pacman_x = 0;
		pacman_y = 0;
		ghost1_x = 0;
		ghost1_y = 0;
		ghost2_x = 0;
		ghost2_y = 0;
		ghost3_x = 0;
		ghost3_y = 0;
		ghost4_x = 0;
		ghost4_y = 0;
		clk_100mhz = 0;
		clk_100mhz_phase = 2'b00;

		// Wait 100 ns for global reset to finish
		#100;
      #10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		
		pacman_x = 9;
		pacman_y = 17;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;
		#10 clk_100mhz = 1; #10 clk_100mhz = 0;		
		// Add stimulus here
		
	end
      
		always@(posedge clk_100mhz) begin
			clk_100mhz_phase <= clk_100mhz_phase + 1;
		end
endmodule

