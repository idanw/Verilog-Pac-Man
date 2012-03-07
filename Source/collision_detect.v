`timescale 1ns / 1ps
/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module collision_detect(pacman_valid_moves, 
								ghost1_valid_moves,
								ghost2_valid_moves,
								ghost3_valid_moves,
								ghost4_valid_moves,
								pacman_x, 
								pacman_y,
								ghost1_x,
								ghost1_y,
								ghost2_x,
								ghost2_y,
								ghost3_x,
								ghost3_y,
								ghost4_x,
								ghost4_y,
								map_num,
								clk_100mhz, 
								clk_100mhz_phase);

	output [3:0] pacman_valid_moves;
	output [3:0] ghost1_valid_moves;
	output [3:0] ghost2_valid_moves;
	output [3:0] ghost3_valid_moves;
	output [3:0] ghost4_valid_moves;
	
	input [5:0] pacman_x;
	input [4:0] pacman_y;
	
	input [5:0] ghost1_x;
	input [4:0] ghost1_y;
	input [5:0] ghost2_x;
	input [4:0] ghost2_y;
	input [5:0] ghost3_x;
	input [4:0] ghost3_y;
	input [5:0] ghost4_x;
	input [4:0] ghost4_y;
	
	input [1:0] map_num;
	
	input clk_100mhz;
	input [1:0] clk_100mhz_phase;
	
	reg [3:0] pacman_valid_moves;
	reg [3:0] ghost1_valid_moves;
	reg [3:0] ghost2_valid_moves;
	reg [3:0] ghost3_valid_moves;
	reg [3:0] ghost4_valid_moves;
	reg [3:0] pacman_valid_moves_tmp;
	reg [3:0] ghost1_valid_moves_tmp;
	reg [3:0] ghost2_valid_moves_tmp;
	reg [3:0] ghost3_valid_moves_tmp;

	
	reg [6:0] collision_addr_a, collision_addr_b;
	
	wire [75:0] collision_out_a, collision_out_b;
	
	map_collision_detect collision_detect (
	  .clka(clk_100mhz), // input clka
	  .addra(collision_addr_a), // input [6 : 0] addra
	  .douta(collision_out_a), // output [75 : 0] douta
	  .clkb(clk_100mhz), // input clkb
	  .addrb(collision_addr_b), // input [6 : 0] addrb
	  .doutb(collision_out_b) // output [75 : 0] doutb
	);

	always @(posedge clk_100mhz) begin
		case(clk_100mhz_phase)
			2'b00: begin
				collision_addr_a = {map_num, ghost2_y};
				collision_addr_b = {map_num, ghost3_y};
				
				pacman_valid_moves_tmp <= pacman_valid_moves_tmp;
				ghost1_valid_moves_tmp <=  ghost1_valid_moves_tmp;
				ghost2_valid_moves_tmp <=  ghost2_valid_moves_tmp;
				ghost3_valid_moves_tmp <=  ghost3_valid_moves_tmp;

				pacman_valid_moves <= pacman_valid_moves;
				ghost1_valid_moves <=  ghost1_valid_moves;
				ghost2_valid_moves <=  ghost2_valid_moves;
				ghost3_valid_moves <=  ghost3_valid_moves;
				ghost4_valid_moves <=  ghost4_valid_moves;
			end
			2'b01: begin
				collision_addr_a = collision_addr_a;
				collision_addr_b = {map_num, ghost4_y};
				
				pacman_valid_moves_tmp <= {	collision_out_a[{pacman_x[4:0], 2'b11}],
														collision_out_a[{pacman_x[4:0], 2'b10}],
														collision_out_a[{pacman_x[4:0], 2'b00}],
														collision_out_a[{pacman_x[4:0], 2'b01}]
													};
				ghost1_valid_moves_tmp <=  {	collision_out_b[{ghost1_x[4:0], 2'b11}],
														collision_out_b[{ghost1_x[4:0], 2'b10}],
														collision_out_b[{ghost1_x[4:0], 2'b00}],
														collision_out_b[{ghost1_x[4:0], 2'b01}]
													};
				ghost2_valid_moves_tmp <=  ghost2_valid_moves_tmp;
				ghost3_valid_moves_tmp <=  ghost3_valid_moves_tmp;

				pacman_valid_moves <= pacman_valid_moves;
				ghost1_valid_moves <=  ghost1_valid_moves;
				ghost2_valid_moves <=  ghost2_valid_moves;
				ghost3_valid_moves <=  ghost3_valid_moves;
				ghost4_valid_moves <=  ghost4_valid_moves;
			end
			
			2'b10: begin
				collision_addr_a = collision_addr_a;
				collision_addr_b = {map_num, ghost4_y};
				
				pacman_valid_moves_tmp <= pacman_valid_moves_tmp;
				ghost1_valid_moves_tmp <=  ghost1_valid_moves_tmp;
				ghost2_valid_moves_tmp <=  {	collision_out_a[{ghost2_x[4:0], 2'b11}],
														collision_out_a[{ghost2_x[4:0], 2'b10}],
														collision_out_a[{ghost2_x[4:0], 2'b00}],
														collision_out_a[{ghost2_x[4:0], 2'b01}]
													};
				ghost3_valid_moves_tmp <=  {	collision_out_b[{ghost3_x[4:0], 2'b11}],
														collision_out_b[{ghost3_x[4:0], 2'b10}],
														collision_out_b[{ghost3_x[4:0], 2'b00}],
														collision_out_b[{ghost3_x[4:0], 2'b01}]
													};
													
				pacman_valid_moves <= pacman_valid_moves;
				ghost1_valid_moves <=  ghost1_valid_moves;
				ghost2_valid_moves <=  ghost2_valid_moves;
				ghost3_valid_moves <=  ghost3_valid_moves;
				ghost4_valid_moves <=  ghost4_valid_moves;
			end
			
			2'b11: begin
				collision_addr_a = {map_num, pacman_y};
				collision_addr_b = {map_num, ghost1_y};

				pacman_valid_moves_tmp <= pacman_valid_moves_tmp;
				ghost1_valid_moves_tmp <=  ghost1_valid_moves_tmp;
				ghost2_valid_moves_tmp <=  ghost2_valid_moves_tmp;
				ghost3_valid_moves_tmp <=  ghost3_valid_moves_tmp;
				
				pacman_valid_moves <= pacman_valid_moves_tmp;
				ghost1_valid_moves <=  ghost1_valid_moves_tmp;
				ghost2_valid_moves <=  ghost2_valid_moves_tmp;
				ghost3_valid_moves <=  ghost3_valid_moves_tmp;
				ghost4_valid_moves <=  {	collision_out_b[{ghost4_x[4:0], 2'b11}],
													collision_out_b[{ghost4_x[4:0], 2'b10}],
													collision_out_b[{ghost4_x[4:0], 2'b00}],
													collision_out_b[{ghost4_x[4:0], 2'b01}]
												};

				
			end
		endcase
	end

endmodule
