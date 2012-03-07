`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:20:08 12/05/2011 
// Design Name: 
// Module Name:    Score_in 
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
 * File Primary Author: Greg Zoeller
 * See LICENSE for license information
 */

module score_bcd_converter(s1,s2,s3,s4,s5,s6, scorein1, scorein2, clk,reset);
	input [19:0] scorein1, scorein2;
	input clk, reset;
	output [3:0] s1,s2,s3,s4,s5,s6;
	reg [3:0] s2,s3,s4,s5,s6,s1;
	reg [20:0] s_total, s_current;

	wire [4:0] s_difference;
	assign s_difference = s_total - s_current;
	
	always @ (posedge clk)
	begin		
		if(reset == 1)
		begin
			s_current <=0;
			s_total <= 0;
			s1 <= 0;
			s2 <= 0;
			s3 <= 0;
			s4 <= 0;
			s5 <= 0;
			s6 <= 0;
		end
		else begin
			s_total <= scorein1 + scorein2;
			
			if( s1 > 9)
			begin
				s2 <= s2 + 1;
				s1 <= s1 - 10;
			end
			else if ( s2 > 9)
			begin
				s3 <= s3 +1;
				s2 <= s2 - 10;
			end
			else if( s3 >9)
			begin
				s4 <= s4 +1;
				s3 <= s3-10;
			end
			else if( s4 >9)
			begin
				s5 <= s5 +1;
				s4 <= s4-10;
			end
			else if( s5 >9)
			begin
				s6 <= s6 +1;
				s5 <= s4-10;
			end
			else if( s6 >9)
			begin
				s1 <=0;
				s2 <=0;
				s3 <=0;
				s4 <=0;
				s5 <=0;
				s6 <=0;
			end
			else if(s_difference != 5'b0_0000)
			begin
				s1 <= s1 + s_difference[3:0];
				s_current <= s_total;
			end
		end
			
			
		

	end

	
	
	
	


endmodule
