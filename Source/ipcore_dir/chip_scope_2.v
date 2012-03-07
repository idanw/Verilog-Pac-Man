///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 13.2
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : chip_scope_2.v
// /___/   /\     Timestamp  : Tue Dec 13 20:18:42 Eastern Standard Time 2011
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module chip_scope_2(
    CONTROL,
    ASYNC_IN,
    ASYNC_OUT);


inout [35 : 0] CONTROL;
input [18 : 0] ASYNC_IN;
output [32 : 0] ASYNC_OUT;

endmodule
