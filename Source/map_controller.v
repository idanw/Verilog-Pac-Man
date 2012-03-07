`timescale 1ns / 1ps

/* 
 * File Primary Author: Idan Warsawski
 * See LICENSE for license information
 */

/*
99% of you probably won't even read this..but I just turned 18 and I am trying my 
best to become a horse. On? the 29th of November? I am traveling? to the wide open 
fields of Nevada to hopefully learn from the best horses. Being a horse means a lot 
to me.

I've just started? my training. I have just nailed horseshoes? to my feet (really hurts)
and shaved my hair into a horse mane. It would mean the world? to me if you supported me
 and helped me complete my ambition.

--wutupitscarley (youtube)
*/
module map_controller(vga_out, 
							pixel_x, 
							pixel_y, 
							map_num, 
							is_dot,
							hide_dot,
							reset, 
							clk_100mhz, 
							clk_100mhz_phase, 
							clk_50mhz, 
							clk_25mhz);
	
	output [2:0] vga_out;
	//0 == left, 1 == right, 2 == up, 3 == down

	input [9:0] pixel_x;
	input [8:0] pixel_y;
	input [1:0] map_num;
	input [1:0] clk_100mhz_phase;
	input clk_100mhz, clk_50mhz, clk_25mhz;
	input reset;
	output is_dot;
	input hide_dot;
	
	
	reg [7:0] map_addr_a, map_addr_b;
	reg [2:0] vga_out;
		
	reg [7:0] sprite_addr_a, sprite_addr_b;
	
	wire [5:0] x;
	wire [4:0] y;
	assign x = pixel_x[9:4];
	assign y = pixel_y[8:4];
		
	wire [75:0] map_out_a, map_out_b, collision_out_a, collision_out_b;	
	wire [63:0] map_sprite_out_a, map_sprite_out_b;
	
	wire [3:0] sprite_num;
	
	assign sprite_num = ((x > 18) | (y > 22))
						? 4'b0000 
						: 
						{map_out_a[{x, 2'b11}], map_out_a[{x, 2'b10}], 
						map_out_a[{x, 2'b01}], map_out_a[{x, 2'b00}]};
	
	assign is_dot = (sprite_num[3:1] == 3'b111);
	
	map_mem_read map (
	  .clka(clk_100mhz), // input clka
	  .addra({1'b0, map_num, y}), // input [7 : 0] addra
	  .douta(map_out_a), // output [75 : 0] douta
	  .clkb(clk_100mhz), // input clkb
	  .addrb(map_controller_mem_address), // input [7 : 0] addrb
	  .doutb(map_controller_mem_output) // output [75 : 0] doutb
	);
	
	map_sprites map_sprites_mem (
	  .clka(clk_100mhz), // input clka
	  .addra(sprite_addr_a), // input [9 : 0] addra
	  .douta(map_sprite_out_a) // output [15 : 0] douta
	 // .clkb(clk_100mhz), // input clkb
	 // .addrb(sprite_addr_b), // input [9 : 0] addrb
	 // .doutb(map_sprite_out_b) // output [15 : 0] doutb
	);


	always @(posedge clk_100mhz) begin

		if(reset) begin //I think this and will take care of some clock boundry sync issues
			vga_out <= 3'b000;
			sprite_addr_a <= 8'b0000_0000;
			//reread_map <= 1;
			//map_iterator <= 5'b1_0111;
		end else begin
			
			case(clk_100mhz_phase)
				2'b00: begin //Grab tile code from map_mem_read. Compute sprite values
					vga_out <= vga_out;
					sprite_addr_a <= sprite_addr_a;
				end
				
				2'b01: begin //compute RGB addresses
					vga_out <= vga_out;
					sprite_addr_a <= {sprite_num, pixel_y[3:0]};
				end
			
				2'b10: begin
					vga_out <= vga_out;
					sprite_addr_a <= {sprite_num, pixel_y[3:0]};

				end
				
				2'b11: begin
					if(is_dot & hide_dot) begin
						vga_out <= 3'b000;
					end else begin
						vga_out <= {map_sprite_out_a[{pixel_x[3:0], 2'b10}],
										map_sprite_out_a[{pixel_x[3:0], 2'b01}],
										map_sprite_out_a[{pixel_x[3:0], 2'b00}]
										};
					end
					sprite_addr_a <= sprite_addr_a;
				end
			endcase
			
		end
	end

endmodule
