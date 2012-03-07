`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:26:14 12/07/2011 
// Design Name: 
// Module Name:    dot_tracker 
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

module dot_tracker(	score, 
							pacman_x, 
							pacman_y, 
							map_num,
							dt_pix_scan_x,
							dt_pix_scan_y,
							is_dot,
							hide_dot,
							reset, 
							clk_100mhz);
	
	output [9:0] score;
	input [9:0] pacman_x;
	input [8:0] pacman_y;
	input [1:0] map_num;
	input [9:0] dt_pix_scan_x;
	input [8:0] dt_pix_scan_y;
	input is_dot;
	output hide_dot;
	input reset;
	input clk_100mhz;
	
	reg [9:0] score;
	reg rewrite_map;
	reg map_store_write_en;
	
	
	reg [1:0] prev_map;
	
	reg [1:0] incremental_shrinkremental;
	
	reg [4:0] iterator;
	reg [18:0] map_store_a_in;
	reg [4:0] map_store_addr_a;
	wire [18:0] dot_tracker_mem_output;
	wire [18:0] map_store_dout_a;
	
	//assign hide_dot = score_map[dt_pix_scan_y[8:4]][dt_pix_scan_x[8:4]];
	assign hide_dot = dot_tracker_mem_output[dt_pix_scan_x[8:4]];
	
	map_temp_store mts (
		.clka(clk_100mhz), // input clka
		.wea(map_store_write_en), // input [0 : 0] wea
		.addra(map_store_addr_a), // input [4 : 0] addra
		.dina(map_store_a_in), // input [18 : 0] dina
		.douta(map_store_dout_a), // output [18 : 0] douta
		.clkb(clk_100mhz), // input clkb
		.web(1'b0), // input [0 : 0] web
		.addrb(dt_pix_scan_y[8:4]), // input [4 : 0] addrb
		.dinb(16'b0000_0000_0000_0000), // input [18 : 0] dinb
		.doutb(dot_tracker_mem_output) // output [18 : 0] doutb
	);
	always @(posedge clk_100mhz) begin
		if(reset) begin
			rewrite_map <= 1;
			score <= 0;
			iterator <= 5'b1_0111;
			map_store_write_en <= 0;
			map_store_addr_a <= 5'b00000;
			prev_map <= 2'b11;
			map_store_a_in <= 19'b000_0000_0000_0000_0000;
			incremental_shrinkremental <= 2'b00; 
		end else if(prev_map != map_num) begin
			rewrite_map <= 1;
			prev_map <= map_num;
		end else if(rewrite_map) begin
			if(iterator == 5'b1_0111) begin
				iterator <= 5'b0_0000;
				map_store_write_en <= 1;
				map_store_addr_a <= 5'b00000;
				rewrite_map <= 1;
			end else begin
				if(iterator == 5'b1_0110) begin
					rewrite_map <= 0;
					map_store_write_en <= 0;
				end
				map_store_write_en <= 1;
				iterator <= iterator + 1;
				map_store_addr_a <= map_store_addr_a + 1;
			end
			
			map_store_a_in <= 19'b000_0000_0000_0000_0000;
		end else begin
			map_store_addr_a <= pacman_y[8:4];
			if(map_store_write_en)
				map_store_write_en <= 0;
			else begin
				if((pacman_y[3:0] == 4'b0000) & (pacman_x[3:0] == 4'b0000)) begin
					incremental_shrinkremental <= incremental_shrinkremental + 1;
				end 
				
				if((incremental_shrinkremental == 2'b11) 
				& (dt_pix_scan_y[8:4] == pacman_y[8:4]) & (pacman_x[8:4] == dt_pix_scan_x[8:4])
				& (pacman_y[3:0] == 4'b0000) & (pacman_x[3:0] == 4'b0000)
				) begin
					case(pacman_x[8:4])
						5'b00000: map_store_a_in <= map_store_dout_a | 19'b000_0000_0000_0000_0001;
						5'b00001: map_store_a_in <= map_store_dout_a | 19'b000_0000_0000_0000_0010;
						5'b00010: map_store_a_in <= map_store_dout_a | 19'b000_0000_0000_0000_0100;
						5'b00011: map_store_a_in <= map_store_dout_a | 19'b000_0000_0000_0000_1000;
						5'b00100: map_store_a_in <= map_store_dout_a | 19'b000_0000_0000_0001_0000;
						5'b00101: map_store_a_in <= map_store_dout_a | 19'b000_0000_0000_0010_0000;
						5'b00110: map_store_a_in <= map_store_dout_a | 19'b000_0000_0000_0100_0000;
						5'b00111: map_store_a_in <= map_store_dout_a | 19'b000_0000_0000_1000_0000;
						5'b01000: map_store_a_in <= map_store_dout_a | 19'b000_0000_0001_0000_0000;
						5'b01001: map_store_a_in <= map_store_dout_a | 19'b000_0000_0010_0000_0000;
						5'b01010: map_store_a_in <= map_store_dout_a | 19'b000_0000_0100_0000_0000;
						5'b01011: map_store_a_in <= map_store_dout_a | 19'b000_0000_1000_0000_0000;
						5'b01100: map_store_a_in <= map_store_dout_a | 19'b000_0001_0000_0000_0000;
						5'b01101: map_store_a_in <= map_store_dout_a | 19'b000_0010_0000_0000_0000;
						5'b01110: map_store_a_in <= map_store_dout_a | 19'b000_0100_0000_0000_0000;
						5'b01111: map_store_a_in <= map_store_dout_a | 19'b000_1000_0000_0000_0000;
						5'b10000: map_store_a_in <= map_store_dout_a | 19'b001_0000_0000_0000_0000;
						5'b10001: map_store_a_in <= map_store_dout_a | 19'b010_0000_0000_0000_0000;
						5'b10010: map_store_a_in <= map_store_dout_a | 19'b100_0000_0000_0000_0000;
						default: map_store_a_in <= map_store_dout_a;
					endcase
					
					if(!hide_dot & is_dot) begin
						score <= score + 1;
						map_store_write_en <= 1;
					end
				end
			end

			//if() begin
				
				/*if((score_map[dt_pix_scan_y[8:4]][dt_pix_scan_x[8:4]] == 0)) begin
					score_map[pacman_y[8:4]][pacman_x[8:4]] <= 1;
					score <= score + 1;
				end*/
				
			//end
		end
	end
	
	
	/*map_temp_store mts (
		.clka(clk_100mhz), // input clka
		.wea(map_store_write_en), // input [0 : 0] wea
		.addra(map_store_addr_a), // input [4 : 0] addra
		.dina(map_controller_mem_address), // input [15 : 0] dina
		.douta(dot_tracker_mem_output), // output [15 : 0] douta
		.clkb(clk_100mhz), // input clkb
		.web(1'b0), // input [0 : 0] web
		.addrb(dot_tracker_mem_address), // input [4 : 0] addrb
		.dinb(16'b0000_0000_0000_0000), // input [15 : 0] dinb
		.doutb(dot_tracker_mem_output) // output [15 : 0] doutb
	);

	always @(posedge clk_100mhz) begin
		if(reset) begin
			rewrite_map <= 1;
			iterator <= 5'b1_0111; //line 23
			map_store_addr_a <= 5'b0000;
			map_store_in_a = 19'b000_0000_0000_0000_0000_0000;
			map_read_addr_a <= 5'b00_0000;
		end else if(rewrite_map) begin
			if(iterator == 5'b1_0111) begin
				iterator <= 5'b0_0001;
				map_store_addr_a <= 5'b00000;
				map_controller_mem_address <= 8'b0000_0000; //TODO: make this reliant on map_num as well
				map_store_write_en <= 1;
				map_store_in_a = {
					map_controller_mem_output[74:72] == 3'b111,
					map_controller_mem_output[70:68] == 3'b111,
					map_controller_mem_output[66:64] == 3'b111,
					map_controller_mem_output[62:60] == 3'b111,
					map_controller_mem_output[58:56] == 3'b111,
					map_controller_mem_output[54:52] == 3'b111,
					map_controller_mem_output[50:48] == 3'b111,
					map_controller_mem_output[46:44] == 3'b111,
					map_controller_mem_output[42:40] == 3'b111,
					map_controller_mem_output[38:36] == 3'b111,
					map_controller_mem_output[34:32] == 3'b111,
					map_controller_mem_output[30:28] == 3'b111,
					map_controller_mem_output[26:24] == 3'b111,
					map_controller_mem_output[22:20] == 3'b111,
					map_controller_mem_output[18:16] == 3'b111,
					map_controller_mem_output[14:12] == 3'b111,
					map_controller_mem_output[10:8] == 3'b111,
					map_controller_mem_output[6:4] == 3'b111,
					map_controller_mem_output[2:0] == 3'b111
				};
			end else begin
				if(iterator == 5'b1_0110) begin
					rewrite_map <= 0;
					map_store_write_en <= 0;
				end
				iterator <= iterator + 1;
				map_controller_mem_address <= map_controller_mem_address + 1;
				map_store_addr_a <= map_store_addr_a + 1;
			end

		end/* else begin
			if((pacman_x[3:0] == 4'b0000) & (pacman_y[3:0] == 4'b0000)) begin
			
			end
		end*/
	
	//end
	
endmodule
