///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 13.2
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : chip_scope.v
// /___/   /\     Timestamp  : Sat Dec 03 15:58:19 Eastern Standard Time 2011
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module chip_scope(
    CONTROL,
    CLK,
    SYNC_IN,
    SYNC_OUT);


inout [35 : 0] CONTROL;
input CLK;
input [63 : 0] SYNC_IN;
output [63 : 0] SYNC_OUT;

endmodule
