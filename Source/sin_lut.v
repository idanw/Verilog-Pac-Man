`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:40:21 10/30/2011 
// Design Name: 
// Module Name:    sin_lut 
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

module sin_lut(out, in);
	output [4:0] out;
	input [5:0] in;
	reg [4:0] out;
	always begin
		case(in)
			/*0: out = 8;
			1: out = 10;
			2: out = 13;
			3: out = 14;
			4: out = 15;
			5: out = 14;
			6: out = 13;
			7: out = 10;
			8: out = 8;
			9: out = 5;
			10: out = 2;
			11: out = 1;
			12: out = 0;
			13: out = 1;
			14: out = 2;
			15: out = 5;*/
			
			/*0: out = 15;
1: out = 17;
2: out = 20;
3: out = 23;
4: out = 25;
5: out = 27;
6: out = 28;
7: out = 29;
8: out = 29;
9: out = 29;
10: out = 28;
11: out = 27;
12: out = 25;
13: out = 23;
14: out = 20;
15: out = 17;
16: out = 15;
17: out = 12;
18: out = 9;
19: out = 6;
20: out = 4;
21:  out = 2;
22:  out = 1;
23:  out = 0;
24:  out = 0;
25:  out = 0;
26:  out = 1;
27:  out = 2;
28:  out = 4;
29:  out = 6;
30:  out = 9;
31:  out = 12;*/
 0: out = 15;
 1: out = 17;
 2: out = 19;
 3: out = 21;
 4: out = 23;
 5: out = 25;
 6: out = 26;
 7: out = 27;
 8: out = 28;
 9: out = 29;
10: out = 29;
11: out = 29;
12: out = 28;
13: out = 27;
14: out = 26;
15: out = 25;
16: out = 23;
17: out = 21;
18: out = 19;
19: out = 17;
20: out = 15;
21: out = 12;
22: out = 10;
23: out = 8;
24: out = 6;
25: out = 4;
26: out = 3;
27: out = 2;
28: out = 1;
29: out = 0;
30: out = 0;
31: out = 0;
32: out = 1;
33: out = 2;
34: out = 3;
35: out = 4;
36: out = 6;
37: out = 8;
38: out = 10;
39: out = 12;
default: out = 0;
		endcase

	end

endmodule
