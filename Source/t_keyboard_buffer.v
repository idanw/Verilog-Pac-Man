`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:26:43 11/01/2011
// Design Name:   keyboard_buffer
// Module Name:   X:/Desktop/EC551/Lab3/Lab3/t_keyboard_buffer.v
// Project Name:  Lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: keyboard_buffer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_keyboard_buffer;

	// Inputs
	reg ps2d;
	reg ps2c;
	reg clk_50mhz;
	reg reset;

	// Outputs
	wire [7:0] key_out;

	// Instantiate the Unit Under Test (UUT)
	keyboard_buffer uut (
		.key_out(key_out), 
		.ps2d(ps2d), 
		.ps2c(ps2c), 
		.clk_50mhz(clk_50mhz), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		ps2d = 0;
		ps2c = 0;
		clk_50mhz = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

