`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:40:47 12/01/2011 
// Design Name: 
// Module Name:    moving_object_sprite_gen 
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
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

module moving_object_sprite_gen(vga_out, scan_pix_x, scan_pix_y, 
		pacman_x, pacman_y, pacman_dir, 
		ghost1_x, ghost1_y, ghost1_dir,
		ghost2_x, ghost2_y, ghost2_dir,
		ghost3_x, ghost3_y, ghost3_dir,
		ghost4_x, ghost4_y, ghost4_dir,
		animation_clk, clk_100mhz, clk_100mhz_phase);
	
	output [2:0] vga_out;
	input [9:0] scan_pix_x;
	input [8:0] scan_pix_y;
	
	input [9:0] pacman_x;
	input [8:0] pacman_y;
	input [3:0] pacman_dir;
	
	input [9:0] ghost1_x;
	input [8:0] ghost1_y;
	input [3:0] ghost1_dir;

	input [9:0] ghost2_x;
	input [8:0] ghost2_y;
	input [3:0] ghost2_dir;
	
	input [9:0] ghost3_x;
	input [8:0] ghost3_y;
	input [3:0] ghost3_dir;

	input [9:0] ghost4_x;
	input [8:0] ghost4_y;
	input [3:0] ghost4_dir;	
	
	input animation_clk, clk_100mhz;
	input [1:0] clk_100mhz_phase;
	
	wire [63:0] mov_sprite_out_a, mov_sprite_out_b;
	wire [63:0] mov_ghost_sprite_out_a, mov_ghost_sprite_out_b;
	
	reg [2:0] vga_out;
	
	//Pacman min/max precomputation
	wire [9:0] pacman_x_max;
	wire [8:0] pacman_y_max;
	assign pacman_x_max = pacman_x + 4'hF;
	assign pacman_y_max = pacman_y + 4'hF;

	wire [4:0] pacman_y_addr, pacman_x_addr;
	assign pacman_y_addr = scan_pix_y[3:0] - pacman_y[3:0];
	assign pacman_x_addr = scan_pix_x[3:0] - pacman_x[3:0];

	//Ghost 1 min/max precomputation
	wire [9:0] ghost1_x_max;
	wire [8:0] ghost1_y_max;
	
	assign ghost1_x_max = ghost1_x + 4'hF;
	assign ghost1_y_max = ghost1_y + 4'hF;
	
	wire [4:0] ghost1_y_addr, ghost1_x_addr;
	assign ghost1_y_addr = scan_pix_y[3:0] - ghost1_y[3:0];
	assign ghost1_x_addr = scan_pix_x[3:0] - ghost1_x[3:0];	
	
	//Ghost 2 min/max precomputation
	wire [9:0] ghost2_x_max;
	wire [8:0] ghost2_y_max;
	
	assign ghost2_x_max = ghost2_x + 4'hF;
	assign ghost2_y_max = ghost2_y + 4'hF;
	
	wire [4:0] ghost2_y_addr, ghost2_x_addr;
	assign ghost2_y_addr = scan_pix_y[3:0] - ghost2_y[3:0];
	assign ghost2_x_addr = scan_pix_x[3:0] - ghost2_x[3:0];
	
	//Ghost 3 min/max precomputation
	wire [9:0] ghost3_x_max;
	wire [8:0] ghost3_y_max;
	
	assign ghost3_x_max = ghost3_x + 4'hF;
	assign ghost3_y_max = ghost3_y + 4'hF;
	
	wire [4:0] ghost3_y_addr, ghost3_x_addr;
	assign ghost3_y_addr = scan_pix_y[3:0] - ghost3_y[3:0];
	assign ghost3_x_addr = scan_pix_x[3:0] - ghost3_x[3:0];	
	
	//Ghost 4 min/max precomputation
	wire [9:0] ghost4_x_max;
	wire [8:0] ghost4_y_max;
	
	assign ghost4_x_max = ghost4_x + 4'hF;
	assign ghost4_y_max = ghost4_y + 4'hF;
	
	wire [4:0] ghost4_y_addr, ghost4_x_addr;
	assign ghost4_y_addr = scan_pix_y[3:0] - ghost4_y[3:0];
	assign ghost4_x_addr = scan_pix_x[3:0] - ghost4_x[3:0];	
	
	
	
	
	
	reg [2:0] pacman_dir_minimized;
	reg [2:0] ghost1_dir_minimized; 
	reg [2:0] ghost2_dir_minimized;
	reg [2:0] ghost3_dir_minimized;
	reg [2:0] ghost4_dir_minimized;
	
	reg [2:0] pacman_vga_val;
	reg [2:0] ghost1_vga_val;
	reg [2:0] ghost2_vga_val;
	reg [2:0] ghost3_vga_val;
	reg [2:0] ghost4_vga_val;
	reg [2:0] lives_vga_val; 
	
	reg [8:0] ghost_sprite_addr_a, ghost_sprite_addr_b;
	
	movement_sprites pacman_sprites (
	  .clka(clk_100mhz), // input clka
	  .addra({pacman_dir_minimized, animation_clk, pacman_y_addr[3:0]}), // input [7 : 0] addra
	  .douta(mov_sprite_out_a), // output [63 : 0] douta
	  .clkb(clk_100mhz), // input clkb
	  .addrb({3'b000, 1'b0, scan_pix_y[3:0]}), // input [7 : 0] addrb
	  .doutb(mov_sprite_out_b) // output [63 : 0] doutb
	);

	ghost_sprites ghost_sprite (
	  .clka(clk_100mhz), // input clka
	  .addra(ghost_sprite_addr_a), // input [7 : 0] addra
	  .douta(mov_ghost_sprite_out_a), // output [63 : 0] douta
	  .clkb(clk_100mhz), // input clkb
	  .addrb(ghost_sprite_addr_b), // input [7 : 0] addrb
	  .doutb(mov_ghost_sprite_out_b) // output [63 : 0] doutb
	);

	always @(posedge clk_100mhz) begin
	
		case(pacman_dir)
			4'b0001: pacman_dir_minimized = 3'b001;
			4'b0010: pacman_dir_minimized = 3'b000;
			4'b0100: pacman_dir_minimized = 3'b010;
			4'b1000: pacman_dir_minimized = 3'b011;
			default: pacman_dir_minimized = pacman_dir_minimized;
		endcase
		
		case(ghost1_dir)
			4'b0001: ghost1_dir_minimized = 3'b001;
			4'b0010: ghost1_dir_minimized = 3'b000;
			4'b0100: ghost1_dir_minimized = 3'b010;
			4'b1000: ghost1_dir_minimized = 3'b011;
			default: ghost1_dir_minimized = ghost1_dir_minimized;
		endcase

		case(ghost2_dir)
			4'b0001: ghost2_dir_minimized = 3'b001;
			4'b0010: ghost2_dir_minimized = 3'b000;
			4'b0100: ghost2_dir_minimized = 3'b010;
			4'b1000: ghost2_dir_minimized = 3'b011;
			default: ghost2_dir_minimized = ghost2_dir_minimized;
		endcase

		case(ghost3_dir)
			4'b0001: ghost3_dir_minimized = 3'b001;
			4'b0010: ghost3_dir_minimized = 3'b000;
			4'b0100: ghost3_dir_minimized = 3'b010;
			4'b1000: ghost3_dir_minimized = 3'b011;
			default: ghost3_dir_minimized = ghost3_dir_minimized;
		endcase

		case(ghost4_dir)
			4'b0001: ghost4_dir_minimized = 3'b001;
			4'b0010: ghost4_dir_minimized = 3'b000;
			4'b0100: ghost4_dir_minimized = 3'b010;
			4'b1000: ghost4_dir_minimized = 3'b011;
			default: ghost4_dir_minimized = ghost4_dir_minimized;
		endcase
		
		case(clk_100mhz_phase)
			2'b00: begin //This is a null to allow for the direction computation to complete
				
				vga_out <= vga_out;
				ghost1_vga_val <= ghost1_vga_val;
				ghost2_vga_val <= ghost2_vga_val;
				ghost3_vga_val <= ghost3_vga_val;
				ghost4_vga_val <= ghost4_vga_val;
				pacman_vga_val <= pacman_vga_val;
				lives_vga_val <= lives_vga_val;
				
				ghost_sprite_addr_a = {ghost3_dir_minimized, animation_clk, ghost3_y_addr[3:0]};
				ghost_sprite_addr_b = {ghost4_dir_minimized, animation_clk, ghost4_y_addr[3:0]};
				
			end
			
			2'b01: begin
				vga_out <= vga_out;
				if((pacman_x <= scan_pix_x) & (pacman_x_max >= scan_pix_x) & (pacman_y <= scan_pix_y) & (pacman_y_max >= scan_pix_y)) begin
					pacman_vga_val <= {mov_sprite_out_a[{pacman_x_addr[3:0], 2'b10}],
							mov_sprite_out_a[{pacman_x_addr[3:0], 2'b01}],
							mov_sprite_out_a[{pacman_x_addr[3:0], 2'b00}]};
				end else begin
					pacman_vga_val <= 3'b000;
				end
				
				if((ghost1_x <= scan_pix_x) & (ghost1_x_max >= scan_pix_x) & (ghost1_y <= scan_pix_y) & (ghost1_y_max >= scan_pix_y)) begin
					if(	{mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b10}],
							mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b01}],
							mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b00}]} == 3'b010)
						ghost1_vga_val <= {	1'b0, 
													mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b01}],
													mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b01}]
												}; //Remap B channel to RG for yellow
												
					else 
						ghost1_vga_val <= {mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b10}],
												mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b01}],
												mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b00}]
												};
							
					/*{mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b10}],
							mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b01}],
							mov_ghost_sprite_out_a[{ghost1_x_addr[3:0], 2'b00}]};*/
				end else begin
					ghost1_vga_val <= 3'b000;
				end
				
				if((ghost2_x <= scan_pix_x) & (ghost2_x_max >= scan_pix_x) & (ghost2_y <= scan_pix_y) & (ghost2_y_max >= scan_pix_y)) begin
					if(	{mov_ghost_sprite_out_b[{ghost2_x_addr[3:0], 2'b10}],
							mov_ghost_sprite_out_b[{ghost2_x_addr[3:0], 2'b01}],
							mov_ghost_sprite_out_b[{ghost2_x_addr[3:0], 2'b00}]} == 3'b010)
						ghost2_vga_val <= {mov_ghost_sprite_out_b[{ghost2_x_addr[3:0], 2'b01}],
												1'b0,
												mov_ghost_sprite_out_b[{ghost2_x_addr[3:0], 2'b01}]
												}; //Remap B channel to RB for Pink
					else
					ghost2_vga_val <= {mov_ghost_sprite_out_b[{ghost2_x_addr[3:0], 2'b10}],
											mov_ghost_sprite_out_b[{ghost2_x_addr[3:0], 2'b01}],
											mov_ghost_sprite_out_b[{ghost2_x_addr[3:0], 2'b00}]
											};
				end else begin
					ghost2_vga_val <= 3'b000;
				end
				
				ghost_sprite_addr_a = {ghost3_dir_minimized, animation_clk, ghost3_y_addr[3:0]};
				ghost_sprite_addr_b = {ghost4_dir_minimized, animation_clk, ghost4_y_addr[3:0]};
			end
			
			2'b10: begin
			
				//Pacman Lives
				if((scan_pix_x[9:4] <= 6'b00_0010) & (scan_pix_y[8:4] > 5'b1_0111) & (scan_pix_y[8:4] < 5'b1_1000)) begin
					lives_vga_val <= {mov_sprite_out_b[{scan_pix_x[3:0], 2'b10}],
											mov_sprite_out_b[{scan_pix_x[3:0], 2'b01}],
											mov_sprite_out_b[{scan_pix_x[3:0], 2'b00}]};
				end else begin
					lives_vga_val <= 3'b000;
				end

				if((ghost3_x <= scan_pix_x) & (ghost3_x_max >= scan_pix_x) & (ghost3_y <= scan_pix_y) & (ghost3_y_max >= scan_pix_y)) begin
					if({mov_ghost_sprite_out_a[{ghost3_x_addr[3:0], 2'b10}],
							mov_ghost_sprite_out_a[{ghost3_x_addr[3:0], 2'b01}],
							mov_ghost_sprite_out_a[{ghost3_x_addr[3:0], 2'b00}]} == 3'b010)
						ghost3_vga_val <= {mov_ghost_sprite_out_a[{ghost3_x_addr[3:0], 2'b01}],
												mov_ghost_sprite_out_a[{ghost3_x_addr[3:0], 2'b01}],
												1'b0};//Remap B channel to GB for Cyan
							
					else
						ghost3_vga_val <= {mov_ghost_sprite_out_a[{ghost3_x_addr[3:0], 2'b10}],
												mov_ghost_sprite_out_a[{ghost3_x_addr[3:0], 2'b01}],
												mov_ghost_sprite_out_a[{ghost3_x_addr[3:0], 2'b00}]
												};
				end else begin
					ghost3_vga_val <= 3'b000;
				end
				
				if((ghost4_x <= scan_pix_x) & (ghost4_x_max >= scan_pix_x) & (ghost4_y <= scan_pix_y) & (ghost4_y_max >= scan_pix_y)) begin
					if(	{mov_ghost_sprite_out_b[{ghost4_x_addr[3:0], 2'b10}],
							mov_ghost_sprite_out_b[{ghost4_x_addr[3:0], 2'b01}],
							mov_ghost_sprite_out_b[{ghost4_x_addr[3:0], 2'b00}]} == 3'b010)
						ghost4_vga_val <= {2'b00, mov_ghost_sprite_out_b[{ghost4_x_addr[3:0], 2'b01}]}; //Remap B channel to R for red
					else
						ghost4_vga_val <= {mov_ghost_sprite_out_b[{ghost4_x_addr[3:0], 2'b10}],
												mov_ghost_sprite_out_b[{ghost4_x_addr[3:0], 2'b01}],
												mov_ghost_sprite_out_b[{ghost4_x_addr[3:0], 2'b00}]
												};
				end else begin
					ghost4_vga_val <= 3'b000;
				end
				
				lives_vga_val <= lives_vga_val;
				ghost1_vga_val <= ghost1_vga_val;
				pacman_vga_val <= pacman_vga_val;
				vga_out <= vga_out;
			end
			
			2'b11: begin
				if(pacman_vga_val != 3'b000) vga_out <= pacman_vga_val;
				else if(ghost1_vga_val != 3'b000) vga_out <= ghost1_vga_val;
				else if(ghost2_vga_val != 3'b000) vga_out <= ghost2_vga_val;
				else if(ghost3_vga_val != 3'b000) vga_out <= ghost3_vga_val;
				else if(ghost4_vga_val != 3'b000) vga_out <= ghost4_vga_val;
				else if(lives_vga_val != 3'b000) vga_out <= lives_vga_val;
				else vga_out <= 3'b000;
				ghost1_vga_val <= ghost1_vga_val;
				pacman_vga_val <= pacman_vga_val;
				
				ghost_sprite_addr_a = {ghost1_dir_minimized, animation_clk, ghost1_y_addr[3:0]};
				ghost_sprite_addr_b = {ghost2_dir_minimized, animation_clk, ghost2_y_addr[3:0]};
			end
			
		endcase
		
	
	end

endmodule
