`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:22:43 11/06/2011
// Design Name:   map_controller
// Module Name:   X:/Desktop/EC551/Lab3/Lab3/t_map_controller.v
// Project Name:  Lab3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: map_controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module t_map_controller;

	// Inputs
	reg [9:0] x;
	reg [8:0] y;
	reg clk;
	reg clk_25mhz;
	reg reset;
	reg [1:0] map_num;
	// Outputs
	wire [2:0] block_color;
	wire [3:0] valid_dir;

	// Instantiate the Unit Under Test (UUT)
	map_controller uut (
		.vga_out(block_color), 
		.valid_dir(valid_dir), 
		.pixel_x(x), 
		.pixel_y(y), 
		.map_num(map_num),
		.reset(reset),
		.clk_50mhz(clk),
		.clk_25mhz(clk_25mhz),
		.tmp_in(2'b00)
	);
	integer i;
	
	initial begin
	#100;

		// Initialize Inputs
		x = 0;
		y = 16;
		clk = 0;
		clk_25mhz = 0;
		map_num = 0;
		// Wait 100 ns for global reset to finish
		#10 clk = 1; #10 clk = 0;
		reset = 1;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		reset = 0;
		
		repeat(50) begin
      #10 clk = 1; #10 clk = 0;
		end
		#10 clk = 1; #10 clk = 0;
		reset = 1;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		#10 clk = 1; #10 clk = 0;
		reset = 0;
		
		repeat(100) begin
      #10 clk = 1; #10 clk = 0;
		end
		map_num = 1;
		repeat(1000) begin
      #10 clk = 1; #10 clk = 0;
		end
		
		x = 0;
		y = 1;
		#10 clk = 1; #10 clk = 0;
		x = 1;
		y = 1;
		#10 clk = 1; #10 clk = 0;
		
		// Add stimulus here

	end
     
	always @(posedge clk) begin
		clk_25mhz <= ~clk_25mhz;
	end
	
	always @(posedge clk_25mhz) begin
		if(x == 76) begin
			x <= 44;
			y <= y + 1;
		end else begin
			x <= x + 1;
			y <= y;
		end
	end
endmodule

